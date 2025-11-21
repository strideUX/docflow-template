# DocFlow Instructions for GitHub Copilot

This project uses **DocFlow**, a spec-driven development workflow.

---

## Primary Rules Location

**`.cursor/rules/docflow.mdc`** - Complete workflow system

**Read this file to understand:**
- Three-agent orchestration model (PM, Implementation, QE)
- Spec lifecycle and status states
- Command system (12 commands)
- Context loading strategy
- File organization rules
- Natural language triggers

---

## Quick Integration Guide

### 1. Check Current Work
**Always read:** `docflow/ACTIVE.md`

Shows what's currently in progress and needs attention.

### 2. Follow Active Specs
**Location:** `docflow/specs/active/`

When implementing:
- Load the complete spec
- Follow acceptance criteria
- Check off items as you complete: [ ] → [x]
- Fill Implementation Notes as you work

### 3. Follow Coding Standards
**Read:** `docflow/context/standards.md`

Apply these rules to all code suggestions:
- TypeScript strict mode
- No `any` types
- Follow project conventions
- Proper error handling

### 4. Respect Tech Stack
**Read:** `docflow/context/stack.md`

Use the documented:
- Framework patterns
- State management approach
- Component structure
- API patterns

### 5. Search Before Creating
**Before suggesting new code:**
- Search codebase for existing implementations
- Check `docflow/knowledge/` for documented patterns
- Avoid creating duplicate functionality

---

## Copilot-Specific Behavior

### Code Suggestions
When suggesting code:
- Follow patterns in `stack.md`
- Match conventions in `standards.md`
- Reference acceptance criteria from active spec
- Use existing utilities and components

### Inline Completions
- Match project's naming conventions
- Follow established patterns
- Respect TypeScript strict mode
- Include proper error handling

### Chat Assistance
You can use DocFlow commands:
- "Create a spec for [feature]" → use /capture
- "What should I work on?" → use /start-session
- "Review this implementation" → use /validate

### Documentation
Help maintain:
- Decision Logs in specs
- Implementation Notes as you code
- Knowledge base docs when discovering patterns

---

## File Organization

```
docflow/
├── ACTIVE.md              # Current work (check this)
├── INDEX.md               # All work inventory
├── context/               # Project rules (follow these)
│   ├── overview.md
│   ├── stack.md          # Tech patterns
│   └── standards.md      # Code quality
├── specs/                # Spec lifecycle
│   ├── templates/        # Use these for new specs
│   ├── active/          # Current work
│   ├── backlog/         # Planned work
│   └── complete/        # Done
└── knowledge/           # Project knowledge
    ├── decisions/       # ADRs
    ├── features/        # Feature docs
    ├── notes/          # Technical notes
    └── product/        # UX artifacts
```

---

## Key Principles for Copilot

### When Suggesting Code
1. Search for existing implementations first
2. Follow standards.md conventions
3. Match existing patterns in codebase
4. Include TypeScript types (strict mode)
5. Add proper error handling
6. Document complex logic

### When Helping with Specs
1. Use templates from `docflow/specs/templates/`
2. Fill inline agent instructions
3. Make acceptance criteria specific and testable
4. Document decisions in Decision Log

### When Discovering Patterns
If you find reusable patterns while coding:
- Suggest documenting in `docflow/knowledge/features/`
- Add to Decision Log if it's an architectural choice
- Keep knowledge base current

---

## Workflow States

**Features & Bugs:**
```
BACKLOG → READY → IMPLEMENTING → REVIEW → QE_TESTING → COMPLETE
```

**Chores & Ideas:**
```
BACKLOG → ACTIVE → COMPLETE
```

---

## Commands Reference

**Full command list in:** `.cursor/commands/`

Quick reference:
- `/start-session` - Begin work (PM agent)
- `/implement [spec]` - Build it (Implementation agent)
- `/validate [spec]` - Test it (QE agent)
- `/close [spec]` - Archive it (PM agent)
- `/status` - Check state (any agent)

**Natural language works too:**
- "let's start" / "what's next"
- "build [spec]" / "implement [spec]"
- "test this" / "review implementation"

---

## Critical Rules

⚠️ **Never create root-level status files:**
- ❌ NO STATUS.md, SUMMARY.md, TODO.md in project root
- ✅ Use docflow/ACTIVE.md and specs instead

⚠️ **Always search before creating:**
- Check for existing implementations
- Reference docflow/knowledge/ for patterns
- Avoid duplication

⚠️ **Follow atomic file operations:**
- When moving specs, delete source then create destination
- Update ACTIVE.md and INDEX.md in same operation

⚠️ **Load context situationally:**
- Don't auto-load all files
- Load based on current task
- See rules for guidance

---

## For More Information

1. **`.cursor/rules/docflow.mdc`** - Complete rules (read this!)
2. **`WORKFLOW.md`** - Workflow guide with examples
3. **`AGENTS.md`** - Universal agent instructions
4. **`README.md`** - Project overview
5. **`docflow/knowledge/README.md`** - Knowledge base guide

---

**DocFlow is designed for AI-first development. Follow the rules, and the workflow will guide you.**

