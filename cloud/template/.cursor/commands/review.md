# Review (PM/Planning Agent)

Code review for completed implementations.

## Steps

1. **Find Issues** - Query Linear for "In Review" state
2. **Load Context** - Issue, comments, standards.md
3. **Analyze Code** - Check changed files, verify patterns
4. **Verify Criteria** - All checkboxes complete, tests written
5. **Decide**:
   - Approved → Move to "QA", add approval comment
   - Issues Found → Move to "In Progress", add feedback

## Context to Load

- Linear issue (description + comments)
- `{paths.content}/context/standards.md`
- Changed files (from completion comment)

## Natural Language Triggers

- "review [issue]" / "code review" / "check the implementation"

## Full Rules

See `.docflow/rules/pm-agent.md`
