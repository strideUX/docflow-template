# Implementation Agent Rules

> Load when building features, fixing bugs, or implementing specs.  
> **Also load**: `always.md` for comment templates and verification gates.

---

## Role Overview

The Implementation Agent builds:
- Picks up assigned work from Linear
- Implements code + tests + documentation
- Tracks progress via Linear checkboxes and comments
- Handles blockers appropriately
- Hands off to Review when complete

---

## /implement - Start or Continue Implementation

### Execution Checklist

```
□ 1. QUERY Linear for available issues
     States: "Todo", "In Progress", "Blocked"
     Filter: Assigned to me or unassigned

□ 2. IF multiple issues → Ask user which to work on

□ 3. IF issue assigned to someone else
     → WARN: "This is assigned to @[name]. Continue anyway?"
     → Wait for confirmation

□ 4. READ full issue
     - Description
     - All comments
     - Attachments (check for Figma links)

□ 5. CHECK AI Effort Estimate
     Search for "## AI Effort Estimate" section
     
     IF MISSING:
       → Say: "⚠️ Missing AI Effort Estimate. No baseline for tracking."
       → Ask: "Calculate estimate before starting?"
       → If yes: Calculate using skill, update description
       → If no: Proceed with warning
     
     IF PRESENT:
       → Note: "Tracking against estimate of ~[X]k tokens"

□ 6. LOAD context files
     - {paths.content}/context/stack.md
     - {paths.content}/context/standards.md
     - If Figma attached: Call Figma MCP

□ 7. SHOW implementation checklist with estimate:
     
     📋 **Implementation Checklist**
     
     **Issue:** [ISSUE-ID] - [Title]
     **AI Effort Estimate:** ~[X]k tokens ($[X]-$[X])
     
     **Acceptance Criteria:**
     - [ ] [Criterion 1]
     - [ ] [Criterion 2]
     ...
     
     **Remember:**
     - Write tests alongside code
     - Update checkboxes in description as you complete criteria
     - Document decisions in comments
     
     Ready to start!

□ 8. IF issue not already In Progress
     Run: .docflow/scripts/transition-issue.sh [ISSUE-ID] "In Progress" \
       "**Implementation Started** — Picking up work."
```

---

## During Implementation

### Completing Acceptance Criteria (DETERMINISTIC)

For each criterion completed:

```
□ 1. READ current description
     get_issue({ id: "..." })

□ 2. FIND the checkbox
     "- [ ] Criterion text"

□ 3. CHANGE to checked
     "- [x] Criterion text"

□ 4. SAVE entire updated description
     update_issue({ id: "...", description: "..." })

□ 5. OPTIONALLY add progress comment
     "**Progress** — [What was done]. [X]/[Y] criteria complete."
```

**❌ DO NOT:**
- Put checkmarks in comments
- Create new checkboxes in comments
- Leave description unchanged

### Progress Comments

Add when significant progress made:

```
**Progress** — [What was completed]. [X]/[Y] criteria done.
```

### Decisions During Implementation (CREATIVE)

When making technical decisions:

```
□ 1. DOCUMENT in Linear comment:
     **Decision: [Title]**
     
     **Context:** [Why decision was needed]
     **Decision:** [What was decided]
     **Rationale:** [Why this choice]

□ 2. IF significant architectural decision
     → Also add to {paths.content}/knowledge/decisions/
```

---

## /block - Document Blocker

### Execution Checklist

```
□ 1. IDENTIFY blocker
     What is blocking? What is needed?

□ 2. CHECK if blocked by another issue
     If yes: Note the blocking issue ID

□ 3. RUN transition script:
     .docflow/scripts/transition-issue.sh [ISSUE-ID] "Blocked" \
       "**Blocked** — [What is blocking]. Needs: [What is needed]. Blocking since: [date]."

□ 4. IF blocked by another issue
     Create blocking relationship in Linear:
     issueRelationCreate({ issueId: blocking, relatedIssueId: blocked, type: "blocks" })

□ 5. RESPOND to user
     "Marked [ISSUE-ID] as blocked. Will resume when [blocker] resolved."
```

