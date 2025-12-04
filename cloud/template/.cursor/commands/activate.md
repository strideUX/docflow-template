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

### 3. **Get Assignee**

**Get current developer:**
```bash
git config github.user || git config user.name || "Developer"
```

**Check if already assigned:**
- If assigned to someone else, warn before changing
- If unassigned, assign to current user

### 4. **Update Linear Issue**

```typescript
updateIssue(issueId, {
  stateId: config.linear.states.READY,  // Todo state
  assigneeId: currentUserId
})

addComment(issueId, {
  body: `### ${date} - Activated for Implementation

**Assigned to:** @${username}
**Status:** Ready for implementation

This issue is now queued for development.`
})
```

### 5. **Confirmation**

```markdown
✅ Activated!

**Issue:** LIN-XXX
**Title:** [Title]
**Status:** Todo (ready for implementation)
**Assigned to:** @you

**Acceptance Criteria:**
- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] [Criterion 3]

Run `/implement LIN-XXX` or say "implement" to start building.
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
- Issue status → Todo/Ready
- Assignee set
- Activation comment added
- Ready for implementation handoff

---

## Checklist
- [ ] Found issue to activate
- [ ] Verified issue has required content
- [ ] Got current developer username
- [ ] Updated Linear status to Ready/Todo
- [ ] Set assignee
- [ ] Added activation comment
- [ ] Provided confirmation with criteria

