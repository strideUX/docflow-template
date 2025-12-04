# Spec Assets

This folder contains spec-specific resources like screenshots, reference images, code snippets, and other materials needed during implementation.

## Organization

Assets are organized by spec name:
```
assets/
├── feature-dashboard/
│   ├── mockup.png
│   └── reference-layout.jpg
├── bug-login-error/
│   └── error-screenshot.png
└── feature-sprint-planning/
    └── capacity-algorithm.txt
```

## Usage

1. **When creating a spec** that needs visual/reference materials:
   - Create folder: `assets/[spec-name]/`
   - Add files with descriptive names
   - Reference in spec: "See specs/assets/[spec-name]/file.png"

2. **When completing a spec**:
   - Assets can be archived with the spec or deleted if no longer needed
   - Keep assets if they provide historical context

## What Goes Here

✅ Screenshots for bug reports  
✅ UI mockups and reference designs  
✅ API response examples  
✅ Code snippets to replicate  
✅ Test data files

❌ Project-wide documentation (use `/knowledge/` instead)  
❌ Reusable templates (use `/specs/templates/` instead)

