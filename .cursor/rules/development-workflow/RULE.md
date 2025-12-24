# DocFlow Template Development Workflow

> **Glob:** `**/*`
> **Always Apply:** true

## Purpose

This rule ensures consistent development practices when building features for the DocFlow template project itself.

---

## MANDATORY: Feature Development Checklist

When implementing new features or changes to DocFlow Cloud, ALWAYS follow these steps in order:

### 1. Version Update

- [ ] Increment version in `.docflow/version` (currently in `cloud/template/.docflow/version`)
- [ ] Use semantic versioning: MAJOR.MINOR.PATCH
  - **MAJOR**: Breaking changes
  - **MINOR**: New features (backwards compatible)
  - **PATCH**: Bug fixes, documentation

### 2. Manifest Update

- [ ] Update `manifest.json` version to match
- [ ] Add new files to `files.tree` section
- [ ] Add new directories to `owned_directories` if applicable
- [ ] Update `merged_files` if adding new config keys to preserve

### 3. Migration File

- [ ] Create `migrations/{version}.json` with:
  ```json
  {
    "version": "X.Y.Z",
    "date": "YYYY-MM-DD",
    "description": "Brief description of changes",
    "changes": {
      "features": [...],
      "improvements": [...]
    },
    "files_added": [...],
    "files_modified": [...],
    "config_changes": {...},
    "upgrade_notes": [...],
    "breaking_changes": [...]
  }
  ```

### 4. README Update

- [ ] Update version in README header
- [ ] Update version reference in file structure diagram
- [ ] Add "What's New in vX.Y" section at the top of Key Features
- [ ] Move previous version's "What's New" to normal Key Features section
- [ ] Update file structure diagram to show new files/folders
- [ ] Update footer version

### 5. Template Files

If the feature adds new files to the template:

- [ ] Add files to `cloud/template/` in correct location
- [ ] Ensure proper structure for Cursor rules (use `RULE.md` in folders)
- [ ] Update any command files that reference new features

---

## File Structure Reference

```
docflow-template/
├── cloud/
│   ├── manifest.json          ← UPDATE: version + file tree
│   ├── README.md              ← UPDATE: version refs + what's new
│   └── template/
│       └── .docflow/
│           ├── version        ← UPDATE: increment version
│           ├── config.json    ← ADD: new config keys
│           ├── rules/         ← ADD: new rule files
│           ├── scripts/       ← ADD: new shell scripts
│           ├── skills/        ← ADD: new skill folders
│           └── templates/     ← ADD: new template files
└── migrations/
    └── X.Y.Z.json             ← CREATE: migration file
```

---

## Verification Before Committing

Run through this checklist:

1. **Version consistency**: All version references match (version file, manifest, README header, README footer, README structure diagram)
2. **Migration completeness**: Migration file lists all added/modified files
3. **Manifest accuracy**: All new files appear in manifest file tree
4. **README current**: What's New section describes the feature clearly

---

## Example Commit Message

```
feat(cloud): add workflow consistency enforcement (v4.5.0)

- Add AI Labor Estimate skill for token/cost sizing
- Add always.md with deterministic rules and comment templates
- Add shell scripts for atomic workflow operations
- Restructure agent rules with numbered checklists

Migration: migrations/4.5.0.json
```

---

*This rule applies to the docflow-template repository itself, not to projects using DocFlow.*

