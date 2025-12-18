# Figma Integration Rules

> Load when working with Figma designs or UI implementation.

---

## When to Use

Load this rule when:
- Linear issue has a Figma attachment
- User mentions Figma or design specs
- Implementing UI components

---

## Figma MCP Integration

When issue has Figma attachment:
1. Extract fileKey and nodeId from URL
2. Call Figma MCP: `get_design_context(fileKey, nodeId)`
3. Use returned specs for implementation

### Available MCP Tools

```typescript
// Get design context (colors, spacing, structure)
get_design_context(fileKey, nodeId)

// Get screenshot for visual reference
get_screenshot(fileKey, nodeId)

// Get design tokens/variables
get_variable_defs(fileKey)
```

---

## Extracting Figma URL Components

Figma URL format:
```
https://www.figma.com/file/{fileKey}/{fileName}?node-id={nodeId}
```

Extract:
- `fileKey` - The file identifier
- `nodeId` - The specific frame/component (URL decoded)

---

## Using Design Context

When implementing from Figma specs:
1. Match colors exactly (use design tokens if available)
2. Use specified spacing values
3. Follow component structure from design
4. Check for responsive variants

---

## Attaching Figma to Issues

When creating or refining issues with UI work:
1. Get Figma URL from user
2. Add as attachment to Linear issue
3. Note in issue description which frame to reference
