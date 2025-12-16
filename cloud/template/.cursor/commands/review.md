# Review (PM/Planning Agent)

## Overview
Context-aware review command that handles two scenarios:

1. **Spec Refinement** (issue in Backlog/Todo) - Refine acceptance criteria, prepare for implementation
2. **Code Review** (issue in Review state) - Analyze implementation, verify quality, approve for QA

**Agent Role:** PM/Planning Agent (orchestrator)  
**Frequency:** When refining specs OR reviewing completed implementation

---

## Steps

### 1. **Find Issue and Determine Review Type**

**If user specified issue (LIN-XXX):**
- Query that specific issue from Linear
- Check issue state to determine review type

**If not specified:**
- Query Linear for issues needing review
- Prioritize: In Review state first, then Backlog
- Show list and ask which to review

**Determine review type:**
```
If state == "In Review" (REVIEW):
  → Code Review (implementation complete, needs verification)

If state == "Backlog" or "Todo":
  → Spec Refinement (preparing for implementation)
```

---

## SPEC REFINEMENT (Backlog/Todo Issues)

### 2a. **Load Context for Spec Review**
From Linear MCP:
- Full description
- All comments
- Attachments (Figma, etc.)
- Current labels and priority

Also load:
- `docflow/context/overview.md` (ensure alignment)
- `docflow/knowledge/INDEX.md` (check for related decisions)

### 3a. **Assess Spec Completeness**

Check issue has:

**Required:**
- [ ] Clear, specific title
- [ ] Context explaining "why"
- [ ] User story (for features)
- [ ] Acceptance criteria (testable)
- [ ] Type label (feature/bug/chore/idea)
- [ ] Priority set

**Nice to Have:**
- [ ] Technical notes/approach
- [ ] Complexity estimate
- [ ] Design references (Figma)
- [ ] Dependencies noted

### 4a. **Present Spec Assessment**

```markdown
## 📋 Spec Review: LIN-XXX

**Title:** [Current title]
**Type:** [feature/bug/chore/idea]
**Priority:** [priority]

### Current State:
✅ Has context
✅ Has user story
⚠️ Acceptance criteria need detail
❌ Missing technical approach

### Acceptance Criteria:
- [ ] [Criterion 1] ← Could be more specific
- [ ] [Criterion 2]

### Suggested Improvements:
1. Add measurable criteria for [X]
2. Clarify edge cases for [Y]
3. Add technical approach notes

Would you like me to:
1. Refine the acceptance criteria
2. Add technical notes
3. Mark as ready to activate
4. Something else
```

### 5a. **Refine Spec Based on Discussion**

Update Linear issue with improvements:

```typescript
updateIssue(issueId, {
  description: updatedDescription,
  priority: updatedPriority,  // 1-4 if changed
  estimate: estimateValue     // 1-5 if set
})

addComment(issueId, {
  body: '**Refined** — Clarified acceptance criteria, added technical approach, Estimate: M.'
})
```

### 6a. **Spec Review Confirmation**

```markdown
✅ Spec review complete!

**Issue:** LIN-XXX
**Status:** Refined and ready

**Updated:**
- Acceptance criteria clarified
- Technical approach added
- Complexity: M

Ready to `/activate LIN-XXX` when you want to start.
```

---

## CODE REVIEW (In Review Issues)

### 2b. **Load Context for Code Review**

From Linear MCP:
- Full description (with acceptance criteria)
- All comments (especially implementation notes)
- Files changed (from completion comment)

Also load:
- `docflow/context/standards.md` (code quality rules)
- Implementation comments from Linear
- Changed files (use codebase search/read)

### 3b. **Analyze Implementation**

**Review the actual code changes:**

1. **Find changed files** from the completion comment
2. **Read each file** and analyze:
   - Does it follow `standards.md` conventions?
   - Is the code well-structured and readable?
   - Are there any obvious issues or anti-patterns?
   - Is error handling appropriate?

3. **Check tests:**
   - Were tests written?
   - Do tests cover the acceptance criteria?
   - Are edge cases considered?

4. **Check documentation:**
   - Were significant decisions documented?
   - Is code commented appropriately?

### 4b. **Present Code Review**

