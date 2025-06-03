## optimized_neurovis_root.gd
## Root node controller for optimized NeuroVis architecture
##
## This script coordinates all educational systems, handles scene lifecycle,
## and provides centralized service access for the brain visualization platform.
##
## @tutorial: Educational application architecture
## @version: 1.0

class_name OptimizedNeuroVisRoot
extends Node

# === SIGNALS ===
## Emitted when the educational application is fully initialized
signal application_ready

## Emitted when a brain structure is selected
signal structure_selected(structure_name: String, structure_data: Dictionary)

## Emitted when models have been loaded successfully
signal models_loaded(model_names: Array)

# === CONSTANTS ===
## Application states for educational platform
enum AppState {
    INITIALIZING,    # Systems being set up
    LOADING_MODELS,  # Loading 3D models
    RUNNING,         # Normal operation
    ERROR            # Error state
}

# === EXPORTED VARIABLES ===
## Educational theme mode (enhanced or minimal)
@export_enum("Enhanced:0", "Minimal:1") var theme_mode: int = 0

## Enable or disable educational debug features
@export var enable_debug: bool = true

# === PRIVATE VARIABLES ===
var _app_state: AppState = AppState.INITIALIZING
var _scene_manager: SceneManager
var _structure_manager: StructureManager
var _ui_pool: UIComponentPool
var _current_scene: Node

# === LIFECYCLE METHODS ===
func _ready() -> void:
    print("[NeuroVisRoot] Starting optimized NeuroVis educational platform")
    
    # Get required services
    _scene_manager = get_node_or_null("Services/SceneManager")
    _structure_manager = get_node_or_null("Services/StructureManager")
    _ui_pool = get_node_or_null("Services/UIComponentPool")
    
    # Validate essential services
    if not _validate_services():
        _set_error_state("Critical services missing")
        return
    
    # Connect scene management signals
    _scene_manager.scene_changed.connect(_on_scene_changed)
    _scene_manager.scene_load_failed.connect(_on_scene_load_failed)
    
    # Connect structure management signals
    _structure_manager.structure_selected.connect(_on_structure_selected)
    _structure_manager.related_structures_found.connect(_on_related_structures_found)
    
    # Initialize sub-systems
    _initialize_systems()
    
    # Set appropriate theme
    _apply_theme(theme_mode)
    
    print("[NeuroVisRoot] Root initialization complete")

# === PUBLIC METHODS ===
## Get the current application state
func get_app_state() -> AppState:
    """Get the current educational application state"""
    return _app_state

## Switch to a different scene
## @param scene_path: Path to the scene to load
func change_scene(scene_path: String) -> void:
    """Change to different educational scene with proper transitions"""
    if not _scene_manager:
        push_error("[NeuroVisRoot] Cannot change scene - SceneManager not available")
        return
    
    print("[NeuroVisRoot] Changing to scene: " + scene_path)
    _scene_manager.change_scene(scene_path)

## Select a brain structure for educational display
## @param structure_name: Name of the structure to select
func select_structure(structure_name: String) -> void:
    """Select a brain structure for educational focus"""
    if not _structure_manager:
        push_error("[NeuroVisRoot] Cannot select structure - StructureManager not available")
        return
    
    print("[NeuroVisRoot] Selecting structure: " + structure_name)
    _structure_manager.select_structure(structure_name)

## Switch the active theme mode
## @param mode: Theme mode to apply (0=Enhanced, 1=Minimal)
func set_theme_mode(mode: int) -> void:
    """Switch between educational theme modes"""
    _apply_theme(mode)

## Get a UI component from the pool
## @param component_type: Type of component to retrieve
## @param config: Configuration for the component
func get_ui_component(component_type: String, config: Dictionary = {}) -> Control:
    """Get an educational UI component through the pool system"""
    if not _ui_pool:
        push_error("[NeuroVisRoot] Cannot get component - UIComponentPool not available")
        return null
    
    return _ui_pool.get_component(component_type, config)

## Release a UI component back to the pool
## @param component: Component to release
func release_ui_component(component: Control) -> void:
    """Return an educational UI component to the pool"""
    if not _ui_pool or not component:
        return
    
    _ui_pool.release_component(component)

# === PRIVATE METHODS ===
## Validate required services are available
func _validate_services() -> bool:
    """Validate that all essential services are available"""
    var services_valid = true
    
    if not _scene_manager:
        push_error("[NeuroVisRoot] SceneManager service missing!")
        services_valid = false
    
    if not _structure_manager:
        push_error("[NeuroVisRoot] StructureManager service missing!")
        services_valid = false
    
    if not _ui_pool:
        push_error("[NeuroVisRoot] UIComponentPool service missing!")
        services_valid = false
    
    return services_valid

