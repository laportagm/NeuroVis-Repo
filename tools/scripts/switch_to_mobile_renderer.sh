#!/bin/bash

# Switch to Mobile Renderer for Better Performance
echo "======================================="
echo "NeuroVis Mobile Renderer Switch"
echo "======================================="
echo ""
echo "This will switch to the mobile renderer for 2-3x performance improvement."
echo "Note: Some visual effects will be reduced."
echo ""

# Find Godot
GODOT_PATH="/Applications/Godot.app/Contents/MacOS/Godot"

if [ ! -f "$GODOT_PATH" ]; then
    echo "❌ Error: Godot not found at $GODOT_PATH"
    exit 1
fi

# Generate LOD configurations first
echo "1. Generating LOD configurations..."
"$GODOT_PATH" --headless --script tools/scripts/generate_lod_models.gd

# Switch to mobile renderer
echo ""
echo "2. Switching to mobile renderer..."
"$GODOT_PATH" --headless --script tools/scripts/switch_to_mobile_renderer.gd

echo ""
echo "✅ Mobile renderer configured!"
echo ""
echo "IMPORTANT: You must restart Godot for the renderer change to take effect."
echo ""
echo "After restarting:"
echo "1. Run ./run_performance_baseline.sh to verify improvements"
echo "2. The app should now run at 30-60 FPS"
echo "3. Dynamic quality adjustment will maintain stable performance"
