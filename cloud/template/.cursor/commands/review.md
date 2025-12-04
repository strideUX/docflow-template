# Review (PM/Planning Agent)

## Overview
Refine a backlog issue - add detail, clarify acceptance criteria, prepare for implementation.

**Agent Role:** PM/Planning Agent (orchestrator)  
**Frequency:** When preparing backlog items for implementation

---

## Steps

### 1. **Find Issue to Review**

**If user specified issue (LIN-XXX):**
- Query that specific issue from Linear

**If not specified:**
- Query Linear for backlog issues
- Show list sorted by priority
- Ask which to review

### 2. **Load Full Issue Context**
From Linear MCP:
- Full description
- All comments
- Attachments (Figma, etc.)
- Current labels and priority

Also load:
- `docflow/context/overview.md` (ensure alignment)
- `docflow/knowledge/INDEX.md` (check for related decisions)

### 3. **Assess Completeness**

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

### 4. **Present Assessment**

```markdown
## 📋 Review: LIN-XXX

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

### 5. **Refine Based on Discussion**

Update Linear issue with improvements:

```typescript
updateIssue(issueId, {
  description: updatedDescription,
  priority: updatedPriority,  // if changed
  estimate: complexity        // if set
})

addComment(issueId, {
  body: `### ${date} - Spec Refined

**Changes Made:**
- Clarified acceptance criteria
- Added technical approach
- Set complexity estimate: M

Ready for activation.`
})
```

### 6. **Confirmation**

```markdown
✅ Review complete!

**Issue:** LIN-XXX
**Status:** Refined and ready

**Updated:**
- Acceptance criteria clarified
- Technical approach added
- Complexity: M

Ready to `/activate LIN-XXX` when you want to start.
```

---

## Bulk Review

For reviewing multiple items:
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

---

## Context to Load
- Linear issue (full details)
- `docflow/context/overview.md`
- `docflow/knowledge/INDEX.md`
- Related features/decisions if relevant

---

## Natural Language Triggers
User might say:
- "review [issue]" / "refine [issue]"
- "prepare [issue]" / "is [issue] ready"
- "look at backlog" / "check backlog"
- "get [issue] ready"

**Run this command when detected.**

---

## Outputs
- Issue assessed for completeness
- Improvements identified
- Issue updated in Linear
- Ready for activation

---

## Checklist
- [ ] Found issue to review
- [ ] Loaded full issue context
- [ ] Assessed completeness
- [ ] Presented assessment to user
- [ ] Made agreed improvements
- [ ] Updated Linear issue
- [ ] Added review comment
- [ ] Confirmed ready status

