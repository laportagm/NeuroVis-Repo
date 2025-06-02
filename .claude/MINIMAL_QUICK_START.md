# Quick Implementation Prompts for Minimal UI

## 🚀 Ready-to-Use Claude Code Prompts

### 1. Full Minimal Redesign
```bash
claude "Help me implement a minimal, Apple-inspired redesign of my NeuroVis UI:

1. Update UIThemeManager.gd with minimal color palette:
   - Monochrome: black background with white text at various opacities
   - Remove all accent colors except for essential states
   - Simplify to 6 core colors maximum

2. Replace ui_info_panel.gd with minimal_info_panel.gd:
   - Clean typography hierarchy (28px title, 15px body, 13px captions)
   - Remove glass morphism effects
   - Subtle borders and backgrounds (4% white opacity)
   - Essential actions only (bookmark, close)

3. Simplify animations:
   - 0.3s cubic-bezier transitions
   - No bounce or spring effects
   - Subtle fade and slide only

4. Update all UI components to match this minimal aesthetic"
```

### 2. Typography Update Only
```bash
claude "Update my UI typography to match Apple/OpenAI style:
- Display: 28px, 600 weight, -0.02em letter-spacing
- Body: 15px, 400 weight, 1.6 line-height  
- Caption: 13px, 500 weight, uppercase
- Use -apple-system, SF Pro Display, Inter fonts
- Clear hierarchy with generous white space"
```

### 3. Color System Conversion
```bash
claude "Convert my colorful UI to a minimal monochrome palette:
From:
- Primary: #00D9FF
- Secondary: #FF006E  
- Success: #06FFA5

To:
- All whites with opacity variations
- background: rgba(255,255,255,0.04)
- border: rgba(255,255,255,0.08)
- text: rgba(255,255,255,0.85)"
```

### 4. Animation Simplification
```bash
claude "Simplify all UI animations to be minimal and purposeful:
- Remove all bounce effects (TRANS_BACK)
- Use only cubic easing (0.4, 0, 0.2, 1)
- Durations: 0.2s fast, 0.3s normal, 0.5s slow
- Only animate opacity and small position changes
- Remove scale animations except for buttons (0.95 on press)"
```

### 5. Component by Component
```bash
# Info Panel
claude "Redesign ui_info_panel.gd with minimal Apple aesthetic using the code from minimal_info_panel.gd"

# Control Panel  
claude "Apply the same minimal design principles to model_control_panel.gd"

# Navigation
claude "Create a minimal navigation bar with monochrome colors and subtle interactions"
```

## 🎯 Complete Migration in 30 Minutes

```bash
# Step 1: Backup current UI (5 min)
cp -r scenes/ui scenes/ui_backup

# Step 2: Update design system (10 min)
claude "Using minimal-design-spec.json, update UIThemeManager.gd with minimal design tokens"

# Step 3: Replace info panel (10 min)
claude "Replace ui_info_panel.gd with minimal_info_panel.gd, ensuring all signals connect properly"

# Step 4: Test and refine (5 min)
./quick_test.sh
claude "Fix any styling inconsistencies in the minimal UI"
```

## 💡 Pro Tips

1. **Start with one component** - Don't try to redesign everything at once
2. **Remove before adding** - Strip away decorations first
3. **Test on black background** - Ensures proper contrast
4. **Check accessibility** - Minimal design should improve readability
5. **Keep it consistent** - Use the same patterns everywhere

Remember: The goal is to make the UI invisible so users focus on your content!
