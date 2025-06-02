#!/bin/bash

echo "🔥 NUCLEAR RESET: Clearing ALL Godot Tools Configuration"
echo "======================================================="

# Step 1: Clear VS Code workspace settings
echo "Step 1: Backing up and clearing workspace settings..."
if [ -f ".vscode/settings.json" ]; then
    cp .vscode/settings.json .vscode/settings.json.backup
    echo "✅ Backup created: .vscode/settings.json.backup"
fi

# Create minimal clean settings
cat > .vscode/settings.json << 'EOF'
{
    "files.exclude": {
        ".godot/": true,
        "**/*.import": true
    }
}
EOF

echo "✅ Minimal settings created"

# Step 2: Clear launch.json
echo ""
echo "Step 2: Clearing launch configuration..."
if [ -f ".vscode/launch.json" ]; then
    cp .vscode/launch.json .vscode/launch.json.backup
    rm .vscode/launch.json
    echo "✅ launch.json removed (backup created)"
fi

# Step 3: Instructions for VS Code reset
echo ""
echo "Step 3: VS Code Extension Reset Instructions"
echo "⚠️  YOU MUST DO THESE STEPS MANUALLY:"
echo ""
echo "1. Close VS Code completely (Cmd+Q)"
echo "2. Open Terminal and run:"
echo "   rm -rf ~/.vscode/extensions/geequlim.godot-tools-*"
echo "3. Open VS Code"
echo "4. Go to Extensions (Cmd+Shift+X)"
echo "5. Search for 'Godot Tools'"
echo "6. Install the extension"
echo "7. Restart VS Code"
echo ""
echo "Step 4: Clear VS Code User Settings"
echo "1. In VS Code, press Cmd+Shift+P"
echo "2. Type: 'Preferences: Open Settings (JSON)'"
echo "3. Look for ANY lines containing 'godot' and DELETE them"
echo "4. Save the file"
echo ""

# Step 4: Find actual Godot installation
echo "Step 5: Finding your Godot installation..."
echo ""

# Check common locations
locations=(
    "/Applications/Godot.app/Contents/MacOS/Godot"
    "/Applications/Godot_v4.4.app/Contents/MacOS/Godot"
    "/Applications/Godot_v4.3.app/Contents/MacOS/Godot"
    "/Applications/Godot_mono.app/Contents/MacOS/Godot"
    "/usr/local/bin/godot"
    "/opt/homebrew/bin/godot"
)

found_godot=""
for path in "${locations[@]}"; do
    if [ -f "$path" ] && [ -x "$path" ]; then
        echo "✅ FOUND GODOT: $path"
        found_godot="$path"
        break
    fi
done

if [ -z "$found_godot" ]; then
    echo "❌ No standard Godot installation found"
    echo "🔍 Searching entire system..."
    find /Applications -name "Godot" -type f -executable 2>/dev/null | head -5
    find /usr -name "godot" -type f -executable 2>/dev/null | head -5
else
    echo ""
    echo "🎯 CONFIGURATION TO USE:"
    echo "========================"
    echo "After reinstalling Godot Tools extension:"
    echo "1. Press Cmd+Shift+P in VS Code"
    echo "2. Type: 'Preferences: Open Settings (JSON)'"
    echo "3. Add this configuration:"
    echo ""
    echo "{"
    echo "    \"godot_tools.editor_path\": \"$found_godot\","
    echo "    \"godot_tools.gdscript_lsp_server_port\": 6005"
    echo "}"
    echo ""
fi

echo "🚨 IMPORTANT: After VS Code reset, configure Godot:"
echo "1. Open Godot Engine"
echo "2. Open your project"
echo "3. Editor → Editor Settings → Text Editor → External"
echo "4. Enable 'Use External Editor'"
echo "5. Enable 'Use Language Server'"
echo ""
echo "✅ Nuclear reset preparation complete!"
echo "📋 Follow the manual steps above to complete the reset."
