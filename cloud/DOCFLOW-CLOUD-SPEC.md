# DocFlow Cloud Specification

> **Version**: 3.0.0  
> **Status**: DRAFT  
> **Created**: 2025-12-04  
> **Last Updated**: 2025-12-04

---

## Executive Summary

DocFlow Cloud transforms the spec-driven development workflow from a fully local system to a hybrid architecture where:

- **Workflow state (specs/tasks)** → Lives in Linear (or other PM tools)
- **Understanding layer (context/knowledge)** → Stays local in the codebase
- **System brains (rules/commands)** → Local, synced from central repo

This enables team collaboration, visibility, and native AI agent integration while maintaining fast local context access and avoiding template distribution challenges.

---

## Table of Contents

1. [Vision & Goals](#1-vision--goals)
2. [Architecture Overview](#2-architecture-overview)
3. [What Lives Where](#3-what-lives-where)
4. [Provider Abstraction Layer](#4-provider-abstraction-layer)
5. [Linear Integration (Phase 1)](#5-linear-integration-phase-1)
6. [DocFlow Update System](#6-docflow-update-system)
7. [Asset & Design Integration](#7-asset--design-integration)
8. [Migration Path](#8-migration-path)
9. [Implementation Plan](#9-implementation-plan)
10. [Future Providers](#10-future-providers)

---

## 1. Vision & Goals

### 1.1 The Problem

The current local-only DocFlow system has several challenges:

1. **Template Distribution Hell**: Updating DocFlow means touching every project
2. **No Team Visibility**: Specs only visible to developers with repo access
3. **No Real Collaboration**: Markdown files don't support real-time editing
4. **Manual Sync**: INDEX.md and ACTIVE.md require manual updates
5. **No Native AI Integration**: Can't leverage PM tool → AI agent workflows

### 1.2 The Solution

A hybrid architecture that separates concerns:

| Concern | Location | Rationale |
|---------|----------|-----------|
| **Workflow state** | Cloud (Linear) | Collaboration, visibility, automation |
| **Understanding** | Local (git) | Fast access, version-controlled with code |
| **System rules** | Local (synced) | No external dependency, centrally maintained |

### 1.3 Design Principles

1. **Provider-Agnostic Core**: Rules and commands work with any PM tool
2. **Local-First Reading**: Agent reads context locally (fast, offline-capable)
3. **Cloud-First Workflow**: Tasks/specs managed in PM tool
4. **Central Distribution**: System updates flow from one source
5. **Graceful Degradation**: Works without cloud, falls back to local

---

## 2. Architecture Overview

### 2.1 System Diagram

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         DOCFLOW ECOSYSTEM                                │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  ┌────────────────────────────────────────────────────────────────────┐ │
│  │  DOCFLOW SOURCE REPO (github.com/org/docflow)                      │ │
│  │                                                                     │ │
│  │  The "brains" - centrally maintained:                              │ │
│  │  ├── rules/docflow.mdc          (workflow rules)                   │ │
│  │  ├── commands/*.md              (slash commands)                   │ │
│  │  ├── agents/AGENTS.md           (agent instructions)               │ │
│  │  ├── templates/                 (spec templates)                   │ │
│  │  └── platform/                  (cursor, claude, warp configs)     │ │
│  │                                                                     │ │
│  │  Version tagged releases: v3.0.0, v3.1.0, etc.                     │ │
│  └────────────────────────────────────────────────────────────────────┘ │
│                              │                                           │
│                              │ /docflow-update syncs files               │
│                              ▼                                           │
│  ┌────────────────────────────────────────────────────────────────────┐ │
│  │  PROJECT CODEBASE                                                   │ │
│  │                                                                     │ │
│  │  LOCAL FILES (always present, agent reads directly):               │ │
│  │  ├── .cursor/rules/docflow.mdc    ← synced from source repo        │ │
│  │  ├── .cursor/commands/*.md        ← synced from source repo        │ │
│  │  ├── AGENTS.md                    ← synced from source repo        │ │
│  │  ├── WARP.md                      ← synced from source repo        │ │
│  │  │                                                                  │ │
│  │  ├── docflow/                                                       │ │
│  │  │   ├── context/                 (LOCAL - understanding layer)    │ │
│  │  │   │   ├── overview.md          (project vision, goals)          │ │
│  │  │   │   ├── stack.md             (tech stack, architecture)       │ │
│  │  │   │   └── standards.md         (code conventions)               │ │
│  │  │   │                                                              │ │
│  │  │   ├── knowledge/               (LOCAL - project knowledge)      │ │
│  │  │   │   ├── INDEX.md             (knowledge inventory)            │ │
│  │  │   │   ├── decisions/           (ADRs)                           │ │
│  │  │   │   ├── features/            (feature docs)                   │ │
│  │  │   │   ├── notes/               (learnings, gotchas)             │ │
│  │  │   │   └── product/             (personas, flows)                │ │
│  │  │   │                                                              │ │
│  │  │   └── README.md                (how to use docflow)             │ │
│  │  │                                                                  │ │
│  │  └── .docflow.json                (config: version + provider IDs) │ │
│  │                                                                     │ │
│  │  Agent reads rules locally - no MCP dependency for core!           │ │
│  └────────────────────────────────────────────────────────────────────┘ │
│                              │                                           │
│                              │ Commands call Provider MCP                │
│                              ▼                                           │
│  ┌────────────────────────────────────────────────────────────────────┐ │
│  │  PROVIDER LAYER (Linear MCP / Jira MCP / etc.)                     │ │
│  │                                                                     │ │
│  │  Standard interface:                                                │ │
│  │  ├── createSpec()    updateSpec()    getSpec()    listSpecs()      │ │
│  │  ├── setStatus()     getActiveSpecs()                              │ │
│  │  ├── addComment()    getComments()                                 │ │
│  │  └── addAttachment() getAttachments()                              │ │
│  └────────────────────────────────────────────────────────────────────┘ │
│                              │                                           │
│                              ▼                                           │
│  ┌────────────────────────────────────────────────────────────────────┐ │
│  │  PM TOOL (Linear / Jira / Asana / GitHub)                          │ │
│  │                                                                     │ │
│  │  CLOUD DATA:                                                        │ │
│  │  ├── Initiatives/Projects      (scope containers)                  │ │
│  │  ├── Issues                    (specs - features, bugs, etc.)      │ │
│  │  ├── Workflow States           (BACKLOG → COMPLETE)                │ │
│  │  ├── Labels                    (spec types, priorities)            │ │
│  │  ├── Attachments               (Figma links, screenshots)          │ │
│  │  └── Comments                  (decision log, notes)               │ │
│  │                                                                     │ │
│  │  VIEWS (replace local INDEX.md / ACTIVE.md):                       │ │
│  │  ├── "Backlog" filter                                              │ │
│  │  ├── "In Progress" filter                                          │ │
│  │  └── "Completed" filter                                            │ │
│  └────────────────────────────────────────────────────────────────────┘ │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### 2.2 Data Flow

```
Designer                    PM Tool (Linear)              Agent
   │                             │                          │
   │  Add Figma link ──────────▶│                          │
   │                             │                          │
   │                             │◀── Read issue ───────────│
   │                             │                          │
   │                             │    (sees Figma URL)      │
   │                             │                          │
   │◀─────────────────────────── │ ──── Call Figma MCP ────▶│
   │   (Figma responds with      │                          │
   │    design context)          │                          │
   │                             │                          │
   │                             │◀── Update status ────────│
   │                             │                          │
   │                             │◀── Add comment ──────────│
   │                             │    (implementation notes) │
```

---

## 3. What Lives Where

### 3.1 LOCAL (Git-Versioned with Code)

| Content | Path | Purpose |
|---------|------|---------|
| **Workflow Rules** | `.cursor/rules/docflow.mdc` | Agent's operating instructions |
| **Slash Commands** | `.cursor/commands/*.md` | Command implementations |
| **Agent Instructions** | `AGENTS.md` | Role-based agent guidance |
| **Platform Configs** | `WARP.md`, `.claude/` | Tool-specific setup |
| **Project Overview** | `docflow/context/overview.md` | Vision, goals, scope |
| **Tech Stack** | `docflow/context/stack.md` | Architecture, dependencies |
| **Code Standards** | `docflow/context/standards.md` | Conventions, patterns |
| **ADRs** | `docflow/knowledge/decisions/` | Architectural decisions |
| **Feature Docs** | `docflow/knowledge/features/` | Complex feature explanations |
| **Notes** | `docflow/knowledge/notes/` | Learnings, gotchas |
| **Product Docs** | `docflow/knowledge/product/` | Personas, user flows |
| **Config** | `.docflow.json` | Version + provider config |

**Why Local:**
- Agent needs instant access (no network call)
- Changes with code (version-controlled together)
- Developers need it in IDE
- Defines "what the project IS"

### 3.2 CLOUD (PM Tool)

| Content | Linear Equivalent | Purpose |
|---------|-------------------|---------|
| **Specs** | Issues | Work items (features, bugs, chores, ideas) |
| **Workflow State** | Workflow States | BACKLOG → COMPLETE progression (includes BLOCKED) |
| **Spec Types** | Labels | feature, bug, chore, idea |
| **Priority** | Priority field | Urgent, High, Medium, Low |
| **Complexity** | Estimate/Points | S, M, L, XL |
| **Assignments** | Assignee | Who's working on what |
| **Decision Log** | Comments | Dated decisions and rationale |
| **Implementation Notes** | Comments | Progress updates |
| **Assets** | Attachments | Figma links, screenshots |
| **INDEX.md equivalent** | Issue list + filters | Inventory of all work |
| **ACTIVE.md equivalent** | "In Progress" view | Current focus |

**Why Cloud:**
- Team collaboration
- Stakeholder visibility
- Real-time updates
- Native integrations (Figma, Slack, etc.)
- AI agent integration (Cursor Background Agent)

### 3.3 REMOVED (No Longer Needed)

| Old File | Replacement |
|----------|-------------|
| `docflow/INDEX.md` | Linear issue list with filters |
| `docflow/ACTIVE.md` | Linear "In Progress" view |
| `docflow/specs/` | Linear issues |
| `docflow/specs/templates/` | Linear issue templates |
| `docflow/specs/assets/` | Linear attachments |

---

## 4. Provider Abstraction Layer

### 4.1 Standard Interface

All PM tool providers implement this interface:

```typescript
// @docflow/provider-core

interface DocFlowProvider {
  // === Specs (Issues/Tasks) ===
  createSpec(input: CreateSpecInput): Promise<Spec>;
  updateSpec(id: string, input: UpdateSpecInput): Promise<Spec>;
  getSpec(id: string): Promise<Spec>;
  listSpecs(filter: SpecFilter): Promise<Spec[]>;
  deleteSpec(id: string): Promise<void>;
  
  // === Status/Workflow ===
  setStatus(id: string, status: DocFlowStatus): Promise<void>;
  getActiveSpecs(): Promise<Spec[]>;
  getBacklogSpecs(): Promise<Spec[]>;
  
  // === Comments/Activity ===
  addComment(specId: string, comment: string): Promise<Comment>;
  getComments(specId: string): Promise<Comment[]>;
  
  // === Attachments/Assets ===
  addAttachment(specId: string, attachment: Attachment): Promise<void>;
  getAttachments(specId: string): Promise<Attachment[]>;
  
  // === Documents (Optional - not all providers support) ===
  createDocument?(input: CreateDocInput): Promise<Document>;
  updateDocument?(id: string, content: string): Promise<Document>;
  getDocument?(id: string): Promise<Document>;
  listDocuments?(): Promise<Document[]>;
  
  // === Provider Info ===
  getProviderInfo(): ProviderInfo;
  testConnection(): Promise<boolean>;
}

// === Standard Types ===

type DocFlowStatus = 
  | 'BACKLOG' 
  | 'READY' 
  | 'IMPLEMENTING' 
  | 'BLOCKED'
  | 'REVIEW' 
  | 'TESTING' 
  | 'COMPLETE'
  | 'ARCHIVED'    // Terminal: deferred to future
  | 'CANCELED'    // Terminal: won't do
  | 'DUPLICATE';  // Terminal: already exists

type SpecType = 'feature' | 'bug' | 'chore' | 'idea';

type Priority = 'urgent' | 'high' | 'medium' | 'low';

type Complexity = 'S' | 'M' | 'L' | 'XL';

interface Spec {
  id: string;
  identifier: string;      // LIN-123, PROJ-456, etc.
  title: string;
  description: string;     // Full markdown content
  type: SpecType;
  status: DocFlowStatus;
  priority: Priority;
  complexity?: Complexity;
  assignee?: User;
  labels: string[];
  attachments: Attachment[];
  comments: Comment[];
  url: string;             // Link to view in PM tool
  createdAt: Date;
  updatedAt: Date;
}

interface Attachment {
  id: string;
  title: string;
  url: string;
  type: 'link' | 'file' | 'figma' | 'image';
  metadata?: Record<string, unknown>;
}

interface Comment {
  id: string;
  body: string;
  author: User;
  createdAt: Date;
}

interface ProviderInfo {
  name: string;            // 'linear', 'jira', 'asana', 'github'
  version: string;
  capabilities: {
    documents: boolean;
    customFields: boolean;
    realTimeSync: boolean;
    aiAgentIntegration: boolean;
  };
}
```

### 4.2 Status Mapping

Each provider maps DocFlow statuses to native states:

```typescript
interface StatusMapping {
  BACKLOG: string;     // Provider's backlog state
  READY: string;       // Provider's ready/todo state
  IMPLEMENTING: string; // Provider's in-progress state
  BLOCKED: string;     // Provider's blocked state (needs feedback/dependency)
  REVIEW: string;      // Provider's review state
  TESTING: string;     // Provider's QA state
  COMPLETE: string;    // Provider's done state
  // Terminal states (optional - for edge cases)
  ARCHIVED?: string;   // Provider's archived/deferred state
  CANCELED?: string;   // Provider's canceled state
  DUPLICATE?: string;  // Provider's duplicate state
}

// Example: Linear mapping
const linearStatusMapping: StatusMapping = {
  BACKLOG: 'Backlog',
  READY: 'Todo',
  IMPLEMENTING: 'In Progress',
  BLOCKED: 'Blocked',
  REVIEW: 'In Review',
  TESTING: 'QA',
  COMPLETE: 'Done',
  ARCHIVED: 'Archived',
  CANCELED: 'Canceled',
  DUPLICATE: 'Duplicate'
};

// Example: Jira mapping
const jiraStatusMapping: StatusMapping = {
  BACKLOG: 'Open',
  READY: 'Ready for Dev',
  IMPLEMENTING: 'In Development',
  BLOCKED: 'Blocked',
  REVIEW: 'Code Review',
  TESTING: 'In QA',
  COMPLETE: 'Closed',
  ARCHIVED: 'Deferred',
  CANCELED: "Won't Do",
  DUPLICATE: 'Duplicate'
};
```

---

## 5. Linear Integration (Phase 1)

### 5.1 Linear Hierarchy Mapping

```
Linear                          DocFlow
──────────────────────────────────────────────────
Organization                    (workspace)
  └── Team                      (codebase/project)
        ├── Initiative          (optional: epic scope)
        ├── Project             (feature grouping)
        ├── Issues              → Specs
        │     ├── Labels        → type (feature, bug, etc.)
        │     ├── Priority      → priority
        │     ├── Estimate      → complexity
        │     ├── State         → status
        │     ├── Assignee      → assignedTo
        │     ├── Description   → full spec content
        │     ├── Comments      → decision log, impl notes
        │     └── Attachments   → assets, Figma links
        │
        ├── Project Documents   → (optional) product docs
        └── Workflow States     → status progression
```

### 5.2 Project Configuration

```json
// .docflow.json
{
  "docflow": {
    "version": "3.0.0",
    "sourceRepo": "github.com/org/docflow"
  },
  
  "provider": {
    "type": "linear",
    
    "linear": {
      "teamId": "abc123-team-id",
      "initiativeId": "xyz789-initiative-id",
      "defaultProjectId": "proj-456-optional",
      
      "labels": {
        "feature": "label-id-feature",
        "bug": "label-id-bug",
        "chore": "label-id-chore",
        "idea": "label-id-idea"
      },
      
      "states": {
        "BACKLOG": "state-id-backlog",
        "READY": "state-id-todo",
        "IMPLEMENTING": "state-id-in-progress",
        "BLOCKED": "state-id-blocked",
        "REVIEW": "state-id-in-review",
        "TESTING": "state-id-qa",
        "COMPLETE": "state-id-done",
        "ARCHIVED": "state-id-archived",
        "CANCELED": "state-id-canceled",
        "DUPLICATE": "state-id-duplicate"
      }
    }
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

### 5.3 Linear Issue Template

Linear issue body maps to DocFlow spec structure:

```markdown
## Context
<!-- Why does this feature exist? What problem does it solve? -->

[Problem description and business value]

## User Story

**As a** [user role]
**I want to** [goal]
**So that** [benefit]

## Acceptance Criteria

### Must Have
- [ ] [Criterion 1]
- [ ] [Criterion 2]

### Should Have
- [ ] [Nice-to-have 1]

### Won't Have
- [ ] [Out of scope]

## Technical Notes

### Implementation Approach
[High-level approach]

### Components Needed
- `ComponentName` - [purpose]

### Data Model
```typescript
// Schema changes if any
```

## Design Reference
<!-- Figma links added as attachments -->

---
<!-- Below sections updated via comments -->

## Decision Log
_See issue comments for dated decisions_

## Implementation Notes
_See issue comments for progress updates_
```

### 5.4 Linear MCP Configuration

```json
// .cursor/mcp.json
{
  "mcpServers": {
    "docflow-linear": {
      "command": "npx",
      "args": ["@docflow/provider-linear"],
      "env": {
        "LINEAR_API_KEY": "${LINEAR_API_KEY}",
        "DOCFLOW_CONFIG": ".docflow.json"
      }
    },
    "linear": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "https://mcp.linear.app/mcp"],
      "env": {
        "LINEAR_API_KEY": "${LINEAR_API_KEY}"
      }
    },
    "figma": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-figma"],
      "env": {
        "FIGMA_ACCESS_TOKEN": "${FIGMA_ACCESS_TOKEN}"
      }
    }
  }
}
```

### 5.5 Cursor Background Agent Integration

Linear has native Cursor integration:

1. **Assign to @Cursor**: Issues assigned to Cursor are picked up automatically
2. **Mention @Cursor**: Comment `@Cursor please implement this` triggers agent
3. **Agent Updates**: Agent can update issue status, add comments, create PRs
4. **Repository Linking**: Linear knows which repo via project/issue labels

```
User assigns LIN-123 to @Cursor
        │
        ▼
Cursor Background Agent picks up issue
        │
        ▼
Agent reads issue → sees Figma attachment
        │
        ▼
Agent calls Figma MCP → gets design context
        │
        ▼
Agent reads local context (stack.md, standards.md)
        │
        ▼
Agent implements feature
        │
        ▼
Agent updates Linear issue status → REVIEW
        │
        ▼
Agent creates PR, links to issue
```

---

## 6. DocFlow Update System

### 6.1 Overview

A lightweight MCP server that syncs local DocFlow files from the central source repo.

```
User: /docflow-update

DocFlow Update MCP:
1. Read .docflow.json → current version: 3.0.0
2. Check source repo releases → latest: 3.1.0
3. Show changelog: "3.1.0: Added X, fixed Y"
4. Ask: "Update to 3.1.0? [y/n]"

If yes:
5. Download files from source repo tag v3.1.0
6. Overwrite local files:
   - .cursor/rules/docflow.mdc
   - .cursor/commands/*.md
   - AGENTS.md
   - WARP.md
   - .claude/* (if present)
7. Update .docflow.json version to 3.1.0
8. Report: "Updated to DocFlow 3.1.0 ✓"
```

### 6.2 Update MCP Structure

```
docflow-update-mcp/
├── src/
│   ├── server.ts           # MCP server entry
│   └── tools/
│       ├── check.ts        # Check for updates
│       ├── update.ts       # Perform update
│       └── version.ts      # Show current version
├── package.json            # @docflow/update-mcp
└── README.md
```

### 6.3 MCP Tools

```typescript
const tools = [
  {
    name: "docflow_check_update",
    description: "Check if DocFlow updates are available",
    inputSchema: {
      type: "object",
      properties: {},
      required: []
    }
  },
  {
    name: "docflow_update",
    description: "Update local DocFlow files to specified version",
    inputSchema: {
      type: "object",
      properties: {
        version: {
          type: "string",
          description: "Version to update to (e.g., '3.1.0' or 'latest')"
        }
      },
      required: []
    }
  },
  {
    name: "docflow_version",
    description: "Show current DocFlow version and source",
    inputSchema: {
      type: "object",
      properties: {},
      required: []
    }
  }
];
```

### 6.4 Version Pinning

Projects can control update behavior:

```json
// .docflow.json
{
  "docflow": {
    "version": "3.0.0",       // Pinned to specific version
    // OR
    "version": "latest",      // Always use latest
    // OR
    "version": "^3.0",        // Compatible with 3.x
    
    "autoUpdate": false,      // Don't auto-update
    "sourceRepo": "github.com/org/docflow"
  }
}
```

---

## 7. Asset & Design Integration

### 7.1 Figma Integration Flow

```
Designer adds Figma link to Linear issue
        │
        │  Attachment: {
        │    title: "Login Screen Design",
        │    url: "https://figma.com/file/abc?node-id=123:456",
        │    type: "figma"
        │  }
        │
        ▼
Agent reads issue via Linear MCP
        │
        │  Sees Figma URL in attachments
        │
        ▼
Agent extracts: fileKey="abc", nodeId="123:456"
        │
        ▼
Agent calls Figma MCP:
├── get_design_context(fileKey, nodeId)
│   └── Returns: component structure, CSS, layout
├── get_variable_defs(fileKey, nodeId)
│   └── Returns: color tokens, spacing values
└── get_screenshot(fileKey, nodeId)
    └── Returns: visual reference image
        │
        ▼
Agent implements with actual design specs
```

### 7.2 Asset Types in Linear

| Asset Type | How to Add | Agent Access |
|------------|------------|--------------|
| **Figma links** | Attachment URL | Linear MCP → Figma MCP |
| **Screenshots** | Upload to issue | Linear MCP → image URL |
| **Design tokens** | In Figma | Figma MCP → variables |
| **Reference docs** | Link attachment | Linear MCP → URL |
| **Wireframes** | Image upload | Linear MCP → image |

### 7.3 Issue Template for Design Work

```markdown
## Design Reference

**Figma**: [Add Figma link with node-id as attachment]

**Key Screens**:
- [Embed screenshot of main view]
- [Embed screenshot of alternate state]

**Design Tokens**:
- Primary: `--color-primary` (from Figma)
- Spacing: `--space-4` (from Figma)

## Acceptance Criteria
- [ ] Matches Figma design exactly
- [ ] Uses design system components
- [ ] Responsive per breakpoints
- [ ] Animations per interaction spec
```

---

## 8. Migration Path

### 8.1 From Local DocFlow to Cloud

#### Step 1: Setup Linear

```bash
1. Create Linear team (if not exists)
2. Create workflow states matching DocFlow statuses
3. Create labels: feature, bug, chore, idea
4. Create issue templates from spec templates
5. (Optional) Create initiative for project scope
```

#### Step 2: Configure Project

```bash
1. Create .docflow.json with Linear config
2. Add Linear MCP to .cursor/mcp.json
3. Set LINEAR_API_KEY environment variable
```

#### Step 3: Migrate Existing Specs

```bash
# For each spec in docflow/specs/
1. Create Linear issue from spec content
2. Set appropriate status/labels
3. Add attachments from docflow/specs/assets/
4. Verify issue ID matches spec

# Then remove local specs
rm -rf docflow/specs/
rm docflow/INDEX.md
rm docflow/ACTIVE.md
```

#### Step 4: Update Rules

```bash
# Sync latest cloud-enabled rules
/docflow-update

# Verify rules call Linear MCP instead of local files
```

### 8.2 Gradual Migration (Hybrid Period)

For teams wanting gradual transition:

```
Phase 1: New specs → Linear, existing specs → local
Phase 2: Active specs → Linear, backlog → local  
Phase 3: All specs → Linear
Phase 4: Remove local specs directory
```

---

## 9. Implementation Plan

### 9.1 Phase 1: Foundation (Week 1-2)

- [ ] Create DocFlow source repo structure
- [ ] Implement DocFlow Update MCP
- [ ] Create provider interface (`@docflow/provider-core`)
- [ ] Update rules to support provider abstraction
- [ ] Update commands to call provider MCP

### 9.2 Phase 2: Linear Provider (Week 3-4)

- [ ] Implement Linear provider (`@docflow/provider-linear`)
- [ ] Create Linear issue templates
- [ ] Implement status mapping
- [ ] Test Figma integration flow
- [ ] Document Linear setup process

### 9.3 Phase 3: Migration Tools (Week 5)

- [ ] Create migration script (local → Linear)
- [ ] Create setup wizard (`/docflow-setup-cloud`)
- [ ] Test hybrid operation mode
- [ ] Write migration documentation

### 9.4 Phase 4: Polish & Document (Week 6)

- [ ] End-to-end testing
- [ ] Performance optimization
- [ ] Complete documentation
- [ ] Release v3.0.0

---

## 10. Future Providers

### 10.1 Provider Roadmap

| Provider | Priority | Complexity | Notes |
|----------|----------|------------|-------|
| **Linear** | P0 | Medium | Best AI integration, modern API |
| **GitHub Issues** | P1 | Low | Good for OSS projects |
| **Jira** | P2 | High | Enterprise demand, complex API |
| **Asana** | P3 | Medium | If requested |
| **Notion** | P4 | Medium | Document-heavy workflows |

### 10.2 Provider Implementation Checklist

For each new provider:

- [ ] Implement `DocFlowProvider` interface
- [ ] Create status mapping configuration
- [ ] Create issue template equivalents
- [ ] Test attachment handling
- [ ] Document authentication setup
- [ ] Add to provider selection in setup wizard

### 10.3 Feature Parity Matrix

| Feature | Linear | GitHub | Jira | Asana |
|---------|--------|--------|------|-------|
| Issues/Tasks | ✅ | ✅ | ✅ | ✅ |
| Custom States | ✅ | ⚠️ | ✅ | ⚠️ |
| Labels/Tags | ✅ | ✅ | ✅ | ✅ |
| Attachments | ✅ | ✅ | ✅ | ✅ |
| Comments | ✅ | ✅ | ✅ | ✅ |
| Documents | ✅ | ❌ | ❌ | ⚠️ |
| AI Integration | ✅ | ✅ | ❌ | ❌ |
| Real-time | ✅ | ❌ | ⚠️ | ✅ |
| GraphQL API | ✅ | ✅ | ❌ | ❌ |
| Figma Integration | ✅ | ❌ | ✅ | ✅ |

---

## Appendix A: File Structure Comparison

### Before (Local Only)

```
project/
├── .cursor/
│   ├── rules/docflow.mdc
│   └── commands/*.md
├── docflow/
│   ├── ACTIVE.md              ← REMOVED
│   ├── INDEX.md               ← REMOVED
│   ├── context/               ← STAYS
│   ├── knowledge/             ← STAYS
│   └── specs/                 ← REMOVED (→ Linear)
│       ├── active/
│       ├── backlog/
│       ├── complete/
│       └── templates/
└── AGENTS.md
```

### After (Cloud Hybrid)

```
project/
├── .cursor/
│   ├── rules/docflow.mdc      ← Synced from source repo
│   ├── commands/*.md          ← Synced from source repo
│   └── mcp.json               ← Provider + update MCP config
├── docflow/
│   ├── context/               ← LOCAL (understanding)
│   │   ├── overview.md
│   │   ├── stack.md
│   │   └── standards.md
│   ├── knowledge/             ← LOCAL (project knowledge)
│   │   ├── INDEX.md
│   │   ├── decisions/
│   │   ├── features/
│   │   ├── notes/
│   │   └── product/
│   └── README.md
├── .docflow.json              ← Config (version + provider)
└── AGENTS.md                  ← Synced from source repo
```

---

## Appendix B: Command Changes

### Commands That Change

| Command | Before | After |
|---------|--------|-------|
| `/capture` | Creates local spec file | Creates Linear issue |
| `/activate` | Moves file backlog→active | Updates Linear issue state |
| `/implement` | Reads local spec | Reads Linear issue |
| `/validate` | Updates local spec | Updates Linear issue |
| `/close` | Moves file to complete/ | Updates Linear state to Done |
| `/status` | Reads INDEX.md, ACTIVE.md | Queries Linear API |

### Commands That Stay Same

| Command | Behavior |
|---------|----------|
| `/start-session` | Same flow, reads from Linear instead |
| `/wrap-session` | Same flow, updates Linear |
| `/review` | Same flow, operates on Linear issue |
| `/block` | Same flow, updates Linear issue |
| `/docflow-update` | NEW - syncs rules from source repo |

---

## Appendix C: Glossary

| Term | Definition |
|------|------------|
| **Provider** | PM tool integration (Linear, Jira, etc.) |
| **Spec** | Work item (feature, bug, chore, idea) |
| **Understanding Layer** | Local context/knowledge that explains the project |
| **Workflow State** | Spec progression (BACKLOG → COMPLETE) |
| **Source Repo** | Central DocFlow repository with rules/commands |
| **DocFlow Update MCP** | Tool for syncing rules from source repo |
| **Provider MCP** | Tool for interacting with PM tool API |

---

*End of DocFlow Cloud Specification*

