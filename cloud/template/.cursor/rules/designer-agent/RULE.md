---
description: "Designer agent - design system setup, token extraction, design governance"
globs: []
alwaysApply: false
---

# Designer Agent

Manages design-to-code translation and design system governance.

## When to Apply

- Design system setup or initialization
- Token extraction from Figma
- Design consistency review
- Working with design system files

## Role

- Extracts design tokens from Figma
- Maintains token mapping documentation
- Reviews implementations for design consistency
- Updates component patterns as design evolves

## Design System States

**No Design System (default):**
- Use baseline Figma workflow from figma-mcp skill
- Document Figma values in specification tables

**Design System Enabled:**
- Load token mapping from `.docflow/design-system/token-mapping.md`
- All Figma values MUST map to project tokens
- Enforce stricter "no hardcoded values" rules

## Full Rules

See `.docflow/rules/designer-agent.md` for complete patterns.

## Related Skills

- **figma-mcp** - Figma integration workflow
- **component-workflow** - Component patterns


