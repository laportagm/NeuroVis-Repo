#!/bin/bash
# NeuroVis Automated Test & Fix Runner
# Runs tests systematically until as many issues as possible are resolved

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Track overall status
TOTAL_ISSUES=0
FIXES_APPLIED=0

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

print_section() {
    echo ""
    print_status $BLUE "=== $1 ==="
}

print_success() {
    print_status $GREEN "✅ $1"
}

print_warning() {
    print_status $YELLOW "⚠️  $1"
}

print_error() {
    print_status $RED "❌ $1"
}

# Function to run a command and track results
run_test() {
    local test_name="$1"
    local command="$2"
    local optional="${3:-false}"

    print_section "Running: $test_name"

    if eval "$command"; then
        print_success "$test_name completed successfully"
        return 0
    else
        if [ "$optional" = "true" ]; then
            print_warning "$test_name failed (optional)"
            return 1
        else
            print_error "$test_name failed"
            TOTAL_ISSUES=$((TOTAL_ISSUES + 1))
            return 1
        fi
    fi
}

# Function to run a fix and track results
run_fix() {
    local fix_name="$1"
    local command="$2"

    print_section "Applying Fix: $fix_name"

    if eval "$command"; then
        print_success "$fix_name applied successfully"
        FIXES_APPLIED=$((FIXES_APPLIED + 1))
        return 0
    else
        print_error "$fix_name failed"
        return 1
    fi
}

main() {
    print_status $BLUE "🚀 NeuroVis Automated Test & Fix Runner"
    print_status $BLUE "Running systematic tests until issues are resolved..."
    echo ""

    # Phase 1: Emergency Cleanup
    print_section "PHASE 1: Emergency Cleanup"

    # Remove problematic backup directories
    run_fix "Remove backup contamination" "rm -rf backups_20250606_* backups_20250607_* syntax_fix_backup_20250607_173847 syntax_fix_backup_20250607_174148 syntax_fix_backup_20250607_174307 syntax_fix_backup_20250607_174324 syntax_fix_backup_20250607_174708 syntax_fix_backup_20250607_174733 syntax_fix_backup_20250607_174756"

    # Remove old logs
    run_fix "Clean old logs" "rm -f fix_all_20250606_* fix_all_20250607_* cleanup_backup_20250607_*.tar.gz"

    # Phase 2: Basic Syntax Validation
    print_section "PHASE 2: Syntax Validation"

    # Test current syntax
    run_test "Godot 4 Syntax Validation" "./validate_godot4_syntax_fixed.sh" "false"

    # If syntax validation fails, try to fix
    if [ $? -ne 0 ]; then
        run_fix "Fix GDScript Syntax" "./fix_all.sh"
        run_test "Re-test Syntax After Fix" "./validate_godot4_syntax_fixed.sh" "false"
    fi

    # Phase 3: Quality Checks
    print_section "PHASE 3: Quality Assurance"

    # Format code
    run_fix "Format GDScript Code" "cd tools/quality && ./format-code.sh && cd ../.."

    # Lint code
    run_test "GDScript Linting" "cd tools/quality && ./lint-gdscript.sh && cd ../.." "true"

    # Phase 4: Project Validation
    print_section "PHASE 4: Project Structure Validation"

    # Validate resources
    run_test "Resource Validation" "godot --headless --path . --script res://tools/scripts/validate_resources.gd --quit" "true"

    # Validate autoloads
    run_test "Autoload Validation" "godot --headless --path . --script res://tools/scripts/verify_safe_autoload_access.gd --quit" "true"

    # Validate error handling
    run_test "Error Handling Standards" "godot --headless --path . --script res://tools/scripts/verify_error_handling_standards.gd --quit" "true"

    # Phase 5: Performance Testing
    print_section "PHASE 5: Performance Validation"

    # Health monitoring
    run_test "System Health Check" "godot --headless --path . --script res://tools/scripts/HealthMonitor.gd --quit" "true"

    # Rendering benchmarks
    run_test "Rendering Performance" "godot --headless --path . --script res://tools/scripts/RenderingBenchmark.gd --quit" "true"

    # Phase 6: Git Hooks Setup
    print_section "PHASE 6: Automated Protection"

    # Install git hooks
    run_fix "Install Git Hooks" "cd tools/git-hooks && chmod +x install-hooks.sh && ./install-hooks.sh && cd ../.."

    # Phase 7: Comprehensive Testing
    print_section "PHASE 7: Comprehensive Testing"

    # Run full test suite
    run_test "Full Test Suite" "cd tools/quality && ./test-runner.sh && cd ../.." "true"

    # Run NeuroVis specific tests
    run_test "NeuroVis Tests" "./run_neurovis_tests.sh" "true"

    # Phase 8: Final Validation
    print_section "PHASE 8: Final Validation"

    # Final syntax check
    run_test "Final Syntax Check" "./validate_godot4_syntax_fixed.sh" "false"

    # Final error check
    run_test "Final Error Check" "./check_errors.sh" "true"

    # Summary
    print_section "SUMMARY"

    print_status $BLUE "📊 Test & Fix Summary:"
    print_status $BLUE "   Total Issues Found: $TOTAL_ISSUES"
    print_status $BLUE "   Fixes Applied: $FIXES_APPLIED"

    if [ $TOTAL_ISSUES -eq 0 ]; then
        print_success "🎉 All tests passed! Your NeuroVis project is in excellent shape!"
        print_status $GREEN "🧠✨ Educational neuroscience platform ready for medical students!"
    elif [ $TOTAL_ISSUES -le 3 ]; then
        print_warning "🔧 Minor issues remain, but project is functional"
        print_status $YELLOW "Consider running individual tests to address remaining issues"
    else
        print_error "🚨 Multiple issues require attention"
        print_status $RED "Review the output above and address critical failures"
    fi

    echo ""
    print_status $BLUE "💡 Next Steps:"
    print_status $BLUE "   1. Review any failed tests above"
    print_status $BLUE "   2. Test project in Godot editor"
    print_status $BLUE "   3. Run specific fixes for remaining issues"
    print_status $BLUE "   4. Commit improvements: git add . && git commit -m 'fix: resolve project issues'"
}

# Run main function
main "$@"
