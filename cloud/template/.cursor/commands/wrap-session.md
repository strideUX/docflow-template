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
- Any issues that moved states during session
- Any new issues created during session

### 2. **Document Progress on Active Issues**

For each issue in progress, add session wrap comment:

```typescript
addComment(issueId, {
  body: `### ${date} - Session Wrap

**Progress This Session:**
- [What was accomplished]
- [Files touched]

**Current State:**
- [Where things stand]

**Next Steps:**
- [ ] [What to do next session]
- [ ] [What to do next session]

**Blockers:** [None / Description]`
})
```

### 3. **Summarize Session**

```markdown
## 📋 Session Wrap

### 🕐 Session Summary
**Duration:** [start] - [now]

### ✅ Completed This Session
- LIN-101: [Title] → Done ✓
- LIN-102: [Title] → In Review

### 🔨 In Progress (Continued Next Time)
- LIN-456: [Title]
  - Progress: [brief]
  - Next: [what's next]

### 📝 New Items Captured
- LIN-789: [Title] (feature)
- LIN-790: [Title] (bug)

### 🎯 Suggested Next Session
1. Test LIN-102 (in QA)
2. Continue LIN-456
3. Start LIN-789 (high priority)

---
Good session! 🎉
```

### 4. **Offer Final Actions**

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
- `.docflow.json` (Linear config)
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
- Next session suggestions
- Clean handoff for next session

---

## Checklist
- [ ] Queried current state from Linear
- [ ] Added progress comments to active issues
- [ ] Summarized session accomplishments
- [ ] Listed in-progress items
- [ ] Noted new captures
- [ ] Suggested next session priorities
- [ ] Offered final captures
- [ ] Confirmed wrap complete

