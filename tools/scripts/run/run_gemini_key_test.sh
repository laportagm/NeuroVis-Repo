#!/bin/bash
# Run automated test of GeminiSetupDialog with API key

echo "Running Gemini Setup Dialog test with API key..."
echo "This will automatically fill in the provided API key and test validation."

cd "/Users/gagelaporta/1NeuroPro/NeuroVisProject/1/(4)NeuroVis copy"

godot --headless --script res://test_gemini_with_key.gd 2>&1 | tee gemini_test_output.log

echo "Test completed. Check gemini_test_output.log for details."