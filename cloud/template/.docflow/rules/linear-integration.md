# Linear Integration Rules

> Load when working with Linear API, issues, or workflow states.

---

## ⚠️ CRITICAL: MCP Limitations

**The Linear MCP CANNOT do these operations - you MUST use curl commands:**

| Operation | MCP Support | What To Do |
|-----------|-------------|------------|
| Create Milestone | ❌ NO | Execute curl command (see Milestones section) |
| Assign to Milestone | ❌ NO | Execute curl command (see Milestones section) |
| Post Project Update | ❌ NO | Execute curl command (see Project Updates section) |

**DO NOT try MCP tools for these operations. Go directly to the curl commands.**

---

## Status States

### Full Workflow (Features & Bugs)
```
BACKLOG ──→ READY ──→ IMPLEMENTING ──→ REVIEW → TESTING → COMPLETE
   │          │            │             │         │         │
 Linear    Linear       Linear        Linear    Linear    Linear
Backlog     Todo      In Progress   In Review    QA       Done
                           │             │
                           ▼             │
                       BLOCKED ◄─────────┘
```

**State Transitions:**
- `/capture` → Backlog (raw capture)
- `/refine` → Todo (refined, ready to pick up)
- `/activate` → In Progress (**MUST be assigned** - no exceptions)

### State Meanings

| State | Linear | What Happens | Assignment |
|-------|--------|--------------|------------|
| BACKLOG | Backlog | Raw ideas or refined specs awaiting prioritization | Optional |
| READY | Todo | Refined, prioritized, ready to pick up | Optional |
| IMPLEMENTING | In Progress | Code + Tests + Docs being written | **REQUIRED** |
| BLOCKED | Blocked | Stuck - needs feedback, dependency, or decision | Required |
| REVIEW | In Review | Implementation complete, awaiting code review | Required |
| TESTING | QA | Code review passed, manual testing by user | Required |
| COMPLETE | Done | Verified and shipped | Required |

### Terminal States (via `/close`)

| State | Linear | What Happens |
|-------|--------|--------------|
| ARCHIVED | Archived | Deferred to future - not canceled |
| CANCELED | Canceled | Decision made not to pursue |
| DUPLICATE | Duplicate | Already exists - link to original |

### Simplified Workflow (Chores & Ideas)
```
BACKLOG → IMPLEMENTING → COMPLETE
```
*Note: Chores and ideas skip REVIEW/TESTING unless explicitly needed.*

---

## Reading from Linear

Use Linear MCP to:
- Query issues by status, assignee, labels
- Read issue details including comments
- Get attachment URLs (Figma links, screenshots)

## Writing to Linear

Use Linear MCP to:
- Create new issues
- Update issue status, priority, estimate
- Update issue description (including checkboxes)
- Add comments
- Assign users

---

## Priority Values

| Value | Name    | Use When                          |
|-------|---------|-----------------------------------|
| 0     | None    | Not yet triaged                   |
| 1     | Urgent  | Drop everything, fix now          |
| 2     | High    | Next up, important, unblocks others |
| 3     | Medium  | Normal priority (default)         |
| 4     | Low     | Nice to have, when time permits   |

**Setting Priority:**
- During `/refine` - set based on importance and blocking relationships
- During `/activate` - confirm or adjust priority
- Higher priority if issue unblocks other work

---

## Dependencies (Blocking Relationships)

Linear supports "blocks" and "blocked by" relationships between issues.

### When to Set Dependencies

- During `/docflow-setup` Phase 4 (initial prioritization)
- During `/refine` (ask about dependencies)
- Anytime logical ordering is apparent

### How to Query Dependencies

```typescript
// Get issue with relations
get_issue({ id: "PLA-123", includeRelations: true })

// Response includes:
// - relations.blocks: issues this blocks
// - relations.blockedBy: issues blocking this
```

### How to Create Dependencies

```typescript
// Via GraphQL API (LINEAR_API_KEY required)
issueRelationCreate({
  issueId: "blocking-issue-id",
  relatedIssueId: "blocked-issue-id",
  type: "blocks"
})
```

### Smart Activation Query

When recommending "what's next", filter for ready issues:
1. In Todo or Backlog state
2. Not blocked by incomplete issues
3. Sorted by Priority (Urgent → Low)
4. Show what each issue unblocks

```markdown
📋 **Ready to work on:**

**Recommended:** PLA-75 - Auth System
- Priority: High
- No blockers ✓
- Unblocks: PLA-80, PLA-85

**Blocked (can't start yet):**
- PLA-80 - User Dashboard (waiting on PLA-75)
```

---

## Estimate Values (Complexity)

| Value | Name | Rough Effort         |
|-------|------|----------------------|
| 1     | XS   | < 1 hour             |
| 2     | S    | 1-4 hours            |
| 3     | M    | Half day to full day |
| 4     | L    | 2-3 days             |
| 5     | XL   | Week+                |

