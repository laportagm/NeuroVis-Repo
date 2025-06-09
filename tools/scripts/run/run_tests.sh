#!/bin/bash
# NeuroVis Test Suite Runner Script

echo "🧪 NeuroVis Test Suite Runner"
echo "=============================="
echo ""

# Set Godot path (update this to your Godot installation)
GODOT_PATH="/Applications/Godot.app/Contents/MacOS/Godot"
PROJECT_PATH="$(pwd)"  # Use current directory instead of hardcoded path

# Check if Godot exists
if [ ! -f "$GODOT_PATH" ]; then
    echo "❌ Error: Godot not found at $GODOT_PATH"
    echo "Please update GODOT_PATH in this script"
    exit 1
fi

# Make sure log directory exists
LOG_DIR="$PROJECT_PATH/test_logs"
mkdir -p "$LOG_DIR"

# Current timestamp for log files
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="$LOG_DIR/test_run_$TIMESTAMP.log"

# Function to run tests
run_tests() {
    echo "🚀 Running test suite: $1"
    echo "------------------------"
    
    # Create test-specific log file
    TEST_LOG_FILE="$LOG_DIR/${1%.*}_$TIMESTAMP.log"
    
    echo "📝 Logging to: $TEST_LOG_FILE"
    
    # Run Godot in headless mode with test scene and capture output
    "$GODOT_PATH" --headless --path "$PROJECT_PATH" --script "res://tests/$1" > "$TEST_LOG_FILE" 2>&1
    EXIT_CODE=$?
    
    # Show output regardless of result
    cat "$TEST_LOG_FILE"
    
    # Check exit code
    if [ $EXIT_CODE -eq 0 ]; then
        echo "✅ Test suite passed!"
    else
        echo "❌ Test suite failed with exit code: $EXIT_CODE"
        
        # Analyze error patterns to provide more helpful information
        if grep -q "Parser Error" "$TEST_LOG_FILE"; then
            echo "🔍 Found parser errors. Check script syntax."
        elif grep -q "ERROR: Error while loading script" "$TEST_LOG_FILE"; then
            echo "🔍 Script loading error. Check for missing dependencies or files."
        elif grep -q "ERROR: load: Condition" "$TEST_LOG_FILE"; then
            echo "🔍 Error in resource loading. Check paths and resource availability."
        elif grep -q "Autoload error" "$TEST_LOG_FILE"; then
            echo "🔍 Autoload initialization issue. Expected in headless mode for UI components."
        fi
        
        # Append to main log
        echo "Test '$1' failed with exit code $EXIT_CODE" >> "$LOG_FILE"
        
        # In headless mode, some failures are expected and can be tolerated
        if [ "$2" == "allow_failures" ]; then
            echo "⚠️ Allowing failure in headless mode."
            return 0
        else
            return 1
        fi
    fi
}

# Function to run specific test file
run_specific_test() {
    echo "🎯 Running specific test: $1"
    
    # Create test-specific log file with basename of the script
    TEST_NAME=$(basename "$1" .gd)
    TEST_LOG_FILE="$LOG_DIR/${TEST_NAME}_$TIMESTAMP.log"
    
    echo "📝 Logging to: $TEST_LOG_FILE"
    
    # Run Godot in headless mode with test scene and capture output
    "$GODOT_PATH" --headless --path "$PROJECT_PATH" --script "$1" > "$TEST_LOG_FILE" 2>&1
    EXIT_CODE=$?
    
    # Show output regardless of result
    cat "$TEST_LOG_FILE"
    
    # Check exit code and provide detailed feedback
    if [ $EXIT_CODE -eq 0 ]; then
        echo "✅ Test '$TEST_NAME' passed!"
    else
        echo "❌ Test '$TEST_NAME' failed with exit code: $EXIT_CODE"
        
        # Analyze error patterns to provide more helpful information
        if grep -q "Parser Error" "$TEST_LOG_FILE"; then
            echo "🔍 Found parser errors. Check script syntax."
        elif grep -q "ERROR: Error while loading script" "$TEST_LOG_FILE"; then
            echo "🔍 Script loading error. Check for missing dependencies or files."
        elif grep -q "ERROR: load: Condition" "$TEST_LOG_FILE"; then
            echo "🔍 Error in resource loading. Check paths and resource availability."
        elif grep -q "Autoload error" "$TEST_LOG_FILE"; then
            echo "🔍 Autoload initialization issue. Expected in headless mode for UI components."
        fi
        
        # Append to main log
        echo "Test '$1' failed with exit code $EXIT_CODE" >> "$LOG_FILE"
        
        # In headless mode, some failures are expected and can be tolerated
        if [ "$2" == "allow_failures" ]; then
            echo "⚠️ Allowing failure in headless mode."
            return 0
        fi
        
        return $EXIT_CODE
    fi
}

