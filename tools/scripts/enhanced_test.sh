#!/bin/bash

echo "🔧 NeuroVis Enhanced Standards Test Suite"
echo "=========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Test 1: Basic Project Health (existing)
echo ""
print_status $BLUE "📊 Test 1: Basic Project Health"
echo "================================="

# Check if detection script exists and is executable
echo "Detection script check:"
if [ -f "./detect_godot.sh" ]; then
    print_status $GREEN "✅ detect_godot.sh exists"
    chmod +x ./detect_godot.sh
else
    print_status $YELLOW "❓ detect_godot.sh not found (optional)"
fi

# Quick Godot detection
echo ""
echo "Godot installation check:"
if [ -f "/Applications/Godot.app/Contents/MacOS/Godot" ]; then
    print_status $GREEN "✅ Standard Godot found: /Applications/Godot.app/Contents/MacOS/Godot"
elif [ -f "/Applications/Godot_v4.4.app/Contents/MacOS/Godot" ]; then
    print_status $GREEN "✅ Godot v4.4 found: /Applications/Godot_v4.4.app/Contents/MacOS/Godot"
else
    print_status $YELLOW "❓ Standard paths not found"
fi

# Test 2: Educational Standards Compliance
echo ""
print_status $BLUE "📚 Test 2: Educational Standards Compliance"
echo "============================================="

# Check if Claude Code commands exist
echo "Claude Code command validation:"
COMMANDS_DIR=".claude/commands"
REQUIRED_COMMANDS=("standards-check.md" "auto-organize.md" "educational-feature.md")

for cmd in "${REQUIRED_COMMANDS[@]}"; do
    if [ -f "$COMMANDS_DIR/$cmd" ]; then
        print_status $GREEN "✅ $cmd exists"
    else
        print_status $RED "❌ $cmd missing"
    fi
done

# Test 3: Educational Architecture Validation
echo ""
print_status $BLUE "🏗️ Test 3: Educational Architecture Validation"
echo "==============================================="

# Check core educational directories
CORE_DIRS=("core/knowledge" "core/ai" "core/interaction" "core/models" "core/systems")
UI_DIRS=("ui/components" "ui/panels" "ui/theme")
SCENE_DIRS=("scenes/main" "scenes/debug")
ASSET_DIRS=("assets/data" "assets/models")

echo "Core educational directories:"
for dir in "${CORE_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        count=$(find "$dir" -name "*.gd" | wc -l)
        print_status $GREEN "✅ $dir ($(echo $count | tr -d ' ') scripts)"
    else
        print_status $YELLOW "❓ $dir not found"
    fi
done

echo ""
echo "Educational UI directories:"
for dir in "${UI_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        count=$(find "$dir" -name "*.gd" | wc -l)
        print_status $GREEN "✅ $dir ($(echo $count | tr -d ' ') scripts)"
    else
        print_status $YELLOW "❓ $dir not found"
    fi
done

# Test 4: Educational Content Validation
echo ""
print_status $BLUE "🧠 Test 4: Educational Content Validation"
echo "=========================================="

# Check anatomical data
if [ -f "assets/data/anatomical_data.json" ]; then
    print_status $GREEN "✅ Educational content database exists"
    # Validate JSON syntax
    if python3 -m json.tool assets/data/anatomical_data.json > /dev/null 2>&1; then
        print_status $GREEN "✅ Educational content JSON is valid"
    else
        print_status $RED "❌ Educational content JSON has syntax errors"
    fi
else
    print_status $RED "❌ Educational content database missing"
fi

# Check 3D educational models
echo ""
echo "Educational 3D models:"
if [ -d "assets/models" ]; then
    model_count=$(find assets/models -name "*.glb" | wc -l)
    print_status $GREEN "✅ Educational models directory ($(echo $model_count | tr -d ' ') .glb files)"
else
    print_status $YELLOW "❓ Educational models directory not found"
fi

# Test 5: VS Code Educational Integration
echo ""
print_status $BLUE "⚙️ Test 5: VS Code Educational Integration"
echo "==========================================="

# Check VS Code configuration
VS_CODE_FILES=("settings.json" "tasks.json" "launch.json" "keybindings.json")

for file in "${VS_CODE_FILES[@]}"; do
    if [ -f ".vscode/$file" ]; then
        print_status $GREEN "✅ .vscode/$file exists"
    else
        print_status $YELLOW "❓ .vscode/$file not found"
    fi
done

# Test 6: Educational Autoload Services
echo ""
print_status $BLUE "🤖 Test 6: Educational Autoload Services"
echo "========================================="

# Check project.godot for educational autoloads
EDUCATIONAL_AUTOLOADS=("KnowledgeService" "AIAssistant" "UIThemeManager" "ModelSwitcherGlobal")

if [ -f "project.godot" ]; then
    print_status $GREEN "✅ project.godot exists"
    
    for autoload in "${EDUCATIONAL_AUTOLOADS[@]}"; do
        if grep -q "$autoload" project.godot; then
            print_status $GREEN "✅ $autoload autoload configured"
        else
            print_status $YELLOW "❓ $autoload autoload not found"
        fi
    done
else
    print_status $RED "❌ project.godot not found"
fi

# Test 7: Educational Documentation
echo ""
print_status $BLUE "📖 Test 7: Educational Documentation"
echo "====================================="

# Check essential documentation
DOCS=("CLAUDE.md" "README.md")

for doc in "${DOCS[@]}"; do
    if [ -f "$doc" ]; then
        lines=$(wc -l < "$doc")
        print_status $GREEN "✅ $doc exists ($lines lines)"
    else
        print_status $YELLOW "❓ $doc not found"
    fi
done

# Test 8: Performance and Quality
echo ""
print_status $BLUE "⚡ Test 8: Performance and Quality"
echo "=================================="

# Check pre-commit hooks
if [ -f ".git/hooks/pre-commit" ]; then
    if [ -x ".git/hooks/pre-commit" ]; then
        print_status $GREEN "✅ Pre-commit hooks active"
    else
        print_status $YELLOW "❓ Pre-commit hooks not executable"
    fi
else
    print_status $YELLOW "❓ Pre-commit hooks not installed"
fi

# Summary
echo ""
print_status $BLUE "🎯 Enhanced Test Summary"
echo "========================"

# Optional: Run Claude standards check if available
if command -v claude >/dev/null 2>&1 && [ -f ".claude/commands/standards-check.md" ]; then
    echo ""
    print_status $BLUE "🔍 Running Claude Educational Standards Check..."
    echo "================================================="
    # Run the standards check but don't fail the script if Claude isn't available
    claude -f .claude/commands/standards-check.md 2>/dev/null || print_status $YELLOW "❓ Claude standards check unavailable"
fi

echo ""
print_status $GREEN "🎉 Enhanced NeuroVis test suite completed!"
echo ""
echo "Next steps:"
echo "1. Address any ❌ red issues above"
echo "2. Consider investigating ❓ yellow items"
echo "3. Run: claude -f .claude/commands/standards-check.md"
echo "4. Launch: Ctrl+Shift+G (VS Code) or manually open Godot"
echo "5. Test educational features with F1 debug console"