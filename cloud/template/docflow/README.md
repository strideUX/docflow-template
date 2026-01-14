# DocFlow Cloud

This project uses DocFlow Cloud - a hybrid workflow where:
- **Work items (specs)** live in Linear
- **Project understanding** lives locally in git
- **Framework config, rules & templates** live in `.docflow/`

---

## Directory Structure

```
.docflow/                  # FRAMEWORK (updatable)
├── config.json            # Provider settings, workspace config
├── version                # For upgrade detection
├── rules/                 # Workflow rules (source of truth)
│   ├── always.md          # Non-negotiable process rules
│   ├── core.md            # Essential rules (always loaded)
│   ├── workflow-agent.md  # PM, Implementation, QE workflows
│   ├── linear-integration.md
│   ├── figma-integration.md
│   ├── session-awareness.md
│   └── designer-agent.md
├── scripts/               # Automation scripts
│   ├── status-summary.sh
│   ├── session-context.sh
│   ├── stale-check.sh
│   ├── activate-issue.sh
│   ├── transition-issue.sh
│   └── wrap-session.sh
├── skills/                # Portable Agent Skills
│   ├── linear-workflow/
│   ├── figma-mcp/         # Figma integration workflow
│   ├── component-workflow/ # Component patterns & testing
│   ├── ai-labor-estimate/ # Token/cost estimation
│   ├── spec-templates/
│   └── docflow-commands/
├── templates/             # Issue templates
└── design-system/         # (Optional) Created by /design-setup
    ├── token-mapping.md   # Figma → code translations
    └── component-patterns.md

{this-folder}/             # PROJECT CONTENT (this folder)
├── context/               # Project fundamentals
│   ├── overview.md        # Vision, goals, scope
│   ├── stack.md           # Tech stack, architecture
│   └── standards.md       # Code conventions
│
├── knowledge/             # Project knowledge
│   ├── INDEX.md           # Knowledge inventory
│   ├── decisions/         # Architecture Decision Records
│   ├── features/          # Complex feature documentation
│   ├── notes/             # Learnings, gotchas, tips
│   └── product/           # Personas, user flows
│
└── README.md              # This file

.cursor/
├── rules/                 # Cursor rule pointers
│   ├── docflow-core/RULE.md      # Always applied
│   ├── pm-agent/RULE.md          # Planning triggers
│   ├── implementation-agent/RULE.md  # Build triggers
│   ├── qe-agent/RULE.md          # Testing triggers
│   ├── linear-integration/RULE.md
│   └── ...
└── commands/              # Slash commands

.claude/
├── CLAUDE.md              # Claude Code instructions
└── commands/              # Symlinks to .cursor/commands/
```

**Note:** Content folder name is configurable via `paths.content` in `.docflow/config.json`.

---

## What Lives Where

### LOCAL (This Directory)

| Content | Location | Purpose |
|---------|----------|---------|
| Project overview | `context/overview.md` | Vision, goals, scope |
| Tech stack | `context/stack.md` | Architecture, dependencies |
| Code standards | `context/standards.md` | Conventions, patterns |
| ADRs | `knowledge/decisions/` | Why we made choices |
| Feature docs | `knowledge/features/` | How features work |
| Notes | `knowledge/notes/` | Learnings, gotchas |
| Product docs | `knowledge/product/` | Personas, user flows |

**Why local?** Agent needs instant access, changes with code, developers need it in IDE.

### LINEAR (Cloud)

| Content | Linear Location | Purpose |
|---------|-----------------|---------|
| Specs | Issues | Features, bugs, chores, ideas |
| Status | Workflow states | BACKLOG → DONE progression |
| Priorities | Priority field | Urgent, High, Medium, Low |
| Assignments | Assignee | Who's working on what |
| Assets | Attachments | Figma links, screenshots |
| Progress | Comments | Decision log, impl notes |

**Why cloud?** Team collaboration, stakeholder visibility, AI agent integration.

---

## No Longer Exists

These are **replaced by Linear**:

- ~~`docflow/specs/`~~ → Linear issues
- ~~`docflow/INDEX.md`~~ → Linear issue list
- ~~`docflow/ACTIVE.md`~~ → Linear "In Progress" view
- ~~`docflow/specs/assets/`~~ → Linear attachments

---

## Quick Commands

```
/start-session    - Check Linear status, plan work
/capture          - Create new Linear issue
/new-project      - Create project with product label/icon
/implement        - Pick up issue from Linear
/validate         - Test implementation
/close            - Move issue to Done
/docflow-update   - Sync rules from source repo
/design-setup     - (Optional) Initialize design system integration
```

---

## Design System (Optional)

If you have a Figma design system with tokens, run `/design-setup` to enable enhanced Figma integration:

```
/design-setup
```

This creates:
- `.docflow/design-system/token-mapping.md` - Your Figma → code translations
- `.docflow/design-system/component-patterns.md` - Your reusable components

And updates `.docflow/config.json` with:
```json
{
  "designSystem": {
    "enabled": true,
    "figmaFiles": {
      "designs": "your-designs-file-key",
      "system": "your-design-system-file-key"
    }
  }
}
```

**Without design system:** Baseline Figma workflow (5-phase, screenshot-first) always works.
**With design system:** Token enforcement, validation, stricter design consistency.

---

## Configuration

See `.docflow/config.json` for:
- DocFlow version
- `paths.content` - This folder name (default: "docflow")
- `provider.teamId` - Linear team ID
- `workspace.activeProjects` - Array of active project IDs
- `workspace.product` - Product identity (name, labelId, icon, color)
- `statusMapping` - Workflow state names

See `.cursor/mcp.json` for MCP server configuration.

---

## More Information

- `AGENTS.md` - AI agent instructions
- `.docflow/rules/` - Complete workflow rules (source of truth)
- `.docflow/skills/` - Portable agent skills
- `knowledge/INDEX.md` - Knowledge base inventory
