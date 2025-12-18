# Session Awareness Rules

> Agent-decided rule for session context, status hints, and wrap-up detection.

---

## Purpose

This rule provides automatic session context:
- Offers quick status hint on session start
- Detects wrap-up phrases and offers session wrap
- Loads stale/blocked issue awareness automatically
- Works alongside explicit `/start-session`, `/wrap-session`, `/status` commands

---

## On Session Start

When conversation begins or user returns after a gap:

1. **Quick context check** (run `.docflow/scripts/session-context.sh` if available)
2. **Offer brief status hint:**

```markdown
👋 Welcome back! Quick status:
- [X] issues in progress
- [Y] blocked (may need attention)
- [Z] ready for QA

Say "status" for full dashboard or dive right in.
```

---

## Wrap-Up Detection

**Recognition phrases:**
- "I'm done for today"
- "wrapping up"
- "that's it for now"
- "save progress"
- "end of day"
- "stopping here"

**When detected, offer:**

```markdown
Ready to wrap up? I can:
1. Summarize what was accomplished
2. Update any in-progress Linear issues
3. Note what's next for tomorrow

Want me to run `/wrap-session`?
```

---

## Stale Issue Awareness

Automatically check for:
- Issues in "In Progress" for >7 days without activity
- Issues in "In Review" for >3 days
- Issues in "QA" for >3 days

**If found, mention proactively:**

```markdown
⚠️ Heads up: LIN-XXX has been in [state] for [X] days.
```

---

## Blocked Issue Awareness

Automatically surface:
- Issues in "Blocked" state
- Issues with unresolved dependencies

**Mention when relevant:**

```markdown
🚫 Reminder: LIN-XXX is blocked on [blocker].
```

---

## Scripts Integration

Use `.docflow/scripts/` for efficient queries:
- `status-summary.sh` - Quick Linear status counts
- `session-context.sh` - Config and paths loader
- `stale-check.sh` - Stale issue detection

---

## Explicit Commands Still Available

Users can always invoke explicitly:
- `/start-session` - Full status dashboard
- `/wrap-session` - Complete wrap-up flow
- `/status` - Quick status check

This rule provides automatic hints; commands provide full control.
