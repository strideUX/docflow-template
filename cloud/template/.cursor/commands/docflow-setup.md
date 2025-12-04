# DocFlow Setup (System)

## Overview
Complete DocFlow Cloud setup: configure Linear, fill project context, and create initial work items.

**Agent Role:** PM/Planning Agent  
**Frequency:** Once per project (during initial setup)

---

## Steps

### 1. **Check Current State**

Read `.docflow.json` and verify:
- Does the file exist?
- Is `teamId` configured (not "YOUR_TEAM_ID")?
- Is `LINEAR_API_KEY` environment variable set?

```bash
# Check env var
echo $LINEAR_API_KEY
```

**If not configured:**
```markdown
## 🔧 DocFlow Cloud Setup

I see DocFlow Cloud is installed but Linear isn't fully configured yet.

**Current Status:**
- [ ] Linear API Key: ${set/not set}
- [ ] Team ID: ${configured/not configured}
- [ ] MCP Connection: ${working/not tested}

Let's complete the setup. Do you have:
1. A Linear account with API access?
2. Your Linear Team ID?

If not, I can help you get these.
```

### 2. **Complete Linear Configuration**

**If Team ID needed:**
```markdown
To find your Linear Team ID:

1. Go to Linear → Team Settings → General
2. Look at the URL: linear.app/team/**TEAM_KEY**/settings
3. Or use the API to query teams

What's your team key or ID?
```

**If API Key needed:**
```markdown
To get your Linear API Key:

1. Go to Linear → Settings → API → Personal API Keys
2. Create a new key with appropriate permissions
3. Copy the key (starts with `lin_api_`)

Set it as an environment variable:
```bash
export LINEAR_API_KEY="lin_api_your_key_here"
```

Add to your ~/.zshrc or ~/.bashrc for persistence.
```

**Update .docflow.json with provided values:**
```typescript
// Update the config file
{
  "linear": {
    "teamId": "provided-team-id"
  }
}
```

### 3. **Test Linear Connection**

Use Linear MCP to verify connection:
```typescript
// Test query
const teams = await linearClient.teams();
console.log("Connected to Linear!");
console.log("Teams:", teams.nodes.map(t => t.name));
```

**If successful:**
```markdown
✅ Linear connection verified!

**Team:** [Team Name]
**Workflow States:** [list states]
**Labels:** [list labels]

I'll map these to DocFlow workflow states.
```

**If failed:**
- Check API key is correct
- Verify permissions
- Ensure MCP is configured in `.cursor/mcp.json`

### 4. **Map Workflow States**

Query Linear for team's workflow states and map to DocFlow:

```typescript
const team = await linearClient.team(teamId);
const states = await team.states();

// Auto-map based on common names
const mapping = {
  BACKLOG: findState(states, ['Backlog', 'To Do', 'Open']),
  READY: findState(states, ['Todo', 'Ready', 'Ready for Dev']),
  IMPLEMENTING: findState(states, ['In Progress', 'In Development']),
  REVIEW: findState(states, ['In Review', 'Code Review']),
  TESTING: findState(states, ['QA', 'Testing', 'In QA']),
  COMPLETE: findState(states, ['Done', 'Closed', 'Complete'])
};
```

**Present mapping to user:**
```markdown
## Workflow State Mapping

I'll map your Linear states to DocFlow workflow:

| DocFlow | Linear State | ID |
|---------|--------------|-----|
| BACKLOG | Backlog | abc123 |
| READY | Todo | def456 |
| IMPLEMENTING | In Progress | ghi789 |
| REVIEW | In Review | jkl012 |
| TESTING | QA | mno345 |
| COMPLETE | Done | pqr678 |

Does this look right? I'll save these to .docflow.json.
```

Update `.docflow.json` with state IDs.

### 5. **Create or Map Labels**

Check if type labels exist, create if needed:

```typescript
const labels = await team.labels();

const typeLabels = {
  feature: findOrCreate('feature', '#3B82F6'),  // blue
  bug: findOrCreate('bug', '#EF4444'),          // red
  chore: findOrCreate('chore', '#6B7280'),      // gray
  idea: findOrCreate('idea', '#8B5CF6')         // purple
};
```

Update `.docflow.json` with label IDs.

### 6. **Gather Project Information**

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

### 7. **Fill Context Files**

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

### 8. **Create Initial Linear Issues**

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

**If approved, create issues:**
```typescript
for (const item of items) {
  await linearClient.createIssue({
    teamId: config.linear.teamId,
    title: item.title,
    description: buildDescription(item),
    priority: item.priority,
    labelIds: [config.linear.labels[item.type]],
    stateId: config.linear.states.BACKLOG
  });
}
```

### 9. **Setup Complete**

```markdown
## ✅ DocFlow Cloud Setup Complete!

**Configuration:**
- ✓ Linear connected (Team: [name])
- ✓ Workflow states mapped
- ✓ Labels configured
- ✓ .docflow.json updated

**Project Context:**
- ✓ overview.md filled
- ✓ stack.md configured
- ✓ standards.md ready

**Initial Work:**
- ✓ Created [X] issues in Linear backlog

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
- `.docflow.json` (configuration)
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
- `.docflow.json` fully configured
- `docflow/context/*` files populated
- Initial Linear issues created
- Project ready for development

---

## Checklist
- [ ] Checked Linear configuration status
- [ ] API key verified (env var)
- [ ] Team ID configured
- [ ] Linear connection tested
- [ ] Workflow states mapped and saved
- [ ] Labels created/mapped and saved
- [ ] Project information gathered
- [ ] Context files populated
- [ ] Initial issues created in Linear
- [ ] Setup confirmation provided

