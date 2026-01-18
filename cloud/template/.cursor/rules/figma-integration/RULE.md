---
description: "Figma MCP integration - design context loading, UI implementation from designs"
globs: []
alwaysApply: false
---

# Figma Integration

Handles Figma MCP integration for design-driven implementation.

## When to Apply

- Linear issue has Figma attachment
- User mentions Figma or design specs
- Implementing UI components

## Quick Reference

### MCP Tools

- `get_screenshot(fileKey, nodeId)` - Visual reference (ALWAYS FIRST)
- `get_design_context(fileKey, nodeId)` - Colors, spacing, structure
- `get_variable_defs(fileKey)` - Design tokens
- `get_metadata(fileKey, nodeId)` - Node structure for large designs

### Baseline Behavior

1. Screenshot first - get visual truth
2. Download ALL assets - no placeholders
3. Create specification table before coding
4. Validate against screenshot

## Design System Enhancement

If `.docflow/config.json` has `designSystem.enabled: true`:
- Load `.docflow/design-system/token-mapping.md`
- All Figma values must map to project tokens
- Run validation script before marking complete

## Full Documentation

- **Skills:** `.claude/skills/figma-mcp/SKILL.md` - Complete workflow
- **Rules:** `.docflow/rules/figma-integration.md` - Full patterns
- **Designer Agent:** `.docflow/rules/designer-agent.md` - Token extraction
