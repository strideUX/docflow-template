# New Project (PM/Planning Agent)

Create a new project in Linear with configured product label and icon, and add it to active projects.

## When to Use

- Starting a new body of work that needs its own project
- `/capture` suggests creating a new project for an issue
- You want to organize work into a dedicated project

## Steps

1. **Get Project Details**
   - Ask: "What should the project be called?"
   - Ask: "Brief description?" (optional)

2. **Read Config**
   - Load `.docflow/config.json`
   - Get: `provider.teamId`, `workspace.product.labelId`, `workspace.product.icon`, `workspace.product.color`

3. **Create Project in Linear**

```bash
curl -s -X POST https://api.linear.app/graphql \
  -H "Authorization: $LINEAR_API_KEY" \
  -d '{
    "query": "mutation($teamIds: [String!]!, $name: String!, $description: String, $icon: String, $color: String) { projectCreate(input: { teamIds: $teamIds, name: $name, description: $description, icon: $icon, color: $color }) { success project { id name url } } }",
    "variables": {
      "teamIds": ["[teamId from config]"],
      "name": "[project name]",
      "description": "[description]",
      "icon": "[icon from config.workspace.product.icon]",
      "color": "[color from config.workspace.product.color]"
    }
  }'
```

4. **Apply Product Label** (if configured)
   - If `workspace.product.labelId` exists, apply label to project

5. **Update Config**
   - Add new project ID to `workspace.activeProjects` array
   - Save `.docflow/config.json`

6. **Confirm to User**

```markdown
Created project '[name]' and added to active projects.

Project URL: [url]

You can now use `/capture` to add issues to this project.
```

## Context to Load

- `.docflow/config.json`

## Natural Language Triggers

- "new project"
- "create project"
- "start new project"

## Linear Icons & Colors

**Icons** (use lowercase name from Linear's icon picker):
- comment, code, bug, rocket, star, heart, flag, bookmark
- lightning, mountain, sun, moon, cloud, fire, leaf, globe
- (many more - check Linear's project icon picker for full list)

**Colors** (use the color name):
- Gray, Purple, Blue, Teal, Green, Yellow, Orange, Red, Pink

## Full Rules

See `.docflow/rules/workflow-agent.md`
