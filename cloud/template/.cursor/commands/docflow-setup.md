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

### 8a. **Gather Project Links**

After gathering project information, ask about links:

```markdown
## 🔗 Project Links

Let's capture important links for this project:

**Repository:**
- What's the GitHub/GitLab URL for this project?
- (If not yet created, we can add this later)

**Related Links** (optional):
- Figma designs?
- Documentation?
- External APIs or services?
- Deployment dashboards?

Share any links you'd like to keep handy, or say "skip" to add later.
```

**When user provides links:**
- Save repository URL to overview.md Links section
- Save each related link with a brief description
- These will sync to Linear project description

**If user skips:**
- Leave Links section with placeholder
- Note they can add links anytime and run `/sync-project`

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

### 10. **Sync Project Description**

After context files are filled, sync to Linear project:

```markdown
✅ Context files ready!

Syncing project description to Linear...
```

**Run `/sync-project` (or inline):**
- Read context files
- Generate summary
- Update Linear project `content` field

```markdown
✅ Project synced!

Linear project description now includes:
- Vision and goals from overview.md
- Tech stack from stack.md
- Key standards from standards.md

**Note:** If you update context files later, run `/sync-project` to keep Linear in sync.
```

---

### 11. **Create Initial Linear Issues**

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

### 12. **Setup Complete**

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
- ✓ Links captured (repo + related)
- ✓ Project synced to Linear

**Initial Work:**
- ✓ Created [X] issues in Linear backlog

---

**You're ready to start!**

Next commands:
- `/start-session` - See your Linear backlog and start working
- `/capture` - Add more work items
- `/implement [issue]` - Pick up and build

**Remember:** 
- If you update `docflow/context/` files, run `/sync-project` to keep Linear in sync
- When you encounter useful links during development, I'll ask if you want to save them

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

## Migration from Local DocFlow

**Detection:** `docflow/specs/` folder exists with content (backlog or complete specs)

This scenario handles projects that used local DocFlow and are migrating to cloud.

### Migration Overview

```
Local DocFlow                    Linear
─────────────────────────────────────────────────
docflow/specs/backlog/*.md   →   Issues (Backlog state)
docflow/specs/complete/*.md  →   Issues (Done state)
docflow/context/*            →   Keep local (unchanged)
docflow/knowledge/*          →   Keep local (unchanged)
docflow/ACTIVE.md            →   Remove (Linear views replace)
docflow/INDEX.md             →   Remove (Linear views replace)
docflow/specs/templates/*    →   Remove (Linear templates replace)
```

### Step M1: Detect Local Specs

After steps 1-7 (environment, API, team, project, states, labels), check for local specs:

```bash
# Check if local specs exist
ls docflow/specs/backlog/*.md 2>/dev/null | wc -l
ls docflow/specs/complete/**/*.md 2>/dev/null | wc -l
```

**If local specs found:**
```markdown
## 📦 Local Specs Detected

I found existing local DocFlow specs:

| Location | Count |
|----------|-------|
| Backlog | [N] specs |
| Complete | [N] specs |

These need to be migrated to Linear. I'll:
1. Parse each spec into our Linear issue template
2. Create issues in Linear with appropriate status
3. Preserve decision logs and notes as comments
4. Archive the local specs folder when done

Ready to migrate? (yes/no)
```

**If no local specs:** Skip to step 8 (gather project info or use existing context).

---

### Step M2: Parse and Import Backlog Specs

For each file in `docflow/specs/backlog/*.md`:

#### M2a. Parse Local Spec

Read the spec file and extract:

```typescript
interface LocalSpec {
  // From frontmatter/header
  title: string;           // Spec title
  type: 'feature' | 'bug' | 'chore' | 'idea';  // From filename prefix
  status: string;          // BACKLOG
  priority: string;        // Low, Medium, High, Urgent
  complexity: string;      // XS, S, M, L, XL
  
  // Dates from metadata (preserve original timestamps)
  created: string;         // **Created**: 2025-12-02
  completed?: string;      // **Completed**: 2025-12-01 (only for done specs)
  
  // From sections
  problemStatement: string;  // ## Problem Statement
  proposedSolution: string;  // ## Proposed Solution
  acceptanceCriteria: string[];  // ## Acceptance Criteria (as checkboxes)
  technicalNotes: string;    // ## Technical Notes
  outOfScope: string;        // ## Out of Scope
  dependencies: string;      // ## Dependencies
  
  // From logs (will become comments)
  decisionLog: DecisionEntry[];  // ## Decision Log table
  implementationNotes: string;   // ## Implementation Notes
}
```

