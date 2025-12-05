# Block (Implementation Agent)

## Overview
Document a blocker on the current issue and request help.

**Agent Role:** Implementation Agent (builder)  
**Frequency:** When implementation cannot proceed

---

## Steps

### 1. **Identify Current Issue**

Check what's currently being worked on:
- Query Linear for issues assigned to current user in "In Progress" state
- Or use issue from recent context

### 2. **Gather Blocker Details**

Ask user (or infer from context):
- What specifically is blocking progress?
- What's needed to unblock?
- Who needs to help? (PM decision, external dependency, etc.)
- How severe? (Completely blocked vs partially blocked)

### 3. **Document in Linear**

Add blocker comment:

```typescript
addComment(issueId, {
  body: '**Blocked** — [What is blocking]. Need: [what is needed to unblock].'
})
```

For complex blockers, can expand:
```markdown
**Blocked** — [Brief description of blocker].

Needed to unblock:
- [What's needed 1]
- [What's needed 2]

@[person] for help.
```

### 3b. **Notify Relevant People (Optional)**

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

### 4. **Update Issue State (Optional)**

Depending on blocker type:

**If needs PM decision:**
```typescript
// Keep in progress but flag
addLabel(issueId, "blocked")
```

**If completely stuck:**
```typescript
updateIssue(issueId, {
  stateId: config.linear.states.REVIEW  // Send back for help
})
```

### 5. **Confirmation**

```markdown
🚫 Blocker documented on LIN-XXX

**Issue:** [Title]
**Blocker:** [Brief description]
**Status:** Flagged for help

I've tagged the relevant people in Linear. 

**What you can do:**
1. Work on a different issue: `/status`
2. Wait for help on this blocker
3. Try a different approach: [suggestion if applicable]
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

**Run this command when detected.**

---

## Outputs
- Blocker documented in Linear comment
- Issue flagged/labeled appropriately
- Relevant people tagged
- User informed of options

---

## Checklist
- [ ] Identified current issue
- [ ] Gathered blocker details
- [ ] Added detailed blocker comment to Linear
- [ ] Tagged relevant people
- [ ] Added blocked label (if applicable)
- [ ] Updated state (if applicable)
- [ ] Provided next step options

