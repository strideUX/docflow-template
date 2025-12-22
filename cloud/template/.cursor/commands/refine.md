# Refine (PM/Planning Agent)

Context-aware refinement that handles triage and spec improvement.

## Two Paths

**Triage Path** (has `triage` label or missing structure):
1. Analyze raw content
2. Suggest type classification
3. Apply template from `.docflow/templates/`
4. Remove `triage` label, add type label
5. Set initial priority and identify dependencies

**Refinement Path** (already templated):
1. Assess completeness
2. Identify gaps
3. Refine acceptance criteria
4. Add technical notes
5. Set estimate
6. **Set priority and dependencies** (if not already set)
7. **Move to "Todo" state** (ready for activation)

## Priority & Dependency Questions

During refinement, assess and set:

### Priority
Ask/infer based on:
- Is this blocking other work? → High/Urgent
- Is this a core v1 feature? → High
- Is this a nice-to-have? → Low/Medium

| Priority | Criteria |
|----------|----------|
| Urgent | Blocking launch, critical bug |
| High | Core feature, foundational, unblocks others |
| Medium | Important but not blocking |
| Low | Enhancement, future, nice-to-have |

### Dependencies
Ask:
- "Does this depend on other issues being complete first?"
- "Will completing this unblock other work?"

If dependencies exist:
1. Find the related issues in Linear
2. Create "blocked by" / "blocks" relationships
3. Note in refinement comment

Example output:
```markdown
**Refined** — Added acceptance criteria, set estimate (M).
Priority: High (unblocks F2, F3)
Blocked by: PLA-70 (Infrastructure)
Ready for activation after PLA-70 completes.
```

## Steps

1. **Find Issue** - Query Linear or use specified issue
2. **Determine Path** - Triage or Refinement
3. **Execute Path** - Apply appropriate actions
4. **Set Priority** - If not already set
5. **Set Dependencies** - Create blocking relationships if applicable
6. **Move to Todo** - If refinement complete
7. **Update Linear** - Save changes, add comment with priority/dependency info

## Natural Language Triggers

- "refine [issue]" / "triage [issue]" / "prepare [issue]"

## Full Rules

See `.docflow/rules/pm-agent.md` and `.docflow/skills/spec-templates/SKILL.md`



