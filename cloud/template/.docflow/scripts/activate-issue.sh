#!/bin/bash
#
# activate-issue.sh - Assign issue and move to In Progress atomically
#
# Usage: ./activate-issue.sh <issue-id> <assignee-email> [priority] [estimate]
#
# Arguments:
#   issue-id       - Linear issue identifier (e.g., PLA-123)
#   assignee-email - Email of user to assign (or "me" for current user)
#   priority       - 1-4 (optional, 1=Urgent, 4=Low)
#   estimate       - 1-5 (optional, 1=XS, 5=XL)
#
# Example:
#   ./activate-issue.sh PLA-123 matt@example.com 2 3
#   ./activate-issue.sh PLA-123 me
#
# Requirements:
#   - LINEAR_API_KEY in .env file
#   - provider.teamId in .docflow/config.json
#   - jq installed
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Arguments
ISSUE_ID="$1"
ASSIGNEE_EMAIL="$2"
PRIORITY="$3"
ESTIMATE="$4"

# Validate arguments
if [ -z "$ISSUE_ID" ] || [ -z "$ASSIGNEE_EMAIL" ]; then
    echo -e "${RED}Error: Issue ID and assignee required${NC}"
    echo "Usage: ./activate-issue.sh <issue-id> <assignee-email> [priority] [estimate]"
    exit 1
fi

# Check for .env file
if [ ! -f ".env" ]; then
    echo -e "${RED}Error: .env file not found${NC}"
    exit 1
fi

# Check for config.json
if [ ! -f ".docflow/config.json" ]; then
    echo -e "${RED}Error: .docflow/config.json not found${NC}"
    exit 1
fi

# Check for jq
if ! command -v jq &> /dev/null; then
    echo -e "${RED}Error: jq is required but not installed${NC}"
    exit 1
fi

# Read credentials
LINEAR_API_KEY=$(grep LINEAR_API_KEY .env | cut -d '=' -f2 | tr -d '"' | tr -d "'")
TEAM_ID=$(jq -r '.provider.teamId' .docflow/config.json)

if [ -z "$LINEAR_API_KEY" ] || [ "$LINEAR_API_KEY" == "null" ]; then
    echo -e "${RED}Error: LINEAR_API_KEY not found in .env${NC}"
    exit 1
fi

echo -e "${YELLOW}Step 1: Looking up issue $ISSUE_ID...${NC}"

