# Implement (Implementation Agent)

## Overview
Pick up a Linear issue and build it. Auto-complete when done.

**Agent Role:** Implementation Agent (builder)  
**Frequency:** When starting implementation work

**This receives the handoff from PM Agent.**

---

## Steps

### 1. **Find Available Work**
Query Linear MCP for issues with:
- Status = "Todo" (READY) or "In Progress" (IMPLEMENTING)
- Assigned to current user OR unassigned

**Get current username:**
```bash
git config github.user || git config user.name || "Developer"
```

### 2. **Select Issue**

**If user specified issue (LIN-XXX):**
- Query that specific issue from Linear

**If multiple issues available:**
- Check user's message for context clues
- If clear from context, pick that one
- If ambiguous, ask: "I see multiple issues ready. Which one: [list]?"

**If no issues available:**
- Report: "No issues ready for implementation."
- Show what's assigned to others (if any)
- Suggest checking with PM Agent

### 3. **Load Full Context**
Load everything needed:
- Full issue from Linear (description, comments, attachments)
- `docflow/context/stack.md` (technical patterns)
- `docflow/context/standards.md` (code quality rules)

**Check for Figma attachments:**
If issue has Figma link attached:
```
Call Figma MCP: get_design_context(fileKey, nodeId)
→ Get colors, spacing, component structure
```

### 4. **Update Linear Issue Status**
Use Linear MCP to update:
```typescript
updateIssue(issueId, {
  stateId: config.linear.states.IMPLEMENTING,
  assigneeId: currentUserId  // if not already assigned
})
```

Add start comment:
```typescript
addComment(issueId, {
  body: "### " + date + " - Implementation Started\n\nBeginning work on this issue."
})
```

### 5. **Begin Implementation**
Work through the issue:
- Follow acceptance criteria from description
- Adhere to stack.md patterns
- Follow standards.md conventions
- Use Figma specs if available (colors, spacing, etc.)

### 6. **Update Checkboxes as You Work**

The issue description contains acceptance criteria as checkboxes. **Update them in-place** as each criterion is completed:

```typescript
// Read current description
const issue = await getIssue(issueId);
const currentDescription = issue.description;

// Update checkbox from [ ] to [x]
const updatedDescription = currentDescription.replace(
  '- [ ] Acceptance criterion 1',
  '- [x] Acceptance criterion 1'
);

// Save updated description
updateIssue(issueId, {
  description: updatedDescription
});

// Add progress comment
addComment(issueId, {
  body: '**Progress** — Completed acceptance criterion 1.'
});
```

**Comment format for progress:**
```markdown
**Progress** — Brief description of what was done.
```

**Examples:**
- `**Progress** — Data model and types defined.`
- `**Progress** — useLocalStorage hook implemented, moving to useTodos.`
- `**Blocked** — Need API access from backend team.`

### 7. **Attach Reference Materials (Optional)**

If implementation creates or references knowledge files:

```markdown
Created docflow/knowledge/features/auth-flow.md with implementation details.

Would you like me to attach it to this issue?
- **GitHub link** (stays in sync with repo)
- **Upload copy** (snapshot attached to issue)
```

Run `/attach` to add files to the issue.

### 8. **Auto-Complete When Done**
When ALL acceptance criteria checkboxes are checked:

**Update Linear issue:**
```typescript
// Verify all checkboxes are [x]
updateIssue(issueId, {
  stateId: config.linear.states.REVIEW
})

addComment(issueId, {
  body: '**Ready for Review** — All acceptance criteria complete. Files: X.'
})
```

**Brief summary to user:**
```markdown
✅ Implementation complete!

**Issue:** LIN-XXX
**Status:** In Review
**Files changed:** X

All acceptance criteria met ✓

Run `/validate LIN-XXX` or say "validate" to begin QE testing.
```

**This hands off to QE Agent.**

---

## On Blocker

If you hit a blocker, run `/block` instead:
- Add blocker comment to Linear issue
- Keep in current state or move to review
- Explain what's blocking

---

## Context to Load
- Linear issue (full details + comments)
- `docflow/context/stack.md`
- `docflow/context/standards.md`
- Figma design context (if attached)
- Use codebase_search as needed

---

## Natural Language Triggers
User might say:
- "implement [issue]" / "build [issue]"
- "let's work on LIN-XXX"
- "start implementation"
- "pick up [issue]"

**Run this command when detected.**

---

## Outputs
- Linear issue status → IMPLEMENTING (at start)
- Progress comments added to Linear
- Implementation completed
- Linear issue status → REVIEW (at end)
- Brief completion summary

---

## Checklist
- [ ] Found available work in Linear
- [ ] Loaded issue + stack.md + standards.md
- [ ] Checked for Figma attachments
- [ ] Verified status is In Progress (or updated it)
- [ ] Added start comment if just beginning
- [ ] Updated description checkboxes as criteria completed
- [ ] Added progress comments to Linear
- [ ] Attached reference materials if created (knowledge docs, notes)
- [ ] All checkboxes marked [x] when done
- [ ] Updated Linear status to In Review when done
- [ ] Added completion comment
- [ ] Provided completion summary

