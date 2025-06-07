#!/bin/bash
# Install required MCP packages for Claude Code

echo "🔧 Installing Claude Code MCP packages..."

npm install -g @modelcontextprotocol/server-filesystem
npm install -g @modelcontextprotocol/server-github
npm install -g @modelcontextprotocol/server-sqlite
npm install -g @modelcontextprotocol/server-godot
npm install -g @modelcontextprotocol/server-memory
npm install -g @modelcontextprotocol/server-sequential-thinking
npm install -g @modelcontextprotocol/server-puppeteer
npm install -g @modelcontextprotocol/server-fetch

echo "✅ MCP packages installation complete!"
