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

// Check for stale issues (in active state for extended time)
// Active states: In Progress (>7 days), In Review (>3 days), QA (>3 days)
const staleIssues = [...inProgress, ...review, ...qa].filter(issue => {
  const daysSinceUpdate = daysSince(issue.updatedAt);
  if (issue.state.name === 'In Progress') return daysSinceUpdate > 7;
  return daysSinceUpdate > 3;
});

// Check for dependency issues (blocked by incomplete issues)
const withDependencies = await linearClient.issues({
  filter: { blockedBy: { some: { state: { type: { neq: "completed" } } } } }
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

### ⚠️ Stale (needs attention)
| Issue | Title | State | Days | Assignee |
|-------|-------|-------|------|----------|
| LIN-200 | [Title] | In Review | 5 | @sarah |
| LIN-180 | [Title] | In Progress | 10 | @cory |

### 🔗 Has Dependencies
| Issue | Title | Blocked By |
|-------|-------|------------|
| LIN-300 | [Title] | LIN-250 (In Progress) |

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
⚠️ **Stale:** LIN-200 in review for 5 days
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
- `.docflow/config.json` (Linear config)
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
- [ ] Checked for stale issues (extended time in active state)
- [ ] Checked for dependency relationships
- [ ] Got current username
- [ ] Filtered user's items
- [ ] Presented dashboard with Blocked, Stale, Dependencies sections
- [ ] Suggested next actions

