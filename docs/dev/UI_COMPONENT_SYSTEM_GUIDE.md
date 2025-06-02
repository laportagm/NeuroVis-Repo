# NeuroVis UI Component System Guide

## Overview

The NeuroVis UI Component System provides a comprehensive, modular approach to building consistent, accessible, and responsive user interfaces. This system replaces the previous scattered UI components with a unified architecture.

## Architecture

### Core Components

#### 1. BaseUIComponent (`ui/components/core/BaseUIComponent.gd`)
- **Purpose**: Foundation class for all UI components
- **Features**: 
  - Lifecycle management (initialize, update, cleanup)
  - Theme system integration
  - Accessibility support
  - Configuration management
  - State tracking
  - Animation helpers

```gdscript
# Example usage
var my_component = MyCustomComponent.new()
my_component.set_config({
    "title": "Brain Structure Info",
    "theme_mode": "enhanced",
    "accessibility_enabled": true
})
my_component.initialize_component()
```

#### 2. ResponsiveComponent (`ui/components/core/ResponsiveComponent.gd`)
- **Purpose**: Automatic responsive design adaptation
- **Features**:
  - Breakpoint-based layouts (mobile, tablet, desktop)
  - Adaptive typography scaling
  - Touch-friendly controls
  - Orientation-aware positioning

```gdscript
# Responsive panel that adapts to screen size
var responsive_panel = ResponsiveComponent.new()
responsive_panel.responsive_enabled = true
responsive_panel.adaptive_typography = true
```

#### 3. UIComponentFactory (`ui/components/core/UIComponentFactory.gd`)
- **Purpose**: Centralized component creation with consistent styling
- **Features**:
  - Type-safe component creation
  - Style presets and variants
  - Complex component factories (panels, forms, etc.)

```gdscript
# Create consistent components
var primary_button = UIComponentFactory.create_button("Save Changes", "primary")
var info_panel = UIComponentFactory.create_info_panel({
    "title": "Structure Information"
})
```

### Specialized Components

#### 4. ModularInfoPanel (`ui/components/panels/ModularInfoPanel.gd`)
- **Purpose**: Replaces multiple info panel variations
- **Features**:
  - Configurable sections (header, description, functions, etc.)
  - Search functionality
  - Collapsible sections
  - Real-time content updates

```gdscript
# Create modular info panel
var info_panel = ModularInfoPanel.new()
info_panel.add_section("description", {
    "title": "Description",
    "content_type": "rich_text",
    "collapsible": true
})

# Load brain structure data
info_panel.load_structure_data(structure_data)
```

#### 5. AccessibilityManager (`ui/components/controls/AccessibilityManager.gd`)
- **Purpose**: Comprehensive accessibility support
- **Features**:
  - Keyboard navigation
  - Screen reader announcements
  - High contrast mode
  - Font scaling
  - WCAG compliance checking

```gdscript
# Setup accessibility
AccessibilityManager.initialize()
AccessibilityManager.register_component(my_component)
AccessibilityManager.set_high_contrast_mode(true)
```

#### 6. InteractiveTooltip (`ui/components/controls/InteractiveTooltip.gd`)
- **Purpose**: Rich, interactive tooltips with multimedia content
- **Features**:
  - Multiple tooltip types (simple, rich, educational, diagnostic)
  - Interactive actions
  - Smart positioning
  - Responsive design

```gdscript
# Show educational tooltip for brain structure
InteractiveTooltip.show_structure_tooltip(target_control, "hippocampus")

# Show diagnostic information
InteractiveTooltip.show_diagnostic_tooltip(control, {
    "performance": "60 FPS",
    "memory": "45 MB",
    "models_loaded": 3
})
```

## Component Types and Usage

### 1. Panels
```gdscript
# Basic panel
var panel = UIComponentFactory.create_panel("default")

# Enhanced glass panel
var glass_panel = UIComponentFactory.create_panel("enhanced", {
    "opacity": 0.9,
    "blur": true
})

# Modular information panel
var info_panel = ModularInfoPanel.new()
info_panel.panel_title = "Brain Structure Details"
info_panel.show_search = true
info_panel.collapsible_sections = true
```