**Date parsing:**
Extract dates from the metadata header:
```
**Created**: 2025-12-02     → created: "2025-12-02"
**Completed**: 2025-12-01   → completed: "2025-12-01"
```

If no date found, default to today's date.

**Filename parsing:**
- `feature-place-photos.md` → type: "feature", title: "Place Photos"
- `bug-login-crash.md` → type: "bug", title: "Login Crash"
- `chore-cleanup.md` → type: "chore", title: "Cleanup"
- `idea-voice-control.md` → type: "idea", title: "Voice Control"

#### M2b. Look Up Label ID for Issue Type

**IMPORTANT:** Each issue must have the correct type label applied.

Before creating issues, query Linear for the team's labels:

```typescript
// Via MCP
const labels = await linear_getLabels({ teamId: config.teamId });

// Or via GraphQL
query {
  team(id: "TEAM_ID") {
    labels {
      nodes { id name }
    }
  }
}
```

**Map filename prefix to label:**

| Filename Prefix | Label Name | Example |
|-----------------|------------|---------|
| `feature-*` | feature | feature-place-photos.md |
| `bug-*` | bug | bug-login-crash.md |
| `chore-*` | chore | chore-cleanup.md |
| `idea-*` | idea | idea-voice-control.md |

**Find the label ID:**
```typescript
const typeLabelId = labels.find(l => l.name.toLowerCase() === parsedType)?.id;
```

If label not found, warn user and continue without label.

#### M2c. Map to Linear Issue Template

Transform local spec to Linear issue format:

**Title:** `[Parsed title]`

**Description (using our template structure):**
```markdown
## Context
[Problem Statement from local spec]

[Proposed Solution from local spec, if different context needed]

## User Story
<!-- Parse from spec or generate from context -->
**As a** [inferred user type]
**I want to** [goal from problem statement]
**So that** [benefit]

## Acceptance Criteria

### Must Have
[Parse acceptance criteria from local spec as checkboxes]
- [ ] [Criterion 1]
- [ ] [Criterion 2]

### Should Have
[Nice-to-haves if present in local spec]

### Won't Have (Out of Scope)
[Out of Scope section from local spec]

## Technical Notes

### Implementation Approach
[Technical Notes from local spec]

### Dependencies
[Dependencies from local spec]

---

_Migrated from local DocFlow on [date]_
```

**Labels (REQUIRED):**
- Use the `typeLabelId` from step M2b
- This applies the type label (feature/bug/chore/idea) to the issue
- **Do not skip this** - issues without type labels are harder to filter

**Priority:** Map from local spec
- Urgent → 1
- High → 2
- Medium → 3
- Low → 4

**Estimate:** Map complexity to points
- XS → 1
- S → 2
- M → 3
- L → 4
- XL → 5

**State:** Backlog (for backlog specs)

#### M2d. Create Linear Issue

**Include original dates AND type label when creating issues:**

```typescript
// Via MCP
createIssue({
  teamId: config.teamId,
  projectId: config.projectId,
  title: parsedSpec.title,
  description: formattedDescription,
  // IMPORTANT: Include type label from step M2b
  labelIds: [typeLabelId],  // e.g., label ID for "feature", "bug", etc.
  priority: mappedPriority,
  estimate: mappedEstimate,
  stateId: backlogStateId,
  // Preserve original creation date from local spec
  createdAt: parsedSpec.created  // "2025-12-02" → ISO date
})
```

