#!/bin/bash

# Aurelius - SpecMethodDevLite - Project Initializer / Updater
# Usage: ./init-or-update-project.sh <path-to-target-project> [mode]
# Mode: commands | agent | hybrid (default)

if [ -z "$1" ]; then
    echo "Usage: $0 <path-to-target-project> [mode]"
    exit 1
fi

TARGET_DIR=$1
INSTALL_MODE=${2:-"hybrid"}
SOURCE_DIR=$(dirname "$(readlink -f "$0")")

echo "--- Aurelius Framework Setup ---"
echo "Source: $SOURCE_DIR"
echo "Target: $TARGET_DIR"
echo "Mode:   $INSTALL_MODE"

# 1. Ensure Target Directories exist
mkdir -p "$TARGET_DIR/.gemini"
mkdir -p "$TARGET_DIR/.gemini/settings"
mkdir -p "$TARGET_DIR/.gemini/skills"
mkdir -p "$TARGET_DIR/.gemini/agents"
mkdir -p "$TARGET_DIR/.gemini/commands/aurelius"
mkdir -p "$TARGET_DIR/.gemini/commands/aurelius/specific"
mkdir -p "$TARGET_DIR/.gemini/policies"
mkdir -p "$TARGET_DIR/.gemini/hooks"
mkdir -p "$TARGET_DIR/devlog"
mkdir -p "$TARGET_DIR/templates"
mkdir -p "$TARGET_DIR/specs/diagrams"
mkdir -p "$TARGET_DIR/backlog/TODO"
mkdir -p "$TARGET_DIR/backlog/WIP"
mkdir -p "$TARGET_DIR/backlog/DONE"

# 2. Update Configuration (Force Overwrite)
echo "Updating configuration..."

# Skills are always needed as they are the core logic
cp -rf "$SOURCE_DIR/.gemini/skills/"* "$TARGET_DIR/.gemini/skills/"

# Agents
if [[ "$INSTALL_MODE" == "hybrid" || "$INSTALL_MODE" == "agent" ]]; then
    echo "Installing Agents..."
    cp -rf "$SOURCE_DIR/.gemini/agents/"* "$TARGET_DIR/.gemini/agents/"
fi

# Commands
if [[ "$INSTALL_MODE" == "hybrid" || "$INSTALL_MODE" == "commands" ]]; then
    echo "Installing Commands..."
    # Update command files directly, skipping directories (like 'specific/') to preserve user customizations
    cp -f "$SOURCE_DIR/.gemini/commands/aurelius/"* "$TARGET_DIR/.gemini/commands/aurelius/" 2>/dev/null || true
fi

cp -rf "$SOURCE_DIR/.gemini/hooks/"* "$TARGET_DIR/.gemini/hooks/"
cp -rf "$SOURCE_DIR/templates/"* "$TARGET_DIR/templates/"


# 3. Bootstrap Specs & Local Instructions (Copy only if not existing)
echo "Checking for initial specification and local instruction files..."

# Function to copy template if file doesn't exist
init_file() {
    local src=$1
    local dest=$2
    if [ ! -f "$TARGET_DIR/$dest" ]; then
        echo "Initializing $dest..."
        cp "$SOURCE_DIR/$src" "$TARGET_DIR/$dest"
    else
        echo "Skipping $dest (already exists)."
    fi
}

init_file ".gemini/settings.json" ".gemini/settings.json"
init_file ".gemini/policies/aurelius-tools.toml" ".gemini/policies/aurelius-tools.toml"

# Local instruction placeholders (to avoid injection errors)
init_file ".gemini/commands/aurelius/specific/analyze.md" ".gemini/commands/aurelius/specific/analyze.md"
init_file ".gemini/commands/aurelius/specific/dev-ticket.md" ".gemini/commands/aurelius/specific/dev-ticket.md"
init_file ".gemini/commands/aurelius/specific/finalize-ticket.md" ".gemini/commands/aurelius/specific/finalize-ticket.md"
init_file ".gemini/commands/aurelius/specific/gen-tickets.md" ".gemini/commands/aurelius/specific/gen-tickets.md"
init_file ".gemini/commands/aurelius/specific/groom-ticket.md" ".gemini/commands/aurelius/specific/groom-ticket.md"
init_file ".gemini/commands/aurelius/specific/bootstrap-specs.md" ".gemini/commands/aurelius/specific/bootstrap-specs.md"
init_file ".gemini/commands/aurelius/specific/design.md" ".gemini/commands/aurelius/specific/design.md"
init_file ".gemini/commands/aurelius/specific/triage.md" ".gemini/commands/aurelius/specific/triage.md"

init_file "templates/product-context-template.md" "specs/productContext.md"
init_file "templates/context-map-template.md" "specs/context-map.md"
init_file "templates/prd-template.md" "specs/01-PRD.md"
init_file "templates/ux-template.md" "specs/02-UX-DESIGN.md"
init_file "templates/architecture-template.md" "specs/03-ARCHITECTURE.md"
init_file "templates/epics-template.md" "specs/04-EPICS.md"
init_file "templates/user-story-template.md" "backlog/template-us.md"

# 4. Empty placeholder files
if [ ! -f "$TARGET_DIR/specs/00-BRIEF.md" ]; then touch "$TARGET_DIR/specs/00-BRIEF.md"; fi
if [ ! -f "$TARGET_DIR/specs/04-EPICS.md" ]; then touch "$TARGET_DIR/specs/04-EPICS.md"; fi

echo ""
echo "Done! Project in $TARGET_DIR is now using Aurelius (SpecMethodDevLite)."
echo "Next steps:"
echo "  1. Go to your project: cd $TARGET_DIR"
echo "  2. Use 'gemini aurelius:bootstrap-specs' to start a new project."
echo "  3. Use 'gemini aurelius:analyze <issue-url>' to automate a feature implementation."