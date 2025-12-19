# Figma Integration Rules

> Load when working with Figma designs or UI implementation.

---

## When to Use

Load this rule when:
- Linear issue has a Figma attachment
- User mentions Figma or design specs
- Implementing UI components from designs

---

## Core Skill Reference

**For complete Figma workflow, load the `figma-mcp` skill:**
- `.docflow/skills/figma-mcp/SKILL.md` - Full 5-phase workflow
- `.docflow/skills/figma-mcp/PROMPTING.md` - Prompting strategies
- `.docflow/skills/figma-mcp/TROUBLESHOOTING.md` - Common issues

**For component patterns, load the `component-workflow` skill:**
- `.docflow/skills/component-workflow/SKILL.md` - Component patterns
- `.docflow/skills/component-workflow/CHECKLIST.md` - Validation checklist

---

## Quick Reference

### Available MCP Tools

```typescript
// Get visual reference (ALWAYS FIRST)
get_screenshot(fileKey, nodeId)

// Get design context (colors, spacing, structure)
get_design_context(fileKey, nodeId)

// Get design tokens/variables
get_variable_defs(fileKey, nodeId?)

// Get node structure for large designs
get_metadata(fileKey, nodeId)
```

### Extracting Figma URL Components

Figma URL format:
```
https://www.figma.com/file/{fileKey}/{fileName}?node-id={nodeId}
```

Extract:
- `fileKey` - The file identifier
- `nodeId` - The specific frame/component (URL decoded: `123-456` → `123:456`)

---

## Baseline Behavior (Always Applies)

Regardless of design system configuration:

1. **Screenshot First** - Always get visual reference before implementing
2. **Download Assets** - Never use placeholders
3. **Specification Table** - Document Figma values before coding
4. **Visual Validation** - Compare implementation to design

---

## Design System Enhancement

**Check for design system configuration:**

If `.docflow/config.json` has `designSystem.enabled: true`:
1. Load `.docflow/design-system/token-mapping.md`
2. Map all Figma values to project tokens
3. Run validation script before completion
4. Document exceptions for values without tokens

If no design system configured:
- Use exact Figma values
- Document all values in specification table
- Note opportunities for tokenization

---

## 5-Phase Workflow Summary

### Phase 1: Visual Reference
```
get_screenshot(fileKey, nodeId)
```
Keep visible throughout implementation.

### Phase 2: Extract Data
```
get_design_context(fileKey, nodeId)
```
Extract colors, spacing, typography, assets.

### Phase 3: Specification Table
Map every Figma value to implementation.

### Phase 4: Download & Implement
Download ALL assets first, then build.

### Phase 5: Validate
Compare element-by-element to screenshot.

---

## Attaching Figma to Issues

When creating or refining issues with UI work:
1. Get Figma URL from user
2. Add as attachment to Linear issue
3. Note in issue description which frame to reference

---

## Related Rules

- **Designer Agent** (`designer-agent.md`) - Design system setup and token extraction
- **Implementation Agent** (`implementation-agent.md`) - Building features

## Related Skills

- **figma-mcp** - Complete Figma workflow and validation
- **component-workflow** - Component patterns and testing
