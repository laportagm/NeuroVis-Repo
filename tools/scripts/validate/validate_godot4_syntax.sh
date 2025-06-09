#!/bin/bash

# Validate Godot 4 Syntax Script
# This script checks the entire codebase for Godot 3 syntax patterns

echo "🔍 Validating Godot 4 syntax compliance..."
echo "========================================="

# Run the validation using Godot
godot --headless --script res://tools/scripts/validate_godot4_syntax.gd --quit

# Check exit code
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ All code follows Godot 4 conventions!"
    exit 0
else
    echo ""
    echo "❌ Found Godot 3 syntax patterns that need to be updated."
    echo "Please fix the issues listed above."
    exit 1
fi