#!/bin/bash

# Godot Installation Detector for A1-NeuroVis
echo "🔍 Detecting Godot Installation..."
echo "================================="

# Array of possible Godot paths
paths=(
    "/Applications/Godot.app/Contents/MacOS/Godot"
    "/Applications/Godot_v4.4.app/Contents/MacOS/Godot"
    "/Applications/Godot_v4.3.app/Contents/MacOS/Godot"
    "/Applications/Godot_v4.2.app/Contents/MacOS/Godot"
    "/Applications/Godot_mono.app/Contents/MacOS/Godot"
    "/Applications/Godot_v4.4_mono.app/Contents/MacOS/Godot"
    "/usr/local/bin/godot"
    "/opt/homebrew/bin/godot"
    "/usr/bin/godot"
)

found_paths=()

echo "🔎 Checking standard locations..."

# Check each path
for path in "${paths[@]}"; do
    if [ -f "$path" ] && [ -x "$path" ]; then
        echo "✅ Found: $path"
        found_paths+=("$path")
    fi
done

# Check for any Godot apps in Applications
echo ""
echo "🔎 Searching Applications folder..."
find /Applications -name "*Godot*.app" -type d 2>/dev/null | while read -r app; do
    godot_executable="$app/Contents/MacOS/Godot"
    if [ -f "$godot_executable" ] && [ -x "$godot_executable" ]; then
        echo "✅ Found: $godot_executable"
    fi
done

# Check PATH
echo ""
echo "🔎 Checking PATH..."
if command -v godot &> /dev/null; then
    godot_path=$(which godot)
    echo "✅ Found in PATH: $godot_path"
fi

echo ""
echo "🎯 RECOMMENDATION:"
if [ ${#found_paths[@]} -gt 0 ]; then
    echo "Use this path in VS Code settings:"
    echo "   \"godot_tools.editor_path\": \"${found_paths[0]}\""
else
    echo "❌ No Godot installation found!"
    echo "Please install Godot 4.x from: https://godotengine.org/download"
fi

echo ""
echo "📝 To use this path:"
echo "1. Copy the path above"
echo "2. Open VS Code settings (Cmd+,)"
echo "3. Search for 'godot_tools.editor_path'"
echo "4. Paste the path"
echo "5. Restart VS Code"
