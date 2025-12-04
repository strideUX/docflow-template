# Implement (Implementation Agent)

## Overview
Pick up an active spec and build it. Auto-complete when done.

**Agent Role:** Implementation Agent (builder)  
**Frequency:** When starting implementation work

**This receives the handoff from PM Agent.**

---

## Steps

### 1. **Find Available Work**
Check /docflow/specs/active/ for specs with:
- status=READY (queued for implementation)
- status=IMPLEMENTING (if resuming work)
- AssignedTo=@currentuser OR AssignedTo=Unassigned

**Get current username:**
- Try: `git config github.user`
- Fallback: `git config user.name`
- If neither: use "Developer"

### 2. **Select Spec**
**If user specified spec name:**
- Load that specific spec

**If multiple specs available:**
- Check user's message for context clues
- If clear from context, pick that one
- If ambiguous, ask: "I see multiple specs ready. Which one: [list]?"

**If no specs available:**
- Report: "No specs ready for implementation."
- Show what's assigned to others (if any)
- Suggest checking with PM Agent

### 3. **Load Full Context**
Load everything needed:
- The complete spec (all sections)
- /docflow/context/stack.md (technical patterns)
- /docflow/context/standards.md (code quality rules)

### 4. **Update Spec Status**
Set in spec:
```markdown
**Status**: IMPLEMENTING
**Owner**: Implementation
**Last Updated**: YYYY-MM-DD
```

If "Started" date in Implementation Notes is empty, set it to today.

### 5. **Begin Implementation**
Work through the spec:
- Follow acceptance criteria
- Adhere to stack.md patterns
- Follow standards.md conventions
- Fill Implementation Notes progressively as you work
- Update acceptance criteria: [ ] → [x] as you complete them
- Document decisions in Decision Log
- Create /docflow/specs/assets/[spec-name]/ if visual assets needed

### 6. **Track Progress**
As you work, update Implementation Notes:
- Files changed
- Key decisions made
- Challenges encountered
- Any deviations from original plan (with justification)

### 7. **Auto-Complete When Done**
When ALL acceptance criteria are met:
- Verify Implementation Notes section is filled out
- Set spec metadata:
```markdown
**Status**: REVIEW
**Owner**: DocFlow
**Last Updated**: YYYY-MM-DD
```

**Brief summary to user:**
"✅ Implementation complete!

**Spec**: [spec-name]  
**Status**: REVIEW (ready for code review)  
**Files changed**: X  
**Acceptance criteria**: All met ✓

The spec is now ready for the QE/Validation agent to review.

Run `/validate [spec-name]` or just say \"validate [spec-name]\"
"

**This hands off to QE Agent.**

---

## On Blocker

If you hit a blocker during implementation, run `/block` instead:
- Document the blocker in spec
- Set status=REVIEW (hands back to PM)
- Explain what's blocking

---

## Context to Load
- Active spec being implemented (complete)
- /docflow/context/stack.md
- /docflow/context/standards.md
- Use codebase_search as needed for existing code

---

## Natural Language Triggers
User might say:
- "implement [spec]" / "build [spec]"
- "let's work on [spec]"
- "start implementation"
- "pick up [spec]"

**Run this command when detected.**

---

## Outputs
- Spec status updated to IMPLEMENTING (at start)
- Implementation completed
- Implementation Notes filled out
- Spec status updated to REVIEW (at end)
- Brief completion summary

---

## Checklist
- [ ] Found available work
- [ ] Loaded spec + stack.md + standards.md
- [ ] Set status=IMPLEMENTING
- [ ] Followed acceptance criteria
- [ ] Filled Implementation Notes progressively
- [ ] Checked off acceptance criteria as completed
- [ ] Documented decisions
- [ ] Auto-set status=REVIEW when done
- [ ] Provided completion summary

