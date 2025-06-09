#!/bin/bash

# 🚀 NEUROVIS CLAUDE CODE SETUP SCRIPT
# Automated setup for professional educational development environment with Claude Code

set -e  # Exit on any error

echo "🧠 ===== NEUROVIS CLAUDE CODE SETUP ====="
echo "Setting up professional educational development environment for Claude Code..."
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

PROJECT_ROOT="$(pwd)"
CLAUDE_DIR="$PROJECT_ROOT/.claude"

echo -e "${BLUE}📍 Project Root: $PROJECT_ROOT${NC}"
echo ""

# Function to print status
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Step 1: Create Claude directory structure
echo -e "${BLUE}🔄 Step 1: Creating Claude Code directory structure...${NC}"

mkdir -p "$CLAUDE_DIR"
print_status "Created Claude directory: $CLAUDE_DIR"

echo ""

# Step 2: Check for Godot installation
echo -e "${BLUE}🔄 Step 2: Detecting Godot Installation${NC}"
echo "-----------------------------------"

GODOT_PATHS=(
    "/Applications/Godot.app/Contents/MacOS/Godot"
    "/Applications/Godot_v4.4.app/Contents/MacOS/Godot"
    "/Applications/Godot_v4.3.app/Contents/MacOS/Godot" 
    "/Applications/Godot_v4.2.app/Contents/MacOS/Godot"
    "/Applications/Godot_mono.app/Contents/MacOS/Godot"
    "/usr/local/bin/godot"
    "/opt/homebrew/bin/godot"
)

FOUND_GODOT=""
for path in "${GODOT_PATHS[@]}"; do
    if [ -f "$path" ] && [ -x "$path" ]; then
        echo -e "${GREEN}✅ Found Godot: $path${NC}"
        FOUND_GODOT="$path"
        break
    fi
done

if [ -z "$FOUND_GODOT" ]; then
    echo -e "${YELLOW}⚠️ No Godot installation found automatically!${NC}"
    read -p "Please enter the path to your Godot executable: " FOUND_GODOT
    
    if [ ! -f "$FOUND_GODOT" ] || [ ! -x "$FOUND_GODOT" ]; then
        echo -e "${RED}❌ Invalid Godot path or not executable!${NC}"
        echo "Please install Godot 4.x from: https://godotengine.org/download"
        echo "Then run this script again."
        exit 1
    fi
fi

# Step 3: Create Claude configuration files
echo -e "${BLUE}🔄 Step 3: Creating Claude Code configuration...${NC}"

# Create project-specific configuration
cat > "$CLAUDE_DIR/config.json" << EOF
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "$PROJECT_ROOT"],
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
      "args": ["-y", "@modelcontextprotocol/server-sqlite", "--db-path", "$PROJECT_ROOT/neurovis.db"]
    },
    "godot": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-godot"],
      "env": {
        "GODOT_PROJECT_PATH": "$PROJECT_ROOT",
        "GODOT_EXECUTABLE": "$FOUND_GODOT"
      }
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    },
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
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

print_status "Created Claude Code configuration at: $CLAUDE_DIR/config.json"

# Create CLAUDE.md file with project instructions
cat > "$CLAUDE_DIR/CLAUDE.md" << 'EOF'
# CLAUDE.md - NeuroVis Project Instructions

## Project Overview
**NeuroVis** is an advanced educational neuroscience visualization platform built with Godot 4.4.1 for interactive brain anatomy exploration. It's designed for medical students, neuroscience researchers, and healthcare professionals as a comprehensive learning tool for neuroanatomy education.

## Current Task Context
You are currently working on enhancing the Gemini AI integration for the educational platform. The feature branch is focused on implementing Google's Gemini API for enhanced educational AI assistance within the application.

## Project Structure
The project follows a modern, educational-focused modular architecture:

- `core/` - Business logic & core systems
  - `ai/` - AI services for educational support (current focus)
  - `interaction/` - User interaction handling
  - `knowledge/` - Educational content management
  - `models/` - 3D model management
  - `systems/` - Core educational systems

- `ui/` - Educational user interface
  - `components/` - Reusable educational UI components
  - `panels/` - Educational information panels
  - `theme/` - Educational design system

- `scenes/` - Godot scenes for educational workflows
- `assets/` - Educational content assets
- `docs/` - Educational platform documentation

## Current AI Integration

The Gemini integration is currently in progress:
- `core/ai/GeminiAIService.gd` - Main service for Gemini API communication
- `core/ai/AIAssistantService.gd` - General AI assistant interface
- `ui/components/panels/AIAssistantPanel.gd` - UI for AI interactions

## Development Standards
- Follow GDScript coding standards with proper documentation
- Use proper error handling and educational context
- Maintain separation between UI and business logic
- Keep educational terminology accurate and consistent
- Ensure accessibility compliance

