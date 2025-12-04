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

#### 1. Collaborative Discovery & Concept Refinement

```
🎯 Setting up DocFlow for a new project!

Let's talk through your idea so I can help you scope it well 
and set up the right foundation. This is collaborative - I'll 
ask questions, offer alternatives, and help refine the concept.
```

**Start conversational, not transactional:**
- "Tell me about what you're building - what's the core idea?"
- Listen, then probe deeper with follow-ups

**Example opening flow:**
```
User: "I want to build a task management app"

Agent: "Cool! Task management - let me ask a few questions to 
        help us scope this well.
        
        First, who's this for? Personal use, team use, or both?"

User: "Team use, like Asana but simpler"

Agent: "Got it. 'Simpler than Asana' - can you give me an example 
        of what you'd cut? I want to make sure we're aligned on 
        what 'simple' means here."
```

**Vetting Questions (adapt based on their answers):**

**On Product Concept:**
- What problem does this solve? (validate the "why")
- Have you seen similar solutions? What would you do differently?
- What's your definition of "done" for an MVP? (scope check)
- If scope seems too large: "That's ambitious - could we start with X and add Y later?"

**On Users:**
- Who are the target users specifically?
- What's their current workflow/pain point?
- If unclear: "Let me make sure I understand - you want users to be able to..."

**On Features:**
- When they list features, ask: "Which of these is absolutely required for launch?"
- If complex feature mentioned: "That feature is complex - can we break it down?"
- Suggest prerequisites: "For that to work, you'll need X first - should I add that?"
- Offer alternatives: "For that use case, [alternative approach] might be simpler - thoughts?"

**On Feasibility:**
- If they want integrations/APIs: "This will need API access and auth - is that ok?"
- If they want real-time: "Real-time means WebSockets or polling - preference?"
- If they want complex data: "That data model will need migrations - comfortable with that?"

**Goal:** Iterate until you have a solid, scoped concept that's achievable. Don't just accept everything - help them refine.

**Red Flags (push back constructively):**
- Too many features for MVP → Suggest phasing
- Vague requirements → Ask clarifying questions
- Unrealistic scope → Explain trade-offs
- Missing prerequisites → Identify dependencies

**Green Lights (proceed with confidence):**
- Clear problem statement
- Defined target users
- Reasonable MVP scope
- User understands trade-offs

#### 2. Stack Selection & Research

**If user has strong preference:**
```
User: "I want to use React and Node.js"

Agent: "Perfect - React and Node.js are great for this use case. 
        Let me research current best practices so we set this 
        up right..."
```
→ Skip to research phase

**If user is uncertain or asks for recommendation:**

**Ask about their context:**
- "What languages/frameworks are you comfortable with?"
- "Any deployment constraints? (Vercel, AWS, self-hosted)"
- "Team project or solo?"
- "Need mobile app eventually, or web-only?"

**Make recommendation based on:**
- Their experience level
- Project requirements
- Best practices for use case
- Ecosystem maturity

**Example recommendation:**
```
Agent: "Based on what you described, I'd recommend:
        - Next.js (React + API in one, great DX)
        - Prisma for database (type-safe, great for teams)
        - Vercel for deployment (zero-config, fast)
        
        This stack is well-documented, actively maintained, and 
        perfect for [their use case]. Sound good, or want to 
        explore alternatives?"
```

**Once stack is chosen, RESEARCH IT:**

**Step A: Use Ref.tools MCP for official docs**
```
Agent: "Let me get the official docs for [framework]..."
```

Actions:
- `mcp_Ref_ref_search_documentation` to search for framework documentation
  - Include framework name, version, and topic (e.g., "React 18 best practices setup")
  - Search for official docs, GitHub repos, and framework-specific guides
