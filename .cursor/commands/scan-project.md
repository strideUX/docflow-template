# Scan Project - Agent Guidance

## Purpose
Analyze an existing codebase to understand what it does, retrofit DocFlow documentation, and prepare the project for spec-driven development. This handles both projects without DocFlow and projects with older/incomplete DocFlow systems.

## When to Trigger

### Automatic Detection
Run this process automatically when:
- User says "scan the project", "analyze this codebase", "set up DocFlow for existing project"
- OR when checking workspace and finding:
  - Code/source files exist in project
  - DocFlow directory missing OR context files are still templates
  - Old spec system detected (different format/structure)

### User Triggers
When user says phrases like:
- "scan this project"
- "analyze this codebase"
- "what does this project do?"
- "help me understand this code"
- "add DocFlow to this project"
- "migrate to DocFlow"
- "I inherited this codebase"

## Scan Process

This is a **discovery and documentation conversation**. Be thorough but conversational.

### Phase 1: Initial Assessment (1-2 minutes)

**Detect project type and state:**

1. **Check for existing DocFlow/specs:**
   - Look for `/docflow/`, `/specs/`, `.specs/`, `docs/specs/`
   - Look for `BACKLOG.md`, `TODO.md`, spec files
   - If found: Note format and structure for migration later

2. **Check for package management:**
   - `package.json` (Node.js)
   - `requirements.txt`, `pyproject.toml` (Python)
   - `go.mod` (Go)
   - `Cargo.toml` (Rust)
   - `composer.json` (PHP)
   - Read and analyze dependencies

3. **Identify framework:**
   - Next.js: `next.config.*`, `app/`, `pages/`
   - React: `src/`, `public/`, React in package.json
   - Expo: `expo/`, `app.json`, Expo in package.json
   - Vue: `vue.config.*`, `.vue` files
   - Express/Fastify: Server files, API routes
   - Django/Flask: Python web framework files
   - Scan for framework-specific patterns

4. **Assess project size:**
   - Count source files
   - Identify main directories
   - Note complexity level (simple/moderate/complex)

**Initial message to user:**
"I found a [framework] project with [X files]. Let me scan through the codebase to understand what it does. This will take a moment..."

### Phase 2: Deep Code Analysis (3-5 minutes)

**Scan systematically:**

1. **Read README/documentation:**
   - README.md, CONTRIBUTING.md, docs/
   - Extract project purpose, setup instructions
   - Note any architecture documentation

2. **Analyze entry points:**
   - Next.js: `app/page.tsx`, `pages/index.tsx`
   - React: `src/App.tsx`, `src/main.tsx`
   - API: Main server file, routes
   - Identify main application flow

3. **Map features:**
   - List major directories/modules
   - For each directory, identify what feature it represents
   - Read key component/module files
   - Map data models/schemas
   - Identify external integrations (APIs, databases)

4. **Detect patterns and standards:**
   - File naming conventions
   - Component structure patterns
   - State management approach
   - API patterns (REST, GraphQL, tRPC)
   - Testing setup
   - Linting/formatting config

5. **Identify tech stack:**
   - Database (Convex, Prisma, Supabase, MongoDB, PostgreSQL)
   - Styling (Tailwind, CSS Modules, styled-components)
   - UI library (shadcn, MUI, Chakra)
   - Auth (Clerk, Auth.js, Supabase Auth)
   - Deployment indicators (Vercel, Netlify, AWS)

**Progress updates:**
Give user progress updates as you scan:
- "Found authentication system using [X]..."
- "Detected [N] main features: [list]..."
- "Using [database] with [patterns]..."

### Phase 3: Ask Clarifying Questions (2-3 minutes)

**Based on what you found, ask about gaps:**

1. **Project purpose (if not clear from code):**
   - "I can see this is a [type] app with [features]. Can you describe the core problem it solves?"
   - "Who are the target users?"

2. **Incomplete features:**
   - "I see [feature] is partially implemented. Is this in progress or planned?"

3. **Technical decisions:**
   - "Why [X approach] over [Y]?" (if pattern seems unusual)
   - "What's the deployment target?"

