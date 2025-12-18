# Linear Setup Guide for DocFlow

> Complete guide for structuring Linear to work with DocFlow Cloud

---

## Overview

This guide covers:
1. [Labels](#labels) - Type and workflow labels
2. [Workflow States](#workflow-states) - Status progression
3. [Issue Templates](#issue-templates) - Structured issue formats
4. [Project Setup](#project-setup) - Project description format
5. [Configuration](#configuration) - .docflow/config.json setup

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

Set this as the **only** template in Linear for fast idea/bug capture:

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
_Add `triage` label. Agent will classify and structure via /refine._
```

**After creating:** Add the `triage` label so it gets picked up for refinement.

### Full Templates (Agent-Applied)

Full templates for feature, bug, chore, and idea issues live in `.docflow/templates/` in your project. Agents read these templates and apply them when:

- Creating issues via `/capture`
- Refining issues via `/refine`
- Triaging quick captures with `triage` label

This keeps Linear simple (one template) while giving agents the structure they need.

---

## Project Setup

### Project Description Placeholder

Set this as your Linear project description initially:

```
📁 Run /docflow-setup to sync project details from codebase.
```

The `/docflow-setup` command will populate the project description from your context files.

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

📁 *Full details in `{content-folder}/context/`*
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

### .docflow/config.json

```json
{
  "version": "3.0.0",
  "sourceRepo": "github.com/strideUX/docflow-template",
  "paths": {
    "content": "docflow"
  },
  "provider": {
    "type": "linear",
    "teamId": "your-team-id",
    "projectId": "your-project-id",
    "defaultMilestoneId": null
  },
  "statusMapping": {
    "BACKLOG": "Backlog",
    "READY": "Todo",
    "IMPLEMENTING": "In Progress",
    "BLOCKED": "Blocked",
    "REVIEW": "In Review",
    "TESTING": "QA",
    "COMPLETE": "Done",
    "ARCHIVED": "Archived",
    "CANCELED": "Canceled",
    "DUPLICATE": "Duplicate"
  }
}
```

**`paths.content`** - Name of folder containing context/knowledge (default: "docflow", can be "docs" etc.)

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

Templates are in your project's `.docflow/templates/` folder:

```
.docflow/
├── config.json            # Configuration
├── version                # For upgrades
└── templates/
    ├── quick-capture.md   ← Copy to Linear as default template
    ├── feature.md         ← Agent uses for /capture and /refine
    ├── bug.md
    ├── chore.md
    └── idea.md
```

**Only `quick-capture.md` goes in Linear.** Full templates are applied by agents automatically.

---

*This guide is for DocFlow Cloud v3.0.0 with Linear integration.*
