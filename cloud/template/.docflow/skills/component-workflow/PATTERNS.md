# Component Patterns

Standard patterns for building components.

## Base Component Template

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
        'flex flex-col',
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

## CVA Variants Pattern

```tsx
import { cva, type VariantProps } from 'class-variance-authority'
import { cn } from '@/lib/utils'

const buttonVariants = cva(
  [
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
  extends HTMLAttributes<HTMLButtonElement>,
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

## Compound Component Pattern

```tsx
const Card = ({ children, className, ...props }) => (
  <div className={cn('rounded-lg bg-white', className)} {...props}>
    {children}
  </div>
)

const CardHeader = ({ children, className, ...props }) => (
  <div className={cn('p-4 border-b border-gray-200', className)} {...props}>
    {children}
  </div>
)

const CardContent = ({ children, className, ...props }) => (
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

## Index File Pattern

```tsx
// src/components/buttons/index.ts
export { Button } from './Button'
export { ButtonLink } from './ButtonLink'
export type { ButtonProps } from './Button'

// src/components/index.ts
export * from './buttons'
export * from './cards'
export * from './forms'
```

## Test Pattern

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

  it('handles click events', async () => {
    const user = userEvent.setup()
    const onClick = vi.fn()
    
    render(<Button onClick={onClick}>Click</Button>)
    await user.click(screen.getByRole('button'))
    
    expect(onClick).toHaveBeenCalledOnce()
  })
})
```

## Common Mistakes

### Wrong

```tsx
// Hardcoded colors when tokens exist
className="bg-[#026aa2] px-4 py-2"

// Inline font styles
style={{ fontFamily: "'Inter', sans-serif" }}

// Not using cn() for merging
className={`base-styles ${className}`}

// Placeholder images
<img src="/placeholder.svg" />
```

### Correct

```tsx
// Use tokens or document values
className="bg-blue-600 px-4 py-2"

// Use font classes
className="font-sans"

// Proper merging with cn()
className={cn('base-styles', className)}

// Actual assets
<img src="/images/actual-image.png" />
```

