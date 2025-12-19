# Token Mapping (Figma → Project)

Translate Figma values to project design tokens.

> **Instructions:** Fill this file with your project's token mappings.
> Run `/extract-tokens` with a Figma design system file to auto-populate.

---

## Quick Reference: Hex → Token

| Hex | Token | Class |
|-----|-------|-------|
| | | |

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

### Brand Colors

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

### Font Weights

| Figma Weight | Tailwind Class |
|--------------|----------------|
| 400 / Regular | `font-normal` |
| 500 / Medium | `font-medium` |
| 600 / SemiBold | `font-semibold` |
| 700 / Bold | `font-bold` |

### Common Typography Patterns

| Use Case | Classes |
|----------|---------|
| Display heading | |
| Section heading | |
| Body text | |
| Button text | |
| Small text | |

---

## Spacing

| Figma (px) | Token | Class Examples |
|------------|-------|----------------|
| 4px | | `p-1`, `gap-1` |
| 8px | | `p-2`, `gap-2` |
| 12px | | `p-3`, `gap-3` |
| 16px | | `p-4`, `gap-4` |
| 20px | | `p-5`, `gap-5` |
| 24px | | `p-6`, `gap-6` |
| 32px | | `p-8`, `gap-8` |
| 40px | | `p-10`, `gap-10` |
| 48px | | `p-12`, `gap-12` |
| 64px | | `p-16`, `gap-16` |

### Values Without Tokens

| Figma (px) | Use Arbitrary Value |
|------------|---------------------|
| 18px | `px-[18px]` |
| | |

---

## Border Radius

| Figma (px) | Token | Tailwind Class |
|------------|-------|----------------|
| 4px | | `rounded-sm` |
| 6px | | `rounded-md` |
| 8px | | `rounded-lg` |
| 12px | | `rounded-xl` |
| 16px | | `rounded-2xl` |
| 9999px | | `rounded-full` |

---

## Shadows

| Figma Shadow | Tailwind Class |
|--------------|----------------|
| | |

---

## Figma Property → Tailwind Translation

### Layout Properties

| Figma Property | Value | Tailwind |
|----------------|-------|----------|
| `layoutMode` | `"VERTICAL"` | `flex flex-col` |
| `layoutMode` | `"HORIZONTAL"` | `flex flex-row` |
| `primaryAxisAlignItems` | `"MIN"` | `justify-start` |
| `primaryAxisAlignItems` | `"CENTER"` | `justify-center` |
| `primaryAxisAlignItems` | `"MAX"` | `justify-end` |
| `primaryAxisAlignItems` | `"SPACE_BETWEEN"` | `justify-between` |
| `counterAxisAlignItems` | `"MIN"` | `items-start` |
| `counterAxisAlignItems` | `"CENTER"` | `items-center` |
| `counterAxisAlignItems` | `"MAX"` | `items-end` |

### Sizing Properties

| Figma Property | Value | Tailwind |
|----------------|-------|----------|
| `layoutSizingHorizontal` | `"FIXED"` | `w-[Xpx]` |
| `layoutSizingHorizontal` | `"FILL"` | `w-full` |
| `layoutSizingHorizontal` | `"HUG"` | `w-fit` |
| `layoutSizingVertical` | `"FIXED"` | `h-[Xpx]` |
| `layoutSizingVertical` | `"FILL"` | `h-full` |
| `layoutSizingVertical` | `"HUG"` | `h-fit` |

---

## When No Token Exists

If a Figma value doesn't have a project token:

1. **Document it** in your specification table
2. **Use arbitrary value**: `p-[18px]`, `rounded-[10px]`
3. **Note for future**: Consider adding token if used frequently

```tsx
// Documented exception: 18px padding (no token)
className="px-[18px] py-3"
```

