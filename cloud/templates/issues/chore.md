# Chore Issue Template

> Copy this template when creating a maintenance, cleanup, or improvement issue in Linear or other PM tools.

---

## Context

**Why This Matters:**
[Explanation of the value - cleaner code, better UX, faster performance, etc.]

**Scope:**
[What areas/pages/features does this touch? Be specific enough to stay focused.]

**Type:** Ongoing | One-time

---

## Task List

### Initial Tasks
- [ ] [Task 1 - be specific]
- [ ] [Task 2 - be specific]
- [ ] [Task 3 - be specific]

### Added During Work
<!-- Add new tasks discovered while working -->

### Out of Scope
<!-- Tasks that don't fit - might become new issues -->
- [Task that's too big or different focus]

---

## Acceptance Criteria

### Completion
- [ ] All initial tasks completed (or moved to out of scope)
- [ ] Code quality acceptable
- [ ] No regressions introduced

### Tests
- [ ] Tests updated if behavior changed
- [ ] All tests passing
- [ ] N/A - No behavior changes

### Documentation
- [ ] Patterns documented (if new approach discovered)
- [ ] N/A - No significant documentation needed

---

## Technical Notes

### Approach
[How you'll tackle this work]

### Files to Touch
- `path/to/file.tsx` - [What changes]

### Risk Assessment
- **Regression Risk:** Low | Medium | High
- **Related Areas:** [What else might be affected]

---

## Completion Criteria

**This chore is done when:**
- [ ] [Completion criterion 1]
- [ ] [Completion criterion 2]
- [ ] No obvious improvements remaining

**Signs this needs to be split:**
- Work has been ongoing for 3+ weeks
- Scope has grown significantly
- New tasks are unrelated to original purpose

---

## Workflow Notes

**Status Flow (simplified):**
```
Backlog → In Progress → Done
```

Or full flow if significant:
```
Backlog → Todo → In Progress → In Review → QA → Done
```

**Comments should track:**
- Progress updates
- Tasks discovered during work
- Completion recommendation

**Comment Format:**
```
**[Status]** — Brief description.
```

Examples:
- `**Progress** — Completed 3/5 tasks, found 2 more to add.`
- `**Ready to Close** — All tasks done, code cleaner.`
