# DocFlow Upgrade (Setup & Migration)

## Purpose
Install, migrate, or repair DocFlow in a project. Handles fresh installations, version upgrades, migrations from other systems, and repairs.

**This command makes file changes.** Always asks for approval before modifying project structure.

**Agent Role:** PM/Planning Agent  
**Frequency:** Once per project (or when upgrading versions)

---

## When to Trigger

### Automatic Detection
Run when:
- User says "upgrade docflow", "install docflow", "migrate to docflow"
- `/docflow-scan` recommended running upgrade
- User confirms they want to proceed with setup/migration

### Always Ask First
Before making any changes:
- Show what will be changed
- Explain migration/installation plan
- Get explicit approval
- Offer to archive old content

---

## Route to Correct Scenario

Detect project state and route to appropriate upgrade path:

```
if (no /docflow/ folder exists)
  → Scenario 1: Fresh Installation
  
else if (DocFlow 1.x detected - has shared/, reference/, etc.)
  → Scenario 2: Version Upgrade (1.x → 2.1)
  
else if (other spec system found - specs/ in different location)
  → Scenario 3: Migrate Other System
  
else if (DocFlow exists but broken/incomplete)
  → Scenario 4: Repair DocFlow
  
else
  → DocFlow 2.1 already installed and healthy
  → Suggest running /docflow-scan for health check
```

---

## Scenario 1: Fresh Installation (No DocFlow)

**Use when:** Project has code but no DocFlow system

### Phase 1: Confirm Installation (1 min)

**Show plan:**
```
I'll install DocFlow 2.1 in your project:

✅ Create /docflow/ structure
✅ Add platform adapters (AGENTS.md, .claude/, .github/)
✅ Fill context files from your codebase
✅ Document existing features
✅ Create initial backlog

This is safe - no code changes, only documentation added.

Ready to proceed?
```

**Wait for approval.**

### Phase 2: Analyze Codebase (5-10 min)

**Same as docflow-scan analysis:**
1. Detect framework and stack
2. Map features and structure
3. Identify patterns
4. Find integrations

**Progress updates:**
- "Analyzing your Next.js app..."
- "Found 15 features..."
- "Detecting patterns..."

### Phase 3: Ask Clarifying Questions (2-3 min)

**Fill gaps:**
- Project purpose (if not obvious from code/README)
- Target users
- Current priorities
- Known issues or tech debt
- Abandoned vs incomplete features

### Phase 4: Create DocFlow Structure

**Create folders:**
```
/docflow/
  ├── ACTIVE.md
  ├── INDEX.md
  ├── README.md
  ├── context/
  │   ├── overview.md
  │   ├── stack.md
  │   └── standards.md
  ├── knowledge/
  │   ├── INDEX.md
  │   ├── README.md
  │   ├── decisions/
  │   ├── features/
  │   ├── notes/
  │   └── product/
  │       ├── personas.md
  │       └── user-flows.md
  └── specs/
      ├── active/
      ├── backlog/
      ├── complete/
      │   └── YYYY-QQ/
      ├── assets/
      │   └── README.md
      └── templates/
          ├── README.md
          ├── feature.md
          ├── bug.md
          ├── chore.md
          └── idea.md
```

**Add platform adapters:**
```
/AGENTS.md
/.claude/
  └── rules.md
/.github/
  └── copilot-instructions.md
```

### Phase 5: Fill Context Files

**`context/overview.md`:**
- Extract from README or analyze code
- Document project purpose and vision
- List main features discovered
- Note target users

**`context/stack.md`:**
- Document detected stack
- List patterns found in code
- Note deployment setup
- Include file structure

**`context/standards.md`:**
- Use template best practices
- Add project-specific conventions found in code
- Note linting/formatting setup

### Phase 6: Document Existing Features

**For each major feature:**

Create spec in `/docflow/specs/complete/YYYY-QQ/`:

