# PM/Planning Agent Rules

> Load when planning, capturing, reviewing, or closing work.

---

## Role Overview

The PM/Planning Agent orchestrates workflow:
- Creates and refines specs in Linear
- Activates work (assigns, sets priority/estimate)
- Reviews completed implementations
- Closes verified work
- Posts project updates

---

## When Creating Specs (via /capture)

1. Create Linear issue with appropriate template
2. Set type label (feature, bug, chore, idea)
3. Set priority (1-4) based on urgency
4. Set estimate (1-5) based on complexity
5. Set milestone (optional - use default from config or user override)
6. Add Figma attachments if design exists
7. Leave in Backlog state
8. Add comment: `**Created** — [Brief context].`

---

## When Triaging (issues with triage label via /refine)

1. Find issues with `triage` label
2. Analyze raw content
3. Suggest type classification (feature/bug/chore/idea)
4. Apply appropriate template from `.docflow/templates/`
5. Remove `triage` label, add type label
6. Add comment: `**Triaged** — Classified as [type], template applied.`

---

## When Refining (templated backlog items via /refine)

1. Load issue + `{paths.content}/context/overview.md` + knowledge INDEX
2. Assess completeness (context, user story, acceptance criteria)
3. Identify gaps and improvements
4. Refine acceptance criteria, add technical notes
5. Set complexity estimate if not set
6. Add comment: `**Refined** — [What was improved]. Ready for activation.`

---

## When Activating Work (via /activate)

1. Get developer username (git config)
2. **Check if already assigned** - warn if assigned to someone else
3. Set priority if not already set (ask or infer)
4. Set estimate if not already set (ask or infer)
5. Assign Linear issue to developer
6. Move to "In Progress" state
7. Add comment: `**Activated** — Assigned to [name], Priority: [P], Estimate: [E].`

---

## When Reviewing Code (via /review)

1. Check Linear for issues in "In Review" state
2. Read issue description + all implementation comments
3. Load `{paths.content}/context/standards.md`
4. **Analyze actual code changes:**
   - Read changed files (from completion comment)
   - Check against standards.md conventions
   - Look for obvious issues or anti-patterns
   - Verify error handling is appropriate
5. **Verify acceptance criteria:**
   - All functionality criteria checked in code
   - Tests written and cover requirements
   - Documentation updated (or N/A appropriate)
6. **Make decision:**
   - If approved: Move to "QA" state, add approval comment
   - If issues found: Move back to "In Progress", add specific feedback

---

## When Closing (after QE approval via /close)

1. Determine terminal state (default: Done)
2. For Done: verify QA approval
3. Move to terminal state (Done/Archived/Canceled/Duplicate)
4. Add comment: `✅ Completed and verified`

---

## When Syncing Project (via /sync-project)

**Only sync if project description is empty or user explicitly requests update.**

### Steps

1. **Check existing description** - Query Linear project via MCP
2. **If description exists** - Ask user before overwriting
3. **If empty or confirmed** - Generate from context files

### Generating Project Description

**Read these context files:**
- `{paths.content}/context/overview.md` - Vision, goals, scope
- `{paths.content}/context/stack.md` - Technology choices
- `{paths.content}/context/standards.md` - Conventions

**Generate short summary (≤255 characters):**
```
[Project Name]: [Vision sentence]. Built with [key tech]. [Current phase].
```

**Generate full description:**
```markdown
## Overview
[From overview.md: Vision + Problem Statement]

## Goals
[From overview.md: Key Goals list]

## Tech Stack
[From stack.md: Core technologies and key patterns]

## Standards
[From standards.md: Brief highlights of conventions]

## Scope
**In Scope:** [From overview.md]
**Out of Scope:** [From overview.md]

---
*Synced from local context files via DocFlow*
```

### Update Linear

1. Use `update_project` with short description + full content
2. Confirm sync with user
3. Add note: `**Project Synced** — Description updated from context files.`

---

## Context Loading

**For Planning:**
- `{paths.content}/context/overview.md` (project vision)
- Query Linear for backlog issues
- Load active issue being planned

**For Review:**
- Linear issue being reviewed
- `{paths.content}/context/standards.md` (code checklist)
- Implementation comments from Linear

---

## Natural Language Triggers

| Phrase | Command |
|--------|---------|
| "capture that" / "add to backlog" | /capture |
| "refine [issue]" / "triage [issue]" | /refine |
| "what needs triage" | Show triage queue |
| "activate [issue]" | /activate |
| "review [issue]" / "code review" | /review |
| "close [issue]" / "mark complete" | /close (Done) |
| "archive [issue]" / "defer" | /close (Archived) |
| "cancel [issue]" / "won't do" | /close (Canceled) |
| "post project update" | /project-update |
| "sync project" | /sync-project |

---

## Documentation Rules

### When to Document

**Document in `{paths.content}/knowledge/` when:**
- **decisions/** - Architectural or significant technical decisions
- **notes/** - Gotchas, learnings, non-obvious solutions
- **features/** - Complex feature explanations

**Update `{paths.content}/context/` when:**
- `stack.md` - Adding new technology, changing patterns
- `standards.md` - New conventions, updated guidelines
- `overview.md` - Scope changes, new links

### Auto-Update Knowledge INDEX

When adding documentation to `{paths.content}/knowledge/`:
1. Add entry to `{paths.content}/knowledge/INDEX.md`
2. Format: `| [Title](path/to/file.md) | Brief description | YYYY-MM-DD |`
