---
name: component-workflow
description: Build well-structured UI components with proper patterns, testing, and validation. Use when creating components, implementing variants, or writing component tests.
---

# Component Workflow

Build well-structured UI components with TypeScript and testing.

**For Figma design extraction and token mapping, see the `figma-mcp` skill.**

---

## Component Structure

### Directory Organization

```
src/components/
├── buttons/
│   ├── Button.tsx
│   ├── Button.test.tsx
│   └── index.ts
├── cards/
│   ├── Card.tsx
│   └── index.ts
├── forms/
│   ├── Input.tsx
│   ├── Input.test.tsx
│   └── index.ts
├── navbars/
│   ├── Navbar.tsx
│   └── index.ts
├── sections/
│   ├── HeroSection.tsx
│   └── index.ts
└── index.ts          # Re-exports all components
```

### Naming Conventions

| Type | Pattern | Example |
|------|---------|---------|
| Component file | PascalCase | `Button.tsx` |
| Test file | Component + .test | `Button.test.tsx` |
| Index file | lowercase | `index.ts` |
| Directory | kebab-case plural | `buttons/`, `form-fields/` |

---

## Before Building: Reuse Check

**STOP! Before writing ANY new UI code, check:**

1. **Does a similar component already exist?** → Use it or extend it
2. **Is there a shared component library?** → Import from there
3. **Can an existing component be composed?** → Compose, don't duplicate

**Rule: Reuse > Extend > Create**

---

## Component Patterns

### Base Component Template

```tsx
import { type HTMLAttributes } from 'react'
import { cn } from '@/lib/utils'

interface ComponentProps extends HTMLAttributes<HTMLDivElement> {
  variant?: 'default' | 'alternate'
}

export function Component({
  className,
  variant = 'default',
  children,
  ...props
}: ComponentProps) {
  return (
    <div
      className={cn(
        // Base styles
        'flex flex-col gap-3',
        // Variant styles
        variant === 'alternate' && 'bg-gray-100',
        // Allow override
        className
      )}
      {...props}
    >
      {children}
    </div>
  )
}
```

### Variant Pattern (with class-variance-authority)

For components with multiple variants, use CVA:

```tsx
import { cva, type VariantProps } from 'class-variance-authority'
import { cn } from '@/lib/utils'

const buttonVariants = cva(
  [
    // Base styles (always applied)
    'inline-flex items-center justify-center',
    'font-medium text-base',
    'rounded-lg transition-colors',
    'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2',
    'disabled:pointer-events-none disabled:opacity-50',
  ],
  {
    variants: {
      variant: {
        primary: [
          'bg-blue-600 text-white',
          'hover:bg-blue-700',
        ],
        secondary: [
          'bg-white text-gray-700',
          'border border-gray-300',
          'hover:bg-gray-50',
        ],
        ghost: [
          'bg-transparent text-gray-600',
          'hover:bg-gray-100',
        ],
      },
      size: {
        sm: 'px-3 py-1.5 text-sm',
        md: 'px-4 py-2',
        lg: 'px-6 py-3',
      },
    },
    defaultVariants: {
      variant: 'primary',
      size: 'md',
    },
  }
)

interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {}

export function Button({ className, variant, size, ...props }: ButtonProps) {
  return (
    <button
      className={cn(buttonVariants({ variant, size }), className)}
      {...props}
    />
  )
}
```

### Compound Component Pattern

For complex components with multiple parts:

```tsx
const Card = ({ children, className, ...props }: HTMLAttributes<HTMLDivElement>) => (
  <div className={cn('rounded-lg bg-white shadow-sm', className)} {...props}>
    {children}
  </div>
)

const CardHeader = ({ children, className, ...props }: HTMLAttributes<HTMLDivElement>) => (
  <div className={cn('p-4 border-b border-gray-200', className)} {...props}>
    {children}
  </div>
)

const CardContent = ({ children, className, ...props }: HTMLAttributes<HTMLDivElement>) => (
  <div className={cn('p-4', className)} {...props}>
    {children}
  </div>
)

// Usage
<Card>
  <CardHeader>Title</CardHeader>
  <CardContent>Body</CardContent>
</Card>
```

---

## Export Pattern

### Component Index

```tsx
// src/components/buttons/index.ts
export { Button } from './Button'
export { ButtonLink } from './ButtonLink'
export type { ButtonProps } from './Button'
```

### Root Index

```tsx
// src/components/index.ts
export * from './buttons'
export * from './cards'
export * from './forms'
export * from './navbars'
export * from './sections'
```

---

## Testing Pattern

```tsx
import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { describe, it, expect, vi } from 'vitest'
import { Button } from './Button'

describe('Button', () => {
  it('renders with default props', () => {
    render(<Button>Click me</Button>)
    expect(screen.getByRole('button')).toHaveTextContent('Click me')
  })

  it('applies variant styles', () => {
    render(<Button variant="primary">Click</Button>)
    expect(screen.getByRole('button')).toHaveClass('bg-blue-600')
  })

  it('applies size styles', () => {
    render(<Button size="lg">Click</Button>)
    expect(screen.getByRole('button')).toHaveClass('px-6')
  })

  it('handles click events', async () => {
    const user = userEvent.setup()
    const onClick = vi.fn()
    
    render(<Button onClick={onClick}>Click</Button>)
    await user.click(screen.getByRole('button'))
    
    expect(onClick).toHaveBeenCalledOnce()
  })

  it('can be disabled', () => {
    render(<Button disabled>Click</Button>)
    expect(screen.getByRole('button')).toBeDisabled()
  })

  it('merges custom className', () => {
    render(<Button className="custom-class">Click</Button>)
    expect(screen.getByRole('button')).toHaveClass('custom-class')
  })
})
```

---

## Interactive States

Always implement all interactive states from the design:

```tsx
<button className={cn(
  // Default state
  "bg-blue-600 text-white",
  
  // Hover state
  "hover:bg-blue-700",
  
  // Focus state (keyboard navigation)
  "focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2",
  
  // Active state (pressed)
  "active:bg-blue-800",
  
  // Disabled state
  "disabled:opacity-50 disabled:cursor-not-allowed"
)}>
```

---

## Class Composition with cn()

Always use `cn()` (or clsx/classnames) for class merging:

```tsx
import { cn } from '@/lib/utils'

// ✅ Correct - allows className override
className={cn('base-styles', variant && 'variant-styles', className)}

// ❌ Wrong - template literal doesn't merge properly
className={`base-styles ${className}`}
```

### The cn() Utility

```tsx
// lib/utils.ts
import { clsx, type ClassValue } from 'clsx'
import { twMerge } from 'tailwind-merge'

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}
```

---

## Component Checklist

### Before Building
- [ ] **Confirmed no existing component can be reused**
- [ ] Got Figma screenshot (if from design)
- [ ] Got design context (if from design)
- [ ] Planned component structure (props, variants)

### Structure
- [ ] Component in correct directory (`src/components/[type]/`)
- [ ] TypeScript interface defined for props
- [ ] Props extend appropriate HTML attributes
- [ ] Uses `cn()` for class composition
- [ ] Allows `className` override

### Styling
- [ ] All interactive states implemented (hover, focus, active, disabled)
- [ ] Uses project tokens (if design system configured)
- [ ] Responsive behavior handled

### Quality
- [ ] Tests written and passing
- [ ] Exported from component index.ts
- [ ] Added to parent index.ts
- [ ] No TypeScript errors

---

## See Also

- **figma-mcp skill** - Design extraction and token mapping
- **references/CHECKLIST.md** - Detailed validation checklist
- **references/PATTERNS.md** - Extended code patterns


