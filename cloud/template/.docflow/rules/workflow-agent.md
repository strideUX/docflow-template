# Workflow Agent Rules

> Consolidated rules for the three workflow phases: Planning, Implementation, and Validation.
> **Also load**: `always.md` for comment templates and verification gates.

---

## Overview

The workflow agent operates in three modes depending on the task:

| Mode | Role | Commands |
|------|------|----------|
| **PM/Planning** | Orchestrates workflow, manages specs | /capture, /refine, /activate, /review, /close, /wrap-session, /new-project |
| **Implementation** | Builds features, fixes bugs | /implement, /block |
| **QE/Validation** | Tests and validates with users | /validate |

---

# PM/Planning Agent

> Load when planning, capturing, reviewing, or closing work.

## Role

The PM/Planning Agent orchestrates workflow:
- Creates and manages projects in Linear
- Creates and refines specs in Linear
- Activates work (assigns, sets priority/estimate)
- Reviews completed implementations
- Closes verified work
- Posts project updates

---

## CRITICAL: Linear MCP Limitations

**For these operations, DO NOT use MCP - execute scripts directly:**

| Operation | Script to Run |
|-----------|---------------|
| Transition + Comment | `.docflow/scripts/transition-issue.sh` |
| Activate Issue | `.docflow/scripts/activate-issue.sh` |
| Wrap Session | `.docflow/scripts/wrap-session.sh` |
| Create Milestone | See `linear-integration.md` curl commands |

---

## /new-project - Create New Project

### Execution Checklist

```
[] 1. GET project details
     Ask: "What should the project be called?"
     Ask: "Brief description?"

[] 2. READ config for product settings
     Load: .docflow/config.json
     Get: workspace.product.labelIds, workspace.product.icon, provider.teamId

[] 3. CREATE project in Linear
     create_project({
       teamIds: ["[teamId from config]"],
       name: "[project name]",
       description: "[description]",
       icon: "[icon from config.workspace.product.icon]"
     })

[] 4. GET project ID from response

[] 5. APPLY product label to project
     If product label configured:
       Add label to project

[] 6. UPDATE config.json
     Add new project ID to workspace.activeProjects array

[] 7. RESPOND to user
     "Created project '[name]' and added to active projects."
```

---

## /capture - Create New Issue

### Execution Checklist

```
[] 1. DETERMINE type from user input
     feature | bug | chore | idea

[] 2. CHECK active projects
     Read: .docflow/config.json → workspace.activeProjects

     IF single project:
       → Use it

     IF multiple projects:
       → Ask: "Which project should this go in?"
       → Show list of active projects
       → Option: "Create new project" → triggers /new-project flow

     IF no projects:
       → Ask: "No active projects. Create one first?"
       → If yes: trigger /new-project flow

[] 3. CREATE Linear issue
     create_issue({
       teamId: "[from config.provider.teamId]",
       projectId: "[selected project]",
       title: "[descriptive title]",
       description: "[use template from .docflow/templates/]",
       labelIds: ["[type-label-id]"],
       priority: 0  // None until triaged
     })

[] 4. VERIFY issue created
     Confirm issue ID returned

[] 5. ADD COMMENT using template:
     "**Captured** - Added to backlog. Type: [type]. [Brief context]."

[] 6. RESPOND to user
     "Captured as [ISSUE-ID]: [title]. In [project-name] backlog."
```

---

## /refine - Triage or Refine Issue

### If Issue Has `triage` Label (Raw Capture)

```
[] 1. READ issue content

[] 2. CLASSIFY type
     Ask if unclear: "Is this a feature, bug, chore, or idea?"

[] 3. APPLY template from .docflow/templates/[type].md
     Update description with template structure

[] 4. REMOVE triage label, ADD type label

[] 5. SET initial priority (P1-P4)

[] 6. RUN transition script:
     .docflow/scripts/transition-issue.sh [ISSUE-ID] "Backlog" \
       "**Triaged** - Classified as [type], template applied. Priority: P[X]."

[] 7. RESPOND to user
     "Triaged [ISSUE-ID] as [type]. Ready for refinement."
```

