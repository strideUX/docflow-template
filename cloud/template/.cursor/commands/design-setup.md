---
description: Initialize or update design system integration for this project
---

# Design System Setup

Set up design system integration to enhance Figma-to-code accuracy.

## Prerequisites

- Figma MCP configured (optional but recommended)
- Project already has `.docflow/config.json`

## Workflow

### Phase 1: Gather Information

1. **Ask about design system source:**
   - "Do you have a Figma file with your design system/tokens?"
   - If yes, get the file key
   - If no, we'll create a manual token mapping

2. **Determine styling framework:**
   - Tailwind CSS (ask version: 3 or 4)
   - CSS Modules
   - Styled Components
   - Other

3. **Asset configuration:**
   - Asset storage path (default: `public/images`)
   - Icon strategy: Figma-only or library allowed?

### Phase 2: Extract Tokens (if Figma provided)

If user provides Figma design system file:

1. **Call Figma MCP:**
   ```
   get_variable_defs(fileKey)
   ```

2. **Extract and categorize:**
   - Colors (background, text, border, brand)
   - Spacing values
   - Typography (fonts, sizes, weights)
   - Border radius
   - Shadows

3. **Generate token mapping**

### Phase 3: Create Configuration

1. **Create design system directory:**
   ```
   .docflow/design-system/
   ├── token-mapping.md
   └── component-patterns.md
   ```

2. **Copy templates from:**
   ```
   .docflow/templates/design-system/
   ```

3. **Populate token-mapping.md** with extracted tokens (or leave template for manual entry)

4. **Update .docflow/config.json:**
   ```json
   {
     "designSystem": {
       "enabled": true,
       "framework": "tailwind",
       "tailwindVersion": 4,
       "figmaFiles": {
         "designs": "abc123",
         "system": "xyz789"
       },
       "assetPath": "public/images",
       "iconStrategy": "figma-only",
       "validation": {
         "script": null,
         "preCommit": false
       }
     }
   }
   ```

### Phase 4: Optional - Validation Script

Ask if user wants automated design system validation:

If yes:
1. Copy validation script template to `scripts/check-design-system.mjs`
2. Configure forbidden patterns based on framework
3. Update config with script path
4. Optionally add to pre-commit hooks

If no:
- Skip validation script setup

### Phase 5: Document Component Patterns

1. **Scan for existing components:**
   - Look in `src/components/`
   - Identify reusable patterns

2. **Populate component-patterns.md:**
   - Document available components
   - Add usage examples
   - Note import paths

### Phase 6: Complete

1. **Show summary:**
   ```
   ✅ Design System Configured
   
   Token Mapping: .docflow/design-system/token-mapping.md
   Component Patterns: .docflow/design-system/component-patterns.md
   Validation: [enabled/disabled]
   
   Framework: Tailwind CSS v4
   Asset Path: public/images
   Icon Strategy: Figma-only
   ```

2. **Explain enhancement:**
   - Figma workflow now enforces token usage
   - Specification tables map to project tokens
   - Validation catches hardcoded values (if enabled)

3. **Next steps:**
   - Review and customize token-mapping.md
   - Add any missing component patterns
   - Run `/implement` on an issue with Figma to test

## Notes

- Design system is optional - baseline Figma behavior always works
- Can be added to existing projects at any time
- Token mapping can be updated with `/extract-tokens` (create if doesn't exist)
- Use `designer-agent.md` rules for token extraction work

