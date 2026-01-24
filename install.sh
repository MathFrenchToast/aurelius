#!/bin/bash

# SpecMethodDevLite Installer
# Copies the .gemini configuration and templates to the current directory.

echo "Installing SpecMethodDevLite..."

# Create directories
mkdir -p .gemini/skills
mkdir -p .gemini/commands
mkdir -p templates

# Note: In a real distribution, files would be copied from a source.
# Here we verify the structure created by the generative kit.

echo "Checking .gemini/skills/..."
ls .gemini/skills/

echo "Checking .gemini/commands/..."
ls .gemini/commands/

echo "Checking templates/..."
ls templates/

echo ""
echo "Installation structure:"
echo "- .gemini/skills/: Contains personas (PM, PO, Arch, Dev, etc.)"
echo "- .gemini/commands/: Contains workflows (1-init, 2-bootstrap, etc.)"
echo "- templates/: Contains MD templates (Context, PRD, US)"

echo ""
echo "Setup complete. Start with:"
echo "  1. gemini 1-init"
echo "  2. gemini 2-bootstrap-specs --concept 'My App Idea'"