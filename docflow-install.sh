#!/bin/bash
# DocFlow Unified Installer
# Version: 4.1
# 
# Handles ALL DocFlow installation scenarios:
#   - New project creation
#   - Install into existing project
#   - Update existing DocFlow (smart update with manifest)
#   - Migrate from local to cloud
#
# Usage: 
#   # Interactive mode
#   curl -sSL https://raw.githubusercontent.com/strideUX/docflow-template/main/docflow-install.sh | bash
#
#   # Update current project
#   curl -sSL https://raw.githubusercontent.com/strideUX/docflow-template/main/docflow-install.sh | bash -s -- --update
#
#   # Update specific project
#   curl -sSL https://raw.githubusercontent.com/strideUX/docflow-template/main/docflow-install.sh | bash -s -- --update --path /path/to/project

set -e

DOCFLOW_VERSION="4.2.9"
RAW_BASE_LOCAL="https://raw.githubusercontent.com/strideUX/docflow-template/main/local/template"
RAW_BASE_CLOUD="https://raw.githubusercontent.com/strideUX/docflow-template/main/cloud/template"
RAW_BASE_ROOT="https://raw.githubusercontent.com/strideUX/docflow-template/main"
MANIFEST_URL="https://raw.githubusercontent.com/strideUX/docflow-template/main/cloud/manifest.json"

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
UPDATE_MODE=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --update)
      UPDATE_MODE=true
      shift
      ;;
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
# HELPER FUNCTIONS
# =====================================================

download_file() {
  local url="$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  
  if command -v curl &> /dev/null; then
    curl -sSL "$url" -o "$dest" 2>/dev/null || {
      echo -e "${RED}❌ Failed to download: $url${NC}"
      return 1
    }
  elif command -v wget &> /dev/null; then
    wget -q "$url" -O "$dest" 2>/dev/null || {
      echo -e "${RED}❌ Failed to download: $url${NC}"
      return 1
    }
  else
    echo -e "${RED}❌ Error: curl or wget required${NC}"
    exit 1
  fi
}

get_json_value() {
  local file="$1"
  local key="$2"
  if command -v python3 &> /dev/null; then
    python3 -c "import json; print(json.load(open('$file'))$key)" 2>/dev/null
  elif command -v jq &> /dev/null; then
    jq -r "$key" "$file" 2>/dev/null
  else
    echo ""
  fi
}

compare_versions() {
  local v1="$1"
  local v2="$2"
  if [ "$v1" = "$v2" ]; then
    echo "equal"
  elif [ "$(printf '%s\n' "$v1" "$v2" | sort -V | head -n1)" = "$v1" ]; then
    echo "older"
  else
    echo "newer"
  fi
}

# =====================================================
# UPDATE MODE
# =====================================================