### Unblocking

When blocker is resolved:

```
□ 1. RUN transition script:
     .docflow/scripts/transition-issue.sh [ISSUE-ID] "In Progress" \
       "**Unblocked** — [What resolved the blocker]. Resuming implementation."

□ 2. RESPOND to user
     "Unblocked [ISSUE-ID]. Resuming work."
```

---

## Implementation Complete

### Execution Checklist (DETERMINISTIC)

```
□ 1. VERIFY all acceptance criteria checked
     Read description, confirm all checkboxes are [x]
     IF ANY UNCHECKED:
       → List remaining items
       → Ask: "Complete these before marking done?"
       → Do not proceed until all checked

□ 2. ESTIMATE tokens used
     Rough calculation:
     - Count conversation turns × ~2k tokens/turn
     - Or estimate based on complexity
     Note: This is approximate

□ 3. UPDATE AI Effort Estimate section
     Read current description
     Fill in Actuals section:
     - Actual Tokens: ~[X]k
     - Variance: [+/-X]% from estimate
     - Notes: [What drove the work]
     Save updated description

□ 4. RUN transition script:
     .docflow/scripts/transition-issue.sh [ISSUE-ID] "In Review" \
       "**Ready for Review** —
       
       **Summary:** [What was built/fixed]
       **Files Changed:** [count] files
       **Tests:** [What was tested]
       **Docs:** [Updated/N/A]
       **Criteria:** [X]/[Y] complete
       **AI Effort:** ~[X]k actual (est. [X]k, [+/-X]%)"

□ 5. VERIFY state changed
     Query issue, confirm state = "In Review"

□ 6. RESPOND to user
     "Implementation complete for [ISSUE-ID]. Moved to code review."
```

---

## TODO Comments → Linear Issues

### When Adding TODO in Code (DETERMINISTIC)

```
□ 1. WRITE initial TODO comment
     // TODO: Implement rate limiting

□ 2. CREATE Linear issue immediately
     create_issue({
       title: "Implement rate limiting",
       teamId: "[from config]",
       projectId: "[from config]",
       labelIds: ["[triage-label-id]"],
       description: "From code: `src/api/routes.ts:123`\n\nContext: [why needed]"
     })

□ 3. GET issue identifier from response
     e.g., "PLA-456"

□ 4. UPDATE the code comment
     // TODO: Implement rate limiting (PLA-456)
```

**Format:** `// TODO: [Description] (ISSUE-ID)`

---

## Context to Load

| Situation | Load |
|-----------|------|
| Starting work | Issue, stack.md, standards.md |
| Figma attached | Call Figma MCP for design context |
| Making decisions | Issue, relevant knowledge docs |
| Completing | Issue description (for checkbox update) |

---

## Natural Language Triggers

| Phrase | Command |
|--------|---------|
| "implement [issue]" | /implement |
| "build [issue]" | /implement |
| "let's work on..." | /implement |
| "I'm blocked" | /block |
| "can't proceed" | /block |

---

## Quality Checklist (CREATIVE - apply judgment)

Before marking complete, consider:

- [ ] Code follows patterns in stack.md
- [ ] Naming conventions match standards.md
- [ ] Error handling is appropriate
- [ ] Tests cover key functionality
- [ ] No obvious security issues
- [ ] Performance is reasonable

---

## Documentation During Implementation (CREATIVE)

### When to Document

**Add to knowledge base when:**
- Non-obvious solution discovered → `notes/`
- Architectural decision made → `decisions/`
- Complex pattern established → `features/`

**Update context files when:**
- New technology added → `stack.md`
- New convention established → `standards.md`

### After Adding Documentation

```
□ 1. ADD entry to {paths.content}/knowledge/INDEX.md
```
