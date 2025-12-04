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
# STEP 4: Confirm and Create
# =====================================================
echo ""
echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}                    ${YELLOW}Summary${NC}                                 ${CYAN}║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "   Project:  $PROJECT_NAME"
echo "   Location: $FULL_PATH"
echo "   Type:     $MODE"
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

echo -e "${YELLOW}⬇️  Downloading DocFlow ${MODE} files...${NC}"
echo ""

# =====================================================
# STEP 6: Install System Files
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

# Cloud-specific: Create configuration files
if [ "$MODE" == "cloud" ]; then
  echo ""
  echo "   Creating configuration files..."
  
  # Create .docflow.json (config - no secrets, OK to commit)
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
    "projectId": null
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

  # Create .env.example
  cat > .env.example << 'EOF'
# DocFlow Cloud - Environment Configuration
# 
# Copy this file to .env and fill in your values
# IMPORTANT: Never commit .env to git!

# ===========================================
# REQUIRED: Linear API Key
# ===========================================
# Get from: Linear → Settings → API → Personal API Keys
# Format: lin_api_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
LINEAR_API_KEY=

# ===========================================
# REQUIRED: Linear Team ID  
# ===========================================
# Get from: Linear → Settings → Teams → [Your Team]
# Or from URL: linear.app/team/[TEAM_ID]/...
LINEAR_TEAM_ID=

# ===========================================
# OPTIONAL: Figma Access Token
# ===========================================
# Get from: Figma → Settings → Personal Access Tokens
# Only needed if using Figma MCP for design integration
FIGMA_ACCESS_TOKEN=

# NOTE: Project ID is stored in .docflow.json (not a secret)
# Run /docflow-setup to select your project
EOF

  # Create .env (copy of example for user to fill in)
  cp .env.example .env
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
EOF

# Initialize git
echo ""
echo "   Initializing git repository..."
git init -q

# =====================================================
# STEP 7: Installation Summary
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
  echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║${NC}                    ${YELLOW}NEXT STEPS${NC}                              ${CYAN}║${NC}"
  echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
  echo ""
  echo -e "   ${GREEN}1.${NC} Open ${CYAN}.env${NC} and add your Linear credentials:"
  echo ""
  echo "      LINEAR_API_KEY=lin_api_your_key_here"
  echo "      LINEAR_TEAM_ID=your_team_id"
  echo ""
  echo -e "   ${GREEN}2.${NC} Open in Cursor:"
  echo ""
  echo -e "      ${GREEN}cursor ${FULL_PATH}${NC}"
  echo ""
  echo -e "   ${GREEN}3.${NC} Run the setup command:"
  echo ""
  echo -e "      ${GREEN}/docflow-setup${NC}"
  echo ""
  echo "   The agent will:"
  echo "   • Validate your .env configuration"
  echo "   • Test the Linear connection"
  echo "   • Help fill out project context"
  echo "   • Create initial issues in Linear"
else
  echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║${NC}                    ${YELLOW}NEXT STEPS${NC}                              ${CYAN}║${NC}"
  echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
  echo ""
  echo -e "   ${GREEN}1.${NC} Open in Cursor:"
  echo ""
  echo -e "      ${GREEN}cursor ${FULL_PATH}${NC}"
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
