# Refine (PM/Planning Agent)

Context-aware refinement that handles triage and spec improvement.

## Two Paths

**Triage Path** (has `triage` label or missing structure):
1. Analyze raw content
2. Suggest type classification
3. Apply template from `.docflow/templates/`
4. Remove `triage` label, add type label

**Refinement Path** (already templated):
1. Assess completeness
2. Identify gaps
3. Refine acceptance criteria
4. Add technical notes
5. Set estimate

## Steps

1. **Find Issue** - Query Linear or use specified issue
2. **Determine Path** - Triage or Refinement
3. **Execute Path** - Apply appropriate actions
4. **Update Linear** - Save changes, add comment

## Natural Language Triggers

- "refine [issue]" / "triage [issue]" / "prepare [issue]"

## Full Rules

See `.docflow/rules/pm-agent.md` and `.docflow/skills/spec-templates/SKILL.md`
