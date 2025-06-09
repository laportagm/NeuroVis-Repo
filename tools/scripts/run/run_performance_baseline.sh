#!/bin/bash

# Run Performance Baseline Test for NeuroVis
# This establishes performance benchmarks for the educational platform

echo "==================================="
echo "NeuroVis Performance Baseline Test"
echo "==================================="
echo ""
echo "This test will measure:"
echo "  • Scene loading times"
echo "  • 3D model rendering performance"
echo "  • UI responsiveness"
echo "  • Memory usage patterns"
echo ""
echo "Target: 60fps for educational experience"
echo ""

# Find Godot executable
GODOT_PATH="/Applications/Godot.app/Contents/MacOS/Godot"

if [ ! -f "$GODOT_PATH" ]; then
    echo "❌ Error: Godot not found at $GODOT_PATH"
    echo "Please update the path in this script"
    exit 1
fi

echo "Using Godot at: $GODOT_PATH"
echo ""

# Run the performance baseline test
echo "Starting performance test..."
"$GODOT_PATH" --headless --script tools/scripts/performance_baseline.gd

echo ""
echo "Test complete! Check user://performance_baseline.json for detailed results."
