# DocFlow - strideOS

This project uses DocFlow, a spec-driven development workflow. Start here to understand the system.

## Quick Start

### For Development Work
1. **Check what's active**: Read `ACTIVE.md` to see current focus
2. **Start a session**: Type `/start-session` in Cursor chat
3. **Work on active spec**: Follow acceptance criteria in `specs/active/`
4. **Wrap when done**: Type `/wrap-session` to checkpoint progress

### For Understanding the Project
1. **Read context files** in `docflow/context/`:
   - `overview.md` - What we're building and why
   - `stack.md` - Technologies and architecture
   - `standards.md` - How we write code
2. **Check the plan**: `INDEX.md` shows all work items

## Project Structure

```
docflow/
├── ACTIVE.md                          # Current focus (updated frequently)
├── INDEX.md                           # Master inventory of all work
│
├── context/                           # Project context (stable)
│   ├── overview.md                    # Product vision, goals, success criteria
│   ├── stack.md                       # Tech stack, architecture patterns
│   └── standards.md                   # Coding standards, best practices
│
├── specs/                             # All features and work items
│   ├── active/                        # Currently implementing
│   ├── backlog/                       # Planned work (priority ordered)
│   ├── complete/                      # Finished work (archived by quarter)
│   │   └── YYYY-QQ/
│   └── reference/                     # Historical docs and decisions
│
└── shared/                            # Cross-cutting concerns
    └── dependencies.md                # Track shared code (prevent duplication)
```

## Development Workflow

### Cursor Slash Commands
Type `/` in Cursor chat to see available commands:

- `/start-session` - Begin work session, check status
- `/wrap-session` - Save progress, checkpoint work
- `/capture` - Quickly add idea/feature/bug to backlog
- `/review` - Review and refine backlog items
- `/new-project` - Set up new projects
- `/scan-project` - Analyze existing codebases

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
2. **Check dependencies.md**: Before creating new shared code
3. **Update as you go**: Keep ACTIVE.md and acceptance criteria current
4. **Document decisions**: Use Decision Log in specs
5. **TypeScript strict mode**: All code fully typed
6. **Real-time first**: Leverage Convex subscriptions throughout

## Important Files

- `ACTIVE.md` - What's being worked on right now
- `INDEX.md` - Complete inventory of work items
- `context/overview.md` - Product vision and goals
- `context/stack.md` - Technical stack and architecture
- `context/standards.md` - Code quality and development standards
- `shared/dependencies.md` - Shared code tracking
- `specs/reference/qe-testing-workflow.md` - QE testing phase guide
- `specs/.templates/` - All spec templates (spec-full, feature, bug, idea)

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

- Check the spec in `specs/active/` for current work
- Check `context/` files for project context
- Check `INDEX.md` for complete work list
- Check `shared/dependencies.md` for existing code
- Check `specs/reference/` for historical documentation
