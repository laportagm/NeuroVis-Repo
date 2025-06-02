# Simplified Main Scene - Clean and Modern Implementation
class_name NeuroVisMainScene
extends Node3D

# Essential preloads - use regular load to avoid parser issues
var MultiStructureSelectionManagerScript = load("res://core/interaction/MultiStructureSelectionManager.gd")
var CameraBehaviorControllerScript = load("res://core/interaction/CameraBehaviorController.gd")
var ModelCoordinatorScene = load("res://core/models/ModelRegistry.gd")
var ComparativeInfoPanelScript = load("res://ui/panels/ComparativeInfoPanel.gd")
# UIThemeManager is now available as autoload

# === NEW FOUNDATION LAYER ===
var FeatureFlags = load("res://core/features/FeatureFlags.gd")
var ComponentRegistry = load("res://ui/core/ComponentRegistry.gd")
var ComponentStateManager = load("res://ui/state/ComponentStateManager.gd")

# UI Component System preloads - PROGRESSIVE ENABLEMENT
var SafeAutoloadAccess = load("res://ui/components/core/SafeAutoloadAccess.gd")
var BaseUIComponent = load("res://ui/components/core/BaseUIComponent.gd")
var UIComponentFactory = load("res://ui/components/core/UIComponentFactory.gd")
var ResponsiveComponent = load("res://ui/components/core/ResponsiveComponent_Safe.gd")

# Legacy support (will be migrated)
var InfoPanelFactory = load("res://ui/panels/InfoPanelFactory.gd")

# QA Testing integration
var SelectionTestRunner = load("res://tests/qa/SelectionTestRunner.gd")

# Constants
const RAY_LENGTH: float = 1000.0
const DEBUG_MODE: bool = true

# Export variables for customizing highlight appearance
@export var highlight_color: Color = Color(0.0, 1.0, 0.0, 1.0)
@export var emission_energy: float = 0.5

# Core node references
@onready var camera: Camera3D = $Camera3D
@onready var object_name_label: Label = $UI_Layer/ObjectNameLabel
@onready var info_panel: Control = $UI_Layer/StructureInfoPanel
@onready var brain_model_parent: Node3D = $BrainModel
@onready var model_control_panel: Control = $UI_Layer/ModelControlPanel

# New UI components (temporarily disabled for progressive enablement)
# var ai_assistant_panel: AIAssistantPanel
var ai_assistant_panel: Control  # Temporary generic type
var comparative_panel: Control  # Comparative info panel for multi-selection

# Components
var selection_manager: Node
var camera_controller: Node
var model_coordinator: Node
var selection_test_runner: Node  # SelectionTestRunner type loaded dynamically

# System state
var initialization_complete: bool = false
var last_selected_structure: String = ""
var _gemini_setup_shown: bool = false

# Signals
signal structure_selected(structure_name: String)
signal structure_deselected
signal models_loaded(model_names: Array)
signal initialization_failed(reason: String)

func _ready() -> void:
    print("[INIT] Starting NeuroVis main scene...")
    
    # Initialize foundation layer first
    _initialize_foundation_layer()
    
    # Initialize safety framework
    _initialize_ui_safety()
    
    # Initialize UI component system safely
    _initialize_ui_components()
    
    initialize_core_systems()
    
    # Register foundation debug commands
    _register_foundation_debug_commands()
    
    # Initialize QA testing system
    _initialize_qa_testing()
    
    print("[INIT] NeuroVis ready!")

func _initialize_ui_safety() -> void:
    """Initialize UI safety framework"""
    print("[INIT] Initializing UI safety framework...")
    
    # Log autoload status for debugging
    if SafeAutoloadAccess.has_method("log_autoload_status"):
        SafeAutoloadAccess.call("log_autoload_status")
    
    # Test safety framework
    var framework_working = true
    
    # Test structure retrieval
    var test_structure = {}
    if SafeAutoloadAccess.has_method("get_structure_safely"):
        test_structure = SafeAutoloadAccess.call("get_structure_safely", "Test")
    if not test_structure.has("id"):
        framework_working = false
        
    # Test component creation
    var test_button = null
    if UIComponentFactory.has_method("create_button"):
        test_button = UIComponentFactory.call("create_button", "Test", "primary")
    if test_button:
        test_button.queue_free()
    else:
        framework_working = false
    
    if framework_working:
        print("[INIT] ✓ UI safety framework operational")
    else:
        print("[INIT] ⚠ UI safety framework has issues - proceeding with caution")

func _initialize_foundation_layer() -> void:
    """Initialize the new foundation layer systems"""
    print("[INIT] Initializing foundation layer...")
    
    # Load feature flags configuration
    var flags_loaded = true
    if FeatureFlags.has_method("is_enabled"):
        if not FeatureFlags.call("is_enabled", "__test_flag__"):  # This triggers initialization
            flags_loaded = true
    
    if flags_loaded:
        print("[INIT] ✓ FeatureFlags initialized")
        # Log current configuration
        if FeatureFlags.has_method("is_enabled") and FeatureFlags.has_method("print_flag_status"):
            if FeatureFlags.get("DEBUG_COMPONENT_INSPECTOR") != null:
                if FeatureFlags.call("is_enabled", FeatureFlags.get("DEBUG_COMPONENT_INSPECTOR")):
                    FeatureFlags.call("print_flag_status")
    else:
        print("[INIT] ⚠ FeatureFlags initialization failed")
    
    # Initialize component registry
    var test_component = ComponentRegistry.create_component("button", {"text": "Test"})
    if test_component:
        print("[INIT] ✓ ComponentRegistry initialized")
        test_component.queue_free()
        
        # Show registry stats in debug mode
        if FeatureFlags.is_enabled(FeatureFlags.DEBUG_COMPONENT_INSPECTOR):
            ComponentRegistry.print_registry_stats()
    else:
        print("[INIT] ⚠ ComponentRegistry initialization failed")
    
    # Initialize state manager
    if FeatureFlags.is_enabled(FeatureFlags.UI_STATE_PERSISTENCE):
        ComponentStateManager.save_component_state("test", {"test": true})
        var restored = ComponentStateManager.restore_component_state("test")
        if not restored.is_empty():
            print("[INIT] ✓ ComponentStateManager initialized")
            ComponentStateManager.remove_component_state("test")
        else:
            print("[INIT] ⚠ ComponentStateManager not working")
    else:
        print("[INIT] - ComponentStateManager disabled (feature flag off)")

