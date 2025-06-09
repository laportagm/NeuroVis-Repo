#!/usr/bin/env bash
# Pre-commit hook for gdformat
# Formats GDScript files using gdtoolkit

set -euo pipefail

# Activate virtual environment if it exists
VENV_DIR="$(dirname "$0")/../.venv"
if [[ -d "$VENV_DIR" ]]; then
    source "$VENV_DIR/bin/activate" || source "$VENV_DIR/Scripts/activate" || true
fi

# Check if gdformat is available
if ! command -v gdformat &> /dev/null; then
    echo "Error: gdformat not found. Please run .claude/lint-and-fix.sh first to install dependencies."
    exit 1
fi

# Get list of staged GDScript files
files=("$@")

# Format each file
exit_code=0
for file in "${files[@]}"; do
    if [[ -f "$file" ]]; then
        # Run gdformat with NeuroVis configuration
        if ! gdformat "$file" --line-length 100; then
            echo "Error formatting: $file"
            exit_code=1
        fi

        # Stage the formatted file
        git add "$file"
    fi
done

exit $exit_code
