# Phase 3: StyleEngine & Advanced Interactions - Quick Start Guide

## Overview
Phase 3 introduces unified style management and advanced interaction capabilities to NeuroVis. This guide provides quick examples for developers.

## StyleEngine Quick Reference

### Basic Theme Management
```gdscript
# Set theme mode
StyleEngine.set_theme_mode(StyleEngine.ThemeMode.ENHANCED)    # Student-friendly
StyleEngine.set_theme_mode(StyleEngine.ThemeMode.MINIMAL)     # Clinical/professional
StyleEngine.set_theme_mode(StyleEngine.ThemeMode.HIGH_CONTRAST) # Accessibility

# Get current theme
var current_theme = StyleEngine.get_theme_mode()
```

### Color System
```gdscript
# Get theme-appropriate colors
var primary = StyleEngine.get_color("primary")      # Theme primary color
var background = StyleEngine.get_color("background") # Theme background
var text = StyleEngine.get_color("text_primary")    # Primary text color

# Get complete color palette
var palette = StyleEngine.get_color_palette()
```

### Responsive Design
```gdscript
# Get responsive sizes
var base_size = Vector2(300, 400)
var responsive_size = StyleEngine.get_responsive_size(base_size)

# Check layout type
if StyleEngine.is_mobile_layout():
    setup_mobile_ui()
elif StyleEngine.is_tablet_layout():
    setup_tablet_ui()

# Get responsive font sizes
var title_size = StyleEngine.get_font_size("title")   # Auto-scaled
var body_size = StyleEngine.get_font_size("body")
```

### Component Styling
```gdscript
# Apply unified styling to any component
var style_config = {
    "type": "panel",        # panel, button, label, header
    "variant": "primary",   # primary, secondary, educational
    "responsive": true,     # Enable responsive behavior
    "educational": true     # Educational styling cues
}
StyleEngine.apply_component_style(my_component, style_config)
```

### Animations
```gdscript
# Create smooth transitions
var fade_in = StyleEngine.create_fade_transition(panel, true)
var slide_transition = StyleEngine.create_slide_transition(
    panel, 
    Vector2(-300, 0),  # From position
    Vector2(0, 0)      # To position
)
var scale_animation = StyleEngine.create_scale_animation(
    button,
    Vector2.ONE,       # From scale
    Vector2(1.1, 1.1)  # To scale
)

# Get educational animation durations
var quick = StyleEngine.get_animation_duration("micro")        # 0.1s
var normal = StyleEngine.get_animation_duration("short")       # 0.2s
var smooth = StyleEngine.get_animation_duration("medium")      # 0.4s
var educational = StyleEngine.get_animation_duration("educational") # 1.2s
```

## Advanced Interaction System Quick Reference

### Basic Setup
```gdscript
# Create and add interaction system
var interaction_system = AdvancedInteractionSystem.new()
add_child(interaction_system)

# Set interaction mode
interaction_system.set_interaction_mode(
    AdvancedInteractionSystem.InteractionMode.LEARNING  # Educational context
)
```

### Enable Features
```gdscript
# Enable specific interaction features
interaction_system.enable_gestures(true)          # Touch gestures
interaction_system.enable_context_menus(true)     # Right-click menus

# Connect to signals
interaction_system.gesture_recognized.connect(_on_gesture)
interaction_system.context_menu_requested.connect(_on_context_menu)
interaction_system.educational_action_triggered.connect(_on_educational_action)
```

### Component Integration
```gdscript
# Enable advanced interactions on components
func setup_advanced_component(component: Control):
    # Enable drag & drop
    component.set_meta("draggable", true)
    component.set_meta("drag_type", "panel")
    
    # Enable gestures
    component.set_meta("gesture_enabled", true)
    
    # Enable context menu
    component.set_meta("context_menu_enabled", true)
    component.set_meta("panel_type", "info_panel")
    
    # Define gesture mappings
    var gesture_mappings = {
        "swipe_up": "expand_sections",
        "swipe_down": "collapse_sections",
        "long_press": "show_context_menu"
    }
    component.set_meta("gesture_mappings", gesture_mappings)
```

### Educational Gestures
```gdscript
# Handle educational gesture actions
func _on_gesture(gesture_name: String, gesture_data: Dictionary):
    match gesture_name:
        "swipe_left":
            navigate_to_previous_structure()
        "swipe_right":
            navigate_to_next_structure()
        "swipe_up":
            expand_all_sections()
        "swipe_down":
            collapse_all_sections()
        "pinch_zoom":
            toggle_zoom_mode()
        "long_press":
            show_structure_context_menu()
```

## Feature Flags

### Enable Phase 3 Features
```gdscript
# Enable in code
FeatureFlags.enable_feature(FeatureFlags.UI_STYLE_ENGINE)
FeatureFlags.enable_feature(FeatureFlags.UI_ADVANCED_INTERACTIONS)
FeatureFlags.enable_feature(FeatureFlags.UI_SMOOTH_ANIMATIONS)
FeatureFlags.enable_feature(FeatureFlags.UI_GESTURE_RECOGNITION)
FeatureFlags.enable_feature(FeatureFlags.UI_CONTEXT_MENUS)

# Check if enabled
if FeatureFlags.is_enabled(FeatureFlags.UI_STYLE_ENGINE):
    apply_styled_components()
```

