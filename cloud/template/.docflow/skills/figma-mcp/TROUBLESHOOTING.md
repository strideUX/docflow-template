# Figma MCP Troubleshooting

Common issues and fixes.

## Output Doesn't Match Figma

**Symptoms:** Colors, spacing, or layout differ from design.

**Fixes:**
1. Re-run `get_screenshot` for fresh visual reference
2. Check token mapping is correct (if design system configured)
3. Verify all spacing and sizing values translated
4. Compare interactive states (hover, focus)

## Missing Styles

**Symptoms:** Some styles missing from output.

**Fixes:**
1. Run `get_variable_defs` to extract specific tokens
2. Check if style is in a parent node
3. Verify node selection is correct in Figma URL

## Incomplete Response

**Symptoms:** Output is truncated or missing sections.

**Fixes:**
1. Selection is too large → break it down
2. Run `get_metadata` first to understand structure
3. Target smaller, specific nodes

## Assets Not Loading

**Symptoms:** Images don't appear or show broken links.

**Fixes:**
1. Verify Figma desktop app is running (for local MCP)
2. Check localhost URLs are being used correctly
3. Assets should be at `http://127.0.0.1:3845/assets/...`
4. Don't use placeholders - use actual asset URLs

## Slow Responses

**Symptoms:** Tool calls taking very long or timing out.

**Fixes:**
1. Reduce selection size
2. Target specific components instead of full pages
3. Use `get_metadata` to identify specific nodes first

## Wrong Node Selected

**Symptoms:** Getting design for wrong component.

**Fixes:**
1. Verify nodeId from Figma URL (format: `123:456` or `123-456`)
2. Use `get_metadata` to see node structure
3. Check you're using correct fileKey

## Extracting Figma URL Components

Figma URL format:
```
https://www.figma.com/file/{fileKey}/{fileName}?node-id={nodeId}
```

- `fileKey` - The file identifier (e.g., `yAln8XH1UxkgKaFuJspT6d`)
- `nodeId` - The specific frame/component, URL decoded (e.g., `123:456` or `123-456`)

## Red Flags in Code

If you see these patterns, STOP and fix:

```tsx
// ❌ Hardcoded colors (when tokens exist)
className="bg-[#026aa2] text-[#414651]"

// ❌ Inline font styles
style={{ fontFamily: "'Inter', sans-serif" }}

// ❌ Raw Figma variables (not translated)
className="px-[var(--spacing-lg,12px)]"

// ❌ Placeholder images
<img src="/placeholder.svg" />

// ❌ Icon library imports (unless project allows)
import { ChevronRight } from 'lucide-react'
```

## Pre-Implementation Checklist

### Before Starting
- [ ] Have Figma URL with node ID
- [ ] Know the file key
- [ ] Figma desktop app running (if using local MCP)

### During Implementation
- [ ] Got `get_screenshot` for visual reference
- [ ] Got `get_design_context` output
- [ ] Created specification table
- [ ] Downloaded actual assets (no placeholders)
- [ ] Reused existing components where possible

### After Implementation
- [ ] Visual comparison to Figma screenshot passes
- [ ] All interactive states work
- [ ] Follows project token conventions (if design system configured)
- [ ] Tests written and passing


