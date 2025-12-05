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

### Then Configure and Setup

**For Cloud (Linear) installations:**

1. Open the created `.env` file and add your API key:
   ```bash
   LINEAR_API_KEY=lin_api_your_key_here
   ```
   (Get from: Linear → Settings → API → Personal API Keys)

2. Load environment variables (choose one):
   - **direnv (recommended):** `echo "dotenv" > .envrc && direnv allow`
   - **Manual:** Add exports to `~/.zshrc`
   - **Per-session:** `source .env && cursor .`

3. Open in Cursor and run setup:
   ```bash
   cursor ~/Projects/your-project-name
   # Then run: /docflow-setup
   ```

**For Local installations:**

```bash
cursor ~/Projects/your-project-name
# Then run: /docflow-setup
```

The setup command will:
- Validate your configuration (Cloud: checks .env values)
- Fill out project context from a PRD or description
- Create initial work items in Linear or local specs
- Get your project ready for development

---

## Versions

### 📁 Local (v2.x)

The fully local DocFlow system. All specs, indexes, and workflow state stored in markdown files.

**Best for:**
- Solo developers
- Offline-first workflows
- Getting started with DocFlow

📖 **[Local Documentation](./local/DOCFLOW-GUIDE.md)**

---

### ☁️ Cloud (v3.x)

The hybrid DocFlow system with Linear integration. Specs live in Linear, project understanding stays in your codebase.

**Best for:**
- Teams needing collaboration
- Stakeholder visibility
- Cursor Background Agent workflows
- Design-integrated development (Figma MCP)

📖 **[Cloud Documentation](./cloud/README.md)**  
📋 **[Full Specification](./cloud/DOCFLOW-CLOUD-SPEC.md)**

---

## Comparison

| Feature | Local (v2) | Cloud (v3) |
|---------|------------|------------|
| Spec Storage | Markdown files | Linear issues |
| Team Visibility | Git only | Linear UI |
| Offline Work | ✅ Full | ✅ Context only |
| Collaboration | Via git | Real-time |
| AI Agent Integration | Good | Excellent |
| Figma Integration | Manual | Automatic (MCP) |
| Update Distribution | Manual copy | `/docflow-update` |
| Setup Complexity | Low | Medium |

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
BACKLOG → READY → IMPLEMENTING → REVIEW → TESTING → COMPLETE
```

### Cloud Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    DOCFLOW CLOUD SYSTEM                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  GitHub (DocFlow Source)                                        │
│  └── strideUX/docflow-template                                  │
│      ├── Releases (versioned)                                   │
│      └── Raw files (downloadable via /docflow-update)           │
│              │                                                  │
│              ▼                                                  │
│  Your Project Repository                                        │
│  ├── .cursor/                                                   │
│  │   ├── rules/docflow.mdc    ← Core workflow rules             │
│  │   └── commands/*.md        ← 12 slash commands               │
│  ├── .claude/commands/        ← Symlinks to .cursor/commands    │
│  ├── .warp/rules.md           ← Warp adapter                    │
│  ├── .github/copilot-*.md     ← GitHub Copilot adapter          │
│  ├── docflow/                                                   │
│  │   ├── context/             ← Project understanding (local)   │
│  │   └── knowledge/           ← Decisions, notes (local)        │
│  ├── .docflow.json            ← Config + Linear IDs             │
│  ├── AGENTS.md                ← Agent instructions              │
│  └── WARP.md                  ← Warp workflow guide             │
│              │                                                  │
│              │ Commands call Linear/Figma                       │
│              ▼                                                  │
│  External Services                                              │
│  ├── Linear ───────────────── Issues, workflow, comments        │
│  └── Figma ────────────────── Design context, assets            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Separation of Concerns

| Layer | What It Contains | Where It Lives |
|-------|------------------|----------------|
| **Understanding** | Context, stack, standards, decisions | Always local (versioned with code) |
| **Doing** | Specs, tasks, status, comments | Local (v2) or Linear (v3) |
| **Rules** | Commands, agent instructions | Local (synced from source repo in v3) |

---

## Commands

Both versions support the same commands:

| Command | Description | Agent |
|---------|-------------|-------|
| `/start-session` | Begin work session, load context | Any |
| `/wrap-session` | End session, save progress | Any |
| `/capture` | Create new spec/issue | PM |
| `/review` | Review backlog, prioritize | PM |
| `/activate` | Move spec to ready | PM |
| `/implement` | Work on active spec | Implementation |
| `/validate` | Test and verify | QE |
| `/close` | Complete spec | PM |
| `/block` | Mark spec blocked | Any |
| `/status` | Show current state | Any |
| `/docflow-setup` | Initial project setup | System |
| `/docflow-update` | Update DocFlow rules | System |

---

## Cloud Version Features

### MCP Setup (Recommended)

DocFlow Cloud works best with MCP servers installed in Cursor. Without MCPs, the agent falls back to direct API calls.

**Installing Linear MCP:**
1. Open Cursor Settings → Features → MCP
2. Add new MCP:
   - Name: `linear`
   - Command: `npx`
   - Args: `-y mcp-remote https://mcp.linear.app/mcp`

