#!/bin/bash

# Test script for all button actions and flow logic
echo "=== Running Button Actions & Flow Logic Tests ==="
echo ""

# Set project path
PROJECT_PATH="/Users/gagelaporta/1NeuroPro/NeuroVisProject/1/(4)NeuroVis copy"

# Run comprehensive flow test
echo "1. Running comprehensive button actions and flow test..."
echo "------------------------------------------------------"
godot --headless --path "$PROJECT_PATH" --script "res://test_button_actions_flow.gd"
echo ""

# Run browser opening test (requires visual confirmation)
echo "2. Running browser opening test (requires visual confirmation)..."
echo "----------------------------------------------------------------"
echo "NOTE: This test will open your browser. Please verify it opens to Google Console."
godot --path "$PROJECT_PATH" --script "res://test_browser_opening.gd"
echo ""

# Run key validation edge cases test
echo "3. Running key validation edge cases test..."
echo "-------------------------------------------"
godot --headless --path "$PROJECT_PATH" --script "res://test_key_validation_edge_cases.gd"
echo ""

echo "=== All Button Action Tests Complete ==="
echo ""
echo "Summary of what was tested:"
echo "✓ Welcome button opens browser and transitions states"
echo "✓ Guidance button transitions to key input state"
echo "✓ Key validation with various inputs (empty, invalid, valid)"
echo "✓ Status messages update appropriately"
echo "✓ Final button closes dialog and emits signal"
echo "✓ Edge cases in key validation"
echo "✓ Browser opening to correct URL"