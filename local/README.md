# DocFlow Template

**A complete spec-driven development workflow system for AI-assisted development.**

**Version:** 2.1 | **Released:** Nov 21, 2024 | **[Release Notes](releases/2.1.md)**

---

## What is DocFlow?

DocFlow is a **lightweight, structured workflow system** that transforms your AI coding assistant into a complete development partner with three specialized roles:

- **🎯 PM/Planning Agent** - Plans, refines, and orchestrates work
- **💻 Implementation Agent** - Builds features with focused context
- **✅ QE/Validation Agent** - Tests and validates iteratively with you

### The Problem It Solves

Working with AI assistants without structure leads to:
- ❌ Lost context across conversations
- ❌ Incomplete implementations
- ❌ Scattered documentation
- ❌ Duplicated effort
- ❌ No systematic testing

### What DocFlow Provides

- ✅ **Structured specs** with clear acceptance criteria
- ✅ **Three specialized agents** for different workflow phases
- ✅ **Progressive documentation** that stays current
- ✅ **Knowledge base** that grows with your project
- ✅ **Efficient context** loading (2K-7K tokens typical)
- ✅ **Natural language** interface (no command memorization)
- ✅ **Cross-platform** compatible (Cursor, Claude, Copilot, etc.)

---

## Quick Start

### 1. Install DocFlow

**One-line installation:**
```bash
curl -sSL https://raw.githubusercontent.com/strideUX/docflow-template/main/docflow-install.sh | bash
```

**Or download and inspect first:**
```bash
curl -sSL https://raw.githubusercontent.com/strideUX/docflow-template/main/docflow-install.sh > docflow-install.sh
chmod +x docflow-install.sh
./docflow-install.sh
```

> **Note:** For private repos, you'll need GitHub authentication. If the one-line install fails, download the script first (method 2) or authenticate with `gh auth login`.

**What it does:**
- ✅ Detects your project type (new, existing code, or existing DocFlow)
- ✅ Installs all system files (.cursor, .claude, .github, AGENTS.md)
- ✅ Creates complete docflow/ structure
- ✅ Preserves any existing content (safe for upgrades)

**Installs:**
- `.cursor/` - Rules and 11 commands
- `.claude/` - Claude Desktop adapter
- `.github/` - GitHub Copilot adapter
- `AGENTS.md` - Universal AI instructions
- `docflow/` - Complete workflow structure

### 2. Complete Setup

**In your AI tool (Cursor, Claude Desktop, etc.):**
```bash
/docflow-setup
```

**Automatically handles all scenarios:**

**New Project** (~10-15 min):
- Agent asks about your project vision
- Creates context files from conversation
- Builds initial backlog
- Generates custom project-scaffolding spec

**Existing Project** (~5-10 min):
- Agent analyzes your existing code
- Documents current features
- Fills context files from stack
- Sets up DocFlow for ongoing work

**Upgrade DocFlow** (~15-30 min):
- Migrates to version 2.1
- Updates spec formats
- Preserves all content
- Organizes knowledge base

### 3. Start Working

```bash
/start-session
```

Agent shows current state and helps you pick what to work on.

**That's it!** DocFlow is ready to use.

---

## Three-Agent Workflow

```
🎯 PM Agent        💻 Implementation      ✅ QE Agent         🎯 PM Agent
   Plans              Builds                Validates           Closes
     ↓                  ↓                       ↓                  ↓
  /activate        /implement             /validate           /close
     ↓                  ↓                       ↓                  ↓
  READY          IMPLEMENTING          QE_TESTING          COMPLETE
```

**Key insight:** Different agents, different threads, different contexts = focused and efficient work.

**See [DOCFLOW-GUIDE.md](DOCFLOW-GUIDE.md) for detailed examples and workflows.**

---

## Commands (11 Total)

### Daily Workflow

**PM/Planning Agent:**
- `/start-session` - Begin session
- `/capture` - Quick capture work
- `/review` - Refine backlog item
- `/activate` - Ready for implementation
- `/close` - Archive completed work
- `/wrap-session` - End session

**Implementation Agent:**
- `/implement` - Pick up and build
- `/block` - Document blocker

**QE/Validation Agent:**
- `/validate` - Test and validate

**Any Agent:**
- `/status` - Check current state

### System Setup (Once Per Project)
- `/docflow-setup` - Universal setup (new, retrofit, or upgrade)

**Natural language works too!** Say "let's start", "build this", "test it" - agents understand.

---

## Spec Templates (4 Types)

| Template | Use Case | Workflow | Complexity |
|----------|----------|----------|------------|
| **feature.md** | New functionality | Full (6 states) | S/M/L/XL |
| **bug.md** | Fix defects | Full (6 states) | S/M/L/XL |
| **chore.md** | Maintenance/cleanup | Simple (3 states) | Ongoing |
| **idea.md** | Quick exploration | Simple (3 states) | Rough |

**All templates include inline agent instructions for consistency.**

---

## What's Included

### Core System (`template/` folder)
```
template/
├── .cursor/              # Cursor rules and 11 commands
├── .claude/              # Claude Desktop adapter
├── .github/              # GitHub Copilot adapter
├── AGENTS.md             # Universal AI instructions
│
└── docflow/              # Complete workflow structure
    ├── ACTIVE.md         # Current work
    ├── INDEX.md          # Master inventory
    ├── context/          # Project fundamentals
    ├── specs/            # Spec lifecycle + templates
    └── knowledge/        # Project knowledge base
```

