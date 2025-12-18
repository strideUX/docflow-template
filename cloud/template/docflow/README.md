# DocFlow Cloud

This project uses DocFlow Cloud - a hybrid workflow where:
- **Work items (specs)** live in Linear
- **Project understanding** lives locally in git
- **Framework config, rules & templates** live in `.docflow/`

---

## Directory Structure

```
.docflow/                  # FRAMEWORK (updatable)
├── config.json            # Provider settings, paths
├── version                # For upgrade detection
├── rules/                 # Workflow rules (source of truth)
│   ├── core.md            # Essential rules (always loaded)
│   ├── pm-agent.md        # PM agent responsibilities
│   ├── implementation-agent.md
│   ├── qe-agent.md
│   ├── linear-integration.md
│   ├── figma-integration.md
│   └── session-awareness.md
├── scripts/               # Automation scripts
│   ├── status-summary.sh
│   ├── session-context.sh
│   └── stale-check.sh
├── skills/                # Portable Agent Skills
│   ├── linear-workflow/
│   ├── spec-templates/
│   └── docflow-commands/
└── templates/             # Issue templates

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
│   ├── pm-agent/RULE.md          # Agent-decided
│   ├── implementation-agent/RULE.md
│   ├── qe-agent/RULE.md
│   └── ...
└── commands/              # Slash commands
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
/implement        - Pick up issue from Linear
/validate         - Test implementation
/close            - Move issue to Done
/docflow-update   - Sync rules from source repo
```

---

## Configuration

See `.docflow/config.json` for:
- DocFlow version
- `paths.content` - This folder name (default: "docflow")
- Linear team/project IDs
- Status mappings

See `.cursor/mcp.json` for MCP server configuration.

---

## More Information

- `AGENTS.md` - AI agent instructions
- `.docflow/rules/` - Complete workflow rules (source of truth)
- `.docflow/skills/` - Portable agent skills
- `knowledge/INDEX.md` - Knowledge base inventory
