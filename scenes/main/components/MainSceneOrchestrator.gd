## MainSceneOrchestrator.gd
## Simplified main scene orchestrator that coordinates focused components
##
## This is the refactored version of node_3d.gd that delegates responsibilities
## to specialized components, reducing complexity and improving maintainability.

class_name MainSceneOrchestrator
extends Node3D

# === EXPORTS ===
@export var highlight_color: Color = Color.CYAN
@export var emission_energy: float = 0.3

# === NODE REFERENCES ===
@onready var camera: Camera3D = $CameraContainer/Camera3D
@onready var brain_model_parent: Node3D = $BrainModelParent
@onready var info_panel: Control = $UI_Layer/InfoPanel
@onready var comparative_panel: Control = $UI_Layer/ComparativeInfoPanel
@onready var object_name_label: Label = $UI_Layer/ObjectNameLabel
@onready var ui_layer: CanvasLayer = $UI_Layer

# === COMPONENTS ===
var debug_manager: DebugManager
var selection_coordinator: SelectionCoordinator
var ui_coordinator: UICoordinator
var ai_coordinator: AICoordinator

# === AUTOLOAD REFERENCES ===
var FeatureFlags = null
var UIThemeManager = null
var ModelCoordinator = null
var InputRouter = null
var CameraController = null

# === INITIALIZATION ===
func _ready() -> void:
    """Initialize the main scene with component-based architecture"""
    print("\n=== NeuroVis Main Scene Initialization (Refactored) ===")
    
    # Get autoload references
    _get_autoload_references()
    
    # Create and setup components
    _create_components()
    _setup_components()
    
    # Initialize core systems
    _initialize_core_systems()
    
    # Connect component signals
    _connect_component_signals()
    
    print("=== Initialization Complete ===\n")

func _get_autoload_references() -> void:
    """Get references to autoload singletons"""
    FeatureFlags = get_node_or_null("/root/FeatureFlags")
    UIThemeManager = get_node_or_null("/root/UIThemeManager")
    ModelCoordinator = get_node_or_null("/root/ModelCoordinator")
    InputRouter = get_node_or_null("/root/InputRouter")
    CameraController = get_node_or_null("/root/CameraController")

func _create_components() -> void:
    """Create component instances"""
    print("[Orchestrator] Creating components...")
    
    # Create debug manager
    debug_manager = DebugManager.new()
    debug_manager.name = "DebugManager"
    add_child(debug_manager)
    
    # Create selection coordinator
    selection_coordinator = SelectionCoordinator.new()
    selection_coordinator.name = "SelectionCoordinator"
    add_child(selection_coordinator)
    
    # Create UI coordinator
    ui_coordinator = UICoordinator.new()
    ui_coordinator.name = "UICoordinator"
    add_child(ui_coordinator)
    
    # Create AI coordinator
    ai_coordinator = AICoordinator.new()
    ai_coordinator.name = "AICoordinator"
    add_child(ai_coordinator)
    
    print("[Orchestrator] ✓ Components created")

func _setup_components() -> void:
    """Setup components with required dependencies"""
    print("[Orchestrator] Setting up components...")
    
    # Setup debug manager
    debug_manager.setup({
        "ai_integration": ai_coordinator.ai_integration,
        "selection_manager": selection_coordinator.selection_manager,
        "info_panel": info_panel,
        "comparative_panel": comparative_panel
    })
    
    # Setup selection coordinator
    selection_coordinator.setup({
        "camera": camera,
        "brain_model_parent": brain_model_parent,
        "info_panel": info_panel,
        "comparative_panel": comparative_panel,
        "ai_integration": ai_coordinator.ai_integration,
        "object_name_label": object_name_label
    })
    
    # Setup UI coordinator
    ui_coordinator.setup({
        "info_panel": info_panel,
        "comparative_panel": comparative_panel,
        "object_name_label": object_name_label
    })
    
    # Setup AI coordinator
    ai_coordinator.setup()
    
    print("[Orchestrator] ✓ Components configured")

func _initialize_core_systems() -> void:
    """Initialize remaining core systems"""
    print("[Orchestrator] Initializing core systems...")
    
    # Initialize camera system
    if CameraController and CameraController.has_method("initialize"):
        CameraController.initialize(camera, brain_model_parent)
        print("[Orchestrator] ✓ Camera system initialized")
    
    # Initialize model system
    if ModelCoordinator and ModelCoordinator.has_method("initialize"):
        ModelCoordinator.initialize(brain_model_parent)
        print("[Orchestrator] ✓ Model system initialized")
    
    # Initialize input system
    if InputRouter and InputRouter.has_method("initialize"):
        InputRouter.initialize()
        print("[Orchestrator] ✓ Input system initialized")

func _connect_component_signals() -> void:
    """Connect signals between components"""
    print("[Orchestrator] Connecting component signals...")
    
    # Selection signals
    selection_coordinator.structure_selected.connect(_on_structure_selected)
    selection_coordinator.structure_deselected.connect(_on_structure_deselected)
    selection_coordinator.comparison_mode_changed.connect(_on_comparison_mode_changed)
    
    # UI signals
    ui_coordinator.ui_initialized.connect(_on_ui_initialized)
    ui_coordinator.theme_changed.connect(_on_theme_changed)
    
    # AI signals
    ai_coordinator.ai_initialized.connect(_on_ai_initialized)
    ai_coordinator.ai_response_received.connect(_on_ai_response_received)
    ai_coordinator.ai_error_occurred.connect(_on_ai_error_occurred)
    
    print("[Orchestrator] ✓ Signals connected")

# === SIGNAL HANDLERS ===
func _on_structure_selected(structure_name: String) -> void:
    """Handle structure selection from selection coordinator"""
    # Update AI context
    ai_coordinator.set_current_structure(structure_name)
    
    # Update UI
    ui_coordinator.show_info_panel({"name": structure_name})

func _on_structure_deselected() -> void:
    """Handle structure deselection"""
    # Clear AI context
    ai_coordinator.reset_context()
    
    # Hide UI panels
    ui_coordinator.hide_all_panels()

func _on_comparison_mode_changed(active: bool) -> void:
    """Handle comparison mode changes"""
    if active:
        print("[Orchestrator] Comparison mode activated")
    else:
        print("[Orchestrator] Comparison mode deactivated")

func _on_ui_initialized() -> void:
    """Handle UI initialization completion"""
    print("[Orchestrator] UI fully initialized")

func _on_theme_changed(theme_mode: String) -> void:
    """Handle theme changes"""
    print("[Orchestrator] Theme changed to: %s" % theme_mode)

func _on_ai_initialized() -> void:
    """Handle AI initialization completion"""
    print("[Orchestrator] AI services ready")

func _on_ai_response_received(response: String) -> void:
    """Handle AI responses"""
    # Could show response in UI or trigger other actions
    pass

func _on_ai_error_occurred(error: String) -> void:
    """Handle AI errors"""
    ui_coordinator.show_notification("AI Error: " + error, 5.0, Color.RED)

# === PUBLIC METHODS ===
func get_component(component_name: String) -> Node:
    """Get a specific component by name"""
    match component_name:
        "debug":
            return debug_manager
        "selection":
            return selection_coordinator
        "ui":
            return ui_coordinator
        "ai":
            return ai_coordinator
        _:
            return null

func is_ready() -> bool:
    """Check if all components are initialized"""
    return (
        debug_manager != null and
        selection_coordinator != null and
        ui_coordinator != null and
        ai_coordinator != null
    )