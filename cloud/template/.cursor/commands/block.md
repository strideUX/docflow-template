# Block (Implementation Agent)

Move an issue to Blocked status when implementation cannot proceed.

## Steps

1. **Identify Issue** - Current in-progress work
2. **Gather Details** - What's blocking, what's needed
3. **Move to Blocked** - Update Linear state
4. **Link Dependency** - If blocked by another issue
5. **Add Comment** - `**Blocked** — [What's blocking]. Needs: [what's needed].`
6. **Notify** - Tag relevant people

## Comment Format

```markdown
**Blocked** — [Brief description].
**Needs:** [What's needed to unblock]
**Blocked by:** LIN-XXX (if applicable)
```

## Resuming

When unblocked, run `/implement` to move back to In Progress.

## Natural Language Triggers

- "I'm blocked" / "can't proceed" / "stuck on this"

## Full Rules

See `.docflow/rules/workflow-agent.md` → Implementation section
