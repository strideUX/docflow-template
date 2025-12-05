# Activate (PM/Planning Agent)

## Overview
Ready a backlog issue for implementation by assigning and moving to Todo.

**Agent Role:** PM/Planning Agent (orchestrator)  
**Frequency:** When preparing work for implementation

**This hands off to Implementation Agent.**

---

## Steps

### 1. **Find Issue to Activate**

**If user specified issue (LIN-XXX):**
- Query that specific issue from Linear

**If not specified:**
- Query Linear for backlog issues
- Show prioritized list
- Ask user which to activate

### 2. **Verify Issue is Ready**

Check issue has:
- Clear title
- Description with context
- Acceptance criteria defined
- Appropriate labels (type)

**If incomplete:**
```markdown
⚠️ Issue LIN-XXX needs refinement before activation:

Missing:
- [ ] Acceptance criteria
- [ ] Technical notes

Would you like to:
1. Add the missing pieces now
2. Run `/review LIN-XXX` to refine first
3. Activate anyway (not recommended)
```

### 3. **Set Priority and Estimate**

**If not already set, ask or infer:**

Priority values:
| Value | Name   | Use When                        |
|-------|--------|----------------------------------|
| 1     | Urgent | Drop everything                 |
| 2     | High   | Next up, important              |
| 3     | Medium | Normal priority (default)       |
| 4     | Low    | Nice to have                    |

Estimate values (complexity):
| Value | Name | Rough Effort         |
|-------|------|----------------------|
| 1     | XS   | < 1 hour             |
| 2     | S    | 1-4 hours            |
| 3     | M    | Half day to full day |
| 4     | L    | 2-3 days             |
| 5     | XL   | Week+                |

**Ask user if unclear:**
```markdown
Before activating, let's set:
- **Priority:** [1=Urgent, 2=High, 3=Medium, 4=Low]?
- **Estimate:** [1=XS, 2=S, 3=M, 4=L, 5=XL]?
```

### 4. **Get Assignee**

**Get current developer:**
```bash
git config github.user || git config user.name || "Developer"
```

**Check if already assigned:**
- If assigned to someone else, warn before changing
- If unassigned, assign to current user

### 5. **Update Linear Issue**

```typescript
updateIssue(issueId, {
  stateId: config.linear.states.IMPLEMENTING,  // In Progress state
  assigneeId: currentUserId,
  priority: priorityValue,  // 1-4
  estimate: estimateValue   // 1-5
})

addComment(issueId, {
  body: `**Activated** — Assigned to ${username}, Priority: ${priorityName}, Estimate: ${estimateName}.`
})
```

### 6. **Confirmation**

```markdown
✅ Activated!

**Issue:** LIN-XXX
**Title:** [Title]
**Status:** In Progress
**Assigned to:** @you
**Priority:** [High/Medium/etc]
**Estimate:** [S/M/etc]

**Acceptance Criteria:**
- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] [Criterion 3]

Ready to implement. I'll update checkboxes as we complete each criterion.
```

---

## Activating Multiple Issues

If user wants to queue several items:
```
User: "activate LIN-101, LIN-102, and LIN-103"

Agent: Activating 3 issues...

✅ LIN-101: [Title] → Todo
✅ LIN-102: [Title] → Todo  
✅ LIN-103: [Title] → Todo

All assigned to @you. Ready to implement.
```

---

## Context to Load
- `.docflow.json` (Linear config)
- Target issue from Linear
- `docflow/context/overview.md` (verify alignment)

---

## Natural Language Triggers
User might say:
- "activate [issue]" / "let's start [issue]"
- "ready to build [issue]"
- "queue [issue] for implementation"
- "move [issue] to active"

**Run this command when detected.**

---

## Outputs
- Issue status → In Progress
- Priority set (1-4)
- Estimate set (1-5)
- Assignee set
- Activation comment added
- Ready to begin implementation

---

## Checklist
- [ ] Found issue to activate
- [ ] Verified issue has required content
- [ ] Set priority (1-4 value)
- [ ] Set estimate (1-5 value)
- [ ] Got current developer username
- [ ] Updated Linear status to In Progress
- [ ] Set assignee
- [ ] Added activation comment with priority/estimate
- [ ] Provided confirmation with criteria

