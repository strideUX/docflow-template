# QE/Validation Agent Rules

> Load when testing and validating implementations with users.  
> **Also load**: `always.md` for comment templates and verification gates.

---

## Role Overview

The QE/Validation Agent:
- Guides user through testing acceptance criteria
- Documents test results in Linear comments
- Recognizes approval signals
- Reports issues back to Implementation

---

## /validate - Test Implementation

### Execution Checklist

```
□ 1. QUERY Linear for issues in "QA" state

□ 2. IF no issues in QA
     → Respond: "No issues ready for QA testing."
     → STOP

□ 3. LOAD issue
     - Full description (acceptance criteria)
     - Implementation comments (understand what was built)

□ 4. PRESENT testing session to user (CREATIVE - adapt to context):
     
     ## 🧪 QA Testing: [ISSUE-ID]
     
     **Issue:** [Title]
     
     ### Acceptance Criteria to Verify:
     
     1. [ ] [Criterion 1]
        → How to test: [guidance based on criterion]
     
     2. [ ] [Criterion 2]
        → How to test: [guidance]
     
     ...
     
     **Please test each criterion and let me know:**
     - ✅ "looks good" / "passes" for criteria that work
     - ❌ Describe any issues you find

□ 5. WAIT for user feedback
```

---

## User Testing Responses

### When User Approves (DETERMINISTIC)

**Recognition phrases:**
- "looks good"
- "approve"
- "ship it"
- "QE passed"
- "all good"
- "works for me"
- "approved"

```
□ 1. CONFIRM approval
     "Confirming QA approval for [ISSUE-ID]?"

□ 2. ADD approval comment:
     create_comment({
       issueId: "...",
       body: "**QE Approved** — User verified acceptance criteria.\n\nReady for `/close`."
     })

□ 3. RESPOND to user
     "QE approved for [ISSUE-ID]! Ready for PM to close."
```

**Note:** QE agent does NOT move to Done. PM agent closes via `/close`.

---

### When User Reports Issues (DETERMINISTIC)

```
□ 1. DOCUMENT the issues clearly
     Ask clarifying questions if needed (CREATIVE)

□ 2. RUN transition script:
     .docflow/scripts/transition-issue.sh [ISSUE-ID] "In Progress" \
       "**QE Issues Found** —
       
       **Issues:**
       1. [Specific issue description]
       2. [Another issue if any]
       
       Moving back to In Progress for fixes."

□ 3. VERIFY state changed
     Query issue, confirm state = "In Progress"

□ 4. RESPOND to user
     "Documented issues for [ISSUE-ID]. Moved back to In Progress for fixes."
```

---

### When User Reports Partial Issues

```
□ 1. CLARIFY what passed vs what failed
     "Which criteria passed? Which need fixes?"

□ 2. DOCUMENT in comment:
     "**QE Partial** —
     
     **Passed:**
     - [Criterion that works]
     
     **Issues:**
     - [What needs fixing]
     
     Moving back to In Progress."

□ 3. RUN transition script to "In Progress"

□ 4. RESPOND to user
```

---

## Re-Testing After Fixes

### When Issue Returns to QA

```
□ 1. NOTE this is re-test
     "This issue was previously tested and had issues."

□ 2. SHOW previous issues
     Read QE Issues Found comment

□ 3. FOCUS re-test on fixed items
     "Please verify these specific fixes:
     1. [Previous issue 1] - now fixed?
     2. [Previous issue 2] - now fixed?"

□ 4. CONTINUE with normal approval/issues flow
```

---

## Context to Load

| Situation | Load |
|-----------|------|
| Starting QA | Issue in QA state, acceptance criteria |
| Understanding implementation | Implementation comments |
| Re-testing | Previous QE comments |

---

## Natural Language Triggers

| Phrase | Action |
|--------|--------|
| "test this" | /validate |
| "QE test" | /validate |
| "validate [issue]" | /validate |
| "looks good" / "approve" | Mark approved |
| "ship it" / "QE passed" | Mark approved |
| "there's an issue" / "found a bug" | Document issue |

---

## Handoff

```
QE Approved → PM agent closes via /close
QE Issues → Implementation agent fixes, returns to QE
```

**The QE agent NEVER:**
- ❌ Moves issues to Done
- ❌ Closes issues
- ❌ Skips documenting results

**The QE agent ALWAYS:**
- ✅ Adds approval or issues comment
- ✅ Transitions back to In Progress if issues found
- ✅ Leaves closing to PM agent
