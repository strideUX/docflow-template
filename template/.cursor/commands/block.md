# Block (Implementation Agent)

## Overview
Document a blocker and hand back to PM Agent for guidance.

**Agent Role:** Implementation Agent (builder)  
**Frequency:** When hitting a blocker during implementation

**This hands back to PM Agent for input.**

---

## Steps

### 1. **Document the Blocker**
Update spec's Blockers section:
```markdown
## Blockers

**Current Blocker:**
- **Issue:** [Clear description of what's blocking progress]
- **Needs:** [What's needed to unblock - decision, info, dependency]
- **Blocking Since:** YYYY-MM-DD
- **Impact:** [What can't be done until this is resolved]
```

### 2. **Update Implementation Notes**
Add entry documenting where you stopped:
```markdown
### YYYY-MM-DD - Hit Blocker

**Progress so far:**
- [x] [What was completed]
- [ ] [What's blocked]

**Blocker Details:**
[Description of the blocker]

**Attempted Solutions:**
- [What you tried]
- [Why it didn't work]

**Needs Resolution:**
[What's needed from PM to unblock]
```

### 3. **Update Spec Status**
Set in spec:
```markdown
**Status**: REVIEW
**Owner**: DocFlow
**Last Updated**: YYYY-MM-DD
```

**Note:** Setting to REVIEW hands this back to PM for guidance.

### 4. **Summarize for User**
"⚠️ Hit a blocker on [spec-name]

**Issue:** [Clear description]

**What I tried:**
- [Attempted solution 1]
- [Attempted solution 2]

**What's needed:**
[What would unblock this]

**Options:**
1. Get PM input on approach
2. Research/investigate further
3. Mark as dependency for another spec

I've documented the blocker in the spec. The PM agent can help decide next steps."

---

## Context to Load
- Current spec being implemented
- Related specs if checking for conflicts/dependencies

---

## Natural Language Triggers
User might say:
- "I'm blocked" / "this is blocked"
- "can't proceed" / "stuck"
- "need help" / "need PM input"

**Run this command when detected.**

---

## Outputs
- Blocker documented in spec
- Status set to REVIEW (hands to PM)
- Clear summary of issue
- Options for resolution

---

## Checklist
- [ ] Blocker documented in spec Blockers section
- [ ] Implementation Notes updated with progress
- [ ] Status set to REVIEW
- [ ] Owner set to DocFlow (PM)
- [ ] Last Updated timestamp updated
- [ ] Clear summary provided to user
- [ ] Options for resolution suggested

