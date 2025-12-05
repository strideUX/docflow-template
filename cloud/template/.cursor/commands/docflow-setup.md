# DocFlow Setup (System)

## Overview
Complete DocFlow Cloud setup: validate environment, configure Linear, fill project context, and create initial work items.

**Agent Role:** PM/Planning Agent  
**Frequency:** Once per project (during initial setup)

---

## Linear API Access

### MCP-First, Curl Fallback

For all Linear operations in this command:

1. **Try MCP first** - If Linear MCP is available, use it for cleaner interactions
2. **Fall back to curl** - If MCP unavailable, use direct GraphQL API calls

**MCP Example:**
```typescript
// Cleaner - use when MCP available
linear_getTeams()
linear_createIssue({ teamId, title, description, ... })
```

**Curl Fallback Example:**
```bash
# Works without MCP - use as fallback
source .env && curl -s -X POST https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: $LINEAR_API_KEY" \
  -d '{"query": "{ teams { nodes { id name key } } }"}' | jq .
```

**Always source `.env` before curl commands to load the API key.**

---

## Steps

### 1. **Check Environment File**

First, verify the `.env` file exists and has required values:

```bash
# Check if .env exists
[ -f ".env" ] && echo "EXISTS" || echo "MISSING"
```

**If `.env` is MISSING:**
```markdown
## 🔧 DocFlow Cloud Setup

Welcome! I see this is a fresh DocFlow Cloud installation.

**Step 1: Configure your environment**

You have a `.env.example` file in your project root. To complete setup:

1. Copy it to `.env`:
   ```bash
   cp .env.example .env
   ```

2. Open `.env` and add your Linear credentials:
   - **LINEAR_API_KEY** - Get from Linear → Settings → API → Personal API Keys
   - **LINEAR_TEAM_ID** - Get from your team URL: linear.app/team/[TEAM_ID]/...
   - **LINEAR_PROJECT_ID** (optional) - Get from project URL

Once you've filled in the values, run `/docflow-setup` again!
```

**Stop here if .env is missing.**

---

### 2. **Validate API Key**

Read and check the `.env` file:

```bash
# Source the env file and check value
source .env
echo "API_KEY: ${LINEAR_API_KEY:0:15}..."
```

**Check the API key:**
- Must exist and not be empty
- Must start with `lin_api_`

**If empty or invalid:**
```markdown
## ⚠️ Missing API Key

Your `.env` file exists but the API key is missing or invalid.

**To get your API key:**
1. Go to Linear → Settings → API → Personal API Keys
2. Create a new key (starts with `lin_api_`)
3. Copy and paste into your `.env` file

Update your `.env` file and run `/docflow-setup` again!
```

**Stop here if API key is missing.**

---

### 3. **Test Linear Connection**

Once API key is valid, test the connection:

```markdown
✅ API key found!

Testing Linear connection...
```

**Try MCP first:**
```typescript
// If Linear MCP is available
linear_getTeams()
```

**If MCP unavailable, use curl:**
```bash
source .env && curl -s -X POST https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: $LINEAR_API_KEY" \
  -d '{"query": "{ teams { nodes { id name key } } }"}' | jq .
```

**If successful:**
```markdown
✅ Linear connection verified!

Found teams: [Team A, Team B, ...]
```

**If failed:**
```markdown
❌ Could not connect to Linear

**Possible issues:**
- API key may be incorrect or expired
- Check your internet connection

**To fix:**
1. Verify your API key is correct in `.env`
2. Regenerate a new key if needed: Linear → Settings → API
```

**Stop here if connection fails.**

---

### 4. **Select Team**

Check `.docflow.json` for existing team ID:

```bash
cat .docflow.json | grep teamId
```

**If teamId is null:**

Query Linear for all teams:

**MCP:**
```typescript
linear_getTeams()
```

**Curl fallback:**
```bash
source .env && curl -s -X POST https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: $LINEAR_API_KEY" \
  -d '{"query": "{ teams { nodes { id name key } } }"}' | jq '.data.teams.nodes'
```

