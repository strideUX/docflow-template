# Start Session (PM/Planning Agent)

Begin a work session by checking Linear status within your product scope.

## Product Scope Filtering

**CRITICAL: All queries must be filtered to your product scope.**

The agent should only see:
- **Projects** that have ALL labels in `workspace.product.labelIds`
- **Issues** from `workspace.activeProjects` only

## Steps

1. **Load Configuration**
   ```bash
   # Read from .docflow/config.json
   TEAM_ID=$(jq -r '.provider.teamId' .docflow/config.json)
   LABEL_IDS=$(jq -c '.workspace.product.labelIds // []' .docflow/config.json)
   ACTIVE_PROJECTS=$(jq -c '.workspace.activeProjects // []' .docflow/config.json)
   PRODUCT_NAME=$(jq -r '.workspace.product.name // "Project"' .docflow/config.json)
   ```

2. **Query Product-Scoped Projects**

   Get all projects that have ALL the configured labels:
   ```bash
   # Query projects with label filtering
   LINEAR_API_KEY=$(grep LINEAR_API_KEY .env | cut -d '=' -f2)

   curl -s -X POST https://api.linear.app/graphql \
     -H "Content-Type: application/json" \
     -H "Authorization: $LINEAR_API_KEY" \
     -d '{
       "query": "query($teamId: String!) { team(id: $teamId) { projects { nodes { id name projectLabels { nodes { id name } } } } } }",
       "variables": { "teamId": "'"$TEAM_ID"'" }
     }'
   ```

   **Filter in code**: Only include projects where `projectLabels` contains ALL IDs from `workspace.product.labelIds`.

3. **Categorize Projects**
   - **Active**: Projects in `workspace.activeProjects` array
   - **Available**: Projects with matching labels but NOT in activeProjects

4. **Query Issues from Active Projects Only**
   ```bash
   # Query issues filtered by active project IDs
   curl -s -X POST https://api.linear.app/graphql \
     -H "Content-Type: application/json" \
     -H "Authorization: $LINEAR_API_KEY" \
     -d '{
       "query": "query($projectId: String!) { project(id: $projectId) { issues { nodes { id identifier title state { name type } priority dueDate } } } }",
       "variables": { "projectId": "[active-project-id]" }
     }'
   ```

5. **Present Dashboard**

```markdown
---
## Session Dashboard

**Product:** [product name from config]
**Team:** [team name]

### Active Projects
- [Project Name] (X issues) ← currently focused

### Available Projects (same product, not active)
- [Other Project] (Y issues) — "add" to activate

---
## Issue Summary (Active Projects Only)

| Status | Count |
|--------|-------|
| QA | X |
| In Review | X |
| Blocked | X |
| In Progress | X |
| Backlog | X |

---
## Needs Attention

**In Review (X)** - ready for review/merge:
- ENG-XXX [title]

**Active Project Backlog (X):**
- ENG-XXX [title] (Priority)

---
## What would you like to do?

1. **Review** [issue]
2. **Start** a backlog item from active project
3. **Capture** a new issue
4. **Activate** an available project
5. **Something else** - tell me what you need
```

6. **Handle "Activate Project" Request**

   If user wants to activate an available project:
   - Add project ID to `workspace.activeProjects` array in config
   - Confirm activation
   - Refresh dashboard

## Context to Load

- `.docflow/config.json` (required - contains labelIds filter)
- `{paths.content}/context/overview.md`
- Linear queries via MCP or API

## Natural Language Triggers

- "let's start" / "what's next" / "where are we"

## MCP Alternative

If using Linear MCP instead of curl:
```
# Get team projects
list_projects(teamId: "[team-id]")

# Then filter client-side by labels
# Only show issues from projects in activeProjects
```

**Always filter results by `workspace.product.labelIds` and `workspace.activeProjects`.**

## Full Rules

See `.docflow/rules/workflow-agent.md` and `.docflow/rules/session-awareness.md`