```markdown
# Feature: [Feature Name]

**Status**: COMPLETE
**Owner**: Implementation
**AssignedTo**: [from git]
**Priority**: [inferred]
**Complexity**: [S/M/L based on size]
**Created**: [estimate or ask]
**Completed**: [estimate - before scan date]

## Context
[What this feature does - from code analysis]

## User Story
As a [user type]
I want [capability]
So that [benefit]

## Implementation Summary
**Key Files:**
- [List main files]

**Patterns Used:**
- [Patterns discovered]

**Integrations:**
- [External services, if any]

## Decision Log
### [Scan Date] - Feature Documented
Feature discovered and documented during DocFlow installation.
Analyzed from existing codebase.
```

**Group by quarter** (estimate completion dates or use current quarter)

### Phase 7: Populate Knowledge Base

**If complex systems found:**
- Document in `/docflow/knowledge/features/`
- Example: "authentication-flow.md"

**If architectural decisions obvious:**
- Document in `/docflow/knowledge/decisions/`
- Example: "001-why-convex.md"

**If patterns/gotchas found:**
- Document in `/docflow/knowledge/notes/`

**Update knowledge/INDEX.md** with all entries

### Phase 8: Create Initial Backlog

**Ask about planned work:**
"What features are you planning to build next?"

**For each mentioned:**
- Create spec in backlog/
- Use appropriate template
- Fill what you know from conversation
- Leave some sections for refinement later

### Phase 9: Initialize Tracking Files

**ACTIVE.md:**
```markdown
# Current Work Status

**Last Updated:** YYYY-MM-DD HH:MM

DocFlow installed and initialized.
[N] existing features documented.

Ready to start working!

## Next Steps
1. Run /start-session to review backlog
2. Run /review [spec-name] to refine a backlog item
3. Run /activate [spec-name] to start implementing
```

**INDEX.md:**
- List all completed features
- List backlog items
- Set priorities

### Phase 10: Summary & Handoff

```
✅ DocFlow 2.1 Installed!

**Project:** [Name]
**Type:** [Framework] [Language]

📁 Structure Created:
   - Context files filled from codebase
   - [N] existing features documented
   - [N] planned features in backlog
   - Knowledge base initialized

🎯 Ready to Use:
   
   Run /start-session to begin working!
   
**Next Steps:**
1. Review backlog priorities
2. Refine a spec with /review [name]
3. Activate and implement with /activate [name]

Welcome to DocFlow! 🚀
```

---

## Scenario 2: Version Upgrade (DocFlow 1.x → 2.1)

**Use when:** Project has old DocFlow structure

### Phase 1: Detect Version & Show Changes

**Analyze current structure:**
- Check for 1.x indicators (shared/, reference/, dependencies.md)
- List what will be removed
- List what will be added
- List what will be migrated

**Show plan:**
```
📊 DocFlow 1.x Detected

**Changes in 2.1:**

❌ Will Remove:
- /docflow/shared/ (use search instead)
- /docflow/reference/ (moved to knowledge/)
- /docflow/dependencies.md (use search instead)
- /.templates/ (renamed to templates/)

✅ Will Add:
- /docflow/knowledge/ (decisions, features, notes, product)
- /docflow/specs/assets/ (spec-specific resources)
- AGENTS.md (universal AI instructions)
- .claude/ and .github/ (platform adapters)

🔄 Will Migrate:
- All specs (convert metadata: Time → Complexity)
- All context files (preserve + enhance)
- All completed work (reorganize if needed)
- All templates (updated to 2.1)

📦 Will Archive:
- Full backup to /docflow-v1-backup-YYYY-MM-DD/
- Removable after you confirm migration success

**This is non-destructive.** Old version archived, easy to rollback.

Proceed with upgrade?
```

**Wait for approval.**

### Phase 2: Backup Current DocFlow

**Create archive:**
1. Copy entire `/docflow/` → `/docflow-v1-backup-YYYY-MM-DD/`
2. Copy `.cursor/` → `.cursor-v1-backup-YYYY-MM-DD/` (if upgrading commands)
3. Create BACKUP-README.md in archive explaining what's there

**Verify backup:**
- Check all files copied
- Confirm archive readable
- Log archive location

### Phase 3: Create New Structure

