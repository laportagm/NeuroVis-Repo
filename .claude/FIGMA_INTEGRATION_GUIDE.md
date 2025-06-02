# Figma Integration Setup for NeuroVis

## Important Note
While I mentioned "Figma MCP" in the improvement plan, there isn't a direct Figma MCP integration available yet. This guide provides several practical approaches to integrate Figma workflows with Claude Code.

## Option 1: Custom Figma MCP Server (Advanced)

### Prerequisites
- Node.js 18+ installed
- Figma account with API access
- Claude Code configured

### Setup Steps

1. **Get Figma Access Token**
   ```bash
   # 1. Go to Figma → Settings → Personal Access Tokens
   # 2. Create new token with "File content" permission
   # 3. Copy the token (you'll need it below)
   ```

2. **Install Dependencies**
   ```bash
   cd /Users/gagelaporta/11A-NeuroVis\ copy3/.claude
   npm install
   ```

3. **Configure Your Token**
   ```bash
   # Edit mcp_config.json and replace "your-figma-token-here" with your actual token
   # IMPORTANT: Keep this token secure and don't commit it to version control
   ```

4. **Add to Claude Code Configuration**
   ```bash
   # Add this to your Claude Code MCP configuration:
   claude config add-mcp-server figma-integration /Users/gagelaporta/11A-NeuroVis\ copy3/.claude/mcp_config.json
   ```

### Usage Examples
Once configured, you can use these tools in Claude Code:

```bash
# Get Figma file structure
claude "Use get_figma_file to analyze the design file with key 'abc123' and identify the main UI components"

# Export specific components as images
claude "Use export_figma_images to export the button components from file 'abc123' as PNG at 2x scale"

# Extract design tokens
claude "Use analyze_figma_design_tokens to extract colors, typography, and spacing from file 'abc123' for my Godot theme system"
```

## Option 2: Figma REST API Direct Integration (Recommended)

This is simpler and more reliable than the custom MCP server:

### Step 1: Create Figma API Helper Script
```bash
# Create a simple Node.js script to interact with Figma API
# Use this for design token extraction and asset export
```

### Step 2: Use with Claude Code
```bash
# Run API calls and pipe results to Claude Code for analysis
curl -H "X-Figma-Token: YOUR_TOKEN" "https://api.figma.com/v1/files/FILE_KEY" | claude "Analyze this Figma file data and extract design tokens"
```

## Option 3: Manual Workflow with Claude Code (Easiest)

### For Design System Work:
1. **Export from Figma manually**
   - Colors as JSON/CSS
   - Typography scales as specifications
   - Component screenshots for reference

2. **Use Claude Code for implementation**
   ```bash
   cd /Users/gagelaporta/11A-NeuroVis\ copy3
   
   # Analyze and implement design tokens
   claude "Help me implement these Figma design tokens in my UIThemeManager.gd file"
   
   # Convert designs to Godot components
   claude "Based on this Figma design screenshot, help me enhance my info panel component"
   ```

### For Asset Management:
1. **Export assets from Figma**
   - Icons as SVG
   - UI components as PNG
   - Design specifications as PDF

2. **Organize with Claude Code**
   ```bash
   # Help organize and optimize assets
   claude "Help me organize these Figma exports into my Godot project structure"
   ```

## Option 4: Design Tokens Workflow

### Step 1: Export Design Tokens from Figma
Use Figma plugins like:
- "Design Tokens" plugin
- "Figma Tokens" plugin
- "Style Dictionary" integration

### Step 2: Convert to Godot with Claude Code
```bash
# Convert tokens to GDScript
claude "Convert these design tokens to GDScript constants for my UIThemeManager.gd"

# Example tokens file:
{
  "colors": {
    "primary": "#0066FF",
    "secondary": "#00AA44",
    "surface": "#1A1A2E"
  },
  "typography": {
    "h1": { "size": 24, "weight": "bold" },
    "body": { "size": 14, "weight": "normal" }
  }
}
```

## Practical Workflow for NeuroVis

### Recommended Approach:
1. **Design in Figma** - Create your enhanced UI designs
2. **Export systematically** - Colors, typography, components, assets
3. **Use Claude Code for implementation** - Convert designs to Godot code
4. **Iterate with screenshots** - Share Figma designs with Claude Code for feedback

### Example Commands:
```bash
# Start design system implementation
claude "Based on my Figma design system, help me update my UIThemeManager.gd with these colors and typography"

# Implement specific components
claude "Help me implement this Figma information panel design in my ui_info_panel.gd script"

# Create responsive layouts
claude "Based on this Figma layout, help me create responsive positioning in Godot"
```

## Security Notes
- **Never commit Figma tokens** to version control
- **Use environment variables** for sensitive data
- **Limit token permissions** to minimum required access

## Troubleshooting

### Common Issues:
1. **MCP Server not connecting**: Check Node.js version and dependencies
2. **API authentication fails**: Verify Figma token permissions
3. **File not found**: Check Figma file sharing permissions

### Alternative Solutions:
- Use Figma's web app with screen sharing during Claude Code sessions
- Export designs manually and reference them in prompts
- Use design system documentation instead of live API access

## Next Steps
1. Choose the option that fits your workflow
2. Start with manual exports if API integration seems complex
3. Use Claude Code to implement designs in your Godot project
4. Iterate based on what works best for your development process

The key is leveraging Claude Code's ability to analyze design specifications and implement them in Godot, regardless of how you get the design data from Figma.
