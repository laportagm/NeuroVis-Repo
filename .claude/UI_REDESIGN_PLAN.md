# NeuroVis UI Redesign Implementation Plan

## 🎯 Goal
Implement a theme system supporting both Enhanced (Gaming) and Minimal (Apple/OpenAI) styles without breaking existing functionality.

## 📋 Pre-Implementation Checklist

### Current State Analysis
- [x] Current UI uses `ui_info_panel.gd` in `scenes/`
- [x] UIThemeManager exists with glass morphism styling
- [x] Signals connected: `structure_selected`, `panel_closed`
- [x] Model manager integration working
- [x] Current color system uses accent colors

### Risk Mitigation
1. **Backup current working state**
2. **Create theme switching system**
3. **Test each component individually**
4. **Maintain backward compatibility**
5. **Implement rollback points**

## 🔄 Implementation Phases

### Phase 1: Foundation (Day 1)
**Goal**: Set up theme system without changing current UI

#### Step 1.1: Backup Current State
```bash
# Create backup branch
git checkout -b ui-redesign-backup
git add .
git commit -m "Backup before UI redesign"
git checkout TheDefaultBranch

# Create working branch
git checkout -b feature/theme-system
```

#### Step 1.2: Create Theme Manager Extension
```gdscript
# scripts/ui/UIThemeVariants.gd
class_name UIThemeVariants
extends RefCounted

enum ThemeMode {
    ENHANCED,  # Current gaming style
    MINIMAL    # Apple/OpenAI style
}

static var current_theme: ThemeMode = ThemeMode.ENHANCED

# Theme configurations
const THEMES = {
    ThemeMode.ENHANCED: {
        "name": "Enhanced",
        "colors": preload("res://.claude/figma-exports/info-panel-design-spec.json"),
        "panel_class": "StructureInfoPanel"
    },
    ThemeMode.MINIMAL: {
        "name": "Minimal", 
        "colors": preload("res://.claude/figma-exports/minimal-design-spec.json"),
        "panel_class": "MinimalInfoPanel"
    }
}
```

#### Step 1.3: Update UIThemeManager
```gdscript
# Add to UIThemeManager.gd
static var theme_mode: UIThemeVariants.ThemeMode = UIThemeVariants.ThemeMode.ENHANCED

static func get_current_colors() -> Dictionary:
    if theme_mode == UIThemeVariants.ThemeMode.MINIMAL:
        return MINIMAL_COLORS
    else:
        return COLORS  # Current colors

static func switch_theme(mode: UIThemeVariants.ThemeMode) -> void:
    theme_mode = mode
    # Emit theme change signal
```

### Phase 2: Minimal Panel Integration (Day 2)
**Goal**: Add minimal panel without removing current one

#### Step 2.1: Copy Minimal Panel
```bash
cp .claude/minimal_info_panel.gd scripts/ui/minimal_info_panel.gd
```

#### Step 2.2: Create Panel Factory
```gdscript
# scripts/ui/InfoPanelFactory.gd
class_name InfoPanelFactory
extends RefCounted

static func create_info_panel(theme: UIThemeVariants.ThemeMode) -> Control:
    match theme:
        UIThemeVariants.ThemeMode.MINIMAL:
            return preload("res://scripts/ui/minimal_info_panel.gd").new()
        _:
            return preload("res://scenes/ui_info_panel.gd").new()
```

#### Step 2.3: Update Main Scene Integration
```gdscript
# In main_scene.gd, modify info panel creation
func _create_info_panel() -> void:
    # Remove old hardcoded panel
    if info_panel:
        info_panel.queue_free()
    
    # Create based on theme
    info_panel = InfoPanelFactory.create_info_panel(UIThemeManager.theme_mode)
    
    # Reconnect signals (works for both panel types)
    info_panel.panel_closed.connect(_on_info_panel_closed)
    info_panel.structure_bookmarked.connect(_on_structure_bookmarked)
    
    # Add to scene
    ui_layer.add_child(info_panel)
```

### Phase 3: Theme Switching UI (Day 3)
**Goal**: Add settings to switch themes

#### Step 3.1: Create Settings Menu
```gdscript
# scripts/ui/settings_menu.gd
extends Control

signal theme_changed(mode)

@onready var theme_selector: OptionButton

func _ready():
    _populate_themes()
    theme_selector.selected = UIThemeManager.theme_mode

func _populate_themes():
    theme_selector.add_item("Enhanced (Gaming)", UIThemeVariants.ThemeMode.ENHANCED)
    theme_selector.add_item("Minimal (Professional)", UIThemeVariants.ThemeMode.MINIMAL)

func _on_theme_selected(index: int):
    var mode = theme_selector.get_item_id(index)
    emit_signal("theme_changed", mode)
```

