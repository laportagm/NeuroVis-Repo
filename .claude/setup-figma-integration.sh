#!/bin/bash

# NeuroVis Figma Integration Quick Start
# This script helps you get started with Figma + Claude Code workflow

echo "🎨 NeuroVis Figma Integration Setup"
echo "=================================="

# Check if Claude Code is installed
if ! command -v claude &> /dev/null; then
    echo "❌ Claude Code not found. Please install it first:"
    echo "   Visit: https://claude.ai/code"
    exit 1
fi

echo "✅ Claude Code found"

# Check project structure
if [ ! -f "project.godot" ]; then
    echo "❌ Not in NeuroVis project directory"
    echo "   Run this script from: /Users/gagelaporta/11A-NeuroVis copy3/"
    exit 1
fi

echo "✅ NeuroVis project found"

# Create assets directories for Figma exports
echo "📁 Creating asset directories..."
mkdir -p assets/figma-exports/{components,icons,colors,typography}
mkdir -p .claude/figma-assets

echo "✅ Asset directories created"

# Check if UI components exist
if [ -f "scripts/ui/UIThemeManager.gd" ]; then
    echo "✅ UIThemeManager.gd found - ready for enhancement"
else
    echo "⚠️  UIThemeManager.gd not found - will need to create it"
fi

if [ -f "scenes/ui_info_panel.gd" ]; then
    echo "✅ Info panel component found - ready for enhancement"
else
    echo "⚠️  Info panel component not found"
fi

# Create quick start templates
echo "📄 Creating quick start templates..."

cat > .claude/figma-quick-start.md << 'EOF'
# Figma + Claude Code Quick Start for NeuroVis

## Immediate Next Steps

### 1. Export from Figma
Place these in `assets/figma-exports/`:
- [ ] Color palette (as JSON or CSS)
- [ ] Typography specifications
- [ ] Key component screenshots
- [ ] Icon assets (SVG format)

### 2. Start with Design Tokens
```bash
claude "Help me implement professional design tokens in my UIThemeManager.gd based on these Figma exports"
```

### 3. Enhance Key Components
```bash
claude "Based on this Figma design, enhance my ui_info_panel.gd component"
```

### 4. Add Professional Polish
```bash
claude "Add smooth animations and micro-interactions to match these Figma prototypes"
```

## Templates Ready
- Design token implementation prompt
- Component enhancement prompt  
- Animation specification prompt
- Layout system prompt

See PRACTICAL_FIGMA_PROMPTS.md for complete examples.
EOF

# Show next steps
echo ""
echo "🚀 Setup Complete! Next Steps:"
echo "=============================="
echo ""
echo "1. 🎨 Export from Figma:"
echo "   - Colors and typography → assets/figma-exports/colors/"
echo "   - Component designs → assets/figma-exports/components/"
echo "   - Icons → assets/figma-exports/icons/"
echo ""
echo "2. 📖 Read the guides:"
echo "   - .claude/FIGMA_INTEGRATION_GUIDE.md (full setup options)"
echo "   - .claude/PRACTICAL_FIGMA_PROMPTS.md (ready-to-use prompts)"
echo ""
echo "3. 🛠️  Start implementing:"
echo "   claude \"Based on my Figma exports, help me enhance my NeuroVis UI...\""
echo ""
echo "4. 📊 Optional: Set up API integration:"
echo "   - Follow advanced setup in FIGMA_INTEGRATION_GUIDE.md"
echo "   - Requires Figma access token and Node.js"
echo ""
echo "✨ Pro Tip: Start with manual exports and design token implementation"
echo "   This gives you immediate results without complex API setup!"
echo ""

# Check if they want to open the guides
read -p "📖 Open the practical prompts guide now? (y/n): " open_guide
if [[ $open_guide =~ ^[Yy]$ ]]; then
    if command -v code &> /dev/null; then
        code .claude/PRACTICAL_FIGMA_PROMPTS.md
    elif command -v open &> /dev/null; then
        open .claude/PRACTICAL_FIGMA_PROMPTS.md
    else
        echo "📄 Guide location: .claude/PRACTICAL_FIGMA_PROMPTS.md"
    fi
fi

echo ""
echo "🎯 Ready to transform your NeuroVis UI with Figma + Claude Code!"
