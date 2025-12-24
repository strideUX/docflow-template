# PM/Planning Agent Rules

> Load when planning, capturing, reviewing, or closing work.  
> **Also load**: `always.md` for comment templates and verification gates.

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

## ⚠️ CRITICAL: Linear MCP Limitations

**For these operations, DO NOT use MCP - execute scripts directly:**

| Operation | Script to Run |
|-----------|---------------|
| Transition + Comment | `.docflow/scripts/transition-issue.sh` |
| Activate Issue | `.docflow/scripts/activate-issue.sh` |
| Wrap Session | `.docflow/scripts/wrap-session.sh` |
| Create Milestone | See `linear-integration.md` curl commands |

---

## /capture - Create New Issue

### Execution Checklist

```
□ 1. DETERMINE type from user input
     feature | bug | chore | idea

□ 2. CREATE Linear issue
     create_issue({
       teamId: "[from config]",
       projectId: "[from config]",
       title: "[descriptive title]",
       description: "[use template from .docflow/templates/]",
       labelIds: ["[type-label-id]"],
       priority: 0  // None until triaged
     })

□ 3. VERIFY issue created
     Confirm issue ID returned

□ 4. ADD COMMENT using template:
     "**Captured** — Added to backlog. Type: [type]. [Brief context]."

□ 5. RESPOND to user
     "Captured as [ISSUE-ID]: [title]. In backlog for refinement."
```

---

## /refine - Triage or Refine Issue

### If Issue Has `triage` Label (Raw Capture)

```
□ 1. READ issue content

□ 2. CLASSIFY type
     Ask if unclear: "Is this a feature, bug, chore, or idea?"

□ 3. APPLY template from .docflow/templates/[type].md
     Update description with template structure

□ 4. REMOVE triage label, ADD type label

□ 5. SET initial priority (P1-P4)

□ 6. RUN transition script:
     .docflow/scripts/transition-issue.sh [ISSUE-ID] "Backlog" \
       "**Triaged** — Classified as [type], template applied. Priority: P[X]."

□ 7. RESPOND to user
     "Triaged [ISSUE-ID] as [type]. Ready for refinement."
```

### If Issue Already Templated (Refinement)

```
□ 1. LOAD context
     - Issue description and comments
     - {paths.content}/context/overview.md
     - {paths.content}/knowledge/INDEX.md

□ 2. ASSESS completeness
     - Is context clear?
     - Are acceptance criteria specific and testable?
     - Are technical notes filled?

□ 3. IDENTIFY gaps
     Ask clarifying questions if needed (CREATIVE - use judgment)

□ 4. REFINE content (CREATIVE)
     - Improve acceptance criteria
     - Add technical notes
     - Fill missing sections

□ 5. SET complexity estimate if not set
     XS | S | M | L | XL → estimate: 1-5

□ 6. SET priority if not set
     - Urgent (P1): Blocking launch, critical bug
     - High (P2): Core feature, foundational, unblocks others
     - Medium (P3): Important but not blocking
     - Low (P4): Enhancement, nice-to-have

□ 7. CHECK dependencies
     Ask: "Does this depend on other issues?"
     Ask: "Will completing this unblock other work?"
     Create blocking relationships if needed

□ 8. CALCULATE AI Effort Estimate
     See .docflow/skills/ai-labor-estimate/SKILL.md
     - Identify task type base tokens
     - Score scope, novelty, clarity, codebase
     - Calculate estimate and cost range
     - ADD estimate section to description

□ 9. UPDATE description with all changes
     update_issue({ id: "...", description: "..." })

□ 10. RUN transition script:
      .docflow/scripts/transition-issue.sh [ISSUE-ID] "Todo" \
        "**Refined** — [What improved]. Priority: P[X]. Dependencies: [list or none]. AI Estimate: ~[X]k tokens ($[X]-$[X]). Ready for activation."

□ 11. RESPOND to user
      "Refined [ISSUE-ID]. Priority P[X], estimate [size]. Ready to activate."
```

---

## /activate - Start Work on Issue

### If No Issue Specified → Recommend