### 2. Buttons
```gdscript
# Style variants
var primary_btn = UIComponentFactory.create_button("Primary Action", "primary")
var secondary_btn = UIComponentFactory.create_button("Secondary", "secondary")
var danger_btn = UIComponentFactory.create_button("Delete", "danger")
var ghost_btn = UIComponentFactory.create_button("Cancel", "ghost")
var icon_btn = UIComponentFactory.create_button("✕", "icon")
```

### 3. Form Components
```gdscript
# Create complete form
var form = UIComponentFactory.create_form([
    {"type": "text", "label": "Structure Name", "placeholder": "Enter name..."},
    {"type": "dropdown", "label": "Category", "options": ["Cortex", "Subcortex", "Brainstem"]},
    {"type": "checkbox", "text": "Include in analysis", "checked": true}
], {
    "title": "Structure Configuration",
    "actions": [
        {"text": "Save", "style": "primary"},
        {"text": "Cancel", "style": "secondary"}
    ]
})
```

### 4. Responsive Layouts
```gdscript
# Create responsive component
var responsive_control = UIComponentFactory.create_responsive_component(
    UIComponentFactory.ComponentType.PANEL, 
    {"theme_variant": "default"}
)

# Manual responsive setup
var component = ResponsiveComponent.new()
component.set_custom_layout_config("mobile", {
    "panel_width_percent": 0.95,
    "position": "bottom",
    "font_scale": 0.9
})
```

## Integration with Existing Code

### Migration from Old Components

#### Before (Multiple Info Panels):
```gdscript
# OLD: Multiple separate info panel files
# - ui_info_panel.gd
# - enhanced_info_panel.gd  
# - minimal_info_panel.gd
# - modern_info_display.gd
```

#### After (Unified Modular Panel):
```gdscript
# NEW: Single configurable panel
var info_panel = ModularInfoPanel.new()
info_panel.set_config({
    "style": "enhanced",  # or "minimal", "modern"
    "sections": ["header", "description", "functions"],
    "search_enabled": true
})
```

### UIThemeManager Integration

All components automatically integrate with the existing `UIThemeManager`:

```gdscript
# Components automatically use current theme
UIThemeManager.set_theme_mode(UIThemeManager.ThemeMode.ENHANCED)

# All new components will use enhanced theme
var button = UIComponentFactory.create_button("Test", "primary")
```

## Accessibility Features

### Automatic Accessibility
```gdscript
# Components automatically include:
# - Proper focus management
# - ARIA-like properties
# - Keyboard navigation
# - Screen reader support

var accessible_component = BaseUIComponent.new()
accessible_component.accessibility_enabled = true
```

### Manual Accessibility Enhancement
```gdscript
# Enhanced accessibility features
AccessibilityManager.register_component(component)
component.set_accessibility_data({
    "description": "Opens brain structure information panel",
    "role": "button",
    "help_text": "Press Enter or Space to activate"
})
```

## Responsive Design

### Breakpoint System
- **Mobile**: < 480px (touch-optimized, vertical layout)
- **Tablet Portrait**: 480-768px (medium spacing, mixed layout)
- **Tablet Landscape**: 768-1024px (desktop-like, horizontal focus)
- **Desktop**: 1024-1440px (standard desktop layout)
- **Wide Desktop**: > 1440px (enhanced spacing, wide layout)

### Responsive Configuration
```gdscript
# Automatic responsive behavior
var responsive_panel = ResponsiveComponent.new()
responsive_panel.responsive_enabled = true
responsive_panel.maintain_aspect_ratio = true
responsive_panel.adaptive_typography = true

# Custom breakpoint configurations
responsive_panel.set_custom_layout_config("mobile", {
    "padding": {"top": 8, "bottom": 8, "left": 8, "right": 8},
    "font_scale": 0.9,
    "button_height": 44,  # Touch-friendly
    "position": "bottom"
})
```

## Performance Considerations

### Component Lifecycle
- Components automatically clean up resources
- Proper signal disconnection
- Memory leak prevention
- State management

### Lazy Loading
```gdscript
# Components support deferred initialization
var component = MyComponent.new()
component.auto_initialize = false
# ... setup configuration ...
component.initialize_component()  # Initialize when ready
```

