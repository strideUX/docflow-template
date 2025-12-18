# Activate (PM/Planning Agent)

Ready an issue for implementation by assigning and setting metadata.

**Activates from:** Todo (preferred) or Backlog → In Progress

## Two Modes

### Mode 1: Activate Specific Issue
When user specifies an issue: `/activate PLA-123`

### Mode 2: Smart Recommendation (No Issue Specified)
When user just says `/activate` or "what should I work on next?":

1. **Query Available Issues:**
   - Get issues in Todo or Backlog state
   - Include priority, estimate, and blocking relationships

2. **Filter to Ready Issues:**
   - Exclude issues blocked by incomplete work
   - Exclude issues already assigned to others

3. **Rank by:**
   - Priority (Urgent → High → Medium → Low)
   - Unblocked status
   - Estimate (smaller = quicker wins, optional tiebreaker)

4. **Present Recommendation:**
```markdown
📋 **Ready to work on:**

**Recommended:** PLA-75 - F1: Slack OAuth
- Priority: High
- Estimate: L
- No blockers
- Unblocks: PLA-80, PLA-85

**Also available:**
- PLA-70 - Phase 1: Infrastructure (High, M)
- PLA-98 - AI title generation (Medium, S) ← quick win

**Blocked (can't start yet):**
- PLA-80 - F2: Request Capture (waiting on PLA-75)

Which would you like to activate?
```

---

## Activation Steps (Once Issue Selected)

### ⚠️ ASSIGNMENT IS MANDATORY

**No issue can move to In Progress without an assignee.**

1. **Determine Assignee (REQUIRED):**
   - Query Linear for current user: `get_viewer()` or `list_users()`
   - If can't determine → **ASK explicitly**: "Who should this be assigned to?"
   - Never skip this step

2. **Check Current Assignment:**
   - If unassigned → assign to current user
   - If assigned to current user → proceed
   - If assigned to someone else → **WARN and confirm** before reassigning

3. **Verify Not Blocked** - Warn if blocked by incomplete issues

4. **Set Priority** - 1-4 if not set

5. **Set Estimate** - 1-5 if not set

6. **Assign Issue (REQUIRED):**
   ```typescript
   update_issue({
     issueId: "xxx",
     assigneeId: "user-id"  // MUST be set
   })
   ```

7. **Verify Assignment Succeeded:**
   - Query issue after update
   - Confirm assignee is set
   - If not → retry or error

8. **Move to In Progress** - Update state (only after assignment confirmed)

9. **Add Comment** - `**Activated** — Assigned to [name], Priority: [P], Estimate: [E].`

## Natural Language Triggers

- "activate [issue]" / "start [issue]" / "pick up [issue]"
- "what should I work on?" / "what's next?" / "activate" (no issue = smart recommend)

## Full Rules

See `.docflow/rules/pm-agent.md` and `.docflow/rules/linear-integration.md`
