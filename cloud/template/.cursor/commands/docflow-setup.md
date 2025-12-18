# DocFlow Setup (PM/Planning Agent)

Complete project setup: define what you're building, connect to Linear, and create initial backlog.

## Overview

This command guides you through:
1. **Project Definition** - What are we building?
2. **Linear Connection** - Connect to your team/project
3. **Initial Backlog** - Capture first work items

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
3. **Update Config** - Save to `.docflow/config.json`
4. **Verify** - Test connection

---

## Phase 3: Initial Backlog (Optional)

Ask if user wants to capture initial work items:

```markdown
Would you like to capture some initial work items for the backlog?

I can help you create:
- Features you want to build
- Technical tasks (setup, infrastructure)
- Ideas to explore later

Say "yes" to start capturing, or "skip" to finish setup.
```

For each item:
1. Use `/capture` flow
2. Apply appropriate template
3. Create in Linear (Backlog state)

---

## Phase 4: Sync & Complete

1. Run `/sync-project` to push context to Linear
2. Show summary:

```markdown
✅ **DocFlow Setup Complete!**

**Project:** [Name]
**Linear Team:** [Team]
**Linear Project:** [Project]
**Backlog Items:** [Count] created

**Context files ready:**
- `{paths.content}/context/overview.md` ✓
- `{paths.content}/context/stack.md` ✓
- `{paths.content}/context/standards.md` ✓

**Next steps:**
- Run `/start-session` to begin work
- Run `/capture` to add more items
- Refine backlog with `/refine`
```

---

## Requirements

- Linear MCP installed (or LINEAR_API_KEY in .env)

## Full Rules

See `.docflow/rules/pm-agent.md`
