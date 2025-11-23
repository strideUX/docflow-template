# DocFlow Cloud: Evolution Plan

**Status:** Planning  
**Last Updated:** November 23, 2024  
**Architecture:** Mastra Framework (Self-Hosted)

---

## Executive Summary

**Core Decision:** Build DocFlow Cloud using **Mastra** (TypeScript-native AI agent framework), deployed to Vercel alongside your Next.js + Convex stack.

**Why Mastra?**
- ✅ **40% less code** than custom Vercel AI SDK implementation (~880 vs ~1,450 lines)
- ✅ **Workflow orchestration built-in** - No custom state machine needed
- ✅ **Production observability** - Monitoring & evaluation tools included
- ✅ **Self-hosted** - No platform fees, full control, predictable costs
- ✅ **No vendor lock-in** - Open-source, deploy anywhere
- ✅ **TypeScript-native** - Perfect fit with your stack

**What Changes:**
- **Agent Framework:** Mastra agents (not custom AI SDK routes)
- **Orchestration:** Mastra graph-based workflows (not custom state machine)
- **Deployment:** Same Vercel infrastructure (no new platform)
- **Cost:** Same (~$30-100/mo for Vercel + Convex + E2B + LLM calls)

**What Stays the Same:**
- ✅ Next.js 15 frontend
- ✅ MCP server for local bridge
- ✅ Three-agent model (PM → Implementation → QE)
- ✅ Local-first philosophy (git-versioned knowledge)

**New Strategic Capability:**
- 🎯 **Multi-Provider Support** - Works with Convex, Jira, Asana, Linear, or custom task systems
- 🎯 **TaskProvider abstraction** - Workflows are backend-agnostic
- 🎯 **Per-project configuration** - Each project chooses its task system
- 🎯 **Future-proof** - Easy to add new providers without touching workflow code

**Next Step:** Phase 0 validation (1 week) to prove Mastra workflow execution + provider pattern

---

## Current State

DocFlow is a local-first, markdown-based workflow system that provides:

- ✅ Excellent AI agent context (2-7K tokens, efficient)
- ✅ Three-agent orchestration model (PM → Implementation → QE)
- ✅ Living documentation that serves humans and AI
- ✅ Clear workflow states and transitions
- ✅ Project-specific knowledge that grows over time

**The Problem:**

- ❌ Workflow logic lives in copied markdown files across projects
- ❌ Updates require manual propagation to every project
- ❌ No way to leverage cloud-based AI agents
- ❌ No centralized task orchestration across projects
- ❌ Limited to local developer presence for all work

---

## Why Change?

### Core Issues to Solve

1. **Template Distribution Hell**
   - Every project has a copy of workflow rules
   - Updating workflow = touching every project manually
   - No version management or rollback capability

2. **Can't Scale with Cloud Agents**
   - All work requires local developer + local AI (Cursor, etc.)
   - Can't assign tasks to cloud agents for autonomous execution
   - Missing opportunity for parallel work (local dev + cloud agents)

3. **No Central Orchestration**
   - Can't see work across multiple projects
   - Can't coordinate between developers and agents
   - No centralized priority management

4. **Workflow Evolution is Painful**
   - Improving the three-agent model requires updating every project
   - Testing workflow changes is manual and error-prone
   - No A/B testing or gradual rollout capability

---

## Multi-Provider Strategy: Task Management Abstraction

### Strategic Decision: Provider-Agnostic Architecture

**Goal:** Support multiple task management backends (Convex, Jira, Asana, Linear, custom systems) without changing core workflow logic.

**Why This Matters:**
1. **Product Flexibility** - Different customers use different tools
2. **Better Architecture** - Forces separation of concerns
3. **Future-Proof** - Easy to add new providers
4. **No Lock-In** - Users choose their task system
5. **Competitive Advantage** - Works with existing workflows

### Architectural Impact

**Current Plan (Convex-only):**
```typescript
// Mastra workflows directly call Convex
const task = await fetch(`${CONVEX_URL}/api/tasks/${taskId}`);
```

**Multi-Provider Plan (Abstraction Layer):**
```typescript
// Mastra workflows call abstract provider
const task = await taskProvider.getTask(taskId);
// Provider could be: Convex, Jira, Asana, etc.
```

### Provider Interface Pattern

```typescript
// lib/task-providers/types.ts

export interface DocFlowTask {
  id: string;
  title: string;
  description: string;
  status: TaskStatus;
  type: 'feature' | 'bug' | 'chore' | 'idea';
  owner: 'PM' | 'Implementation' | 'QE' | 'User';
  assignedTo: string;
  acceptanceCriteria: AcceptanceCriterion[];
  implementationNotes?: string;
  reviewNotes?: string;
  qeNotes?: string;
  metadata: {
    projectId: string;
    complexity?: 'S' | 'M' | 'L' | 'XL';
    templateVersion: string;
    externalId?: string;        // Original ID in source system
    externalUrl?: string;        // Link back to source system
    syncedAt: Date;
  };
}

export interface TaskProvider {
  // Core CRUD operations
  getTask(taskId: string): Promise<DocFlowTask>;
  createTask(task: Omit<DocFlowTask, 'id'>): Promise<DocFlowTask>;
  updateTask(taskId: string, updates: Partial<DocFlowTask>): Promise<DocFlowTask>;
  deleteTask(taskId: string): Promise<void>;
  
  // State transitions
  transitionStatus(taskId: string, newStatus: TaskStatus): Promise<DocFlowTask>;
  
  // Queries
  listTasks(filters: TaskFilters): Promise<DocFlowTask[]>;
  getTasksByProject(projectId: string): Promise<DocFlowTask[]>;
  getTasksByStatus(status: TaskStatus): Promise<DocFlowTask[]>;
  getTasksForAgent(assignedTo: string): Promise<DocFlowTask[]>;
  
  // Assignment
  assignTask(taskId: string, assignedTo: string): Promise<DocFlowTask>;
  
  // Provider metadata
  getProviderInfo(): ProviderInfo;
  
  // Optional: Real-time sync
  subscribeToTask?(taskId: string, callback: (task: DocFlowTask) => void): () => void;
}

export interface ProviderInfo {
  name: string;              // 'convex', 'jira', 'asana', 'linear'
  displayName: string;       // 'Convex', 'Jira Cloud', 'Asana'
  version: string;
  capabilities: {
    realTimeSync: boolean;
    webhooks: boolean;
    customFields: boolean;
    attachments: boolean;
  };
}
```

### Provider Implementations

**1. Convex Provider (Reference Implementation)**

