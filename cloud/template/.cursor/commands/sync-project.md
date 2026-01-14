# Sync Project (PM/Planning Agent)

Sync local context files to Linear project description.

## Important

**Only sync if:**
- Project description is empty (new project), OR
- User explicitly confirms overwrite

**Never overwrite existing project description without asking.**

## Steps

1. **Query Linear Project** - Check if description exists
2. **If exists** - Show current, ask user to confirm overwrite
3. **If empty or confirmed** - Read context files, generate description
4. **Update Linear** - Short summary + full content
5. **Confirm** sync complete

## Context to Load

- `.docflow/config.json`
- `{paths.content}/context/overview.md` - Vision, goals, scope
- `{paths.content}/context/stack.md` - Technology choices
- `{paths.content}/context/standards.md` - Conventions

## Output Format

**Short summary (≤255 chars):**
`[Project Name]: [Vision]. Built with [key tech]. [Phase].`

**Full description:** Overview, Goals, Tech Stack, Standards, Scope

## Natural Language Triggers

- "sync project" / "update project description"

## Full Rules

See `.docflow/rules/workflow-agent.md` → PM section
