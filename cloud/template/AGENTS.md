# AI Agent Instructions

This project uses **DocFlow Cloud**, a spec-driven development workflow with Linear integration.

---

## Primary Documentation

**Read these files for complete instructions:**

1. **`.docflow/config.json`** - Configuration (read first for paths)
2. **`.docflow/rules/core.md`** - Essential workflow rules
3. **`.docflow/rules/`** - Role-specific rules (load as needed)
4. **`.claude/skills/`** - Portable workflow skills (auto-discovered)

---

## Agent Roles

| Agent | Purpose | Rules |
|-------|---------|-------|
| **PM/Planning** | Planning, reviewing, closing | `.docflow/rules/workflow-agent.md` (PM section) |
| **Implementation** | Building features | `.docflow/rules/workflow-agent.md` (Implementation section) |
| **QE/Validation** | Testing with user | `.docflow/rules/workflow-agent.md` (QE section) |
| **Designer** | Design system, tokens | `.docflow/rules/designer-agent.md` |

---

## Key Skills

| Skill | Purpose | Path |
|-------|---------|------|
| **figma-mcp** | Figma integration workflow | `.claude/skills/figma-mcp/` |
| **component-workflow** | Component patterns & testing | `.claude/skills/component-workflow/` |
| **linear-workflow** | Linear MCP integration | `.claude/skills/linear-workflow/` |

---

## Key Principles

- **Specs live in Linear** (not local files)
- **Context stays local** (`{paths.content}/context/`, `{paths.content}/knowledge/`)
- **Update Linear, not files** for status/progress
- **Load rules situationally** based on current task
- **Design system is optional** - baseline Figma behavior always works

---

## Commands

Commands are in `.cursor/commands/`. Use natural language or slash commands.

**Quick reference:**
- `/start-session` - Begin work session
- `/capture` - Create issue
- `/implement` - Build feature
- `/new-project` - Create project with product label/icon
- `/status` - Check Linear state
- `/design-setup` - Initialize design system (optional)

---

## Design System (Optional)

If `.docflow/config.json` has `designSystem.enabled: true`:
- Token mapping enforced for all Figma implementations
- Load `.docflow/design-system/token-mapping.md` for translations
- Validation script can enforce design system compliance

Run `/design-setup` to initialize design system integration.

---

## For Complete Rules

See `.docflow/rules/` directory for comprehensive workflow documentation.
