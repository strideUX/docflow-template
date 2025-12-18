# DocFlow Cloud Core Rules

> Version: 4.0.0 | Updated: 2024-12
> These are essential rules loaded on every interaction.

## Overview

DocFlow Cloud is a hybrid spec-driven workflow:
- **Workflow state (specs)** → Lives in Linear
- **Understanding (context/knowledge)** → Lives locally in git
- **System config & templates** → `.docflow/` folder
- **System rules** → `.docflow/rules/` (source of truth)

---

## Configuration

**Always read `.docflow/config.json` first to get:**
- `paths.content` - Where context/knowledge lives (default: "docflow")
- `provider.teamId` - Linear team ID
- `provider.projectId` - Linear project ID
- `statusMapping` - Maps DocFlow states to Linear states

**Dynamic paths based on config:**
```
{paths.content}/context/     → e.g., docflow/context/
{paths.content}/knowledge/   → e.g., docflow/knowledge/
```

---

## Directory Structure

```
.docflow/                    # Framework (updatable)
├── config.json              # Provider settings, paths
├── version                  # Version for upgrades
├── templates/               # Issue templates
├── rules/                   # Rule content (source of truth)
├── scripts/                 # Automation scripts
└── skills/                  # Portable Agent Skills

{paths.content}/             # Project content (default: "docflow")
├── context/                 # Project understanding (LOCAL)
│   ├── overview.md          # Vision and goals
│   ├── stack.md             # Tech stack and patterns
│   └── standards.md         # Code conventions
└── knowledge/               # Project knowledge (LOCAL)
    ├── INDEX.md             # Knowledge inventory
    ├── decisions/           # ADRs
    ├── features/            # Complex feature docs
    └── notes/               # Technical notes
```

---

## Agent Roles

| Agent | Purpose | Commands |
|-------|---------|----------|
| **PM/Planning** | Orchestration, planning, reviewing, closing | capture, refine, activate, review, close, project-update, sync-project |
| **Implementation** | Building features, fixing bugs | implement, block, attach |
| **QE/Validation** | Testing with user | validate |

**Load role-specific rules from `.docflow/rules/` when needed.**

---

## Critical Rules

### Never Create Local Spec Files
- ❌ NO files in `{paths.content}/specs/`
- ❌ NO `INDEX.md` or `ACTIVE.md` files
- ✅ ALL specs live in Linear as issues

### Context Stays Local
- ✅ `{paths.content}/context/` always in git
- ✅ `{paths.content}/knowledge/` always in git

### Framework Stays in .docflow/
- ✅ `.docflow/config.json` for configuration
- ✅ `.docflow/templates/` for issue templates
- ✅ `.docflow/rules/` for workflow rules

### Update Linear, Not Local Files
- Status changes → Update Linear issue state
- Progress notes → Add Linear comment
- Decisions → Add dated Linear comment
- Blockers → Add Linear comment and tag

### Search Before Creating
- Use codebase_search to find existing code
- Check `{paths.content}/knowledge/` for patterns
- Avoid duplicating functionality

---

## Loading Additional Rules

Load these from `.docflow/rules/` based on context:
- **pm-agent.md** - When planning, capturing, reviewing
- **implementation-agent.md** - When building features
- **qe-agent.md** - When testing/validating
- **linear-integration.md** - When working with Linear API
- **figma-integration.md** - When Figma designs involved
- **session-awareness.md** - For session management

---

*For complete rules, see `.docflow/rules/` directory.*
