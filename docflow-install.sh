#!/bin/bash
# DocFlow Unified Installer
# Version: 3.0
# 
# Handles ALL DocFlow installation scenarios:
#   - New project creation
#   - Install into existing project
#   - Update existing DocFlow
#   - Migrate from local to cloud
#
# Usage: 
#   # Create new project (interactive)
#   curl -sSL https://raw.githubusercontent.com/strideUX/docflow-template/main/docflow-install.sh | bash
#
#   # Install/update in current directory
#   curl -sSL https://raw.githubusercontent.com/strideUX/docflow-template/main/docflow-install.sh | bash -s -- --here
#
#   # Install/update in specific directory
#   curl -sSL https://raw.githubusercontent.com/strideUX/docflow-template/main/docflow-install.sh | bash -s -- --path /path/to/project

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

# Parse arguments
INSTALL_MODE=""
TARGET_PATH=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --here)
      INSTALL_MODE="existing"
      TARGET_PATH="$(pwd)"
      shift
      ;;
    --path)
      INSTALL_MODE="existing"
      TARGET_PATH="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done

echo ""
echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}              ${GREEN}DocFlow ${DOCFLOW_VERSION} Installer${NC}                      ${CYAN}║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# =====================================================
# DETECT SCENARIO
# =====================================================

# If no install mode set, ask what user wants to do
if [ -z "$INSTALL_MODE" ]; then
  echo -e "${YELLOW}What would you like to do?${NC}"
  echo ""
  echo -e "   ${GREEN}1)${NC} Create a new project with DocFlow"
  echo -e "   ${BLUE}2)${NC} Install/update DocFlow in an existing project"
  echo ""
  read -p "Select (1 or 2): " SCENARIO_CHOICE
  
  if [ "$SCENARIO_CHOICE" == "1" ]; then
    INSTALL_MODE="new"
  elif [ "$SCENARIO_CHOICE" == "2" ]; then
    INSTALL_MODE="existing"
    echo ""
    echo -e "${YELLOW}Enter path to existing project:${NC}"
    read -p "Path (or . for current directory): " TARGET_PATH
    if [ "$TARGET_PATH" == "." ]; then
      TARGET_PATH="$(pwd)"
    fi
    # Expand ~ to home directory
    TARGET_PATH="${TARGET_PATH/#\~/$HOME}"
  else
    echo -e "${RED}Invalid selection. Exiting.${NC}"
    exit 1
  fi
fi

# =====================================================
# SCENARIO: NEW PROJECT
# =====================================================
if [ "$INSTALL_MODE" == "new" ]; then
  echo ""
  echo -e "${YELLOW}📝 New Project Setup${NC}"
  echo ""
  read -p "Project name: " PROJECT_NAME

  if [ -z "$PROJECT_NAME" ]; then
    echo -e "${RED}Project name is required. Exiting.${NC}"
    exit 1
  fi

  # Convert to folder-friendly name
  FOLDER_NAME=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-')
  echo ""
  echo -e "   Folder name: ${CYAN}${FOLDER_NAME}${NC}"

  # Project location
  echo ""
  DEFAULT_LOCATION="$HOME/Projects"
  read -p "Location (default: $DEFAULT_LOCATION): " PROJECT_LOCATION

  if [ -z "$PROJECT_LOCATION" ]; then
    PROJECT_LOCATION="$DEFAULT_LOCATION"
  fi
  PROJECT_LOCATION="${PROJECT_LOCATION/#\~/$HOME}"

  TARGET_PATH="$PROJECT_LOCATION/$FOLDER_NAME"
  echo ""
  echo -e "   Full path: ${CYAN}${TARGET_PATH}${NC}"

  # Check if directory exists
  if [ -d "$TARGET_PATH" ]; then
    echo ""
    echo -e "${RED}⚠️  Directory already exists: $TARGET_PATH${NC}"
    read -p "Overwrite? (y/n): " OVERWRITE
    if [[ ! $OVERWRITE =~ ^[Yy]$ ]]; then
      echo "Installation cancelled."
      exit 0
    fi
    rm -rf "$TARGET_PATH"
  fi

  IS_NEW_PROJECT=true
fi

