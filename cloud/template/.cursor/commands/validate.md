# Validate (QE/Validation Agent)

## Overview
Test and validate an implementation with the user. Guide through QE testing.

**Agent Role:** QE/Validation Agent (tester)  
**Frequency:** After implementation is complete (status=REVIEW or QA)

**This receives handoff from Implementation Agent.**

---

## Steps

### 1. **Find Issue to Validate**

**If user specified issue (LIN-XXX):**
- Query that specific issue from Linear

**If not specified:**
- Query Linear for issues in "In Review" or "QA" state
- Filter by team
- Present options if multiple

### 2. **Load Issue Context**
From Linear MCP, load:
- Full issue description
- All comments (implementation notes)
- Attachments (Figma, screenshots)

Also load:
- `docflow/context/standards.md` (for code review)

### 3. **Code Review Phase (if status=REVIEW)**

Review the implementation:
- Read implementation comments
- Check acceptance criteria against code
- Verify standards compliance

**If code review passes:**
```typescript
updateIssue(issueId, {
  stateId: config.linear.states.TESTING  // Move to QA
})

addComment(issueId, {
  body: '**Review Passed** — Code meets standards, ready for QE testing.'
})
```

Inform user:
```markdown
✅ Code review passed!

**Issue:** LIN-XXX
**Status:** QA (ready for your testing)

**To test, please verify:**
1. [Acceptance criterion 1]
2. [Acceptance criterion 2]
3. [Acceptance criterion 3]

Let me know when you've tested. Say "looks good" to approve or describe any issues.
```

**If code issues found:**
```typescript
updateIssue(issueId, {
  stateId: config.linear.states.IMPLEMENTING  // Back to dev
})

addComment(issueId, {
  body: '**Review Failed** — [Specific issue 1], [Specific issue 2]. Returning to implementation.'
})
```

### 4. **QE Testing Phase (if status=QA)**

Guide user through testing:
```markdown
## 🧪 QE Testing: LIN-XXX

**Issue:** [Title]

### Acceptance Criteria to Verify:
- [ ] [Criterion 1 - how to test]
- [ ] [Criterion 2 - how to test]
- [ ] [Criterion 3 - how to test]

### Test Scenarios:
1. **Happy path:** [What to try]
2. **Edge case:** [What to try]
3. **Error case:** [What to try]

Please test these scenarios and let me know:
- ✅ "looks good" / "approved" - if everything works
- ❌ Describe any issues you find
```

### 5. **Handle User Feedback**

**If user approves:**
Recognize approval phrases:
- "looks good" / "approved" / "ship it"
- "works great" / "all good" / "verified"
- "QE passed" / "testing passed"

```typescript
addComment(issueId, {
  body: '**QE Passed** — All acceptance criteria verified by user.'
})
```

Inform user:
```markdown
🎉 QE Testing Approved!

**Issue:** LIN-XXX
**Status:** Ready to close

Run `/close LIN-XXX` to archive, or I can do it now.
```

**If user reports issues:**
```typescript
updateIssue(issueId, {
  stateId: config.linear.states.IMPLEMENTING
})

addComment(issueId, {
  body: '**QE Failed** — [Issue 1], [Issue 2]. Returning to implementation.'
})
```

Inform user:
```markdown
📝 Issues documented.

**Issue:** LIN-XXX moved back to In Progress

The implementation agent will address:
1. [Issue 1]
2. [Issue 2]

Run `/implement LIN-XXX` to continue fixing.
```

---

## Context to Load
- Linear issue (full details + all comments)
- `docflow/context/standards.md`
- Implementation notes from comments

---

## Natural Language Triggers
User might say:
- "validate [issue]" / "test [issue]"
- "review the implementation"
- "let's test this"
- "QE [issue]"

**Run this command when detected.**

---

## Outputs
- Code review completed (if needed)
- Linear status updated
- Testing guidance provided to user
- User feedback captured
- Appropriate next state set

---

## Checklist
- [ ] Found issue to validate
- [ ] Loaded issue + comments + standards
- [ ] Performed code review (if status=REVIEW)
- [ ] Updated status appropriately
- [ ] Provided testing guidance (if status=QA)
- [ ] Waited for user feedback
- [ ] Documented approval or issues
- [ ] Set appropriate next state

