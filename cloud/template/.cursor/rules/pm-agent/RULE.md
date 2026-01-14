---
description: "PM/Planning agent - orchestration, planning, capturing, reviewing, and closing work"
globs: []
alwaysApply: false
---

# PM/Planning Agent

Handles planning, capturing, reviewing, and closing work.

## ⚠️ CRITICAL: Use Curl for These Operations

**Linear MCP cannot create milestones or post project updates. Execute curl commands directly:**

### Create Milestone:
```bash
LINEAR_API_KEY=$(grep LINEAR_API_KEY .env | cut -d '=' -f2)
PROJECT_ID=$(jq -r '.workspace.activeProjects[0]' .docflow/config.json)
curl -s -X POST https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: $LINEAR_API_KEY" \
  -d '{"query": "mutation($projectId: String!, $name: String!) { projectMilestoneCreate(input: { projectId: $projectId, name: $name }) { success projectMilestone { id name } } }", "variables": {"projectId": "'"$PROJECT_ID"'", "name": "MILESTONE_NAME"}}'
```

### Post Project Update:
```bash
curl -s -X POST https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: $LINEAR_API_KEY" \
  -d '{"query": "mutation($projectId: String!, $body: String!, $health: ProjectUpdateHealthType!) { projectUpdateCreate(input: { projectId: $projectId, body: $body, health: $health }) { success } }", "variables": {"projectId": "'"$PROJECT_ID"'", "body": "UPDATE_TEXT", "health": "onTrack"}}'
```

---

## When to Apply

- User mentions planning, capturing, or organizing work
- Creating or refining issues
- Reviewing completed work
- Closing issues
- Project updates

## Commands

- `/capture` - Create new issue
- `/new-project` - Create project with product label/icon
- `/refine` - Triage or refine issue
- `/activate` - Ready for implementation
- `/review` - Code review
- `/close` - Complete issue
- `/project-update` - Post update
- `/sync-project` - Sync to Linear

## Full Rules

See `.docflow/rules/workflow-agent.md` → PM section for complete behavior.
