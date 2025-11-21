# DocFlow Template - Project Setup

This is a complete DocFlow template ready to be copied into any new project.

## Quick Setup

### 1. Copy Template to Your Project

```bash
# Clone the template repository
git clone git@github.com:strideUX/docflow-template.git

# From your project root
cp -r /path/to/docflow-template/* ./
# Example: cp -r ~/Documents/Work/docflow-template/* ./
```

Or manually copy these files/folders to your project root:
- `.cursor/` - Cursor rules and commands
- `docflow/` - DocFlow directory structure

### 2. Customize Context Files

Update these project-specific files in `/docflow/context/`:

**`overview.md`** - Update with your project details:
- Project name and purpose
- Goals and success metrics
- Target audience
- Scope (in/out)

**`stack.md`** - Update with your tech stack:
- Framework (Next.js, React, etc.)
- Styling (Tailwind, CSS Modules, etc.)
- Database/CMS (Prisma, Sanity, etc.)
- Deployment platform
- Development tools

**`standards.md`** - Adjust coding standards to match your team:
- Code style preferences
- Naming conventions
- Testing requirements
- PR/review process

### 3. Initialize Your First Spec

Choose one of the templates in `/docflow/specs/templates/`:
- `feature.md` - New features with user stories (comprehensive workflow)
- `bug.md` - Bug fixes with root cause analysis
- `chore.md` - Maintenance, cleanup, refactoring (task-based, ongoing)
- `idea.md` - Quick idea capture (lightweight, can be refined later)

Copy to `/docflow/specs/backlog/` and customize.

Each template includes inline agent instructions to guide consistent, high-quality spec creation.

### 4. Initialize DocFlow

**For a brand new project:**
```
/docflow-new
```
Agent will guide you through vision, stack selection, and initial backlog creation.

**For an existing project:**
```
/docflow-scan
```
Agent will analyze your code and set up DocFlow based on what exists.

### 5. Start Your First Session

After DocFlow is initialized, begin working:
```
/start-session
```

DocFlow will guide you through the workflow!

## What's Included

### `.cursor/` Directory
- `rules/docflow.mdc` - Core DocFlow rules (always active)
- `commands/start-session.md` - Begin work session
- `commands/wrap-session.md` - Save progress
- `commands/capture.md` - Quick capture ideas/bugs
- `commands/review.md` - Review backlog items

### `docflow/` Directory
```
docflow/
├── ACTIVE.md              # Current work (update frequently)
├── INDEX.md               # Master inventory
│
├── context/               # Project fundamentals
│   ├── overview.md        # Product vision, goals
│   ├── stack.md           # Tech stack details
│   └── standards.md       # Coding standards
│
├── specs/                 # Spec lifecycle
│   ├── templates/         # Spec templates
│   ├── active/            # Currently implementing
│   ├── backlog/           # Planned work
│   ├── complete/          # Finished (archive by quarter)
│   └── assets/            # Spec-specific resources
│
└── knowledge/             # Project knowledge base
    ├── decisions/         # Architecture decisions (ADRs)
    ├── features/          # Complex feature docs
    └── notes/             # Real-time discoveries
```

## Key Features

### Status-Based Workflow
- **BACKLOG** → **READY** → **IMPLEMENTING** → **REVIEW** → **COMPLETE**
- Automatic assignment tracking via git username
- Multi-developer coordination support

### Natural Language Commands
Cursor recognizes these phrases:
- "let's start" → Runs `/start-session`
- "let's wrap" → Runs `/wrap-session`
- "capture that" → Runs `/capture`
- "review this" → Runs `/review`

### Root File Protection (Rule 0)
DocFlow prevents clutter by forbidding status files in project root:
- ❌ NO STATUS.md, SUMMARY.md, TODO.md in root
- ✅ ALL tracking in /docflow/ACTIVE.md and specs
- ✅ Knowledge in /docflow/knowledge/ (not scattered docs)

### Two Documentation Patterns
**Option A: Small changes**
→ Add "Recently Completed" section to ACTIVE.md

**Option B: Large features**
→ Create spec, work on it, move to /docflow/specs/complete/

## First Steps Checklist

- [ ] Copy template files to project
- [ ] Update `docflow/context/overview.md` with project details
- [ ] Update `docflow/context/stack.md` with tech stack
- [ ] Customize `docflow/context/standards.md` for your team
- [ ] Create your first spec in `/docflow/specs/backlog/`
- [ ] Update `docflow/INDEX.md` with initial work items
- [ ] Run `/start-session` in Cursor to begin

## Questions?

Check `/docflow/README.md` in your project for:
- Workflow commands
- Natural language triggers
- Key principles
- File organization

## Template Maintenance

This template is maintained at: **git@github.com:strideUX/docflow-template.git**

Updates should flow:
1. Refine DocFlow in a live project (e.g., stride-website)
2. Extract improvements back to this template repository
3. Apply to other projects by copying from template

**Update Workflow**: Live Project → Template Repo → Other Projects
**GitHub Repository**: `git@github.com:strideUX/docflow-template.git`
**Local Clone Example**: `~/Documents/Work/docflow-template/`