4. **Priorities:**
   - "What are you actively working on?"
   - "What features are planned next?"
   - "Any known bugs or technical debt?"

### Phase 4: Handle Old DocFlow/Specs (if exists)

**If old spec system detected:**

1. **Analyze old format:**
   - Read existing specs/documentation
   - Identify what's valuable to preserve
   - Note which specs are complete/incomplete/outdated

2. **Archive old system:**
   - Create `/docflow/specs/reference/archived-[date]/`
   - Copy old specs there
   - Create `MIGRATION.md` explaining what was moved and why

3. **Migrate valuable content:**
   - Convert old specs to new format
   - Preserve decision history
   - Update to current status (likely COMPLETE for old features)
   - Place completed work in `/docflow/specs/complete/[YYYY-QQ]/`

4. **Inform user:**
   - "I found your old spec system in [location]"
   - "Archived to /docflow/specs/reference/archived-[date]/"
   - "Migrated [N] specs to new format"
   - "Preserved all decision history and context"

### Phase 5: Fill Context Files (2-3 minutes)

**Create comprehensive documentation:**

**`/docflow/context/overview.md`:**
```markdown
# [Project Name]

## What is this?
[Clear description based on code analysis and user input]

## Core Purpose
[Problem it solves, extracted from README/code/conversation]

## Key Features
- [Feature 1 - discovered from code]
- [Feature 2 - discovered from code]
- [Feature 3 - discovered from code]
[List 5-8 main features discovered]

## Users
[Target users from README or user input]

## Success Criteria
[From README or ask user]
```

**`/docflow/context/stack.md`:**
```markdown
# Technical Stack

## Frontend
- **Framework**: [Detected framework + version]
- **UI Library**: [React/Vue/etc]
- **Styling**: [Detected styling approach]
- **State Management**: [Detected if applicable]
- **Components**: [UI library detected]

## Backend
- **Database**: [Detected database]
- **Authentication**: [Detected auth system]
- **File Storage**: [If detected]
- **API Pattern**: [REST/GraphQL/tRPC detected]

## Infrastructure
- **Hosting**: [Detected or ask]
- **Monitoring**: [If detected]
- **Analytics**: [If detected]

## Development
- **Language**: TypeScript [or detected]
- **Package Manager**: [npm/pnpm/yarn detected]
- **Testing**: [Detected test framework]
- **Linting**: [Detected linter config]

## Key Patterns
[List 3-5 patterns discovered from code analysis]
- [Pattern 1: e.g., "Server components by default"]
- [Pattern 2: e.g., "Optimistic updates with Convex"]
- [Pattern 3: e.g., "Feature-based folder structure"]
```

**`/docflow/context/standards.md`:**
```markdown
# Coding Standards

## Discovered Patterns
[Document conventions found in existing code]

### File Naming
- [Detected convention: kebab-case/PascalCase/etc]

### Component Structure
- [Detected pattern]

### State Management
- [Detected approach]

### Code Organization
[Document actual folder structure]

[Keep rest of standards.md with best practices, 
 but note "Detected patterns" section at top]
```

**`/docflow/shared/dependencies.md`:**
```markdown
# Shared Dependencies

[For each major system discovered, document:]

## [System Name]
- **Tables/Models**: [detected data models]
- **Key Mutations**: [write operations found]
- **Key Queries**: [read operations found]
- **Components**: [shared UI components found]
- **Utilities**: [shared helper functions found]
- **Used by**: [features that use this system]

[Repeat for each major system]
```

### Phase 6: Create Discovery Documentation (2-3 minutes)

**Create initial specs for existing features:**

For each major feature discovered, create a spec in `/docflow/specs/complete/[YYYY-QQ]/`:

```markdown
# Feature: [Feature Name]

**Status**: COMPLETE (Discovered during scan)
**Owner**: [Unknown/Original Developer]
**AssignedTo**: N/A
**Priority**: N/A
**Created**: [Date of scan]
**Completed**: [Before scan date]

## Context
[What this feature does, discovered from code]

## Implementation
**Key Files:**
- [List main files for this feature]

**Patterns Used:**
- [Patterns discovered]

**External Dependencies:**
- [APIs, libraries used]

## Decision Log
- [Scan Date]: Feature discovered during project scan
- [Scan Date]: Documented existing implementation
```

