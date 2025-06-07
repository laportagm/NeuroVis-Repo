#!/bin/bash

# 🚨 VS Code Integration Fix Script
# NeuroVis Project - Systematic Fix Process

echo "🔧 VS Code Integration Fix for NeuroVis"
echo "======================================"
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Step 1: Detect Godot Installation
echo -e "${BLUE}Step 1: Detecting Godot Installation${NC}"
echo "-----------------------------------"

GODOT_PATHS=(
    "/Applications/Godot.app/Contents/MacOS/Godot"
    "/Applications/Godot_v4.4.app/Contents/MacOS/Godot"
    "/Applications/Godot_v4.3.app/Contents/MacOS/Godot" 
    "/Applications/Godot_v4.2.app/Contents/MacOS/Godot"
    "/Applications/Godot_mono.app/Contents/MacOS/Godot"
    "/usr/local/bin/godot"
    "/opt/homebrew/bin/godot"
)

FOUND_GODOT=""
for path in "${GODOT_PATHS[@]}"; do
    if [ -f "$path" ] && [ -x "$path" ]; then
        echo -e "${GREEN}✅ Found Godot: $path${NC}"
        FOUND_GODOT="$path"
        break
    fi
done

if [ -z "$FOUND_GODOT" ]; then
    echo -e "${RED}❌ No Godot installation found!${NC}"
    echo "Please install Godot 4.x from: https://godotengine.org/download"
    echo "Then run this script again."
    exit 1
fi

# Step 2: Test Godot executable
echo ""
echo -e "${BLUE}Step 2: Testing Godot Executable${NC}"
echo "---------------------------------"

if "$FOUND_GODOT" --version >/dev/null 2>&1; then
    GODOT_VERSION=$("$FOUND_GODOT" --version 2>/dev/null | head -1)
    echo -e "${GREEN}✅ Godot works: $GODOT_VERSION${NC}"
else
    echo -e "${RED}❌ Godot executable test failed${NC}"
    echo "The Godot executable at $FOUND_GODOT cannot run properly."
    exit 1
fi

# Step 3: Update VS Code Settings
echo ""
echo -e "${BLUE}Step 3: Updating VS Code Settings${NC}"
echo "--------------------------------"

SETTINGS_PATH=".vscode/settings.json"
BACKUP_PATH=".vscode/settings_backup_$(date +%Y%m%d_%H%M%S).json"

if [ -f "$SETTINGS_PATH" ]; then
    echo "📋 Backing up current settings to: $BACKUP_PATH"
    cp "$SETTINGS_PATH" "$BACKUP_PATH"
fi

# Create updated settings with detected Godot path
cat > "$SETTINGS_PATH" << EOF
{
    "godot_tools.editor_path": "$FOUND_GODOT",
    "godot_tools.gdscript_lsp_server_port": 6005,
    "godot_tools.editor_version": "4.x",
    "godot_tools.scene_file_config": "main",
    "godot_tools.editor_server_enabled": true,
    "godot_tools.connection_retry_count": 5,
    "godot_tools.connection_retry_delay": 1000,
    "godot_tools.show_connection_status": true,
    
    "editor.formatOnSave": true,
    "editor.formatOnType": true,
    "editor.minimap.enabled": true,
    "editor.bracketPairColorization.enabled": true,
    "editor.guides.bracketPairs": true,
    "editor.inlayHints.enabled": "on",
    
    "files.exclude": {
        ".godot/": true,
        "**/*.import": true,
        "**/*.uid": true,
        "**/.DS_Store": true,
        "**/logs/**": true
    },
    "files.associations": {
        "*.gd": "gdscript",
        "*.tscn": "godot-scene",
        "*.tres": "godot-resource"
    },
    
    "[gdscript]": {
        "editor.insertSpaces": false,
        "editor.detectIndentation": false,
        "editor.tabSize": 4,
        "editor.wordWrap": "bounded",
        "editor.wordWrapColumn": 100,
        "editor.suggest.showKeywords": true,
        "editor.suggest.showSnippets": true
    },
    
    "git.autofetch": true,
    "git.enableSmartCommit": true,
    "git.confirmSync": false,
    
    "files.watcherExclude": {
        ".godot/": true,
        "**/logs/**": true,
        "**/*.import": true
    },
    
    "github.copilot.enable": {
        "*": true,
        "gdscript": true,
        "godot-scene": true,
        "godot-resource": true,
        "plaintext": true,
        "markdown": true
    }
}
EOF

echo -e "${GREEN}✅ VS Code settings updated with Godot path: $FOUND_GODOT${NC}"

# Step 4: Test Project Configuration
echo ""
echo -e "${BLUE}Step 4: Testing Project Configuration${NC}"
echo "-----------------------------------"

if [ ! -f "project.godot" ]; then
    echo -e "${RED}❌ project.godot not found in current directory${NC}"
    echo "Please run this script from your NeuroVis project root."
    exit 1
fi

echo -e "${GREEN}✅ project.godot found${NC}"

# Test if project can be parsed
if "$FOUND_GODOT" --headless --path . --quit >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Project can be loaded by Godot${NC}"
else
    echo -e "${YELLOW}⚠️  Project has some issues, but may still work${NC}"
fi

# Step 5: Check network connectivity
echo ""
echo -e "${BLUE}Step 5: Testing Network Configuration${NC}"
echo "------------------------------------"

# Check if port 6005 is available
if ! lsof -i :6005 >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Port 6005 is available for Language Server${NC}"
else
    echo -e "${YELLOW}⚠️  Port 6005 is in use, Language Server may have connection issues${NC}"
fi

# Final instructions
echo ""
echo -e "${GREEN}🎯 FIX COMPLETE! Next Steps:${NC}"
echo "=============================="
echo ""
echo -e "${YELLOW}1. RESTART VS CODE COMPLETELY${NC}"
echo "   - Close VS Code (Cmd+Q)"
echo "   - Wait 5 seconds"
echo "   - Reopen VS Code"
echo ""
echo -e "${YELLOW}2. REINSTALL GODOT TOOLS EXTENSION${NC}"
echo "   - Go to Extensions (Cmd+Shift+X)"
echo "   - Search 'Godot Tools'"
echo "   - Click 'Uninstall' if installed"
echo "   - Click 'Install'"
echo "   - Restart VS Code again"
echo ""
echo -e "${YELLOW}3. START GODOT FIRST, THEN VS CODE${NC}"
echo "   - Open Godot editor"
echo "   - Open your NeuroVis project in Godot"
echo "   - Wait for full project load"
echo "   - Then open VS Code with project"
echo ""
echo -e "${YELLOW}4. TEST CONNECTION${NC}"
echo "   - Open any .gd file"
echo "   - Type 'print(' and look for autocomplete"
echo "   - Check bottom status bar for 'Godot Tools' indicator"
echo ""
echo -e "${GREEN}Your Godot path is configured as: $FOUND_GODOT${NC}"
echo ""
echo -e "${BLUE}If you still have issues, check:${NC}"
echo "- Godot Editor Settings → External → Use External Editor = ON"
echo "- Godot Editor Settings → External → Use Language Server = ON"
echo "- Port should be 6005 in both Godot and VS Code"
echo ""
echo -e "${GREEN}🚀 NeuroVis development environment should now be working!${NC}"
