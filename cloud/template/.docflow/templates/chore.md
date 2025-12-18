<!-- AGENT INSTRUCTIONS
When creating or refining a chore issue:

1. CONTEXT SECTION:
   - Explain the value (cleaner code, better UX, faster performance)
   - Be specific about scope to prevent scope creep
   - Mark as "Ongoing" if this is iterative work

2. TASK LIST:
   - Be specific and actionable
   - Add tasks as you discover them during work
   - Move tasks to "Out of Scope" if they're too big
   - Tasks should be completable in one session

3. ACCEPTANCE CRITERIA:
   - Focus on completion and quality
   - Mark documentation as N/A if no new patterns
   - Mark tests as N/A if no behavior changes

4. COMPLETION CRITERIA:
   - "Done when" should be clear stopping point
   - If scope keeps growing, suggest splitting into multiple chores

5. WORKFLOW:
   - Chores often skip formal review/QA
   - Use simplified flow: Backlog → In Progress → Done
   - Use full flow only for significant refactors

Remove these instructions when creating the final issue.
-->

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
- [ ] No obvious improvements remaining in scope

**Signs this needs to be split:**
- Work has been ongoing for 3+ weeks
- Scope has grown significantly
- New tasks are unrelated to original purpose

---

_Created: YYYY-MM-DD_

