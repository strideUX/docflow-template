# Wrap Session (PM/Planning Agent)

## Overview
End a work session by saving progress and noting what's next.

**Agent Role:** PM/Planning Agent (orchestrator)  
**Frequency:** End of each work session

---

## Steps

### 1. **Query Current State**

Check Linear for:
- Issues currently in progress (assigned to user)
- Issues currently blocked (assigned to user)
- Any issues that moved states during session
- Any new issues created during session

### 2. **Document Progress on Active Issues**

For each issue in progress, add session wrap comment:

```typescript
addComment(issueId, {
  body: '**Session End** — [Brief progress summary]. Next: [what to do next].'
})
```

For issues with significant progress, can expand:
```markdown
**Session End** — [What was accomplished].

Next session:
- [Next step 1]
- [Next step 2]
```

### 3. **Summarize Session**

```markdown
## 📋 Session Wrap

### 🕐 Session Summary
**Duration:** [start] - [now]

### ✅ Completed This Session
- LIN-101: [Title] → Done ✓
- LIN-102: [Title] → In Review

### 🚫 Blocked (Needs Attention)
- LIN-234: [Title]
  - Blocker: [brief description]
  - Needs: [what's needed to unblock]

### 🔨 In Progress (Continued Next Time)
- LIN-456: [Title]
  - Progress: [brief]
  - Next: [what's next]

### 📝 New Items Captured
- LIN-789: [Title] (feature)
- LIN-790: [Title] (bug)

### 🎯 Suggested Next Session
1. Test LIN-102 (in QA)
2. Check on LIN-234 (blocked)
3. Continue LIN-456
4. Start LIN-789 (high priority)

---
Good session! 🎉
```

### 4. **Post Project Update (Optional)**

If work was done on a project, offer to post a project update:

```markdown
Would you like to post a project update for [Project Name]?

Suggested update:
**Health:** 🟢 On Track
**Summary:**
- Completed STR-101, STR-102
- STR-456 in progress (70% done)
- Next: QE testing on STR-102

Say "post update" to publish, or "skip" to continue.
```

**If user approves, run `/project-update`:**
- Uses session summary as update body
- Sets health status based on blockers (onTrack if none)
- Posts via Linear GraphQL API

See `/project-update` command for implementation details.

### 5. **Offer Final Actions**

```markdown
Before you go:
- [ ] Any last captures? (say "capture [idea]")
- [ ] Anything to note? (I'll add to Linear)
- [ ] Ready to wrap? (say "done" or "that's it")
```

---

## Quick Wrap

For fast exit:
```
User: "quick wrap"

Agent: 
📋 Session saved!
- LIN-456 progress noted
- 2 items completed
- Next: Test LIN-102

See you next time! 👋
```

---

## Context to Load
- `.docflow/config.json` (Linear config)
- Linear queries for current state
- Session context (what was worked on)

---

## Natural Language Triggers
User might say:
- "let's wrap" / "wrap it up"
- "I'm done" / "done for the day"
- "save progress" / "checkpoint"
- "end session"

**Run this command when detected.**

---

## Outputs
- Progress comments added to active issues
- Session summary provided
- Project update posted (if approved)
- Next session suggestions
- Clean handoff for next session

---

## Checklist
- [ ] Queried current state from Linear
- [ ] Added progress comments to active issues
- [ ] Summarized session accomplishments
- [ ] Listed in-progress items
- [ ] Noted new captures
- [ ] Offered project update (if project work done)
- [ ] Posted project update (if approved)
- [ ] Suggested next session priorities
- [ ] Offered final captures
- [ ] Confirmed wrap complete

