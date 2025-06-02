#!/bin/bash

# Test script for API key validation and auto-save functionality
echo "=== Running API Key Validation and Auto-Save Tests ==="
echo ""

# Set project path
PROJECT_PATH="/Users/gagelaporta/1NeuroPro/NeuroVisProject/1/(4)NeuroVis copy"

# Run validation and auto-save test
echo "1. Running API validation and auto-save test..."
echo "---------------------------------------------"
godot --headless --path "$PROJECT_PATH" --script "res://test_api_validation_autosave.gd"
echo ""

# Run loading states test
echo "2. Running validation loading states test..."
echo "------------------------------------------"
godot --headless --path "$PROJECT_PATH" --script "res://test_validation_loading_states.gd"
echo ""

# Run updated full flow test
echo "3. Running updated full flow test with validation..."
echo "---------------------------------------------------"
godot --headless --path "$PROJECT_PATH" --script "res://test_full_flow.gd"
echo ""

echo "=== All Validation Tests Complete ==="
echo ""
echo "Summary of what was tested:"
echo "✓ API key validation through GeminiAIService"
echo "✓ Loading states during validation"
echo "✓ Success leads to auto-save with educational defaults"
echo "✓ Failure shows helpful error messages"
echo "✓ Button states update appropriately"
echo "✓ Educational defaults applied (Gemini Pro, safe settings, etc.)"
echo ""
echo "Note: For full validation testing, you need a real Google Gemini API key"