func _initialize_ui_components() -> void:
    """Initialize UI components safely"""
    print("[INIT] Initializing UI components...")
    
    # Check if we should use new component system
    if FeatureFlags.is_enabled(FeatureFlags.UI_MODULAR_COMPONENTS):
        print("[INIT] ✓ Using new modular component system")
    else:
        print("[INIT] - Using legacy component system")
    
    # Initialize AccessibilityManager safely (temporarily disabled)
    # if AccessibilityManager and AccessibilityManager.has_method("initialize"):
    #     AccessibilityManager.initialize()
    #     print("[INIT] ✓ AccessibilityManager initialized")
    # else:
    print("[INIT] - AccessibilityManager temporarily disabled for progressive enablement")

func _initialize_qa_testing() -> void:
    """Initialize QA testing system for selection reliability"""
    print("[INIT] Initializing QA testing system...")
    
    selection_test_runner = SelectionTestRunner.new()
    add_child(selection_test_runner)
    
    # Initialize with main scene reference
    selection_test_runner.initialize(self)
    
    print("[INIT] ✓ QA testing system ready - Use F1 console commands:"
        + "\n  - qa_test [full|quick|structure] - Run selection tests"
        + "\n  - qa_status - Check test progress"
        + "\n  - qa_analyze - Analyze selection system")

func initialize_core_systems() -> void:
    """Initialize core systems in proper order"""
    # Validate essential nodes exist
    if not _validate_essential_nodes():
        var error_msg = "[CRITICAL] Essential UI nodes missing - cannot initialize"
        push_error(error_msg)
        initialization_failed.emit(error_msg)
        return
    
    # Initialize core components
    _setup_selection_manager()
    _setup_camera_controller()
    _setup_model_coordinator()
    
    # Setup enhanced UI
    #_setup_enhanced_ui()
    
    # Setup UI and connections
    _setup_ui_connections()
    
    # Load models
    if model_coordinator:
        model_coordinator.load_brain_models()
    
    # Apply modern styling
    _apply_modern_theme()
    
    initialization_complete = true
    _print_instructions()
    
    # Check if Gemini needs setup (deferred to avoid initialization conflicts)
    call_deferred("_check_gemini_setup")

func _validate_essential_nodes() -> bool:
    """Validate that essential nodes exist"""
    var valid = true
    
    if not camera:
        push_error("Camera3D not found!")
        valid = false
    
    if not object_name_label:
        push_error("ObjectNameLabel not found!")
        valid = false
    
    if not info_panel:
        push_error("StructureInfoPanel not found!")
        valid = false
    
    if not brain_model_parent:
        push_error("BrainModel parent not found!")
        valid = false
    
    return valid

func _setup_selection_manager() -> void:
    """Setup multi-structure selection manager"""
    selection_manager = MultiStructureSelectionManagerScript.new()
    add_child(selection_manager)
    
    # Connect signals for single selection (backwards compatibility)
    selection_manager.structure_selected.connect(_on_structure_selected)
    selection_manager.structure_deselected.connect(_on_structure_deselected)
    selection_manager.structure_hovered.connect(_on_structure_hovered)
    selection_manager.structure_unhovered.connect(_on_structure_unhovered)
    
    # Connect multi-selection signals
    selection_manager.multi_selection_changed.connect(_on_multi_selection_changed)
    selection_manager.comparison_mode_entered.connect(_on_comparison_mode_entered)
    selection_manager.comparison_mode_exited.connect(_on_comparison_mode_exited)
    selection_manager.selection_limit_reached.connect(_on_selection_limit_reached)
    
    # Configure appearance
    selection_manager.configure_highlight_colors(highlight_color, Color(1.0, 0.7, 0.0, 0.6))
    selection_manager.set_emission_energy(emission_energy)
    selection_manager.set_outline_enabled(true)
    
    print("[INIT] Selection manager ready")

func _setup_camera_controller() -> void:
    """Setup camera controller"""
    camera_controller = CameraBehaviorControllerScript.new()
    add_child(camera_controller)
    camera_controller.initialize(camera, brain_model_parent)
    
    print("[INIT] Camera controller ready")

func _setup_model_coordinator() -> void:
    """Setup model coordinator"""
    model_coordinator = ModelCoordinatorScene.new()
    add_child(model_coordinator)
    model_coordinator.set_model_parent(brain_model_parent)
    
    # Connect signals
    model_coordinator.models_loaded.connect(_on_models_loaded)
    model_coordinator.model_load_failed.connect(_on_model_load_failed)
    
    print("[INIT] Model coordinator ready")

func _setup_enhanced_ui() -> void:
    """Setup enhanced UI layer with new component system"""
    # Get the UI layer
    var ui_layer = get_node_or_null("UI_Layer")
    if not ui_layer or not ui_layer is CanvasLayer:
        push_error("[ENHANCED_UI] UI_Layer not found or wrong type!")
        return
    
    print("[ENHANCED_UI] Setting up new UI component system")
    
    # Remove any existing info panel placeholder
    var existing_panel = ui_layer.get_node_or_null("StructureInfoPanel")
    if existing_panel:
        existing_panel.queue_free()
        info_panel = null
        print("[ENHANCED_UI] Removed existing panel")
    
    # Register UI layer components for accessibility
    #AccessibilityManager.register_component(ui_layer)
    
    # Setup responsive design detection
    var viewport_size = get_viewport().get_visible_rect().size
    print("[ENHANCED_UI] Viewport size: " + str(viewport_size))
    
    # Add theme toggle button with new component system
    #var theme_toggle = UIComponentFactory.create_button("🎨", "icon", {
        #"custom_minimum_size": Vector2(32, 32),
        #"tooltip_text": "Toggle Theme"
    #})
    #theme_toggle.position = Vector2(10, 50)
    #theme_toggle.pressed.connect(_on_theme_toggle_pressed)
    
    # Add AI Assistant toggle button
    #var ai_toggle = UIComponentFactory.create_button("🤖", "icon", {
        #"custom_minimum_size": Vector2(32, 32),
        #"tooltip_text": "AI Assistant"
    #})
    #ai_toggle.position = Vector2(10, 90)
    #ai_toggle.pressed.connect(_on_ai_toggle_pressed)
    
    # Register tooltips
    #InteractiveTooltip.register_tooltip_for_control(theme_toggle, {
        #"type": "simple",
        #"text": "Switch between Enhanced and Minimal themes"
    #})
    
    #InteractiveTooltip.register_tooltip_for_control(ai_toggle, {
        #"type": "simple", 
        #"text": "Open AI Assistant for brain anatomy questions"
    #})
    
    #ui_layer.add_child(theme_toggle)
    #ui_layer.add_child(ai_toggle)
    
    print("[ENHANCED_UI] New UI component system setup complete")

