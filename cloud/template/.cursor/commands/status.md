# Status (All Agents)

Quick check of current work state from Linear within your product scope.

## Product Scope Filtering

**CRITICAL: Only show status for your product scope.**

- Query issues from `workspace.activeProjects` only
- Show other product-scoped projects as "available"

## Steps

1. **Load Configuration**
   ```bash
   TEAM_ID=$(jq -r '.provider.teamId' .docflow/config.json)
   LABEL_IDS=$(jq -c '.workspace.product.labelIds // []' .docflow/config.json)
   ACTIVE_PROJECTS=$(jq -c '.workspace.activeProjects // []' .docflow/config.json)
   PRODUCT_NAME=$(jq -r '.workspace.product.name // "Project"' .docflow/config.json)
   ```

2. **Query Issues from Active Projects**
   ```bash
   LINEAR_API_KEY=$(grep LINEAR_API_KEY .env | cut -d '=' -f2)

   # For each project in activeProjects, query issues
   curl -s -X POST https://api.linear.app/graphql \
     -H "Content-Type: application/json" \
     -H "Authorization: $LINEAR_API_KEY" \
     -d '{
       "query": "query($projectId: String!) { project(id: $projectId) { name issues { nodes { id identifier title state { name type } priority } } } }",
       "variables": { "projectId": "[active-project-id]" }
     }'
   ```

3. **Get Product-Scoped Projects** (for available list)
   - Query all team projects
   - Filter by `labelIds`
   - Categorize as active vs available

4. **Check for Stale Issues** (extended time in active state)

5. **Present Dashboard**

```markdown
---
## Status Dashboard

**Product:** [product name]

### Active Projects
- [Project Name] — X total issues

### Available Projects
- [Other Project] — Y issues (say "activate [name]" to add)

---
## Issue Summary (Active Projects Only)

| Status | Count |
|--------|-------|
| In Progress | X |
| In Review | X |
| Blocked | X |
| Backlog | X |

---
## Stale Issues
- ENG-XXX in [state] for X days

---
## Quick Actions
- "activate [project]" — add to active projects
- "start [issue]" — begin work
- "capture" — add new issue
```

## Context to Load

- `.docflow/config.json` (required - contains labelIds filter)
- Linear queries via MCP or API

## Scripts

Run `.docflow/scripts/status-summary.sh` for quick counts (note: needs product filtering).
Run `.docflow/scripts/stale-check.sh` for stale issues.

## Natural Language Triggers

- "status" / "what's the status" / "where are we"

## Full Rules

See `.docflow/rules/linear-integration.md`
