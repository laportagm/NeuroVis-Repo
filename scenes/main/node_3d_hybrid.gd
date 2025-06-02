## Hybrid implementation demonstrating component-based improvements.
##
## This version keeps the working functionality while showing how components
## would improve the architecture without breaking the existing system.
class_name MainSceneHybrid
extends Node3D

# ==================== COMPONENT ORGANIZATION ====================
# In the refactored architecture, these would be separate component files:
# - BrainVisualizerComponent (handles 3D visualization)
# - UIManagerComponent (handles UI panels)
# - InteractionHandlerComponent (handles input)
# - StateManagerComponent (coordinates components)

# ==================== SCENE REFERENCES ====================
@onready var camera: Camera3D = $Camera3D
@onready var ui_layer: CanvasLayer = $UI_Layer
@onready var brain_model_parent: Node3D = $BrainModel
@onready var object_name_label: Label = $UI_Layer/ObjectNameLabel
@onready var info_panel = $UI_Layer/StructureInfoPanel
@onready var model_control_panel = $UI_Layer/ModelControlPanel

# ==================== PRELOADED SCRIPTS ====================
const ModelCoordinatorScene = preload("res://core/models/ModelRegistry.gd")
const LoadingOverlay = preload("res://ui/panels/LoadingOverlay.gd")
const BrainStructureSelectionManagerScript = preload("res://core/interaction/BrainStructureSelectionManager.gd")
const CameraBehaviorControllerScript = preload("res://core/interaction/CameraBehaviorController.gd")
const AnatomicalKnowledgeDatabaseScript = preload("res://core/knowledge/AnatomicalKnowledgeDatabase.gd")
const BrainVisualizationCoreScript = preload("res://core/systems/BrainVisualizationCore.gd")
const ModelVisibilityManagerScript = preload("res://core/models/ModelVisibilityManager.gd")

# ==================== COMPONENT-LIKE ORGANIZATION ====================
# Brain Visualization Component
var model_coordinator = null
var neural_net = null
var model_switcher = null

# UI Manager Component
var ui_panels: Dictionary = {}

# Interaction Handler Component
var selection_manager = null
var camera_controller = null

# State Manager Component
var knowledge_base = null
var current_state: Dictionary = {
	"selected_structure": "",
	"models_loaded": false
}

# ==================== CONFIGURATION ====================
@export var highlight_color: Color = Color(0.0, 1.0, 0.0, 1.0)
@export var emission_energy: float = 0.5

# ==================== SIGNALS ====================
signal structure_selected(structure_name: String)
signal structure_deselected
signal models_loaded(model_names: Array)

var initialization_complete: bool = false

func _ready() -> void:
	print("\n" + "=".repeat(70))
	print("NEUROVIS - COMPONENT-ORGANIZED ARCHITECTURE")
	print("=".repeat(70))
	print("[INIT] Starting organized initialization...")
	
	# Component-style initialization
	await _initialize_all_components()
	
	print("[INIT] All components initialized successfully")
	print("=".repeat(70) + "\n")

# ==================== COMPONENT INITIALIZATION ====================

func _initialize_all_components() -> void:
	"""Initialize all components in proper order"""
	
	# 1. State Manager Component (Knowledge Base)
	await _initialize_state_manager()
	
	# 2. UI Manager Component
	await _initialize_ui_manager()
	
	# 3. Brain Visualizer Component
	await _initialize_brain_visualizer()
	
	# 4. Interaction Handler Component
	await _initialize_interaction_handler()
	
	# 5. Final setup
	await _finalize_setup()
	
	initialization_complete = true

# ==================== STATE MANAGER COMPONENT ====================

func _initialize_state_manager() -> void:
	print("\n[STATE MANAGER] Initializing...")
	
	# Initialize knowledge base
	knowledge_base = AnatomicalKnowledgeDatabaseScript.new()
	add_child(knowledge_base)
	knowledge_base.load_knowledge_base()
	print("[STATE MANAGER] ✓ Knowledge base loaded")
	
	print("[STATE MANAGER] ✓ Component initialized")

# ==================== UI MANAGER COMPONENT ====================

func _initialize_ui_manager() -> void:
	print("\n[UI MANAGER] Initializing...")
	
	# Setup UI layer
	if ui_layer:
		ui_layer.visible = true
		ui_layer.add_to_group("ui_layer")
	
	# Register UI panels
	if object_name_label:
		ui_panels["object_label"] = object_name_label
		object_name_label.text = "Selected: None"
	
	if info_panel:
		ui_panels["info"] = info_panel
		info_panel.visible = false
		if info_panel.has_signal("panel_closed"):
			info_panel.panel_closed.connect(_on_info_panel_closed)
	
	if model_control_panel:
		ui_panels["model_control"] = model_control_panel
		model_control_panel.visible = true
	
	print("[UI MANAGER] ✓ Registered %d panels" % ui_panels.size())
	print("[UI MANAGER] ✓ Component initialized")

