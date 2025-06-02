#!/bin/bash
# NeuroVis Parser Error Checker
# Comprehensive parser error detection and prevention tool

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
GODOT_BINARY="${GODOT_PATH:-/Applications/Godot.app/Contents/MacOS/Godot}"
LOG_FILE="$PROJECT_ROOT/parser_errors.log"

# Statistics
total_files=0
files_with_errors=0
total_errors=0
total_warnings=0

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

# Function to log messages
log_message() {
    local level=$1
    local message=$2
    echo "$(date '+%Y-%m-%d %H:%M:%S') [$level] $message" >> "$LOG_FILE"
}

# Function to check if Godot is available
check_godot() {
    if [[ -f "$GODOT_BINARY" ]]; then
        print_status $GREEN "✅ Godot found: $GODOT_BINARY"
        return 0
    elif command -v godot >/dev/null 2>&1; then
        GODOT_BINARY="godot"
        print_status $GREEN "✅ Godot found in PATH"
        return 0
    else
        print_status $RED "❌ Godot not found"
        print_status $YELLOW "   Please set GODOT_PATH or install Godot in PATH"
        return 1
    fi
}

# Function to get all GDScript files
get_gdscript_files() {
    find "$PROJECT_ROOT" -name "*.gd" \
        -not -path "*/.godot/*" \
        -not -path "*/tmp/*" \
        -not -path "*/build/*" \
        -not -path "*/export/*" \
        -not -path "*/archive*/*" \
        | sort
}

# Function to check syntax using Godot
check_syntax() {
    local file=$1
    local errors=0
    
    print_status $CYAN "📄 Checking: $(basename "$file")"
    
    # Use Godot to check syntax
    local output
    if output=$("$GODOT_BINARY" --check-only --script "$file" 2>&1); then
        print_status $GREEN "  ✅ Syntax OK"
        log_message "INFO" "Syntax OK: $file"
    else
        print_status $RED "  ❌ Syntax Error:"
        echo "$output" | sed 's/^/    /'
        log_message "ERROR" "Syntax error in $file: $output"
        errors=1
        files_with_errors=$((files_with_errors + 1))
    fi
    
    total_errors=$((total_errors + errors))
    return $errors
}

# Function to check for common parser error patterns
check_common_patterns() {
    local file=$1
    local warnings=0
    
    # Check for Godot 3 vs Godot 4 compatibility issues
    
    # Old export syntax
    if grep -n "^export " "$file" >/dev/null 2>&1; then
        print_status $YELLOW "  ⚠️  Old export syntax (use @export)"
        grep -n "^export " "$file" | head -3 | sed 's/^/    Line /'
        warnings=$((warnings + 1))
    fi
    
    # Old tool syntax
    if grep -n "^tool$" "$file" >/dev/null 2>&1; then
        print_status $YELLOW "  ⚠️  Old tool syntax (use @tool)"
        warnings=$((warnings + 1))
    fi
    
    # Check for potential circular dependencies
    local preload_count=$(grep -c "preload(" "$file" 2>/dev/null || echo 0)
    if [[ $preload_count -gt 10 ]]; then
        print_status $YELLOW "  ⚠️  Many preload statements ($preload_count) - check for circular deps"
        warnings=$((warnings + 1))
    fi
    
    # Check for missing type hints on functions
    if grep -n "^func [^_].*:" "$file" | grep -v " -> " >/dev/null 2>&1; then
        print_status $YELLOW "  ⚠️  Functions missing return type hints"
        warnings=$((warnings + 1))
    fi
    
    # Check for old signal connect syntax
    if grep -n "\.connect(" "$file" | grep -v "\.connect.*bind(" >/dev/null 2>&1; then
        print_status $YELLOW "  ⚠️  Check signal connections for Godot 4 compatibility"
        warnings=$((warnings + 1))
    fi
    
    # Check for potential resource loading issues
    if grep -n "load(\"res://" "$file" | grep -v "ResourceLoader.exists" >/dev/null 2>&1; then
        print_status $YELLOW "  ⚠️  Direct load() without existence check"
        warnings=$((warnings + 1))
    fi
    
    total_warnings=$((total_warnings + warnings))
    return $warnings
}

