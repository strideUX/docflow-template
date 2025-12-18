#!/bin/bash
# status-summary.sh
# Queries Linear via API for current state counts
# Returns structured status output for session commands
# Requires: LINEAR_API_KEY environment variable

set -e

# Check for API key
if [ -z "$LINEAR_API_KEY" ]; then
  # Try to source from .env
  if [ -f ".env" ]; then
    source .env
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

# Query Linear for issue counts by state
# This uses the GraphQL API directly for efficiency
echo "=== Linear Status Summary ==="

QUERY='{"query": "{ issues(filter: { state: { type: { in: [\"started\", \"unstarted\", \"backlog\"] } } }) { nodes { state { name type } } } }"}'

RESPONSE=$(curl -s -X POST https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: $LINEAR_API_KEY" \
  -d "$QUERY")

if command -v jq &> /dev/null; then
  echo "$RESPONSE" | jq -r '
    .data.issues.nodes | group_by(.state.name) | 
    map({state: .[0].state.name, count: length}) | 
    .[] | "\(.state): \(.count)"
  ' 2>/dev/null || echo "Use Linear MCP for detailed status"
else
  echo "Install jq for parsed output, or use Linear MCP"
fi