func _setup_ui_connections() -> void:
    """Setup UI connections and styling"""
    # Setup object label
    object_name_label.text = "Selected: None"
    
    # Setup model control panel
    if model_control_panel:
        if ModelSwitcherGlobal and ModelSwitcherGlobal.has_signal("model_visibility_changed"):
            ModelSwitcherGlobal.model_visibility_changed.connect(_on_model_visibility_changed)
        
        if model_control_panel.has_signal("model_selected"):
            model_control_panel.model_selected.connect(_on_model_selected)
    
    print("[INIT] UI connections complete")

func _connect_modular_panel_signals() -> void:
    """Connect signals for the new modular info panel"""
    if not info_panel:
        return
    
    # Connect modular panel signals
    if info_panel.has_signal("panel_closed"):
        info_panel.panel_closed.connect(_on_info_panel_closed)
    
    if info_panel.has_signal("content_changed"):
        info_panel.content_changed.connect(_on_panel_content_changed)
    
    if info_panel.has_signal("section_toggled"):
        info_panel.section_toggled.connect(_on_section_toggled)
    
    if info_panel.has_signal("action_triggered"):
        info_panel.action_triggered.connect(_on_panel_action_triggered)
    
    print("[INFO] Modular panel signals connected")

# Legacy panel connection method (for backward compatibility)
func _connect_legacy_panel_signals() -> void:
    """Connect signals for legacy info panels"""
    _connect_modular_panel_signals()

func _apply_modern_theme() -> void:
    """Apply modern glass morphism theme using UIThemeManager"""
    var theme_manager = load("res://ui/panels/UIThemeManager.gd")
    
    # Apply glass styling to object label
    if object_name_label:
        theme_manager.apply_modern_label(object_name_label, theme_manager.FONT_SIZE_MEDIUM, theme_manager.TEXT_PRIMARY)
    
    # Note: Info panel styling is handled when it's created
    
    # Apply styling to model control panel
    if model_control_panel:
        theme_manager.apply_glass_panel(model_control_panel)
    
    print("[INIT] Modern theme applied")

# Input handling
func _input(event: InputEvent) -> void:
    if not initialization_complete:
        return
    
    # Keyboard shortcuts
    if event is InputEventKey and event.pressed:
        match event.keycode:
            KEY_F:
                camera_controller.focus_on_bounds(Vector3.ZERO, 2.0)
                get_viewport().set_input_as_handled()
            KEY_1, KEY_KP_1:
                camera_controller.set_view_preset("front")
                get_viewport().set_input_as_handled()
            KEY_3, KEY_KP_3:
                camera_controller.set_view_preset("right")
                get_viewport().set_input_as_handled()
            KEY_7, KEY_KP_7:
                camera_controller.set_view_preset("top")
                get_viewport().set_input_as_handled()
            KEY_R:
                camera_controller.reset_view()
                get_viewport().set_input_as_handled()
    
    # Mouse hover for structure highlighting
    if event is InputEventMouseMotion:
        selection_manager.handle_hover_at_position(event.position)
    
    # Right-click for structure selection with multi-selection support
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
        # MultiStructureSelectionManager will check modifiers internally
        selection_manager.handle_selection_at_position(event.position)
        get_viewport().set_input_as_handled()

# Signal handlers
func _on_structure_selected(structure_name: String, _mesh: MeshInstance3D) -> void:
    # Update label with modern animation
    load("res://ui/panels/UIThemeManager.gd").animate_fade_text_change(object_name_label, "Selected: " + structure_name)
    
    # Display structure information
    _display_structure_info(structure_name)
    
    # Update AI Assistant context safely
    if ai_assistant_panel and ai_assistant_panel.visible:
        if ai_assistant_panel.has_method("set_current_structure"):
            ai_assistant_panel.set_current_structure(structure_name)
    
    # Update AI service context
    if AIAssistant:
        AIAssistant.set_current_structure(structure_name)
    
    emit_signal("structure_selected", structure_name)
    print("Selected: " + structure_name)

func _on_structure_deselected() -> void:
    object_name_label.text = "Selected: None"
    if info_panel:
        info_panel.visible = false
    emit_signal("structure_deselected")

func _on_structure_hovered(structure_name: String, _mesh: MeshInstance3D) -> void:
    # Show hover feedback only if nothing is selected
    if selection_manager.get_selected_structure_name().is_empty():
        object_name_label.text = "Hover: " + structure_name

func _on_structure_unhovered() -> void:
    # Clear hover feedback only if nothing is selected
    if selection_manager.get_selected_structure_name().is_empty():
        object_name_label.text = "Selected: None"

func _on_info_panel_closed() -> void:
    if info_panel:
        info_panel.queue_free()
        info_panel = null

func _on_models_loaded(model_names: Array) -> void:
    print("Models loaded: " + str(model_names))
    emit_signal("models_loaded", model_names)
    
    # Setup model control panel
    if model_control_panel and model_control_panel.has_method("setup_with_models"):
        model_control_panel.setup_with_models(model_names)

func _on_model_load_failed(model_path: String, error: String) -> void:
    print("Failed to load model " + model_path + ": " + error)

func _on_model_selected(model_name: String) -> void:
    if ModelSwitcherGlobal:
        ModelSwitcherGlobal.toggle_model_visibility(model_name)

func _on_model_visibility_changed(model_name: String, visible_state: bool) -> void:
    if model_control_panel and model_control_panel.has_method("update_button_state"):
        model_control_panel.update_button_state(model_name, visible_state)

# Structure information display with new component system
func _display_structure_info(structure_name: String) -> void:
    # Check if new KnowledgeService is available, fallback to legacy KB
    var using_knowledge_service = false
    var structure_data: Dictionary = {}
    
    if KnowledgeService and KnowledgeService.is_initialized():
        # Use new KnowledgeService
        using_knowledge_service = true
        structure_data = KnowledgeService.get_structure(structure_name)
        
        if typeof(structure_data) != TYPE_DICTIONARY or structure_data.is_empty():
            # Try fuzzy search if exact match fails
            var search_results = KnowledgeService.search_structures(structure_name)
            if not search_results.is_empty():
                structure_data = search_results[0]  # Use best match
        
        if typeof(structure_data) != TYPE_DICTIONARY or structure_data.is_empty():
            print("Structure not found via KnowledgeService: " + structure_name)
            return
            
    elif KB and KB.is_loaded:
        # Fallback to legacy knowledge base
        var structure_id = _find_structure_id(structure_name)
        if structure_id.is_empty():
            print("Structure not found in legacy knowledge base: " + structure_name)
            return
        
        structure_data = KB.get_structure(structure_id)
        if typeof(structure_data) != TYPE_DICTIONARY or structure_data.is_empty():
            print("No data found for structure: " + structure_id)
            return
    else:
        print("No knowledge base available")
        return
    
    # Store last selected structure
    last_selected_structure = structure_name
    
    print("[INFO] Using %s for data retrieval" % ("KnowledgeService" if using_knowledge_service else "Legacy KB"))
    
    # === NEW COMPONENT SYSTEM INTEGRATION ===
    if FeatureFlags.is_enabled(FeatureFlags.UI_MODULAR_COMPONENTS):
        _display_with_new_component_system(structure_name, structure_data)
    else:
        _display_with_legacy_system(structure_name, structure_data)

