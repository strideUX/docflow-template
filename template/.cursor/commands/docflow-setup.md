# DocFlow Setup

## Overview
Universal setup command that intelligently handles all DocFlow initialization scenarios:
- **New projects** (empty directory)
- **Existing projects without DocFlow** (retrofit to existing code)
- **Existing projects with DocFlow** (upgrade/migration)

**Automatically detects your scenario and adapts the setup process.**

## Agent Role
**PM/Planning Agent** - This is a system setup command that requires planning, analysis, and orchestration.

## Detection Logic

### Step 1: Determine Scenario

Check the project state:

**A. Does code exist?**
- Look for: `package.json`, `requirements.txt`, `go.mod`, `Cargo.toml`
- Look for: `src/`, `app/`, `lib/`, `components/` directories
- More content than just `docflow/` folder?

**B. Does DocFlow content exist?**
- Is `docflow/` folder present and populated?
- Are context files (`docflow/context/*.md`) filled out or just templates?
- Are there any specs in `docflow/specs/`?
- Does `docflow/ACTIVE.md` have content?

**Result → Choose scenario:**
1. **NEW PROJECT** - No code, no DocFlow content
2. **RETROFIT** - Code exists, DocFlow is empty/templates only
3. **UPGRADE** - Code exists, DocFlow has content

---

## Scenario 1: New Project

**Detection:** Empty directory or only basic config files, no meaningful code, DocFlow is empty.

### Process

#### 1. Greet and Gather (Conversational)

```
🎯 Setting up DocFlow for a new project!

Tell me about what you're building. I'll ask a few questions 
to set up your project properly.
```

**Ask these questions naturally:**
- What are you building? (product vision, core purpose)
- Who is it for? (target users, use cases)
- What tech stack do you want? (or should I recommend one?)
- What are the first 3-5 features you want to build?
- Any specific requirements? (performance, integrations, etc.)

**Goal:** Gather enough to fill context files and create initial backlog.

#### 2. Fill Context Files

Based on conversation, populate:

**`docflow/context/overview.md`:**
- Project name and purpose
- Target users and use cases
- Core features (high level)
- Success metrics

**`docflow/context/stack.md`:**
- Chosen framework/language
- Key dependencies
- Development tools
- Deployment approach

**`docflow/context/standards.md`:**
- Coding conventions for their stack
- File organization patterns
- Testing approach
- Documentation standards

#### 3. Create Initial Backlog

For each feature mentioned, create a spec:
- `docflow/specs/backlog/feature-[name].md`
- Copy from `docflow/specs/templates/feature.md`
- Fill in basics from conversation
- Set priority (work with user on ordering)
- Mark complexity (S/M/L/XL based on discussion)

#### 4. Generate Project Scaffolding Spec

**Critical:** Create a custom scaffolding spec for their stack:

**`docflow/specs/active/project-scaffolding.md`:**
```markdown
# Project Scaffolding

**Type:** Chore
**Status:** ACTIVE
**Complexity:** M
**Created:** [date]

## Context
Set up the foundational project structure for [their project name].

## Task List

### Initial Setup
- [ ] Initialize project in current directory (NOT a subdirectory)
- [ ] Set up [their framework] project structure
- [ ] Configure [their tools/dependencies]
- [ ] Create initial file structure
- [ ] Set up development environment

### Version Control
- [ ] Initialize git repository (`git init`)
- [ ] Create `.gitignore` for [their stack]
- [ ] Create initial commit with scaffolding

### Configuration
- [ ] [Framework-specific config files]
- [ ] [Environment setup]
- [ ] [Any integrations mentioned]

### Documentation
- [ ] Create project README.md
- [ ] Document setup instructions
- [ ] Document development workflow

## Completion Criteria
- Project can be run locally
- All dependencies install correctly
- Git repository initialized
- README documents how to get started
```

**Customize the task list** based on their stack (React, Python, Go, etc.).

#### 5. Initialize Tracking

**`docflow/ACTIVE.md`:**
```markdown
# Active Work

**Last Updated:** [date]

## Primary Focus
**Spec:** project-scaffolding
**Started:** [date]
**Status:** Setting up project foundation

## Context
Setting up a new [project type] project. After scaffolding is 
complete, we'll begin building the first features.

## Next Up
After scaffolding:
1. feature-[first priority]
2. feature-[second priority]
```

