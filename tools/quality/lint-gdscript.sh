#!/bin/bash
# NeuroVis GDScript Linter
# Performs static analysis and style checking for GDScript files

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
GODOT_BINARY="${GODOT_PATH:-godot}"
LINT_CONFIG="$PROJECT_ROOT/tools/quality/gdscript-lint.cfg"

# Linting options
CHECK_SYNTAX=true
CHECK_STYLE=true
CHECK_COMPLEXITY=true
CHECK_NAMING=true
FIX_ISSUES=false
STAGED_ONLY=false
VERBOSE=false

# Statistics
total_files=0
files_with_issues=0
total_issues=0

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to print section headers
print_section() {
    echo ""
    print_status $BLUE "=== $1 ==="
}

# Function to check if Godot is available
check_godot() {
    if ! command -v "$GODOT_BINARY" >/dev/null 2>&1; then
        print_status $YELLOW "⚠️  Godot not found in PATH, syntax checking disabled"
        CHECK_SYNTAX=false
        return 1
    fi
    return 0
}

# Function to get GDScript files to lint
get_gdscript_files() {
    if [[ "$STAGED_ONLY" == true ]]; then
        # Get staged files only
        git diff --cached --name-only --diff-filter=ACM | grep -E '\.gd$' || true
    else
        # Get all GDScript files in project
        find "$PROJECT_ROOT" -name "*.gd" \
            -not -path "*/.godot/*" \
            -not -path "*/tmp/*" \
            -not -path "*/build/*" \
            -not -path "*/export/*" \
            -not -name "*Test.gd" \
            -not -name "*_test.gd" \
            | sort
    fi
}

# Function to check syntax using Godot
check_syntax() {
    local file=$1
    local issues=0
    
    if [[ "$CHECK_SYNTAX" != true ]]; then
        return 0
    fi
    
    if [[ "$VERBOSE" == true ]]; then
        echo "    Checking syntax..."
    fi
    
    # Use Godot to check syntax
    local output
    if ! output=$("$GODOT_BINARY" --check-only --script "$file" 2>&1); then
        print_status $RED "    ❌ Syntax Error:"
        echo "$output" | sed 's/^/      /'
        issues=$((issues + 1))
    elif [[ "$VERBOSE" == true ]]; then
        print_status $GREEN "    ✅ Syntax OK"
    fi
    
    return $issues
}

# Function to check coding style
check_style() {
    local file=$1
    local issues=0
    
    if [[ "$CHECK_STYLE" != true ]]; then
        return 0
    fi
    
    if [[ "$VERBOSE" == true ]]; then
        echo "    Checking style..."
    fi
    
    # Check indentation (should use tabs)
    if grep -n "^    " "$file" >/dev/null 2>&1; then
        print_status $YELLOW "    ⚠️  Found spaces for indentation (should use tabs)"
        if [[ "$VERBOSE" == true ]]; then
            grep -n "^    " "$file" | head -3 | sed 's/^/      Line /'
        fi
        issues=$((issues + 1))
    fi
    
    # Check line length (warn if > 100 characters)
    local long_lines=$(awk 'length > 100 {print NR ": " $0}' "$file")
    if [[ -n "$long_lines" ]]; then
        print_status $YELLOW "    ⚠️  Lines longer than 100 characters:"
        echo "$long_lines" | head -3 | sed 's/^/      /'
        if [[ $(echo "$long_lines" | wc -l) -gt 3 ]]; then
            echo "      ... and $(($(echo "$long_lines" | wc -l) - 3)) more"
        fi
        issues=$((issues + 1))
    fi
    
    # Check for trailing whitespace
    if grep -n " $" "$file" >/dev/null 2>&1; then
        print_status $YELLOW "    ⚠️  Trailing whitespace found"
        if [[ "$FIX_ISSUES" == true ]]; then
            sed -i '' 's/[[:space:]]*$//' "$file"
            print_status $GREEN "      ✅ Fixed trailing whitespace"
        fi
        issues=$((issues + 1))
    fi
    
    # Check for missing final newline
    if [[ -s "$file" ]] && [[ "$(tail -c1 "$file" | wc -l)" -eq 0 ]]; then
        print_status $YELLOW "    ⚠️  Missing final newline"
        if [[ "$FIX_ISSUES" == true ]]; then
            echo "" >> "$file"
            print_status $GREEN "      ✅ Added final newline"
        fi
        issues=$((issues + 1))
    fi
    
    # Check for multiple consecutive empty lines
    if grep -Pzo "(?s)\n\n\n\n" "$file" >/dev/null 2>&1; then
        print_status $YELLOW "    ⚠️  Multiple consecutive empty lines (>3)"
        issues=$((issues + 1))
    fi
    
    return $issues
}

