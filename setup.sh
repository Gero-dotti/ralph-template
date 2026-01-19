#!/bin/bash

# Ralph Playbook - Setup Script
# Copies template files to a target project

set -e

TARGET_DIR="${1:-.}"

if [[ "$TARGET_DIR" == "--help" || "$TARGET_DIR" == "-h" ]]; then
    echo "Ralph Playbook - Setup Script"
    echo ""
    echo "Usage: ./setup.sh [TARGET_DIRECTORY]"
    echo ""
    echo "Copies Ralph Playbook files to the target directory."
    echo "If no directory specified, copies to current directory."
    echo ""
    echo "Examples:"
    echo "  ./setup.sh /path/to/my-project"
    echo "  ./setup.sh ."
    echo "  cd /my-project && /path/to/ralph-template/setup.sh"
    exit 0
fi

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Resolve target directory to absolute path
TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd)" || {
    echo "Error: Target directory does not exist: $1"
    exit 1
}

echo "Ralph Playbook Setup"
echo "===================="
echo ""
echo "Source: $SCRIPT_DIR"
echo "Target: $TARGET_DIR"
echo ""

# Files to copy
FILES=(
    "loop.sh"
    "PROMPT_plan.md"
    "PROMPT_build.md"
    "AGENTS.md"
    "IMPLEMENTATION_PLAN.md"
)

# Copy main files
for file in "${FILES[@]}"; do
    if [[ -f "$TARGET_DIR/$file" ]]; then
        echo "  [skip] $file (already exists)"
    else
        cp "$SCRIPT_DIR/$file" "$TARGET_DIR/$file"
        echo "  [copy] $file"
    fi
done

# Copy specs directory
if [[ -d "$TARGET_DIR/specs" ]]; then
    echo "  [skip] specs/ (already exists)"
else
    cp -r "$SCRIPT_DIR/specs" "$TARGET_DIR/specs"
    echo "  [copy] specs/"
fi

# Make scripts executable
chmod +x "$TARGET_DIR/loop.sh"

echo ""
echo "Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Edit AGENTS.md with your project-specific info"
echo "  2. Write requirement specs in specs/"
echo "  3. Run ./loop.sh plan to generate implementation plan"
echo "  4. Run ./loop.sh build to start implementing"
echo ""
