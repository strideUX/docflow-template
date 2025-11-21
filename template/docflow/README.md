# DocFlow Quick Reference

Welcome to the DocFlow directory! This is your workspace for spec-driven development.

---

## 📁 What's Here

### Current Work
- **ACTIVE.md** - What's being worked on right now (check this first!)
- **INDEX.md** - Complete inventory of all work (backlog, active, completed)

### Project Context
**`context/`** - Stable project fundamentals
- `overview.md` - Vision, goals, users, success criteria
- `stack.md` - Tech stack, architecture patterns
- `standards.md` - Code conventions, quality rules

### Spec Workflow
**`specs/`** - All work items flow through here
- `templates/` - Spec templates (feature, bug, chore, idea)
- `backlog/` - Planned work, priority ordered
- `active/` - Currently being implemented
- `complete/` - Finished work, archived by quarter (YYYY-QQ)
- `assets/` - Spec-specific screenshots, references

### Project Knowledge
**`knowledge/`** - Growing knowledge base
- `INDEX.md` - Scan this first to find what you need!
- `decisions/` - Architecture decisions (numbered ADRs)
- `features/` - Complex feature documentation
- `notes/` - Technical discoveries and gotchas
- `product/` - User personas, flows, UX guidelines

---

## 🔄 Workflow Commands

**See `WORKFLOW.md` for the complete three-agent model.**

### Quick Command Reference

**PM/Planning Agent:**
- `/start-session` - Begin your work session
- `/capture` - Quick capture new work
- `/review [spec]` - Refine backlog items
- `/activate [spec]` - Ready for implementation
- `/close [spec]` - Archive completed work
- `/wrap-session` - End your session

**Implementation Agent:**
- `/implement [spec]` - Pick up and build
- `/block` - Hit a blocker

**QE/Validation Agent:**
- `/validate [spec]` - Test and validate

**Any Agent:**
- `/status` - Check current state

**System Setup:**
- `/docflow-new` - Set up new project
- `/docflow-scan` - Retrofit existing project

---

## 🎯 How Specs Flow

### Features & Bugs (Full Workflow)
```
BACKLOG → READY → IMPLEMENTING → REVIEW → QE_TESTING → COMPLETE
   ↓        ↓          ↓            ↓           ↓           ↓
  Plan   Activate    Build       Review      Test      Archive
```

### Chores & Ideas (Simplified)
```
BACKLOG → ACTIVE → COMPLETE
   ↓        ↓         ↓
  Plan    Work     Archive
```

---

## 💡 Quick Tips

### Starting Your Day
1. Run `/start-session` or just say "let's start"
2. Check what needs attention (QE approvals, reviews, blockers)
3. Pick what to work on

### Capturing New Work
- Just say "capture that" or "add to backlog"
- Agent will ask type: feature, bug, chore, or idea
- Quick capture, then continue current work

### Implementing Features
1. Switch to fresh Implementation agent thread
2. Say "implement [spec-name]"
3. Agent loads spec and builds it
4. Auto-marks for review when complete

### Testing & Validation
1. Switch to fresh QE agent thread
2. Say "validate [spec-name]"
3. Work iteratively with agent to test
4. Say "looks good" to approve

### Closing Work
1. Back in PM agent thread
2. Run `/close [spec-name]`
3. Spec archived, next work queued

---

## 📋 Using Specs

### Spec Templates
Located in `specs/templates/`:
- **feature.md** - New functionality (S/M/L/XL complexity)
- **bug.md** - Fix defects
- **chore.md** - Maintenance and improvements (no complexity)
- **idea.md** - Quick exploration

Each template has inline `<!-- AGENT INSTRUCTIONS -->` to guide creation.

### Acceptance Criteria
- Check off as you complete: `[ ]` → `[x]`
- Make them specific and testable
- These drive implementation

### Decision Logs
- Add dated entries as you make decisions
- Format: `### YYYY-MM-DD - Decision Title`
- Include rationale and alternatives considered

### Implementation Notes
- Fill progressively as you work
- Document files changed
- Note key decisions
- Explain deviations from plan

---

## 📚 Knowledge Base

### Scan the INDEX First
`knowledge/INDEX.md` is lightweight (~500 tokens).

Read it to find what knowledge exists, then load only what you need.

### What Goes Where

**`decisions/`** - Architecture decisions
- Format: `NNN-decision-title.md`
- When: Making architectural choices
- Example: "001-why-convex.md"

**`features/`** - Complex feature docs
- When: Feature is architecturally complex
- Documents how complex things work internally

**`notes/`** - Real-time discoveries
- API quirks, library limitations, workarounds
- Quick notes that might become decisions later

**`product/`** - UX artifacts
- User personas
- User flows and journeys
- Design guidelines

---

## 🔍 Finding Things

### Where is...?
- **Current work** → ACTIVE.md
- **What exists** → INDEX.md
- **How to code** → context/standards.md
- **Tech stack** → context/stack.md
- **Why we decided X** → knowledge/decisions/
- **How feature Y works** → knowledge/features/
- **User personas** → knowledge/product/personas.md
- **Spec templates** → specs/templates/
- **Active specs** → specs/active/
- **Backlog** → specs/backlog/

### Search Tools
- Use `codebase_search` for existing code
- Use `grep` for exact patterns
- Check knowledge/INDEX.md for documented patterns
- Check INDEX.md for related specs

---

## ⚠️ Critical Rules

### Never Create Root Status Files
❌ NO: STATUS.md, SUMMARY.md, TODO.md in project root  
✅ YES: All tracking in ACTIVE.md and specs

### Move Files Atomically
1. DELETE source file
2. CREATE destination file
3. Update ACTIVE.md and INDEX.md in same operation

### Search Before Creating
- Use codebase_search to find existing code
- Check knowledge base for patterns
- Don't duplicate functionality

### Update as You Go
- Check off acceptance criteria
- Fill Implementation Notes progressively
- Update Last Updated timestamps
- Keep ACTIVE.md current

---

## 🎓 Learning More

- **`../WORKFLOW.md`** - Three-agent model and command guide
- **`../.cursor/rules/docflow.mdc`** - Complete rules (source of truth)
- **`../.cursor/commands/`** - Detailed command files
- **`../AGENTS.md`** - Universal AI agent instructions
- **`specs/templates/README.md`** - Template guide
- **`knowledge/README.md`** - Knowledge base guide

---

## 🚀 Getting Started

**New project?** Run `/docflow-new`  
**Existing project?** Run `/docflow-scan`  
**Daily work?** Run `/start-session`

**Need help?** Just ask! The system is designed for natural conversation.

---

**Last Updated:** 2024-11-21  
**DocFlow Version:** 1.0

