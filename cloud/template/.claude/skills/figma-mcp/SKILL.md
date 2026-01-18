---
name: figma-mcp
description: Build pixel-perfect UI from Figma designs. Use when building components, extracting designs, or implementing screens from Figma. Provides workflow, prompting strategies, and validation rules.
tools: mcp__figma__get_screenshot, mcp__figma__get_design_context, mcp__figma__get_variable_defs, mcp__figma__get_metadata
---

# Figma MCP Integration

Build pixel-perfect UI components from Figma designs using the Figma MCP server.

---

## 🚨 Golden Rules

**The Figma design is the ONLY source of truth.**

### ALWAYS
- Get screenshot FIRST - this is your visual truth
- Download ALL assets before writing any code
- Create specification table before implementing
- Validate implementation against screenshot element-by-element
- Use project design tokens when a design system is configured

### NEVER
- Hardcode colors, spacing, or font values when tokens exist
- Use placeholder images - download actual assets from Figma
- Use icon libraries (lucide, heroicons, etc.) unless project explicitly allows
- Guess values - extract exact values from Figma
- Skip visual validation

---

## Design System Enhancement

**Check for design system configuration:**

If `.docflow/config.json` has `designSystem.enabled: true`:
1. Load `.docflow/design-system/token-mapping.md` for translations
2. All Figma values MUST map to project tokens
3. Run validation script before marking complete
4. Document any values without tokens as exceptions

If no design system configured:
- Document all Figma values in specification table
- Use exact values from Figma
- Note where tokens could be created for consistency

---

## Workflow: 5 Phases

### Phase 1: Get Visual Reference (MANDATORY FIRST STEP)

```
mcp__figma__get_screenshot(fileKey, nodeId)
```

**This is your visual truth. Keep it visible throughout the entire process.**

The screenshot tells you:
- Color scheme and visual hierarchy
- Layout structure
- What the final result MUST look like

### Phase 2: Extract Design Data

```
mcp__figma__get_design_context(fileKey, nodeId)
```

**Extract ALL of these from the output:**

| Data Type | What to Extract |
|-----------|-----------------|
| **Dimensions** | width, height, padding, margin, gap (px values) |
| **Colors** | All hex values for backgrounds, text, borders |
| **Typography** | font-family, font-size, font-weight, line-height |
| **Assets** | const declarations at TOP of output (logo, icons, images) |
| **Border Radius** | cornerRadius values |
| **Shadows** | boxShadow definitions |
| **Layout** | flex direction, alignment, spacing |

**For precise token values:**
```
mcp__figma__get_variable_defs(fileKey, nodeId)
```

**For large/complex designs:**
```
mcp__figma__get_metadata(fileKey, nodeId)
```
Then target specific sub-nodes.

### Phase 3: Create Specification Table

**MANDATORY before writing any code.**

Map every Figma value to implementation:

| Element | Figma Value | Token/Class | Notes |
|---------|-------------|-------------|-------|
| Container bg | #f8f6f0 | `bg-[color]` | Map to token if available |
| Heading font | Inter Medium | `font-sans font-medium` | |
| Heading size | 60px / 72px | `text-6xl` | |
| Heading color | #181d27 | `text-gray-900` | |
| Button bg | #026aa2 | `bg-[color]` | Brand color |
| Button padding | 12px 18px | `py-3 px-[18px]` | |
| Gap | 12px | `gap-3` | |
| Border radius | 8px | `rounded-lg` | |

**If design system configured:** Replace generic values with project tokens.

**Document ANY value without a token as an exception.**

### Phase 4: Download Assets & Implement

**Download ALL assets FIRST:**

```bash
curl -o public/images/logo.svg "[figma-localhost-url]"
curl -o public/images/icon-arrow.svg "[figma-localhost-url]"
curl -o public/images/hero-image.png "[figma-localhost-url]"
```

**NEVER proceed without downloading assets. NEVER use placeholders.**

**Then implement using specification table:**

```tsx
// Every value comes from the specification table
<section className="bg-[#f8f6f0] py-12">
  <div className="flex flex-col gap-3">
    <h1 className="font-sans text-6xl font-medium text-gray-900">
      Title
    </h1>
    <Button>Get Started</Button>
  </div>
</section>
```

### Phase 5: Validate (MANDATORY)

Compare implementation to Figma screenshot element by element:

| Check | What to Compare |
|-------|-----------------|
| Logo | Correct asset, exact dimensions, position |
| Typography | Font, size, weight, color, line-height for EVERY text |
| Spacing | Gap, padding, margin values |
| Colors | Background, text, border colors |
| Sizing | Width, height, max-width |
| Borders | Radius, width, color |
| Shadows | All shadow values |
| Alignment | Element positioning |

**If ANY element doesn't match → FIX before marking complete.**

---

## Figma Property → CSS/Tailwind Translation

### Layout Properties

| Figma Property | Value | CSS/Tailwind |
|----------------|-------|--------------|
| `layoutMode` | `"VERTICAL"` | `flex flex-col` |
| `layoutMode` | `"HORIZONTAL"` | `flex flex-row` |
| `primaryAxisAlignItems` | `"MIN"` | `justify-start` |
| `primaryAxisAlignItems` | `"CENTER"` | `justify-center` |
| `primaryAxisAlignItems` | `"MAX"` | `justify-end` |
| `primaryAxisAlignItems` | `"SPACE_BETWEEN"` | `justify-between` |
| `counterAxisAlignItems` | `"MIN"` | `items-start` |
| `counterAxisAlignItems` | `"CENTER"` | `items-center` |
| `counterAxisAlignItems` | `"MAX"` | `items-end` |
| `counterAxisAlignItems` | `"STRETCH"` | `items-stretch` |

