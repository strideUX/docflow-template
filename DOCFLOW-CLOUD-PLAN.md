# DocFlow Cloud: Evolution Plan

**Status:** Planning  
**Last Updated:** November 22, 2024

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

## Architecture: Cloud-Orchestrated, Locally-Grounded

```
┌─────────────────────────────────────────────────────────┐
│           Task Management (Next.js 15 + Convex)         │
│  • Active tasks (status, assignments, priorities)       │
│  • Workflow state machine                               │
│  • Template/rules service (versioned)                   │
│  • Agent assignment logic                               │
└─────────────────────────────────────────────────────────┘
                          ↕ MCP Protocol
┌─────────────────────────────────────────────────────────┐
│              Agent Orchestration Layer                  │
│  • Cloud agent pool (Agentuity or CrewAI)              │
│  • Execution sandboxes (E2B)                            │
│  • Context injection (local → cloud)                    │
│  • Git operations (PR creation)                         │
└─────────────────────────────────────────────────────────┘
                          ↕ MCP Tools
┌─────────────────────────────────────────────────────────┐
│              MCP Server (Local Bridge)                  │
│  • Bidirectional sync (cloud ↔ local)                  │
│  • Context provider (project files → agents)            │
│  • Local cache & offline queue                          │
│  • Git operations                                        │
└─────────────────────────────────────────────────────────┘
                          ↕
┌─────────────────────────────────────────────────────────┐
│              Local Project (Git Repo)                   │
│  docflow/context/     (project knowledge)               │
│  docflow/knowledge/   (historical record)               │
│  .docflow.sync        (local cache, git-ignored)        │
└─────────────────────────────────────────────────────────┘
```

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

### 3. Cloud Agent Implementation: Vercel AI SDK (Leverage Existing Stack)

**Decision:** Build cloud agents with Vercel AI SDK in Next.js, skip third-party orchestration platforms

**Why AI SDK:**
- Already using Next.js 15 (perfect fit)
- Excellent tool calling support (maps to MCP tools)
- Multi-model support (OpenAI, Anthropic, etc.)
- You control the code (no platform lock-in)
- Deploys to Vercel seamlessly
- No additional platform costs
- Mature, well-maintained by Vercel

**Architecture:**
```
Next.js API Routes (AI SDK agents)
  → Convex (task queue + state machine)
    → AI SDK tools call MCP server
      → E2B for code execution
        → GitHub for PRs
```

**Why E2B:**
- Secure code execution sandboxes
- Multiple language support (TypeScript, Python, etc.)
- Fast spin-up
- Good for implementation agents that need to run code

**Alternative (if you outgrow this):** Move to Agentuity or CrewAI later if you need more sophisticated orchestration

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

## Cloud Agent Implementation with Vercel AI SDK

### Why AI SDK is Perfect for Your Use Case

You're already using **Next.js 15 + Convex**. The Vercel AI SDK is designed specifically for this stack and gives you:

1. **Tool Calling** - AI SDK tools map perfectly to your MCP tools
2. **Multi-Step Reasoning** - Agents can plan and execute multiple steps
3. **Streaming** - Real-time updates to UI (optional)
4. **Type Safety** - Full TypeScript support
5. **Model Flexibility** - Swap between OpenAI, Anthropic, etc.

### Architecture: Build vs Buy

**You could use Agentuity/CrewAI for orchestration, but why?**

You already have orchestration:
- ✅ Convex = your task queue and state machine
- ✅ Next.js = your API layer
- ✅ AI SDK = your agent framework

**Just add:**
- Agent API routes (3 files, one per agent type)
- Convex cron to poll queue
- AI SDK tools (wrappers around MCP calls)

Total additional code: ~500 lines vs learning entire new platform.

### Implementation Example

**Step 1: Define AI SDK Tools (Your MCP Bridge)**

