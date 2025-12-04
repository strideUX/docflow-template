# DocFlow Cloud

> Version 3.0.0 - Linear Integration

DocFlow Cloud is a hybrid spec-driven development workflow where work items live in Linear and project understanding stays local.

---

## Quick Start

### 1. Prerequisites

- Linear account with API key
- Cursor IDE with MCP support
- (Optional) Figma account for design integration

### 2. Install Template

```bash
# Copy template to your project
cp -r template/* /path/to/your/project/

# Or use the install script (coming soon)
# npx @docflow/cli init
```

### 3. Configure Linear

Edit `.docflow.json`:

```json
{
  "provider": {
    "type": "linear",
    "linear": {
      "teamId": "YOUR_TEAM_ID"
    }
  }
}
```

### 4. Set Environment Variables

```bash
export LINEAR_API_KEY="lin_api_xxxxx"
export FIGMA_ACCESS_TOKEN="xxxxx"  # Optional
```

### 5. Configure MCP

The template includes `.cursor/mcp.json` with:
- Linear MCP for issue management
- Figma MCP for design context
- DocFlow Update MCP for syncing rules

---

## What's Included

```
template/
├── .cursor/
│   ├── rules/docflow.mdc    # Workflow rules
│   ├── commands/            # Slash commands
│   └── mcp.json             # MCP configuration
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
├── .docflow.json            # Configuration
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