```typescript
// lib/task-providers/convex-provider.ts

export class ConvexTaskProvider implements TaskProvider {
  constructor(private config: { url: string; apiKey: string }) {}
  
  async getTask(taskId: string): Promise<DocFlowTask> {
    const response = await fetch(`${this.config.url}/api/tasks/${taskId}`, {
      headers: { 'Authorization': `Bearer ${this.config.apiKey}` }
    });
    const convexTask = await response.json();
    return this.mapConvexToDocFlow(convexTask);
  }
  
  async createTask(task: Omit<DocFlowTask, 'id'>): Promise<DocFlowTask> {
    const response = await fetch(`${this.config.url}/api/tasks`, {
      method: 'POST',
      headers: { 
        'Authorization': `Bearer ${this.config.apiKey}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(this.mapDocFlowToConvex(task))
    });
    return this.mapConvexToDocFlow(await response.json());
  }
  
  async transitionStatus(taskId: string, newStatus: TaskStatus): Promise<DocFlowTask> {
    // Convex-specific state machine validation
    const response = await fetch(`${this.config.url}/api/tasks/${taskId}/transition`, {
      method: 'POST',
      headers: { 
        'Authorization': `Bearer ${this.config.apiKey}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ newStatus })
    });
    return this.mapConvexToDocFlow(await response.json());
  }
  
  getProviderInfo(): ProviderInfo {
    return {
      name: 'convex',
      displayName: 'Convex',
      version: '1.0.0',
      capabilities: {
        realTimeSync: true,    // Convex has real-time subscriptions
        webhooks: true,
        customFields: true,
        attachments: false
      }
    };
  }
  
  private mapConvexToDocFlow(convexTask: any): DocFlowTask {
    // Transform Convex schema to DocFlow interface
    return {
      id: convexTask._id,
      title: convexTask.title,
      description: convexTask.description,
      status: convexTask.docflow.status,
      type: convexTask.docflow.type,
      owner: convexTask.docflow.owner,
      assignedTo: convexTask.docflow.assignedTo,
      acceptanceCriteria: convexTask.docflow.acceptanceCriteria,
      implementationNotes: convexTask.docflow.implementationNotes,
      reviewNotes: convexTask.docflow.reviewNotes,
      qeNotes: convexTask.docflow.qeNotes,
      metadata: {
        projectId: convexTask.projectId,
        complexity: convexTask.docflow.complexity,
        templateVersion: convexTask.docflow.templateVersion,
        externalId: convexTask._id,
        syncedAt: new Date()
      }
    };
  }
  
  private mapDocFlowToConvex(task: Partial<DocFlowTask>): any {
    // Transform DocFlow interface to Convex schema
    return {
      title: task.title,
      description: task.description,
      projectId: task.metadata?.projectId,
      docflow: {
        type: task.type,
        status: task.status,
        owner: task.owner,
        assignedTo: task.assignedTo,
        complexity: task.metadata?.complexity,
        templateVersion: task.metadata?.templateVersion,
        acceptanceCriteria: task.acceptanceCriteria,
        implementationNotes: task.implementationNotes,
        reviewNotes: task.reviewNotes,
        qeNotes: task.qeNotes
      }
    };
  }
}
```

**2. Jira Provider (Future Implementation)**

```typescript
// lib/task-providers/jira-provider.ts

export class JiraTaskProvider implements TaskProvider {
  constructor(private config: { 
    baseUrl: string;
    email: string;
    apiToken: string;
    projectKey: string;
    docflowFieldIds: {      // Custom field IDs in Jira
      status: string;
      owner: string;
      acceptanceCriteria: string;
      implementationNotes: string;
    };
  }) {}
  
  async getTask(taskId: string): Promise<DocFlowTask> {
    const response = await fetch(
      `${this.config.baseUrl}/rest/api/3/issue/${taskId}`,
      {
        headers: {
          'Authorization': `Basic ${btoa(`${this.config.email}:${this.config.apiToken}`)}`,
          'Accept': 'application/json'
        }
      }
    );
    const jiraIssue = await response.json();
    return this.mapJiraToDocFlow(jiraIssue);
  }
  
  async createTask(task: Omit<DocFlowTask, 'id'>): Promise<DocFlowTask> {
    const jiraIssue = {
      fields: {
        project: { key: this.config.projectKey },
        summary: task.title,
        description: task.description,
        issuetype: { name: this.mapTypeToJiraIssueType(task.type) },
        // Map DocFlow fields to Jira custom fields
        [this.config.docflowFieldIds.status]: task.status,
        [this.config.docflowFieldIds.owner]: task.owner,
        [this.config.docflowFieldIds.acceptanceCriteria]: JSON.stringify(task.acceptanceCriteria)
      }
    };
    
    const response = await fetch(
      `${this.config.baseUrl}/rest/api/3/issue`,
      {
        method: 'POST',
        headers: {
          'Authorization': `Basic ${btoa(`${this.config.email}:${this.config.apiToken}`)}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(jiraIssue)
      }
    );
    const created = await response.json();
    return this.getTask(created.key);
  }
  
  async transitionStatus(taskId: string, newStatus: TaskStatus): Promise<DocFlowTask> {
    // Jira uses transition IDs, need to map DocFlow status to Jira transition
    const transitionId = this.getJiraTransitionId(newStatus);
    
    await fetch(
      `${this.config.baseUrl}/rest/api/3/issue/${taskId}/transitions`,
      {
        method: 'POST',
        headers: {
          'Authorization': `Basic ${btoa(`${this.config.email}:${this.config.apiToken}`)}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ transition: { id: transitionId } })
      }
    );
    
    return this.getTask(taskId);
  }
  
  getProviderInfo(): ProviderInfo {
    return {
      name: 'jira',
      displayName: 'Jira Cloud',
      version: '1.0.0',
      capabilities: {
        realTimeSync: false,   // Would need webhooks
        webhooks: true,
        customFields: true,
        attachments: true
      }
    };
  }
  
  private mapJiraToDocFlow(jiraIssue: any): DocFlowTask {
    // Transform Jira issue to DocFlow interface
    return {
      id: jiraIssue.key,
      title: jiraIssue.fields.summary,
      description: jiraIssue.fields.description,
      status: jiraIssue.fields[this.config.docflowFieldIds.status] || 'BACKLOG',
      type: this.mapJiraIssueTypeToDocFlow(jiraIssue.fields.issuetype.name),
      owner: jiraIssue.fields[this.config.docflowFieldIds.owner] || 'User',
      assignedTo: jiraIssue.fields.assignee?.emailAddress || 'Unassigned',
      acceptanceCriteria: JSON.parse(
        jiraIssue.fields[this.config.docflowFieldIds.acceptanceCriteria] || '[]'
      ),
      implementationNotes: jiraIssue.fields[this.config.docflowFieldIds.implementationNotes],
      metadata: {
        projectId: jiraIssue.fields.project.key,
        templateVersion: '2.1',
        externalId: jiraIssue.key,
        externalUrl: `${this.config.baseUrl}/browse/${jiraIssue.key}`,
        syncedAt: new Date()
      }
    };
  }
  
  private mapTypeToJiraIssueType(type: string): string {
    const mapping = {
      'feature': 'Story',
      'bug': 'Bug',
      'chore': 'Task',
      'idea': 'Epic'
    };
    return mapping[type] || 'Task';
  }
  
  private mapJiraIssueTypeToDocFlow(jiraType: string): 'feature' | 'bug' | 'chore' | 'idea' {
    const mapping = {
      'Story': 'feature',
      'Bug': 'bug',
      'Task': 'chore',
      'Epic': 'idea'
    };
    return (mapping[jiraType] || 'chore') as any;
  }
  
  private getJiraTransitionId(status: TaskStatus): string {
    // Would need to be configured per Jira workflow
    const transitions = {
      'BACKLOG': '11',
      'READY': '21',
      'IMPLEMENTING': '31',
      'REVIEW': '41',
      'QE_TESTING': '51',
      'COMPLETE': '61'
    };
    return transitions[status] || '11';
  }
}
```

**3. Asana Provider (Future Implementation)**

```typescript
// lib/task-providers/asana-provider.ts

export class AsanaTaskProvider implements TaskProvider {
  constructor(private config: {
    accessToken: string;
    workspaceGid: string;
    projectGid: string;
  }) {}
  
  async getTask(taskId: string): Promise<DocFlowTask> {
    const response = await fetch(
      `https://app.asana.com/api/1.0/tasks/${taskId}`,
      {
        headers: {
          'Authorization': `Bearer ${this.config.accessToken}`,
          'Accept': 'application/json'
        }
      }
    );
    const asanaTask = await response.json();
    return this.mapAsanaToDocFlow(asanaTask.data);
  }
  
  // ... similar pattern to Jira provider
  
  getProviderInfo(): ProviderInfo {
    return {
      name: 'asana',
      displayName: 'Asana',
      version: '1.0.0',
      capabilities: {
        realTimeSync: false,
        webhooks: true,
        customFields: true,
        attachments: true
      }
    };
  }
}
```

### Provider Factory & Configuration

```typescript
// lib/task-providers/factory.ts

export type ProviderConfig = 
  | { type: 'convex'; url: string; apiKey: string }
  | { type: 'jira'; baseUrl: string; email: string; apiToken: string; projectKey: string; docflowFieldIds: any }
  | { type: 'asana'; accessToken: string; workspaceGid: string; projectGid: string }
  | { type: 'linear'; apiKey: string; teamId: string }
  | { type: 'custom'; adapter: TaskProvider };

export class TaskProviderFactory {
  static create(config: ProviderConfig): TaskProvider {
    switch (config.type) {
      case 'convex':
        return new ConvexTaskProvider(config);
      
      case 'jira':
        return new JiraTaskProvider(config);
      
      case 'asana':
        return new AsanaTaskProvider(config);
      
      case 'linear':
        return new LinearTaskProvider(config);
      
      case 'custom':
        return config.adapter;
      
      default:
        throw new Error(`Unknown provider type: ${(config as any).type}`);
    }
  }
}
```

**Project Configuration:**

```typescript
// .docflow/config.json (in each project)
{
  "version": "2.1",
  "provider": {
    "type": "convex",
    "config": {
      "url": "${CONVEX_URL}",
      "apiKey": "${DOCFLOW_API_KEY}"
    }
  },
  "projectId": "my-project-123"
}

// Alternative: Jira project
{
  "version": "2.1",
  "provider": {
    "type": "jira",
    "config": {
      "baseUrl": "https://mycompany.atlassian.net",
      "email": "${JIRA_EMAIL}",
      "apiToken": "${JIRA_API_TOKEN}",
      "projectKey": "MYPROJ",
      "docflowFieldIds": {
        "status": "customfield_10001",
        "owner": "customfield_10002",
        "acceptanceCriteria": "customfield_10003",
        "implementationNotes": "customfield_10004"
      }
    }
  },
  "projectId": "MYPROJ"
}
```

### Provider Discovery & Initialization

**How Mastra Workflows Get the Right Provider:**

```typescript
// mastra/providers/index.ts

import { TaskProvider, ProviderConfig } from '@/lib/task-providers/types';
import { TaskProviderFactory } from '@/lib/task-providers/factory';

// Cache providers per project
const providerCache = new Map<string, TaskProvider>();

export async function getTaskProvider(projectId: string): Promise<TaskProvider> {
  // Check cache first
  if (providerCache.has(projectId)) {
    return providerCache.get(projectId)!;
  }
  
  // Fetch provider config via MCP
  const config = await fetchProviderConfig(projectId);
  
  // Create provider instance
  const provider = TaskProviderFactory.create(config);
  
  // Cache it
  providerCache.set(projectId, provider);
  
  return provider;
}

async function fetchProviderConfig(projectId: string): ProviderConfig {
  // Call MCP server to get project-specific config
  const response = await fetch(`http://localhost:3000/mcp/project-config`, {
    method: 'POST',
    body: JSON.stringify({ projectId })
  });
  return await response.json();
}
```

**MCP Server Provides Configuration:**

```typescript
// @docflow/mcp-server/src/tools/config.ts

export const getProviderConfigTool = {
  name: 'docflow_get_provider_config',
  description: 'Get task provider configuration for a project',
  
  async execute({ projectId }: { projectId: string }) {
    // Read .docflow/config.json from local project
    const projectPath = await findProjectPath(projectId);
    const configPath = path.join(projectPath, '.docflow', 'config.json');
    
    const config = JSON.parse(await fs.readFile(configPath, 'utf-8'));
    
    // Resolve environment variables (${VAR_NAME})
    return {
      type: config.provider.type,
      config: resolveEnvVars(config.provider.config),
      projectId: config.projectId
    };
  }
};
```

### Cross-Provider Task Flow Example

**Scenario: Jira-backed project with cloud agents**

```
1. Developer: "activate user-dashboard for cloud agent"

2. MCP Server:
   - Reads .docflow/config.json → provider: "jira"
   - Creates JiraTaskProvider
   - Calls jiraProvider.assignTask('PROJ-123', 'cloud-agent')
   - Updates Jira via API

3. Jira Webhook → Your Next.js endpoint
   - Detects task assignment change
   - Adds to Convex agent queue (or triggers directly)

4. Mastra Workflow Triggered:
   - Receives: { taskId: 'PROJ-123', projectId: 'my-proj' }
   - Calls: getTaskProvider('my-proj')
   - Gets: JiraTaskProvider instance

5. Workflow Execution (provider-agnostic):
   const task = await provider.getTask('PROJ-123');
   await provider.transitionStatus('PROJ-123', 'IMPLEMENTING');
   // Agent works...
   await provider.updateTask('PROJ-123', { 
     implementationNotes: '...',
     status: 'REVIEW' 
   });

6. Jira Updated:
   - Custom fields updated via Jira API
   - Status transitioned via Jira workflow
   - PR link added to Jira issue
   
7. Developer reviews in Jira
   - Sees DocFlow status
   - Sees implementation notes
   - Clicks link to PR in GitHub
```

### Strategic Benefits

| Benefit | Impact |
|---------|--------|
| **Customer Choice** | Each customer uses their preferred task system |
| **Gradual Migration** | Move projects between systems without code changes |
| **Multi-Tenant** | SaaS product can support all major task systems |
| **Better Architecture** | Clean separation of concerns |
| **Testing** | Easy to mock providers for tests |
| **Competitive Advantage** | "Works with your existing tools" |

### Implementation Priority

**Phase 1 (MVP):** Convex provider only
- Build and validate provider interface
- Single implementation proves the pattern
- Get to market faster

**Phase 2:** Add Jira provider
- Most common enterprise ask
- Proves multi-provider architecture works
- Opens enterprise market

**Phase 3:** Add Asana, Linear, custom
- Based on customer demand
- Provider pattern makes this easy
- Each provider ~200 lines of code

---

## Technology Choice: Mastra Framework

**Decision:** Build with **Mastra** (TypeScript-native AI agent framework), self-hosted on Vercel

### Why Mastra Over Alternatives?

**Mastra vs Custom AI SDK Implementation:**
- ✅ **40% less code** (~600 lines vs ~1,100 lines)
- ✅ **Workflow orchestration built-in** (no custom state machine needed)
- ✅ **Agent framework included** (less boilerplate)
- ✅ **Observability tools** ready out-of-the-box
- ✅ **Human-in-the-loop** workflows native
- ✅ Same deployment model (Vercel, your existing stack)

**Mastra vs Managed Platforms (Agentuity, CrewAI Cloud):**
- ✅ **Self-hosted** - No platform fees
- ✅ **Full control** - Your infrastructure, your data
- ✅ **No vendor lock-in** - Open-source, deploy anywhere
- ✅ **TypeScript-native** - Perfect fit with Next.js
- ✅ **Predictable costs** - No surprise platform fees

**What You Get with Mastra:**
```
Built-in:
✅ Agent framework with reasoning & tool use
✅ Graph-based workflow orchestration
✅ Multi-model support (40+ providers)
✅ TypeScript-first with full type safety
✅ Production observability & monitoring
✅ Human-in-the-loop workflow suspension
✅ Local dev server for testing

What You Still Need:
🔨 MCP server (local bridge)
🔨 Convex integration (task storage)
🔨 Custom tools (MCP, E2B, GitHub)
```

### Architecture Benefits

| Aspect | Custom Build | Mastra Self-Hosted |
|--------|--------------|-------------------|
| Code to Write | ~1,100 lines | ~600 lines |
| Workflow Logic | Custom state machine | Built-in graph engine |
| Agent Coordination | Manual | Native multi-agent |
| Observability | Build from scratch | Included |
| Multi-step Reasoning | Implement yourself | Built-in |
| Model Switching | Manual | 40+ providers ready |
| Monthly Cost | $30-100 | $30-100 (same) |

---

## Target State: Hybrid Local/Cloud Architecture

### What Stays Local (Git-Versioned)

**Project Context & Knowledge** - These are historical, project-specific artifacts:

```
docflow/
├── context/
│   ├── overview.md        # Project vision (project-specific)
│   ├── stack.md           # Tech stack (evolves with project)
│   └── standards.md       # Code conventions (project-specific)
│
├── knowledge/
│   ├── decisions/         # ADRs (historical record)
│   ├── features/          # Complex feature docs
│   ├── notes/             # Project-specific gotchas
│   └── product/           # Personas, flows
│
└── specs/complete/        # Historical record of completed work
    └── YYYY-QQ/
```

**Why Local:**
- Version-controlled with code (git history matters)
- Project-specific knowledge
- Works offline
- No vendor lock-in
- Already perfect AI context

### What Moves to Cloud (SaaS)

**Active Work & Orchestration** - These are living, operational concerns:

```
Cloud System:
├── Active Tasks (BACKLOG → READY → IMPLEMENTING → etc.)
├── Task Assignment (local dev vs cloud agent)
├── Status Transitions & Validation
├── Workflow Templates (versioned, single source of truth)
├── Agent System Prompts (centralized, optimized)
├── Agent Orchestration Queue
└── Cross-Project Analytics
```

**Why Cloud:**
- Single source of truth for workflow logic
- Update once, affects all projects
- Enables cloud agent pool
- Multi-user/multi-agent coordination
- Analytics and insights
- Can scale independently

---

## Architecture: Cloud-Orchestrated, Locally-Grounded (Multi-Provider)

```
┌─────────────────────────────────────────────────────────┐
│     Task Provider Layer (Pluggable Backends)            │
│  ┌─────────┬─────────┬─────────┬─────────┬──────────┐  │
│  │ Convex  │  Jira   │ Asana   │ Linear  │  Custom  │  │
│  └─────────┴─────────┴─────────┴─────────┴──────────┘  │
│  All implement common TaskProvider interface            │
└─────────────────────────────────────────────────────────┘
                          ↕ TaskProvider Interface
┌─────────────────────────────────────────────────────────┐
│       Mastra Framework (Self-Hosted on Vercel)          │
│  • Three Agents (PM, Implementation, QE)                │
│  • Workflow orchestration (graph-based)                 │
│  • Tool definitions (TaskProvider, MCP, E2B, GitHub)    │
│  • Provider-agnostic task operations                    │
│  • Built-in observability and monitoring                │
│  • Multi-model support (OpenAI, Anthropic, etc.)        │
└─────────────────────────────────────────────────────────┘
                          ↕ MCP Tools
┌─────────────────────────────────────────────────────────┐
│              MCP Server (Local Bridge)                  │
│  • Bidirectional sync (cloud ↔ local)                  │
│  • Context provider (project files → agents)            │
│  • Local cache & offline queue                          │
│  • Git operations (PR creation)                         │
│  • Provider configuration discovery                     │
└─────────────────────────────────────────────────────────┘
                          ↕
┌─────────────────────────────────────────────────────────┐
│              Local Project (Git Repo)                   │
│  docflow/context/     (project knowledge)               │
│  docflow/knowledge/   (historical record)               │
│  .docflow/config.json (provider configuration)          │
│  .docflow.sync        (local cache, git-ignored)        │
└─────────────────────────────────────────────────────────┘
```

**Key Change:** Mastra workflows interact with an abstraction layer, not directly with Convex. This allows swapping task backends without changing workflow code.

---

## Key Decisions Made

### 1. Integration Point: Your Task Management System

**Decision:** DocFlow Cloud integrates with your existing Next.js 15 + Convex task management tool

**Implications:**
- Tasks live in your Convex database (not a separate system)
- DocFlow-specific fields added to your task schema
- Your UI becomes the central dashboard
- Workflow logic (state machine) lives in Convex functions

**Integration Points:**
```
Your Task Management System
├── Convex Schema: Add DocFlow fields
│   ├── status: TaskStatus (BACKLOG → READY → IMPLEMENTING → etc.)
│   ├── type: 'feature' | 'bug' | 'chore' | 'idea'
│   ├── assignedTo: 'local-dev' | 'cloud-agent' | string
│   ├── owner: 'PM' | 'Implementation' | 'QE' | 'User'
│   ├── acceptanceCriteria: Criterion[]
│   └── docflowMetadata: { templateVersion, projectId, etc. }
│
├── Convex Functions: Workflow State Machine
│   ├── tasks.transition(taskId, newStatus)  # Validates transitions
│   ├── tasks.assign(taskId, agent)          # Assigns to local/cloud
│   └── tasks.validate(taskId)               # Checks criteria completion
│
└── Convex HTTP API: For MCP Server
    ├── GET /api/tasks?project=X&status=Y
    ├── PATCH /api/tasks/:id
    └── POST /api/tasks
```

### 2. Communication Protocol: MCP (Model Context Protocol)

**Decision:** Use MCP as the bridge between local projects and cloud system

**Why MCP:**
- Universal (works with Cursor, Claude Desktop, VS Code, future tools)
- Designed for AI ↔ external system communication
- Bidirectional (cloud can push updates to local)
- Tool calling built-in (cloud agents can read/write local files)
- Industry standard (Anthropic, others converging)

**MCP Tools to Build:**
```typescript
// MCP Server exposes these tools to agents
{
  "docflow_sync_tasks": "Pull active tasks from Convex to local cache",
  "docflow_get_context": "Get project context (overview, stack, standards)",
  "docflow_update_spec": "Update task in Convex with implementation notes",
  "docflow_create_task": "Create new task in Convex",
  "docflow_get_knowledge": "Search local knowledge base",
  "docflow_create_pr": "Create GitHub PR with changes"
}
```

### 3. Cloud Agent Implementation: Mastra Framework (Self-Hosted)

**Decision:** Build cloud agents with Mastra framework, deploy to Vercel alongside Next.js app

**Why Mastra:**
- **TypeScript-native**: Perfect fit with Next.js 15 stack
- **Built-in agent framework**: Less boilerplate than AI SDK
- **Workflow orchestration**: Graph-based workflow engine (eliminates custom state machine code)
- **Multi-model support**: 40+ providers (OpenAI, Anthropic, Gemini, etc.)
- **Tool calling**: Native support, maps perfectly to MCP tools
- **Human-in-the-loop**: Built-in workflow suspension for approvals
- **Observability**: Production monitoring and evaluation tools included
- **Self-hosted**: Deploy to Vercel, no platform lock-in
- **No additional platform costs**: Open-source, runs in your infrastructure

**Architecture:**
```
Next.js App (Vercel)
├── app/                       # Your task management UI
├── mastra/                    # Mastra agents & workflows
│   ├── agents/               # PM, Implementation, QE
│   ├── workflows/            # DocFlow lifecycle orchestration
│   └── tools/                # MCP bridge, E2B, GitHub
└── convex/                   # Task storage & state

Flow:
Mastra Agents (in Next.js)
  → Mastra Workflows (orchestration)
    → Mastra Tools (call MCP server)
      → E2B for code execution
        → GitHub for PRs
          → Convex for state updates
```

**Why E2B:**
- Secure code execution sandboxes
- Multiple language support (TypeScript, Python, etc.)
- Fast spin-up
- Integrates well with Mastra tools

**Comparison to Alternatives:**
- **vs Vercel AI SDK**: Mastra includes workflow orchestration, observability, and agent framework (40% less code)
- **vs Agentuity/CrewAI**: Self-hosted means no platform fees, full control, deploy anywhere
- **vs Custom Build**: Production-ready features out of the box

**Migration Path:** Can optionally use Mastra Cloud later for enhanced observability, but start self-hosted for control and cost predictability

### 4. Local Files Stay Authoritative

**Decision:** Local git repo is always the source of truth for project context

**Why:**
- Git history is invaluable
- Offline work must be possible
- No vendor lock-in
- Code and context live together

**Cloud is only for:**
- Active task orchestration (temporary state)
- Workflow rules (can be cached locally)
- Agent coordination

### 5. Cursor CLI Role: Local Automation Only

**Decision:** Use Cursor CLI for local development automation, not cloud orchestration

**Use Cases:**
- CI/CD integration (trigger local agent checks)
- Scripted workflows (`cursor-cli agent --query "activate task X"`)
- Local testing of agent behaviors
- Developer convenience commands

**NOT for:**
- Running cloud agents (use Next.js API routes with AI SDK)
- Production task orchestration (use Convex actions)
- Multi-agent coordination (handled by your Next.js app)

---

## Integration with Your Task Management System

### Convex Schema Extensions

```typescript
// Your existing task schema + DocFlow additions
export const tasks = defineTable({
  // Your existing fields
  title: v.string(),
  description: v.string(),
  projectId: v.id("projects"),
  assigneeId: v.optional(v.string()),
  
  // DocFlow-specific additions
  docflow: v.optional(v.object({
    type: v.union(
      v.literal("feature"),
      v.literal("bug"),
      v.literal("chore"),
      v.literal("idea")
    ),
    status: v.union(
      v.literal("BACKLOG"),
      v.literal("READY"),
      v.literal("IMPLEMENTING"),
      v.literal("REVIEW"),
      v.literal("QE_TESTING"),
      v.literal("COMPLETE")
    ),
    owner: v.union(
      v.literal("PM"),
      v.literal("Implementation"),
      v.literal("QE"),
      v.literal("User")
    ),
    assignedTo: v.string(), // '@username', 'cloud-agent', 'Unassigned'
    complexity: v.optional(v.union(
      v.literal("S"),
      v.literal("M"),
      v.literal("L"),
      v.literal("XL")
    )),
    templateVersion: v.string(),
    acceptanceCriteria: v.array(v.object({
      id: v.string(),
      description: v.string(),
      completed: v.boolean(),
    })),
    implementationNotes: v.optional(v.string()),
    reviewNotes: v.optional(v.string()),
    qeNotes: v.optional(v.string()),
  })),
})
  .index("by_project_status", ["projectId", "docflow.status"])
  .index("by_assignee", ["docflow.assignedTo"]);
```

### Convex Functions for State Machine

```typescript
// convex/tasks/docflow.ts

// Validate state transitions
export const transition = mutation({
  args: { taskId: v.id("tasks"), newStatus: v.string() },
  handler: async (ctx, { taskId, newStatus }) => {
    const task = await ctx.db.get(taskId);
    if (!task?.docflow) throw new Error("Not a DocFlow task");
    
    // State machine validation
    const validTransitions = {
      BACKLOG: ["READY"],
      READY: ["IMPLEMENTING"],
      IMPLEMENTING: ["REVIEW", "BACKLOG"],
      REVIEW: ["QE_TESTING", "IMPLEMENTING"],
      QE_TESTING: ["COMPLETE", "IMPLEMENTING"],
      COMPLETE: [],
    };
    
    const allowed = validTransitions[task.docflow.status];
    if (!allowed.includes(newStatus)) {
      throw new Error(`Invalid transition: ${task.docflow.status} → ${newStatus}`);
    }
    
    await ctx.db.patch(taskId, {
      "docflow.status": newStatus,
      "docflow.owner": getOwnerForStatus(newStatus),
    });
  },
});

// Assign to cloud agent
export const assignToAgent = mutation({
  args: { taskId: v.id("tasks"), agentType: v.string() },
  handler: async (ctx, { taskId, agentType }) => {
    // Add to agent queue (separate table or Convex scheduler)
    await ctx.db.insert("agentQueue", {
      taskId,
      agentType,
      status: "queued",
      queuedAt: Date.now(),
    });
    
    await ctx.db.patch(taskId, {
      "docflow.assignedTo": "cloud-agent",
    });
  },
});
```

### HTTP Endpoints for MCP Server

```typescript
// convex/http.ts

import { httpRouter } from "convex/server";
import { httpAction } from "./_generated/server";

const http = httpRouter();

// GET /api/docflow/tasks?projectId=X&status=Y
http.route({
  path: "/api/docflow/tasks",
  method: "GET",
  handler: httpAction(async (ctx, request) => {
    const url = new URL(request.url);
    const projectId = url.searchParams.get("projectId");
    const status = url.searchParams.get("status");
    
    // Auth: Verify API key from header
    const apiKey = request.headers.get("x-docflow-api-key");
    // ... validate apiKey against projects table
    
    const tasks = await ctx.runQuery(internal.tasks.list, {
      projectId,
      status,
    });
    
    return new Response(JSON.stringify(tasks), {
      headers: { "Content-Type": "application/json" },
    });
  }),
});

export default http;
```

---

## Cloud Agent Implementation with Mastra Framework

### Why Mastra is Perfect for Your Use Case

You're already using **Next.js 15 + Convex**. Mastra is a TypeScript-native framework that enhances this stack:

1. **Agent Framework** - Built-in agent creation with reasoning and tool use
2. **Workflow Orchestration** - Graph-based workflows replace custom state machines
3. **Tool Calling** - Native tool system maps perfectly to your MCP tools
4. **Multi-Step Reasoning** - Agents can plan and execute complex multi-step tasks
5. **Type Safety** - Full TypeScript support throughout
6. **Model Flexibility** - 40+ providers (OpenAI, Anthropic, Gemini, etc.)
7. **Human-in-the-Loop** - Built-in workflow suspension for approvals
8. **Observability** - Production monitoring and evaluation tools included

### Architecture: Mastra vs Alternatives

**Why Mastra over Vercel AI SDK?**

| Feature | Vercel AI SDK | Mastra Framework | Advantage |
|---------|---------------|------------------|-----------|
| Agent Framework | Build custom | Built-in | ✅ Less code |
| Workflow Orchestration | Build custom | Graph-based engine | ✅ Eliminates custom logic |
| Multi-Agent Coordination | Manual | Native support | ✅ Built-in |
| Observability | Build custom | Included | ✅ Production-ready |
| Human-in-Loop | Build custom | Built-in | ✅ Native feature |
| Tool Calling | ✅ Yes | ✅ Yes | Equal |
| Next.js Integration | ✅ Native | ✅ Native | Equal |
| Self-Hosted | ✅ Yes | ✅ Yes | Equal |

**What you get:**
- ✅ Convex = your task storage and data layer
- ✅ Next.js = your UI and API layer
- ✅ **Mastra = your agent framework + workflow orchestration**

**Code reduction:**
- Vercel AI SDK approach: ~1,100 lines
- **Mastra approach: ~600 lines** (40% less code)

You eliminate the need to build custom workflow orchestration, agent coordination, and observability infrastructure.

### Implementation Example

**Step 1: Define Mastra Tools (Your MCP Bridge)**

```typescript
// mastra/tools/index.ts
import { createTool } from '@mastra/core';
import { z } from 'zod';

export const getContextTool = createTool({
  id: 'get-context',
  description: 'Get project context files from local repository via MCP',
  inputSchema: z.object({
    projectId: z.string(),
    files: z.array(z.enum(['overview', 'stack', 'standards']))
  }),
  execute: async ({ context, input }) => {
    // Call your MCP server
    const response = await fetch('http://localhost:3000/mcp', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        tool: 'docflow_get_context',
        params: { projectId: input.projectId, files: input.files }
      })
    });
    return await response.json();
  }
});

