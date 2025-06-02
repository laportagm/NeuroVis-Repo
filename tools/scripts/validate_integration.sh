#!/bin/bash

# 🧪 VS Code Integration Validation Script
# Tests if the fix worked properly

echo "🧪 Testing VS Code Integration Fix"
echo "================================"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PASSED=0
TOTAL=0

# Test function
test_check() {
    local name="$1"
    local command="$2"
    TOTAL=$((TOTAL + 1))
    
    echo -n "Testing $name... "
    if eval "$command" >/dev/null 2>&1; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}FAIL${NC}"
    fi
}

# Run tests
echo -e "${BLUE}Environment Tests:${NC}"
test_check "VS Code settings exist" "[ -f .vscode/settings.json ]"
test_check "Launch config exists" "[ -f .vscode/launch.json ]"
test_check "Project config exists" "[ -f project.godot ]"

echo ""
echo -e "${BLUE}Godot Tests:${NC}"

# Get Godot path from settings
GODOT_PATH=$(grep -o '"godot_tools.editor_path": "[^"]*"' .vscode/settings.json | cut -d'"' -f4)

if [ -n "$GODOT_PATH" ]; then
    test_check "Godot executable exists" "[ -f '$GODOT_PATH' ]"
    test_check "Godot is executable" "[ -x '$GODOT_PATH' ]"
    test_check "Godot version check" "'$GODOT_PATH' --version"
    test_check "Project loads in Godot" "'$GODOT_PATH' --headless --path . --quit"
else
    echo -e "${RED}❌ Could not find Godot path in settings${NC}"
fi

echo ""
echo -e "${BLUE}Configuration Tests:${NC}"
test_check "Port setting exists" "grep -q '6005' .vscode/settings.json"
test_check "GDScript association exists" "grep -q 'gdscript' .vscode/settings.json"
test_check "Launch scenes configured" "grep -q 'main\\|current' .vscode/launch.json"

echo ""
echo -e "${BLUE}Results:${NC}"
echo "========"
echo "Tests passed: $PASSED/$TOTAL"

if [ $PASSED -eq $TOTAL ]; then
    echo -e "${GREEN}🎉 All tests passed! VS Code integration should be working.${NC}"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "1. Start Godot and open your project"
    echo "2. Start VS Code and open project folder"
    echo "3. Open a .gd file and test autocomplete"
    echo "4. Check for 'Godot Tools' in VS Code status bar"
elif [ $PASSED -gt $((TOTAL / 2)) ]; then
    echo -e "${YELLOW}⚠️  Most tests passed, but some issues remain.${NC}"
    echo "Try restarting both Godot and VS Code."
else
    echo -e "${RED}❌ Multiple issues detected. Run fix_vscode_integration.sh again.${NC}"
fi

echo ""
echo -e "${BLUE}Troubleshooting:${NC}"
echo "- Ensure Godot 4.x is installed"
echo "- Restart VS Code completely"
echo "- Reinstall Godot Tools extension"
echo "- Start Godot before VS Code"
