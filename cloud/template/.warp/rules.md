# DocFlow Cloud Rules for Warp

This project uses **DocFlow Cloud** with Linear integration.

## Primary Documentation

1. **`.docflow/config.json`** - Configuration (read first)
2. **`.docflow/rules/core.md`** - Essential workflow rules
3. **`.docflow/rules/`** - Role-specific rules
4. **`AGENTS.md`** - Universal agent instructions

---

## Quick Start

```bash
# View configuration
cat .docflow/config.json

# View local context (adjust path if needed)
cat docflow/context/stack.md
```

---

## Warp Strengths

- ✅ Implementation work (builds, tests, git)
- ✅ Reading local context
- ✅ Terminal-heavy workflows

## For Extended Sessions

Consider Cursor for:
- Complex planning sessions
- Figma design integration
- Iterative QE testing

---

## Agent Roles

| Agent | Best Tool | Rules |
|-------|-----------|-------|
| PM/Planning | Cursor, Claude | `.docflow/rules/workflow-agent.md` (PM section) |
| Implementation | **Warp**, Cursor | `.docflow/rules/workflow-agent.md` (Implementation section) |
| QE/Validation | Cursor, Claude | `.docflow/rules/workflow-agent.md` (QE section) |

---

## Commands

See `.cursor/commands/` for detailed specs.

**Warp usage:** Describe command to AI or reference the command file.

---

*For complete rules, see `.docflow/rules/` directory.*
