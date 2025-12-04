# DocFlow Update (System)

## Overview
Check for and apply updates to DocFlow rules and commands from the source repository.

**Agent Role:** System command  
**Frequency:** When user wants to update DocFlow

---

## Steps

### 1. **Read Current Version**

Read `.docflow.json`:
```json
{
  "docflow": {
    "version": "3.0.0",
    "sourceRepo": "github.com/org/docflow",
    "lastUpdated": "2025-01-15T10:30:00Z"
  }
}
```

### 2. **Check Source Repository**

Use DocFlow Update MCP (or direct API):
```typescript
// Check latest release from source repo
const latest = await checkLatestVersion(sourceRepo);
// Returns: { version: "3.1.0", changelog: "...", files: [...] }
```

### 3. **Compare Versions**

```markdown
## 🔄 DocFlow Update Check

**Current Version:** 3.0.0
**Latest Version:** 3.1.0
**Source:** github.com/org/docflow

### What's New in 3.1.0:
- Added Figma MCP integration guidance
- Improved Linear status mapping
- Fixed command trigger detection
- New `/docflow-setup` wizard

### Files That Would Update:
- `.cursor/rules/docflow.mdc`
- `.cursor/commands/*.md` (8 files)
- `AGENTS.md`

Would you like to update? (yes/no)
```

### 4. **Apply Update (If Approved)**

Download and overwrite files:
```typescript
// Files to update from source repo
const filesToUpdate = [
  '.cursor/rules/docflow.mdc',
  '.cursor/commands/start-session.md',
  '.cursor/commands/capture.md',
  '.cursor/commands/implement.md',
  '.cursor/commands/validate.md',
  '.cursor/commands/activate.md',
  '.cursor/commands/close.md',
  '.cursor/commands/review.md',
  '.cursor/commands/block.md',
  '.cursor/commands/status.md',
  '.cursor/commands/wrap-session.md',
  '.cursor/commands/docflow-update.md',
  'AGENTS.md'
];

// Download each file from source repo at specified version
for (const file of filesToUpdate) {
  const content = await downloadFile(sourceRepo, version, file);
  await writeFile(file, content);
}
```

### 5. **Update Config**

```typescript
// Update .docflow.json
config.docflow.version = newVersion;
config.docflow.lastUpdated = new Date().toISOString();
await writeFile('.docflow.json', JSON.stringify(config, null, 2));
```

### 6. **Confirmation**

```markdown
✅ DocFlow Updated to 3.1.0!

**Updated Files:**
- `.cursor/rules/docflow.mdc`
- `.cursor/commands/*.md` (8 files)
- `AGENTS.md`
- `.docflow.json`

**Changelog:**
- Added Figma MCP integration guidance
- Improved Linear status mapping
- Fixed command trigger detection

The new rules are now active. No restart needed.
```

---

## Version Pinning

If `.docflow.json` has pinned version:
```json
{
  "docflow": {
    "version": "^3.0",  // Accept 3.x updates
    // or
    "version": "3.0.0"  // Pinned, no auto-update
  }
}
```

Handle accordingly:
```markdown
⚠️ Version Pinned

Your project is pinned to version 3.0.0.
Latest available: 3.1.0

To update:
1. Change version in .docflow.json to "3.1.0" or "^3.0"
2. Run `/docflow-update` again

Or update now with: `/docflow-update --force`
```

---

## Already Up to Date

```markdown
✅ DocFlow is up to date!

**Current Version:** 3.1.0
**Source:** github.com/org/docflow
**Last Checked:** Just now

No updates available.
```

---

## Context to Load
- `.docflow.json` (current version)
- DocFlow Update MCP (or GitHub API)

---

## Natural Language Triggers
User might say:
- "update docflow" / "check for updates"
- "get latest docflow"
- "sync docflow rules"

**Run this command when detected.**

---

## Outputs
- Version comparison shown
- Changelog displayed
- Files updated (if approved)
- Config version bumped
- Confirmation provided

---

## Checklist
- [ ] Read current version from config
- [ ] Checked source repo for latest
- [ ] Compared versions
- [ ] Showed changelog
- [ ] Listed files to update
- [ ] Got user approval
- [ ] Downloaded and applied files
- [ ] Updated config version
- [ ] Confirmed completion

