#!/bin/bash
# status-summary.sh
# Queries Linear via API for current state counts within product scope
# Returns structured status output for session commands
# Requires: LINEAR_API_KEY environment variable

set -e

# Check for API key
if [ -z "$LINEAR_API_KEY" ]; then
  # Try to source from .env
  if [ -f ".env" ]; then
    export $(grep -v '^#' .env | xargs)
  fi
fi

if [ -z "$LINEAR_API_KEY" ]; then
  echo "=== Status Summary ==="
  echo "⚠️  LINEAR_API_KEY not set - use Linear MCP for status"
  echo ""
  echo "To enable script-based status:"
  echo "1. Set LINEAR_API_KEY in .env"
  echo "2. Run: source .env"
  exit 0
fi

# Check for jq
if ! command -v jq &> /dev/null; then
  echo "⚠️  jq not installed - install with: brew install jq"
  exit 0
fi

# Read config
CONFIG_FILE=".docflow/config.json"
if [ ! -f "$CONFIG_FILE" ]; then
  echo "⚠️  Config file not found: $CONFIG_FILE"
  exit 0
fi

TEAM_ID=$(jq -r '.provider.teamId // empty' "$CONFIG_FILE")
ACTIVE_PROJECTS=$(jq -r '.workspace.activeProjects // [] | .[]' "$CONFIG_FILE")
PRODUCT_NAME=$(jq -r '.workspace.product.name // "Project"' "$CONFIG_FILE")

if [ -z "$TEAM_ID" ]; then
  echo "⚠️  No teamId configured"
  exit 0
fi

echo "=== Status Summary: $PRODUCT_NAME ==="
echo ""

# Query issues from active projects only
for PROJECT_ID in $ACTIVE_PROJECTS; do
  if [ -n "$PROJECT_ID" ]; then
    RESPONSE=$(curl -s -X POST https://api.linear.app/graphql \
      -H "Content-Type: application/json" \
      -H "Authorization: $LINEAR_API_KEY" \
      -d "{
        \"query\": \"query(\$projectId: String!) { project(id: \$projectId) { name issues { nodes { state { name type } } } } }\",
        \"variables\": { \"projectId\": \"$PROJECT_ID\" }
      }")

    PROJECT_NAME=$(echo "$RESPONSE" | jq -r '.data.project.name // "Unknown"')
    echo "📁 $PROJECT_NAME"

    echo "$RESPONSE" | jq -r '
      .data.project.issues.nodes | group_by(.state.name) |
      map({state: .[0].state.name, count: length}) |
      sort_by(.state) |
      .[] | "   \(.state): \(.count)"
    ' 2>/dev/null || echo "   (no issues or error)"

    echo ""
  fi
done

if [ -z "$ACTIVE_PROJECTS" ]; then
  echo "⚠️  No active projects configured"
  echo "   Add projects to workspace.activeProjects in config"
fi
