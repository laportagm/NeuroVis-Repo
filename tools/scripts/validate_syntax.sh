#!/bin/bash

echo "🔍 NeuroVis GDScript Syntax Validator"
echo "===================================="

# Configuration
GODOT_PATH="/Applications/Godot.app/Contents/MacOS/Godot"
PROJECT_PATH="/Users/gagelaporta/1NeuroPro/NeuroVisProject/1/(4)NeuroVis copy"
ERROR_LOG="syntax_errors.log"
TEMP_PROJECT="temp_syntax_check"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if Godot exists
if [ ! -f "$GODOT_PATH" ]; then
    echo -e "${RED}❌ Godot not found at: $GODOT_PATH${NC}"
    echo "Please update GODOT_PATH in this script"
    exit 1
fi

echo -e "${GREEN}✅ Godot found: $GODOT_PATH${NC}"

# Initialize error tracking
error_count=0
warning_count=0
total_files=0

# Clear previous log
> "$ERROR_LOG"

echo -e "${BLUE}📄 Scanning for GDScript files...${NC}"

# Find all GDScript files
gdscript_files=$(find "$PROJECT_PATH" -name "*.gd" -type f | grep -v ".godot" | grep -v "temp_")

total_files=$(echo "$gdscript_files" | wc -l | xargs)
echo -e "${BLUE}Found $total_files GDScript file(s) to check${NC}"

# Create temporary project for isolated checking
temp_dir="$PROJECT_PATH/$TEMP_PROJECT"
mkdir -p "$temp_dir"

# Minimal project.godot for syntax checking
cat > "$temp_dir/project.godot" << 'EOF'
[application]
config/name="Syntax Check"
config/features=PackedStringArray("4.4", "Mobile")

[rendering]
renderer/rendering_method="mobile"
EOF

echo ""
echo -e "${BLUE}🔍 Checking syntax for each file...${NC}"

# Check each file individually
while IFS= read -r file; do
    if [ -n "$file" ]; then
        # Get relative path for display
        rel_path=$(echo "$file" | sed "s|$PROJECT_PATH/||")
        echo -n "📄 Checking: $rel_path"
        
        # Copy file to temp directory with same structure
        file_dir=$(dirname "$file")
        rel_dir=$(echo "$file_dir" | sed "s|$PROJECT_PATH||")
        mkdir -p "$temp_dir$rel_dir"
        cp "$file" "$temp_dir$rel_dir/"
        
        # Check syntax using Godot
        temp_file="$temp_dir$rel_dir/$(basename "$file")"
        
        # Run syntax check
        result=$("$GODOT_PATH" --headless --path "$temp_dir" --check-only --script "$temp_file" 2>&1)
        exit_code=$?
        
        if [ $exit_code -eq 0 ] && [ -z "$result" ]; then
            echo -e " ${GREEN}✅${NC}"
        else
            echo -e " ${RED}❌${NC}"
            echo "  Error details:" >> "$ERROR_LOG"
            echo "  File: $rel_path" >> "$ERROR_LOG"
            echo "$result" >> "$ERROR_LOG"
            echo "---" >> "$ERROR_LOG"
            
            # Count errors vs warnings
            if echo "$result" | grep -i "error" > /dev/null; then
                ((error_count++))
            else
                ((warning_count++))
            fi
            
            # Show error summary
            echo -e "  ${RED}❌ Syntax Error:${NC}"
            echo "$result" | head -3 | sed 's/^/    /'
        fi
        
        # Clean up temp file
        rm -f "$temp_file"
    fi
done <<< "$gdscript_files"

# Clean up temp directory
rm -rf "$temp_dir"

echo ""
echo -e "${BLUE}📊 Syntax Check Results${NC}"
echo "======================="
echo "Total files checked: $total_files"
echo -e "✅ Clean files: $((total_files - error_count - warning_count))"
echo -e "${YELLOW}⚠️  Warnings: $warning_count${NC}"
echo -e "${RED}❌ Errors: $error_count${NC}"

if [ $error_count -gt 0 ] || [ $warning_count -gt 0 ]; then
    echo ""
    echo -e "${YELLOW}📄 Full error report saved to: $ERROR_LOG${NC}"
    echo ""
    echo -e "${BLUE}🔧 Common fixes:${NC}"
    echo "1. Check indentation (4 spaces, no tabs)"
    echo "2. Add proper type hints: func name(param: Type) -> ReturnType"
    echo "3. Verify class_name comes before extends"
    echo "4. Check signal declarations: signal name(param: Type)"
    echo "5. Ensure all variables have type hints"
fi

if [ $error_count -eq 0 ]; then
    echo -e "${GREEN}🎉 All syntax checks passed!${NC}"
    exit 0
else
    echo -e "${RED}❌ Found $error_count syntax errors that need fixing${NC}"
    exit 1
fi