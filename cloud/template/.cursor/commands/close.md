# Close (PM/Planning Agent)

## Overview
Archive completed work by moving Linear issue to Done state.

**Agent Role:** PM/Planning Agent (orchestrator)  
**Frequency:** After QE testing is approved

---

## Steps

### 1. **Find Issue to Close**

**If user specified issue (LIN-XXX):**
- Query that specific issue from Linear

**If not specified:**
- Query Linear for issues in QA state that have been approved
- Look for approval comments
- Ask user which to close if multiple

### 2. **Verify Issue is Ready to Close**

Check:
- Status is QA or has been through QA
- Has approval comment from user
- All acceptance criteria marked complete

**If not ready:**
```markdown
⚠️ LIN-XXX may not be ready to close:

**Current Status:** [status]
**QE Approval:** Not found

Are you sure you want to close this? Options:
1. Close anyway
2. Run `/validate LIN-XXX` first
3. Cancel
```

### 3. **Update Linear Issue**

```typescript
updateIssue(issueId, {
  stateId: config.linear.states.COMPLETE  // Done state
})

addComment(issueId, {
  body: '**Complete** — Verified and closed.'
})
```

### 4. **Confirmation**

```markdown
🎉 Closed!

**Issue:** LIN-XXX
**Title:** [Title]
**Status:** Done ✓

[View in Linear](issue-url)

**Summary:**
- Implemented: [date]
- Reviewed: [date]
- Approved: [date]
- Closed: [today]

What's next? Run `/status` to see remaining work.
```

---

## Closing Multiple Issues

```
User: "close all approved issues"

Agent: Found 2 approved issues in QA...

✅ LIN-101: [Title] → Done
✅ LIN-102: [Title] → Done

Both issues archived. Great work! 🎉
```

---

## Context to Load
- `.docflow.json` (Linear config)
- Target issue from Linear
- Issue comments (verify approval)

---

## Natural Language Triggers
User might say:
- "close [issue]" / "archive [issue]"
- "mark complete" / "this is done"
- "finalize [issue]"
- "wrap up [issue]"

**Run this command when detected.**

---

## Outputs
- Issue status → Done/Complete
- Closing comment added
- Confirmation provided
- Issue archived in Linear

---

## Checklist
- [ ] Found issue to close
- [ ] Verified QE approval exists
- [ ] Updated Linear status to Done
- [ ] Added closing comment
- [ ] Provided confirmation
- [ ] Suggested next actions

