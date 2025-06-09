#!/bin/bash
# Godot Path Helper for NeuroVis Scripts
# Source this file in your scripts: source ./godot_path_helper.sh

find_godot() {
    local GODOT_PATHS=(
        "/Applications/Godot.app/Contents/MacOS/Godot"
        "/Applications/Godot_v4.4.1-stable_macos.universal.app/Contents/MacOS/Godot"
        "/Applications/Godot_v4.4-stable_macos.universal.app/Contents/MacOS/Godot"
        "/usr/local/bin/godot"
        "/opt/homebrew/bin/godot"
        "$(which godot 2>/dev/null)"
    )

    for path in "${GODOT_PATHS[@]}"; do
        if [ -x "$path" ]; then
            echo "$path"
            return 0
        fi
    done

    echo ""
    return 1
}

# Export the function
export -f find_godot

# Try to find Godot and export the path
GODOT_EXEC=$(find_godot)

if [ -z "$GODOT_EXEC" ]; then
    echo "❌ Godot executable not found!"
    echo "Please install Godot 4.4+ or add it to your PATH"
    echo ""
    echo "Common installation methods:"
    echo "  - Download from: https://godotengine.org/download"
    echo "  - Install via Homebrew: brew install godot"
    echo "  - Add existing installation to PATH"
    echo ""
    return 1 2>/dev/null || exit 1
fi

echo "📍 Found Godot at: $GODOT_EXEC"
export GODOT_EXEC