func _display_with_new_component_system(structure_name: String, structure_data: Dictionary) -> void:
    """Display structure info using new component registry system"""
    print("[NEW_UI] Using new component system for: " + structure_name)
    
    # Get UI layer
    var ui_layer = get_node_or_null("UI_Layer")
    if not ui_layer or not ui_layer is CanvasLayer:
        push_error("[ERROR] UI_Layer not found or wrong type!")
        return
    
    # Create component ID for caching/state persistence
    var component_id = "info_panel_" + structure_name.to_lower().replace(" ", "_")
    
    # Component configuration
    var config = {
        "structure_name": structure_name,
        "structure_data": structure_data,
        "theme": UIThemeManager.current_mode if UIThemeManager else "enhanced",
        "position": "right",
        "closeable": true
    }
    
    # Save current component state if persistence is enabled
    if FeatureFlags.is_enabled(FeatureFlags.UI_STATE_PERSISTENCE) and info_panel:
        _save_panel_state(component_id, info_panel)
    
    # Remove existing panel
    if info_panel:
        # Release from registry instead of destroying
        if FeatureFlags.is_enabled(FeatureFlags.UI_COMPONENT_POOLING):
            var old_id = info_panel.get_meta("component_id", "")
            if old_id != "":
                ComponentRegistry.release_component(old_id)
        info_panel.queue_free()
        info_panel = null
    
    # Create new component through registry
    info_panel = ComponentRegistry.get_or_create(component_id, "info_panel", config)
    
    if not info_panel:
        push_error("[NEW_UI] Failed to create info panel through ComponentRegistry")
        _display_with_legacy_system(structure_name, structure_data)  # Fallback
        return
    
    info_panel.name = "StructureInfoPanel"
    
    # Restore component state if available
    if FeatureFlags.is_enabled(FeatureFlags.UI_STATE_PERSISTENCE):
        _restore_panel_state(component_id, info_panel)
    
    # Add to UI layer
    ui_layer.add_child(info_panel)
    
    # Configure panel with structure data
    if info_panel.has_method("display_structure_info"):
        info_panel.display_structure_info(structure_data)
    elif info_panel.has_method("configure"):
        info_panel.configure(config)
    else:
        # Fallback configuration
        if info_panel.has_method("set_text"):
            var display_text = structure_data.get("displayName", structure_name) + "\n" + structure_data.get("shortDescription", "No description available")
            info_panel.set_text(display_text)
    
    # Connect signals
    _connect_panel_signals(info_panel)
    
    # Show panel with animation if supported
    if info_panel.has_method("show_panel"):
        info_panel.show_panel()
    else:
        info_panel.visible = true
    
    var display_name = structure_data.get("displayName", structure_name)
    print("[NEW_UI] ✓ Info panel created through ComponentRegistry for: " + display_name)

func _display_with_legacy_system(structure_name: String, structure_data: Dictionary) -> void:
    """Display structure info using legacy system"""
    print("[LEGACY_UI] Using legacy system for: " + structure_name)
    
    # Get UI layer
    var ui_layer = get_node_or_null("UI_Layer")
    if not ui_layer or not ui_layer is CanvasLayer:
        push_error("[ERROR] UI_Layer not found or wrong type!")
        return
    
    # Remove existing panel if any
    if info_panel:
        info_panel.queue_free()
        info_panel = null
    
    # Create info panel using legacy factory
    info_panel = InfoPanelFactory.create_info_panel()
    if not info_panel:
        push_error("[ERROR] Failed to create info panel")
        return
    
    info_panel.name = "StructureInfoPanel"
    
    # Configure panel
    if info_panel.has_method("set_panel_title"):
        info_panel.set_panel_title("Structure Information")
    if info_panel.has_method("set_closeable"):
        info_panel.set_closeable(true)
    
    # Add to UI layer
    ui_layer.add_child(info_panel)
    
    # Load structure data into the panel
    if info_panel.has_method("display_structure_info"):
        info_panel.display_structure_info(structure_data)
    elif info_panel.has_method("load_structure_data"):
        info_panel.load_structure_data(structure_data)
    elif info_panel.has_method("update_info"):
        info_panel.update_info(structure_data)
    elif info_panel.has_method("display_structure"):
        info_panel.display_structure(structure_data)
    else:
        # Basic fallback - set text if it's a simple label/panel
        if info_panel.has_method("set_text"):
            var display_text = (structure_data.get("displayName") or "Unknown") + "\n" + (structure_data.get("shortDescription") or "No description available")
            info_panel.set_text(display_text)
    
    # Connect panel signals
    _connect_panel_signals(info_panel)
    
    # Show panel
    info_panel.visible = true
    
    var display_name = structure_data.get("displayName", structure_name)
    print("[LEGACY_UI] ✓ Info panel created and displayed for: " + display_name)

func _save_panel_state(component_id: String, panel: Control) -> void:
    """Save panel state for persistence"""
    if not panel:
        return
    
    var state = {}
    
    # Save common panel state
    if panel.has_method("get_state"):
        state = panel.get_state()
    else:
        # Extract basic state
        state = {
            "visible": panel.visible,
            "position": panel.position,
            "size": panel.size,
            "modulate": panel.modulate
        }
    
    ComponentStateManager.save_component_state(component_id, state)

func _restore_panel_state(component_id: String, panel: Control) -> void:
    """Restore panel state from persistence"""
    if not panel:
        return
    
    var state = ComponentStateManager.restore_component_state(component_id)
    if state.is_empty():
        return
    
    # Restore panel state
    if panel.has_method("restore_state"):
        panel.restore_state(state)
    else:
        # Restore basic state
        if state.has("position"):
            panel.position = state.position
        if state.has("size"):
            panel.size = state.size
        if state.has("modulate"):
            panel.modulate = state.modulate

