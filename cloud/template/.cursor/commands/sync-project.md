# Sync Project (PM/Planning Agent)

## Overview
Synchronize the Linear project description with local context files. Generates a concise summary from `docflow/context/` and updates the Linear project.

**Agent Role:** PM/Planning Agent  
**Frequency:** After updating context files, during setup, or on-demand

---

## When to Run

- **During `/docflow-setup`** - Part of initial project configuration
- **After updating context files** - Keep Linear in sync
- **On-demand** - Manually refresh project description

---

## Source of Truth

```
docflow/context/
├── overview.md   ──► Project vision, goals, scope
├── stack.md      ──► Tech stack, architecture
└── standards.md  ──► Key conventions
         │
         ▼
    Generate Summary
         │
         ▼
Linear Project Description
```

**Local context files are the source of truth.** The Linear project description is a generated summary.

---

## Steps

### 1. **Read Context Files**

Load all three context files:
- `docflow/context/overview.md`
- `docflow/context/stack.md`
- `docflow/context/standards.md`

### 2. **Extract Key Information**

**From overview.md:**
- Project Name
- Vision (1-2 sentences)
- Key Goals (top 3)
- Current Phase

**From stack.md:**
- Core technologies (Frontend, Backend)
- Key dependencies

**From standards.md:**
- Top 3-5 conventions summary

### 3. **Generate Project Summary & Content**

Linear has two fields:
- **`description`** - Short summary shown in project list (255 char max)
- **`content`** - Full markdown shown on project page

**Short Summary (description):**
Extract the vision statement from overview.md (1-2 sentences, under 255 chars):
```
[Vision statement from overview.md]
```

**Full Content:**
```markdown
## [Project Name]

**Vision:** [1-2 sentence vision from overview.md]

**Phase:** [Current phase]

---

### Goals
1. [Goal 1]
2. [Goal 2]
3. [Goal 3]

---

### Tech Stack
- **Frontend:** [Framework, Language]
- **Backend:** [Runtime, Database]
- **Hosting:** [Platform]

---

### Key Standards
- [Convention 1]
- [Convention 2]
- [Convention 3]

---

📁 *Full details in `docflow/context/`*
🔄 *Last synced: [YYYY-MM-DD]*
```

### 4. **Get Project ID**

Read from `.docflow.json`:
```bash
cat .docflow.json | jq -r '.provider.projectId'
```

Or query Linear for current project.

### 5. **Update Linear Project**

Update both fields in a single call:

**Using Linear MCP:**
```typescript
updateProject(projectId, {
  description: shortSummary,  // 255 char max - shown in project list
  content: fullContent        // Full markdown - shown on project page
})
```

**Using GraphQL API (fallback):**
```bash
source .env

curl -s -X POST https://api.linear.app/graphql \
  -H "Authorization: $LINEAR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "mutation UpdateProject($id: String!, $description: String!, $content: String!) { projectUpdate(id: $id, input: { description: $description, content: $content }) { success project { id name } } }",
    "variables": {
      "id": "PROJECT_ID",
      "description": "SHORT_SUMMARY",
      "content": "FULL_CONTENT"
    }
  }'
```

### 6. **Confirmation**

```markdown
✅ Project synced!

**Project:** [Name]
**Updated:** Description synced from docflow/context/

**Summary includes:**
- Vision and goals from overview.md
- Tech stack from stack.md  
- Key standards from standards.md

[View in Linear](project-url)
```

---

## Example Output

For a Next.js todo app project:

**Short Summary (description - 255 char max):**
```
A simple, elegant todo app for testing DocFlow Cloud workflows.
```

**Full Content:**
```markdown
## ToDue

**Vision:** A simple, elegant todo app for testing DocFlow Cloud workflows.

**Phase:** Development

---

### Goals
1. Validate Linear integration
2. Test checkbox and comment workflows
3. Demonstrate full development cycle

---

### Tech Stack
- **Frontend:** Next.js 14, TypeScript, Tailwind CSS
- **Backend:** Convex (serverless)
- **Hosting:** Vercel

---

### Key Standards
- TypeScript strict mode, no `any` types
- Feature-based file organization
- Zod validation at boundaries
- Conventional commits

---

📁 *Full details in `docflow/context/`*
🔄 *Last synced: 2025-12-05*
```

---

## Integration with Setup

This command is called as part of `/docflow-setup` after context files are filled:

```
/docflow-setup
    ↓
Step 9: Fill context files
    ↓
Step 10: /sync-project (auto-called)
    ↓
Step 11: Create initial issues
    ↓
Setup complete!
```

---

## Context to Load
- `docflow/context/overview.md`
- `docflow/context/stack.md`
- `docflow/context/standards.md`
- `.docflow.json` (for project ID)
- `.env` (for API key if using curl)

---

## Natural Language Triggers
User might say:
- "sync project" / "update project description"
- "refresh linear from context"
- "sync context to linear"

**Run this command when detected.**

---

## Outputs
- Linear project description updated
- Summary generated from context files
- Sync timestamp recorded

---

## Checklist
- [ ] Read all three context files
- [ ] Extracted key information
- [ ] Generated formatted summary
- [ ] Got project ID from config
- [ ] Updated Linear project description
- [ ] Provided confirmation

