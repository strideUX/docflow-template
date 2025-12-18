# DocFlow Cloud Rules for Claude

This project uses DocFlow Cloud with Linear integration. Read these rules carefully.

## Primary Documentation

1. **`.docflow/config.json`** - Configuration (read first for paths)
2. **`AGENTS.md`** - Agent instructions and role definitions
3. **`.cursor/rules/docflow.mdc`** - Complete workflow rules (also applies to Claude)
4. **`{paths.content}/context/`** - Project understanding

**Note:** `{paths.content}` is defined in `.docflow/config.json` (default: "docflow")

## Quick Reference

### Your Roles

**PM/Planning Agent:**
- Commands: /start-session, /capture, /refine, /activate, /close, /wrap-session, /project-update, /sync-project
- Manages work in Linear, posts project updates
- Uses templates from `.docflow/templates/` when creating/refining issues

**Implementation Agent:**
- Commands: /implement, /block, /attach
- Builds features, updates Linear, attaches reference files

**QE/Validation Agent:**
- Commands: /validate
- Tests implementations, guides user

### Where Things Live

| Content | Location |
|---------|----------|
| Config & Templates | `.docflow/` (framework) |
| Context & Knowledge | `{paths.content}/` (project) |
| Specs/Tasks | **Linear** (issues) |
| Rules/Commands | `.cursor/` (synced) |

### Key Differences from Local DocFlow

- ❌ NO local spec files (no `{paths.content}/specs/`)
- ❌ NO `INDEX.md` or `ACTIVE.md`
- ✅ All specs → Linear issues
- ✅ Status changes → Linear state updates
- ✅ Progress notes → Linear comments
- ✅ Templates in `.docflow/templates/`

### Workflow States (in Linear)

```
Backlog → In Progress → In Review → QA → Done
```

### Issue Metadata
- **Priority:** 1=Urgent, 2=High, 3=Medium, 4=Low
- **Estimate:** 1=XS, 2=S, 3=M, 4=L, 5=XL
- **Checkboxes:** Update in description as criteria completed
- **Comments:** Use `**Status** — Brief note.` format

### Team Collaboration
- **Assign:** `updateIssue(id, { assignee: "name" })` — by name, email, or "me"
- **Subscribers:** Add via GraphQL `subscriberIds` for notifications
- **Find users:** `list_users({ query: "name" })`

### Natural Language Triggers

- "let's start" → /start-session
- "capture that" → /capture
- "refine [issue]" → /refine
- "implement [x]" → /implement
- "attach [file]" → /attach
- "looks good" → QE approval
- "wrap up" → /wrap-session
- "post project update" → /project-update
- "sync project" → /sync-project

## Templates

When creating or refining issues, read templates from `.docflow/templates/`:
- `feature.md` - New functionality
- `bug.md` - Defect reports
- `chore.md` - Maintenance work
- `idea.md` - Future exploration
- `quick-capture.md` - Lightweight capture

Templates contain agent instructions in comments - follow them, then remove from final issue.

## Commands

All commands are in `.cursor/commands/` and work identically for Claude.

See `AGENTS.md` for full command reference.
