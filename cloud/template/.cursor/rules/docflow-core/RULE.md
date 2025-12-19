---
description: "DocFlow Cloud core rules - essential workflow configuration and structure"
globs: []
alwaysApply: true
---

# DocFlow Cloud Core Rules

This project uses **DocFlow Cloud**, a spec-driven development workflow with Linear integration.

## 🚨 CRITICAL: Always Use Configured Project

**ALL issues MUST be created within the configured Linear project. Never create issues outside of it.**

### Get Project IDs from Config:
```bash
# Read from .docflow/config.json
TEAM_ID=$(jq -r '.provider.teamId' .docflow/config.json)
PROJECT_ID=$(jq -r '.provider.projectId' .docflow/config.json)
```

### Every create_issue call MUST include:
```
create_issue(
  title: "...",
  teamId: "[TEAM_ID from config]",      # REQUIRED
  projectId: "[PROJECT_ID from config]", # REQUIRED - never omit this
  ...
)
```

**If projectId is omitted, the issue won't be in the project. This breaks tracking.**

---

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

## ⚠️ REQUIRED: Status Change Protocol

**Every status change requires BOTH a comment AND (for Done) checkbox updates.**

| Transition | Actions Required |
|------------|------------------|
| → Backlog | 1. `create_comment`: `**Created** — [description]` |
| → Todo | 1. `create_comment`: `**Refined** — Ready for activation.` |
| → In Progress | 1. `create_comment`: `**Activated** — Starting implementation.` |
| → Blocked | 1. `create_comment`: `**Blocked** — [reason]` |
| → In Review | 1. `create_comment`: `**Ready for Review** — [summary]` |
| → QA | 1. `create_comment`: `**Review Approved** — Ready for testing.` |
| **→ Done** | **3 STEPS REQUIRED - SEE BELOW** |

---

## 🚨 CLOSING TO DONE: 3 MANDATORY STEPS

**You MUST complete ALL 3 steps in this EXACT order. Do not skip any step.**

### Step 1: Update checkboxes in DESCRIPTION (NOT comments!)

```
# First, get the current description
get_issue(id: "PLA-123")

# Find all "- [ ]" and change to "- [x]"
# Then save the ENTIRE description back:
update_issue(
  id: "PLA-123", 
  description: "[full description with - [x] checked boxes]"
)
```

**❌ WRONG:** Putting ✓ or ☑️ in a comment - this does NOT update the description
**✅ CORRECT:** Calling `update_issue` with `description` parameter

### Step 2: Add completion comment

```
create_comment(
  issueId: "PLA-123",
  body: "**Complete** — [summary of what was done]"
)
```

### Step 3: Change status to Done

```
update_issue(id: "PLA-123", stateId: "[done-state-id]")
```

---

## Checkboxes During Implementation

Update checkboxes as you complete criteria (not just at the end):

1. `get_issue` → read current description
2. Change `- [ ] Criterion` to `- [x] Criterion`  
3. `update_issue` with full updated description

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