## Initialize all required systems
func _initialize_systems() -> void:
    """Initialize all educational systems in proper sequence"""
    print("[NeuroVisRoot] Initializing educational systems")
    
    # Get current scene
    _current_scene = get_node_or_null("SceneManager/MainEducationalScene")
    if not _current_scene:
        push_error("[NeuroVisRoot] Main educational scene not found")
        _set_error_state("Main scene missing")
        return
    
    # Initialize interaction system
    var interaction_system = _get_system_node("InteractionSystem")
    if interaction_system and interaction_system.has_method("initialize"):
        interaction_system.initialize()
    
    # Initialize selection system
    var selection_system = _get_system_node("SelectionSystem")
    if selection_system and selection_system.has_method("initialize"):
        selection_system.initialize()
    
    # Initialize visualization system
    var visualization_system = _get_system_node("VisualizationSystem")
    if visualization_system and visualization_system.has_method("initialize"):
        visualization_system.initialize()
    
    # Initialize educational system
    var educational_system = _get_system_node("EducationalSystem")
    if educational_system and educational_system.has_method("initialize"):
        educational_system.initialize()
    
    # Initialize model loading
    _initialize_models()
    
    # Set running state
    _app_state = AppState.RUNNING
    
    # Emit ready signal
    application_ready.emit()
    
    print("[NeuroVisRoot] All systems initialized")
    _print_instructions()

## Initialize 3D brain models
func _initialize_models() -> void:
    """Initialize educational brain models"""
    print("[NeuroVisRoot] Loading educational 3D models")
    
    # Set loading state
    _app_state = AppState.LOADING_MODELS
    
    # Find model registry
    var model_registry = get_node_or_null("/root/ModelRegistry")
    if model_registry:
        # Set brain model parent
        var brain_model_parent = _get_node_path("BrainModels/ModelSets")
        if brain_model_parent:
            model_registry.set_model_parent(brain_model_parent)
            
            # Connect signals
            if not model_registry.models_loaded.is_connected(_on_models_loaded):
                model_registry.models_loaded.connect(_on_models_loaded)
                
            if not model_registry.model_load_failed.is_connected(_on_model_load_failed):
                model_registry.model_load_failed.connect(_on_model_load_failed)
            
            # Start loading
            model_registry.load_brain_models()
        else:
            push_error("[NeuroVisRoot] BrainModels node not found")
    else:
        push_error("[NeuroVisRoot] ModelRegistry not found - cannot load models")
        # Continue anyway - set to running state
        _app_state = AppState.RUNNING

## Apply educational theme mode
func _apply_theme(mode: int) -> void:
    """Apply appropriate educational theme for learning"""
    if not UIThemeManager:
        push_warning("[NeuroVisRoot] UIThemeManager not available - cannot change theme")
        return
    
    var theme_name = "Enhanced"
    if mode == 1:
        UIThemeManager.set_theme_mode(UIThemeManager.ThemeMode.MINIMAL)
        theme_name = "Minimal"
    else:
        UIThemeManager.set_theme_mode(UIThemeManager.ThemeMode.ENHANCED)
    
    print("[NeuroVisRoot] Applied " + theme_name + " educational theme")
    
    # Update theme-dependent UI elements
    _refresh_themed_components()

## Refresh components after theme change
func _refresh_themed_components() -> void:
    """Refresh UI components after theme change"""
    # Update theme for UI elements
    var ui = _get_node_path("UIController/UI")
    if ui:
        # Update header
        var header = ui.get_node_or_null("Regions/Header")
        if header and header is Control:
            UIThemeManager.apply_glass_panel(header)
        
        # Update panels
        var left_panel = ui.get_node_or_null("Regions/SidePanel_Left")
        if left_panel and left_panel is Control:
            UIThemeManager.apply_glass_panel(left_panel)
        
        var right_panel = ui.get_node_or_null("Regions/SidePanel_Right")
        if right_panel and right_panel is Control:
            UIThemeManager.apply_glass_panel(right_panel)
        
        # Update footer
        var footer = ui.get_node_or_null("Regions/Footer")
        if footer and footer is Control:
            UIThemeManager.apply_glass_panel(footer)
        
        # Update labels
        var object_label = ui.get_node_or_null("Regions/Header/HBoxContainer/ObjectNameLabel")
        if object_label and object_label is Label:
            UIThemeManager.apply_modern_label(object_label, UIThemeManager.FONT_SIZE_MEDIUM, UIThemeManager.TEXT_PRIMARY)

