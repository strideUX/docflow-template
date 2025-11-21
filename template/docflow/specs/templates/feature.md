# Feature: [Short Descriptive Name]

<!-- 
AGENT INSTRUCTIONS:
- Replace [Short Descriptive Name] with kebab-case filename (e.g., "User Dashboard" → feature-user-dashboard.md)
- Fill ALL sections marked with brackets [like this]
- Update Status as work progresses: BACKLOG → READY → IMPLEMENTING → REVIEW → QE_TESTING → COMPLETE
- Set Complexity: S (few hours), M (1-2 days), L (3-5 days), XL (1 week)
- If larger than XL, break into smaller features
- Keep this template structure intact - don't remove sections
- Update Last Updated timestamp whenever you modify this file
-->

**Status**: BACKLOG  
**Owner**: DocFlow  
**AssignedTo**: Unassigned  
**Priority**: High | Medium | Low  
**Complexity**: S | M | L | XL  
**Created**: YYYY-MM-DD  
**Last Updated**: YYYY-MM-DD

---

## Context
<!-- 
AGENT: Explain the "why" behind this feature. What problem does it solve? 
Include: Current pain points, user needs, business value
-->

[Why does this feature exist? What problem does it solve?]

**Current Issues:**
- [Issue or limitation 1]
- [Issue or limitation 2]
- [Issue or limitation 3]

---

## User Story
<!-- 
AGENT: Define WHO needs this, WHAT they want to do, and WHY it matters.
Use actual user role from the project (e.g., "Project Manager", "Client", "Admin")
-->

**As a** [specific user role]  
**I want to** [specific goal or action]  
**So that** [concrete benefit or outcome]

**Example Scenario:**
[Describe a real-world scenario where this feature would be used]

---

## Acceptance Criteria
<!-- 
AGENT: List SPECIFIC, TESTABLE criteria. Each should be verifiable yes/no.
Good: "User can upload files up to 10MB"
Bad: "File upload works well"
Check off items [x] as you complete them during implementation.
-->

### Must Have (Required)
- [ ] [Specific, measurable criterion 1]
- [ ] [User can perform X action and see Y result]
- [ ] [System behaves correctly when Z happens]
- [ ] [Error handling: System shows helpful message when...]

### Should Have (Important but not blocking)
- [ ] [Nice-to-have criterion 1]
- [ ] [Performance: Action completes in < X seconds]

### Won't Have (Out of scope for now)
- [ ] [Future enhancement 1]
- [ ] [Feature that can wait for later]

---

## Technical Notes
<!-- 
AGENT: Planning section - fill this out BEFORE implementing.
Search codebase for existing patterns to follow or reuse.
Reference /docflow/context/stack.md for architectural patterns.
-->

### Implementation Approach
[High-level description of how this will be built]

**Key Technical Decisions:**
1. [Decision 1 and rationale]
2. [Decision 2 and rationale]

### Components Needed
**New Components to Create:**
- `ComponentName` - [What it does]
- `HelperFunction` - [What it does]

**Existing Components to Modify:**
- `ExistingComponent` (path/to/file.tsx) - [What changes are needed]

### Data Model
<!-- If database changes are needed -->
```typescript
// New tables/fields needed
// OR: "No data model changes required"
```

### API Endpoints
<!-- If backend changes are needed -->
- `POST /api/endpoint` - [Description]
- `GET /api/endpoint` - [Description]
- OR: [No new endpoints required]

### UI/UX Considerations
- [Layout/design notes]
- [User flow considerations]
- [Accessibility requirements]

---

## Dependencies
<!-- 
AGENT: Document what this feature relies on and what relies on it.
Check /docflow/knowledge/ for related decisions or features.
-->

**Required Before Starting:**
- [Feature or system that must exist first]
- [Dependency 2]
- OR: [No dependencies - can start immediately]

**Modifies These Systems:**
- [Existing feature/module that will change]
- [System 2]

**Enables Future Work:**
- [Feature that depends on this being complete]
- [Future work 2]

---

## Decision Log
<!-- 
AGENT: Add dated entries as you make decisions during planning and implementation.
Format: ### YYYY-MM-DD - Decision Title
Include: What was decided, why, and what alternatives were considered
-->

### YYYY-MM-DD - Initial Spec Created
**Decision:** Created feature spec for [feature name]  
**Rationale:** [Why this feature was proposed and prioritized]  
**Alternatives Considered:** [Other approaches that were discussed]

<!-- Add more entries as decisions are made -->

---

## Implementation Notes
<!-- 
AGENT: Fill this section progressively AS YOU IMPLEMENT.
Document what you're building, key decisions, files changed, problems solved.
This becomes the historical record of how this feature was built.
-->

