# DocFlow Scan (Analysis & Recommendations)

## Purpose
Analyze existing project and provide actionable recommendations for documentation gaps, spec opportunities, and DocFlow health.

**This is a read-only analysis command.** It reviews the current state and suggests actions but makes no file changes.

**Agent Role:** PM/Planning Agent  
**Frequency:** On-demand (can run anytime for health checks)

---

## When to Trigger

### Automatic Detection
Run when:
- User says "scan this project", "analyze codebase", "review documentation"
- User asks "what's missing", "documentation gaps", "what should I capture"
- User wants a DocFlow health check

---

## Analysis Flow

### Phase 1: Project Detection (30 sec)

**Identify project type:**
1. Check package management (package.json, requirements.txt, Gemfile, etc.)
2. Identify framework and language
3. Scan directory structure
4. Count source files and estimate size
5. Check git status (if available)

**Output:**
```
📊 Project Scan Starting...

**Project Type:** [Framework] [Language]
**Size:** [N] source files
**Structure:** [Directory layout summary]
```

---

### Phase 2: DocFlow State Detection (1 min)

**Check for DocFlow presence:**

**Scenario A: No DocFlow Found**
- No `/docflow/` folder exists
- **Recommendation:** Run `/docflow-upgrade` to install DocFlow 2.1

**Scenario B: DocFlow 1.x Detected**
- Has `/docflow/` but old structure detected:
  - `shared/` folder exists (removed in 2.1)
  - `reference/` folder exists (removed in 2.1)
  - `dependencies.md` exists (removed in 2.1)
  - `.templates` folder exists (renamed in 2.1)
  - Specs missing Complexity field (added in 2.1)
- **Recommendation:** Run `/docflow-upgrade` to migrate to version 2.1

**Scenario C: DocFlow 2.1 Present**
- Has correct folder structure
- Context files exist
- Templates folder present
- **Continue to health check**

**Scenario D: Other Spec System**
- Found specs in non-standard location
- Different format/structure
- **Recommendation:** Run `/docflow-upgrade` to migrate to DocFlow 2.1

**Scenario E: Broken/Incomplete DocFlow**
- Folder exists but missing key files
- Context files are still templates/placeholders
- Empty or corrupted structure
- **Recommendation:** Run `/docflow-upgrade` to repair

---

### Phase 3: Codebase Analysis (3-8 min)

**Systematically analyze code:**

**Entry Points:**
- Main files (index, app, main)
- Route definitions
- API endpoints

**Feature Discovery:**
- Scan by directory/module
- Identify user-facing features
- Note internal systems (auth, data, integrations)
- Map component hierarchy (if UI app)

**Architecture & Patterns:**
- State management approach
- Data layer patterns
- API/backend integration
- Authentication/authorization
- Real-time features (if any)

**Dependencies & Integrations:**
- External services
- Third-party libraries
- Database/ORM
- Deployment setup

**Progress updates:**
- "Analyzing authentication system..."
- "Found 12 API routes..."
- "Detected real-time features using [X]..."

---

### Phase 4: DocFlow Comparison (2-3 min)

**If DocFlow exists, check for drift:**

**Context Files vs Code:**
- Does `stack.md` match actual stack?
- Does `overview.md` reflect current vision?
- Do `standards.md` match code patterns?

**Specs vs Features:**
- Which features exist in code but not documented?
- Which specs are marked incomplete but code looks done?
- Which specs are outdated or abandoned?

**Knowledge Base:**
- Are complex features documented in knowledge/?
- Are architectural decisions captured?
- Are technical gotchas noted?

---

### Phase 5: Gap Analysis

**Undocumented Features:**
```
📝 Features Found in Code (not in specs):
1. [Feature name] - [Brief description]
   Location: [File paths]
   Complexity: [Estimate S/M/L]
   
2. [Feature name] - [Brief description]
   ...

**Suggestion:** Create completed specs in /docflow/specs/complete/[quarter]/
to document these for future reference.
```

**Missing Context:**
```
⚠️ Context Gaps:
- stack.md says [X] but code uses [Y]
- overview.md missing [important aspect]
- standards.md doesn't mention [pattern used everywhere]

**Suggestion:** Update context files to match current reality.
```

**Knowledge Opportunities:**
```
💡 Capture Opportunities:
- Complex feature: [Name] could be documented in knowledge/features/
- Architectural decision: [Decision] should be in knowledge/decisions/
- Technical gotcha: [Issue] worth noting in knowledge/notes/
- User flow: [Flow] could be mapped in knowledge/product/

**Suggestion:** Document these to help future work.
```

**Incomplete Specs:**
```
🔄 Specs Needing Attention:
- feature-X.md (status=IMPLEMENTING, last updated 2 weeks ago)
- feature-Y.md (status=READY, code looks complete)

**Suggestion:** Review and update status or complete implementation.
```

**Stale Work:**
```
🗑️ Potentially Stale:
- chore-Z.md (ACTIVE for 3 months)
- idea-Q.md (no updates, may no longer be relevant)

**Suggestion:** Review and close or update.
```

---

### Phase 6: Health Score (if DocFlow 2.1 exists)

**Calculate health metrics:**

