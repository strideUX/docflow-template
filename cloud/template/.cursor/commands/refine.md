# Refine (PM/Planning Agent)

## Overview
Context-aware refinement command that handles two paths:

1. **Triage Path** - Raw captures with `triage` label or missing structure → Classify type + apply template
2. **Refinement Path** - Templated issues → Refine details, prepare for implementation

**Agent Role:** PM/Planning Agent (orchestrator)  
**Frequency:** When preparing backlog items for implementation

---

## Steps

### 1. **Find Issue and Determine Path**

**If user specified issue (LIN-XXX):**
- Query that specific issue from Linear

**If not specified:**
- Query Linear for backlog issues
- Prioritize: `triage` label first, then others
- Show list and ask which to refine

**Determine path:**
```
If has `triage` label OR missing core template structure:
  → TRIAGE PATH (classify + template)

If has template structure (user story, acceptance criteria, etc.):
  → REFINEMENT PATH (detail + prepare)
```

**How to detect missing structure:**
- No "## Context" or "## User Story" section
- No "## Acceptance Criteria" section
- Very short description (< 100 chars)
- Looks like quick capture format

---

## TRIAGE PATH (Raw → Templated)

### 2a. **Analyze Raw Content**

Read the issue and extract:
- What is this about? (core idea)
- What type does this seem like?
- Any context clues (urgency, who reported, etc.)

### 3a. **Suggest Classification**

```markdown
## 🏷️ Triage: LIN-XXX

**Raw Content:**
> [First 200 chars of description...]

**My Assessment:**

This looks like a **[feature/bug/chore/idea]** because:
- [Reason 1]
- [Reason 2]

**Suggested Type:** `feature` | `bug` | `chore` | `idea`

Is this classification correct? (yes / change to [type])
```

### 4a. **Apply Template Structure**

Once type is confirmed:

1. **Read the appropriate template from `.docflow/templates/`** (feature.md, bug.md, chore.md, idea.md)
   - Follow agent instructions in the template comments
   - Remove agent instruction comments from final issue
2. **Extract content from raw capture:**
   - "What" → Context / Problem description
   - "Why" → User story / Value
   - "Context" → Additional notes
   - "Notes" → Technical notes / references

3. **Generate templated description:**
   - Fill in what we know
   - Leave placeholders for what we don't
   - Keep original content accessible

**Example transformation:**

```markdown
# Before (Quick Capture)
## What
Users can't reset their password

## Why  
Getting support tickets about this

## Notes
Happens on mobile mostly

# After (Bug Template Applied)
## Context
**When Discovered:** [From ticket]
**Impact:** Users unable to access accounts
**Frequency:** Reported on mobile devices

## Bug Description
### Expected Behavior
Users should be able to reset their password from the login screen.

### Actual Behavior
[Need to investigate - appears to fail on mobile]

### Steps to Reproduce
1. [Need to confirm steps]

## Acceptance Criteria
### Fix Verification
- [ ] Password reset works on mobile
- [ ] Password reset works on desktop
- [ ] User receives reset email

### Tests
- [ ] Regression test added
- [ ] N/A

### Documentation  
- [ ] N/A

## Technical Notes
### Root Cause Analysis
[To be investigated]

---
_Original capture: Users can't reset password, mostly on mobile, causing support tickets._
```

### 5a. **Update Linear Issue**

```typescript
updateIssue(issueId, {
  description: templatedDescription,
  labelIds: [typeLabelId]  // Add feature/bug/chore/idea label
})

// Remove triage label
removeLabel(issueId, triageLabelId)

addComment(issueId, {
  body: '**Triaged** — Classified as [type], template applied. Ready for refinement.'
})
```

### 6a. **Offer Continued Refinement**

```markdown
✅ Triage complete!

**Issue:** LIN-XXX
**Type:** [feature/bug/chore/idea]
**Template:** Applied

The issue now has structure. Would you like to:
1. **Refine now** - Fill in more details
2. **Save for later** - Leave in backlog for future refinement

(Say "refine" to continue, or "done" to save for later)
```

If user says "refine" → Continue to Refinement Path

---

## REFINEMENT PATH (Templated → Ready)

### 2b. **Load Full Issue Context**

From Linear MCP:
- Full description
- All comments
- Attachments (Figma, etc.)
- Current labels and priority

Also load:
- `docflow/context/overview.md` (ensure alignment)
- `docflow/knowledge/INDEX.md` (check for related decisions)

### 3b. **Assess Completeness**

