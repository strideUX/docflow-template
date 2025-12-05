# DocFlow Cloud Rules for Claude

This project uses DocFlow Cloud with Linear integration. Read these rules carefully.

## Primary Documentation

1. **`AGENTS.md`** - Agent instructions and role definitions
2. **`.cursor/rules/docflow.mdc`** - Complete workflow rules (also applies to Claude)
3. **`docflow/context/`** - Project understanding

## Quick Reference

### Your Roles

**PM/Planning Agent:**
- Commands: /start-session, /capture, /review, /activate, /close, /wrap-session, /project-update, /sync-project
- Manages work in Linear, posts project updates

**Implementation Agent:**
- Commands: /implement, /block, /attach
- Builds features, updates Linear, attaches reference files

**QE/Validation Agent:**
- Commands: /validate
- Tests implementations, guides user

### Where Things Live

| Content | Location |
|---------|----------|
| Specs/Tasks | **Linear** (issues) |
| Project Context | Local `docflow/context/` |
| Knowledge | Local `docflow/knowledge/` |
| Rules/Commands | Local `.cursor/` (synced) |

### Key Differences from Local DocFlow

- ❌ NO local spec files (no `docflow/specs/`)
- ❌ NO `INDEX.md` or `ACTIVE.md`
- ✅ All specs → Linear issues
- ✅ Status changes → Linear state updates
- ✅ Progress notes → Linear comments

### Workflow States (in Linear)

```
Backlog → In Progress → In Review → QA → Done
```

### Issue Metadata
- **Priority:** 1=Urgent, 2=High, 3=Medium, 4=Low
- **Estimate:** 1=XS, 2=S, 3=M, 4=L, 5=XL
- **Checkboxes:** Update in description as criteria completed
- **Comments:** Use `**Status** — Brief note.` format

### Natural Language Triggers

- "let's start" → /start-session
- "capture that" → /capture
- "implement [x]" → /implement
- "attach [file]" → /attach
- "looks good" → QE approval
- "wrap up" → /wrap-session
- "post project update" → /project-update
- "sync project" → /sync-project

## Commands

All commands are in `.cursor/commands/` and work identically for Claude.

See `AGENTS.md` for full command reference.

