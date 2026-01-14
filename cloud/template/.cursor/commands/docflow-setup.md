# DocFlow Setup (PM/Planning Agent)

Complete project setup: define what you're building, connect to Linear, and create initial backlog.

## Overview

This command guides you through:
1. **Project Definition** - What are we building?
2. **Linear Connection** - Connect to your team/project
3. **Milestones** - Create phases to organize work
4. **Initial Backlog** - Capture work items (assigned to milestones)
5. **Prioritization** - Set priorities and dependencies
6. **Sync & Complete** - Push to Linear, recommend first issue

---

## Phase 1: Project Definition

### Gather Project Understanding

Ask the user about their project. Accept input as:
- **Loose concept** - "I want to build a todo app"
- **Detailed description** - Paragraphs of context
- **PRD/Spec file** - "Here's my PRD" or @file reference

### Interactive Refinement

**For loose concepts:** Guide them through discovery questions:
- What problem are you solving?
- Who has this problem? (target users)
- What's the core value proposition?
- What does success look like?
- What's in scope vs out of scope for v1?
- Any technical constraints or preferences?

**For PRDs/specs:** Take a critical look:
- Are the goals clear and measurable?
- Is the scope well-defined?
- Are there gaps or ambiguities?
- Is v1 appropriately scoped (not too big)?
- Suggest refinements or clarifying questions

### Iterative Conversation

Don't just accept input - engage in back-and-forth:
1. Reflect back what you understood
2. Ask clarifying questions
3. Challenge assumptions if needed
4. Suggest improvements
5. Confirm before finalizing

Example flow:
```markdown
You: "I want to build a habit tracking app"

Agent: "Great idea! Let me understand better:
- What makes habits hard to track with existing apps?
- Are you targeting personal use or teams?
- Mobile-first, web, or both?
- Any specific habits in mind (health, productivity, custom)?"

[User responds]

Agent: "Based on that, here's what I'm thinking:
**Vision:** A simple habit tracker focused on [X]
**Core differentiator:** [Y]
**V1 scope:** [Z features]

Does this capture it? Anything to adjust?"
```

### Fill Context Files

Based on refined understanding, fill out:

**`{paths.content}/context/overview.md`:**
- Project Name
- Vision (one sentence)
- Problem Statement
- Target Users
- Key Goals (3-5)
- Success Metrics
- Scope (In/Out)

**`{paths.content}/context/stack.md`:**
- Ask about tech preferences or infer from context
- Core technologies
- Key patterns/architecture

**`{paths.content}/context/standards.md`:**
- Code conventions (or use sensible defaults)
- Can be refined later

### Conversation Flow

```markdown
👋 **Welcome to DocFlow Setup!**

Let's define your project. You can:
- Describe your idea in a few sentences
- Paste a detailed PRD or spec
- Share a file with @filename

**What are you building?**
```

After receiving input:
```markdown
Great! Based on what you've shared, here's what I understand:

**Project:** [Name]
**Vision:** [One sentence]
**Problem:** [What it solves]

I'll now fill out your context files. Ready to continue?
```

---

## Phase 2: Linear Connection

1. **Get Team ID** - Query Linear teams, let user select
2. **Get/Create Project** - Query existing or create new
3. **Configure Product Identity** - Set product label and icon
4. **Update Config** - Save to `.docflow/config.json`
5. **Verify** - Test connection

### Product Configuration

After connecting to Linear, configure the product identity for this codebase:

```markdown
**Product Configuration**

This helps organize your work in Linear.

1. **Product Name:** What product/app does this codebase represent?
   Example: "FlyDocs", "StrideApp", "Website"

2. **Product Label:** Do you have a label group (like "Pods") to categorize projects?
   - yes -> Which label should I use for projects from this codebase?
   - no -> Skip (can add later)

3. **Icon:** What icon should new projects use?
   Icons: comment, code, bug, rocket, star, heart, flag, lightning, etc.

4. **Color:** What color should new projects use?
   Colors: Gray, Purple, Blue, Teal, Green, Yellow, Orange, Red, Pink
```

