# Wrap Session (PM/Planning Agent)

## Overview
End your planning session by saving progress and setting up for next time.

**Agent Role:** PM/Planning Agent (orchestrator)  
**Frequency:** End of each work session

---

## Steps

### 1. **Review All Active Specs**
- Check all specs in /docflow/specs/active/
- Note the status of each:
  - READY: Queued for implementation
  - IMPLEMENTING: Being worked on
  - REVIEW: Waiting for code review
  - QE_TESTING: Waiting for user approval

### 2. **Update ACTIVE.md**
- Update "Last Updated" timestamp
- Ensure Primary/Secondary focus sections reflect current state
- Add any brief status notes if needed

### 3. **Check for Incomplete Work**
For any specs in progress:
- Ensure Decision Log is current
- Verify progress is documented
- Note any blockers

### 4. **Session Summary**
Provide clear wrap-up summary:
```
📊 Session Summary:

✅ Completed This Session:
   - [what was accomplished]

💻 In Progress:
   - [spec] - status=IMPLEMENTING - @username
   - [spec] - status=REVIEW - ready for code review

📋 Queued for Next Session:
   - [spec] - status=READY - ready for implementation
   - [spec] - in backlog - needs refinement

⏭️ Next Steps:
   - [what to do when you return]
   - [any urgent items]

🚫 Blockers to Address:
   - [blocker 1]
   OR: None
```

### 5. **Prepare for Next Session**
Set up for success:
- Identify highest priority for next session
- Note any questions that need answering
- Flag any specs that need attention

### 6. **Confirmation**
"Session wrapped! 👋

**Current State:**
- X specs in progress
- Y specs ready for your approval
- Z specs queued for implementation

**Next Session:**
- [Primary focus for next time]

Everything is documented and ready for next time."

---

## Context to Load
- /docflow/ACTIVE.md (to update)
- All specs in /docflow/specs/active/ (scan for status)
- /docflow/INDEX.md (may need updating if priorities changed)

---

## Natural Language Triggers
User might say:
- "let's wrap" / "wrap up"
- "I'm done" / "done for now"
- "end session" / "save progress"
- "call it a day"

**Just run this command automatically.**

---

## Outputs
- Updated /docflow/ACTIVE.md
- Session summary
- Clear next steps
- Confidence that work is saved

---

## Checklist
- [ ] All active specs reviewed
- [ ] Spec statuses verified and current
- [ ] ACTIVE.md updated with timestamp
- [ ] Decision logs current
- [ ] Session summary provided
- [ ] Next steps identified
