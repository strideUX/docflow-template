# Start Session (PM/Planning Agent)

Begin a work session by checking Linear status within your product scope.

## Product Scope Filtering — HARD GATE

**CRITICAL: All queries must be filtered to your product scope. NO EXCEPTIONS.**

The agent should only see:
- **Projects** that have **ALL** labels in `workspace.product.labelIds`
- **Issues** from `workspace.activeProjects` only

### What This Means

If `labelIds: ["StrideApp-uuid", "Internal-uuid"]`:
- ✅ Show: Projects with BOTH StrideApp AND Internal labels
- ❌ Hide: Projects with only StrideApp (missing Internal)
- ❌ Hide: Projects with QoL, Cook, FlyDocs, etc. (different product)

**This is a HARD filter. Even if user asks about "all projects", only show matching ones.**

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

## MCP Alternative — MUST FILTER CLIENT-SIDE

Linear MCP returns ALL team projects. **You MUST filter client-side.**

```
# Step 1: Get all team projects
list_projects(teamId: "[team-id]")
# Returns: ALL projects including QoL, Cook, FlyDocs, etc.

# Step 2: READ config labelIds
configLabelIds = ["30023a7a-...", "e8a0851a-..."]  # from workspace.product.labelIds

# Step 3: FILTER — Only keep projects with ALL labelIds
For each project in response:
  projectLabelIds = project.projectLabels.nodes.map(label => label.id)

  # Check if project has ALL required labels
  hasAllLabels = configLabelIds.every(reqId => projectLabelIds.includes(reqId))

  if (!hasAllLabels):
    EXCLUDE this project from results

# Step 4: ONLY show filtered projects to user
```

**Example:**
- Config: `labelIds: ["StrideApp-uuid", "Internal-uuid"]`
- Project "Post Launch Clean Up" has labels: [StrideApp, Internal] → ✅ SHOW
- Project "MVP - Beta Launch" has labels: [Cook] → ❌ HIDE
- Project "Hire Fullstack Dev" has labels: [QoL] → ❌ HIDE

**NEVER skip the filter step. NEVER show projects that don't match ALL labelIds.**

## Full Rules

See `.docflow/rules/workflow-agent.md` and `.docflow/rules/session-awareness.md`