func _connect_panel_signals(panel: Control) -> void:
    """Connect panel signals consistently"""
    if not panel:
        return
    
    # Connect panel signals if available
    if panel.has_signal("panel_closed"):
        if not panel.is_connected("panel_closed", _on_info_panel_closed):
            panel.panel_closed.connect(_on_info_panel_closed)
    elif panel.has_signal("closed"):
        if not panel.is_connected("closed", _on_info_panel_closed):
            panel.closed.connect(_on_info_panel_closed)

func _find_structure_id(mesh_name: String) -> String:
    """Find structure ID by mesh name (legacy method for backward compatibility)"""
    if KnowledgeService and KnowledgeService.is_initialized():
        # Use new KnowledgeService for better search
        var search_results = KnowledgeService.search_structures(mesh_name)
        if not search_results.is_empty():
            return search_results[0].get("id", "")
        return ""
    
    # Fallback to legacy search
    var lower_name = mesh_name.to_lower()
    var structure_ids = KB.get_all_structure_ids()
    
    # Try exact match first
    for id in structure_ids:
        var structure = KB.get_structure(id)
        if typeof(structure) == TYPE_DICTIONARY and structure.has("displayName") and structure.displayName.to_lower() == lower_name:
            return id
    
    # Try partial match
    for id in structure_ids:
        var structure = KB.get_structure(id)
        if typeof(structure) == TYPE_DICTIONARY and structure.has("displayName"):
            var display_name = structure.displayName.to_lower()
            if lower_name.contains(display_name) or display_name.contains(lower_name):
                return id
    
    return ""

# Refresh panel with new theme
func refresh_info_panel() -> void:
    """Recreate the info panel with the current theme if one is visible"""
    if info_panel and info_panel.visible and not last_selected_structure.is_empty():
        print("[THEME] Refreshing panel for: " + last_selected_structure)
        # Let the old panel finish freeing before creating new one
        call_deferred("_display_structure_info", last_selected_structure)

func _print_instructions() -> void:
    print("\n=== NEUROVIS CONTROLS ===")
    print("• Right-click: Select brain structures")
    print("• Left-click + drag: Orbit camera")
    print("• Middle-click + drag: Pan camera") 
    print("• Mouse wheel: Zoom")
    print("• F: Focus view")
    print("• R: Reset camera")
    print("• 1/3/7: Front/Right/Top view")
    print("• 🎨 button: Toggle theme")
    print("• 🤖 button: AI Assistant")
    print("========================\n")

# New Modular Panel Signal Handlers
func _on_panel_content_changed(section: String, _data: Dictionary) -> void:
    print("[MODULAR_UI] Content changed in section '%s'" % section)

func _on_section_toggled(section_name: String, expanded: bool) -> void:
    print("[MODULAR_UI] Section '%s' %s" % [section_name, "expanded" if expanded else "collapsed"])
    # Optional: Save section state preferences

func _on_panel_action_triggered(action: String, data: Dictionary) -> void:
    print("[MODULAR_UI] Action triggered: %s with data: %s" % [action, data])
    
    match action:
        "learn_more":
            var structure_id = data.get("structure_id", "")
            if not structure_id.is_empty():
                _show_detailed_info(structure_id)
        "highlight":
            var structure_id = data.get("structure_id", "")
            if not structure_id.is_empty():
                _highlight_related_structure(structure_id)
        "bookmark":
            var structure_id = data.get("structure_id", "")
            _toggle_bookmark(structure_id)
        "search":
            var query = data.get("query", "")
            _perform_structure_search(query)
        _:
            print("[MODULAR_UI] Unknown action: %s" % action)

func _on_theme_toggle_pressed() -> void:
    """Handle theme toggle button press"""
    var theme_manager = preload("res://ui/panels/UIThemeManager.gd")
    
    # Toggle between enhanced and minimal themes
    var current_mode = theme_manager.current_mode
    if current_mode == theme_manager.ThemeMode.ENHANCED:
        theme_manager.set_theme_mode(theme_manager.ThemeMode.MINIMAL)
    else:
        theme_manager.set_theme_mode(theme_manager.ThemeMode.ENHANCED)
    
    # Refresh the current panel with new theme
    refresh_info_panel()

func _on_ai_toggle_pressed() -> void:
    """Handle AI assistant toggle button press"""
    #if ai_assistant_panel and ai_assistant_panel.visible:
        # Hide AI assistant
        #ai_assistant_panel.animate_hide()
    #else:
        # Show AI assistant
        #_show_ai_assistant()

# New action handlers for modular panel
func _show_detailed_info(structure_id: String) -> void:
    """Show detailed information for a structure"""
    print("[ACTION] Showing detailed info for: %s" % structure_id)
    # TODO: Create detailed view or expand current panel

func _highlight_related_structure(structure_id: String) -> void:
    """Highlight a related structure in the 3D view"""
    print("[ACTION] Highlighting related structure: %s" % structure_id)
    # TODO: Use selection manager to highlight structure

func _toggle_bookmark(structure_id: String) -> void:
    """Toggle bookmark status for a structure"""
    print("[ACTION] Toggling bookmark for: %s" % structure_id)
    # TODO: Implement bookmark persistence

func _perform_structure_search(query: String) -> void:
    """Perform search across all brain structures"""
    print("[ACTION] Searching for: %s" % query)
    
    if KnowledgeService and KnowledgeService.is_initialized():
        var search_results = KnowledgeService.search_structures(query)
        print("[SEARCH] Found %d results for query: %s" % [search_results.size(), query])
        
        for result in search_results:
            print("  - %s (%s)" % [result.get("displayName", "Unknown"), result.get("id", "")])
        
        # If we have results, display the first one
        if not search_results.is_empty():
            var first_result = search_results[0]
            var structure_name = first_result.get("displayName", "")
            if not structure_name.is_empty():
                _display_structure_info(structure_name)
    else:
        print("[SEARCH] KnowledgeService not available - search functionality limited")

# Legacy handlers for backward compatibility
func _on_structure_bookmarked(structure_id: String, _bookmarked: bool) -> void:
    _toggle_bookmark(structure_id)

func _on_structure_search_requested(query: String) -> void:
    _perform_structure_search(query)

func _on_related_structure_selected(structure_id: String) -> void:
    _display_structure_info(structure_id)

