# Implement (Implementation Agent)

## Overview
Pick up a Linear issue and build it. Implementation includes code, tests, and documentation. Auto-complete when done.

**Agent Role:** Implementation Agent (builder)  
**Frequency:** When starting implementation work

**This receives the handoff from PM Agent.**

---

## Implementation Includes

Implementation is not just code. A complete implementation includes:

1. **Code** - The actual feature/fix
2. **Tests** - Unit tests, integration tests as appropriate
3. **Documentation** - Code comments, knowledge base updates (when significant)

Check the issue's acceptance criteria for specific test and documentation requirements.

---

## Steps

### 1. **Find Available Work**
Query Linear MCP for issues with:
- Status = "Todo" (READY), "In Progress" (IMPLEMENTING), or "Blocked" (BLOCKED)
- Assigned to current user OR unassigned

**Note:** Blocked issues can be resumed when the blocker is resolved.

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

### 3. **Check Assignment (Prevent Race Conditions)**

Before starting work, verify assignment:

```typescript
const issue = await getIssue(issueId);

if (issue.assignee && issue.assignee.id !== currentUserId) {
  // Assigned to someone else - warn before taking over
  return promptUser(`⚠️ ${issue.identifier} is assigned to @${issue.assignee.name}.
  
  They may already be working on this.
  
  Options:
  1. Pick a different issue
  2. Take over (reassign to yourself - will notify them)
  3. Check with @${issue.assignee.name} first`);
}

// If unassigned or assigned to current user, proceed
```

**This prevents two developers from accidentally working on the same issue.**

### 4. **Load Full Context**
Load everything needed:
- Full issue from Linear (description, comments, attachments)
- `{paths.content}/context/stack.md` (technical patterns)
- `{paths.content}/context/standards.md` (code quality rules)

**Check for Figma attachments:**
If issue has Figma link attached:
```
Call Figma MCP: get_design_context(fileKey, nodeId)
→ Get colors, spacing, component structure
```

### 5. **Update Linear Issue Status**
Use Linear MCP to update:
```typescript
updateIssue(issueId, {
  stateId: config.linear.states.IMPLEMENTING,
  assigneeId: currentUserId  // if not already assigned
})
```

**If resuming from Blocked state:**
```typescript
addComment(issueId, {
  body: "**Unblocked** — [What resolved the blocker]. Resuming implementation."
})
```

**If starting fresh:**
```typescript
addComment(issueId, {
  body: "### " + date + " - Implementation Started\n\nBeginning work on this issue."
})
```

### 6. **Show Implementation Checklist**

At the start of implementation, remind about requirements:

```markdown
📋 **Implementation Checklist**

As you build, remember to:
- [ ] Write tests alongside code (per acceptance criteria)
- [ ] Document decisions in Linear comments
- [ ] Update knowledge base for significant patterns/decisions
- [ ] Update context files if architecture changes

When complete, I'll move to REVIEW and add a summary.
```

### 7. **Begin Implementation**
Work through the issue:
- Follow acceptance criteria from description
- Adhere to stack.md patterns
- Follow standards.md conventions
- Use Figma specs if available (colors, spacing, etc.)
- **Write tests** as you implement (not after)
- **Document decisions** in Linear comments as you make them

### 8. **Update Checkboxes as You Work**

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

### 9. **Document Significant Decisions/Patterns**

When significant decisions or patterns emerge during implementation:

**Add to Knowledge Base:**
- `{paths.content}/knowledge/decisions/` - Architectural decisions (ADRs)
- `{paths.content}/knowledge/notes/` - Gotchas, learnings, non-obvious solutions
- `{paths.content}/knowledge/features/` - Complex feature explanations

**Update Context Files (if architecture changes):**
- `{paths.content}/context/stack.md` - New technologies, patterns
- `{paths.content}/context/standards.md` - New conventions

**After adding documentation, update the index:**
```bash
# Add new entry to {paths.content}/knowledge/INDEX.md
```

**Add comment to Linear issue with links:**
```markdown
**Documentation Updated** —
- Added: `{paths.content}/knowledge/decisions/adr-auth-strategy.md` - Auth approach decision
- Updated: `{paths.content}/context/stack.md` - Added NextAuth section

[View in repo after merge]
```

**Attach to issue (optional):**
Run `/attach` to link files directly to the issue.

### 10. **Auto-Complete When Done**
When ALL acceptance criteria checkboxes are checked (functionality, tests, docs):

**Verify completion:**
- [ ] All functionality criteria checked
- [ ] Tests criteria checked (or marked N/A)
- [ ] Documentation criteria checked (or marked N/A)

**Update Linear issue:**
```typescript
// Verify all checkboxes are [x] or N/A
updateIssue(issueId, {
  stateId: config.linear.states.REVIEW
})
```

**Add detailed completion comment:**
```markdown
**Ready for Review** —

**Summary:** [Brief description of what was built/fixed]

**Files Changed:** [count] files
- `path/to/main-file.tsx` - [primary change]
- `path/to/component.tsx` - [what was added/changed]
- `path/to/file.test.tsx` - [tests added]

**Tests:**
- [X] unit tests for [component/function]
- [X] integration test for [flow] (if applicable)

**Documentation:**
- [List any docs added/updated, or "N/A - no significant changes"]

**Acceptance Criteria:** [X]/[Y] complete
```

**Brief summary to user:**
```markdown
✅ Implementation complete!

**Issue:** LIN-XXX
**Status:** In Review
**Files changed:** [count]

**Completed:**
- ✓ Functionality criteria
- ✓ Tests written
- ✓ Documentation updated (or N/A)

**Next:** Run `/review LIN-XXX` for code review, or wait for human review.
Then `/validate LIN-XXX` for QE testing.
```

**This hands off to Review (agentic or human), then QE Agent.**

---

## On Blocker

If you hit a blocker, run `/block`:
- Moves issue to "Blocked" state
- Documents what's blocking and what's needed
- Tags relevant people for help

When the blocker is resolved, run `/implement` again to resume.

---

## Context to Load
- Linear issue (full details + comments)
- `{paths.content}/context/stack.md`
- `{paths.content}/context/standards.md`
- Figma design context (if attached)
- Use codebase_search as needed

---

## Natural Language Triggers
User might say:
- "implement [issue]" / "build [issue]"
- "let's work on LIN-XXX"
- "start implementation"
- "pick up [issue]"
- "resume [issue]" / "unblock [issue]"

**Run this command when detected.**

---

## Outputs
- Linear issue status → IMPLEMENTING (at start, or when resuming from BLOCKED)
- Progress comments added to Linear
- Unblock comment if resuming from Blocked state
- Implementation completed
- Linear issue status → REVIEW (at end)
- Brief completion summary

---

## Checklist
- [ ] Found available work in Linear (including Blocked issues)
- [ ] Checked assignment (warn if assigned to someone else)
- [ ] Loaded issue + stack.md + standards.md
- [ ] Checked for Figma attachments
- [ ] Showed implementation checklist reminder
- [ ] Verified status is In Progress (or updated from Todo/Blocked)
- [ ] Added start comment (or unblock comment if resuming from Blocked)
- [ ] Wrote tests alongside code
- [ ] Updated description checkboxes as criteria completed
- [ ] Added progress comments to Linear
- [ ] Documented significant decisions/patterns in knowledge base
- [ ] Updated INDEX.md if new knowledge docs added
- [ ] Added documentation comment with links (if docs updated)
- [ ] All checkboxes marked [x] or N/A when done
- [ ] Updated Linear status to In Review when done
- [ ] Added detailed completion comment (summary, files, tests, docs)
- [ ] Provided completion summary

