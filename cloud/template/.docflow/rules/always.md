# ALWAYS Rules (Deterministic - No Exceptions)

> **Load with core.md on every interaction.**
> These rules are mechanical and must be followed exactly every time.

---

## Golden Rules

1. **Product scope filtering** — Only show projects/issues matching `workspace.product.labelIds`
2. **Every status transition gets a comment** — No silent state changes
3. **Assignment before In Progress** — No unassigned work in progress
4. **Project update on wrap** — Every session ends with a POST to Linear
5. **Checkboxes in description** — Never put completion checkmarks in comments

---

## Product Scope Protocol

### ALWAYS Filter by Product Labels — HARD GATE

**This is non-negotiable. Every project list MUST be filtered.**

When showing projects to the user, a project is ONLY visible if it has **ALL** labels from `workspace.product.labelIds`.

**Example:** If config has `labelIds: ["StrideApp-uuid", "Internal-uuid"]`:
- ✅ Show: Project with labels [StrideApp, Internal]
- ❌ Hide: Project with labels [StrideApp] only (missing Internal)
- ❌ Hide: Project with labels [QoL] (wrong product)
- ❌ Hide: Project with labels [Cook] (wrong product)
- ❌ Hide: Project with no labels

### Filtering Steps (MUST FOLLOW)

```
□ 1. READ config to get labelIds array
     labelIds = workspace.product.labelIds (e.g., ["uuid1", "uuid2"])

□ 2. QUERY projects from team (MCP or API)
     Response includes ALL team projects

□ 3. CLIENT-SIDE FILTER — REQUIRED
     For each project:
       - Get project's label IDs (from projectLabels)
       - Check: Does project have ALL IDs from config labelIds?
       - If ANY labelId is missing → EXCLUDE project

     Example filter logic:
       configLabelIds = ["30023a7a-...", "e8a0851a-..."]
       projectLabelIds = project.projectLabels.map(l => l.id)
       isVisible = configLabelIds.every(id => projectLabelIds.includes(id))

□ 4. CATEGORIZE filtered projects
     Active = in workspace.activeProjects array
     Available = matches ALL labels but not in activeProjects

□ 5. QUERY issues from Active projects ONLY
```

### DO NOT (Hard Rules)

- ❌ **NEVER** show projects that don't have ALL labelIds — even if user asks
- ❌ **NEVER** skip the client-side filter step
- ❌ **NEVER** show QoL, Cook, FlyDocs, etc. if they don't match labelIds
- ❌ **NEVER** query issues from non-active projects

### When User Asks About "Other Projects"

Only show projects matching ALL labelIds. If user asks about projects outside scope:
```
"I can only show projects within the StrideApp + Internal scope.
The available projects matching this criteria are: [filtered list]"
```

---

## Status Transition Protocol

### ALWAYS Do These Steps (In Order)

For ANY status change, execute these steps in sequence:

```
□ 1. CHANGE STATE via Linear MCP
     update_issue({ id: "...", stateId: "..." })

□ 2. ADD COMMENT using exact template (see below)
     create_comment({ issueId: "...", body: "..." })

□ 3. VERIFY the change
     Query issue, confirm state changed

□ 4. RESPOND to user with confirmation
```

**DO NOT:**
- ❌ Skip the comment
- ❌ Add comment before state change (comment should reflect new state)
- ❌ Respond to user before verifying the change
- ❌ Summarize what you "will do" — actually do it, then confirm

---

## Comment Templates (Use Exactly)

Copy these templates exactly. Fill in bracketed values.

### Capture
```
**Captured** — [Brief description of what was captured]. Type: [feature/bug/chore/idea].
```

### Triage
```
**Triaged** — Classified as [type]. Priority: P[1-4]. [Any initial observations].
```

### Refine
```
**Refined** — [What was clarified or improved]. Priority: P[1-4]. Dependencies: [list or none].
```

### Activate
```
**Activated** — Assigned to @[name]. Estimate: [XS/S/M/L/XL]. Starting implementation.
```

### Progress (during implementation)
```
**Progress** — [What was completed]. Criteria: [X]/[Y] done.
```

### Blocked
```
**Blocked** — [What is blocking progress].
**Needs:** [Specific action or decision required to unblock].
```

### Unblocked
```
**Unblocked** — [How it was resolved]. Resuming work.
```

### Implementation Complete
```
**Ready for Review** —

**What changed:** [Brief summary of implementation]
**Files:** [count] modified
**Testing:** [How it was verified]
**Criteria:** [X]/[Y] complete
```

### Code Review Pass
```
**Code Review Passed** — Implementation meets standards. Moving to QA.
```

### Code Review Fail
```
**Code Review: Changes Needed** —

1. [Issue and suggested fix]
2. [Issue and suggested fix]

Returning to implementation.
```

### QE Approval
```
**QE Approved** — Acceptance criteria verified by user. Ready for close.
```

### QE Issues
```
**QE: Issues Found** —

1. [What failed or didn't meet expectations]
2. [What failed or didn't meet expectations]

Returning to implementation.
```

### Close
```
✅ **Closed** — [One-line summary of what was delivered].
```

### Archive/Cancel/Duplicate
```
**Archived** — Deferring. Reason: [why not now].
```
```
**Canceled** — Not pursuing. Reason: [why].
```
```
**Duplicate** — See [ISSUE-ID].
```

---

## Wrap Session Protocol

