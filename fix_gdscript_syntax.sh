#!/bin/bash
# NeuroVis GDScript Syntax Fixer Wrapper
# Fixes recurring GDScript syntax issues like indentation, class structure, and control flow problems

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PYTHON_SCRIPT="$SCRIPT_DIR/fix_gdscript_syntax.py"

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Check if Python is available
check_python() {
    if command -v python3 >/dev/null 2>&1; then
        PYTHON_CMD="python3"
    elif command -v python >/dev/null 2>&1; then
        PYTHON_CMD="python"
    else
        print_status $RED "❌ Python not found. Please install Python 3.x"
        exit 1
    fi
    
    print_status $GREEN "✅ Using Python: $PYTHON_CMD"
}

# Main execution
main() {
    print_status $BLUE "🔧 NeuroVis GDScript Syntax Fixer"
    print_status $BLUE "Fixes: Indentation, Class Structure, Control Flow Issues"
    echo ""
    
    # Check Python availability
    check_python
    
    # Check if Python script exists
    if [[ ! -f "$PYTHON_SCRIPT" ]]; then
        print_status $RED "❌ Python fixer script not found: $PYTHON_SCRIPT"
        exit 1
    fi
    
    # Warning message
    print_status $YELLOW "⚠️  This will modify your GDScript files!"
    print_status $YELLOW "   Backups will be created automatically."
    echo ""
    read -p "Continue? (y/n) " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status $YELLOW "Operation cancelled."
        exit 0
    fi
    
    # Run the Python fixer
    print_status $BLUE "🚀 Running GDScript syntax fixer..."
    echo ""
    
    if "$PYTHON_CMD" "$PYTHON_SCRIPT" "$SCRIPT_DIR"; then
        echo ""
        print_status $GREEN "✅ GDScript syntax fixing completed!"
        echo ""
        print_status $BLUE "💡 Recommended next steps:"
        print_status $BLUE "   1. Test your project in Godot editor"
        print_status $BLUE "   2. Run: ./validate_godot4_syntax.sh"
        print_status $BLUE "   3. If issues persist, check backup files"
        echo ""
    else
        echo ""
        print_status $RED "❌ Syntax fixing failed!"
        print_status $YELLOW "   Check the output above for specific errors"
        exit 1
    fi
}

# Help function
show_help() {
    echo "NeuroVis GDScript Syntax Fixer"
    echo ""
    echo "This script fixes common GDScript syntax issues:"
    echo "  • Indentation problems"
    echo "  • Class structure issues" 
    echo "  • Control flow statement placement"
    echo "  • Orphaned code blocks"
    echo "  • Malformed variable declarations"
    echo ""
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help    Show this help message"
    echo ""
    echo "The script will:"
    echo "  1. Create automatic backups of all modified files"
    echo "  2. Fix syntax issues in all .gd files"
    echo "  3. Provide a summary of changes made"
    echo ""
    echo "Backup files are stored in: syntax_fix_backup_[timestamp]/"
}

# Parse command line arguments
case "${1:-}" in
    -h|--help)
        show_help
        exit 0
        ;;
    *)
        main "$@"
        ;;
esac
