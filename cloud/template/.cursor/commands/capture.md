# Capture (PM/Planning Agent)

## Overview
Quickly capture new work to Linear backlog without context switching.

**Agent Role:** PM/Planning Agent (orchestrator)  
**Frequency:** Anytime inspiration strikes or issues are discovered

---

## Steps

### 1. **Identify Type**
Ask: "Is this a feature, bug, chore, or idea?"

**Type Guide:**
- **Feature**: New functionality with clear user story
- **Bug**: Something broken that needs fixing
- **Chore**: Maintenance, cleanup, refactoring
- **Idea**: Rough concept to explore later

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

**For Ideas:**
- What's the concept?
- Why might this be valuable?

### 3. **Build Issue Description**
Use the appropriate template structure:

**For Features:**
```markdown
## Context
[Why this matters - 1-2 sentences]

## User Story
**As a** [user role]
**I want to** [goal]
**So that** [benefit]

## Acceptance Criteria
### Must Have
- [ ] [Key criterion 1]
- [ ] [Key criterion 2]
- [ ] [Key criterion 3]

### Should Have
- [ ] [Nice-to-have]

### Won't Have
- [ ] [Out of scope]

## Technical Notes
[Initial thoughts on approach - can be refined later]

---
_Captured: YYYY-MM-DD_
```

**For Bugs:**
```markdown
## Bug Description
[What's broken]

## Steps to Reproduce
1. [Step 1]
2. [Step 2]
3. [Expected vs Actual]

## Severity
[Critical / High / Medium / Low]

## Acceptance Criteria
- [ ] [Bug is fixed]
- [ ] [No regression]

---
_Captured: YYYY-MM-DD_
```

**For Chores:**
```markdown
## Task
[What needs to be done]

## Why
[Why this matters]

## Scope
- [Area 1]
- [Area 2]

## Done When
- [ ] [Completion criterion 1]
- [ ] [Completion criterion 2]

---
_Captured: YYYY-MM-DD_
```

**For Ideas:**
```markdown
## Sketch
[Brain dump of the idea]

## Potential Value
[Why this might be worth doing]

## Questions to Answer
- [ ] [What needs researching]
- [ ] [What needs validating]

---
_Captured: YYYY-MM-DD_
```

### 4. **Set Priority and Estimate**

Ask or infer based on context:

**Priority (required for bugs, optional for others):**
| Value | Name   | Use When                        |
|-------|--------|----------------------------------|
| 1     | Urgent | Drop everything                 |
| 2     | High   | Next up, important              |
| 3     | Medium | Normal priority (default)       |
| 4     | Low    | Nice to have                    |

**Estimate (optional at capture, can set during activation):**
| Value | Name | Rough Effort         |
|-------|------|----------------------|
| 1     | XS   | < 1 hour             |
| 2     | S    | 1-4 hours            |
| 3     | M    | Half day to full day |
| 4     | L    | 2-3 days             |
| 5     | XL   | Week+                |

### 5. **Create Linear Issue**
Use Linear MCP to create issue:

```typescript
// Linear MCP call
createIssue({
  teamId: config.linear.teamId,
  title: "[Type]: [Name]",
  description: [built description],
  priority: [1-4 based on user input],
  estimate: [1-5 if known],
  labelIds: [config.linear.labels[type]],
  stateId: config.linear.states.BACKLOG,
  assignee: [optional - if user specifies]  // "me", name, or email
})

// Add creation comment
addComment(issueId, {
  body: '**Created** — [Brief context about why this was captured].'
})
```

**Optional Assignment:**
If user says "capture this for cory" or "assign to matt":
```typescript
createIssue({
  ...
  assignee: "cory"  // name, email, or "me"
})
```

By default, leave unassigned (goes to backlog for later activation).

### 6. **Add Figma/Assets If Available**
If user mentions design references:
- Add Figma URL as attachment
- Note any screenshots needed

### 7. **Confirmation**
```markdown
✅ Captured to Linear!

**Issue:** LIN-XXX
**Title:** [Type]: [Name]
**Priority:** [Level]
**Estimate:** [Size or "Not set"]
**Status:** Backlog

[View in Linear](issue-url)

You can continue with current work. Refine later with `/review LIN-XXX`.
```

---

## Quick Capture Mode

If user is in flow and mentions something quickly:

**User:** "oh we should add dark mode"  
**Agent:** "Should I /capture that as a feature?"  
**User:** "yes"  
**Agent:** [Quickly creates minimal issue]

**Don't interrupt flow** - capture quickly and move on.

---

## Context to Load
- `.docflow.json` (for Linear config)
- Minimal - keep it fast

---

## Natural Language Triggers
User might say:
- "capture that" / "add to backlog"
- "I have an idea" / "found a bug"
- "we should add [x]"
- "make a note" / "TODO"

**Run this command when detected.**

---

## Outputs
- New issue in Linear (Backlog state)
- Appropriate type label applied
- Quick confirmation with issue link
- User continues current work

---

## Checklist
- [ ] Type identified (feature/bug/chore/idea)
- [ ] Minimal context gathered
- [ ] Description built from template
- [ ] Priority set (1-4)
- [ ] Estimate set (1-5, optional at capture)
- [ ] Linear issue created via MCP
- [ ] Type label applied
- [ ] State set to Backlog
- [ ] Creation comment added
- [ ] Confirmation with link provided
- [ ] User can continue current work