if [ "$UPDATE_MODE" = true ]; then
  echo -e "${YELLOW}🔄 DocFlow Update Mode${NC}"
  echo ""
  
  # If no path specified, show project picker
  if [ -z "$TARGET_PATH" ]; then
    echo "Which project would you like to update?"
    echo ""
    echo -e "   ${GREEN}1)${NC} Current directory ($(pwd))"
    echo -e "   ${BLUE}2)${NC} Enter a path"
    echo ""
    read -p "Select (1 or 2): " UPDATE_CHOICE
    
    if [ "$UPDATE_CHOICE" == "1" ]; then
      TARGET_PATH="$(pwd)"
    elif [ "$UPDATE_CHOICE" == "2" ]; then
      echo ""
      read -p "Enter project path: " TARGET_PATH
      TARGET_PATH="${TARGET_PATH/#\~/$HOME}"
    else
      echo -e "${RED}Invalid selection. Exiting.${NC}"
      exit 1
    fi
  fi
  
  # Validate path
  if [ ! -d "$TARGET_PATH" ]; then
    echo -e "${RED}Directory does not exist: $TARGET_PATH${NC}"
    exit 1
  fi
  
  TARGET_PATH="$(cd "$TARGET_PATH" && pwd)"
  cd "$TARGET_PATH"
  
  # Check if this is a DocFlow project
  if [ ! -f ".docflow/version" ] && [ ! -f ".docflow/config.json" ]; then
    echo -e "${RED}Not a DocFlow Cloud project: $TARGET_PATH${NC}"
    echo "   Missing .docflow/version or .docflow/config.json"
    echo ""
    echo "   Run without --update to install DocFlow in this project."
    exit 1
  fi
  
  # Get current version
  CURRENT_VERSION="4.0.0"
  if [ -f ".docflow/version" ]; then
    CURRENT_VERSION=$(cat .docflow/version | tr -d '[:space:]')
  fi
  
  echo -e "   Project: ${CYAN}$TARGET_PATH${NC}"
  echo -e "   Current: ${YELLOW}v$CURRENT_VERSION${NC}"
  echo -e "   Latest:  ${GREEN}v$DOCFLOW_VERSION${NC}"
  echo ""
  
  # Compare versions
  VERSION_STATUS=$(compare_versions "$CURRENT_VERSION" "$DOCFLOW_VERSION")
  
  if [ "$VERSION_STATUS" = "equal" ]; then
    echo -e "${GREEN}✓ Already up to date!${NC}"
    echo ""
    exit 0
  elif [ "$VERSION_STATUS" = "newer" ]; then
    echo -e "${YELLOW}⚠️  Project version ($CURRENT_VERSION) is newer than installer ($DOCFLOW_VERSION)${NC}"
    read -p "Continue anyway? (y/n): " FORCE_UPDATE
    if [[ ! $FORCE_UPDATE =~ ^[Yy]$ ]]; then
      exit 0
    fi
  fi
  
  # Download manifest
  echo "   Fetching manifest..."
  TEMP_MANIFEST=$(mktemp)
  download_file "$MANIFEST_URL" "$TEMP_MANIFEST"
  
  # Read content folder from config
  CONTENT_FOLDER="docflow"
  if [ -f ".docflow/config.json" ]; then
    CONTENT_FOLDER=$(get_json_value ".docflow/config.json" "['paths']['content']" || echo "docflow")
  fi
  
  # Preserve project-specific config values
  echo "   Preserving project configuration..."
  TEAM_ID=""
  PROJECT_ID=""
  MILESTONE_ID=""
  if [ -f ".docflow/config.json" ]; then
    if command -v python3 &> /dev/null; then
      TEAM_ID=$(python3 -c "import json; d=json.load(open('.docflow/config.json')); print(d.get('provider',{}).get('teamId',''))" 2>/dev/null || echo "")
      PROJECT_ID=$(python3 -c "import json; d=json.load(open('.docflow/config.json')); print(d.get('provider',{}).get('projectId',''))" 2>/dev/null || echo "")
      MILESTONE_ID=$(python3 -c "import json; d=json.load(open('.docflow/config.json')); print(d.get('provider',{}).get('defaultMilestoneId',''))" 2>/dev/null || echo "")
    elif command -v jq &> /dev/null; then
      TEAM_ID=$(jq -r '.provider.teamId // empty' .docflow/config.json)
      PROJECT_ID=$(jq -r '.provider.projectId // empty' .docflow/config.json)
      MILESTONE_ID=$(jq -r '.provider.defaultMilestoneId // empty' .docflow/config.json)
    fi
  fi
  
  echo ""
  echo -e "${YELLOW}📦 Updating DocFlow files...${NC}"
  echo ""
  
  # Set base URL
  RAW_BASE="$RAW_BASE_CLOUD"
  
  # =====================================================
  # UPDATE OWNED DIRECTORIES (replace entirely)
  # =====================================================
  echo "   [1/5] Updating .docflow/rules..."
  rm -rf .docflow/rules
  mkdir -p .docflow/rules
  for rule in core pm-agent implementation-agent qe-agent linear-integration figma-integration session-awareness; do
    download_file "${RAW_BASE}/.docflow/rules/${rule}.md" ".docflow/rules/${rule}.md"
  done
  
  echo "   [2/5] Updating .docflow/scripts..."
  rm -rf .docflow/scripts
  mkdir -p .docflow/scripts
  for script in status-summary session-context stale-check; do
    download_file "${RAW_BASE}/.docflow/scripts/${script}.sh" ".docflow/scripts/${script}.sh"
  done
  chmod +x .docflow/scripts/*.sh
  
  echo "   [3/5] Updating .docflow/skills..."
  rm -rf .docflow/skills
  mkdir -p .docflow/skills/linear-workflow .docflow/skills/spec-templates .docflow/skills/docflow-commands
  download_file "${RAW_BASE}/.docflow/skills/linear-workflow/SKILL.md" ".docflow/skills/linear-workflow/SKILL.md"
  download_file "${RAW_BASE}/.docflow/skills/spec-templates/SKILL.md" ".docflow/skills/spec-templates/SKILL.md"
  download_file "${RAW_BASE}/.docflow/skills/docflow-commands/SKILL.md" ".docflow/skills/docflow-commands/SKILL.md"
  
  echo "   [4/5] Updating .docflow/templates..."
  rm -rf .docflow/templates
  mkdir -p .docflow/templates
  for template in feature bug chore idea quick-capture README; do
    download_file "${RAW_BASE}/.docflow/templates/${template}.md" ".docflow/templates/${template}.md"
  done
  
  echo "   [5/5] Updating Cursor rules..."
  for rule_dir in docflow-core pm-agent implementation-agent qe-agent linear-integration figma-integration session-awareness templates; do
    rm -rf ".cursor/rules/${rule_dir}"
    mkdir -p ".cursor/rules/${rule_dir}"
    download_file "${RAW_BASE}/.cursor/rules/${rule_dir}/RULE.md" ".cursor/rules/${rule_dir}/RULE.md"
  done
  
  # =====================================================
  # UPDATE OWNED FILES
  # =====================================================
  echo ""
  echo "   Updating commands..."
  mkdir -p .cursor/commands
  for cmd in activate attach block capture close docflow-setup docflow-update implement project-update refine review start-session status sync-project validate wrap-session; do
    download_file "${RAW_BASE}/.cursor/commands/${cmd}.md" ".cursor/commands/${cmd}.md"
  done
  
  echo "   Updating adapters..."
  mkdir -p .claude .warp .github
  download_file "${RAW_BASE}/.claude/rules.md" ".claude/rules.md"
  download_file "${RAW_BASE}/.warp/rules.md" ".warp/rules.md"
  download_file "${RAW_BASE}/.github/copilot-instructions.md" ".github/copilot-instructions.md"
  download_file "${RAW_BASE}/AGENTS.md" "AGENTS.md"
  download_file "${RAW_BASE}/WARP.md" "WARP.md"
  
  # =====================================================
  # UPDATE CONFIG (preserve project values)
  # =====================================================
  echo "   Updating config (preserving project settings)..."
  download_file "${RAW_BASE}/.docflow/config.json" ".docflow/config.json.new"
  
  if command -v python3 &> /dev/null; then
    python3 << EOF
import json

# Load new config
with open('.docflow/config.json.new', 'r') as f:
    config = json.load(f)

# Restore preserved values
config['provider']['teamId'] = '$TEAM_ID' if '$TEAM_ID' and '$TEAM_ID' != 'None' else None
config['provider']['projectId'] = '$PROJECT_ID' if '$PROJECT_ID' and '$PROJECT_ID' != 'None' else None
config['provider']['defaultMilestoneId'] = '$MILESTONE_ID' if '$MILESTONE_ID' and '$MILESTONE_ID' != 'None' else None
config['paths']['content'] = '$CONTENT_FOLDER'

with open('.docflow/config.json', 'w') as f:
    json.dump(config, f, indent=2)
    f.write('\n')
EOF
    rm .docflow/config.json.new
  else
    mv .docflow/config.json.new .docflow/config.json
    echo "   ⚠️  python3 not found - manually verify .docflow/config.json settings"
  fi
  
  # Update version
  echo "$DOCFLOW_VERSION" > .docflow/version
  
  # =====================================================
  # CLEANUP OLD FILES (from migrations)
  # =====================================================
  echo ""
  echo "   Checking for deprecated files..."
  
  OLD_FILES_FOUND=false
  FILES_TO_DELETE=()
  
  # Check for files removed in 4.0.0
  if [ -f ".docflow.json" ]; then
    OLD_FILES_FOUND=true
    FILES_TO_DELETE+=(".docflow.json")
  fi
  if [ -f ".cursor/rules/docflow.mdc" ]; then
    OLD_FILES_FOUND=true
    FILES_TO_DELETE+=(".cursor/rules/docflow.mdc")
  fi
  
  if [ "$OLD_FILES_FOUND" = true ]; then
    echo ""
    echo -e "${YELLOW}🧹 Found deprecated files:${NC}"
    for f in "${FILES_TO_DELETE[@]}"; do
      echo "   • $f"
    done
    echo ""
    read -p "   Delete these old files? (y/n): " DELETE_OLD
    
    if [[ $DELETE_OLD =~ ^[Yy]$ ]]; then
      for f in "${FILES_TO_DELETE[@]}"; do
        rm -f "$f"
        echo -e "   ${GREEN}✓ Deleted $f${NC}"
      done
    else
      echo "   ⏭ Kept old files"
    fi
  else
    echo "   ✓ No deprecated files found"
  fi
  
  # =====================================================
  # UPDATE COMPLETE
  # =====================================================
  echo ""
  echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${GREEN}║${NC}              ${CYAN}✅ UPDATE COMPLETE!${NC}                            ${GREEN}║${NC}"
  echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
  echo ""
  echo -e "   Project: ${CYAN}$TARGET_PATH${NC}"
  echo -e "   Version: ${YELLOW}$CURRENT_VERSION${NC} → ${GREEN}$DOCFLOW_VERSION${NC}"
  echo ""
  echo -e "${YELLOW}What's new in $DOCFLOW_VERSION:${NC}"
  echo "   • Milestone management for organizing work into phases"
  echo "   • Create milestones during project setup"
  echo "   • Assign issues to milestones during capture"
  echo "   • Priority/dependency workflow"
  echo "   • Smart 'what's next' recommendations"
  echo "   • Mandatory assignment for In Progress state"
  echo ""
  
  exit 0
fi

# =====================================================
# DETECT SCENARIO (Non-update mode)
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
  
  # Check if already has DocFlow Cloud - suggest update mode
  if [ -f "$TARGET_PATH/.docflow/version" ]; then
    CURRENT_VERSION=$(cat "$TARGET_PATH/.docflow/version" | tr -d '[:space:]')
    echo -e "   ${BLUE}Found: DocFlow Cloud v$CURRENT_VERSION${NC}"
    echo ""
    echo -e "   ${YELLOW}💡 TIP: Use --update flag for smarter updates:${NC}"
    echo "      curl -sSL [URL] | bash -s -- --update --path $TARGET_PATH"
    echo ""
    read -p "   Continue with full reinstall anyway? (y/n): " CONTINUE_INSTALL
    if [[ ! $CONTINUE_INSTALL =~ ^[Yy]$ ]]; then
      exit 0
    fi
  fi
  
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
  
  # Check for new .docflow/ folder or old .docflow.json
  if [ -f "$TARGET_PATH/.docflow/config.json" ]; then
    HAS_CLOUD_CONFIG=true
    CURRENT_MODE="cloud"
  elif [ -f "$TARGET_PATH/.docflow.json" ]; then
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

# =====================================================
# CONTENT FOLDER NAME (Cloud only)
# =====================================================
CONTENT_FOLDER="docflow"

if [ "$MODE" == "cloud" ]; then
  echo ""
  echo -e "${YELLOW}📁 Content Folder Name${NC}"
  echo ""
  echo "   DocFlow stores project context and knowledge in a folder."
  echo "   Default is 'docflow', but you can use 'docs' or another name."
  echo ""
  read -p "Content folder name [docflow]: " CUSTOM_CONTENT_FOLDER
  
  if [ -n "$CUSTOM_CONTENT_FOLDER" ]; then
    CONTENT_FOLDER="$CUSTOM_CONTENT_FOLDER"
  fi
  
  echo ""
  echo -e "   Using: ${CYAN}${CONTENT_FOLDER}/${NC}"
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
if [ "$MODE" == "cloud" ]; then
  echo "   Content:  $CONTENT_FOLDER/"
fi
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
# DOWNLOAD FUNCTION (using RAW_BASE)
# =====================================================
download_template_file() {
  local source="$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  download_file "${RAW_BASE}/${source}" "$dest"
}

echo ""
echo -e "${YELLOW}⬇️  Installing DocFlow ${MODE} files...${NC}"
echo ""

# =====================================================
# INSTALL CURSOR RULES & COMMANDS
# =====================================================
echo "   [1/7] Installing Cursor rules..."

if [ "$MODE" == "cloud" ]; then
  # New folder-based rules structure
  for rule_dir in docflow-core session-awareness pm-agent implementation-agent qe-agent linear-integration figma-integration templates; do
    mkdir -p ".cursor/rules/${rule_dir}"
    download_template_file ".cursor/rules/${rule_dir}/RULE.md" ".cursor/rules/${rule_dir}/RULE.md"
  done
else
  # Local mode uses single rule file (for now)
  mkdir -p .cursor/rules
  download_template_file ".cursor/rules/docflow.mdc" ".cursor/rules/docflow.mdc"
fi

echo "   [2/7] Installing commands..."
mkdir -p .cursor/commands

# Commands - common to both modes
for cmd in start-session wrap-session capture review activate implement validate close block status docflow-setup; do
  download_template_file ".cursor/commands/${cmd}.md" ".cursor/commands/${cmd}.md"
done

# Cloud-specific commands
if [ "$MODE" == "cloud" ]; then
  for cmd in docflow-update sync-project project-update attach refine; do
    download_template_file ".cursor/commands/${cmd}.md" ".cursor/commands/${cmd}.md"
  done
fi

# Platform adapters
echo "   [3/7] Installing platform adapters..."
mkdir -p .claude/commands .warp .github

download_template_file ".claude/rules.md" ".claude/rules.md"
download_template_file ".warp/rules.md" ".warp/rules.md"
download_template_file ".github/copilot-instructions.md" ".github/copilot-instructions.md"
download_template_file "AGENTS.md" "AGENTS.md"
download_template_file "WARP.md" "WARP.md"

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

# =====================================================
# INSTALL .docflow/ FRAMEWORK (Cloud) or docflow/specs (Local)
# =====================================================
if [ "$MODE" == "cloud" ]; then
  echo "   [4/7] Installing .docflow/ framework..."
  mkdir -p .docflow/templates .docflow/rules .docflow/scripts
  mkdir -p .docflow/skills/linear-workflow .docflow/skills/spec-templates .docflow/skills/docflow-commands
  
  # Download config, version
  download_template_file ".docflow/config.json" ".docflow/config.json"
  download_template_file ".docflow/version" ".docflow/version"
  
  # Download templates
  for template in README feature bug chore idea quick-capture; do
    download_template_file ".docflow/templates/${template}.md" ".docflow/templates/${template}.md"
  done
  
  # Download rules
  for rule in core linear-integration pm-agent implementation-agent qe-agent figma-integration session-awareness; do
    download_template_file ".docflow/rules/${rule}.md" ".docflow/rules/${rule}.md"
  done
  
  # Download scripts
  for script in status-summary session-context stale-check; do
    download_template_file ".docflow/scripts/${script}.sh" ".docflow/scripts/${script}.sh"
  done
  chmod +x .docflow/scripts/*.sh
  
  # Download skills
  download_template_file ".docflow/skills/linear-workflow/SKILL.md" ".docflow/skills/linear-workflow/SKILL.md"
  download_template_file ".docflow/skills/spec-templates/SKILL.md" ".docflow/skills/spec-templates/SKILL.md"
  download_template_file ".docflow/skills/docflow-commands/SKILL.md" ".docflow/skills/docflow-commands/SKILL.md"
  
  # Update content path in config if customized
  if [ "$CONTENT_FOLDER" != "docflow" ]; then
    if command -v sed &> /dev/null; then
      sed -i.bak "s/\"content\": \"docflow\"/\"content\": \"${CONTENT_FOLDER}\"/" .docflow/config.json
      rm -f .docflow/config.json.bak
    fi
  fi
  
  # Migrate from old .docflow.json if it exists
  if [ -f ".docflow.json" ]; then
    echo ""
    echo -e "   ${YELLOW}Found old .docflow.json - migrating settings...${NC}"
    
    if command -v python3 &> /dev/null; then
      OLD_TEAM_ID=$(python3 -c "import json; d=json.load(open('.docflow.json')); print(d.get('provider',{}).get('teamId',''))" 2>/dev/null)
      OLD_PROJECT_ID=$(python3 -c "import json; d=json.load(open('.docflow.json')); print(d.get('provider',{}).get('projectId',''))" 2>/dev/null)
      
      if [ -n "$OLD_TEAM_ID" ] && [ "$OLD_TEAM_ID" != "None" ]; then
        python3 -c "
import json
with open('.docflow/config.json', 'r') as f:
    config = json.load(f)
config['provider']['teamId'] = '$OLD_TEAM_ID'
config['provider']['projectId'] = '$OLD_PROJECT_ID' if '$OLD_PROJECT_ID' != 'None' else None
with open('.docflow/config.json', 'w') as f:
    json.dump(config, f, indent=2)
"
        echo -e "   ${GREEN}✓ Migrated Linear settings (teamId, projectId)${NC}"
      fi
    else
      echo "   ⚠️  python3 not found - manually copy teamId/projectId from .docflow.json to .docflow/config.json"
    fi
  fi

  echo "   ✓ .docflow/ framework installed"
else
  echo "   [4/7] Creating local specs structure..."
  mkdir -p docflow/specs/{templates,active,backlog,complete,assets}
fi

# =====================================================
# INSTALL CONTENT FOLDER
# =====================================================
echo "   [5/7] Creating content directory structure..."
mkdir -p "${CONTENT_FOLDER}/context"
mkdir -p "${CONTENT_FOLDER}/knowledge/{decisions,features,notes,product}"

# Context templates - only install if they don't exist or are empty
echo "   [6/7] Installing context templates..."
for ctx in overview stack standards; do
  if [ ! -f "${CONTENT_FOLDER}/context/${ctx}.md" ] || [ ! -s "${CONTENT_FOLDER}/context/${ctx}.md" ]; then
    download_template_file "docflow/context/${ctx}.md" "${CONTENT_FOLDER}/context/${ctx}.md"
  else
    echo "      ⏭ Preserving existing ${ctx}.md"
  fi
done

# Knowledge base files - only install if they don't exist
echo "   [7/7] Installing documentation..."
if [ ! -f "${CONTENT_FOLDER}/knowledge/INDEX.md" ]; then
  download_template_file "docflow/knowledge/INDEX.md" "${CONTENT_FOLDER}/knowledge/INDEX.md"
fi
if [ ! -f "${CONTENT_FOLDER}/knowledge/README.md" ]; then
  download_template_file "docflow/knowledge/README.md" "${CONTENT_FOLDER}/knowledge/README.md"
fi
if [ ! -f "${CONTENT_FOLDER}/knowledge/product/personas.md" ]; then
  download_template_file "docflow/knowledge/product/personas.md" "${CONTENT_FOLDER}/knowledge/product/personas.md"
fi
if [ ! -f "${CONTENT_FOLDER}/knowledge/product/user-flows.md" ]; then
  download_template_file "docflow/knowledge/product/user-flows.md" "${CONTENT_FOLDER}/knowledge/product/user-flows.md"
fi
download_template_file "docflow/README.md" "${CONTENT_FOLDER}/README.md"

# Local-specific files
if [ "$MODE" == "local" ]; then
  if [ ! -f "docflow/ACTIVE.md" ]; then
    download_template_file "docflow/ACTIVE.md" "docflow/ACTIVE.md"
  fi
  if [ ! -f "docflow/INDEX.md" ]; then
    download_template_file "docflow/INDEX.md" "docflow/INDEX.md"
  fi
  
  # Spec templates
  for template in feature bug chore idea README; do
    download_template_file "docflow/specs/templates/${template}.md" "docflow/specs/templates/${template}.md"
  done
fi

# Cloud-specific: Create environment files
if [ "$MODE" == "cloud" ]; then
  echo ""
  echo "   Creating environment files..."
  
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

  # Create .env and optionally add API key
  if [ ! -f ".env" ]; then
    cp .env.example .env
    echo "   ✓ .env created"
    
    echo ""
    echo -e "${YELLOW}🔑 Linear API Key Setup${NC}"
    echo ""
    echo "   Would you like to add your Linear API key now?"
    echo "   (Get from: Linear → Settings → API → Personal API Keys)"
    echo ""
    read -p "   Add API key now? (y/n): " ADD_KEY
    
    if [[ $ADD_KEY =~ ^[Yy]$ ]]; then
      echo ""
      echo "   Paste your Linear API key (input hidden for security):"
      read -s LINEAR_KEY
      echo ""
      
      if [ -n "$LINEAR_KEY" ]; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
          sed -i '' "s/^LINEAR_API_KEY=.*/LINEAR_API_KEY=${LINEAR_KEY}/" .env
        else
          sed -i "s/^LINEAR_API_KEY=.*/LINEAR_API_KEY=${LINEAR_KEY}/" .env
        fi
        echo -e "   ${GREEN}✓ API key saved to .env${NC}"
      else
        echo "   ⏭ No key entered, you can add it later"
      fi
    else
      echo "   ⏭ Skipped - add your key to .env before running /docflow-setup"
    fi
  else
    echo "   ⏭ .env already exists"
  fi
