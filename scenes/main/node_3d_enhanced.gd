## node_3d_enhanced.gd
## Enhanced main scene controller with core architecture integration
##
## This is an enhanced version of the main scene controller that integrates
## the new core architecture components for a more modular, extensible system.
##
## @tutorial: Core architecture integration for educational platform
## @version: 1.0

class_name NeuroVisEnhancedScene
extends Node3D

# === CORE ARCHITECTURE COMPONENTS ===
var _core_systems_bootstrap: CoreSystemsBootstrap
var _event_bus: EventBus
var _app_state: AppState
var _service_locator: ServiceLocator
var _resource_manager: ResourceManager

# === SCENE COMPONENTS ===
@onready var camera: Camera3D = $Camera3D
@onready var object_name_label: Label = $UI_Layer/ObjectNameLabel
@onready var brain_model_parent: Node3D = $BrainModel
@onready var model_control_panel: Control = $UI_Layer/ModelControlPanel

# === EXPORT VARIABLES ===
@export var highlight_color: Color = Color(0.0, 1.0, 0.0, 1.0)
@export var emission_energy: float = 0.5
@export_group("Core Architecture")
@export var initialize_core_architecture: bool = true
@export var load_models_on_ready: bool = true

# === SCENE STATE ===
var initialization_complete: bool = false
var selection_manager: Node
var info_panel: Control
var comparative_panel: Control

# === SIGNALS ===
signal structure_selected(structure_name: String)
signal structure_deselected
signal models_loaded(model_names: Array)
signal initialization_failed(reason: String)

# === INITIALIZATION ===
func _ready() -> void:
    print("[ENHANCED] Starting NeuroVis enhanced scene with core architecture...")
    
    if initialize_core_architecture:
        _initialize_core_architecture()
    else:
        push_warning("[ENHANCED] Core architecture initialization skipped (disabled in export)")
        _initialize_fallback_systems()

func _initialize_core_architecture() -> void:
    """Initialize core architecture components"""
    print("[ENHANCED] Initializing core architecture components...")
    
    # Create the core systems bootstrap
    _core_systems_bootstrap = CoreSystemsBootstrap.new()
    add_child(_core_systems_bootstrap)
    
    # Connect signals
    _core_systems_bootstrap.initialization_complete.connect(_on_systems_initialization_complete)
    _core_systems_bootstrap.initialization_failed.connect(_on_system_initialization_failed)
    
    # Start initialization process
    _core_systems_bootstrap.initialize_systems()
    
    print("[ENHANCED] Core architecture initialization started")

func _on_systems_initialization_complete(duration: float) -> void:
    """Handle completed core systems initialization"""
    print("[ENHANCED] Core systems initialized in %.2f seconds" % duration)
    
    # Get references to core systems
    _event_bus = _core_systems_bootstrap.get_system("event_bus")
    _app_state = _core_systems_bootstrap.get_system("app_state")
    _service_locator = _core_systems_bootstrap.get_system("service_locator")
    _resource_manager = _core_systems_bootstrap.get_system("resource_manager")
    selection_manager = _core_systems_bootstrap.get_system("selection_system")
    
    # Connect core systems to scene components
    _connect_core_systems()
    
    # Load models if requested
    if load_models_on_ready:
        _load_brain_models()
    
    # Complete initialization
    initialization_complete = true
    _print_instructions()
    
    # Start educational session tracking
    if _app_state:
        _app_state.start_educational_session()

func _on_system_initialization_failed(system_name: String, error: String) -> void:
    """Handle system initialization failure"""
    push_error("[ENHANCED] Failed to initialize system '%s': %s" % [system_name, error])
    
    # Fallback for critical systems
    if system_name == "event_bus" or system_name == "selection_system":
        _initialize_fallback_systems()
    
    # Notify about failure
    initialization_failed.emit("Failed to initialize %s: %s" % [system_name, error])

