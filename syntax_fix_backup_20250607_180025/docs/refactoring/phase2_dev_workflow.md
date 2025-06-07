# Phase 2: Development Workflow Improvements

## 2.1 Re-enable Development Tools (Half Day)

### Current State Analysis
From project.godot, these autoloads are commented out:
```
;CommandDebugCmd="*res://debug/debug_cmd.gd"
;DebugDraw3D="*res://addons/debug_draw_3d/debug_draw_3d.gd"
;GodotKnowledgeGraphPlugin="*res://addons/knowledge_graph_plugin/scripts/godot_knowledge_graph_plugin.gd"
;TestRunner="*res://tests/test_runner.gd"
;PerformanceMonitor="*res://debug/performance_monitor.gd"
;SceneValidator="*res://debug/scene_validator.gd"
;DebugOverlay="*res://debug/debug_overlay.gd"
;ConsoleCommands="*res://debug/console_commands.gd"
;ProfilerAutostart="*res://debug/profiler_autostart.gd"
```

### Implementation Plan

#### Step 1: Audit and Fix Each Tool
```bash
# AI Prompt for systematic re-enabling
claude "Role: Godot debugging specialist. Task: For each commented autoload in project.godot: 1) Uncomment the line, 2) Run ./quick_test.sh to check for errors, 3) If errors occur, fix the root cause (likely missing dependencies or initialization order), 4) Document the tool's purpose and usage. Start with DebugCmd as it's already partially functional."
```

#### Step 2: Create Development Tool Dashboard
```gdscript
# debug/dev_dashboard.gd
extends Control

var tools_status = {
    "DebugCmd": false,
    "DebugDraw3D": false,
    "TestRunner": false,
    "PerformanceMonitor": false,
    "SceneValidator": false
}

func _ready():
    _check_tool_availability()
    _create_tool_ui()

func _input(event):
    # F12 to toggle dashboard
    if event.is_action_pressed("toggle_dev_dashboard"):
        visible = !visible
```

#### AI Implementation Prompts:

```xml
<task>
  <role>Development tools specialist</role>
  <objective>Re-enable all development autoloads</objective>
  <priority_order>
    1. DebugCmd (partially working)
    2. TestRunner (needed for validation)
    3. PerformanceMonitor (measure improvements)
    4. DebugDraw3D (visual debugging)
    5. Others in dependency order
  </priority_order>
  <for_each_tool>
    - Uncomment in project.godot
    - Fix initialization errors
    - Add to dev dashboard
    - Create usage documentation
  </for_each_tool>
</task>
```

## 2.2 Standardize Code Style (1 Day)

### Automated Style Standardization Plan

#### Step 1: Create Style Configuration
```bash
# .gdscript-style.yml
style_rules:
  naming:
    classes: PascalCase
    functions: snake_case
    variables: snake_case
    constants: UPPER_SNAKE_CASE
    signals: snake_case
    enums: PascalCase
  
  formatting:
    indent: tabs
    line_length: 100
    blank_lines_between_functions: 1
    space_after_comma: true
    space_around_operators: true
  
  organization:
    order:
      - class_name
      - extends
      - signals
      - enums
      - constants
      - export_variables
      - onready_variables
      - variables
      - ready
      - init
      - public_methods
      - private_methods
```

#### Step 2: Batch Style Fix
```bash
# AI Prompt for systematic style fixes
claude -p "Role: Code style enforcer. Task: Apply Godot official style guide to all .gd files. Process in batches: 1) Core systems (core/*.gd), 2) UI components (ui/*.gd), 3) Scenes (scenes/*.gd). For each file: Apply naming conventions, fix indentation, reorganize code sections per style guide. Output: Diff patches grouped by directory."
```

#### Step 3: Create Style Checker
```gdscript
# tools/style_checker.gd
@tool
extends EditorScript

func _run():
    var files = _get_all_gd_files("res://")
    var violations = []
    
    for file_path in files:
        var issues = _check_file_style(file_path)
        if issues.size() > 0:
            violations.append({
                "file": file_path,
                "issues": issues
            })
    
    _generate_style_report(violations)
```

### AI Batch Implementation:
```xml
<task>
  <role>Code standardization specialist</role>
  <objective>Apply consistent style across entire codebase</objective>
  <execution>
    <parallel>
      - Create style configuration file
      - Build style checking tool
      - Generate initial style report
    </parallel>
    <sequential>
      - Fix core/ directory styles
      - Fix ui/ directory styles  
      - Fix scenes/ directory styles
      - Update CLAUDE.md with style guide
    </sequential>
  </execution>
  <validation>Run style checker showing zero violations</validation>
</task>
```

## 2.3 Add Comprehensive Documentation (2 Days)

### Documentation Structure

#### Step 1: API Documentation Template
```gdscript
## Handles 3D brain visualization and interaction.
##
## BrainVisualizer manages the loading, display, and interaction with 3D brain models.
## It coordinates between brain regions, neurons, and visual highlighting.
##
## @tutorial(Brain Visualization): https://github.com/project/wiki/brain-viz
class_name BrainVisualizer extends Node3D

## Emitted when a brain region is selected by the user.
## @param region The selected BrainRegion object containing anatomical data
signal region_selected(region: BrainRegion)

## Currently loaded brain model name.
## Used to track which anatomical model is active.
var current_model: String = ""

## Loads a brain model by name.
## @param model_name The identifier of the model to load (e.g., "human_adult")
## @return True if model loaded successfully, false otherwise
func load_brain_model(model_name: String) -> bool:
    pass
```

#### Step 2: Generate Documentation Site
```bash
# Create documentation generator
claude "Create tools/doc_generator.gd that: 1) Parses all GDScript files for doc comments, 2) Extracts class descriptions, method signatures, signals, 3) Generates Markdown documentation, 4) Creates searchable API reference. Output structure: docs/api/[module]/[class].md"
```

#### Step 3: Architecture Documentation
```bash
claude "Create comprehensive architecture documentation in docs/architecture/: 1) System overview with component diagram, 2) Data flow documentation, 3) Scene structure requirements, 4) Development guide, 5) Troubleshooting guide. Use Mermaid for diagrams."
```

### AI Implementation Strategy:

```xml
<task>
  <role>Technical documentation expert</role>
  <context>NeuroVis codebase documentation</context>
  <deliverables>
    1. API documentation for all public classes
    2. Architecture overview document
    3. Development setup guide
    4. Component interaction diagrams
    5. Troubleshooting guide
  </deliverables>
  <process>
    - Scan codebase for public APIs
    - Generate doc comments template
    - Create visual diagrams
    - Write usage examples
    - Build searchable docs
  </process>
</task>
```

## Implementation Timeline

### Day 1: Development Tools
- Morning: Re-enable and fix autoloads
- Afternoon: Create dev dashboard

### Day 2: Code Standardization  
- Morning: Apply style fixes to core/
- Afternoon: Apply style fixes to remaining code

### Day 3-4: Documentation
- Day 3: API documentation generation
- Day 4: Architecture and guide documentation

## Validation Checklist
- [ ] All dev tools accessible via F12 dashboard
- [ ] Zero style violations in style checker
- [ ] 100% public API documented
- [ ] Architecture diagrams complete
- [ ] Setup guide tested with fresh clone
