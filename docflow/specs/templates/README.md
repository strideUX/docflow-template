# Spec Templates

This folder contains templates for creating new specs. Each template has inline agent instructions to ensure consistent, high-quality documentation.

## Available Templates

### 📋 feature.md - Feature Specs
**Use for:** New functionality, enhancements, user-facing changes

**When to use:**
- Building a new feature or capability
- Enhancing existing functionality
- User-requested improvements
- Product roadmap items

**What's included:**
- Complete workflow sections (Planning → Implementation → Review → QE)
- User story format
- Detailed acceptance criteria
- Technical planning sections
- Implementation tracking
- Code review checklist
- QE testing validation

**Template structure:** Comprehensive with all workflow phases

---

### 🐛 bug.md - Bug Reports
**Use for:** Defects, errors, broken functionality

**When to use:**
- Something that should work but doesn't
- Error messages or crashes
- Incorrect behavior
- Performance issues
- User-reported problems

**What's included:**
- Reproduction steps
- Expected vs. actual behavior
- Root cause analysis section
- Fix approach planning
- Regression testing checklist
- Prevention recommendations

**Template structure:** Bug-specific workflow from report to verification

---

### 💡 idea.md - Quick Idea Capture
**Use for:** Brainstorming, future possibilities, rough concepts

**When to use:**
- Quick idea that needs capturing
- "What if we..." moments
- Future enhancements
- Exploratory concepts
- Unvalidated opportunities

**What's included:**
- Lightweight brain dump format
- Value assessment
- Questions to answer
- Research checklist
- Path to refinement into feature spec

**Template structure:** Minimal - just enough to capture and evaluate

---

## How to Use These Templates

### 1. Choose the Right Template
- **Feature**: Well-defined work that adds/changes functionality
- **Bug**: Something is broken and needs fixing
- **Idea**: Rough concept that needs validation/refinement

### 2. Copy to Backlog
```bash
# Example: Creating a new feature spec
cp docflow/specs/templates/feature.md docflow/specs/backlog/feature-user-dashboard.md
```

### 3. Fill Out the Template
- Follow the inline `<!-- AGENT INSTRUCTIONS -->` comments
- Fill all sections marked with `[brackets]`
- Don't remove sections - mark as "N/A" if not applicable
- Update metadata (Status, Owner, Priority, Complexity, Dates)
- **Set Complexity**: S (few hours), M (1-2 days), L (3-5 days), XL (1 week)
- **If XL or larger**: Break into smaller specs instead

### 4. Activate When Ready
Use `/start-session` command to move from backlog to active when ready to implement.

---

## Template Structure Explained

All templates follow a consistent structure:

### Planning Phase (Top of spec)
- **Metadata**: Status, ownership, priority, dates
- **Context**: Why this work exists
- **Requirements**: What needs to be delivered
- **Technical Notes**: How to build it

### Execution Phase (Middle of spec)
- **Decision Log**: Track key decisions with dates
- **Implementation Notes**: Document as you build
- **Blockers**: Track what's preventing progress

### Validation Phase (Bottom of spec)
- **DocFlow Review**: AI code review checkpoint
- **QE Testing**: User validation and approval

---

## Agent Guidelines

### When Creating Specs:
1. **Always use inline instructions** - They're there to help you fill it out correctly
2. **Be specific** - Vague specs lead to unclear implementations
3. **Update as you go** - Specs are living documents during implementation
4. **Check off criteria** - Mark `[x]` as you complete acceptance criteria
5. **Document decisions** - Add to Decision Log with dates and rationale

### When Implementing Specs:
1. **Read the entire spec first** - Understand the full scope
2. **Fill Implementation Notes progressively** - Document as you work
3. **Update timestamps** - Change "Last Updated" when you modify the spec
4. **Create assets folder if needed** - `/docflow/specs/assets/[spec-name]/` for screenshots, etc.
5. **Don't skip sections** - Each section serves a purpose in the workflow

### When Reviewing Specs:
1. **Verify all acceptance criteria** - Each should be testable and verified
2. **Check for scope creep** - Implementation should match the plan
3. **Ensure documentation is complete** - Implementation Notes should tell the story
4. **Validate standards compliance** - Follow /docflow/context/standards.md

---

## Template Evolution

These templates will evolve based on real-world usage. If you find:
- **Missing sections** → Add them
- **Confusing instructions** → Clarify them
- **Unused sections** → Consider removing them
- **Better patterns** → Update templates

**Template updates flow:**
1. Refine in live project
2. Extract improvements back to template
3. Apply to future specs

---

## Quick Reference

| Template | Purpose | Size | When to Use |
|----------|---------|------|-------------|
| `feature.md` | New functionality | Comprehensive | Planned development work |
| `bug.md` | Fix defects | Focused | Something is broken |
| `idea.md` | Capture concepts | Lightweight | Brainstorming, future work |

**Remember:** Templates are guides, not straitjackets. Adapt as needed, but maintain consistency across your project.

