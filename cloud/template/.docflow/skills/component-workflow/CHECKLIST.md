# Component Checklist

**Complete ALL items for every component.**

---

## Phase 0: Component Reuse Check (MANDATORY)

**STOP! Before writing ANY UI code, answer these questions:**

- [ ] Does a similar component exist? → Reuse or extend it
- [ ] Can existing components be composed? → Compose, don't duplicate
- [ ] Is there a design system/component library? → Use those components

**If an existing component can do the job, USE IT.**

---

## Phase 1: Before Building

- [ ] **Confirmed no existing component can be reused**
- [ ] Checked if component already exists in codebase
- [ ] Got Figma screenshot (if implementing from design)
- [ ] Got design context (if implementing from design)
- [ ] Created specification table (Figma → implementation)
- [ ] Identified all assets to download
- [ ] Downloaded all assets (no placeholders)
- [ ] Planned component structure (props, variants)

---

## Phase 2: During Build

### Code Structure
- [ ] Component uses `cn()` for class composition
- [ ] TypeScript interface defined for props
- [ ] Props extend appropriate HTML attributes
- [ ] Allows `className` override
- [ ] No inline styles (unless documented exception)

### Styling
- [ ] All colors use tokens or documented values
- [ ] All spacing matches design
- [ ] Typography matches (font, size, weight, color)
- [ ] Border radius matches
- [ ] Shadows match (if applicable)

### Assets
- [ ] All images downloaded from Figma
- [ ] Logo uses actual asset (not text)
- [ ] Icons extracted from Figma (unless library allowed)
- [ ] No placeholder images

---

## Phase 3: After Build - Validation

### Visual Comparison (REQUIRED)

Compare implementation to Figma screenshot element by element:

- [ ] **Logo**: Correct asset, exact dimensions, correct position
- [ ] **Typography**: Font family, size, weight, color, line-height for EVERY text element
- [ ] **Spacing**: Gaps, padding, margins match EXACTLY
- [ ] **Colors**: All background, text, border colors match
- [ ] **Sizing**: Width, height, max-width values match
- [ ] **Alignment**: All elements aligned as in Figma
- [ ] **Borders**: Radius, width, color match
- [ ] **Shadows**: All shadows match design

### Interactive States
- [ ] Hover states work correctly
- [ ] Focus states visible and correct
- [ ] Active states work correctly
- [ ] Disabled states (if applicable) correct

### Accessibility
- [ ] Keyboard navigation works
- [ ] ARIA attributes correct
- [ ] Alt text for images
- [ ] Focus indicators visible

### Final Steps
- [ ] Tests written and passing
- [ ] Exported from index.ts
- [ ] Added to parent index.ts
- [ ] No TypeScript errors
- [ ] No lint errors

---

## Red Flags (STOP AND FIX)

If you see ANY of these in your code, STOP and fix before proceeding:

```tsx
// ❌ WORST OFFENSE: Inline button styles when Button component exists
<button className="bg-blue-600 text-white px-4 py-2 rounded-md">
// ✅ Fix: Use the Button component
import { Button } from '@/components/buttons'
<Button variant="primary">Submit</Button>

// ❌ Duplicating component styling inline
<button className="relative w-full bg-blue-600...">
// ✅ Fix: Use the component with className for width
<Button variant="primary" className="w-full">Submit</Button>

// ❌ Placeholder image
<img src="/placeholder.svg" />
// ✅ Fix: Download actual asset from Figma

// ❌ Text-only logo
<span className="font-bold">Company</span>
// ✅ Fix: Use actual logo SVG from Figma
<img src="/images/logo.svg" alt="Company" />

// ❌ Template literal for class merging
className={`base-styles ${className}`}
// ✅ Fix: Use cn() for proper merging
className={cn('base-styles', className)}
```

---

## Validation Failure Protocol

If visual comparison reveals ANY discrepancy:

1. **Document** the specific issue (element, expected vs actual)
2. **Fix** the code to match design exactly
3. **Re-validate** after fix
4. **Repeat** until 100% match

**DO NOT mark component as complete until visual validation passes.**

