# DocFlow Cloud for Warp

This project uses **DocFlow Cloud** with Linear integration.

**For complete rules:** See `.docflow/rules/`  
**For configuration:** See `.docflow/config.json`  
**For Warp adapter:** See `.warp/rules.md`

---

## Quick Start

```bash
# Check configuration
cat .docflow/config.json

# View context (adjust path per config)
cat docflow/context/overview.md
```

---

## Warp Excels At

- **Implementation work** - Direct terminal access
- **Fast builds and tests** - Efficient operations
- **File operations** - Quick context reading

---

## Commands

| Command | Purpose |
|---------|---------|
| `/start-session` | Begin session |
| `/implement [issue]` | Build feature |
| `/status` | Quick status check |
| `/block` | Document blocker |

See `.cursor/commands/` for full specs.

---

## Directory Structure

```
.docflow/           # Framework (rules, templates, skills)
{paths.content}/    # Project content (context, knowledge)
.cursor/            # Cursor integration (rules, commands)
```

**Specs live in Linear, not local files.**

---

*DocFlow Cloud works great in Warp!*