**`docflow/INDEX.md`:**
- List all backlog items created
- Show priorities
- Note that scaffolding is the first active task

#### 6. Complete and Hand Off

```
✅ New project setup complete!

📋 Created:
   • Context files (overview, stack, standards)
   • [N] backlog items:
     - feature-[name] (Priority: High)
     - feature-[name] (Priority: Medium)
     - ...
   • Project scaffolding spec (ACTIVE and ready)

📁 DocFlow Structure:
   • /docflow/context/ - Project documentation
   • /docflow/specs/backlog/ - Feature queue
   • /docflow/specs/active/ - Current work (scaffolding)

⏭️  Next step:

   Run: /implement project-scaffolding
   
   Or just say: "let's build the foundation"
   
   The Implementation Agent will set up your project structure
   and get everything ready for feature development.
```

---

## Scenario 2: Retrofit Existing Project

**Detection:** Code exists, but DocFlow is empty or only has template files.

### Process

#### 1. Greet and Analyze

```
🔍 I see existing code! Let me analyze your project and 
   set up DocFlow to work with it...
```

**Analyze the codebase:**
- Read primary config files (`package.json`, `requirements.txt`, etc.)
- Scan directory structure
- Identify framework and patterns
- Map main features (routes, components, modules)
- Find data models/schemas
- Note integrations (APIs, databases, services)
- Identify current patterns and conventions

**Time:** 5-10 minutes of analysis.

#### 2. Ask Clarifying Questions

After analysis, ask:
- "What's the main purpose of this application?"
- "Who are the primary users?"
- "I found these features: [list]. Are they complete or in progress?"
- "Are there any known issues or tech debt I should document?"
- "What are you actively working on right now?"

#### 3. Fill Context Files

**`docflow/context/overview.md`:**
- App purpose (from answers + code)
- Current state and users
- Key features (from code analysis)
- Any known issues

**`docflow/context/stack.md`:**
- Detected framework and version
- All dependencies found
- Build tools and scripts
- Deployment approach (if apparent)

**`docflow/context/standards.md`:**
- Extract patterns from existing code
- File organization they're using
- Naming conventions observed
- Testing approach (if present)

#### 4. Document Existing Features

For each major feature found, create a completed spec:

**`docflow/specs/complete/[current-quarter]/feature-[name].md`:**
- Copy from template
- Status: COMPLETE
- Brief description of what it does
- Key files involved
- Implementation notes: "Discovered during DocFlow retrofit"

**Don't spend too long** - these are quick documentation, not full specs.

#### 5. Capture Current Work

If user mentioned current work or you found work-in-progress:
- Create spec in `docflow/specs/active/` or `docflow/specs/backlog/`
- Mark status appropriately
- Document what's done and what's remaining

#### 6. Populate Knowledge Base

If you found interesting patterns or quirks:
- Document complex patterns in `docflow/knowledge/features/`
- Note any unusual approaches in `docflow/knowledge/notes/`
- Keep it brief - just key insights

#### 7. Initialize Tracking

**`docflow/ACTIVE.md`:**
- If there's current work, reference that spec
- Otherwise, note that setup is complete and ready for new work

**`docflow/INDEX.md`:**
- List all documented features
- Show any backlog items created
- Provide quick reference to what exists

#### 8. Complete and Hand Off

```
✅ DocFlow retrofit complete!

📊 Documented:
   • Context files (from existing code)
   • [N] existing features in complete/
   • Tech stack: [framework] + [key deps]
   • Coding patterns and conventions

📁 Your Codebase:
   • [brief summary of what exists]
   • [key features found]
   • [any WIP noted]

⏭️  Next step:

   Run: /start-session
   
   Or say: "what should I work on?"
   
   DocFlow is now ready to manage your ongoing development.
   Continue with existing work or start something new.
```

---

## Scenario 3: Upgrade Existing DocFlow

**Detection:** DocFlow folder exists with actual content (specs, filled context files).

### Process

#### 1. Greet and Analyze Current State

```
🔄 Upgrading existing DocFlow to version 2.1...

Let me analyze your current setup and check what needs updating.
```

**Analyze current DocFlow:**

