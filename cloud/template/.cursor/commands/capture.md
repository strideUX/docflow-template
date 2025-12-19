# Capture (PM/Planning Agent)

Quickly capture new work to Linear backlog without context switching.

## Steps

1. **Identify Type** - feature, bug, chore, or idea
2. **Gather Context** - title, description, user value
3. **Apply Template** from `.docflow/templates/`
4. **Set Metadata** - priority (1-4), estimate (1-5, optional)
5. **Check for Milestones** - Query project milestones
6. **Assign Milestone** - If milestones exist, ask which one
7. **Create Linear Issue** - Backlog state with milestone
8. **Confirm** with issue link

## Milestone Assignment

Before creating the issue, check if project has milestones:

```bash
# Query milestones
curl -s -X POST https://api.linear.app/graphql \
  -H "Authorization: $LINEAR_API_KEY" \
  -d '{"query": "query($projectId: String!) { project(id: $projectId) { projectMilestones { nodes { id name } } } }", "variables": {"projectId": "..."}}'
```

**If milestones exist:**
```markdown
Which milestone should this be assigned to?

1. Phase 1: Foundation
2. Phase 2: Core Features
3. Phase 3: Polish
4. None (no milestone)

Select:
```

**If no milestones:** Skip this step.

**If default milestone in config:** Use it unless user specifies otherwise.

## Context to Load

- `.docflow/config.json`
- `.docflow/templates/{type}.md`

## Natural Language Triggers

- "capture that" / "add to backlog" / "found a bug" / "new idea"

## Quick Capture Mode

For fast capture: minimal issue, refine later with `/refine`.

## Full Rules

See `.docflow/rules/pm-agent.md` and `.docflow/skills/spec-templates/SKILL.md`
