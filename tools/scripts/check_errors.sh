#!/bin/bash
echo "🔍 Quick Parser Error Check"
echo "=========================="

# Use the full path to the Godot executable
GODOT_PATH="/Applications/Godot.app/Contents/MacOS/Godot"

# Path is now hardcoded in the script

# Run the error detection script
./scripts/ci/detect_parser_errors.sh
