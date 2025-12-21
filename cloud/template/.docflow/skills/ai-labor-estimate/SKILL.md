# AI Labor Estimate Skill

> **Purpose**: Estimate token usage and API costs for AI-driven development tasks before implementation begins.

---

## Overview

This skill enables agents to:
1. **Analyze specs** to predict token consumption
2. **Calculate cost ranges** based on provider pricing
3. **Track actuals** for calibration over time
4. **Compare** Human vs AI vs Hybrid cost projections

---

## When to Use

| Trigger | Action |
|---------|--------|
| `/refine [spec]` | Calculate estimate, add to issue |
| `/activate [spec]` | **Validate** estimate exists; if missing, offer to calculate; warn on high estimates |
| `/implement [spec]` | **Validate** estimate exists; if missing, offer to calculate; show estimate in checklist |
| `/close [spec]` | Record actuals, calculate variance |
| Implementation complete | Estimate tokens used, update actuals in issue |
| User asks "how much will this cost?" | Run estimation |

### Validation Flow (for /activate and /implement)

```
1. Read issue description
2. Search for "## AI Effort Estimate" section
3. IF missing:
   → WARN: "⚠️ Missing AI Effort Estimate"
   → OFFER: "Would you like me to calculate one now?"
   → IF yes: Run estimation, update description
   → IF no: Proceed with warning about no baseline
4. IF present but has placeholders ([X]k):
   → OFFER: "Estimate exists but incomplete. Fill it now?"
5. IF estimate exceeds thresholds:
   → tokens > 200k OR cost > $5: Show warning
   → cost > $10: Require explicit approval
6. Continue with activation/implementation
```

---

## Estimation Formula

```
estimated_tokens = base_tokens × scope_mult × novelty_mult × clarity_mult × codebase_mult

Where:
  base_tokens     = task type baseline (see table below)
  scope_mult      = 0.5 (S) / 1.0 (M) / 2.0 (L) / 4.0 (XL)
  novelty_mult    = 0.7 (existing pattern) / 1.2 (partial new) / 2.0 (greenfield)
  clarity_mult    = 0.8 (well-defined) / 1.5 (needs discovery) / 2.5 (exploratory)
  codebase_mult   = 0.8 (simple) / 1.0 (moderate) / 1.5 (complex)

Confidence Range:
  low_estimate    = estimated_tokens × 0.6
  high_estimate   = estimated_tokens × 2.5
```

### Base Tokens by Task Type

| Task Type | Base Tokens | Rationale |
|-----------|-------------|-----------|
| **feature** | 40,000 | Full cycle: plan, implement, iterate, review |
| **bug** | 20,000 | Investigation + targeted fix |
| **chore** | 10,000 | Usually straightforward |
| **idea** | 5,000 | Quick exploration only |

---

## Scoring Multipliers

### Scope (from Complexity field)

| Complexity | Multiplier | Indicators |
|------------|------------|------------|
| **S** | 0.5 | 1-3 acceptance criteria, single file |
| **M** | 1.0 | 4-6 acceptance criteria, 2-5 files |
| **L** | 2.0 | 7-10 acceptance criteria, multiple modules |
| **XL** | 4.0 | 10+ criteria, cross-cutting changes |

### Novelty (from Technical Notes)

| Level | Multiplier | Indicators |
|-------|------------|------------|
| **existing-pattern** | 0.7 | "Follow existing X pattern", references similar code |
| **partial-new** | 1.2 | Mix of new + existing, some exploration needed |
| **greenfield** | 2.0 | New patterns, no precedent in codebase |

### Clarity (from Acceptance Criteria quality)

| Level | Multiplier | Indicators |
|-------|------------|------------|
| **well-defined** | 0.8 | All criteria specific & testable |
| **needs-discovery** | 1.5 | Some vague criteria, needs investigation |
| **exploratory** | 2.5 | Research-heavy, unclear solution |

### Codebase Complexity (from `stack.md`)

| Level | Multiplier | Indicators |
|-------|------------|------------|
| **simple** | 0.8 | Small codebase, clear patterns |
| **moderate** | 1.0 | Standard project, documented patterns |
| **complex** | 1.5 | Large codebase, multiple integrations |

---

## Cost Calculation

```
cost = tokens × (input_rate × input_ratio + output_rate × output_ratio)

Where:
  input_rate   = provider cost per 1M input tokens
  output_rate  = provider cost per 1M output tokens
  input_ratio  = 0.70 (typical for development)
  output_ratio = 0.30 (typical for development)
```

See `provider-costs.md` for current pricing.

---

## Issue Template Section

Add this to Linear issue description during `/refine`:

```markdown
---

## AI Effort Estimate

### Sizing Factors

| Factor | Value | Multiplier |
|--------|-------|------------|
| **Task Type** | [feature/bug/chore] | base: [X]k |
| **Scope** | [S/M/L/XL] | ×[0.5/1.0/2.0/4.0] |
| **Novelty** | [existing/partial/greenfield] | ×[0.7/1.2/2.0] |
| **Clarity** | [defined/discovery/exploratory] | ×[0.8/1.5/2.5] |
| **Codebase** | [simple/moderate/complex] | ×[0.8/1.0/1.5] |

### Estimate

**Provider**: [Claude Sonnet 4 / GPT-4o / etc.]  
**Calculated Tokens**: ~[X]k  
**Confidence**: ±[40-60]%  
**Token Range**: [low]k - [high]k  
**Cost Range**: $[low] - $[high]

### Comparison

| Approach | Est. Cost | Est. Time | Best For |
|----------|-----------|-----------|----------|
| **Full AI** | $[X] | [X] hrs | Well-defined, pattern-matching |
| **AI-Assisted** | $[X] + [X]hrs human | [X] hrs | Complex decisions |
| **Human-Led** | $[X] (review) + [X]hrs | [X] hrs | Novel architecture |

---
```

