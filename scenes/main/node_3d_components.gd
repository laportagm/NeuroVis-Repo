## Main scene using component-based architecture.
##
## This is the refactored main scene that delegates all functionality to specialized components.
## It coordinates initialization and high-level operations only.
##
## @tutorial: https://github.com/project/wiki/main-scene-architecture
class_name MainSceneComponents
extends Node3D

# Component scripts
const ComponentBase = preload("res://scripts/components/component_base.gd")
const BrainVisualizerScript = preload("res://scripts/components/brain_visualizer.gd")
const UIManagerScript = preload("res://scripts/components/ui_manager.gd") 
const InteractionHandlerScript = preload("res://scripts/components/interaction_handler.gd")
const StateManagerScript = preload("res://scripts/components/state_manager.gd")

# Components
var brain_visualizer: Node
var ui_manager: Node
var interaction_handler: Node
var state_manager: Node

# Scene node references
@onready var camera: Camera3D = $Camera3D
@onready var ui_layer: CanvasLayer = $UI_Layer
@onready var brain_model_parent: Node3D = $BrainModel

# UI node references
@onready var object_name_label: Label = $UI_Layer/ObjectNameLabel
@onready var info_panel = $UI_Layer/StructureInfoPanel
@onready var model_control_panel = $UI_Layer/ModelControlPanel

# Export variables for customizing highlight appearance
@export var highlight_color: Color = Color(0.0, 1.0, 0.0, 1.0)
@export var emission_energy: float = 0.5

# Signals
signal scene_ready
signal initialization_failed(error: String)

var initialization_complete: bool = false

func _ready() -> void:
	print("\n[MainSceneComponents] ====== COMPONENT-BASED INITIALIZATION ======")
	print("[MainSceneComponents] Starting component-based architecture...")
	
	# Create components
	_create_components()
	
	# Setup component references
	_setup_component_references()
	
	# Initialize components
	await _initialize_components()
	
	# Start loading content
	_start_content_loading()
	
	initialization_complete = true
	print("[MainSceneComponents] ====== INITIALIZATION COMPLETE ======\n")
	scene_ready.emit()

func _create_components() -> void:
	"""Create all component instances"""
	print("[MainSceneComponents] Creating components...")
	
	# Create BrainVisualizer
	brain_visualizer = BrainVisualizerScript.new()
	brain_visualizer.name = "BrainVisualizer"
	add_child(brain_visualizer)
	print("[MainSceneComponents] ✓ BrainVisualizer created")
	
	# Create UIManager
	ui_manager = UIManagerScript.new()
	ui_manager.name = "UIManager"
	add_child(ui_manager)
	print("[MainSceneComponents] ✓ UIManager created")
	
	# Create InteractionHandler
	interaction_handler = InteractionHandlerScript.new()
	interaction_handler.name = "InteractionHandler"
	add_child(interaction_handler)
	print("[MainSceneComponents] ✓ InteractionHandler created")
	
	# Create StateManager
	state_manager = StateManagerScript.new()
	state_manager.name = "StateManager"
	add_child(state_manager)
	print("[MainSceneComponents] ✓ StateManager created")

func _setup_component_references() -> void:
	"""Pass required references to each component"""
	print("[MainSceneComponents] Setting up component references...")
	
	# Setup BrainVisualizer
	if brain_visualizer:
		brain_visualizer.set_model_parent(brain_model_parent)
		print("[MainSceneComponents] ✓ BrainVisualizer references set")
	
	# Setup UIManager
	if ui_manager:
		ui_manager.set_ui_layer(ui_layer)
		ui_manager.set_object_name_label(object_name_label)
		ui_manager.set_info_panel(info_panel)
		ui_manager.set_model_control_panel(model_control_panel)
		print("[MainSceneComponents] ✓ UIManager references set")
	
	# Setup InteractionHandler
	if interaction_handler:
		interaction_handler.set_camera(camera)
		# Configure highlight colors
		interaction_handler.configure_highlight_colors(highlight_color, Color(1.0, 0.7, 0.0, 0.6))
		interaction_handler.set_emission_energy(emission_energy)
		interaction_handler.set_outline_enabled(true)
		print("[MainSceneComponents] ✓ InteractionHandler references set")
	
	# Setup StateManager with component references
	if state_manager:
		state_manager.set_components(brain_visualizer, ui_manager, interaction_handler)
		print("[MainSceneComponents] ✓ StateManager references set")

func _initialize_components() -> void:
	"""Initialize all components and wait for them to be ready"""
	print("[MainSceneComponents] Initializing components...")
	
	var components = [brain_visualizer, ui_manager, interaction_handler, state_manager]
	
	for component in components:
		if component and not component.is_initialized:
			print("[MainSceneComponents] Initializing %s..." % component.name)
			await _wait_for_component(component)
			if component.is_initialized:
				print("[MainSceneComponents] ✓ %s initialized" % component.name)
			else:
				print("[MainSceneComponents] ✗ %s failed to initialize" % component.name)

