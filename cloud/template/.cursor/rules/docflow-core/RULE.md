---
description: "DocFlow Cloud core rules - essential workflow configuration and structure"
globs: []
alwaysApply: true
---

# DocFlow Cloud Core Rules

This project uses **DocFlow Cloud**, a spec-driven development workflow with Linear integration.

## ⚠️ CRITICAL: Linear MCP Limitations

**The Linear MCP CANNOT do these operations. You MUST execute curl commands directly:**

| Operation | MCP Support | Action Required |
|-----------|-------------|-----------------|
| Create Milestone | ❌ NO | Execute curl command below |
| Assign to Milestone | ❌ NO | Execute curl command below |
| Post Project Update | ❌ NO | Execute curl command below |

**DO NOT try MCP tools first. Execute shell commands immediately.**

### Create Milestone (EXECUTE THIS):
```bash
LINEAR_API_KEY=$(grep LINEAR_API_KEY .env | cut -d '=' -f2)
PROJECT_ID=$(jq -r '.provider.projectId' .docflow/config.json)
curl -s -X POST https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: $LINEAR_API_KEY" \
  -d '{"query": "mutation($projectId: String!, $name: String!) { projectMilestoneCreate(input: { projectId: $projectId, name: $name }) { success projectMilestone { id name } } }", "variables": {"projectId": "'"$PROJECT_ID"'", "name": "MILESTONE_NAME_HERE"}}'
```

### Post Project Update (EXECUTE THIS):
```bash
LINEAR_API_KEY=$(grep LINEAR_API_KEY .env | cut -d '=' -f2)
PROJECT_ID=$(jq -r '.provider.projectId' .docflow/config.json)
curl -s -X POST https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: $LINEAR_API_KEY" \
  -d '{"query": "mutation($projectId: String!, $body: String!, $health: ProjectUpdateHealthType!) { projectUpdateCreate(input: { projectId: $projectId, body: $body, health: $health }) { success } }", "variables": {"projectId": "'"$PROJECT_ID"'", "body": "UPDATE_TEXT_HERE", "health": "onTrack"}}'
```

---

## ⚠️ REQUIRED: Comments on Every Status Change

**You MUST add a comment when changing issue status. No exceptions.**

| Transition | Comment Format |
|------------|----------------|
| → Backlog | `**Created** — [Brief description of what this is]` |
| → Todo | `**Refined** — [What was improved]. Priority: [P]. Ready for activation.` |
| → In Progress | `**Activated** — Assigned to [name]. Starting implementation.` |
| → Blocked | `**Blocked** — [What's blocking]. Needs: [what's needed to unblock].` |
| → In Progress (unblocked) | `**Unblocked** — [What resolved the blocker].` |
| → In Review | `**Ready for Review** — [Summary of changes]. Files: [key files changed].` |
| → QA | `**Review Approved** — Ready for testing.` |
| → Done | `**Complete** — [Final summary]. All criteria verified.` |
| → Archived | `**Archived** — [Reason for deferral].` |
| → Canceled | `**Canceled** — [Reason].` |

**Use Linear MCP `add_comment` for every status transition.**

---

## ⚠️ REQUIRED: Update Checkboxes in DESCRIPTION (Not Comments!)

**Checkboxes are in the issue DESCRIPTION. You must UPDATE THE DESCRIPTION to check them off.**

### ❌ WRONG: Adding checkmarks in comments
Do NOT put `✓` or `[x]` in comments. That doesn't update the actual checkboxes.

### ✅ CORRECT: Update the description field
Use `update_issue` with the `description` parameter to modify the actual checkboxes.

### Step-by-Step Process:

**Step 1: Get current description**
```
get_issue(id: "PLA-123")
→ Returns description with: "- [ ] OAuth install flow works..."
```

**Step 2: Modify the checkbox text**
Change `- [ ]` to `- [x]` in the description string.

**Step 3: Save updated description**
```
update_issue(
  id: "PLA-123",
  description: "## Acceptance Criteria\n- [x] OAuth install flow works...\n- [x] Tokens stored securely..."
)
```

### When to Update:
- ✅ After completing each criterion during implementation
- ✅ **MANDATORY before "Done"** - call `update_issue` with all boxes checked

### Before Closing to Done:
1. Call `get_issue` to read current description
2. Check if any `- [ ]` remain unchecked
3. Call `update_issue` with description containing all `- [x]`
4. THEN change status to Done

---

## Essential Reading

**Read these files for complete rules:**

1. `.docflow/config.json` - Configuration (paths, provider settings)
2. `.docflow/rules/core.md` - Essential workflow rules
3. `.docflow/rules/` - Role-specific rules (load as needed)
4. `.docflow/skills/` - Portable workflow skills

## Quick Reference

### Agent Roles

| Agent | Commands |
|-------|----------|
| PM/Planning | capture, refine, activate, review, close, project-update, sync-project |
| Implementation | implement, block, attach |
| QE/Validation | validate |

### Critical Rules

- ❌ Never create local spec files - ALL specs live in Linear
- ❌ Never use MCP for milestones/project updates - use curl commands above
- ✅ Context stays local in `{paths.content}/context/`
- ✅ Knowledge stays local in `{paths.content}/knowledge/`
- ✅ Update Linear, not local files for status/progress

### Configuration

Read `.docflow/config.json` for `paths.content` (default: "docflow").

**Load additional rules from `.docflow/rules/` based on context.**
