# DocFlow Setup (System)

## Overview
Complete DocFlow Cloud setup: validate environment, configure Linear, fill project context, and create initial work items.

**Agent Role:** PM/Planning Agent  
**Frequency:** Once per project (during initial setup)

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

### 2. **Validate Environment Values**

Read and check the `.env` file:

```bash
# Source the env file and check values
source .env
echo "API_KEY: ${LINEAR_API_KEY:0:10}..."
echo "TEAM_ID: $LINEAR_TEAM_ID"
echo "PROJECT_ID: $LINEAR_PROJECT_ID"
```

**Check each required value:**

| Variable | Required | Status Check |
|----------|----------|--------------|
| LINEAR_API_KEY | ✓ Yes | Must start with `lin_api_` |
| LINEAR_TEAM_ID | ✓ Yes | Must not be empty |
| LINEAR_PROJECT_ID | Optional | Can be empty (will select later) |

**If values are empty or invalid:**
```markdown
## ⚠️ Missing Configuration

Your `.env` file exists but is missing some required values:

| Variable | Status |
|----------|--------|
| LINEAR_API_KEY | ${empty/set} |
| LINEAR_TEAM_ID | ${empty/set} |
| LINEAR_PROJECT_ID | ${empty/set} (optional) |

**To get these values:**

1. **LINEAR_API_KEY:**
   - Go to Linear → Settings → API → Personal API Keys
   - Create a new key (starts with `lin_api_`)

2. **LINEAR_TEAM_ID:**
   - Go to your team in Linear
   - Copy from URL: linear.app/team/**[TEAM_ID]**/...
   - Or: Settings → Teams → [Team] → Copy ID

3. **LINEAR_PROJECT_ID (optional):**
   - Open your project in Linear
   - Copy from URL: linear.app/[team]/project/**[PROJECT_ID]**
   - Or leave empty to select during setup

Update your `.env` file and run `/docflow-setup` again!
```

**Stop here if required values are missing.**

---

### 3. **Test Linear Connection**

Once `.env` is valid, test the MCP connection:

```markdown
✅ Environment configured!

Testing Linear connection...
```

Use Linear MCP to verify connection:
- Query teams to confirm API key works
- Verify the configured team ID exists

**If successful:**
```markdown
✅ Linear connection verified!

**Connected to:** [Team Name]
**Workflow States:** [list]
**Available Labels:** [list]
```

**If failed:**
```markdown
❌ Could not connect to Linear

**Possible issues:**
- API key may be incorrect or expired
- Team ID may not exist
- Check your internet connection

**To fix:**
1. Verify your API key is correct in `.env`
2. Regenerate a new key if needed
3. Double-check your team ID
```

---

### 4. **Select/Confirm Project**

Check `.docflow.json` for existing project ID:

```bash
cat .docflow.json | grep projectId
```

**If projectId is null:**

Query Linear for projects in the team and present options:

```markdown
## 📁 Select a Project

I found these projects in your team:

| # | Project | Status |
|---|---------|--------|
| 1 | DocFlow | In Progress |
| 2 | Website Redesign | Planned |
| 3 | *(Create new)* | - |

Which project should DocFlow use for this codebase?
```

**When user selects:**
- If existing project: Get the project ID
- If new project: Create it via Linear MCP

**Save to .docflow.json:**
```json
{
  "provider": {
    "type": "linear",
    "projectId": "selected-project-id"
  }
}
```

```markdown
✅ Project configured: **[Project Name]**

I've saved the project ID to `.docflow.json` - this file can be committed.
```

---

### 5. **Map Workflow States**

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

### 6. **Verify Labels**

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

### 7. **Gather Project Information**

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

### 8. **Fill Context Files**

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

### 9. **Create Initial Linear Issues**

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

### 10. **Setup Complete**

```markdown
## ✅ DocFlow Cloud Setup Complete!

**Environment:**
- ✓ .env configured
- ✓ Linear connection verified
- ✓ Project: [Project Name]

**Configuration:**
- ✓ Workflow states mapped
- ✓ Labels verified
- ✓ .docflow.json ready

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
- [ ] Validated required environment variables
- [ ] Tested Linear API connection
- [ ] Selected/confirmed Linear project
- [ ] Verified workflow state mapping
- [ ] Verified/created labels
- [ ] Gathered project information
- [ ] Filled context files
- [ ] Created initial issues in Linear
- [ ] Provided setup confirmation
