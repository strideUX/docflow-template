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

## MCP Tools

- `get_design_context(fileKey, nodeId)` - Colors, spacing, structure
- `get_screenshot(fileKey, nodeId)` - Visual reference
- `get_variable_defs(fileKey)` - Design tokens

## Full Rules

See `.docflow/rules/figma-integration.md` for complete patterns.
