# AI Agent Instructions

This project uses **DocFlow**, a spec-driven development workflow system optimized for AI-assisted development.

---

## 📖 Primary Documentation

### You MUST Read These Files First:

1. **`.cursor/rules/docflow.mdc`** - Complete workflow rules (SOURCE OF TRUTH)
   - Three-agent orchestration model
   - Command system and natural language triggers
   - Context loading strategy
   - File movement rules
   - Spec lifecycle management

2. **`WORKFLOW.md`** - Visual workflow guide
   - Three-agent model diagram
   - Command reference by agent role
   - Example workflows
   - Best practices

3. **`docflow/ACTIVE.md`** - Current work state
   - What's in progress right now
   - What needs attention
   - Always check this on every interaction

---

## 🎯 Quick Start for Agents

### Understand Your Role

**PM/Planning Agent:**
- Plan and refine work
- Activate specs for implementation
- Review and close completed work
- Commands: /start-session, /capture, /review, /activate, /close, /wrap-session

**Implementation Agent:**
- Build features and fix bugs
- Auto-complete when done
- Commands: /implement, /block

**QE/Validation Agent:**
- Code review and user testing
- Iterate with user until approved
- Commands: /validate

### Check Current State
```bash
1. Read: docflow/ACTIVE.md (know what's happening)
2. Scan: docflow/specs/active/ (check statuses)
3. Review: docflow/INDEX.md (see priorities)
```

### Load Context Situationally
**Don't auto-load everything!** See `.cursor/rules/docflow.mdc` for when to load:
- Planning: overview.md, INDEX.md
- Implementing: spec, stack.md, standards.md
- Searching: Use codebase_search, then load what you find

**Knowledge base:** Scan `docflow/knowledge/INDEX.md` first, then load selectively.

### Follow the Workflow

**Features & Bugs:**
```
BACKLOG → READY → IMPLEMENTING → REVIEW → QE_TESTING → COMPLETE
```

**Chores & Ideas:**
```
BACKLOG → ACTIVE → COMPLETE
```

---

## 📁 Directory Structure

```
docflow/
├── ACTIVE.md              # Current work (check always)
├── INDEX.md               # Master inventory
├── context/               # Project fundamentals
│   ├── overview.md        # Vision and goals
│   ├── stack.md           # Tech stack and patterns
│   └── standards.md       # Code conventions
├── specs/                 # Spec lifecycle
│   ├── templates/         # 4 templates: feature, bug, chore, idea
│   ├── active/            # In progress
│   ├── backlog/           # Planned
│   ├── complete/          # Archived by quarter
│   └── assets/            # Spec-specific resources
└── knowledge/             # Project knowledge
    ├── INDEX.md           # Scan this first!
    ├── decisions/         # Architecture decisions (ADRs)
    ├── features/          # Complex feature docs
    ├── notes/             # Technical discoveries
    └── product/           # Personas, user flows
```

---

## 🔧 Available Commands

Type `/` to see commands, or use natural language triggers.

**PM/Planning (6):**
- `/start-session` - Begin session, check status
- `/wrap-session` - End session, save state
- `/capture` - Quick capture new work
- `/review [spec]` - Refine backlog item
- `/activate [spec]` - Ready for implementation
- `/close [spec]` - Archive completed work

**Implementation (2):**
- `/implement [spec]` - Pick up and build
- `/block` - Document blocker

**QE/Validation (1):**
- `/validate [spec]` - Test and review

**All Agents (1):**
- `/status` - Check current state

**DocFlow Setup (2):**
- `/docflow-new` - Set up new project
- `/docflow-scan` - Retrofit existing project

---

## 🗣️ Natural Language Support

You don't need explicit commands. Recognize these phrases:

**Start session:**
- "let's start" / "what's next" / "where are we"

**Capture:**
- "capture that" / "add to backlog" / "found a bug"

**Implement:**
- "let's build [spec]" / "implement [spec]"

**Validate:**
- "test this" / "review implementation"

**Approve (during QE):**
- "looks good" / "approve" / "ship it"

**See `.cursor/rules/docflow.mdc`** for complete trigger list.

---

## 🎨 Spec Templates

Four types in `docflow/specs/templates/`:

| Template | Use Case | Workflow | Complexity |
|----------|----------|----------|------------|
| **feature.md** | New functionality | Full (6 states) | S/M/L/XL |
| **bug.md** | Fix defects | Full (6 states) | S/M/L/XL |
| **chore.md** | Maintenance/cleanup | Simple (3 states) | N/A |
| **idea.md** | Quick exploration | Simple (3 states) | Rough |

Each template includes comprehensive agent instructions.

---

## ⚠️ Critical Rules

### Never Create Root-Level Status Files
- ❌ NO STATUS.md, SUMMARY.md, TODO.md in project root
- ✅ ALL tracking in /docflow/ACTIVE.md and specs

### Always Move Files Atomically
1. DELETE source file
2. CREATE destination file
3. Update ACTIVE.md and INDEX.md in same operation

### Search Before Creating
- Use codebase_search to find existing code
- Check docflow/knowledge/ for existing patterns
- Avoid duplicating functionality

### Document Decisions
- Spec-specific: In spec Decision Log
- Architectural: In docflow/knowledge/decisions/

### Update as You Go
- Check off acceptance criteria: [ ] → [x]
- Fill Implementation Notes progressively
- Update Last Updated timestamps
- Keep tracking files current

---

## 🔄 Workflow Execution Patterns

### Starting Work
```
1. Agent recognizes: "let's start" → runs /start-session
2. Shows: QE work, review work, active work, backlog
3. User picks what to work on
4. Agent executes appropriate command
```

### Handoffs
```
PM → Implementation:  /activate sets status=READY
Implementation → QE:  Auto-sets status=REVIEW when done
QE → PM:             User approval triggers ready for /close
PM → Next:           /close queues next priority
```

### Never Auto-Close
- Implementation agent: marks REVIEW, doesn't close
- QE agent: approves, doesn't close
- PM agent: only one who closes via /close command

---

## 📚 Additional Resources

- **README.md** - Project overview and quick start
- **SETUP.md** - Installation and setup guide
- **WORKFLOW.md** - Three-agent model and commands
- **docflow/knowledge/README.md** - Knowledge base guide
- **docflow/specs/templates/README.md** - Template guide

---

## Tool-Specific Files

### Using Cursor?
You're already set! Rules auto-load.

### Using Claude Desktop?
See `.claude/rules.md`

### Using VS Code with Copilot?
See `.github/copilot-instructions.md`

### Using Something Else?
This file (AGENTS.md) is your starting point. Read the rules in `.cursor/rules/docflow.mdc`.

---

**The workflow is tool-agnostic. The rules define behavior, not the AI tool.**

