# FlyDocs Vision Document

> A comprehensive hybrid PRD/tech spec for building a productized spec-driven development platform

---

## What Makes FlyDocs Compelling

### The Pitch

> **Help your engineering team fly.**

FlyDocs doesn't replace your workflow — it **augments** your team. Seamlessly integrate AI into your existing development process while adding the things developers hate to do: consistent process governance, self-documentation, and visibility into what's getting done.

### The Differentiators

| Capability | What It Means | Why It Matters |
|------------|---------------|----------------|
| **Context Efficiency** | Tiered loading, compression, smart indexing | Faster, cheaper, better AI interactions |
| **Process Governance** | Non-negotiable rules that actually get followed | Consistency without rigidity — devs don't have to remember |
| **Zero-Friction Setup** | GitHub auth → scan → PR in minutes | Adoption wedge for existing teams |
| **Persistent Memory** | AI remembers decisions, patterns, and failures across sessions | No more re-explaining your codebase every conversation |
| **Cost Intelligence** | Calibrated estimates, actual tracking, forecasting | Prove ROI to leadership, budget planning |
| **MCP Router** | Single unified integration for all PM tools | Full API coverage, analytics passthrough |
| **Composable Skills** | Install, share, and sell workflow modules | Ecosystem play, agency value, premium features |

### The Vision

> **FlyDocs is the platform that augments your engineering team with AI — not by replacing developers, but by handling the overhead they hate: process compliance, documentation, and context management.**

It integrates with your existing PM tools, provides cost visibility, and keeps context efficient — while your team uses their own AI accounts.

### Why Engineering Leaders Will Care

1. **Augmentation, not replacement**: AI handles process overhead so devs focus on building
2. **Self-documenting**: Work gets documented automatically as it happens
3. **Visibility**: See what AI is doing, how much it costs, what's getting done
4. **Consistency**: Process governance that works without blocking velocity
5. **ROI**: Calibrated estimates and actual tracking to justify AI investment
6. **Control**: Works with existing tools (Linear, Jira, GitHub) — not another silo

### Integration Philosophy

> **FlyDocs augments existing tools and workflows rather than replacing them.**

We detect patterns, suggest conventions, and provide orchestration — but teams keep their:

- **Git strategy**: Trunk-based, GitFlow, or whatever works for them
- **Test frameworks**: Jest, pytest, Vitest — we run what's there
- **PM tools**: Linear, Jira, GitHub Issues — we integrate, not replace
- **CI/CD pipelines**: We hook in, we don't take over

**The Augmentation Spectrum**:

| Integration | Light (Default) | Medium | Deep (Optional) |
|-------------|-----------------|--------|-----------------|
| **Git** | Detect patterns, suggest conventions | Auto-link PRs to issues | Create branches on activate |
| **Testing** | Document expectations in specs | Gate status on test pass | Suggest test cases from specs |
| **PM Tools** | Unified MCP interface | Full API coverage | Custom workflows |
| **CI/CD** | Detect existing setup | Report status in workflow | Trigger deploys on close |

This philosophy ensures FlyDocs adds value without requiring teams to change what already works.

---

## Roadmap at a Glance

| Phase | Focus | Version | Key Deliverables |
|-------|-------|---------|------------------|
| **Phase 0** | Scaffolding | — | Clean up DocFlow 4.6, bootstrap FlyDocs |
| **Phase 1** | Foundation | — | Web setup, Linear integration, local-only mode |
| **Phase 2** | Intelligence | **v0.1 Beta** | Memory, Jira, composable skills |
| **Phase 3** | Analytics | — | Token tracking, cost forecasting, dashboards |
| **Phase 4** | Platform | **v1.0** | Skill SDK, enterprise, full PM suite |

**MVP/Beta (v0.1)**: Phases 0-2 complete
**Full Release (v1.0)**: All phases complete

---

## Future-Forward Features

These are the capabilities that make the roadmap exciting:

**Foundation** (Phase 1):

- **Git integration (light)**: Pattern detection, PR templates, branch suggestions
- **Testing integration (light)**: Framework detection, QE orchestration
- **Opinionated workflow**: Our proven BACKLOG → DONE flow

**Intelligence Layer** (Phase 2):

- **Long-term memory** with decision, pattern, warning, and calibration types
- **Composable skills** with marketplace distribution (free, premium, agency)
- **Jira + GitHub Issues** integration via unified MCP
- **Context7 integration** for version-specific library documentation
- **Workflow toggles** (Pro): Skip optional states like QA

**Analytics & Workflows** (Phase 3):

- **Token tracking** by project, issue, user
- **Cost forecasting** based on calibrated estimates
- **Team dashboards** for engineering leadership
- **Budget alerts** and approval workflows
- **Git integration (medium)**: Auto-link PRs, cycle time tracking
- **Testing integration (medium)**: Status gates, coverage trends
- **Custom workflows (Team)**: Config-driven states and transitions

**Platform & Enterprise** (Phase 4):

- **Skill SDK** for building custom skills
- **Stack-specific integrations** (Vercel, Convex, Supabase) via MCP Aggregator
- **Enterprise SSO** and team management
- **On-prem option** for compliance-sensitive orgs
- **Asana + Monday** integration
- **Visual workflow editor** (Enterprise): Drag-and-drop workflow design
- **Git integration (deep)**: Branch creation, PR requirements
- **Testing integration (deep)**: Test suggestions, property-based hints

**Deep Capability Previews** (see Part 4 for details):

- **SimpleMem** (primary): 43% accuracy, 30x token efficiency via write-time disambiguation
- **MCP Aggregator**: Central hub for PM tools + docs + stack integrations
- **LLMLingua/ACON**: Up to 20x context compression
- **AGENTS.md**: Universal standard, 60k+ repos, Linux Foundation backed
- **Git/Testing Integration**: Augment existing workflows, don't replace
- **Custom Workflows**: Opinionated default, premium flexibility

---

## Part 1: Product Vision

### What We're Building

**FlyDocs** is a spec-driven development platform that bridges the gap between AI-assisted coding and enterprise engineering practices. It's a hybrid system where:

