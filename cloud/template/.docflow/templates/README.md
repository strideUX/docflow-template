# Issue Templates

This folder contains templates for creating and refining Linear issues. Each template includes agent instructions to ensure consistent, high-quality issue structure.

## Template Usage

**Agents use these templates when:**
- Creating new issues via `/capture`
- Refining issues via `/refine`
- Triaging quick captures with `triage` label

**Humans use `quick-capture.md` in Linear** as the default template for fast idea/bug capture.

## Available Templates

| Template | Purpose | When to Use |
|----------|---------|-------------|
| `feature.md` | New functionality | Building something new with user story |
| `bug.md` | Fix defects | Something is broken |
| `chore.md` | Maintenance/cleanup | Refactoring, polish, improvements |
| `idea.md` | Capture concepts | Rough ideas for future exploration |
| `quick-capture.md` | Fast capture | Human entry in Linear (default template) |

## Agent Instructions

Each template contains `<!-- AGENT: ... -->` comments that guide the AI when filling out sections. These instructions are removed from the final issue in Linear.

**Key principles:**
1. Fill all `[bracketed]` sections with specific content
2. Don't remove sections - mark as "N/A" if not applicable
3. Be specific in acceptance criteria (testable, measurable)
4. Include context about "why" not just "what"
5. Reference project context from `{content-folder}/context/` when relevant

## Template Evolution

Update these templates as your workflow evolves:
- Add sections that are consistently needed
- Remove sections that are never used
- Improve agent instructions based on what works

Changes here apply to all future issues.



