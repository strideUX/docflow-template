---
name: spec-templates
description: "Guides creation and refinement of issue specs using DocFlow templates. Apply when creating, capturing, triaging, or refining features, bugs, chores, or ideas."
---

# Spec Templates Skill

This skill provides guidance for creating well-structured issue specifications.

## Template Selection

| Type | When to Use | Template |
|------|-------------|----------|
| **Feature** | New functionality with user value | `.docflow/templates/feature.md` |
| **Bug** | Something broken that needs fixing | `.docflow/templates/bug.md` |
| **Chore** | Maintenance, cleanup, refactoring | `.docflow/templates/chore.md` |
| **Idea** | Rough concept for future exploration | `.docflow/templates/idea.md` |
| **Quick Capture** | Fast capture during flow | `.docflow/templates/quick-capture.md` |

---

## Template Application

### Reading Templates
1. Read the appropriate template from `.docflow/templates/`
2. Templates contain `<!-- AGENT INSTRUCTIONS -->` comments
3. Follow those instructions, then remove them from final issue

### Filling Templates
Extract from user input:
- **What** → Context / Problem description
- **Why** → User story / Value
- **How** → Technical notes / Approach
- **Done when** → Acceptance criteria

### Quality Criteria

A complete spec should have:
- [ ] Clear, specific title
- [ ] Context explaining "why"
- [ ] User story (features) or problem description (bugs)
- [ ] Acceptance criteria (testable, as checkboxes)
- [ ] Type label assigned
- [ ] Priority set (1-4)

---

## Acceptance Criteria Format

```markdown
## Acceptance Criteria

### Must Have
- [ ] Specific, measurable criterion
- [ ] User can perform X action
- [ ] System behaves correctly when Y

### Should Have
- [ ] Nice-to-have enhancement

### Won't Have (Out of Scope)
- Explicitly excluded functionality

### Tests
- [ ] Tests written for core functionality
- [ ] Edge cases covered

### Documentation
- [ ] Code documented
- [ ] Knowledge base updated (if significant)
- [ ] N/A - No significant documentation needed
```

---

## Triage Flow

For issues with `triage` label:
1. Analyze raw content
2. Suggest type classification
3. Apply appropriate template
4. Remove `triage` label
5. Add type label
6. Comment: `**Triaged** — Classified as [type].`

---

## Refinement Flow

For templated backlog items:
1. Assess completeness
2. Identify gaps
3. Refine acceptance criteria
4. Add technical notes
5. Set estimate if not set
6. **Move to "Todo" state** (ready to pick up)
7. Comment: `**Refined** — Ready for activation.`
