# Status (All Agents)

## Overview
Quick check of current work state from Linear.

**Agent Role:** Any agent  
**Frequency:** Anytime user wants to know current state

---

## Steps

### 1. **Query Linear**

Get counts and details for each state:

```typescript
// Query by state
const qa = await linearClient.issues({ 
  filter: { state: { name: { eq: "QA" } } }
});
const review = await linearClient.issues({ 
  filter: { state: { name: { eq: "In Review" } } }
});
const blocked = await linearClient.issues({ 
  filter: { state: { name: { eq: "Blocked" } } }
});
const inProgress = await linearClient.issues({ 
  filter: { state: { name: { eq: "In Progress" } } }
});
const todo = await linearClient.issues({ 
  filter: { state: { name: { eq: "Todo" } } }
});
const backlog = await linearClient.issues({ 
  filter: { state: { name: { eq: "Backlog" } } }
});
```

### 2. **Get Current User's Work**

```bash
username=$(git config github.user || git config user.name)
```

Filter for issues assigned to current user.

### 3. **Present Status Dashboard**

```markdown
## 📊 DocFlow Status

### 🔥 Needs Attention
| State | Count | Your Items |
|-------|-------|------------|
| 🧪 QA Testing | X | LIN-123 |
| 👀 In Review | X | - |

### 🚫 Blocked
| Issue | Title | Blocker |
|-------|-------|---------|
| LIN-234 | [Title] | [Brief blocker] |

### 📈 In Progress
| Issue | Title | Assignee |
|-------|-------|----------|
| LIN-456 | [Title] | @you |
| LIN-457 | [Title] | @other |

### ✅ Ready to Start
| Issue | Title | Priority |
|-------|-------|----------|
| LIN-789 | [Title] | High |
| LIN-790 | [Title] | Medium |

### 📥 Backlog
**Total:** X items
**Top priority:** LIN-101 - [Title]

---

### Quick Actions
- `/validate LIN-123` - Test QA item
- `/implement LIN-234` - Resume blocked issue (if unblocked)
- `/implement LIN-789` - Start high priority
- `/capture` - Add new work
```

---

## Compact Mode

For quick check:
```
User: "quick status"

Agent:
📊 **Status:** 1 in QA, 1 blocked, 2 in progress, 3 ready, 12 backlog
🔥 **Action needed:** LIN-123 needs your testing
🚫 **Blocked:** LIN-234 waiting on [blocker]
```

---

## Filtered Status

```
User: "what's assigned to me"

Agent:
## Your Work (@username)

**In Progress:**
- LIN-456: [Title]

**Ready:**
- LIN-789: [Title]

**In QA (needs your testing):**
- LIN-123: [Title]
```

---

## Context to Load
- `.docflow.json` (Linear config)
- Linear queries only
- No local files needed

---

## Natural Language Triggers
User might say:
- "status" / "what's the status"
- "where are we" / "current state"
- "what's in progress"
- "what needs work"

**Run this command when detected.**

---

## Outputs
- Current state from Linear
- Counts by status
- User's assigned items highlighted
- Quick action suggestions

---

## Checklist
- [ ] Queried Linear for all states (including Blocked)
- [ ] Got current username
- [ ] Filtered user's items
- [ ] Presented dashboard with Blocked section
- [ ] Suggested next actions

