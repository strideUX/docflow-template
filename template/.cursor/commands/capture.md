# Capture (PM/Planning Agent)

## Overview
Quickly capture new work to the backlog without context switching from current work.

**Agent Role:** PM/Planning Agent (orchestrator)  
**Frequency:** Anytime inspiration strikes or issues are discovered

---

## Steps

### 1. **Identify Type**
Ask: "Is this a feature, bug, chore, or idea?"

**Type Guide:**
- **Feature**: New functionality with clear user story
- **Bug**: Something broken that needs fixing
- **Chore**: Maintenance, cleanup, refactoring, improvements
- **Idea**: Rough concept to explore or validate later

**If unclear:** Infer from context or ask user to clarify

### 2. **Gather Minimum Viable Context**
**For Features:**
- What user problem does this solve?
- Who is it for? (persona)
- What's the desired outcome?

**For Bugs:**
- What's broken?
- How to reproduce?
- How severe/urgent?

**For Chores:**
- What needs improving?
- What areas are affected?
- Why does this matter?

**For Ideas:**
- What's the concept?
- Why might this be valuable?
- What needs to be figured out?

### 3. **Create Spec File**
**Use correct template:**
- Copy from /docflow/specs/templates/[type].md
- Name: `[type]-[kebab-case-name].md`
- Save in /docflow/specs/backlog/

**Examples:**
- `feature-user-dashboard.md`
- `bug-login-error.md`
- `chore-ui-polish.md`
- `idea-ai-search.md`

### 4. **Fill Minimal Spec**
**Don't overthink it** - just capture enough to remember and refine later.

**For Features/Bugs/Chores:**
```markdown
# [Type]: [Name]

**Status**: BACKLOG
**Priority**: [High/Medium/Low - ask or infer]
**Complexity**: [S/M/L/XL - rough guess or TBD]
**Created**: YYYY-MM-DD

## Context
[Why this matters - 1-2 sentences]

## [User Story / Bug Description / Task List]
[Quick description of what/why/how]

## Acceptance Criteria
- [ ] [Key criterion 1]
- [ ] [Key criterion 2]
- [ ] [Key criterion 3]

## Decision Log
### YYYY-MM-DD - Initial Capture
**Decision:** Captured [type] for [reason]
**Priority:** [Why this priority level]
```

**For Ideas:**
```markdown
# Idea: [Name]

**Status**: BACKLOG
**Created**: YYYY-MM-DD

## Sketch
[Brain dump of the idea]

## Potential Value
[Why this might be worth doing]

## Questions
- [ ] [What needs researching]
- [ ] [What needs validating]
```

### 5. **Update INDEX.md**
Add to Backlog Priority section:
```markdown
## Backlog Priority
1. [spec-name] - [one-line description] - [Priority]
```

Place based on priority (high at top).

### 6. **Confirmation**
"✅ Captured [type]: [name] to backlog!

**Location:** /docflow/specs/backlog/[spec-filename]  
**Priority:** [Level]  
**Next step:** Refine with /review when ready to build

You can continue with current work."

---

## Quick Capture Mode

If user is in flow and just mentions something quickly:

**User:** "oh we should add dark mode"  
**Agent:** "Should I /capture that as a feature?"  
**User:** "yes"  
**Agent:** [Quickly creates feature-dark-mode.md with minimal info]

**Don't interrupt flow** - capture quickly and move on.

---

## Context to Load
- /docflow/INDEX.md (to update)
- /docflow/specs/templates/[type].md (to copy)
- Minimal - keep it fast

---

## Natural Language Triggers
User might say:
- "capture that" / "add to backlog"
- "I have an idea" / "found a bug"
- "we should add [x]"
- "make a note"
- "TODO" / "FIXME" (in conversation)

**Run this command when detected.**

---

## Outputs
- New spec in backlog
- INDEX.md updated
- Quick confirmation
- User continues current work (no context switch)

---

## Checklist
- [ ] Type identified (feature/bug/chore/idea)
- [ ] Minimal context gathered
- [ ] Correct template copied
- [ ] Spec file created in backlog
- [ ] Basic sections filled
- [ ] Priority set
- [ ] INDEX.md updated
- [ ] Confirmation provided
- [ ] User can continue current work
