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

1. **Ask about Figma files:**
   
   ```markdown
   📐 **Figma File Configuration**
   
   Do you have Figma files for this project?
   
   I'll need:
   - **Design System File** (optional) — Contains your design tokens (colors, spacing, typography)
   - **Designs File** (optional) — Contains your actual UI designs
   
   **How to find the file key:**
   From a Figma URL like: `https://www.figma.com/file/abc123xyz/DesignSystem`
   The file key is: `abc123xyz`
   
   Please provide:
   1. Design System file key (for tokens): ___________
   2. Designs file key (for UI): ___________
   3. Or type "skip" to set up manually later
   ```

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

1. **Update config with all collected information:**
   
   Save to `.docflow/config.json`:
   ```json
   {
     "designSystem": {
       "enabled": true,
       "framework": "tailwind",
       "tailwindVersion": 4,
       "figmaFiles": {
         "designs": "[designs-file-key-from-user]",
         "system": "[system-file-key-from-user]"
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

2. **Show summary:**
   ```markdown
   ✅ **Design System Configured!**
   
   **Files Created:**
   - `.docflow/design-system/token-mapping.md` — Edit to add your token translations
   - `.docflow/design-system/component-patterns.md` — Document your components
   
   **Configuration Saved:**
   - Framework: Tailwind CSS v4
   - Figma Design System: [file-key or "not set"]
   - Figma Designs: [file-key or "not set"]
   - Asset Path: public/images
   - Icon Strategy: Figma-only
   - Validation: [enabled/disabled]
   
   **What This Enables:**
   - Figma workflow now enforces token usage
   - Specification tables must map to project tokens
   - Implementation validated against token-mapping.md
   
   **Next Steps:**
   1. Fill out `.docflow/design-system/token-mapping.md` with your project's tokens
   2. Run `/implement` on an issue with Figma attachment to test the workflow
   3. Optionally add validation script for automated enforcement
   ```

3. **If Figma file keys were provided:**
   - Offer to run token extraction: "Would you like me to extract tokens from your Figma design system now?"
   - If yes, call `get_variable_defs(fileKey)` and populate token-mapping.md

## Notes

- Design system is optional - baseline Figma behavior always works
- Can be added to existing projects at any time
- Token mapping can be updated with `/extract-tokens` (create if doesn't exist)
- Use `designer-agent.md` rules for token extraction work


