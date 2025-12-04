# DocFlow Rules for Warp

This project uses **DocFlow**, a spec-driven development workflow optimized for AI-assisted development.

---

## 📖 Read the Source of Truth

**`.cursor/rules/docflow.mdc`**

This file contains the complete DocFlow system. **You MUST read it** to understand:
- Three-agent orchestration model
- Command system and natural language triggers
- Context loading strategy (situational, not auto-load)
- File movement rules (efficient mv operations)
- Spec lifecycle management
- Knowledge base usage

**Also read:**
- `WARP.md` - Warp-specific workflow guide
- `docflow/ACTIVE.md` - Current work state (always check this)
- `AGENTS.md` - Universal agent instructions

---

## Quick Start

### 1. Understand Your Role
DocFlow uses a **three-agent model**:
- **PM/Planning Agent** - Plans, refines, activates, closes work
- **Implementation Agent** - Builds features, fixes bugs
- **QE/Validation Agent** - Tests and validates with user

See `AGENTS.md` for the visual model.

### 2. Check Current State
On every interaction:
```
✓ Read docflow/ACTIVE.md (what's happening now)
✓ Scan docflow/specs/active/ (check statuses)
```

### 3. Load Context Situationally
**Don't load everything!** Load based on task:
- **Planning:** overview.md, INDEX.md, knowledge/INDEX.md
- **Implementing:** spec, stack.md, standards.md
- **Reviewing:** spec, standards.md

See `.cursor/rules/docflow.mdc` for complete context loading rules.

### 4. Use Commands or Natural Language
**Commands:** `/start-session`, `/implement`, `/validate`, etc.  
**Natural language:** "let's start", "build this", "test it"

Both work the same way.

---

## Warp-Specific Notes

### Terminal-First Workflow
Warp is excellent for:
- **Implementation Agent work** - Direct terminal access for builds, tests, git
- **File operations** - Efficient mv commands for spec management
- **Running validation** - Tests, type-checking, linting
- **Quick status checks** - Fast file browsing and viewing

### Using Warp AI
When working with Warp's AI:
1. Reference this file: "Read .warp/rules.md for project workflow"
2. Point to specs: "Check docflow/ACTIVE.md for current state"
3. Follow DocFlow patterns described in AGENTS.md
4. Reference command specs in `.cursor/commands/` for detailed behavior

### Long Conversations
Warp works well for:
- **Implementation Agent** - Focused terminal-based building
- **Quick status checks** - Fast context switching

For extended planning or QE sessions, consider Cursor or Claude Desktop.

### File Operations
- Warp can create/update specs via AI
- Use terminal `mv` command for efficiency (single operation)
- Direct file editing with your preferred editor

---

## Commands Available

See `.cursor/commands/` for detailed command files.

**PM Agent:** start-session, wrap-session, capture, review, activate, close  
**Implementation Agent:** implement, block  
**QE Agent:** validate  
**All Agents:** status  

---

## Workflow States

**Features & Bugs:**
```
BACKLOG → READY → IMPLEMENTING → REVIEW → QE_TESTING → COMPLETE
```

**Chores & Ideas:**
```
BACKLOG → ACTIVE → COMPLETE
```

---

## Critical Rules

Read `.cursor/rules/docflow.mdc` for complete rules. Key ones:

1. ❌ Never create root-level status files
2. ✅ Use terminal mv command to move files (efficient, single operation)
3. ✅ Search before creating code (avoid duplicates)
4. ✅ Load context situationally (not everything)
5. ✅ Follow spec templates (inline instructions)
6. ✅ Update as you go (ACTIVE.md, criteria, logs)
7. ✅ Wait for user approval before closing specs

---

## For Complete System Documentation

1. **`.cursor/rules/docflow.mdc`** - Complete rules ⭐ READ THIS
2. **`WARP.md`** - Warp workflow guide
3. **`AGENTS.md`** - Universal instructions
4. **`.cursor/commands/`** - Command details

---

**Warp works great with DocFlow!** Use it for focused implementation and terminal-based workflows.