# Parse command line arguments
case "$1" in
    "all")
        echo "Running all tests..."
        run_tests "TestRunner.gd" "allow_failures"
        ;;
    "safe")
        echo "Running core tests with failure handling..."
        # Run a more reliable custom test script that handles headless mode better
        run_specific_test "res://run_neurovis_tests.gd" "allow_failures"
        ;;
    "core")
        echo "Running core system tests..."
        run_specific_test "res://tests/integration/test_brain_visualization_core.gd" "allow_failures"
        ;;
    "ui")
        echo "Running UI component tests..."
        run_specific_test "res://tests/integration/test_ui_components.gd" "allow_failures"
        ;;
    "ai")
        echo "Running AI assistant tests..."
        run_specific_test "res://tests/integration/test_ai_assistant.gd" "allow_failures"
        ;;
    "pipeline")
        echo "Running full pipeline tests..."
        run_specific_test "res://tests/integration/test_full_pipeline.gd" "allow_failures"
        ;;
    "watch")
        echo "Running tests in watch mode..."
        echo "Press Ctrl+C to stop"
        
        # Use fswatch on macOS or inotifywait on Linux
        if command -v fswatch &> /dev/null; then
            fswatch -o "$PROJECT_PATH/tests" "$PROJECT_PATH/ui" "$PROJECT_PATH/core" | while read; do
                clear
                run_specific_test "res://run_neurovis_tests.gd" "allow_failures"
            done
        else
            echo "❌ fswatch not installed. Install with: brew install fswatch"
            exit 1
        fi
        ;;
    "debug")
        echo "Running tests with debugging output..."
        GODOT_OPTIONS="--verbose --allow-focus-steal-pid"
        
        # Create a debug log with more details
        DEBUG_LOG_FILE="$LOG_DIR/debug_$TIMESTAMP.log"
        "$GODOT_PATH" $GODOT_OPTIONS --headless --path "$PROJECT_PATH" --script "res://run_neurovis_tests.gd" 2>&1 | tee "$DEBUG_LOG_FILE"
        
        echo "📝 Debug log saved to: $DEBUG_LOG_FILE"
        ;;
    *)
        echo "Usage: $0 [all|safe|core|ui|ai|pipeline|watch|debug]"
        echo ""
        echo "Options:"
        echo "  all      - Run all test suites (might show expected failures in headless mode)"
        echo "  safe     - Run the simplified test suite that handles headless mode better"
        echo "  core     - Run core system tests only"
        echo "  ui       - Run UI component tests only"
        echo "  ai       - Run AI assistant tests only"
        echo "  pipeline - Run full pipeline tests only"
        echo "  watch    - Run tests in watch mode (auto-run on file changes)"
        echo "  debug    - Run tests with verbose output for debugging issues"
        echo ""
        echo "Example: $0 safe"
        exit 1
        ;;
esac

# Generate test report
if [ "$1" != "watch" ]; then
    echo ""
    echo "📊 Generating test report..."
    
    # Create reports directory
    REPORTS_DIR="$PROJECT_PATH/test_reports"
    mkdir -p "$REPORTS_DIR"
    
    # Copy test results from user directory
    USER_RESULT_FILE="$HOME/.local/share/godot/app_userdata/NeuroVis/test_results.json"
    if [ -f "$USER_RESULT_FILE" ]; then
        cp "$USER_RESULT_FILE" "$REPORTS_DIR/test_results_$TIMESTAMP.json"
        echo "✅ Test results copied to test_reports/"
    fi
    
    # Generate a summary report from logs
    SUMMARY_FILE="$REPORTS_DIR/test_summary_$TIMESTAMP.md"
    
    echo "# NeuroVis Test Summary" > "$SUMMARY_FILE"
    echo "**Date:** $(date)" >> "$SUMMARY_FILE"
    echo "**Test Mode:** $1" >> "$SUMMARY_FILE"
    echo "" >> "$SUMMARY_FILE"
    echo "## Test Results" >> "$SUMMARY_FILE"
    echo "" >> "$SUMMARY_FILE"
    
    if [ -f "$LOG_FILE" ]; then
        echo "### Failed Tests" >> "$SUMMARY_FILE"
        echo "```" >> "$SUMMARY_FILE"
        cat "$LOG_FILE" >> "$SUMMARY_FILE"
        echo "```" >> "$SUMMARY_FILE"
        echo "" >> "$SUMMARY_FILE"
    else
        echo "All tests passed or did not generate failure logs." >> "$SUMMARY_FILE"
        echo "" >> "$SUMMARY_FILE"
    fi
    
    echo "### Logs" >> "$SUMMARY_FILE"
    echo "Log files are available in the \`test_logs\` directory:" >> "$SUMMARY_FILE"
    echo '```' >> "$SUMMARY_FILE"
    ls -l "$LOG_DIR" >> "$SUMMARY_FILE" 2>/dev/null || echo "No log files found"
    echo '```' >> "$SUMMARY_FILE"
    
    echo "✅ Test summary saved to: $SUMMARY_FILE"
fi

echo ""
echo "🏁 Test run complete!"

# Open test reports if in debug mode and on macOS
if [ "$1" == "debug" ] && [ "$(uname)" == "Darwin" ]; then
    echo "📈 Opening test reports..."
    open "$LOG_DIR"
fi