fi

# Update .gitignore
echo ""
echo "   Updating .gitignore..."

GITIGNORE_ADDITIONS=""

if [ "$MODE" == "cloud" ]; then
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
docflow/specs-archived*
${CONTENT_FOLDER}/specs-archived*"
    fi
    
    if [ -n "$GITIGNORE_ADDITIONS" ]; then
      echo "$GITIGNORE_ADDITIONS" >> .gitignore
      echo "   ✓ .gitignore updated"
    else
      echo "   ⏭ .gitignore already configured"
    fi
  else
    cat > .gitignore << EOF
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
${CONTENT_FOLDER}/specs-archived*
EOF
    echo "   ✓ .gitignore created"
  fi
else
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
# CLEANUP OLD FILES (Cloud mode only)
# =====================================================
if [ "$MODE" == "cloud" ]; then
  OLD_FILES_FOUND=false
  
  if [ -f ".docflow.json" ] || [ -f ".cursor/rules/docflow.mdc" ]; then
    OLD_FILES_FOUND=true
    echo ""
    echo -e "${YELLOW}🧹 Cleanup: Old DocFlow files detected${NC}"
    echo ""
    
    if [ -f ".docflow.json" ]; then
      echo "   • .docflow.json (old config - migrated to .docflow/config.json)"
    fi
    if [ -f ".cursor/rules/docflow.mdc" ]; then
      echo "   • .cursor/rules/docflow.mdc (old rules - replaced by folder structure)"
    fi
    
    echo ""
    read -p "   Delete these old files? (y/n): " DELETE_OLD
    
    if [[ $DELETE_OLD =~ ^[Yy]$ ]]; then
      if [ -f ".docflow.json" ]; then
        rm ".docflow.json"
        echo -e "   ${GREEN}✓ Deleted .docflow.json${NC}"
      fi
      if [ -f ".cursor/rules/docflow.mdc" ]; then
        rm ".cursor/rules/docflow.mdc"
        echo -e "   ${GREEN}✓ Deleted docflow.mdc${NC}"
      fi
    else
      echo "   ⏭ Kept old files (you can delete them manually later)"
    fi
  fi
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
if [ "$MODE" == "cloud" ]; then
  echo -e "   Content folder: ${CYAN}${CONTENT_FOLDER}/${NC}"
fi
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
  echo -e "   ${YELLOW}💡 Future updates:${NC}"
  echo "      curl -sSL [URL] | bash -s -- --update --path $TARGET_PATH"
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
