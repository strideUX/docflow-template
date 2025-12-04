#!/bin/bash
# DocFlow Installer
# Version: 2.1
# 
# Usage: 
#   curl -sSL https://raw.githubusercontent.com/strideUX/docflow-template/main/docflow-install.sh | bash
#
# Or download and run locally:
#   curl -sSL https://raw.githubusercontent.com/strideUX/docflow-template/main/docflow-install.sh > docflow-install.sh
#   chmod +x docflow-install.sh
#   ./docflow-install.sh

set -e

DOCFLOW_VERSION="2.1"
REPO_URL="https://github.com/strideUX/docflow-template"
RAW_BASE="https://raw.githubusercontent.com/strideUX/docflow-template/main/template"

echo ""
echo "╔════════════════════════════════════════════════╗"
echo "║     DocFlow ${DOCFLOW_VERSION} Installer                    ║"
echo "╚════════════════════════════════════════════════╝"
echo ""

# Detect project state
detect_state() {
  if [ -d "docflow" ] && [ -f ".cursor/rules/docflow.mdc" ]; then
    echo "existing-docflow"
  elif [ -f "package.json" ] || [ -f "requirements.txt" ] || [ -f "go.mod" ] || [ -f "Cargo.toml" ] || [ -d "src" ] || [ -d "app" ]; then
    echo "existing-code"
  else
    echo "new-project"
  fi
}

STATE=$(detect_state)

echo "📊 Project Detection:"
case $STATE in
  "new-project")
    echo "   Status: New project (empty directory)"
    echo "   Setup: Will install fresh DocFlow system"
    ;;
  "existing-code")
    echo "   Status: Existing code detected"
    echo "   Setup: Will retrofit DocFlow to existing project"
    ;;
  "existing-docflow")
    echo "   Status: DocFlow already installed"
    echo "   Setup: Will upgrade to version ${DOCFLOW_VERSION}"
    ;;
esac
echo ""

# Confirm
read -p "Continue with installation? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Installation cancelled."
  exit 0
fi
echo ""

# Download function
download_file() {
  local source="$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  
  if command -v curl &> /dev/null; then
    curl -sSL "${RAW_BASE}/${source}" -o "$dest" 2>/dev/null || {
      echo "❌ Failed to download: $source"
      return 1
    }
  elif command -v wget &> /dev/null; then
    wget -q "${RAW_BASE}/${source}" -O "$dest" 2>/dev/null || {
      echo "❌ Failed to download: $source"
      return 1
    }
  else
    echo "❌ Error: curl or wget required"
    exit 1
  fi
}

echo "⬇️  Downloading DocFlow system files..."
echo ""

# Core system files - Rules
echo "   [1/5] Installing rules and commands..."
mkdir -p .cursor/rules .cursor/commands

download_file ".cursor/rules/docflow.mdc" ".cursor/rules/docflow.mdc"

# Commands (12 total)
download_file ".cursor/commands/start-session.md" ".cursor/commands/start-session.md"
download_file ".cursor/commands/wrap-session.md" ".cursor/commands/wrap-session.md"
download_file ".cursor/commands/capture.md" ".cursor/commands/capture.md"
download_file ".cursor/commands/review.md" ".cursor/commands/review.md"
download_file ".cursor/commands/activate.md" ".cursor/commands/activate.md"
download_file ".cursor/commands/implement.md" ".cursor/commands/implement.md"
download_file ".cursor/commands/validate.md" ".cursor/commands/validate.md"
download_file ".cursor/commands/close.md" ".cursor/commands/close.md"
download_file ".cursor/commands/block.md" ".cursor/commands/block.md"
download_file ".cursor/commands/status.md" ".cursor/commands/status.md"
download_file ".cursor/commands/docflow-setup.md" ".cursor/commands/docflow-setup.md"

# Platform adapters
echo "   [2/5] Installing platform adapters..."
mkdir -p .claude/commands .warp .github
download_file ".claude/rules.md" ".claude/rules.md"
download_file ".warp/rules.md" ".warp/rules.md"
download_file ".github/copilot-instructions.md" ".github/copilot-instructions.md"
download_file "AGENTS.md" "AGENTS.md"
download_file "WARP.md" "WARP.md"

