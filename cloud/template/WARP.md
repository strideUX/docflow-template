# DocFlow Cloud for Warp

This project uses **DocFlow Cloud**, a spec-driven development workflow with Linear integration.

**For complete rules:** Read `.cursor/rules/docflow.mdc`  
**For Warp adapter:** Read `.warp/rules.md`

---

## 🚀 Quick Start for Warp Users

### 1. Check Current State
```bash
# Quick context check
cat docflow/context/overview.md | head -20

# Check Linear status (via CLI if installed)
# Or ask Warp AI: "What's the current status in Linear?"
```

### 2. Understand the Three-Agent Model

| Agent | Role | Best Tool |
|-------|------|-----------|
| **PM/Planning** | Orchestration, planning, closing | Cursor, Claude |
| **Implementation** | Building features, fixing bugs | Warp, Cursor |
| **QE/Validation** | Testing with user | Cursor, Claude |

**Warp excels at Implementation Agent work** - direct terminal access, fast builds, efficient operations.

### 3. Work with Warp AI

When using Warp's AI assistant:
- Say: "Read .warp/rules.md for project workflow"
- Reference: "Check Linear for current issues"
- For commands: "Follow .cursor/commands/implement.md"

---

## 📋 Available Commands

DocFlow uses slash commands. In Warp, describe the command behavior to the AI or reference the command file.

### PM/Planning Agent
| Command | Purpose | Warp Usage |
|---------|---------|------------|
| `/start-session` | Begin session, check Linear | "Run start-session workflow" |
| `/capture` | Create Linear issue | "Capture this as a feature/bug/chore" |
| `/review` | Refine backlog item | "Review LIN-XXX" |
| `/activate` | Ready for implementation | "Activate LIN-XXX" |
| `/close` | Archive completed work | "Close LIN-XXX" |
| `/wrap-session` | End session, save state | "Wrap up the session" |

### Implementation Agent
| Command | Purpose | Warp Usage |
|---------|---------|------------|
| `/implement` | Pick up and build | "Implement LIN-XXX" |
| `/block` | Document blocker | "I'm blocked on this" |

### QE/Validation Agent
| Command | Purpose | Warp Usage |
|---------|---------|------------|
| `/validate` | Test and validate | "Validate LIN-XXX" |

### All Agents
| Command | Purpose | Warp Usage |
|---------|---------|------------|
| `/status` | Check Linear state | "What's the current status?" |
| `/docflow-update` | Sync rules | "Update docflow" |

---

## 📁 Directory Structure

```
project/
├── .cursor/
│   ├── rules/docflow.mdc    # Workflow rules
│   ├── commands/            # Slash commands
│   └── mcp.json             # Linear + Figma MCPs
├── docflow/
│   ├── context/             # Project understanding (LOCAL)
│   │   ├── overview.md
│   │   ├── stack.md
│   │   └── standards.md
│   └── knowledge/           # Project knowledge (LOCAL)
│       ├── INDEX.md
│       ├── decisions/
│       ├── features/
│       └── notes/
├── .docflow.json            # Config (Linear IDs)
└── AGENTS.md                # Agent instructions

LINEAR (Cloud):
├── Issues                   # All specs live here
├── Workflow States          # BACKLOG → DONE
├── Comments                 # Decision log, impl notes
└── Attachments              # Figma, screenshots
```

---

## ⚡ Workflow States (in Linear)

**Features & Bugs (Full Workflow):**
```
Backlog → Todo → In Progress → In Review → QA → Done
```

**Chores & Ideas (Simplified):**
```
Backlog → In Progress → Done
```

---

## ⚠️ Key Differences from Local DocFlow

| Local Version | Cloud Version |
|---------------|---------------|
| Specs in `docflow/specs/` | Specs in **Linear** |
| `INDEX.md` for inventory | **Linear issue list** |
| `ACTIVE.md` for status | **Linear "In Progress"** |
| File moves for workflow | **Linear state changes** |
| Local markdown | **Linear comments** |

**What stays local:**
- `docflow/context/` - Project understanding
- `docflow/knowledge/` - ADRs, feature docs, notes
- Rules and commands

---

## 🛠️ Suggested Shell Aliases

Add these to your `.zshrc` or `.bashrc`:

```bash
# DocFlow Navigation
alias df-context='cat docflow/context/overview.md'
alias df-stack='cat docflow/context/stack.md'
alias df-standards='cat docflow/context/standards.md'
alias df-knowledge='cat docflow/knowledge/INDEX.md'

# Quick context check
df-status() {
  echo "=== Project Overview ==="
  head -20 docflow/context/overview.md
  echo "\n=== Tech Stack ==="
  head -15 docflow/context/stack.md
  echo "\n=== Check Linear for current work ==="
}

# Open Linear (macOS)
alias df-linear='open "https://linear.app"'
```

---

## 💡 Tips for Warp with Linear

### Terminal Workflow
```bash
# View local context
cat docflow/context/stack.md

# Search knowledge
grep -r "authentication" docflow/knowledge/

# Check config
cat .docflow.json
```

### Working with Warp AI
- Keep conversations focused (fresh threads for each issue)
- Reference Linear issue IDs: "Working on LIN-123"
- Ask AI to query Linear: "What issues are in progress?"

### Best For
- ✅ Implementation work (builds, tests, git)
- ✅ Reading local context
- ✅ File operations
- ✅ Terminal-heavy workflows

### Consider Cursor/Claude For
- Extended planning sessions
- Iterative QE testing with user
- Figma design integration
- Complex Linear operations

---

## 🔗 Related Files

| File | Purpose |
|------|---------|
| `.cursor/rules/docflow.mdc` | Complete rules (source of truth) |
| `.warp/rules.md` | Warp adapter rules |
| `.claude/rules.md` | Claude adapter rules |
| `AGENTS.md` | Universal AI instructions |
| `.cursor/commands/` | Detailed command specs |
| `.docflow.json` | Linear configuration |

---

**DocFlow Cloud works great in Warp!** 🎉

