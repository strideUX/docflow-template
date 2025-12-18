#!/bin/bash
# session-context.sh
# Reads .docflow/config.json and outputs key configuration values
# Used by session-awareness rule and commands for efficient config loading

set -e

CONFIG_FILE=".docflow/config.json"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Error: $CONFIG_FILE not found"
  exit 1
fi

# Extract key values using jq (if available) or basic parsing
if command -v jq &> /dev/null; then
  echo "=== DocFlow Configuration ==="
  echo "Content Path: $(jq -r '.paths.content // "docflow"' "$CONFIG_FILE")"
  echo "Team ID: $(jq -r '.provider.teamId // "not set"' "$CONFIG_FILE")"
  echo "Project ID: $(jq -r '.provider.projectId // "not set"' "$CONFIG_FILE")"
  echo "Version: $(jq -r '.version // "unknown"' "$CONFIG_FILE")"
else
  echo "=== DocFlow Configuration ==="
  echo "(Install jq for better output)"
  cat "$CONFIG_FILE"
fi