**Update tracking files:**
- Initialize `/docflow/ACTIVE.md` with timestamp
- Create `/docflow/INDEX.md` with:
  - Active: [Empty or current WIP from user]
  - Backlog: [Next features from conversation]
  - Completed: [All discovered features]

### Phase 7: Identify Next Steps (1-2 minutes)

**Based on scan, suggest next work:**

1. **Incomplete features found:**
   - Create specs in `/docflow/specs/active/` with status=IMPLEMENTING
   - Document what's done vs. what's needed

2. **Planned features discussed:**
   - Create specs in `/docflow/specs/backlog/`
   - Basic structure, refine later with `/review`

3. **Technical debt identified:**
   - Create bug specs: `bug-[name].md`
   - Document the issue and impact

4. **Suggest improvements:**
   - Based on best practices for their stack
   - Create idea specs for consideration

### Phase 8: Summary & Handoff

**Provide comprehensive summary:**

```
📊 Project Scan Complete!

**Project**: [Name]
**Type**: [Framework] [project type]
**Size**: [X files, Y features]

✅ DocFlow Context Created:
   - overview.md: [Brief summary]
   - stack.md: [Stack summary]
   - standards.md: [Detected patterns]
   - dependencies.md: [N systems documented]

📁 Features Documented:
   - [N] existing features in /specs/complete/
   - [N] in-progress in /specs/active/
   - [N] planned in /specs/backlog/

🔄 Migration (if applicable):
   - Old specs archived to /specs/reference/archived-[date]/
   - [N] specs migrated to new format

🎯 Next Steps:
   1. [Suggested next action]
   2. [Alternative action]
   
Ready to start working? Run `/start-session` to begin!
```

## Tools to Use

- `list_dir` - Map directory structure
- `read_file` - Read key files (README, package.json, configs, source files)
- `grep` - Search for patterns (imports, exports, component usage)
- `codebase_search` - Find how features are implemented
- `glob_file_search` - Find files by type/pattern
- `run_terminal_cmd` - Run git commands for history (if needed)

## Key Principles

### Be Thorough But Efficient
Don't read every file - focus on:
- Entry points
- Main feature files
- Shared utilities
- Config files
- Data models/schemas

### Document What Exists
Don't judge or critique the code during scan - just document objectively what's there.

### Preserve History
If old docs exist, archive them properly. Don't delete anything.

### Ask Good Questions
Use scan to inform questions. "I see X, but Y is unclear..." is better than "What does this do?"

### Make It Actionable
End with clear next steps. User should know exactly what to do after scan completes.

## Common Scenarios

### Scenario A: No Documentation
Project has code but no README or docs.
→ Do thorough code analysis
→ Ask more clarifying questions
→ Create comprehensive overview.md

### Scenario B: Inherited Codebase
User is new to the project.
→ Focus on teaching as you scan
→ Explain patterns you find
→ Create detailed dependencies.md for reference

### Scenario C: Old DocFlow Version
Project has specs but old format.
→ Archive carefully with migration notes
→ Preserve all decision history
→ Update format but keep content

### Scenario D: Partial Implementation
Some features half-built.
→ Create specs with status=IMPLEMENTING
→ Document what's done in Implementation Notes
→ List what's remaining in Acceptance Criteria

## Red Flags to Avoid

❌ Reading entire codebase file-by-file (too slow)
❌ Making assumptions without verification
❌ Deleting old documentation
❌ Generic/vague context files
❌ Not asking clarifying questions
❌ Ending without clear next steps

## Success Criteria

✅ User understands their codebase better
✅ Context files accurately reflect the actual code
✅ All major features documented
✅ Shared systems mapped in dependencies.md
✅ Clear next steps identified
✅ Old specs properly archived/migrated (if applicable)
✅ Project ready for spec-driven development

