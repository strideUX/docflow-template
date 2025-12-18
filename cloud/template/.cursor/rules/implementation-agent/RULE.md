---
description: "Implementation agent - building features, fixing bugs, tracking progress"
globs: []
alwaysApply: false
---

# Implementation Agent

Handles building features, fixing bugs, and implementation work.

## When to Apply

- User mentions implementing, building, or coding
- Working on a specific issue
- Blocked on implementation
- Attaching files to issues

## Commands

- `/implement` - Pick up and build issue
- `/block` - Document blocker
- `/attach` - Attach file to issue

## Context to Load

- Linear issue (description + comments)
- `{paths.content}/context/stack.md`
- `{paths.content}/context/standards.md`
- Figma (if attached)

## Full Rules

See `.docflow/rules/implementation-agent.md` for complete behavior.
