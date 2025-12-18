# Start Session (PM/Planning Agent)

Begin a work session by checking Linear status and identifying what needs attention.

## Steps

1. **Load Configuration** - Read `.docflow/config.json`
2. **Query Linear** for issues by priority:
   - QA (needs testing)
   - In Review (needs code review)
   - Blocked (needs attention)
   - In Progress (active work)
   - Backlog (ready to start)
3. **Present Dashboard** with counts and options
4. **Wait for User Direction**

## Context to Load

- `.docflow/config.json`
- `{paths.content}/context/overview.md`
- Linear queries via MCP

## Scripts

Run `.docflow/scripts/status-summary.sh` for quick counts.

## Natural Language Triggers

- "let's start" / "what's next" / "where are we"

## Full Rules

See `.docflow/rules/pm-agent.md` and `.docflow/rules/session-awareness.md`