**Present options:**
```markdown
## 👥 Select a Team

I found these teams in your Linear workspace:

| # | Team | Key | ID |
|---|------|-----|-----|
| 1 | strideUX | stride | abc123... |
| 2 | Client A | client-a | def456... |

Which team should this project use?
```

**When user selects:**
- Get the team ID from the selection

**Save to .docflow.json:**
```json
{
  "provider": {
    "type": "linear",
    "teamId": "selected-team-id",
    "projectId": null
  }
}
```

```markdown
✅ Team configured: **[Team Name]**
```

**If only one team exists:** Auto-select it and inform user.

---

### 5. **Select Project**

Check `.docflow.json` for existing project ID:

```bash
cat .docflow.json | grep projectId
```

**If projectId is null:**

Query Linear for projects in the selected team:

**MCP:**
```typescript
linear_getProjects({ teamId: "selected-team-id" })
```

**Curl fallback:**
```bash
source .env && curl -s -X POST https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: $LINEAR_API_KEY" \
  -d '{"query": "{ projects(filter: { team: { id: { eq: \"TEAM_ID\" } } }) { nodes { id name state } } }"}' | jq '.data.projects.nodes'
```

**Present options:**
```markdown
## 📁 Select a Project

I found these projects in **[Team Name]**:

| # | Project | Status | ID |
|---|---------|--------|-----|
| 1 | DocFlow | In Progress | proj123... |
| 2 | Website Redesign | Planned | proj456... |
| 3 | *(Create new)* | - | - |

Which project should DocFlow use for this codebase?
```

**When user selects:**
- If existing project: Get the project ID
- If create new: Create via MCP or curl mutation

**Create new project (if needed):**
```bash
source .env && curl -s -X POST https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: $LINEAR_API_KEY" \
  -d '{"query": "mutation { projectCreate(input: { name: \"Project Name\", teamIds: [\"TEAM_ID\"] }) { success project { id name } } }"}' | jq .
```

**Save to .docflow.json:**
```json
{
  "provider": {
    "type": "linear",
    "teamId": "team-id",
    "projectId": "selected-project-id"
  }
}
```

```markdown
✅ Project configured: **[Project Name]**

I've saved both team and project IDs to `.docflow.json` - this file can be committed.
```

---

### 6. **Map Workflow States**

Query Linear for team's workflow states and verify mapping:

```bash
# Read current mapping from .docflow.json
cat .docflow.json | grep -A 10 "statusMapping"
```

**Present mapping to user:**
```markdown
## Workflow State Mapping

I'll map your Linear states to DocFlow workflow:

| DocFlow | → | Linear State |
|---------|---|--------------|
| BACKLOG | → | Backlog |
| READY | → | Todo |
| IMPLEMENTING | → | In Progress |
| REVIEW | → | In Review |
| TESTING | → | QA |
| COMPLETE | → | Done |

Does this match your Linear workflow?
```

**If user needs to adjust:**
- Update `statusMapping` in `.docflow.json` to match their actual state names

---

### 7. **Verify Labels**

Check if type labels exist in Linear:

```markdown
## Labels Check

Looking for DocFlow type labels in Linear...

| Label | Status |
|-------|--------|
| feature | ✓ Found / ⚠️ Missing |
| bug | ✓ Found / ⚠️ Missing |
| chore | ✓ Found / ⚠️ Missing |
| idea | ✓ Found / ⚠️ Missing |
```

**If labels missing:**
```markdown
Some labels are missing. I can:
1. **Create them** - Add the missing labels to Linear
2. **Skip** - You'll add labels manually later

What would you like to do?
```

---

### 8. **Gather Project Information**

```markdown
## 📋 Project Setup

Now let's set up your project context. I can work from:

1. **A PRD or Project Document** - Paste or share the file
2. **A brief description** - Tell me about your project
3. **An existing codebase** - I'll analyze what's here

Which would you like to do?
```