---

## Recording Actuals (on /close)

Add to issue comment on completion:

```markdown
## AI Effort Actuals

**Estimated Tokens**: [X]k  
**Actual Tokens**: [X]k (from session/API logs if available)  
**Variance**: [+/-X]% [under/over]  
**Actual Cost**: $[X]

### Variance Notes
- [What drove the variance - blockers, scope change, retries, etc.]
- [Lessons for future estimation]

### Calibration Data
- Task Type: [feature]
- Final Complexity: [M]
- Novelty Actual: [partial-new]
- Clarity Actual: [well-defined]
```

---

## Agent Instructions

### During /refine (PM Agent)

1. **Read the spec** completely
2. **Identify task type** from labels (feature, bug, chore, idea)
3. **Score each factor**:
   - Count acceptance criteria → scope
   - Check Technical Notes for patterns → novelty
   - Assess criteria specificity → clarity
   - Reference `stack.md` → codebase complexity
4. **Calculate estimate** using formula
5. **Look up provider costs** from `provider-costs.md` or `.docflow/config.json`
6. **Add estimate section** to issue description (replace placeholders with values)
7. **If estimate exceeds threshold**, flag for human review:
   - \> 200k tokens → Consider breaking down the issue
   - \> $5 estimated → Confirm before proceeding
8. **Include estimate in refine comment**: `AI Estimate: ~Xk tokens ($X-$X)`

### During /activate (PM Agent)

1. **Search issue description** for "## AI Effort Estimate"
2. **If missing**:
   - WARN: "⚠️ This issue is missing an AI Effort Estimate."
   - ASK: "Would you like me to calculate one now before activation?"
   - If yes → Calculate and add to description
   - If no → Proceed but note: "No baseline for actuals comparison"
3. **If present but incomplete** (still has `[X]k` placeholders):
   - OFFER: "AI Effort Estimate exists but has placeholder values. Complete it now?"
4. **If present and exceeds thresholds**:
   - \> 200k tokens or \> $5 → Show warning, ask for confirmation
   - \> $10 → Require explicit "yes proceed" before continuing
5. **Include in activation comment**: `AI Effort: ~Xk tokens ($X-$X)`

### During /implement (Implementation Agent)

1. **Search issue description** for "## AI Effort Estimate"
2. **If missing**:
   - WARN: "⚠️ Missing AI Effort Estimate - tracking actuals won't have comparison baseline."
   - OFFER: "Calculate estimate before starting implementation?"
   - If yes → Calculate estimate, update description
   - If no → Proceed with warning
3. **If present**:
   - Show estimate in implementation checklist
   - Note: "Tracking against estimate of ~Xk tokens"
4. **During implementation**:
   - Keep rough mental model of token usage
   - Note if work is going significantly over estimate (scope discovery, retries)

### On Implementation Complete (Implementation Agent)

1. **Estimate actual tokens used**:
   - Rough method: conversation turns × ~2k tokens/turn
   - Or estimate based on files changed, complexity of work
2. **Update AI Effort Estimate section** in issue description:
   - Fill "Actual Tokens" field
   - Calculate variance percentage
   - Add notes on variance drivers
3. **Include in completion comment**: `AI Effort: ~Xk actual (estimated Xk, +/-X% variance)`

### During /close (PM Agent)

1. **Verify actuals were recorded** (from implementation completion)
2. **If actuals missing**: Estimate based on issue activity/comments
3. **Calculate final variance** from estimate
4. **Add final actuals to issue** if not already present
5. **Log patterns for calibration**:
   - Which factor assessments were off?
   - What should be adjusted for similar future work?
6. **Include in close comment**: `Final AI Effort: ~Xk tokens (+/-X% from estimate)`

---

## Configuration

In `.docflow/config.json`:

```json
{
  "aiLabor": {
    "enabled": true,
    "defaultProvider": "claude-sonnet-4",
    "thresholds": {
      "warnTokens": 200000,
      "warnCost": 5.00,
      "requireApproval": 10.00
    },
    "tracking": {
      "recordActuals": true,
      "calibrationEnabled": true
    }
  }
}
```

---

## Example Calculation

**Spec**: "Add user profile photo upload"

| Factor | Assessment | Value |
|--------|------------|-------|
| Type | Feature | 40k base |
| Scope | M (5 criteria, ~4 files) | ×1.0 |
| Novelty | Existing pattern (similar to doc upload) | ×0.7 |
| Clarity | Well-defined (clear criteria) | ×0.8 |
| Codebase | Moderate | ×1.0 |

**Calculation**:
```
40,000 × 1.0 × 0.7 × 0.8 × 1.0 = 22,400 tokens

Range: 13,440 - 56,000 tokens (±60% confidence)

Cost (Claude Sonnet 4 @ $3/$15 per 1M):
  Low:  13.4k × (0.7×$3 + 0.3×$15)/1M = $0.09
  High: 56k × (0.7×$3 + 0.3×$15)/1M = $0.37
```

**Result**: ~22k tokens, $0.09 - $0.37 estimated cost

---

## Related Skills

- `linear-workflow` - For updating Linear issues
- `spec-templates` - Template structure reference

---

## Calibration Over Time

Track estimates vs actuals to improve accuracy:

1. **Log all estimates and actuals** in issue comments
2. **Review monthly** for patterns:
   - Which task types are consistently over/under?
   - Which factors need adjustment?
3. **Adjust multipliers** based on your codebase patterns
4. **Document adjustments** in `.docflow/knowledge/notes/`

