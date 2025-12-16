# Bug Issue Template

> Copy this template when creating a new bug issue in Linear or other PM tools.

---

## Context

**When Discovered:** [Date or event when bug was found]
**Discovered By:** [User, developer, automated test, etc.]
**Impact:** [How this affects users or the system]
**Frequency:** [Always | Sometimes | Rarely | Under specific conditions]

[Additional context about the bug]

---

## Bug Description

### Expected Behavior
[Describe what SHOULD happen - the correct behavior]

### Actual Behavior
[Describe what ACTUALLY happens - the broken behavior]

### Steps to Reproduce
1. [First action - be specific]
2. [Second action - include any data/conditions needed]
3. [Third action]
4. [Observe the bug]

### Environment
- **Browser/Platform:** [Chrome, Safari, Mobile, etc.]
- **OS:** [macOS, Windows, iOS, Android, etc.]
- **User Role:** [Which user type experiences this]
- **Data Conditions:** [Specific data state that triggers bug]

### Screenshots/Evidence
<!-- Add as attachments -->

---

## Acceptance Criteria

### Fix Verification
- [ ] Bug no longer reproducible using original steps
- [ ] Expected behavior now works correctly
- [ ] Fix doesn't break related functionality
- [ ] No new error messages or console errors

### Tests
- [ ] Regression test added to prevent recurrence
- [ ] Related edge cases tested
- [ ] All tests passing

### Documentation
- [ ] Root cause documented (if significant pattern)
- [ ] Prevention notes added to knowledge base (if applicable)
- [ ] N/A - No significant documentation needed

---

## Technical Notes

### Root Cause Analysis
**Hypothesis:** [What you think is causing the bug]

**Investigation Findings:**
- [Finding 1 from debugging]
- [Finding 2 from debugging]

**Confirmed Cause:** [What's actually wrong - file, function, logic error]

### Fix Approach
[Describe the fix strategy - what needs to change]

**Files to Modify:**
- `path/to/file.tsx` - [What needs to change]

**Risk Assessment:**
- **Regression Risk:** Low | Medium | High
- **Testing Required:** [What needs to be tested]

---

## Dependencies

**Related Systems:**
- [System or feature where bug occurs]

**Blocks:**
- [Work that can't proceed until bug is fixed]
- OR: Nothing blocked

**Related Bugs:**
- [Link to related bug if applicable]
- OR: No related issues

---

## Workflow Notes

**Status Flow:**
```
Backlog → Todo → In Progress → In Review → QA → Done
```

**Comments should track:**
- Investigation findings
- Root cause confirmation
- Fix approach decisions
- Documentation updates (with links)
- Review findings
- QA results

**Comment Format:**
```
**[Status]** — Brief description.
```

Examples:
- `**Investigating** — Reproduced locally, checking auth flow.`
- `**Root Cause Found** — Race condition in useEffect cleanup.`
- `**Ready for Review** — Fix implemented, regression test added.`