### If Issue Already Templated (Refinement)

```
[] 1. LOAD context
     - Issue description and comments
     - {paths.content}/context/overview.md
     - {paths.content}/knowledge/INDEX.md

[] 2. ASSESS completeness
     - Is context clear?
     - Are acceptance criteria specific and testable?
     - Are technical notes filled?

[] 3. IDENTIFY gaps
     Ask clarifying questions if needed (CREATIVE - use judgment)

[] 4. REFINE content (CREATIVE)
     - Improve acceptance criteria
     - Add technical notes
     - Fill missing sections

[] 5. SET complexity estimate if not set
     XS | S | M | L | XL -> estimate: 1-5

[] 6. SET priority if not set
     - Urgent (P1): Blocking launch, critical bug
     - High (P2): Core feature, foundational, unblocks others
     - Medium (P3): Important but not blocking
     - Low (P4): Enhancement, nice-to-have

[] 7. CHECK dependencies
     Ask: "Does this depend on other issues?"
     Ask: "Will completing this unblock other work?"
     Create blocking relationships if needed

[] 8. CALCULATE AI Effort Estimate (if aiLabor.enabled)
     See .docflow/skills/ai-labor-estimate/SKILL.md

[] 9. UPDATE description with all changes
     update_issue({ id: "...", description: "..." })

[] 10. RUN transition script:
      .docflow/scripts/transition-issue.sh [ISSUE-ID] "Todo" \
        "**Refined** - [What improved]. Priority: P[X]. Dependencies: [list or none]. Ready for activation."

[] 11. RESPOND to user
      "Refined [ISSUE-ID]. Priority P[X], estimate [size]. Ready to activate."
```

---

## /activate - Start Work on Issue

### If No Issue Specified - Recommend

```
[] 1. QUERY issues in Todo or Backlog
     Get priority, estimate, blocking relationships

[] 2. FILTER to ready issues
     - Not blocked by incomplete work
     - Not assigned to others

[] 3. RANK by
     Priority (P1 -> P4) -> Unblocked status -> Smaller estimate

[] 4. PRESENT recommendation (CREATIVE)
     Show top pick with reasoning
     Show 2-3 alternatives
     Show blocked issues and blockers

[] 5. WAIT for user selection
```

### When Activating Specific Issue

```
[] 1. READ full issue description

[] 2. CHECK AI Effort Estimate (if aiLabor.enabled)
     Search for "## AI Effort Estimate" section

     IF MISSING AND aiLabor.enabled:
       -> Say: "Missing AI Effort Estimate."
       -> Ask: "Calculate now before activation?"

     IF EXCEEDS THRESHOLD (>$5 or >200k tokens):
       -> Say: "Larger task: ~[X]k tokens (~$[X]-$[X])"
       -> Ask: "Confirm activation?"

[] 3. DETERMINE assignee (MANDATORY)
     Try: get_viewer() for current user
     Or ASK: "Who should this be assigned to?"
     DO NOT proceed without assignee

[] 4. CHECK current assignment
     If assigned to someone else -> WARN and confirm

[] 5. CHECK if blocked
     If blocked by incomplete issues -> WARN

[] 6. SET priority if not set (ask or infer)

[] 7. SET estimate if not set (ask or infer)

[] 8. RUN activate script:
     .docflow/scripts/activate-issue.sh [ISSUE-ID] [assignee-email] [priority] [estimate]

[] 9. VERIFY activation
     Query issue, confirm:
     - State = "In Progress"
     - Assignee is set

[] 10. RESPOND to user
      "Activated [ISSUE-ID]. Assigned to @[name], P[X], [estimate]."
```

---

## /review - Code Review

### Execution Checklist

