#!/bin/bash
# Quick launch script for Claude Code

echo "🧠 Launching Claude Code for NeuroVis..."
echo "==========================================="

# Set up default command
COMMAND="claude"

# Check if we have any arguments
if [ $# -eq 0 ]; then
    # No arguments, check if we should run in interactive mode
    if [ -t 0 ]; then
        # Run Claude Code in interactive mode with project config
        echo "🔍 Running Claude Code in interactive mode"
        $COMMAND --config ./.claude/config.json
    else
        # Being piped to, print help
        echo "Usage:"
        echo "  ./run_claude_code.sh                  - Run Claude in interactive mode"
        echo "  ./run_claude_code.sh -p \"prompt\"      - Run with a specific prompt"
        echo "  ./run_claude_code.sh --help           - Show all options"
        exit 0
    fi
else
    # Pass all arguments to claude
    $COMMAND --config ./.claude/config.json "$@"
fi
