#!/bin/bash

# Apply Aggressive Optimizations for 60fps
echo "======================================="
echo "NeuroVis Aggressive Optimization"
echo "======================================="
echo ""
echo "WARNING: This will apply aggressive settings that may reduce visual quality"
echo "         but should achieve 60fps target performance."
echo ""
echo "Press Ctrl+C to cancel, or wait 3 seconds to continue..."
sleep 3

# Find Godot
GODOT_PATH="/Applications/Godot.app/Contents/MacOS/Godot"

if [ ! -f "$GODOT_PATH" ]; then
    echo "❌ Error: Godot not found at $GODOT_PATH"
    exit 1
fi

# Run aggressive optimization
echo ""
echo "Applying aggressive optimizations..."
"$GODOT_PATH" --path . --script tools/scripts/apply_aggressive_optimizations.gd

echo ""
echo "✅ Optimizations applied!"
echo ""
echo "The main scene should now run at 60fps."
echo "To test: godot scenes/main/node_3d.tscn"
