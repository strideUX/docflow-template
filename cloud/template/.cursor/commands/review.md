# Review (PM/Planning Agent)

## Overview
Code review for completed implementations. Analyzes code changes, verifies acceptance criteria, tests, and documentation before approving for QA testing.

**Agent Role:** PM/Planning Agent (orchestrator)  
**Frequency:** When implementation is complete (status = In Review)

**Note:** For spec refinement (backlog items), use `/refine` instead.

---

## Steps

### 1. **Find Issues Awaiting Review**

**If user specified issue (LIN-XXX):**
- Query that specific issue from Linear
- Verify it's in "In Review" state

**If not specified:**
- Query Linear for issues in "In Review" state
- Show list and ask which to review

```markdown
## 🔍 Code Review Queue

Found [N] issues awaiting code review:

| Issue | Title | Completed By | Files |
|-------|-------|--------------|-------|
| LIN-201 | [Title] | @developer | 5 files |
| LIN-202 | [Title] | @developer | 3 files |

Which would you like to review?
```

### 2. **Load Review Context**

From Linear MCP:
- Full description (with acceptance criteria)
- All comments (especially implementation/completion notes)
- Files changed (from completion comment)

Also load:
- `docflow/context/standards.md` (code quality rules)
- Changed files (use codebase search/read)
- Test files if mentioned

### 3. **Analyze Implementation**

**Review the actual code changes:**

1. **Find changed files** from the completion comment
2. **Read each significant file** and analyze:
   - Does it follow `standards.md` conventions?
   - Is the code well-structured and readable?
   - Are there any obvious issues or anti-patterns?
   - Is error handling appropriate?
   - Are types properly defined (TypeScript)?

3. **Check tests:**
   - Were tests written?
   - Do tests cover the acceptance criteria?
   - Are edge cases considered?
   - Do tests follow project patterns?

4. **Check documentation:**
   - Were significant decisions documented?
   - Is code commented appropriately?
   - Was knowledge base updated (if needed)?

### 4. **Present Code Review**

```markdown
## 🔍 Code Review: LIN-XXX

**Issue:** [Title]
**Implemented by:** [assignee]
**Files Changed:** [count]

---

### Acceptance Criteria Verification

| Criterion | Status | Verified In |
|-----------|--------|-------------|
| [Criterion 1] | ✅ | `file.tsx:42` |
| [Criterion 2] | ✅ | `hook.ts:15` |
| [Criterion 3] | ⚠️ | Not found |

### Tests Verification

- **Test file:** `component.test.tsx`
- **Coverage:**
  - ✅ Core functionality tested
  - ✅ Happy path covered
  - ⚠️ Error case missing
- **Status:** Tests passing / failing

### Documentation Verification

- ✅ Code comments adequate
- ✅ Knowledge base: N/A (no significant patterns)
- ✅ Context files: N/A (no architecture changes)

---

### Code Quality Assessment

**Standards Compliance:** ✅ Good | ⚠️ Minor issues | ❌ Needs work

**Review Findings:**

✅ **Good:**
- Clean component structure
- Proper TypeScript types
- Error handling present
- Follows existing patterns

⚠️ **Suggestions (non-blocking):**
- Consider extracting [X] to a custom hook
- Could add JSDoc to public function [Y]

❌ **Issues (must fix before approval):**
- [Critical issue that must be addressed]
- [Another blocking issue]

---

### Recommendation

**✅ APPROVE** - Ready for QA testing
OR
**⚠️ REQUEST CHANGES** - Issues above must be fixed first
```

### 5. **Take Action Based on Review**

**If APPROVE:**
```typescript
updateIssue(issueId, {
  stateId: config.linear.states.TESTING  // Move to QA
})

addComment(issueId, {
  body: `**Code Review Passed** ✅

**Verified:**
- All acceptance criteria met
- Tests adequate  
- Code quality good

**Suggestions (optional):**
- [Non-blocking suggestions]

Ready for QA testing.`
})
```

**If REQUEST CHANGES:**
```typescript
updateIssue(issueId, {
  stateId: config.linear.states.IMPLEMENTING  // Back to In Progress
})

addComment(issueId, {
  body: `**Code Review: Changes Requested** ⚠️

**Issues to address:**
1. [Issue 1 - specific guidance]
2. [Issue 2 - specific guidance]

Please fix and move back to Review when ready.`
})
```

### 6. **Confirmation**

**If approved:**
```markdown
✅ Code review complete!

**Issue:** LIN-XXX
**Status:** QA (ready for testing)

**Verified:**
- All acceptance criteria met
- Tests adequate
- Code quality good

Next: `/validate LIN-XXX` to begin QE testing.
```

**If changes requested:**
```markdown
⚠️ Code review complete - changes needed

**Issue:** LIN-XXX  
**Status:** In Progress (returned for fixes)

**Issues to address:**
1. [Issue 1]
2. [Issue 2]

Fix these and move back to Review when ready.
```

---

## Review Depth

The code review should be **meaningful but not exhaustive**:

**DO check:**
- Acceptance criteria are actually met (verify in code)
- Tests exist and cover main functionality
- Code follows `standards.md` patterns
- No obvious bugs or anti-patterns
- Error handling is present
- Types are properly defined

**DON'T get stuck on:**
- Minor style preferences (that's what linters are for)
- Hypothetical future issues
- Over-optimization
- Bikeshedding

**Goal:** Verify the implementation is solid enough for QA, not perfect.

---

## Context to Load
- Linear issue (full details + all comments)
- `docflow/context/standards.md`
- Changed files (from completion comment)
- Test files
- Related files if needed for context

---

## Natural Language Triggers
- "review [issue]" (when issue is in Review state)
- "code review [issue]"
- "check the implementation"
- "review the changes"
- "what needs code review"

---

## Outputs
- Implementation analyzed
- Quality assessed against standards
- Tests verified
- Documentation checked
- Approved → moved to QA
- OR Changes requested → moved back to In Progress

---

## Checklist
- [ ] Found issue in Review state
- [ ] Loaded issue + standards.md + completion comments
- [ ] Identified changed files from completion comment
- [ ] Read and analyzed implementation code
- [ ] Verified each acceptance criterion in code
- [ ] Checked tests exist and cover requirements
- [ ] Checked documentation (or verified N/A appropriate)
- [ ] Assessed code quality against standards
- [ ] Presented detailed review findings
- [ ] Made approval decision
- [ ] Updated Linear status (QA or back to In Progress)
- [ ] Added review comment with findings
- [ ] Confirmed next steps to user
