# AI Agent Instructions

This project uses **DocFlow Cloud**, a spec-driven development workflow with Linear integration for task management.

---

## 📖 Primary Documentation

### You MUST Read These Files First:

1. **`.cursor/rules/docflow.mdc`** - Complete workflow rules (SOURCE OF TRUTH)
   - Three-agent orchestration model
   - Command system and natural language triggers
   - Context loading strategy
   - Linear integration patterns

2. **`docflow/context/`** - Project understanding
   - `overview.md` - Project vision and goals
   - `stack.md` - Tech stack and architecture
   - `standards.md` - Code conventions

3. **Linear** - Current work state
   - Check "In Progress" view for active work
   - Check "Backlog" for prioritized work
   - Issues contain full spec details

---

## 🎯 Quick Start for Agents

### Understand Your Role

**PM/Planning Agent:**
- Plan and refine work in Linear
- Activate specs (set priority, estimate, assignee, move to In Progress)
- Review and close completed work
- Post project updates (health status + summary)
- Commands: /start-session, /capture, /review, /activate, /close, /wrap-session, /project-update, /sync-project

**Implementation Agent:**
- Build features and fix bugs
- Read specs from Linear, update description checkboxes as work progresses
- Add progress comments for audit trail
- Attach reference files (knowledge docs, notes) to issues
- Commands: /implement, /block, /attach

**QE/Validation Agent:**
- Code review and user testing
- Iterate with user until approved
- Commands: /validate

### Check Current State
```
1. Query Linear for "In Progress" issues (know what's active)
2. Read docflow/context/ (understand project)
3. Load specific spec from Linear when implementing
```

### Load Context Situationally
**Don't auto-load everything!** See `.cursor/rules/docflow.mdc` for when to load:
- Planning: overview.md, Linear backlog
- Implementing: Linear spec, stack.md, standards.md
- Searching: Use codebase_search, then load what you find

**Knowledge base:** Scan `docflow/knowledge/INDEX.md` first, then load selectively.

---

## 📁 Directory Structure

```
project/
├── .cursor/
│   ├── rules/docflow.mdc    # Workflow rules (synced from source)
│   └── commands/            # Slash commands (synced from source)
│
├── docflow/
│   ├── context/             # Project understanding (LOCAL)
│   │   ├── overview.md      # Vision and goals
│   │   ├── stack.md         # Tech stack and patterns
│   │   └── standards.md     # Code conventions
│   │
│   ├── knowledge/           # Project knowledge (LOCAL)
│   │   ├── INDEX.md         # Knowledge inventory
│   │   ├── decisions/       # Architecture decisions (ADRs)
│   │   ├── features/        # Complex feature docs
│   │   ├── notes/           # Technical discoveries
│   │   └── product/         # Personas, user flows
│   │
│   └── README.md            # DocFlow usage guide
│
├── .docflow.json            # Config (version + Linear IDs)
└── AGENTS.md                # This file
```

### What's NOT Local (Lives in Linear)

- **Specs** → Linear issues
- **INDEX.md** → Linear issue list with filters
- **ACTIVE.md** → Linear "In Progress" view
- **Spec assets** → Linear attachments
- **Decision log** → Linear issue comments
- **Implementation notes** → Linear issue comments

---

## 🔧 Available Commands

Type `/` to see commands, or use natural language triggers.

**PM/Planning (8):**
- `/start-session` - Begin session, check Linear status
- `/wrap-session` - End session, update Linear, offer project update
- `/capture` - Create new Linear issue
- `/review [issue]` - Refine backlog item
- `/activate [issue]` - Ready for implementation
- `/close [issue]` - Move to Done
- `/project-update [project]` - Post project health + summary update
- `/sync-project` - Sync context files to Linear project description

**Implementation (3):**
- `/implement [issue]` - Pick up and build
- `/block` - Document blocker in Linear
- `/attach [file] [issue]` - Attach files (GitHub link or upload)

**QE/Validation (1):**
- `/validate [issue]` - Test and review

**All Agents (1):**
- `/status` - Check Linear state

**DocFlow System (2):**
- `/docflow-update` - Sync rules from source repo
- `/docflow-setup` - Configure Linear integration

---

## 🗣️ Natural Language Support

You don't need explicit commands. Recognize these phrases:

**Start session:** "let's start" / "what's next" / "where are we"
**Capture:** "capture that" / "add to backlog" / "found a bug"
**Implement:** "let's build [spec]" / "implement [spec]"
**Attach:** "attach [file]" / "link the doc" / "upload notes"
**Validate:** "test this" / "review implementation"
**Approve (during QE):** "looks good" / "approve" / "ship it"
**Project update:** "post project update" / "update project status"
**Sync project:** "sync project" / "update project description"

---

## 🔄 Workflow States (in Linear)

**Features & Bugs:**
```
Backlog → In Progress → In Review → QA → Done
```

**Chores & Ideas:**
```
Backlog → In Progress → Done
```

---

## 📊 Issue Metadata

### Priority Values
| Value | Name   | Use When                        |
|-------|--------|----------------------------------|
| 1     | Urgent | Drop everything                 |
| 2     | High   | Next up, important              |
| 3     | Medium | Normal priority (default)       |
| 4     | Low    | Nice to have                    |

### Estimate Values (Complexity)
| Value | Name | Rough Effort         |
|-------|------|----------------------|
| 1     | XS   | < 1 hour             |
| 2     | S    | 1-4 hours            |
| 3     | M    | Half day to full day |
| 4     | L    | 2-3 days             |
| 5     | XL   | Week+                |

### Acceptance Criteria as Checkboxes
Issue descriptions contain acceptance criteria as markdown checkboxes:
```markdown
## Acceptance Criteria
- [ ] First criterion (pending)
- [x] Second criterion (complete)
```

**During implementation:** Update checkboxes in-place as each criterion is completed. The issue description is the single source of truth.

### Comment Format
Use concise, consistent comments for audit trail:
```markdown
**Status** — Brief description.
```

Examples:
- `**Activated** — Assigned to Matt, Priority: High, Estimate: S.`
- `**Progress** — Completed data model, starting hooks.`
- `**Blocked** — Waiting on API access.`
- `**Ready for Review** — All criteria complete. Files: 4.`
- `**Complete** — Verified and closed.`

---

## 📎 Assets & Design

### Figma Integration
When a Linear issue has a Figma attachment:
1. Read issue → see Figma URL
2. Call Figma MCP: `get_design_context(fileKey, nodeId)`
3. Receive: colors, spacing, component structure, even code
4. Implement with actual design specs

### Screenshots & References
- Embedded in Linear issue description
- Attached to Linear issue
- Agent can read image URLs directly

---

## ⚠️ Critical Rules

### Never Create Local Spec Files
- ❌ NO specs in docflow/specs/ (doesn't exist anymore)
- ❌ NO INDEX.md or ACTIVE.md files
- ✅ ALL specs live in Linear

### Context Stays Local
- ✅ docflow/context/ stays in git
- ✅ docflow/knowledge/ stays in git
- These are version-controlled with code

### Update Linear, Not Files
- Status changes → Update Linear issue state
- Acceptance criteria → Update checkboxes in issue description
- Progress notes → Add Linear comment (`**Progress** — ...`)
- Decisions → Add dated Linear comment
- Blockers → Add comment (`**Blocked** — ...`)

### Document Decisions
- Spec-specific: In Linear issue comments (dated)
- Architectural: In docflow/knowledge/decisions/

---

## 🛠️ Linear API Access

### MCP-First, Curl Fallback

For all Linear operations:
1. **Try MCP first** - If Linear MCP is installed in Cursor, use it
2. **Fall back to curl** - If MCP unavailable, use direct GraphQL API

**MCP (when available):**
```typescript
linear_getTeams()
linear_createIssue({ teamId, title, description, ... })
linear_updateIssue(id, { stateId, ... })
```

**Curl fallback:**
```bash
source .env && curl -s -X POST https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: $LINEAR_API_KEY" \
  -d '{"query": "{ teams { nodes { id name } } }"}' | jq .
```

### Figma MCP (Optional)
If Figma MCP is installed:
- `get_design_context` - Get UI code and specs
- `get_screenshot` - Get visual reference
- `get_variable_defs` - Get design tokens

### MCP Setup
MCPs are installed in **Cursor Settings → Features → MCP**, not in the project.
See the cloud README for setup instructions.

---

## 📚 Additional Resources

- **docflow/README.md** - DocFlow usage in this project
- **docflow/knowledge/README.md** - Knowledge base guide
- **.cursor/rules/docflow.mdc** - Complete workflow rules

---

**The workflow is tool-agnostic. Linear is the first provider; others can be added.**

