#!/bin/bash

# Claude Code MCP Configuration Script
# This script configures MCPs for Claude Code (terminal version)

echo "🔧 Configuring Claude Code MCPs"
echo "==============================="

# Create .claude directory if it doesn't exist
mkdir -p ~/.claude
mkdir -p ~/.claude/commands

# Create Claude Code configuration
CLAUDE_CODE_CONFIG="$HOME/.claude/config.json"

# Backup existing config
if [ -f "$CLAUDE_CODE_CONFIG" ]; then
    cp "$CLAUDE_CODE_CONFIG" "${CLAUDE_CODE_CONFIG}.backup.$(date +%Y%m%d_%H%M%S)"
    echo "📋 Backed up existing Claude Code config"
fi

# Create comprehensive Claude Code MCP configuration
cat > "$CLAUDE_CODE_CONFIG" << 'EOF'
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

echo "✅ Claude Code configuration created at: $CLAUDE_CODE_CONFIG"
echo ""

# Create project-specific configuration
PROJECT_CONFIG="/Users/gagelaporta/1NeuroPro/NeuroVisProject/1/(4)NeuroVis copy/.claude/config.json"
mkdir -p "/Users/gagelaporta/1NeuroPro/NeuroVisProject/1/(4)NeuroVis copy/.claude"

cat > "$PROJECT_CONFIG" << 'EOF'
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
      "args": ["-y", "@modelcontextprotocol/server-sqlite", "--db-path", "./neurovis.db"]
    },
    "godot": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-godot"],
      "env": {
        "GODOT_PROJECT_PATH": ".",
        "GODOT_EXECUTABLE": "/Applications/Godot.app/Contents/MacOS/Godot"
      }
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    },
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
    }
  }
}
EOF

echo "✅ Project-specific config created at: $PROJECT_CONFIG"
echo ""
echo "📝 Configuration complete!"
echo ""
echo "To use Claude Code:"
echo "  Global config: claude --config ~/.claude/config.json"
echo "  Project config: claude --config ./.claude/config.json"
echo "  Or simply: claude (will auto-detect configs)"
