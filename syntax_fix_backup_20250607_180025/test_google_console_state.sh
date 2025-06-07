#!/bin/bash

# Test script for Google Console guidance state
echo "=== Testing Google Console Guidance State ==="
echo ""

# Set project path
PROJECT_PATH="/Users/gagelaporta/1NeuroPro/NeuroVisProject/1/(4)NeuroVis copy"

# Run the test
echo "Launching Google Console state test..."
godot --path "$PROJECT_PATH" --script "res://test_google_console_state.gd"

echo ""
echo "=== Test Complete ==="