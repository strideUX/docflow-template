# AI Agent Instructions

This project uses **DocFlow Cloud**, a spec-driven development workflow with Linear integration.

---

## Primary Documentation

**Read these files for complete instructions:**

1. **`.docflow/config.json`** - Configuration (read first for paths)
2. **`.docflow/rules/core.md`** - Essential workflow rules
3. **`.docflow/rules/`** - Role-specific rules (load as needed)
4. **`.docflow/skills/`** - Portable workflow skills

---

## Agent Roles

| Agent | Purpose | Rules |
|-------|---------|-------|
| **PM/Planning** | Planning, reviewing, closing | `.docflow/rules/pm-agent.md` |
| **Implementation** | Building features | `.docflow/rules/implementation-agent.md` |
| **QE/Validation** | Testing with user | `.docflow/rules/qe-agent.md` |

---

## Key Principles

- **Specs live in Linear** (not local files)
- **Context stays local** (`{paths.content}/context/`, `{paths.content}/knowledge/`)
- **Update Linear, not files** for status/progress
- **Load rules situationally** based on current task

---

## Commands

Commands are in `.cursor/commands/`. Use natural language or slash commands.

**Quick reference:**
- `/start-session` - Begin work session
- `/capture` - Create issue
- `/implement` - Build feature
- `/status` - Check Linear state

---

## For Complete Rules

See `.docflow/rules/` directory for comprehensive workflow documentation.
