# Wrap Session (PM/Planning Agent)

End a work session by summarizing progress, updating Linear issues, and posting a project update.

## Steps

1. **Gather Session Context:**
   - Query Linear for issues touched this session (In Progress, recently moved)
   - Check what was completed vs still in progress

2. **Update Individual Issues:**
   - Add progress comments to in-progress work
   - Note blockers or next steps per issue

3. **Compose Session Summary:**
   ```markdown
   ## What was done
   - [List accomplishments with issue refs]
   
   ## What's next
   - [Next priorities or blockers]
   ```

4. **Post Project Update to Linear (REQUIRED):**
   - Determine health status: `onTrack`, `atRisk`, or `offTrack`
   - Post update via Linear GraphQL API
   - Include session summary

5. **Confirm with User:**
   - Show summary posted
   - Link to project updates in Linear

## Project Update Format

```markdown
**Session Summary — [Date]**

✅ **Completed:**
- [Issue] — [What was done]
- [Issue] — [What was done]

🔄 **In Progress:**
- [Issue] — [Current state, % complete]

📋 **Next Up:**
- [Issue] — [Priority for next session]

🚧 **Blockers:** [None / List blockers]
```

## Health Status Guide

| Status | When to Use |
|--------|-------------|
| `onTrack` | Progress made, no blockers, on schedule |
| `atRisk` | Minor blockers, slight delays, needs attention |
| `offTrack` | Major blockers, significantly behind, needs intervention |

## Posting to Linear

**Note:** Linear MCP does not support project updates. Use direct API call.

Requires `LINEAR_API_KEY` in `.env` and `projectId` from `.docflow/config.json`.

### Shell API Call

```bash
LINEAR_API_KEY=$(grep LINEAR_API_KEY .env | cut -d '=' -f2)
PROJECT_ID=$(jq -r '.workspace.activeProjects[0]' .docflow/config.json)

curl -s -X POST https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: $LINEAR_API_KEY" \
  -d '{
    "query": "mutation($projectId: String!, $body: String!, $health: ProjectUpdateHealthType!) { projectUpdateCreate(input: { projectId: $projectId, body: $body, health: $health }) { success projectUpdate { id url } } }",
    "variables": {
      "projectId": "'"$PROJECT_ID"'",
      "body": "[SESSION_SUMMARY_MARKDOWN]",
      "health": "onTrack"
    }
  }'
```

### Response

```json
{
  "data": {
    "projectUpdateCreate": {
      "success": true,
      "projectUpdate": {
        "id": "xxx",
        "url": "https://linear.app/team/project/xxx#projectUpdate-xxx"
      }
    }
  }
}
```

## Context to Load

- Linear issues worked on this session
- `.docflow/config.json` (for projectId)

## Scripts

Run `.docflow/scripts/status-summary.sh` for current state.

## Natural Language Triggers

- "wrap it up" / "I'm done" / "save progress" / "end of day"

## Full Rules

See `.docflow/rules/workflow-agent.md` and `.docflow/rules/session-awareness.md`
