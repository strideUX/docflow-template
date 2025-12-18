# DocFlow Cloud Rules for Warp

This project uses **DocFlow Cloud**, a spec-driven development workflow with Linear integration.

---

## 📖 Read the Source of Truth

**`.cursor/rules/docflow.mdc`**

This file contains the complete DocFlow system. **You MUST read it** to understand:
- Three-agent orchestration model
- Command system and natural language triggers
- Context loading strategy (situational, not auto-load)
- Linear integration patterns
- Knowledge base usage

**Also read:**
- `.docflow/config.json` - Configuration (paths, provider settings)
- `WARP.md` - Warp-specific workflow guide
- `AGENTS.md` - Universal agent instructions

---

## Quick Start

### 1. Read Configuration First
```bash
cat .docflow/config.json
```
This tells you:
- `paths.content` - Where context/knowledge folders are (default: "docflow")
- `provider` - Linear team and project IDs

### 2. Understand Your Role
DocFlow uses a **three-agent model**:
- **PM/Planning Agent** - Plans, refines, activates, closes work (in Linear)
- **Implementation Agent** - Builds features, fixes bugs
- **QE/Validation Agent** - Tests and validates with user

See `AGENTS.md` for the visual model.

### 3. Check Current State
On every interaction:
```
✓ Read .docflow/config.json for paths
✓ Query Linear for "In Progress" issues
✓ Read {paths.content}/context/ for project understanding
```

### 4. Load Context Situationally
**Don't load everything!** Load based on task:
- **Planning:** overview.md, Linear backlog
- **Implementing:** Linear issue, stack.md, standards.md
- **Creating/Refining issues:** Templates from `.docflow/templates/`
- **Reviewing:** Linear issue + comments, standards.md

See `.cursor/rules/docflow.mdc` for complete context loading rules.

### 5. Use Commands or Natural Language
**Commands:** `/start-session`, `/implement`, `/validate`, etc.  
**Natural language:** "let's start", "build this", "test it"

Both work the same way.

---

## Key Cloud Differences

### Specs Live in Linear
- ❌ NO local spec files in `{paths.content}/specs/`
- ❌ NO `INDEX.md` or `ACTIVE.md` files
- ✅ All specs are **Linear issues**
- ✅ Status tracked by **Linear workflow states**
- ✅ Progress notes in **Linear comments**

### Local Context Stays
- ✅ `{paths.content}/context/` - Project understanding
- ✅ `{paths.content}/knowledge/` - ADRs, features, notes
- ✅ Rules and commands in `.cursor/`

### Framework in .docflow/
- ✅ `.docflow/config.json` - Configuration
- ✅ `.docflow/templates/` - Issue templates with agent instructions
- ✅ `.docflow/version` - For upgrade detection

---

## Warp-Specific Notes

### Terminal-First Workflow
Warp is excellent for:
- **Implementation Agent work** - Direct terminal access for builds, tests, git
- **Reading local context** - Quick file viewing
- **Running validation** - Tests, type-checking, linting
- **Fast iteration** - Build → test → fix cycles

### Using Warp AI
When working with Warp's AI:
1. Reference this file: "Read .warp/rules.md for project workflow"
2. Check config: "Read .docflow/config.json for paths"
3. Point to Linear: "Check Linear for issue LIN-XXX"
4. Follow DocFlow patterns described in AGENTS.md
5. Reference command specs in `.cursor/commands/` for detailed behavior

### Long Conversations
Warp works well for:
- **Implementation Agent** - Focused terminal-based building
- **Quick context checks** - Fast file access

For extended planning or QE sessions with Linear, consider Cursor or Claude.

---

## Commands Available

See `.cursor/commands/` for detailed command files.

**PM Agent:** start-session, wrap-session, capture, refine, activate, close, project-update, sync-project  
**Implementation Agent:** implement, block, attach  
**QE Agent:** validate  
**All Agents:** status  
**System:** docflow-update

---

## Workflow States (in Linear)

**Features & Bugs:**
```
Backlog → In Progress → In Review → QA → Done
```

**Chores & Ideas:**
```
Backlog → In Progress → Done
```

---

## Issue Metadata

- **Priority:** 1=Urgent, 2=High, 3=Medium, 4=Low
- **Estimate:** 1=XS, 2=S, 3=M, 4=L, 5=XL
- **Checkboxes:** Update in description as criteria completed (`- [ ]` → `- [x]`)
- **Comments:** Use `**Status** — Brief note.` format

## Team Collaboration

- **Assign:** `updateIssue(id, { assignee: "name" })` — by name, email, or "me"
- **Subscribers:** Add via GraphQL `subscriberIds` for notifications
- **Find users:** `list_users({ query: "name" })`

---

## Critical Rules

Read `.cursor/rules/docflow.mdc` for complete rules. Key ones:

1. ❌ Never create local spec files (use Linear)
2. ✅ All specs → Linear issues
3. ✅ Status changes → Linear state updates
4. ✅ Progress notes → Linear comments
5. ✅ Context/knowledge stays local
6. ✅ Templates in `.docflow/templates/`
7. ✅ Load context situationally
8. ✅ Wait for user approval before closing

---

## For Complete System Documentation

1. **`.docflow/config.json`** - Configuration
2. **`.cursor/rules/docflow.mdc`** - Complete rules ⭐ READ THIS
3. **`WARP.md`** - Warp workflow guide
4. **`AGENTS.md`** - Universal instructions
5. **`.cursor/commands/`** - Command details

---

**Warp works great with DocFlow Cloud!** Use it for focused implementation and terminal-based workflows.
