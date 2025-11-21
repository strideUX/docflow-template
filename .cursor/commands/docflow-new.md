# DocFlow New (System Setup)

## Purpose
Set up a brand new project by conversing with the user to understand their vision, filling out DocFlow context files, and creating an initial backlog with project scaffolding as the first active task.

**Use Case:** Starting fresh with a new project idea  
**Agent Role:** PM/Planning Agent  
**Frequency:** Once per new project

---

## When to Trigger

### Automatic Detection
Run this process automatically when:
- User says "let's start a new project", "initialize project", "set up a new project"
- Opening a project with only `/docflow/` and `.cursor/` directories
- Context files contain template placeholders like `[Project Name]`

### Ask First
If conditions suggest new project but uncertain:  
"It looks like this might be a new project. Would you like me to help you set it up?"

---

## Conversation Flow

**This is a natural conversation (10-15 min), not a form. Adapt based on user responses.**

### Phase 1: Understand the Vision (3-5 min)

**Start conversationally:**
"Let's get your project set up! Tell me about what you're building."

**Listen for and gently probe:**
- Project name (if not obvious from directory)
- Core purpose (what problem does it solve?)
- Target users (who is this for?)
- Key value proposition (why will people use it?)
- Initial feature ideas (what will it do?)

**Don't interrogate** - extract from rich descriptions, only ask to fill gaps.

### Phase 2: Tech Stack Discovery (2-3 min)

**Detect before asking:**
- Check for package.json, config files
- Look for framework indicators
- Read existing configs if present

**If stack detected:**
"I see you have [framework] set up. Is this what you want to use?"

**If nothing detected:**
"What tech stack are you thinking? Framework, styling, database?"

**Probe for:**
- Frontend framework (Next.js, React, Expo, etc.)
- Styling (Tailwind, CSS Modules, etc.)
- Backend/Database (Convex, Supabase, Prisma, etc.)
- State management
- Authentication (if applicable)
- Hosting target

**Use your knowledge** to suggest best practices if they're uncertain.

### Phase 3: Fill Context Files (2-3 min)

**`/docflow/context/overview.md`:**
- Use user's language where possible
- Keep concise (1-2 sentences per section)
- Focus on WHY not just WHAT

**`/docflow/context/stack.md`:**
- Fill detected/confirmed tech stack
- Add key patterns (e.g., "Server components by default" for Next.js)
- Include deployment target

**`/docflow/context/standards.md`:**
- Use sensible defaults (already in template)
- Add any custom preferences mentioned
- Update Project Initialization section with their framework

**Initialize tracking files:**
- Set timestamp in /docflow/ACTIVE.md
- Prepare /docflow/INDEX.md for backlog items

### Phase 4: Build Initial Backlog (3-5 min)

**Gather features:**
"What are the first 3-5 things you want to build?"

**As user mentions features:**
- Create spec immediately: `feature-[name].md` in backlog/
- Ask 1-2 clarifying questions per feature
- Fill proper format (use templates)
- Add to INDEX.md as you go

**Prioritize together:**
"Which is most important to start with?"

**Capture additional:**
- "Any bugs or technical debt to track?"
- "Any ideas to park for later?"

### Phase 5: Create Project Scaffolding Spec (Dynamic)

**IMPORTANT: Generate this fresh based on their stack - NOT a template!**

**Create:** `/docflow/specs/active/feature-project-scaffolding.md`

**Customize with their specifics:**

```markdown
# Feature: Project Scaffolding

**Status**: READY
**Owner**: Implementation
**AssignedTo**: @username
**Priority**: Critical (must complete first)
**Complexity**: M
**Created**: YYYY-MM-DD

## Context
Initialize the [ProjectName] project with [their framework], [their backend], and core tooling. This provides the foundation for all subsequent features.

## User Story
As a developer
I want a properly configured development environment
So that I can build features efficiently with all necessary tools in place

## Acceptance Criteria
### Framework & Dependencies
- [ ] [Framework] initialized IN CURRENT DIRECTORY (use . flag)
- [ ] DO NOT create nested project folder
- [ ] [Their styling system] configured
- [ ] [Their backend/database] initialized and connected
- [ ] TypeScript strict mode configured
- [ ] Development server runs without errors

### Project Setup
- [ ] Git repository initialized
- [ ] .gitignore properly configured
- [ ] First commit: "Initial project setup"
- [ ] Environment variables configured (.env.local)
- [ ] README with setup instructions

### Code Quality
- [ ] ESLint configured
- [ ] Prettier configured (if they want it)
- [ ] [Their linting preferences]

### First Route/Page
- [ ] Basic routing structure
- [ ] Landing/home page working
- [ ] Navigation in place (if applicable)

## Technical Notes

### Initialization Command
[Specific command for their framework]
Examples:
- Next.js: `npx create-next-app@latest . --typescript`
- Expo: `npx create-expo-app . --template blank --no-install`
- Vite: `npm create vite@latest . -- --template react-ts`

### Critical Rules
- Initialize in current directory (use . flag)
- Do NOT create nested folders
- If framework creates subfolder, move contents up and delete
- Verify: pwd should show /projectname not /projectname/projectname

### Dependencies to Install
[List their specific deps based on conversation]
- [Styling library]
- [UI components]
- [Backend/database client]
- [Other tools mentioned]

### Git Setup
```bash
git init
git add .
git commit -m "Initial project setup with [framework]"
```

## Dependencies
- Uses: None (foundation)
- Blocks: ALL other features

## Decision Log
### YYYY-MM-DD - Stack Selected
**Decision:** [Framework] + [Backend] + [Styling]
**Rationale:** [Why these choices based on conversation]
```

**Add to ACTIVE.md as primary focus**
**Add to INDEX.md active section**

### Phase 6: Handoff to Implementation

**Summarize:**
```
✅ Project vision documented
✅ Tech stack defined: [summary]
✅ Initial backlog created: [count] items
✅ First task ready: Project Scaffolding

**Next Step:**
The first task is to scaffold [framework] and initialize git.

Ready to build? Switch to Implementation agent and run:
/implement project-scaffolding

Or just say: "let's build this"
```

---

## Key Principles

### Be Conversational
Planning session, not data entry. Listen, adapt, follow conversation thread.

### Create as You Go
Create specs as features discussed. More natural than collecting then creating.

### Make Scaffolding Specific
Tailor to THEIR project: their stack, their preferences, their constraints.

### One Active Task Only
Only scaffolding should be in active/ with status=READY. Everything else in backlog.

### Always Assign
Get developer username (`git config`) and set AssignedTo immediately.

---

## Tools to Use
- `list_dir` - Detect project structure
- `read_file` - Read package.json, configs
- `run_terminal_cmd` - Get git username
- `grep` - Search configs

---

## Checklist
- [ ] Conversational, not robotic
- [ ] Context files filled with actual details
- [ ] Stack-specific scaffolding created (not generic)
- [ ] 3-8 concrete backlog items created
- [ ] Scaffolding assigned to developer
- [ ] User knows what happens next
- [ ] Handoff to Implementation clear
