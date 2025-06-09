#!/bin/bash

# Optimize 3D Rendering for NeuroVis
echo "======================================="
echo "NeuroVis 3D Rendering Optimization"
echo "======================================="
echo ""
echo "This will apply performance optimizations to achieve 60fps"
echo "Current performance: ~10fps → Target: 60fps"
echo ""

# Find Godot
GODOT_PATH="/Applications/Godot.app/Contents/MacOS/Godot"

if [ ! -f "$GODOT_PATH" ]; then
    echo "❌ Error: Godot not found at $GODOT_PATH"
    exit 1
fi

# Run optimization
echo "Applying optimizations..."
"$GODOT_PATH" --headless --script tools/scripts/optimize_3d_rendering.gd

echo ""
echo "✅ Optimizations complete!"
echo ""
echo "Next steps:"
echo "1. Run ./run_performance_baseline.sh to verify improvements"
echo "2. Launch the project to test visual quality"
echo "3. Adjust settings in user://rendering_optimizations.cfg if needed"
