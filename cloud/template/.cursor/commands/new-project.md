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
   - Get: `provider.teamId`, `workspace.product.labelId`, `workspace.product.icon`

3. **Create Project in Linear**

```bash
curl -s -X POST https://api.linear.app/graphql \
  -H "Authorization: $LINEAR_API_KEY" \
  -d '{
    "query": "mutation($teamIds: [String!]!, $name: String!, $description: String, $icon: String) { projectCreate(input: { teamIds: $teamIds, name: $name, description: $description, icon: $icon }) { success project { id name url } } }",
    "variables": {
      "teamIds": ["[teamId from config]"],
      "name": "[project name]",
      "description": "[description]",
      "icon": "[icon from config.workspace.product.icon]"
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

## Linear Icons

Available icons (use exact name):
- Rocket
- Code
- Bug
- Star
- Heart
- Flag
- Bookmark
- Lightning
- Mountain
- Sun
- Moon
- Cloud
- Fire
- Leaf
- Globe

## Full Rules

See `.docflow/rules/workflow-agent.md`
