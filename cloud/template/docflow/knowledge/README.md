# Knowledge Base

This directory contains project knowledge that accumulates over time.

## Structure

```
knowledge/
├── INDEX.md      # Start here - inventory of all knowledge
├── decisions/    # Architecture Decision Records (ADRs)
├── features/     # Complex feature documentation
├── notes/        # Technical discoveries and learnings
└── product/      # User research and product docs
```

## When to Add Knowledge

### Decisions (`decisions/`)
Add an ADR when you make a significant technical choice:
- Choosing a framework or library
- Designing a system architecture
- Establishing a pattern that others should follow

**Format**: `NNN-title.md` (e.g., `001-use-convex.md`)

### Features (`features/`)
Add feature documentation when:
- A feature is too complex for just a spec
- Multiple specs relate to one system
- Future developers will need deep context

**Format**: `feature-name.md` (e.g., `auth-system.md`)

### Notes (`notes/`)
Add notes when you discover:
- API quirks or gotchas
- Performance optimizations
- Debugging techniques
- Third-party service behaviors

**Format**: `topic-name.md` (e.g., `stripe-webhooks.md`)

### Product (`product/`)
Add product docs for:
- User personas
- User flows and journeys
- Research findings
- Product requirements

**Format**: `document-name.md` (e.g., `personas.md`)

## Always Update INDEX.md

When adding any knowledge document, update `INDEX.md` so agents can discover it.

## Relationship to Specs

- **Specs** (in Linear) = What we're building now
- **Knowledge** (here) = What we've learned that persists

Specs reference knowledge. Knowledge grows from implementing specs.

