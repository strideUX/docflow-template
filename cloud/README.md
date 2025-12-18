# DocFlow Cloud

> Version 3.0.0 - Linear Integration

DocFlow Cloud is a hybrid spec-driven development workflow where work items live in Linear and project understanding stays local.

---

## Quick Start

### 1. Prerequisites

- Linear account with API key
- Cursor IDE
- **Recommended:** Linear MCP installed in Cursor (see [MCP Setup](#mcp-setup))
- (Optional) Figma account + MCP for design integration

### 2. Install with Unified Installer

```bash
curl -sSL https://raw.githubusercontent.com/strideUX/docflow-template/main/docflow-install.sh | bash
```

Select "Cloud" when prompted. This creates your project with all files including `.env.example`.

### 3. Configure Environment

Open the `.env` file created in your project and add your API key:

```bash
# .env (secrets only - never commit!)
LINEAR_API_KEY=lin_api_your_key_here    # Required (only value you need!)
FIGMA_ACCESS_TOKEN=figd_xxx              # Optional
```

Get your API key from: **Linear → Settings → API → Personal API Keys**

Note: Team ID and Project ID are discovered automatically during setup and saved to `.docflow.json`.

### 4. Load Environment Variables

Choose one approach:

**Option A: direnv (Recommended)**
```bash
brew install direnv
echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc
source ~/.zshrc
echo "dotenv" > .envrc
direnv allow
```

**Option B: Shell Profile**
```bash
echo 'export LINEAR_API_KEY="lin_api_xxx"' >> ~/.zshrc
source ~/.zshrc
```

**Option C: Manual**
```bash
source .env && cursor .
```

### 5. Run Setup

```bash
cursor /path/to/your/project
# Then run: /docflow-setup
```

The setup command will:
- Validate your `.env` configuration
- Test the Linear connection
- Help you select team and project
- Gather project links (repo, Figma, docs)
- Help you fill project context
- Sync project description to Linear
- Create initial Linear issues

---

## MCP Setup

DocFlow Cloud works best with MCP (Model Context Protocol) servers installed in Cursor. MCPs provide cleaner API interactions and better handling of rich content.

### Installing Linear MCP (Recommended)

1. Open Cursor Settings → Features → MCP
2. Add the Linear MCP:
   - **Name:** `linear`
   - **Command:** `npx`
   - **Args:** `-y mcp-remote https://mcp.linear.app/mcp`
3. The MCP will use `LINEAR_API_KEY` from your environment

### Installing Figma MCP (Optional)

1. Open Cursor Settings → Features → MCP
2. Add the Figma MCP:
   - **Name:** `figma`
   - **Command:** `npx`
   - **Args:** `-y @anthropic/mcp-figma`
3. Set `FIGMA_ACCESS_TOKEN` in your environment

### Without MCPs

DocFlow Cloud still works without MCPs installed. The agent will fall back to direct API calls using curl and GraphQL. This is fully functional but:
- Slightly messier for complex markdown content
- Manual URL handling for attachments
- No design context extraction from Figma

**We recommend installing MCPs for the best experience.**

---

## What's Included

```
template/
├── .docflow/                    # FRAMEWORK (updatable)
│   ├── config.json              # Provider settings, paths, version
│   ├── version                  # For upgrade detection
│   └── templates/               # Issue templates with agent instructions
│       ├── feature.md
│       ├── bug.md
│       ├── chore.md
│       ├── idea.md
│       └── quick-capture.md     # Also used as Linear default
│
├── .cursor/
│   ├── rules/docflow.mdc       # Workflow rules
│   └── commands/               # Slash commands
│
├── {content-folder}/           # PROJECT CONTENT (default: "docflow")
│   ├── context/                # Project understanding
│   │   ├── overview.md         # Vision, goals, links
│   │   ├── stack.md            # Tech stack
│   │   └── standards.md        # Code conventions
│   │
│   ├── knowledge/              # Project knowledge
│   │   ├── INDEX.md            # Knowledge inventory
│   │   ├── decisions/          # ADRs
│   │   ├── features/           # Feature docs
│   │   ├── notes/              # Learnings
│   │   └── product/            # Personas, flows
│   │
│   └── README.md
│
├── .env.example                # Environment template (copy to .env)
├── .env                        # Your credentials (never commit!)
├── .gitignore                  # Ignores .env
└── AGENTS.md                   # AI agent instructions
```

**Note:** The content folder name is configurable during install (default: "docflow"). Set in `.docflow/config.json` as `paths.content`.

---

## Key Concepts

### What Lives Where

| Content | Location | Why |
|---------|----------|-----|
| **Specs** | Linear | Collaboration, visibility, workflow |
| **Config & Templates** | `.docflow/` | Framework files (updatable) |
| **Context & Knowledge** | `{content-folder}/` | Project-specific (yours) |
| **Rules & Commands** | `.cursor/` (synced) | No external dependency |

### Workflow

```
┌─────────────────────────────────────────────────────────────────────┐
│                            INTAKE                                    │
├─────────────────────────────────────────────────────────────────────┤
│  Quick Capture (with `triage` label) ──► /refine ──► BACKLOG       │
│  /capture (from IDE) ─────────────────────────────► BACKLOG        │
└─────────────────────────────────────────────────────────────────────┘
                                │
                                │ /refine (spec refinement)
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│  BACKLOG → READY → IMPLEMENTING ──→ REVIEW → QA → COMPLETE         │
│     │        │          │              │      │        │            │
│  Linear   Linear     Linear         Linear  Linear  Linear          │
│  Backlog   Todo    In Progress     In Review  QA     Done           │
│                         │              │      │                     │
│                         ▼              │      │                     │
│                     BLOCKED ◄──────────┘      │                     │
│                         │                     │                     │
│                      Linear                   │                     │
│                     Blocked                   │                     │
│                         │                     │                     │
│                         └──► (resume when unblocked)                │
└─────────────────────────────────────────────────────────────────────┘

Terminal States (via /close):
- Done      → Verified and shipped
- Archived  → Deferred to future  
- Canceled  → Won't do
- Duplicate → Already exists elsewhere
```

### Three-Agent Model

1. **PM Agent**: Captures, triages, refines, activates, reviews code, closes
2. **Implementation Agent**: Builds features (code + tests + docs)
3. **QE Agent**: Validates with user

### Team Collaboration Features

**Race Condition Prevention:**
- Before activating or implementing, agent checks if issue is assigned to someone else
- Warns before taking over work someone may already be doing

**Stale Work Detection:**
- Dashboard shows issues sitting too long in active states
- In Progress > 7 days, Review/QA > 3 days triggers warning

**Dependency Tracking:**
- Block command can link to blocking issues
- Dashboards surface issues with unresolved dependencies
- "Blocked by LIN-XXX (In Progress @sarah)"

---

## Commands

### Planning Commands
```
/start-session   - Begin work session, see queues + stale + dependencies
/capture         - Create new Linear issue (with template)
/refine          - Triage raw captures OR refine specs
/activate        - Assign and move to Ready (with race condition check)
/close           - Close work (Done/Archived/Canceled/Duplicate)
```

### Implementation Commands
```
/implement       - Pick up and build (with assignment check)
/block           - Move to Blocked state + link dependencies
/attach          - Add files to issue
```

### Review & QE Commands
```
/review          - Code review (post-implementation)
/validate        - Manual QE testing
```

### System Commands
```
/status          - Check state + queues + stale items + dependencies
/sync-project    - Sync context to Linear project
/docflow-update  - Sync rules from source repo
```

---

## Linear Setup

### Required Labels

| Label | Color | Purpose |
|-------|-------|---------|
| `triage` | Orange | Raw captures needing classification |
| `feature` | Green | New functionality |
| `bug` | Red | Defect reports |
| `chore` | Gray | Maintenance work |
| `idea` | Purple | Future exploration |

### Required Workflow States

| Linear State | DocFlow Status | Description |
|--------------|----------------|-------------|
| Backlog | BACKLOG | Ideas, raw captures |
| Todo | READY | Refined, ready to implement |
| In Progress | IMPLEMENTING | Being built |
| Blocked | BLOCKED | Waiting on feedback, dependency, or decision |
| In Review | REVIEW | Awaiting code review |
| QA | TESTING | Manual testing |
| Done | COMPLETE | Shipped |
| Archived | ARCHIVED | Deferred to future (not canceled) |
| Canceled | CANCELED | Decision made not to pursue |
| Duplicate | DUPLICATE | Already exists elsewhere |

### Issue Templates

Set **Quick Capture** as the default template in Linear. Copy from `.docflow/templates/quick-capture.md`.

Full templates (feature, bug, chore, idea) are in `.docflow/templates/` with agent instructions. Agents use these when creating/refining issues via `/capture` and `/refine`.

See **[LINEAR-SETUP-GUIDE.md](./LINEAR-SETUP-GUIDE.md)** for complete setup instructions.

---

## Acceptance Criteria Structure

All issues use a three-part acceptance criteria structure:

```markdown
## Acceptance Criteria

### Functionality
- [ ] [What the feature/fix must do]

### Tests
- [ ] Tests written for core functionality
- [ ] Edge cases covered
- [ ] N/A - No tests needed

### Documentation
- [ ] Code documented
- [ ] Knowledge base updated (if significant)
- [ ] Context files updated (if architecture changes)
- [ ] N/A - No documentation needed
```

This ensures implementation includes **code + tests + documentation**.

---

## Figma Integration

When Linear issues have Figma attachments:

1. Agent reads issue → sees Figma URL
2. Agent calls Figma MCP → gets design context
3. Agent implements with actual specs (colors, spacing, etc.)

This enables design-accurate implementations without manual spec copying.

**Requires:** Figma MCP installed in Cursor + `FIGMA_ACCESS_TOKEN` in environment.

---

## Link Capture

During development, when you share useful links (GitHub, Figma, docs), the agent will ask:

> "Would you like me to save this to your project's Related Links?"

If yes:
1. Link is added to `docflow/context/overview.md`
2. You can run `/sync-project` to update Linear

---

## Updating DocFlow

Rules and commands are synced from a central source repo:

```
/docflow-update

# Checks for updates, shows changelog, syncs if approved
```

This solves the "template distribution" problem - update once, sync everywhere.

---

## Migration from Local DocFlow

See [DOCFLOW-CLOUD-SPEC.md](./DOCFLOW-CLOUD-SPEC.md) for detailed migration guide.

Quick steps:
1. Set up Linear with matching structure
2. Configure `.docflow.json`
3. Migrate existing specs to Linear issues
4. Remove local `docflow/specs/`, `INDEX.md`, `ACTIVE.md`

---

## Documentation

- **[DOCFLOW-CLOUD-SPEC.md](./DOCFLOW-CLOUD-SPEC.md)** - Full specification
- **[LINEAR-SETUP-GUIDE.md](./LINEAR-SETUP-GUIDE.md)** - Linear structure guide
- **[template/.docflow/templates/](./template/.docflow/templates/)** - Issue templates with agent instructions
- **[template/AGENTS.md](./template/AGENTS.md)** - AI agent instructions
- **[template/.cursor/rules/docflow.mdc](./template/.cursor/rules/docflow.mdc)** - Complete workflow rules

---

## Future Providers

DocFlow Cloud is designed for provider abstraction:

| Provider | Status | Notes |
|----------|--------|-------|
| **Linear** | ✅ Active | First provider |
| **GitHub Issues** | 🔜 Planned | Good for OSS |
| **Jira** | 🔜 Planned | Enterprise demand |
| **Asana** | 📋 Backlog | If requested |

---

## Contributing

This is part of the DocFlow project. See the main README for contribution guidelines.

---

*DocFlow Cloud v3.0.0*