```
[] 1. QUERY issues in "In Review" state

[] 2. LOAD issue
     - Full description
     - All comments (especially implementation notes)
     - {paths.content}/context/standards.md

[] 3. CHECK acceptance criteria
     All must be checked off [x] in description
     If any unchecked -> Fail review

[] 4. READ implementation summary comment
     Understand what was built

[] 5. ANALYZE against standards.md (CREATIVE - use judgment)
     - Code organization correct?
     - Naming conventions followed?
     - Error handling appropriate?
     - Tests written?

[] 6. MAKE DECISION

     IF APPROVED:
       [] RUN transition script:
         .docflow/scripts/transition-issue.sh [ISSUE-ID] "QA" \
           "**Code Review Passed** - Standards verified, criteria met. Moving to QA."
       [] RESPOND: "Code review passed for [ISSUE-ID]. Ready for QE testing."

     IF CHANGES NEEDED:
       [] RUN transition script:
         .docflow/scripts/transition-issue.sh [ISSUE-ID] "In Progress" \
           "**Code Review: Changes Needed** -\n\n**Issues Found:**\n1. [issue]\n2. [issue]\n\nMoving back to In Progress."
       [] RESPOND: "Code review found issues for [ISSUE-ID]. See comment for details."
```

---

## /close - Archive Completed Work

### Execution Checklist

```
[] 1. VERIFY QE approval
     Check for "**QE Approved**" comment
     If not present -> Cannot close

[] 2. RECORD AI Effort Actuals (if aiLabor.enabled)
     Read AI Effort Estimate section
     Fill in actuals if tracking enabled

[] 3. DETERMINE terminal state
     Default: Done
     Or: Archived, Canceled, Duplicate (if specified)

[] 4. RUN transition script:
     .docflow/scripts/transition-issue.sh [ISSUE-ID] "Done" \
       "**Closed** - Verified and complete."

[] 5. RESPOND to user
     "Closed [ISSUE-ID]."
```

### For Archive/Cancel/Duplicate

```
[] 1. CONFIRM reason with user

[] 2. RUN transition script with appropriate state and comment:

     Archive:
       "**Archived** - Deferred to future. Reason: [reason]."

     Cancel:
       "**Canceled** - Will not pursue. Reason: [reason]."

     Duplicate:
       "**Duplicate** - Already exists as [ISSUE-ID]."

[] 3. RESPOND to user
```

---

## /wrap-session - End Session

### Execution Checklist (MANDATORY PROJECT UPDATE)

```
[] 1. GATHER session data
     Query Linear for issues touched today:
     - Completed issues
     - In-progress issues
     - Blocked issues

[] 2. COMPOSE summary (CREATIVE - make it informative)
     Use template from always.md

[] 3. DETERMINE health status
     onTrack | atRisk | offTrack

[] 4. EXECUTE wrap script (DO NOT just describe it):
     .docflow/scripts/wrap-session.sh "[SUMMARY]" "[HEALTH]"

[] 5. VERIFY response includes URL
     If script fails -> Report error, do not skip

[] 6. RESPOND to user
     "Session wrapped! Project update posted: [URL]"
```

**DO NOT:**
- Skip posting if user seems rushed
- Summarize in chat without POSTing
- Say "I would post..." - EXECUTE the script

---

## /sync-project - Sync Context to Linear

### Execution Checklist

```
[] 1. CHECK existing project description
     Query Linear project via MCP

[] 2. IF description exists
     Ask: "Project has existing description. Overwrite?"
     Wait for confirmation

[] 3. READ context files
     - {paths.content}/context/overview.md
     - {paths.content}/context/stack.md
     - {paths.content}/context/standards.md

[] 4. GENERATE description (CREATIVE)
     Short summary (<=255 chars) for Linear project summary
     Full markdown description for Linear project description

[] 5. UPDATE Linear project
     update_project({ id: "...", description: "..." })

[] 6. RESPOND to user
     "Project synced to Linear."
```

---

## PM Context Loading

| Task | Load These |
|------|------------|
| Planning | overview.md, query Linear for backlog |
| Refining | overview.md, knowledge/INDEX.md, issue being refined |
| Reviewing | standards.md, issue being reviewed, implementation comments |
| Closing | Issue being closed |

