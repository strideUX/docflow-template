# Linear Integration Rules

> Load when working with Linear API, issues, or workflow states.

---

## Status States

### Full Workflow (Features & Bugs)
```
BACKLOG → READY → IMPLEMENTING ──→ REVIEW → TESTING → COMPLETE
   │         │          │            │         │         │
 Linear   Linear     Linear       Linear    Linear    Linear
Backlog    Todo    In Progress  In Review    QA       Done
                        │            │
                        ▼            │
                    BLOCKED ◄────────┘
```

### State Meanings

| State | Linear | What Happens |
|-------|--------|--------------|
| BACKLOG | Backlog | Raw ideas or refined specs awaiting prioritization |
| READY | Todo | Refined, prioritized, ready to pick up |
| IMPLEMENTING | In Progress | Code + Tests + Docs being written |
| BLOCKED | Blocked | Stuck - needs feedback, dependency, or decision |
| REVIEW | In Review | Implementation complete, awaiting code review |
| TESTING | QA | Code review passed, manual testing by user |
| COMPLETE | Done | Verified and shipped |

### Terminal States (via `/close`)

| State | Linear | What Happens |
|-------|--------|--------------|
| ARCHIVED | Archived | Deferred to future - not canceled |
| CANCELED | Canceled | Decision made not to pursue |
| DUPLICATE | Duplicate | Already exists - link to original |

### Simplified Workflow (Chores & Ideas)
```
BACKLOG → ACTIVE → COMPLETE
```

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
| 2     | High    | Next up, important                |
| 3     | Medium  | Normal priority (default)         |
| 4     | Low     | Nice to have, when time permits   |

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

**During implementation:**
1. Read current description to see checkbox state
2. As each criterion is completed, update description with `[x]`
3. Use `update_issue` with full updated description
4. Add comment noting progress

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

### Assignment
```typescript
updateIssue(issueId, { assignee: "cory" })      // by name
updateIssue(issueId, { assignee: "me" })        // self
updateIssue(issueId, { assignee: "cory@..." })  // by email
```

### Subscribers (Notifications)
```bash
# Via GraphQL API (requires LINEAR_API_KEY)
issueUpdate(id: "...", input: { subscriberIds: ["user-id"] })
```

### Finding Users
```typescript
list_users({ query: "cory" })  // Find user by name/email
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
        ▼
    BACKLOG (typed, templated)
        │
        │ /refine (refinement path)
        ▼
      READY
```

**Triage label:** Issues with `triage` label are raw captures needing classification.
