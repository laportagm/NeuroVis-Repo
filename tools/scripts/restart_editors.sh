#!/bin/bash

echo "Restarting editors to clear stale cache..."
echo "=========================================="

# Kill any running Godot instances
echo "Closing Godot editor instances..."
pkill -f "Godot" 2>/dev/null || echo "No Godot instances found"

# Kill VS Code instances
echo "Closing VS Code instances..."
pkill -f "Code" 2>/dev/null || echo "No VS Code instances found"

# Give processes time to close
sleep 2

# Clear any lock files
echo "Clearing any lock files..."
find . -name "*.lock" -o -name ".lock" | grep -v ".git" | xargs rm -f 2>/dev/null

# Clear VS Code workspace storage
echo "Clearing VS Code workspace storage..."
rm -rf ~/Library/Application\ Support/Code/User/workspaceStorage/*neurovis* 2>/dev/null

# Wait a moment
sleep 1

# Reopen VS Code with the project
echo "Reopening VS Code..."
if command -v code &> /dev/null; then
    code . &
    echo "VS Code reopened"
else
    echo "VS Code command not found in PATH"
fi

# Open Godot with the project
echo "Opening Godot with the project..."
if [ -f "/Applications/Godot.app/Contents/MacOS/Godot" ]; then
    /Applications/Godot.app/Contents/MacOS/Godot --editor --path . &
    echo "Godot editor opened"
elif command -v godot &> /dev/null; then
    godot --editor --path . &
    echo "Godot editor opened"
else
    echo "Godot not found. Please open it manually."
fi

echo ""
echo "=========================================="
echo "Editors restarted!"
echo ""
echo "The stale error messages about:"
echo "  /ui/components/controls/AccessibilityManager.gd"
echo "should now be gone."
echo ""
echo "The correct file locations are:"
echo "  ✓ AccessibilityManager.gd -> core/systems/"
echo "  ✓ SafeAutoloadAccess.gd -> ui/components/core/"