#### Step 3.2: Handle Theme Changes
```gdscript
# In main_scene.gd
func _on_theme_changed(mode: UIThemeVariants.ThemeMode) -> void:
    UIThemeManager.switch_theme(mode)
    
    # Recreate UI panels with new theme
    _create_info_panel()
    _create_model_control_panel()
    
    # Save preference
    _save_theme_preference(mode)
```

### Phase 4: Testing & Polish (Day 4)
**Goal**: Ensure everything works perfectly

#### Step 4.1: Comprehensive Testing
```bash
# Test script
./test_theme_switching.sh

# Manual tests:
# 1. Launch with Enhanced theme
# 2. Select hippocampus - verify panel shows
# 3. Switch to Minimal theme
# 4. Verify panel recreates in minimal style
# 5. Test all interactions
# 6. Restart app - verify theme persists
```

#### Step 4.2: Fix Signal Issues
```gdscript
# Common issue: Signals not reconnecting
func _ensure_signal_connections():
    # Disconnect if connected
    if info_panel.panel_closed.is_connected(_on_info_panel_closed):
        info_panel.panel_closed.disconnect(_on_info_panel_closed)
    
    # Reconnect
    info_panel.panel_closed.connect(_on_info_panel_closed)
```

## 🛡️ Safety Measures

### 1. Gradual Rollout
```gdscript
# Add feature flag
const ENABLE_THEME_SWITCHING = true

func _ready():
    if ENABLE_THEME_SWITCHING:
        _setup_theme_system()
    else:
        _use_legacy_ui()
```

### 2. Error Handling
```gdscript
func _create_info_panel_safe() -> void:
    try:
        info_panel = InfoPanelFactory.create_info_panel(theme_mode)
    except:
        print("Failed to create themed panel, falling back to default")
        info_panel = preload("res://scenes/ui_info_panel.gd").new()
```

### 3. Compatibility Layer
```gdscript
# Ensure both panels have same interface
class_name IInfoPanel
extends Control

# Required methods
func display_structure_data(data: Dictionary) -> void: pass
func hide_panel() -> void: pass
func show_panel() -> void: pass

# Required signals
signal panel_closed
signal structure_bookmarked(structure_id)
```

## 📊 Testing Checklist

### Functionality Tests
- [ ] Structure selection shows panel
- [ ] Panel displays correct data
- [ ] Close button works
- [ ] Bookmark functionality works
- [ ] Animations play smoothly
- [ ] Theme switching doesn't lose data
- [ ] Settings persist on restart

### Performance Tests  
- [ ] No memory leaks when switching themes
- [ ] FPS remains stable
- [ ] Panel creation time < 100ms
- [ ] Theme switch time < 500ms

### Edge Cases
- [ ] Rapid theme switching
- [ ] Theme switch during animation
- [ ] Missing structure data
- [ ] Screen resize during theme switch

## 🚀 Deployment Strategy

### Week 1: Internal Testing
- Implement Phase 1-2
- Test with team
- Gather feedback

### Week 2: Beta Release
- Implement Phase 3-4
- Release with feature flag
- Monitor for issues

### Week 3: Full Release
- Enable for all users
- Remove feature flag
- Document in user guide

## 💡 Quick Commands

```bash
# Start implementation
claude "Help me implement Phase 1 of the theme system following the plan in UI_REDESIGN_PLAN.md"

# Test integration
claude "Create a test script to verify theme switching works without breaking signals"

# Fix specific issues
claude "The info panel signals aren't reconnecting after theme switch - fix this"
```

## 🔧 Troubleshooting Guide

### Issue: Panel doesn't appear after theme switch
```gdscript
# Solution: Ensure proper parent assignment
info_panel = InfoPanelFactory.create_info_panel(theme_mode)
ui_layer.add_child(info_panel)  # Don't forget this!
info_panel.visible = true
```

### Issue: Signals not working
```gdscript
# Solution: Use deferred connections
call_deferred("_connect_panel_signals")
```

### Issue: Theme doesn't persist
```gdscript
# Solution: Save to user settings
func _save_theme_preference(mode: int) -> void:
    var config = ConfigFile.new()
    config.set_value("ui", "theme_mode", mode)
    config.save("user://settings.cfg")
```

## ✅ Success Criteria

1. **Both themes work**: Can switch between Enhanced and Minimal
2. **No regressions**: All current features still work
3. **Performance maintained**: No FPS drops
4. **Clean code**: Well-organized, documented
5. **User choice**: Theme preference saved

This plan ensures a smooth, safe implementation of the dual-theme system!
