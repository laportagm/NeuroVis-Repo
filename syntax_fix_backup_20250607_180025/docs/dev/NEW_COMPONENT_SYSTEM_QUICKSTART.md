# New Component System - Quick Start Guide

## Overview
The new component system provides a modern, modular approach to UI development in NeuroVis using composition, caching, and progressive enhancement.

## Key Components

### 1. InfoPanelComponent
Main educational information panel with fragment composition.

```gdscript
# Create with ComponentRegistry
var panel = ComponentRegistry.create_component("info_panel", {
    "title": "Brain Structure Name",
    "theme_mode": "enhanced",  # or "minimal"
    "responsive": true,
    "show_bookmark": true
})

# Display structure data
panel.display_structure_info(structure_data)
```

### 2. Fragment Components
Modular UI pieces that can be combined.

```gdscript
# Header with actions
var header = ComponentRegistry.create_component("header", {
    "title": "Hippocampus",
    "actions": ["bookmark", "close"]
})

# Content with sections
var content = ComponentRegistry.create_component("content", {
    "sections": ["description", "functions", "clinical_relevance"]
})

# Action buttons
var actions = ComponentRegistry.create_component("actions", {
    "preset": "educational",  # default, educational, clinical
    "buttons": [
        {"text": "Learn More", "action": "learn"},
        {"text": "Quiz", "action": "quiz"}
    ]
})

# Individual section
var section = ComponentRegistry.create_component("section", {
    "name": "description",
    "title": "Description",
    "collapsible": true,
    "expanded": true
})
```

## Feature Flags

Control which system is used:

```gdscript
# Enable new component system
FeatureFlags.enable_feature(FeatureFlags.UI_MODULAR_COMPONENTS)

# Disable for legacy system
FeatureFlags.disable_feature(FeatureFlags.UI_MODULAR_COMPONENTS)

# Toggle between systems for testing
ComponentRegistry.set_legacy_mode(false)  # Use new system
ComponentRegistry.set_legacy_mode(true)   # Use legacy system
```

## Theme Configuration

```gdscript
# Enhanced theme (student-friendly, engaging)
var config = {
    "theme_mode": "enhanced",
    "use_glassmorphism": true,
    "vibrant_colors": true
}

# Minimal theme (clinical, professional)
var config = {
    "theme_mode": "minimal",
    "clean_design": true,
    "high_contrast": true
}
```

## State Management

```gdscript
# Components automatically save/restore state
var panel = ComponentRegistry.get_or_create("main_info", "info_panel", config)

# Manual state operations
ComponentStateManager.save_component_state("panel_id", {"expanded": true})
var state = ComponentStateManager.restore_component_state("panel_id")
```

## Testing & Debug Commands

### Available Debug Commands (F1 console)
- `test_new_components` - Comprehensive system test
- `registry_stats` - View component statistics
- `migration_test` - Test legacy vs new switching
- `flags_status` - Show feature flag status

### Testing Your Components
```gdscript
# Create test component
var test_panel = ComponentRegistry.create_component("info_panel", {
    "title": "Test Structure",
    "theme_mode": "enhanced"
})

# Validate methods exist
if test_panel.has_method("display_structure_info"):
    print("✓ Component API complete")

# Test with sample data
test_panel.display_structure_info({
    "id": "test",
    "displayName": "Test Structure",
    "shortDescription": "Test description"
})
```

## Performance Tips

### 1. Use Component Caching
```gdscript
# Cached creation (recommended)
var panel = ComponentRegistry.get_or_create("info_main", "info_panel", config)

# Direct creation (use sparingly)
var panel = ComponentRegistry.create_component("info_panel", config)
```

### 2. Release Components When Done
```gdscript
# Release from cache (keeps component alive)
ComponentRegistry.release_component("info_main")

# Completely destroy component
ComponentRegistry.destroy_component("info_main")
```

### 3. Monitor Performance
```gdscript
# View registry statistics
ComponentRegistry.print_registry_stats()

# Check cache hit rate
var stats = ComponentRegistry.get_registry_stats()
print("Cache hit rate: %.1f%%" % (stats.hit_ratio * 100))
```

## Migration from Legacy

### 1. Gradual Migration
```gdscript
# Old way (being phased out)
var panel = InfoPanelFactory.create_info_panel()

# New way (recommended)
var panel = ComponentRegistry.create_component("info_panel", config)
```

### 2. Feature Flag Strategy
```gdscript
# Check which system is active
if FeatureFlags.is_enabled(FeatureFlags.UI_MODULAR_COMPONENTS):
    # Use new component system
    var panel = ComponentRegistry.create_component("info_panel", config)
else:
    # Use legacy system
    var panel = InfoPanelFactory.create_info_panel()
```

## Common Patterns

### 1. Educational Information Display
```gdscript
func display_brain_structure(structure_name: String):
    var structure_data = KnowledgeService.get_structure(structure_name)
    
    var panel = ComponentRegistry.get_or_create(
        "main_info_panel", 
        "info_panel", 
        {
            "title": structure_data.get("displayName", structure_name),
            "theme_mode": "enhanced",
            "responsive": true,
            "show_bookmark": true
        }
    )
    
    panel.display_structure_info(structure_data)
```

### 2. Custom Fragment Assembly
```gdscript
func create_custom_panel():
    var container = VBoxContainer.new()
    
    # Add header
    var header = ComponentRegistry.create_component("header", {
        "title": "Custom Panel",
        "actions": ["settings", "close"]
    })
    container.add_child(header)
    
    # Add content sections
    var content = ComponentRegistry.create_component("content", {
        "sections": ["overview", "details"]
    })
    container.add_child(content)
    
    # Add actions
    var actions = ComponentRegistry.create_component("actions", {
        "preset": "default"
    })
    container.add_child(actions)
    
    return container
```

### 3. Theme Switching
```gdscript
func switch_to_clinical_mode():
    # Update theme globally
    UIThemeManager.set_theme_mode(UIThemeManager.ThemeMode.MINIMAL)
    
    # Recreate components with new theme
    var panel = ComponentRegistry.get_or_create("main_info", "info_panel", {
        "theme_mode": "minimal"
    })
```

## Troubleshooting

### Component Not Loading
1. Check if script files exist
2. Verify feature flags are enabled
3. Check console for error messages
4. Use fallback factory methods

### Performance Issues
1. Monitor cache hit rate with `registry_stats`
2. Clean up unused components with `registry_cleanup`
3. Use component pooling for frequently created components

### Theme Not Applying
1. Verify `UIThemeManager` is initialized
2. Check theme mode in component config
3. Ensure theme files are loaded correctly

---
**Quick Reference**: Use `test_new_components` in F1 console to validate your setup!  
**Documentation**: See `PHASE_2_COMPONENT_MIGRATION_COMPLETE.md` for full details