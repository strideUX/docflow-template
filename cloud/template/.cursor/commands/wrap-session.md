# Wrap Session (PM/Planning Agent)

End a work session by summarizing progress and updating Linear.

## Steps

1. **Summarize Accomplishments** - What was done this session
2. **Update Linear Issues** - Add progress comments to in-progress work
3. **Offer Project Update** - Health status + summary (optional)
4. **Note Next Steps** - What to pick up next time

## Context to Load

- Linear issues worked on this session
- `.docflow/config.json`

## Scripts

Run `.docflow/scripts/status-summary.sh` for current state.

## Natural Language Triggers

- "wrap it up" / "I'm done" / "save progress" / "end of day"

## Full Rules

See `.docflow/rules/pm-agent.md` and `.docflow/rules/session-awareness.md`
