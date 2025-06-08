#!/bin/bash

# Verify all NeuroVis autoload services
echo "======================================"
echo "NeuroVis Autoload Verification"
echo "======================================"
echo ""

# Find Godot
GODOT_PATH="/Applications/Godot.app/Contents/MacOS/Godot"

if [ ! -f "$GODOT_PATH" ]; then
    echo "❌ Error: Godot not found at $GODOT_PATH"
    exit 1
fi

# Run verification
"$GODOT_PATH" --headless --script tools/scripts/verify_autoloads.gd

exit $?