**Add new folders:**
```
/docflow/knowledge/
  ├── INDEX.md
  ├── README.md
  ├── decisions/
  ├── features/
  ├── notes/
  └── product/
      ├── personas.md
      └── user-flows.md

/docflow/specs/assets/
  └── README.md

/docflow/templates/ (rename from .templates)
```

**Add platform adapters:**
```
/AGENTS.md
/.claude/rules.md
/.github/copilot-instructions.md
```

### Phase 4: Migrate Specs

**For each spec in old system:**

1. **Convert metadata:**
   - Remove: `Estimated Time: X hours`
   - Add: `Complexity: [S/M/L/XL]` (convert based on hours)
     - 2-4 hrs → S
     - 4-16 hrs → M
     - 16-40 hrs → L
     - 40+ hrs → XL

2. **Update template format:**
   - Ensure all 2.1 sections present
   - Add inline agent instructions if missing
   - Keep all existing content

3. **Preserve history:**
   - Keep all Decision Log entries
   - Keep all Implementation Notes
   - Keep all dates and timestamps

4. **Update status if needed:**
   - Old states map to new states
   - Verify status matches reality

### Phase 5: Migrate Context Files

**For each context file:**

1. **Read existing content**
2. **Merge with 2.1 template:**
   - Keep user's content
   - Add new sections from 2.1
   - Update structure if changed
3. **Enhance if gaps found:**
   - Compare to actual code
   - Fill missing info
   - Update outdated info

### Phase 6: Extract Knowledge

**From old specs and code:**

**Check for decisions:**
- Look in old decision logs
- Create knowledge/decisions/ entries
- Format as ADRs

**Check for complex features:**
- Identify architecturally complex features
- Create knowledge/features/ docs
- Link from specs

**Check for notes:**
- Look for technical gotchas in old specs
- Create knowledge/notes/ entries

**Update knowledge/INDEX.md**

### Phase 7: Remove Old Structure

**Delete deprecated folders/files:**
- Remove `/docflow/shared/`
- Remove `/docflow/reference/`
- Remove `/docflow/dependencies.md`
- Rename `.templates` → `templates`

**Verify nothing lost:**
- Check backup has everything
- Confirm migration complete

### Phase 8: Update Commands (if needed)

**If .cursor/commands/ needs updating:**
- Backup old commands (already in archive)
- Copy new 2.1 command files
- Update .cursor/rules/docflow.mdc if changed

### Phase 9: Create Migration Record

**Create `/docflow/MIGRATION.md`:**

```markdown
# Migration from DocFlow 1.x to 2.1

**Date:** YYYY-MM-DD
**Previous Version:** 1.x
**New Version:** 2.1
**Backup Location:** /docflow-v1-backup-YYYY-MM-DD/

## What Changed

### Structure
- Added: knowledge/ (decisions, features, notes, product)
- Added: specs/assets/
- Added: Platform adapters (AGENTS.md, .claude/, .github/)
- Removed: shared/, reference/, dependencies.md
- Renamed: .templates → templates

### Specs
- [N] specs migrated
- Metadata converted: Estimated Time → Complexity
- All history preserved
- All content preserved

### Context
- Context files updated to 2.1 format
- All custom content preserved
- Enhanced with current codebase analysis

### Knowledge
- [N] decisions extracted and documented
- [N] features documented
- [N] technical notes captured

## Rollback Instructions

If you need to rollback:
1. Delete /docflow/
2. Rename /docflow-v1-backup-YYYY-MM-DD/ → /docflow/
3. Restore .cursor/ from backup if needed

**Backup can be deleted** once you've confirmed migration success (give it a week).

## Next Steps

Everything should work the same, with these improvements:
- Better knowledge organization
- Cross-platform support
- New chore template available
- Clearer spec metadata

Continue working with /start-session as usual!
```

### Phase 10: Summary & Verification

