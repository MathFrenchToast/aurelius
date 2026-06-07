#!/bin/bash

# Aurelius - SpecMethodDevLite - Project Initializer / Updater (Antigravity CLI Version)
# Usage: ./init-or-update-project.sh <path-to-target-project>

if [ -z "$1" ]; then
    echo "Usage: $0 <path-to-target-project>"
    exit 1
fi

TARGET_DIR=$1
SOURCE_DIR=$(dirname "$(readlink -f "$0")")

echo "--- Aurelius Framework Setup (Antigravity CLI) ---"
echo "Source: $SOURCE_DIR"
echo "Target: $TARGET_DIR"

# 1. Ensure Target Directories exist
mkdir -p "$TARGET_DIR/.agent"
mkdir -p "$TARGET_DIR/.agent/skills"
mkdir -p "$TARGET_DIR/.agent/policies"
mkdir -p "$TARGET_DIR/.agent/hooks"
mkdir -p "$TARGET_DIR/devlog"
mkdir -p "$TARGET_DIR/templates"
mkdir -p "$TARGET_DIR/specs/diagrams"
mkdir -p "$TARGET_DIR/backlog/TODO"
mkdir -p "$TARGET_DIR/backlog/WIP"
mkdir -p "$TARGET_DIR/backlog/DONE"

# 2. Update Skills, Policies & Hooks (Force Overwrite)
echo "Updating skills and hooks..."
cp -rf "$SOURCE_DIR/.agent/skills/"* "$TARGET_DIR/.agent/skills/"
cp -rf "$SOURCE_DIR/.agent/hooks/"* "$TARGET_DIR/.agent/hooks/"
cp -rf "$SOURCE_DIR/templates/"* "$TARGET_DIR/templates/"


# 3. Bootstrap Settings, Policies, Specs & Local Instructions (Copy only if not existing)
echo "Checking for configuration and initial specification files..."

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

init_file ".agent/settings.json" ".agent/settings.json"
init_file ".agent/mcp_config.json" ".agent/mcp_config.json"
init_file ".agent/policies/aurelius-tools.toml" ".agent/policies/aurelius-tools.toml"

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
echo "Done! Project in $TARGET_DIR is now using Aurelius (SpecMethodDevLite) for Antigravity."
echo "Next steps:"
echo "  1. Go to your project: cd $TARGET_DIR"
echo "  2. Use '@bootstrap-specs' to start a new project."
echo "  3. Use '@analyze <issue-url>' to automate a feature implementation."