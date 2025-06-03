#!/bin/bash

# Master MCP Setup Script for NeuroVis
# Sets up MCPs for both Claude Desktop and Claude Code

echo "🚀 NeuroVis MCP Integration Setup"
echo "================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Step 1: Install MCP packages
echo -e "${BLUE}Step 1: Installing MCP Packages${NC}"
echo "-------------------------------"
chmod +x install_mcp_packages.sh
./install_mcp_packages.sh

echo ""

# Step 2: Configure Claude Desktop
echo -e "${BLUE}Step 2: Configuring Claude Desktop${NC}"
echo "---------------------------------"
chmod +x configure_claude_desktop.sh
./configure_claude_desktop.sh

echo ""

# Step 3: Configure Claude Code
echo -e "${BLUE}Step 3: Configuring Claude Code${NC}"
echo "------------------------------"
chmod +x configure_claude_code.sh
./configure_claude_code.sh

echo ""

# Step 4: Set up tokens
echo -e "${YELLOW}Step 4: Token Configuration Required${NC}"
echo "-----------------------------------"
echo "You need to add your API tokens:"
echo ""
echo "1. GitHub Token:"
echo "   - Go to: https://github.com/settings/tokens"
echo "   - Generate token with repo permissions"
echo "   - Replace 'your_github_token_here' in config files"
echo ""
echo "2. Figma Token (optional):"
echo "   - Go to: https://www.figma.com/developers/api#access-tokens"
echo "   - Generate token"
echo "   - Replace 'your_figma_token_here' in config files"
echo ""

# Step 5: Test configuration
echo -e "${BLUE}Step 5: Testing Configuration${NC}"
echo "-----------------------------"
echo "Testing Claude Code configuration..."

# Test if Claude Code can find config
if claude --help > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Claude Code is available${NC}"
else
    echo -e "${YELLOW}⚠️ Claude Code may not be installed or in PATH${NC}"
fi

# Test project config
if [ -f ".claude/config.json" ]; then
    echo -e "${GREEN}✅ Project-specific config created${NC}"
else
    echo -e "${RED}❌ Project config missing${NC}"
fi

# Test global config
if [ -f "$HOME/.claude/config.json" ]; then
    echo -e "${GREEN}✅ Global Claude Code config created${NC}"
else
    echo -e "${RED}❌ Global config missing${NC}"
fi

# Test desktop config
DESKTOP_CONFIG="$HOME/Library/Application Support/Claude/claude_desktop_config.json"
if [ -f "$DESKTOP_CONFIG" ]; then
    echo -e "${GREEN}✅ Claude Desktop config created${NC}"
else
    echo -e "${RED}❌ Desktop config missing${NC}"
fi

echo ""
echo -e "${GREEN}🎉 MCP Setup Complete!${NC}"
echo "====================="
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "1. Add your GitHub token to the config files"
echo "2. Restart Claude Desktop app"
echo "3. Test custom commands:"
echo "   ${BLUE}claude '/neuro-debug \"scene_issue\" \"description\"'${NC}"
echo "   ${BLUE}claude '/ai-implement \"chatbot\" \"integrate LLM API\"'${NC}"
echo "   ${BLUE}claude '/performance-profile \"node_3d.gd\"'${NC}"
echo "   ${BLUE}claude '/knowledge-sync \"new architecture patterns\"'${NC}"
echo ""
echo -e "${YELLOW}Available Commands:${NC}"
echo "- /neuro-debug      # Systematic debugging with multiple MCPs"
echo "- /ai-implement     # AI feature development workflow" 
echo "- /performance-profile # Performance analysis and optimization"
echo "- /knowledge-sync   # Project knowledge management"
echo ""
echo -e "${BLUE}Config Locations:${NC}"
echo "- Claude Desktop: $DESKTOP_CONFIG"
echo "- Claude Code Global: $HOME/.claude/config.json"
echo "- Claude Code Project: ./.claude/config.json"
echo "- Custom Commands: ./.claude/commands/"
echo ""
echo -e "${GREEN}Your NeuroVis project now has enterprise-level MCP integration! 🚀${NC}"
