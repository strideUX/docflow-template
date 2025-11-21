# DocFlow - strideOS

This project uses DocFlow, a spec-driven development workflow. Start here to understand the system.

## Quick Start

### For Development Work
1. **Check what's active**: Read `docflow/ACTIVE.md` to see current focus
2. **Start a session**: Type `/start-session` in Cursor chat
3. **Work on active spec**: Follow acceptance criteria in `docflow/specs/active/`
4. **Wrap when done**: Type `/wrap-session` to checkpoint progress

### For Understanding the Project
1. **Read context files** in `docflow/context/`:
   - `overview.md` - What we're building and why
   - `stack.md` - Technologies and architecture
   - `standards.md` - How we write code
2. **Check the plan**: `docflow/INDEX.md` shows all work items

## Project Structure

```
docflow/
├── ACTIVE.md                          # Current focus (updated frequently)
├── INDEX.md                           # Master inventory of all work
│
├── context/                           # Project fundamentals
│   ├── overview.md                    # Product vision, goals, success criteria
│   ├── stack.md                       # Tech stack, architecture patterns
│   └── standards.md                   # Coding standards, best practices
│
├── specs/                             # Spec lifecycle
│   ├── templates/                     # Spec templates (feature, bug, idea, etc.)
│   ├── active/                        # Currently implementing
│   ├── backlog/                       # Planned work (priority ordered)
│   ├── complete/                      # Finished work (archived by quarter)
│   │   └── YYYY-QQ/
│   └── assets/                        # Spec-specific resources (screenshots, etc.)
│       └── [spec-name]/
│
└── knowledge/                         # Project knowledge base
    ├── decisions/                     # Architecture Decision Records (ADRs)
    ├── features/                      # Complex feature documentation
    └── notes/                         # Real-time discoveries and gotchas
```

## Development Workflow

**📖 See [WORKFLOW.md](WORKFLOW.md) for complete three-agent workflow model and command guide.**

### Cursor Slash Commands
Type `/` in Cursor chat to see available commands:

**Daily Workflow:**
- `/start-session` - Begin work session (PM agent)
- `/wrap-session` - End work session (PM agent)
- `/capture` - Quick capture new work (PM agent)
- `/review` - Refine backlog items (PM agent)
- `/activate` - Ready spec for implementation (PM agent)
- `/implement` - Pick up and build (Implementation agent)
- `/validate` - Test and review (QE agent)
- `/close` - Archive completed work (PM agent)
- `/status` - Check current state (any agent)

**DocFlow Setup (once per project):**
- `/docflow-new` - Set up new project with DocFlow
- `/docflow-scan` - Retrofit or update existing projects

### Natural Language Commands
Cursor recognizes these phrases:
- "let's start" / "what's next" → Runs `/start-session`
- "let's wrap" / "I'm done" → Runs `/wrap-session`
- "capture that" / "add to backlog" → Runs `/capture`
- "review [item]" → Runs `/review`
- "looks good" / "ship it" / "approve" → Approves QE testing

## Project Overview

**strideOS** - The operating system for strideUX, a revolutionary project management solution where **projects ARE living documents**. Built with:
- **Next.js 15** - App Router with React Server Components
- **Convex** - Real-time database and serverless backend
- **BlockNote** - Rich text editor with section-based architecture
- **shadcn/ui + Tailwind CSS** - Modern component library
- **TypeScript** - Full type safety throughout

## Key Features

1. **Document-Centric PM** - Projects as living documents with embedded functionality
2. **Sprint Planning System** - Automated weekly sprints with capacity management
3. **Real-time Collaboration** - Yjs-powered collaborative editing
4. **Task Management** - Unified task and personal todo system
5. **Client Collaboration** - Client access within project context
6. **Role-Based Access** - Admin, PM, Task Owner, and Client roles
7. **JIRA-Style Identifiers** - Human-readable slugs for all entities

## Key Principles

1. **Follow existing patterns**: Check stack.md for established patterns
2. **Search before creating**: Use codebase search to find existing functionality
3. **Update as you go**: Keep ACTIVE.md and acceptance criteria current
4. **Document decisions**: Use Decision Logs in specs and knowledge/decisions/
5. **TypeScript strict mode**: All code fully typed
6. **Real-time first**: Leverage Convex subscriptions throughout

## Important Files

- `docflow/ACTIVE.md` - What's being worked on right now
- `docflow/INDEX.md` - Complete inventory of work items
- `docflow/context/overview.md` - Product vision and goals
- `docflow/context/stack.md` - Technical stack and architecture
- `docflow/context/standards.md` - Code quality and development standards
- `docflow/specs/templates/` - Spec templates (feature, bug, chore, idea)
- `docflow/knowledge/` - Architecture decisions and feature documentation

## Architecture Highlights

### Unified Data Architecture
- **Single Source of Truth**: One data source, multiple interaction paradigms
- **Real-time Sync**: All views update through Convex subscriptions
- **Project-Document Integration**: Projects reference documents, tasks appear in both contexts

### Sprint Planning System
- **Weekly Sprints**: Automated across all clients and departments
- **Capacity Management**: Department workstream-based calculations
- **Cross-Client Planning**: Unified planner view for resource allocation

### Section-Based Documents
- **Multiple Editors**: Each section has its own BlockNote editor
- **Template System**: Document templates define section structures
- **Flexible Organization**: Sections can be reordered and customized

## Questions?

- Check the spec in `docflow/specs/active/` for current work
- Check `docflow/context/` files for project context
- Check `docflow/INDEX.md` for complete work list
- Check `docflow/knowledge/` for architectural decisions and feature docs
- Use codebase search to find existing code patterns