**Structure checks:**
- Does old `shared/` folder exist?
- Does old `reference/` folder exist?
- Does `dependencies.md` exist in docflow/?
- Are templates in `.templates/` (old, hidden) vs `templates/` (new, visible)?
- Are old command files present (`new-project.md`, `scan-project.md`)?
- Are 2.1 platform adapters missing (AGENTS.md, .claude/, .github/)?
- Is `knowledge/` folder missing or incomplete?
- Is `specs/assets/` folder missing?

**Spec format checks:**
- Read a sample of specs
- Check for old fields: `Estimated Time`
- Check for missing new fields: `Complexity`
- Check for old status values
- Check section structure vs new templates

**Content inventory:**
- Count active specs
- Count backlog specs
- Count completed specs
- Identify any blocked or stale items

#### 2. Report Findings

```
📊 Current DocFlow Analysis:

Structure:
   ✓ Active specs: [N]
   ✓ Backlog specs: [N]
   ✓ Completed specs: [N]

⚠️  Needs updating:
   • Old structure detected: shared/, reference/, dependencies.md
   • [N] specs using old format (time estimates)
   • [N] specs missing complexity field
   • Templates in .templates/ (should be templates/)
   • Old command files: new-project.md, scan-project.md
   • Missing 2.1 additions: knowledge/, assets/, platform adapters

🔄 Migration Plan:
   1. Archive old structure → knowledge/archived-migration/
   2. Remove legacy files (.templates/, dependencies.md, old commands)
   3. Add 2.1 structure (knowledge/, assets/, adapters)
   4. Update [N] specs to 2.1 format
   5. Create migration documentation

✅ All active work will be preserved and updated.
📦 Old files archived (safe to delete after 30 days).
```

#### 3. Ask for Approval

```
This migration is safe and reversible. Your content will be 
preserved and updated to the new format.

Proceed with migration? (yes/no)
```

**If user says no:** Stop and wait for further instruction.

**If user says yes:** Continue to step 4.

#### 4. Perform Migration

**A. Archive old structure:**
```bash
# Create archive location
mkdir -p docflow/knowledge/archived-migration/

# Move old folders
mv shared/ docflow/knowledge/archived-migration/shared-[date]/
mv reference/ docflow/knowledge/archived-migration/reference-[date]/
mv docflow/specs/.templates/ docflow/knowledge/archived-migration/old-templates-[date]/
```

**B. Update spec formats:**

For each spec file that needs updating:
- Remove `Estimated Time` field
- Add `Complexity: [infer from old time or mark TBD]`
- Update section headers to match new templates
- Ensure status values are correct
- Preserve all content and notes

**Do this in batches** - update 5-10 at a time and show progress.

**C. Initialize new structure:**
- Ensure `docflow/knowledge/` has all subdirectories
- Create `docflow/knowledge/INDEX.md` if missing
- Create `docflow/knowledge/README.md` if missing
- Ensure `docflow/specs/assets/` exists

**D. Migrate relevant content:**
- Move useful docs from `shared/` to appropriate `knowledge/` folders
- Move references to `knowledge/notes/` or `knowledge/features/`
- Convert and organize based on content type

**E. Clean up legacy files:**

**DocFlow 1.x files to remove:**
```bash
# Old hidden templates folder (replaced by visible templates/)
rm -rf docflow/specs/.templates/

# Old dependency tracking (use search instead)
rm -f docflow/dependencies.md

# Old command files (replaced with 2.1 versions)
rm -f .cursor/commands/new-project.md
rm -f .cursor/commands/scan-project.md
```

**Files to verify exist (2.1 additions):**
- `AGENTS.md` in root
- `.claude/rules.md`
- `.github/copilot-instructions.md`
- `docflow/knowledge/` structure
- `docflow/specs/assets/`
- `docflow/specs/templates/` (visible, not hidden)