**Started**: YYYY-MM-DD  
**Status**: [In Progress | Completed | Blocked]

### Files Changed
<!-- Update this list as you work -->
**Created:**
- `path/to/new-file.tsx` - [Description of what this file does]

**Modified:**
- `path/to/existing-file.tsx` - [What changed and why]

### Implementation Progress
<!-- Track your progress -->
- [x] [Completed task 1]
- [x] [Completed task 2]
- [ ] [In progress task 3]
- [ ] [Not started task 4]

### Key Implementation Decisions
<!-- Document decisions made DURING implementation -->
1. **[Decision made during coding]**
   - Why: [Rationale]
   - Impact: [What this affects]

### Challenges & Solutions
<!-- Document problems you encountered and how you solved them -->
1. **Challenge:** [Problem you encountered]
   - **Solution:** [How you solved it]
   - **Learning:** [What to remember for next time]

### Deviations from Original Plan
<!-- If you had to change the approach from what was planned -->
- [What changed from the original spec]
- [Why the change was necessary]
- [Impact of the change]

---

## Blockers
<!-- 
AGENT: Document anything preventing progress. Update status to REVIEW when blocked.
-->

[None currently | List active blockers here]

**Current Blocker:**
- **Issue:** [What's blocking progress]
- **Needs:** [What's needed to unblock]
- **Blocking Since:** YYYY-MM-DD

---

## DocFlow Review
<!-- 
AGENT (DocFlow): Fill this section when implementation is complete (status=REVIEW).
Verify all acceptance criteria met, check code quality, ensure standards compliance.
Set status to QE_TESTING if approved, or back to IMPLEMENTING if changes needed.
-->

**Reviewed By**: DocFlow Agent  
**Review Date**: YYYY-MM-DD  
**Decision**: ✅ APPROVED | ⚠️ CHANGES NEEDED

### Code Review Checklist
- [ ] All acceptance criteria met
- [ ] No unauthorized scope changes
- [ ] Follows TypeScript strict mode
- [ ] Proper error handling implemented
- [ ] Code follows patterns in /docflow/context/standards.md
- [ ] Implementation notes complete and clear

### Review Findings

**Code Quality**: ⭐ Excellent | ✓ Good | ⚠️ Needs Work  
[Comments on implementation quality]

**Standards Compliance**: ✅ Passed | ⚠️ Issues Found  
[Comments on adherence to coding standards]

**Testing Coverage**: ✅ Adequate | ⚠️ Insufficient  
[Comments on testing approach]

### Changes Required (if any)
1. [Required change 1 with specific guidance]
2. [Required change 2 with specific guidance]

### Approval Decision
[Summary: Ready for QE testing | Needs revisions - see changes required above]

---

## QE Testing & Validation
<!-- 
AGENT (User): Fill this section when testing the implementation.
Test ALL acceptance criteria in a real environment.
Approve with phrases like "looks good", "approve", "ship it" to move to COMPLETE.
Report any issues to send back to IMPLEMENTING.
-->

**Tested By**: @username  
**Test Date**: YYYY-MM-DD  
**Status**: PENDING | IN_PROGRESS | ✅ PASSED | ❌ FAILED

### Functional Testing
- [ ] All acceptance criteria validated in real environment
- [ ] Core functionality works as expected
- [ ] Edge cases tested and working
- [ ] User experience meets expectations
- [ ] No regressions in related features
- [ ] Performance is acceptable
- [ ] Works on different screen sizes/devices
- [ ] Error messages are clear and helpful

### Test Scenarios
<!-- Document what you actually tested -->
1. **Scenario:** [What you tested]
   - **Result:** ✅ PASS | ❌ FAIL
   - **Notes:** [Any observations]

2. **Scenario:** [What you tested]
   - **Result:** ✅ PASS | ❌ FAIL
   - **Notes:** [Any observations]

### Issues Found
<!-- If you found bugs or issues during testing -->

**Issue 1:**
- **Description:** [What's wrong]
- **Steps to Reproduce:** [How to see the problem]
- **Expected:** [What should happen]
- **Actual:** [What actually happens]
- **Severity:** High | Medium | Low
- **Screenshot:** [See /docflow/specs/assets/[spec-name]/ if applicable]

### Final Approval
<!-- User decision after testing -->

**Date**: YYYY-MM-DD  
**Decision**: ✅ APPROVED - Ready to close | ⚠️ NEEDS FIXES

[Final comments: Is this ready for production? Any concerns? Celebration notes?]

---

## Future Enhancements
<!-- 
Ideas for improvements that are out of scope for current work.
These can become new specs in the backlog.
-->

- [Enhancement idea 1]
- [Enhancement idea 2]
- [Enhancement idea 3]
