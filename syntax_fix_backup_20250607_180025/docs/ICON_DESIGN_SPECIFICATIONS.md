# NeuroVis Icon Design Specifications

## Overview
The NeuroVis icon should represent the intersection of neuroscience, education, and technology. It needs to be recognizable at all sizes from 16x16 to 1024x1024 pixels.

## Design Concept

### Primary Elements
1. **Brain Silhouette**: Simplified, modern representation
2. **Neural Connections**: Abstract network lines/dots
3. **3D Perspective**: Subtle depth indication

### Color Palette
Based on the NeuroVis brand colors:
- **Primary**: #00D9FF (Cyan) - Neural connections
- **Secondary**: #7209B7 (Purple) - Brain matter
- **Accent**: #06FFA5 (Green) - Active regions
- **Background**: #0A0A0F (Deep space black) or transparent

### Style Guidelines
- **Minimalist**: Clean, simple shapes
- **Modern**: Flat design with subtle gradients
- **Scientific**: Accurate but stylized
- **Scalable**: Readable at all sizes

## Icon Variations

### 1. Main App Icon (1024x1024)
Full detail version with:
- Gradient backgrounds
- Multiple neural connection lines
- Subtle glow effects
- Full color palette

### 2. Small Icons (16x16 to 64x64)
Simplified version with:
- Solid colors (no gradients)
- Fewer neural connections
- Thicker lines for visibility
- High contrast

### 3. Monochrome Version
For system tray and special uses:
- Single color (white/black)
- Even simpler design
- Maximum contrast

## Technical Requirements

### File Formats
1. **Source**: SVG (vector) or high-res PNG (1024x1024)
2. **Windows**: ICO with sizes: 16, 32, 48, 64, 128, 256
3. **macOS**: ICNS with all required sizes including @2x
4. **Linux**: PNG in standard sizes
5. **Web**: PNG favicons and touch icons

### Design Grid
- Use 1024x1024 master canvas
- 64px safe margin on all sides
- Center the main design in 896x896 area
- Align to 32px grid for pixel-perfect scaling

## Visual Examples

### Concept Sketch
```
     ╭─────────────────╮
     │                 │
     │    ╭─────╮      │
     │   ╱       ╲     │
     │  │  ◇───◇  │    │  ← Neural connections
     │  │ ╱     ╲ │    │
     │  │◇   ◆   ◇│    │  ← Brain regions
     │  │ ╲     ╱ │    │
     │   ╲  ◇─◇  ╱     │
     │    ╰─────╯      │
     │                 │
     ╰─────────────────╯
```

### Layer Structure
1. **Background**: Gradient or solid
2. **Brain Shape**: Main silhouette
3. **Neural Network**: Connection lines
4. **Highlights**: Active regions
5. **Effects**: Glow, shadows (optional)

## Creation Process

### 1. Vector Design (Recommended)
```xml
<!-- SVG Template -->
<svg width="1024" height="1024" xmlns="http://www.w3.org/2000/svg">
  <!-- Background -->
  <rect width="1024" height="1024" fill="#0A0A0F"/>
  
  <!-- Brain shape -->
  <path d="..." fill="#7209B7" opacity="0.9"/>
  
  <!-- Neural connections -->
  <g stroke="#00D9FF" stroke-width="4" fill="none">
    <path d="..."/>
    <circle cx="" cy="" r="8" fill="#00D9FF"/>
  </g>
  
  <!-- Active regions -->
  <circle cx="" cy="" r="32" fill="#06FFA5" opacity="0.6"/>
</svg>
```

### 2. Raster Design (Alternative)
- Start with 1024x1024 canvas
- Use shape tools for brain outline
- Add neural network on separate layer
- Apply effects sparingly
- Export as PNG with transparency

## Accessibility Considerations

### Contrast Ratios
- Icon vs Background: Minimum 3:1
- Important elements: Minimum 4.5:1
- Test on light and dark backgrounds

### Color Blindness
- Design should work in grayscale
- Avoid relying solely on color
- Use shape and position for meaning

## Export Guidelines

### From Vector (SVG)
```bash
# Using Inkscape
inkscape input.svg -w 1024 -h 1024 -o neurovis_icon_1024.png

# Using ImageMagick
convert -background none input.svg -resize 1024x1024 neurovis_icon_1024.png
```

### From Raster (Photoshop/GIMP)
1. Save as PNG with transparency
2. Ensure 1024x1024 dimensions
3. Use maximum quality
4. No compression

## Usage Examples

### In Godot Project
```
[application]
config/icon="res://icon.png"
config/macos_native_icon="res://icon.icns"
config/windows_native_icon="res://icon.ico"
```

### Platform Integration
- **Windows**: Shows in taskbar, start menu, desktop
- **macOS**: Shows in dock, Launchpad, Finder
- **Linux**: Shows in application menu, dock/panel

## Testing Checklist

- [ ] Visible at 16x16 pixels
- [ ] Recognizable at 32x32 pixels
- [ ] Clear details at 256x256 pixels
- [ ] Works on dark backgrounds
- [ ] Works on light backgrounds
- [ ] Maintains brand identity
- [ ] Accessible to color blind users
- [ ] Professional appearance

## Resources

### Design Tools
- **Figma**: Free, web-based, great for icons
- **Inkscape**: Free, open-source vector editor
- **Affinity Designer**: Professional vector tool
- **Adobe Illustrator**: Industry standard

### Icon Templates
- Apple Human Interface Guidelines
- Material Design Icon Guidelines
- Microsoft Fluent Design Icons

### Testing Tools
- IconJar (macOS): Preview at all sizes
- RealFaviconGenerator.net: Web favicon testing
- Contrast Checker: Verify accessibility

---

Remember: The icon is often the first thing users see. It should be memorable, professional, and clearly represent NeuroVis's purpose as an educational brain visualization tool.
