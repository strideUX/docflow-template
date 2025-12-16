# Start Session (PM/Planning Agent)

## Overview
Begin a work session by checking Linear status and identifying what needs attention.

**Agent Role:** PM/Planning Agent (orchestrator)  
**Frequency:** Start of each work session

---

## Steps

### 1. **Load Configuration**
Read `.docflow.json` to get:
- Linear team ID
- Status mappings
- Any default project filters

### 2. **Query Linear for Current State**
Use Linear MCP to query issues. Check in this order:

**Priority 1 - QA Testing (needs user verification):**
```
Query: status = "QA" (or mapped TESTING state)
Show: Issues waiting for user testing
```

**Priority 2 - In Review (needs code review):**
```
Query: status = "In Review" (or mapped REVIEW state)
Show: Issues needing code review
```

**Priority 3 - Blocked (needs attention):**
```
Query: status = "Blocked" (or mapped BLOCKED state)
Show: Issues waiting for feedback, dependency, or decision
```

**Priority 4 - In Progress (active work):**
```
Query: status = "In Progress" (or mapped IMPLEMENTING state)
Filter: assigned to current user
Show: Work currently being implemented
```

**Priority 5 - Backlog (prioritized, ready to activate):**
```
Query: status = "Backlog" (or mapped BACKLOG state)
Limit: Top 5 by priority
Show: What's coming up
```

**Also check:**
- **Dependencies:** Issues with "blocked by" relationships where blocker is incomplete
- **Stale work:** Issues in active states (In Progress, Review, QA) for extended periods

### 3. **Get Current Developer Info**
```bash
git config github.user || git config user.name || "Developer"
```
Use this to filter "my work" vs "all work"

### 4. **Present Status Dashboard**
```markdown
## 📋 DocFlow Session Start

### 🧪 Needs Your Testing (QA)
- LIN-123: [Title] - Ready for QE validation

### 👀 Needs Review
- LIN-456: [Title] - Implementation complete

### 🚫 Blocked
- LIN-234: [Title] - [Brief blocker description]

### ⚠️ Stale (needs attention)
- LIN-200: [Title] - In Review for 5 days (no activity)
- LIN-180: [Title] - In Progress for 10 days (@sarah)

### 🔗 Has Dependencies
- LIN-300: [Title] - Blocked by LIN-250 (In Progress @cory)

### 🔨 In Progress (@you)
- LIN-789: [Title] - Priority: High, Estimate: M

### 📥 Backlog (Ready to Activate)
| Issue | Title | Priority | Estimate |
|-------|-------|----------|----------|
| LIN-101 | [Title] | High | S |
| LIN-102 | [Title] | Medium | M |
| LIN-103 | [Title] | Low | - |

**What would you like to do?**
1. Continue work on LIN-789
2. Test LIN-123 (QA)
3. Review LIN-456
4. Resume LIN-234 (if unblocked)
5. Start something new
6. Capture new work
```

### 5. **Load Project Context**
Also load:
- `docflow/context/overview.md` (project understanding)
- `docflow/knowledge/INDEX.md` (scan for relevant knowledge)

### 6. **Wait for User Direction**
User picks what to work on, then execute appropriate command:
- "Continue 789" → `/implement LIN-789`
- "Test 123" → `/validate LIN-123`
- "Review 456" → Start code review flow
- "Start 101" → `/activate LIN-101`
- "Capture something" → `/capture`

---

## Context to Load
- `.docflow.json` (configuration)
- `docflow/context/overview.md` (project context)
- Linear queries (via MCP)

---

## Natural Language Triggers
User might say:
- "let's start" / "let's get started"
- "what's next" / "what should I work on"
- "start a session" / "begin work"
- "where are we" / "current status"

**Run this command when detected.**

---

## Outputs
- Linear status dashboard
- Clear options for next action
- Project context loaded
- Ready to execute next command

---

## Checklist
- [ ] Read .docflow.json config
- [ ] Queried Linear for QA issues
- [ ] Queried Linear for Review issues
- [ ] Queried Linear for Blocked issues
- [ ] Queried Linear for In Progress issues
- [ ] Queried Linear for Backlog items (with priority/estimate)
- [ ] Checked for stale issues (>3 days in active state without activity)
- [ ] Checked for dependency relationships (blocked by incomplete issues)
- [ ] Got current developer username
- [ ] Presented status dashboard (including Blocked, Stale, Dependencies)
- [ ] Loaded project context
- [ ] Waiting for user direction