**Log cleanup actions:**
Create `docflow/knowledge/archived-migration/MIGRATION-[date].md`:
```markdown
# DocFlow 1.x → 2.1 Migration

**Date:** [date]
**Migrated by:** DocFlow Setup Command

## Files Removed
- `/docflow/specs/.templates/` → Archived
- `/docflow/shared/` → Archived
- `/docflow/reference/` → Archived
- `/docflow/dependencies.md` → Archived
- `/.cursor/commands/new-project.md` → Removed
- `/.cursor/commands/scan-project.md` → Removed

## Files Added
- `/AGENTS.md` - Universal AI instructions
- `/.claude/rules.md` - Claude Desktop adapter
- `/.github/copilot-instructions.md` - GitHub Copilot adapter
- `/docflow/knowledge/` - Knowledge base structure
- `/docflow/specs/assets/` - Spec-specific resources
- `/docflow/specs/templates/` - Updated templates (visible)

## Specs Updated
- [N] specs converted from `Estimated Time` → `Complexity`
- All metadata updated to 2.1 format
- All content and history preserved

## Archive Location
Old structure preserved in:
- `/docflow/knowledge/archived-migration/shared-[date]/`
- `/docflow/knowledge/archived-migration/reference-[date]/`
- `/docflow/knowledge/archived-migration/old-templates-[date]/`

Safe to delete after verifying migration (recommend keeping for 30 days).
```

#### 5. Verify Migration

- Count specs before and after (should match)
- Check that active work is intact
- Verify context files are preserved
- Ensure no content was lost

#### 6. Complete and Hand Off

```
✅ DocFlow upgraded to version 2.1!

📊 Migration Summary:
   • [N] specs updated to new format
   • Old structure archived to knowledge/archived-migration/
   • Knowledge base initialized with new structure
   • All content preserved and organized

📁 New Structure:
   • /docflow/knowledge/ - Project knowledge base
   • /docflow/specs/templates/ - Updated templates
   • /docflow/specs/assets/ - Spec-specific resources

✅ Your work is ready to continue:
   • Active specs: [N]
   • Backlog: [N]
   • Knowledge base: Organized and ready

⏭️  Next step:

   Run: /status
   
   Review your current work and continue where you left off.
   
   Or run: /start-session
   
   Begin your next development session with the upgraded system.
```

---

## Error Handling

### If Scenario is Unclear
```
I'm not sure if this is a new project, existing code, or 
an upgrade. Can you clarify?

- "new project" - I'll help you start from scratch
- "existing code" - I'll analyze and set up DocFlow
- "upgrade" - I'll migrate your current DocFlow to 2.1
```

### If Migration Seems Risky
- Warn user about potential issues
- Recommend manual backup
- Get explicit approval before proceeding
- Offer to do migration in smaller steps

### If Errors Occur During Setup
- Stop immediately
- Report specific issue
- Don't leave in partial state
- Offer to rollback or fix

### If User Asks to Skip Steps
- Confirm what they want to skip
- Warn if it will impact workflow
- Proceed with their preferences

---

## Natural Language Triggers

User might say:
- "set up DocFlow"
- "initialize the project"
- "add DocFlow to this project"
- "upgrade DocFlow"
- "migrate to 2.1"
- "get started with DocFlow"
- "finish the installation"
- "complete DocFlow setup"

**When you hear these, run this command automatically.**

---

## Context Loading

**Load these files:**
- `/docflow/` folder structure (list to understand state)
- `docflow/context/*.md` (if they exist, to check if filled)
- `docflow/ACTIVE.md` (if exists, to see current state)
- `docflow/INDEX.md` (if exists, to see what's tracked)
- Sample specs (if they exist, to check format)
- Project config files (package.json, etc. - to analyze stack)

**Don't load:**
- Individual spec content (unless checking format)
- All completed specs (just count them)
- Entire codebase (just scan structure)

---

## Expected Output

### For New Projects
```
✅ Setup complete
📋 [N] backlog items created
📁 Scaffolding spec ready
⏭️  Next: /implement project-scaffolding
```

### For Retrofits
```
✅ Retrofit complete
📊 [N] features documented
📁 Knowledge captured
⏭️  Next: /start-session
```

### For Upgrades
```
✅ Upgrade complete
📊 [N] specs updated
📁 Structure modernized
⏭️  Next: /status or /start-session
```

---

## Checklist

- [ ] Detected scenario correctly (new/retrofit/upgrade)
- [ ] Chose appropriate flow
- [ ] Gathered necessary information
- [ ] Filled or updated context files appropriately
- [ ] Created, documented, or updated specs
- [ ] Initialized or updated tracking files (ACTIVE.md, INDEX.md)
- [ ] Provided clear completion summary
- [ ] Gave specific next step command
- [ ] Verified all content preserved (for upgrades)