export const executeCodeTool = createTool({
  id: 'execute-code',
  description: 'Execute code in secure E2B sandbox',
  inputSchema: z.object({
    code: z.string(),
    language: z.enum(['typescript', 'python', 'javascript'])
  }),
  execute: async ({ input }) => {
    // Call E2B
    const sandbox = await E2B.create({ language: input.language });
    const result = await sandbox.runCode(input.code);
    await sandbox.close();
    return result;
  }
});

export const createPRTool = createTool({
  id: 'create-pr',
  description: 'Create GitHub pull request with implementation',
  inputSchema: z.object({
    taskId: z.string(),
    branch: z.string(),
    files: z.array(z.object({
      path: z.string(),
      content: z.string()
    })),
    title: z.string(),
    description: z.string()
  }),
  execute: async ({ input }) => {
    // Call MCP server to create PR
    const response = await fetch('http://localhost:3000/mcp', {
      method: 'POST',
      body: JSON.stringify({
        tool: 'docflow_create_pr',
        params: input
      })
    });
    return await response.json();
  }
});

export const updateTaskTool = createTool({
  id: 'update-task',
  description: 'Update task status and notes in Convex',
  inputSchema: z.object({
    taskId: z.string(),
    status: z.string().optional(),
    implementationNotes: z.string().optional(),
    reviewNotes: z.string().optional()
  }),
  execute: async ({ input }) => {
    const { taskId, ...updates } = input;
    // Update Convex via HTTP API
    const response = await fetch(`${process.env.CONVEX_URL}/api/tasks/${taskId}`, {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(updates)
    });
    return await response.json();
  }
});
```

**Step 2: Define Agents**

```typescript
// mastra/agents/implementation.ts
import { Agent } from '@mastra/core';
import { anthropic } from '@mastra/anthropic';
import { getContextTool, executeCodeTool, createPRTool, updateTaskTool } from '../tools';

