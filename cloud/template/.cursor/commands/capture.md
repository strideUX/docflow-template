# Capture (PM/Planning Agent)

Quickly capture new work to Linear backlog without context switching.

## Product Scope Filtering

**CRITICAL: Only show projects within your product scope.**

Projects must have ALL labels in `workspace.product.labelIds` to be visible.

## Steps

1. **Identify Type** - feature, bug, chore, or idea
2. **Gather Context** - title, description, user value
3. **Determine Project** - Check product-scoped projects (see below)
4. **Apply Template** from `.docflow/templates/`
5. **Set Metadata** - priority (1-4), estimate (1-5, optional)
6. **Check for Milestones** - Query project milestones
7. **Assign Milestone** - If milestones exist, ask which one
8. **Create Linear Issue** - Backlog state with milestone
9. **Confirm** with issue link

## Project Selection (Product-Scoped)

First, get all projects matching your product labels:

```bash
# Load config
TEAM_ID=$(jq -r '.provider.teamId' .docflow/config.json)
LABEL_IDS=$(jq -c '.workspace.product.labelIds // []' .docflow/config.json)
ACTIVE_PROJECTS=$(jq -c '.workspace.activeProjects // []' .docflow/config.json)
LINEAR_API_KEY=$(grep LINEAR_API_KEY .env | cut -d '=' -f2)

# Query all team projects with their labels
curl -s -X POST https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: $LINEAR_API_KEY" \
  -d '{
    "query": "query($teamId: String!) { team(id: $teamId) { projects { nodes { id name projectLabels { nodes { id } } } } } }",
    "variables": { "teamId": "'"$TEAM_ID"'" }
  }'

# Filter: Only projects with ALL labelIds from config
```

**Then present options:**

**If single active project:**
- Use it automatically

**If multiple active projects:**
```markdown
Which project should this issue go in?

**Active Projects:**
1. [Project 1 name] ← active
2. [Project 2 name] ← active

**Available Projects (same product):**
3. [Project 3 name] — will activate if selected

4. Create new project...

Select:
```

**If selecting an "available" project:**
- Add it to `workspace.activeProjects` in config
- Then create issue in that project

**If no product-scoped projects:**
```markdown
No projects found for [product name].
Would you like to create one?
- yes -> Run /new-project flow (will apply product labels)
- no -> Cannot capture without a project
```

## Milestone Assignment

Before creating the issue, check if project has milestones:

```bash
PROJECT_ID=$(jq -r '.workspace.activeProjects[0]' .docflow/config.json)
LINEAR_API_KEY=$(grep LINEAR_API_KEY .env | cut -d '=' -f2)

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

- `.docflow/config.json` (required - contains labelIds filter)
- `.docflow/templates/{type}.md`

## Natural Language Triggers

- "capture that" / "add to backlog" / "found a bug" / "new idea"

## Quick Capture Mode

For fast capture: minimal issue, refine later with `/refine`.

## Full Rules

See `.docflow/rules/workflow-agent.md` and `.claude/skills/spec-templates/SKILL.md`
