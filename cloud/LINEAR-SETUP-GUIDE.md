# Linear Setup Guide for DocFlow

> Reference guide for structuring Linear to work with DocFlow Cloud

---

## Organization Structure

```
Stride (Organization)
│
├── Client Teams (weekly sprints)
│   ├── Team: Client A
│   ├── Team: Client B
│   └── Team: Client C
│
└── Internal Team
    └── Team: strideUX (weekly focus + kanban)
        ├── Project: DocFlow
        ├── Project: StrideOS
        ├── Project: Finance Dashboard
        ├── Project: Cook
        └── Project: Portfolio
```

---

## Team: strideUX

### Workflow States

| State | Type | DocFlow Status | Description |
|-------|------|----------------|-------------|
| Backlog | Backlog | BACKLOG | Ideas, future work, not prioritized |
| Todo | Unstarted | READY | Ready to work on, prioritized |
| In Progress | Started | IMPLEMENTING | Currently being built |
| In Review | Started | REVIEW | Code review / PR open |
| QA | Started | TESTING | Testing and validation |
| Done | Completed | COMPLETE | Verified and shipped |
| Canceled | Canceled | - | Won't do |

### Labels (Type)

| Label | Color | Description |
|-------|-------|-------------|
| `feature` | Green | New functionality |
| `bug` | Red | Fix for broken behavior |
| `chore` | Gray | Maintenance, refactoring, ops |
| `idea` | Purple | Future consideration, exploration |

### Labels (Platform) - For StrideOS

| Label | Color | Description |
|-------|-------|-------------|
| `web` | Blue | Web application |
| `mobile` | Cyan | Mobile app (iOS/Android) |
| `stride-app` | Indigo | Stride desktop/web app |
| `all-apps` | Violet | Cross-platform work |

### Cycles

- **Weekly cycles** for prioritization focus
- Issues assigned to current cycle = "this week's work"
- Unfinished items roll over or return to backlog
- Review each week: what goes into next cycle?

---

## Projects (Products)

### DocFlow
```
Project: DocFlow
├── Linear integration features
├── Multi-PM provider support
├── Documentation and guides
└── Testing and validation
```

### StrideOS
```
Project: StrideOS
├── Web app features [web]
├── Mobile app features [mobile]
├── Stride app features [stride-app]
└── Cross-platform [all-apps]
```

### Others
- **Finance Dashboard** - Internal financial tools
- **Cook** - App builder platform
- **Portfolio** - Mobile showcase apps

---

## Issue Structure

Each issue maps to a DocFlow spec:

```
Issue: "Add user authentication"
├── Title: Clear, actionable name
├── Description: Full spec content
│   ├── User Story
│   ├── Acceptance Criteria
│   ├── Technical Notes
│   └── Dependencies
├── Labels: [feature] + platform labels
├── Priority: Urgent/High/Medium/Low/None
├── Estimate: Points (XS=1, S=2, M=3, L=5, XL=8)
├── Project: DocFlow (or other product)
├── Cycle: Week 49 (optional)
├── Assignee: Developer or @Cursor
└── Comments: Decision log, implementation notes
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

## Scaling Path

### Stage 1: Starting Out
```
Team: strideUX
└── Project: DocFlow (all issues here)
```

### Stage 2: Product Growing
```
Team: strideUX
└── Project: DocFlow
    └── Initiative: "v3 Cloud Launch" (groups work)
```

### Stage 3: Product Spins Off
```
Team: DocFlow (own team)
├── Project: Core Platform
├── Project: Linear Provider
└── Own workflow, cycles, team members
```

---

## Config Reference

### .docflow.json

```json
{
  "docflow": {
    "version": "3.0.0",
    "sourceRepo": "github.com/strideUX/docflow-template"
  },
  "provider": {
    "type": "linear",
    "linear": {
      "teamId": "your-team-id",
      "defaultProjectId": "your-project-id",
      "labels": {
        "feature": "feature-label-id",
        "bug": "bug-label-id",
        "chore": "chore-label-id",
        "idea": "idea-label-id"
      }
    }
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

**State IDs:** Settings → Teams → Workflow → Use API to query

---

## Quick Reference

| Concept | Linear Feature |
|---------|----------------|
| Codebase scope | Team |
| Product/Epic | Project |
| Spec/Task | Issue |
| Spec type | Label (feature/bug/chore/idea) |
| Status | Workflow State |
| Priority | Priority field |
| Complexity | Estimate (points) |
| Weekly focus | Cycle |
| Large initiative | Initiative |
| Spec content | Issue description |
| Decision log | Issue comments |
| Implementation notes | Issue comments |

---

## Workflow Summary

```
Weekly Review (PM Agent)
    │
    ▼
Backlog → Todo (prioritized for cycle)
    │
    ▼
Todo → In Progress (developer picks up)
    │
    ▼
In Progress → In Review (PR opened)
    │
    ▼
In Review → QA (code merged, testing)
    │
    ▼
QA → Done (verified, shipped)
```

---

*This guide is for the Stride organization using DocFlow Cloud with Linear.*

