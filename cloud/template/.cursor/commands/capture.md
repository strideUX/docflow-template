# Capture (PM/Planning Agent)

Quickly capture new work to Linear backlog without context switching.

## Steps

1. **Identify Type** - feature, bug, chore, or idea
2. **Gather Context** - title, description, user value
3. **Determine Project** - Check active projects in config
4. **Apply Template** from `.docflow/templates/`
5. **Set Metadata** - priority (1-4), estimate (1-5, optional)
6. **Check for Milestones** - Query project milestones
7. **Assign Milestone** - If milestones exist, ask which one
8. **Create Linear Issue** - Backlog state with milestone
9. **Confirm** with issue link

## Project Selection

Before creating the issue, check `workspace.activeProjects` in config:

**If single project:**
- Use it automatically

**If multiple projects:**
```markdown
Which project should this issue go in?

1. [Project 1 name]
2. [Project 2 name]
3. Create new project...

Select:
```

**If no projects:**
```markdown
No active projects configured. Would you like to create one first?
- yes -> Run /new-project flow
- no -> Cannot capture without a project
```

**If user selects "Create new project":**
- Trigger `/new-project` flow
- After project created, continue with capture

## Milestone Assignment

Before creating the issue, check if project has milestones:

```bash
# Get project ID from config (or use selected project if multiple)
LINEAR_API_KEY=$(grep LINEAR_API_KEY .env | cut -d '=' -f2)
PROJECT_ID=$(jq -r '.workspace.activeProjects[0]' .docflow/config.json)

# Query milestones
curl -s -X POST https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: $LINEAR_API_KEY" \
  -d '{"query": "query($projectId: String!) { project(id: $projectId) { projectMilestones { nodes { id name } } } }", "variables": {"projectId": "'"$PROJECT_ID"'"}}'
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

See `.docflow/rules/workflow-agent.md` and `.docflow/skills/spec-templates/SKILL.md`