### Debug Commands (F1 Console)
```bash
# Test Phase 3 systems
test_phase3

# Feature flag management
flags_status                    # Show all flags
flag_enable ui_style_engine    # Enable StyleEngine
flag_enable ui_advanced_interactions  # Enable advanced interactions
flag_toggle ui_smooth_animations      # Toggle animations

# Style debugging
registry_stats                  # Component registry stats
style_stats                     # Style engine stats (if available)
```

## Common Patterns

### 1. Educational Panel with Full Phase 3 Features
```gdscript
func create_educational_panel(structure_data: Dictionary) -> Control:
    # Create panel using ComponentRegistry
    var panel = ComponentRegistry.create_component("info_panel", {
        "title": structure_data.get("displayName", "Structure"),
        "theme_mode": "enhanced",
        "responsive": true,
        "show_bookmark": true
    })
    
    # Apply StyleEngine styling
    StyleEngine.apply_component_style(panel, {
        "type": "panel",
        "variant": "educational",
        "responsive": true
    })
    
    # Enable advanced interactions
    panel.set_meta("draggable", true)
    panel.set_meta("gesture_enabled", true)
    panel.set_meta("context_menu_enabled", true)
    
    # Add educational gesture mappings
    var gestures = {
        "swipe_up": "expand_all",
        "swipe_down": "collapse_all",
        "swipe_left": "previous_structure",
        "swipe_right": "next_structure"
    }
    panel.set_meta("gesture_mappings", gestures)
    
    return panel
```

### 2. Smooth Educational Transitions
```gdscript
func transition_between_structures(old_panel: Control, new_panel: Control):
    # Fade out old panel
    var fade_out = StyleEngine.create_fade_transition(old_panel, false,
        StyleEngine.get_animation_duration("medium"))
    
    # Slide in new panel
    var slide_in = StyleEngine.create_slide_transition(new_panel,
        Vector2(300, 0), Vector2.ZERO,
        StyleEngine.get_animation_duration("educational"))
    
    # Chain animations
    fade_out.finished.connect(func():
        slide_in.play()
        old_panel.queue_free()
    )
    
    fade_out.play()
```

### 3. Responsive Theme Switching
```gdscript
func setup_responsive_theming():
    # Connect to viewport changes
    get_viewport().size_changed.connect(_on_viewport_changed)
    
    # Initial responsive setup
    _update_responsive_theme()

func _on_viewport_changed():
    _update_responsive_theme()

func _update_responsive_theme():
    # Switch theme based on screen size
    if StyleEngine.is_mobile_layout():
        StyleEngine.set_theme_mode(StyleEngine.ThemeMode.MINIMAL)
        enable_mobile_gestures()
    else:
        StyleEngine.set_theme_mode(StyleEngine.ThemeMode.ENHANCED)
        enable_desktop_interactions()
```

### 4. Accessibility Support
```gdscript
func enable_accessibility_features():
    # Enable accessibility mode
    StyleEngine.enable_accessibility_mode(true)
    
    # Set high contrast theme
    StyleEngine.set_theme_mode(StyleEngine.ThemeMode.HIGH_CONTRAST)
    
    # Configure interaction system for accessibility
    var interaction_system = get_node("AdvancedInteractionSystem")
    interaction_system.set_interaction_mode(
        AdvancedInteractionSystem.InteractionMode.ACCESSIBILITY
    )
    
    # Disable motion for sensitive users
    FeatureFlags.disable_feature(FeatureFlags.UI_SMOOTH_ANIMATIONS)
```

## Performance Tips

### 1. Style Caching
```gdscript
# Use component registry for caching
var panel = ComponentRegistry.get_or_create("main_info", "info_panel", config)

# Clear cache when needed
StyleEngine.clear_style_cache()
```

### 2. Animation Optimization
```gdscript
# Limit concurrent animations
var max_animations = 5
if get_children().filter(func(c): return c is Tween).size() < max_animations:
    create_new_animation()

# Use appropriate duration types
var duration = StyleEngine.get_animation_duration("micro")  # For quick feedback
```

### 3. Gesture Performance
```gdscript
# Enable gestures only when needed
if StyleEngine.is_mobile_layout():
    interaction_system.enable_gestures(true)
else:
    interaction_system.enable_gestures(false)
```

## Troubleshooting

### Styles Not Applying
```gdscript
# Check feature flag
if not FeatureFlags.is_enabled(FeatureFlags.UI_STYLE_ENGINE):
    print("StyleEngine not enabled")

# Check component configuration
StyleEngine.print_style_stats()
```

### Interactions Not Working
```gdscript
# Verify interaction system setup
if not has_node("AdvancedInteractionSystem"):
    print("AdvancedInteractionSystem not found")

# Check feature flags
if not FeatureFlags.is_enabled(FeatureFlags.UI_ADVANCED_INTERACTIONS):
    print("Advanced interactions not enabled")
```

### Performance Issues
```gdscript
# Monitor performance
ComponentRegistry.print_registry_stats()
StyleEngine.print_style_stats()

# Clean up unused components
ComponentRegistry.cleanup_registry()
```

## Next Steps

1. **Test Phase 3**: Use `test_phase3` debug command
2. **Explore Examples**: Check existing InfoPanelComponent integration
3. **Customize Themes**: Experiment with StyleEngine theme modes
4. **Add Interactions**: Integrate AdvancedInteractionSystem in your components
5. **Optimize Performance**: Monitor and optimize based on your usage patterns

---
**Quick Reference**: Use F1 console commands for testing and debugging Phase 3 features!