# === AI ASSISTANT METHODS ===
func _show_ai_assistant() -> void:
    """Show the AI assistant panel"""
    var ui_layer = get_node_or_null("UI_Layer")
    if not ui_layer or not ui_layer is CanvasLayer:
        push_error("[AI] UI_Layer not found or wrong type!")
        return
    
    # Remove existing AI panel if any
    if ai_assistant_panel:
        ai_assistant_panel.queue_free()
        ai_assistant_panel = null
    
    # Create new AI assistant panel safely (temporarily using fallback)
    print("[AI] AI assistant panel temporarily disabled for progressive enablement")
    print("[AI] Using fallback panel for now")
    
    # Create a simple fallback panel
    ai_assistant_panel = PanelContainer.new()
    ai_assistant_panel.name = "AIAssistantPanel_Fallback"
    
    var label = Label.new()
    label.text = "AI Assistant (Coming Soon)"
    ai_assistant_panel.add_child(label)
    
    # Add to UI layer
    ui_layer.add_child(ai_assistant_panel)
    
    # Position the panel
    _position_ai_assistant_panel()
    
    # Show panel
    ai_assistant_panel.visible = true
    
    print("[AI] ✓ Fallback AI assistant panel created successfully")
    
    print("[AI] AI Assistant panel created and displayed")

func _position_ai_assistant_panel() -> void:
    """Position the AI assistant panel responsively"""
    #if not ai_assistant_panel:
        #return
    
    #var viewport_size = get_viewport().get_visible_rect().size
    
    # Position on the left side for desktop, bottom for mobile
    #if viewport_size.x > 1024:  # Desktop
        #ai_assistant_panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER_LEFT)
        #ai_assistant_panel.position.x = 16
        #ai_assistant_panel.custom_minimum_size = Vector2(400, 600)
    #else:  # Mobile/Tablet
        #ai_assistant_panel.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
        #ai_assistant_panel.position.y -= 350
        #ai_assistant_panel.custom_minimum_size = Vector2(viewport_size.x - 32, 350)
    pass

func _connect_ai_panel_signals() -> void:
    """Connect AI assistant panel signals"""
    #if not ai_assistant_panel:
        #return
    
    # Connect panel signals
    #if ai_assistant_panel.has_signal("panel_closed"):
        #ai_assistant_panel.panel_closed.connect(_on_ai_panel_closed)
    
    #if ai_assistant_panel.has_signal("question_asked"):
        #ai_assistant_panel.question_asked.connect(_on_ai_question_asked)
    
    #if ai_assistant_panel.has_signal("feedback_given"):
        #ai_assistant_panel.feedback_given.connect(_on_ai_feedback_given)
    
    #print("[AI] AI panel signals connected")
    pass

func _on_ai_panel_closed() -> void:
    """Handle AI panel close"""
    #if ai_assistant_panel:
        #ai_assistant_panel.queue_free()
        #ai_assistant_panel = null
    print("[AI] AI Assistant panel closed")

func _on_ai_question_asked(question: String) -> void:
    """Handle AI question asked"""
    print("[AI] Question asked: %s" % question)
    # Questions are handled automatically by the AI service

func _on_ai_feedback_given(rating: int, comment: String) -> void:
    """Handle AI feedback"""
    print("[AI] Feedback received - Rating: %d, Comment: %s" % [rating, comment])
    # TODO: Store feedback for AI service improvement

# Debug command registration
func _register_debug_commands() -> void:
    if not OS.is_debug_build() or not DebugCmd:
        return
    
    DebugCmd.register_command("reset_camera", func(): camera_controller.reset_view(), "Reset camera")
    DebugCmd.register_command("list_models", _debug_list_models, "List models")
    DebugCmd.register_command("test_selection", _debug_test_selection, "Test selection")

func _debug_list_models() -> void:
    if ModelSwitcherGlobal:
        var models = ModelSwitcherGlobal.get_model_names()
        print("Models: " + str(models))

func _debug_test_selection() -> void:
    var center = get_viewport().get_visible_rect().size / 2.0
    selection_manager.handle_selection_at_position(center)

# === FOUNDATION LAYER DEBUG COMMANDS ===
func _register_foundation_debug_commands() -> void:
    """Register debug commands for foundation layer"""
    if not OS.is_debug_build() or not DebugCmd:
        return
    
    # Feature flag commands
    DebugCmd.register_command("flags_status", _debug_show_flags, "Show feature flag status")
    DebugCmd.register_command("flag_enable", _debug_enable_flag, "Enable feature flag [flag_name]")
    DebugCmd.register_command("flag_disable", _debug_disable_flag, "Disable feature flag [flag_name]")
    DebugCmd.register_command("flag_toggle", _debug_toggle_flag, "Toggle feature flag [flag_name]")
    
    # Component registry commands
    DebugCmd.register_command("registry_stats", _debug_registry_stats, "Show component registry statistics")
    DebugCmd.register_command("registry_cleanup", _debug_registry_cleanup, "Clean up component registry")
    DebugCmd.register_command("test_component", _debug_test_component, "Test component creation [type] [config]")
    
    # State manager commands
    DebugCmd.register_command("state_stats", _debug_state_stats, "Show state manager statistics")
    DebugCmd.register_command("state_list", _debug_list_states, "List all component states")
    DebugCmd.register_command("state_clear", _debug_clear_states, "Clear all component states")
    
    # Integration commands
    DebugCmd.register_command("test_foundation", _debug_test_foundation, "Run foundation layer tests")
    DebugCmd.register_command("demo_foundation", _debug_demo_foundation, "Show foundation demo window")
    DebugCmd.register_command("migration_test", _debug_migration_test, "Test migration between systems")
    DebugCmd.register_command("test_new_components", _debug_test_new_components, "Test new component system (Phase 2)")
    DebugCmd.register_command("test_phase3", _debug_test_phase3, "Test Phase 3: StyleEngine & Advanced Interactions")
    
    # AI integration commands
    DebugCmd.register_command("force_gemini_setup", func():
        _gemini_setup_shown = false
        call_deferred("_check_gemini_setup")
        return "Forcing Gemini setup check"
    , "Force Gemini setup dialog check")

# Feature flag debug commands
func _debug_show_flags() -> void:
    FeatureFlags.print_flag_status()

func _debug_enable_flag(flag_name: String = "") -> void:
    if flag_name.is_empty():
        print("Usage: flag_enable <flag_name>")
        return
    FeatureFlags.enable_feature(flag_name)
    print("Enabled: " + flag_name)

func _debug_disable_flag(flag_name: String = "") -> void:
    if flag_name.is_empty():
        print("Usage: flag_disable <flag_name>")
        return
    FeatureFlags.disable_feature(flag_name)
    print("Disabled: " + flag_name)

func _debug_toggle_flag(flag_name: String = "") -> void:
    if flag_name.is_empty():
        print("Usage: flag_toggle <flag_name>")
        return
    var new_state = FeatureFlags.toggle_feature(flag_name)
    print("Toggled %s: %s" % [flag_name, "enabled" if new_state else "disabled"])