# Function to check naming conventions
check_naming() {
    local file=$1
    local issues=0
    
    if [[ "$CHECK_NAMING" != true ]]; then
        return 0
    fi
    
    if [[ "$VERBOSE" == true ]]; then
        echo "    Checking naming conventions..."
    fi
    
    # Check class_name follows PascalCase
    local class_names=$(grep -n "^class_name " "$file" | cut -d' ' -f2)
    for class_name in $class_names; do
        if [[ ! "$class_name" =~ ^[A-Z][a-zA-Z0-9]*$ ]]; then
            print_status $YELLOW "    ⚠️  Class name should be PascalCase: $class_name"
            issues=$((issues + 1))
        fi
    done
    
    # Check function names follow snake_case
    local function_names=$(grep -n "^func " "$file" | grep -v "^func _" | sed 's/.*func \([a-zA-Z_][a-zA-Z0-9_]*\).*/\1/')
    for func_name in $function_names; do
        if [[ ! "$func_name" =~ ^[a-z][a-z0-9_]*$ ]]; then
            print_status $YELLOW "    ⚠️  Function name should be snake_case: $func_name"
            issues=$((issues + 1))
        fi
    done
    
    # Check variable names in var declarations
    local var_names=$(grep -n "^[[:space:]]*var " "$file" | sed 's/.*var \([a-zA-Z_][a-zA-Z0-9_]*\).*/\1/')
    for var_name in $var_names; do
        # Skip private variables (starting with _)
        if [[ "$var_name" =~ ^_.*$ ]]; then
            continue
        fi
        
        if [[ ! "$var_name" =~ ^[a-z][a-z0-9_]*$ ]]; then
            print_status $YELLOW "    ⚠️  Variable name should be snake_case: $var_name"
            issues=$((issues + 1))
        fi
    done
    
    # Check constant names follow ALL_CAPS_SNAKE_CASE
    local const_names=$(grep -n "^[[:space:]]*const " "$file" | sed 's/.*const \([a-zA-Z_][a-zA-Z0-9_]*\).*/\1/')
    for const_name in $const_names; do
        if [[ ! "$const_name" =~ ^[A-Z][A-Z0-9_]*$ ]]; then
            print_status $YELLOW "    ⚠️  Constant name should be ALL_CAPS_SNAKE_CASE: $const_name"
            issues=$((issues + 1))
        fi
    done
    
    return $issues
}

# Function to check code complexity
check_complexity() {
    local file=$1
    local issues=0
    
    if [[ "$CHECK_COMPLEXITY" != true ]]; then
        return 0
    fi
    
    if [[ "$VERBOSE" == true ]]; then
        echo "    Checking complexity..."
    fi
    
    # Check function length (warn if > 50 lines)
    local in_function=false
    local function_name=""
    local function_start=0
    local brace_count=0
    local line_num=0
    
    while IFS= read -r line; do
        line_num=$((line_num + 1))
        
        # Detect function start
        if [[ "$line" =~ ^func[[:space:]]+([a-zA-Z_][a-zA-Z0-9_]*) ]]; then
            if [[ "$in_function" == true ]]; then
                # Previous function ended
                local function_length=$((line_num - function_start))
                if [[ $function_length -gt 50 ]]; then
                    print_status $YELLOW "    ⚠️  Function '$function_name' is long ($function_length lines)"
                    issues=$((issues + 1))
                fi
            fi
            
            function_name="${BASH_REMATCH[1]}"
            function_start=$line_num
            in_function=true
            brace_count=0
        fi
        
        # Count nested levels (approximate complexity)
        local nested_keywords="if|while|for|match|func"
        if [[ "$line" =~ ($nested_keywords) ]]; then
            brace_count=$((brace_count + 1))
        fi
        
        # Warn about deep nesting
        if [[ $brace_count -gt 4 ]]; then
            print_status $YELLOW "    ⚠️  Deep nesting detected (line $line_num)"
            issues=$((issues + 1))
            brace_count=0  # Reset to avoid spam
        fi
        
    done < "$file"
    
    # Check final function
    if [[ "$in_function" == true ]]; then
        local function_length=$((line_num - function_start))
        if [[ $function_length -gt 50 ]]; then
            print_status $YELLOW "    ⚠️  Function '$function_name' is long ($function_length lines)"
            issues=$((issues + 1))
        fi
    fi
    
    return $issues
}

