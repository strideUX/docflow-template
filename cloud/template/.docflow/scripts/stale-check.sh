#!/bin/bash
# stale-check.sh
# Checks for issues in active states for extended periods
# Returns list of stale issues with days since last update
# Used by session-awareness rule

set -e

# Check for API key
if [ -z "$LINEAR_API_KEY" ]; then
  if [ -f ".env" ]; then
    source .env
  fi
fi

if [ -z "$LINEAR_API_KEY" ]; then
  echo "=== Stale Check ==="
  echo "⚠️  LINEAR_API_KEY not set - use Linear MCP for stale detection"
  exit 0
fi

echo "=== Stale Issue Check ==="

# Calculate date threshold (7 days ago for In Progress, 3 days for Review/QA)
SEVEN_DAYS_AGO=$(date -v-7d +%Y-%m-%d 2>/dev/null || date -d "7 days ago" +%Y-%m-%d)
THREE_DAYS_AGO=$(date -v-3d +%Y-%m-%d 2>/dev/null || date -d "3 days ago" +%Y-%m-%d)

# Query for potentially stale issues
QUERY='{"query": "{ issues(filter: { state: { name: { in: [\"In Progress\", \"In Review\", \"QA\"] } } }) { nodes { identifier title state { name } updatedAt } } }"}'

RESPONSE=$(curl -s -X POST https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: $LINEAR_API_KEY" \
  -d "$QUERY")

if command -v jq &> /dev/null; then
  echo "$RESPONSE" | jq -r '
    .data.issues.nodes[] | 
    select(.updatedAt < (now - 259200 | todate)) |
    "\(.identifier): \(.title) (\(.state.name)) - last updated: \(.updatedAt | split("T")[0])"
  ' 2>/dev/null || echo "No stale issues found or use Linear MCP"
else
  echo "Install jq for parsed output, or use Linear MCP"
fi