# Component registry debug commands
func _debug_registry_stats() -> void:
    ComponentRegistry.print_registry_stats()

func _debug_registry_cleanup() -> void:
    ComponentRegistry.cleanup_registry()
    print("Registry cleanup completed")

func _debug_test_component(component_type: String = "button", config_str: String = "{}") -> void:
    if component_type.is_empty():
        print("Usage: test_component <type> [config_json]")
        return
    
    var config = {}
    if config_str != "{}":
        var json = JSON.new()
        if json.parse(config_str) == OK:
            config = json.data
    
    var component = ComponentRegistry.create_component(component_type, config)
    if component:
        print("✓ Created component: %s (%s)" % [component.get_class(), component_type])
        component.queue_free()
    else:
        print("✗ Failed to create component: " + component_type)

# State manager debug commands
func _debug_state_stats() -> void:
    ComponentStateManager.print_state_stats()

func _debug_list_states() -> void:
    var states = ComponentStateManager.list_all_component_states()
    print("Component States (%d):" % states.size())
    for state_id in states:
        var info = ComponentStateManager.get_component_state_info(state_id)
        var age_text = "%.1fs" % info.get("age_seconds", 0) if info.get("exists", false) else "N/A"
        var persist_text = "persistent" if info.get("persistent", false) else "session"
        print("  %s (%s, %s)" % [state_id, persist_text, age_text])

func _debug_clear_states() -> void:
    ComponentStateManager.clear_session_states()
    print("Cleared session states")

# Integration debug commands
func _debug_test_foundation() -> void:
    print("Running foundation layer tests...")
    var TestFramework = preload("res://tests/integration/test_component_foundation.gd")
    var results = TestFramework.run_foundation_tests()
    
    print("\n=== FOUNDATION TEST RESULTS ===")
    print("Success Rate: %.1f%% (%d/%d)" % [results.success_rate, results.passed_tests, results.total_tests])
    
    if results.success_rate == 100.0:
        print("🎉 All tests passed!")
    else:
        print("⚠️ Some tests failed")

func _debug_demo_foundation() -> void:
    print("Opening foundation demo window...")
    var FoundationDemo = preload("res://ui/integration/FoundationDemo.gd")
    var demo_window = FoundationDemo.create_demo_window()
    get_tree().root.add_child(demo_window)

func _debug_migration_test() -> void:
    print("Testing migration between legacy and new systems...")
    
    # Test legacy mode
    print("1. Testing legacy mode...")
    ComponentRegistry.set_legacy_mode(true)
    _display_structure_info("hippocampus")  # This should use legacy system
    
    await get_tree().create_timer(2.0).timeout
    
    # Test new mode
    print("2. Testing new mode...")
    ComponentRegistry.set_legacy_mode(false)
    _display_structure_info("hippocampus")  # This should use new system
    
    print("Migration test completed - check console output for system usage")

func _debug_test_new_components() -> void:
    """Test the new component system Phase 2 implementation"""
    print("\n=== TESTING NEW COMPONENT SYSTEM (PHASE 2) ===")
    
    # Test InfoPanel creation with new system
    print("1. Testing InfoPanel with new component architecture...")
    var info_config = {
        "title": "Hippocampus",
        "theme_mode": "enhanced",
        "responsive": true,
        "show_bookmark": true
    }
    
    var new_panel = ComponentRegistry.create_component("info_panel", info_config)
    if new_panel:
        print("✓ InfoPanel created: %s" % new_panel.name)
        
        # Test structure display
        if new_panel.has_method("display_structure_info"):
            var test_structure = {
                "id": "hippocampus",
                "displayName": "Hippocampus",
                "shortDescription": "Essential for memory formation",
                "functions": ["Memory consolidation", "Spatial navigation"],
                "clinicalRelevance": "Critical in Alzheimer's disease"
            }
            new_panel.display_structure_info(test_structure)
            print("✓ Structure info displayed successfully")
        else:
            print("⚠ Missing display_structure_info method")
        
        # Add to scene temporarily for visual test
        get_tree().root.add_child(new_panel)
        new_panel.position = Vector2(50, 50)
        
        # Auto-remove after 5 seconds
        await get_tree().create_timer(5.0).timeout
        if is_instance_valid(new_panel):
            new_panel.queue_free()
            print("✓ Test panel cleaned up")
    else:
        print("✗ Failed to create InfoPanel")
    
    # Test individual fragments
    print("\n2. Testing fragment components...")
    _test_fragment_components()
    
    # Test factory system
    print("\n3. Testing factory patterns...")
    ComponentRegistry.print_registry_stats()
    
    print("=== NEW COMPONENT TESTS COMPLETED ===\n")

func _test_fragment_components() -> void:
    """Test individual fragment components"""
    
    # Test header fragment
    var header_config = {
        "title": "Test Structure",
        "actions": ["bookmark", "close"],
        "theme_mode": "enhanced"
    }
    var header = ComponentRegistry.create_component("header", header_config)
    if header:
        print("✓ Header fragment created")
        header.queue_free()
    else:
        print("✗ Header fragment failed")
    
    # Test content fragment
    var content_config = {
        "sections": ["description", "functions", "clinical_relevance"]
    }
    var content = ComponentRegistry.create_component("content", content_config)
    if content:
        print("✓ Content fragment created")
        content.queue_free()
    else:
        print("✗ Content fragment failed")
    
    # Test actions fragment
    var actions_config = {
        "preset": "default",
        "buttons": [
            {"text": "Learn More", "action": "learn"},
            {"text": "Bookmark", "action": "bookmark"}
        ]
    }
    var actions = ComponentRegistry.create_component("actions", actions_config)
    if actions:
        print("✓ Actions fragment created")
        actions.queue_free()
    else:
        print("✗ Actions fragment failed")
    
    # Test section fragment
    var section_config = {
        "name": "description",
        "title": "Description",
        "collapsible": true,
        "expanded": true
    }
    var section = ComponentRegistry.create_component("section", section_config)
    if section:
        print("✓ Section fragment created")
        section.queue_free()
    else:
        print("✗ Section fragment failed")

