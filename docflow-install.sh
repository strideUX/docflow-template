#!/bin/bash
# DocFlow Unified Installer
# Version: 3.0
# 
# Creates a new project with DocFlow installed
#
# Usage: 
#   curl -sSL https://raw.githubusercontent.com/strideUX/docflow-template/main/docflow-install.sh | bash
#
# Or download and run locally:
#   ./docflow-install.sh

set -e

DOCFLOW_VERSION="3.0"
RAW_BASE_LOCAL="https://raw.githubusercontent.com/strideUX/docflow-template/main/local/template"
RAW_BASE_CLOUD="https://raw.githubusercontent.com/strideUX/docflow-template/main/cloud/template"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo ""
echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}          ${GREEN}DocFlow ${DOCFLOW_VERSION} - New Project Setup${NC}              ${CYAN}║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# =====================================================
# STEP 1: Project Name
# =====================================================
echo -e "${YELLOW}📝 Project Setup${NC}"
echo ""
read -p "Project name: " PROJECT_NAME

if [ -z "$PROJECT_NAME" ]; then
  echo -e "${RED}Project name is required. Exiting.${NC}"
  exit 1
fi

# Convert to folder-friendly name (lowercase, replace spaces with dashes)
FOLDER_NAME=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-')

echo ""
echo -e "   Folder name: ${CYAN}${FOLDER_NAME}${NC}"

# =====================================================
# STEP 2: Project Location
# =====================================================
echo ""
DEFAULT_LOCATION="$HOME/Projects"
read -p "Location (default: $DEFAULT_LOCATION): " PROJECT_LOCATION

if [ -z "$PROJECT_LOCATION" ]; then
  PROJECT_LOCATION="$DEFAULT_LOCATION"
fi

# Expand ~ to home directory
PROJECT_LOCATION="${PROJECT_LOCATION/#\~/$HOME}"

FULL_PATH="$PROJECT_LOCATION/$FOLDER_NAME"

echo ""
echo -e "   Full path: ${CYAN}${FULL_PATH}${NC}"

# Check if directory exists
if [ -d "$FULL_PATH" ]; then
  echo ""
  echo -e "${RED}⚠️  Directory already exists: $FULL_PATH${NC}"
  read -p "Overwrite? (y/n): " OVERWRITE
  if [[ ! $OVERWRITE =~ ^[Yy]$ ]]; then
    echo "Installation cancelled."
    exit 0
  fi
  rm -rf "$FULL_PATH"
fi

# =====================================================
# STEP 3: Choose Installation Type
# =====================================================
echo ""
echo -e "${YELLOW}📦 Choose DocFlow Type:${NC}"
echo ""
echo -e "   ${GREEN}1) Local${NC}  - All specs stored as local markdown files"
echo "            Best for: Solo developers, offline work"
echo ""
echo -e "   ${BLUE}2) Cloud${NC}  - Specs stored in Linear, context stays local"
echo "            Best for: Teams, collaboration, Cursor Background Agent"
echo ""
read -p "Select (1 or 2): " INSTALL_TYPE

if [[ "$INSTALL_TYPE" != "1" && "$INSTALL_TYPE" != "2" ]]; then
  echo -e "${RED}Invalid selection. Exiting.${NC}"
  exit 1
fi

if [ "$INSTALL_TYPE" == "1" ]; then
  MODE="local"
  RAW_BASE="$RAW_BASE_LOCAL"
  echo ""
  echo -e "${GREEN}✓ Local installation selected${NC}"
else
  MODE="cloud"
  RAW_BASE="$RAW_BASE_CLOUD"
  echo ""
  echo -e "${BLUE}✓ Cloud (Linear) installation selected${NC}"
fi

# =====================================================
# STEP 4: Cloud Configuration (if cloud mode)
# =====================================================
LINEAR_TEAM_ID=""
LINEAR_API_KEY=""

if [ "$MODE" == "cloud" ]; then
  echo ""
  echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${BLUE}║${NC}              ${CYAN}Linear Configuration${NC}                          ${BLUE}║${NC}"
  echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
  echo ""
  echo "DocFlow Cloud stores specs in Linear for team collaboration."
  echo ""
  echo -e "${YELLOW}You'll need:${NC}"
  echo "  1. Linear API Key (from Linear → Settings → API)"
  echo "  2. Team ID (from team URL or settings)"
  echo ""
  echo -e "${CYAN}Don't have these yet?${NC}"
  echo "  - Skip now, then run /docflow-setup in Cursor to configure"
  echo ""
  
  read -p "Configure Linear now? (y/n): " CONFIGURE_LINEAR
  
  if [[ $CONFIGURE_LINEAR =~ ^[Yy]$ ]]; then
    echo ""
    read -p "Linear API Key (lin_api_...): " LINEAR_API_KEY
    echo ""
    read -p "Linear Team ID: " LINEAR_TEAM_ID
    
    if [ -n "$LINEAR_API_KEY" ]; then
      echo ""
      echo -e "${GREEN}✓ Linear configuration captured${NC}"
    fi
  else
    echo ""
    echo -e "${YELLOW}⚠️  Skipping Linear configuration${NC}"
    echo "   Run /docflow-setup in Cursor to complete setup"
  fi
fi

# =====================================================
# STEP 5: Confirm and Create
# =====================================================
echo ""
echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}                    ${YELLOW}Summary${NC}                                 ${CYAN}║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "   Project:  $PROJECT_NAME"
echo "   Location: $FULL_PATH"
echo "   Type:     $MODE"
if [ "$MODE" == "cloud" ] && [ -n "$LINEAR_TEAM_ID" ]; then
  echo "   Linear:   Team ID configured ✓"
