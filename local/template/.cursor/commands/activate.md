# Activate (PM/Planning Agent)

## Overview
Ready a refined spec for implementation by moving it to active and assigning it.

**Agent Role:** PM/Planning Agent (orchestrator)  
**Frequency:** When backlog spec is refined and ready to build

**This is the handoff to Implementation Agent.**

---

## Steps

### 1. **Verify Spec is Ready**
Check the spec has:
- [ ] Clear context and problem statement
- [ ] Specific, testable acceptance criteria
- [ ] Technical approach documented
- [ ] Dependencies identified
- [ ] No obvious gaps or questions

If not ready, suggest running `/review [spec]` first.

### 2. **Check Assignment**
- Get current developer username:
  - Try: `git config github.user`
  - Fallback: `git config user.name`
  - If neither: use "Developer"
- Check spec's AssignedTo field
- If assigned to someone else, warn: "This spec is assigned to [user]. Continue anyway?"

### 3. **Move the Spec**
**Efficient file movement:**
- Use terminal mv command:
  ```bash
  mv /docflow/specs/backlog/[spec-name].md /docflow/specs/active/[spec-name].md
  ```
- Verify file exists in active/ after move
- Single operation, one approval

### 4. **Update Spec Metadata**
Set in the spec:
```markdown
**Status**: READY
**Owner**: Implementation
**AssignedTo**: @username
**Last Updated**: YYYY-MM-DD
```

### 5. **Update Tracking Files**
- Update /docflow/ACTIVE.md:
  - Add to Primary or Secondary focus
  - Note it's ready for implementation
- Update /docflow/INDEX.md:
  - Move from Backlog to Active section
  - Update status

### 6. **Confirmation**
"✅ [Spec name] activated and ready for implementation!

**Status**: READY  
**Assigned to**: @username  
**Priority**: [High/Medium/Low]

This spec is now queued for the Implementation agent.

When ready to build, the Implementation agent should run:
`/implement [spec-name]`

Or just say: \"let's work on [spec-name]\"
"

---

## Context to Load
- Spec from /docflow/specs/backlog/ (to verify readiness)
- /docflow/ACTIVE.md (to update)
- /docflow/INDEX.md (to update)

---

## Natural Language Triggers
User might say:
- "activate [spec]"
- "ready to build [spec]"
- "queue [spec] for implementation"
- "move [spec] to active"

**Run this command when detected.**

---

## Outputs
- Spec moved from backlog → active
- Status set to READY
- Developer assigned
- Tracking files updated
- Clear confirmation for user

---

## Checklist
- [ ] Spec completeness verified
- [ ] Developer username obtained
- [ ] Assignment checked (warn if conflict)
- [ ] File moved atomically (delete then create)
- [ ] Spec metadata updated
- [ ] ACTIVE.md updated
- [ ] INDEX.md updated
- [ ] Confirmation provided