### Resource Management
```gdscript
# Automatic cleanup on removal
func _exit_tree():
    cleanup_component()  # Automatically called by BaseUIComponent
```

## Testing and Debugging

### Component Inspector
```gdscript
# Get component debug information
var debug_info = component.get_component_info()
print("Component State: ", debug_info.state)
print("Config: ", debug_info.config)
```

### Accessibility Testing
```gdscript
# Test color contrast
var sufficient = AccessibilityManager.is_contrast_sufficient(
    Color.WHITE, Color.BLACK, "AA", false
)

# Test component accessibility
AccessibilityManager.announce("Testing screen reader support")
```

## Best Practices

### 1. Use Factory Methods
```gdscript
# GOOD: Use factory for consistency
var button = UIComponentFactory.create_button("Action", "primary")

# AVOID: Direct instantiation
var button = Button.new()  # Missing styling and configuration
```

### 2. Configure Before Initialization
```gdscript
# GOOD: Configure then initialize
var component = MyComponent.new()
component.set_config(my_config)
component.initialize_component()

# AVOID: Changing config after initialization
component.initialize_component()
component.set_config(my_config)  # May not apply properly
```

### 3. Use Responsive Components
```gdscript
# GOOD: Responsive by default
var responsive_panel = UIComponentFactory.create_responsive_component(
    UIComponentFactory.ComponentType.PANEL
)

# CONSIDER: Manual responsive handling only when necessary
var manual_panel = ResponsiveComponent.new()
manual_panel.responsive_enabled = false
```

### 4. Enable Accessibility
```gdscript
# GOOD: Always enable accessibility
AccessibilityManager.register_component(component)

# Set meaningful descriptions
component.set_accessibility_data({
    "description": "Shows detailed brain structure information",
    "role": "dialog"
})
```

## Examples and Use Cases

### Brain Structure Information Display
```gdscript
func show_structure_info(structure_id: String):
    var info_panel = ModularInfoPanel.new()
    info_panel.panel_title = "Structure Information"
    info_panel.closeable = true
    info_panel.add_section("header", ModularInfoPanel.SECTION_TYPES.header)
    info_panel.add_section("description", ModularInfoPanel.SECTION_TYPES.description)
    info_panel.add_section("functions", ModularInfoPanel.SECTION_TYPES.functions)
    
    # Load structure data
    var structure_data = KnowledgeService.get_structure(structure_id)
    info_panel.load_structure_data(structure_data)
    
    # Add to scene
    add_child(info_panel)
    info_panel.animate_show()
```

### Camera Control Panel
```gdscript
func create_camera_controls():
    var control_panel = UIComponentFactory.create_control_panel({
        "title": "Camera Controls",
        "sections": [
            {
                "title": "Movement",
                "content": [
                    {"type": "button", "text": "Reset View", "style": "primary"},
                    {"type": "slider", "label": "Move Speed", "config": {"min": 0.1, "max": 2.0, "value": 1.0}}
                ]
            },
            {
                "title": "Rotation", 
                "content": [
                    {"type": "checkbox", "text": "Auto-rotate", "checked": false},
                    {"type": "slider", "label": "Rotation Speed", "config": {"min": 0.1, "max": 5.0, "value": 1.0}}
                ]
            }
        ]
    })
```

### Interactive Help System
```gdscript
func setup_help_tooltips():
    # Register tooltips for brain structures
    InteractiveTooltip.register_tooltip_for_control(hippocampus_model, {
        "type": "educational",
        "title": "Hippocampus",
        "description": "Critical for memory formation and spatial navigation.",
        "actions": [
            {"text": "Learn More", "action": "open_details"},
            {"text": "Highlight Connections", "action": "show_connections"}
        ]
    })
    
    # Diagnostic tooltips for debug info
    InteractiveTooltip.register_tooltip_for_control(performance_indicator, {
        "type": "diagnostic",
        "title": "Performance Info",
        "data": {
            "fps": Engine.get_frames_per_second(),
            "memory": OS.get_static_memory_usage_by_type(),
            "models_loaded": ModelLoader.get_loaded_model_count()
        }
    })
```

This UI Component System provides a robust foundation for creating consistent, accessible, and responsive user interfaces in NeuroVis while maintaining compatibility with existing code.