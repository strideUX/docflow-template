# DocFlow

> Spec-driven development workflow for AI-assisted coding

DocFlow is a structured workflow system that helps AI agents and developers collaborate effectively through detailed specifications and a three-agent orchestration model.

---

## Versions

### 📁 [Local](./local/) - v2.x (Current Stable)

The original, fully local DocFlow system. All specs, indexes, and workflow state stored in markdown files within the project.

**Best for:**
- Solo developers
- Projects that don't need team collaboration
- Offline-first workflows
- Getting started with DocFlow

```bash
# Install local version
cd local
./docflow-install.sh /path/to/your/project
```

[📖 Local Documentation](./local/DOCFLOW-GUIDE.md)

---

### ☁️ [Cloud](./cloud/) - v3.x (Linear Integration)

The hybrid DocFlow system with Linear integration. Specs live in Linear, understanding stays local.

**Best for:**
- Teams needing collaboration
- Projects requiring stakeholder visibility
- Cursor Background Agent workflows
- Design-integrated development (Figma)

```bash
# Install cloud version
cp -r cloud/template/* /path/to/your/project/
# Then configure .docflow.json with your Linear IDs
```

[📖 Cloud Documentation](./cloud/README.md)  
[📋 Full Specification](./cloud/DOCFLOW-CLOUD-SPEC.md)

---

## Comparison

| Feature | Local (v2) | Cloud (v3) |
|---------|------------|------------|
| Spec Storage | Markdown files | Linear issues |
| Team Visibility | Git only | Linear UI |
| Offline Work | ✅ Full | ✅ Context only |
| Collaboration | Via git | Real-time |
| AI Agent Integration | Good | Excellent |
| Figma Integration | Manual | Automatic |
| Update Distribution | Manual copy | MCP sync |
| Setup Complexity | Low | Medium |

---

## Core Concepts

Both versions share the same core workflow:

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

### Separation of Concerns

| Layer | What It Contains | Where It Lives |
|-------|------------------|----------------|
| **Understanding** | Context, knowledge | Always local (git) |
| **Workflow** | Specs, status | Local (v2) or Cloud (v3) |
| **Rules** | Commands, agent instructions | Local (synced in v3) |

---

## Getting Started

### Option 1: Start with Local

If you're new to DocFlow or working solo:

```bash
cd local
./docflow-install.sh /path/to/your/project
```

Then read [DOCFLOW-GUIDE.md](./local/DOCFLOW-GUIDE.md).

### Option 2: Start with Cloud

If you need team features or Linear integration:

```bash
cp -r cloud/template/* /path/to/your/project/
```

Then:
1. Edit `.docflow.json` with your Linear team ID
2. Set `LINEAR_API_KEY` environment variable
3. Read [Cloud README](./cloud/README.md)

---

## Migration

### Local → Cloud

See [DOCFLOW-CLOUD-SPEC.md](./cloud/DOCFLOW-CLOUD-SPEC.md) Section 8 for migration guide.

### Cloud → Local

Copy context/knowledge from cloud project, then install local template.

---

## Repository Structure

```
docflow-template/
├── README.md              # This file
├── local/                 # Local version (v2.x)
│   ├── DOCFLOW-GUIDE.md   # Complete local documentation
│   ├── docflow-install.sh # Installation script
│   ├── template/          # Local template files
│   └── releases/          # Version history
│
└── cloud/                 # Cloud version (v3.x)
    ├── README.md          # Cloud quick start
    ├── DOCFLOW-CLOUD-SPEC.md  # Full specification
    └── template/          # Cloud template files
```

---

## Contributing

Contributions welcome! Please:

1. Decide which version you're improving (local or cloud)
2. Follow existing patterns and conventions
3. Update documentation with changes
4. Test with actual AI agents

---

## License

[Your License Here]

---

*DocFlow - Making AI-assisted development structured and effective*

