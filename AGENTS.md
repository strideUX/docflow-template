# DocFlow Template - Agent Instructions

> This file provides guidance for AI agents working on the **DocFlow template repository itself**.

---

## Project Overview

This is the source repository for DocFlow, a spec-driven development workflow for AI-assisted coding. It contains:

- **Cloud version** (`cloud/`) — Hybrid workflow with Linear integration
- **Local version** (`local/`) — Fully local markdown-based workflow
- **Migrations** (`migrations/`) — Version upgrade metadata
- **Installer** (`docflow-install.sh`) — Unified installation script

---

## MANDATORY: Feature Development Workflow

When building new features or making changes to DocFlow Cloud, **ALWAYS** follow these steps:

### 1. Version Update
Update version in `cloud/template/.docflow/version`

### 2. Manifest Update
Update `cloud/manifest.json`:
- Bump `version` to match
- Add new files to `files.tree`
- Add new directories to `owned_directories` if needed
- Update `merged_files` for new config keys

### 3. Migration File
Create `migrations/{version}.json` with:
- `version`, `date`, `description`
- `changes.features` and `changes.improvements`
- `files_added`, `files_modified`
- `config_changes`, `upgrade_notes`, `breaking_changes`

### 4. README Updates
Update `cloud/README.md`:
- Version in header and footer
- File structure diagram
- "What's New" section
- Key Features section

Update `README.md` (root):
- Migration file list
- "What's New" section

### 5. Verification
Before committing, verify:
- [ ] All version references match
- [ ] Migration lists all changed files
- [ ] Manifest includes all new files
- [ ] READMEs describe the changes

---

## Rules Location

Cursor rules for this project: `.cursor/rules/development-workflow/RULE.md`

---

## Key Files

| File | Purpose |
|------|---------|
| `cloud/manifest.json` | File ownership definitions |
| `cloud/template/.docflow/version` | Current version |
| `migrations/*.json` | Version upgrade metadata |
| `cloud/README.md` | Cloud documentation |
| `docflow-install.sh` | Installation script |

---

## Architecture Notes

### Template Structure
Files in `cloud/template/` are copied to user projects during installation. The installer uses `manifest.json` to determine:
- Which files to overwrite (owned)
- Which files to preserve (user content)
- Which config keys to merge (config.json)

### Migration System
Migration files tell the installer what changed between versions, enabling:
- Cleanup of deprecated files
- Documentation of breaking changes
- User-facing upgrade notes

---

*Working on DocFlow? Follow the development workflow rule for consistent, well-documented changes.*