## Key Commands
- `claude config show` - Show current Claude configuration
- `claude --config ./.claude/config.json` - Use project-specific configuration
- `claude -p "Your prompt"` - Send quick prompt to Claude

## GitHub Workflow
- Current branch: `feature/gemini-integration`
- Make atomic commits with clear messages
- Use standard commit format: `<type>(<scope>): <description>`
EOF

print_status "Created Claude.md project instruction file"

# Create convenience script for Claude Code
cat > "$PROJECT_ROOT/run_claude_code.sh" << 'EOF'
#!/bin/bash
# Quick launch script for Claude Code

echo "🧠 Launching Claude Code for NeuroVis..."
echo "==========================================="

# Set up default command
COMMAND="claude"

# Check if we have any arguments
if [ $# -eq 0 ]; then
    # No arguments, check if we should run in interactive mode
    if [ -t 0 ]; then
        # Run Claude Code in interactive mode with project config
        echo "🔍 Running Claude Code in interactive mode"
        $COMMAND --config ./.claude/config.json
    else
        # Being piped to, print help
        echo "Usage:"
        echo "  ./run_claude_code.sh                  - Run Claude in interactive mode"
        echo "  ./run_claude_code.sh -p \"prompt\"      - Run with a specific prompt"
        echo "  ./run_claude_code.sh --help           - Show all options"
        exit 0
    fi
else
    # Pass all arguments to claude
    $COMMAND --config ./.claude/config.json "$@"
fi
EOF

chmod +x "$PROJECT_ROOT/run_claude_code.sh"
print_status "Created run_claude_code.sh convenience script"

echo ""

# Step 4: Create Claude AI integration template files
echo -e "${BLUE}🔄 Step 4: Creating Claude AI integration templates...${NC}"

# Create documentation for Claude integration
cat > "$PROJECT_ROOT/docs/dev/CLAUDE_INTEGRATION_GUIDE.md" << 'EOF'
# 🤖 Claude AI Integration Guide for NeuroVis

This document provides guidance on using Claude AI effectively within the NeuroVis educational platform development workflow.

## 🚀 Getting Started

### Initial Setup
```bash
# Set up Claude Code environment
./setup_claude_code.sh

# Run Claude Code with project configuration
./run_claude_code.sh
```

### Quick Commands
```bash
# Ask Claude a specific question
./run_claude_code.sh -p "How should I implement error handling in GeminiAIService.gd?"

# Start interactive Claude session
./run_claude_code.sh
```

## 💡 Effective Prompting Strategies

### Educational Feature Development
When developing educational features:
```
Please help me implement [feature] for the NeuroVis educational platform.
The feature should [educational purpose] and integrate with our existing
knowledge services. Please follow our standard error handling patterns
and educational naming conventions.
```

### Code Refactoring
When improving existing code:
```
I need to refactor the [component] to improve [aspect]. Please help me
identify issues and suggest improvements while maintaining educational
context and proper error handling.
```

### Bug Fixing
When fixing issues:
```
I'm experiencing [issue] in the [component]. Here's the error message:
[error]. Please help me diagnose and fix this issue following our
educational development standards.
```

### Documentation Generation
When creating documentation:
```
Please generate educational documentation for [component] following our
standard format. Include: overview, educational purpose, usage examples,
error handling, and educational context.
```

## 🧩 Integration Workflows

### AI-Assisted Feature Development Workflow
1. Create feature requirements document
2. Ask Claude to draft initial implementation
3. Review and enhance the implementation
4. Add educational context and proper error handling
5. Test with educational scenarios
6. Document with Claude's assistance

### Code Review Workflow
1. Share code with Claude
2. Ask for specific improvement areas
3. Apply targeted enhancements
4. Validate educational integrity
5. Generate review summary

### Educational Content Validation
1. Share anatomical content with Claude
2. Request medical terminology verification
3. Enhance educational context
4. Validate learning objectives
5. Generate educational metadata

## 🏗️ Claude Code Project Organization

Claude can help with:
- Code structure recommendations
- Educational naming suggestions
- Documentation generation
- Error handling patterns
- Educational context enhancement
- Performance optimization suggestions
- Accessibility improvements

## 🚀 Best Practices

1. **Be specific** about educational requirements
2. **Provide context** about the educational purpose
3. **Reference existing patterns** from our codebase
4. **Specify constraints** like performance or accessibility
5. **Request educational metadata** for new features
6. **Ask for validation** of medical terminology
7. **Seek learning objectives** for new features

## 🔍 Troubleshooting

If Claude provides solutions that don't align with our educational standards:
1. Clarify educational purpose
2. Reference specific examples from our codebase
3. Mention our documentation standards
4. Highlight educational context requirements
5. Specify target audience (medical students, etc.)

## 🎓 Educational Quality Assurance

When implementing educational features, ensure Claude:
1. Maintains accurate medical terminology
2. Provides appropriate educational context
3. Follows accessibility guidelines
4. Maintains performance standards
5. Integrates with knowledge services
6. Supports learning objectives
7. Includes clinical relevance

## 🌟 Advanced Claude Techniques

### Chain-of-Thought Prompting
```
Let's think through implementing the [feature] step by step:
1. First, we need to understand the educational purpose
2. Then, identify the core components needed
3. Next, determine integration points with knowledge services
4. Finally, implement with proper error handling and documentation
```

### Self-Critique Prompting
```
Please review this implementation of [feature] and critique it from
multiple perspectives: educational value, code quality, performance,
accessibility, and medical accuracy.
```

### Educational Enhancement Prompting
```
Please enhance this implementation with additional educational context,
clinical relevance, and learning objective metadata to better serve our
medical student users.
```
EOF

print_status "Created Claude integration guide"

echo ""

# Step 5: Check NPM and NPX installation
echo -e "${BLUE}🔄 Step 5: Checking NPM and NPX availability...${NC}"

if command -v npm &> /dev/null; then
    print_status "NPM is available"
    NPM_AVAILABLE=true
else
    print_warning "NPM not found. MCP servers may not function properly."
    NPM_AVAILABLE=false
fi

if command -v npx &> /dev/null; then
    print_status "NPX is available"
    NPX_AVAILABLE=true
else
    print_warning "NPX not found. MCP servers may not function properly."
    NPX_AVAILABLE=false
fi

echo ""

# Step 6: Install required MCP packages
if [ "$NPM_AVAILABLE" = true ]; then
    echo -e "${BLUE}🔄 Step 6: Installing required MCP packages...${NC}"
    
    # Create package installation script
    cat > "$PROJECT_ROOT/install_mcp_packages.sh" << 'EOF'
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
EOF

    chmod +x "$PROJECT_ROOT/install_mcp_packages.sh"
    print_status "Created install_mcp_packages.sh script"
    
    # Ask if user wants to install packages now
    read -p "Do you want to install required MCP packages now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        "$PROJECT_ROOT/install_mcp_packages.sh"
    else
        print_warning "Skipping package installation. Run ./install_mcp_packages.sh manually later."
    fi
else
    echo -e "${BLUE}🔄 Step 6: Skipping MCP package installation (NPM not found)...${NC}"
    print_warning "Please install NPM and then run ./install_mcp_packages.sh"
fi

echo ""

# Step 7: Create CLI convenience file
echo -e "${BLUE}🔄 Step 7: Creating CLI convenience file...${NC}"

cat > "$PROJECT_ROOT/.clauderc" << 'EOF'
# Claude CLI configuration file
# Load with: source .clauderc

# Claude Code aliases
alias cc="./run_claude_code.sh"
alias ccq="./run_claude_code.sh -p"
alias ccd="claude docs"

# Claude Code functions
claude_help() {
  echo "🧠 NeuroVis Claude Code Commands"
  echo "==============================="
  echo "cc                - Start interactive Claude Code session"
  echo "ccq \"prompt\"      - Quick Claude Code query"
  echo "ccd               - Open Claude documentation"
  echo "claude_help       - Show this help"
}

echo "🧠 Claude Code aliases loaded. Type 'claude_help' for command list."
EOF

print_status "Created .clauderc CLI convenience file"
echo "To use aliases, run: source .clauderc"

echo ""

# Final summary
echo -e "${GREEN}🎉 ===== SETUP COMPLETE! ===== ${NC}"
echo ""
echo -e "${BLUE}📋 What was set up:${NC}"
echo "   ✅ Claude Code configuration with Godot integration"
echo "   ✅ Project-specific Claude instruction file"
echo "   ✅ Convenience scripts for Claude Code"
echo "   ✅ MCP server configuration"
echo "   ✅ Integration guide and documentation"
echo "   ✅ CLI aliases for faster Claude interaction"
echo ""
echo -e "${BLUE}🚀 Next Steps:${NC}"
echo "   1. Install Claude CLI if not already installed: pip install claude-cli"
echo "   2. Authenticate Claude CLI: claude auth login"
echo "   3. Run ./install_mcp_packages.sh if you skipped installation"
echo "   4. Start using Claude Code: ./run_claude_code.sh"
echo "   5. Read the integration guide: docs/dev/CLAUDE_INTEGRATION_GUIDE.md"
echo ""
echo -e "${BLUE}🎯 Key Features:${NC}"
echo "   • Interactive Claude Code sessions with ./run_claude_code.sh"
echo "   • Quick queries with ./run_claude_code.sh -p \"your prompt\""
echo "   • Godot integration for enhanced context"
echo "   • Project-specific instruction file for consistent context"
echo "   • Filesystem, GitHub, SQLite, and other MCP integrations"
echo ""
echo -e "${GREEN}Happy NeuroVis Development with Claude! 🧠✨${NC}"