func _initialize_fallback_systems() -> void:
    """Initialize fallback systems when core architecture isn't available"""
    print("[ENHANCED] Initializing fallback systems...")
    
    # Create fallback selection manager
    var MultiStructureSelectionManagerScript = load("res://core/interaction/MultiStructureSelectionManager.gd")
    selection_manager = MultiStructureSelectionManagerScript.new()
    add_child(selection_manager)
    
    # Connect signals
    selection_manager.structure_selected.connect(_on_structure_selected)
    selection_manager.structure_deselected.connect(_on_structure_deselected)
    
    # Configure appearance
    selection_manager.configure_highlight_colors(highlight_color, Color(1.0, 0.7, 0.0, 0.6))
    selection_manager.set_emission_energy(emission_energy)
    selection_manager.set_outline_enabled(true)
    
    # Set up camera controller
    var CameraBehaviorControllerScript = load("res://core/interaction/CameraBehaviorController.gd")
    var camera_controller = CameraBehaviorControllerScript.new()
    add_child(camera_controller)
    camera_controller.initialize(camera, brain_model_parent)
    
    # Load models
    if load_models_on_ready:
        _load_brain_models_fallback()
    
    # Complete initialization
    initialization_complete = true
    _print_instructions()

func _connect_core_systems() -> void:
    """Connect core systems to scene components"""
    if not _event_bus or not selection_manager:
        push_error("[ENHANCED] Cannot connect core systems - key systems missing")
        return
    
    # Register for structure selection events
    _event_bus.register(EventBus.STRUCTURE_SELECTED, _on_structure_selected_event)
    _event_bus.register(EventBus.STRUCTURE_DESELECTED, _on_structure_deselected_event)
    _event_bus.register(EventBus.STRUCTURE_HOVERED, _on_structure_hovered_event)
    _event_bus.register(EventBus.MODEL_LOADED, _on_model_loaded_event)
    _event_bus.register(EventBus.MULTI_SELECTION_CHANGED, _on_multi_selection_changed_event)
    
    # Connect to UI components
    _setup_ui_connections()
    
    print("[ENHANCED] Core systems connected successfully")

func _setup_ui_connections() -> void:
    """Set up UI connections"""
    # Initialize object label
    object_name_label.text = "Selected: None"
    
    # Connect to model control panel
    if model_control_panel:
        if model_control_panel.has_signal("model_selected"):
            model_control_panel.model_selected.connect(_on_model_selected)
    
    # Register for theme change events
    if _event_bus:
        _event_bus.register(EventBus.THEME_CHANGED, _on_theme_changed)
    
    print("[ENHANCED] UI connections established")

# === MODEL LOADING ===
func _load_brain_models() -> void:
    """Load brain models using ResourceManager"""
    if not _resource_manager:
        push_warning("[ENHANCED] ResourceManager not available - using fallback")
        _load_brain_models_fallback()
        return
    
    print("[ENHANCED] Loading brain models using ResourceManager...")
    
    # Use model coordinator through service locator
    var model_coordinator = _service_locator.get_service("model_coordinator")
    if model_coordinator:
        model_coordinator.set_model_parent(brain_model_parent)
        model_coordinator.load_brain_models()
    else:
        push_warning("[ENHANCED] Model coordinator not available - using fallback")
        _load_brain_models_fallback()

func _load_brain_models_fallback() -> void:
    """Fallback model loading when ResourceManager isn't available"""
    print("[ENHANCED] Loading brain models using fallback method...")
    
    var ModelCoordinatorScript = load("res://core/models/ModelRegistry.gd")
    var model_coordinator = ModelCoordinatorScript.new()
    add_child(model_coordinator)
    
    model_coordinator.set_model_parent(brain_model_parent)
    model_coordinator.models_loaded.connect(_on_models_loaded)
    model_coordinator.load_brain_models()

# === INPUT HANDLING ===
func _input(event: InputEvent) -> void:
    if not initialization_complete:
        return
    
    # Keyboard shortcuts
    if event is InputEventKey and event.pressed:
        _handle_keyboard_input(event)
    
    # Mouse hover for structure highlighting
    if event is InputEventMouseMotion:
        if selection_manager and selection_manager.has_method("handle_hover_at_position"):
            selection_manager.handle_hover_at_position(event.position)
    
    # Right-click for structure selection
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
        if selection_manager and selection_manager.has_method("handle_selection_at_position"):
            selection_manager.handle_selection_at_position(event.position)
            get_viewport().set_input_as_handled()