### Sizing Properties

| Figma Property | Value | CSS/Tailwind |
|----------------|-------|--------------|
| `layoutSizingHorizontal` | `"FIXED"` | `w-[Xpx]` |
| `layoutSizingHorizontal` | `"FILL"` | `w-full` |
| `layoutSizingHorizontal` | `"HUG"` | `w-fit` |
| `layoutSizingVertical` | `"FIXED"` | `h-[Xpx]` |
| `layoutSizingVertical` | `"FILL"` | `h-full` |
| `layoutSizingVertical` | `"HUG"` | `h-fit` |

### Fill & Stroke Properties

| Figma Property | CSS/Tailwind |
|----------------|--------------|
| `fills: [{ color: hex }]` | `bg-[#hex]` or use token |
| `fills: [{ color, opacity: 0.5 }]` | `bg-[#hex]/50` |
| `strokes: [{ color }]` | `border border-[#hex]` |
| `strokeWeight: 1` | `border` |
| `strokeWeight: 2` | `border-2` |

### Padding Translation

| Figma Padding | CSS/Tailwind |
|---------------|--------------|
| `padding: 16` (all same) | `p-4` |
| `paddingTop: 16, paddingBottom: 16` | `py-4` |
| `paddingLeft: 24, paddingRight: 24` | `px-6` |
| `py: 12, px: 16` | `py-3 px-4` |
| `py: 10, px: 18` | `py-[10px] px-[18px]` |

---

## Common Mistakes & Fixes

### ❌ Hardcoded Colors (when tokens exist)

```tsx
// WRONG (if design system configured)
className="bg-[#026aa2] text-[#414651]"

// CORRECT (use project tokens)
className="bg-brand-solid text-text-secondary"
```

### ❌ Placeholder Images

```tsx
// WRONG
<img src="/placeholder.svg" alt="Logo" />

// CORRECT
<img src="/images/logo.svg" alt="Company Name" />
```

### ❌ Icon Libraries (unless project allows)

```tsx
// WRONG
import { ArrowRight } from 'lucide-react'
<ArrowRight className="w-5 h-5" />

// CORRECT - Extract SVG from Figma
<img src="/images/icon-arrow-right.svg" alt="" className="w-5 h-5" />
```

### ❌ Text-Only Logo

```tsx
// WRONG
<span className="font-bold text-xl">Company</span>

// CORRECT
<img src="/images/logo.svg" alt="Company" className="h-8" />
```

### ❌ Raw Figma CSS Variables

```tsx
// WRONG
className="px-[var(--spacing-lg,12px)]"
style={{ fontFamily: "'Inter', sans-serif" }}

// CORRECT
className="px-3 font-sans"
```

---

## Validation Checklist

Before marking any component complete:

### Design Extraction
- [ ] Got `get_screenshot` output (FIRST)
- [ ] Got `get_design_context` output
- [ ] Created specification table with all values
- [ ] Mapped to project tokens (if design system configured)

### Assets
- [ ] ALL assets downloaded (not placeholders)
- [ ] Logo uses actual SVG from Figma
- [ ] All icons extracted from Figma (unless library allowed)
- [ ] All images downloaded from Figma URLs

### Implementation
- [ ] Colors use tokens or documented values
- [ ] Spacing matches exactly
- [ ] Typography matches exactly (font, size, weight, color)
- [ ] Border radius matches exactly
- [ ] Shadows match exactly
- [ ] Layout and alignment match

### Visual Comparison
- [ ] Side-by-side comparison with Figma screenshot
- [ ] Every element matches design
- [ ] Interactive states implemented (hover, focus, active, disabled)

---

## Troubleshooting

### Output Doesn't Match Figma

1. Re-run `get_screenshot` for fresh visual reference
2. Check token mapping is correct (if using design system)
3. Verify all spacing and sizing values translated
4. Compare interactive states

### Missing Styles

1. Run `get_variable_defs` to extract specific tokens
2. Check if style is in a parent node
3. Verify node selection is correct in Figma URL

### Incomplete Response

1. Selection is too large → break it down
2. Run `get_metadata` first to understand structure
3. Target smaller, specific nodes

### Assets Not Loading

1. Verify Figma desktop app is running
2. Check localhost URLs are being used correctly
3. Assets should be at `http://127.0.0.1:3845/assets/...`

### Slow Responses

1. Reduce selection size
2. Target specific components instead of full pages
3. Use `get_metadata` to identify specific nodes first

---

## Breaking Down Large Designs

### Strategy

1. Start with smallest logical component (button, card, input)
2. Build up to sections (header, hero, footer)
3. Compose sections into full pages

### Example

```
Full Page (too large)
├── Header (manageable)
│   ├── Logo
│   ├── Nav Links
│   └── CTA Button
├── Hero Section (manageable)
│   ├── Headline
│   ├── Subheadline
│   └── CTA Group
└── Features Grid (break down further)
    ├── Feature Card 1
    ├── Feature Card 2
    └── Feature Card 3
```

---

## Supporting Files

When design system is configured, also reference:
- **`.docflow/design-system/token-mapping.md`** - Project-specific translations
- **`.docflow/design-system/component-patterns.md`** - Reusable component patterns

See also:
- **`component-workflow` skill** - React component patterns and testing


