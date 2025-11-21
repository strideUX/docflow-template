# Bug: [Short Descriptive Name]

<!-- 
AGENT INSTRUCTIONS:
- Replace [Short Descriptive Name] with kebab-case filename (e.g., "Login Error" → bug-login-error.md)
- Fill ALL sections marked with brackets [like this]
- Add screenshots to /docflow/specs/assets/[spec-name]/ if helpful
- Set Complexity: S (quick fix), M (few hours), L (1-2 days), XL (major refactor)
- If larger than XL, consider breaking into multiple bugs or converting to feature
- Update Status as work progresses: BACKLOG → READY → IMPLEMENTING → REVIEW → QE_TESTING → COMPLETE
- Keep this template structure intact - don't remove sections
- Update Last Updated timestamp whenever you modify this file
-->

**Status**: BACKLOG  
**Owner**: DocFlow  
**AssignedTo**: Unassigned  
**Priority**: Critical | High | Medium | Low  
**Complexity**: S | M | L | XL  
**Created**: YYYY-MM-DD  
**Last Updated**: YYYY-MM-DD

---

## Context
<!-- 
AGENT: Explain when this was discovered and the impact.
Include: User reports, when it started happening, frequency, who's affected
-->

**When Discovered**: [Date or event when bug was found]  
**Discovered By**: [User, developer, automated test, etc.]  
**Impact**: [How this affects users or the system]  
**Frequency**: [Always | Sometimes | Rarely | Under specific conditions]

[Additional context about the bug]

---

## Bug Description
<!-- 
AGENT: Be VERY specific about what's wrong. 
Good bug reports have: exact steps, what happens, what should happen instead.
-->

### Expected Behavior
[Describe what SHOULD happen - the correct behavior]

### Actual Behavior
[Describe what ACTUALLY happens - the broken behavior]

### Steps to Reproduce
<!-- AGENT: Provide EXACT steps so anyone can reproduce the bug -->
1. [First action - be specific]
2. [Second action - include any data/conditions needed]
3. [Third action]
4. [Observe the bug]

### Environment
<!-- Where does this bug occur? -->
- **Browser/Platform**: [Chrome, Safari, Mobile, etc.]
- **OS**: [macOS, Windows, iOS, Android, etc.]
- **User Role**: [Which user type experiences this]
- **Data Conditions**: [Specific data state that triggers bug]

### Screenshots/Evidence
<!-- If you have screenshots, add them to /docflow/specs/assets/[spec-name]/ -->
- [Screenshot 1: See /docflow/specs/assets/bug-name/error.png]
- [Console errors: See asset folder]
- OR: [No screenshots available]

---

## Acceptance Criteria
<!-- 
AGENT: Define what "fixed" means. How will we know the bug is resolved?
Check off items [x] as you complete them during implementation.
-->

### Must Fix
- [ ] Bug no longer reproducible using original steps
- [ ] No error messages or console errors
- [ ] Expected behavior now works correctly
- [ ] Fix doesn't break related functionality

### Verification
- [ ] Regression test added to prevent bug from returning
- [ ] Related edge cases tested and working
- [ ] Fix tested in all affected environments
- [ ] No new bugs introduced by the fix

---

## Technical Notes
<!-- 
AGENT: Analysis section - fill this out BEFORE fixing.
-->

### Root Cause Analysis
<!-- What's actually causing the bug? -->
**Hypothesis**: [What you think is causing the bug]

**Investigation Findings**:
- [Finding 1 from debugging]
- [Finding 2 from debugging]

