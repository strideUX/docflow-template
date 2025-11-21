# DocFlow Scan (System Setup)

## Purpose
Analyze existing codebase and retrofit or update DocFlow documentation.

**Handles three scenarios:**
- **2a:** Code exists, no DocFlow → Create DocFlow from scratch
- **2b:** Code exists, old DocFlow → Migrate and update
- **2c:** Code exists, broken DocFlow → Fix and align

**Agent Role:** PM/Planning Agent  
**Frequency:** Once per existing project (or when DocFlow needs refresh)

---

## When to Trigger

### Automatic Detection
Run when:
- User says "scan this project", "analyze codebase", "add DocFlow"
- Finding existing code but DocFlow is missing/incomplete
- Context files don't match actual codebase

### Smart Detection
Check project state and route to appropriate path:
```
if (no /docflow/ folder exists)
  → Path A: Create DocFlow from Scratch (Scenario 2a)
  
else if (context files are templates OR empty)
  → Path B: Fill Empty DocFlow (Scenario 2b variant)
  
else if (old spec system detected in different location)
  → Path C: Migrate Old Spec System (Scenario 2b)
  
else if (DocFlow exists but seems outdated)
  → Path D: Update Existing DocFlow (Scenario 2b)
```

---

## Path A: Create DocFlow from Scratch (No DocFlow Exists)

### Phase 1: Initial Assessment (1-2 min)

**Detect project:**
1. Check package management (package.json, requirements.txt, etc.)
2. Identify framework (Next.js, React, Django, etc.)
3. Scan directory structure
4. Count source files (assess size)

**Message user:**
"I found a [framework] project with [X files]. Let me analyze it to understand what you've built..."

### Phase 2: Deep Code Analysis (5-10 min)

**Scan systematically:**
1. Read README/docs (if exists)
2. Analyze entry points (main files, routes)
3. Map features by directory/module
4. Detect patterns and conventions
5. Identify tech stack components
6. Find data models/schemas
7. Note external integrations

**Progress updates:**
- "Found authentication using [X]..."
- "Detected [N] main features..."
- "Using [database] with [patterns]..."

### Phase 3: Ask Clarifying Questions (2-3 min)

**Fill gaps:**
- Project purpose (if not clear)
- Target users
- Incomplete features (in progress or abandoned?)
- Technical decisions (why X approach?)
- Current priorities
- Known issues or tech debt

### Phase 4: Fill Context Files

**Auto-generate from code analysis:**

**`overview.md`:**
- Extract from README or generate from code
- List discovered features
- Note user types if detectable

**`stack.md`:**
- Document detected stack
- List patterns found in code
- Note deployment setup

**`standards.md`:**
- Document existing conventions
- Keep best practices from template

### Phase 5: Document Existing Features

**For each major feature found:**

Create in `/docflow/specs/complete/YYYY-QQ/`:
```markdown
# Feature: [Feature Name]

**Status**: COMPLETE (Discovered during scan)
**Completed**: [Before scan - estimate or ask]

## Context
[What this feature does from code analysis]

## Implementation
**Key Files:**
- [List main files]

**Patterns:**
- [Patterns discovered]

## Decision Log
- [Scan Date]: Feature discovered and documented during project scan
```

### Phase 6: Populate Knowledge Base

**If complex systems found:**
- Document in /docflow/knowledge/features/
- Example: "sprint-planning-algorithm.md"

**If interesting patterns:**
- Document in /docflow/knowledge/notes/
- Example: "real-time-sync-gotchas.md"

### Phase 7: Update Tracking Files

**Initialize:**
- /docflow/ACTIVE.md with timestamp
- /docflow/INDEX.md with:
  - Completed: All discovered features
  - Backlog: Next features from conversation

**Suggest next work:**
- Identify incomplete features
- Capture planned features from discussion
- Create specs in backlog

---

## Path B: Migrate Old Spec System (Existing Specs)

### Phase 1: Detect Old System

**Check for:**
- Old spec folders (./specs/, .specs/, docs/specs/)
- Different file formats
- Old tracking systems (BACKLOG.md, TODO.md)

**Analyze structure:**
- What format are they using?
- Which specs are current vs outdated?
- What's valuable to preserve?

### Phase 2: Ask Before Changes

**⚠️ IMPORTANT: Get user approval first**

"I found an existing spec system in [location]:
- [N] specs in old format
- Last updated: [date from git or files]