**Via GraphQL API (if MCP doesn't support createdAt):**
```bash
source .env && curl -s -X POST https://api.linear.app/graphql \
  -H "Authorization: $LINEAR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "mutation CreateIssue($input: IssueCreateInput!) { issueCreate(input: $input) { success issue { id identifier } } }",
    "variables": {
      "input": {
        "teamId": "TEAM_ID",
        "projectId": "PROJECT_ID",
        "title": "TITLE",
        "description": "DESCRIPTION",
        "labelIds": ["LABEL_ID"],
        "priority": 3,
        "estimate": 2,
        "stateId": "STATE_ID",
        "createdAt": "2025-12-02T00:00:00.000Z"
      }
    }
  }'
```

**Note:** Linear accepts `createdAt` for data import scenarios. Format as ISO 8601.

#### M2e. Add Decision Log as Comments

If the local spec has a Decision Log, add each entry as a comment:

```typescript
// For each decision in decisionLog
addComment(issueId, {
  body: `### ${decision.date} - ${decision.title}\n\n${decision.rationale}\n\n_Imported from local spec_`
})
```

**Progress update:**
```markdown
✓ Imported: feature-place-photos → LIN-XXX
✓ Imported: feature-ui-overhaul → LIN-XXY
✓ Imported: idea-voice-control → LIN-XXZ
✓ Imported: idea-caravan-mode → LIN-XYZ

Backlog: 4/4 specs imported
```

---

### Step M3: Import Completed Specs

For completed specs, offer **CSV export** as the primary method (faster for bulk historical data).

**Ask user for import method:**
```markdown
## 📚 Completed Specs

Found [N] completed specs in local archive.

**Import options:**
1. **CSV export** (Recommended) - Generate CSV, import via Linear UI
2. **Individual API** - Create each issue via API (slower)
3. **Skip** - Don't import completed (history stays in git)

Which option?
```

---

#### Option 1: CSV Export (Recommended for 10+ specs)

Generate a CSV file that can be imported via Linear's built-in import:

**Generate CSV file:**
```bash
# Create: docflow/completed-specs-import.csv
```

**CSV columns:**
```csv
Title,Description,State,Labels,Priority,Estimate,Created,Completed
"Feature: Driving Detection","## Context\n...",Done,feature,2,3,2025-09-19,2025-12-01
"Feature: Map Integration","## Context\n...",Done,feature,2,2,2025-10-15,2025-12-01
```

**For each completed spec, extract:**

| CSV Column | Source | Example |
|------------|--------|---------|
| Title | Spec title (from header or filename) | "Feature: Driving Detection" |
| Description | Full spec content (Context, Acceptance Criteria, etc.) | Markdown content |
| State | Always "Done" for completed | Done |
| Labels | Filename prefix | feature, bug, chore, idea |
| Priority | `**Priority**` field mapped | 1=Urgent, 2=High, 3=Medium, 4=Low |
| Estimate | `**Complexity**` field mapped | 1=XS, 2=S, 3=M, 4=L, 5=XL |
| Created | `**Created**` date | 2025-09-19 |
| Completed | `**Completed**` date | 2025-12-01 |

**After generating CSV:**
```markdown
## ✅ CSV Generated

Created: `docflow/completed-specs-import.csv`
Contains: [N] completed specs

**To import into Linear:**
1. Go to Linear → Team Settings → Import/Export
2. Click "Import Issues"
3. Upload the CSV file
4. Map columns (should auto-detect)
5. Set Project to: [Project Name]
6. Import!

After import, you can delete the CSV file.
```

---

#### Option 2: Individual API (For smaller batches)

If user prefers API or has < 10 specs:

For each file in `docflow/specs/complete/**/*.md`:

Same process as M2 (backlog), but:
- Set state to **Done** instead of Backlog
- **Set `createdAt`** from spec's `**Created**` date
- **Set `completedAt`** from spec's `**Completed**` date
- Include type label from filename prefix

**Create completed issue with dates:**
```typescript
createIssue({
  teamId: config.teamId,
  projectId: config.projectId,
  title: parsedSpec.title,
  description: formattedDescription,
  labelIds: [typeLabelId],  // IMPORTANT: Include type label
  priority: mappedPriority,
  estimate: mappedEstimate,
  stateId: doneStateId,
  createdAt: parsedSpec.created,     // "2025-09-19"
  completedAt: parsedSpec.completed  // "2025-12-01"
})
```

**Progress update:**
```markdown
✓ Imported: feature-driving-detection → LIN-AAA (Done)
✓ Imported: feature-map-integration → LIN-AAB (Done)
... [N more]

