---
description: "Linear API integration - workflow states, issue management, comments, team collaboration"
globs: []
alwaysApply: false
---

# Linear Integration

Handles Linear API patterns and issue management.

## ⚠️ CRITICAL: MCP Cannot Do Everything

**These operations require curl commands - DO NOT use MCP:**

| Operation | What To Do |
|-----------|------------|
| Create Milestone | Execute curl command below |
| Assign to Milestone | Execute curl command below |
| Post Project Update | Execute curl command below |

### Create Milestone (EXECUTE THIS):
```bash
LINEAR_API_KEY=$(grep LINEAR_API_KEY .env | cut -d '=' -f2)
PROJECT_ID=$(jq -r '.workspace.activeProjects[0]' .docflow/config.json)
curl -s -X POST https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: $LINEAR_API_KEY" \
  -d '{"query": "mutation($projectId: String!, $name: String!) { projectMilestoneCreate(input: { projectId: $projectId, name: $name }) { success projectMilestone { id name } } }", "variables": {"projectId": "'"$PROJECT_ID"'", "name": "MILESTONE_NAME"}}'
```

### Assign Issue to Milestone (EXECUTE THIS):
```bash
curl -s -X POST https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: $LINEAR_API_KEY" \
  -d '{"query": "mutation($issueId: String!, $milestoneId: String!) { issueUpdate(id: $issueId, input: { projectMilestoneId: $milestoneId }) { success } }", "variables": {"issueId": "ISSUE_UUID", "milestoneId": "MILESTONE_UUID"}}'
```

---

## ⚠️ REQUIRED: Comment on Every Status Change

**Always add a comment when changing status. Use `add_comment` MCP tool.**

| Transition | Comment |
|------------|---------|
| → Todo | `**Refined** — Ready for activation.` |
| → In Progress | `**Activated** — Starting implementation.` |
| → Blocked | `**Blocked** — [reason]. Needs: [what].` |
| → In Review | `**Ready for Review** — [summary of changes].` |
| → QA | `**Review Approved** — Ready for testing.` |
| → Done | `**Complete** — All criteria verified.` |

---

## When to Apply

- Working with Linear issues
- Status transitions
- Adding comments
- Team collaboration (assignment, subscribers)
- Querying issue state

## Key Concepts

- Workflow: BACKLOG → READY → IMPLEMENTING → REVIEW → TESTING → COMPLETE
- Terminal states: Archived, Canceled, Duplicate
- Priority: 1-4 (Urgent to Low)
- Estimate: 1-5 (XS to XL)

## Full Rules

See `.docflow/rules/linear-integration.md` for complete API patterns.

## Skill

See `.claude/skills/linear-workflow/SKILL.md` for workflow guidance.
