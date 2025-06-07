# Minimal UI Design Implementation for NeuroVis

## 🎯 Design Principles (Apple/OpenAI Inspired)

### Core Philosophy
- **Clarity**: Content is king, UI disappears
- **Simplicity**: Every element earns its place
- **Purpose**: Function over decoration
- **Refinement**: Subtle details, not ornaments

## 📐 Design System

### Color Palette
```gdscript
# Monochromatic with opacity variations
background: rgba(255, 255, 255, 0.04)  # 4% white
border:     rgba(255, 255, 255, 0.08)  # 8% white
hover:      rgba(255, 255, 255, 0.06)  # 6% white
text:       rgba(255, 255, 255, 0.85)  # 85% white
muted:      rgba(255, 255, 255, 0.30)  # 30% white
```

### Typography
```
Display: 28px, 600 weight, -0.02em tracking
Body:    15px, 400 weight, 1.6 line-height
Caption: 13px, 500 weight, uppercase
Small:   14px, 400 weight
```

### Spacing
```
Base unit: 4px
Scale: 4, 8, 16, 24, 32, 40, 60
```

### Animation
```
Duration: 0.2s (fast), 0.3s (normal), 0.5s (slow)
Easing: cubic-bezier(0.4, 0, 0.2, 1)
```

## 🎨 Visual Characteristics

### What's Different
1. **No Glass Morphism Effects**
   - Simple transparency instead of complex blur
   - Flat surfaces with subtle borders

2. **Monochrome Palette**
   - Black background
   - White text with opacity variations
   - No accent colors except for active states

3. **Minimal Animations**
   - Subtle fades and slides
   - No bounce or spring effects
   - Purpose-driven micro-interactions

4. **Clean Typography**
   - Clear hierarchy
   - Generous white space
   - No decorative elements

5. **Essential Actions Only**
   - Bookmark and close (no share)
   - Hidden sections by default
   - Progressive disclosure

## 💻 Implementation Guide

### Quick Integration
```bash
# 1. Add minimal panel to your project
cp .claude/minimal_info_panel.gd scenes/ui/

# 2. Update with Claude Code
claude "Integrate minimal_info_panel.gd into my main scene, replacing the current info panel"

# 3. Update theme manager
claude "Add minimal design tokens from minimal-design-spec.json to UIThemeManager.gd"
```

### Key Code Patterns

#### Minimal Styling
```gdscript
# Simple, flat style
var style = StyleBoxFlat.new()
style.bg_color = Color(1, 1, 1, 0.04)
style.border_color = Color(1, 1, 1, 0.08)
style.set_border_width_all(1)
style.set_corner_radius_all(12)
```

#### Subtle Interactions
```gdscript
# Hover effect
item.mouse_entered.connect(func():
    var tween = create_tween()
    tween.tween_property(item, "modulate", Color(1.1, 1.1, 1.1), 0.2)
)
```

#### Clean Layout
```gdscript
# Consistent spacing
container.add_theme_constant_override("separation", 32)
container.add_theme_constant_override("margin_left", 32)
```

## 🔄 Migrating from Enhanced to Minimal

### Step 1: Remove Visual Effects
```gdscript
# Remove glass morphism
# OLD: style.bg_color = Color(0.06, 0.06, 0.09, 0.85)
# NEW: style.bg_color = Color(1, 1, 1, 0.04)

# Remove shadows
# OLD: style.shadow_size = 32
# NEW: # No shadow
```

### Step 2: Simplify Colors
```gdscript
# OLD: Multiple accent colors
# NEW: Monochrome palette
const COLORS = {
    "text": Color(1, 1, 1, 0.85),
    "muted": Color(1, 1, 1, 0.3)
}
```

### Step 3: Reduce Animations
```gdscript
# OLD: Bounce animations
# tween.set_trans(Tween.TRANS_BACK)

# NEW: Simple cubic easing
# tween.set_trans(Tween.TRANS_CUBIC)
```

## 📊 Benefits of Minimal Design

### Performance
- ✅ Faster rendering (no blur effects)
- ✅ Lower GPU usage
- ✅ Smaller file sizes
- ✅ Better battery life on mobile

### Usability
- ✅ Better readability
- ✅ Clearer information hierarchy
- ✅ Less cognitive load
- ✅ Professional appearance

### Development
- ✅ Easier to maintain
- ✅ Faster to implement
- ✅ More accessible by default
- ✅ Cross-platform consistency

## 🎯 When to Use Minimal Design

### Perfect For:
- Medical/scientific applications
- Professional tools
- Data visualization
- Educational content (adult)
- Accessibility-focused apps

### Consider Enhanced For:
- Gaming applications
- Children's education
- Entertainment apps
- Marketing/promotional content

## 📝 Final Recommendations

1. **Start Minimal**: Begin with the minimal design as your base
2. **Add Purposefully**: Only add visual elements that serve a function
3. **Test with Users**: Let user needs drive design decisions
4. **Maintain Consistency**: Use the design system throughout

The minimal approach creates a professional, timeless interface that puts your content first - perfect for a neuroscience visualization tool where accuracy and clarity are paramount.
