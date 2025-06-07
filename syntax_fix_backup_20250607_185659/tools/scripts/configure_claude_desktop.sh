#!/bin/bash

# Claude Desktop MCP Configuration Script
# This script helps configure MCPs for Claude Desktop

echo "🔧 Configuring Claude Desktop MCPs"
echo "================================="

# Common Claude Desktop config locations on macOS
CONFIG_PATHS=(
    "$HOME/Library/Application Support/Claude/claude_desktop_config.json"
    "$HOME/.config/claude/claude_desktop_config.json"
    "$HOME/.claude/claude_desktop_config.json"
)

# Find existing config
DESKTOP_CONFIG=""
for path in "${CONFIG_PATHS[@]}"; do
    if [ -f "$path" ]; then
        echo "✅ Found existing Claude Desktop config: $path"
        DESKTOP_CONFIG="$path"
        break
    fi
done

# If no config found, create one
if [ -z "$DESKTOP_CONFIG" ]; then
    # Create directory if needed
    mkdir -p "$HOME/Library/Application Support/Claude"
    DESKTOP_CONFIG="$HOME/Library/Application Support/Claude/claude_desktop_config.json"
    echo "📁 Creating new config at: $DESKTOP_CONFIG"
fi

# Backup existing config
if [ -f "$DESKTOP_CONFIG" ]; then
    cp "$DESKTOP_CONFIG" "${DESKTOP_CONFIG}.backup.$(date +%Y%m%d_%H%M%S)"
    echo "📋 Backed up existing config"
fi

# Create comprehensive MCP configuration
cat > "$DESKTOP_CONFIG" << 'EOF'
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/Users/gagelaporta/1NeuroPro/NeuroVisProject/1/(4)NeuroVis copy"],
      "env": {
        "ALLOWED_EXTENSIONS": ".gd,.tscn,.tres,.cs,.md,.json,.txt,.sh"
      }
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "your_github_token_here"
      }
    },
    "sqlite": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sqlite", "--db-path", "/Users/gagelaporta/1NeuroPro/NeuroVisProject/1/(4)NeuroVis copy/neurovis.db"]
    },
    "godot": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-godot"],
      "env": {
        "GODOT_PROJECT_PATH": "/Users/gagelaporta/1NeuroPro/NeuroVisProject/1/(4)NeuroVis copy",
        "GODOT_EXECUTABLE": "/Applications/Godot.app/Contents/MacOS/Godot"
      }
    },
    "figma": {
      "command": "npx",
      "args": ["-y", "claude-figma-mcp"],
      "env": {
        "FIGMA_PERSONAL_ACCESS_TOKEN": "your_figma_token_here"
      }
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    },
    "puppeteer": {
      "command": "npx", 
      "args": ["-y", "@modelcontextprotocol/server-puppeteer"]
    },
    "fetch": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-fetch"]
    }
  }
}
EOF

echo "✅ Claude Desktop configuration created!"
echo ""
echo "📝 Next steps:"
echo "1. Replace 'your_github_token_here' with your actual GitHub token"
echo "2. Replace 'your_figma_token_here' with your actual Figma token (if using Figma)"
echo "3. Restart Claude Desktop app"
echo ""
echo "Config location: $DESKTOP_CONFIG"
