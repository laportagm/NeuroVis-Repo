#!/bin/bash

echo "🔧 A1-NeuroVis Quick Fix Test"
echo "============================="

# Test 1: Check if detection script exists and is executable
echo "Test 1: Detection script"
if [ -f "./detect_godot.sh" ]; then
    echo "✅ detect_godot.sh exists"
    chmod +x ./detect_godot.sh
    echo "✅ Made executable"
else
    echo "❌ detect_godot.sh not found"
fi

# Test 2: Quick Godot detection
echo ""
echo "Test 2: Quick Godot search"
if [ -f "/Applications/Godot.app/Contents/MacOS/Godot" ]; then
    echo "✅ Standard Godot found: /Applications/Godot.app/Contents/MacOS/Godot"
elif [ -f "/Applications/Godot_v4.4.app/Contents/MacOS/Godot" ]; then
    echo "✅ Godot v4.4 found: /Applications/Godot_v4.4.app/Contents/MacOS/Godot"
else
    echo "❓ Standard paths not found, running full search..."
    find /Applications -name "*Godot*.app" -type d 2>/dev/null | head -3
fi

# Test 3: Check VS Code settings
echo ""
echo "Test 3: VS Code settings"
if [ -f "./.vscode/settings.json" ]; then
    echo "✅ VS Code settings exist"
    if grep -q "godot_tools.editor_path" ./.vscode/settings.json; then
        echo "✅ Godot path setting found"
    else
        echo "❌ Godot path setting missing"
    fi
else
    echo "❌ VS Code settings not found"
fi

# Test 4: Check launch.json
echo ""
echo "Test 4: Launch configuration"
if [ -f "./.vscode/launch.json" ]; then
    echo "✅ Launch configuration exists"
    if grep -q "main\|current\|pinned" ./.vscode/launch.json; then
        echo "✅ Valid scene parameters found"
    else
        echo "❌ Invalid scene parameters"
    fi
else
    echo "❌ Launch configuration not found"
fi

echo ""
echo "🎯 Next Steps:"
echo "1. Run: ./detect_godot.sh"
echo "2. Follow the EMERGENCY_FIX_GUIDE.md"
echo "3. Start Godot FIRST, then VS Code"
