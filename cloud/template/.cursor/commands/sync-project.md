# Sync Project (PM/Planning Agent)

Sync local context files to Linear project description.

## Steps

1. **Read Context Files** - overview.md, stack.md, standards.md
2. **Generate Summary** - 255 char short + full content
3. **Update Linear Project** - description + content fields
4. **Confirm** sync complete

## Context to Load

- `.docflow/config.json`
- `{paths.content}/context/overview.md`
- `{paths.content}/context/stack.md`
- `{paths.content}/context/standards.md`

## Natural Language Triggers

- "sync project" / "update project description"

## Full Rules

See `.docflow/rules/pm-agent.md`