# Function to lint a single file
lint_file() {
    local file=$1
    local file_issues=0
    
    echo ""
    print_status $BLUE "📄 $(basename "$file")"
    
    # Run all checks
    local syntax_issues=0
    local style_issues=0
    local naming_issues=0
    local complexity_issues=0
    
    if check_syntax "$file"; then
        syntax_issues=$?
    fi
    
    if check_style "$file"; then
        style_issues=$?
    fi
    
    if check_naming "$file"; then
        naming_issues=$?
    fi
    
    if check_complexity "$file"; then
        complexity_issues=$?
    fi
    
    file_issues=$((syntax_issues + style_issues + naming_issues + complexity_issues))
    
    if [[ $file_issues -eq 0 ]]; then
        print_status $GREEN "  ✅ No issues found"
    else
        print_status $RED "  ❌ $file_issues issue(s) found"
        files_with_issues=$((files_with_issues + 1))
    fi
    
    total_issues=$((total_issues + file_issues))
    return $file_issues
}

# Function to print usage
print_usage() {
    echo "NeuroVis GDScript Linter"
    echo ""
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  --syntax           Check syntax only"
    echo "  --style            Check style only"
    echo "  --naming           Check naming conventions only"
    echo "  --complexity       Check complexity only"
    echo "  --fix              Fix auto-fixable issues"
    echo "  --staged           Check staged files only"
    echo "  -v, --verbose      Verbose output"
    echo "  -h, --help         Show this help"
    echo ""
    echo "Environment Variables:"
    echo "  GODOT_PATH         Path to Godot binary"
    echo ""
    echo "Examples:"
    echo "  $0                 Run all checks"
    echo "  $0 --style --fix   Check and fix style issues"
    echo "  $0 --staged        Check staged files only"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --syntax)
            CHECK_STYLE=false
            CHECK_NAMING=false
            CHECK_COMPLEXITY=false
            shift
            ;;
        --style)
            CHECK_SYNTAX=false
            CHECK_NAMING=false
            CHECK_COMPLEXITY=false
            shift
            ;;
        --naming)
            CHECK_SYNTAX=false
            CHECK_STYLE=false
            CHECK_COMPLEXITY=false
            shift
            ;;
        --complexity)
            CHECK_SYNTAX=false
            CHECK_STYLE=false
            CHECK_NAMING=false
            shift
            ;;
        --fix)
            FIX_ISSUES=true
            shift
            ;;
        --staged)
            STAGED_ONLY=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            print_usage
            exit 0
            ;;
        *)
            print_status $RED "Unknown option: $1"
            print_usage
            exit 1
            ;;
    esac
done

# Main execution
main() {
    print_status $BLUE "🔍 NeuroVis GDScript Linter"
    
    if [[ "$STAGED_ONLY" == true ]]; then
        print_status $BLUE "Mode: Staged files only"
    else
        print_status $BLUE "Mode: All project files"
    fi
    
    echo ""
    
    # Check if Godot is available for syntax checking
    check_godot
    
    # Get files to lint
    local files
    files=$(get_gdscript_files)
    
    if [[ -z "$files" ]]; then
        print_status $YELLOW "⚠️  No GDScript files found to lint"
        exit 0
    fi
    
    total_files=$(echo "$files" | wc -l)
    print_status $BLUE "Found $total_files GDScript file(s) to lint"
    
    # Lint each file
    local failed_files=0
    for file in $files; do
        if ! lint_file "$file"; then
            failed_files=$((failed_files + 1))
        fi
    done
    
    # Print summary
    print_section "Linting Summary"
    print_status $BLUE "Files checked: $total_files"
    
    if [[ $files_with_issues -eq 0 ]]; then
        print_status $GREEN "Files with issues: $files_with_issues"
    else
        print_status $YELLOW "Files with issues: $files_with_issues"
    fi
    
    if [[ $total_issues -eq 0 ]]; then
        print_status $GREEN "Total issues: $total_issues"
        print_status $GREEN "🎉 All files passed linting!"
        exit 0
    else
        print_status $RED "Total issues: $total_issues"
        print_status $YELLOW "💡 Run with --fix to auto-fix some issues"
        exit 1
    fi
}

# Run main function
main "$@"