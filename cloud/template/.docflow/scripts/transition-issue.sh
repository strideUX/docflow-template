#!/bin/bash
#
# transition-issue.sh - Change issue state and add comment atomically
#
# Usage: ./transition-issue.sh <issue-id> <state-name> "<comment>"
#
# Arguments:
#   issue-id   - Linear issue identifier (e.g., PLA-123) or UUID
#   state-name - Target state name (e.g., "In Progress", "In Review", "Done")
#   comment    - Comment to add (required)
#
# Example:
#   ./transition-issue.sh PLA-123 "In Progress" "**Activated** — Assigned to @matt"
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
STATE_NAME="$2"
COMMENT="$3"

# Validate arguments
if [ -z "$ISSUE_ID" ] || [ -z "$STATE_NAME" ] || [ -z "$COMMENT" ]; then
    echo -e "${RED}Error: All arguments required${NC}"
    echo "Usage: ./transition-issue.sh <issue-id> <state-name> \"<comment>\""
    echo ""
    echo "States: Backlog, Todo, In Progress, Blocked, In Review, QA, Done, Archived, Canceled"
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

if [ -z "$TEAM_ID" ] || [ "$TEAM_ID" == "null" ]; then
    echo -e "${RED}Error: provider.teamId not found in config.json${NC}"
    exit 1
fi

echo -e "${YELLOW}Step 1: Looking up issue $ISSUE_ID...${NC}"

# Get issue UUID if identifier provided
ISSUE_RESPONSE=$(curl -s -X POST https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: $LINEAR_API_KEY" \
  -d "{
    \"query\": \"query { issue(id: \\\"$ISSUE_ID\\\") { id identifier title state { name } } }\"
  }")

ISSUE_UUID=$(echo "$ISSUE_RESPONSE" | jq -r '.data.issue.id')
ISSUE_IDENTIFIER=$(echo "$ISSUE_RESPONSE" | jq -r '.data.issue.identifier')
ISSUE_TITLE=$(echo "$ISSUE_RESPONSE" | jq -r '.data.issue.title')
CURRENT_STATE=$(echo "$ISSUE_RESPONSE" | jq -r '.data.issue.state.name')

if [ -z "$ISSUE_UUID" ] || [ "$ISSUE_UUID" == "null" ]; then
    echo -e "${RED}Error: Issue $ISSUE_ID not found${NC}"
    exit 1
fi

echo "   Found: $ISSUE_IDENTIFIER - $ISSUE_TITLE"
echo "   Current state: $CURRENT_STATE"

echo -e "${YELLOW}Step 2: Looking up state '$STATE_NAME'...${NC}"

# Get state UUID
STATE_RESPONSE=$(curl -s -X POST https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: $LINEAR_API_KEY" \
  -d "{
    \"query\": \"query { workflowStates(filter: { team: { id: { eq: \\\"$TEAM_ID\\\" } }, name: { eq: \\\"$STATE_NAME\\\" } }) { nodes { id name } } }\"
  }")

STATE_UUID=$(echo "$STATE_RESPONSE" | jq -r '.data.workflowStates.nodes[0].id')

if [ -z "$STATE_UUID" ] || [ "$STATE_UUID" == "null" ]; then
    echo -e "${RED}Error: State '$STATE_NAME' not found for team${NC}"
    echo "Available states for team $TEAM_ID:"
    curl -s -X POST https://api.linear.app/graphql \
      -H "Content-Type: application/json" \
      -H "Authorization: $LINEAR_API_KEY" \
      -d "{
        \"query\": \"query { workflowStates(filter: { team: { id: { eq: \\\"$TEAM_ID\\\" } } }) { nodes { name } } }\"
      }" | jq -r '.data.workflowStates.nodes[].name'
    exit 1
fi

echo "   Found state: $STATE_NAME ($STATE_UUID)"

echo -e "${YELLOW}Step 3: Updating issue state...${NC}"

# Update issue state
UPDATE_RESPONSE=$(curl -s -X POST https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: $LINEAR_API_KEY" \
  -d "{
    \"query\": \"mutation { issueUpdate(id: \\\"$ISSUE_UUID\\\", input: { stateId: \\\"$STATE_UUID\\\" }) { success issue { id state { name } } } }\"
  }")

UPDATE_SUCCESS=$(echo "$UPDATE_RESPONSE" | jq -r '.data.issueUpdate.success')
NEW_STATE=$(echo "$UPDATE_RESPONSE" | jq -r '.data.issueUpdate.issue.state.name')

if [ "$UPDATE_SUCCESS" != "true" ]; then
    echo -e "${RED}Error: Failed to update state${NC}"
    echo "$UPDATE_RESPONSE"
    exit 1
fi

echo "   State updated: $CURRENT_STATE → $NEW_STATE"

echo -e "${YELLOW}Step 4: Adding comment...${NC}"

# Escape comment for JSON
ESCAPED_COMMENT=$(echo "$COMMENT" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g')

# Add comment
COMMENT_RESPONSE=$(curl -s -X POST https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: $LINEAR_API_KEY" \
  -d "{
    \"query\": \"mutation { commentCreate(input: { issueId: \\\"$ISSUE_UUID\\\", body: \\\"$ESCAPED_COMMENT\\\" }) { success comment { id } } }\"
  }")

COMMENT_SUCCESS=$(echo "$COMMENT_RESPONSE" | jq -r '.data.commentCreate.success')

if [ "$COMMENT_SUCCESS" != "true" ]; then
    echo -e "${RED}Error: Failed to add comment${NC}"
    echo "$COMMENT_RESPONSE"
    exit 1
fi

echo "   Comment added"

echo ""
echo -e "${GREEN}✅ Transition complete!${NC}"
echo "   Issue: $ISSUE_IDENTIFIER - $ISSUE_TITLE"
echo "   State: $CURRENT_STATE → $NEW_STATE"
echo "   Comment: Added"

