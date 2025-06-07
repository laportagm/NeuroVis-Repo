#\!/bin/bash

# Test script for Gemini integration and setup dialog
# This script launches Godot to test the GeminiSetupDialog functionality

echo "=== Running Gemini Integration Test ==="
echo "Testing GeminiSetupDialog and GeminiAIService integration"
echo ""

# Set project path
PROJECT_PATH="/Users/gagelaporta/1NeuroPro/NeuroVisProject/1/(4)NeuroVis copy"

# Check if Godot is available
if \! command -v godot &> /dev/null; then
    echo "Error: Godot not found in PATH"
    echo "Please ensure Godot is installed and accessible"
    exit 1
fi

# Run the test scene
echo "Launching test scene..."
godot --path "$PROJECT_PATH" --scene "res://tests/integration/test_gemini_setup_dialog.tscn" --quit --headless

# Alternative: Run as script if scene doesn't work
if [ $? -ne 0 ]; then
    echo ""
    echo "Scene test failed, trying script mode..."
    godot --path "$PROJECT_PATH" --script "res://tests/integration/test_gemini_setup_dialog.gd" --quit --headless
fi

echo ""
echo "=== Test Complete ==="
echo "Check the output above for test results"
EOF < /dev/null