#!/bin/bash
# Enable Core Development Mode for NeuroVis

echo "🔧 Enabling NeuroVis Core Development Mode..."
echo ""

# Set Godot path (update this to your Godot installation)
GODOT_PATH="/Applications/Godot.app/Contents/MacOS/Godot"

# Check if Godot exists
if [ ! -f "$GODOT_PATH" ]; then
    echo "❌ Error: Godot not found at $GODOT_PATH"
    echo "Please update GODOT_PATH in this script"
    exit 1
fi

# Run the enable script
"$GODOT_PATH" --headless --path "$(pwd)" --script enable_core_development_mode.gd

echo ""
echo "✅ Core Development Mode Enabled!"
echo ""
echo "You can now run the project with simplified systems for core development."
echo ""
echo "To disable, run: ./disable_core_dev.sh"