```typescript
// lib/ai/tools.ts
import { tool } from 'ai';
import { z } from 'zod';

export const getContextTool = tool({
  description: 'Get project context files from local repository via MCP',
  parameters: z.object({
    projectId: z.string(),
    files: z.array(z.enum(['overview', 'stack', 'standards']))
  }),
  execute: async ({ projectId, files }) => {
    // Call your MCP server
    const response = await fetch('http://localhost:3000/mcp', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        tool: 'docflow_get_context',
        params: { projectId, files }
      })
    });
    return await response.json();
  }
});

export const executeCodeTool = tool({
  description: 'Execute code in secure E2B sandbox',
  parameters: z.object({
    code: z.string(),
    language: z.enum(['typescript', 'python', 'javascript'])
  }),
  execute: async ({ code, language }) => {
    // Call E2B
    const sandbox = await E2B.create({ language });
    const result = await sandbox.runCode(code);
    await sandbox.close();
    return result;
  }
});

export const createPRTool = tool({
  description: 'Create GitHub pull request with implementation',
  parameters: z.object({
    taskId: z.string(),
    branch: z.string(),
    files: z.array(z.object({
      path: z.string(),
      content: z.string()
    })),
    title: z.string(),
    description: z.string()
  }),
  execute: async (params) => {
    // Call MCP server to create PR
    const response = await fetch('http://localhost:3000/mcp', {
      method: 'POST',
      body: JSON.stringify({
        tool: 'docflow_create_pr',
        params
      })
    });
    return await response.json();
  }
});

export const updateTaskTool = tool({
  description: 'Update task status and notes in Convex',
  parameters: z.object({
    taskId: z.string(),
    status: z.string().optional(),
    implementationNotes: z.string().optional(),
    reviewNotes: z.string().optional()
  }),
  execute: async ({ taskId, ...updates }) => {
    // Update Convex directly (you're in Next.js, same backend)
    const { convex } = await import('@/convex/client');
    await convex.mutation(api.tasks.update, {
      id: taskId,
      updates
    });
    return { success: true };
  }
});
```

**Step 2: Implementation Agent API Route**

```typescript
// app/api/agents/implementation/route.ts
import { anthropic } from '@ai-sdk/anthropic';
import { generateText } from 'ai';
import { getContextTool, executeCodeTool, createPRTool, updateTaskTool } from '@/lib/ai/tools';
import { convex } from '@/convex/client';
import { api } from '@/convex/_generated/api';

export async function POST(req: Request) {
  const { taskId } = await req.json();
  
  // Get task from Convex
  const task = await convex.query(api.tasks.get, { id: taskId });
  
  if (!task?.docflow) {
    return Response.json({ error: 'Not a DocFlow task' }, { status: 400 });
  }
  
  // Update status to IMPLEMENTING
  await convex.mutation(api.tasks.transition, {
    id: taskId,
    status: 'IMPLEMENTING'
  });
  
  // Build prompt from spec
  const prompt = `
You are an Implementation Agent in the DocFlow workflow system.

Task: ${task.title}
Type: ${task.docflow.type}
Complexity: ${task.docflow.complexity}

Acceptance Criteria:
${task.docflow.acceptanceCriteria.map((c, i) => `${i + 1}. ${c.description}`).join('\n')}

Technical Notes:
${task.docflow.technicalNotes || 'None provided'}

Your job:
1. Get project context (stack.md, standards.md) to understand patterns
2. Plan the implementation approach
3. Write the code following project standards
4. Create a PR with your implementation
5. Update the task with implementation notes

Use the provided tools to complete this task.
  `.trim();
  
  try {
    // Run agent with AI SDK
    const result = await generateText({
      model: anthropic('claude-3-5-sonnet-20241022'),
      system: `You are an expert software engineer following the DocFlow implementation workflow.
