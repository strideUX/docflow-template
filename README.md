# DocFlow - Spec-Driven Development Workflow

**A complete workflow system for AI-assisted development.**

DocFlow transforms your AI coding assistant into a project manager, implementation partner, and QA validator through a structured three-agent orchestration model.

---

## 🚀 What is DocFlow?

**DocFlow is a lightweight, spec-driven development workflow** that helps you:
- ✅ Plan and refine work before building
- ✅ Implement features with clear acceptance criteria
- ✅ Review and validate implementations systematically
- ✅ Document decisions and maintain project knowledge
- ✅ Orchestrate multiple AI agents for different roles
- ✅ Keep context focused and efficient

**Built for Cursor, works everywhere** - Portable across AI tools with platform adapters.

---

## 📖 Documentation

**Start here:**
1. **[SETUP.md](SETUP.md)** - Installation and first steps
2. **[WORKFLOW.md](WORKFLOW.md)** - Three-agent model and command guide
3. **[docflow/README.md](docflow/README.md)** - Quick reference for daily use

**Complete rules:**
- **`.cursor/rules/docflow.mdc`** - Source of truth for all workflow rules

---

## 🎯 Three-Agent Workflow Model

DocFlow uses specialized agent roles for efficient work:

### PM/Planning Agent (Orchestrator)
**Role:** Planning, refining, activating work, closing completed specs  
**Thread:** Long-running session thread  
**Commands:** start-session, wrap-session, capture, review, activate, close

### Implementation Agent (Builder)
**Role:** Build features, fix bugs, work on chores  
**Thread:** Fresh, focused per spec  
**Commands:** implement, block  
**Auto-completes:** Marks for review when done (no manual wrap)

### QE/Validation Agent (Validator)
**Role:** Code review + iterative user testing  
**Thread:** Fresh per validation  
**Commands:** validate  
**Iterates:** Works with you until approved

**See [WORKFLOW.md](WORKFLOW.md) for visual diagrams and examples.**

---

## 📁 Directory Structure

```
docflow/
├── ACTIVE.md                    # Current work state
├── INDEX.md                     # Master inventory
│
├── context/                     # Project fundamentals
│   ├── overview.md              # Vision, goals, users
│   ├── stack.md                 # Tech stack & patterns
│   └── standards.md             # Code conventions
│
├── specs/                       # Spec lifecycle
│   ├── templates/               # 4 spec types
│   │   ├── feature.md           # New functionality (S/M/L/XL)
│   │   ├── bug.md               # Fix defects (S/M/L/XL)
│   │   ├── chore.md             # Maintenance (no complexity)
│   │   └── idea.md              # Quick exploration
│   ├── active/                  # Currently implementing
│   ├── backlog/                 # Planned work
│   ├── complete/                # Archived by quarter
│   └── assets/                  # Spec-specific resources
│       └── [spec-name]/
│
└── knowledge/                   # Project knowledge base
    ├── INDEX.md                 # Lightweight index (scan first)
    ├── decisions/               # Architecture decisions (ADRs)
    ├── features/                # Complex feature docs
    ├── notes/                   # Technical discoveries
    └── product/                 # Personas, user flows, UX
```

---

## 🔧 Commands (12 Total)

### Daily Workflow (9 commands)

**PM/Planning Agent:**
```bash
/start-session     # Begin work session, check status
/capture           # Quick capture new work to backlog
/review [spec]     # Refine backlog item for activation
/activate [spec]   # Ready spec for implementation (handoff)
/close [spec]      # Archive completed work
/wrap-session      # End session, save state
```

**Implementation Agent:**
```bash
/implement [spec]  # Pick up and build active spec
/block             # Document blocker, hand back to PM
```

**QE/Validation Agent:**
```bash
/validate [spec]   # Review code and test with user
```

**Any Agent:**
```bash
/status            # Check current state of all work
```

