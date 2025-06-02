#!/bin/bash

# Install Required MCP Packages
echo "📦 Installing Required MCP Packages"
echo "==================================="

# Core MCP packages
echo "Installing core MCP packages..."
npm install -g @modelcontextprotocol/server-filesystem
npm install -g @modelcontextprotocol/server-github  
npm install -g @modelcontextprotocol/server-sqlite
npm install -g @modelcontextprotocol/server-memory
npm install -g @modelcontextprotocol/server-puppeteer
npm install -g @modelcontextprotocol/server-fetch

# Additional packages (you've already installed these)
echo "Installing additional MCP packages..."
npm install -g claude-figma-mcp
npm install -g figma-developer-mcp

# Godot MCP (if available)
echo "Checking for Godot MCP package..."
if npm info @modelcontextprotocol/server-godot > /dev/null 2>&1; then
    npm install -g @modelcontextprotocol/server-godot
    echo "✅ Godot MCP installed"
else
    echo "⚠️ Godot MCP not available yet - using project-specific implementation"
fi

# Sequential thinking (if available)
if npm info @modelcontextprotocol/server-sequential-thinking > /dev/null 2>&1; then
    npm install -g @modelcontextprotocol/server-sequential-thinking
    echo "✅ Sequential thinking MCP installed"
else
    echo "⚠️ Sequential thinking MCP may need manual setup"
fi

echo ""
echo "✅ MCP package installation complete!"
echo ""
echo "Installed packages:"
npm list -g --depth=0 | grep modelcontextprotocol
npm list -g --depth=0 | grep figma-mcp