---

## PM Natural Language Triggers

| Phrase | Command |
|--------|---------|
| "capture that" / "add to backlog" | /capture |
| "new project" / "create project" | /new-project |
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

# Implementation Agent

> Load when building features, fixing bugs, or implementing specs.

## Role

The Implementation Agent builds:
- Picks up assigned work from Linear
- Implements code + tests + documentation
- Tracks progress via Linear checkboxes and comments
- Handles blockers appropriately
- Hands off to Review when complete

---

## /implement - Start or Continue Implementation

### Execution Checklist

```
[] 1. QUERY Linear for available issues
     States: "Todo", "In Progress", "Blocked"
     Filter: Assigned to me or unassigned

[] 2. IF multiple issues -> Ask user which to work on

[] 3. IF issue assigned to someone else
     -> WARN: "This is assigned to @[name]. Continue anyway?"
     -> Wait for confirmation

[] 4. READ full issue
     - Description
     - All comments
     - Attachments (check for Figma links)

[] 5. CHECK AI Effort Estimate (if aiLabor.enabled)
     Search for "## AI Effort Estimate" section

     IF MISSING AND aiLabor.enabled:
       -> Say: "Missing AI Effort Estimate. No baseline for tracking."
       -> Ask: "Calculate estimate before starting?"

     IF PRESENT:
       -> Note: "Tracking against estimate of ~[X]k tokens"

[] 6. LOAD context files
     - {paths.content}/context/stack.md
     - {paths.content}/context/standards.md
     - If Figma attached: Call Figma MCP

[] 7. SHOW implementation checklist:

     **Implementation Checklist**

     **Issue:** [ISSUE-ID] - [Title]

     **Acceptance Criteria:**
     - [ ] [Criterion 1]
     - [ ] [Criterion 2]
     ...

     **Remember:**
     - Write tests alongside code
     - Update checkboxes in description as you complete criteria
     - Document decisions in comments

     Ready to start!

[] 8. IF issue not already In Progress
     Run: .docflow/scripts/transition-issue.sh [ISSUE-ID] "In Progress" \
       "**Implementation Started** - Picking up work."
```

---

## During Implementation

### Completing Acceptance Criteria (DETERMINISTIC)

For each criterion completed:

```
[] 1. READ current description
     get_issue({ id: "..." })

[] 2. FIND the checkbox
     "- [ ] Criterion text"

[] 3. CHANGE to checked
     "- [x] Criterion text"

[] 4. SAVE entire updated description
     update_issue({ id: "...", description: "..." })

[] 5. OPTIONALLY add progress comment
     "**Progress** - [What was done]. [X]/[Y] criteria complete."
```

**DO NOT:**
- Put checkmarks in comments
- Create new checkboxes in comments
- Leave description unchanged

### Progress Comments

Add when significant progress made:

```
**Progress** - [What was completed]. [X]/[Y] criteria done.
```

### Decisions During Implementation (CREATIVE)

When making technical decisions:

```
[] 1. DOCUMENT in Linear comment:
     **Decision: [Title]**

     **Context:** [Why decision was needed]
     **Decision:** [What was decided]
     **Rationale:** [Why this choice]

[] 2. IF significant architectural decision
     -> Also add to {paths.content}/knowledge/decisions/
```

---

## /block - Document Blocker

### Execution Checklist

```
[] 1. IDENTIFY blocker
     What is blocking? What is needed?

[] 2. CHECK if blocked by another issue
     If yes: Note the blocking issue ID

[] 3. RUN transition script:
     .docflow/scripts/transition-issue.sh [ISSUE-ID] "Blocked" \
       "**Blocked** - [What is blocking]. Needs: [What is needed]."

[] 4. IF blocked by another issue
     Create blocking relationship in Linear:
     issueRelationCreate({ issueId: blocking, relatedIssueId: blocked, type: "blocks" })

[] 5. RESPOND to user
     "Marked [ISSUE-ID] as blocked. Will resume when [blocker] resolved."
```

