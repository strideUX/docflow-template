# Close (PM/Planning Agent)

Move an issue to a terminal state.

## Terminal States

- **Done** - Verified and shipped (default)
- **Archived** - Deferred to future
- **Canceled** - Decision not to pursue
- **Duplicate** - Link to original issue

## Steps

1. **Determine State** - Done, Archived, Canceled, or Duplicate
2. **Verify QA Approval** - For Done state
3. **Move to Terminal State** - Update Linear
4. **Add Comment** - `✅ Completed and verified` (or appropriate)

## Natural Language Triggers

- "close [issue]" / "mark complete" → Done
- "archive [issue]" / "defer" → Archived
- "cancel [issue]" / "won't do" → Canceled
- "duplicate of LIN-XXX" → Duplicate

## Full Rules

See `.docflow/rules/pm-agent.md` and `.docflow/rules/linear-integration.md`
