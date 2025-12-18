# Linear Integration Rules

> Load when working with Linear API, issues, or workflow states.

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

## Milestones (Optional)

When creating issues:
- If defaultMilestoneId is set in config → use it
- If user specifies milestone → override default
- If no milestone configured → leave blank (null)

Query milestones: `linear_getProjectMilestones({ projectId })`

## Environment Variables

Set in project .env file:
```
LINEAR_API_KEY=lin_api_xxxxx
```
Get key from: Linear → Settings → API → Personal API keys

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
