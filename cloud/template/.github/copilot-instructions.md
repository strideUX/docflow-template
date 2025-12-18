# DocFlow Cloud Instructions for GitHub Copilot

This project uses **DocFlow Cloud** with Linear integration.

## Primary Documentation

1. **`.docflow/config.json`** - Configuration (read first)
2. **`.docflow/rules/core.md`** - Essential workflow rules
3. **`.docflow/rules/`** - Role-specific rules
4. **`AGENTS.md`** - Universal agent instructions

---

## Quick Integration Guide

### Check Configuration
```bash
cat .docflow/config.json
```
Get `paths.content` for context/knowledge paths.

### Follow Coding Standards
Read `{paths.content}/context/standards.md` for conventions.

### Respect Tech Stack
Read `{paths.content}/context/stack.md` for patterns.

### Search Before Creating
Check existing code and `{paths.content}/knowledge/` for patterns.

---

## Key Differences

- **Specs live in Linear** (not local files)
- **Context stays local** in `{paths.content}/`
- **Status tracked by Linear** workflow states

---

## Code Suggestions

When suggesting code:
1. Follow patterns in `stack.md`
2. Match conventions in `standards.md`
3. Reference acceptance criteria from Linear
4. Use existing utilities and components

---

*For complete rules, see `.docflow/rules/` directory.*
