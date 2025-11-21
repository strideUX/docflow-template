# Knowledge Base

This directory contains project-wide knowledge that doesn't fit in the core context files but is essential for understanding how the application works.

## Structure

### `INDEX.md` - Knowledge Base Index
**Quick reference to all knowledge docs.** Scan this first (~500 tokens) to find what you need, then load selectively.

Agents should:
1. Read INDEX.md on every knowledge lookup
2. Use descriptions to assess relevance
3. Load only applicable docs
4. Never auto-load the entire knowledge base

### `/decisions/` - Architecture Decision Records (ADRs)
Key architectural and technical decisions with rationale.

**Format:** `NNN-decision-title.md` (numbered for easy reference)

**Example:**
- `001-why-convex.md` - Why we chose Convex over other databases
- `002-no-redux.md` - Why we're not using Redux

**Template:**
```markdown
# NNN: [Decision Title]

**Date:** YYYY-MM-DD
**Status:** Accepted | Superseded | Deprecated

## Context
[What situation led to this decision?]

## Decision
[What did we decide?]

## Consequences
**Positive:**
- [Benefit 1]

**Negative:**
- [Tradeoff 1]

## Alternatives Considered
- [Option that was rejected and why]
```

### `/features/` - Complex Feature Documentation
Deep technical explanations of how complex features work.

**When to create:**
- Feature is architecturally complex
- Future developers/agents will need to understand internals
- Implementation details don't fit in a spec

**Examples:**
- `sprint-capacity-calculation.md`
- `document-section-architecture.md`
- `real-time-sync-strategy.md`

### `/product/` - Product & UX Documentation
User context, personas, flows, and design guidelines.

**What goes here:**
- User personas and profiles
- User journey maps and flows
- Design system guidelines
- Accessibility requirements
- UX principles and patterns

**When to reference:**
- Creating user-facing features
- Planning UX improvements
- Understanding user context
- Ensuring feature alignment with user needs

### `/notes/` - Real-Time Discoveries
Quick notes, gotchas, workarounds, and discoveries made during development.

**What goes here:**
- API quirks discovered during implementation
- Library limitations and workarounds
- Common pitfalls to avoid
- Temporary notes that might become decisions later

**Examples:**
- `convex-gotchas.md`
- `blocknote-limitations.md`
- `deployment-checklist.md`

## When to Use Knowledge vs. Context

**Use `/context/`** for:
- Project vision and goals
- Tech stack and architectural patterns
- Code standards and conventions
- Stable, foundational information

**Use `/knowledge/`** for:
- Specific technical decisions
- How complex features work internally
- Discoveries made during development
- Information that emerges over time

## Maintenance

- **Keep it current** - Update when decisions change
- **Keep it concise** - Link to specs for implementation details
- **Keep it searchable** - Use clear filenames and headers
- **Archive rarely-used docs** - Move outdated notes to specs/complete/ if tied to old features