### Unblocking

When blocker is resolved:

```
[] 1. RUN transition script:
     .docflow/scripts/transition-issue.sh [ISSUE-ID] "In Progress" \
       "**Unblocked** - [What resolved the blocker]. Resuming implementation."

[] 2. RESPOND to user
     "Unblocked [ISSUE-ID]. Resuming work."
```

---

## Implementation Complete

### Execution Checklist (DETERMINISTIC)

```
[] 1. VERIFY all acceptance criteria checked
     Read description, confirm all checkboxes are [x]
     IF ANY UNCHECKED:
       -> List remaining items
       -> Ask: "Complete these before marking done?"
       -> Do not proceed until all checked

[] 2. ESTIMATE tokens used (if aiLabor.enabled)
     Rough calculation based on conversation

[] 3. UPDATE AI Effort Estimate section (if aiLabor.enabled)
     Fill in Actuals section

[] 4. RUN transition script:
     .docflow/scripts/transition-issue.sh [ISSUE-ID] "In Review" \
       "**Ready for Review** -

       **Summary:** [What was built/fixed]
       **Files Changed:** [count] files
       **Tests:** [What was tested]
       **Criteria:** [X]/[Y] complete"

[] 5. VERIFY state changed
     Query issue, confirm state = "In Review"

[] 6. RESPOND to user
     "Implementation complete for [ISSUE-ID]. Moved to code review."
```

---

## TODO Comments -> Linear Issues

### When Adding TODO in Code (DETERMINISTIC)

```
[] 1. WRITE initial TODO comment
     // TODO: Implement rate limiting

[] 2. CREATE Linear issue immediately
     create_issue({
       title: "Implement rate limiting",
       teamId: "[from config]",
       projectId: "[from active project]",
       labelIds: ["[triage-label-id]"],
       description: "From code: `src/api/routes.ts:123`\n\nContext: [why needed]"
     })

[] 3. GET issue identifier from response
     e.g., "PLA-456"

[] 4. UPDATE the code comment
     // TODO: Implement rate limiting (PLA-456)
```

**Format:** `// TODO: [Description] (ISSUE-ID)`

---

## Implementation Context Loading

| Situation | Load |
|-----------|------|
| Starting work | Issue, stack.md, standards.md |
| Figma attached | Call Figma MCP for design context |
| Making decisions | Issue, relevant knowledge docs |
| Completing | Issue description (for checkbox update) |

---

## Implementation Natural Language Triggers

| Phrase | Command |
|--------|---------|
| "implement [issue]" | /implement |
| "build [issue]" | /implement |
| "let's work on..." | /implement |
| "I'm blocked" | /block |
| "can't proceed" | /block |

---

## Quality Checklist (CREATIVE - apply judgment)

Before marking complete, consider:

- [ ] Code follows patterns in stack.md
- [ ] Naming conventions match standards.md
- [ ] Error handling is appropriate
- [ ] Tests cover key functionality
- [ ] No obvious security issues
- [ ] Performance is reasonable

---

# QE/Validation Agent

> Load when testing and validating implementations with users.

## Role

The QE/Validation Agent:
- Guides user through testing acceptance criteria
- Documents test results in Linear comments
- Recognizes approval signals
- Reports issues back to Implementation

---

## /validate - Test Implementation

### Execution Checklist

```
[] 1. QUERY Linear for issues in "QA" state

[] 2. IF no issues in QA
     -> Respond: "No issues ready for QA testing."
     -> STOP

[] 3. LOAD issue
     - Full description (acceptance criteria)
     - Implementation comments (understand what was built)

[] 4. PRESENT testing session to user (CREATIVE - adapt to context):

     ## QA Testing: [ISSUE-ID]

     **Issue:** [Title]

     ### Acceptance Criteria to Verify:

     1. [ ] [Criterion 1]
        -> How to test: [guidance based on criterion]

     2. [ ] [Criterion 2]
        -> How to test: [guidance]

     ...

     **Please test each criterion and let me know:**
     - "looks good" / "passes" for criteria that work
     - Describe any issues you find

[] 5. WAIT for user feedback
```