You have access to tools to get project context, execute code, create PRs, and update tasks.
Always follow the project's stack.md patterns and standards.md conventions.
Write clear, well-tested code that meets all acceptance criteria.`,
      prompt,
      tools: {
        getContext: getContextTool,
        executeCode: executeCodeTool,
        createPR: createPRTool,
        updateTask: updateTaskTool
      },
      maxSteps: 15  // Allow multiple tool calls
    });
    
    // Agent completed - transition to REVIEW
    await convex.mutation(api.tasks.transition, {
      id: taskId,
      status: 'REVIEW'
    });
    
    return Response.json({
      success: true,
      result: result.text,
      toolCalls: result.steps?.length || 0
    });
    
  } catch (error) {
    // Agent failed - document blocker
    await updateTaskTool.execute({
      taskId,
      implementationNotes: `❌ Agent failed: ${error.message}`
    });
    
    await convex.mutation(api.tasks.transition, {
      id: taskId,
      status: 'REVIEW'  // Send to PM for investigation
    });
    
    return Response.json({ error: error.message }, { status: 500 });
  }
}
```

**Step 3: Convex Cron to Poll Queue**

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
    // Determine agent type based on status
    let agentType = 'implementation';
    if (task.docflow.status === 'BACKLOG') agentType = 'pm';
    if (task.docflow.status === 'REVIEW') agentType = 'qe';
    
    // Call your Next.js API route (deployed on Vercel)
    try {
      await fetch(`${process.env.NEXT_PUBLIC_URL}/api/agents/${agentType}`, {
        method: 'POST',
        headers: { 
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${process.env.AGENT_API_KEY}`
        },
        body: JSON.stringify({ taskId: task._id })
      });
    } catch (error) {
      console.error(`Failed to trigger ${agentType} agent:`, error);
    }
  }
});
```

**Step 4: PM Agent (Similar Pattern)**

```typescript
// app/api/agents/pm/route.ts
export async function POST(req: Request) {
  const { taskId } = await req.json();
  const task = await convex.query(api.tasks.get, { id: taskId });
  
  const result = await generateText({
    model: anthropic('claude-3-5-sonnet-20241022'),
    system: 'You are a PM/Planning agent in DocFlow. Refine specs, clarify requirements, activate for implementation.',
    prompt: `Refine this spec: ${task.title}...`,
    tools: {
      getContext: getContextTool,
      searchKnowledge: searchKnowledgeTool,
      updateTask: updateTaskTool,
      activateTask: activateTaskTool
    },
    maxSteps: 10
  });
  
  return Response.json({ success: true });
}
```

### Cost Comparison

**Option A: AI SDK (Your Stack)**
- Next.js hosting: $0 (Vercel free tier or $20/mo)
- Convex: $0 (free tier) or $25/mo
- E2B: $10-50/mo (based on usage)
- LLM API calls: ~$0.01-0.10 per task
- **Total: ~$30-100/mo**

**Option B: Agentuity**
- Agentuity platform: Unknown (contact sales)
- LLM API calls: Same as above
- E2B: Same as above
- **Total: ??? (likely $200+/mo)**

### Benefits of AI SDK Approach

1. **You already know the stack** (Next.js, Convex)
2. **Full control** over agent behavior
3. **Easy debugging** (it's just your code)
4. **No platform lock-in** (can migrate to Agentuity later if needed)
5. **Cheaper** (no platform fees)
6. **Faster iteration** (deploy to Vercel in seconds)

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

4. Agentuity polling Convex sees new task in queue

5. Implementation Agent (cloud) starts:
   a. Reads task from Convex
   b. Calls MCP: docflow_get_context(projectId, ['stack', 'standards'])
   c. Executes code in E2B sandbox
   d. Calls MCP: docflow_create_pr(taskId, files)
   e. Updates Convex: status=REVIEW

6. Webhook/notification → local dev

7. Dev reviews PR in GitHub
```

### Flow 3: Template Update (Workflow Rules)

```
1. Admin updates workflow rules (e.g., add new status)

2. New template version 2.2 saved in Convex

3. Projects on "latest" auto-pull on next MCP sync

4. Projects on pinned version stay on 2.1

5. Developer can manually upgrade:
   `docflow upgrade --template-version=2.2`

6. MCP server:
   - Fetches template from Convex
   - Updates local .cursor/rules/docflow.mdc
   - Updates .docflow/config.json

7. Agent reloads, now uses new rules
```

---

## Components to Build

### 1. Convex Integration (Your Task System)

**Additions Needed:**
- [ ] Add `docflow` field to task schema
- [ ] Implement state machine validation (transition function)
- [ ] Create agent queue table (for cloud agent assignments)
- [ ] Add HTTP endpoints for MCP server to call
- [ ] Add API key authentication for external access

### 2. MCP Server (Local Bridge)

**New Package:** `@docflow/mcp-server`

**Responsibilities:**
- Expose MCP tools to local AI agents (Cursor, Claude, etc.)
- Sync tasks from Convex to local cache
- Provide project context to cloud agents
- Create GitHub PRs
- Handle offline mode (queue operations when cloud unreachable)

**Key Files:**
```
@docflow/mcp-server/
├── src/
│   ├── server.ts           # MCP protocol implementation
│   ├── tools/
│   │   ├── sync.ts         # docflow_sync_tasks
│   │   ├── context.ts      # docflow_get_context
│   │   ├── tasks.ts        # docflow_create_task, update_task
│   │   └── git.ts          # docflow_create_pr
│   ├── cache/
│   │   └── sqlite.ts       # Local cache (SQLite)
│   └── convex-client.ts    # HTTP client for Convex API
├── cli.ts                  # CLI: docflow init, sync, upgrade
└── package.json
```

### 3. Cloud Agent Runtime (Agentuity + E2B)

**Components:**
- Agentuity configuration for three agent types (PM, Implementation, QE)
- E2B sandbox configuration for code execution
- Agent implementations that call MCP tools
- Polling or webhook listener for Convex agent queue

**Agent Types:**
```
PM Agent (Cloud):
- Refines specs
- Decides priority
- Routes to implementation

Implementation Agent (Cloud):
- Reads spec from Convex
- Gets context via MCP
- Executes code in E2B
- Creates PR via MCP
- Updates task status

QE Agent (Cloud or Local):
- Reviews code
- Tests implementation
- Works with user iteratively
```

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

1. **AI SDK vs Agentuity: Final Decision**
   - Start with AI SDK (leverage existing stack, faster MVP)?
   - Or use Agentuity for orchestration (less code, more features)?
   - Hybrid: Use AI SDK for agents, but deploy to Agentuity platform?
   - Can we prototype both and compare in 1-2 weeks?

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

7. **AI SDK Multi-Step Reasoning**
   - How many `maxSteps` should agents have? (10? 20? Unlimited with cost cap?)
   - Should we implement custom retry logic or use AI SDK's built-in?
   - How to handle agent "getting stuck" in loops?

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

1. **Prototype MCP Server**
   - Build basic MCP server that exposes 2-3 tools
   - Test with Cursor: Can local agent call `docflow_sync_tasks`?
   - Validate MCP protocol understanding

2. **Extend Convex Schema**
   - Add `docflow` field to your task schema
   - Implement basic state machine validation
   - Test via your existing UI

3. **Test Agentuity Integration**
   - Sign up for Agentuity trial
   - Deploy simple agent that calls MCP tool
   - Validate: Can cloud agent read local context?

### Short-Term (MVP)

4. **Build Core MCP Tools**
   - `docflow_sync_tasks` (pull from Convex)
   - `docflow_get_context` (read local files)
   - `docflow_create_task` (create in Convex)

5. **Update Local Agent Templates**
   - Modify `AGENTS.md` to reference MCP tools
   - Update `/start-session` command to call MCP

6. **Deploy First Cloud Agent**
   - Simple implementation agent
   - Reads task, gets context, creates PR
   - Test end-to-end flow

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

- **Agentuity** (https://agentuity.com) - Recommended for orchestration
- **CrewAI Flows** (https://crewai.com) - Alternative if more customization needed
- **E2B** (https://e2b.dev) - Code execution sandboxes
- **LangGraph Cloud** - Considered but more LangChain-specific

### Technologies in Use

- **MCP (Model Context Protocol)** - Anthropic's standard for AI ↔ external systems
- **Convex** - Your existing backend (real-time DB + serverless functions)
- **Next.js 15** - Your existing frontend
- **Agentuity or CrewAI** - Cloud agent orchestration
- **E2B** - Secure code execution for implementation agents

### Related Reading

- MCP Documentation: https://modelcontextprotocol.io/
- Convex Real-Time Subscriptions: https://docs.convex.dev/client/react/useQuery
- Agentuity Docs: https://docs.agentuity.com/
- E2B Docs: https://e2b.dev/docs

---

## Summary: Leverage What You Already Have

### What You Have

✅ **Next.js 15** - Perfect for hosting AI SDK agents  
✅ **Convex** - Your task queue, state machine, and database  
✅ **Task Management UI** - Just extend with DocFlow fields  
✅ **Understanding of workflow** - Three-agent model is clear  

### What You Need to Build

🔨 **MCP Server** (~500 lines)
- Bridge between cloud agents and local projects
- Provides context to cloud agents
- Handles git operations

🔨 **AI SDK Agent Routes** (~300 lines total)
- `app/api/agents/pm/route.ts`
- `app/api/agents/implementation/route.ts`
- `app/api/agents/qe/route.ts`

🔨 **AI SDK Tools** (~200 lines)
- Wrappers around MCP calls
- E2B integration
- Convex updates

🔨 **Convex Extensions** (~100 lines)
- Add `docflow` field to task schema
- State machine validation
- Cron to poll queue

**Total: ~1,100 lines of code to get cloud agents working**

### Recommended Tech Choices

| Component | Choice | Why |
|-----------|--------|-----|
| **Cloud Agents** | Vercel AI SDK | You already use Next.js, no new platform needed |
| **Code Execution** | E2B | Secure sandboxes, works with AI SDK |
| **Local Bridge** | Custom MCP Server | Universal, works with all AI tools |
| **Orchestration** | Convex Crons | You already have Convex, no new service |
| **Local Automation** | Cursor CLI | Optional, for developer convenience |

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

Before writing 1,100 lines of code:

1. **Test AI SDK + Tools** (1-2 days)
   - Create single agent route
   - Implement one tool (getContext)
   - Verify it can call tool and get response

2. **Test E2B** (1 day)
   - Run simple code execution
   - Verify sandboxing works
   - Check pricing

3. **Test MCP Protocol** (2-3 days)
   - Build minimal MCP server (2 tools)
   - Test with local Cursor agent
   - Verify cloud agent can call MCP tools

**If all three work: Build the full system**  
**If any fail: Reconsider Agentuity/CrewAI**

### Migration Path

**MVP (Week 1-4):**
- Extend Convex schema with DocFlow fields
- Build minimal MCP server
- Create one agent route (Implementation)
- Test end-to-end with one real task

**V1 (Week 5-8):**
- Add PM and QE agent routes
- Full MCP tool suite
- Convex cron for polling
- Basic monitoring/logging

**V2 (Week 9-12):**
- Template management in Convex
- Multi-project dashboard
- Analytics and insights
- Cost tracking

**Later (if needed):**
- Migrate to Agentuity if orchestration becomes complex
- Add more sophisticated agent routing
- Implement agent collaboration features

---

**Last Updated:** November 22, 2024  
**Status:** Planning - Ready to implement MVP  
**Recommended Approach:** Start with Vercel AI SDK + Convex, migrate to Agentuity only if needed


