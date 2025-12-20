<!-- AGENT INSTRUCTIONS
When creating or refining a feature issue:

1. CONTEXT SECTION:
   - Explain the problem being solved, not just the solution
   - Include business value or user impact
   - Reference project goals from {content-folder}/context/overview.md if relevant

2. USER STORY:
   - Must follow "As a... I want... So that..." format
   - Be specific about the user role (not just "user")
   - Benefit should be concrete and measurable
   - Include an example scenario for clarity

3. ACCEPTANCE CRITERIA:
   - Each criterion must be testable and specific
   - Use checkboxes for tracking completion
   - Include error handling scenarios
   - "Must Have" = required for completion
   - "Should Have" = nice to have, not blocking
   - "Won't Have" = explicitly out of scope

4. TECHNICAL NOTES:
   - Reference patterns from {content-folder}/context/stack.md
   - List specific components/files to create or modify
   - Include data model changes if applicable
   - Note any API changes needed

5. DEPENDENCIES:
   - List issues that must be completed first
   - Note what future work this enables

Remove these instructions when creating the final issue.
-->

## Context

[Problem description - what user pain or business need does this address?]

**Current Issues:**
- [Issue or limitation 1]
- [Issue or limitation 2]

---

## User Story

**As a** [specific user role]
**I want to** [specific goal or action]
**So that** [concrete benefit or outcome]

**Example Scenario:**
[Real-world scenario where this feature would be used]

---

## Acceptance Criteria

### Must Have
- [ ] [Specific, measurable criterion 1]
- [ ] [User can perform X action and see Y result]
- [ ] [System behaves correctly when Z happens]
- [ ] [Error handling: System shows helpful message when...]

### Should Have
- [ ] [Nice-to-have enhancement]

### Won't Have (Out of Scope)
- [Explicitly excluded functionality]

### Tests
- [ ] Tests written for core functionality
- [ ] Edge cases and error scenarios covered
- [ ] All tests passing

### Documentation
- [ ] Code documented (comments on complex logic)
- [ ] Knowledge base updated (if significant decisions/patterns)
- [ ] Context files updated (if architecture changes)
- [ ] N/A - No significant documentation needed

---

## Technical Notes

### Implementation Approach
[High-level description of how this will be built]

**Key Technical Decisions:**
1. [Decision 1 and rationale]
2. [Decision 2 and rationale]

### Components Needed
**New:**
- `ComponentName` - [What it does]

**Modify:**
- `ExistingComponent` - [What changes needed]

### Data Model
```typescript
// Schema changes if any
// OR: No data model changes required
```

### API Endpoints
- `POST /api/endpoint` - [Description]
- OR: No new endpoints required

---

## Dependencies

**Required Before Starting:**
- [Feature or system that must exist first]
- OR: No dependencies - can start immediately

**Enables Future Work:**
- [Feature that depends on this being complete]

---

## Design Reference
<!-- Add Figma links as attachments -->

---

## AI Effort Estimate
<!-- 
AGENT: Fill this section during /refine using the ai-labor-estimate skill.
See .docflow/skills/ai-labor-estimate/SKILL.md for calculation details.
Update Actuals section during /close for calibration.
-->

### Sizing Factors

| Factor | Value | Multiplier |
|--------|-------|------------|
| **Task Type** | feature | base: 40k |
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

### Approach Comparison

| Approach | Est. Cost | Est. Time | Recommendation |
|----------|-----------|-----------|----------------|
| **Full AI** | $[X] | [X] hrs | [When to use] |
| **AI-Assisted** | $[X] + [X]hrs | [X] hrs | [When to use] |
| **Human-Led** | $[X] (review) | [X] hrs | [When to use] |

### Actuals (fill on /close)
**Actual Tokens**: [fill after completion]  
**Variance**: [+/-X]% [under/over estimate]  
**Notes**: [what drove variance - blockers, scope changes, retries]

---

_Created: YYYY-MM-DD_