func _debug_test_phase3() -> void:
    """Test Phase 3: StyleEngine and AdvancedInteractionSystem"""
    print("\n=== TESTING PHASE 3: STYLE ENGINE & ADVANCED INTERACTIONS ===")
    
    # Enable Phase 3 features for testing
    FeatureFlags.enable_feature(FeatureFlags.UI_STYLE_ENGINE)
    FeatureFlags.enable_feature(FeatureFlags.UI_ADVANCED_INTERACTIONS)
    FeatureFlags.enable_feature(FeatureFlags.UI_SMOOTH_ANIMATIONS)
    FeatureFlags.enable_feature(FeatureFlags.UI_CONTEXT_MENUS)
    FeatureFlags.enable_feature(FeatureFlags.UI_GESTURE_RECOGNITION)
    
    # Load test script
    var test_script = load("res://test_phase3_features.gd")
    if test_script:
        var test_instance = test_script.new()
        get_tree().root.add_child(test_instance)
        
        # Auto-remove test instance after completion
        await get_tree().create_timer(5.0).timeout
        if is_instance_valid(test_instance):
            test_instance.queue_free()
            print("✓ Phase 3 test instance cleaned up")
    else:
        print("✗ Failed to load Phase 3 test script")
    
    print("=== PHASE 3 TESTS COMPLETED ===\n")

# === MULTI-SELECTION HANDLERS ===
func _on_multi_selection_changed(selections: Array) -> void:
    """Handle changes to multi-selection state"""
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
        _display_structure_info(selection["name"])
        object_name_label.text = "Selected: " + selection["name"]
        
    else:
        # Multiple selections - show comparative panel
        if info_panel:
            info_panel.hide()
        _show_comparative_panel(selections)
        
        # Update label to show multiple selections
        var names = []
        for sel in selections:
            names.append(sel["name"])
        object_name_label.text = "Comparing: " + ", ".join(names)
    
    print("[MultiSelect] Selection changed: %d structures" % selections.size())

func _on_comparison_mode_entered() -> void:
    """Handle entering comparison mode"""
    print("[MultiSelect] Entered comparison mode")
    
    # Show comparison mode indicator (optional)
    # Could add visual feedback here

func _on_comparison_mode_exited() -> void:
    """Handle exiting comparison mode"""
    print("[MultiSelect] Exited comparison mode")
    
    # Hide comparative panel
    if comparative_panel:
        comparative_panel.hide()

func _on_selection_limit_reached() -> void:
    """Handle when selection limit is reached"""
    print("[MultiSelect] Selection limit reached!")
    
    # Show user feedback
    var notification = Label.new()
    notification.text = "Maximum 3 structures can be selected for comparison"
    notification.add_theme_color_override("font_color", Color(1, 0.8, 0))
    notification.add_theme_font_size_override("font_size", 16)
    
    # Position at top center
    notification.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
    notification.position.y = 100
    notification.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    
    # Add to UI layer
    var ui_layer = get_node_or_null("UI_Layer")
    if ui_layer:
        ui_layer.add_child(notification)
        
        # Auto-remove after 3 seconds
        await get_tree().create_timer(3.0).timeout
        notification.queue_free()

func _show_comparative_panel(selections: Array) -> void:
    """Show the comparative information panel"""
    var ui_layer = get_node_or_null("UI_Layer")
    if not ui_layer:
        push_error("[MultiSelect] UI_Layer not found!")
        return
    
    # Create comparative panel if it doesn't exist
    if not comparative_panel:
        comparative_panel = ComparativeInfoPanelScript.new()
        comparative_panel.name = "ComparativeInfoPanel"
        
        # Position on the right side
        comparative_panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER_RIGHT)
        comparative_panel.position.x = -420
        comparative_panel.custom_minimum_size = Vector2(400, 600)
        
        ui_layer.add_child(comparative_panel)
        
        # Connect signals
        comparative_panel.structure_focused.connect(_on_comparative_structure_focused)
        comparative_panel.comparison_cleared.connect(func(): selection_manager.clear_all_selections())
    
    # Update panel with selections
    comparative_panel.update_selections(selections)
    comparative_panel.show()

func _on_comparative_structure_focused(structure_name: String) -> void:
    """Handle focus request from comparative panel"""
    # Find the mesh for this structure
    var meshes = _get_all_brain_meshes()
    for mesh in meshes:
        if mesh.name == structure_name:
            # Focus camera on this structure
            if camera_controller and camera_controller.has_method("focus_on_mesh"):
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

func _check_gemini_setup() -> void:
    """Check if Gemini needs setup on first launch"""
    if _gemini_setup_shown:
        return
    
    var gemini = get_node_or_null("/root/GeminiAI")
    if not gemini or not gemini.has_method("needs_setup"):
        print("[Gemini] Service not available or missing needs_setup method")
        return
    
    # Check if setup is needed
    if gemini.needs_setup():
        print("[Gemini] Setup needed, showing dialog after short delay")
        # Add a small delay to ensure UI is fully ready
        await get_tree().create_timer(0.5).timeout
        _show_gemini_setup_dialog()
        _gemini_setup_shown = true
    else:
        print("[Gemini] Setup not needed, already configured")

func _show_gemini_setup_dialog() -> void:
    """Show the Gemini setup wizard"""
    var ui_layer = get_node_or_null("UI_Layer")
    if not ui_layer:
        ui_layer = self  # Fallback to adding to self
    
    # Load and create dialog
    print("[Gemini] Loading setup dialog scene")
    var dialog_scene = load("res://ui/panels/GeminiSetupDialog.tscn")
    if not dialog_scene:
        push_error("[Gemini] Setup dialog scene not found")
        return
    
    var dialog = dialog_scene.instantiate()
    if not dialog:
        push_error("[Gemini] Failed to instantiate dialog")
        return
        
    dialog.name = "GeminiSetupDialog"
    
    # Connect signals before adding to scene tree
    if dialog.has_signal("setup_completed"):
        dialog.setup_completed.connect(_on_gemini_setup_completed.bind(dialog))
    else:
        push_warning("[Gemini] Dialog missing setup_completed signal")
        
    if dialog.has_signal("setup_cancelled"):
        dialog.setup_cancelled.connect(_on_gemini_setup_cancelled.bind(dialog))
    else:
        push_warning("[Gemini] Dialog missing setup_cancelled signal")
    
    # Add to scene after connecting signals
    ui_layer.add_child(dialog)
    
    # Ensure dialog is visible and call show method if available
    dialog.visible = true
    if dialog.has_method("show_dialog"):
        dialog.call_deferred("show_dialog")
    
    print("[Gemini] Setup dialog shown")

func _on_gemini_setup_completed(dialog: Control) -> void:
    """Handle successful Gemini setup"""
    print("[Gemini] Setup completed successfully")
    dialog.queue_free()
    
    # Update AI provider
    var ai_service = get_node_or_null("/root/AIAssistant")
    if ai_service:
        ai_service.set_provider(AIAssistantService.AIProvider.GEMINI_USER)

func _on_gemini_setup_cancelled(dialog: Control) -> void:
    """Handle cancelled Gemini setup"""
    print("[Gemini] Setup cancelled")
    dialog.queue_free()
