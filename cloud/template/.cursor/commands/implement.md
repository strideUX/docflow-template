# Implement (Implementation Agent)

Pick up a Linear issue and build it. Implementation includes code, tests, and documentation.

## Steps

1. **Find Work** - Query Linear for Todo/In Progress/Blocked issues
2. **Check Assignment** - Warn if assigned to someone else
3. **Load Context** - Issue, stack.md, standards.md, Figma (if attached)
4. **Move to In Progress** - Update Linear state
5. **Show Checklist** - code + tests + docs reminder
6. **Build** - Update checkboxes as criteria completed
7. **Complete** - Move to In Review, add summary comment

## Context to Load

- Linear issue (full description + comments)
- `{paths.content}/context/stack.md`
- `{paths.content}/context/standards.md`
- Figma MCP (if attached)

## On Blocker

Run `/block` to document and move to Blocked state.

## Natural Language Triggers

- "implement [issue]" / "build [issue]" / "let's work on LIN-XXX"

## Full Rules

See `.docflow/rules/workflow-agent.md` → Implementation section