# ==================== BRAIN VISUALIZER COMPONENT ====================

func _initialize_brain_visualizer() -> void:
	print("\n[BRAIN VISUALIZER] Initializing...")
	
	# Initialize neural network module
	neural_net = BrainVisualizationCoreScript.new()
	add_child(neural_net)
	print("[BRAIN VISUALIZER] ✓ Neural network initialized")
	
	# Initialize model switcher
	model_switcher = ModelVisibilityManagerScript.new()
	add_child(model_switcher)
	print("[BRAIN VISUALIZER] ✓ Model switcher initialized")
	
	# Initialize model coordinator
	model_coordinator = ModelCoordinatorScene.new()
	add_child(model_coordinator)
	
	if brain_model_parent:
		model_coordinator.set_model_parent(brain_model_parent)
		model_coordinator.models_loaded.connect(_on_models_loaded)
		model_coordinator.model_load_failed.connect(_on_model_load_failed)
		model_coordinator.load_brain_models()
		print("[BRAIN VISUALIZER] ✓ Model loading initiated")
	
	print("[BRAIN VISUALIZER] ✓ Component initialized")

# ==================== INTERACTION HANDLER COMPONENT ====================

func _initialize_interaction_handler() -> void:
	print("\n[INTERACTION HANDLER] Initializing...")
	
	# Create SelectionManager
	selection_manager = BrainStructureSelectionManagerScript.new()
	add_child(selection_manager)
	
	# Connect selection signals
	if selection_manager.has_signal("structure_selected"):
		selection_manager.structure_selected.connect(_on_structure_selected)
		selection_manager.structure_deselected.connect(_on_structure_deselected)
		selection_manager.structure_hovered.connect(_on_structure_hovered)
		selection_manager.structure_unhovered.connect(_on_structure_unhovered)
	
	# Configure selection
	selection_manager.configure_highlight_colors(highlight_color, Color(1.0, 0.7, 0.0, 0.6))
	selection_manager.set_emission_energy(emission_energy)
	selection_manager.set_outline_enabled(true)
	print("[INTERACTION HANDLER] ✓ Selection manager configured")
	
	# Create CameraController
	camera_controller = CameraBehaviorControllerScript.new()
	add_child(camera_controller)
	
	if camera and brain_model_parent:
		camera_controller.initialize(camera, brain_model_parent)
		print("[INTERACTION HANDLER] ✓ Camera controller initialized")
	
	print("[INTERACTION HANDLER] ✓ Component initialized")

# ==================== FINAL SETUP ====================

func _finalize_setup() -> void:
	print("\n[SETUP] Finalizing...")
	
	# Setup model control panel connections
	if model_control_panel and ModelSwitcherGlobal:
		if ModelSwitcherGlobal.has_signal("model_visibility_changed"):
			ModelSwitcherGlobal.model_visibility_changed.connect(_on_model_visibility_changed)
		if model_control_panel.has_signal("model_selected"):
			model_control_panel.model_selected.connect(_on_model_selected)
		
		if ModelSwitcherGlobal.get_model_names().size() > 0:
			model_control_panel.setup_with_models(ModelSwitcherGlobal.get_model_names())
		else:
			models_loaded.connect(func(names): model_control_panel.setup_with_models(names))
	
	# Print instructions
	_print_interaction_instructions()
	
	print("[SETUP] ✓ Complete")

# ==================== EVENT HANDLERS ====================

func _on_models_loaded(model_names: Array) -> void:
	print("[BRAIN VISUALIZER] Models loaded: ", model_names)
	current_state["models_loaded"] = true
	emit_signal("models_loaded", model_names)

func _on_model_load_failed(model_path: String, error: String) -> void:
	print("[BRAIN VISUALIZER] ERROR: Failed to load ", model_path, ": ", error)

func _on_structure_selected(structure_name: String, _mesh: MeshInstance3D) -> void:
	current_state["selected_structure"] = structure_name
	
	# Update UI through UI Manager pattern
	if "object_label" in ui_panels:
		var label = ui_panels["object_label"]
		var tween = label.create_tween()
		tween.tween_property(label, "modulate:a", 0.0, 0.1)
		tween.tween_callback(func(): label.text = "Selected: " + structure_name)
		tween.tween_property(label, "modulate:a", 1.0, 0.1)
	
	emit_signal("structure_selected", structure_name)
	_display_structure_info(structure_name)

