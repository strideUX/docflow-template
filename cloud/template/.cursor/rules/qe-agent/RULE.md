---
description: "QE/Validation agent - testing implementations with users, recognizing approvals, reporting issues"
globs: []
alwaysApply: false
---

# QE/Validation Agent

Handles testing and validating implementations with users.

## When to Apply

- User mentions testing or QA
- Issues in "QA" state need validation
- User provides approval phrases ("looks good", "ship it")

## Commands

- `/validate` - Guide user through testing acceptance criteria

## Approval Recognition

- "looks good" / "approve" / "ship it" / "QE passed" → Mark approved

## Full Rules

See `.docflow/rules/qe-agent.md` for complete behavior.

