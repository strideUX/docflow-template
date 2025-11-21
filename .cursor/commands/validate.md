# Validate (QE/Validation Agent)

## Overview
Review implementation and work with user to test and validate. Iterate until user approves.

**Agent Role:** QE/Validation Agent (tester & validator)  
**Frequency:** When implementation is marked for review

**This receives the handoff from Implementation Agent.**

---

## Steps

### 1. **Find Work to Validate**
Check /docflow/specs/active/ for specs with:
- status=REVIEW (just completed, needs validation)
- status=QE_TESTING (already in testing, may need to continue)

**If user specified spec:**
- Load that spec

**If multiple available:**
- Infer from context or ask: "Which spec should I validate: [list]?"

**If none available:**
- Report: "No specs ready for validation."

### 2. **Load Full Context**
Load everything needed:
- The complete spec (especially Implementation Notes section)
- /docflow/context/standards.md (code quality checklist)
- Review what was built and why

### 3. **Perform DocFlow Code Review**
**Check Implementation Quality:**
- [ ] All acceptance criteria met
- [ ] No unauthorized scope changes
- [ ] TypeScript strict mode compliance
- [ ] Proper error handling
- [ ] Code follows patterns in standards.md
- [ ] Implementation Notes complete and clear

**Fill out DocFlow Review section in spec:**
```markdown
**Reviewed By**: DocFlow Agent
**Review Date**: YYYY-MM-DD
**Decision**: ✅ APPROVED | ⚠️ CHANGES NEEDED

### Review Findings
**Code Quality**: ⭐ Excellent | ✓ Good | ⚠️ Needs Work
[Comments]

**Standards Compliance**: ✅ Passed | ⚠️ Issues Found
[Comments]

**Test Coverage**: ✅ Adequate | ⚠️ Insufficient
[Comments]
```

### 4. **Decision Point: Approve or Send Back**

**If Code Issues Found:**
- Document specific issues in DocFlow Review section
- Add issues to Implementation Notes for context
- Set status=IMPLEMENTING, owner=Implementation
- Summarize what needs fixing
- **This sends back to Implementation Agent**
- STOP here - don't proceed to QE testing

**If Code Approved:**
- Continue to step 5

### 5. **Set Up QE Testing** (if code approved)
Update spec metadata:
```markdown
**Status**: QE_TESTING
**Owner**: User
**Last Updated**: YYYY-MM-DD
```

Add note to DocFlow Review section:
"✅ Code review passed. Ready for QE testing and validation."

### 6. **Generate Testing Guidance for User**
Create testing checklist based on acceptance criteria:

"✅ Code review complete! Ready for your testing.

**What to test:**
1. [Test scenario from criterion 1]
2. [Test scenario from criterion 2]
3. [Test scenario from criterion 3]

**Where to test:**
- [URL/page/feature location]

**Test these scenarios:**
- ✅ [Happy path]
- ⚠️ [Edge case 1]
- ⚠️ [Edge case 2]
- ❌ [Error case - verify error handling]

**Let me know:**
- If everything works as expected, say \"looks good\" or \"approve\"
- If you find issues, describe what's wrong and I'll document them
"

### 7. **Work Iteratively with User**
**During testing session:**

**If user finds issues:**
- Document in QE Testing section
- Add to Implementation Notes with details
- Set status=IMPLEMENTING
- Send back to Implementation Agent
- Summarize: "I've documented the issues. Sending back to implementation."

**If user approves:**
- Fill out QE Testing section with approval
- Prepare spec for closure
- Tell user: "Perfect! Ready for PM agent to /close this."

### 8. **Never Auto-Close**
Wait for explicit user approval.

**Don't close the spec yourself** - that's the PM agent's job via `/close` command.

---

## Context to Load
- Spec with Implementation Notes (complete)
- /docflow/context/standards.md (quality checklist)
- Implementation Notes (what was built)

---

## Natural Language Triggers
User might say:
- "validate [spec]" / "test [spec]"
- "review the implementation"
- "let's test this" / "ready to test"
- "check if this works"

**Run this command when detected.**

---

## Outputs
- DocFlow Review section filled out
- Testing guidance for user
- Iterative testing feedback
- Issues documented OR approval confirmed
- Spec ready for closure (if approved)

---

## Checklist
- [ ] Loaded spec with Implementation Notes
- [ ] Performed code review against standards
- [ ] Filled out DocFlow Review section
- [ ] Decision: Approve or send back
- [ ] If approved: Set status=QE_TESTING
- [ ] If approved: Generated testing guidance
- [ ] Worked iteratively with user
- [ ] Documented issues OR approval
- [ ] Did NOT auto-close spec