Check issue has:

**Required:**
- [ ] Clear, specific title
- [ ] Context explaining "why"
- [ ] User story (for features) or problem description (for bugs)
- [ ] Acceptance criteria (testable)
- [ ] Type label (feature/bug/chore/idea)
- [ ] Priority set

**For Implementation:**
- [ ] Technical notes/approach
- [ ] Complexity estimate
- [ ] Design references (if UI work)
- [ ] Dependencies noted

### 4b. **Present Assessment**

```markdown
## 📋 Refine: LIN-XXX

**Title:** [Current title]
**Type:** [feature/bug/chore/idea]
**Priority:** [priority or "not set"]

### Completeness Check:
✅ Has context
✅ Has user story
⚠️ Acceptance criteria need detail
❌ Missing technical approach
❌ No complexity estimate

### Current Acceptance Criteria:
- [ ] [Criterion 1] ← Could be more specific
- [ ] [Criterion 2]

### Suggested Improvements:
1. Add measurable criteria for [X]
2. Clarify edge cases for [Y]
3. Add technical approach notes
4. Set complexity estimate

Would you like me to:
1. **Refine all** - I'll improve everything
2. **Refine specific** - Tell me what to focus on
3. **Mark ready** - It's good enough, activate it
```

### 5b. **Refine Based on Discussion**

Update Linear issue with improvements:

```typescript
updateIssue(issueId, {
  description: updatedDescription,
  priority: updatedPriority,  // 1-4 if changed
  estimate: estimateValue     // 1-5 if set
})

addComment(issueId, {
  body: '**Refined** — [What was improved]. Ready for activation.'
})
```

### 6b. **Refinement Confirmation**

```markdown
✅ Refinement complete!

**Issue:** LIN-XXX
**Status:** Ready for activation

**Updated:**
- Acceptance criteria clarified
- Technical approach added
- Complexity: M
- Priority: High

Ready to `/activate LIN-XXX` when you want to start.
```

---

## Bulk Operations

### Triage Queue
```
User: "what needs triage"

Agent: Found 3 items with `triage` label:

| Issue | Title | Created |
|-------|-------|---------|
| LIN-101 | Password reset broken | 2 days ago |
| LIN-102 | Add dark mode | 1 day ago |
| LIN-103 | Slow page load | Today |

Would you like to triage them? (all / pick one)
```

### Refinement Queue
```
User: "what needs refinement"

Agent: Found 4 items in backlog needing refinement:

**Missing details:**
- LIN-104: [Title] ⚠️ No acceptance criteria
- LIN-105: [Title] ⚠️ No technical approach

**Ready for activation:**
- LIN-106: [Title] ✅ Complete
- LIN-107: [Title] ✅ Complete

Would you like to refine the incomplete ones?
```

---

## Context to Load

**First, read `.docflow/config.json` to get `paths.content`.**

**For Triage:**
- Linear issue (raw content)
- `.docflow/templates/{type}.md` (to apply structure)

**For Refinement:**
- Linear issue (full details)
- `{paths.content}/context/overview.md`
- `{paths.content}/knowledge/INDEX.md`
- Related features/decisions if relevant

---

## Natural Language Triggers

**Triage:**
- "triage [issue]" / "classify [issue]"
- "what is this" / "what type is this"
- "process the triage queue"

**Refinement:**
- "refine [issue]" / "improve [issue]"
- "prepare [issue]" / "detail [issue]"
- "get [issue] ready"

**Combined:**
- "refine [issue]" → Auto-detects which path
- "clean up backlog" → Shows both queues

---

## Outputs

**Triage Path:**
- Issue classified (type label added)
- Template structure applied
- `triage` label removed
- Ready for refinement (or already refined)

**Refinement Path:**
- Issue details improved
- Acceptance criteria clarified
- Technical approach added
- Ready for activation

---

## Checklist

**Triage Path:**
- [ ] Found issue to triage
- [ ] Analyzed raw content
- [ ] Suggested classification (type)
- [ ] Got user confirmation on type
- [ ] Applied appropriate template
- [ ] Preserved original content
- [ ] Removed `triage` label
- [ ] Added type label
- [ ] Added triage comment
- [ ] Offered continued refinement

**Refinement Path:**
- [ ] Found issue to refine
- [ ] Loaded full issue context
- [ ] Assessed completeness
- [ ] Presented assessment to user
- [ ] Made agreed improvements
- [ ] Updated Linear issue
- [ ] Added refinement comment
- [ ] Confirmed ready status