```
📊 DocFlow Health Score: [X]/100

✅ Structure: [score]/25
   - Correct folder layout
   - Templates present
   - Platform adapters exist

✅ Context: [score]/25
   - Context files filled and current
   - Matches actual codebase
   - Standards documented

✅ Specs: [score]/25
   - Active work tracked
   - Completed work documented
   - No stale specs

✅ Knowledge: [score]/25
   - Decisions captured
   - Complex features documented
   - Technical notes present
```

---

### Phase 7: Final Report & Recommendations

**Provide comprehensive analysis:**

```
📊 DocFlow Scan Complete!

**Project:** [Name]
**Type:** [Framework] [Language]
**DocFlow Version:** [None / 1.x / 2.1 / Other]
**Health Score:** [X]/100 (if 2.1 exists)

---

## Summary

**What You Have:**
- [N] features in codebase
- [N] documented in specs (if DocFlow exists)
- [Tech stack summary]

**What's Missing:**
- [N] undocumented features
- [N] context gaps
- [N] knowledge capture opportunities

---

## Recommended Actions

### Immediate (Do Now):
1. [Most important action based on state]
   - If no DocFlow: `/docflow-upgrade` to install
   - If old version: `/docflow-upgrade` to migrate
   - If healthy: Capture [specific gap]

### Soon (This Week):
2. [Second priority]
3. [Third priority]

### Ongoing (As You Work):
- Document features as you build (/capture)
- Note decisions in knowledge/decisions/
- Keep context files current

---

## Next Steps

[Specific command or action to take]
```

---

## Key Principles

### Read-Only Analysis
- **Never write files** - only analyze and recommend
- User decides what actions to take
- Safe to run anytime without risk

### Actionable Output
- Specific recommendations, not vague suggestions
- Clear priority order
- Exact commands/actions to take next

### Works for Any Project
- Projects without DocFlow
- Projects with old DocFlow
- Projects with DocFlow 2.1 (health check)
- Projects with other systems

### Honest Assessment
- Show gaps objectively
- Don't critique during scan
- Focus on opportunities, not failures

### Efficient Discovery
- Focus on main features and patterns
- Don't read every file
- Use search and sampling

---

## Tools to Use

- `list_dir` - Map directory structure
- `read_file` - Read configs, key files, specs
- `grep` - Search for patterns
- `codebase_search` - Find implementations by meaning
- `glob_file_search` - Find files by type
- `run_terminal_cmd` - Git commands (read-only, like git log)

---

## Output Format

Always end with:
1. **Summary** (what was found)
2. **Gaps** (what's missing)
3. **Health score** (if DocFlow 2.1 exists)
4. **Recommended actions** (ordered by priority)
5. **Next step** (specific command or action)

---

## Detection Patterns for DocFlow Versions

### DocFlow 1.x Indicators:
- `/docflow/shared/` exists
- `/docflow/reference/` exists
- `/docflow/dependencies.md` exists
- `.templates` folder (hidden)
- Specs have `Estimated Time` field
- No `knowledge/` folder
- No `specs/assets/` folder
- No `AGENTS.md` in root
- No `.claude/` or `.github/` folders

### DocFlow 2.1 Indicators:
- `/docflow/templates/` exists (not hidden)
- `/docflow/knowledge/` with subfolders
- `/docflow/specs/assets/` exists
- Specs have `Complexity` field (S/M/L/XL)
- `AGENTS.md` in root
- Platform adapters (`.claude/`, `.github/`)
- No `shared/`, `reference/`, `dependencies.md`

---

## Example Scans

### Healthy Project with DocFlow 2.1:
```
📊 Health Score: 92/100

Structure ✅ 25/25
Context ✅ 23/25 (stack.md slightly outdated)
Specs ✅ 22/25 (2 stale chores)
Knowledge ✅ 22/25 (missing some decisions)

**Recommended Actions:**
1. Update stack.md to reflect new caching strategy
2. Close or update 2 stale chores
3. Document authentication decision in knowledge/decisions/
```

### Project with No DocFlow:
```
**DocFlow:** Not installed

**What I Found:**
- Next.js 14 app with App Router
- 23 features implemented
- Convex backend, Clerk auth
- Well-structured codebase

**Recommended Actions:**
1. Run `/docflow-upgrade` to install DocFlow 2.1
   - I'll document your 23 existing features
   - Fill context from your stack
   - Set up knowledge base
   - Create backlog for planned work

Ready when you are!
```

### Project with DocFlow 1.x:
```
**DocFlow:** Version 1.x detected

**Issues Found:**
- Using old folder structure (shared/, reference/)
- Specs missing Complexity field
- No knowledge base
- Missing platform adapters

**Recommended Actions:**
1. Run `/docflow-upgrade` to migrate to 2.1
   - Preserves all your specs and history
   - Migrates to new structure
   - Adds knowledge base
   - Converts metadata format

This is non-destructive (old version archived).
```

---

## Checklist

- [ ] Project type detected
- [ ] DocFlow state identified
- [ ] Codebase analyzed
- [ ] Features discovered
- [ ] Gaps identified
- [ ] Health score calculated (if applicable)
- [ ] Specific recommendations provided
- [ ] Next action clear
- [ ] No files written (read-only)
