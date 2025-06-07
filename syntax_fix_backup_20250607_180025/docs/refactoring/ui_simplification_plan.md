# UI Architecture Simplification Plan

## Current Issues to Address

### 1. Compatibility Layer Overhead
- `ui_info_panel.gd` delegates to `InformationPanelController.gd`
- Unnecessary indirection adds complexity
- Mixed patterns across different UI components

### 2. Fallback UI Creation
```gdscript
# REMOVE: This pattern
if not _validate_ui_nodes():
    print("[INFO_PANEL] UI nodes not found - using compatibility mode")
    _create_fallback_ui()
```

### 3. Inconsistent UI Patterns
- Some panels use direct scene binding
- Others use programmatic creation
- Mixed initialization approaches

## New Standardized UI Architecture

### UI Component Template
```gdscript
# Standard UI panel structure
class_name UIPanelBase extends Control

signal panel_shown
signal panel_hidden
signal content_updated

@export var animation_duration: float = 0.3
@export var auto_hide: bool = false
@export var auto_hide_delay: float = 3.0

var is_showing: bool = false

func _ready():
    visible = false
    _setup_ui()
    _connect_signals()

func show_panel(animate: bool = true) -> void:
    if animate:
        _animate_show()
    else:
        visible = true
    is_showing = true
    panel_shown.emit()

func hide_panel(animate: bool = true) -> void:
    if animate:
        _animate_hide()
    else:
        visible = false
    is_showing = false
    panel_hidden.emit()
```

### Standardized UI Manager
```gdscript
# core/ui/ui_manager.gd
class_name UIManager extends Node

# Panel registry with type safety
var panels: Dictionary = {
    "info": null,  # InfoPanel
    "model_control": null,  # ModelControlPanel
    "settings": null,  # SettingsPanel
}

func _ready():
    _discover_panels()
    _validate_panels()

func _discover_panels():
    # Auto-discover panels by group
    for panel in get_tree().get_nodes_in_group("ui_panels"):
        if panel.has_meta("panel_id"):
            var panel_id = panel.get_meta("panel_id")
            panels[panel_id] = panel

func show_panel(panel_id: String, data: Dictionary = {}) -> void:
    if panel_id in panels and panels[panel_id]:
        panels[panel_id].show_panel()
        if panels[panel_id].has_method("update_content"):
            panels[panel_id].update_content(data)
```

## Implementation Steps

### Phase 1: Create Standardized Base Classes

#### Task 1: UIPanelBase Implementation
```bash
claude "Create core/ui/ui_panel_base.gd with standardized panel behavior: show/hide animations using Godot tweens, auto-hide functionality, consistent signal interface. Include glass morphism styling helpers. Reference model_control_panel.gd for animation patterns."
```

#### Task 2: Refactor Info Panel
```xml
<task>
  <role>UI developer</role>
  <objective>Simplify InfoPanel to single-file implementation</objective>
  <steps>
    1. Merge ui_info_panel.gd and InformationPanelController.gd
    2. Extend UIPanelBase for consistency
    3. Remove compatibility mode and fallback UI
    4. Direct scene node references only
  </steps>
  <validation>Panel shows/hides correctly with test data</validation>
</task>
```

### Phase 2: Implement Centralized UI Management

#### Task 3: Create UI Manager
```bash
claude -p "Implement UIManager as central UI coordinator. Features: 1) Auto-discovery of UI panels by group, 2) Type-safe panel access, 3) Centralized show/hide logic, 4) Panel state management. No dynamic UI creation - all panels must exist in scene."
```

#### Task 4: Update All Panels
```bash
claude "Systematically update each UI panel to: 1) Extend UIPanelBase, 2) Add panel_id metadata, 3) Join 'ui_panels' group, 4) Implement update_content() method. Panels to update: InfoPanel, ModelControlPanel, SettingsPanel. Maintain all current functionality."
```

### Phase 3: Scene Structure Standardization

#### Task 5: Define UI Scene Structure
```bash
claude "Create scenes/ui/standard_ui_structure.tscn as template for consistent UI organization. Structure: UI (Control) > Panels (Control) > [Individual panels]. Document required node paths in CLAUDE.md."
```

#### Task 6: Migrate Main Scene UI
```bash
claude "Update main scene (node_3d.tscn) to use standardized UI structure. Ensure all UI panels are properly positioned in scene tree. Remove any programmatic UI creation code from node_3d.gd."
```

## AI Batch Implementation Prompt

```xml
<task>
  <role>UI architecture specialist</role>
  <context>NeuroVis UI system refactoring</context>
  <objective>Complete UI simplification in single session</objective>
  <parallel_tasks>
    1. Create ui_panel_base.gd with standard behaviors
    2. Merge InfoPanel implementations
    3. Implement UIManager with auto-discovery
    4. Update all panels to new standard
    5. Validate with ./quick_test.sh
  </parallel_tasks>
  <constraints>
    - No dynamic UI creation
    - All panels must exist in scene
    - Maintain current visual design
    - Preserve all functionality
  </constraints>
  <output>Series of diff patches with commit messages</output>
</task>
```

## Expected Outcomes
- Single file per UI component (no delegates)
- Consistent panel behavior across UI
- 50% reduction in UI initialization code
- Clear scene structure requirements
- Faster UI response times
- Simplified debugging
