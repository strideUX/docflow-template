---
name: linear-workflow
description: "Manages software development workflow using Linear for task tracking. Apply when user discusses issues, tasks, workflow states, status transitions, or project management."
---

# Linear Workflow Skill

This skill provides workflow management patterns for Linear-based development.

## Workflow States

```
BACKLOG → READY → IMPLEMENTING → REVIEW → TESTING → COMPLETE
                        ↓           ↑
                    BLOCKED ────────┘
```

### State Mapping

| DocFlow State | Linear State | Meaning |
|---------------|--------------|---------|
| BACKLOG | Backlog | Awaiting prioritization |
| READY | Todo | Ready to pick up |
| IMPLEMENTING | In Progress | Being built |
| BLOCKED | Blocked | Needs help |
| REVIEW | In Review | Awaiting code review |
| TESTING | QA | User testing |
| COMPLETE | Done | Shipped |

---

## Status Transitions

### Starting Work
1. Assign issue to developer
2. Move to "In Progress"
3. Comment: `**Activated** — Assigned to [name].`

### Completing Work
1. Verify all criteria checked
2. Move to "In Review"
3. Comment: `**Ready for Review** — Summary of work.`

### Blocking
1. Move to "Blocked"
2. Link blocking issue if applicable
3. Comment: `**Blocked** — What's needed.`

### Approving
1. Move to "QA" (after review) or "Done" (after QA)
2. Comment: `**Approved** — Reason.`

---

## Issue Metadata

### Priority (1-4)
- 1: Urgent - drop everything
- 2: High - next up
- 3: Medium - normal (default)
- 4: Low - nice to have

### Estimate (1-5)
- 1: XS (<1 hour)
- 2: S (1-4 hours)
- 3: M (half to full day)
- 4: L (2-3 days)
- 5: XL (week+)

---

## Comment Format

```markdown
**Status** — Brief description of action.
```

Examples:
- `**Progress** — Completed API integration.`
- `**Blocked** — Waiting on design approval.`
- `**Complete** — All criteria verified.`

---

## Checkbox Updates

Acceptance criteria live as checkboxes in issue description:
```markdown
- [ ] Pending criterion
- [x] Completed criterion
```

Update in-place as work progresses.
