#!/bin/bash

# Validate Godot 4 Syntax Script
# This script checks the entire codebase for Godot 3 syntax patterns

echo "🔍 Validating Godot 4 syntax compliance..."
echo "========================================="

# Try to find Godot in common locations
GODOT_PATHS=(
    "/Applications/Godot.app/Contents/MacOS/Godot"
    "/Applications/Godot_4.4.1.app/Contents/MacOS/Godot"
    "/Applications/Godot_v4.4.1-stable_macos.universal.app/Contents/MacOS/Godot"
    "/Applications/Godot_v4.4-stable_macos.universal.app/Contents/MacOS/Godot"
    "/usr/local/bin/godot"
    "/opt/homebrew/bin/godot"
    "$(which godot 2>/dev/null)"
)

GODOT_EXEC=""

# First try to resolve aliases if godot is in PATH
if command -v godot >/dev/null 2>&1; then
    GODOT_FROM_PATH=$(command -v godot)
    if [ -x "$GODOT_FROM_PATH" ]; then
        GODOT_EXEC="$GODOT_FROM_PATH"
    fi
fi

# If not found via command, try the predefined paths
if [ -z "$GODOT_EXEC" ]; then
    for path in "${GODOT_PATHS[@]}"; do
        if [ -n "$path" ] && [ -x "$path" ]; then
            GODOT_EXEC="$path"
            break
        fi
    done
fi

if [ -z "$GODOT_EXEC" ]; then
    echo "❌ Godot executable not found!"
    echo "Please install Godot 4.4+ or add it to your PATH"
    echo ""
    echo "Common locations to check:"
    echo "  - /Applications/Godot.app/Contents/MacOS/Godot"
    echo "  - Install via: brew install godot"
    echo ""
    exit 1
fi

echo "📍 Using Godot at: $GODOT_EXEC"
echo ""

# Get the directory of this script to ensure we're in the right project
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Run the validation using Godot
"$GODOT_EXEC" --headless --path . --script res://tools/scripts/validate_godot4_syntax.gd --quit

# Check exit code
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ All code follows Godot 4 conventions!"
    exit 0
else
    echo ""
    echo "❌ Found Godot 3 syntax patterns that need to be updated."
    echo "Please fix the issues listed above."
    exit 1
fi