- `mcp_Ref_ref_read_url` to read the documentation pages returned
  - Use exact URLs from search results (including #hash fragments)
  - Focus on: current version, recommended setup, project structure, best practices

**Step B: Web search for current best practices (2024/2025)**

Search queries:
- "[framework] best practices 2024"
- "[framework] project structure"
- "[framework] recommended dependencies"
- "[stack] starter template"

**Step C: Synthesize findings**
- Note current versions
- Identify must-have dependencies for their use case
- Capture recommended patterns and conventions
- Note tooling (linters, formatters, testing)

**Time investment:** 3-5 minutes of research to save hours of rework later.

#### 3. Build Context Files from Research

**Now fill context files with RESEARCHED, SPECIFIC information:**

**`docflow/context/overview.md`:**
Based on discovery conversation:
- Project name and purpose (their words)
- Target users and use cases (refined together)
- Core MVP features (scoped version)
- Success criteria (what "done" looks like)

**`docflow/context/stack.md`:**
Based on research:
- Framework and current version (from Ref.tools/web search)
- Recommended dependencies for their use case
- Development tooling (linters, formatters from official docs)
- Build/deployment approach (from best practices)
- Project structure recommendations (from research)

**Example (React + Next.js):**
```markdown
# Stack

## Framework
- **Next.js 15** (App Router)
- **React 18** (Server Components)
- **TypeScript** (strict mode)

## Dependencies
- **Prisma** - Type-safe database ORM
- **NextAuth.js** - Authentication
- **Tailwind CSS** - Styling
- **Zod** - Runtime validation

## Development Tools
- **ESLint** (Next.js config)
- **Prettier** (opinionated formatting)
- **TypeScript** (strict mode)

## Deployment
- **Vercel** (zero-config, edge functions)
- **Postgres** (via Vercel Postgres or Supabase)

## Project Structure
[Based on Next.js 15 App Router conventions - from research]
```

**`docflow/context/standards.md`:**
Based on official docs + best practices:
- Coding conventions (from official style guides)
- File organization (from framework docs)
- Testing approach (from community standards)
- Component patterns (from framework recommendations)

**Example (React/Next.js standards from research):**
```markdown
# Standards

## Code Style
- **TypeScript strict mode** - No implicit any
- **Functional components** - Use hooks, not classes
- **Server Components by default** - Client components only when needed
- **ESLint + Prettier** - Auto-format on save

## File Organization
- **Co-locate by feature** - Not by type
- **Server vs Client** - Explicit 'use client' directives
- **Route handlers** - App router conventions

## Component Patterns
- **Composition over inheritance**
- **Props: interfaces, not types**
- **Event handlers: handleX naming**
- **Async Server Components** for data fetching

## Testing
- **Vitest** for unit tests
- **Playwright** for E2E
- **Test user behavior, not implementation**
```

**Not generic - specific to their chosen stack, from research.**

#### 4. Optional: Capture Initial Backlog

**Don't force this - keep it lightweight.**

```
Agent: "I've captured the core concept and researched the stack. 
        
        Do you want me to create backlog specs for the features 
        we discussed, or would you rather start with just the 
        scaffolding and add features as we go?
        
        (You can always use /capture later to add items)"
```

**If user says yes, create backlog:**
- Create `docflow/specs/backlog/feature-[name].md` for each feature
- Keep it basic - just copy template and fill title/context
- Don't over-engineer - they'll refine with /review later
- Suggest priority order based on dependencies

**If user says no, skip backlog:**
- That's fine! They can /capture as they go
- Focus on getting scaffolding done first
- Backlog can grow organically

**Either way is valid.**

#### 5. Generate Project Scaffolding Spec

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

**If backlog was created:**
```
✅ New project setup complete!

📋 Created:
   • Context files (researched and specific to your stack)
   • [N] backlog items ready for refinement
   • Project scaffolding spec (ACTIVE and ready)

📚 Research Applied:
   • [Framework] - Current version, best practices
   • Standards based on official style guides
   • Stack recommendations from community

📁 DocFlow Structure:
   • /docflow/context/ - Project foundation (researched)
   • /docflow/specs/backlog/ - Feature queue
   • /docflow/specs/active/ - Scaffolding (ready to build)

⏭️  Next step:

   Run: /implement project-scaffolding
   
   Or just say: "let's build the foundation"
   
   The Implementation Agent will set up your project using 
   current [stack] best practices.
```

**If backlog was skipped:**
```
✅ New project setup complete!

📋 Created:
   • Context files (researched and specific to [stack])
   • Project scaffolding spec (ACTIVE and ready)

📚 Research Applied:
   • [Framework] v[X] - Official docs and patterns
   • Current best practices (2024/2025)
   • Standards from [framework] style guide

📁 DocFlow Structure:
   • /docflow/context/ - Project foundation (solid and researched)
   • /docflow/specs/active/ - Scaffolding (ready to build)
   • /docflow/specs/backlog/ - Empty (use /capture as you go)

⏭️  Next step:

   Run: /implement project-scaffolding
   
   Or just say: "let's build it"
   
   After scaffolding is done, use /capture to add features 
   as you think of them.
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
- `WARP.md` in root (Warp workflow guide)
- `.claude/rules.md`
- `.claude/commands/` (symlinks to .cursor/commands/)
- `.warp/rules.md` (Warp adapter)
- `.github/copilot-instructions.md`
- `docflow/knowledge/` structure
- `docflow/specs/assets/`
- `docflow/specs/templates/` (visible, not hidden)

**Create Claude command symlinks (if missing):**
```bash
mkdir -p .claude/commands
cd .claude/commands
# Create symlinks to all cursor commands
for cmd in ../../.cursor/commands/*.md; do
  ln -sf "$cmd" "$(basename $cmd)"
done
```

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
- `/WARP.md` - Warp workflow guide
- `/.claude/rules.md` - Claude Desktop adapter
- `/.claude/commands/` - Symlinks to Cursor commands (Claude Code CLI support)
- `/.warp/rules.md` - Warp adapter
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

**For New Projects:**
- `/docflow/` folder structure (understand state)
- `docflow/specs/templates/` (understand template structure)
- **Use Ref.tools MCP** for chosen stack documentation
- **Use web search** for best practices and patterns

**For Retrofits:**
- `/docflow/` folder structure (understand state)
- Project config files (package.json, requirements.txt, etc.)
- Directory structure (scan, don't read all files)
- Sample code files (to understand patterns)
- `docflow/context/*.md` (if they exist, to check if filled)

**For Upgrades:**
- `/docflow/` folder structure (complete inventory)
- `docflow/context/*.md` (check current state)
- `docflow/ACTIVE.md` (check active work)
- `docflow/INDEX.md` (check tracked items)
- Sample specs from each folder (check format)
- Legacy files (shared/, reference/, dependencies.md)

**Don't auto-load:**
- Individual spec content (unless checking format)
- All completed specs (just count them)
- Entire codebase (use targeted scans)

---

## Expected Output

### For New Projects
```
✅ Setup complete
📚 Context researched ([Framework] v[X] best practices)
📋 Optional: [N] backlog items or ready to /capture later
📁 Scaffolding spec ready
⏭️  Next: /implement project-scaffolding
```

Example:
```
✅ New project setup complete!

📋 Created:
   • Context files (Next.js 15 best practices)
   • 3 backlog items ready for refinement
   • Project scaffolding spec (ACTIVE)

📚 Research Applied:
   • Next.js 15 (App Router, Server Components)
   • React 18 official patterns
   • TypeScript strict mode standards

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

**For New Projects:**
- [ ] Detected scenario correctly (new project - empty dir)
- [ ] Had collaborative discovery conversation (not just Q&A)
- [ ] Vetted the concept (pushed back where appropriate, offered alternatives)
- [ ] Helped choose or validated tech stack choice
- [ ] **Researched stack using Ref.tools + web search**
- [ ] Filled context files with **researched, specific** information (not generic)
- [ ] Created backlog items (or offered /capture alternative)
- [ ] Generated scaffolding spec with stack-specific tasks
- [ ] Initialized tracking files (ACTIVE.md, INDEX.md)
- [ ] Provided clear completion summary with research highlights
- [ ] Gave specific next step command

**For Retrofits:**
- [ ] Detected scenario correctly (code exists, DocFlow empty)
- [ ] Analyzed existing codebase thoroughly
- [ ] Asked clarifying questions about project
- [ ] Filled context files from code analysis + user input
- [ ] Documented existing features in complete/
- [ ] Captured current work if any
- [ ] Populated knowledge base with discoveries
- [ ] Initialized tracking files
- [ ] Provided clear completion summary
- [ ] Gave specific next step command

**For Upgrades:**
- [ ] Detected scenario correctly (DocFlow exists with content)
- [ ] Analyzed current DocFlow state (structure + spec formats)
- [ ] Reported findings clearly (what needs updating)
- [ ] Got explicit user approval before migration
- [ ] Archived old structure safely
- [ ] Updated all specs to 2.1 format
- [ ] Initialized new structure (knowledge/, assets/)
- [ ] Migrated relevant content from old structure
- [ ] Cleaned up legacy files
- [ ] Created Claude command symlinks (.claude/commands/)
- [ ] Created Warp adapter files (.warp/rules.md, WARP.md)
- [ ] Verified all content preserved
- [ ] Created migration log
- [ ] Provided clear completion summary
- [ ] Gave specific next step command