# Function to check scene file references
check_scene_references() {
    local file=$1
    local errors=0
    
    # Extract scene paths from preload statements
    local scene_paths=$(grep "preload(\".*\.tscn\")" "$file" | sed 's/.*preload("\([^"]*\)").*/\1/')
    
    for scene_path in $scene_paths; do
        # Convert res:// path to actual file path
        local actual_path="${scene_path#res://}"
        actual_path="$PROJECT_ROOT/$actual_path"
        
        if [[ ! -f "$actual_path" ]]; then
            print_status $RED "  ❌ Missing scene file: $scene_path"
            errors=$((errors + 1))
        fi
    done
    
    return $errors
}

# Function to check autoload dependencies
check_autoload_dependencies() {
    local file=$1
    local errors=0
    
    # Check for autoload usage
    local autoload_refs=$(grep -n "Engine.get_singleton\|Engine.has_singleton" "$file" | wc -l)
    
    if [[ $autoload_refs -gt 0 ]]; then
        print_status $CYAN "  🔗 Uses autoloads ($autoload_refs references)"
        
        # Extract autoload names
        local autoloads=$(grep -o "Engine\.get_singleton(\"\w*\")" "$file" | sed 's/Engine\.get_singleton("\([^"]*\)").*/\1/' | sort -u)
        
        for autoload in $autoloads; do
            # Check if autoload is defined in project.godot (simplified check)
            if ! grep -q "^$autoload=" "$PROJECT_ROOT/project.godot" 2>/dev/null; then
                print_status $YELLOW "    ⚠️  Autoload '$autoload' not found in project.godot"
                warnings=$((warnings + 1))
            fi
        done
    fi
    
    return $errors
}

# Function to validate tool scripts
check_tool_scripts() {
    local file=$1
    local warnings=0
    
    if grep -q "^@tool" "$file" || grep -q "^tool$" "$file"; then
        print_status $PURPLE "  🔧 Tool script detected"
        
        # Check for potential editor-time issues
        if grep -q "_ready()" "$file"; then
            print_status $YELLOW "    ⚠️  Tool script with _ready() - ensure editor-safe"
            warnings=$((warnings + 1))
        fi
        
        if grep -q "get_tree()" "$file"; then
            print_status $YELLOW "    ⚠️  Tool script uses scene tree - check editor compatibility"
            warnings=$((warnings + 1))
        fi
    fi
    
    total_warnings=$((total_warnings + warnings))
    return $warnings
}

# Function to check for performance issues
check_performance_patterns() {
    local file=$1
    local warnings=0
    
    # Check for potential infinite loops
    if grep -n "while true:" "$file" >/dev/null 2>&1; then
        print_status $YELLOW "  ⚠️  Infinite loop pattern detected"
        warnings=$((warnings + 1))
    fi
    
    # Check for expensive operations in _process
    if grep -A 20 "func _process" "$file" | grep -E "load\(|find_node\(|get_children\(" >/dev/null 2>&1; then
        print_status $YELLOW "  ⚠️  Expensive operations in _process()"
        warnings=$((warnings + 1))
    fi
    
    # Check for missing @onready on node references
    if grep -n "var.*get_node" "$file" >/dev/null 2>&1; then
        print_status $YELLOW "  ⚠️  get_node() in variable declaration - consider @onready"
        warnings=$((warnings + 1))
    fi
    
    total_warnings=$((total_warnings + warnings))
    return $warnings
}

# Function to run comprehensive file check
check_file() {
    local file=$1
    total_files=$((total_files + 1))
    
    # Basic syntax check
    check_syntax "$file"
    
    # Pattern checks
    check_common_patterns "$file"
    
    # Scene reference check
    check_scene_references "$file"
    
    # Autoload dependency check
    check_autoload_dependencies "$file"
    
    # Tool script validation
    check_tool_scripts "$file"
    
    # Performance pattern check
    check_performance_patterns "$file"
    
    echo ""
}

