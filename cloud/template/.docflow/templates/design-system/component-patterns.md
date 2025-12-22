# Component Patterns

Document your project's reusable components and patterns.

> **Instructions:** Fill this file with your existing components.
> Reference these before creating new components.

---

## Available Components

### Buttons

| Component | Import | Usage |
|-----------|--------|-------|
| `Button` | `@/components/buttons/Button` | Primary, secondary, ghost variants |
| | | |

#### Button Usage

```tsx
import { Button } from '@/components/buttons'

// Primary (default)
<Button variant="primary" size="md">Get started</Button>

// Secondary
<Button variant="secondary" size="md">Learn more</Button>

// Full width
<Button variant="primary" className="w-full">Submit</Button>
```

---

### Cards

| Component | Import | Usage |
|-----------|--------|-------|
| | | |

---

### Forms

| Component | Import | Usage |
|-----------|--------|-------|
| | | |

---

### Navigation

| Component | Import | Usage |
|-----------|--------|-------|
| | | |

---

### Sections

| Component | Import | Usage |
|-----------|--------|-------|
| | | |

---

## Component Rules

### DO
- Use existing components before creating new ones
- Extend existing components via props/className
- Follow established patterns

### DON'T
- Write inline button styles when Button exists
- Duplicate component code
- Create new components without checking existing ones

---

## Red Flags

```tsx
// ❌ Inline button styling when Button component exists
<button className="bg-blue-600 text-white px-4 py-2 rounded-md">

// ✅ Use the Button component
<Button variant="primary">Submit</Button>
```


