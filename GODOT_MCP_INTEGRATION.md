# Godot MCP Integration for NeuroVis

This setup adds Godot MCP server integration to your existing Claude Code environment **without affecting your current 8 MCP servers**.

## 🎯 What Was Added

✅ **Godot MCP Server**: Direct Godot engine integration for NeuroVis development  
✅ **VS Code Configuration**: Workspace-specific MCP setup (`.vscode/mcp.json`)  
✅ **Auto-Setup Scripts**: Automated installation and testing  
✅ **Safe Integration**: Preserves your existing MCP server configuration  

## 🚀 Quick Setup

### 1. Install Godot MCP Server
```bash
cd /Users/gagelaporta/1NeuroPro/NeuroVisProject/1/(4)NeuroVis copy
chmod +x setup_godot_mcp.sh
./setup_godot_mcp.sh
```

### 2. Test the Integration
```bash
chmod +x test_godot_mcp.sh
./test_godot_mcp.sh
```

### 3. Start VS Code
Open VS Code in your NeuroVis project. The Godot MCP server will be added to your existing 8 servers.

## 🎮 New Capabilities for NeuroVis

With Godot MCP, Claude Code can now:

- **🔧 Direct Scene Manipulation**: "Add a highlighted cerebellum node to the main brain scene"
- **🐛 Enhanced Debugging**: "Run NeuroVis and capture any GDScript errors"
- **🎯 Project Management**: "Launch Godot editor for NeuroVis project"
- **📊 Structure Analysis**: "Get information about NeuroVis scene hierarchy"
- **⚡ Quick Testing**: "Run quick_test.sh and show debug output"

## 📋 Your Complete MCP Arsenal (9 Servers)

### Original 8 Servers (Unchanged):
1. **codecmcp** - Code analysis and generation
2. **fetch** - Web content retrieval  
3. **filesystem** - File operations
4. **github** - Version control
5. **memory** - Knowledge persistence
6. **puppeteer** - Browser automation
7. **sequential-thinking** - Structured problem solving
8. **sqlite** - Database operations

### New Addition:
9. **godot-mcp** - Direct Godot engine integration

## 🔧 Configuration Files

- `.vscode/mcp.json` - VS Code MCP server configuration (NEW)
- `.vscode/godot-mcp.json` - Godot-specific settings (UPDATED)
- `godot-mcp/` - Godot MCP server installation (NEW)

## 🧪 Test Commands

Once VS Code is running with MCP enabled, test these commands:

```
"Launch Godot editor for my NeuroVis project"
"Get NeuroVis project information and scene structure"  
"Run NeuroVis project and capture debug output"
"Create a new test scene for brain visualization"
"Add a Sprite3D node to the main brain scene"
```

## 🔒 Security & Auto-Approvals

Auto-approved operations (safe for NeuroVis development):
- `launch_editor` - Start Godot editor
- `get_debug_output` - Capture debug information
- `get_project_info` - Read project structure
- `list_scenes` - List available scenes
- `list_scripts` - List GDScript files

All other operations require manual approval for security.

## 🎯 Integration Benefits

- **Seamless Workflow**: Direct 3D brain scene manipulation from natural language
- **Enhanced Debugging**: AI-assisted GDScript error resolution
- **Educational Focus**: Perfect for neuroscience visualization development
- **Professional Development**: Medical-grade software development workflow

Your existing 8 MCP servers continue working exactly as before - this just adds Godot-specific superpowers to Claude Code! 🚀