### ALWAYS Post Project Update

When user wraps session, you MUST:

```
□ 1. GATHER session data from Linear
     Query issues touched, completed, blocked

□ 2. COMPOSE summary using template below

□ 3. EXECUTE wrap script (DO NOT just describe it)
     Run: .docflow/scripts/wrap-session.sh "[SUMMARY]" "[HEALTH]"

□ 4. VERIFY the response includes project update URL

□ 5. SHARE the URL with user
     "Session wrapped! Project update posted: [URL]"
```

**DO NOT:**
- ❌ Just summarize in chat without POSTing
- ❌ Say "I would post..." — actually POST
- ❌ Skip if user seems in a hurry

### Session Summary Template

```markdown
**Session Summary — [YYYY-MM-DD]**

✅ **Completed:**
- [ISSUE-ID] — [What was done]

🔄 **In Progress:**
- [ISSUE-ID] — [Current state, what's next]

📋 **Next Up:**
- [ISSUE-ID] — [Why this is next]

🚧 **Blockers:** [None / List with details]
```

### Health Status

| Status | When to Use |
|--------|-------------|
| `onTrack` | Progress made, no blockers |
| `atRisk` | Minor delays, attention needed |
| `offTrack` | Major blockers, behind schedule |

---

## Activate Protocol

### ALWAYS Assign Before Starting Work

**This is a hard gate. No exceptions.**

An issue CANNOT move to In Progress without an assignee. This is fundamental to accountability.

```
□ 1. GET ASSIGNEE (mandatory — STOP here if unclear)
     → Call get_viewer() to get current user ID
     → This MUST return a valid user ID
     → If it fails: ASK "Who should this be assigned to?"
     → DO NOT proceed to step 2 without a confirmed assignee ID

□ 2. ASSIGN ISSUE FIRST (before any state change)
     update_issue({ id: "...", assigneeId: "[USER_ID]" })
     → Use the actual user ID from step 1
     → Not a name, not a placeholder — the real ID

□ 3. VERIFY ASSIGNMENT (before any state change)
     → Query the issue: get_issue({ id: "..." })
     → Check: Is assignee field now populated?
     → If NOT assigned: STOP, retry step 2
     → DO NOT proceed until assignment is confirmed

□ 4. CHANGE STATE to In Progress (only after assignment verified)
     update_issue({ id: "...", stateId: "..." })

□ 5. ADD COMMENT using Activate template

□ 6. CONFIRM to user with issue link
```

**The sequence matters:** Assign → Verify → Then change state.

**If assignment fails:** Do NOT change state. Report the error and retry.

---

## Implement Protocol

### ALWAYS On Pickup

```
□ 1. READ full issue including description

□ 2. SHOW implementation checklist:
     "📋 Implementation Checklist
      Estimate: [XS-XL]
      Criteria: [list acceptance criteria]
      ..."
```

---

## Checkbox Protocol

### ALWAYS Update Description, Not Comments

When completing acceptance criteria:

```
□ 1. READ current description via Linear MCP
     get_issue({ id: "..." })

□ 2. FIND the checkbox: `- [ ] Criterion text`

□ 3. CHANGE to checked: `- [x] Criterion text`

□ 4. SAVE entire updated description
     update_issue({ id: "...", description: "..." })

□ 5. OPTIONALLY add brief progress comment
```

**DO NOT:**
- ❌ Add "✅ Done: criterion" as a comment
- ❌ Create new checkboxes in comments
- ❌ Leave description checkboxes unchecked

---

## Script Execution Protocol

### ALWAYS Execute, Don't Describe

When a script is needed:

```
□ 1. RUN the script with proper arguments
     run_terminal_cmd: .docflow/scripts/[script].sh [args]

□ 2. CHECK the output for success/failure

□ 3. REPORT result to user
```

**DO NOT:**
- ❌ Say "you should run this script..."
- ❌ Show the script contents without running
- ❌ Describe what the script would do

---

## Verification Gates

### Before Responding to User After Any Command

Ask yourself:

| Command | Verify Before Responding |
|---------|--------------------------|
| /capture | Issue created? Comment added? |
| /refine | State = Todo? Comment added? Priority set? |
| /activate | **Assignee confirmed?** State = In Progress? Comment added? |
| /implement | Issue loaded? Checklist shown? |
| /block | State = Blocked? Comment added? |
| /review | State = In Review? Comment added? |
| /validate | Approval/issues documented? State updated? |
| /close | State = Done? Comment added? |
| /wrap-session | Project update POSTED? URL received? |

**If any verification fails → FIX before responding.**

---

## Error Recovery

### If Something Fails Mid-Sequence

1. **STOP** — Don't continue to next step
2. **REPORT** — Tell user what failed
3. **RETRY** — Attempt the failed step again
4. **ESCALATE** — If still failing, ask user for help

### Common Failures

| Failure | Recovery |
|---------|----------|
| State change failed | Check stateId is correct, retry |
| Comment failed | Check issueId, retry |
| Assignment failed | Check userId exists, retry |
| Script failed | Check credentials in .env, report error |

---

## Summary: The Non-Negotiables

1. ✅ Status change → Comment → Verify → Respond
2. ✅ Wrap session → POST project update → Share URL
3. ✅ Activate → Assign → Change state → Comment
4. ✅ Checkboxes → Update description, not comments
5. ✅ Scripts → Execute them, don't describe them

