# Status (All Agents)

Quick check of current work state from Linear.

## Steps

1. **Query Linear** for issue counts by state
2. **Get Current User's Work** (assigned issues)
3. **Check for Stale Issues** (extended time in active state)
4. **Present Dashboard** with counts and suggestions

## Context to Load

- `.docflow/config.json`
- Linear queries via MCP

## Scripts

Run `.docflow/scripts/status-summary.sh` for quick counts.
Run `.docflow/scripts/stale-check.sh` for stale issues.

## Natural Language Triggers

- "status" / "what's the status" / "where are we"

## Full Rules

See `.docflow/rules/linear-integration.md`
