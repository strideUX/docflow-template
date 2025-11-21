# Capture

## Overview
Quickly capture a new idea, feature, or bug to the backlog without context switching.

## Steps

1. **Identify Type**
   - Ask: "Is this a feature, bug, chore, or idea?"
   - Features: New functionality with user story
   - Bugs: Issues to fix
   - Chores: Maintenance, cleanup, refactoring, improvements
   - Ideas: Rough concepts for later

2. **Gather Context**
   - For Features: What user problem does this solve?
   - For Bugs: What's broken? How to reproduce?
   - For Chores: What needs cleaning up or improving?
   - For Ideas: What's the value proposition?

3. **Create Spec File**
   - Format: `feature-[name].md`, `bug-[name].md`, `chore-[name].md`, or `idea-[name].md`
   - Use kebab-case naming
   - Save in /docflow/specs/backlog/

4. **Write Minimal Spec**
   For features/bugs/chores:
   ```markdown
   # [Type]: [Name]

   ## Context
   [Quick description]

   ## User Story / Bug Description / Task List
   [As a... I want... OR When... Then... OR Task checklist]

   ## Acceptance Criteria / Completion Criteria
   - [ ] Key criteria

   ## Dependencies
   - Uses: [what it depends on]
   - Blocks: [what depends on this]

   ## Decision Log
   - [DATE]: Initial capture
   ```

   For ideas:
   ```markdown
   # Idea: [Name]

   ## Sketch
   [Brain dump - no structure required]

   ## Potential Value
   [Why this might be worth doing]

   ## Questions
   - [ ] Things to figure out
   ```

5. **Update INDEX.md**
   - Add to Backlog Priority section
   - Include brief description

## Confirmation
"Captured [type]: [name] to backlog. You can refine it later with /review."

**Note:** 
- Features/Bugs use full workflow (BACKLOG → READY → IMPLEMENTING → REVIEW → QE_TESTING → COMPLETE)
- Chores use simplified workflow (BACKLOG → ACTIVE → COMPLETE)
- Ideas stay lightweight until refined into another type

## Checklist
- [ ] Type identified (feature, bug, chore, or idea)
- [ ] Spec file created in backlog with correct template structure
- [ ] INDEX.md updated
- [ ] User can continue current work
