# DocFlow Cloud Instructions for GitHub Copilot

This project uses **DocFlow Cloud**, a spec-driven development workflow with Linear integration.

---

## Primary Rules Location

**`.cursor/rules/docflow.mdc`** - Complete workflow system

**Read this file to understand:**
- Three-agent orchestration model (PM, Implementation, QE)
- Linear integration patterns
- Command system (12 commands)
- Context loading strategy
- Natural language triggers

---

## Quick Integration Guide

### 1. Check Current Work
**Query Linear** for "In Progress" issues

Or ask: "What issues are currently active in Linear?"

### 2. Follow Active Issues
**Location:** Linear (not local files)

When implementing:
- Read the Linear issue description
- Follow acceptance criteria
- Update progress via Linear comments
- Check off items as you complete

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

## Key Cloud Differences

### Specs Live in Linear
- ❌ NO local spec files
- ❌ NO `INDEX.md` or `ACTIVE.md`
- ✅ All specs are **Linear issues**
- ✅ Status tracked by **Linear workflow states**
- ✅ Progress notes in **Linear comments**

### Local Context Stays
- ✅ `docflow/context/` - Project understanding
- ✅ `docflow/knowledge/` - ADRs, features, notes
- ✅ Rules in `.cursor/`

---

## Copilot-Specific Behavior

### Code Suggestions
When suggesting code:
- Follow patterns in `stack.md`
- Match conventions in `standards.md`
- Reference acceptance criteria from Linear issue
- Use existing utilities and components

### Inline Completions
- Match project's naming conventions
- Follow established patterns
- Respect TypeScript strict mode
- Include proper error handling

### Chat Assistance
You can use DocFlow commands:
- "Create a spec for [feature]" → creates Linear issue
- "What should I work on?" → queries Linear status
- "Review this implementation" → guides QE testing

### Documentation
Help maintain:
- Comments in Linear (Decision Log style)
- Implementation progress in Linear
- Knowledge base docs when discovering patterns

---

## File Organization

```
project/
├── .cursor/
│   ├── rules/docflow.mdc    # Complete workflow rules
│   ├── commands/            # Slash commands
│   └── mcp.json             # Linear + Figma MCPs
├── docflow/
│   ├── context/             # Project rules (LOCAL)
│   │   ├── overview.md
│   │   ├── stack.md         # Tech patterns
│   │   └── standards.md     # Code quality
│   └── knowledge/           # Project knowledge (LOCAL)
│       ├── INDEX.md
│       ├── decisions/       # ADRs
│       ├── features/        # Feature docs
│       └── notes/           # Technical notes
├── .docflow.json            # Linear configuration
└── AGENTS.md                # Agent instructions

LINEAR (Cloud):
├── Issues                   # All specs
├── Workflow States          # BACKLOG → DONE
├── Comments                 # Progress, decisions
└── Attachments              # Figma, screenshots
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
1. Create issues in Linear (not local files)
2. Include clear acceptance criteria
3. Add context and user story
4. Document decisions in comments

### When Discovering Patterns
If you find reusable patterns while coding:
- Suggest documenting in `docflow/knowledge/features/`
- Add to Linear issue comments if it's a decision
- Keep knowledge base current

---

## Workflow States (in Linear)

**Features & Bugs:**
```
Backlog → In Progress → In Review → QA → Done
```

**Chores & Ideas:**
```
Backlog → In Progress → Done
```

---

## Issue Metadata

### Priority Values
| Value | Name | Use When |
|-------|------|----------|
| 1 | Urgent | Drop everything |
| 2 | High | Next up, important |
| 3 | Medium | Normal (default) |
| 4 | Low | Nice to have |

### Estimate Values (Complexity)
| Value | Name | Rough Effort |
|-------|------|--------------|
| 1 | XS | < 1 hour |
| 2 | S | 1-4 hours |
| 3 | M | Half to full day |
| 4 | L | 2-3 days |
| 5 | XL | Week+ |

### Acceptance Criteria
- Live as checkboxes in issue description: `- [ ]` / `- [x]`
- Update in-place as each criterion is completed
- Issue description is single source of truth

### Comment Format
```
**Status** — Brief description.
```
Examples: `**Activated** — ...`, `**Progress** — ...`, `**Complete** — ...`

### Team Collaboration
- **Assign:** `updateIssue(id, { assignee: "name" })` — by name, email, or "me"
- **Subscribers:** Add via GraphQL `subscriberIds` for notifications
- **Find users:** `list_users({ query: "name" })`

---

## Commands Reference

**Full command list in:** `.cursor/commands/`

Quick reference:
- `/start-session` - Check Linear status (PM agent)
- `/implement [issue]` - Build it (Implementation agent)
- `/attach [file] [issue]` - Attach files to issue (Implementation agent)
- `/validate [issue]` - Test it (QE agent)
- `/close [issue]` - Move to Done (PM agent)
- `/project-update` - Post project status update (PM agent)
- `/sync-project` - Sync context files to Linear project (PM agent)
- `/status` - Query Linear (any agent)
- `/docflow-update` - Sync rules from source

**Natural language works too:**
- "let's start" / "what's next"
- "build LIN-XXX" / "implement this"
- "test this" / "review implementation"
- "sync project" / "update project description"

---

## Critical Rules

⚠️ **Never create local spec files:**
- ❌ NO specs in docflow/specs/
- ❌ NO INDEX.md or ACTIVE.md
- ✅ All specs → Linear issues

⚠️ **Always search before creating:**
- Check for existing implementations
- Reference docflow/knowledge/ for patterns
- Avoid duplication

⚠️ **Update Linear, not local files:**
- Status changes → Linear state
- Progress → Linear comments
- Decisions → Linear comments (dated)

⚠️ **Load context situationally:**
- Don't auto-load all files
- Load based on current task
- See rules for guidance

---

## For More Information

1. **`.cursor/rules/docflow.mdc`** - Complete rules (read this!)
2. **`WARP.md`** - Workflow guide
3. **`AGENTS.md`** - Universal agent instructions
4. **`docflow/knowledge/README.md`** - Knowledge base guide
5. **`.docflow.json`** - Linear configuration

---

**DocFlow Cloud is designed for AI-first development with team collaboration. Follow the rules, and Linear handles the workflow.**

