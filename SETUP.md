# DocFlow Template - Project Setup

This is a complete DocFlow template ready to be copied into any new project.

## Quick Setup

### 1. Copy Template to Your Project

```bash
# From your project root
cp -r /path/to/docflow-template/* ./
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

Choose one of the templates in `/docflow/specs/.templates/`:
- `feature.md` - For new features
- `bug.md` - For bug fixes
- `idea.md` - For exploratory work
- `feature-project-setup.md` - For initial project setup

Copy to `/docflow/specs/backlog/` and customize.

### 4. Start Your First Session

In Cursor, type:
```
/start-session
```

DocFlow will guide you through starting work!

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
├── README.md              # Quick reference guide
│
├── context/               # Project context (stable)
│   ├── overview.md        # Product vision, goals
│   ├── stack.md           # Tech stack details
│   └── standards.md       # Coding standards
│
├── specs/                 # All work items
│   ├── .templates/        # Spec templates
│   ├── active/            # Currently implementing
│   ├── backlog/           # Planned work
│   ├── complete/          # Finished (archive by quarter)
│   └── reference/         # Supporting docs
│
└── shared/
    └── dependencies.md    # Shared code tracking
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

### Two Documentation Patterns
**Option A: Small changes**
→ Add "Recently Completed" section to ACTIVE.md

**Option B: Large features**
→ Create spec, work on it, move to /specs/complete/

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

This template is maintained in the stride-docflow project. Updates should flow:
1. Refine in a live project
2. Extract improvements back to template
3. Apply to other projects

**Source of Truth**: The project using the latest refined DocFlow system
**Template Location**: `/docflow-template/` in stride-docflow repo
