# Project Update (PM/Planning Agent)

Post a project health update to Linear.

## Steps

1. **Compose Summary** - What was accomplished, what's next
2. **Set Health Status** - onTrack, atRisk, or offTrack
3. **Post via GraphQL API** - Requires LINEAR_API_KEY
4. **Confirm** with link

## Requirements

- LINEAR_API_KEY in .env file

## Natural Language Triggers

- "post project update" / "update project status"

## Full Rules

See `.docflow/rules/pm-agent.md`


