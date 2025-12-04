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

**Priority 3 - In Progress (active work):**
```
Query: status = "In Progress" (or mapped IMPLEMENTING state)
Filter: assigned to current user
Show: Work currently being implemented
```

**Priority 4 - Ready/Todo (ready to start):**
```
Query: status = "Todo" (or mapped READY state)
Show: Issues ready for implementation
```

**Priority 5 - Backlog (prioritized):**
```
Query: status = "Backlog" (or mapped BACKLOG state)
Limit: Top 5 by priority
Show: What's coming up
```

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

### 🔨 In Progress (@you)
- LIN-789: [Title] - Currently implementing

### ✅ Ready to Start
- LIN-101: [Title] - Priority: High
- LIN-102: [Title] - Priority: Medium

### 📥 Backlog (Top 5)
1. LIN-201: [Title] - High
2. LIN-202: [Title] - Medium
...

**What would you like to do?**
1. Continue work on LIN-789
2. Test LIN-123 (QA)
3. Review LIN-456
4. Start something new
5. Capture new work
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
- [ ] Queried Linear for In Progress issues
- [ ] Queried Linear for Ready issues
- [ ] Queried Linear for top Backlog items
- [ ] Got current developer username
- [ ] Presented status dashboard
- [ ] Loaded project context
- [ ] Waiting for user direction