---

## Acceptance Criteria as Checkboxes

Issue descriptions contain acceptance criteria as markdown checkboxes:
```markdown
## Acceptance Criteria
- [ ] First criterion
- [ ] Second criterion
- [x] Completed criterion
```

**IMPORTANT: Checkboxes live in the DESCRIPTION, not comments.**

**During implementation:**
1. Read current issue description via Linear MCP
2. Find the checkbox for the completed criterion
3. Change `- [ ]` to `- [x]` in the description text
4. Save the ENTIRE updated description via `update_issue`
5. Optionally add a brief progress comment

**Example update_issue call:**
```typescript
update_issue({
  issueId: "xxx",
  description: "...full description with updated checkboxes..."
})
```

**DO NOT** put completion checkboxes in comments - always update the description.

---

## Comment Format

Use consistent format for audit trail:
```markdown
**Status** — Brief description of action taken.
```

**Examples:**
- `**Activated** — Assigned to Matt, Priority: High, Estimate: S.`
- `**Progress** — Completed data model, starting on hooks.`
- `**Blocked** — Waiting on API access. Needs: Backend credentials.`
- `**Unblocked** — API access granted, resuming.`
- `**Complete** — All acceptance criteria met.`

---

## Team Collaboration

### Assignment (MANDATORY for In Progress)

⚠️ **No issue can be In Progress without an assignee.**

**Finding Current User:**
```typescript
// Get authenticated user
get_viewer()  // Returns current user info

// Or search by name/email
list_users({ query: "matt" })
```

**Assigning Issues:**
```typescript
update_issue({
  issueId: "xxx",
  assigneeId: "user-uuid"  // Use UUID, not name
})
```

**Assignment Flow:**
1. Determine user (get_viewer or ask explicitly)
2. Update issue with assigneeId
3. Verify assignment succeeded (query issue)
4. Only then move to In Progress

### Subscribers (Notifications)
```bash
# Via GraphQL API (requires LINEAR_API_KEY)
issueUpdate(id: "...", input: { subscriberIds: ["user-id"] })
```

### Finding Users
```typescript
list_users({ query: "cory" })  // Find user by name/email
get_viewer()                    // Get current authenticated user
```

---

## Configuration

Read `.docflow/config.json` for:
- `paths.content` - Where context/knowledge folders live
- `provider.teamId` - Required
- `provider.projectId` - Required for project-scoped work
- `provider.defaultMilestoneId` - Optional auto-assign
- `statusMapping` - Maps DocFlow states to Linear states

## Milestones

**Linear MCP does NOT support milestones. YOU MUST use direct API calls.**

When the user asks to create, query, or assign milestones, **execute these shell commands directly**.

### Setup (Run First)

```bash
# Get credentials - run this before any milestone operation
LINEAR_API_KEY=$(grep LINEAR_API_KEY .env | cut -d '=' -f2)
PROJECT_ID=$(jq -r '.provider.projectId' .docflow/config.json)
```

### Query Project Milestones

**Execute this to list existing milestones:**

```bash
curl -s -X POST https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: $LINEAR_API_KEY" \
  -d '{
    "query": "query($projectId: String!) { project(id: $projectId) { projectMilestones { nodes { id name description sortOrder targetDate } } } }",
    "variables": { "projectId": "'"$PROJECT_ID"'" }
  }'
```

### Create Milestone

**Execute this to create a new milestone (substitute values):**

```bash
curl -s -X POST https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: $LINEAR_API_KEY" \
  -d '{
    "query": "mutation($projectId: String!, $name: String!, $description: String, $targetDate: TimelessDate) { projectMilestoneCreate(input: { projectId: $projectId, name: $name, description: $description, targetDate: $targetDate }) { success projectMilestone { id name } } }",
    "variables": {
      "projectId": "'"$PROJECT_ID"'",
      "name": "MILESTONE_NAME_HERE",
      "description": "DESCRIPTION_HERE",
      "targetDate": "YYYY-MM-DD"
    }
  }'
```

**Example:** Create "Testing & Deployment" milestone:
```bash
curl -s -X POST https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: $LINEAR_API_KEY" \
  -d '{
    "query": "mutation($projectId: String!, $name: String!) { projectMilestoneCreate(input: { projectId: $projectId, name: $name }) { success projectMilestone { id name } } }",
    "variables": { "projectId": "'"$PROJECT_ID"'", "name": "Testing & Deployment" }
  }'
```

### Assign Issue to Milestone

**Execute this to move an issue to a milestone:**

First, get the issue ID (from Linear MCP or issue identifier like "PLA-123"):
```bash
# If you have the issue identifier, query for UUID first
curl -s -X POST https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: $LINEAR_API_KEY" \
  -d '{
    "query": "query { issue(id: \"PLA-123\") { id title } }"
  }'
```

