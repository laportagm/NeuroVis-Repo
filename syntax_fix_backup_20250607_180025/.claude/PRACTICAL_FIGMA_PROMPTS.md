# Practical Claude Code + Figma Prompts for NeuroVis

## Ready-to-Use Prompts (No API Integration Required)

### 1. Design Token Implementation
**Use after exporting colors/typography from Figma:**

```bash
claude "I have these design tokens from Figma. Help me implement them in my UIThemeManager.gd:

Colors:
- Primary: #0066FF (neural blue)  
- Secondary: #00AA44 (synaptic green)
- Surface: #1A1A2E (dark background)
- Text Primary: #FFFFFF
- Text Secondary: #CCCCCC

Typography:
- Hero: 32px, bold
- H1: 24px, bold  
- H2: 20px, semibold
- Body: 14px, regular

Update my existing UIThemeManager.gd with these professional design tokens and create helper functions for consistent application."
```

### 2. Component Implementation from Screenshots
**Use with Figma design screenshots:**

```bash
claude "Based on this Figma design [attach screenshot], help me enhance my ui_info_panel.gd component. The design shows:

- Glass morphism background with subtle border
- Clear typography hierarchy
- Interactive bookmark button
- Expandable sections for functions
- Smooth animations between states

Update my existing component to match this design while maintaining the current functionality."
```

### 3. Layout System Creation
**For responsive design implementation:**

```bash
claude "Help me create a responsive layout system for my NeuroVis Godot app based on these Figma layout specifications:

Grid System:
- 8px base unit
- 16px, 24px, 32px, 48px spacing scale
- Container max width: 1200px
- Sidebar width: 320px
- Panel margins: 24px

Create GDScript functions to handle responsive positioning and sizing that I can use across all my UI components."
```

### 4. Animation Specifications
**For micro-interactions:**

```bash
claude "Based on these Figma animation prototypes, help me implement smooth transitions in my Godot UI:

Entrance Animations:
- Fade + Scale: 0.3s ease-out
- Slide up: 0.25s ease-out  
- Stagger delay: 0.1s between items

Interactive States:
- Hover: 0.15s ease-out scale to 1.05
- Press: 0.1s ease-in scale to 0.95
- Focus: 0.2s ease-out glow effect

Update my existing animation functions in UIThemeManager.gd to match these timing specifications."
```

### 5. Icon System Implementation
**After exporting SVG icons from Figma:**

```bash
claude "I've exported these SVG icons from Figma for my NeuroVis app:
- bookmark.svg
- search.svg  
- close.svg
- settings.svg
- brain-structure.svg

Help me:
1. Convert them to Godot-compatible format
2. Create an icon management system
3. Integrate them into my existing UI components
4. Ensure they follow the design system colors and sizing"
```

## Workflow Integration Prompts

### Design Review Session
```bash
claude "I'm reviewing my current NeuroVis UI against these Figma designs. Help me identify the biggest gaps and create an implementation priority list:

Current Issues I See:
- Inconsistent spacing
- Typography hierarchy unclear
- Button styles need standardization
- Glass morphism could be more sophisticated

Figma Design Goals:
- Professional educational software appearance
- Consistent component library
- Smooth micro-interactions
- Accessibility-focused design

Create a step-by-step improvement plan for my existing Godot components."
```

### Component Audit
```bash
claude "Audit my existing UI components against these Figma design system specifications:

Components to Review:
- ui_info_panel.gd (information display)
- model_control_panel.gd (model toggles)
- UIThemeManager.gd (styling system)

Design System Requirements:
- Consistent color usage
- Proper typography hierarchy  
- Standard spacing patterns
- Interactive state definitions

Identify what needs updating and provide specific GDScript improvements."
```

### Asset Integration
```bash
claude "Help me integrate these Figma exports into my Godot project structure:

Assets Exported:
- /assets/ui/ (PNG components for reference)
- /assets/icons/ (SVG icons)
- design-tokens.json (colors and typography)
- spacing-guide.pdf (layout specifications)

Current Project Structure:
/Users/gagelaporta/11A-NeuroVis copy3/
├── assets/
├── scenes/  
├── scripts/ui/

Show me how to organize these assets and update my code to use them effectively."
```

## Implementation Workflow

### Step 1: Export from Figma
- Design system colors and typography
- Component screenshots for reference
- Icon assets as SVG
- Layout specifications as PDF/JSON

### Step 2: Use Claude Code for Implementation
```bash
cd /Users/gagelaporta/11A-NeuroVis\ copy3

# Start implementation session
claude "Starting UI enhancement session for NeuroVis. I have Figma designs to implement. First, let's update my design system..."

# Work through components systematically
claude "Next, let's enhance my information panel based on the Figma design..."

# Polish and refine
claude "Finally, let's add the micro-animations and polish details..."
```

### Step 3: Iterate and Refine
```bash
# Test and refine
claude "The new UI is implemented. Help me test it and identify any issues..."

# Performance optimization  
claude "Optimize the UI performance while maintaining the design quality..."
```

## Pro Tips for Success

### Before Starting:
1. **Organize Figma exports** - Create clear folder structure
2. **Document design decisions** - Note colors, spacing, typography choices
3. **Take screenshots** - Capture key states and interactions
4. **Export systematically** - Don't try to implement everything at once

### During Implementation:
1. **Start with design tokens** - Colors and typography first
2. **One component at a time** - Don't overwhelm the context
3. **Test frequently** - Run your Godot project to see changes
4. **Document as you go** - Update comments and documentation

### For Best Results:
1. **Be specific in prompts** - Include exact measurements and colors
2. **Reference existing code** - Point Claude Code to current implementations
3. **Ask for explanations** - Understand the changes being made
4. **Request alternatives** - Get multiple implementation options

This approach gives you the power of Figma design quality with Claude Code implementation efficiency, even without direct API integration.