```
✅ DocFlow Upgraded to 2.1!

**Migration Summary:**

🔄 Migrated:
   - [N] specs (metadata converted)
   - [N] context files (enhanced)
   - [N] completed features

📦 Backup Created:
   - Old version in /docflow-v1-backup-YYYY-MM-DD/
   - Safe to delete after verification (give it a week)

✨ New Features:
   - Knowledge base (decisions, features, notes)
   - Platform adapters (works in Claude, Copilot)
   - Spec assets folder
   - Chore template

🎯 Ready to Continue:
   
   Run /start-session to resume work!
   
Everything preserved. Your workflow continues exactly as before.
Migration record in /docflow/MIGRATION.md

Welcome to DocFlow 2.1! 🎉
```

---

## Scenario 3: Migrate Other Spec System

**Use when:** Project has specs in different location/format

### Phase 1: Detect & Analyze Old System

**Find specs:**
- Common locations: `/specs/`, `/.specs/`, `/docs/specs/`, `/documentation/`
- Check git history for spec activity
- Identify format (markdown, notion exports, issues, etc.)

**Analyze structure:**
- How many specs?
- What format?
- What metadata?
- Current vs outdated?
- Any valuable history?

### Phase 2: Show Migration Plan

```
📊 Spec System Detected

**Found:** [N] specs in [location]
**Format:** [description]
**Last Updated:** [from git or file dates]

**Migration Plan:**

1. Archive old system → [location]/archived-YYYY-MM-DD/
2. Convert [N] specs to DocFlow format
3. Install DocFlow 2.1 structure
4. Map old metadata to DocFlow fields
5. Create MIGRATION.md documenting conversion

**What will be preserved:**
- All spec content
- All history (if present)
- All completion dates

**What will be enhanced:**
- Structured format (templates)
- Clear workflow states
- Implementation tracking
- Code review integration

Proceed with migration?
```

**Wait for approval.**

### Phase 3: Archive Old System

**Create archive:**
1. Copy old spec system → `[old-location]-archived-YYYY-MM-DD/`
2. Create ARCHIVE-README.md explaining what's there
3. Do NOT delete old system yet (keep until verified)

### Phase 4: Install DocFlow

**Same as Scenario 1:**
- Create full DocFlow 2.1 structure
- Fill context files from code
- Add platform adapters

### Phase 5: Convert Specs

**For each valuable spec:**

**Determine state:**
- Complete? → complete/YYYY-QQ/
- In progress? → active/ with appropriate status
- Planned? → backlog/

**Map to template:**
- New feature → feature.md
- Bug fix → bug.md
- Maintenance → chore.md
- Exploration → idea.md

**Convert content:**
- Map old fields to DocFlow metadata
- Preserve all content
- Add missing sections (mark as TBD)
- Keep original dates
- Add "Migrated from [old system]" in Decision Log

### Phase 6: Populate Knowledge & Tracking

**Same as Scenario 1:**
- Extract knowledge
- Document features from code
- Create backlog
- Initialize tracking files

### Phase 7: Create Migration Record

**Create `/docflow/MIGRATION.md`:**

```markdown
# Migration from [Old System] to DocFlow 2.1

**Date:** YYYY-MM-DD
**Old System:** [Description]
**Old Location:** [Path]
**Archive Location:** [Archive path]

## What Was Migrated

- [N] specs converted to DocFlow format
- [N] marked complete
- [N] marked in-progress
- [N] marked backlog

## Conversion Mapping

**Metadata:**
- [Old field] → [DocFlow field]
- [Old status] → [DocFlow status]

**Content:**
- All original content preserved
- Added standard DocFlow sections
- Enhanced with implementation tracking

## Old System Archive

Original system archived at [location].
Safe to delete after verification (give it a month).

## Next Steps

Your specs are now in DocFlow!
Run /start-session to begin using the workflow.
```

### Phase 8: Summary & Handoff

```
✅ Migration to DocFlow 2.1 Complete!

**Converted:**
   - [N] specs from [old system]
   - All content and history preserved
   - Enhanced with DocFlow structure

📦 Archive:
   - Old system backed up to [location]
   - Safe to delete after verification

🎯 Ready to Use:
   
   Run /start-session to begin!
   
Your existing work is now part of DocFlow's workflow.
Migration record in /docflow/MIGRATION.md

Welcome to DocFlow! 🚀
```