**If PRD provided:**
- Parse the document
- Extract: project name, vision, goals, tech stack, features
- Use to fill context files and create initial issues

**If description provided:**
- Ask clarifying questions
- Build out context interactively

**If existing codebase:**
- Scan package.json, config files, src structure
- Infer stack and patterns
- Ask user to confirm

---

### 9. **Fill Context Files**

Based on gathered information, update:

**docflow/context/overview.md:**
```markdown
# Project Overview

## Project Name
[Extracted/provided name]

## Vision
[Extracted vision statement]

## Problem Statement
[What problem this solves]

## Target Users
[User types]

## Key Goals
1. [Goal 1]
2. [Goal 2]
3. [Goal 3]
...
```

**docflow/context/stack.md:**
```markdown
# Tech Stack

## Core Technologies

### Frontend
- **Framework**: [Detected/provided]
- **Language**: TypeScript
...

### Backend
- **Database**: [Detected/provided]
...
```

**docflow/context/standards.md:**
- Keep template defaults
- Customize based on detected patterns

---

### 10. **Create Initial Linear Issues**

From PRD or description, identify initial work items:

```markdown
## 📝 Initial Work Items

Based on your project description, I've identified these initial items:

**Features:**
1. [Feature 1] - [brief description]
2. [Feature 2] - [brief description]
3. [Feature 3] - [brief description]

**Setup/Chores:**
1. [Initial setup task]
2. [Configuration task]

Should I create these as Linear issues?
```

**If approved:**
- Create issues via Linear MCP
- Add appropriate labels (feature/bug/chore/idea)
- Set to Backlog state
- Assign to selected project

---

### 11. **Setup Complete**

```markdown
## ✅ DocFlow Cloud Setup Complete!

**Linear Connection:**
- ✓ API key verified
- ✓ Team: [Team Name]
- ✓ Project: [Project Name]

**Configuration:**
- ✓ Team & project IDs saved to .docflow.json
- ✓ Workflow states mapped
- ✓ Labels verified

**Project Context:**
- ✓ overview.md filled
- ✓ stack.md configured
- ✓ standards.md ready

**Initial Work:**
- ✓ Created [X] issues in Linear backlog

---

**You're ready to start!**

Next commands:
- `/start-session` - See your Linear backlog and start working
- `/capture` - Add more work items
- `/implement [issue]` - Pick up and build

Happy building! 🚀
```

---

## Handling Existing Projects

If project already has code:

### Scan and Detect
```bash
# Detect framework
[ -f "package.json" ] && cat package.json | jq '.dependencies'
[ -f "next.config.js" ] && echo "Next.js detected"
[ -f "vite.config.ts" ] && echo "Vite detected"
```

### Preserve Existing Context
If context files already have content:
- Show diff of what would change
- Ask user to approve changes
- Merge rather than overwrite

---

## Context to Load
- `.env` (environment configuration)
- `.docflow.json` (workflow configuration)
- `docflow/context/*` (current content, if any)
- Linear MCP (for API calls)
- Project files (package.json, etc.)

---

## Natural Language Triggers
User might say:
- "set up docflow" / "configure docflow"
- "connect to linear" / "set up linear"
- "initialize project" / "start new project"
- "I have a PRD" / "here's my project doc"

**Run this command when detected.**

---

## Outputs
- `.env` validated
- `.docflow.json` status mapping verified
- `docflow/context/*` files populated
- Initial Linear issues created
- Project ready for development

---

## Checklist
- [ ] Checked .env file exists
- [ ] Validated LINEAR_API_KEY
- [ ] Tested Linear API connection
- [ ] Selected/saved team ID to .docflow.json
- [ ] Selected/saved project ID to .docflow.json
- [ ] Verified workflow state mapping
- [ ] Verified/created labels
- [ ] Gathered project information
- [ ] Filled context files
- [ ] Created initial issues in Linear
- [ ] Provided setup confirmation
