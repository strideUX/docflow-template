# DocFlow for Warp

This project uses **DocFlow**, a spec-driven development workflow optimized for AI-assisted development.

**For complete rules:** Read `.cursor/rules/docflow.mdc`  
**For Warp adapter:** Read `.warp/rules.md`

---

## 🚀 Quick Start for Warp Users

### 1. Check Current State
```bash
# Quick status check
cat docflow/ACTIVE.md

# See active specs
ls -la docflow/specs/active/

# See backlog
ls -la docflow/specs/backlog/
```

### 2. Understand the Three-Agent Model

| Agent | Role | Best Tool |
|-------|------|-----------|
| **PM/Planning** | Orchestration, planning, closing | Cursor, Claude |
| **Implementation** | Building features, fixing bugs | Warp, Cursor |
| **QE/Validation** | Testing with user | Cursor, Claude |

**Warp excels at Implementation Agent work** - direct terminal access, fast builds, efficient file operations.

### 3. Work with Warp AI

When using Warp's AI assistant:
- Say: "Read .warp/rules.md for project workflow"
- Reference: "Check docflow/ACTIVE.md for current state"
- For commands: "Follow .cursor/commands/implement.md"

---

## 📋 Available Commands

DocFlow uses slash commands. In Warp, describe the command behavior to the AI or reference the command file.

### PM/Planning Agent
| Command | Purpose | Warp Usage |
|---------|---------|------------|
| `/start-session` | Begin session, check status | "Run start-session workflow" |
| `/capture` | Quick capture to backlog | "Capture this as a feature/bug/chore" |
| `/review` | Refine backlog item | "Review [spec-name]" |
| `/activate` | Ready for implementation | "Activate [spec-name]" |
| `/close` | Archive completed work | "Close [spec-name]" |
| `/wrap-session` | End session, save state | "Wrap up the session" |

### Implementation Agent
| Command | Purpose | Warp Usage |
|---------|---------|------------|
| `/implement` | Pick up and build | "Implement [spec-name]" |
| `/block` | Document blocker | "I'm blocked on this" |

### QE/Validation Agent
| Command | Purpose | Warp Usage |
|---------|---------|------------|
| `/validate` | Test and validate | "Validate [spec-name]" |

### All Agents
| Command | Purpose | Warp Usage |
|---------|---------|------------|
| `/status` | Check current state | "What's the current status?" |

---

## 🛠️ Suggested Shell Aliases

Add these to your `.zshrc` or `.bashrc` for quick DocFlow operations:

```bash
# DocFlow Navigation
alias df-status='cat docflow/ACTIVE.md && echo "\n--- Active Specs ---" && ls -la docflow/specs/active/'
alias df-active='ls -la docflow/specs/active/'
alias df-backlog='ls -la docflow/specs/backlog/'
alias df-index='cat docflow/INDEX.md'

# Quick spec access
df-spec() {
  local spec="$1"
  if [ -f "docflow/specs/active/${spec}.md" ]; then
    ${EDITOR:-code} "docflow/specs/active/${spec}.md"
  elif [ -f "docflow/specs/backlog/${spec}.md" ]; then
    ${EDITOR:-code} "docflow/specs/backlog/${spec}.md"
  else
    echo "Spec not found: $spec"
    echo "Active specs:" && ls docflow/specs/active/
    echo "Backlog specs:" && ls docflow/specs/backlog/
  fi
}

# Move spec to active (activate)
df-activate() {
  local spec="$1"
  if [ -f "docflow/specs/backlog/${spec}.md" ]; then
    mv "docflow/specs/backlog/${spec}.md" "docflow/specs/active/${spec}.md"
    echo "Activated: $spec"
  else
    echo "Spec not found in backlog: $spec"
  fi
}

# Move spec to complete (archive)
df-complete() {
  local spec="$1"
  local quarter=$(date +%Y-Q)$(( ($(date +%-m) - 1) / 3 + 1 ))
  mkdir -p "docflow/specs/complete/${quarter}"
  if [ -f "docflow/specs/active/${spec}.md" ]; then
    mv "docflow/specs/active/${spec}.md" "docflow/specs/complete/${quarter}/${spec}.md"
    echo "Completed: $spec → complete/${quarter}/"
  else
    echo "Spec not found in active: $spec"
  fi
}
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
│   └── complete/          # Archived by quarter
└── knowledge/             # Project knowledge
    ├── INDEX.md           # Scan this first!
    ├── decisions/         # Architecture decisions
    ├── features/          # Complex feature docs
    └── notes/             # Technical discoveries
```

---

## ⚡ Workflow States

**Features & Bugs (Full Workflow):**
```
BACKLOG → READY → IMPLEMENTING → REVIEW → QE_TESTING → COMPLETE
```

**Chores & Ideas (Simplified):**
```
BACKLOG → ACTIVE → COMPLETE
```

---

## ⚠️ Critical Rules

1. **❌ Never create root-level status files** - Use docflow/ACTIVE.md
2. **✅ Use `mv` for file moves** - Single operation, efficient
3. **✅ Update tracking files** - ACTIVE.md and INDEX.md after changes
4. **✅ Search before creating** - Avoid duplicate code
5. **✅ Wait for approval** - Don't auto-close specs

---

## 🔗 Related Files

| File | Purpose |
|------|---------|
| `.cursor/rules/docflow.mdc` | Complete rules (source of truth) |
| `.warp/rules.md` | Warp adapter rules |
| `.claude/rules.md` | Claude adapter rules |
| `AGENTS.md` | Universal AI instructions |
| `.cursor/commands/` | Detailed command specifications |

---

## 💡 Tips for Warp

### Terminal Efficiency
```bash
# Quick file moves (preferred over delete/create)
mv docflow/specs/backlog/feature-x.md docflow/specs/active/

# View spec without opening editor
cat docflow/specs/active/feature-x.md | head -50

# Search specs
grep -r "status.*IMPLEMENTING" docflow/specs/active/
```

### Working with Warp AI
- Keep conversations focused (fresh threads for each spec)
- Reference specific files rather than asking AI to guess
- Use natural language triggers from the rules file

### Best For
- ✅ Implementation work (builds, tests, git)
- ✅ Quick status checks
- ✅ File operations
- ✅ Terminal-heavy workflows

### Consider Cursor/Claude For
- Extended planning sessions
- Iterative QE testing with user
- Complex multi-file refactoring

---

**DocFlow works great in Warp!** 🎉

