#!/bin/bash
# NeuroVis Test Runner
# Executes all tests in the project with proper reporting

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
TESTS_DIR="$PROJECT_ROOT/tests"
TOOLS_DIR="$PROJECT_ROOT/tools"
REPORTS_DIR="$PROJECT_ROOT/tools/reports"
GODOT_BINARY="${GODOT_PATH:-godot}"

# Test configuration
RUN_UNIT_TESTS=true
RUN_INTEGRATION_TESTS=true
RUN_PERFORMANCE_TESTS=false
GENERATE_COVERAGE=false
VERBOSE_OUTPUT=false

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
        print_status $RED "❌ Godot not found in PATH"
        print_status $YELLOW "Set GODOT_PATH environment variable or ensure godot is in PATH"
        exit 1
    fi
    
    print_status $GREEN "✅ Godot found: $GODOT_BINARY"
}

# Function to setup test environment
setup_test_environment() {
    print_section "Setting up test environment"
    
    # Create reports directory
    mkdir -p "$REPORTS_DIR"
    
    # Validate test directory structure
    if [[ ! -d "$TESTS_DIR" ]]; then
        print_status $RED "❌ Tests directory not found: $TESTS_DIR"
        exit 1
    fi
    
    print_status $GREEN "✅ Test environment ready"
}

# Function to run unit tests
run_unit_tests() {
    if [[ "$RUN_UNIT_TESTS" != true ]]; then
        return 0
    fi
    
    print_section "Running Unit Tests"
    
    local unit_tests_dir="$TESTS_DIR/unit"
    if [[ ! -d "$unit_tests_dir" ]]; then
        print_status $YELLOW "⚠️  Unit tests directory not found: $unit_tests_dir"
        return 0
    fi
    
    local test_files=$(find "$unit_tests_dir" -name "*Test.gd" -o -name "*_test.gd")
    if [[ -z "$test_files" ]]; then
        print_status $YELLOW "⚠️  No unit test files found"
        return 0
    fi
    
    local total_tests=0
    local passed_tests=0
    local failed_tests=0
    
    print_status $BLUE "Found unit test files:"
    for test_file in $test_files; do
        echo "  - $(basename "$test_file")"
        total_tests=$((total_tests + 1))
    done
    
    # Run each test file
    for test_file in $test_files; do
        local test_name=$(basename "$test_file" .gd)
        echo ""
        print_status $BLUE "Running: $test_name"
        
        if run_single_test "$test_file"; then
            print_status $GREEN "  ✅ PASSED: $test_name"
            passed_tests=$((passed_tests + 1))
        else
            print_status $RED "  ❌ FAILED: $test_name"
            failed_tests=$((failed_tests + 1))
        fi
    done
    
    # Summary
    echo ""
    print_status $BLUE "Unit Tests Summary:"
    print_status $GREEN "  Passed: $passed_tests"
    if [[ $failed_tests -gt 0 ]]; then
        print_status $RED "  Failed: $failed_tests"
    else
        print_status $GREEN "  Failed: $failed_tests"
    fi
    print_status $BLUE "  Total: $total_tests"
    
    return $failed_tests
}

# Function to run integration tests
run_integration_tests() {
    if [[ "$RUN_INTEGRATION_TESTS" != true ]]; then
        return 0
    fi
    
    print_section "Running Integration Tests"
    
    local integration_tests_dir="$TESTS_DIR/integration"
    if [[ ! -d "$integration_tests_dir" ]]; then
        print_status $YELLOW "⚠️  Integration tests directory not found: $integration_tests_dir"
        return 0
    fi
    
    local test_files=$(find "$integration_tests_dir" -name "*Test.gd" -o -name "*_test.gd")
    if [[ -z "$test_files" ]]; then
        print_status $YELLOW "⚠️  No integration test files found"
        return 0
    fi
    
    print_status $BLUE "Found integration test files:"
    for test_file in $test_files; do
        echo "  - $(basename "$test_file")"
    done
    
    # Run integration tests (may require different approach)
    local failed_integration=0
    for test_file in $test_files; do
        local test_name=$(basename "$test_file" .gd)
        echo ""
        print_status $BLUE "Running: $test_name"
        
        if run_single_test "$test_file"; then
            print_status $GREEN "  ✅ PASSED: $test_name"
        else
            print_status $RED "  ❌ FAILED: $test_name"
            failed_integration=$((failed_integration + 1))
        fi
    done
    
    return $failed_integration
}

# Function to run performance tests
run_performance_tests() {
    if [[ "$RUN_PERFORMANCE_TESTS" != true ]]; then
        return 0
    fi
    
    print_section "Running Performance Tests"
    
    local performance_tests_dir="$TESTS_DIR/performance"
    if [[ ! -d "$performance_tests_dir" ]]; then
        print_status $YELLOW "⚠️  Performance tests directory not found: $performance_tests_dir"
        return 0
    fi
    
    # Performance tests implementation
    print_status $YELLOW "⚠️  Performance tests not yet implemented"
    return 0
}

