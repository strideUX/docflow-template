<!-- AGENT INSTRUCTIONS
When creating or refining a bug issue:

1. CONTEXT SECTION:
   - Capture when/how the bug was discovered
   - Assess user impact (how many affected, how severe)
   - Note frequency (always, sometimes, specific conditions)

2. BUG DESCRIPTION:
   - Expected vs Actual must be crystal clear
   - Steps to reproduce must be detailed enough for anyone to follow
   - Include specific data conditions if relevant
   - Note environment details (browser, OS, user role)

3. ACCEPTANCE CRITERIA:
   - "Fix Verification" should mirror the reproduction steps
   - Include regression concerns (what else might break)
   - Tests section should include regression test requirement

4. TECHNICAL NOTES:
   - Start with hypothesis if cause unknown
   - Update "Confirmed Cause" after investigation
   - Include specific file/function where bug exists
   - Assess risk of the fix

5. SEVERITY GUIDANCE:
   - Critical: System unusable, data loss, security issue
   - High: Major feature broken, no workaround
   - Medium: Feature impaired but workaround exists
   - Low: Minor issue, cosmetic, edge case

Remove these instructions when creating the final issue.
-->

## Context

**When Discovered:** [Date or event when bug was found]
**Discovered By:** [User, developer, automated test, etc.]
**Impact:** [How this affects users - be specific about scope]
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

## AI Effort Estimate
<!-- 
AGENT: Fill this section during /refine using the ai-labor-estimate skill.
See .claude/skills/ai-labor-estimate/SKILL.md for calculation details.
Update Actuals section during /close for calibration.
-->

### Sizing Factors

| Factor | Value | Multiplier |
|--------|-------|------------|
| **Task Type** | bug | base: 20k |
| **Scope** | [S/M/L/XL] | ×[0.5/1.0/2.0/4.0] |
| **Novelty** | [existing/partial/greenfield] | ×[0.7/1.2/2.0] |
| **Clarity** | [defined/discovery/exploratory] | ×[0.8/1.5/2.5] |
| **Codebase** | [simple/moderate/complex] | ×[0.8/1.0/1.5] |

### Estimate

**Provider**: [Claude Sonnet 4]  
**Calculated Tokens**: ~[X]k  
**Confidence**: ±[40-60]%  
**Token Range**: [low]k - [high]k  
**Cost Range**: $[low] - $[high]

### Actuals (fill on /close)
**Actual Tokens**: [fill after completion]  
**Variance**: [+/-X]% [under/over estimate]  
**Notes**: [what drove variance - investigation time, fix complexity, retries]

---

_Reported: YYYY-MM-DD_