### Documentation (This Repository)
- `README.md` - This file (quick start)
- `DOCFLOW-GUIDE.md` - Complete reference guide
- `releases/` - Version history and release notes

---

## Key Features

### Efficient Context Management
- Situational loading based on task
- Knowledge base index-first
- Search before auto-load
- Typical usage: 2K-7K tokens (96%+ headroom)

### Three-Agent Orchestration
- PM agent orchestrates (long-running thread)
- Implementation builds (fresh, focused thread)
- QE validates iteratively (fresh thread with user)
- Clear handoff points between agents

### Progressive Documentation
- Specs evolve through workflow
- Decision logs track rationale
- Implementation notes capture process
- Knowledge base grows organically

### Cross-Platform Compatible
- Optimized for Cursor
- Works with Claude Desktop
- Works with GitHub Copilot
- Universal adapter for any AI tool

### Natural Language Interface
- No command memorization needed
- Conversational triggers
- Agents understand context
- "looks good" approves work

---

## Directory Structure (After Installation)

```
your-project/
├── .cursor/              ← Cursor rules and commands
├── .claude/              ← Claude Desktop adapter
├── .github/              ← GitHub Copilot adapter
├── AGENTS.md             ← Universal AI instructions
│
└── docflow/              ← DocFlow workspace
    ├── ACTIVE.md         ← Current state (check first!)
    ├── INDEX.md          ← Master inventory
    ├── README.md         ← Quick daily reference
    │
    ├── context/          ← Project fundamentals
    │   ├── overview.md
    │   ├── stack.md
    │   └── standards.md
    │
    ├── specs/            ← Spec lifecycle
    │   ├── templates/    ← 4 spec types
    │   ├── active/       ← Currently implementing
    │   ├── backlog/      ← Planned work
    │   ├── complete/     ← Archived by quarter
    │   └── assets/       ← Spec-specific resources
    │
    └── knowledge/        ← Project knowledge
        ├── INDEX.md      ← Scan first!
        ├── decisions/
        ├── features/
        ├── notes/
        └── product/
```

---

## Example: Feature Implementation

```
1. PM: "let's start"              → Shows status
2. PM: "review dashboard spec"    → Refines spec
3. PM: "ready to build"           → Activates for impl

4. Impl: "implement dashboard"    → Builds feature
   [Auto-completes when done]     → Marks REVIEW

5. QE: "validate dashboard"       → Reviews & tests
   User tests...
   User: "looks great!"           → Approves

6. PM: /start-session             → Sees approved work
7. PM: "close it"                 → Archives, queues next
```

**Simple, clean, systematic.**

---

## System Characteristics

**Lightweight:**
- 4 spec types
- 11 commands
- ~6,350 lines total system

**Efficient:**
- 2K-7K tokens typical usage
- 96%+ context headroom
- Search-first approach

**Complete:**
- All workflow phases covered
- All agent roles defined
- All handoffs explicit
- All scenarios handled

**Portable:**
- Works across AI tools
- Single source of truth
- Lightweight adapters
- Tool-agnostic design

---

## Documentation

### Quick Start
- **[README.md](README.md)** - This file (overview and setup)
- **`template/docflow/README.md`** - Quick daily reference (after copying)

### Complete Reference
- **[DOCFLOW-GUIDE.md](DOCFLOW-GUIDE.md)** - Comprehensive guide
  - Three-agent model details
  - All 11 commands with examples
  - All 4 templates explained
  - Workflow states and transitions
  - Knowledge base usage
  - Best practices and troubleshooting

### Source Files
- **`template/.cursor/rules/docflow.mdc`** - Complete workflow rules (648 lines)
- **`template/.cursor/commands/`** - 11 command implementation files
- **`template/docflow/specs/templates/`** - 4 spec templates with instructions

### Platform Adapters
- **`template/AGENTS.md`** - Universal AI instructions
- **`template/.claude/rules.md`** - Claude Desktop
- **`template/.github/copilot-instructions.md`** - GitHub Copilot

---

## Version History

**Current:** 2.1 (Nov 21, 2024)
- Complete system refactoring
- Three-agent model formalized
- Knowledge base added
- Context optimization
- Cross-platform support

**See [releases/](releases/) for detailed release notes.**

---

## Next Steps

1. **Run `docflow-install.sh` in your project**
2. **Complete setup with `/docflow-setup`**
3. **Start working with `/start-session`**
4. **Read [DOCFLOW-GUIDE.md](DOCFLOW-GUIDE.md) for deep dive**

---

## Questions?

- **Complete guide:** [DOCFLOW-GUIDE.md](DOCFLOW-GUIDE.md)
- **Release notes:** [releases/2.1.md](releases/2.1.md)
- **Daily reference:** `template/docflow/README.md`
- **Templates guide:** `template/docflow/specs/templates/README.md`
- **Knowledge guide:** `template/docflow/knowledge/README.md`

---

**Ready to build better software with AI assistance?**

Install DocFlow with one command and let it guide you through structured, efficient development.