# Function to run a single test file
run_single_test() {
    local test_file=$1
    local output_file="$REPORTS_DIR/$(basename "$test_file" .gd).log"
    
    # Basic test execution (adjust based on your test framework)
    # This is a placeholder - replace with actual test execution
    if [[ "$VERBOSE_OUTPUT" == true ]]; then
        if "$GODOT_BINARY" --headless --script "$test_file" > "$output_file" 2>&1; then
            cat "$output_file"
            return 0
        else
            cat "$output_file"
            return 1
        fi
    else
        if "$GODOT_BINARY" --headless --script "$test_file" > "$output_file" 2>&1; then
            return 0
        else
            if [[ -s "$output_file" ]]; then
                echo "  Error output:"
                tail -n 5 "$output_file" | sed 's/^/    /'
            fi
            return 1
        fi
    fi
}

# Function to generate test reports
generate_reports() {
    print_section "Generating Test Reports"
    
    local report_file="$REPORTS_DIR/test-summary.md"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    cat > "$report_file" << EOF
# NeuroVis Test Report
Generated: $timestamp

## Test Execution Summary

### Unit Tests
- Status: $([[ "$RUN_UNIT_TESTS" == true ]] && echo "Executed" || echo "Skipped")
- Files: $(find "$TESTS_DIR/unit" -name "*Test.gd" -o -name "*_test.gd" 2>/dev/null | wc -l || echo "0")

### Integration Tests
- Status: $([[ "$RUN_INTEGRATION_TESTS" == true ]] && echo "Executed" || echo "Skipped")
- Files: $(find "$TESTS_DIR/integration" -name "*Test.gd" -o -name "*_test.gd" 2>/dev/null | wc -l || echo "0")

### Performance Tests
- Status: $([[ "$RUN_PERFORMANCE_TESTS" == true ]] && echo "Executed" || echo "Skipped")

## Test Logs
Individual test logs are available in: \`tools/reports/\`

## Environment
- Godot: $("$GODOT_BINARY" --version 2>/dev/null | head -n1 || echo "Unknown")
- Platform: $(uname -s)
- Project: NeuroVis
EOF
    
    print_status $GREEN "✅ Test report generated: $report_file"
}

# Function to print usage
print_usage() {
    echo "NeuroVis Test Runner"
    echo ""
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -u, --unit           Run unit tests only"
    echo "  -i, --integration    Run integration tests only"
    echo "  -p, --performance    Include performance tests"
    echo "  -c, --coverage       Generate coverage report"
    echo "  -v, --verbose        Verbose output"
    echo "  -h, --help           Show this help"
    echo ""
    echo "Environment Variables:"
    echo "  GODOT_PATH          Path to Godot binary"
    echo ""
    echo "Examples:"
    echo "  $0                   Run all tests"
    echo "  $0 -u                Run unit tests only"
    echo "  $0 -i -v             Run integration tests with verbose output"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -u|--unit)
            RUN_UNIT_TESTS=true
            RUN_INTEGRATION_TESTS=false
            RUN_PERFORMANCE_TESTS=false
            shift
            ;;
        -i|--integration)
            RUN_UNIT_TESTS=false
            RUN_INTEGRATION_TESTS=true
            RUN_PERFORMANCE_TESTS=false
            shift
            ;;
        -p|--performance)
            RUN_PERFORMANCE_TESTS=true
            shift
            ;;
        -c|--coverage)
            GENERATE_COVERAGE=true
            shift
            ;;
        -v|--verbose)
            VERBOSE_OUTPUT=true
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
    print_status $BLUE "🧪 NeuroVis Test Runner"
    print_status $BLUE "Project: $PROJECT_ROOT"
    echo ""
    
    # Validate environment
    check_godot
    setup_test_environment
    
    # Track overall results
    local total_failures=0
    
    # Run test suites
    if ! run_unit_tests; then
        total_failures=$((total_failures + $?))
    fi
    
    if ! run_integration_tests; then
        total_failures=$((total_failures + $?))
    fi
    
    if ! run_performance_tests; then
        total_failures=$((total_failures + $?))
    fi
    
    # Generate reports
    generate_reports
    
    # Final summary
    print_section "Test Execution Complete"
    
    if [[ $total_failures -eq 0 ]]; then
        print_status $GREEN "🎉 All tests passed!"
        exit 0
    else
        print_status $RED "❌ $total_failures test(s) failed"
        exit 1
    fi
}

# Run main function
main "$@"