- **Context lives in code** (self-documenting, version-controlled)
- **Workflow state lives in PM tools** (Linear, Jira, GitHub Issues)
- **Intelligence layer is optional** (users bring their own AI accounts)

The core insight: Teams don't need another AI tool that replaces their workflow. They need a system that **augments** their existing tools and processes with structure that makes AI collaboration predictable and accountable.

### Who It's For (Personas)

| Persona | Pain Points | FlyDocs Value |
|---------|-------------|---------------|
| **Tech Lead / Staff Eng** | AI outputs are inconsistent, context gets lost between sessions, code quality varies | Structured specs, persistent context, process governance |
| **VP of Engineering** | No visibility into AI-assisted work, can't measure ROI, worried about quality | Analytics dashboard, cost tracking, audit trails |
| **Solo Dev / Agency** | Context reloading every session, workflow overhead, inconsistent outputs | Auto-setup, lightweight context, composable skills |
| **Enterprise Team** | Compliance requirements, need governance without blocking velocity | Constitution-based rules, process enforcement, integration with existing tools |

### Adoption Wedges

1. **Zero-friction setup**: `npx flydocs init` → scans repo → generates context files → creates PR
2. **Works with existing tools**: Linear, Jira, GitHub Issues — not a replacement
3. **No AI costs to us**: Users authenticate with their own API keys, runs in their IDE/CLI
4. **Brownfield-first**: Designed for existing codebases, not greenfield projects

### Competitive Positioning

