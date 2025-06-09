#!/bin/bash
# Comprehensive Shell Script Linting Fix
# This script fixes all ShellCheck issues found in the NeuroVis project

set -e

echo "🔧 Comprehensive Shell Script Linting Fix"
echo "========================================"

# Create backup directory
BACKUP_DIR="./shell_script_backups_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "📁 Creating backups in: $BACKUP_DIR"

# Install missing Python tools
echo ""
echo "📦 Installing Python linting tools..."
pip3 install flake8 black pylint

# Function to backup and fix a file
fix_shell_file() {
    local file=$1
    local filename=$(basename "$file")

    echo "🔧 Fixing: $file"

    # Create backup
    cp "$file" "$BACKUP_DIR/$filename.backup"

    # Fix SC2086: Quote variables
    sed -i '' 's/print_status \$RED "/print_status "$RED" "/g' "$file"
    sed -i '' 's/print_status \$GREEN "/print_status "$GREEN" "/g' "$file"
    sed -i '' 's/print_status \$YELLOW "/print_status "$YELLOW" "/g' "$file"
    sed -i '' 's/print_status \$BLUE "/print_status "$BLUE" "/g' "$file"

    echo "  ✅ Fixed quoting issues in $filename"
}

# Function to fix declare/assign issues
fix_declare_assign() {
    local file=$1
    local filename=$(basename "$file")

    echo "🔧 Fixing declare/assign issues in: $filename"

    # Fix specific SC2155 issues from the test-runner.sh
    if [[ "$filename" == "test-runner.sh" ]]; then
        # Fix: local test_files=$(find...)
        sed -i '' 's/local test_files=\$(find/local test_files\
    test_files=\$(find/g' "$file"

        # Fix: local test_name=$(basename...)
        sed -i '' 's/local test_name=\$(basename/local test_name\
        test_name=\$(basename/g' "$file"

        # Fix: local output_file=$(...)
        sed -i '' 's/local output_file=\$(/local output_file\
    output_file=\$(/g' "$file"

        # Fix: local timestamp=$(date...)
        sed -i '' 's/local timestamp=\$(date/local timestamp\
    timestamp=\$(date/g' "$file"

        echo "  ✅ Fixed declare/assign issues in $filename"
    fi
}

# Function to remove unused variables
remove_unused_variables() {
    local file=$1
    local filename=$(basename "$file")

    echo "🧹 Removing unused variables in: $filename"

    if [[ "$filename" == "test-runner.sh" ]]; then
        # Remove unused TOOLS_DIR
        sed -i '' '/^TOOLS_DIR="/d' "$file"

        # Remove unused GENERATE_COVERAGE assignment (keep the declaration for CLI parsing)
        sed -i '' '/^            GENERATE_COVERAGE=true$/d' "$file"

        echo "  ✅ Removed unused variables in $filename"
    fi
}

echo ""
echo "🛠️  Fixing shell scripts..."

# Fix the main problematic files
if [[ -f "tools/git-hooks/install-hooks.sh" ]]; then
    fix_shell_file "tools/git-hooks/install-hooks.sh"
fi

if [[ -f "tools/quality/test-runner.sh" ]]; then
    fix_shell_file "tools/quality/test-runner.sh"
    fix_declare_assign "tools/quality/test-runner.sh"
    remove_unused_variables "tools/quality/test-runner.sh"
fi

# Also fix any other shell scripts with similar issues
echo ""
echo "🔍 Checking for other shell scripts to fix..."
find . -name "*.sh" -not -path "./.git/*" -not -path "./shell_script_backups*" | while read -r script; do
    if grep -q "print_status \$[A-Z]" "$script" 2>/dev/null; then
        echo "Found similar issues in: $script"
        fix_shell_file "$script"
    fi
done

echo ""
echo "✅ Shell script fixes complete!"
echo ""
echo "📋 Summary of fixes applied:"
echo "  • SC2086: Quoted all color variables in print_status calls"
echo "  • SC2155: Separated declare and assign statements"
echo "  • SC2034: Removed unused variables (TOOLS_DIR)"
echo "  • Installed Python linting tools (flake8, black, pylint)"
echo ""
echo "📁 Backups saved in: $BACKUP_DIR"
echo ""
echo "🧪 Test the fixes:"
echo "  shellcheck tools/git-hooks/install-hooks.sh"
echo "  shellcheck tools/quality/test-runner.sh"
echo "  flake8 --max-line-length=88 *.py"
echo ""
echo "🚀 Run linting on all files:"
echo "  pre-commit run --all-files"
