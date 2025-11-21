# Start Session (PM/Planning Agent)

## Overview
Begin your planning session by checking current progress and determining priorities.

**Agent Role:** PM/Planning Agent (orchestrator)  
**Frequency:** Start of each work session

---

## Steps

### 1. **Check for Completed QE Work FIRST (Highest Priority)**
- Check /docflow/specs/active/ for specs with status=QE_TESTING
- These are ready for user approval
- List them prominently: "Ready for your approval:"
- Wait for user to approve or provide feedback

### 2. **Check for Code Review Work**
- Check /docflow/specs/active/ for specs with status=REVIEW
- These need DocFlow code review before QE
- List them: "Ready for code review:"
- Offer to review now or continue with planning

### 3. **Check Active Implementation Work**
- Review /docflow/ACTIVE.md for current state
- Check specs with status=IMPLEMENTING
- Show who's working on what
- Note any blockers

### 4. **Check Backlog Priorities**
- Review /docflow/INDEX.md for backlog priorities
- Identify top items ready for refinement
- Show what could be activated next

### 5. **Summarize Current State**
Present a clear summary:
```
📊 Session Status:

✅ Ready for Approval (QE_TESTING):
   - [spec-name] - [brief description]

🔍 Ready for Review (REVIEW):
   - [spec-name] - [brief description]

💻 In Progress (IMPLEMENTING):
   - [spec-name] - assigned to @username

📋 Top Backlog Priorities:
   1. [spec-name] - [status: needs review / ready to activate]
   2. [spec-name]
   3. [spec-name]

🚫 Blockers:
   - [any blocked work]
   OR: None
```

### 6. **Ask What to Work On**
Based on the state, suggest next action:
- If QE work exists: "Ready to approve [spec]?"
- If review work exists: "Should I review [spec]?"
- If backlog items need refinement: "Want to refine [spec]?"
- If nothing urgent: "What would you like to work on?"

---

## Context to Load
- /docflow/ACTIVE.md (current state)
- Scan /docflow/specs/active/ (check statuses, don't load full specs yet)
- /docflow/INDEX.md (backlog priorities)
- /docflow/context/overview.md (if creating new specs)

---

## Natural Language Triggers
User might say:
- "let's start" / "what's next"
- "where are we" / "status check"
- "what should I work on"
- "resume work" / "continue"

**Just run this command automatically.**

---

## Outputs
- Clear status summary
- Prioritized list of what needs attention
- Suggested next action
- Ready to execute next command (capture, review, activate, close)

---

## Checklist
- [ ] Checked for QE_TESTING specs (priority!)
- [ ] Checked for REVIEW specs
- [ ] Reviewed ACTIVE.md
- [ ] Reviewed INDEX.md priorities
- [ ] Summarized current state
- [ ] Suggested next action
