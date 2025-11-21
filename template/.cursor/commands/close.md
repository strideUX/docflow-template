# Close (PM/Planning Agent)

## Overview
Archive a completed, approved spec and queue next work.

**Agent Role:** PM/Planning Agent (orchestrator)  
**Frequency:** After user approves QE testing

**This completes the workflow cycle.**

---

## Steps

### 1. **Verify Spec is Approved**
Check that:
- Spec has status=QE_TESTING
- QE Testing section shows user approval
- OR user is explicitly saying to close it

**If not approved yet:**
- Don't close
- Tell user: "This spec is still in [status]. Needs QE approval first."
- Suggest running `/validate [spec]` if in REVIEW

### 2. **Final Updates to Spec**
Before archiving:
- Verify QE Testing section is filled out
- Add final Decision Log entry:
```markdown
### YYYY-MM-DD - Completed and Approved
**Decision:** Spec completed and approved by user
**Outcome:** [Brief summary of what was delivered]
**QE Status:** Passed - ready for production
```

### 3. **Move to Archive**
**Efficient file movement:**
- Determine quarter folder: YYYY-QQ (e.g., 2024-Q4)
- Create folder if doesn't exist: /docflow/specs/complete/YYYY-QQ/
- Use terminal mv command:
  ```bash
  mv /docflow/specs/active/[spec-name].md /docflow/specs/complete/YYYY-QQ/[spec-name].md
  ```
- Verify file moved successfully
- Single operation, one approval

**Set final metadata:**
```markdown
**Status**: COMPLETE
**Owner**: DocFlow
**Completed**: YYYY-MM-DD
```

### 4. **Handle Spec Assets** (if they exist)
Check if /docflow/specs/assets/[spec-name]/ exists:
- Ask user: "Keep assets or clean up?"
- If keep: Leave them for reference
- If clean up: Delete the folder
- Note decision in spec

### 5. **Update Tracking Files**
**Update /docflow/ACTIVE.md:**
- Remove from Primary/Secondary focus
- Update Last Updated timestamp

**Update /docflow/INDEX.md:**
- Remove from Active section
- Add to Completed section with date:
```markdown
## Completed
- [YYYY-MM-DD] [spec-name] - [brief description]
```

### 6. **Check for Next Work**
Look at /docflow/INDEX.md backlog:
- Identify next priority
- Suggest: "Ready to review [next-spec]?" or "What's next?"

### 7. **Confirmation**
"🎉 [Spec name] completed and archived!

**Archived to:** /docflow/specs/complete/YYYY-QQ/  
**Completed:** YYYY-MM-DD  
**Impact:** [Brief summary of what was delivered]

**Next Priorities:**
1. [spec-name] - [ready to activate / needs review]
2. [spec-name]

What would you like to work on next?"

---

## Context to Load
- Spec from /docflow/specs/active/ (to archive)
- /docflow/ACTIVE.md (to update)
- /docflow/INDEX.md (to update and show next)

---

## Natural Language Triggers
User might say:
- "close [spec]" / "archive [spec]"
- "mark complete" / "this is done"
- "finalize [spec]"

**Run this command when detected.**

---

## Outputs
- Spec moved to complete/YYYY-QQ/
- Tracking files updated
- Next priorities shown
- Celebration of completion 🎉

---

## Checklist
- [ ] Verified spec is approved (status=QE_TESTING)
- [ ] Added final Decision Log entry
- [ ] Moved file atomically to complete/YYYY-QQ/
- [ ] Set final metadata (COMPLETE, completed date)
- [ ] Handled spec assets (keep or delete)
- [ ] Updated ACTIVE.md
- [ ] Updated INDEX.md
- [ ] Identified next priorities
- [ ] Provided completion confirmation

