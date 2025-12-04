#!/bin/bash
# DocFlow Unified Installer
# Version: 3.0
# 
# Supports both Local and Cloud (Linear) installations
#
# Usage: 
#   curl -sSL https://raw.githubusercontent.com/strideUX/docflow-template/main/docflow-install.sh | bash
#
# Or download and run locally:
#   curl -sSL https://raw.githubusercontent.com/strideUX/docflow-template/main/docflow-install.sh > docflow-install.sh
#   chmod +x docflow-install.sh
#   ./docflow-install.sh

set -e

DOCFLOW_VERSION="3.0"
REPO_URL="https://github.com/strideUX/docflow-template"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo ""
echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}          ${GREEN}DocFlow ${DOCFLOW_VERSION} Unified Installer${NC}                   ${CYAN}║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# =====================================================
# STEP 1: Choose Installation Type
# =====================================================
echo -e "${YELLOW}📦 Choose Installation Type:${NC}"
echo ""
echo "   ${GREEN}1) Local${NC}  - All specs stored as local markdown files"
echo "            Best for: Solo developers, offline work"
echo ""
echo "   ${BLUE}2) Cloud${NC}  - Specs stored in Linear, context stays local"
echo "            Best for: Teams, collaboration, Cursor Background Agent"
echo ""
read -p "Select (1 or 2): " INSTALL_TYPE

if [[ "$INSTALL_TYPE" != "1" && "$INSTALL_TYPE" != "2" ]]; then
  echo -e "${RED}Invalid selection. Exiting.${NC}"
  exit 1
fi

if [ "$INSTALL_TYPE" == "1" ]; then
  MODE="local"
  RAW_BASE="https://raw.githubusercontent.com/strideUX/docflow-template/main/local/template"
  echo ""
  echo -e "${GREEN}✓ Local installation selected${NC}"
else
  MODE="cloud"
  RAW_BASE="https://raw.githubusercontent.com/strideUX/docflow-template/main/cloud/template"
  echo ""
  echo -e "${BLUE}✓ Cloud (Linear) installation selected${NC}"
fi

echo ""

# =====================================================
# STEP 2: Detect Project State
# =====================================================
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

echo -e "${YELLOW}📊 Project Detection:${NC}"
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
    echo "   Setup: Will upgrade to version ${DOCFLOW_VERSION} (${MODE})"
    ;;
esac
echo ""

# =====================================================
# STEP 3: Cloud Configuration (if cloud mode)
# =====================================================
LINEAR_TEAM_ID=""
LINEAR_API_KEY=""

if [ "$MODE" == "cloud" ]; then
  echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${BLUE}║${NC}              ${CYAN}Linear Configuration${NC}                          ${BLUE}║${NC}"
  echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
  echo ""
  echo "DocFlow Cloud requires a Linear workspace for task management."
  echo ""
  echo -e "${YELLOW}You'll need:${NC}"
  echo "  1. Linear API Key (from Linear Settings → API)"
  echo "  2. Team ID (from team URL or API)"
  echo ""
  echo -e "${CYAN}Don't have these yet?${NC}"
  echo "  - You can skip now and configure later in .docflow.json"
  echo "  - The /docflow-setup command will help you complete setup"
  echo ""
  
  read -p "Configure Linear now? (y/n): " CONFIGURE_LINEAR
  
  if [[ $CONFIGURE_LINEAR =~ ^[Yy]$ ]]; then
    echo ""
    echo -e "${CYAN}Enter your Linear API Key:${NC}"
    echo "(Get it from: Linear → Settings → API → Personal API Keys)"
    read -p "API Key (lin_api_...): " LINEAR_API_KEY
    
    echo ""
    echo -e "${CYAN}Enter your Linear Team ID:${NC}"
    echo "(From team settings or URL: linear.app/team/TEAM_KEY/settings)"
    read -p "Team ID: " LINEAR_TEAM_ID
    
    if [ -n "$LINEAR_API_KEY" ]; then
      echo ""
      echo -e "${GREEN}✓ Linear configuration captured${NC}"
      
      # Store API key guidance
      echo ""
      echo -e "${YELLOW}⚠️  Security Note:${NC}"
      echo "   Store your API key as an environment variable:"
      echo "   export LINEAR_API_KEY=\"${LINEAR_API_KEY}\""
      echo ""
      echo "   Add to your ~/.zshrc or ~/.bashrc for persistence"
    fi
  else
    echo ""
    echo -e "${YELLOW}⚠️  Skipping Linear configuration${NC}"
    echo "   You'll need to update .docflow.json manually"
    echo "   and set LINEAR_API_KEY environment variable"
  fi
  echo ""
fi

# =====================================================
# STEP 4: Confirm Installation
# =====================================================
read -p "Continue with ${MODE} installation? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Installation cancelled."
  exit 0
fi
echo ""

