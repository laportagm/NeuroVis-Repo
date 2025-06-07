# Multiple Godot Configurations

## Configuration A: Standard Installation
{
    "godot_tools.editor_path": "/Applications/Godot.app/Contents/MacOS/Godot",
    "godot_tools.gdscript_lsp_server_port": 6005
}

## Configuration B: Version-Specific Installation  
{
    "godot_tools.editor_path": "/Applications/Godot_v4.4.app/Contents/MacOS/Godot",
    "godot_tools.gdscript_lsp_server_port": 6005
}

## Configuration C: Homebrew Installation
{
    "godot_tools.editor_path": "/opt/homebrew/bin/godot",
    "godot_tools.gdscript_lsp_server_port": 6005
}

## Configuration D: Mono Version
{
    "godot_tools.editor_path": "/Applications/Godot_mono.app/Contents/MacOS/Godot",
    "godot_tools.gdscript_lsp_server_port": 6005
}

## Configuration E: Custom Port
{
    "godot_tools.editor_path": "/Applications/Godot.app/Contents/MacOS/Godot",
    "godot_tools.gdscript_lsp_server_port": 6008
}

# How to Use:
# 1. Run: ./detect_godot.sh
# 2. Find which configuration matches your setup
# 3. Copy the configuration to your VS Code settings
# 4. Restart VS Code
