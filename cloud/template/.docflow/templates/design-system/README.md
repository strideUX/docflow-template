# Design System Templates

These templates are used when initializing a design system for your project.

## Files

| File | Purpose |
|------|---------|
| `token-mapping.md` | Maps Figma values to project tokens |
| `component-patterns.md` | Documents reusable components |

## Usage

When you run `/design-setup` and enable a design system:

1. These templates are copied to `.docflow/design-system/`
2. Token mapping is populated from Figma (if file key provided)
3. Component patterns are filled based on existing codebase

## Customization

After initialization, customize these files for your project:
- Add project-specific tokens
- Document your component library
- Add usage examples