func _handle_keyboard_input(event: InputEventKey) -> void:
    """Handle keyboard input"""
    var camera_controller = _service_locator.get_service("camera_controller") if _service_locator else null
    
    match event.keycode:
        KEY_F:
            if camera_controller and camera_controller.has_method("focus_on_bounds"):
                camera_controller.focus_on_bounds(Vector3.ZERO, 2.0)
                get_viewport().set_input_as_handled()
        KEY_1, KEY_KP_1:
            if camera_controller and camera_controller.has_method("set_view_preset"):
                camera_controller.set_view_preset("front")
                get_viewport().set_input_as_handled()
        KEY_3, KEY_KP_3:
            if camera_controller and camera_controller.has_method("set_view_preset"):
                camera_controller.set_view_preset("right")
                get_viewport().set_input_as_handled()
        KEY_7, KEY_KP_7:
            if camera_controller and camera_controller.has_method("set_view_preset"):
                camera_controller.set_view_preset("top")
                get_viewport().set_input_as_handled()
        KEY_R:
            if camera_controller and camera_controller.has_method("reset_view"):
                camera_controller.reset_view()
                get_viewport().set_input_as_handled()

# === EVENT HANDLERS ===
func _on_structure_selected_event(_event_name: String, event_data) -> void:
    """Handle structure selected event from EventBus"""
    var structure_name = event_data.get("structure_name", "")
    if structure_name.is_empty():
        return
    
    # Update label
    object_name_label.text = "Selected: " + structure_name
    
    # Display structure information
    _display_structure_info(structure_name)
    
    # Record in AppState for analytics
    if _app_state and _app_state.has_method("record_structure_view"):
        _app_state.record_structure_view(structure_name)
    
    # Emit own signal for backward compatibility
    structure_selected.emit(structure_name)
    
    print("[ENHANCED] Selected: " + structure_name)

func _on_structure_deselected_event(_event_name: String, _event_data) -> void:
    """Handle structure deselected event from EventBus"""
    object_name_label.text = "Selected: None"
    
    if info_panel:
        info_panel.visible = false
    
    structure_deselected.emit()

func _on_structure_hovered_event(_event_name: String, event_data) -> void:
    """Handle structure hovered event from EventBus"""
    var structure_name = event_data.get("structure_name", "")
    if structure_name.is_empty():
        return
    
    # Show hover feedback only if nothing is selected
    if selection_manager.get_selected_structure_name().is_empty():
        object_name_label.text = "Hover: " + structure_name

func _on_model_loaded_event(_event_name: String, event_data) -> void:
    """Handle model loaded event from EventBus"""
    var model_names = event_data.get("model_names", [])
    
    print("[ENHANCED] Models loaded: " + str(model_names))
    models_loaded.emit(model_names)
    
    # Setup model control panel
    if model_control_panel and model_control_panel.has_method("setup_with_models"):
        model_control_panel.setup_with_models(model_names)

func _on_multi_selection_changed_event(_event_name: String, event_data) -> void:
    """Handle multi-selection changed event from EventBus"""
    var selections = event_data.get("selections", [])
    
    # Update UI based on number of selections
    if selections.size() == 0:
        # No selection - hide panels
        if info_panel:
            info_panel.hide()
        if comparative_panel:
            comparative_panel.hide()
        object_name_label.text = "Selected: None"
    elif selections.size() == 1:
        # Single selection - show traditional info panel
        if comparative_panel:
            comparative_panel.hide()
        var selection = selections[0]
        _display_structure_info(selection.get("name", ""))
        object_name_label.text = "Selected: " + selection.get("name", "")
    else:
        # Multiple selections - show comparative panel
        if info_panel:
            info_panel.hide()
        _show_comparative_panel(selections)
        
        # Update label to show multiple selections
        var names = []
        for sel in selections:
            names.append(sel.get("name", ""))
        object_name_label.text = "Comparing: " + ", ".join(names)
    
    print("[ENHANCED] Selection changed: %d structures" % selections.size())

func _on_theme_changed(_event_name: String, event_data) -> void:
    """Handle theme changed event from EventBus"""
    var theme_mode = event_data.get("mode", "")
    print("[ENHANCED] Theme changed to: " + theme_mode)
    
    # Refresh info panel with new theme
    if info_panel and info_panel.visible:
        # Get current structure name
        var structure_name = ""
        if _app_state:
            structure_name = _app_state.get_state("current_structure", "")
        
        if not structure_name.is_empty():
            # Let the old panel finish freeing before creating new one
            call_deferred("_display_structure_info", structure_name)

