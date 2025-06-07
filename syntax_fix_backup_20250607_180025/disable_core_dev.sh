#!/bin/bash
# Disable Core Development Mode for NeuroVis

echo "🔧 Disabling NeuroVis Core Development Mode..."
echo ""

# Set Godot path (update this to your Godot installation)
GODOT_PATH="/Applications/Godot.app/Contents/MacOS/Godot"

# Check if Godot exists
if [ ! -f "$GODOT_PATH" ]; then
    echo "❌ Error: Godot not found at $GODOT_PATH"
    echo "Please update GODOT_PATH in this script"
    exit 1
fi

# Run the disable script
"$GODOT_PATH" --headless --path "$(pwd)" --script disable_core_development_mode.gd

echo ""
echo "✅ Core Development Mode Disabled!"
echo ""
echo "Full functionality has been restored."
echo ""
echo "To re-enable, run: ./enable_core_dev.sh"