Options:
1. **Archive and start fresh** - Save old system, create new DocFlow
2. **Migrate and update** - Convert to new format, preserve history
3. **Leave as-is** - Don't touch old system

What would you like to do?"

**Wait for user decision.**

### Phase 3: Archive Old System

**If user approves migration:**

1. Create `/docflow/specs/archived-[YYYY-MM-DD]/`
2. Copy entire old system there
3. Create `MIGRATION.md`:
```markdown
# Migration from Old Spec System

**Date**: YYYY-MM-DD
**Old Location**: [where it was]
**Old Format**: [description]

## What Was Migrated
- [N] specs converted to new format
- [N] specs archived (outdated/complete)

## What Was Preserved
- All decision history
- All implementation notes
- All completion dates

## New Location
- Active work: /docflow/specs/active/
- Backlog: /docflow/specs/backlog/
- Completed: /docflow/specs/complete/[quarters]/
```

### Phase 4: Convert Relevant Specs

**For each valuable spec:**
1. Determine status (complete, in-progress, planned)
2. Convert to appropriate template
3. Preserve all content and history
4. Place in correct folder:
   - Complete → complete/[quarter]/
   - In progress → active/ with status=IMPLEMENTING
   - Planned → backlog/

**Update format but keep content:**
- Keep decision logs
- Keep implementation notes
- Update to new status system
- Add missing sections

### Phase 5: Fill Context Files

**Use code + old specs:**
- Extract context from old specs
- Combine with code analysis
- Fill overview.md, stack.md, standards.md
- Update with current reality (not just what specs say)

---

## Path C: Update Existing DocFlow

### Phase 1: Compare DocFlow to Code

**Check for drift:**
- Context files vs actual stack
- Completed specs vs actual features
- Standards vs actual code patterns

**Ask user:**
"I see some differences between DocFlow and the actual code:
- stack.md says [X], but code uses [Y]
- Feature [A] is marked incomplete, but looks done in code
- [Other drifts found]

Should I update DocFlow to match the current code?"

**Wait for approval.**

### Phase 2: Update Context Files

If approved:
- Update stack.md to match actual code
- Update standards.md to match actual patterns
- Refresh overview.md if project evolved

### Phase 3: Sync Spec States

**Check active specs:**
- Verify status matches reality
- Mark actually-complete specs as COMPLETE
- Archive old completed work
- Update priorities based on current work

### Phase 4: Populate Knowledge

**If knowledge/ is empty:**
- Extract decisions from old specs
- Document complex features
- Add technical notes discovered

---

## Phase Final: Summary & Handoff (All Paths)

**Provide comprehensive summary:**
```
📊 DocFlow Scan Complete!

**Project**: [Name]
**Type**: [Framework] [project type]
**Features**: [X existing, Y planned]

✅ DocFlow Setup:
   - Context files: [Created/Updated]
   - Stack documented: [Summary]
   - Standards captured: [Summary]

📁 Specs:
   - [N] existing features in complete/
   - [N] planned in backlog/
   - [Migration: N old specs archived] (if applicable)

📚 Knowledge Base:
   - [N] decisions documented
   - [N] features documented
   - [N] technical notes

🎯 Next Steps:
   Ready to start working! Run /start-session to begin.
   
   Suggested first action: [what makes sense]
```

---

## Tools to Use
- `list_dir` - Map directory structure
- `read_file` - Read files (README, configs, source)
- `grep` - Search for patterns
- `codebase_search` - Find implementations
- `glob_file_search` - Find files by type
- `run_terminal_cmd` - Git commands (if needed)

---

## Key Principles

### Be Thorough But Efficient
Focus on entry points, main features, shared utilities, configs. Don't read every file.

### Ask Before Changing
For scenario 2b (existing DocFlow), always ask before updating.

### Preserve History
If migrating, archive carefully. Don't delete anything.

### Document What Exists
Describe objectively what's there. Don't critique during scan.

### Make It Actionable
End with clear next steps. User should know exactly what to do.

---

## Checklist
- [ ] Detected which scenario (2a, 2b, 2c)
- [ ] Code analyzed appropriately
- [ ] User questions asked and answered
- [ ] Context files filled/updated
- [ ] Existing features documented
- [ ] Old specs migrated (if applicable)
- [ ] Knowledge base populated
- [ ] Tracking files initialized
- [ ] Clear summary provided
- [ ] Next steps identified
