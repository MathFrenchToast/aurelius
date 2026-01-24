#!/bin/bash

# Aurelius - SpecMethodDevLite - Project Initializer / Updater
# Usage: ./init-or-update-project.sh <path-to-target-project>

if [ -z "$1" ]; then
    echo "Usage: $0 <path-to-target-project>"
    exit 1
fi

TARGET_DIR=$1
SOURCE_DIR=$(dirname "$(readlink -f "$0")")

echo "--- Aurelius Framework Setup ---"
echo "Source: $SOURCE_DIR"
echo "Target: $TARGET_DIR"

# 1. Ensure Target Directories exist
mkdir -p "$TARGET_DIR/.gemini/skills"
mkdir -p "$TARGET_DIR/.gemini/commands/aurelius"
mkdir -p "$TARGET_DIR/.gemini/policies"
mkdir -p "$TARGET_DIR/templates"
mkdir -p "$TARGET_DIR/specs/diagrams"
mkdir -p "$TARGET_DIR/backlog/TODO"
mkdir -p "$TARGET_DIR/backlog/WIP"
mkdir -p "$TARGET_DIR/backlog/DONE"

# 2. Update Config, Skills & Policies (Force Overwrite)
echo "Updating configuration, skills and policies..."
cp -rf "$SOURCE_DIR/.gemini/skills/"* "$TARGET_DIR/.gemini/skills/"
cp -rf "$SOURCE_DIR/.gemini/commands/aurelius/"* "$TARGET_DIR/.gemini/commands/aurelius/"
cp -rf "$SOURCE_DIR/.gemini/policies/"* "$TARGET_DIR/.gemini/policies/"
cp -rf "$SOURCE_DIR/templates/"* "$TARGET_DIR/templates/"

# 3. Bootstrap Specs (Copy only if not existing)
echo "Checking for initial specification files..."

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
echo "  2. Use 'gemini aurelius:bootstrap-specs' to start."