# DocFlow Cloud Templates

Templates for PM tools (Linear, Jira, etc.) to ensure consistent structure across issues and projects.

## Structure

```
templates/
├── issues/           # Issue/ticket templates
│   ├── feature.md    # New functionality
│   ├── bug.md        # Defect reports
│   ├── chore.md      # Maintenance/cleanup
│   └── idea.md       # Future consideration
│
├── projects/         # Project description templates
│   └── project.md    # Project overview format
│
└── README.md         # This file
```

## Usage

### For Linear

1. **Issues:** Copy the relevant template content when creating a new issue
2. **Projects:** Use `/sync-project` command to auto-generate from context files

### For Other PM Tools

Adapt templates to match the tool's format while keeping the same structure and sections.

## Template Philosophy

### Issues

All issue templates include:
- **Context** - Why this work matters
- **Acceptance Criteria** - What "done" looks like
  - Functionality requirements
  - Tests requirements
  - Documentation requirements
- **Technical Notes** - How to approach
- **Workflow Notes** - How to track progress

### Projects

Project descriptions are **generated** from local context files:
- `docflow/context/overview.md` → Vision, goals, phase, links
- `docflow/context/stack.md` → Tech stack
- `docflow/context/standards.md` → Key conventions

This keeps the codebase as the source of truth while providing visibility in the PM tool.

## Keeping Templates Updated

These templates should evolve with your workflow. When you find:
- Missing sections → Add them
- Unused sections → Remove them
- Better patterns → Update templates

Changes here don't auto-sync to existing issues - they're for new issue creation.
