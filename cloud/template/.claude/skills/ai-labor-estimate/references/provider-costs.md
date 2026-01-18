# AI Provider Costs

> **Last Updated**: 2025-01  
> **Note**: Prices change frequently. Verify current rates at provider websites.

---

## Quick Reference

| Provider | Model | Input (per 1M) | Output (per 1M) | Blended* |
|----------|-------|----------------|-----------------|----------|
| **Anthropic** | Claude Sonnet 4 | $3.00 | $15.00 | $6.60 |
| **Anthropic** | Claude Opus 4 | $15.00 | $75.00 | $33.00 |
| **Anthropic** | Claude Haiku 3.5 | $0.80 | $4.00 | $1.76 |
| **OpenAI** | GPT-4o | $2.50 | $10.00 | $4.75 |
| **OpenAI** | GPT-4o-mini | $0.15 | $0.60 | $0.29 |
| **OpenAI** | o1 | $15.00 | $60.00 | $28.50 |
| **OpenAI** | o3-mini | $1.10 | $4.40 | $2.09 |
| **Google** | Gemini 2.0 Flash | $0.10 | $0.40 | $0.19 |
| **Google** | Gemini 1.5 Pro | $1.25 | $5.00 | $2.38 |

*Blended assumes 70% input / 30% output ratio typical for development tasks.

---

## Detailed Pricing

### Anthropic (Claude)

| Model | Input | Output | Context | Best For |
|-------|-------|--------|---------|----------|
| **Claude Opus 4** | $15.00/1M | $75.00/1M | 200K | Complex reasoning, architecture |
| **Claude Sonnet 4** | $3.00/1M | $15.00/1M | 200K | Balanced: code + reasoning |
| **Claude Haiku 3.5** | $0.80/1M | $4.00/1M | 200K | Fast tasks, simple edits |

**Recommended for DocFlow**: Claude Sonnet 4 (best balance for development)

### OpenAI

| Model | Input | Output | Context | Best For |
|-------|-------|--------|---------|----------|
| **o1** | $15.00/1M | $60.00/1M | 200K | Complex reasoning |
| **o3-mini** | $1.10/1M | $4.40/1M | 200K | Fast reasoning |
| **GPT-4o** | $2.50/1M | $10.00/1M | 128K | General development |
| **GPT-4o-mini** | $0.15/1M | $0.60/1M | 128K | Simple tasks |

### Google (Gemini)

| Model | Input | Output | Context | Best For |
|-------|-------|--------|---------|----------|
| **Gemini 2.0 Flash** | $0.10/1M | $0.40/1M | 1M | Large context, speed |
| **Gemini 1.5 Pro** | $1.25/1M | $5.00/1M | 2M | Very large context |

---

## Cost Calculation Examples

### Example 1: Small Feature (22k tokens)

| Provider | Model | Cost |
|----------|-------|------|
| Anthropic | Claude Sonnet 4 | $0.15 |
| OpenAI | GPT-4o | $0.10 |
| Google | Gemini 2.0 Flash | $0.004 |

### Example 2: Medium Feature (75k tokens)

| Provider | Model | Cost |
|----------|-------|------|
| Anthropic | Claude Sonnet 4 | $0.50 |
| OpenAI | GPT-4o | $0.36 |
| Google | Gemini 2.0 Flash | $0.01 |

### Example 3: Large Feature (200k tokens)

| Provider | Model | Cost |
|----------|-------|------|
| Anthropic | Claude Sonnet 4 | $1.32 |
| OpenAI | GPT-4o | $0.95 |
| Google | Gemini 2.0 Flash | $0.04 |

---

## Human Labor Comparison

For ROI calculations, compare AI costs to equivalent human rates:

| Role | Hourly Rate | Task Equivalent |
|------|-------------|-----------------|
| Junior Developer | $50-75/hr | Simple bugs, chores |
| Mid Developer | $100-150/hr | Features, complex bugs |
| Senior Developer | $150-250/hr | Architecture, complex features |
| Contractor | $75-200/hr | Variable scope work |

### Breakeven Analysis

```
AI Cost = estimated_tokens × blended_rate
Human Cost = estimated_hours × hourly_rate

If AI_cost < Human_cost × confidence_factor:
  → Prefer AI approach
```

**Confidence Factors**:
- Well-defined task: 1.0x (AI likely accurate)
- Some ambiguity: 1.5x (buffer for retries)
- High uncertainty: 2.5x (expect iterations)

---

## Configuration

Set default provider in `.docflow/config.json`:

```json
{
  "aiLabor": {
    "defaultProvider": "claude-sonnet-4",
    "providerRates": {
      "claude-sonnet-4": {
        "input": 3.00,
        "output": 15.00,
        "inputRatio": 0.70,
        "outputRatio": 0.30
      },
      "gpt-4o": {
        "input": 2.50,
        "output": 10.00,
        "inputRatio": 0.70,
        "outputRatio": 0.30
      }
    }
  }
}
```

---

## Updating Prices

1. Check provider pricing pages quarterly
2. Update this file with new rates
3. Bump version in `.docflow/version`
4. Run `/docflow-update` in projects to sync

**Provider Links**:
- [Anthropic Pricing](https://www.anthropic.com/pricing)
- [OpenAI Pricing](https://openai.com/pricing)
- [Google AI Pricing](https://cloud.google.com/vertex-ai/generative-ai/pricing)


