# Figma MCP Prompting Strategies

Get better output by using the right tools and prompts.

## Tool Selection

| Situation | Tool to Use |
|-----------|-------------|
| Building a component | `get_screenshot` → `get_design_context` |
| Need specific token values | `get_variable_defs` |
| Large/complex design | `get_metadata` first, then target sub-nodes |
| Visual validation | `get_screenshot` |

## Framework Customization

Default output is **React + Tailwind**. Customize with prompts:

```
"Generate this in Vue"
"Generate this in plain HTML + CSS"
"Generate this for iOS SwiftUI"
```

## Using Existing Components

```
"Generate using components from src/components/"
"Use the existing Button and Card components"
"Compose this with our design system components"
```

## Breaking Down Large Selections

Large selections cause slow responses or incomplete output. Break them down:

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

### When to Break Down

- Response seems slow → reduce selection size
- Output is truncated → use `get_metadata`, target sub-nodes
- Complex nested elements → handle pieces separately

## Asset Handling

The MCP server hosts assets at `http://localhost:3845/assets/...`

### Do

```tsx
// Download assets using curl, then reference locally
<img src="/images/feature.png" alt="Feature" />

// Use SVGs from MCP response
<svg>...</svg>
```

### Don't

```tsx
// Don't use placeholders
<img src="/placeholder.png" />

// Don't import icon packages (unless project allows)
import { Icon } from 'lucide-react'
```

## Token Extraction

When you need specific token values:

```
"Get the variables used in this selection"
"What color and spacing variables are used here?"
"List the variable names and their values"
```

## Quality Prompts

```
"Build this with 1:1 visual parity to Figma"
"Match all interactive states (hover, focus, active, disabled)"
"Use only project design tokens, no hardcoded values"
```

