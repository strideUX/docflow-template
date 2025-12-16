# Feature Issue Template

> Copy this template when creating a new feature issue in Linear or other PM tools.

---

## Context
<!-- Why does this feature exist? What problem does it solve? -->

[Problem description and business value]

**Current Issues:**
- [Issue or limitation 1]
- [Issue or limitation 2]

---

## User Story

**As a** [specific user role]
**I want to** [specific goal or action]
**So that** [concrete benefit or outcome]

**Example Scenario:**
[Real-world scenario where this feature would be used]

---

## Acceptance Criteria

### Functionality
- [ ] [Specific, measurable criterion 1]
- [ ] [User can perform X action and see Y result]
- [ ] [System behaves correctly when Z happens]
- [ ] [Error handling: System shows helpful message when...]

### Tests
- [ ] Tests written for core functionality
- [ ] Edge cases and error scenarios covered
- [ ] All tests passing

### Documentation
- [ ] Code documented (comments on complex logic)
- [ ] Knowledge base updated (if significant decisions/patterns)
- [ ] Context files updated (if architecture changes)
- [ ] N/A - No significant documentation needed

---

## Technical Notes

### Implementation Approach
[High-level description of how this will be built]

**Key Technical Decisions:**
1. [Decision 1 and rationale]
2. [Decision 2 and rationale]

### Components Needed
**New:**
- `ComponentName` - [What it does]

**Modify:**
- `ExistingComponent` - [What changes needed]

### Data Model
```typescript
// Schema changes if any
// OR: No data model changes required
```

### API Endpoints
- `POST /api/endpoint` - [Description]
- OR: No new endpoints required

---

## Dependencies

**Required Before Starting:**
- [Feature or system that must exist first]
- OR: No dependencies - can start immediately

**Enables Future Work:**
- [Feature that depends on this being complete]

---

## Design Reference
<!-- Add Figma links as attachments -->

---

## Workflow Notes

**Status Flow:**
```
Backlog → Todo → In Progress → In Review → QA → Done
```

**Comments should track:**
- Decision log entries (dated)
- Implementation progress
- Documentation updates (with links)
- Review findings
- QA results

**Comment Format:**
```
**[Status]** — Brief description.
```

Examples:
- `**Activated** — Assigned to [name], Priority: High.`
- `**Progress** — Completed data model, starting on UI.`
- `**Documentation Updated** — Added ADR for auth strategy.`
- `**Ready for Review** — All criteria met, PR open.`