---

## Scenario 4: Repair Broken DocFlow

**Use when:** DocFlow folder exists but broken/incomplete

### Phase 1: Diagnose Issues

**Check what's wrong:**
- Missing folders?
- Empty context files (still templates)?
- Corrupted structure?
- Incomplete installation?
- Half-migrated state?

**Show diagnosis:**
```
⚠️ DocFlow Issues Detected

**Problems Found:**
- [Issue 1]
- [Issue 2]
- [Issue 3]

**Repair Plan:**
[Specific repairs needed]

This will fix the structure while preserving any existing content.

Proceed with repair?
```

**Wait for approval.**

### Phase 2: Backup Current State

**Even if broken, backup:**
- Copy `/docflow/` → `/docflow-broken-backup-YYYY-MM-DD/`
- Preserve whatever is there

### Phase 3: Repair Structure

**Fix folder structure:**
- Create missing folders
- Fix permissions if needed
- Verify all expected paths exist

**Fix/Fill context files:**
- If empty/template → fill from codebase (like fresh install)
- If partially filled → preserve and enhance
- If corrupted → rebuild from code + ask questions

**Fix templates:**
- Ensure all 4 templates present and correct
- Update to 2.1 versions

**Add missing pieces:**
- Platform adapters if missing
- Knowledge structure if missing
- Assets folder if missing

### Phase 4: Validate & Sync

**Check specs:**
- Verify all specs are valid
- Fix broken metadata
- Update states if needed

**Check tracking:**
- Ensure ACTIVE.md and INDEX.md valid
- Rebuild if corrupted

### Phase 5: Summary

```
✅ DocFlow Repaired!

**Fixed:**
   - [Issue 1] ✓
   - [Issue 2] ✓
   - [Issue 3] ✓

📦 Backup:
   - Broken state backed up (for reference)

🎯 Ready to Use:
   
   Run /start-session to begin!
   
DocFlow should now work correctly.
```

---

## Key Principles

### Always Get Approval
- Show what will change
- Explain why
- Wait for confirmation
- Offer alternatives if uncertain

### Preserve Everything
- Archive before modifying
- Keep all user content
- Maintain all history
- Document what changed

### Be Thorough But Efficient
- Focus on valuable content
- Don't migrate junk
- Ask about ambiguous items
- Trust user's judgment

### Make It Actionable
- Clear next steps
- Working state at end
- Documentation of changes
- Easy rollback if needed

### Document Migration
- Always create MIGRATION.md
- Explain what changed
- Show rollback instructions
- List next steps

---

## Tools to Use

- `list_dir` - Check structure
- `read_file` - Read existing content
- `write_file` - Create new files
- `move_file` - Reorganize (terminal mv)
- `grep` / `codebase_search` - Find content
- `run_terminal_cmd` - Git commands

---

## Checklist

- [ ] Scenario detected correctly
- [ ] User approval obtained
- [ ] Backup created (if modifying existing)
- [ ] New structure created/updated
- [ ] Content migrated/preserved
- [ ] Context files filled
- [ ] Knowledge base populated
- [ ] Tracking files initialized
- [ ] Migration documented (if applicable)
- [ ] Summary provided
- [ ] Next steps clear
- [ ] System functional

---

## Version Detection Reference

### DocFlow 1.x Indicators:
- `/docflow/shared/` exists
- `/docflow/reference/` exists
- `/docflow/dependencies.md` exists
- `.templates` folder (hidden)
- Specs have `Estimated Time` field
- No `knowledge/` folder
- No `specs/assets/` folder
- No `AGENTS.md` in root

### DocFlow 2.1 Indicators:
- `/docflow/templates/` exists (visible)
- `/docflow/knowledge/` with subfolders
- `/docflow/specs/assets/` exists
- Specs have `Complexity` field
- `AGENTS.md` in root
- `.claude/` and `.github/` adapters
- No `shared/`, `reference/`, `dependencies.md`
