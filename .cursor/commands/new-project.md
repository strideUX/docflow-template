# New Project Setup - Agent Guidance

## Purpose
Guide the DocFlow agent through initializing a new project by conversing with the user to understand their vision, detect/confirm their tech stack, fill out DocFlow context files, and create an initial backlog with project scaffolding as the first active task.

## When to Trigger

### Automatic Detection
Run this process automatically when:
- User says anything like "let's start a new project", "initialize project", "set up a new project"
- OR when checking the workspace and finding:
  - Only `/docflow/` and `.cursor/` directories exist
  - Context files are still templates (contain placeholders like `[Project Name]`)
  - No active specs exist
  - No code/source files exist in root

### Ask First
If conditions suggest new project but you're uncertain: "It looks like this might be a new project. Would you like me to help you set it up?"

## Conversation Flow

This is a **natural conversation**, not a form to fill out. Follow this flow but adapt based on user responses.

### Phase 1: Understand the Vision (2-3 minutes)

**Start conversationally:**
"Let's get your project set up! Tell me about what you're building."

**Listen for and gently probe:**
- Project name (if not obvious from directory)
- Core purpose (what problem does it solve?)
- Target users (who is this for?)
- Key value proposition (why will people use it?)
- Success criteria (how will you know it's working?)

**Don't interrogate** - if user gives you a rich description, extract answers from it. Only ask follow-ups for gaps.

### Phase 2: Tech Stack Discovery (1-2 minutes)

**Detect before asking:**
- Use filesystem tools to check for:
  - `package.json` (read it if exists)
  - Config files (next.config, vite.config, tsconfig, etc.)
  - Framework indicators (app/, pages/, src/)
  - Backend setup (convex/, prisma/, supabase/)

**If you detect a stack:**
"I see you have [X framework] set up. Is this the stack you want to use?"

**If nothing detected:**
"What tech stack are you thinking for this? (Framework, styling, database, etc.)"

**Probe for:**
- Frontend framework (Next.js, React, Expo, etc.)
- Styling approach (Tailwind, CSS Modules, etc.)
- Backend/Database (Convex, Prisma, Supabase, Firebase, etc.)
- State management (if applicable)
- Authentication (if applicable)
- Hosting/deployment target

**Use your knowledge** to suggest best practices for their chosen stack if they're uncertain.

### Phase 3: Development Preferences (30 seconds)

**Quick checks:**
- "Any specific code style preferences?" (or use defaults)
- "Testing requirements?" (or assume standard)
- "Git conventions?" (or use defaults)

Don't belabor this - defaults from `standards.md` template are usually fine.

### Phase 4: Fill Context Files

Now that you understand the project, populate:

**`/docflow/context/overview.md`:**
- Replace placeholders with actual project details
- Use the user's language where possible
- Keep it concise (1-2 sentences per section)

**`/docflow/context/stack.md`:**
- Fill in detected/confirmed tech stack
- Add key patterns for the stack (e.g., "Server components by default" for Next.js)
- Include deployment target

**`/docflow/context/standards.md`:**
- Update Project Initialization Standards section with specific framework
- Add any custom preferences mentioned
- Keep the rest as sensible defaults

**Initialize tracking files:**
- Set timestamp in `/docflow/ACTIVE.md`
- Prepare `/docflow/INDEX.md` (you'll populate in next phase)

### Phase 5: Build Initial Backlog (3-5 minutes)

**Start broad:**
"Now let's think about features. What are the first 3-5 things you want to build?"

**As user mentions features:**
- Create spec file immediately: `feature-[name].md` in `/docflow/specs/backlog/`
- Ask 1-2 clarifying questions per feature:
  - "Who is this for specifically?"
  - "What's the core behavior?"
  - "Any constraints or requirements?"
- Fill out spec with proper format (Context, User Story, Acceptance Criteria, Dependencies, Decision Log)
- Add to INDEX.md backlog section as you go

**Prioritize together:**
"Which of these is most important to start with?"

**Capture additional items:**
- "Any bugs or technical debt to track?"
- "Any future ideas to park for later?"
- Create specs for these too (bug-[name].md, idea-[name].md)

### Phase 6: Create Project Scaffolding Task (Dynamic)

This is **NOT a template** - create this spec based on everything you learned:

**Create:** `/docflow/specs/active/feature-project-scaffolding.md`

**Customize it with:**
- Their specific framework and version
- Their specific dependencies
- Their folder structure preferences
- Acceptance criteria that match their stack:
  - Framework initialized (with specific command)
  - Their chosen styling system set up
  - Their chosen database/backend initialized
  - TypeScript configured (strict mode)
  - Their linting preferences
  - First route/page working

**Set metadata:**
```markdown
**Status**: READY  
**Owner**: Implementation  
**AssignedTo**: @username (from git config)  
**Priority**: Critical (must complete first)
```

**Critical: Include installation commands**
In Technical Notes section, include exact commands for their stack:
```markdown
## Technical Notes

### Initialization Command
[Specific command for their framework with . flag]

### Critical Rules
- Initialize in current directory (use . flag)
- Do NOT create nested folders
- If framework creates subfolder, move contents up and delete

### Dependencies to Install
[List their specific deps: Tailwind, Convex, shadcn, etc.]
```

**Add to ACTIVE.md as primary focus**
**Add to INDEX.md active section**

### Phase 7: Handoff

**Summarize what was created:**
```
✅ Project vision documented in /docflow/context/
✅ Tech stack: [their stack] defined
✅ Initial backlog created: [count] features, [count] ideas
✅ First task ready: Project Scaffolding (assigned to @username)
```

**Clear next step:**
"Your project is set up! The first task is to scaffold [framework]. Ready to start implementing? You can run `/start-session` or just say 'let's start' and I'll hand this off to the Implementation agent."

## Tools to Use

- `list_dir` - Detect project structure
- `read_file` - Read package.json, config files
- `run_terminal_cmd` - Execute git commands: `git config github.user` or `git config user.name`
- `grep` - Search for patterns in config files

## Key Principles

### Be Conversational
This is a planning session, not data entry. Listen, adapt, follow the thread of conversation.

### Create as You Go
Don't collect all info then create files. Create specs as features are discussed. More natural.

### Use What Exists
If package.json or configs exist, read them first. Don't ask questions you can answer yourself.

### Make It Specific
The scaffolding task should be tailored to THEIR project, not generic. Include their exact stack, their preferences, their constraints.

### One Active Task Only
Only the scaffolding task should be in /specs/active/ and status=READY. Everything else in backlog.

### Assign Immediately
Get developer username and set AssignedTo= so Implementation agent knows it's theirs.

## Common Scenarios

### Scenario A: Empty Directory
User copies DocFlow template, no code exists yet.
→ Full new project flow, scaffolding is truly first task

### Scenario B: Existing package.json
Some initialization already done.
→ Detect stack, ask "looks like you started with [X], want me to help plan the features?"
→ Scaffolding task might be "Complete project setup" instead

### Scenario C: User Uncertain About Stack
→ Ask about project type (web app? mobile? API?)
→ Suggest appropriate stack based on their needs
→ Explain trade-offs briefly

## Red Flags to Avoid

❌ Robotic questioning ("Question 1 of 10...")
❌ Creating generic templates (customize everything)
❌ Waiting until end to create files (create as you go)
❌ Multiple active tasks (only scaffolding)
❌ Missing AssignedTo (always assign to developer)
❌ Vague scaffolding criteria (be specific to their stack)

## Success Criteria

✅ User feels heard and understood
✅ Context files accurately reflect their project
✅ Backlog has 3-8 concrete, actionable specs
✅ Scaffolding task is detailed and project-specific
✅ User knows exactly what happens next
✅ Handoff to Implementation agent is clear

