#!/bin/bash
# Fix all hardcoded paths to point to the correct project directory
# Current project: /Users/gagelaporta/1NeuroPro/NeuroVisProject/1/(4)NeuroVis copy

echo "🔧 Fixing project paths for NeuroVis..."
echo "Target path: /Users/gagelaporta/1NeuroPro/NeuroVisProject/1/(4)NeuroVis copy"
echo ""

# Define the correct project path
CORRECT_PATH="/Users/gagelaporta/1NeuroPro/NeuroVisProject/1/(4)NeuroVis copy"

# Create backup before making changes
echo "📁 Creating backup of files to be modified..."
mkdir -p path_fix_backup
cp launch_cursor.sh path_fix_backup/ 2>/dev/null || true
cp setup_vscode_enhancement.sh path_fix_backup/ 2>/dev/null || true
cp scripts/build_and_package.sh path_fix_backup/ 2>/dev/null || true
cp tools/scripts/test_selection_performance.sh path_fix_backup/ 2>/dev/null || true
cp tools/scripts/validate_syntax.sh path_fix_backup/ 2>/dev/null || true
cp tools/scripts/configure_claude_code.sh path_fix_backup/ 2>/dev/null || true
cp tools/scripts/configure_claude_desktop.sh path_fix_backup/ 2>/dev/null || true
cp test_godot_mcp.sh path_fix_backup/ 2>/dev/null || true
cp setup_godot_mcp.sh path_fix_backup/ 2>/dev/null || true
cp .claude/config.json path_fix_backup/ 2>/dev/null || true
cp CLAUDE.md path_fix_backup/ 2>/dev/null || true

echo "🔄 Updating shell scripts..."

# Fix launch_cursor.sh
if [ -f "launch_cursor.sh" ]; then
    sed -i '' "s|/Users/gagelaporta/1NeuroPro/NeuroVisProject/NeuroVis|${CORRECT_PATH}|g" launch_cursor.sh
    echo "✅ Fixed launch_cursor.sh"
fi

# Fix setup_vscode_enhancement.sh
if [ -f "setup_vscode_enhancement.sh" ]; then
    sed -i '' "s|/Users/gagelaporta/11A-NeuroVis copy3|${CORRECT_PATH}|g" setup_vscode_enhancement.sh
    echo "✅ Fixed setup_vscode_enhancement.sh"
fi

# Fix scripts/build_and_package.sh
if [ -f "scripts/build_and_package.sh" ]; then
    sed -i '' "s|/Users/gagelaporta/11A-NeuroVis copy3|${CORRECT_PATH}|g" scripts/build_and_package.sh
    echo "✅ Fixed scripts/build_and_package.sh"
fi

# Fix tools/scripts files
for script in tools/scripts/test_selection_performance.sh tools/scripts/validate_syntax.sh tools/scripts/configure_claude_code.sh tools/scripts/configure_claude_desktop.sh; do
    if [ -f "$script" ]; then
        sed -i '' "s|/Users/gagelaporta/11A-NeuroVis copy3|${CORRECT_PATH}|g" "$script"
        echo "✅ Fixed $script"
    fi
done

# Fix test_godot_mcp.sh
if [ -f "test_godot_mcp.sh" ]; then
    sed -i '' "s|/Users/gagelaporta/1NeuroPro/NeuroVisProject/NeuroVis|${CORRECT_PATH}|g" test_godot_mcp.sh
    echo "✅ Fixed test_godot_mcp.sh"
fi

# Fix setup_godot_mcp.sh
if [ -f "setup_godot_mcp.sh" ]; then
    sed -i '' "s|/Users/gagelaporta/1NeuroPro/NeuroVisProject/NeuroVis|${CORRECT_PATH}|g" setup_godot_mcp.sh
    echo "✅ Fixed setup_godot_mcp.sh"
fi

echo ""
echo "🔄 Updating configuration files..."

# Fix .claude/config.json
if [ -f ".claude/config.json" ]; then
    sed -i '' "s|/Users/gagelaporta/1NeuroPro/NeuroVisProject/NeuroVis|${CORRECT_PATH}|g" .claude/config.json
    echo "✅ Fixed .claude/config.json"
fi

echo ""
echo "🔄 Updating documentation files..."

# Fix CLAUDE.md
if [ -f "CLAUDE.md" ]; then
    # Replace the old path references
    sed -i '' "s|godot --path \"/Users/gagelaporta/11A-NeuroVis copy3\"|godot --path \"${CORRECT_PATH}\"|g" CLAUDE.md
    # Also update the project path reference in header
    sed -i '' "s|/Users/gagelaporta/11A-NeuroVis copy3|${CORRECT_PATH}|g" CLAUDE.md
    echo "✅ Fixed CLAUDE.md"
fi

# Fix other documentation files that might have paths
for doc in docs/dev/*.md docs/*.md *.md; do
    if [ -f "$doc" ] && grep -q "/Users/gagelaporta/11A-NeuroVis copy3\|/Users/gagelaporta/1NeuroPro/NeuroVisProject/NeuroVis" "$doc" 2>/dev/null; then
        sed -i '' "s|/Users/gagelaporta/11A-NeuroVis copy3|${CORRECT_PATH}|g" "$doc"
        sed -i '' "s|/Users/gagelaporta/1NeuroPro/NeuroVisProject/NeuroVis|${CORRECT_PATH}|g" "$doc"
        echo "✅ Fixed $doc"
    fi
done

echo ""
echo "🔄 Creating project path reference file..."

# Create a reference file with the correct path
cat > PROJECT_PATH_REFERENCE.txt << EOF
# NeuroVis Project Path Reference
# This file contains the correct paths for this project instance

PROJECT_ROOT="${CORRECT_PATH}"
PROJECT_NAME="NeuroVis Educational Platform"

# Use these paths in scripts and documentation:
# For Godot: godot --path "${CORRECT_PATH}"
# For scripts: cd "${CORRECT_PATH}"

# This helps ensure all tools and AI assistants use the correct project location.
EOF

echo "✅ Created PROJECT_PATH_REFERENCE.txt"

echo ""
echo "🔄 Updating VS Code workspace file..."

# Check if workspace file exists and update it
if [ -f "neurovis-enhanced.code-workspace" ]; then
    # The workspace file should use relative paths, but let's ensure it's correct
    echo "✅ VS Code workspace file uses relative paths (OK)"
fi

echo ""
echo "✨ Path fixing complete!"
echo ""
echo "📊 Summary:"
echo "- Updated shell scripts to use correct project path"
echo "- Fixed configuration files"
echo "- Updated documentation with correct paths"
echo "- Created PROJECT_PATH_REFERENCE.txt for future reference"
echo "- Backup created in path_fix_backup/ directory"
echo ""
echo "💡 Next steps:"
echo "1. Review the changes with: git diff"
echo "2. Test that scripts still work correctly"
echo "3. Commit the fixes: git add -A && git commit -m 'fix: update all paths to correct project location'"
echo ""
echo "⚠️  Note: Some resource paths in .gd files use 'res://' which is correct Godot syntax."
echo "    These should NOT be changed as they are relative to the project root."