```markdown
## 🔍 Code Review: LIN-XXX

**Issue:** [Title]
**Implemented by:** [assignee]
**Files Changed:** [count]

---

### Acceptance Criteria Check
- [x] Criterion 1 - Verified in `file.tsx`
- [x] Criterion 2 - Verified
- [ ] Criterion 3 - ⚠️ Not found / incomplete

### Tests Check
- [x] Tests written: `file.test.tsx`
- [x] Core functionality covered
- [ ] Edge cases: ⚠️ Missing error case test

### Documentation Check
- [x] Code comments adequate
- [x] Knowledge base updated (or N/A)
- [x] Context files updated (or N/A)

---

### Code Quality Assessment

**Standards Compliance:** ✅ Good | ⚠️ Minor issues | ❌ Needs work

**Findings:**

✅ **Good:**
- Clean component structure
- Proper TypeScript types
- Error handling present

⚠️ **Suggestions:**
- Consider extracting [X] to a hook
- Add JSDoc to public function [Y]

❌ **Issues (must fix):**
- [Issue that must be addressed]

---

### Recommendation

**✅ APPROVE** - Ready for QA testing
OR
**⚠️ REQUEST CHANGES** - See issues above
```

### 5b. **Take Action Based on Review**

**If APPROVE:**
```typescript
updateIssue(issueId, {
  stateId: config.linear.states.TESTING  // Move to QA
})

addComment(issueId, {
  body: '**Code Review Passed** ✅\n\nAll criteria verified. Code quality good. Ready for QA testing.'
})
```

**If REQUEST CHANGES:**
```typescript
updateIssue(issueId, {
  stateId: config.linear.states.IMPLEMENTING  // Back to In Progress
})

addComment(issueId, {
  body: '**Code Review: Changes Requested** ⚠️\n\n**Issues to address:**\n- [Issue 1]\n- [Issue 2]\n\nPlease fix and move back to Review when ready.'
})
```

### 6b. **Code Review Confirmation**

**If approved:**
```markdown
✅ Code review complete!

**Issue:** LIN-XXX
**Status:** QA (ready for testing)

**Verified:**
- All acceptance criteria met
- Tests adequate
- Code quality good

Ready for `/validate LIN-XXX` to begin QE testing.
```

**If changes requested:**
```markdown
⚠️ Code review complete - changes needed

**Issue:** LIN-XXX
**Status:** In Progress (returned for fixes)

**Issues to address:**
- [Issue 1]
- [Issue 2]

Move back to Review when fixed.
```

---

## Bulk Review

**For backlog/spec review:**
```
User: "review the backlog"

Agent: Found 5 items in backlog. Let me assess each...

**Ready to activate:**
- LIN-101: [Title] ✅ Complete
- LIN-103: [Title] ✅ Complete

**Need refinement:**
- LIN-102: [Title] ⚠️ Missing AC
- LIN-104: [Title] ⚠️ Needs tech notes
- LIN-105: [Title] ⚠️ Unclear scope

Would you like to refine the incomplete ones?
```

**For code review queue:**
```
User: "what needs code review"

Agent: Found 2 items awaiting code review:

**In Review:**
- LIN-201: [Title] - Completed by [dev], [X] files
- LIN-202: [Title] - Completed by [dev], [Y] files

Would you like me to review one?
```

---

## Context to Load

**For Spec Review:**
- Linear issue (full details)
- `docflow/context/overview.md`
- `docflow/knowledge/INDEX.md`
- Related features/decisions if relevant

**For Code Review:**
- Linear issue (full details + comments)
- `docflow/context/standards.md`
- Changed files (from completion comment)
- Test files

---

## Natural Language Triggers

**Spec Review:**
- "review [issue]" / "refine [issue]"
- "prepare [issue]" / "is [issue] ready"
- "look at backlog" / "check backlog"
- "get [issue] ready"

**Code Review:**
- "review [issue]" (when issue is in Review state)
- "code review [issue]"
- "check the implementation"
- "review the changes"

**Run this command when detected.**

---

## Outputs

**Spec Review:**
- Issue assessed for completeness
- Improvements identified
- Issue updated in Linear
- Ready for activation

**Code Review:**
- Implementation analyzed
- Quality assessed against standards
- Tests verified
- Approved → moved to QA
- OR Changes requested → moved back to In Progress

---

## Checklist

**Spec Review:**
- [ ] Found issue to review
- [ ] Determined review type (spec refinement)
- [ ] Loaded issue + overview.md + knowledge INDEX
- [ ] Assessed spec completeness
- [ ] Presented assessment to user
- [ ] Made agreed improvements
- [ ] Updated Linear issue
- [ ] Added refinement comment
- [ ] Confirmed ready status

**Code Review:**
- [ ] Found issue to review
- [ ] Determined review type (code review)
- [ ] Loaded issue + standards.md + changed files
- [ ] Read and analyzed implementation code
- [ ] Verified acceptance criteria met
- [ ] Checked tests exist and cover requirements
- [ ] Checked documentation updated (or N/A)
- [ ] Assessed code quality against standards
- [ ] Presented review findings
- [ ] Updated Linear status (QA or back to In Progress)
- [ ] Added review comment with findings
- [ ] Confirmed next steps

