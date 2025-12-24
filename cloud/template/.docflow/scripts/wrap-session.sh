#!/bin/bash
#
# wrap-session.sh - Post project update to Linear
#
# Usage: ./wrap-session.sh "<summary>" "<health>"
#
# Arguments:
#   summary - Markdown summary of the session (required)
#   health  - onTrack | atRisk | offTrack (default: onTrack)
#
# Example:
#   ./wrap-session.sh "**Session Summary**\n\n✅ Completed:\n- PLA-123" "onTrack"
#
# Requirements:
#   - LINEAR_API_KEY in .env file
#   - provider.projectId in .docflow/config.json
#   - jq installed
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Arguments
SUMMARY="$1"
HEALTH="${2:-onTrack}"

# Validate arguments
if [ -z "$SUMMARY" ]; then
    echo -e "${RED}Error: Summary is required${NC}"
    echo "Usage: ./wrap-session.sh \"<summary>\" \"<health>\""
    exit 1
fi

# Validate health value
if [[ ! "$HEALTH" =~ ^(onTrack|atRisk|offTrack)$ ]]; then
    echo -e "${RED}Error: Health must be onTrack, atRisk, or offTrack${NC}"
    exit 1
fi

# Check for .env file
if [ ! -f ".env" ]; then
    echo -e "${RED}Error: .env file not found${NC}"
    echo "Create .env with LINEAR_API_KEY=lin_api_xxxxx"
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
    echo "Install with: brew install jq"
    exit 1
fi

# Read credentials
LINEAR_API_KEY=$(grep LINEAR_API_KEY .env | cut -d '=' -f2 | tr -d '"' | tr -d "'")
PROJECT_ID=$(jq -r '.provider.projectId' .docflow/config.json)

# Validate credentials
if [ -z "$LINEAR_API_KEY" ] || [ "$LINEAR_API_KEY" == "null" ]; then
    echo -e "${RED}Error: LINEAR_API_KEY not found in .env${NC}"
    exit 1
fi

if [ -z "$PROJECT_ID" ] || [ "$PROJECT_ID" == "null" ]; then
    echo -e "${RED}Error: provider.projectId not found in config.json${NC}"
    exit 1
fi

echo -e "${YELLOW}Posting project update to Linear...${NC}"

# Escape the summary for JSON
ESCAPED_SUMMARY=$(echo "$SUMMARY" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g')

# Post project update
RESPONSE=$(curl -s -X POST https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: $LINEAR_API_KEY" \
  -d "{
    \"query\": \"mutation(\$projectId: String!, \$body: String!, \$health: ProjectUpdateHealthType!) { projectUpdateCreate(input: { projectId: \$projectId, body: \$body, health: \$health }) { success projectUpdate { id url } } }\",
    \"variables\": {
      \"projectId\": \"$PROJECT_ID\",
      \"body\": \"$ESCAPED_SUMMARY\",
      \"health\": \"$HEALTH\"
    }
  }")

# Check for errors
if echo "$RESPONSE" | jq -e '.errors' > /dev/null 2>&1; then
    ERROR=$(echo "$RESPONSE" | jq -r '.errors[0].message')
    echo -e "${RED}Error posting update: $ERROR${NC}"
    exit 1
fi

# Check for success
SUCCESS=$(echo "$RESPONSE" | jq -r '.data.projectUpdateCreate.success')
if [ "$SUCCESS" != "true" ]; then
    echo -e "${RED}Failed to post project update${NC}"
    echo "$RESPONSE"
    exit 1
fi

# Extract URL
UPDATE_URL=$(echo "$RESPONSE" | jq -r '.data.projectUpdateCreate.projectUpdate.url')
UPDATE_ID=$(echo "$RESPONSE" | jq -r '.data.projectUpdateCreate.projectUpdate.id')

echo -e "${GREEN}✅ Project update posted successfully!${NC}"
echo -e "   ID: $UPDATE_ID"
echo -e "   URL: $UPDATE_URL"
echo ""
echo "$UPDATE_URL"

