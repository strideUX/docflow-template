# DocFlow Cloud Rules for Claude

This project uses **DocFlow Cloud** with Linear integration.

## Primary Documentation

1. **`.docflow/config.json`** - Configuration (read first)
2. **`.docflow/rules/core.md`** - Essential workflow rules
3. **`.docflow/rules/`** - Role-specific rules
4. **`AGENTS.md`** - Universal agent instructions

---

## Agent Roles

| Agent | Rules File |
|-------|------------|
| PM/Planning | `.docflow/rules/pm-agent.md` |
| Implementation | `.docflow/rules/implementation-agent.md` |
| QE/Validation | `.docflow/rules/qe-agent.md` |

---

## Key Differences from Local DocFlow

- ❌ NO local spec files - ALL specs in Linear
- ✅ Context stays in `{paths.content}/context/`
- ✅ Status changes → Linear state updates
- ✅ Progress notes → Linear comments

---

## Commands

See `.cursor/commands/` for detailed command specs.

**Natural language triggers:**
- "let's start" → /start-session
- "capture that" → /capture
- "implement [x]" → /implement
- "looks good" → QE approval

---

*For complete rules, see `.docflow/rules/` directory.*
