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
- Help you fill project context
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
├── .cursor/
│   ├── rules/docflow.mdc    # Workflow rules
│   └── commands/            # Slash commands
│
├── docflow/
│   ├── context/             # Project understanding
│   │   ├── overview.md      # Vision, goals
│   │   ├── stack.md         # Tech stack
│   │   └── standards.md     # Code conventions
│   │
│   ├── knowledge/           # Project knowledge
│   │   ├── INDEX.md         # Knowledge inventory
│   │   ├── decisions/       # ADRs
│   │   ├── features/        # Feature docs
│   │   ├── notes/           # Learnings
│   │   └── product/         # Personas, flows
│   │
│   └── README.md
│
├── .env.example             # Environment template (copy to .env)
├── .env                     # Your credentials (never commit!)
├── .docflow.json            # Workflow configuration
├── .gitignore               # Ignores .env
└── AGENTS.md                # AI agent instructions
```

---

## Key Concepts

### What Lives Where

| Content | Location | Why |
|---------|----------|-----|
| **Specs** | Linear | Collaboration, visibility, workflow |
| **Context** | Local | Fast access, version-controlled |
| **Knowledge** | Local | Persists with code |
| **Rules** | Local (synced) | No external dependency |

### Workflow

```
BACKLOG → READY → IMPLEMENTING → REVIEW → TESTING → COMPLETE
   │         │          │           │         │         │
 Linear   Linear     Linear      Linear    Linear    Linear
```

### Three-Agent Model

1. **PM Agent**: Plans, activates, reviews, closes
2. **Implementation Agent**: Builds features
3. **QE Agent**: Validates with user

---

## Commands

```
/start-session   - Begin work session
/capture         - Create new Linear issue
/implement       - Pick up and build issue
/validate        - Test implementation
/close           - Archive completed work
/status          - Check current state
/docflow-update  - Sync rules from source
```

---

## Linear Setup

### Required Linear Structure

1. **Team**: Create or use existing team
2. **Workflow States**: Configure to match DocFlow statuses
3. **Labels**: Create labels for spec types (feature, bug, chore, idea)
4. **Issue Templates**: (Optional) Create templates matching DocFlow specs

### Recommended Workflow States

| Linear State | DocFlow Status |
|--------------|----------------|
| Backlog | BACKLOG |
| Todo | READY |
| In Progress | IMPLEMENTING |
| In Review | REVIEW |
| QA | TESTING |
| Done | COMPLETE |

---

## Figma Integration

When Linear issues have Figma attachments:

1. Agent reads issue → sees Figma URL
2. Agent calls Figma MCP → gets design context
3. Agent implements with actual specs (colors, spacing, etc.)

This enables design-accurate implementations without manual spec copying.

**Requires:** Figma MCP installed in Cursor + `FIGMA_ACCESS_TOKEN` in environment.

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
