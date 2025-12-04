# DocFlow Cloud

This project uses DocFlow Cloud - a hybrid workflow where:
- **Work items (specs)** live in Linear
- **Project understanding** lives locally in git

---

## Directory Structure

```
docflow/
├── context/           # Project fundamentals (LOCAL)
│   ├── overview.md    # Vision, goals, scope
│   ├── stack.md       # Tech stack, architecture
│   └── standards.md   # Code conventions
│
├── knowledge/         # Project knowledge (LOCAL)
│   ├── INDEX.md       # Knowledge inventory
│   ├── decisions/     # Architecture Decision Records
│   ├── features/      # Complex feature documentation
│   ├── notes/         # Learnings, gotchas, tips
│   └── product/       # Personas, user flows
│
└── README.md          # This file
```

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

See `.docflow.json` in project root for:
- DocFlow version
- Linear team/project IDs
- Status mappings

See `.cursor/mcp.json` for MCP server configuration.

---

## More Information

- `AGENTS.md` - AI agent instructions
- `.cursor/rules/docflow.mdc` - Complete workflow rules
- `knowledge/INDEX.md` - Knowledge base inventory