**Confirmed Cause**: [What's actually wrong - file, function, logic error]

### Fix Approach
<!-- How will you fix it? -->
[Describe the fix strategy - what needs to change]

**Files to Modify:**
- `path/to/file.tsx` - [What needs to change]
- `path/to/file2.tsx` - [What needs to change]

**Fix Strategy:**
1. [Step 1 of the fix]
2. [Step 2 of the fix]
3. [Step 3 of the fix]

### Affected Areas
<!-- What else might be impacted by this bug or the fix? -->
- [Feature/area 1 that might be affected]
- [Feature/area 2 that might be affected]
- OR: [Isolated bug - no other areas affected]

### Risk Assessment
**Risk of Regression**: Low | Medium | High  
**Testing Required**: [What needs to be tested]  
**Related Areas to Test**: [List features that might be affected]

---

## Dependencies
<!-- 
AGENT: What does this bug depend on? What's blocked by it?
-->

**Related Systems:**
- [System or feature where bug occurs]
- [Related functionality]

**Blocks:**
- [Work that can't proceed until bug is fixed]
- OR: [Nothing blocked]

**Related Bugs/Issues:**
- [Link to related bug if applicable]
- OR: [No related issues]

---

## Decision Log
<!-- 
AGENT: Track the investigation and fix decisions.
Document your debugging process and why you chose this fix approach.
-->

### YYYY-MM-DD - Bug Reported
**Description:** [Initial bug report]  
**Severity:** Critical | High | Medium | Low  
**Impact:** [Who/what is affected and how severely]

### YYYY-MM-DD - Investigation Started
**Findings:** [What you discovered during debugging]  
**Root Cause:** [What's actually causing the bug]

### YYYY-MM-DD - Fix Approach Decided
**Decision:** [How you'll fix it]  
**Rationale:** [Why this approach over alternatives]  
**Alternatives Considered:** [Other fixes you considered and why you didn't choose them]

---

## Implementation Notes
<!-- 
AGENT: Fill this section AS YOU FIX the bug.
Document what you changed, why, and any challenges.
-->

**Started**: YYYY-MM-DD  
**Status**: [In Progress | Completed | Blocked]

### Files Changed
**Modified:**
- `path/to/file.tsx`
  - **Change:** [What you changed]
  - **Why:** [Why this fixes the bug]
  - **Lines:** [Line numbers or function names]

### Fix Implementation
<!-- What did you actually do? -->
1. [x] [Completed step 1]
2. [x] [Completed step 2]
3. [ ] [Step 3]

**Technical Details:**
[Detailed explanation of the fix - code logic, approach, why it works]

### Testing Performed
<!-- What testing did you do while implementing? -->
- [x] [Test 1 - manual verification]
- [x] [Test 2 - checked edge cases]
- [ ] [Test 3 - regression testing]

### Challenges Encountered
<!-- Any problems during the fix? -->
1. **Challenge:** [Problem you hit]
   - **Solution:** [How you resolved it]

### Side Effects
<!-- Did fixing this reveal or cause anything else? -->
- [Any side effects or related issues discovered]
- OR: [No side effects]

---

## Blockers
<!-- 
AGENT: Document anything preventing the fix.
-->

[None currently | List active blockers here]

**Current Blocker:**
- **Issue:** [What's blocking the fix]
- **Needs:** [What's needed to unblock]
- **Blocking Since:** YYYY-MM-DD

---

## DocFlow Review
<!-- 
AGENT (DocFlow): Review the bug fix before QE testing.
Verify the fix is correct, complete, and doesn't introduce new issues.
-->

**Reviewed By**: DocFlow Agent  
**Review Date**: YYYY-MM-DD  
**Decision**: ✅ APPROVED | ⚠️ CHANGES NEEDED

### Code Review Checklist
- [ ] Fix addresses root cause (not just symptoms)
- [ ] No unauthorized scope changes
- [ ] Follows TypeScript strict mode
- [ ] Proper error handling if applicable
- [ ] Code follows patterns in /docflow/context/standards.md
- [ ] Implementation notes document the fix clearly

### Review Findings

**Fix Quality**: ⭐ Excellent | ✓ Good | ⚠️ Needs Work  
[Assessment of the fix approach and implementation]

**Regression Risk**: ✅ Low | ⚠️ Medium | ❌ High  
[Assessment of whether this might break something else]

**Test Coverage**: ✅ Adequate | ⚠️ Insufficient  
[Assessment of testing performed]

### Changes Required (if any)
1. [Required change 1]
2. [Required change 2]

### Approval Decision
[Summary: Ready for QE testing | Needs revisions]

---

## QE Testing & Validation
<!-- 
AGENT (User): Test the bug fix thoroughly.
Verify the bug is gone AND nothing else broke.
-->

**Tested By**: @username  
**Test Date**: YYYY-MM-DD  
**Status**: PENDING | IN_PROGRESS | ✅ PASSED | ❌ FAILED

### Bug Fix Verification
- [ ] Original steps to reproduce NO LONGER trigger the bug
- [ ] Expected behavior now works correctly
- [ ] No error messages or console errors
- [ ] Bug stays fixed after multiple attempts
- [ ] Fix works in all affected environments
- [ ] Fix works for all affected user roles

### Regression Testing
- [ ] Related features still work correctly
- [ ] No new bugs introduced elsewhere
- [ ] Performance not negatively affected
- [ ] UI/UX still functions as expected

### Test Results

**Original Bug Test:**
- **Steps Performed:** [Retested original repro steps]
- **Result:** ✅ Bug fixed | ❌ Bug still present
- **Notes:** [Observations]

**Edge Case Tests:**
1. **Test:** [Edge case tested]
   - **Result:** ✅ PASS | ❌ FAIL
   - **Notes:** [Observations]

2. **Test:** [Edge case tested]
   - **Result:** ✅ PASS | ❌ FAIL
   - **Notes:** [Observations]

### Issues Found During Testing
<!-- If the fix didn't work or created new problems -->

**Issue:**
- **Description:** [What's still wrong or what broke]
- **Severity:** High | Medium | Low
- **Action Needed:** [What needs to be fixed]

### Final Approval
<!-- User decision after testing -->

**Date**: YYYY-MM-DD  
**Decision**: ✅ APPROVED - Bug is fixed | ⚠️ NEEDS MORE WORK

[Final comments and observations]

---

## Prevention
<!-- 
How can we prevent this type of bug in the future?
This might become a knowledge/notes doc or a standards update.
-->

**Root Cause Category:** [Logic error | Missing validation | Race condition | etc.]

**Prevention Ideas:**
- [Test we should add]
- [Pattern we should follow]
- [Documentation we should create]

**Follow-up Actions:**
- [ ] [Add to testing checklist]
- [ ] [Update coding standards]
- [ ] [Document in /docflow/knowledge/notes/]
