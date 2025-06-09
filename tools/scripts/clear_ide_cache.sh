#!/bin/bash

echo "Clearing IDE cache and fixing references..."

# Clear Godot cache if it exists
if [ -d ".godot" ]; then
    echo "Clearing Godot cache..."
    rm -rf .godot/editor/script_editor_cache.cfg
    rm -rf .godot/editor/filesystem_cache*
    rm -rf .godot/editor/filesystem_update*
    rm -rf .godot/editor/recent_dirs
    rm -rf .godot/imported/*.tmp
    echo "Godot cache cleared."
else
    echo "No .godot directory found (will be created when project opens in Godot)."
fi

# Clear VS Code workspace cache
if [ -d ".vscode" ]; then
    echo "Clearing VS Code workspace state..."
    rm -f .vscode/*.tmp
    rm -f .vscode/*.cache
fi

# Check for incorrect references
echo ""
echo "Checking for incorrect AccessibilityManager references..."
incorrect_refs=$(grep -r "ui/components/controls/AccessibilityManager" . --include="*.gd" --include="*.tscn" --include="*.tres" --include="*.cfg" 2>/dev/null | grep -v "clear_ide_cache.sh")

if [ -n "$incorrect_refs" ]; then
    echo "Found incorrect references:"
    echo "$incorrect_refs"
    echo ""
    echo "These files contain incorrect paths to AccessibilityManager."
    echo "The correct path is: core/systems/AccessibilityManager.gd"
else
    echo "No incorrect references found."
fi

echo ""
echo "Verifying correct autoload configuration..."
grep "AccessibilityManager=" project.godot

echo ""
echo "Cache clearing complete!"
echo ""
echo "Next steps:"
echo "1. Close any open Godot editor instances"
echo "2. Close and reopen VS Code"
echo "3. Open the project in Godot - this will rebuild the cache"
echo "4. The false error messages should be gone"
