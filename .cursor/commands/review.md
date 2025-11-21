# Review (PM/Planning Agent)

## Overview
Refine a backlog item to prepare it for implementation.

**Agent Role:** PM/Planning Agent (orchestrator)  
**Frequency:** Before activating backlog items

---

## Steps

### 1. **Select Item**
**If user specified:**
- Load that spec from /docflow/specs/backlog/

**If not specified:**
- Show items from /docflow/specs/backlog/
- Ask: "Which item would you like to review?"

### 2. **Check Completeness**
Review the spec for:
- [ ] Clear context and problem statement
- [ ] Specific, testable acceptance criteria
- [ ] Technical approach documented (for features/bugs)
- [ ] Dependencies identified
- [ ] Complexity set (S/M/L/XL for features/bugs)
- [ ] Priority level set

### 3. **Ask Clarifying Questions**
Based on what's missing or unclear:

**For Features:**
- "Who specifically is this for?" (persona)
- "What's the exact behavior you want?"
- "What user flows does this touch?"
- "Any constraints or requirements?"
- "What should happen on errors?"

**For Bugs:**
- "Can you provide exact steps to reproduce?"
- "What's the expected behavior?"
- "How often does this happen?"
- "Who's affected?"

**For Chores:**
- "What specific improvements are needed?"
- "What's the scope - which areas?"
- "What does 'done' look like?"
- "Is this one-time or ongoing?"

**For Ideas:**
- "What problem would this solve?"
- "Who would benefit?"
- "What's the rough complexity?"
- "Should this become a feature or stay as idea?"

### 4. **Refine the Spec**
Fill out missing sections:
- Update Context with clarity
- Add/improve Acceptance Criteria (make them specific and testable)
- Document Technical Approach (for features/bugs)
- Add to Decision Log with date
- Set appropriate complexity
- Set priority

### 5. **Search for Related Work**
- Use codebase_search to find existing implementations
- Check /docflow/INDEX.md for related specs
- Check /docflow/knowledge/INDEX.md for relevant decisions/features
- Add findings to Dependencies or Technical Notes

### 6. **Determine Readiness**
Ask: "Is this ready to activate for implementation?"

**If YES:**
- Spec is complete enough to build
- Offer to run `/activate [spec]` now

**If NO:**
- Document what's still needed
- Leave in backlog
- Note in Decision Log what questions remain

### 7. **Update Priority** (if needed)
If priorities changed based on discussion:
- Update /docflow/INDEX.md backlog section
- Reorder if necessary

---

## Context to Load
- Spec from /docflow/specs/backlog/
- /docflow/INDEX.md (to check related work)
- /docflow/knowledge/INDEX.md (to check existing decisions)
- /docflow/context/overview.md (for features - ensure alignment)
- /docflow/knowledge/product/personas.md (for user-facing features)

---

## Natural Language Triggers
User might say:
- "review [item]" / "refine [item]"
- "is [item] ready"
- "prepare [item]"
- "check backlog"

**Run this command when detected.**

---

## Outputs
- Refined spec with complete details
- Clarity on readiness
- Updated backlog priorities
- Decision on whether to activate

---

## Checklist
- [ ] Item selected
- [ ] Completeness assessed
- [ ] Clarifying questions asked
- [ ] Spec refined with details
- [ ] Related work searched
- [ ] Readiness determined
- [ ] Priority updated if needed
- [ ] Decision Log updated
