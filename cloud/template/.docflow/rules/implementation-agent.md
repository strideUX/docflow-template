# Implementation Agent Rules

> Load when building features, fixing bugs, or implementing specs.

---

## Role Overview

The Implementation Agent builds:
- Picks up assigned work from Linear
- Implements code + tests + documentation
- Tracks progress via Linear checkboxes and comments
- Handles blockers appropriately
- Hands off to Review when complete

---

## On Startup (via /implement)

1. Query Linear for issues assigned to current user in "Todo" or "In Progress"
2. **Check assignment before starting** - warn if picking up issue assigned to someone else
3. If multiple, ask user which to work on
4. Read full issue including comments
5. Show implementation checklist reminder (code + tests + docs)

---

## Context to Load

- Current Linear issue (full description + comments)
- `{paths.content}/context/stack.md` (technical patterns)
- `{paths.content}/context/standards.md` (code conventions)
- If issue has Figma attachment → call Figma MCP for design context

---

## Implementation Checklist

**Implementation = Code + Tests + Docs**

Remind at start of implementation:
```markdown
📋 **Implementation Checklist**

As you build, remember to:
- [ ] Write tests alongside code (per acceptance criteria)
- [ ] Document decisions in Linear comments
- [ ] Update knowledge base for significant patterns/decisions
- [ ] Update context files if architecture changes

When complete, I'll move to REVIEW and add a summary.
```

---

## During Implementation

1. Write tests alongside code (not after)
2. Update description checkboxes as criteria are completed
3. Add progress comments: `**Progress** — What was done.`
4. Document decisions in comments (dated)
5. If Figma attached: call Figma MCP for design specs
6. Document significant patterns/decisions to knowledge base

### Updating Checkboxes

Read current description, update checkbox from `[ ]` to `[x]`, save with `update_issue`, add progress comment.

---

## On Completion

1. Verify ALL acceptance criteria checkboxes are checked
2. Move to "In Review" state
3. Add detailed completion comment:

```markdown
**Ready for Review** —

**Summary:** [What was built/fixed]
**Files Changed:** [count] files
**Tests:** [what was tested]
**Documentation:** [docs added/updated or N/A]
**Acceptance Criteria:** [X]/[Y] complete
```

---

## On Blocker (via /block)

1. Move to "Blocked" state
2. If blocked by another issue, create dependency link (blockedByIssueIds)
3. Add comment: `**Blocked** — [What's blocking]. Needs: [what's needed].`
4. Tag PM/reviewer if needed

---

## Resuming from Blocked

When blocker is resolved, `/implement` moves issue back to "In Progress":
- Add comment: `**Unblocked** — [What resolved the blocker].`

---

## Natural Language Triggers

| Phrase | Action |
|--------|--------|
| "implement [issue]" / "build [issue]" | /implement |
| "let's work on LIN-XXX" | /implement |
| "I'm blocked" / "can't proceed" | /block |
| "attach [file]" | /attach |

---

## Documentation During Implementation

**Add to Knowledge Base when:**
- Architectural decisions made
- Non-obvious solutions discovered
- Complex patterns established

**Update Context Files when:**
- New technologies added (stack.md)
- New conventions established (standards.md)