# Get issue details
ISSUE_RESPONSE=$(curl -s -X POST https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: $LINEAR_API_KEY" \
  -d "{
    \"query\": \"query { issue(id: \\\"$ISSUE_ID\\\") { id identifier title description state { name } assignee { email name } priority estimate } }\"
  }")

ISSUE_UUID=$(echo "$ISSUE_RESPONSE" | jq -r '.data.issue.id')
ISSUE_IDENTIFIER=$(echo "$ISSUE_RESPONSE" | jq -r '.data.issue.identifier')
ISSUE_TITLE=$(echo "$ISSUE_RESPONSE" | jq -r '.data.issue.title')
ISSUE_DESC=$(echo "$ISSUE_RESPONSE" | jq -r '.data.issue.description')
CURRENT_STATE=$(echo "$ISSUE_RESPONSE" | jq -r '.data.issue.state.name')
CURRENT_ASSIGNEE=$(echo "$ISSUE_RESPONSE" | jq -r '.data.issue.assignee.email')
CURRENT_PRIORITY=$(echo "$ISSUE_RESPONSE" | jq -r '.data.issue.priority')
CURRENT_ESTIMATE=$(echo "$ISSUE_RESPONSE" | jq -r '.data.issue.estimate')

if [ -z "$ISSUE_UUID" ] || [ "$ISSUE_UUID" == "null" ]; then
    echo -e "${RED}Error: Issue $ISSUE_ID not found${NC}"
    exit 1
fi

echo "   Found: $ISSUE_IDENTIFIER - $ISSUE_TITLE"
echo "   Current state: $CURRENT_STATE"

# Check for AI Effort Estimate
echo -e "${YELLOW}Step 2: Checking AI Effort Estimate...${NC}"
if echo "$ISSUE_DESC" | grep -q "## AI Effort Estimate"; then
    echo "   ✓ AI Effort Estimate section found"
    HAS_ESTIMATE="true"
else
    echo -e "   ${YELLOW}⚠️ Missing AI Effort Estimate section${NC}"
    HAS_ESTIMATE="false"
fi

# Get assignee
echo -e "${YELLOW}Step 3: Looking up assignee...${NC}"

if [ "$ASSIGNEE_EMAIL" == "me" ]; then
    # Get current user
    USER_RESPONSE=$(curl -s -X POST https://api.linear.app/graphql \
      -H "Content-Type: application/json" \
      -H "Authorization: $LINEAR_API_KEY" \
      -d '{"query": "query { viewer { id email name } }"}')
    ASSIGNEE_UUID=$(echo "$USER_RESPONSE" | jq -r '.data.viewer.id')
    ASSIGNEE_NAME=$(echo "$USER_RESPONSE" | jq -r '.data.viewer.name')
    ASSIGNEE_EMAIL_ACTUAL=$(echo "$USER_RESPONSE" | jq -r '.data.viewer.email')
else
    # Look up user by email
    USER_RESPONSE=$(curl -s -X POST https://api.linear.app/graphql \
      -H "Content-Type: application/json" \
      -H "Authorization: $LINEAR_API_KEY" \
      -d "{
        \"query\": \"query { users(filter: { email: { eq: \\\"$ASSIGNEE_EMAIL\\\" } }) { nodes { id email name } } }\"
      }")
    ASSIGNEE_UUID=$(echo "$USER_RESPONSE" | jq -r '.data.users.nodes[0].id')
    ASSIGNEE_NAME=$(echo "$USER_RESPONSE" | jq -r '.data.users.nodes[0].name')
    ASSIGNEE_EMAIL_ACTUAL=$ASSIGNEE_EMAIL
fi

if [ -z "$ASSIGNEE_UUID" ] || [ "$ASSIGNEE_UUID" == "null" ]; then
    echo -e "${RED}Error: User '$ASSIGNEE_EMAIL' not found${NC}"
    exit 1
fi

echo "   Found: $ASSIGNEE_NAME ($ASSIGNEE_EMAIL_ACTUAL)"

# Get In Progress state
echo -e "${YELLOW}Step 4: Looking up 'In Progress' state...${NC}"

STATE_RESPONSE=$(curl -s -X POST https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: $LINEAR_API_KEY" \
  -d "{
    \"query\": \"query { workflowStates(filter: { team: { id: { eq: \\\"$TEAM_ID\\\" } }, name: { eq: \\\"In Progress\\\" } }) { nodes { id name } } }\"
  }")

STATE_UUID=$(echo "$STATE_RESPONSE" | jq -r '.data.workflowStates.nodes[0].id')

if [ -z "$STATE_UUID" ] || [ "$STATE_UUID" == "null" ]; then
    echo -e "${RED}Error: 'In Progress' state not found${NC}"
    exit 1
fi

echo "   Found state: In Progress"

# Build update input
echo -e "${YELLOW}Step 5: Updating issue...${NC}"

UPDATE_INPUT="assigneeId: \\\"$ASSIGNEE_UUID\\\", stateId: \\\"$STATE_UUID\\\""

if [ -n "$PRIORITY" ] && [ "$PRIORITY" != "null" ]; then
    UPDATE_INPUT="$UPDATE_INPUT, priority: $PRIORITY"
fi

if [ -n "$ESTIMATE" ] && [ "$ESTIMATE" != "null" ]; then
    UPDATE_INPUT="$UPDATE_INPUT, estimate: $ESTIMATE"
fi

UPDATE_RESPONSE=$(curl -s -X POST https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: $LINEAR_API_KEY" \
  -d "{
    \"query\": \"mutation { issueUpdate(id: \\\"$ISSUE_UUID\\\", input: { $UPDATE_INPUT }) { success issue { id state { name } assignee { name } priority estimate } } }\"
  }")

UPDATE_SUCCESS=$(echo "$UPDATE_RESPONSE" | jq -r '.data.issueUpdate.success')

if [ "$UPDATE_SUCCESS" != "true" ]; then
    echo -e "${RED}Error: Failed to update issue${NC}"
    echo "$UPDATE_RESPONSE"
    exit 1
fi

NEW_STATE=$(echo "$UPDATE_RESPONSE" | jq -r '.data.issueUpdate.issue.state.name')
FINAL_ASSIGNEE=$(echo "$UPDATE_RESPONSE" | jq -r '.data.issueUpdate.issue.assignee.name')
FINAL_PRIORITY=$(echo "$UPDATE_RESPONSE" | jq -r '.data.issueUpdate.issue.priority')
FINAL_ESTIMATE=$(echo "$UPDATE_RESPONSE" | jq -r '.data.issueUpdate.issue.estimate')

echo "   ✓ Assigned to: $FINAL_ASSIGNEE"
echo "   ✓ State: $NEW_STATE"
echo "   ✓ Priority: P$FINAL_PRIORITY"
echo "   ✓ Estimate: $FINAL_ESTIMATE"

# Add comment
echo -e "${YELLOW}Step 6: Adding activation comment...${NC}"

PRIORITY_LABEL="P${FINAL_PRIORITY:-3}"
ESTIMATE_LABELS=("" "XS" "S" "M" "L" "XL")
ESTIMATE_LABEL="${ESTIMATE_LABELS[$FINAL_ESTIMATE]:-M}"

COMMENT="**Activated** — Assigned to @$FINAL_ASSIGNEE. Priority: $PRIORITY_LABEL. Estimate: $ESTIMATE_LABEL."
if [ "$HAS_ESTIMATE" == "false" ]; then
    COMMENT="$COMMENT\n\n⚠️ Note: Missing AI Effort Estimate."
fi

ESCAPED_COMMENT=$(echo "$COMMENT" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g')

COMMENT_RESPONSE=$(curl -s -X POST https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: $LINEAR_API_KEY" \
  -d "{
    \"query\": \"mutation { commentCreate(input: { issueId: \\\"$ISSUE_UUID\\\", body: \\\"$ESCAPED_COMMENT\\\" }) { success } }\"
  }")

COMMENT_SUCCESS=$(echo "$COMMENT_RESPONSE" | jq -r '.data.commentCreate.success')

if [ "$COMMENT_SUCCESS" != "true" ]; then
    echo -e "${YELLOW}Warning: Failed to add comment (issue still activated)${NC}"
fi

echo ""
echo -e "${GREEN}✅ Issue activated successfully!${NC}"
echo "   Issue: $ISSUE_IDENTIFIER - $ISSUE_TITLE"
echo "   Assignee: $FINAL_ASSIGNEE"
echo "   State: In Progress"
echo "   Priority: $PRIORITY_LABEL"
echo "   Estimate: $ESTIMATE_LABEL"
if [ "$HAS_ESTIMATE" == "false" ]; then
    echo -e "   ${YELLOW}⚠️ Consider adding AI Effort Estimate${NC}"
fi

