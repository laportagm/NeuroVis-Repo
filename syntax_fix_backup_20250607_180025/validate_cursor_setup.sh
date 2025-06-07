#!/bin/bash
echo "🔍 Validating Cursor + Godot Setup..."

# Check installations
[[ -d "/Applications/Cursor.app" ]] && echo "✅ Cursor installed" || echo "❌ Cursor missing"
[[ -d "/Applications/Godot.app" ]] && echo "✅ Godot installed" || echo "❌ Godot missing"

# Check extensions
/Applications/Cursor.app/Contents/MacOS/Cursor --list-extensions | grep -q godot && echo "✅ Godot extensions installed" || echo "❌ Extensions missing"

# Check project
[[ -f "project.godot" ]] && echo "✅ Godot project found" || echo "❌ Not in Godot project"

# Test LSP
./launch_cursor.sh &
sleep 5
lsof -i:6005 && echo "✅ Godot LSP connected" || echo "❌ LSP connection failed"