## Get a system node by name
func _get_system_node(system_name: String) -> Node:
    """Get an educational system node by name"""
    return _get_node_path("MainEducationalScene/Systems/" + system_name)

## Helper to get node from path
func _get_node_path(path: String) -> Node:
    """Helper to get node with safety checks"""
    return get_node_or_null("SceneManager/" + path)

## Set error state
func _set_error_state(error: String) -> void:
    """Handle educational application errors"""
    _app_state = AppState.ERROR
    push_error("[NeuroVisRoot] Error: " + error)
    
    # Show error UI if possible
    var ui = _get_node_path("UIController/UI")
    if ui:
        # TODO: Create error notification
        pass

## Print user instructions
func _print_instructions() -> void:
    """Print educational control instructions"""
    print("\n=== NEUROVIS CONTROLS ===")
    print("• Right-click: Select brain structures")
    print("• Left-click + drag: Orbit camera")
    print("• Middle-click + drag: Pan camera") 
    print("• Mouse wheel: Zoom")
    print("• F: Focus view")
    print("• R: Reset camera")
    print("• 1/3/7: Front/Right/Top view")
    print("• Ctrl+click: Add structure to comparison")
    print("• Shift+click: Replace selection")
    print("========================\n")

# === SIGNAL HANDLERS ===
## Handle scene change event
func _on_scene_changed(scene_path: String) -> void:
    """Process educational scene changes"""
    print("[NeuroVisRoot] Scene changed to: " + scene_path)
    
    # Update current scene reference
    _current_scene = get_tree().current_scene
    
    # Update UI
    _refresh_themed_components()

## Handle scene load failure
func _on_scene_load_failed(scene_path: String, error: String) -> void:
    """Handle educational scene loading errors"""
    push_error("[NeuroVisRoot] Failed to load scene " + scene_path + ": " + error)
    _set_error_state("Scene loading failed: " + error)

## Handle structure selection
func _on_structure_selected(structure_name: String, structure_data: Dictionary) -> void:
    """Process educational structure selection"""
    print("[NeuroVisRoot] Structure selected: " + structure_name)
    
    # Update UI
    var ui = _get_node_path("UIController/UI")
    if ui:
        var label = ui.get_node_or_null("Regions/Header/HBoxContainer/ObjectNameLabel")
        if label and label is Label:
            label.text = "Selected: " + structure_name
    
    # Forward signal
    structure_selected.emit(structure_name, structure_data)

## Handle related structures found
func _on_related_structures_found(main_structure: String, related: Array) -> void:
    """Process educational structure relationships"""
    if related.is_empty():
        return
        
    print("[NeuroVisRoot] Found " + str(related.size()) + " structures related to " + main_structure)
    
    # Update UI with related structures
    # (Implementation would show relationships in info panel)

## Handle models loaded
func _on_models_loaded(model_names: Array) -> void:
    """Process educational models loaded event"""
    print("[NeuroVisRoot] Models loaded: " + str(model_names))
    
    # Update state
    _app_state = AppState.RUNNING
    
    # Setup model control panel
    var ui = _get_node_path("UIController/UI")
    if ui:
        var model_controls = ui.get_node_or_null("Regions/SidePanel_Left/ModelControlContainer")
        if model_controls and model_controls is Control:
            # Clear existing controls
            for child in model_controls.get_children():
                if child.name != "Label":  # Keep the label
                    child.queue_free()
            
            # Add model buttons
            for model_name in model_names:
                var button = Button.new()
                button.text = model_name
                button.toggle_mode = true
                button.pressed.connect(func(): _on_model_selected(model_name))
                model_controls.add_child(button)
    
    # Forward signal
    models_loaded.emit(model_names)

## Handle model load failure
func _on_model_load_failed(model_path: String, error: String) -> void:
    """Process educational model loading errors"""
    push_error("[NeuroVisRoot] Failed to load model " + model_path + ": " + error)
    
    # Continue operation but log error - models may be partially loaded

## Handle model selection
func _on_model_selected(model_name: String) -> void:
    """Process educational model selection"""
    print("[NeuroVisRoot] Model selected: " + model_name)
    
    # Toggle model visibility using global service
    if ModelSwitcherGlobal:
        ModelSwitcherGlobal.toggle_model_visibility(model_name)
    else:
        push_warning("[NeuroVisRoot] ModelSwitcherGlobal not available - cannot change model visibility")