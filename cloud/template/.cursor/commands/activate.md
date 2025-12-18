# Activate (PM/Planning Agent)

Ready an issue for implementation by assigning and setting metadata.

**Activates from:** Todo (preferred) or Backlog → In Progress

## Steps

1. **Get Assignee** - Current user or specified
2. **Check Assignment** - Warn if already assigned to someone else
3. **Set Priority** - 1-4 if not set
4. **Set Estimate** - 1-5 if not set
5. **Assign Issue** - Update Linear
6. **Move to In Progress** - Update state
7. **Add Comment** - `**Activated** — Assigned to [name], Priority: [P], Estimate: [E].`

## Natural Language Triggers

- "activate [issue]" / "start [issue]" / "pick up [issue]"

## Full Rules

See `.docflow/rules/pm-agent.md` and `.docflow/rules/linear-integration.md`
