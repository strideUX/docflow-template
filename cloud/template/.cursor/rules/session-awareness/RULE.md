---
description: "Session context awareness - detects session start/end, offers status hints, surfaces stale/blocked issues"
globs: []
alwaysApply: false
---

# Session Awareness

Provides automatic session context and wrap-up detection.

## When to Apply

- Session start (first interaction or return after gap)
- Wrap-up phrases detected ("I'm done", "wrapping up")
- Stale or blocked issues need attention

## Full Rules

See `.docflow/rules/session-awareness.md` for complete behavior.

## Scripts

- `.docflow/scripts/status-summary.sh` - Quick status counts
- `.docflow/scripts/session-context.sh` - Config loader
- `.docflow/scripts/stale-check.sh` - Stale issue detection

## Explicit Commands

Users can always invoke:
- `/start-session` - Full dashboard
- `/wrap-session` - Complete wrap-up
- `/status` - Quick check
