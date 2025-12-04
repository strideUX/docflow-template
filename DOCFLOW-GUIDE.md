# DocFlow Complete Guide

**Version 2.1** - Complete reference for the DocFlow spec-driven development workflow system.

---

## Table of Contents

1. [Three-Agent Workflow Model](#three-agent-workflow-model)
2. [Commands Reference](#commands-reference)
3. [Spec Templates](#spec-templates)
4. [Workflow States](#workflow-states)
5. [Example Workflows](#example-workflows)
6. [Knowledge Base](#knowledge-base)
7. [Context Loading Strategy](#context-loading-strategy)
8. [Best Practices](#best-practices)
9. [Setup Instructions](#setup-instructions)

---

## Three-Agent Workflow Model

DocFlow uses a **three-agent orchestration model** for efficient, focused work:

```
┌──────────────────────────────────────────────────┐
│  🎯 PM/Planning Agent (DocFlow)                  │
│  Role: Orchestration & Planning                  │
│  • Refines specs and captures work              │
│  • Activates work for implementation             │
│  • Reviews and closes completed work             │
│  Commands: /start-session, /capture, /review,   │
│           /activate, /close, /wrap-session       │
└──────────────────────────────────────────────────┘
                        ↓
              Activates spec for implementation
                        ↓
┌──────────────────────────────────────────────────┐
│  💻 Implementation Agent                         │
│  Role: Build the thing                           │
│  • Picks up active specs                         │
│  • Implements features/fixes                     │
│  • Auto-marks for review when complete           │
│  Commands: /implement, /block                    │
└──────────────────────────────────────────────────┘
                        ↓
          Auto-sends to validation when done
                        ↓
┌──────────────────────────────────────────────────┐
│  ✅ QE/Validation Agent                          │
│  Role: Validate with user                        │
│  • Performs code review                          │
│  • Works iteratively with user to test          │
│  • Finds issues or approves                      │
│  • Sends back to impl or marks approved          │
│  Commands: /validate                             │
└──────────────────────────────────────────────────┘
                        ↓
            User approves: "looks good!"
                        ↓
┌──────────────────────────────────────────────────┐
│  🎯 PM/Planning Agent (DocFlow)                  │
│  • Closes and archives the spec                 │
│  • Queues next priority work                     │
│  Commands: /close, /start-session                │
└──────────────────────────────────────────────────┘
```

### Why Three Agents?

**PM/Planning Agent:**
- Long-running thread maintains project context
- Understands priorities and big picture
- Orchestrates workflow without getting in the weeds
- Reviews work against specifications

**Implementation Agent:**
- Fresh, focused thread per spec
- Clean context (only what's needed to build)
- Auto-completes when acceptance criteria met
- No memory of previous unrelated work

**QE/Validation Agent:**
- Fresh thread with spec + implementation context
- Iterative conversation focused on testing
- Can loop back to implementation if issues found
- Validates with user until approved

---

## Commands Reference

### PM/Planning Agent Commands (6)

#### `/start-session` - Begin Planning Session
**Purpose:** Check current state and identify priorities

**What it does:**
- Checks for QE approvals (highest priority)
- Shows work ready for code review
- Lists active implementation work
- Shows backlog priorities
- Suggests next action

**Natural language:**
- "let's start" / "what's next" / "where are we"

#### `/capture` - Quick Capture
**Purpose:** Add new work to backlog without context switching

**What it does:**
- Asks type: feature, bug, chore, or idea
- Creates spec in backlog from template
- Updates INDEX.md
- Lets you continue current work

**Natural language:**
- "capture that" / "add to backlog" / "found a bug"

#### `/review [spec-name]` - Refine Backlog Item
**Purpose:** Prepare spec for activation

**What it does:**
- Loads spec from backlog
- Asks clarifying questions
- Fills out acceptance criteria
- Adds technical notes
- Searches for related work
- Determines readiness

**Natural language:**
- "review [spec]" / "refine [spec]" / "is [spec] ready"

#### `/activate [spec-name]` - Ready for Implementation
**Purpose:** Handoff to Implementation agent

**What it does:**
- Moves spec from backlog → active
- Sets status=READY
- Assigns to developer (@username from git)
- **This is the handoff!**

**Natural language:**
- "activate [spec]" / "ready to build [spec]" / "queue [spec]"

#### `/close [spec-name]` - Archive Completed Work
**Purpose:** Complete the workflow cycle

**What it does:**
- Verifies spec is approved (status=QE_TESTING)
- Moves to complete/YYYY-QQ/
- Updates tracking files
- Shows next priorities

**Natural language:**
- "close [spec]" / "archive [spec]" / "mark complete"

#### `/wrap-session` - End Planning Session
**Purpose:** Save state and prepare for next time

**What it does:**
- Reviews all active specs
- Updates ACTIVE.md
- Provides session summary
- Identifies next steps

**Natural language:**
- "let's wrap" / "I'm done" / "end session"

---

### Implementation Agent Commands (2)

#### `/implement [spec-name]` - Pick Up and Build
**Purpose:** Build the feature/fix the bug

**What it does:**
- Finds specs with status=READY
- Loads spec + stack.md + standards.md
- Sets status=IMPLEMENTING
- Builds according to acceptance criteria
- **Auto-marks status=REVIEW when complete**

**Natural language:**
- "implement [spec]" / "build [spec]" / "let's work on [spec]"

**Key behavior:** No manual "wrap" needed - agent knows when it's done.

#### `/block` - Document Blocker
**Purpose:** Hand back to PM when stuck

**What it does:**
- Documents blocker in spec
- Sets status=REVIEW (hands to PM)
- Explains what's needed

**Natural language:**
- "I'm blocked" / "stuck on this" / "need help"

---

### QE/Validation Agent Commands (1)

#### `/validate [spec-name]` - Test and Validate
**Purpose:** Code review + user testing iteration

**What it does:**
- Loads spec with Implementation Notes
- Performs DocFlow code review
- Sets status=QE_TESTING
- Generates testing checklist
- Works iteratively with user
- Documents issues OR waits for approval
- Sends back to IMPLEMENTING if issues found

**Natural language:**
- "validate [spec]" / "test [spec]" / "review implementation"

**User approval phrases:**
- "looks good" / "approve" / "ship it" / "all good"

**Key behavior:** Iterates with user until approved. Doesn't auto-close.

---

### All Agents Commands (1)

#### `/status` - Check Current State
**Purpose:** See what's happening across all work

**What it does:**
- Shows specs by status
- Shows work assigned to you vs others
- Shows blockers
- Suggests next action

**Natural language:**
- "status" / "where are we" / "what's active"

---

### System Setup Command (1)

#### `/docflow-setup` - Universal Setup
**Purpose:** Intelligently handle all DocFlow setup scenarios

**Automatically detects and handles:**
1. **New Project** - Empty directory
   - Conversational setup (~10-15 min)
   - Fills context files from your vision
   - Creates initial backlog
   - Generates project-scaffolding spec (custom to your stack)
   - First task: Framework setup + git init

2. **Retrofit Existing** - Code exists, no DocFlow
   - Analyzes existing code (~5-10 min)
   - Documents current features
   - Fills context files from detected stack
   - Sets up DocFlow for ongoing work

3. **Upgrade DocFlow** - Existing DocFlow found
   - Migrates to version 2.1 (~15-30 min)
   - Updates spec formats (removes time, adds complexity)
   - Preserves all content and active work
   - Archives old structure (shared/, reference/)
   - Organizes knowledge base

**When to use:** 
- Run once after `docflow-install.sh`
- Agent automatically chooses the right flow based on detection
- Always safe - preserves existing content
- Always asks before making changes (for upgrades)

---

## Spec Templates

### feature.md - New Functionality
**Use for:** User-facing features, new capabilities, enhancements

**Workflow:** Full (6 states)
```
BACKLOG → READY → IMPLEMENTING → REVIEW → QE_TESTING → COMPLETE
```

**Complexity:** S/M/L/XL
- S = Few hours
- M = 1-2 days
- L = 3-5 days
- XL = ~1 week (max - break larger into smaller)

**Includes:**
- Problem statement and user story
- Detailed acceptance criteria
- Technical planning sections
- Implementation tracking
- Code review checklist
- QE testing validation
- Decision logging

---

### bug.md - Fix Defects
**Use for:** Broken functionality, errors, incorrect behavior

**Workflow:** Full (6 states)
```
BACKLOG → READY → IMPLEMENTING → REVIEW → QE_TESTING → COMPLETE
```

**Complexity:** S/M/L/XL

**Includes:**
- Reproduction steps
- Expected vs actual behavior
- Root cause analysis
- Fix approach planning
- Regression testing
- Prevention recommendations

---

### chore.md - Maintenance & Cleanup
**Use for:** Refactoring, UI polish, technical debt, improvements

**Workflow:** Simplified (3 states)
```
BACKLOG → ACTIVE → COMPLETE
```

**Complexity:** N/A (can be ongoing)

**Includes:**
- Context (why it matters)
- Evolving task checklist
- Work notes (loose format)
- Simple completion criteria
- Agent suggests completion, waits for user approval

**Key difference:** No formal QE step, just user approval to close.

---

### idea.md - Quick Exploration
**Use for:** Brainstorming, spikes, rough concepts, future possibilities

**Workflow:** Simplified (3 states)
```
BACKLOG → ACTIVE → COMPLETE
```

**Complexity:** Rough estimate

**Includes:**
- Brain dump sketch
- Value assessment
- Questions to answer
- Research checklist
- Path to refinement into feature

**Key difference:** Lightweight, can stay rough until validated.

---

## Workflow States

### Full Workflow (Features & Bugs)

**BACKLOG**
- Spec captured but not ready for implementation
- Needs refinement via `/review`
- May have incomplete acceptance criteria

**READY**
- PM agent has refined and activated via `/activate`
- Assigned to developer
- Ready for Implementation agent to pick up

**IMPLEMENTING**
- Implementation agent is building
- Acceptance criteria being completed
- Implementation Notes being filled

**REVIEW**
- Implementation complete
- Needs DocFlow code review
- QE agent will validate via `/validate`

**QE_TESTING**
- Code review passed
- User is testing with QE agent
- Iterating until approval

**COMPLETE**
- User approved
- Ready for PM agent to `/close`
- Will be archived to complete/YYYY-QQ/

---

### Simplified Workflow (Chores & Ideas)

**BACKLOG**
- Captured but not started
- Can be refined if needed

**ACTIVE**
- Currently working on it
- Tasks being checked off
- No formal review needed

**COMPLETE**
- User approved
- Ready to archive

---

## Example Workflows

### Happy Path: Feature Implementation

```
1. PM Agent (Long-running planning thread)
   User: "let's start"
   PM: /start-session
   → Shows: QE approvals, reviews, active work, backlog

2. PM Agent (same thread)
   User: "let's work on the user dashboard"
   PM: /review feature-user-dashboard
   → Refines spec with user, asks questions

3. PM Agent (same thread)
   User: "ready to build this"
   PM: /activate feature-user-dashboard
   → Status=READY, assigned to @username
   → "Ready for Implementation agent!"

4. Implementation Agent (FRESH focused thread)
   User: "start work" or "implement dashboard"
   Impl: /implement
   → Picks up feature-user-dashboard
   → Loads spec + stack.md + standards.md
   → Sets status=IMPLEMENTING
   → [Builds the feature]
   → Auto-marks status=REVIEW when done
   → "Implementation complete! Ready for validation."

5. QE Agent (FRESH validation thread)
   User: "validate the dashboard"
   QE: /validate feature-user-dashboard
   → Loads spec with Implementation Notes
   → Performs code review
   → Sets status=QE_TESTING
   → "Code review passed! Let's test it."
   → [User tests with agent's guidance]
   User: "looks great! works perfectly"
   QE: → Fills QE Testing section
   → "Approved! Ready for PM to close."

6. PM Agent (Back to long-running thread)
   PM: /start-session
   → Sees approved work
   PM: /close feature-user-dashboard
   → Moves to complete/2024-Q4/
   → Updates tracking files
   → "Dashboard feature complete! 🎉 What's next?"
```

---

### With Feedback Loop

```
5. QE Agent
   User: "validate dashboard"
   QE: /validate feature-user-dashboard
   → Reviews code
   → Sets status=QE_TESTING
   → [User testing]
   User: "the mobile view is broken"
   QE: → Documents issue in spec
   → Sets status=IMPLEMENTING
   → "Sending back to implementation with notes."

6. Implementation Agent (back to fresh thread)
   User: "fix the mobile issue"
   Impl: /implement feature-user-dashboard
   → Reads QE notes
   → Fixes the mobile view
   → Auto-marks status=REVIEW
   → "Fixed! Ready for validation again."

7. QE Agent (continue validation thread)
   User: "test it again"
   QE: /validate feature-user-dashboard
   → Tests the fix
   User: "perfect! approve it"
   QE: → Approved

8. PM Agent
   PM: /close feature-user-dashboard
   → Complete!
```

---

### Chore Workflow (Simplified)

```
1. PM Agent
   User: "capture a chore for UI cleanup"
   PM: /capture
   → Creates chore-ui-cleanup.md in backlog

2. PM Agent
   User: "let's work on the UI cleanup"
   PM: /activate chore-ui-cleanup
   → Status=ACTIVE (not READY - chores use simplified workflow)

3. Implementation Agent
   User: "start on UI cleanup"
   Impl: /implement chore-ui-cleanup
   → Works through task checklist
   → Adds new tasks as discovered
   → Checks off completed items
   → When thinks it's done: "This looks complete. Ready to close?"

4. User
   User: "yes, close it"
   
5. PM Agent
   PM: /close chore-ui-cleanup
   → Moves to complete/
   → Done!
```

**Note:** Chores skip REVIEW and QE_TESTING - just need user approval.

---

## Commands Reference

### PM/Planning Agent (6 Commands)

#### /start-session
**Purpose:** Begin your planning session  
**Context loaded:** ACTIVE.md, scan active/ specs  
**Outputs:** Status summary, suggested next action  
**Natural language:** "let's start", "what's next", "where are we"

#### /capture
**Purpose:** Quick capture new work  
**Context loaded:** INDEX.md (to update)  
**Outputs:** New spec in backlog  
**Natural language:** "capture that", "add to backlog"

#### /review [spec]
**Purpose:** Refine backlog item  
**Context loaded:** Spec, INDEX.md, overview.md, knowledge/INDEX.md  
**Outputs:** Refined spec ready to activate  
**Natural language:** "review [spec]", "refine [spec]"

#### /activate [spec]
**Purpose:** Ready spec for implementation (handoff)  
**Context loaded:** Spec, ACTIVE.md, INDEX.md  
**Outputs:** Spec moved to active/, status=READY, assigned  
**Natural language:** "activate [spec]", "ready to build [spec]"

#### /close [spec]
**Purpose:** Archive completed work  
**Context loaded:** Spec, ACTIVE.md, INDEX.md  
**Outputs:** Spec archived to complete/YYYY-QQ/, next priorities shown  
**Natural language:** "close [spec]", "archive [spec]"

#### /wrap-session
**Purpose:** End planning session  
**Context loaded:** ACTIVE.md, all active/ specs  
**Outputs:** Session summary, next steps  
**Natural language:** "let's wrap", "I'm done"

---

### Implementation Agent (2 Commands)

#### /implement [spec]
**Purpose:** Pick up and build active spec  
**Context loaded:** Spec (complete), stack.md, standards.md  
**Outputs:** Implementation, auto-marks REVIEW when done  
**Natural language:** "implement [spec]", "build [spec]", "let's work on [spec]"

**Auto-completion:** Agent marks status=REVIEW when all criteria met.

#### /block
**Purpose:** Document blocker, hand back to PM  
**Context loaded:** Current spec  
**Outputs:** Blocker documented, status=REVIEW  
**Natural language:** "I'm blocked", "stuck on this"

---

### QE/Validation Agent (1 Command)

#### /validate [spec]
**Purpose:** Code review + user testing iteration  
**Context loaded:** Spec with Implementation Notes, standards.md  
**Outputs:** Code review, testing guidance, approval or issues  
**Natural language:** "validate [spec]", "test [spec]"

**Approval phrases:** "looks good", "approve", "ship it", "all good"

---

### All Agents (1 Command)

#### /status
**Purpose:** Check current state  
**Context loaded:** ACTIVE.md, scan active/ specs, INDEX.md  
**Outputs:** Status dashboard by category  
**Natural language:** "status", "where are we", "what's active"

---

### System Setup (1 Command)

#### /docflow-setup
**Purpose:** Universal setup - handles all scenarios  
**Use once:** After running `docflow-install.sh`  
**Auto-detects:**
- New project (~10-15 min conversation)
- Existing code (~5-10 min analysis)
- Upgrade DocFlow (~15-30 min migration)

**Natural language:** "set up DocFlow", "initialize", "complete setup"  

---

## Spec Templates

### Template Selection Guide

**Is something broken?** → `bug.md`  
**Building new functionality?** → `feature.md`  
**Maintenance/cleanup/refactoring?** → `chore.md`  
**Exploring an idea?** → `idea.md`

### Template Structure

All templates include:
- Inline `<!-- AGENT INSTRUCTIONS -->` comments
- Metadata (Status, Owner, AssignedTo, Priority, Complexity, Dates)
- Context section (why it matters)
- Requirements/Criteria section
- Technical notes
- Decision Log (dated entries)
- Implementation Notes (progressive)
- Workflow-appropriate completion sections

### Complexity Sizing

**For Features & Bugs:**
- **S** - Few hours
- **M** - 1-2 days
- **L** - 3-5 days
- **XL** - ~1 week maximum

**If bigger than XL:** Break into smaller specs.

**For Chores:** No complexity (can be ongoing)

**For Ideas:** Rough estimate

---

## Knowledge Base

### Structure
```
docflow/knowledge/
├── INDEX.md           # Scan this first (~500 tokens)
├── decisions/         # Architecture Decision Records (ADRs)
├── features/          # Complex feature documentation
├── notes/             # Technical discoveries
└── product/           # Personas, user flows, UX
```

### When to Use

**decisions/** - Architecture Decision Records
- Format: `NNN-decision-title.md` (numbered)
- When: Making architectural choices
- Example: "001-why-convex.md"

**features/** - Complex Feature Docs
- When: Feature is architecturally complex
- Documents internals for future reference

**notes/** - Real-Time Discoveries
- API quirks, library limitations, workarounds
- Quick captures during development

**product/** - UX Artifacts
- User personas and profiles
- User journey maps
- Design system guidelines

### Loading Strategy

1. **Scan INDEX.md first** (~500 tokens)
2. **Assess relevance** from one-line descriptions
3. **Load selectively** - only what applies to current task
4. **Never auto-load all** - trust search and index

**When to load product docs:**
- Creating user-facing features
- Planning UX improvements
- Understanding user context

---

## Context Loading Strategy

### Situational Loading (Not Auto-Load)

**On Every Interaction:**
- Check `docflow/ACTIVE.md` (quick scan)
- Scan for priority work (REVIEW, QE_TESTING)

**When Planning:**
- Load: overview.md, INDEX.md, knowledge/INDEX.md
- Why: Understand vision, avoid duplicates

**When Implementing:**
- Load: spec (complete), stack.md, standards.md
- Why: Build correctly with quality standards

**When Reviewing:**
- Load: spec, standards.md
- Why: Verify quality and completeness

**When Searching:**
- Use: codebase_search, grep
- Then: Load only relevant findings
- Why: More efficient than guessing

**Knowledge Base:**
- Scan: knowledge/INDEX.md first
- Load: Only relevant docs
- Why: Knowledge grows, can't load everything

### Efficiency Metrics
- **Typical usage:** 2K-7K tokens
- **Available:** 200K+ tokens
- **Headroom:** 96%+ unused capacity
- **Result:** Fast, focused, cost-effective

---

## Best Practices

### For PM Agent (Long-Running Thread)
- Keep one thread for entire session
- Check status at start and end
- Review implementations before user testing
- Close work after user approval
- Capture ideas as they come up

### For Implementation Agent (Fresh Thread)
- Start fresh thread for focused work
- Let agent auto-complete when done
- Use `/block` if stuck
- Keep thread focused on one spec
- Don't manually wrap

### For QE Agent (Fresh Thread)
- Start fresh for each validation
- Work iteratively with user
- Document issues clearly
- Loop back to implementation if needed
- Wait for explicit user approval

### For All Agents
- Trust natural language triggers (no need to type /commands)
- Use `/status` to check current state
- Keep work moving through pipeline
- Document decisions as you go
- Search before creating code

---

## Setup Instructions

### Installation (All Projects)

**1. Run Install Script**
```bash
# One-line installation
curl -sSL https://raw.githubusercontent.com/strideUX/docflow-template/main/docflow-install.sh | bash

# Or download and inspect first (recommended for private repos)
curl -sSL https://raw.githubusercontent.com/strideUX/docflow-template/main/docflow-install.sh > docflow-install.sh
chmod +x docflow-install.sh
./docflow-install.sh
```

> **Note:** For private repos, authenticate first with `gh auth login` or download the script manually.

**2. Complete Setup**
```bash
# In your AI tool (Cursor, Claude, etc.)
/docflow-setup
```

**3. Agent Auto-Detects Scenario:**

**New Project:**
- Conversational setup (~10-15 min)
- Describe project vision
- Choose tech stack
- Create initial backlog
- Generate project-scaffolding spec

**Existing Code:**
- Analyze codebase (~5-10 min)
- Ask clarifying questions
- Fill context files from detected stack
- Document existing features

**Existing DocFlow:**
- Migrate to 2.1 (~15-30 min)
- Update spec formats
- Preserve all content
- Organize knowledge base

**4. Start Working**
```bash
# New projects
/implement project-scaffolding

# Existing projects
/start-session
```

---

## Natural Language Reference

You rarely need to type `/commands` - agents understand natural language:

### Session Management
- "let's start" → `/start-session`
- "let's wrap" / "I'm done" → `/wrap-session`
- "status" / "where are we" → `/status`

### Planning
- "capture that idea" → `/capture`
- "review the dashboard spec" → `/review`
- "ready to build this" → `/activate`
- "close the spec" → `/close`

### Implementation
- "implement dashboard" → `/implement`
- "I'm blocked" → `/block`

### Validation
- "validate dashboard" → `/validate`
- "looks good!" → Approval (during QE)
- "ship it" → Approval (during QE)

---

## File Organization

### What Goes Where

**`docflow/ACTIVE.md`** - Current work state
- What's being worked on right now
- Who's working on what
- What needs attention

**`docflow/INDEX.md`** - Master inventory
- All specs (active, backlog, completed)
- Priorities
- Overall project status

**`docflow/context/`** - Project fundamentals (stable)
- overview.md - Vision and goals
- stack.md - Tech stack and patterns
- standards.md - Code conventions

**`docflow/specs/`** - Spec lifecycle
- templates/ - Create specs from these
- backlog/ - Planned work
- active/ - Current work
- complete/ - Archived by quarter
- assets/ - Screenshots, references per spec

**`docflow/knowledge/`** - Growing knowledge base
- INDEX.md - Scan this first
- decisions/ - ADRs
- features/ - Complex feature docs
- notes/ - Technical gotchas
- product/ - Personas, flows, UX

---

## Platform Support

DocFlow works across AI tools:

### Cursor (Primary)
- All rules auto-load from `.cursor/rules/docflow.mdc`
- Commands available natively in `.cursor/commands/`
- Optimized experience

### Claude Code (CLI)
- Reads `.claude/rules.md`
- Full slash command support via `.claude/commands/` (symlinked to Cursor commands)
- Great for terminal-based workflows
- Same `/command` syntax as Cursor

### Claude Desktop
- Reads `.claude/rules.md`
- Points to Cursor rules
- Great for PM and QE agents

### Warp
- Reads `.warp/rules.md` and `WARP.md`
- Terminal-first workflow guidance
- Shell aliases for common operations
- Excellent for Implementation Agent work

### GitHub Copilot
- Reads `.github/copilot-instructions.md`
- Follows standards.md for code
- Can use chat commands

### Any AI Tool
- Reads `AGENTS.md`
- Universal instructions
- Same workflow everywhere

**Single source of truth:** `.cursor/rules/docflow.mdc`

---

## Critical Rules

### Never Create Root-Level Status Files
❌ **Forbidden:** STATUS.md, SUMMARY.md, TODO.md in project root  
✅ **Use:** docflow/ACTIVE.md and specs instead

### Move Files Efficiently
1. Use terminal `mv` command (single operation)
2. Update spec content with search_replace (status, dates)
3. Update ACTIVE.md and INDEX.md
4. Preferred over delete/create (requires fewer approvals)

### Search Before Creating
- Use codebase_search for existing functionality
- Check knowledge base for patterns
- Don't duplicate code

### Update Progressively
- Check off acceptance criteria as you complete
- Fill Implementation Notes while working
- Update timestamps when modifying
- Keep ACTIVE.md current

### Wait for Approval
- Implementation agent: marks REVIEW, doesn't close
- QE agent: approves, doesn't close
- PM agent: only one who closes via `/close`

---

## Troubleshooting

### Agent Not Following Workflow
- Ensure rules file is in `.cursor/rules/docflow.mdc`
- Check that paths use `/docflow/` prefix
- Verify natural language triggers in rules

### Specs Not Moving Correctly
- Check for atomic file operations (delete then create)
- Verify ACTIVE.md and INDEX.md being updated
- Look for error messages during file operations

### Context Too Large
- Review what's being loaded
- Should be situational, not auto-loading everything
- Check knowledge/INDEX.md is being scanned (not full docs loaded)

### Commands Not Recognized
- Try explicit `/command-name`
- Check natural language trigger phrases in rules
- Verify command file exists in `.cursor/commands/`

---

## Version Information

**Current Version:** 2.1  
**Released:** November 21, 2024  
**See:** [releases/2.1.md](releases/2.1.md) for complete release notes

---

## Resources

### In Template Repository
- `template/` - Copy this to your projects
- `releases/` - Version history
- `README.md` - Quick overview
- `DOCFLOW-GUIDE.md` - This file (complete reference)

### After Installation (In Your Project)
- `docflow/README.md` - Quick daily reference
- `.cursor/rules/docflow.mdc` - Complete rules
- `.cursor/commands/` - Command implementations
- `AGENTS.md` - Universal AI instructions

---

**DocFlow 2.1: Refined, efficient, and ready for production use.** 🚀