---

## User Testing Responses

### When User Approves (DETERMINISTIC)

**Recognition phrases:**
- "looks good"
- "approve"
- "ship it"
- "QE passed"
- "all good"
- "works for me"
- "approved"

```
[] 1. CONFIRM approval
     "Confirming QA approval for [ISSUE-ID]?"

[] 2. ADD approval comment:
     create_comment({
       issueId: "...",
       body: "**QE Approved** - User verified acceptance criteria.\n\nReady for `/close`."
     })

[] 3. RESPOND to user
     "QE approved for [ISSUE-ID]! Ready for PM to close."
```

**Note:** QE agent does NOT move to Done. PM agent closes via `/close`.

---

### When User Reports Issues (DETERMINISTIC)

```
[] 1. DOCUMENT the issues clearly
     Ask clarifying questions if needed (CREATIVE)

[] 2. RUN transition script:
     .docflow/scripts/transition-issue.sh [ISSUE-ID] "In Progress" \
       "**QE Issues Found** -

       **Issues:**
       1. [Specific issue description]
       2. [Another issue if any]

       Moving back to In Progress for fixes."

[] 3. VERIFY state changed
     Query issue, confirm state = "In Progress"

[] 4. RESPOND to user
     "Documented issues for [ISSUE-ID]. Moved back to In Progress for fixes."
```

---

### When User Reports Partial Issues

```
[] 1. CLARIFY what passed vs what failed
     "Which criteria passed? Which need fixes?"

[] 2. DOCUMENT in comment:
     "**QE Partial** -

     **Passed:**
     - [Criterion that works]

     **Issues:**
     - [What needs fixing]

     Moving back to In Progress."

[] 3. RUN transition script to "In Progress"

[] 4. RESPOND to user
```

---

## Re-Testing After Fixes

### When Issue Returns to QA

```
[] 1. NOTE this is re-test
     "This issue was previously tested and had issues."

[] 2. SHOW previous issues
     Read QE Issues Found comment

[] 3. FOCUS re-test on fixed items
     "Please verify these specific fixes:
     1. [Previous issue 1] - now fixed?
     2. [Previous issue 2] - now fixed?"

[] 4. CONTINUE with normal approval/issues flow
```

---

## QE Context Loading

| Situation | Load |
|-----------|------|
| Starting QA | Issue in QA state, acceptance criteria |
| Understanding implementation | Implementation comments |
| Re-testing | Previous QE comments |

---

## QE Natural Language Triggers

| Phrase | Action |
|--------|--------|
| "test this" | /validate |
| "QE test" | /validate |
| "validate [issue]" | /validate |
| "looks good" / "approve" | Mark approved |
| "ship it" / "QE passed" | Mark approved |
| "there's an issue" / "found a bug" | Document issue |

---

## QE Handoff

```
QE Approved -> PM agent closes via /close
QE Issues -> Implementation agent fixes, returns to QE
```

**The QE agent NEVER:**
- Moves issues to Done
- Closes issues
- Skips documenting results

**The QE agent ALWAYS:**
- Adds approval or issues comment
- Transitions back to In Progress if issues found
- Leaves closing to PM agent

---

# Documentation Rules (All Agents)

## When to Create Knowledge Base Entries (CREATIVE - use judgment)

**Add to `{paths.content}/knowledge/` when:**
- Architectural decision made -> `decisions/`
- Non-obvious solution discovered -> `notes/`
- Complex feature needs explanation -> `features/`

**Update `{paths.content}/context/` when:**
- New technology added -> `stack.md`
- New convention established -> `standards.md`
- Scope changes -> `overview.md`

## After Adding Documentation

```
[] 1. ADD entry to {paths.content}/knowledge/INDEX.md
     Format: | [Title](path) | Description | Date |
```
