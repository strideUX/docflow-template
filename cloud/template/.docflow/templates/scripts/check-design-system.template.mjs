/**
 * Design System Validation Script
 * 
 * Scans source files for design system violations.
 * Configurable forbidden/allowed patterns.
 * 
 * Usage: node scripts/check-design-system.mjs
 * 
 * Configure by editing the FORBIDDEN_PATTERNS and ALLOWED_PATTERNS arrays.
 */

import fs from 'node:fs'
import path from 'node:path'

const ROOT = process.cwd()
const SRC_DIR = path.join(ROOT, 'src')

const FILE_EXTENSIONS = new Set(['.ts', '.tsx', '.css', '.jsx', '.js'])

/**
 * Forbidden patterns - these will cause validation to fail
 * 
 * Customize based on your design system:
 * - Add patterns for hardcoded values you want to catch
 * - Remove patterns that don't apply to your framework
 */
const FORBIDDEN_PATTERNS = [
  {
    name: 'Hardcoded spacing arbitrary values (p-/m-/gap-[..px])',
    regex: /\b(p|px|py|pt|pb|pl|pr|m|mx|my|mt|mb|ml|mr|gap)-\[[0-9.]+px\]/g,
  },
  {
    name: 'Hardcoded radius arbitrary values (rounded-[..px])',
    regex: /\brounded-\[[0-9.]+px\]/g,
  },
  {
    name: 'Hardcoded hex colors (#fff/#ffffff)',
    regex: /#[0-9a-fA-F]{3,8}/g,
  },
  {
    name: 'Hardcoded rgba() colors',
    regex: /rgba\(/g,
  },
]

/**
 * Allowed patterns - these are exceptions that won't be flagged
 * 
 * Common exceptions:
 * - Layout/intrinsic sizing (w-[Xpx], h-[Xpx], max-w-[Xpx])
 * - Specific one-off values that are documented
 */
const ALLOWED_PATTERNS = [
  // Layout/intrinsic sizing whitelist
  /\b(max-w|min-w|w|h|max-h|min-h)-\[[0-9.]+px\]/g,
  // Thin borders
  /\bborder-\[0\.5px\]/g,
]

/**
 * Paths to skip during validation
 * 
 * Add paths that should not be checked:
 * - Style definition files
 * - Mocks and test utilities
 * - Generated files
 */
const SKIP_PATH_FRAGMENTS = [
  `${path.sep}src${path.sep}styles${path.sep}`,
  `${path.sep}src${path.sep}mocks${path.sep}`,
  `${path.sep}src${path.sep}test${path.sep}`,
  `${path.sep}CLAUDE.md`,
  `${path.sep}node_modules${path.sep}`,
]

function shouldSkipFile(filePath) {
  return SKIP_PATH_FRAGMENTS.some((frag) => filePath.includes(frag))
}

function listFilesRecursive(dirPath) {
  const results = []

  if (!fs.existsSync(dirPath)) {
    return results
  }

  const entries = fs.readdirSync(dirPath, { withFileTypes: true })
  for (const entry of entries) {
    const fullPath = path.join(dirPath, entry.name)
    if (entry.isDirectory()) {
      results.push(...listFilesRecursive(fullPath))
      continue
    }

    const ext = path.extname(entry.name)
    if (FILE_EXTENSIONS.has(ext)) {
      results.push(fullPath)
    }
  }

  return results
}

function maskAllowed(text) {
  let masked = text
  for (const allowed of ALLOWED_PATTERNS) {
    masked = masked.replaceAll(allowed, '')
  }
  return masked
}

function findMatches(content, regex) {
  const matches = []

  const re = new RegExp(regex.source, regex.flags)
  let m
  while ((m = re.exec(content)) !== null) {
    matches.push({ index: m.index, match: m[0] })
  }

  return matches
}

function getLineInfo(content, index) {
  const upToIndex = content.slice(0, index)
  const line = upToIndex.split('\n').length
  const lineStart = upToIndex.lastIndexOf('\n') + 1
  const lineEnd = content.indexOf('\n', index)
  const end = lineEnd === -1 ? content.length : lineEnd
  const lineText = content.slice(lineStart, end)
  return { line, lineText }
}

function main() {
  if (!fs.existsSync(SRC_DIR)) {
    console.error('Cannot find src/ directory to scan.')
    process.exit(2)
  }

  const files = listFilesRecursive(SRC_DIR).filter((f) => !shouldSkipFile(f))

  const violations = []

  for (const filePath of files) {
    const raw = fs.readFileSync(filePath, 'utf8')
    const content = maskAllowed(raw)

    for (const rule of FORBIDDEN_PATTERNS) {
      const matches = findMatches(content, rule.regex)
      for (const match of matches) {
        const { line, lineText } = getLineInfo(raw, match.index)
        violations.push({
          file: path.relative(ROOT, filePath),
          line,
          rule: rule.name,
          snippet: lineText.trim(),
        })
      }
    }
  }

  if (violations.length === 0) {
    console.log('✅ Design system check passed.')
    return
  }

  console.error(`❌ Design system check failed: ${violations.length} violation(s) found.\n`)
  for (const v of violations) {
    console.error(`  ${v.file}:${v.line}`)
    console.error(`    Rule: ${v.rule}`)
    console.error(`    Code: ${v.snippet}\n`)
  }

  process.exit(1)
}

main()