func _on_structure_deselected() -> void:
	current_state["selected_structure"] = ""
	
	if "object_label" in ui_panels:
		ui_panels["object_label"].text = "Selected: None"
	
	if "info" in ui_panels:
		ui_panels["info"].visible = false
	
	emit_signal("structure_deselected")

func _on_structure_hovered(structure_name: String, _mesh: MeshInstance3D) -> void:
	if current_state["selected_structure"].is_empty() and "object_label" in ui_panels:
		ui_panels["object_label"].text = "Hover: " + structure_name

func _on_structure_unhovered() -> void:
	if current_state["selected_structure"].is_empty() and "object_label" in ui_panels:
		ui_panels["object_label"].text = "Hover: None"

func _on_info_panel_closed() -> void:
	pass

func _on_model_selected(model_name: String) -> void:
	if ModelSwitcherGlobal:
		ModelSwitcherGlobal.toggle_model_visibility(model_name)

func _on_model_visibility_changed(model_name: String, is_visible: bool) -> void:
	if model_control_panel and model_control_panel.has_method("update_button_state"):
		model_control_panel.update_button_state(model_name, is_visible)

# ==================== INPUT HANDLING ====================

func _input(event: InputEvent) -> void:
	if not initialization_complete:
		return
	
	# Handle keyboard shortcuts
	if event is InputEventKey and event.pressed:
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
	
	# Handle mouse input
	elif event is InputEventMouseMotion:
		if selection_manager:
			selection_manager.handle_hover_at_position(event.position)
	
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			if selection_manager:
				selection_manager.handle_selection_at_position(event.position)
			get_viewport().set_input_as_handled()

# ==================== HELPER FUNCTIONS ====================

func _display_structure_info(structure_name: String) -> void:
	if not "info" in ui_panels or not knowledge_base or not knowledge_base.is_loaded:
		return
	
	var structure_id = _find_structure_id_by_name(structure_name)
	if structure_id.is_empty():
		return
	
	var structure_data = knowledge_base.get_structure(structure_id)
	if not structure_data.is_empty():
		var info_panel = ui_panels["info"]
		info_panel.visible = true
		if info_panel.has_method("display_structure_data"):
			info_panel.display_structure_data(structure_data)

func _find_structure_id_by_name(mesh_name: String) -> String:
	# Use neural net mapping
	if neural_net and neural_net.has_method("map_mesh_name_to_structure_id"):
		var mapped_id = neural_net.map_mesh_name_to_structure_id(mesh_name)
		if not mapped_id.is_empty():
			return mapped_id
	
	# Fallback to knowledge base search
	if not knowledge_base:
		return ""
	
	var lower_mesh_name = mesh_name.to_lower()
	var structure_ids = knowledge_base.get_all_structure_ids()
	
	# Try exact match
	for id in structure_ids:
		var structure = knowledge_base.get_structure(id)
		if structure.has("displayName") and structure.displayName.to_lower() == lower_mesh_name:
			return id
	
	# Try partial match
	for id in structure_ids:
		var structure = knowledge_base.get_structure(id)
		if structure.has("displayName"):
			var display_name = structure.displayName.to_lower()
			if lower_mesh_name.contains(display_name) or display_name.contains(lower_mesh_name):
				return id
	
	return ""

func _print_interaction_instructions() -> void:
	print("\n" + "=".repeat(60))
	print("INTERACTION INSTRUCTIONS")
	print("=".repeat(60))
	print("SELECTION:")
	print("  • Right-click to select brain structures")
	print("\nCAMERA CONTROLS:")
	print("  • Left-click + drag: Orbit view")
	print("  • Middle-click + drag: Pan view")
	print("  • Mouse wheel: Zoom in/out")
	print("\nKEYBOARD SHORTCUTS:")
	print("  • F: Focus on bounds")
	print("  • 1: Front view")
	print("  • 3: Right view")
	print("  • 7: Top view")
	print("  • R: Reset view")
	print("=".repeat(60) + "\n")

# ==================== STATUS REPORTING ====================

func get_component_status() -> Dictionary:
	return {
		"scene": "MainSceneHybrid",
		"initialized": initialization_complete,
		"components": {
			"state_manager": {
				"knowledge_base_loaded": knowledge_base != null and knowledge_base.is_loaded,
				"selected_structure": current_state["selected_structure"]
			},
			"ui_manager": {
				"panels_registered": ui_panels.size(),
				"panels": ui_panels.keys()
			},
			"brain_visualizer": {
				"models_loaded": current_state["models_loaded"],
				"neural_net": neural_net != null,
				"model_coordinator": model_coordinator != null
			},
			"interaction_handler": {
				"selection_manager": selection_manager != null,
				"camera_controller": camera_controller != null
			}
		}
	}
