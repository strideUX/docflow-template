# Linear Setup Guide for DocFlow

> Complete guide for structuring Linear to work with DocFlow Cloud

---

## Overview

This guide covers:
1. [Labels](#labels) - Type and workflow labels
2. [Workflow States](#workflow-states) - Status progression
3. [Issue Templates](#issue-templates) - Structured issue formats
4. [Project Setup](#project-setup) - Project description format
5. [Configuration](#configuration) - .docflow.json setup

---

## Labels

### Type Labels (Required)

| Label | Color | Description |
|-------|-------|-------------|
| `triage` | Orange | Raw captures needing classification |
| `feature` | Green | New functionality |
| `bug` | Red | Fix for broken behavior |
| `chore` | Gray | Maintenance, refactoring, cleanup |
| `idea` | Purple | Future consideration, exploration |

**Triage label** is used for quick captures that need to be classified and templated via `/refine`.

### Platform Labels (Optional)

For multi-platform projects:

| Label | Color | Description |
|-------|-------|-------------|
| `web` | Blue | Web application |
| `mobile` | Cyan | Mobile app (iOS/Android) |
| `all-platforms` | Violet | Cross-platform work |

---

## Workflow States

Configure your team's workflow states to match DocFlow:

| State | Type | DocFlow Status | Description |
|-------|------|----------------|-------------|
| Backlog | Backlog | BACKLOG | Ideas, raw captures, needs refinement |
| Todo | Unstarted | READY | Refined, prioritized, ready to implement |
| In Progress | Started | IMPLEMENTING | Code + tests + docs being written |
| Blocked | Started | BLOCKED | Waiting on feedback, dependency, or decision |
| In Review | Started | REVIEW | Implementation complete, code review |
| QA | Started | TESTING | Code review passed, manual testing |
| Done | Completed | COMPLETE | Verified and shipped |
| Archived | Completed | ARCHIVED | Deferred to future (not canceled, may revisit) |
| Canceled | Canceled | CANCELED | Decision made not to pursue |
| Duplicate | Canceled | DUPLICATE | Already exists elsewhere |

---

## Issue Templates

### Default Template: Quick Capture

Set this as the default template in Linear for fast idea/bug capture:

```markdown
## What

[One sentence - what is this about?]

## Why

[Why does this matter? What's the problem or opportunity?]

## Context

[Any additional details that would help understand this]

## Notes

[Links, screenshots, related issues]

---
_Add `triage` label. Will be classified via /refine._
```

**After creating:** Add the `triage` label so it gets picked up for refinement.

---

### Feature Template

```markdown
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

### Components Needed
- `ComponentName` - [What it does]

### Files to Create/Modify
- `path/to/file.tsx` - [What changes]

---

## Design Reference
<!-- Add Figma links as attachments -->

---

## Dependencies

**Required Before Starting:**
- [Feature or system that must exist first]
- OR: No dependencies

---

<!-- Decision log and implementation notes tracked via comments -->
```

---

### Bug Template

```markdown
## Context

**When Discovered:** [Date]
**Impact:** [How this affects users]
**Frequency:** [Always | Sometimes | Specific conditions]

---

## Bug Description

### Expected Behavior
[What SHOULD happen]

### Actual Behavior
[What ACTUALLY happens]

### Steps to Reproduce
1. [Step 1]
2. [Step 2]
3. [Observe bug]

### Environment
- **Browser/Platform:** [Chrome, Safari, etc.]
- **User Role:** [Which user type]

---

## Acceptance Criteria

### Fix Verification
- [ ] Bug no longer reproducible
- [ ] Expected behavior works correctly
- [ ] No regressions introduced

### Tests
- [ ] Regression test added
- [ ] Edge cases tested
- [ ] All tests passing

### Documentation
- [ ] Root cause documented (if significant)
- [ ] Prevention notes added (if applicable)
- [ ] N/A - No documentation needed

---

## Technical Notes

### Root Cause Analysis
**Hypothesis:** [What's causing it]
**Confirmed Cause:** [After investigation]

### Fix Approach
[How to fix it]

**Files to Modify:**
- `path/to/file.tsx` - [What changes]

---

<!-- Investigation and fix progress tracked via comments -->
```

---

### Chore Template

```markdown
## Context

**Why This Matters:**
[Value - cleaner code, better UX, faster performance, etc.]

**Scope:**
[What areas/features does this touch?]

**Type:** Ongoing | One-time

---

## Task List

### Initial Tasks
- [ ] [Task 1]
- [ ] [Task 2]
- [ ] [Task 3]

### Added During Work
<!-- Add new tasks discovered while working -->

---

## Acceptance Criteria

### Completion
- [ ] All tasks completed
- [ ] No regressions introduced

### Tests
- [ ] Tests updated if behavior changed
- [ ] N/A - No behavior changes

### Documentation
- [ ] Patterns documented (if new approach)
- [ ] N/A - No documentation needed

---

## Technical Notes

### Approach
[How you'll tackle this]

### Files to Touch
- `path/to/file.tsx` - [What changes]

---

<!-- Progress tracked via comments -->
```

---

### Idea Template

```markdown
## Sketch

**What:** [One sentence - what is this?]
**Why:** [Why might this be valuable?]
**How:** [Rough idea of how it might work]

**Details:**
[Additional thoughts, context, inspiration]

---

## Potential Value

**For Users:**
- [Benefit 1]

**Estimated Impact:** 🔥 High | 📊 Medium | 💡 Low | ❓ Unknown

---

## Questions to Answer

- [ ] What needs research?
- [ ] What's the technical feasibility?
- [ ] What's the rough effort?

---

## Rough Complexity

**Complexity:** XS | S | M | L | XL | ❓ Unknown

---

## Next Steps

**To Validate:**
1. [Research step]
2. [User validation]

**To Turn Into Feature:**
1. [ ] Answer questions above
2. [ ] Define acceptance criteria
3. [ ] Create feature issue

---

## Status

- [ ] Captured
- [ ] Researched
- [ ] Validated
- [ ] Refined → Feature issue
- [ ] Declined

---

<!-- Discussion tracked via comments -->
```

---

## Project Setup

### Project Description Format

When you run `/sync-project`, it generates this format from your local context files:

**Short Description (255 char max):**
```
[Vision statement from overview.md]
```

**Full Content:**
```markdown
## [Project Name]

**Vision:** [1-2 sentence vision]

**Phase:** [Planning | Development | Beta | Production]

---

### Goals
1. [Goal 1]
2. [Goal 2]
3. [Goal 3]

---

### Tech Stack
- **Frontend:** [Framework, Language]
- **Backend:** [Runtime, Database]
- **Hosting:** [Platform]

---

### Key Standards
- [Convention 1]
- [Convention 2]
- [Convention 3]

---

### Links
- **Repository:** [GitHub URL]
- [Figma Designs](URL) - UI mockups
- [Documentation](URL) - External docs

---

📁 *Full details in `docflow/context/`*
🔄 *Last synced: [YYYY-MM-DD]*
```

---

## Issue Structure Summary

Each issue maps to a DocFlow spec:

```
Issue: "Add user authentication"
├── Title: Clear, actionable name
├── Description: Full spec content
│   ├── Context (why)
│   ├── User Story / Bug Description
│   ├── Acceptance Criteria
│   │   ├── Functionality
│   │   ├── Tests
│   │   └── Documentation
│   └── Technical Notes
├── Labels: [triage] or [feature/bug/chore/idea] + platform
├── Priority: Urgent/High/Medium/Low/None
├── Estimate: Points (XS=1, S=2, M=3, L=5, XL=8)
├── Project: [Your project]
├── Cycle: [Optional - weekly sprint]
├── Assignee: Developer
├── Attachments: Figma links, screenshots
└── Comments: Decision log, implementation notes, reviews
```

---

## Priority Mapping

| DocFlow | Linear | When to Use |
|---------|--------|-------------|
| P0 | Urgent | Critical, drop everything |
| P1 | High | Important, this cycle |
| P2 | Medium | Normal priority |
| P3 | Low | Nice to have |
| - | None | Backlog items |

---

## Estimate Mapping (Complexity)

| DocFlow | Points | Description |
|---------|--------|-------------|
| XS | 1 | < 1 hour |
| S | 2 | Few hours |
| M | 3 | Half day to day |
| L | 5 | Multiple days |
| XL | 8 | Week+ or needs breakdown |

---

## Configuration

### .docflow.json

```json
{
  "docflow": {
    "version": "3.0.0",
    "sourceRepo": "github.com/strideUX/docflow-template"
  },
  "provider": {
    "type": "linear",
    "teamId": "your-team-id",
    "projectId": "your-project-id"
  },
  "statusMapping": {
    "BACKLOG": "Backlog",
    "READY": "Todo",
    "IMPLEMENTING": "In Progress",
    "REVIEW": "In Review",
    "TESTING": "QA",
    "COMPLETE": "Done"
  }
}
```

### Getting IDs from Linear

**Team ID:** Settings → Teams → [Team] → Copy ID from URL or API

**Project ID:** Project page → Copy ID from URL (`/project/[ID]`)

**Label IDs:** Settings → Labels → Use Linear API or MCP to query

---

## Workflow Summary

```
┌─────────────────────────────────────────────────────────────────────┐
│                         INTAKE/TRIAGE                                │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  Quick Capture ──► `triage` label ──► Backlog                       │
│       │                                   │                          │
│       │                                   │ /refine                  │
│       │                                   │ (classify + template)    │
│       │                                   ▼                          │
│  /capture ──────────────────────────► Backlog (typed)               │
│  (from IDE)                               │                          │
│                                           │ /refine                  │
│                                           │ (detail + prepare)       │
│                                           ▼                          │
│                                        Todo                          │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ /activate
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                        IMPLEMENTATION                                │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  Todo ──► In Progress ──► In Review ──► QA ──► Done                │
│              │                │           │                          │
│         /implement        /review    /validate                       │
│         (code +          (code       (manual                         │
│          tests +          review)     testing)                       │
│          docs)                                                       │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Comment Format

Use consistent comment format for audit trail:

```markdown
**[Status]** — Brief description of action taken.
```

**Examples:**
- `**Triaged** — Classified as bug, template applied.`
- `**Refined** — Clarified acceptance criteria, added technical approach.`
- `**Activated** — Assigned to Matt, Priority: High, Estimate: M.`
- `**Progress** — Completed data model, starting on hooks.`
- `**Documentation Updated** — Added ADR for auth strategy.`
- `**Ready for Review** — All criteria complete, 5 files changed.`
- `**Code Review Passed** ✅ — All criteria verified, tests adequate.`
- `**QA Passed** ✅ — Manual testing complete.`
- `**Complete** — Verified and shipped.`

---

## Quick Reference

| Concept | Linear Feature |
|---------|----------------|
| Codebase scope | Team |
| Product/Epic | Project |
| Spec/Task | Issue |
| Raw capture | Issue + `triage` label |
| Spec type | Label (feature/bug/chore/idea) |
| Status | Workflow State |
| Priority | Priority field |
| Complexity | Estimate (points) |
| Weekly focus | Cycle |
| Large initiative | Initiative |
| Spec content | Issue description |
| Decision log | Issue comments |
| Implementation notes | Issue comments |
| Code review | Issue comments |
| QA results | Issue comments |

---

## Templates Location

All templates are available in the DocFlow repo:

```
cloud/templates/
├── issues/
│   ├── quick-capture.md   ← Default for Linear
│   ├── feature.md
│   ├── bug.md
│   ├── chore.md
│   └── idea.md
└── projects/
    └── project.md
```

Copy these into Linear's issue templates feature.

---

*This guide is for DocFlow Cloud v3.0.0 with Linear integration.*
