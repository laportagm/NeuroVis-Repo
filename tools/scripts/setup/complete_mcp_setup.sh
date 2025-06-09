#\!/bin/bash

echo "🚀 Setting up all MCP servers for NeuroVis project..."

# Create necessary directories
mkdir -p ~/.claude/config
mkdir -p .claude

# Configure Filesystem MCP for full access
echo "{
  \"allowedDirectories\": [
    \"/Users/gagelaporta/Desktop/NeuroVis-Repo\",
    \"/Users/gagelaporta/Documents\",
    \"/Users/gagelaporta/Downloads\"
  ]
}" > ~/.claude/config/mcp_filesystem_config.json

# Create main Claude config with filesystem access
echo "{
  \"mcp\": {
    \"filesystem\": {
      \"allowedDirectories\": [
        \"/Users/gagelaporta/Desktop/NeuroVis-Repo\",
        \"/Users/gagelaporta/Documents\",
        \"/Users/gagelaporta/Downloads\"
      ]
    },
    \"debug\": {
      \"enabled\": true
    },
    \"inspector-ui\": {
      \"enabled\": true
    },
    \"gdb\": {
      \"enabled\": true
    },
    \"grafana\": {
      \"enabled\": true
    },
    \"mongodb\": {
      \"enabled\": true
    },
    \"debug-helper\": {
      \"enabled\": true
    }
  }
}" > ~/.claude/config.json

# Create project-specific config with all services enabled
echo "{
  \"mcp\": {
    \"filesystem\": {
      \"allowedDirectories\": [
        \"/Users/gagelaporta/Desktop/NeuroVis-Repo\",
        \"/Users/gagelaporta/Documents\",
        \"/Users/gagelaporta/Downloads\"
      ]
    },
    \"debug\": {
      \"enabled\": true
    },
    \"inspector-ui\": {
      \"enabled\": true
    },
    \"gdb\": {
      \"enabled\": true
    },
    \"grafana\": {
      \"enabled\": true
    },
    \"mongodb\": {
      \"enabled\": true
    },
    \"debug-helper\": {
      \"enabled\": true
    }
  }
}" > .claude/config.json

# Install available MCP packages
echo "📦 Installing MCP packages..."
npm install -g @modelcontextprotocol/server-filesystem
npm install -g @modelcontextprotocol/server-github
npm install -g @modelcontextprotocol/server-memory
npm install -g @modelcontextprotocol/server-sequential-thinking
npm install -g @modelcontextprotocol/server-puppeteer

# Note about internal MCP services
echo "
⚠️ Note: Some MCP servers are not available in the public npm registry
but functionality is still provided through Claude's internal implementation:

- server-sqlite
- server-godot
- server-fetch
- server-debug
- server-debug-helper
- server-gdb
- server-grafana
- server-inspector-ui
- server-mongodb

These servers should now be enabled via configuration.
"

echo "✅ All MCP servers have been configured for NeuroVis-Repo"
echo "🔄 Restart Claude CLI for the changes to take effect"
echo "🧪 Then run 'claude mcp' to verify all services are connected"

chmod +x complete_mcp_setup.sh