export const implementationAgent = new Agent({
  name: 'Implementation Agent',
  instructions: `You are an Implementation Agent in the DocFlow workflow system.

Your responsibilities:
1. Get project context (stack.md, standards.md) to understand patterns
2. Plan the implementation approach based on acceptance criteria
3. Write code following project standards and conventions
4. Test your implementation in an E2B sandbox
5. Create a pull request with your changes
6. Update the task with detailed implementation notes

Always:
- Follow the project's documented patterns from stack.md
- Adhere to coding standards from standards.md
- Write clear, maintainable code with proper error handling
- Include tests where appropriate
- Provide detailed PR descriptions`,

  model: anthropic('claude-3-5-sonnet-20241022'),
  
  tools: {
    getContext: getContextTool,
    executeCode: executeCodeTool,
    createPR: createPRTool,
    updateTask: updateTaskTool,
  },
  
  // Enable multi-step reasoning
  enableThinking: true,
});
```

**Step 3: Define Workflow (Provider-Agnostic)**

```typescript
// mastra/workflows/docflow.ts
import { Workflow } from '@mastra/core';
import { pmAgent } from '../agents/pm';
import { implementationAgent } from '../agents/implementation';
import { qeAgent } from '../agents/qe';
import { getTaskProvider } from '../providers';