### System Setup (2 commands)
```bash
/docflow-new       # Set up brand new project
/docflow-scan      # Retrofit or update existing project
```

**See `.cursor/commands/` for detailed command documentation.**

---

## 🗣️ Natural Language Support

**You don't need to type /commands!** Agents recognize natural phrases:

- "let's start" → `/start-session`
- "capture that idea" → `/capture`
- "review the dashboard spec" → `/review`
- "ready to build this" → `/activate`
- "let's work on login" → `/implement`
- "test this feature" → `/validate`
- "looks good! approve it" → Approves QE
- "close the spec" → `/close`
- "where are we?" → `/status`
- "let's wrap" → `/wrap-session`

**Just talk naturally - the agent understands context.**

---

## 📋 Spec Templates

Four types for different work:

| Template | Use Case | Workflow | Complexity |
|----------|----------|----------|------------|
| **feature** | New functionality | Full (6 states) | S/M/L/XL |
| **bug** | Fix defects | Full (6 states) | S/M/L/XL |
| **chore** | Maintenance/cleanup | Simple (3 states) | Ongoing |
| **idea** | Quick exploration | Simple (3 states) | Rough |

**Each template includes:**
- Comprehensive inline agent instructions
- Clear section purposes and examples
- Progress tracking checklists
- Decision logging
- Workflow phases appropriate to type

**Complexity sizing:**
- **S** - Few hours
- **M** - 1-2 days
- **L** - 3-5 days
- **XL** - ~1 week (max - break larger work into smaller specs)

---

## 🔄 Workflow States

### Features & Bugs (Full Workflow)
```
BACKLOG → READY → IMPLEMENTING → REVIEW → QE_TESTING → COMPLETE
```

### Chores & Ideas (Simplified Workflow)
```
BACKLOG → ACTIVE → COMPLETE
```

**Handoff points:**
- **PM → Implementation:** `/activate` sets status=READY
- **Implementation → QE:** Auto-sets status=REVIEW when done
- **QE → PM:** User approval triggers `/close`

---

## 🧠 Context Loading Strategy

**Efficient and situational** - don't auto-load everything!

### Always Loaded
- `.cursor/rules/docflow.mdc` (automatic in Cursor)

### On Every Interaction
- Check `docflow/ACTIVE.md` (quick scan)
- Scan for priority work (REVIEW, QE_TESTING specs)

### Load Based on Task
- **Planning:** overview.md, INDEX.md, knowledge/INDEX.md
- **Implementing:** spec, stack.md, standards.md
- **Reviewing:** spec, standards.md
- **User-facing features:** product/personas.md, user-flows.md

### Search, Don't Auto-Load
- Knowledge base (scan INDEX.md first)
- Existing code (use codebase_search)
- Related specs (use INDEX.md to find)

**Typical context usage:** 2K-7K tokens per session (very efficient!)

---

## 📚 Knowledge Base

**`docflow/knowledge/`** grows with your project:

- **INDEX.md** - Lightweight index (~500 tokens) - always scan this first
- **decisions/** - Architecture Decision Records (numbered ADRs)
- **features/** - How complex features work
- **notes/** - Technical gotchas and discoveries
- **product/** - User personas, flows, design guidelines

**Load selectively based on need** - never auto-load everything.

---

## 🎨 Key Features

### ✅ Three-Agent Orchestration
- **PM Agent** plans and orchestrates (long-running thread)
- **Implementation Agent** builds (fresh, focused thread)
- **QE Agent** validates iteratively (fresh thread with user)

### ✅ Spec-Driven Development
- Four template types (feature, bug, chore, idea)
- Clear acceptance criteria
- Progressive documentation
- Decision logging throughout

### ✅ Natural Language Interface
- No need to memorize commands
- Talk naturally, agent understands
- Conversational workflow

### ✅ Atomic File Operations
- Safe spec movement between folders
- Automatic tracking file updates
- No duplicate files

### ✅ Efficient Context Loading
- Situational, not blanket auto-load
- Knowledge base with index-first approach
- Search before loading
- 2K-7K tokens typical (plenty of headroom)

### ✅ Cross-Platform Compatible
- Optimized for Cursor (primary)
- Works with Claude Desktop
- Works with GitHub Copilot
- Universal adapter for other AI tools

### ✅ Knowledge Management
- Architecture decisions tracked (ADRs)
- Complex features documented
- Technical discoveries captured
- Product/UX artifacts organized

---

## 🚀 Getting Started

### For a New Project
1. **Copy this template** to your project directory
2. **Run `/docflow-new`** in Cursor
3. **Agent guides you** through vision, stack, initial backlog
4. **First task created:** Project scaffolding (custom to your stack)
5. **Start building:** `/implement project-scaffolding`

### For an Existing Project
1. **Copy this template** to your project directory
2. **Run `/docflow-scan`** in Cursor
3. **Agent analyzes** your code and creates DocFlow documentation
4. **Migrates old specs** if they exist (archives then converts)
5. **Ready to use:** Start with `/start-session`

**See [SETUP.md](SETUP.md) for detailed installation instructions.**

---

## 🔍 How It Works

### Typical Day
```
Morning:
  PM Agent: /start-session
  → Shows: QE approvals, reviews, active work, backlog

Planning:
  PM Agent: /review feature-x
  PM Agent: /activate feature-x

Implementation:
  Implementation Agent: /implement
  → Builds feature-x
  → Auto-marks for review when complete

Validation:
  QE Agent: /validate feature-x
  → Reviews code
  → Tests with you
  → Iterates until approved

Closure:
  PM Agent: /close feature-x
  → Archives, queues next work

Evening:
  PM Agent: /wrap-session
  → Summary and checkpoint
```

**See [WORKFLOW.md](WORKFLOW.md) for complete examples.**

---

## ⚠️ Critical Rules

### Rule 0: Never Create Root-Level Status Files
**FORBIDDEN:**
- ❌ NO STATUS.md, SUMMARY.md, TODO.md in project root
- ❌ NO PHASE_*_STATUS.md, CHECKLIST.md, NOTES.md in root

**REQUIRED:**
- ✅ ALL tracking in `docflow/ACTIVE.md` and specs
- ✅ ALL knowledge in `docflow/knowledge/`
- ✅ ALL decisions in spec Decision Logs or knowledge/decisions/

### Atomic File Movement
When moving specs between folders:
1. DELETE source file
2. CREATE destination file
3. Update ACTIVE.md and INDEX.md in same operation

### Search Before Creating
- Use `codebase_search` to find existing code
- Check `docflow/knowledge/` for documented patterns
- Avoid duplicating functionality

### Update Progressively
- Check off acceptance criteria: `[ ]` → `[x]`
- Fill Implementation Notes as you work
- Update Last Updated timestamps
- Keep ACTIVE.md current

---

## 🛠️ Platform Support

**This template works across AI tools:**

### Cursor (Primary Platform)
✅ Optimized experience  
✅ Rules auto-load from `.cursor/rules/docflow.mdc`  
✅ Commands available natively  
✅ Full feature support  

### Claude Desktop
✅ Read `.claude/rules.md` for integration  
✅ Points to `.cursor/rules/docflow.mdc`  
✅ Great for PM and QE agents (long conversations)  

### VS Code with Copilot
✅ Read `.github/copilot-instructions.md`  
✅ Code suggestions follow standards.md  
✅ Chat can use DocFlow commands  

### Other AI Tools
✅ Read `AGENTS.md` for universal instructions  
✅ Points to complete system  
✅ Same workflow everywhere  

**Single source of truth** (`.cursor/rules/docflow.mdc`), lightweight adapters for each platform.

---

## 📦 What's Included

### Core System
- `.cursor/rules/docflow.mdc` - Complete workflow rules (648 lines)
- `.cursor/commands/` - 12 command implementation files
- `docflow/` - Complete directory structure with templates

### Documentation
- `WORKFLOW.md` - Three-agent model guide
- `SETUP.md` - Installation instructions
- `AGENTS.md` - Universal AI agent instructions
- `docflow/README.md` - Quick daily reference

### Platform Adapters
- `.claude/rules.md` - Claude Desktop integration
- `.github/copilot-instructions.md` - GitHub Copilot integration

### Templates & Guides
- 4 spec templates (feature, bug, chore, idea)
- Knowledge base templates (personas, user flows)
- README files in each folder explaining usage

---

## 🎯 Key Principles

### Simplicity First
- 4 spec types (not dozens)
- 12 commands (not overwhelming)
- Clear folder structure (no overlap)
- Natural language (no memorization needed)

### Efficiency
- Context: 2K-7K tokens typical (not auto-loading everything)
- Search-first approach (find existing code)
- Knowledge base with index (scan then load selectively)
- Clean agent handoffs (fresh threads when needed)

### Consistency
- All templates have agent instructions
- All commands follow same format
- All paths use `/docflow/` prefix
- Decision logging throughout
- Update as you go

### Flexibility
- Works solo or with teams
- Assignment tracking via git username
- Can be ongoing (chores) or time-boxed (features)
- Adapts to your workflow

---

## 🔄 Workflow Execution

### Feature Implementation (Happy Path)
```
1. PM: /start-session → Check priorities
2. PM: /review feature-x → Refine spec
3. PM: /activate feature-x → Ready for implementation

4. Implementation: /implement → Build it
   → Auto-marks REVIEW when done

5. QE: /validate → Review & test with user
   → User approves: "looks good!"

6. PM: /close → Archive & queue next
```

### With Feedback Loop
```
5. QE: /validate → Find issues
   → Documents & sends back to IMPLEMENTING

6. Implementation: /implement → Fix issues
   → Auto-marks REVIEW

7. QE: /validate → Test again
   → User approves

8. PM: /close → Done!
```

---

## 📊 System Characteristics

**Lightweight:**
- ~600 lines of adapters
- ~650 lines of core rules
- ~1,200 lines of templates
- Total: ~2,500 lines for complete system

**Efficient Context:**
- Typical usage: 2K-7K tokens
- Max scenario: ~17K tokens
- Available: 200K+ tokens
- Headroom: 90%+ unused capacity

**Well-Documented:**
- Inline agent instructions in templates
- Comprehensive command files
- Visual workflow guides
- Cross-platform adapters
- Knowledge base structure

---

## 🎨 Spec Templates

### feature.md - New Functionality
- User story driven
- Comprehensive workflow (6 states)
- Technical planning sections
- Implementation tracking
- Code review + QE testing
- S/M/L/XL complexity

### bug.md - Fix Defects
- Reproduction steps
- Root cause analysis
- Fix approach planning
- Regression testing
- Prevention recommendations
- S/M/L/XL complexity

### chore.md - Maintenance & Cleanup
- Task-based checklist (evolving)
- Work notes (loose format)
- Simple workflow (3 states)
- No complexity (can be ongoing)
- User approval to close

### idea.md - Quick Exploration
- Brain dump format
- Value assessment
- Questions to answer
- Research checklist
- Path to refinement

**All templates include inline `<!-- AGENT INSTRUCTIONS -->` for consistency.**

---

## 🧠 Context Loading Philosophy

**Load minimum viable context based on task:**

**Planning new work:**
- Load: overview.md, INDEX.md, knowledge/INDEX.md
- Why: Understand vision and avoid duplicates

**Implementing:**
- Load: spec, stack.md, standards.md
- Why: Build correctly with clear quality bar

**Reviewing:**
- Load: spec, standards.md
- Why: Verify quality and completeness

**Searching:**
- Use: codebase_search, grep
- Then: Load only relevant findings
- Why: More efficient than guessing

**Knowledge base:**
- Scan: knowledge/INDEX.md (~500 tokens)
- Load: Only relevant docs
- Why: Knowledge grows, can't load everything

---

## 📚 Knowledge Base

**Grows with your project:**

### INDEX.md - Lightweight Index
Scan this first (~500 tokens) to find what exists, then load selectively.

### decisions/ - Architecture Decisions
- Format: `NNN-decision-title.md` (numbered ADRs)
- When: Making architectural choices
- Example: "001-why-convex.md"

### features/ - Complex Feature Docs
- When: Feature is architecturally complex
- Documents how internals work
- Onboarding for future devs/agents

### notes/ - Real-Time Discoveries
- API quirks, library limitations, workarounds
- Quick captures that might become decisions

### product/ - UX Artifacts
- User personas and profiles
- User flows and journeys
- Design system guidelines

**Load when creating user-facing features** to ensure alignment with user needs.

---

## ⚠️ Critical Rules

### Never Create Root-Level Status Files
❌ **Forbidden:**
- STATUS.md, SUMMARY.md, TODO.md
- PHASE_*_STATUS.md, CHECKLIST.md
- Any tracking files in project root

✅ **Required:**
- All tracking in `docflow/ACTIVE.md`
- All work in `docflow/specs/`
- All knowledge in `docflow/knowledge/`

### Always Move Files Atomically
1. DELETE source file
2. CREATE destination file
3. Update ACTIVE.md and INDEX.md in same operation

### Search Before Creating
- Use codebase_search for existing functionality
- Check knowledge base for patterns
- Avoid duplicating code

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

## 🔌 Cross-Platform Compatibility

**DocFlow is tool-agnostic** - works everywhere:

### File Structure
```
.cursor/                    # Cursor-specific (source of truth)
.claude/                    # Claude Desktop adapter
.github/copilot-instructions.md  # GitHub Copilot adapter
AGENTS.md                   # Universal adapter
```

**Maintenance:** Update Cursor files, adapters rarely change (they just point to source).

### Supported Platforms
- ✅ **Cursor** (optimized)
- ✅ **Claude Desktop** (via .claude/rules.md)
- ✅ **VS Code Copilot** (via .github/copilot-instructions.md)
- ✅ **Any AI tool** (via AGENTS.md)

**Same workflow, same commands, any tool.**

---

## 🎓 Learning Resources

### Getting Started
1. [SETUP.md](SETUP.md) - Installation and initialization
2. [WORKFLOW.md](WORKFLOW.md) - Three-agent model and commands
3. [docflow/README.md](docflow/README.md) - Daily quick reference

### Deep Dive
1. `.cursor/rules/docflow.mdc` - Complete rules (source of truth)
2. `.cursor/commands/` - Detailed command implementations
3. `docflow/specs/templates/README.md` - Template guide
4. `docflow/knowledge/README.md` - Knowledge base guide

### For Other AI Tools
1. [AGENTS.md](AGENTS.md) - Universal instructions
2. `.claude/rules.md` - Claude Desktop
3. `.github/copilot-instructions.md` - GitHub Copilot

---

## 🤝 Contributing & Feedback

**This is a living system** that evolves based on real-world usage.

### Template Maintenance
```
1. Refine DocFlow in a live project
2. Extract improvements back to this template
3. Apply to other projects
```

**Updates flow:** Live Project → Template Repo → Other Projects

### Found an Improvement?
- Update templates with better patterns
- Enhance commands with clearer steps
- Add to knowledge base structure
- Improve documentation

---

## 📞 Questions?

- Check `docflow/ACTIVE.md` for current work
- Check `WORKFLOW.md` for agent model
- Check `.cursor/commands/` for command details
- Check `AGENTS.md` for tool-agnostic instructions
- Use `/status` to see current state

---

**DocFlow: AI-first development workflow for focused, efficient building.**