# === LEGACY SIGNAL HANDLERS ===
func _on_structure_selected(structure_name: String, _mesh: MeshInstance3D) -> void:
    """Legacy handler for structure selected signal"""
    if _event_bus:
        # Translate to event
        _event_bus.emit(EventBus.STRUCTURE_SELECTED, {
            "structure_name": structure_name,
            "mesh": _mesh
        })
    else:
        # Direct handling
        _on_structure_selected_event(EventBus.STRUCTURE_SELECTED, {
            "structure_name": structure_name
        })

func _on_structure_deselected() -> void:
    """Legacy handler for structure deselected signal"""
    if _event_bus:
        # Translate to event
        _event_bus.emit(EventBus.STRUCTURE_DESELECTED, {})
    else:
        # Direct handling
        _on_structure_deselected_event(EventBus.STRUCTURE_DESELECTED, {})

func _on_models_loaded(model_names: Array) -> void:
    """Legacy handler for models loaded signal"""
    if _event_bus:
        # Translate to event
        _event_bus.emit(EventBus.MODEL_LOADED, {
            "model_names": model_names
        })
    else:
        # Direct handling
        _on_model_loaded_event(EventBus.MODEL_LOADED, {
            "model_names": model_names
        })

func _on_model_selected(model_name: String) -> void:
    """Handle model selected from control panel"""
    if Engine.has_singleton("ModelSwitcherGlobal"):
        Engine.get_singleton("ModelSwitcherGlobal").toggle_model_visibility(model_name)

# === UI METHODS ===
func _display_structure_info(structure_name: String) -> void:
    """Display structure information"""
    # Get structure data
    var structure_data = _get_structure_data(structure_name)
    if structure_data.is_empty():
        print("[ENHANCED] Structure data not found: " + structure_name)
        return
    
    # Store current structure in AppState
    if _app_state:
        _app_state.set_state("current_structure", structure_name)
    
    # Get UI layer
    var ui_layer = get_node_or_null("UI_Layer")
    if not ui_layer or not ui_layer is CanvasLayer:
        push_error("[ENHANCED] UI_Layer not found or wrong type!")
        return
    
    # Remove existing panel
    if info_panel:
        info_panel.queue_free()
        info_panel = null
    
    # Create info panel using InfoPanelFactory
    var InfoPanelFactoryScript = load("res://ui/panels/InfoPanelFactory.gd")
    info_panel = InfoPanelFactoryScript.create_info_panel()
    if not info_panel:
        push_error("[ENHANCED] Failed to create info panel")
        return
    
    info_panel.name = "StructureInfoPanel"
    
    # Add to UI layer
    ui_layer.add_child(info_panel)
    
    # Load structure data into the panel
    if info_panel.has_method("display_structure_info"):
        info_panel.display_structure_info(structure_data)
    else:
        push_warning("[ENHANCED] Info panel lacks display_structure_info method")
    
    # Connect panel signals
    if info_panel.has_signal("panel_closed"):
        info_panel.panel_closed.connect(_on_info_panel_closed)
    
    # Show panel
    info_panel.visible = true
    
    print("[ENHANCED] Info panel displayed for: " + structure_name)

func _get_structure_data(structure_name: String) -> Dictionary:
    """Get structure data from KnowledgeService or KB"""
    # Try KnowledgeService first
    if Engine.has_singleton("KnowledgeService"):
        var service = Engine.get_singleton("KnowledgeService")
        if service.is_initialized():
            var data = service.get_structure(structure_name)
            if not data.is_empty():
                return data
            
            # Try fuzzy search
            var search_results = service.search_structures(structure_name)
            if not search_results.is_empty():
                return search_results[0]
    
    # Fallback to KB
    if Engine.has_singleton("KB"):
        var kb = Engine.get_singleton("KB")
        if kb.is_loaded:
            var structure_id = _find_structure_id(structure_name)
            if not structure_id.is_empty():
                return kb.get_structure(structure_id)
    
    # Check if we have a knowledge service in the service locator
    if _service_locator:
        var knowledge_service = _service_locator.get_service("knowledge_service")
        if knowledge_service and knowledge_service.has_method("get_structure"):
            var data = knowledge_service.get_structure(structure_name)
            if not data.is_empty():
                return data
    
    return {}

