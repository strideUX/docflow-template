# PM/Planning Agent Rules

> Load when planning, capturing, reviewing, or closing work.

---

## Role Overview

The PM/Planning Agent orchestrates workflow:
- Sets up new projects (defines context, connects Linear)
- Creates and refines specs in Linear
- Activates work (assigns, sets priority/estimate)
- Reviews completed implementations
- Closes verified work
- Posts project updates

---

## When Setting Up Project (via /docflow-setup)

### Phase 1: Project Definition

1. **Welcome and gather input** - Ask what they're building
2. **Accept any format:**
   - Loose concept ("I want to build a todo app")
   - Detailed description (paragraphs)
   - PRD/spec file (@filename reference)

3. **Interactive refinement:**
   - **For loose concepts:** Ask discovery questions (problem, users, value prop, success metrics, v1 scope)
   - **For PRDs:** Critically review for gaps, ambiguities, scope creep; suggest improvements
   - Engage in back-and-forth, don't just accept input
   - Reflect understanding, ask clarifying questions, challenge assumptions

4. **Confirm understanding** before filling files:
   - Project name, vision, problem, users, goals, scope
   
5. **Fill context files:**
   - `{paths.content}/context/overview.md` - Vision, goals, scope
   - `{paths.content}/context/stack.md` - Tech choices
   - `{paths.content}/context/standards.md` - Conventions (defaults OK)

### Phase 2: Linear Connection

1. Query Linear teams → user selects
2. Query/create Linear project
3. Save IDs to `.docflow/config.json`
4. Verify connection

### Phase 3: Backlog - Migration or Creation

**First, check for existing local specs:**
- Look for `{paths.content}/specs/backlog/*.md`
- Look for `{paths.content}/specs/complete/*.md`

**If local specs exist → Migrate:**
1. Show count of specs found
2. Offer to migrate to Linear
3. For each backlog spec:
   - Read file, extract title/description/criteria
   - Create Linear issue (Backlog state)
4. For each completed spec:
   - Create Linear issue (Done state)
5. Offer to archive local specs folder (move to `specs-archived/`)

**If no local specs → New project:**
1. Ask if user wants to capture initial items
2. **Create 5-15 high-level items** (features/epics, not implementation tasks)
3. Focus on **what** not **how** (subtasks come during `/activate`)
4. Apply type label to each (feature/chore/bug/idea)
5. Create in Linear (Backlog state)

### Phase 4: Prioritization & Dependencies

After creating backlog items:
1. **Set priorities:**
   - Urgent: Blocking launch, critical bugs
   - High: Core v1 features, foundational work, unblocks others
   - Medium: Important but not blocking
   - Low: Nice-to-have, future enhancements

2. **Identify dependencies:**
   - What blocks what? (e.g., auth before admin panel)
   - Create "blocks/blocked by" relationships in Linear
   - External blockers? (APIs, designs, etc.)

3. **Present implementation order:**
   - Suggest sequence based on priorities + dependencies
   - Confirm with user before finalizing

### Phase 5: Complete

1. Run `/sync-project` to push context to Linear
2. Show summary with prioritized backlog
3. Recommend first issue to activate

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
6. **Set initial priority** based on content/urgency
7. **Identify dependencies** if apparent
8. Add comment: `**Triaged** — Classified as [type], template applied. Priority: [P].`

---

## When Refining (templated backlog items via /refine)

1. Load issue + `{paths.content}/context/overview.md` + knowledge INDEX
2. Assess completeness (context, user story, acceptance criteria)
3. Identify gaps and improvements
4. Refine acceptance criteria, add technical notes
5. Set complexity estimate if not set
6. **Set priority if not set:**
   - Urgent: Blocking launch, critical bug
   - High: Core feature, foundational, unblocks others
   - Medium: Important but not blocking
   - Low: Enhancement, future, nice-to-have
7. **Set dependencies:**
   - Ask: "Does this depend on other issues?"
   - Ask: "Will completing this unblock other work?"
   - Create "blocks/blocked by" relationships in Linear
8. **Move to "Todo" state** (READY - refined and ready to pick up)
9. Add comment: `**Refined** — [What was improved]. Priority: [P]. [Dependency info]. Ready for activation.`

---

## When Activating Work (via /activate)

### If No Issue Specified → Smart Recommendation

1. **Query available issues:**
   - Get issues in Todo or Backlog state
   - Include priority, estimate, and blocking relationships

2. **Filter to ready issues:**
   - Exclude issues blocked by incomplete work
   - Exclude issues already assigned to others

3. **Rank by:**
   - Priority (Urgent → High → Medium → Low)
   - Unblocked status
   - Estimate (smaller = quicker wins, optional tiebreaker)

4. **Present recommendation:**
   - Show top recommended issue with reasoning
   - Show 2-3 alternatives
   - Show blocked issues (and what's blocking them)
   - Ask which to activate

### When Activating Specific Issue

#### ⚠️ ASSIGNMENT IS MANDATORY - No In Progress without assignee

1. **Determine assignee (REQUIRED):**
   - Try: `get_viewer()` to get current Linear user
   - Try: `list_users()` and match by name/email
   - If can't determine → **ASK explicitly**: "Who should this be assigned to?"
   - **NEVER skip assignment**

2. **Check current assignment:**
   - Unassigned → assign to determined user
   - Assigned to current user → proceed
   - Assigned to someone else → **WARN and confirm** before reassigning

3. **Check if blocked** - warn if blocked by incomplete issues

4. Set priority if not already set (ask or infer)

5. Set estimate if not already set (ask or infer)

6. **Assign issue (REQUIRED):**
   ```typescript
   update_issue({ issueId: "xxx", assigneeId: "user-id" })
   ```

7. **Verify assignment succeeded** - query issue, confirm assignee set

8. Move to "In Progress" state (only after assignment confirmed)

9. Add comment: `**Activated** — Assigned to [name], Priority: [P], Estimate: [E].`

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
| "activate [issue]" | /activate (specific) |
| "what should I work on?" / "what's next?" | /activate (smart recommend) |
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