# =====================================================
# SCENARIO: EXISTING PROJECT
# =====================================================
if [ "$INSTALL_MODE" == "existing" ]; then
  # Validate path
  if [ ! -d "$TARGET_PATH" ]; then
    echo -e "${RED}Directory does not exist: $TARGET_PATH${NC}"
    exit 1
  fi
  
  TARGET_PATH="$(cd "$TARGET_PATH" && pwd)"
  IS_NEW_PROJECT=false
  
  echo ""
  echo -e "${YELLOW}📂 Analyzing project: ${CYAN}$TARGET_PATH${NC}"
  echo ""
  
  # Detect current state
  HAS_DOCFLOW=false
  HAS_LOCAL_SPECS=false
  HAS_CLOUD_CONFIG=false
  CURRENT_MODE=""
  BACKLOG_COUNT=0
  COMPLETE_COUNT=0
  
  if [ -d "$TARGET_PATH/docflow" ]; then
    HAS_DOCFLOW=true
  fi
  
  if [ -d "$TARGET_PATH/docflow/specs" ]; then
    BACKLOG_COUNT=$(find "$TARGET_PATH/docflow/specs/backlog" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    COMPLETE_COUNT=$(find "$TARGET_PATH/docflow/specs/complete" -name "*.md" -not -name "README.md" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$BACKLOG_COUNT" -gt 0 ] || [ "$COMPLETE_COUNT" -gt 0 ]; then
      HAS_LOCAL_SPECS=true
      CURRENT_MODE="local"
    fi
  fi
  
  if [ -f "$TARGET_PATH/.docflow.json" ]; then
    HAS_CLOUD_CONFIG=true
    CURRENT_MODE="cloud"
  fi
  
  # Report findings
  if [ "$HAS_LOCAL_SPECS" = true ]; then
    echo -e "   ${YELLOW}Found: Local DocFlow with specs${NC}"
    echo -e "   • Backlog: ${CYAN}$BACKLOG_COUNT${NC} specs"
    echo -e "   • Complete: ${CYAN}$COMPLETE_COUNT${NC} specs"
    echo ""
  elif [ "$HAS_CLOUD_CONFIG" = true ]; then
    echo -e "   ${BLUE}Found: DocFlow Cloud installation${NC}"
    echo ""
  elif [ "$HAS_DOCFLOW" = true ]; then
    echo -e "   ${GREEN}Found: DocFlow folder (empty or templates only)${NC}"
    echo ""
  else
    echo -e "   ${GREEN}No existing DocFlow found - fresh install${NC}"
    echo ""
  fi
fi

# =====================================================
# CHOOSE DOCFLOW TYPE (local vs cloud)
# =====================================================
echo -e "${YELLOW}📦 Choose DocFlow Type:${NC}"
echo ""
echo -e "   ${GREEN}1) Local${NC}  - All specs stored as local markdown files"
echo "            Best for: Solo developers, offline work"
echo ""
echo -e "   ${BLUE}2) Cloud${NC}  - Specs stored in Linear, context stays local"
echo "            Best for: Teams, collaboration, Cursor Background Agent"
echo ""

# If migrating from local, hint at cloud
if [ "$HAS_LOCAL_SPECS" = true ]; then
  echo -e "   ${YELLOW}💡 TIP: Choose Cloud to migrate your $BACKLOG_COUNT backlog specs to Linear${NC}"
  echo ""
fi

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

# Detect migration scenario
IS_MIGRATION=false
if [ "$HAS_LOCAL_SPECS" = true ] && [ "$MODE" == "cloud" ]; then
  IS_MIGRATION=true
  echo ""
  echo -e "${YELLOW}📦 Migration mode: Local specs will be migrated to Linear${NC}"
fi

# =====================================================
# CONFIRMATION
# =====================================================
echo ""
echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}                    ${YELLOW}Summary${NC}                                 ${CYAN}║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
if [ "$IS_NEW_PROJECT" = true ]; then
  echo "   Action:   Create new project"
  echo "   Project:  $PROJECT_NAME"
else
  echo "   Action:   Install/update DocFlow"
fi
echo "   Location: $TARGET_PATH"
echo "   Type:     $MODE"
if [ "$IS_MIGRATION" = true ]; then
  echo "   Migration: $BACKLOG_COUNT backlog + $COMPLETE_COUNT completed specs → Linear"
fi
echo ""

read -p "Proceed? (y/n): " CONFIRM
if [[ ! $CONFIRM =~ ^[Yy]$ ]]; then
  echo "Installation cancelled."
  exit 0
fi

# Create directory if new project
if [ "$IS_NEW_PROJECT" = true ]; then
  echo ""
  echo -e "${YELLOW}📁 Creating project directory...${NC}"
  mkdir -p "$TARGET_PATH"
fi

cd "$TARGET_PATH"

# =====================================================
# DOWNLOAD FUNCTION
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

echo ""
echo -e "${YELLOW}⬇️  Installing DocFlow ${MODE} files...${NC}"
echo ""

# =====================================================
# INSTALL SYSTEM FILES
# =====================================================
echo "   [1/5] Installing rules and commands..."
mkdir -p .cursor/rules .cursor/commands

download_file ".cursor/rules/docflow.mdc" ".cursor/rules/docflow.mdc"

# Commands - common to both modes
for cmd in start-session wrap-session capture review activate implement validate close block status docflow-setup; do
  download_file ".cursor/commands/${cmd}.md" ".cursor/commands/${cmd}.md"
done

# Cloud-specific commands
if [ "$MODE" == "cloud" ]; then
  for cmd in docflow-update sync-project project-update attach refine; do
    download_file ".cursor/commands/${cmd}.md" ".cursor/commands/${cmd}.md"
  done
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
  for cmd in docflow-update sync-project project-update attach refine; do
    ln -sf "../../.cursor/commands/${cmd}.md" "${cmd}.md" 2>/dev/null || true
  done
fi
cd ../..

# DocFlow structure
echo "   [3/5] Creating/updating DocFlow directory structure..."
mkdir -p docflow/context
mkdir -p docflow/knowledge/{decisions,features,notes,product}

# Local-specific directories (only if new or not migrating)
if [ "$MODE" == "local" ]; then
  mkdir -p docflow/specs/{templates,active,backlog,complete,assets}
fi

# Context templates - only install if they don't exist or are empty
echo "   [4/5] Installing context templates..."
for ctx in overview stack standards; do
  if [ ! -f "docflow/context/${ctx}.md" ] || [ ! -s "docflow/context/${ctx}.md" ]; then
    download_file "docflow/context/${ctx}.md" "docflow/context/${ctx}.md"
  else
    echo "      ⏭ Preserving existing ${ctx}.md"
  fi
done

# Knowledge base files - only install if they don't exist
echo "   [5/5] Installing documentation..."
if [ ! -f "docflow/knowledge/INDEX.md" ]; then
  download_file "docflow/knowledge/INDEX.md" "docflow/knowledge/INDEX.md"
fi
if [ ! -f "docflow/knowledge/README.md" ]; then
  download_file "docflow/knowledge/README.md" "docflow/knowledge/README.md"
fi
if [ ! -f "docflow/knowledge/product/personas.md" ]; then
  download_file "docflow/knowledge/product/personas.md" "docflow/knowledge/product/personas.md"
fi
if [ ! -f "docflow/knowledge/product/user-flows.md" ]; then
  download_file "docflow/knowledge/product/user-flows.md" "docflow/knowledge/product/user-flows.md"
fi
download_file "docflow/README.md" "docflow/README.md"

# Local-specific files
if [ "$MODE" == "local" ]; then
  if [ ! -f "docflow/ACTIVE.md" ]; then
    download_file "docflow/ACTIVE.md" "docflow/ACTIVE.md"
  fi
  if [ ! -f "docflow/INDEX.md" ]; then
    download_file "docflow/INDEX.md" "docflow/INDEX.md"
  fi
  
  # Spec templates
  for template in feature bug chore idea README; do
    download_file "docflow/specs/templates/${template}.md" "docflow/specs/templates/${template}.md"
  done
fi

# Cloud-specific: Create configuration files
if [ "$MODE" == "cloud" ]; then
  echo ""
  echo "   Creating configuration files..."
  
  # Determine project name
  if [ -z "$PROJECT_NAME" ]; then
    PROJECT_NAME=$(basename "$TARGET_PATH")
  fi
  
  # Create .docflow.json (only if doesn't exist or updating)
  cat > .docflow.json << EOF
{
  "docflow": {
    "version": "${DOCFLOW_VERSION}",
    "sourceRepo": "github.com/strideUX/docflow-template"
  },
  "project": {
    "name": "${PROJECT_NAME}",
    "created": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  },
  "provider": {
    "type": "linear",
    "teamId": null,
    "projectId": null
  },
  "statusMapping": {
    "BACKLOG": "Backlog",
    "READY": "Todo",
    "IMPLEMENTING": "In Progress",
    "BLOCKED": "Blocked",
    "REVIEW": "In Review",
    "TESTING": "QA",
    "COMPLETE": "Done",
    "ARCHIVED": "Archived",
    "CANCELED": "Canceled",
    "DUPLICATE": "Duplicate"
  }
}
EOF
  echo "   ✓ .docflow.json created"

  # Create .env.example
  cat > .env.example << 'EOF'
# DocFlow Cloud - Environment Configuration
# 
# Copy this file to .env and add your API key
# IMPORTANT: Never commit .env to git!

# ===========================================
# REQUIRED: Linear API Key
# ===========================================
# Get from: Linear → Settings → API → Personal API Keys
# Format: lin_api_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
LINEAR_API_KEY=

# ===========================================
# OPTIONAL: Figma Access Token
# ===========================================
# Get from: Figma → Settings → Personal Access Tokens
# Only needed if using Figma MCP for design integration
FIGMA_ACCESS_TOKEN=
EOF
  echo "   ✓ .env.example created"

  # Create .env if it doesn't exist
  if [ ! -f ".env" ]; then
    cp .env.example .env
    echo "   ✓ .env created (add your API key)"
  else
    echo "   ⏭ .env already exists"
  fi
fi

# Update .gitignore
echo ""
echo "   Updating .gitignore..."

# Entries to add
GITIGNORE_ADDITIONS=""

if [ "$MODE" == "cloud" ]; then
  # Check if entries exist
  if [ -f ".gitignore" ]; then
    if ! grep -q "^\.env$" ".gitignore" 2>/dev/null; then
      GITIGNORE_ADDITIONS="${GITIGNORE_ADDITIONS}
# Environment (NEVER commit!)
.env
.env.local
.env.*.local"
    fi
    if ! grep -q "specs-archived" ".gitignore" 2>/dev/null; then
      GITIGNORE_ADDITIONS="${GITIGNORE_ADDITIONS}

# DocFlow archived specs (safe to delete after migration)
docflow/specs-archived*"
    fi
    
    if [ -n "$GITIGNORE_ADDITIONS" ]; then
      echo "$GITIGNORE_ADDITIONS" >> .gitignore
      echo "   ✓ .gitignore updated"
    else
      echo "   ⏭ .gitignore already configured"
    fi
  else
    # Create new .gitignore
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

# Environment (NEVER commit!)
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

# DocFlow archived specs (safe to delete after migration)
docflow/specs-archived*
EOF
    echo "   ✓ .gitignore created"
  fi
else
  # Local mode - simpler .gitignore
  if [ ! -f ".gitignore" ]; then
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
    echo "   ✓ .gitignore created"
  fi
fi

# Initialize git for new projects
if [ "$IS_NEW_PROJECT" = true ]; then
  echo ""
  echo "   Initializing git repository..."
  git init -q
fi

# =====================================================
# INSTALLATION SUMMARY
# =====================================================
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC}              ${CYAN}✅ DOCFLOW INSTALLED!${NC}                          ${GREEN}║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}📁 Project Location:${NC}"
echo "   $TARGET_PATH"
echo ""
echo -e "${YELLOW}📦 DocFlow ${DOCFLOW_VERSION} (${MODE}) installed${NC}"
echo ""

