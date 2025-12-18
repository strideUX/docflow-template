# Close (PM/Planning Agent)

## Overview
Move a Linear issue to a terminal state. Default is Done (completed work), but also handles Archive, Cancel, and Duplicate.

**Agent Role:** PM/Planning Agent (orchestrator)  
**Frequency:** After QE testing is approved, or when removing items from active workflow

---

## Terminal States

| State | Use When | Comment Format |
|-------|----------|----------------|
| **Done** | Verified and shipped (default) | `**Complete** — Verified and closed.` |
| **Archived** | Deferred to future, not canceled | `**Archived** — [Reason]. May revisit later.` |
| **Canceled** | Decision made not to pursue | `**Canceled** — [Reason].` |
| **Duplicate** | Already exists elsewhere | `**Duplicate** — See LIN-XXX.` |

---

## Steps

### 1. **Find Issue to Close**

**If user specified issue (LIN-XXX):**
- Query that specific issue from Linear

**If not specified:**
- Query Linear for issues in QA state that have been approved
- Look for approval comments
- Ask user which to close if multiple

### 2. **Determine Terminal State**

**Default: Done** (normal completion flow)

**If user indicates alternative:**
- "archive this" / "defer this" → **Archived**
- "cancel this" / "won't do" → **Canceled**
- "duplicate of LIN-XXX" → **Duplicate**

### 3. **Verify (for Done state only)**

For Done state, check:
- Status is QA or has been through QA
- Has approval comment from user
- All acceptance criteria marked complete

**If not ready:**
```markdown
⚠️ LIN-XXX may not be ready to close:

**Current Status:** [status]
**QE Approval:** Not found

Are you sure you want to close this? Options:
1. Close anyway (Done)
2. Archive instead (defer to later)
3. Run `/validate LIN-XXX` first
4. Cancel
```

### 4. **Update Linear Issue**

**For Done:**
```typescript
updateIssue(issueId, { stateId: config.linear.states.COMPLETE })
addComment(issueId, { body: '**Complete** — Verified and closed.' })
```

**For Archived:**
```typescript
updateIssue(issueId, { stateId: config.linear.states.ARCHIVED })
addComment(issueId, { body: '**Archived** — [Reason]. May revisit later.' })
```

**For Canceled:**
```typescript
updateIssue(issueId, { stateId: config.linear.states.CANCELED })
addComment(issueId, { body: '**Canceled** — [Reason].' })
```

**For Duplicate:**
```typescript
updateIssue(issueId, { stateId: config.linear.states.DUPLICATE })
addComment(issueId, { body: '**Duplicate** — See LIN-XXX for the original issue.' })
```

### 5. **Confirmation**

**For Done:**
```markdown
🎉 Closed!

**Issue:** LIN-XXX
**Title:** [Title]
**Status:** Done ✓

[View in Linear](issue-url)

What's next? Run `/status` to see remaining work.
```

**For Archived:**
```markdown
📦 Archived

**Issue:** LIN-XXX
**Title:** [Title]
**Status:** Archived
**Reason:** [Reason]

This issue can be reactivated later if needed.
```

**For Canceled:**
```markdown
❌ Canceled

**Issue:** LIN-XXX
**Title:** [Title]
**Status:** Canceled
**Reason:** [Reason]
```

**For Duplicate:**
```markdown
🔄 Marked as Duplicate

**Issue:** LIN-XXX
**Title:** [Title]
**Status:** Duplicate
**Original:** LIN-YYY

Work will continue on the original issue.
```

---

## Closing Multiple Issues

```
User: "close all approved issues"

Agent: Found 2 approved issues in QA...

✅ LIN-101: [Title] → Done
✅ LIN-102: [Title] → Done

Both issues closed. Great work! 🎉
```

---

## Context to Load
- `.docflow/config.json` (Linear config)
- Target issue from Linear
- Issue comments (verify approval for Done state)

---

## Natural Language Triggers

**For Done (default):**
- "close [issue]" / "mark complete"
- "this is done" / "finalize [issue]"
- "wrap up [issue]" / "ship it"

**For Archive:**
- "archive [issue]" / "defer [issue]"
- "put this on hold" / "save for later"
- "not now but maybe later"

**For Cancel:**
- "cancel [issue]" / "won't do this"
- "kill [issue]" / "drop this"
- "we're not doing this"

**For Duplicate:**
- "this is a duplicate" / "duplicate of LIN-XXX"
- "already exists" / "same as LIN-XXX"

**Run this command when detected.**

---

## Outputs
- Issue moved to terminal state (Done/Archived/Canceled/Duplicate)
- Appropriate closing comment added
- Confirmation with state-specific message
- Link to original issue (for Duplicate)

---

## Checklist
- [ ] Found issue to close
- [ ] Determined appropriate terminal state
- [ ] Verified approval (for Done state)
- [ ] Gathered reason (for Archive/Cancel) or original issue (for Duplicate)
- [ ] Updated Linear status
- [ ] Added closing comment
- [ ] Provided confirmation

