#!/bin/bash
# Install NeuroVis Git Hooks
# This script installs git hooks for the NeuroVis project

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Get project root
PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
HOOKS_SOURCE_DIR="$PROJECT_ROOT/tools/git-hooks"
HOOKS_TARGET_DIR="$PROJECT_ROOT/.git/hooks"

echo "🔧 Installing NeuroVis Git Hooks..."
echo "Source: $HOOKS_SOURCE_DIR"
echo "Target: $HOOKS_TARGET_DIR"
echo ""

# Check if we're in a git repository
if [[ ! -d "$PROJECT_ROOT/.git" ]]; then
    print_status $RED "❌ Not in a git repository!"
    exit 1
fi

# Check if hooks source directory exists
if [[ ! -d "$HOOKS_SOURCE_DIR" ]]; then
    print_status $RED "❌ Hooks source directory not found: $HOOKS_SOURCE_DIR"
    exit 1
fi

# Create hooks directory if it doesn't exist
mkdir -p "$HOOKS_TARGET_DIR"

# Install hooks
hooks_installed=0
hooks_skipped=0
hooks_failed=0

for hook_file in "$HOOKS_SOURCE_DIR"/*; do
    # Skip this install script and README files
    if [[ "$(basename "$hook_file")" == "install-hooks.sh" ]] || \
       [[ "$(basename "$hook_file")" == "README.md" ]] || \
       [[ "$(basename "$hook_file")" == *.md ]]; then
        continue
    fi
    
    # Skip if not a file
    if [[ ! -f "$hook_file" ]]; then
        continue
    fi
    
    hook_name="$(basename "$hook_file")"
    target_hook="$HOOKS_TARGET_DIR/$hook_name"
    
    echo "Installing hook: $hook_name"
    
    # Check if hook already exists
    if [[ -f "$target_hook" ]]; then
        print_status $YELLOW "⚠️  Hook already exists: $hook_name"
        read -p "Overwrite? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_status $YELLOW "   Skipped: $hook_name"
            hooks_skipped=$((hooks_skipped + 1))
            continue
        fi
    fi
    
    # Copy and make executable
    if cp "$hook_file" "$target_hook" && chmod +x "$target_hook"; then
        print_status $GREEN "   ✅ Installed: $hook_name"
        hooks_installed=$((hooks_installed + 1))
    else
        print_status $RED "   ❌ Failed to install: $hook_name"
        hooks_failed=$((hooks_failed + 1))
    fi
done

echo ""
echo "📊 Installation Summary:"
echo "   Installed: $hooks_installed"
echo "   Skipped: $hooks_skipped"
echo "   Failed: $hooks_failed"
echo ""

if [[ $hooks_installed -gt 0 ]]; then
    print_status $GREEN "🎉 Git hooks installed successfully!"
    echo ""
    echo "📋 Installed hooks will now run automatically:"
    echo "   • pre-commit: Quality checks before commits"
    echo ""
    echo "💡 To bypass hooks temporarily: git commit --no-verify"
    echo "💡 To uninstall hooks: rm .git/hooks/pre-commit"
    echo ""
else
    print_status $YELLOW "⚠️  No hooks were installed"
fi

# Test pre-commit hook if installed
if [[ -f "$HOOKS_TARGET_DIR/pre-commit" ]]; then
    echo "🧪 Testing pre-commit hook..."
    if "$HOOKS_TARGET_DIR/pre-commit" --test 2>/dev/null; then
        print_status $GREEN "✅ Pre-commit hook test passed"
    else
        # Hook might not support --test flag, that's okay
        print_status $YELLOW "⚠️  Pre-commit hook test not available"
    fi
fi

exit 0