# =====================================================
# STEP 5: Download Function
# =====================================================
download_file() {
  local source="$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  
  if command -v curl &> /dev/null; then
    curl -sSL "${RAW_BASE}/${source}" -o "$dest" 2>/dev/null || {
      echo -e "${RED}❌ Failed to download: $source${NC}"
      return 1
    }
  elif command -v wget &> /dev/null; then
    wget -q "${RAW_BASE}/${source}" -O "$dest" 2>/dev/null || {
      echo -e "${RED}❌ Failed to download: $source${NC}"
      return 1
    }
  else
    echo -e "${RED}❌ Error: curl or wget required${NC}"
    exit 1
  fi
}

echo -e "${YELLOW}⬇️  Downloading DocFlow ${MODE} system files...${NC}"
echo ""

# =====================================================
# STEP 6: Install System Files
# =====================================================
echo "   [1/5] Installing rules and commands..."
mkdir -p .cursor/rules .cursor/commands

download_file ".cursor/rules/docflow.mdc" ".cursor/rules/docflow.mdc"

# Commands
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

# Cloud-specific commands
if [ "$MODE" == "cloud" ]; then
  download_file ".cursor/commands/docflow-update.md" ".cursor/commands/docflow-update.md"
  download_file ".cursor/mcp.json" ".cursor/mcp.json"
fi

# Local-specific command
if [ "$MODE" == "local" ]; then
  download_file ".cursor/commands/docflow-setup.md" ".cursor/commands/docflow-setup.md"
fi

# Platform adapters
echo "   [2/5] Installing platform adapters..."
mkdir -p .claude/commands .warp .github
download_file ".claude/rules.md" ".claude/rules.md"
download_file ".warp/rules.md" ".warp/rules.md"
download_file ".github/copilot-instructions.md" ".github/copilot-instructions.md"
download_file "AGENTS.md" "AGENTS.md"
download_file "WARP.md" "WARP.md"

# Create Claude command symlinks
echo "   Creating Claude command symlinks..."
cd .claude/commands
for cmd in start-session wrap-session capture review activate implement validate close block status; do
  ln -sf "../../.cursor/commands/${cmd}.md" "${cmd}.md" 2>/dev/null || true
done
if [ "$MODE" == "cloud" ]; then
  ln -sf "../../.cursor/commands/docflow-update.md" "docflow-update.md" 2>/dev/null || true
fi
cd ../..

# DocFlow structure
echo "   [3/5] Creating DocFlow directory structure..."
mkdir -p docflow/context
mkdir -p docflow/knowledge/{decisions,features,notes,product}

# Local-specific directories
if [ "$MODE" == "local" ]; then
  mkdir -p docflow/specs/{templates,active,backlog,complete,assets}
fi

# Context templates (only if don't exist)
echo "   [4/5] Installing context templates..."
[ ! -f "docflow/context/overview.md" ] && download_file "docflow/context/overview.md" "docflow/context/overview.md"
[ ! -f "docflow/context/stack.md" ] && download_file "docflow/context/stack.md" "docflow/context/stack.md"
[ ! -f "docflow/context/standards.md" ] && download_file "docflow/context/standards.md" "docflow/context/standards.md"

# Knowledge base files
echo "   [5/5] Installing documentation..."
download_file "docflow/knowledge/INDEX.md" "docflow/knowledge/INDEX.md"
download_file "docflow/knowledge/README.md" "docflow/knowledge/README.md"
download_file "docflow/knowledge/product/personas.md" "docflow/knowledge/product/personas.md"
download_file "docflow/knowledge/product/user-flows.md" "docflow/knowledge/product/user-flows.md"
download_file "docflow/README.md" "docflow/README.md"

# Local-specific files
if [ "$MODE" == "local" ]; then
  [ ! -f "docflow/ACTIVE.md" ] && download_file "docflow/ACTIVE.md" "docflow/ACTIVE.md"
  [ ! -f "docflow/INDEX.md" ] && download_file "docflow/INDEX.md" "docflow/INDEX.md"
  
  # Spec templates
  download_file "docflow/specs/templates/feature.md" "docflow/specs/templates/feature.md"
  download_file "docflow/specs/templates/bug.md" "docflow/specs/templates/bug.md"
  download_file "docflow/specs/templates/chore.md" "docflow/specs/templates/chore.md"
  download_file "docflow/specs/templates/idea.md" "docflow/specs/templates/idea.md"
  download_file "docflow/specs/templates/README.md" "docflow/specs/templates/README.md"
fi

