# ALWAYS Rules (Deterministic - No Exceptions)

> **Load with core.md on every interaction.**
> These rules are mechanical and must be followed exactly every time.

---

## Golden Rules

1. **Every status transition gets a comment** — No silent state changes
2. **Assignment before In Progress** — No unassigned work in progress
3. **Project update on wrap** — Every session ends with a POST to Linear
4. **Checkboxes in description** — Never put completion checkmarks in comments

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
**Captured** — Added to backlog. Type: [feature/bug/chore/idea]. [Brief context].
```

### Triage
```
**Triaged** — Classified as [type], template applied. Priority: P[1-4].
```

### Refine
```
**Refined** — [What was improved]. Priority: P[1-4]. Dependencies: [list or none]. Ready for activation.
```

### Activate
```
**Activated** — Assigned to @[name]. Priority: P[1-4]. Estimate: [XS-XL].
```

### Progress (during implementation)
```
**Progress** — [What was completed]. [X]/[Y] criteria done.
```

### Blocked
```
**Blocked** — [What is blocking]. Needs: [What is needed to unblock]. Blocking since: [date].
```

### Unblocked
```
**Unblocked** — [What resolved the blocker]. Resuming implementation.
```

### Implementation Complete
```
**Ready for Review** —

**Summary:** [What was built/fixed]
**Files Changed:** [count] files
**Tests:** [What was tested]
**Docs:** [Updated/N/A]
**Criteria:** [X]/[Y] complete
```

### Code Review Pass
```
**Code Review Passed** — Standards verified, criteria met. Moving to QA.
```

### Code Review Fail
```
**Code Review: Changes Needed** —

**Issues Found:**
1. [Issue 1]
2. [Issue 2]

Moving back to In Progress.
```

### QE Approval
```
**QE Approved** — User verified acceptance criteria. Ready for /close.
```

### QE Issues
```
**QE Issues Found** —

**Issues:**
1. [Issue description]
2. [Issue description]

Moving back to In Progress.
```

### Close
```
✅ **Closed** — Verified and complete.
```

### Archive/Cancel/Duplicate
```
**Archived** — Deferred to future. Reason: [reason].
```
```
**Canceled** — Will not pursue. Reason: [reason].
```
```
**Duplicate** — Already exists as [ISSUE-ID].
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

### ALWAYS Validate Before Activating

```
□ 1. GET ASSIGNEE (mandatory)
     → Try get_viewer() for current user
     → Or ASK: "Who should this be assigned to?"
     → DO NOT proceed without assignee

□ 2. ASSIGN ISSUE
     update_issue({ id: "...", assigneeId: "..." })

□ 3. VERIFY ASSIGNMENT
     Query issue, confirm assignee is set

□ 4. CHANGE STATE to In Progress
     update_issue({ id: "...", stateId: "..." })

□ 5. ADD COMMENT using Activate template

□ 6. CONFIRM to user with issue link
```

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
| /activate | Assignee set? State = In Progress? Comment added? |
| /implement | Issue loaded? Checklist shown? |
| /block | State = Blocked? Comment added? |
| /review | State = QA or In Progress? Comment added? |
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