Then assign to milestone:
```bash
curl -s -X POST https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: $LINEAR_API_KEY" \
  -d '{
    "query": "mutation($issueId: String!, $milestoneId: String!) { issueUpdate(id: $issueId, input: { projectMilestoneId: $milestoneId }) { success } }",
    "variables": {
      "issueId": "ISSUE_UUID_HERE",
      "milestoneId": "MILESTONE_UUID_HERE"
    }
  }'
```

### Milestone Workflow

**During `/docflow-setup`:**
1. Query if project has milestones
2. If none, offer to create phase-based milestones
3. When creating backlog items, assign to appropriate milestone

**During `/capture`:**
1. Query project milestones
2. If milestones exist, ask which one (or none)
3. Assign on issue creation

**Default Milestone (config):**
- `provider.defaultMilestoneId` - Auto-assign to this milestone if set
- User can override per-issue

### Thinking in Milestones

When building initial backlog, group work into phases:

```markdown
**Phase 1: Foundation** (Week 1-2)
- Infrastructure setup
- Auth system
- Core data models

**Phase 2: Core Features** (Week 3-4)
- Feature A
- Feature B

**Phase 3: Polish** (Week 5-6)
- UI refinements
- Performance
- Documentation
```

Each phase becomes a Linear milestone with a target date.

## Environment Variables

Set in project .env file:
```
LINEAR_API_KEY=lin_api_xxxxx
```
Get key from: Linear → Settings → API → Personal API keys

---

## Project Updates

**Note:** Linear MCP does not support project updates. Use direct API call.

### API Call (Shell)

```bash
# Read API key and project ID
LINEAR_API_KEY=$(grep LINEAR_API_KEY .env | cut -d '=' -f2)
PROJECT_ID=$(jq -r '.provider.projectId' .docflow/config.json)

# Post project update
curl -s -X POST https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: $LINEAR_API_KEY" \
  -d '{
    "query": "mutation($projectId: String!, $body: String!, $health: ProjectUpdateHealthType!) { projectUpdateCreate(input: { projectId: $projectId, body: $body, health: $health }) { success projectUpdate { id url } } }",
    "variables": {
      "projectId": "'"$PROJECT_ID"'",
      "body": "**Session Summary**\n\n✅ Completed:\n- Item 1\n\n🔄 In Progress:\n- Item 2",
      "health": "onTrack"
    }
  }'
```

### API Call (JavaScript/TypeScript)

```typescript
const apiKey = process.env.LINEAR_API_KEY;
const projectId = config.provider.projectId; // from .docflow/config.json

const response = await fetch('https://api.linear.app/graphql', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': apiKey,
  },
  body: JSON.stringify({
    query: `
      mutation($projectId: String!, $body: String!, $health: ProjectUpdateHealthType!) {
        projectUpdateCreate(input: {
          projectId: $projectId
          body: $body
          health: $health
        }) {
          success
          projectUpdate { id url }
        }
      }
    `,
    variables: {
      projectId,
      body: sessionSummary,  // markdown string
      health: 'onTrack',     // or 'atRisk', 'offTrack'
    },
  }),
});

const result = await response.json();
console.log('Project update URL:', result.data.projectUpdateCreate.projectUpdate.url);
```

### Health Types

| Value | When to Use |
|-------|-------------|
| `onTrack` | Progress made, no blockers, on schedule |
| `atRisk` | Minor blockers, slight delays, needs attention |
| `offTrack` | Major blockers, significantly behind |

### When to Post

- `/wrap-session` — **REQUIRED** at end of every session
- `/project-update` — Manual posting anytime

### Update Format

```markdown
**Session Summary — [Date]**

✅ **Completed:**
- [PLA-XX] — [What was done]

🔄 **In Progress:**
- [PLA-XX] — [Current state]

📋 **Next Up:**
- [PLA-XX] — [Priority for next session]

🚧 **Blockers:** [None / List blockers]
```

---

## Intake/Triage Flow

```
Quick Capture (with triage label)
        │
        │ /refine (triage path)
        │ - Classify type, apply template
        │ - Set initial priority
        ▼
    BACKLOG (typed, templated, prioritized)
        │
        │ /refine (refinement path)
        │ - Refine criteria
        │ - Set dependencies
        │ - Confirm priority
        ▼
    TODO/READY (refined, prioritized, dependencies set)
        │
        │ /activate (smart recommend or specific)
        │ - Check not blocked
        │ - Assign, start work
        ▼
   IN PROGRESS (assigned, work started)
```

**Triage label:** Issues with `triage` label are raw captures needing classification.

**Ready queue:** Issues in "Todo" state are refined, prioritized, and ready for developers to pick up.

**Smart activation:** When no issue specified, recommend based on priority + unblocked status.
