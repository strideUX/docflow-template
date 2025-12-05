# Project Update (PM/Planning Agent)

## Overview
Post a project update to Linear with health status and summary. Used during session wrap or standalone.

**Agent Role:** PM/Planning Agent (orchestrator)  
**Frequency:** End of session, milestone completion, or on request

---

## Implementation Note

> **Current Method:** Direct GraphQL API call  
> **Future:** May be replaced with Linear MCP function if added  
> **Last Updated:** 2025-12-05

The Linear MCP does not currently support `create_project_update`. This command uses the Linear GraphQL API directly via environment variable `LINEAR_API_KEY`.

---

## Steps

### 1. **Identify Project**

**If user specified project:**
- Use that project ID

**If not specified:**
- Check current context for active project
- Query Linear for user's projects
- Ask which project to update

### 2. **Gather Update Content**

**Health Status (required):**
| Status | Use When |
|--------|----------|
| `onTrack` | Progress is good, no blockers |
| `atRisk` | Some concerns, may need attention |
| `offTrack` | Significant issues, needs help |

**Body (required):**
Concise summary of:
- What was accomplished
- Current state
- What's next
- Any blockers or risks

### 3. **Format Update Body**

Keep it scannable:
```markdown
**This Session:**
- [Key accomplishment 1]
- [Key accomplishment 2]

**Next:**
- [What's coming up]

**Blockers:** None / [Description]
```

### 4. **Create Project Update via API**

```bash
# Load API key from project .env
source .env

curl -s -X POST https://api.linear.app/graphql \
  -H "Authorization: $LINEAR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "mutation CreateProjectUpdate($projectId: String!, $body: String!, $health: ProjectUpdateHealthType!) { projectUpdateCreate(input: { projectId: $projectId, body: $body, health: $health }) { success projectUpdate { id url } } }",
    "variables": {
      "projectId": "[PROJECT_ID]",
      "body": "[UPDATE_BODY]",
      "health": "[onTrack|atRisk|offTrack]"
    }
  }'
```

**Response on success:**
```json
{
  "data": {
    "projectUpdateCreate": {
      "success": true,
      "projectUpdate": {
        "id": "...",
        "url": "https://linear.app/..."
      }
    }
  }
}
```

### 5. **Confirmation**

```markdown
✅ Project update posted!

**Project:** [Name]
**Health:** 🟢 On Track / 🟡 At Risk / 🔴 Off Track
**Update:** [Brief summary]

[View in Linear](update-url)
```

---

## Usage from Wrap Session

When wrapping a session, this command is called automatically if:
- Work was done on issues in a project
- User explicitly requests a project update

The wrap-session summary becomes the update body.

---

## Standalone Usage

User can request directly:
- "post a project update"
- "update the project status"
- "mark project at risk"

---

## Health Status Guidelines

**🟢 On Track (`onTrack`):**
- All work progressing as expected
- No blockers
- Timeline looks good

**🟡 At Risk (`atRisk`):**
- Some concerns emerging
- Minor blockers or delays
- May need attention soon

**🔴 Off Track (`offTrack`):**
- Significant issues
- Major blockers
- Timeline at risk
- Needs immediate attention

---

## Context to Load
- Current project from `.docflow.json` or Linear query
- Session accomplishments (if from wrap-session)
- Any blockers noted during session

---

## Natural Language Triggers
User might say:
- "post project update" / "update the project"
- "mark project on track" / "project is at risk"
- "send status update"

**Run this command when detected.**

---

## Environment Requirements

Requires `LINEAR_API_KEY` from project `.env` file:

```bash
# .env
LINEAR_API_KEY=lin_api_xxxxx
```

**Setup:**
1. Get key from: Linear → Settings → API → Personal API keys
2. Add to project `.env` file
3. Load with `source .env` before running

The key needs permissions to create project updates.

---

## Outputs
- Project update created in Linear
- Health status set
- Update visible in project overview
- Slack notification (if configured in Linear)

---

## Checklist
- [ ] Identified target project
- [ ] Determined health status
- [ ] Composed update body
- [ ] LINEAR_API_KEY available
- [ ] API call successful
- [ ] Confirmation provided with link

---

## Troubleshooting

**"Unauthorized" error:**
- Check LINEAR_API_KEY is set and valid
- Ensure key has write permissions

**"Project not found" error:**
- Verify project ID is correct
- Check user has access to project

**No response:**
- Check network connectivity
- Verify Linear API is available

---

## Future Migration

When Linear MCP adds `create_project_update`:
1. Replace API call with MCP function
2. Remove environment variable requirement
3. Update this documentation

