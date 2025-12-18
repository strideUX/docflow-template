# DocFlow Update (System)

## Overview
Check for and apply updates to DocFlow rules and commands from the GitHub source repository.

**Agent Role:** System command  
**Frequency:** When user wants to update DocFlow

**No separate MCP required** - uses GitHub raw files directly.

---

## Steps

### 1. **Read Current Version**

Read `.docflow/config.json` or `.docflow/version` and extract current version:

```bash
cat .docflow/version
# or
cat .docflow/config.json | grep '"version"' | head -1
```

Expected: `"version": "3.0.0"` or just `3.0.0`

### 2. **Check Latest Release from GitHub**

Query GitHub API for latest release:

```bash
curl -s https://api.github.com/repos/strideUX/docflow-template/releases/latest | grep '"tag_name"'
```

Or if no releases yet, check the main branch and compare to known version.

**Parse the response** to get the latest version tag (e.g., `v3.1.0`).

### 3. **Compare Versions**

Compare current version to latest:
- If same: "DocFlow is up to date!"
- If different: Show what's new and offer to update

**Present to user:**
```markdown
## 🔄 DocFlow Update Check

**Current Version:** 3.0.0
**Latest Version:** 3.1.0
**Source:** github.com/strideUX/docflow-template

### What's New in 3.1.0:
[Changelog from release notes, or list of changes]

### Files That Will Update:
- `.docflow/config.json` (version only, preserves settings)
- `.docflow/version`
- `.docflow/templates/*.md` (5 template files)
- `.cursor/rules/docflow.mdc`
- `.cursor/commands/*.md` (15+ command files)
- `AGENTS.md`
- `WARP.md`
- `.warp/rules.md`
- `.claude/rules.md`
- `.github/copilot-instructions.md`

Would you like to update? (yes/no)
```

### 4. **Download and Apply Updates (If Approved)**

**Set the version tag:**
```bash
VERSION="v3.1.0"  # or "main" for latest
BASE_URL="https://raw.githubusercontent.com/strideUX/docflow-template/${VERSION}/cloud/template"
```

**Download each file:**

```bash
# Rules
curl -sSL "${BASE_URL}/.cursor/rules/docflow.mdc" -o ".cursor/rules/docflow.mdc"

# Commands (12 files)
curl -sSL "${BASE_URL}/.cursor/commands/start-session.md" -o ".cursor/commands/start-session.md"
curl -sSL "${BASE_URL}/.cursor/commands/wrap-session.md" -o ".cursor/commands/wrap-session.md"
curl -sSL "${BASE_URL}/.cursor/commands/capture.md" -o ".cursor/commands/capture.md"
curl -sSL "${BASE_URL}/.cursor/commands/review.md" -o ".cursor/commands/review.md"
curl -sSL "${BASE_URL}/.cursor/commands/activate.md" -o ".cursor/commands/activate.md"
curl -sSL "${BASE_URL}/.cursor/commands/implement.md" -o ".cursor/commands/implement.md"
curl -sSL "${BASE_URL}/.cursor/commands/validate.md" -o ".cursor/commands/validate.md"
curl -sSL "${BASE_URL}/.cursor/commands/close.md" -o ".cursor/commands/close.md"
curl -sSL "${BASE_URL}/.cursor/commands/block.md" -o ".cursor/commands/block.md"
curl -sSL "${BASE_URL}/.cursor/commands/status.md" -o ".cursor/commands/status.md"
curl -sSL "${BASE_URL}/.cursor/commands/docflow-setup.md" -o ".cursor/commands/docflow-setup.md"
curl -sSL "${BASE_URL}/.cursor/commands/docflow-update.md" -o ".cursor/commands/docflow-update.md"

# Platform adapters
curl -sSL "${BASE_URL}/AGENTS.md" -o "AGENTS.md"
curl -sSL "${BASE_URL}/WARP.md" -o "WARP.md"
curl -sSL "${BASE_URL}/.warp/rules.md" -o ".warp/rules.md"
curl -sSL "${BASE_URL}/.claude/rules.md" -o ".claude/rules.md"
curl -sSL "${BASE_URL}/.github/copilot-instructions.md" -o ".github/copilot-instructions.md"
```

**Run these commands** using the terminal tool. Execute them in a batch for efficiency.

### 5. **Update Configuration**

After downloading files, update `.docflow/version` and `.docflow/config.json`:

```bash
# Update version file
echo "3.1.0" > .docflow/version
```

Update `.docflow/config.json` version field:
```json
{
  "version": "3.1.0",
  ...
}
```

Use search_replace to update the version field (preserve other settings).

### 6. **Recreate Claude Command Symlinks**

```bash
mkdir -p .claude/commands
cd .claude/commands
for cmd in start-session wrap-session capture review activate implement validate close block status docflow-setup docflow-update; do
  ln -sf "../../.cursor/commands/${cmd}.md" "${cmd}.md" 2>/dev/null || true
done
cd ../..
```

### 7. **Confirmation**

```markdown
✅ DocFlow Updated to 3.1.0!

**Updated Files:**
- `.docflow/version` ✓
- `.docflow/templates/*.md` (5 files) ✓
- `.cursor/rules/docflow.mdc` ✓
- `.cursor/commands/*.md` (15+ files) ✓
- `AGENTS.md` ✓
- `WARP.md` ✓
- Platform adapters ✓

**Configuration:**
- `.docflow/config.json` version updated ✓

The new rules are now active. No restart needed.

**What's New:**
- [List key changes from this version]
```

---

## Already Up to Date

If versions match:

```markdown
✅ DocFlow is up to date!

**Current Version:** 3.1.0
**Source:** github.com/strideUX/docflow-template
**Last Updated:** 2025-12-04

No updates available.
```

---

## Version Pinning

Check if `.docflow/config.json` has a pinned version:

```json
{
  "version": "3.0.0",        // Specific version - respect unless --force
  "allowUpdates": true       // If false, warn user
}
```

**If pinned and user wants update:**
```markdown
⚠️ Version Pinned

Your project is pinned to version 3.0.0.
Latest available: 3.1.0

To update anyway, say "update anyway" or "force update".
```

---

## Offline / Network Error Handling

If curl fails:
```markdown
❌ Unable to check for updates

**Error:** Could not reach GitHub

This might be because:
- No internet connection
- GitHub is down
- Firewall blocking access

You can try again later or manually download from:
https://github.com/strideUX/docflow-template
```

---

## Manual Update Alternative

If automated update fails, provide manual instructions:

```markdown
## Manual Update Instructions

1. Visit: https://github.com/strideUX/docflow-template/releases
2. Download the latest release
3. Copy these folders to your project:
   - `cloud/template/.docflow/templates/` → `.docflow/templates/`
   - `cloud/template/.docflow/version` → `.docflow/version`
   - `cloud/template/.cursor/` → `.cursor/`
   - `cloud/template/AGENTS.md` → `AGENTS.md`
   - `cloud/template/WARP.md` → `WARP.md`
4. Update `.docflow/config.json` version number
```

---

## Context to Load
- `.docflow/config.json` (current version and settings)
- `.docflow/version` (version file)
- Network access for GitHub API/raw files

---

## Natural Language Triggers
User might say:
- "update docflow" / "check for updates"
- "get latest docflow" / "upgrade docflow"
- "sync docflow rules" / "refresh docflow"
- "is docflow up to date"

**Run this command when detected.**

---

## Outputs
- Version comparison shown
- Files downloaded and updated
- Config version bumped
- Confirmation provided

---

## Full Update Script (One-Shot)

For convenience, here's the complete update as a single script the agent can run:

```bash
#!/bin/bash
# DocFlow Update Script

VERSION="${1:-main}"  # Use provided version or default to main
BASE_URL="https://raw.githubusercontent.com/strideUX/docflow-template/${VERSION}/cloud/template"

echo "Updating DocFlow from ${VERSION}..."

# Create directories if needed
mkdir -p .docflow/templates .cursor/rules .cursor/commands .claude/commands .warp .github

# Download .docflow/ framework files
curl -sSL "${BASE_URL}/.docflow/version" -o ".docflow/version"
for template in README feature bug chore idea quick-capture; do
  curl -sSL "${BASE_URL}/.docflow/templates/${template}.md" -o ".docflow/templates/${template}.md"
done

# Download rules
curl -sSL "${BASE_URL}/.cursor/rules/docflow.mdc" -o ".cursor/rules/docflow.mdc"

# Download commands
for cmd in start-session wrap-session capture refine review activate implement validate close block status docflow-setup docflow-update sync-project project-update attach; do
  curl -sSL "${BASE_URL}/.cursor/commands/${cmd}.md" -o ".cursor/commands/${cmd}.md"
done

# Download platform adapters
curl -sSL "${BASE_URL}/AGENTS.md" -o "AGENTS.md"
curl -sSL "${BASE_URL}/WARP.md" -o "WARP.md"
curl -sSL "${BASE_URL}/.warp/rules.md" -o ".warp/rules.md"
curl -sSL "${BASE_URL}/.claude/rules.md" -o ".claude/rules.md"
curl -sSL "${BASE_URL}/.github/copilot-instructions.md" -o ".github/copilot-instructions.md"

# Recreate Claude symlinks
cd .claude/commands
for cmd in start-session wrap-session capture refine review activate implement validate close block status docflow-setup docflow-update sync-project project-update attach; do
  ln -sf "../../.cursor/commands/${cmd}.md" "${cmd}.md" 2>/dev/null || true
done
cd ../..

echo "✅ DocFlow updated to ${VERSION}"
```

The agent can run this script with the terminal tool, or execute the commands individually.

---

## Checklist
- [ ] Read current version from .docflow/config.json or .docflow/version
- [ ] Checked GitHub for latest version
- [ ] Compared versions
- [ ] Showed changelog/what's new
- [ ] Got user approval (if update available)
- [ ] Downloaded all files via curl (including .docflow/templates/)
- [ ] Updated .docflow/version file
- [ ] Updated .docflow/config.json version field
- [ ] Recreated Claude symlinks
- [ ] Confirmed completion