# Cloud-specific: Create .docflow.json
if [ "$MODE" == "cloud" ]; then
  echo ""
  echo "   Creating .docflow.json configuration..."
  
  # Use provided values or placeholders
  TEAM_ID_VALUE="${LINEAR_TEAM_ID:-YOUR_TEAM_ID}"
  
  cat > .docflow.json << EOF
{
  "docflow": {
    "version": "${DOCFLOW_VERSION}",
    "sourceRepo": "github.com/strideUX/docflow-template",
    "lastUpdated": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  },

  "provider": {
    "type": "linear",

    "linear": {
      "teamId": "${TEAM_ID_VALUE}",
      "initiativeId": null,
      "defaultProjectId": null,

      "labels": {
        "feature": null,
        "bug": null,
        "chore": null,
        "idea": null
      },

      "states": {
        "BACKLOG": null,
        "READY": null,
        "IMPLEMENTING": null,
        "REVIEW": null,
        "TESTING": null,
        "COMPLETE": null
      }
    }
  },

  "statusMapping": {
    "BACKLOG": "Backlog",
    "READY": "Todo",
    "IMPLEMENTING": "In Progress",
    "REVIEW": "In Review",
    "TESTING": "QA",
    "COMPLETE": "Done"
  }
}
EOF
fi

# Add install script to .gitignore
if [ ! -f ".gitignore" ]; then
  touch .gitignore
fi

if ! grep -q "^docflow-install\.sh$" .gitignore 2>/dev/null; then
  echo "docflow-install.sh" >> .gitignore
  echo ""
  echo "   [Added docflow-install.sh to .gitignore]"
fi

# =====================================================
# STEP 7: Installation Summary
# =====================================================
echo ""
echo -e "${GREEN}✅ Installation complete!${NC}"
echo ""

if [ "$MODE" == "local" ]; then
  echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${GREEN}║${NC}              ${CYAN}LOCAL INSTALLATION SUMMARY${NC}                    ${GREEN}║${NC}"
  echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
  echo ""
  echo -e "${YELLOW}📦 Installed DocFlow ${DOCFLOW_VERSION} (Local)${NC}"
  echo ""
  echo "📁 System Files:"
  echo "   ✓ Rules and commands (.cursor/)"
  echo "   ✓ Platform adapters (Claude, Warp, Copilot)"
  echo "   ✓ Spec templates (4 types)"
  echo "   ✓ Knowledge base structure"
  echo ""
  echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║${NC}                    ${YELLOW}NEXT STEP${NC}                               ${CYAN}║${NC}"
  echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
  echo ""
  echo "   Open your AI tool (Cursor, Claude, etc.) and run:"
  echo ""
  echo -e "   ${GREEN}/docflow-setup${NC}"
  echo ""
  echo "   The agent will help you:"
  echo "   • Fill out project context (overview, stack, standards)"
  echo "   • Capture initial work items"
  echo "   • Get your project ready for spec-driven development"
else
  echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${BLUE}║${NC}              ${CYAN}CLOUD INSTALLATION SUMMARY${NC}                    ${BLUE}║${NC}"
  echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
  echo ""
  echo -e "${YELLOW}📦 Installed DocFlow ${DOCFLOW_VERSION} (Cloud/Linear)${NC}"
  echo ""
  echo "📁 System Files:"
  echo "   ✓ Rules and commands (.cursor/)"
  echo "   ✓ MCP configuration (.cursor/mcp.json)"
  echo "   ✓ Platform adapters (Claude, Warp, Copilot)"
  echo "   ✓ Linear config (.docflow.json)"
  echo "   ✓ Knowledge base structure"
  echo ""
  
  if [ -n "$LINEAR_API_KEY" ]; then
    echo -e "${YELLOW}🔑 Environment Setup Required:${NC}"
    echo ""
    echo "   Add to your shell profile (~/.zshrc or ~/.bashrc):"
    echo ""
    echo -e "   ${CYAN}export LINEAR_API_KEY=\"${LINEAR_API_KEY}\"${NC}"
    echo ""
  else
    echo -e "${YELLOW}🔑 Environment Setup Required:${NC}"
    echo ""
    echo "   1. Get API key from Linear → Settings → API"
    echo "   2. Add to shell profile:"
    echo ""
    echo -e "   ${CYAN}export LINEAR_API_KEY=\"lin_api_...\"${NC}"
    echo ""
  fi
  
  if [ "$LINEAR_TEAM_ID" == "" ] || [ "$LINEAR_TEAM_ID" == "YOUR_TEAM_ID" ]; then
    echo -e "${YELLOW}📝 Configuration Needed:${NC}"
    echo ""
    echo "   Update .docflow.json with your Linear team ID"
    echo "   (The setup command will help you find it)"
    echo ""
  fi
  
  echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║${NC}                    ${YELLOW}NEXT STEP${NC}                               ${CYAN}║${NC}"
  echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
  echo ""
  echo "   Open Cursor and run:"
  echo ""
  echo -e "   ${GREEN}/docflow-setup${NC}"
  echo ""
  echo "   The agent will help you:"
  echo "   • Complete Linear configuration"
  echo "   • Fill out project context (overview, stack, standards)"
  echo "   • Create initial issues in Linear from a PRD or description"
  echo "   • Get your project ready for spec-driven development"
fi

echo ""
echo -e "📖 Documentation: ${REPO_URL}"
echo ""