| Tool | Approach | FlyDocs Differentiation |
|------|----------|-------------------------|
| [OpenSpec](https://github.com/Fission-AI/OpenSpec) | Lightweight, dual-folder (specs/changes), IDE-agnostic | We add PM integration + analytics + memory |
| [SpecKit](https://github.com/github/spec-kit) | Constitution-based, elaborate artifacts, GitHub-native | We're hybrid (local + cloud), simpler governance |
| [Kiro](https://kiro.dev/) | Full IDE, AWS-backed, agent hooks | We're platform-agnostic, bring-your-own-AI |
| Cursor/Windsurf | AI IDE with rules files | We add workflow state + PM integration + visibility |

**Our unique position**: The only spec-driven system that:

1. Integrates with existing PM tools (not another silo)
2. Provides cost/usage analytics (prove ROI to leadership)
3. Separates process governance from optional features
4. Has minimal platform cost (users bring their AI)

---

## Part 2: Architecture & Foundation

### Core Architecture (Hybrid Model)

```text
┌─────────────────────────────────────────────────────────────────┐
│  User's Environment (No FlyDocs Cost)                           │
│  ┌──────────────────┐  ┌──────────────────┐                     │
│  │  IDE (Cursor,    │  │  AI Provider     │                     │
│  │  VS Code, etc)   │  │  (User's keys)   │                     │
│  └────────┬─────────┘  └────────┬─────────┘                     │
│           │                     │                               │
│           ▼                     ▼                               │
│  ┌─────────────────────────────────────────────┐                │
│  │  .flydocs/                                  │                │
│  │  ├── rules/       (process governance)      │                │
│  │  ├── skills/      (composable capabilities) │                │
│  │  ├── context/     (project understanding)   │                │
│  │  └── config.json  (integrations, settings)  │                │
│  └─────────────────────────────────────────────┘                │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │ MCP / API
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  FlyDocs Cloud (Optional, Analytics + Integrations)             │
│  ┌──────────────────┐  ┌──────────────────┐  ┌───────────────┐  │
│  │  MCP Router      │  │  Analytics       │  │  Memory       │  │
│  │  (PM Tools)      │  │  Dashboard       │  │  Layer        │  │
│  └──────────────────┘  └──────────────────┘  └───────────────┘  │
│                                                                 │
│  Integrations: Linear, Jira, GitHub Issues, Figma               │
└─────────────────────────────────────────────────────────────────┘
```

### Tech Stack

| Layer | Technology | Rationale |
|-------|------------|-----------|
| **Web App** | Next.js 16 (App Router) | Server components, streaming, edge-ready |
| **Database** | Convex | Real-time sync, TypeScript-first, serverless |
| **AI Integration** | Vercel AI SDK | Unified interface, streaming, tool calling |
| **Auth** | Clerk or WorkOS | GitHub OAuth for repo access (WorkOS more enterprise-ready) |
| **Analytics** | PostHog (events) + custom (tokens) | Open source, self-hostable option |
| **Local CLI** | Node.js + Commander | Cross-platform, npm distribution |

### MCP Router Concept

Instead of users connecting multiple limited MCPs (Linear MCP, Jira MCP, etc.), FlyDocs provides a **unified MCP** that routes through our integrations:

```text
┌─────────────────────────────────────────────────────────┐
│  FlyDocs MCP Server                                     │
│  ┌───────────────────────────────────────────────────┐  │
│  │  Unified Tool Interface                           │  │
│  │  - get_issue / update_issue / create_comment      │  │
│  │  - get_project_status / post_project_update       │  │
│  │  - search_issues / get_user                       │  │
│  └───────────────────────────────────────────────────┘  │
│                          │                              │
│            ┌─────────────┼─────────────┐                │
│            ▼             ▼             ▼                │
│       ┌────────┐   ┌────────┐   ┌──────────┐            │
│       │ Linear │   │  Jira  │   │  GitHub  │            │
│       │  API   │   │  API   │   │  Issues  │            │
│       └────────┘   └────────┘   └──────────┘            │
└─────────────────────────────────────────────────────────┘
```

**Benefits**:

- Single MCP connection for all PM tools
- Richer API coverage than individual MCPs
- Context efficiency (one protocol, unified schema)
- Analytics passthrough (track all operations)

### Configuration Architecture

**Current DocFlow config** (`.docflow/config.json`):

```json
{
  "version": "4.6.0",
  "provider": { "type": "linear", "teamId": "...", "projectId": "..." },
  "statusMapping": { ... },
  "aiLabor": { "enabled": false }
}
```

**FlyDocs config evolution** (`.flydocs/config.json`):

```json
{
  "version": "1.0.0",
  "projectId": "flydocs-cloud-id",    // Links to FlyDocs Cloud

  // PM Integration (unified across providers)
  "integration": {
    "provider": "linear",             // linear | jira | github | asana | monday | none
    "teamId": "...",
    "projectId": "...",
    "statusMapping": {
      "BACKLOG": "Backlog",
      "READY": "Todo",
      "IMPLEMENTING": "In Progress",
      "BLOCKED": "Blocked",
      "REVIEW": "In Review",
      "TESTING": "QA",
      "COMPLETE": "Done"
    }
  },

  // Features (opt-in)
  "features": {
    "memory": { "enabled": true },
    "analytics": { "enabled": true },
    "aiLabor": { "enabled": false, "thresholds": { ... } }
  },

  // Skills installed
  "skills": [
    "@flydocs/linear-workflow",
    "@flydocs/spec-templates"
  ],

  // Team (for multi-user)
  "team": {
    "orgId": "org-123",
    "tier": "pro"                    // free | pro | team | enterprise
  }
}
```

**Config evolution path**:

- DocFlow: Provider-specific, minimal features
- FlyDocs: Provider-agnostic, feature toggles, skill management, team settings
- Cloud sync: Config stored in Convex, local file is cache/override

---

### Setup Automation Flow

**Web-based (Primary)**:

```
1. User authenticates with GitHub
2. FlyDocs scans selected repo
   - Detects framework/stack → generates stack.md
   - Identifies patterns → seeds knowledge/
   - Detects PM tool from config/URLs
3. User reviews generated context files
4. FlyDocs creates PR with .flydocs/ structure
5. User merges, installs MCP, starts working
```

**CLI (Alternative)**:

```bash
npx flydocs init
# Interactive: selects repo, PM tool, generates files
# Creates local .flydocs/ structure
# Optionally connects to FlyDocs Cloud for analytics
```

---

## Part 3: Phased Roadmap

### Phase 1: Foundation (MVP) — Core System

**Goal**: Migrate DocFlow 4.6 to standalone FlyDocs app with web-based setup + local-only free tier

| Feature | Description | Priority |
|---------|-------------|----------|
| **Web Setup Flow** | GitHub auth → repo scan → PR creation | P0 |
| **Context Generation** | Auto-generate stack.md, overview.md from codebase | P0 |
| **Local-Only Mode** | Full spec-driven workflow without PM integration (free tier) | P0 |
| **Linear Integration** | Full API (not just MCP), unified operations | P0 |
| **Process Governance** | always.md rules, comment templates | P0 |
| **FlyDocs MCP** | Unified MCP server for PM operations | P0 |
| **Git Integration (Light)** | Detect patterns, PR templates, branch naming suggestions | P1 |
| **Testing Integration (Light)** | Detect framework, QE runs existing tests | P1 |
| **CLI Distribution** | `npx flydocs` for local operations | P1 |
| **Basic Dashboard** | Connected projects, recent activity | P1 |

### Phase 2: Intelligence Layer — Memory & Skills + Jira → **v0.1 Beta**

**Goal**: Add persistent memory, composable skill system, and Jira integration. **This completes the Beta release.**

| Feature | Description | Priority |
|---------|-------------|----------|
| **Long-term Memory** | Cross-session project learnings (decisions, patterns, failures) | P0 |
| **Jira Integration** | Full API parity with Linear via unified MCP | P0 |
| **Composable Skills** | Installable skill packages (`@flydocs/linear-workflow`) | P0 |
| **Workflow Toggles (Pro)** | Skip optional states (QA, Code Review) | P1 |
| **Skill Marketplace** | Public/private/premium skill distribution | P1 |
| **Context Compression** | Intelligent summarization, index-based retrieval | P1 |
| **GitHub Issues** | Full workflow support via unified MCP | P1 |

### Phase 3: Analytics & Visibility — Cost & Performance

**Goal**: Prove ROI to engineering leadership

| Feature | Description | Priority |
|---------|-------------|----------|
| **Token Tracking** | Track usage by project, issue, user | P0 |
| **Cost Analytics** | Real cost breakdown, trends, forecasting | P0 |
| **Estimation Calibration** | Learn from estimate vs actual, improve predictions | P0 |
| **Git Integration (Medium)** | Auto-link PRs, cycle time tracking, branch suggestions | P1 |
| **Testing Integration (Medium)** | Status gates on test pass, coverage trends | P1 |
| **Custom Workflows (Team)** | Config-driven states, transitions, templates | P1 |
| **Team Dashboard** | Aggregate view across projects, team members | P1 |
| **Budget Alerts** | Thresholds, notifications, approvals | P1 |
| **Export/Reporting** | CSV, API access for external tools | P2 |

### Phase 4: Platform & Ecosystem → **v1.0**

**Goal**: Enable community and enterprise adoption, expand PM integrations. **This completes the v1.0 release.**

| Feature | Description | Priority |
|---------|-------------|----------|
| **Asana Integration** | Full workflow support via unified MCP | P0 |
| **Visual Workflow Editor** | Drag-and-drop workflow design (Enterprise) | P0 |
| **Monday.com Integration** | Full workflow support via unified MCP | P1 |
| **Git Integration (Deep)** | Auto-create branches, require PR for close | P1 |
| **Testing Integration (Deep)** | Test case suggestions, property-based hints | P1 |
| **Per-Project Workflows** | Different workflows for different teams (Enterprise) | P1 |
| **Custom Integrations** | Webhook framework, custom MCP endpoints | P1 |
| **Team Management** | Roles, permissions, shared skills | P1 |
| **Skill SDK** | Framework for building custom skills | P1 |
| **Enterprise SSO** | SAML, OIDC support | P2 |
| **On-prem Option** | Self-hosted FlyDocs Cloud | P2 |

---

## Part 4: Deep Dives

### 4.1 Memory Systems

**The Problem**: Current AI assistants lose context between sessions. Every new conversation starts from scratch, reloading the same files, rediscovering the same patterns.

**Research Insights**:

- **[SimpleMem](https://github.com/aiming-lab/SimpleMem)** (primary): 43% accuracy, 30x token efficiency, write-time disambiguation
- [Mem0](https://mem0.ai/) (compare): Graph-based relationships, more production examples
- Hierarchical memory (short-term → long-term) mirrors human cognition

**Why SimpleMem**: Write-time disambiguation means "tomorrow at 2pm" becomes "2025-01-15T14:00:00" when stored, not when retrieved. This eliminates inference overhead and ambiguity at query time.

**FlyDocs Memory Architecture**:

```text
┌─────────────────────────────────────────────────────────────┐
│  Memory Layers                                              │
│                                                             │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  Session Memory (ephemeral)                          │   │
│  │  - Current conversation context                      │   │
│  │  - Working set of files                              │   │
│  │  - Active issue details                              │   │
│  └──────────────────────────────────────────────────────┘   │
│                          ▲                                  │
│                          │ promote/retrieve                 │
│                          ▼                                  │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  Project Memory (persistent, per-repo)               │   │
│  │  - Decisions: "We chose X over Y because Z"          │   │
│  │  - Patterns: "This codebase uses repository pattern" │   │
│  │  - Failures: "Auth changes broke SSO last time"      │   │
│  │  - Preferences: "User prefers functional style"      │   │
│  └──────────────────────────────────────────────────────┘   │
│                          ▲                                  │
│                          │ aggregate                        │
│                          ▼                                  │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  Team Memory (shared across projects)                │   │
│  │  - Common patterns across team repos                 │   │
│  │  - Shared decisions and standards                    │   │
│  │  - Cross-project learnings                           │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

**Memory Types**:

| Type | Example | Retrieval Trigger |
|------|---------|-------------------|
| **Decision** | "Chose Zustand over Redux for simplicity" | Similar state management discussions |
| **Pattern** | "API routes follow /api/v1/{resource}/{action}" | Creating new endpoints |
| **Warning** | "Changing auth middleware broke SSO" | Touching auth code |
| **Preference** | "User prefers explicit error handling" | Code generation |
| **Calibration** | "Feature estimates typically 30% under" | New estimates |

### 4.2 Context Efficiency

**The Problem**: Context windows fill up quickly. Large codebases can't fit. Reloading context every session is expensive.

**Research Insights**:

- [ACON](https://arxiv.org/abs/2510.00615) reduces memory by 26-54% while preserving performance
- Hierarchical compression: summarize old, keep recent detailed
- Index-based retrieval outperforms naive inclusion

**FlyDocs Approach**:

**1. Smart Indexes (not full content)**

```markdown
# .flydocs/indexes/routes.md

## API Routes Index
| Path | Handler | Description |
|------|---------|-------------|
| GET /api/users | src/routes/users.ts:15 | List users |
| POST /api/users | src/routes/users.ts:42 | Create user |
...

## To get full implementation:
Read the file at the path indicated.
```

**2. Tiered Loading**

```
Always loaded (tiny):
  - overview.md (~200 tokens)
  - stack.md (~300 tokens)
  - active issue description

Loaded on demand:
  - Relevant index sections
  - Pattern documentation
  - Decision history

Retrieved when needed:
  - Full file contents
  - Historical context
  - Related issues
```

**3. Compression Strategies**

- **Observation masking**: Strip verbose output, keep actions/reasoning
- **LLM summarization**: Compress old conversation turns
- **Semantic deduplication**: Don't repeat similar context

### 4.3 Composable Skills

**Current State**: Skills are markdown files with instructions. No versioning, no dependencies, no marketplace.

**Vision**: Skills as installable, composable packages

```bash
# Install a skill
flydocs skill add @flydocs/linear-workflow

# Install premium skill (requires subscription)
flydocs skill add @flydocs/advanced-estimation --license ABC123

# Install from URL
flydocs skill add https://github.com/company/custom-skill
```

**Skill Structure**:

```
@flydocs/linear-workflow/
├── skill.json          # Metadata, dependencies, config schema
├── SKILL.md            # Main instructions (current format)
├── prompts/            # Reusable prompt fragments
│   ├── capture.md
│   ├── refine.md
│   └── activate.md
├── tools/              # MCP tool definitions
│   └── linear.json
└── tests/              # Skill behavior tests
    └── capture.test.md
```

**Skill Categories**:

- **Core** (free): linear-workflow, spec-templates, session-awareness
- **Premium** (paid): advanced-estimation, team-analytics, compliance-tracking
- **Agency** (proprietary): Custom skills for your clients

### 4.4 Cost Analysis & Forecasting

**The Gap**: No tool currently provides accurate, calibrated cost estimation for AI-assisted development.

**FlyDocs Approach**:

**1. Estimation (Before Work)**

```
Inputs:
  - Task type (feature/bug/chore)
  - Complexity (XS-XL)
  - Novelty (existing pattern / partial new / greenfield)
  - Clarity (well-defined / needs discovery / exploratory)

Formula:
  estimated_tokens = base × scope × novelty × clarity × codebase_factor

Output:
  - Token range (low - high)
  - Cost range ($X - $Y)
  - Confidence level
```

**2. Tracking (During Work)**

```
Via MCP Router:
  - Every AI operation logged
  - Tokens in/out captured
  - Mapped to issue/project

Via IDE Extension (future):
  - Direct token capture
  - More granular than MCP
```

**3. Calibration (After Work)**

```
Compare: estimate vs actual
Learn:
  - Which task types are underestimated?
  - Which complexity factors need adjustment?
  - Team-specific multipliers

Apply: Improve future estimates
```

**4. Dashboards**

| View | Audience | Metrics |
|------|----------|---------|
| **Project** | Tech Lead | Cost per issue, burndown, velocity |
| **Team** | VP Eng | Total spend, cost per developer, trends |
| **Issue** | Developer | Tokens used, estimate accuracy |
| **Forecast** | Finance | Projected monthly spend, budget alerts |

### 4.5 MCP Aggregator Architecture

**Evolution: Router → Aggregator**

Phase 1 concept was "MCP Router" for PM tools. The evolved concept is **MCP Aggregator** — a central hub that unifies multiple tool categories.

**Why an Aggregator?**

Current state: Users connect multiple MCPs separately

- Linear MCP (limited API coverage)
- Context7 MCP (docs)
- Grep MCP (code search)
- Vercel MCP (deployments)
- Each = separate connection, separate context, no unified analytics

**FlyDocs MCP Aggregator**:

```text
FlyDocs MCP (Central Hub)
├── PM Tools Layer (Phase 1)
│   ├── Linear API
│   ├── Jira API
│   └── GitHub Issues API
│
├── Documentation Layer (Phase 2)
│   └── Context7 → Version-specific library docs
│
├── Code Intelligence Layer (Phase 3)
│   ├── Grep/search capabilities
│   └── Codebase indexing
│
└── Stack-Specific Layer (Phase 3+, based on config)
    ├── Vercel API (for Next.js projects)
    ├── Convex API (for Convex projects)
    └── Supabase API (for Supabase projects)
```

**Benefits**:

- Single MCP connection for everything
- Unified analytics (track all AI tool usage)
- Context efficiency (we control what gets loaded)
- Smart routing (based on query, route to right backend)
- Stack awareness (config drives which integrations are enabled)

### Context7 Integration

[Context7](https://github.com/upstash/context7) is a key integration for the docs layer:

| Capability | Value |
|------------|-------|
| **Version-specific docs** | No more hallucinated APIs |
| **Direct injection** | Docs go straight into context |
| **Library database** | Curated, trusted sources |
| **20x faster** | Than manual doc searching |

For spec-driven development, this is valuable because:

- Specs reference libraries ("use Zustand for state")
- AI implementing specs needs current docs
- Context7 provides that without bloating context

### Stack-Specific Configuration

```json
// .flydocs/config.json
{
  "stack": {
    "detected": ["nextjs", "convex", "tailwind"],
    "integrations": {
      "context7": {
        "enabled": true,
        "libraries": ["nextjs", "convex", "tailwind"]
      },
      "vercel": { "enabled": true },
      "convex": { "enabled": true }
    }
  }
}
```

Setup flow:

1. Scan repo → detect stack
2. Suggest relevant integrations
3. Enable in config
4. FlyDocs MCP provides unified access

### Phased Rollout

| Phase | MCP Capability |
|-------|----------------|
| **Phase 1** | PM tools only (Linear) |
| **Phase 2** | + Context7 for docs, + Jira |
| **Phase 3** | + Stack-specific (Vercel, Convex, Supabase) |
| **Phase 4** | + Custom integrations via SDK |

**Implementation**:

```typescript
// Unified tool interface
const tools = {
  // Works across all PM tools
  get_issue: async ({ id }) => {
    const provider = await getProvider(projectId);
    return provider.getIssue(id);
  },

  update_issue: async ({ id, ...updates }) => {
    const provider = await getProvider(projectId);
    const result = await provider.updateIssue(id, updates);
    await logOperation('update_issue', { id, updates, result });
    return result;
  },

  // Provider-agnostic operations
  search_issues: async ({ query, filters }) => { ... },
  get_project_status: async () => { ... },
  post_project_update: async ({ summary, health }) => { ... }
};
```

### 4.6 Git Integration

**The Gap**: Git workflows are deeply connected to spec-driven development — branches tied to issues, PRs linked to specs, commit messages referencing work — but most SDD tools don't address this explicitly.

**FlyDocs Approach**: Augment existing git workflows, don't replace them.

**Integration Levels**:

| Level | What FlyDocs Does | What Team Keeps |
|-------|-------------------|-----------------|
| **Light (Default)** | Detect existing patterns during setup scan, suggest conventions, generate PR templates | Their branching strategy (trunk, GitFlow, etc.) |
| **Medium** | Auto-link PRs to issues, branch naming suggestions, track PR cycle time | Their git host (GitHub, GitLab, Bitbucket) |
| **Deep (Opt-in)** | Create branches on `/activate`, require PR before `/close`, enforce naming | Choice of how strict to be |

**Light Integration (Phase 1)**:

- During setup scan: Detect branching patterns from git history
- Generate `.github/PULL_REQUEST_TEMPLATE.md` that references spec acceptance criteria
- Suggest branch naming convention based on detected patterns
- Document conventions in `.flydocs/context/git-workflow.md`

**Medium Integration (Phase 2-3)**:

- When `/activate` runs: Suggest branch name (`feature/ISSUE-123-add-auth`)
- When PR is opened: Auto-link to active issue in PM tool
- Track in analytics: Commits per issue, PR cycle time, review turnaround

**Deep Integration (Phase 4, Opt-in)**:

- `/activate` creates branch automatically
- `/close` blocked until PR is merged
- Enforce branch naming via pre-commit hooks
- CI status gates on workflow transitions

**Config Example**:

```json
{
  "git": {
    "enabled": true,
    "level": "medium",
    "branchPattern": "{{type}}/{{issueId}}-{{slug}}",
    "requirePRForClose": false,
    "autoLinkPRs": true
  }
}
```

**Key Principle**: Never force a strategy. Detect what's there, suggest improvements, let teams opt into stricter controls.

### 4.7 Testing Integration

**The Gap**: QE agent "validates" work, but testing is highly variable across stacks. We don't want to bring our own test framework — we want to orchestrate what's already there.

**FlyDocs Approach**: The QE agent runs existing tests and reports results. We orchestrate, we don't generate.

**Integration Levels**:

| Level | What FlyDocs Does | What Team Keeps |
|-------|-------------------|-----------------|
| **Light (Default)** | Detect test setup, document expectations in specs, QE runs `npm test` | Their test framework, their tests |
| **Medium** | Gate status transitions on test pass, track coverage trends | Their CI/CD pipeline |
| **Deep (Opt-in)** | Suggest test cases from specs, property-based testing hints | Control over what gets tested |

**Light Integration (Phase 1)**:

- During setup scan: Detect test framework (Jest, pytest, Vitest, Go test, etc.)
- Add "Test Plan" section to spec templates (human-written expectations)
- QE agent runs detected test command, reports pass/fail
- Document test conventions in `.flydocs/context/testing.md`

**Medium Integration (Phase 2-3)**:

- Optional gate: Can't move to `/close` unless tests pass
- Track in analytics: Test pass rate per issue, flaky test patterns
- Integration with CI: Pull test results from GitHub Actions, CircleCI, etc.
- Show test health trends in dashboard

**Deep Integration (Phase 4, Opt-in)**:

- Suggest test cases based on spec acceptance criteria (not auto-generate, just suggest)
- Property-based testing hints for complex logic (inspired by Kiro)
- Coverage thresholds as workflow gates
- Test impact analysis: Which tests to run based on changed files

**Config Example**:

```json
{
  "testing": {
    "enabled": true,
    "level": "medium",
    "command": "npm test",
    "requirePassForClose": true,
    "trackCoverage": true,
    "ciIntegration": "github-actions"
  }
}
```

**Spec Template Addition**:

```markdown
## Test Plan

### Unit Tests
- [ ] Test case 1: [description]
- [ ] Test case 2: [description]

### Integration Tests
- [ ] Scenario: [description]

### Manual Verification
- [ ] [What QE should manually check]
```

**Key Principle**: We orchestrate existing tests, we don't generate them. Teams own their test strategy; we help enforce it consistently.

---

## Part 5: Research Insights

### Competitive Analysis Summary

| System | Strengths | Weaknesses | FlyDocs Learning |
|--------|-----------|------------|------------------|
| **[OpenSpec](https://github.com/Fission-AI/OpenSpec)** | Lightweight, brownfield-first, IDE-agnostic | No PM integration, no analytics | Adopt dual-folder model (specs/changes) |
| **[SpecKit](https://github.com/github/spec-kit)** | Constitution governance, comprehensive | Heavy artifact burden, markdown fatigue | Simplify governance, avoid over-specification |
| **[Kiro](https://kiro.dev/)** | Agent hooks, property-based testing, full IDE | AWS-centric, IDE lock-in | Adopt hooks pattern, explore PBT |
| **[Cursor](https://cursor.sh/)** | Fast, familiar, great DX | No PM integration, no visibility | Focus on what they don't do |

### Key Patterns Emerging

1. **Constitution/Rules pattern**: All tools have some form of "immutable principles"
   - SpecKit: constitution.md
   - OpenSpec: project.md + AGENTS.md
   - DocFlow: always.md + core.md
   - **FlyDocs**: Keep this, it works

2. **Phased workflows**: Specify → Plan → Tasks → Implement
   - All tools enforce checkpoints
   - Prevents "vibe coding" drift
   - **FlyDocs**: Already have this via commands

3. **Spec evolution is unsolved**:
   - Per Martin Fowler: "None clearly articulate how specs evolve once initial features ship"
   - **FlyDocs opportunity**: Living specs that update with implementation

4. **Control paradox**:
   - Despite elaborate specs, AI agents frequently ignore constraints
   - **FlyDocs approach**: Process governance (always.md) vs creative freedom (implementation)

### Memory & Context Research

From [Mem0 research](https://arxiv.org/abs/2504.19413):

- 26% accuracy improvement with intelligent memory
- 91% lower latency vs full-context
- 90%+ token cost savings

From [ACON](https://arxiv.org/abs/2510.00615):

- Observation compression + history summarization
- 26-54% peak token reduction
- Smaller models can match larger with good compression

**FlyDocs Application**:

- Implement tiered memory (session → project → team)
- Use index-based retrieval over full inclusion
- Compress historical context, keep recent detailed

### MCP Ecosystem Status

From [MCP Spec 2025-11](https://modelcontextprotocol.io/specification/2025-11-25):

- Now under Linux Foundation (AAIF)
- OpenAI adopted in March 2025
- Multi-server connections supported
- Security concerns remain (auth inconsistent)

**FlyDocs Opportunity**:

- Router pattern provides auth layer
- Unified interface simplifies client integration
- Analytics passthrough adds value individual MCPs can't

---

## Part 6: Strategic Decisions

### Confirmed Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| **Open Source Strategy** | Fully proprietary | Maintain control, cleaner business model |
| **Setup Flow Priority** | Web-first | Better onboarding UX, GitHub auth enables repo access |
| **PM Integration Order** | Linear → Jira → GitHub Issues → Asana → Monday | Start with current strength, expand to enterprise |

### Tiered Access Model

| Tier | Features | PM Integration | Workflow |
|------|----------|----------------|----------|
| **Free** | Local-only, full spec-driven workflow, basic rules | None (pure spec files) | Fixed (opinionated) |
| **Pro** | Cloud features, single PM integration, analytics | One of: Linear, Jira, GitHub | Toggle optional states |
| **Team** | Multi-project, team memory, all integrations | All PM tools | Custom states & transitions |
| **Enterprise** | SSO, audit logs, custom skills, support | All + custom | Visual editor, per-project workflows |

### Custom Workflows (Premium Feature)

**The Insight**: Our opinionated workflow is a strength for onboarding but a limitation for enterprises. Teams have existing processes they can't abandon.

**Default Workflow** (Free tier, opinionated):

```
BACKLOG → TODO → IN PROGRESS → BLOCKED → IN REVIEW → QA → DONE
```

**Customization by Tier**:

| Tier | Workflow Capability | Example |
|------|---------------------|---------|
| **Free** | Fixed workflow, all states required | Must use our states |
| **Pro** | Toggle optional states on/off | Skip QA for small fixes |
| **Team** | Custom states, custom transitions, templates | Add "UAT" state, rename states |
| **Enterprise** | Visual editor, per-project workflows, approval gates | Different workflow per team |

**Config-Driven Workflows** (Team tier):

```json
{
  "workflow": {
    "states": [
      { "id": "backlog", "name": "Backlog", "type": "backlog" },
      { "id": "ready", "name": "Ready for Dev", "type": "ready" },
      { "id": "in_progress", "name": "In Progress", "type": "active" },
      { "id": "code_review", "name": "Code Review", "type": "review" },
      { "id": "uat", "name": "UAT", "type": "testing" },
      { "id": "done", "name": "Done", "type": "complete" }
    ],
    "transitions": [
      { "from": "backlog", "to": "ready", "command": "/refine" },
      { "from": "ready", "to": "in_progress", "command": "/activate" },
      { "from": "in_progress", "to": "code_review", "command": "/review" },
      { "from": "code_review", "to": "uat", "command": "/qa" },
      { "from": "uat", "to": "done", "command": "/close" }
    ],
    "rules": {
      "requireAssigneeForActive": true,
      "requireCommentOnTransition": true,
      "allowedSkipStates": ["uat"]
    }
  }
}
```

**Process Governance Becomes Dynamic**:

- `always.md` generated from workflow config
- Comment templates adapt to configured states
- Commands map to configured transitions
- Rules (assignment required, comments required) remain configurable

**Visual Workflow Editor** (Enterprise, Phase 4):

- Drag-and-drop state configuration
- Visual transition mapping
- Rule configuration UI
- Preview generated `always.md`
- Per-project workflow assignment

**Workflow Templates** (Team+):

- **Agile/Scrum**: Sprint-based with estimation
- **Kanban**: Continuous flow, WIP limits
- **Regulated**: Approval gates, audit trails
- **Minimal**: Just TODO → DOING → DONE

**Phase Rollout**:

| Phase | Workflow Capability |
|-------|---------------------|
| **Phase 1** | Fixed workflow only |
| **Phase 2** | Toggle optional states (Pro) |
| **Phase 3** | Config-driven workflows (Team), templates |
| **Phase 4** | Visual editor (Enterprise), per-project |

**Key Principle**: Start opinionated (reduces decisions for new users), unlock flexibility for teams with established processes.

### Local-Only Mode (Free/Core Tier)

For solo devs, hobbyists, or teams who want spec-driven development without PM integration. Based on the proven DocFlow Local (v2.x) pattern.

**Structure** (evolved from legacy DocFlow):

```
.flydocs/
├── specs/                    # Local spec files
│   ├── active/               # Current work (1-2 specs max)
│   ├── backlog/              # Prioritized queue
│   ├── complete/             # Archived by quarter (2025-Q1/)
│   ├── templates/            # Spec templates
│   └── assets/               # Attachments, diagrams
├── INDEX.md                  # Master list of all specs
├── ACTIVE.md                 # Current focus (quick reference)
├── rules/                    # Process governance
├── context/                  # Project understanding
│   ├── overview.md
│   ├── stack.md
│   └── standards.md
├── knowledge/                # Decisions, patterns, notes
└── config.json               # Local config (no PM integration)
```

**Key Files**:

- `INDEX.md`: Tracks all specs by status (Active, Backlog, Complete)
- `ACTIVE.md`: Quick view of current focus, updated by workflow
- Spec files: Full spec documents in `specs/{status}/[type]-[name].md`

**Workflow** (same commands, local storage):

- `/capture` → Creates spec in `specs/backlog/`
- `/activate` → Moves to `specs/active/`, updates INDEX.md
- `/implement` → Works from active spec
- `/close` → Moves to `specs/complete/YYYY-QN/`

**What's included**:

- Full spec-driven workflow via commands
- Process governance (always.md rules)
- Context files for AI steering
- No cloud dependency, no PM integration

**Trial → Core downgrade model** (TBD):

- Trial: Full cloud features for limited time/projects
- Core: Downgrades to local-only + basic cloud sync (skill updates, etc.)

**Upgrade path**: Connect PM tool → specs sync to issues → unlock full cloud features

### Open Questions (Remaining)

1. **Pricing specifics**: What limits for free tier? Price points for Pro/Team/Enterprise?

2. **Skill marketplace economics**: Revenue share for community skills? Premium tier requirements?

3. **Data residency**: Where does memory/analytics data live? EU considerations?

4. **Git integration depth**: How strict should deep integration be? Force branch creation or suggest?

5. **Testing integration scope**: Should we ever suggest test cases, or purely orchestrate existing tests?

6. **Workflow editor complexity**: How much flexibility in visual editor? Risk of over-engineering?

7. **Workflow templates**: Which templates to ship by default? Community-contributed templates?

---

## Phase 0: Scaffolding (Pre-MVP)

**Goal**: Clean up DocFlow 4.6, use it to bootstrap FlyDocs

| Step | Description |
|------|-------------|
| **0.1** | Finalize DocFlow 4.6 cleanup (almost done) |
| **0.2** | Create FlyDocs repo with Next.js + Convex structure |
| **0.3** | Install DocFlow 4.6 into FlyDocs repo |
| **0.4** | Use DocFlow to spec and build FlyDocs MVP |
| **0.5** | Switch FlyDocs to use itself (dogfooding) |

---

## AGENTS.md Standardization

### The Duplication Problem

Current DocFlow has tool-specific files:

```
.cursor/rules/           # Cursor-specific
.claude/rules.md         # Claude-specific
.warp/rules.md           # Warp-specific
.github/copilot-instructions.md  # Copilot-specific
AGENTS.md                # Universal fallback
```

### The Solution: AGENTS.md as Primary

[AGENTS.md](https://agents.md/) is now the official standard:

- **Backed by**: Google, OpenAI, Factory, Sourcegraph, Cursor
- **Adopted by**: 60,000+ repos
- **Stewarded by**: Linux Foundation (AAIF)
- **Supported by**: Codex, Jules, Copilot, Claude Code, Cursor, Aider, Windsurf

**FlyDocs structure**:

```
AGENTS.md                     # Universal entry point (primary)
.flydocs/
├── rules/                    # Source of truth for all rules
│   ├── always.md             # Process governance
│   ├── core.md               # Core workflow
│   └── {agent}.md            # Agent personas
└── ...

# Minimal tool-specific adapters (auto-generated)
.cursor/rules/flydocs.mdc     → imports from .flydocs/rules/
.claude/rules.md              → imports from .flydocs/rules/
```

**AGENTS.md as router**:

```markdown
# AGENTS.md
This project uses FlyDocs for spec-driven development.
See `.flydocs/rules/` for detailed rules.
See `.flydocs/context/` for project understanding.
```

---

## Memory + Knowledge Dual System

### The Distinction

| Layer | Purpose | Storage | Who Writes |
|-------|---------|---------|------------|
| **Knowledge Base** | Human documentation, architecture, decisions | `.flydocs/knowledge/` | Human + AI (reviewed) |
| **Memory Layer** | AI operational memory, session learnings | Cloud (Convex) | AI (automatic) |

### Knowledge Base Structure (Human-Readable)

```
.flydocs/knowledge/
├── architecture/             # System design docs
│   ├── data-model.md
│   └── api-design.md
├── features/                 # Feature documentation
│   └── auth-flow.md
├── decisions/                # ADRs, decision logs
│   └── 001-chose-convex.md
└── notes/                    # Technical notes
    └── performance-tips.md
```

Follows OpenSpec pattern of living documentation in code.

### Memory Layer (AI-Managed)

See Part 4.1 for memory architecture.

**Primary recommendation: [SimpleMem](https://github.com/aiming-lab/SimpleMem)**

| Aspect | SimpleMem (Primary) | [Mem0](https://mem0.ai/) (Compare) |
|--------|---------------------|-------------------------------------|
| **Accuracy** | **43.24% F1** | 34.2% F1 |
| **Speed** | **388s retrieval** | 583s (50% slower) |
| **Token Efficiency** | **30x fewer** than full-context | Good |
| **Key Innovation** | Write-time disambiguation | Graph-based relationships |
| **Maturity** | Research-focused (newer) | Production examples |

**Why SimpleMem as primary**:

- **26% better accuracy** than Mem0
- **Write-time disambiguation**: Resolves "tomorrow" → "2025-01-15T14:00:00" at write time, not read time
- **30x token efficiency**: Critical for keeping context light
- **Semantic + Lexical + Symbolic indexing**: Three-layer retrieval matches our needs

**Mem0 as fallback**: More production examples, may be useful if SimpleMem doesn't scale. Evaluate both during Phase 2.

---

## Context Efficiency Techniques

### Compression Tools to Evaluate

| Tool | Type | Compression | Notes |
|------|------|-------------|-------|
| **[LLMLingua](https://github.com/microsoft/LLMLingua)** | Prompt compression | Up to 20x | Microsoft, production-ready |
| **[LongLLMLingua](https://aclanthology.org/2024.acl-long.91/)** | RAG-specific | 4x tokens, +21% perf | Solves "lost in middle" |
| **[GPTCache](https://github.com/zilliztech/GPTCache)** | Semantic caching | 10x cost | Zilliz, LangChain integrated |
| **[ACON](https://arxiv.org/abs/2510.00615)** | Agent-specific | 26-54% | Best for agent workflows |

### Format Strategy

| Content Type | Format | Rationale |
|--------------|--------|-----------|
| **Rules (process)** | [XML tags](https://www.ssw.com.au/rules/ai-prompt-xml) in Markdown | Claude optimized for XML, clear section boundaries |
| **Knowledge (human)** | Rich Markdown | Readable, full formatting |
| **Context (loaded)** | Compressed Markdown | Token-efficient, essential only |
| **Indexes** | Tables/structured | Quick scanning |

### Minification Strategy

**Option 1**: Build-time minification

```
.flydocs/rules/always.md     → Source (human-readable)
.flydocs/.cache/always.min   → Minified for loading
```

**Option 2**: Load-time compression

- Strip comments and excessive whitespace
- Collapse verbose sections
- Keep essential structure

**Option 3**: Tiered loading (recommended)

```
Always loaded: ~500 tokens
  - overview.md (compressed)
  - active issue only

On-demand: ~2000 tokens
  - Relevant rules
  - Pattern matches

Full retrieval: As needed
  - Complete files
  - Historical context
```

---

## Next Steps

1. **Validate architecture**: Review this doc, identify gaps
2. **Phase 0 execution**: Clean up DocFlow 4.6, create FlyDocs repo
3. **AGENTS.md migration**: Consolidate tool-specific files to AGENTS.md pattern
4. **Build setup flow**: GitHub auth → scan → PR creation (includes git/test detection)
5. **Prototype memory**: Start with SimpleMem, compare to Mem0 if needed
6. **Define workflow config schema**: Design JSON structure for custom workflows
7. **Document integration levels**: Clear guidance on light/medium/deep for git and testing

---

## Sources

### Spec-Driven Development

- [OpenSpec GitHub](https://github.com/Fission-AI/OpenSpec)
- [SpecKit GitHub](https://github.com/github/spec-kit)
- [Kiro](https://kiro.dev/)
- [Martin Fowler: SDD Tools Comparison](https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html)
- [GitHub Blog: Spec-Driven Development](https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/)
- [Thoughtworks: SDD Practices](https://www.thoughtworks.com/en-us/insights/blog/agile-engineering-practices/spec-driven-development-unpacking-2025-new-engineering-practices)

### Memory Systems

- [Mem0 Research Paper](https://arxiv.org/abs/2504.19413)
- [SimpleMem GitHub](https://github.com/aiming-lab/SimpleMem)

### Context Efficiency

- [ACON Context Compression](https://arxiv.org/abs/2510.00615)
- [Microsoft LLMLingua](https://github.com/microsoft/LLMLingua)
- [LongLLMLingua Paper](https://aclanthology.org/2024.acl-long.91/)
- [GPTCache](https://github.com/zilliztech/GPTCache)

### Standards & Protocols

- [AGENTS.md Specification](https://agents.md/)
- [AGENTS.md GitHub](https://github.com/agentsmd/agents.md)
- [MCP Specification 2025-11](https://modelcontextprotocol.io/specification/2025-11-25)
- [Context7 MCP](https://github.com/upstash/context7) - Version-specific docs for AI coding

### Format & Optimization

- [XML vs Markdown for LLM Prompts](https://medium.com/@isaiahdupree33/optimal-prompt-formats-for-llms-xml-vs-markdown-performance-insights-cef650b856db)
- [SSW Rules: XML Tags in Prompts](https://www.ssw.com.au/rules/ai-prompt-xml)
- [Prompt Formatting Impact Research](https://arxiv.org/html/2411.10541v1)
