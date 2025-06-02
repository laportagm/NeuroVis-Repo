#!/bin/bash

# Make backup of original scene (if they exist and don't already have backups)
if [ -f "/Users/gagelaporta/A1-NeuroVis/scenes/node_3d.tscn" ] && [ ! -f "/Users/gagelaporta/A1-NeuroVis/scenes/node_3d.tscn.bak" ]; then
  cp "/Users/gagelaporta/A1-NeuroVis/scenes/node_3d.tscn" "/Users/gagelaporta/A1-NeuroVis/scenes/node_3d.tscn.bak"
fi

if [ -f "/Users/gagelaporta/A1-NeuroVis/scenes/ui_info_panel.tscn" ] && [ ! -f "/Users/gagelaporta/A1-NeuroVis/scenes/ui_info_panel.tscn.bak" ]; then
  cp "/Users/gagelaporta/A1-NeuroVis/scenes/ui_info_panel.tscn" "/Users/gagelaporta/A1-NeuroVis/scenes/ui_info_panel.tscn.bak"
fi

echo "Using fixed scenes with corrected UIDs and scripts..."

# Launch Godot with the project
echo "Launching Godot editor with fixed scenes..."
# Try to determine the location of Godot on macOS
GODOT_PATH="/Applications/Godot.app/Contents/MacOS/Godot"
if [ ! -f "$GODOT_PATH" ]; then
  # Alternative locations
  GODOT_PATH="/Applications/Godot_4.app/Contents/MacOS/Godot"
fi

if [ -f "$GODOT_PATH" ]; then
  echo "Using Godot at: $GODOT_PATH"
  "$GODOT_PATH" -e --path /Users/gagelaporta/A1-NeuroVis
else
  echo "Godot executable not found at common locations."
  echo "Please open the project manually using Godot."
  echo "Path to project: /Users/gagelaporta/A1-NeuroVis"
fi