export const docflowWorkflow = new Workflow({
  name: 'docflow-task-lifecycle',
  
  triggerSchema: z.object({
    taskId: z.string(),
    action: z.enum(['refine', 'implement', 'review']),
    projectId: z.string(),
  }),
  
  execute: async ({ trigger, step }) => {
    const { taskId, action, projectId } = trigger;
    
    // Get configured provider for this project
    const taskProvider = await getTaskProvider(projectId);
    
    // Fetch task from provider (could be Convex, Jira, Asana, etc.)
    const task = await step.run('fetch-task', async () => {
      return await taskProvider.getTask(taskId);
    });
    
    if (action === 'implement') {
      // Update status to IMPLEMENTING (provider handles the details)
      await step.run('update-status-implementing', async () => {
        await taskProvider.transitionStatus(taskId, 'IMPLEMENTING');
      });
      
      // Run implementation agent
      const implementation = await step.agent('implementation', {
        agent: implementationAgent,
        input: `
Task: ${task.title}
Type: ${task.type}
Complexity: ${task.metadata.complexity}

Acceptance Criteria:
${task.acceptanceCriteria.map((c, i) => `${i + 1}. ${c.description}`).join('\n')}

Technical Notes:
${task.implementationNotes || 'None provided'}

External Link: ${task.metadata.externalUrl || 'N/A'}

Implement this feature following the project's standards and patterns.
        `.trim()
      });
      
      // Update status to REVIEW and add implementation notes
      await step.run('update-status-review', async () => {
        await taskProvider.updateTask(taskId, {
          status: 'REVIEW',
          implementationNotes: implementation.text
        });
      });
      
      return { 
        success: true, 
        prUrl: implementation.toolResults?.createPR?.url,
        taskUrl: task.metadata.externalUrl  // Link back to source system
      };
    }
    
    // Similar patterns for 'refine' and 'review' actions...
  }
});
```

**Key Difference:** The workflow now uses `taskProvider` abstraction instead of direct Convex API calls. This same workflow code works with any task backend.

**Step 4: Initialize Mastra App**

```typescript
// mastra/index.ts
import { Mastra } from '@mastra/core';
import { pmAgent } from './agents/pm';
import { implementationAgent } from './agents/implementation';
import { qeAgent } from './agents/qe';
import { docflowWorkflow } from './workflows/docflow';

export const mastra = new Mastra({
  agents: {
    pm: pmAgent,
    implementation: implementationAgent,
    qe: qeAgent,
  },
  
  workflows: {
    docflow: docflowWorkflow,
  },
  
  // Optional: Connect to Mastra Cloud for observability
  // sync: {
  //   apiKey: process.env.MASTRA_API_KEY,
  // }
});
```

**Step 5: Expose Mastra via Next.js API**

```typescript
// app/api/mastra/route.ts
import { mastra } from '@/mastra';

// This creates API endpoints for agents and workflows
export const { POST, GET } = mastra.createHandler();
```

**Step 6: Trigger Workflows from Convex**

```typescript
// convex/crons.ts
import { cronJobs } from "convex/server";
import { internal } from "./_generated/api";

const crons = cronJobs();

// Poll agent queue every 30 seconds
crons.interval(
  "process-agent-queue",
  { seconds: 30 },
  internal.agents.processQueue
);

export default crons;
```

```typescript
// convex/agents.ts
import { internalAction } from "./_generated/server";
import { internal } from "./_generated/api";

