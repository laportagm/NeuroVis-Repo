# Main Scene Refactoring Plan

## Component Breakdown

### 1. BrainVisualizer Component
**Responsibilities:**
- 3D brain model loading and rendering
- Neuron visualization
- Brain region selection and highlighting
- Camera control coordination

**Extract from node_3d.gd:**
- `_setup_3d_components()`
- `_setup_brain_models()`
- `_handle_neuron_selected()`
- All brain region interaction logic

### 2. UIManager Component  
**Responsibilities:**
- UI panel lifecycle management
- UI state coordination
- Panel visibility and animations
- UI event routing

**Extract from node_3d.gd:**
- `_setup_ui_components()`
- `_ensure_ui_structure()`
- All UI panel references and management
- UI error handling

### 3. InteractionHandler Component
**Responsibilities:**
- Mouse/keyboard input processing
- Ray casting for 3D selection
- Hover state management
- Input mode switching

**Extract from node_3d.gd:**
- `_input()` and `_unhandled_input()`
- `_handle_mouse_movement()`
- `_process_selection()`
- Input state tracking

### 4. StateManager Component (New)
**Responsibilities:**
- Application state coordination
- Component communication hub
- State persistence
- Mode management

## Implementation Steps

### Step 1: Create Component Base Classes
```gdscript
# core/components/component_base.gd
class_name ComponentBase extends Node

signal component_ready
signal component_error(message: String)

var is_initialized: bool = false

func initialize() -> void:
    _initialize_component()
    is_initialized = true
    component_ready.emit()

func _initialize_component() -> void:
    push_error("Component must implement _initialize_component()")
```

### Step 2: Extract BrainVisualizer
1. Create `core/components/brain_visualizer.gd`
2. Move all 3D setup logic
3. Create clean API:
   - `load_brain_model(model_name: String)`
   - `highlight_region(region_id: String)`
   - `show_neurons(neuron_data: Array)`
   - `get_selected_region() -> BrainRegion`

### Step 3: Extract UIManager
1. Create `core/components/ui_manager.gd`
2. Consolidate all UI panel management
3. Implement panel registry pattern:
   ```gdscript
   var panels: Dictionary = {}
   
   func register_panel(name: String, panel: Control) -> void:
       panels[name] = panel
   ```

### Step 4: Extract InteractionHandler
1. Create `core/components/interaction_handler.gd`
2. Implement input state machine
3. Clean event emission for other components

### Step 5: Simplify Main Scene
The new `node_3d.gd` becomes:
```gdscript
extends Node3D

@onready var brain_visualizer: BrainVisualizer = $BrainVisualizer
@onready var ui_manager: UIManager = $UIManager
@onready var interaction_handler: InteractionHandler = $InteractionHandler
@onready var state_manager: StateManager = $StateManager

func _ready():
    # Simple initialization
    brain_visualizer.initialize()
    ui_manager.initialize()
    interaction_handler.initialize()
    state_manager.initialize()
    
    # Connect core signals
    interaction_handler.region_selected.connect(_on_region_selected)
    brain_visualizer.model_loaded.connect(_on_model_loaded)
```

## Validation Checklist
- [ ] All components initialize without errors
- [ ] Brain models load correctly
- [ ] UI panels appear and function
- [ ] Mouse interaction works
- [ ] No regression in functionality
- [ ] Reduced line count in main scene to <200
