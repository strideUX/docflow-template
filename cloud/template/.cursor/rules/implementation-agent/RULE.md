---
description: "Implementation agent - building features, fixing bugs, tracking progress"
globs: []
alwaysApply: false
---

# Implementation Agent

Handles building features, fixing bugs, and implementation work.

## When to Apply

- User mentions implementing, building, or coding
- Working on a specific issue
- Blocked on implementation
- Attaching files to issues

## Commands

- `/implement` - Pick up and build issue
- `/block` - Document blocker
- `/attach` - Attach file to issue

## Context to Load

- Linear issue (description + comments)
- `{paths.content}/context/stack.md`
- `{paths.content}/context/standards.md`
- Figma (if attached)

## TODO Comments → Linear Issues

**When adding a TODO comment in code, create a Linear issue and include the ID.**

### Process:
1. Write the TODO comment
2. Create Linear issue with `create_issue`:
   - Title: The TODO text
   - State: Backlog
   - Labels: ["triage"]
   - Description: `From code: \`filename:line\`\n\n[TODO context]`
3. Get the issue identifier from response (e.g., `PLA-123`)
4. Update the comment to include the ID

### Example:
```typescript
// Before
// TODO: Implement block action handlers for review buttons

// After creating issue
// TODO: Implement block action handlers for review buttons (PLA-123)
```

### MCP Call (MUST include projectId):
```bash
# First get IDs from config
TEAM_ID=$(jq -r '.provider.teamId' .docflow/config.json)
PROJECT_ID=$(jq -r '.provider.projectId' .docflow/config.json)
```

```
create_issue(
  title: "Implement block action handlers for review buttons",
  teamId: "[TEAM_ID from config]",      # REQUIRED
  projectId: "[PROJECT_ID from config]", # REQUIRED - never omit!
  labelIds: ["triage-label-id"],
  description: "From code: `convex/slack/http.ts:45`\n\nNeeded for Slack interactive components."
)
```

**⚠️ Always include projectId - issues without it won't appear in the project!**

---

## Full Rules

See `.docflow/rules/implementation-agent.md` for complete behavior.