export const processQueue = internalAction(async (ctx) => {
  // Get tasks assigned to cloud agents
  const tasks = await ctx.runQuery(internal.tasks.getCloudAgentTasks);
  
  for (const task of tasks) {
    // Determine action based on status
    let action = 'implement';
    if (task.docflow.status === 'BACKLOG') action = 'refine';
    if (task.docflow.status === 'REVIEW') action = 'review';
    
    // Trigger Mastra workflow via API
    try {
      await fetch(`${process.env.NEXT_PUBLIC_URL}/api/mastra/workflows/docflow`, {
        method: 'POST',
        headers: { 
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${process.env.AGENT_API_KEY}`
        },
        body: JSON.stringify({ 
          taskId: task._id,
          action 
        })
      });
    } catch (error) {
      console.error(`Failed to trigger workflow for task ${task._id}:`, error);
    }
  }
});
```

### Cost Comparison

**Option A: Mastra (Self-Hosted)**
- Next.js hosting: $0 (Vercel free tier) or $20/mo
- Convex: $0 (free tier) or $25/mo
- E2B: $10-50/mo (based on usage)
- LLM API calls: ~$0.01-0.10 per task
- Mastra framework: $0 (open-source)
- **Total: ~$30-100/mo**

**Option B: Mastra Cloud**
- Mastra Cloud platform: TBD (currently in beta)
- Next.js hosting: $0 or $20/mo
- Convex: $0 or $25/mo
- LLM API calls: Same as above
- Built-in observability included
- **Total: TBD + ~$30-100/mo**

**Option C: Agentuity/CrewAI**
- Platform fees: Unknown (contact sales)
- LLM API calls: Same as above
- E2B: Same as above
- **Total: ??? (likely $200+/mo)**

### Benefits of Mastra Self-Hosted Approach

1. **Best of both worlds** - Framework power + full control
2. **40% less code** than custom AI SDK implementation
3. **Workflow orchestration** built-in (no custom state machine)
4. **Observability tools** included
5. **No platform fees** (open-source, self-hosted)
6. **No vendor lock-in** - deploy to Vercel, Railway, or any Node.js host
7. **TypeScript-native** - Perfect fit with your stack
8. **Easy debugging** - It's your infrastructure
9. **Faster iteration** - Deploy to Vercel in seconds
10. **Future flexibility** - Can migrate to Mastra Cloud later if needed

---

## Mastra Cloud: Optional Future Enhancement

### What is Mastra Cloud?

Mastra Cloud is a **managed platform** for Mastra applications, similar to how Vercel hosts Next.js apps. It provides:

- **Zero-configuration deployment** - Push to GitHub, auto-deploy
- **Enhanced observability** - Visual workflow debugger, agent execution logs
- **Built-in playground** - Test agents via web UI
- **Cost tracking** - Per-agent and per-workflow usage monitoring
- **Evaluation tools** - Agent performance metrics and optimization

### Why Start Self-Hosted?

**Start self-hosted on Vercel because:**

1. **Data Control** - Your task/project data stays in your infrastructure
2. **Cost Predictability** - Mastra Cloud pricing not yet published (in beta)
3. **No Additional Platform** - Already have Vercel + Convex
4. **Full Control** - Own your deployment and infrastructure
5. **No Lock-In** - Can migrate to Mastra Cloud later without code changes

### When to Consider Mastra Cloud?

**Evaluate Mastra Cloud after MVP if you need:**

- **Better Debugging** - Visual workflow execution debugger
- **Team Collaboration** - Shared playground for testing agents
- **Advanced Analytics** - Deeper insights into agent performance
- **Easier Scaling** - Let platform handle infrastructure
- **Cost Attribution** - Detailed per-workflow cost breakdowns

### Hybrid Approach (Best of Both Worlds)

```
Development: Mastra Cloud
- Fast iteration with visual debugging
- Team collaboration on agent development
- Playground for testing workflows

Production: Self-Hosted (Vercel)
- Data privacy and control
- Predictable costs
- Your infrastructure
```

**Migration is seamless** - Same Mastra code runs in both environments.

---

## Before & After: What Changed

### Original Plan (Vercel AI SDK)

```typescript
// You would have built:
app/api/agents/pm/route.ts           (~100 lines)
app/api/agents/implementation/route.ts (~100 lines)
app/api/agents/qe/route.ts           (~100 lines)
lib/ai/tools.ts                      (~200 lines)
lib/workflow/state-machine.ts        (~150 lines)
lib/observability/logging.ts         (~100 lines)
convex/agents.ts                     (~150 lines)
convex/crons.ts                      (~50 lines)
@docflow/mcp-server/                 (~500 lines)
─────────────────────────────────────────────────
Total: ~1,450 lines + ongoing maintenance
```

### New Plan (Mastra Self-Hosted)

```typescript
// You will build:
mastra/agents/pm.ts                  (~40 lines)
mastra/agents/implementation.ts      (~50 lines)
mastra/agents/qe.ts                  (~40 lines)
mastra/workflows/docflow.ts          (~120 lines)
mastra/tools/index.ts                (~150 lines)
mastra/index.ts                      (~20 lines)
app/api/mastra/route.ts              (~10 lines)
convex/agents.ts                     (~100 lines)
convex/crons.ts                      (~50 lines)
@docflow/mcp-server/                 (~300 lines)
─────────────────────────────────────────────────
Total: ~880 lines (40% reduction)

What you DON'T need to build:
❌ Custom state machine (Mastra workflows)
❌ Custom agent coordination (Mastra agents)
❌ Custom observability (Mastra built-in)
❌ Multi-step reasoning logic (Mastra native)
❌ Tool calling infrastructure (Mastra tools)
```

### What You Gain

| Feature | Before (AI SDK) | After (Mastra) |
|---------|----------------|----------------|
| Workflow State Machine | Custom code (~150 lines) | Built-in graph engine |
| Agent Coordination | Manual implementation | Native multi-agent |
| Multi-Step Reasoning | Custom `maxSteps` logic | Built-in with `enableThinking` |
| Observability | Build from scratch | Production-ready included |
| Human-in-Loop | Custom workflow suspension | Native `step.waitForInput()` |
| Tool Definitions | Custom wrapper pattern | Mastra `createTool()` |
| Model Switching | Manual provider setup | 40+ providers ready |
| Local Testing | Build test harness | Mastra dev server included |
| Workflow Visualization | Not available | Mastra Studio (optional) |

---

## How It Works: Key Flows

### Flow 1: Developer Creates Task (Local Agent)

```
1. User in Cursor: "capture feature: user dashboard"

2. Local agent (via MCP) calls:
   docflow_create_task({
     type: 'feature',
     title: 'User dashboard',
     projectId: 'abc123'
   })

3. MCP Server → Convex HTTP API:
   POST /api/docflow/tasks
   {
     projectId: 'abc123',
     docflow: {
       type: 'feature',
       status: 'BACKLOG',
       assignedTo: 'Unassigned',
       ...
     }
   }

4. Convex creates task, returns taskId

5. MCP server updates local cache (.docflow.sync)

6. Agent confirms: "✅ Created task: feature-user-dashboard"
```

### Flow 2: PM Activates Task for Cloud Agent

```
1. User: "activate user-dashboard, assign to cloud agent"

2. Local PM agent (via MCP):
   docflow_assign_task({
     taskId: 'xyz789',
     assignedTo: 'cloud-agent'
   })

3. Convex:
   - Updates task: status=READY, assignedTo='cloud-agent'
   - Adds to agentQueue table

4. Convex cron (every 30s) sees new task in queue

5. Convex triggers Mastra workflow via HTTP:
   POST /api/mastra/workflows/docflow
   { taskId: 'xyz789', action: 'implement' }

6. Mastra Workflow executes (on Vercel):
   
   Step 1: Fetch task from Convex
   Step 2: Update status to IMPLEMENTING
   Step 3: Run Implementation Agent
     → Agent calls tools:
       a. getContext(projectId, ['stack', 'standards']) via MCP
       b. executeCode(code) via E2B sandbox
       c. createPR(taskId, files) via MCP
       d. updateTask(status=REVIEW, notes)
   Step 4: Update Convex status to REVIEW

7. Webhook/notification → local dev

8. Dev reviews PR in GitHub
```

### Flow 3: Workflow Update (Agent & Workflow Evolution)

```
1. Admin updates Mastra workflow (e.g., add approval step)

2. Update workflow code in Next.js app:
   mastra/workflows/docflow.ts
   - Add new step between implementation and review
   - Add human-in-loop checkpoint

3. Deploy to Vercel:
   git push origin main
   → Vercel auto-deploys

4. All projects immediately use new workflow:
   - Next task processed uses updated workflow
   - No client-side changes needed
   - Workflow versioning in git history

5. For agent prompt updates:
   - Update mastra/agents/implementation.ts
   - Commit changes with version tag
   - Deploy to Vercel

6. Optional: Store workflow templates in Convex
   - Enables per-project workflow customization
   - Projects can pin to specific workflow version
   - MCP can fetch custom workflow configs
```

---

## Components to Build

### 1. Task Provider Abstraction Layer

**New Component:** `lib/task-providers/`

**Core Responsibilities:**
- Define TaskProvider interface (standard contract)
- Implement provider factory pattern
- Normalize task data across systems
- Handle provider-specific mappings

**Key Files:**
```
lib/task-providers/
├── types.ts              # TaskProvider interface, DocFlowTask type
├── factory.ts            # TaskProviderFactory
├── convex-provider.ts    # Convex implementation (Phase 1)
├── jira-provider.ts      # Jira implementation (Phase 2)
├── asana-provider.ts     # Asana implementation (Phase 3)
├── linear-provider.ts    # Linear implementation (Phase 3)
└── mock-provider.ts      # For testing
```

**Estimated Code:** 
- Interface & factory: ~100 lines
- Convex provider: ~200 lines
- Each additional provider: ~200 lines

### 2. Convex Provider Implementation

**If using Convex as your task backend:**

**Additions Needed:**
- [ ] Add `docflow` field to task schema
- [ ] Implement state machine validation (transition function)
- [ ] Create agent queue table (for cloud agent assignments)
- [ ] Add HTTP endpoints for provider to call
- [ ] Add API key authentication for external access
- [ ] Implement ConvexTaskProvider class

**Estimated Code:** ~100 lines schema + ~200 lines provider = ~300 lines

**If using Jira/Asana/other:**

Skip Convex schema changes, implement appropriate provider instead.

### 3. MCP Server (Local Bridge)

**New Package:** `@docflow/mcp-server`

**Responsibilities:**
- Expose MCP tools to local AI agents (Cursor, Claude, etc.)
- **Discover and provide provider configuration** to Mastra
- Sync tasks from any provider to local cache
- Provide project context to Mastra agents
- Create GitHub PRs
- Handle offline mode (queue operations when cloud unreachable)

**Key Files:**
```
@docflow/mcp-server/
├── src/
│   ├── server.ts           # MCP protocol implementation
│   ├── tools/
│   │   ├── sync.ts         # docflow_sync_tasks (provider-agnostic)
│   │   ├── context.ts      # docflow_get_context
│   │   ├── config.ts       # docflow_get_provider_config (NEW)
│   │   ├── tasks.ts        # docflow_create_task, update_task
│   │   └── git.ts          # docflow_create_pr
│   ├── cache/
│   │   └── sqlite.ts       # Local cache (SQLite)
│   ├── providers/
│   │   └── client.ts       # Uses TaskProvider interface
│   └── config/
│       └── reader.ts       # Reads .docflow/config.json
├── cli.ts                  # CLI: docflow init, sync, upgrade
└── package.json
```

**Estimated Code:** ~350 lines (includes provider config discovery)

### 4. Mastra Framework Integration

**New Directory:** `mastra/`

**Components:**
```
mastra/
├── agents/
│   ├── pm.ts              # PM Agent definition
│   ├── implementation.ts  # Implementation Agent
│   └── qe.ts              # QE Agent
├── workflows/
│   └── docflow.ts         # Task lifecycle workflow (provider-agnostic)
├── tools/
│   ├── index.ts           # Tool exports
│   ├── mcp.ts             # MCP bridge tools
│   ├── e2b.ts             # Code execution
│   ├── github.ts          # PR creation
│   └── task-provider.ts   # TaskProvider abstraction tools
├── providers/
│   └── index.ts           # getTaskProvider() helper
└── index.ts               # Mastra app initialization
```

**Agent Types:**
```
PM Agent:
- Refines specs
- Clarifies requirements
- Activates tasks for implementation
- Uses: getContext, searchKnowledge, updateTask

Implementation Agent:
- Reads spec from Convex via workflow
- Gets context via MCP tools
- Executes code in E2B
- Creates PR via MCP
- Updates task status
- Uses: getContext, executeCode, createPR, updateTask

QE Agent:
- Reviews code in PR
- Tests implementation
- Works with user iteratively
- Marks acceptance criteria complete
- Uses: getContext, executeCode, updateTask
```

**Estimated Code:** ~250 lines (much less than custom AI SDK implementation)

### 4. Template Management (In Convex)

**Templates Table:**
```typescript
export const templates = defineTable({
  type: v.union(
    v.literal("feature"),
    v.literal("bug"),
    v.literal("chore"),
    v.literal("idea")
  ),
  version: v.string(),        // "2.1.0", "2.2.0"
  content: v.string(),        // Markdown template
  workflowRules: v.object({   // State machine definition
    states: v.array(v.string()),
    transitions: v.any(),
  }),
  agentPrompts: v.object({
    pm: v.string(),
    implementation: v.string(),
    qe: v.string(),
  }),
  isLatest: v.boolean(),
  createdAt: v.number(),
});
```

---

## Open Questions

### Platform Choice

1. **Mastra Self-Hosted vs Mastra Cloud**
   - **Decision:** Start self-hosted on Vercel
   - Evaluate Mastra Cloud later for enhanced observability
   - Can migrate workflows to Mastra Cloud without code changes
   - Pricing for Mastra Cloud needs clarity before commitment

### Technical

2. **Convex Real-Time Sync**
   - How should MCP server stay in sync with Convex? Polling? Convex subscriptions? Webhooks?
   - Convex has real-time subscriptions—should MCP server maintain WebSocket connection?

3. **Cloud Agent Authentication to GitHub**
   - How do cloud agents create PRs? GitHub App? Personal access token stored in Convex?
   - Should each project configure its own GitHub credentials?

4. **Conflict Resolution**
   - What if local dev and cloud agent edit same file simultaneously?
   - Should cloud agents always work on separate branches and require PR approval?

5. **Cost Management**
   - How to prevent runaway cloud agent costs?
   - Should there be per-task or per-project spending limits?
   - Track costs in Convex (token usage, execution time)?

6. **MCP Server Deployment**
   - Does MCP server run locally (npm install global) or as a service?
   - If service, where hosted? Same server as Next.js app?

7. **Mastra Multi-Step Reasoning & Workflow Limits**
   - How many steps should workflows allow before timeout?
   - Should we implement custom retry logic or use Mastra's built-in?
   - How to handle agents "getting stuck" in loops?
   - What timeout limits for each workflow step?

### Workflow

8. **Agent Assignment Logic**
   - How to decide: local dev vs cloud agent?
   - Should PM agent always decide, or auto-assign based on complexity?
   - Can users set preferences per project? (e.g., "always use cloud for chores")

9. **Offline Mode**
   - How long should local system work without cloud connection?
   - Should MCP server queue operations and sync when back online?
   - What operations are blocked offline? (Create task OK, assign to cloud agent not OK?)

10. **Template Versioning**
    - Should projects be able to test new template versions before committing?
    - Rollback mechanism if new version breaks something?
    - How to handle breaking changes in workflow states?

### Integration

11. **Existing Task Management UI**
    - How much DocFlow-specific UI to add to your task management system?
    - Separate "DocFlow mode" toggle, or always-on DocFlow fields?
    - Should your UI show agent execution logs?

12. **Multi-Project Dashboard**
    - Does your task management system already support multiple projects?
    - How to show DocFlow status across all projects in one view?
    - Filter by: status, assigned agent type, blocked tasks, etc.?

### Agent Execution

13. **E2B Sandbox Configuration**
    - What level of access should cloud agents have?
    - Network access: npm/git allowed, external APIs blocked?
    - File system: Read entire repo or just specific directories?
    - Execution timeout: 30 min max? Cost implications?

14. **Agent Context Size**
    - How much project context can cloud agents access via MCP?
    - Full knowledge base or just specific files?
    - Should agents search knowledge base or have it all loaded?

---

## Next Steps

### Immediate (Validation)

1. **Setup Mastra in Next.js Project**
   - Install `@mastra/core` and model packages
   - Create basic agent with one tool
   - Test locally with Mastra dev server
   - Validate: Can agent call tool and get response?

2. **Prototype MCP Server**
   - Build basic MCP server that exposes 2-3 tools
   - Test with Cursor: Can local agent call `docflow_sync_tasks`?
   - Validate MCP protocol understanding

3. **Extend Convex Schema**
   - Add `docflow` field to your task schema
   - Implement basic state machine validation
   - Add HTTP endpoint for Mastra to call
   - Test via your existing UI

### Short-Term (MVP)

4. **Build Three Mastra Agents**
   - PM Agent (refine specs)
   - Implementation Agent (write code)
   - QE Agent (review/test)
   - Test each agent individually

5. **Build DocFlow Workflow**
   - Create graph-based workflow in Mastra
   - Orchestrate three agents (PM → Implementation → QE)
   - Add human-in-loop checkpoints
   - Test complete lifecycle with mock task

6. **Build Core MCP Tools & Integration**
   - `docflow_sync_tasks` (pull from Convex)
   - `docflow_get_context` (read local files)
   - `docflow_create_task` (create in Convex)
   - `docflow_create_pr` (GitHub integration)
   - Connect Mastra tools to MCP server

7. **Deploy to Vercel**
   - Deploy Next.js app with Mastra agents
   - Test cloud agent execution
   - Validate end-to-end flow with real task

### Medium-Term (Full Integration)

7. **Template Management in Convex**
   - Store templates with versioning
   - MCP tool: `docflow_get_template`
   - Upgrade mechanism

8. **Agent Queue & Orchestration**
   - Convex table: agentQueue
   - Agentuity polling or webhook
   - Assignment logic (manual vs auto)

9. **Analytics & Monitoring**
   - Track agent executions (time, cost, success rate)
   - Task flow metrics (avg time per status)
   - Dashboard in your task management UI

---

## Success Criteria

**We'll know this is working when:**

1. ✅ Local agent in Cursor can create task that appears in Convex
2. ✅ Cloud agent can implement simple task end-to-end without human intervention
3. ✅ Workflow rules can be updated in one place (Convex) and propagate to all projects
4. ✅ Local developer can review cloud agent's PR and merge or request changes
5. ✅ System works offline (local agents can work, cloud tasks queued)
6. ✅ Analytics show cloud agents completing 20%+ of tasks

---

## Resources & References

### Agent Platforms Evaluated

- **Mastra** (https://mastra.ai) - **SELECTED** - TypeScript-native agent framework
- **Vercel AI SDK** - Considered, but Mastra provides more out-of-the-box features
- **Agentuity** (https://agentuity.com) - Alternative for managed orchestration
- **CrewAI Flows** (https://crewai.com) - Alternative if more customization needed
- **E2B** (https://e2b.dev) - Code execution sandboxes (using)

### Technologies in Use

- **Mastra Framework** - Agent framework, workflow orchestration, observability
- **MCP (Model Context Protocol)** - Anthropic's standard for AI ↔ external systems
- **Convex** - Your existing backend (real-time DB + serverless functions)
- **Next.js 15** - Your existing frontend + Mastra host
- **E2B** - Secure code execution for implementation agents
- **Vercel** - Deployment platform (self-hosted Mastra)

### Related Reading

- **Mastra Documentation**: https://mastra.ai/docs
- **Mastra GitHub**: https://github.com/mastra-ai/mastra
- **Mastra Templates**: https://mastra.ai/templates (including MCP examples)
- MCP Documentation: https://modelcontextprotocol.io/
- Convex Real-Time Subscriptions: https://docs.convex.dev/client/react/useQuery
- E2B Docs: https://e2b.dev/docs
- Vercel AI SDK (alternative): https://sdk.vercel.ai/docs

---

## Summary: Mastra-First Architecture

### What You Have

✅ **Next.js 15** - Perfect for hosting Mastra agents  
✅ **Convex** - Your task storage and state management  
✅ **Task Management UI** - Just extend with DocFlow fields  
✅ **Understanding of workflow** - Three-agent model is clear  

### What You Need to Build

🔨 **Task Provider Abstraction** (~300 lines)
- `lib/task-providers/types.ts` (interface definition)
- `lib/task-providers/factory.ts` (provider factory)
- `lib/task-providers/convex-provider.ts` (initial implementation)
- Future providers: ~200 lines each (Jira, Asana, etc.)

🔨 **Mastra Agents & Workflows** (~250 lines)
- `mastra/agents/pm.ts`
- `mastra/agents/implementation.ts`
- `mastra/agents/qe.ts`
- `mastra/workflows/docflow.ts` (provider-agnostic)
- Much simpler than custom AI SDK routes

🔨 **Mastra Tools** (~150 lines)
- Wrappers around MCP calls
- E2B integration
- GitHub PR creation
- TaskProvider integration

🔨 **MCP Server** (~350 lines)
- Bridge between Mastra agents and local projects
- Provider configuration discovery
- Context provision to cloud agents
- Git operations

🔨 **Convex Schema (if using Convex)** (~100 lines)
- Add `docflow` field to task schema
- State machine validation (simplified with Mastra workflows)
- Cron to poll queue

**Total: ~900-1,000 lines of code for MVP (includes provider abstraction)**

**Note:** Provider abstraction adds ~200 lines upfront but pays dividends:
- Adding Jira provider: +200 lines (vs rewriting entire system)
- Adding Asana provider: +200 lines (vs building from scratch)
- Each new provider is isolated, clean, testable

### Recommended Tech Choices

| Component | Choice | Why |
|-----------|--------|-----|
| **Agent Framework** | Mastra (Self-Hosted) | TypeScript-native, workflow orchestration built-in |
| **Task Backend** | Provider Abstraction | Support Convex, Jira, Asana, Linear, custom |
| **Initial Provider** | Convex | Fast to build, real-time, works with existing stack |
| **Code Execution** | E2B | Secure sandboxes, integrates with Mastra tools |
| **Local Bridge** | Custom MCP Server | Universal, works with all AI tools, provider discovery |
| **Orchestration** | Mastra Workflows | Graph-based, provider-agnostic, eliminates custom state machine |
| **Deployment** | Vercel | Your existing platform, deploy with Next.js app |
| **Observability** | Mastra Built-in | Production-ready monitoring included |
| **Optional** | Mastra Cloud | Evaluate later for enhanced features |

### Cursor CLI Role

Use it for:
- ✅ Local development automation
- ✅ CI/CD integration (run checks before PR)
- ✅ Scripting common workflows
- ✅ Testing agent behaviors locally

Don't use it for:
- ❌ Cloud agent orchestration (use Next.js API routes)
- ❌ Production workflows (use Convex)
- ❌ Multi-agent coordination (handled by your app)

### Phase 0: Validate Before Building

Before writing 600-700 lines of code:

1. **Test Mastra Framework** (1-2 days)
   - Install Mastra in Next.js project
   - Create one simple agent with one tool
   - Test locally with Mastra dev server
   - Verify agent can reason and use tools

2. **Test Mastra Workflows** (1 day)
   - Create simple 2-step workflow
   - Test workflow execution
   - Verify step transitions work correctly

3. **Test E2B** (1 day)
   - Run simple code execution
   - Verify sandboxing works
   - Check pricing

4. **Test MCP Protocol** (2-3 days)
   - Build minimal MCP server (2 tools)
   - Test with local Cursor agent
   - Verify Mastra agent can call MCP tools

**If all four work: Build the full system**  
**If any fail: Fall back to Vercel AI SDK or reconsider approach**

### Migration Path

**Phase 0: Validation (Week 1)**
- Install Mastra in Next.js project
- Create one simple agent with tool
- Build minimal MCP server (2 tools)
- Test Mastra workflow execution
- **Build TaskProvider interface** (validate abstraction pattern)
- Verify E2B integration
- **Go/No-Go decision**

**MVP (Week 2-5):**
- **Build TaskProvider abstraction layer**
  - Define interface and types
  - Implement provider factory
  - Create Convex provider (or Jira if preferred)
- Extend Convex schema with DocFlow fields (if using Convex)
- Build three Mastra agents (PM, Implementation, QE)
- **Create provider-agnostic DocFlow workflow**
- Build full MCP tool suite (including provider config discovery)
- Implement provider discovery in MCP server
- Deploy to Vercel
- Test end-to-end with real task

**V1 (Week 6-9):**
- Refine agent prompts based on testing
- Add more sophisticated workflow branches
- Implement human-in-loop checkpoints
- Convex cron for automatic task processing
- Basic cost tracking and monitoring

**V2 (Week 10-13):**
- Template management in Convex
- Multi-project dashboard
- Enhanced analytics and insights
- Agent performance evaluation
- Workflow versioning

**Later (Optional):**
- Evaluate Mastra Cloud for enhanced observability
- Add more agent types (Security, Documentation, etc.)
- Implement cross-project agent coordination
- Advanced workflow patterns (parallel execution, retries)

---

**Last Updated:** November 23, 2024  
**Status:** Planning - Ready to implement MVP  
**Recommended Approach:** Mastra Framework (self-hosted on Vercel) + TaskProvider Abstraction

**Key Benefits:**
- ✅ Works with **any task system** (Convex, Jira, Asana, Linear, custom)
- ✅ Provider abstraction forces clean architecture
- ✅ Built-in workflow orchestration (eliminates custom state machine)
- ✅ Production observability included
- ✅ No platform fees (self-hosted)
- ✅ No vendor lock-in (to Mastra OR to task backend)
- ✅ TypeScript-native, perfect fit with Next.js stack
- ✅ Per-project provider configuration
- ✅ Easy to add new providers (~200 lines each)
- ✅ Multi-tenant ready (different customers, different backends)

**Architectural Decision: Provider Abstraction Upfront**

Even though we're starting with Convex, we're building the provider abstraction layer from day one because:

1. **Forces better architecture** - Workflows can't be coupled to Convex-specific details
2. **Easy to add providers** - Jira/Asana providers are just ~200 lines each
3. **Testing** - Mock provider makes testing trivial
4. **Product flexibility** - "Works with your existing tools" is a differentiator
5. **Small overhead** - Only adds ~200 lines to MVP, saves 1000s later
6. **Future-proof** - Migration between systems is config change, not rewrite

**Next Action:** Validate Mastra framework + TaskProvider pattern with Phase 0 prototypes