```
□ 1. QUERY issues in Todo or Backlog
     Get priority, estimate, blocking relationships

□ 2. FILTER to ready issues
     - Not blocked by incomplete work
     - Not assigned to others

□ 3. RANK by
     Priority (P1 → P4) → Unblocked status → Smaller estimate

□ 4. PRESENT recommendation (CREATIVE)
     Show top pick with reasoning
     Show 2-3 alternatives
     Show blocked issues and blockers

□ 5. WAIT for user selection
```

### When Activating Specific Issue

```
□ 1. READ full issue description

□ 2. CHECK AI Effort Estimate
     Search for "## AI Effort Estimate" section
     
     IF MISSING:
       → Say: "⚠️ Missing AI Effort Estimate."
       → Ask: "Calculate now before activation?"
       → If yes: Run estimation, update description
       → If no: Note limitation, proceed
     
     IF EXCEEDS THRESHOLD (>$5 or >200k tokens):
       → Say: "📊 Larger task: ~[X]k tokens (~$[X]-$[X])"
       → Ask: "Confirm activation?"
       → Wait for explicit "yes"

□ 3. DETERMINE assignee (MANDATORY)
     Try: get_viewer() for current user
     Or ASK: "Who should this be assigned to?"
     ❌ DO NOT proceed without assignee

□ 4. CHECK current assignment
     If assigned to someone else → WARN and confirm

□ 5. CHECK if blocked
     If blocked by incomplete issues → WARN

□ 6. SET priority if not set (ask or infer)

□ 7. SET estimate if not set (ask or infer)

□ 8. RUN activate script:
     .docflow/scripts/activate-issue.sh [ISSUE-ID] [assignee-email] [priority] [estimate]

□ 9. VERIFY activation
     Query issue, confirm:
     - State = "In Progress"
     - Assignee is set

□ 10. RESPOND to user
      "✅ Activated [ISSUE-ID]. Assigned to @[name], P[X], [estimate]. AI Effort: ~[X]k tokens."
```

---

## /review - Code Review

### Execution Checklist

```
□ 1. QUERY issues in "In Review" state

□ 2. LOAD issue
     - Full description
     - All comments (especially implementation notes)
     - {paths.content}/context/standards.md

□ 3. CHECK acceptance criteria
     All must be checked off [x] in description
     If any unchecked → Fail review

□ 4. READ implementation summary comment
     Understand what was built

□ 5. ANALYZE against standards.md (CREATIVE - use judgment)
     - Code organization correct?
     - Naming conventions followed?
     - Error handling appropriate?
     - Tests written?

□ 6. MAKE DECISION

     IF APPROVED:
       □ RUN transition script:
         .docflow/scripts/transition-issue.sh [ISSUE-ID] "QA" \
           "**Code Review Passed** — Standards verified, criteria met. Moving to QA."
       □ RESPOND: "Code review passed for [ISSUE-ID]. Ready for QE testing."

     IF CHANGES NEEDED:
       □ RUN transition script:
         .docflow/scripts/transition-issue.sh [ISSUE-ID] "In Progress" \
           "**Code Review: Changes Needed** —\n\n**Issues Found:**\n1. [issue]\n2. [issue]\n\nMoving back to In Progress."
       □ RESPOND: "Code review found issues for [ISSUE-ID]. See comment for details."
```

---

## /close - Archive Completed Work

### Execution Checklist

```
□ 1. VERIFY QE approval
     Check for "**QE Approved**" comment
     If not present → Cannot close

□ 2. RECORD AI Effort Actuals
     Read AI Effort Estimate section
     Fill in:
     - Actual Tokens: [estimate from activity]
     - Variance: [+/-X]%
     - Notes: [variance drivers]
     Update description with actuals

□ 3. DETERMINE terminal state
     Default: Done
     Or: Archived, Canceled, Duplicate (if specified)

□ 4. RUN transition script:
     .docflow/scripts/transition-issue.sh [ISSUE-ID] "Done" \
       "✅ **Closed** — Verified and complete. Final AI Effort: ~[X]k tokens ([+/-X]% from estimate)."

□ 5. RESPOND to user
     "Closed [ISSUE-ID]. Final AI effort: ~[X]k tokens."
```

