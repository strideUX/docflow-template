# Status (All Agents)

## Overview
Quick status check showing current state of all work.

**Agent Role:** Any agent  
**Frequency:** Anytime you want to check current state

---

## Steps

### 1. **Scan Active Work**
Check /docflow/specs/active/ for all specs and their status:
- READY: Queued for implementation
- IMPLEMENTING: Being worked on
- REVIEW: Needs code review
- QE_TESTING: Needs user approval
- ACTIVE: Chores in progress

### 2. **Check Current User Assignment**
Get current username:
- `git config github.user` OR `git config user.name`

Filter by assignment:
- Assigned to you
- Assigned to others
- Unassigned

### 3. **Review Backlog**
Quick scan of /docflow/INDEX.md:
- Count of backlog items
- Top 3 priorities

### 4. **Check for Blockers**
Scan active specs for Blockers section:
- Any work that's stuck
- What's needed to unblock

### 5. **Present Status Dashboard**
```
📊 DocFlow Status

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Ready for Approval (QE_TESTING):
   • [spec-name] - [brief description]
   → Action: Approve or provide feedback

🔍 Ready for Review (REVIEW):
   • [spec-name] - [brief description]
   → Action: Run /validate

💻 In Progress (IMPLEMENTING):
   • [spec-name] - @username - [started date]
   → Action: Let them work

🎯 Ready to Build (READY):
   • [spec-name] - assigned to @you
   → Action: Run /implement

🔧 Active Chores (ACTIVE):
   • [chore-name] - ongoing since [date]
   → Action: Continue or close

📋 Backlog (BACKLOG):
   • Total: X items
   • Top priority: [spec-name]
   → Action: Run /review to refine

🚫 Blockers:
   • [spec-name] - blocked on [issue]
   → Action: Resolve blocker
   OR: None ✓

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📌 Assigned to You:
   • [specs assigned to current user]

👥 Assigned to Others:
   • [specs assigned to other developers]

⏭️ Suggested Next Action:
   [What makes most sense to do next based on current state]
```

---

## Context to Load
- /docflow/ACTIVE.md (quick read)
- Scan /docflow/specs/active/ (metadata only, not full specs)
- /docflow/INDEX.md (backlog count and priorities)

---

## Natural Language Triggers
User might say:
- "status" / "what's the status"
- "where are we" / "current state"
- "what's active" / "what's in progress"
- "show me what's happening"

**Run this command when detected.**

---

## Outputs
- Clean status dashboard
- Work categorized by status
- Clear next actions
- Assignment visibility
- Blocker awareness

---

## Checklist
- [ ] Scanned all active specs
- [ ] Checked current user assignment
- [ ] Reviewed backlog priorities
- [ ] Checked for blockers
- [ ] Presented clear status dashboard
- [ ] Suggested next action

