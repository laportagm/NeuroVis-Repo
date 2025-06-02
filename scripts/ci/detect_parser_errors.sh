#!/bin/bash

echo "🔍 NeuroVis Comprehensive Parser Error Detection"
echo "================================================="

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

declare -a GDSCRIPT_ERRORS=()
declare -a SCENE_ERRORS=()
TOTAL_ERRORS=0

add_error() {
    local error_type="$1"
    local file="$2"
    local details="$3"
    
    case "$error_type" in
        "gdscript")
            GDSCRIPT_ERRORS+=("$file|$details")
            ;;
        "scene")
            SCENE_ERRORS+=("$file|$details")
            ;;
    esac
    TOTAL_ERRORS=$((TOTAL_ERRORS + 1))
}

# Check GDScript syntax errors
echo -e "${BLUE}1. Checking GDScript Files...${NC}"
gdscript_count=0
while IFS= read -r -d '' file; do
    gdscript_count=$((gdscript_count + 1))
    echo -ne "\rChecking GDScript file $gdscript_count: $(basename "$file")"
    
    error_output=$(/Applications/Godot.app/Contents/MacOS/Godot --headless --check-only "$file" 2>&1)
    exit_code=$?
    
    if [ $exit_code -ne 0 ]; then
        error_details=$(echo "$error_output" | head -1)
        add_error "gdscript" "$file" "$error_details"
    fi
done < <(find . -name "*.gd" -not -path "./.git/*" -print0 2>/dev/null)
echo ""

# Check Scene file errors
echo -e "${BLUE}2. Checking Scene Files...${NC}"
scene_count=0
while IFS= read -r -d '' file; do
    scene_count=$((scene_count + 1))
    echo -ne "\rChecking scene file $scene_count: $(basename "$file")"
    
    error_output=$(/Applications/Godot.app/Contents/MacOS/Godot --headless --check-only "$file" 2>&1)
    exit_code=$?
    
    if [ $exit_code -ne 0 ]; then
        error_details=$(echo "$error_output" | head -1)
        add_error "scene" "$file" "$error_details"
    fi
done < <(find . -name "*.tscn" -not -path "./.git/*" -print0 2>/dev/null)
echo ""

# Generate error report
echo ""
echo "================================================="
echo -e "${CYAN}COMPREHENSIVE ERROR REPORT${NC}"
echo "================================================="

if [ $TOTAL_ERRORS -eq 0 ]; then
    echo -e "${GREEN}🎉 NO PARSER ERRORS FOUND!${NC}"
    echo -e "${GREEN}All files are syntactically correct.${NC}"
    exit 0
fi

echo -e "${RED}Found $TOTAL_ERRORS total parser errors:${NC}"
echo ""

# Report GDScript errors
if [ ${#GDSCRIPT_ERRORS[@]} -gt 0 ]; then
    echo -e "${RED}📄 GDScript Syntax Errors (${#GDSCRIPT_ERRORS[@]}):${NC}"
    for error in "${GDSCRIPT_ERRORS[@]}"; do
        IFS='|' read -r file details <<< "$error"
        echo -e "${YELLOW}  ❌ $file${NC}"
        echo -e "     $details"
    done
    echo ""
fi

# Report Scene errors
if [ ${#SCENE_ERRORS[@]} -gt 0 ]; then
    echo -e "${RED}🎭 Scene File Errors (${#SCENE_ERRORS[@]}):${NC}"
    for error in "${SCENE_ERRORS[@]}"; do
        IFS='|' read -r file details <<< "$error"
        echo -e "${YELLOW}  ❌ $file${NC}"
        echo -e "     $details"
    done
    echo ""
fi

# Save detailed report
{
    echo "NeuroVis Parser Error Report - $(date)"
    echo "============================================="
    echo "Total Errors: $TOTAL_ERRORS"
    echo ""
    
    if [ ${#GDSCRIPT_ERRORS[@]} -gt 0 ]; then
        echo "GDScript Errors:"
        for error in "${GDSCRIPT_ERRORS[@]}"; do
            IFS='|' read -r file details <<< "$error"
            echo "  File: $file"
            echo "  Error: $details"
            echo ""
        done
    fi
    
    if [ ${#SCENE_ERRORS[@]} -gt 0 ]; then
        echo "Scene Errors:"
        for error in "${SCENE_ERRORS[@]}"; do
            IFS='|' read -r file details <<< "$error"
            echo "  File: $file"
            echo "  Error: $details"
            echo ""
        done
    fi
} > parser_errors.log

echo ""
echo -e "${YELLOW}💾 Detailed report saved to: parser_errors.log${NC}"
echo -e "${RED}🚨 Fix all $TOTAL_ERRORS errors before committing!${NC}"

exit 1
