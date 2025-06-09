#!/usr/bin/env bash
# Pre-commit hook for gdparse
# Validates GDScript syntax using gdtoolkit

set -euo pipefail

# Activate virtual environment if it exists
VENV_DIR="$(dirname "$0")/../.venv"
if [[ -d "$VENV_DIR" ]]; then
    source "$VENV_DIR/bin/activate" || source "$VENV_DIR/Scripts/activate" || true
fi

# Check if gdparse is available
if ! command -v gdparse &> /dev/null; then
    echo "Error: gdparse not found. Please run .claude/lint-and-fix.sh first to install dependencies."
    exit 1
fi

# Get list of staged GDScript files
files=("$@")

# Validate each file
exit_code=0
for file in "${files[@]}"; do
    if [[ -f "$file" ]]; then
        # Run gdparse for syntax validation
        if ! gdparse "$file" 2>&1; then
            echo "Syntax error in: $file"
            exit_code=1
        fi
    fi
done

exit $exit_code
