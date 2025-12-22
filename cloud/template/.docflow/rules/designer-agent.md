# Designer Agent Rules

> Load for design system setup, token extraction, and design governance.

---

## Role Overview

The Designer Agent manages design-to-code translation:
- Extracts design tokens from Figma
- Maintains token mapping documentation
- Reviews implementations for design consistency
- Updates component patterns as design evolves

---

## When to Load

- `/design-setup` - Initialize design system integration
- `/extract-tokens` - Pull tokens from Figma
- When working with Figma attachments containing design system components
- When reviewing implementations for design consistency

---

## Design System States

### No Design System (Default)

When `.docflow/config.json` does NOT have `designSystem.enabled: true`:

- Use baseline Figma workflow from `figma-mcp` skill
- Document all Figma values in specification tables
- Use exact values from Figma
- Note opportunities for tokenization

### Design System Enabled

When `.docflow/config.json` has `designSystem.enabled: true`:

- Load token mapping from `.docflow/design-system/token-mapping.md`
- All Figma values MUST map to project tokens
- Run validation script before marking complete
- Document any values without tokens as exceptions
- Enforce stricter "no hardcoded values" rules

---

## Design System Initialization (via /design-setup)

### Phase 1: Gather Information

1. **Ask for Figma design system file:**
   - "Do you have a Figma file with your design system/tokens?"
   - Get file key if available

2. **Determine framework:**
   - Tailwind CSS (version?)
   - CSS Modules
   - Styled Components
   - Other

3. **Asset handling:**
   - Where should assets be stored? (default: `public/images`)
   - Are icon libraries allowed? (default: Figma-only)

### Phase 2: Extract Tokens (if Figma file provided)

1. Call `get_variable_defs(fileKey)` to get design tokens
2. Extract:
   - Color tokens (backgrounds, text, borders)
   - Spacing tokens
   - Typography tokens (fonts, sizes, weights)
   - Border radius tokens
   - Shadow tokens

3. Generate token mapping file

### Phase 3: Create Configuration

1. Update `.docflow/config.json` with design system config
2. Create `.docflow/design-system/` directory
3. Generate `token-mapping.md` with extracted tokens
4. Optionally create validation script from template

### Phase 4: Document Patterns

1. Create `component-patterns.md` if component library exists
2. Document available components for reuse
3. Note any project-specific conventions

---

## Token Extraction Workflow

When asked to extract or update tokens:

### 1. Get Variables from Figma

```
mcp__figma__get_variable_defs(fileKey, nodeId?)
```

### 2. Parse and Categorize

Group tokens by type:
- **Colors**: Background, text, border, brand colors
- **Spacing**: Padding, margin, gap values
- **Typography**: Font families, sizes, weights, line heights
- **Borders**: Radius values
- **Shadows**: Drop shadows, inner shadows

### 3. Generate Mapping File

Create `.docflow/design-system/token-mapping.md`:

```markdown
# Token Mapping

## Colors

### Background Colors
| Figma Variable | Hex | Tailwind Class |
|----------------|-----|----------------|
| `--bg-primary` | #ffffff | `bg-bg-primary` |
| `--bg-secondary` | #f9fafb | `bg-bg-secondary` |

### Text Colors
| Figma Variable | Hex | Tailwind Class |
|----------------|-----|----------------|
| `--text-primary` | #111827 | `text-text-primary` |

## Spacing
| Figma (px) | Token | Class |
|------------|-------|-------|
| 4px | spacing-xs | `p-xs`, `gap-xs` |
| 8px | spacing-sm | `p-sm`, `gap-sm` |
...
```

### 4. Update Config

```json
{
  "designSystem": {
    "enabled": true,
    "framework": "tailwind",
    "figmaFiles": {
      "system": "abc123"
    }
  }
}
```

---

## Design Review

When reviewing implementations for design consistency:

### Checklist

1. **Token Usage**
   - All colors use defined tokens
   - All spacing uses defined tokens
   - No hardcoded hex values
   - No arbitrary pixel values (for tokenized values)

2. **Asset Compliance**
   - Icons from Figma (unless library allowed)
   - No placeholder images
   - Logo is actual asset

3. **Pattern Compliance**
   - Uses existing components where available
   - Follows established patterns
   - Consistent with design system

4. **Visual Accuracy**
   - Matches Figma design exactly
   - All interactive states implemented
   - Responsive behavior correct

### Common Issues

| Issue | Fix |
|-------|-----|
| Hardcoded color `#026aa2` | Use `bg-brand-solid` token |
| Arbitrary spacing `px-[18px]` | Document exception or create token |
| Icon library import | Extract icon from Figma |
| Missing hover state | Add hover styles from design |

---

## Context Loading

**For Token Extraction:**
- `.docflow/config.json` (current settings)
- Figma design system file

**For Design Review:**
- `.docflow/design-system/token-mapping.md`
- Implementation code being reviewed
- Figma design reference

**For Setup:**
- Project's existing CSS/styling setup
- `.docflow/config.json` (to update)

---

## Natural Language Triggers

| Phrase | Action |
|--------|--------|
| "setup design system" | /design-setup |
| "extract tokens from Figma" | /extract-tokens (create if doesn't exist) |
| "update token mapping" | Refresh tokens from Figma |
| "check design consistency" | Review implementation against tokens |
| "add design system" | /design-setup |

---

## File Templates

### Token Mapping Template

```markdown
# Token Mapping (Figma → Project)

Translate Figma values to project design tokens.

---

## Colors

### Background Colors
| Figma Variable | Hex | Tailwind Class |
|----------------|-----|----------------|
| | | |

### Text Colors
| Figma Variable | Hex | Tailwind Class |
|----------------|-----|----------------|
| | | |

### Border Colors
| Figma Variable | Hex | Tailwind Class |
|----------------|-----|----------------|
| | | |

---

## Typography

### Font Families
| Figma Font | Tailwind Class |
|------------|----------------|
| | |

### Font Sizes
| Figma Size | Tailwind Class | Line Height |
|------------|----------------|-------------|
| | | |

---

## Spacing

| Figma (px) | Token | Class Examples |
|------------|-------|----------------|
| | | |

---

## Border Radius

| Figma (px) | Token | Tailwind Class |
|------------|-------|----------------|
| | | |
```

---

## Validation Script (Optional)

When design system is configured with validation, the script at `designSystem.validation.script` will:

1. Scan source files for forbidden patterns
2. Report violations with file/line numbers
3. Fail build/commit if violations found

Forbidden patterns typically include:
- Hardcoded hex colors
- Hardcoded spacing values
- Raw rgba() values
- Arbitrary radius values

Allowed exceptions:
- Layout sizing (`w-[Xpx]`, `h-[Xpx]`)
- One-off documented exceptions