Complete: [N]/[N] specs imported
```

---

#### Option 3: Skip

If user skips completed specs:
- History remains in git (specs-archived folder)
- Only backlog/active specs migrated to Linear
- User can import later if needed

---

### Step M4: Archive Local Specs

After successful import:

```bash
# Create timestamped archive folder
ARCHIVE_DATE=$(date +%Y-%m-%d)
mv docflow/specs docflow/specs-archived-$ARCHIVE_DATE

# Remove tracking files (replaced by Linear views)
rm -f docflow/ACTIVE.md
rm -f docflow/INDEX.md
```

**Report:**
```markdown
## 📁 Local Specs Archived

- Specs moved to: `docflow/specs-archived-[date]/`
- Removed: `ACTIVE.md` (replaced by Linear "In Progress" view)
- Removed: `INDEX.md` (replaced by Linear issue list)

**Note:** The archived folder is in `.gitignore`. You can delete it after 
confirming all specs imported correctly to Linear.
```

---

### Step M5: Migration Complete

```markdown
## ✅ Migration Complete!

**Imported to Linear:**
- Backlog: [N] issues created
- Complete: [N] issues created (historical)
- Decision logs preserved as comments

**Archived locally:**
- `docflow/specs-archived-[date]/` (safe to delete later)
- Removed: ACTIVE.md, INDEX.md

**Preserved locally:**
- `docflow/context/` - Project understanding (unchanged)
- `docflow/knowledge/` - ADRs, notes, product docs (unchanged)

**Linear Project:**
- [Project Name] configured
- [View project](linear-project-url)
- [View backlog](linear-backlog-url)

---

You're now running DocFlow Cloud! 🚀

**Next steps:**
- `/start-session` - See your Linear backlog
- `/status` - Check current state
- Use Linear for all spec work going forward
```

---

### Migration Edge Cases

**Malformed specs:**
- If a spec can't be parsed, report it and skip
- User can manually create issue later
- Don't block entire migration on one bad file

**Large migrations (50+ specs):**
- Process in batches of 10
- Show progress updates
- Allow pause/resume if needed

**Active specs (in docflow/specs/active/):**
- These become "In Progress" issues
- Alert user to verify they're assigned correctly

**Specs with assets:**
- Note any files in `docflow/specs/assets/`
- Suggest manual upload to Linear or linking

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
- "migrate to linear" / "migrate to cloud"
- "import my specs" / "move specs to linear"

**Run this command when detected.**

---

## Outputs
- `.env` validated
- `.docflow.json` status mapping verified with team/project IDs
- `docflow/context/*` files preserved or populated
- Linear project created/configured
- Project description synced to Linear

**For migrations:**
- Local specs imported as Linear issues
- Decision logs preserved as comments
- Local specs archived to `specs-archived-[date]/`
- ACTIVE.md and INDEX.md removed
- Project ready for cloud workflow

---

## Checklist

### Environment & Connection
- [ ] Checked .env file exists
- [ ] Validated LINEAR_API_KEY
- [ ] Tested Linear API connection
- [ ] Selected/saved team ID to .docflow.json
- [ ] Selected/saved project ID to .docflow.json (or created new)
- [ ] Verified workflow state mapping
- [ ] Verified/created labels

### Migration (if local specs exist)
- [ ] Detected local specs in docflow/specs/
- [ ] Parsed backlog specs into Linear template format
- [ ] Created Linear issues for backlog (Backlog state)
- [ ] Asked about importing completed specs
- [ ] Created Linear issues for completed (Done state)
- [ ] Imported decision logs as comments
- [ ] Archived local specs folder
- [ ] Removed ACTIVE.md and INDEX.md

### Project Context
- [ ] Used existing context files (or gathered new info)
- [ ] Verified overview.md, stack.md, standards.md are filled
- [ ] Asked about project links (repo, Figma, docs, etc.)
- [ ] Synced project description to Linear

### Completion
- [ ] Provided setup/migration summary
- [ ] Showed Linear project links
- [ ] Gave next step commands
