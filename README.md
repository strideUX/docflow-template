# DocFlow

> Spec-driven development workflow for AI-assisted coding

DocFlow is a structured workflow system that helps AI agents and developers collaborate effectively through detailed specifications and a three-agent orchestration model.

---

## Quick Start

### Create a New Project

```bash
curl -sSL https://raw.githubusercontent.com/strideUX/docflow-template/main/docflow-install.sh | bash
```

The installer will prompt you for:
- **Project name** → Creates folder automatically
- **Location** → Where to save (default: `~/Projects`)
- **Local or Cloud** → Choose your workflow type

### Update an Existing Project

```bash
# Update current directory
curl -sSL https://raw.githubusercontent.com/strideUX/docflow-template/main/docflow-install.sh | bash -s -- --update

# Update specific project
curl -sSL https://raw.githubusercontent.com/strideUX/docflow-template/main/docflow-install.sh | bash -s -- --update --path /path/to/project
```

The update command:
- Detects your current DocFlow version
- Downloads latest manifest from GitHub
- Updates all DocFlow-owned files
- Preserves your project-specific config (Linear IDs, content folder)
- Cleans up deprecated files from previous versions

---

## After Installation

**For Cloud (Linear) installations:**

1. Add your Linear API key to `.env`:
   ```bash
   LINEAR_API_KEY=lin_api_your_key_here
   ```
   (Get from: Linear → Settings → API → Personal API Keys)

2. Open in Cursor and run setup:
   ```bash
   cursor ~/Projects/your-project-name
   # Then run: /docflow-setup
   ```

**For Local installations:**

```bash
cursor ~/Projects/your-project-name
# Then run: /docflow-setup
```

---

## Versions

### ☁️ Cloud (v4.x) - Current

The hybrid DocFlow system with Linear integration. Specs live in Linear, project understanding stays in your codebase.

**Best for:**
- Teams needing collaboration
- Stakeholder visibility
- Cursor Background Agent workflows
- Design-integrated development (Figma MCP)

📖 **[Cloud Documentation](./cloud/README.md)**  
📋 **[Full Specification](./cloud/DOCFLOW-CLOUD-SPEC.md)**

### 📁 Local (v2.x)

The fully local DocFlow system. All specs, indexes, and workflow state stored in markdown files.

**Best for:**
- Solo developers
- Offline-first workflows
- Getting started with DocFlow

📖 **[Local Documentation](./local/DOCFLOW-GUIDE.md)**

---

## Comparison

| Feature | Local (v2) | Cloud (v4) |
|---------|------------|------------|
| Spec Storage | Markdown files | Linear issues |
| Team Visibility | Git only | Linear UI |
| Offline Work | ✅ Full | ✅ Context only |
| Collaboration | Via git | Real-time |
| AI Agent Integration | Good | Excellent |
| Figma Integration | Manual | Automatic (MCP) |
| Update Distribution | Manual copy | `--update` flag |
| Setup Complexity | Low | Medium |

---

## Update System

DocFlow uses a **manifest-based update system** to keep projects current while preserving your customizations.

### How It Works

```
┌─────────────────────────────────────────────────────────────┐
│  GitHub (docflow-template)                                   │
│  ├── cloud/manifest.json      ← Defines what DocFlow owns   │
│  ├── migrations/*.json        ← Version change history      │
│  └── cloud/template/*         ← Latest template files       │
└─────────────────────────────────────────────────────────────┘
                         │
                         │ --update
                         ▼
┌─────────────────────────────────────────────────────────────┐
│  Your Project                                                │
│  ├── .docflow/version         ← Current version (4.2.0)     │
│  ├── .docflow/config.json     ← YOUR Linear IDs (preserved) │
│  ├── .docflow/rules/*         ← Updated from template       │
│  ├── .cursor/commands/*       ← Updated from template       │
│  ├── .cursor/rules/*          ← Updated from template       │
│  └── docflow/context/*        ← YOUR content (preserved)    │
└─────────────────────────────────────────────────────────────┘
```

### File Ownership

| Category | What Happens on Update |
|----------|------------------------|
| **Owned Directories** | Replaced entirely (`.docflow/rules/`, `.docflow/scripts/`, etc.) |
| **Owned Files** | Overwritten (commands, adapters, AGENTS.md) |
| **Preserved Files** | Never touched (`.env`, `docflow/context/*`, `docflow/knowledge/*`) |
| **Merged Files** | Config values preserved (`.docflow/config.json` keeps your Linear IDs) |

### User Custom Files

**You can safely add your own rules and commands.** The update only touches DocFlow-owned files.

```
.cursor/rules/
  ├── docflow-core/       ← DocFlow owned (updated)
  ├── pm-agent/           ← DocFlow owned (updated)
  ├── my-custom-rule/     ← YOUR rule (preserved)
  └── project-specific/   ← YOUR rule (preserved)

.cursor/commands/
  ├── activate.md         ← DocFlow owned (updated)
  ├── capture.md          ← DocFlow owned (updated)
  └── my-command.md       ← YOUR command (preserved)
```

### Migration Files

Each version has a migration file documenting changes:

```
migrations/
  ├── 4.0.0.json          ← Baseline (restructure from v3)
  ├── 4.1.0.json          ← Priority/dependency workflow
  └── 4.2.0.json          ← Milestone management
```

These help the installer know what files to clean up from previous versions.

---

## Architecture

### Three-Agent Model

```
PM/Planning Agent     Implementation Agent     QE/Validation Agent
       │                      │                       │
       │  Plan & Activate     │  Build & Complete     │  Test & Approve
       │──────────────────────▶──────────────────────▶│
       │                      │                       │
       │◀─────────────────────│◀──────────────────────│
       │   Review & Close     │   Return if issues    │
```

### Workflow States

```
BACKLOG → TODO → IN PROGRESS → IN REVIEW → QA → DONE
```

### Cloud File Structure (v4.x)

```
your-project/
├── .docflow/                    ← DocFlow framework
│   ├── config.json              ← Linear IDs, settings
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
│   ├── skills/                  ← Portable agent skills
│   └── templates/               ← Issue templates
│
├── .cursor/
│   ├── commands/                ← 16 slash commands
│   │   ├── activate.md
│   │   ├── capture.md
│   │   ├── docflow-setup.md
│   │   └── ...
│   └── rules/                   ← Cursor rule folders (pointers)
│       ├── docflow-core/RULE.md
│       ├── pm-agent/RULE.md
│       └── ...
│
├── docflow/                     ← Project content (preserved)
│   ├── context/
│   │   ├── overview.md          ← Project vision, goals
│   │   ├── stack.md             ← Technology choices
│   │   └── standards.md         ← Coding conventions
│   └── knowledge/               ← Decisions, notes, learnings
│
├── .claude/rules.md             ← Claude adapter (pointer)
├── .warp/rules.md               ← Warp adapter (pointer)
├── .github/copilot-instructions.md
├── AGENTS.md                    ← Universal agent instructions
└── .env                         ← Secrets (never committed)
```

---

## Commands

| Command | Description | Agent |
|---------|-------------|-------|
| `/start-session` | Begin work session, load context | Any |
| `/wrap-session` | End session, post project update | Any |
| `/capture` | Create new spec/issue | PM |
| `/refine` | Triage or improve backlog items | PM |
| `/activate` | Assign and start work (smart recommendations) | PM |
| `/implement` | Work on active spec | Implementation |
| `/review` | Code review | PM |
| `/validate` | Test and verify | QE |
| `/close` | Complete spec | PM |
| `/block` | Mark spec blocked | Any |
| `/status` | Show current state | Any |
| `/docflow-setup` | Initial project setup | System |
| `/sync-project` | Push context to Linear | PM |
| `/project-update` | Post project health update | PM |

---

## MCP Setup (Recommended)

DocFlow Cloud works best with MCP servers installed in Cursor.

**Linear MCP:**
1. Cursor Settings → Features → MCP
2. Add new MCP:
   - Name: `linear`
   - Command: `npx`
   - Args: `-y mcp-remote https://mcp.linear.app/mcp`

**Figma MCP (Optional):**
- Name: `figma`
- Command: `npx`
- Args: `-y @anthropic/mcp-figma`

---

## Repository Structure

```
docflow-template/
├── README.md                    # This file
├── docflow-install.sh           # Unified installer
│
├── cloud/                       # Cloud version (v4.x)
│   ├── manifest.json            # File ownership manifest
│   ├── README.md                # Cloud documentation
│   ├── DOCFLOW-CLOUD-SPEC.md    # Full specification
│   └── template/                # Template files
│
├── local/                       # Local version (v2.x)
│   ├── README.md
│   ├── DOCFLOW-GUIDE.md
│   └── template/
│
└── migrations/                  # Version migration files
    ├── 4.0.0.json               # Baseline (restructure)
    ├── 4.1.0.json               # Priority/dependency workflow
    └── 4.2.0.json               # Milestone management
```

---

## What's New in v4.2

- **Milestone Management** — Organize work into project phases during setup
- **Milestone Assignment** — Assign issues to milestones during `/capture`
- **Priority/Dependency Workflow** — Set priorities and blocking relationships during setup and refine
- **Smart Activation** — `/activate` recommends what to work on next based on priority and blockers
- **Mandatory Assignment** — Issues must be assigned before moving to In Progress
- **Project Updates on Wrap** — `/wrap-session` posts progress to Linear project updates
- **Manifest-Based Updates** — Smart updates that preserve your customizations

---

## Roadmap

### v4.x (Cloud - Current)
- [x] Folder-based rules structure
- [x] Agent skills (agentskills.io format)
- [x] Manifest-based updates
- [x] Priority/dependency workflow
- [x] Linear project updates
- [x] Milestone management
- [ ] Jira provider
- [ ] GitHub Issues provider

### v2.x (Local - Stable)
- [x] Full local workflow
- [x] Three-agent model
- [x] All spec types

---

## Support

- **Issues:** [GitHub Issues](https://github.com/strideUX/docflow-template/issues)
- **Discussions:** [GitHub Discussions](https://github.com/strideUX/docflow-template/discussions)

---

## License

MIT License - see [LICENSE](./LICENSE) for details.

---

<p align="center">
  <strong>DocFlow</strong> — Making AI-assisted development structured and effective
</p>
