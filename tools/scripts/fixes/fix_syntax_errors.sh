#!/bin/bash
# NeuroVis Syntax Error Fix - Shell Script
# Comprehensive solution for fixing all preload syntax errors

set -e  # Exit on any error

PROJECT_ROOT="/Users/gagelaporta/Desktop/Neuro/NeuroVis-Repo"
SCRIPT_NAME="fix_preload_syntax.py"

echo "======================================"
echo "NeuroVis Syntax Error Fix Utility"
echo "======================================"
echo "Project: $PROJECT_ROOT"
echo ""

# Check if Python script exists
if [ ! -f "$PROJECT_ROOT/$SCRIPT_NAME" ]; then
    echo "ERROR: $SCRIPT_NAME not found in project root"
    exit 1
fi

# Function to run dry run
run_dry_run() {
    echo "Running DRY RUN to preview changes..."
    echo "--------------------------------------"
    cd "$PROJECT_ROOT"
    python3 "$SCRIPT_NAME" "$PROJECT_ROOT" --dry-run
    echo ""
    echo "DRY RUN COMPLETED"
    echo ""
}

# Function to apply fixes
apply_fixes() {
    echo "Applying syntax fixes..."
    echo "------------------------"
    cd "$PROJECT_ROOT"
    python3 "$SCRIPT_NAME" "$PROJECT_ROOT"
    echo ""
    echo "FIXES APPLIED"
    echo ""
}

# Function to test compilation
test_compilation() {
    echo "Testing Godot project compilation..."
    echo "-----------------------------------"
    
    # Check if godot is available
    if command -v godot &> /dev/null; then
        echo "Testing project compilation with Godot..."
        cd "$PROJECT_ROOT"
        
        # Try to export to test compilation (doesn't create actual export)
        timeout 30s godot --headless --check-only . 2>&1 | head -20
        
        if [ $? -eq 0 ]; then
            echo "✓ Project compilation test PASSED"
        else
            echo "⚠ Project compilation test had issues (check output above)"
        fi
    else
        echo "⚠ Godot not found in PATH, skipping compilation test"
        echo "  You can test manually by opening project in Godot"
    fi
    echo ""
}

# Function to validate autoloads
validate_autoloads() {
    echo "Validating autoload configuration..."
    echo "-----------------------------------"
    
    # Check if project.godot exists and has autoloads
    if [ -f "$PROJECT_ROOT/project.godot" ]; then
        echo "Autoloads configured in project.godot:"
        grep -A 20 "\\[autoload\\]" "$PROJECT_ROOT/project.godot" | grep -v "^$" | head -15
        echo ""
        
        # Check if autoload files exist
        echo "Checking autoload file existence:"
        while IFS= read -r line; do
            if [[ $line =~ ^[A-Za-z].*=.*res:// ]]; then
                file_path=$(echo "$line" | sed 's/.*res:\/\///' | sed 's/".*$//')
                full_path="$PROJECT_ROOT/$file_path"
                if [ -f "$full_path" ]; then
                    echo "✓ $file_path"
                else
                    echo "✗ $file_path (MISSING)"
                fi
            fi
        done < <(grep -A 20 "\\[autoload\\]" "$PROJECT_ROOT/project.godot")
    else
        echo "⚠ project.godot not found"
    fi
    echo ""
}

# Main menu
show_menu() {
    echo "Choose an action:"
    echo "1) Dry run (preview changes only)"
    echo "2) Apply fixes (with backup)"
    echo "3) Test compilation" 
    echo "4) Validate autoloads"
    echo "5) Complete workflow (dry run → apply → test)"
    echo "6) Exit"
    echo ""
    read -p "Enter choice [1-6]: " choice
    
    case $choice in
        1)
            run_dry_run
            show_menu
            ;;
        2)
            apply_fixes
            show_menu
            ;;
        3)
            test_compilation
            show_menu
            ;;
        4)
            validate_autoloads
            show_menu
            ;;
        5)
            echo "Running complete workflow..."
            echo "============================"
            run_dry_run
            echo ""
            read -p "Apply fixes? [y/N]: " confirm
            if [[ $confirm =~ ^[Yy]$ ]]; then
                apply_fixes
                test_compilation
                validate_autoloads
                echo "COMPLETE WORKFLOW FINISHED"
            else
                echo "Workflow cancelled"
            fi
            show_menu
            ;;
        6)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please try again."
            show_menu
            ;;
    esac
}

# Check Python availability
if ! command -v python3 &> /dev/null; then
    echo "ERROR: Python 3 is required but not found"
    exit 1
fi

# Start the menu
show_menu