**Installing Figma MCP (Optional):**
1. Add new MCP:
   - Name: `figma`
   - Command: `npx`
   - Args: `-y @anthropic/mcp-figma`

See [cloud/README.md](./cloud/README.md#mcp-setup) for detailed setup instructions.

### Linear Integration

The cloud version integrates with **Linear** for spec management (MCP preferred, curl fallback):

- **Issues** = Specs (features, bugs, chores, ideas)
- **Projects** = Features or user stories
- **Initiatives** = Larger scope groupings
- **Labels** = Spec types, priorities
- **Workflow States** = DocFlow status progression
- **Comments** = Decision logs, implementation notes

### Design Integration

The cloud version can integrate with **Figma** for design context (requires Figma MCP):

- Access Figma specs directly from Linear issues
- Get colors, spacing, typography
- View design assets without leaving the agent
- Screenshots and design references in issues

### Automatic Updates

Keep DocFlow current across all projects:

```bash
# In any project using DocFlow Cloud
/docflow-update

# Agent checks GitHub for new version
# Downloads and applies updates via curl
# No MCP hosting required
```

### Provider Abstraction

Cloud version is architected for multiple PM tools:

```typescript
// Future support planned
interface PMProvider {
  createIssue(spec: Spec): Promise<Issue>;
  updateIssue(id: string, updates: Partial<Spec>): Promise<Issue>;
  getIssue(id: string): Promise<Issue>;
  queryIssues(filter: Filter): Promise<Issue[]>;
}

// Current: Linear
// Planned: Jira, Asana, GitHub Issues
```

---

## Repository Structure

```
docflow-template/
├── README.md               # This file
├── docflow-install.sh      # Unified installer (choose local or cloud)
│
├── local/                  # Local version (v2.x)
│   ├── DOCFLOW-GUIDE.md    # Complete local documentation
│   ├── docflow-install.sh  # Local-only installer
│   ├── README.md           # Local quick start
│   ├── releases/           # Version history
│   └── template/           # Local template files
│       ├── AGENTS.md
│       ├── WARP.md
│       └── docflow/
│           ├── ACTIVE.md
│           ├── INDEX.md
│           ├── context/
│           ├── knowledge/
│           └── specs/
│               ├── active/
│               ├── backlog/
│               ├── complete/
│               └── templates/
│
└── cloud/                  # Cloud version (v3.x)
    ├── DOCFLOW-CLOUD-SPEC.md   # Full 10-section specification
    ├── README.md               # Cloud quick start
    └── template/               # Cloud template files
        ├── .docflow.json       # Config + Linear IDs
        ├── AGENTS.md
        ├── WARP.md
        ├── .cursor/
        │   ├── rules/docflow.mdc
        │   ├── commands/*.md   # 12 slash commands
        │   └── mcp.json        # Linear + Figma
        ├── .claude/commands/   # Symlinks
        ├── .warp/rules.md
        ├── .github/copilot-instructions.md
        └── docflow/
            ├── context/        # overview, stack, standards
            └── knowledge/      # decisions, notes, product
```

---

## Getting Started

### Option 1: Use the Unified Installer (Recommended)

```bash
curl -sSL https://raw.githubusercontent.com/strideUX/docflow-template/main/docflow-install.sh | bash
```

The installer will guide you through:

1. **Project name** - Enter your project name (auto-converts to folder name)
2. **Location** - Where to create the project (default: `~/Projects`)
3. **Type** - Choose Local or Cloud (Linear)
4. **Linear config** - If Cloud, optionally configure Linear API key and team ID

Then it creates your project folder, downloads all files, and initializes git.

**After installation, open in Cursor and run:**
```
/docflow-setup
```

The agent will help you complete configuration and create initial work items.

### Option 2: Add to Existing Project

If you already have a project and want to add DocFlow:

```bash
cd /path/to/your/project
curl -sSL https://github.com/strideUX/docflow-template/archive/main.tar.gz | tar -xz --strip-components=3 docflow-template-main/cloud/template
```

Then configure `.docflow.json` with your Linear team ID and run `/docflow-setup`.

---

## Migration

### Local → Cloud

1. Install cloud template alongside existing files
2. Run `/docflow-setup` to configure Linear
3. Agent will migrate existing specs to Linear issues
4. Context/knowledge stays local (already compatible)
5. Remove local `docflow/specs/` and `docflow/INDEX.md`, `docflow/ACTIVE.md`

See [DOCFLOW-CLOUD-SPEC.md](./cloud/DOCFLOW-CLOUD-SPEC.md) Section 8 for detailed migration guide.

### Cloud → Local

1. Export Linear issues (comments preserved in markdown)
2. Install local template
3. Copy context/knowledge (already compatible)
4. Place exported specs in `docflow/specs/backlog/`

---

## Environment Variables

### Cloud Version

The cloud version uses a `.env` file for secrets and `.docflow.json` for config:

**`.env`** (never commit - secrets only):
```bash
LINEAR_API_KEY=lin_api_xxx         # Required (only value you need!)
FIGMA_ACCESS_TOKEN=figd_xxx        # Optional
```

**`.docflow.json`** (OK to commit - auto-discovered by setup):
```json
{
  "provider": {
    "type": "linear",
    "teamId": "your-team-id",       // Set by /docflow-setup
    "projectId": "your-project-id"  // Set by /docflow-setup
  }
}
```

### Loading the API Key

The Linear MCP needs the API key in your shell environment. Choose one approach:

**Option A: direnv (Recommended)**
```bash
# Install direnv
brew install direnv

# Add to ~/.zshrc
echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc
source ~/.zshrc

# In your project
echo "dotenv" > .envrc
direnv allow
# → API key auto-loads when you cd into the project!
```

**Option B: Shell Profile**
```bash
# Add to ~/.zshrc or ~/.bashrc
echo 'export LINEAR_API_KEY="lin_api_xxx"' >> ~/.zshrc
source ~/.zshrc
```

**Option C: Manual (per session)**
```bash
# Before opening Cursor
source .env && cursor .
```

---

## Supported AI Tools

| Tool | Local | Cloud | Notes |
|------|-------|-------|-------|
| **Cursor** | ✅ | ✅ | Full support, Background Agent integration |
| **Claude Code** | ✅ | ✅ | Via .claude/commands/ |
| **Warp AI** | ✅ | ✅ | Via WARP.md and .warp/rules.md |
| **GitHub Copilot** | ✅ | ✅ | Via .github/copilot-instructions.md |
| **Other** | ✅ | ✅ | Via AGENTS.md |

---

## Contributing

Contributions welcome! Please:

1. Decide which version you're improving (local or cloud)
2. Follow existing patterns and conventions
3. Update documentation with changes
4. Test with actual AI agents
5. If changing cloud rules/commands, bump version in template

### Development

```bash
# Clone the repo
git clone https://github.com/strideUX/docflow-template.git
cd docflow-template

# Test the installer
./docflow-install.sh
# Follow prompts to create a test project

# Or test by copying templates directly
cp -r cloud/template/* /path/to/test-project/
```

---

## Roadmap

### v3.x (Cloud - Current)
- [x] Linear MCP integration
- [x] Figma MCP integration
- [x] Automatic updates via `/docflow-update`
- [x] Multi-platform adapter support
- [ ] Jira provider
- [ ] Asana provider
- [ ] GitHub Issues provider

### v2.x (Local - Stable)
- [x] Full local workflow
- [x] Three-agent model
- [x] All spec types
- [x] Multi-platform adapters

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
