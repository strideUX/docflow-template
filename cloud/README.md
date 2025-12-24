# DocFlow Cloud

> Version 4.5.0 - Workflow Consistency & AI Labor Estimates

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

# Optional: For Figma design integration
FIGMA_ACCESS_TOKEN=figd_your_token_here
```

Get from:
- Linear: **Linear → Settings → API → Personal API Keys**
- Figma: **Figma → Settings → Personal Access Tokens**

### 5. Run Setup

```bash
cursor /path/to/your/project
# Then run: /docflow-setup
```

### 6. Optional: Design System Setup

If you have a Figma design system with tokens:

```
/design-setup
```

This enables enhanced token enforcement for pixel-perfect implementations.

---

## MCP Setup

DocFlow Cloud works best with MCP servers installed in Cursor.

### Linear MCP (Recommended)

1. Cursor Settings → Features → MCP
2. Add:
   - **Name:** `linear`
   - **Command:** `npx`
   - **Args:** `-y mcp-remote https://mcp.linear.app/mcp`

### Figma MCP (Optional but Recommended)

- **Name:** `figma`
- **Command:** `npx`
- **Args:** `-y @anthropic/mcp-figma`

Required for design-to-code workflow. Get your access token from Figma settings.

---

## File Structure

```
your-project/
├── .docflow/                    ← DOCFLOW FRAMEWORK (updated via --update)
│   ├── config.json              ← Provider settings + design system config
│   ├── version                  ← Current version (4.5.0)
│   ├── rules/                   ← Canonical rule content
│   │   ├── always.md            ← NEW: Mandatory deterministic rules
│   │   ├── core.md
│   │   ├── pm-agent.md
│   │   ├── implementation-agent.md
│   │   ├── qe-agent.md
│   │   ├── linear-integration.md
│   │   ├── figma-integration.md
│   │   ├── designer-agent.md    ← Design system governance
│   │   └── session-awareness.md
│   ├── scripts/                 ← Shell scripts for atomic operations
│   │   ├── wrap-session.sh      ← NEW: Consistent session wrap
│   │   ├── transition-issue.sh  ← NEW: Status transitions + comments
│   │   └── activate-issue.sh    ← NEW: Issue activation flow
│   ├── skills/                  ← Portable agent skills
│   │   ├── ai-labor-estimate/   ← NEW: Token/cost estimation
│   │   ├── linear-workflow/
│   │   ├── figma-mcp/           ← 5-phase Figma workflow
│   │   ├── component-workflow/  ← Component patterns & testing
│   │   ├── spec-templates/
│   │   └── docflow-commands/
│   ├── templates/               ← Issue templates
│   │   ├── feature.md, bug.md, ...
│   │   ├── design-system/       ← NEW: Token mapping templates
│   │   └── scripts/             ← NEW: Validation script template
│   └── design-system/           ← Created by /design-setup (if enabled)
│       ├── token-mapping.md     ← Your project's Figma → code mappings
│       └── component-patterns.md
│
├── .cursor/
│   ├── commands/                ← 17 slash commands (includes /design-setup)
│   └── rules/                   ← Cursor rule folders
│
├── docflow/                     ← PROJECT CONTENT (preserved on update)
│   ├── context/
│   └── knowledge/
│
├── AGENTS.md                    ← Universal agent instructions
└── .env                         ← Secrets (never commit)
```

---

## Design System Integration (NEW in v4.4)

DocFlow now supports optional design system integration for pixel-perfect Figma implementations.

### Baseline Behavior (Always Active)

Even without design system configuration, you get:
- **5-phase Figma workflow** via `figma-mcp` skill
- **Screenshot-first** approach
- **Specification tables** for all implementations
- **Visual validation** checklist

### Enhanced Behavior (With Design System)

Run `/design-setup` to enable:
- Token enforcement for all Figma implementations
- Project-specific `token-mapping.md` with Figma → code translations
- Optional validation script to catch hardcoded values
- Stricter design consistency rules

### Setup Process

```
/design-setup
```

The command will ask:
1. **Figma design system file key** - If you have a Figma file with design tokens
2. **Framework** - Tailwind CSS (version 3 or 4), CSS Modules, etc.
3. **Asset configuration** - Where to store images/icons
4. **Validation** - Whether to add automated design system checks