# Function to generate summary report
generate_summary() {
    print_section "Parser Error Check Summary"
    
    print_status $BLUE "Files checked: $total_files"
    
    if [[ $files_with_errors -eq 0 ]]; then
        print_status $GREEN "Files with errors: $files_with_errors"
    else
        print_status $RED "Files with errors: $files_with_errors"
    fi
    
    if [[ $total_errors -eq 0 ]]; then
        print_status $GREEN "Total errors: $total_errors"
    else
        print_status $RED "Total errors: $total_errors"
    fi
    
    if [[ $total_warnings -eq 0 ]]; then
        print_status $GREEN "Total warnings: $total_warnings"
    else
        print_status $YELLOW "Total warnings: $total_warnings"
    fi
    
    # Overall health assessment
    local error_rate=$((files_with_errors * 100 / total_files))
    
    echo ""
    if [[ $total_errors -eq 0 && $total_warnings -eq 0 ]]; then
        print_status $GREEN "🎉 Perfect! No issues found."
    elif [[ $total_errors -eq 0 && $total_warnings -lt 5 ]]; then
        print_status $GREEN "✅ Excellent - Only minor warnings"
    elif [[ $error_rate -lt 5 ]]; then
        print_status $YELLOW "⚠️  Good - Few issues to address"
    elif [[ $error_rate -lt 20 ]]; then
        print_status $YELLOW "🔶 Needs attention - Several issues found"
    else
        print_status $RED "🚨 Critical - Many issues require immediate attention"
    fi
    
    echo ""
    print_status $BLUE "Log file: $LOG_FILE"
    
    if [[ $total_errors -gt 0 ]]; then
        echo ""
        print_status $YELLOW "Next steps:"
        echo "  1. Fix syntax errors using Godot editor"
        echo "  2. Run: ./tools/quality/lint-gdscript.sh --fix"
        echo "  3. Check specific files mentioned above"
        echo "  4. Re-run this script to verify fixes"
    fi
}

# Function to print usage
print_usage() {
    echo "NeuroVis Parser Error Checker"
    echo ""
    echo "Usage: $0 [options] [file]"
    echo ""
    echo "Options:"
    echo "  --quick           Quick check (syntax only)"
    echo "  --verbose         Verbose output"
    echo "  --file FILE       Check specific file"
    echo "  -h, --help        Show this help"
    echo ""
    echo "Examples:"
    echo "  $0                Check all GDScript files"
    echo "  $0 --quick        Quick syntax check only"
    echo "  $0 --file script.gd  Check specific file"
}

# Parse command line arguments
QUICK_MODE=false
VERBOSE=false
TARGET_FILE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --quick)
            QUICK_MODE=true
            shift
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        --file)
            TARGET_FILE="$2"
            shift 2
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
    print_status $BLUE "🔍 NeuroVis Parser Error Checker"
    print_status $BLUE "================================"
    
    # Initialize log file
    echo "Parser error check started at $(date)" > "$LOG_FILE"
    
    # Check if Godot is available
    if ! check_godot; then
        exit 1
    fi
    
    echo ""
    
    # Get files to check
    if [[ -n "$TARGET_FILE" ]]; then
        if [[ ! -f "$TARGET_FILE" ]]; then
            print_status $RED "❌ File not found: $TARGET_FILE"
            exit 1
        fi
        files=("$TARGET_FILE")
    else
        files=($(get_gdscript_files))
    fi
    
    if [[ ${#files[@]} -eq 0 ]]; then
        print_status $YELLOW "⚠️  No GDScript files found to check"
        exit 0
    fi
    
    print_status $BLUE "Found ${#files[@]} GDScript file(s) to check"
    
    # Check each file
    for file in "${files[@]}"; do
        if [[ "$QUICK_MODE" == true ]]; then
            check_syntax "$file"
        else
            check_file "$file"
        fi
    done
    
    # Generate summary
    generate_summary
    
    # Exit with appropriate code
    if [[ $total_errors -gt 0 ]]; then
        exit 1
    else
        exit 0
    fi
}

# Run main function
main "$@"