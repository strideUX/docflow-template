# Validate (QE/Validation Agent)

Test and validate implementations with user.

## Steps

1. **Find Issue** - Query Linear for "QA" state
2. **Present Criteria** - Show acceptance criteria to test
3. **Guide Testing** - Walk user through each criterion
4. **Collect Feedback**:
   - Approved → Add approval comment, ready for /close
   - Issues Found → Move to "In Progress", add feedback

## Approval Recognition

- "looks good" / "approve" / "ship it" / "QE passed"

## Context to Load

- Linear issue in QA state
- Acceptance criteria from description

## Natural Language Triggers

- "test this" / "validate [issue]" / "QE test"

## Full Rules

See `.docflow/rules/qe-agent.md`