# Create Claude command symlinks (for Claude Code CLI)
echo "   Creating Claude command symlinks..."
cd .claude/commands
for cmd in start-session wrap-session capture review activate implement validate close block status docflow-setup; do
  ln -sf "../../.cursor/commands/${cmd}.md" "${cmd}.md" 2>/dev/null || true
done
cd ../..  # Return to project root

# DocFlow structure
echo "   [3/5] Creating DocFlow directory structure..."
mkdir -p docflow/context
mkdir -p docflow/specs/{templates,active,backlog,complete,assets}
mkdir -p docflow/knowledge/{decisions,features,notes,product}

# Spec templates
echo "   [4/5] Installing spec templates..."
download_file "docflow/specs/templates/feature.md" "docflow/specs/templates/feature.md"
download_file "docflow/specs/templates/bug.md" "docflow/specs/templates/bug.md"
download_file "docflow/specs/templates/chore.md" "docflow/specs/templates/chore.md"
download_file "docflow/specs/templates/idea.md" "docflow/specs/templates/idea.md"
download_file "docflow/specs/templates/README.md" "docflow/specs/templates/README.md"

# Core DocFlow files (only if they don't exist - preserve user's content)
echo "   [5/5] Installing documentation..."
[ ! -f "docflow/ACTIVE.md" ] && download_file "docflow/ACTIVE.md" "docflow/ACTIVE.md"
[ ! -f "docflow/INDEX.md" ] && download_file "docflow/INDEX.md" "docflow/INDEX.md"
[ ! -f "docflow/README.md" ] && download_file "docflow/README.md" "docflow/README.md"

# Context templates (only if don't exist)
[ ! -f "docflow/context/overview.md" ] && download_file "docflow/context/overview.md" "docflow/context/overview.md"
[ ! -f "docflow/context/stack.md" ] && download_file "docflow/context/stack.md" "docflow/context/stack.md"
[ ! -f "docflow/context/standards.md" ] && download_file "docflow/context/standards.md" "docflow/context/standards.md"

# Knowledge base files
download_file "docflow/knowledge/INDEX.md" "docflow/knowledge/INDEX.md"
download_file "docflow/knowledge/README.md" "docflow/knowledge/README.md"
download_file "docflow/knowledge/product/personas.md" "docflow/knowledge/product/personas.md"
download_file "docflow/knowledge/product/user-flows.md" "docflow/knowledge/product/user-flows.md"

# Add install script to .gitignore
if [ ! -f ".gitignore" ]; then
  touch .gitignore
fi

if ! grep -q "^docflow-install\.sh$" .gitignore 2>/dev/null; then
  echo "docflow-install.sh" >> .gitignore
  echo ""
  echo "   [Added docflow-install.sh to .gitignore]"
fi

echo ""
echo "✅ Installation complete!"
echo ""
echo "╔════════════════════════════════════════════════╗"
echo "║              INSTALLATION SUMMARY              ║"
echo "╚════════════════════════════════════════════════╝"
echo ""
echo "📦 Installed DocFlow ${DOCFLOW_VERSION}"
echo ""
echo "📁 System Files:"
echo "   ✓ Rules and commands (.cursor/)"
echo "   ✓ Platform adapters:"
echo "      - Claude Desktop/Code (.claude/, .claude/commands/)"
echo "      - Warp (.warp/, WARP.md)"
echo "      - GitHub Copilot (.github/)"
echo "      - Universal (AGENTS.md)"
echo "   ✓ Spec templates (4 types)"
echo "   ✓ Knowledge base structure"
echo ""

if [ "$STATE" == "existing-docflow" ]; then
  echo "🔄 Upgraded from previous version"
  echo "   Your content has been preserved"
  echo ""
fi

echo "╔════════════════════════════════════════════════╗"
echo "║                  NEXT STEP                     ║"
echo "╚════════════════════════════════════════════════╝"
echo ""
echo "   Open your AI tool (Cursor, Claude, etc.) and run:"
echo ""
echo "   /docflow-setup"
echo ""
echo "   The agent will complete setup based on your"
echo "   project type (new, existing, or upgrade)."
echo ""
echo "📖 Documentation: ${REPO_URL}"
echo ""