# =====================================================
# NEXT STEPS
# =====================================================
echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}                    ${YELLOW}NEXT STEPS${NC}                              ${CYAN}║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

if [ "$MODE" == "cloud" ]; then
  echo -e "   ${GREEN}1.${NC} Add your Linear API key to ${CYAN}.env${NC}:"
  echo ""
  echo "      LINEAR_API_KEY=lin_api_your_key_here"
  echo ""
  echo "      (Get from: Linear → Settings → API → Personal API Keys)"
  echo ""
  echo -e "   ${GREEN}2.${NC} Open in Cursor:"
  echo ""
  echo -e "      ${GREEN}cursor ${TARGET_PATH}${NC}"
  echo ""
  echo -e "   ${GREEN}3.${NC} Run the setup command:"
  echo ""
  echo -e "      ${GREEN}/docflow-setup${NC}"
  echo ""
  
  if [ "$IS_MIGRATION" = true ]; then
    echo "   The agent will:"
    echo "   • Connect to your Linear team"
    echo "   • Create a new project from your context files"
    echo -e "   • ${YELLOW}Migrate $BACKLOG_COUNT backlog specs to Linear${NC}"
    echo -e "   • ${YELLOW}Migrate $COMPLETE_COUNT completed specs to Linear${NC}"
    echo "   • Archive local specs folder"
  else
    echo "   The agent will:"
    echo "   • Validate your .env configuration"
    echo "   • Connect to your Linear team"
    echo "   • Help fill out project context"
    echo "   • Create initial issues in Linear"
  fi
  echo ""
  echo -e "   ${YELLOW}💡 TIP:${NC} Install Linear MCP in Cursor for best experience:"
  echo "      Cursor Settings → Features → MCP → Add:"
  echo "      Name: linear | Command: npx | Args: -y mcp-remote https://mcp.linear.app/mcp"
else
  # Local mode
  echo -e "   ${GREEN}1.${NC} Open in Cursor:"
  echo ""
  echo -e "      ${GREEN}cursor ${TARGET_PATH}${NC}"
  echo ""
  echo -e "   ${GREEN}2.${NC} Run the setup command:"
  echo ""
  echo -e "      ${GREEN}/docflow-setup${NC}"
  echo ""
  echo "   The agent will:"
  echo "   • Fill out project context (overview, stack, standards)"
  echo "   • Capture initial work items as specs"
  echo "   • Get your project ready for development"
fi

echo ""
echo -e "📖 Documentation: https://github.com/strideUX/docflow-template"
echo ""
