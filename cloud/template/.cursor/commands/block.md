# Block (Implementation Agent)

## Overview
Move an issue to Blocked status when implementation cannot proceed due to a dependency, needed feedback, or decision.

**Agent Role:** Implementation Agent (builder)  
**Frequency:** When implementation cannot proceed

---

## Steps

### 1. **Identify Current Issue**

Check what's currently being worked on:
- Query Linear for issues assigned to current user in "In Progress" or "In Review" state
- Or use issue from recent context

### 2. **Gather Blocker Details**

Ask user (or infer from context):
- What specifically is blocking progress?
- What's needed to unblock?
- Who needs to help? (PM decision, external dependency, etc.)

### 3. **Move to Blocked State**

Update issue status to Blocked:

```typescript
updateIssue(issueId, {
  stateId: config.linear.states.BLOCKED
})
```

### 4. **Document Blocker in Linear**

Add blocker comment:

```typescript
addComment(issueId, {
  body: '**Blocked** — [What is blocking]. Needs: [what is needed to unblock].'
})
```

For complex blockers, can expand:
```markdown
**Blocked** — [Brief description of blocker].

**Needs to unblock:**
- [What's needed 1]
- [What's needed 2]

**Who can help:** @[person]
```

### 5. **Notify Relevant People (Optional)**

If someone specific needs to help, add them as a subscriber so they get notified:

```bash
# Via GraphQL API (LINEAR_API_KEY required)
source .env && curl -s -X POST https://api.linear.app/graphql \
  -H "Authorization: $LINEAR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "mutation { issueUpdate(id: \"ISSUE_ID\", input: { subscriberIds: [\"USER_ID\"] }) { success } }"
  }'
```

**This ensures they get notifications for all updates on the issue.**

To find user IDs:
```typescript
// Via MCP
list_users({ query: "cory" })  // Returns user ID
```

### 6. **Confirmation**

```markdown
🚫 Issue blocked: LIN-XXX

**Issue:** [Title]
**Blocker:** [Brief description]
**Status:** Blocked
**Needs:** [What's needed to unblock]

I've moved this to Blocked status and tagged relevant people in Linear.

**What you can do:**
1. Work on a different issue: `/status`
2. Wait for help on this blocker
3. When unblocked: `/implement LIN-XXX` to resume
```

---

## Common Blocker Types

**Technical Blocker:**
- Missing API/dependency
- Architecture decision needed
- Performance issue

**Requirements Blocker:**
- Unclear acceptance criteria
- Conflicting requirements
- Missing design

**External Blocker:**
- Waiting on third party
- Access/permissions needed
- Environment issue

---

## Resuming from Blocked

When the blocker is resolved, use `/implement LIN-XXX` to:
1. Move issue back to "In Progress"
2. Add unblock comment: `**Unblocked** — [What resolved the blocker].`
3. Resume implementation

---

## Context to Load
- Current Linear issue
- Implementation notes so far
- Minimal - focus on documenting blocker

---

## Natural Language Triggers
User might say:
- "I'm blocked" / "this is blocked"
- "can't proceed" / "need help"
- "stuck on this" / "hit a wall"
- "need PM input"
- "waiting on [something]"

**Run this command when detected.**

---

## Outputs
- Issue moved to Blocked state in Linear
- Blocker documented in Linear comment
- Relevant people tagged/subscribed
- User informed of options and how to resume

---

## Checklist
- [ ] Identified current issue
- [ ] Gathered blocker details
- [ ] Moved issue to Blocked state
- [ ] Added detailed blocker comment to Linear
- [ ] Tagged/subscribed relevant people
- [ ] Provided next step options (including how to resume)