func _find_structure_id(mesh_name: String) -> String:
    """Find structure ID by mesh name in legacy KB"""
    if not Engine.has_singleton("KB"):
        return ""
    
    var kb = Engine.get_singleton("KB")
    if not kb.is_loaded:
        return ""
    
    var lower_name = mesh_name.to_lower()
    var structure_ids = kb.get_all_structure_ids()
    
    # Try exact match first
    for id in structure_ids:
        var structure = kb.get_structure(id)
        if typeof(structure) == TYPE_DICTIONARY and structure.has("displayName"):
            if structure.displayName.to_lower() == lower_name:
                return id
    
    # Try partial match
    for id in structure_ids:
        var structure = kb.get_structure(id)
        if typeof(structure) == TYPE_DICTIONARY and structure.has("displayName"):
            var display_name = structure.displayName.to_lower()
            if lower_name.contains(display_name) or display_name.contains(lower_name):
                return id
    
    return ""

func _on_info_panel_closed() -> void:
    """Handle info panel closed"""
    if info_panel:
        info_panel.queue_free()
        info_panel = null

func _show_comparative_panel(selections: Array) -> void:
    """Show the comparative information panel"""
    var ui_layer = get_node_or_null("UI_Layer")
    if not ui_layer:
        push_error("[ENHANCED] UI_Layer not found!")
        return
    
    # Create comparative panel if it doesn't exist
    if not comparative_panel:
        var ComparativeInfoPanelScript = load("res://ui/panels/ComparativeInfoPanel.gd")
        comparative_panel = ComparativeInfoPanelScript.new()
        comparative_panel.name = "ComparativeInfoPanel"
        
        # Position on the right side
        comparative_panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER_RIGHT)
        comparative_panel.position.x = -420
        comparative_panel.custom_minimum_size = Vector2(400, 600)
        
        ui_layer.add_child(comparative_panel)
        
        # Connect signals
        if comparative_panel.has_signal("structure_focused"):
            comparative_panel.structure_focused.connect(_on_comparative_structure_focused)
        
        if comparative_panel.has_signal("comparison_cleared"):
            comparative_panel.comparison_cleared.connect(func(): 
                if selection_manager and selection_manager.has_method("clear_all_selections"):
                    selection_manager.clear_all_selections()
            )
    
    # Update panel with selections
    if comparative_panel.has_method("update_selections"):
        comparative_panel.update_selections(selections)
    
    comparative_panel.show()

func _on_comparative_structure_focused(structure_name: String) -> void:
    """Handle focus request from comparative panel"""
    var camera_controller = _service_locator.get_service("camera_controller") if _service_locator else null
    if not camera_controller:
        return
    
    # Find the mesh for this structure
    var meshes = _get_all_brain_meshes()
    for mesh in meshes:
        if mesh.name == structure_name:
            # Focus camera on this structure
            if camera_controller.has_method("focus_on_mesh"):
                camera_controller.focus_on_mesh(mesh)
            break

func _get_all_brain_meshes() -> Array:
    """Get all brain mesh instances from the brain model parent"""
    var meshes: Array = []
    if brain_model_parent:
        _collect_meshes_recursive(brain_model_parent, meshes)
    return meshes

func _collect_meshes_recursive(node: Node, meshes: Array) -> void:
    """Recursively collect all MeshInstance3D nodes"""
    if node is MeshInstance3D:
        meshes.append(node)
    for child in node.get_children():
        _collect_meshes_recursive(child, meshes)

func _print_instructions() -> void:
    """Print usage instructions"""
    print("\n=== NEUROVIS ENHANCED CONTROLS ===")
    print("• Right-click: Select brain structures")
    print("• Left-click + drag: Orbit camera")
    print("• Middle-click + drag: Pan camera") 
    print("• Mouse wheel: Zoom")
    print("• F: Focus view")
    print("• R: Reset camera")
    print("• 1/3/7: Front/Right/Top view")
    print("================================\n")