# Code Standards

<!--
AGENT INSTRUCTIONS:
- Reference this when implementing ANY feature
- Follow these standards strictly
- If you need to deviate, document in Decision Log
- After updating, run /sync-project to update Linear project description
-->

## TypeScript Standards

### Strict Mode
- Always use `strict: true` in tsconfig
- No `any` types - use `unknown` with type guards
- Explicit return types on exported functions

### Type Definitions
```typescript
// ✅ Good: Use interfaces for objects
interface User {
  id: string;
  name: string;
  email: string;
}

// ✅ Good: Use types for unions/primitives
type Status = 'pending' | 'active' | 'complete';
type UserId = string;

// ❌ Bad: Avoid any
const data: any = fetchData(); // Never do this
```

### Naming Conventions
| Type | Convention | Example |
|------|------------|---------|
| Files/directories | kebab-case | `user-profile.tsx` |
| Components/Classes | PascalCase | `UserProfile` |
| Functions/variables | camelCase | `getUserById` |
| Constants | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT` |
| Types/Interfaces | PascalCase | `UserProfile` |

---

## React/Component Standards

### Component Structure
```typescript
// ✅ Good: Clear, typed props
interface ButtonProps {
  label: string;
  onClick: () => void;
  variant?: 'primary' | 'secondary';
  disabled?: boolean;
}

export function Button({ 
  label, 
  onClick, 
  variant = 'primary',
  disabled = false 
}: ButtonProps) {
  return (
    <button
      className={cn(styles.button, styles[variant])}
      onClick={onClick}
      disabled={disabled}
    >
      {label}
    </button>
  );
}
```

### Hook Patterns
```typescript
// ✅ Good: Custom hook with clear return type
function useUser(id: string): {
  user: User | null;
  isLoading: boolean;
  error: Error | null;
} {
  // Implementation
}

// ✅ Good: Stable references with useCallback
const handleSubmit = useCallback((data: FormData) => {
  // Handle submission
}, [dependency]);
```

### State Management
- Prefer local state when possible
- Use context for truly global state
- External store (Zustand/Redux) for complex state

---

## File Organization

### Co-location
- Keep related files close together
- Component + styles + tests in same directory
- Feature-based organization over type-based

```
features/
├── auth/
│   ├── components/
│   │   ├── LoginForm.tsx
│   │   ├── LoginForm.test.tsx
│   │   └── LoginForm.module.css
│   ├── hooks/
│   │   └── useAuth.ts
│   └── index.ts
```

### Imports
- Use absolute imports with aliases
- Group imports: external → internal → relative
- No circular dependencies

```typescript
// External
import { useState } from 'react';
import { clsx } from 'clsx';

// Internal (absolute)
import { Button } from '@/components/ui';
import { useUser } from '@/hooks';

// Relative (same feature)
import { FormField } from './FormField';
```

---

## Error Handling

### Validation at Boundaries
```typescript
// ✅ Good: Validate external data
import { z } from 'zod';

const UserSchema = z.object({
  id: z.string(),
  email: z.string().email(),
});

function processUser(data: unknown) {
  const user = UserSchema.parse(data);
  // Now safely typed
}
```

### Error Messages
- User-facing: Helpful, actionable
- Developer-facing: Detailed, debuggable
- Never expose internal errors to users

---

## Testing Standards

### Test Organization
```typescript
describe('UserService', () => {
  describe('getUser', () => {
    it('returns user when found', async () => {
      // Arrange
      const userId = 'user-123';
      
      // Act
      const result = await getUser(userId);
      
      // Assert
      expect(result).toMatchObject({ id: userId });
    });

    it('throws NotFoundError when user missing', async () => {
      // Test error case
    });
  });
});
```

### What to Test
- Business logic: Always
- UI components: Key interactions
- Integration: Critical paths
- E2E: Happy paths + critical failures

---

## Git Conventions

### Commit Messages
```
type(scope): description

[optional body]

[optional footer]
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

### Branch Naming
- `feature/short-description`
- `fix/issue-number-description`
- `chore/description`

---

## Code Review Checklist

Before submitting:
- [ ] Types are correct and complete
- [ ] No `any` types
- [ ] Error handling in place
- [ ] Tests for new functionality
- [ ] No console.logs left
- [ ] Follows naming conventions
- [ ] No unused imports/variables
- [ ] Accessibility considered

---

## Accessibility Standards

- All interactive elements keyboard accessible
- Proper heading hierarchy
- ARIA labels where needed
- Color contrast meets WCAG AA
- Focus indicators visible

---

*Last Updated: YYYY-MM-DD*