Save to config:
```json
{
  "workspace": {
    "activeProjects": ["[project-id]"],
    "product": {
      "name": "FlyDocs",
      "labelIds": ["label-xyz789", "label-abc123"],
      "icon": "rocket",
      "color": "Teal"
    }
  }
}
```

---

## Phase 3: Milestones

### Query Existing Milestones

First, check if the project already has milestones:

```bash
# Query milestones via API
curl -s -X POST https://api.linear.app/graphql \
  -H "Authorization: $LINEAR_API_KEY" \
  -d '{"query": "query($projectId: String!) { project(id: $projectId) { projectMilestones { nodes { id name targetDate } } } }", "variables": {"projectId": "..."}}'
```

### If Milestones Exist

```markdown
📅 **Found existing milestones:**

1. Phase 1: Foundation (Target: Jan 15)
2. Phase 2: Core Features (Target: Jan 30)
3. Phase 3: Polish (Target: Feb 15)

Use these for organizing backlog items? (yes/no)
```

### If No Milestones → Offer to Create

```markdown
📅 **Milestones help organize work into phases**

Would you like to create milestones for this project?

Example phases:
- **Phase 1: Foundation** — Infrastructure, auth, core setup
- **Phase 2: Core Features** — Main functionality
- **Phase 3: Polish** — UI refinements, testing, docs

Options:
- **yes** — I'll help you define phases with target dates
- **skip** — Continue without milestones (can add later)
```

### Creating Milestones

For each milestone, gather:
- **Name** (e.g., "Phase 1: Foundation")
- **Description** (brief scope)
- **Target Date** (optional but recommended)

```markdown
Let's define your project phases:

**Milestone 1:**
- Name: Phase 1: Foundation
- Description: Core infrastructure, authentication, and data models
- Target Date: [Ask user or suggest based on project scope]

[Create via API, then continue to next milestone]
```

**API Call to Create Milestone:**
```bash
curl -s -X POST https://api.linear.app/graphql \
  -H "Authorization: $LINEAR_API_KEY" \
  -d '{
    "query": "mutation($projectId: String!, $name: String!, $description: String, $targetDate: TimelessDate) { projectMilestoneCreate(input: { projectId: $projectId, name: $name, description: $description, targetDate: $targetDate }) { success projectMilestone { id name } } }",
    "variables": { "projectId": "...", "name": "Phase 1: Foundation", "description": "...", "targetDate": "2025-01-15" }
  }'
```

### Store Milestone IDs

After creating milestones, store for use during backlog creation.

---

## Phase 4: Backlog - Migration or Creation

### First: Check for Existing Local Specs

**Before asking about new items, check if local specs exist:**
- Look for `{paths.content}/specs/backlog/` or `docflow/specs/backlog/`
- Look for `{paths.content}/specs/complete/` or `docflow/specs/complete/`
- Count any `.md` files (excluding README.md)

### If Local Specs Exist → Offer Migration

```markdown
📦 **Found existing local specs!**

I found:
- [X] specs in backlog
- [Y] completed specs

Would you like me to migrate these to Linear?
- **yes** - I'll create Linear issues from your local specs
- **no** - Skip migration (you can do this later)
```

**Migration process:**
1. Read each spec file from `specs/backlog/`
2. Extract title, description, acceptance criteria
3. Create Linear issue with appropriate template
4. Set to Backlog state
5. For completed specs: Create in Done state
6. After migration, offer to archive local specs folder:

```markdown
✅ Migrated [X] specs to Linear!

Archive the local specs folder? (Moves to specs-archived/)
This keeps a backup but removes the old structure.
```

### If No Local Specs → Offer New Capture (New Project)

```markdown
Would you like to capture some initial work items for the backlog?

I can help you create:
- Features you want to build
- Technical tasks (setup, infrastructure)
- Ideas to explore later

Say "yes" to start capturing, or "skip" to finish setup.
```

