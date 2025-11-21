# DocFlow Rules for Claude Desktop

This project uses **DocFlow**, a spec-driven development workflow optimized for AI-assisted development.

---

## 📖 Read the Source of Truth

**`.cursor/rules/docflow.mdc`**

This file contains the complete DocFlow system. **You MUST read it** to understand:
- Three-agent orchestration model
- Command system and natural language triggers
- Context loading strategy (situational, not auto-load)
- File movement rules (atomic operations)
- Spec lifecycle management
- Knowledge base usage

**Also read:**
- `WORKFLOW.md` - Visual workflow guide
- `docflow/ACTIVE.md` - Current work state (always check this)
- `AGENTS.md` - Universal agent instructions

---

## Quick Start

### 1. Understand Your Role
DocFlow uses a **three-agent model**:
- **PM/Planning Agent** - Plans, refines, activates, closes work
- **Implementation Agent** - Builds features, fixes bugs
- **QE/Validation Agent** - Tests and validates with user

See `WORKFLOW.md` for the visual model.

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

## Claude Desktop Specific Notes

### Chat Interface
- Commands work with `/` prefix
- Natural language triggers work the same as Cursor
- Multi-turn conversations supported (perfect for QE validation)

### Project Context
Claude Desktop can access:
- All docflow/ files
- Command files in .cursor/commands/
- Templates and knowledge base

**Load situationally** - don't request all files at once.

### Long Conversations
Claude Desktop is excellent for:
- **PM Agent** - Long-running planning sessions
- **QE Agent** - Iterative testing with user

Use fresh chats for:
- **Implementation Agent** - Focused building

### File Operations
- Claude can create/update specs
- Claude can move files between folders
- Follow atomic movement rules (delete then create)

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
2. ✅ Always move files atomically (delete → create)
3. ✅ Search before creating code (avoid duplicates)
4. ✅ Load context situationally (not everything)
5. ✅ Follow spec templates (inline instructions)
6. ✅ Update as you go (ACTIVE.md, criteria, logs)
7. ✅ Wait for user approval before closing specs

---

## For Complete System Documentation

1. **`.cursor/rules/docflow.mdc`** - Complete rules ⭐ READ THIS
2. **`WORKFLOW.md`** - Workflow guide
3. **`AGENTS.md`** - Universal instructions
4. **`.cursor/commands/`** - Command details

---

**Claude Desktop works great with DocFlow!** Use it for planning and QE validation especially.