func _wait_for_component(component: Node) -> void:
	"""Wait for a single component to be ready"""
	if component.is_initialized:
		return
	
	# Components initialize on _ready, so wait a frame
	await get_tree().process_frame
	
	# If still not initialized, wait for the signal
	if not component.is_initialized:
		await component.component_ready

func _start_content_loading() -> void:
	"""Start loading brain models and other content"""
	print("[MainSceneComponents] Starting content loading...")
	
	# Load brain models
	if brain_visualizer:
		brain_visualizer.load_brain_models()
		print("[MainSceneComponents] ✓ Brain model loading initiated")
	
	# Connect to model control panel if it exists
	if model_control_panel and ModelSwitcherGlobal:
		_setup_model_control_panel()
		print("[MainSceneComponents] ✓ Model control panel setup")
	
	# Apply modern theme
	_apply_modern_theme()
	
	# Print interaction instructions
	_print_interaction_instructions()

func _setup_model_control_panel() -> void:
	"""Setup model control panel connections"""
	
	# Connect to model switcher signals
	if ModelSwitcherGlobal.has_signal("model_visibility_changed"):
		ModelSwitcherGlobal.model_visibility_changed.connect(_on_model_visibility_changed)
	
	# Connect to panel signals
	if model_control_panel.has_signal("model_selected"):
		model_control_panel.model_selected.connect(_on_model_selected)
	
	# Setup with existing models or wait for them to load
	if ModelSwitcherGlobal.get_model_names().size() > 0:
		model_control_panel.setup_with_models(ModelSwitcherGlobal.get_model_names())
	else:
		if brain_visualizer:
			brain_visualizer.all_models_loaded.connect(
				func(model_names): model_control_panel.setup_with_models(model_names)
			)

func _on_model_selected(model_name: String) -> void:
	"""Handle model selection from control panel"""
	if brain_visualizer:
		brain_visualizer.toggle_model_visibility(model_name)

func _on_model_visibility_changed(model_name: String, is_visible: bool) -> void:
	"""Handle model visibility change"""
	if model_control_panel and model_control_panel.has_method("update_button_state"):
		model_control_panel.update_button_state(model_name, is_visible)

func _apply_modern_theme() -> void:
	"""Apply modern UI theme"""
	print("[MainSceneComponents] Applying modern theme...")
	
	var modern_theme = Theme.new()
	
	if ui_layer:
		for child in ui_layer.get_children():
			if child is Control:
				child.set_theme(modern_theme)

func _print_interaction_instructions() -> void:
	"""Print user interaction instructions"""
	print("\n" + "=".repeat(60))
	print("NEUROVIS COMPONENT-BASED ARCHITECTURE")
	print("=".repeat(60))
	print("SELECTION:")
	print("  • Right-click to select brain structures")
	print("  • ESC to clear selection")
	print("\nCAMERA CONTROLS:")
	print("  • Left-click + drag: Orbit view")
	print("  • Middle-click + drag: Pan view")
	print("  • Mouse wheel: Zoom in/out")
	print("  • R: Reset view")
	print("\nVIEW PRESETS:")
	print("  • 1: Front view")
	print("  • 3: Right view")
	print("  • 7: Top view")
	print("  • F: Focus on selection")
	print("=".repeat(60) + "\n")

# Override input handling to use our interaction handler
func _input(event: InputEvent) -> void:
	if not initialization_complete:
		return
	
	# Camera shortcuts are handled by CameraController in the original implementation
	# Just handle keyboard shortcuts for camera views here
	if event is InputEventKey and event.pressed:
		# Get camera controller from children (it's created by the original initialization)
		var camera_controller = get_node_or_null("@Node@19")  # This is the CameraController based on debug output
		if camera_controller and camera_controller.has_method("set_view_preset"):
			match event.keycode:
				KEY_F:
					if camera_controller.has_method("focus_on_bounds"):
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
					if camera_controller.has_method("reset_view"):
						camera_controller.reset_view()
						get_viewport().set_input_as_handled()

# Debug helper to get component status
func get_component_status() -> Dictionary:
	return {
		"scene": "MainSceneComponents",
		"initialized": initialization_complete,
		"brain_visualizer": brain_visualizer.get_status() if brain_visualizer else "Not created",
		"ui_manager": ui_manager.get_status() if ui_manager else "Not created",
		"interaction_handler": interaction_handler.get_status() if interaction_handler else "Not created",
		"state_manager": state_manager.get_status() if state_manager else "Not created"
	}

func _exit_tree():
	"""Clean up when scene is removed"""
	print("[MainSceneComponents] Cleaning up component-based scene...")