**Backlog Creation Guidelines:**
- Create **5-15 high-level items** max (features/epics, not implementation tasks)
- Focus on **what**, not **how** (subtasks come during `/activate`)
- Apply **type label** to each (feature, chore, bug, idea)
- Think epics: "User Authentication" not "Implement OAuth callback handler"

For each item:
1. Use `/capture` flow
2. Apply appropriate template
3. **Ask which milestone** (if milestones exist)
4. Create in Linear (Backlog state)
5. Set type label (feature/chore/bug/idea)
6. Assign to selected milestone

### Milestone Assignment During Capture

If milestones were created/exist:
```markdown
**Which phase does this belong to?**

1. Phase 1: Foundation
2. Phase 2: Core Features
3. Phase 3: Polish
4. None (unassigned)

Select (1-4):
```

Assign via API:
```bash
curl -s -X POST https://api.linear.app/graphql \
  -H "Authorization: $LINEAR_API_KEY" \
  -d '{"query": "mutation($issueId: String!, $milestoneId: String!) { issueUpdate(id: $issueId, input: { projectMilestoneId: $milestoneId }) { success } }", "variables": {"issueId": "...", "milestoneId": "..."}}'
```

---

## Phase 5: Prioritization & Dependencies

After creating backlog items, guide prioritization:

```markdown
📊 **Let's prioritize your backlog**

I've created [X] items. Now let's figure out the order:

1. **What's critical for v1 launch?** (These get High/Urgent priority)
2. **What needs to be built first?** (Dependencies - e.g., auth before admin)
3. **Any external blockers?** (Waiting on APIs, designs, etc.)
```

### Set Priorities

| Priority | Use For |
|----------|---------|
| **Urgent** | Blocking launch, critical bugs |
| **High** | Core v1 features, foundational work |
| **Medium** | Important but not blocking |
| **Low** | Nice-to-have, future enhancements |

### Identify Dependencies

For each item, ask:
- Does this depend on another issue being complete first?
- Will completing this unblock other work?

**Create "blocks/blocked by" relationships in Linear:**
```markdown
Example:
- "F1: Auth" blocks "F2: User Dashboard"
- "Phase 1: Infrastructure" blocks "F3: Core Features"
```

### Suggest Implementation Order

After setting priorities and dependencies, present:
```markdown
📋 **Recommended Implementation Order:**

1. **Phase 1: Infrastructure** (High, no blockers)
   └─ Unblocks: F1, F2, F3

2. **F1: Authentication** (High, after Phase 1)
   └─ Unblocks: F2, F4

3. **F2: Core Feature** (High, after F1)
   ...

Does this order make sense? Any adjustments?
```

Update Linear with priorities and dependencies before proceeding.

---

## Phase 6: Sync & Complete

1. Run `/sync-project` to push context to Linear
2. Show summary:

```markdown
✅ **DocFlow Setup Complete!**

**Project:** [Name]
**Linear Team:** [Team]
**Linear Project:** [Project]
**Milestones:** [Count] phases created
**Backlog Items:** [Count] created (prioritized, assigned to milestones)

**Context files ready:**
- `{paths.content}/context/overview.md` ✓
- `{paths.content}/context/stack.md` ✓
- `{paths.content}/context/standards.md` ✓

**Recommended first issue:**
- [Issue title] (Priority: High, Milestone: Phase 1, no blockers)

**Next steps:**
- Run `/activate [issue]` to start the recommended issue
- Run `/start-session` to begin work
- Run `/capture` to add more items

**Optional: Design System Integration**
If you have a Figma design system with tokens, run `/design-setup` to enable:
- Token enforcement for pixel-perfect implementations
- Figma → code translation mappings
- Automated design system validation
```

---

## Requirements

- Linear MCP installed (or LINEAR_API_KEY in .env)

## Full Rules

See `.docflow/rules/workflow-agent.md`