### Configuration

After setup, `.docflow/config.json` includes:

```json
{
  "designSystem": {
    "enabled": true,
    "framework": "tailwind",
    "tailwindVersion": 4,
    "figmaFiles": {
      "designs": "abc123",      ← Your main design file
      "system": "xyz789"        ← Your design system file (tokens)
    },
    "assetPath": "public/images",
    "iconStrategy": "figma-only",
    "validation": {
      "script": "scripts/check-design-system.mjs",
      "preCommit": false
    }
  }
}
```

### Token Mapping

`.docflow/design-system/token-mapping.md` contains your project's translations:

```markdown
## Colors

| Figma Variable | Hex | Tailwind Class |
|----------------|-----|----------------|
| `--bg-primary` | #ffffff | `bg-bg-primary` |
| `--text-primary` | #111827 | `text-text-primary` |

## Spacing

| Figma (px) | Token | Class |
|------------|-------|-------|
| 4px | spacing-xs | `p-xs`, `gap-xs` |
| 8px | spacing-sm | `p-sm`, `gap-sm` |
```

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

### Four-Agent Model

1. **PM Agent**: Captures, triages, refines, activates, reviews code, closes
2. **Implementation Agent**: Builds features (code + tests + docs)
3. **QE Agent**: Validates with user
4. **Designer Agent**: Design system setup, token extraction, design governance

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
| `/design-setup` | **NEW:** Initialize design system integration |
| `/sync-project` | Push context to Linear project description |
| `/project-update` | Post project health update |

---

## Key Features

### v4.5: Workflow Consistency & AI Labor Estimates

- **AI Labor Estimates** — Token/cost estimation during `/refine`, validated on `/activate` and `/implement`
- **Deterministic Rules** — `always.md` with mandatory rules that never vary
- **Exact Comment Templates** — Standardized formats for status changes and project updates
- **Shell Scripts** — `wrap-session.sh`, `transition-issue.sh`, `activate-issue.sh` for atomic operations
- **Structured Checklists** — Numbered verification steps in all agent rules
- **Configurable Thresholds** — Warning and approval limits in `config.json`

### v4.4: Design System Integration

- **figma-mcp skill** — Complete 5-phase workflow for Figma implementations
- **component-workflow skill** — React patterns, checklists, testing templates
- **designer-agent** — Design system governance and token extraction
- **Token mapping** — Project-specific Figma → code translations
- **Validation script** — Optional automated design system enforcement
- **Optional enhancement** — Design system adds to baseline, doesn't replace it

### v4.3: Project Configuration

- Mandatory projectId for all issues
- Improved config reading patterns

### v4.2: Milestone Management

- Create milestones during `/docflow-setup`
- Assign issues to milestones during `/capture`
- Priority/dependency workflow
- Smart activation recommendations
- Mandatory assignment for In Progress
- Project updates on wrap

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

---

## Documentation

- **[DOCFLOW-CLOUD-SPEC.md](./DOCFLOW-CLOUD-SPEC.md)** - Full specification
- **[LINEAR-SETUP-GUIDE.md](./LINEAR-SETUP-GUIDE.md)** - Linear structure guide
- **[manifest.json](./manifest.json)** - File ownership manifest
- **[../migrations/](../migrations/)** - Version migration files

---

## What's New in v4.5

- **AI Labor Estimates** — Token and cost estimation for issues during `/refine`, validated on `/activate` and `/implement`
- **Deterministic Workflow Rules** — `always.md` with mandatory rules and exact comment templates
- **Shell Scripts for Consistency** — `wrap-session.sh`, `transition-issue.sh`, `activate-issue.sh` for atomic operations
- **Structured Agent Checklists** — Numbered steps with explicit verification in all agent rules
- **Configurable Thresholds** — Warning and approval limits for AI labor costs in `config.json`

### v4.4: Design System Integration

- **figma-mcp skill** — Complete 5-phase workflow for Figma implementations
- **component-workflow skill** — React patterns, checklists, testing templates
- **designer-agent** — Design system governance and token extraction
- **Token mapping** — Project-specific Figma → code translations
- **Validation script** — Optional automated design system enforcement
- **Optional enhancement** — Design system adds to baseline, doesn't replace it

---

*DocFlow Cloud v4.5.0*
