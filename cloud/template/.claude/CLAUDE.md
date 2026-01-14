# DocFlow Cloud Rules for Claude Code

This project uses **DocFlow Cloud** with Linear integration.

---

## Primary Documentation

1. **`.docflow/config.json`** - Configuration (read first)
2. **`.docflow/rules/always.md`** - Non-negotiable process rules (ALWAYS load)
3. **`.docflow/rules/core.md`** - Essential workflow rules
4. **`.docflow/rules/workflow-agent.md`** - PM, Implementation, QE workflows
5. **`AGENTS.md`** - Universal agent instructions

---

## Agent Roles

| Agent | Rules File |
|-------|------------|
| PM/Planning | `.docflow/rules/workflow-agent.md` (PM section) |
| Implementation | `.docflow/rules/workflow-agent.md` (Implementation section) |
| QE/Validation | `.docflow/rules/workflow-agent.md` (QE section) |
| Designer | `.docflow/rules/designer-agent.md` |

---

## Commands

Commands are in `.claude/commands/` (symlinks to `.cursor/commands/`).

**Core workflow:**
- `/start-session` - Begin work session
- `/capture` - Create issue in Linear
- `/implement` - Build a feature/fix
- `/validate` - Test with user
- `/close` - Complete issue

**Project management:**
- `/new-project` - Create project with product label/icon
- `/status` - Check Linear state
- `/project-update` - Post project health update
- `/sync-project` - Sync context to Linear

**Natural language triggers:**
- "let's start" → /start-session
- "capture that" → /capture
- "implement [x]" → /implement
- "new project" → /new-project
- "looks good" → QE approval

---

## Key Differences from Local DocFlow

- All specs in Linear (not local files)
- Context stays in `{paths.content}/context/`
- Status changes → Linear state updates
- Progress notes → Linear comments

---

## Skills

Load situationally from `.docflow/skills/`:
- `figma-mcp` - Figma integration workflow
- `component-workflow` - Component patterns & testing
- `linear-workflow` - Linear MCP operations
- `ai-labor-estimate` - Token/cost estimation (if enabled)

---

*For complete rules, see `.docflow/rules/` directory.*
