#!/bin/bash

echo "Setting up Godot MCP for NeuroVis project..."

# Navigate to project directory
cd "/Users/gagelaporta/1NeuroPro/NeuroVisProject/1/(4)NeuroVis copy"

# Clone the Godot MCP server if it doesn't exist
if [ ! -d "godot-mcp" ]; then
    echo "Cloning Godot MCP server..."
    git clone https://github.com/Coding-Solo/godot-mcp.git
fi

# Navigate to the MCP server directory
cd godot-mcp

# Install dependencies
echo "Installing dependencies..."
npm install

# Build the server
echo "Building Godot MCP server..."
npm run build

echo "✅ Godot MCP server installation complete!"
echo "📁 Server built at: $(pwd)/build/index.js"
echo "🎮 Godot path configured for: /Applications/Godot.app/Contents/MacOS/Godot"
echo ""
echo "Next steps:"
echo "1. Start VS Code in your NeuroVis project"
echo "2. The MCP configuration will be applied automatically"
echo "3. Test with: 'Launch Godot editor for my NeuroVis project'"
