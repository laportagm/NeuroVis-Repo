#!/bin/bash

# Comprehensive Godot 4 Syntax Fixer
# This script automatically fixes all Godot 3 syntax patterns found by the validator

echo "🔧 Comprehensive Godot 4 Syntax Fixer"
echo "====================================="
echo ""

# Check if Python 3 is available
if ! command -v python3 >/dev/null 2>&1; then
    echo "❌ Python 3 is required but not installed."
    echo "Please install Python 3 and try again."
    exit 1
fi

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "📍 Working directory: $(pwd)"
echo ""

# Ask for confirmation
echo "⚠️  This will automatically fix Godot 3 syntax in ALL .gd files."
echo "   A backup will be created before making any changes."
echo ""
read -p "Do you want to continue? (y/N): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Operation cancelled."
    exit 0
fi

echo ""

# Run the Python fixer
python3 fix_godot4_syntax_comprehensive.py

# Check the exit code
if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 Syntax fixing completed successfully!"
    echo ""
    echo "🔍 Running validation to check results..."
    echo ""
    
    # Run validation if the script exists
    if [ -f "validate_godot4_syntax_fixed.sh" ]; then
        ./validate_godot4_syntax_fixed.sh
    else
        echo "⚠️  Validation script not found. Please run validation manually."
    fi
else
    echo ""
    echo "❌ Syntax fixing failed. Please check the error messages above."
    exit 1
fi