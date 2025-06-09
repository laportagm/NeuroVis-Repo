#!/bin/bash
PROJECT_PATH="/Users/gagelaporta/1NeuroPro/NeuroVisProject/1/(4)NeuroVis copy"
GODOT_PATH="/Applications/Godot.app/Contents/MacOS/Godot"

# Kill any existing Godot LSP
lsof -ti:6005 | xargs kill -9 2>/dev/null

# Start Godot with LSP in background
cd "$PROJECT_PATH"
"$GODOT_PATH" --path "$PROJECT_PATH" --editor --lsp-port 6005 &
GODOT_PID=$!

# Wait for LSP to start
echo "Starting Godot LSP..."
while ! lsof -i:6005 >/dev/null 2>&1; do
  sleep 0.5
done
echo "✅ Godot LSP active on port 6005"

# Launch Cursor
/Applications/Cursor.app/Contents/MacOS/Cursor "$PROJECT_PATH" &

echo "✅ Cursor launched with Godot integration"
echo "PID: Godot=$GODOT_PID"