### For Archive/Cancel/Duplicate

```
□ 1. CONFIRM reason with user

□ 2. RUN transition script with appropriate state and comment:
     
     Archive:
       "**Archived** — Deferred to future. Reason: [reason]."
     
     Cancel:
       "**Canceled** — Will not pursue. Reason: [reason]."
     
     Duplicate:
       "**Duplicate** — Already exists as [ISSUE-ID]."

□ 3. RESPOND to user
```

---

## /wrap-session - End Session

### Execution Checklist (MANDATORY PROJECT UPDATE)

```
□ 1. GATHER session data
     Query Linear for issues touched today:
     - Completed issues
     - In-progress issues
     - Blocked issues

□ 2. COMPOSE summary (CREATIVE - make it informative)
     Use template from always.md:
     
     **Session Summary — [YYYY-MM-DD]**
     
     ✅ **Completed:**
     - [ISSUE-ID] — [What was done]
     
     🔄 **In Progress:**
     - [ISSUE-ID] — [Current state]
     
     📋 **Next Up:**
     - [ISSUE-ID] — [Priority for next session]
     
     🚧 **Blockers:** [None / List]

□ 3. DETERMINE health status
     onTrack | atRisk | offTrack

□ 4. EXECUTE wrap script (DO NOT just describe it):
     .docflow/scripts/wrap-session.sh "[SUMMARY]" "[HEALTH]"

□ 5. VERIFY response includes URL
     If script fails → Report error, do not skip

□ 6. RESPOND to user
     "Session wrapped! Project update posted: [URL]"
```

**❌ DO NOT:**
- Skip posting if user seems rushed
- Summarize in chat without POSTing
- Say "I would post..." — EXECUTE the script

---

## /sync-project - Sync Context to Linear

### Execution Checklist

```
□ 1. CHECK existing project description
     Query Linear project via MCP

□ 2. IF description exists
     Ask: "Project has existing description. Overwrite?"
     Wait for confirmation

□ 3. READ context files
     - {paths.content}/context/overview.md
     - {paths.content}/context/stack.md
     - {paths.content}/context/standards.md

□ 4. GENERATE description (CREATIVE)
     Short summary (≤255 chars) for Linear project summary
     Full markdown description for Linear project description

□ 5. UPDATE Linear project
     update_project({ id: "...", description: "..." })

□ 6. RESPOND to user
     "Project synced to Linear."
```

---

## Context Loading

| Task | Load These |
|------|------------|
| Planning | overview.md, query Linear for backlog |
| Refining | overview.md, knowledge/INDEX.md, issue being refined |
| Reviewing | standards.md, issue being reviewed, implementation comments |
| Closing | Issue being closed, AI Estimate section |

---

## Natural Language Triggers

| Phrase | Command |
|--------|---------|
| "capture that" / "add to backlog" | /capture |
| "refine [issue]" / "triage" | /refine |
| "what needs triage" | Show triage queue |
| "activate [issue]" | /activate (specific) |
| "what should I work on?" | /activate (recommend) |
| "review [issue]" | /review |
| "close [issue]" | /close (Done) |
| "archive" / "defer" | /close (Archived) |
| "cancel" / "won't do" | /close (Canceled) |
| "wrap up" / "end of day" | /wrap-session |
| "sync project" | /sync-project |

---

## Documentation Rules

### When to Create Knowledge Base Entries (CREATIVE - use judgment)

**Add to `{paths.content}/knowledge/` when:**
- Architectural decision made → `decisions/`
- Non-obvious solution discovered → `notes/`
- Complex feature needs explanation → `features/`

**Update `{paths.content}/context/` when:**
- New technology added → `stack.md`
- New convention established → `standards.md`
- Scope changes → `overview.md`

### After Adding Documentation

```
□ 1. ADD entry to {paths.content}/knowledge/INDEX.md
     Format: | [Title](path) | Description | Date |
```
