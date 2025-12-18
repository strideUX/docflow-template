# Capture (PM/Planning Agent)

Quickly capture new work to Linear backlog without context switching.

## Steps

1. **Identify Type** - feature, bug, chore, or idea
2. **Gather Context** - title, description, user value
3. **Apply Template** from `.docflow/templates/`
4. **Set Metadata** - priority (1-4), estimate (1-5, optional)
5. **Create Linear Issue** - Backlog state
6. **Confirm** with issue link

## Context to Load

- `.docflow/config.json`
- `.docflow/templates/{type}.md`

## Natural Language Triggers

- "capture that" / "add to backlog" / "found a bug" / "new idea"

## Quick Capture Mode

For fast capture: minimal issue, refine later with `/refine`.

## Full Rules

See `.docflow/rules/pm-agent.md` and `.docflow/skills/spec-templates/SKILL.md`
