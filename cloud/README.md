# DocFlow Cloud

> Version 4.2.0 - Linear Integration with Milestones & Manifest-Based Updates

DocFlow Cloud is a hybrid spec-driven development workflow where work items live in Linear and project understanding stays local.

---

## Quick Start

### 1. Prerequisites

- Linear account with API key
- Cursor IDE
- **Recommended:** Linear MCP installed in Cursor (see [MCP Setup](#mcp-setup))
- (Optional) Figma account + MCP for design integration

### 2. Install

```bash
curl -sSL https://raw.githubusercontent.com/strideUX/docflow-template/main/docflow-install.sh | bash
```

Select "Cloud" when prompted.

### 3. Update Existing Project

```bash
# Update current directory
curl -sSL https://raw.githubusercontent.com/strideUX/docflow-template/main/docflow-install.sh | bash -s -- --update

# Update specific project
curl -sSL https://raw.githubusercontent.com/strideUX/docflow-template/main/docflow-install.sh | bash -s -- --update --path /path/to/project
```

### 4. Configure Environment

Add your API key to `.env`:

```bash
LINEAR_API_KEY=lin_api_your_key_here
```

Get from: **Linear → Settings → API → Personal API Keys**

### 5. Run Setup

```bash
cursor /path/to/your/project
# Then run: /docflow-setup
```

---

## MCP Setup

DocFlow Cloud works best with MCP servers installed in Cursor.

### Linear MCP (Recommended)

1. Cursor Settings → Features → MCP
2. Add:
   - **Name:** `linear`
   - **Command:** `npx`
   - **Args:** `-y mcp-remote https://mcp.linear.app/mcp`

### Figma MCP (Optional)

- **Name:** `figma`
- **Command:** `npx`
- **Args:** `-y @anthropic/mcp-figma`

---

## File Structure

```
your-project/
├── .docflow/                    ← DOCFLOW FRAMEWORK (updated via --update)
│   ├── config.json              ← Provider settings (YOUR Linear IDs preserved)
│   ├── version                  ← Current version (4.2.0)
│   ├── rules/                   ← Canonical rule content
│   │   ├── core.md
│   │   ├── pm-agent.md
│   │   ├── implementation-agent.md
│   │   ├── qe-agent.md
│   │   ├── linear-integration.md
│   │   ├── figma-integration.md
│   │   └── session-awareness.md
│   ├── scripts/                 ← Shell scripts for efficiency
│   │   ├── status-summary.sh
│   │   ├── session-context.sh
│   │   └── stale-check.sh
│   ├── skills/                  ← Portable agent skills
│   │   ├── linear-workflow/SKILL.md
│   │   ├── spec-templates/SKILL.md
│   │   └── docflow-commands/SKILL.md
│   └── templates/               ← Issue templates
│       ├── feature.md
│       ├── bug.md
│       ├── chore.md
│       ├── idea.md
│       └── quick-capture.md
│
├── .cursor/
│   ├── commands/                ← 16 slash commands
│   └── rules/                   ← Cursor rule folders (pointers to .docflow/rules/)
│       ├── docflow-core/RULE.md
│       ├── pm-agent/RULE.md
│       └── ...
│
├── docflow/                     ← PROJECT CONTENT (preserved on update)
│   ├── context/
│   │   ├── overview.md          ← Project vision, goals
│   │   ├── stack.md             ← Technology choices
│   │   └── standards.md         ← Coding conventions
│   └── knowledge/               ← Decisions, notes, learnings
│
├── .claude/rules.md             ← Claude adapter
├── .warp/rules.md               ← Warp adapter
├── .github/copilot-instructions.md
├── AGENTS.md                    ← Universal agent instructions
└── .env                         ← Secrets (never commit)
```

---

## Update System

DocFlow uses a **manifest-based update system** that knows exactly which files it owns.

### Manifest File

The `manifest.json` defines file ownership:

```json
{
  "version": "4.2.0",
  "ownership": {
    "owned_directories": [".docflow/rules", ".docflow/scripts", ...],
    "owned_files": [".cursor/commands/activate.md", "AGENTS.md", ...],
    "preserved_files": ["docflow/context/*", "docflow/knowledge/*", ".env"],
    "merged_files": {
      ".docflow/config.json": {
        "preserve_keys": ["provider.teamId", "provider.projectId"]
      }
    }
  }
}
```

### What Happens on Update

| File Type | Action |
|-----------|--------|
| **Owned directories** | Replaced entirely |
| **Owned files** | Overwritten |
| **Preserved files** | Never touched |
| **Merged files** | Updated but preserves specified keys |

### Your Custom Files Are Safe

```
.cursor/rules/
  ├── docflow-core/       ← DocFlow (updated)
  ├── pm-agent/           ← DocFlow (updated)
  ├── my-custom-rule/     ← YOURS (preserved)
  └── project-specific/   ← YOURS (preserved)
```

### Migration Files

Version changes are tracked in `migrations/`:

```
migrations/
  ├── 4.0.0.json          ← Restructure from v3
  ├── 4.1.0.json          ← Priority/dependency workflow
  └── 4.2.0.json          ← Milestone management
```

These tell the installer what deprecated files to clean up.

---

## Workflow

```
INTAKE
  ├── Quick Capture (Linear UI) + triage label
  │         │
  │         │ /refine (triage path)
  │         ▼
  └── BACKLOG (templated, prioritized)
              │
              │ /refine (refinement path)
              ▼
          TODO (refined, dependencies set)
              │
              │ /activate (smart recommend or specific)
              ▼
        IN PROGRESS (assigned - REQUIRED)
              │
              │ /implement → /review → /validate
              ▼
           DONE

Terminal States: Archived, Canceled, Duplicate
```

### Three-Agent Model

1. **PM Agent**: Captures, triages, refines, activates, reviews code, closes
2. **Implementation Agent**: Builds features (code + tests + docs)
3. **QE Agent**: Validates with user

---

## Commands

### Planning
| Command | Description |
|---------|-------------|
| `/capture` | Create new Linear issue |
| `/refine` | Triage raw captures OR refine specs, set priority/dependencies |
| `/activate` | Smart "what's next" recommendation, assign and start |
| `/close` | Complete (Done/Archived/Canceled/Duplicate) |

### Implementation
| Command | Description |
|---------|-------------|
| `/implement` | Build the feature (code + tests + docs) |
| `/block` | Move to Blocked state |
| `/attach` | Add files to issue |

### Review & QE
| Command | Description |
|---------|-------------|
| `/review` | Code review |
| `/validate` | Manual QE testing |

### Session
| Command | Description |
|---------|-------------|
| `/start-session` | Begin work, load context |
| `/wrap-session` | End session, POST project update to Linear |
| `/status` | Show current state |

### System
| Command | Description |
|---------|-------------|
| `/docflow-setup` | Initial project setup |
| `/sync-project` | Push context to Linear project description |
| `/project-update` | Post project health update |

---

## Key Features (v4.2)

### Milestone Management

Organize work into project phases:
- Create milestones during `/docflow-setup` (Phase 3)
- Assign issues to milestones during `/capture`
- Query and create via Linear GraphQL API

```markdown
Example phases:
- Phase 1: Foundation (infrastructure, auth)
- Phase 2: Core Features (main functionality)
- Phase 3: Polish (UI, performance, docs)
```

### Priority & Dependency Workflow

During `/docflow-setup` and `/refine`:
- Set priorities (Urgent → High → Medium → Low)
- Create blocking relationships between issues
- Suggested implementation order

### Smart Activation

When you run `/activate` without specifying an issue:
- Queries all Todo/Backlog issues
- Filters out blocked items
- Ranks by priority
- Recommends what to work on next

### Mandatory Assignment

Issues **must** be assigned before moving to In Progress. The agent:
1. Gets current Linear user via `get_viewer()`
2. Assigns the issue
3. Verifies assignment succeeded
4. Only then moves to In Progress

### Project Updates on Wrap

`/wrap-session` now **requires** posting a project update to Linear:
- Summarizes what was completed
- Notes what's in progress
- Lists blockers
- Sets health status (onTrack/atRisk/offTrack)

---

## Linear Setup

### Required Labels

| Label | Purpose |
|-------|---------|
| `triage` | Raw captures needing classification |
| `feature` | New functionality |
| `bug` | Defect reports |
| `chore` | Maintenance work |
| `idea` | Future exploration |

### Workflow States

| Linear State | DocFlow Status |
|--------------|----------------|
| Backlog | BACKLOG |
| Todo | READY |
| In Progress | IMPLEMENTING |
| Blocked | BLOCKED |
| In Review | REVIEW |
| QA | TESTING |
| Done | COMPLETE |
| Archived | ARCHIVED |
| Canceled | CANCELED |
| Duplicate | DUPLICATE |

### Quick Capture Template

Set as default template in Linear. Copy from `.docflow/templates/quick-capture.md`.

Auto-apply `triage` label to new issues created in Linear UI.

---

## Documentation

- **[DOCFLOW-CLOUD-SPEC.md](./DOCFLOW-CLOUD-SPEC.md)** - Full specification
- **[LINEAR-SETUP-GUIDE.md](./LINEAR-SETUP-GUIDE.md)** - Linear structure guide
- **[manifest.json](./manifest.json)** - File ownership manifest
- **[../migrations/](../migrations/)** - Version migration files

---

## What's New in v4.2

- **Milestone Management** — Organize work into project phases
- **Create Milestones in Setup** — Phase 3 guides milestone creation
- **Milestone Assignment** — Assign issues during `/capture`
- **Priority/Dependency Workflow** — Set during setup and refine
- **Smart Activation** — Recommends what to work on based on priority + blockers
- **Mandatory Assignment** — Can't be In Progress without assignee
- **Project Updates on Wrap** — Required on `/wrap-session`
- **Manifest-Based Updates** — Smart updates preserve your customizations

---

*DocFlow Cloud v4.2.0*