fi
echo ""

read -p "Create project? (y/n): " CONFIRM
if [[ ! $CONFIRM =~ ^[Yy]$ ]]; then
  echo "Installation cancelled."
  exit 0
fi

# Create directory
echo ""
echo -e "${YELLOW}📁 Creating project directory...${NC}"
mkdir -p "$FULL_PATH"
cd "$FULL_PATH"

# =====================================================
# STEP 6: Download Function
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

echo -e "${YELLOW}⬇️  Downloading DocFlow ${MODE} files...${NC}"
echo ""

# =====================================================
# STEP 7: Install System Files
# =====================================================
echo "   [1/5] Installing rules and commands..."
mkdir -p .cursor/rules .cursor/commands

download_file ".cursor/rules/docflow.mdc" ".cursor/rules/docflow.mdc"

# Commands
for cmd in start-session wrap-session capture review activate implement validate close block status; do
  download_file ".cursor/commands/${cmd}.md" ".cursor/commands/${cmd}.md"
done

# Mode-specific commands and files
if [ "$MODE" == "cloud" ]; then
  download_file ".cursor/commands/docflow-update.md" ".cursor/commands/docflow-update.md"
  download_file ".cursor/commands/docflow-setup.md" ".cursor/commands/docflow-setup.md"
  download_file ".cursor/mcp.json" ".cursor/mcp.json"
else
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
for cmd in start-session wrap-session capture review activate implement validate close block status docflow-setup; do
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

# Context templates
echo "   [4/5] Installing context templates..."
download_file "docflow/context/overview.md" "docflow/context/overview.md"
download_file "docflow/context/stack.md" "docflow/context/stack.md"
download_file "docflow/context/standards.md" "docflow/context/standards.md"

# Knowledge base files
echo "   [5/5] Installing documentation..."
download_file "docflow/knowledge/INDEX.md" "docflow/knowledge/INDEX.md"
download_file "docflow/knowledge/README.md" "docflow/knowledge/README.md"
download_file "docflow/knowledge/product/personas.md" "docflow/knowledge/product/personas.md"
download_file "docflow/knowledge/product/user-flows.md" "docflow/knowledge/product/user-flows.md"
download_file "docflow/README.md" "docflow/README.md"

# Local-specific files
if [ "$MODE" == "local" ]; then
  download_file "docflow/ACTIVE.md" "docflow/ACTIVE.md"
  download_file "docflow/INDEX.md" "docflow/INDEX.md"
  
  # Spec templates
  for template in feature bug chore idea README; do
    download_file "docflow/specs/templates/${template}.md" "docflow/specs/templates/${template}.md"
  done
fi

# Cloud-specific: Create .docflow.json
if [ "$MODE" == "cloud" ]; then
  echo ""
  echo "   Creating .docflow.json configuration..."
  
  TEAM_ID_VALUE="${LINEAR_TEAM_ID:-YOUR_TEAM_ID}"
  
  cat > .docflow.json << EOF
{
  "docflow": {
    "version": "${DOCFLOW_VERSION}",
    "sourceRepo": "github.com/strideUX/docflow-template",
    "lastUpdated": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  },

  "project": {
    "name": "${PROJECT_NAME}",
    "created": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
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

# Create .gitignore
cat > .gitignore << 'EOF'
# Dependencies
node_modules/
.pnp
.pnp.js

# Build
dist/
build/
.next/
out/

# Environment
.env
.env.local
.env.*.local

# IDE
.idea/
*.swp
*.swo
.DS_Store

# Logs
*.log
npm-debug.log*

# Testing
coverage/
EOF

# Initialize git
echo ""
echo "   Initializing git repository..."
git init -q

# =====================================================
# STEP 8: Installation Summary
# =====================================================
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC}              ${CYAN}✅ PROJECT CREATED!${NC}                           ${GREEN}║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}📁 Project Location:${NC}"
echo "   $FULL_PATH"
echo ""
echo -e "${YELLOW}📦 DocFlow ${DOCFLOW_VERSION} (${MODE}) installed${NC}"
echo ""

if [ "$MODE" == "cloud" ]; then
  if [ -n "$LINEAR_API_KEY" ]; then
    echo -e "${YELLOW}🔑 Don't forget to set your API key:${NC}"
    echo ""
    echo "   export LINEAR_API_KEY=\"${LINEAR_API_KEY}\""
    echo ""
    echo "   Add this to your ~/.zshrc for persistence"
    echo ""
  else
    echo -e "${YELLOW}🔑 You'll need to:${NC}"
    echo "   1. Get API key from Linear → Settings → API"
    echo "   2. Set: export LINEAR_API_KEY=\"lin_api_...\""
    echo ""
  fi
fi

echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}                    ${YELLOW}NEXT STEPS${NC}                              ${CYAN}║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "   1. Open in Cursor:"
echo ""
echo -e "      ${GREEN}cursor ${FULL_PATH}${NC}"
echo ""
echo "   2. Run the setup command:"
echo ""
echo -e "      ${GREEN}/docflow-setup${NC}"
echo ""
echo "   The agent will help you:"
if [ "$MODE" == "cloud" ]; then
  echo "   • Complete Linear configuration (if not done)"
  echo "   • Fill out project context (overview, stack, standards)"
  echo "   • Create initial issues in Linear"
else
  echo "   • Fill out project context (overview, stack, standards)"
  echo "   • Capture initial work items as specs"
fi
echo "   • Get your project ready for development"
echo ""
echo -e "📖 Documentation: https://github.com/strideUX/docflow-template"
echo ""
