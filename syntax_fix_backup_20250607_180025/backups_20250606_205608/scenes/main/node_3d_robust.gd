# Robust version of the main scene with comprehensive error handling and recovery

class_name MainSceneRobust
extends Node3D

# Preload custom classes

signal structure_selected(structure_name: String)
signal structure_deselected
signal models_loaded(model_names: Array)


const CameraControllerScene = preload("res://core/interaction/CameraBehaviorController.gd")
const ModelCoordinatorScene = preload("res://core/models/ModelRegistry.gd")
const BrainStructureSelectionManagerScript = preload(
	"res://core/interaction/BrainStructureSelectionManager.gd"
)
const AnatomicalKnowledgeDatabaseScript = preload(
	"res://core/knowledge/AnatomicalKnowledgeDatabase.gd"
)
const BrainVisualizationCoreScript = preload("res://core/systems/BrainVisualizationCore.gd")
const ModelVisibilityManagerScript = preload("res://core/models/ModelVisibilityManager.gd")

# Constants
const RAY_LENGTH: float = 1000.0
const CAMERA_ROTATION_SPEED: float = 0.01
const CAMERA_ZOOM_SPEED: float = 0.5
const CAMERA_MIN_DISTANCE: float = 2.0
const CAMERA_MAX_DISTANCE: float = 25.0
const DEBUG_MODE: bool = true

# Export variables for customizing highlight appearance

@export var highlight_color: Color = Color(0.0, 1.0, 0.0, 1.0)
@export var emission_energy: float = 0.5

# Node references with robust checking

var selection_manager = null
var camera_controller = null

# Backup references for recovery
var camera_backup: Camera3D = null
var object_name_label_backup: Label = null
var info_panel_backup = null
var brain_model_parent_backup = null
var selection_manager_backup = null
var camera_controller_backup = null

# System references
var knowledge_base = null
var neural_net = null
var model_control_panel = null
var model_switcher = null
var model_coordinator = null

# Safety flags to prevent cascading errors
var initialization_complete: bool = false
var error_recovery_active: bool = false
var initialization_attempt_count: int = 0
var max_initialization_attempts: int = 3

# Performance monitoring
var frame_count: int = 0
var last_fps_check: float = 0.0
var fps_warning_threshold: float = 10.0

# Signals
	var camera_node = get_node_or_null("Camera3D")
	if camera_node and camera_node is Camera3D:
		camera = camera_node
		camera_backup = camera_node
		print("[INIT] Camera found via direct path")
		return true

	# Method 3: Search in children
	for child in get_children():
		if child is Camera3D:
			camera = child
			camera_backup = child
			print("[INIT] Camera found in children")
			return true

	# Method 4: Create emergency camera if none found
	print("[WARNING] No camera found, creating emergency camera...")
	var emergency_camera = Camera3D.new()
	emergency_camera.name = "EmergencyCamera"
	emergency_camera.transform = Transform3D(
		Vector3(1, 0, 0), Vector3(0, 0.866025, 0.5), Vector3(0, -0.5, 0.866025), Vector3(0, 5, 10)
	)
	emergency_camera.current = true
	add_child(emergency_camera)
	camera = emergency_camera
	camera_backup = emergency_camera
	print("[INIT] Emergency camera created")
	return true


	var label_node = get_node_or_null("UI_Layer/ObjectNameLabel")
	if label_node and label_node is Label:
		object_name_label = label_node
		object_name_label_backup = label_node
		print("[INIT] Object label found via direct path")
		return true

	# Method 3: Search recursively
	var ui_layer = get_node_or_null("UI_Layer")
	if ui_layer:
		for child in ui_layer.get_children():
			if child is Label and child.name.contains("ObjectName"):
				object_name_label = child
				object_name_label_backup = child
				print("[INIT] Object label found via search")
				return true

	print("[WARNING] Object label not found")
	return false


	var panel_node = get_node_or_null("UI_Layer/StructureInfoPanel")
	if panel_node:
		info_panel = panel_node
		info_panel_backup = panel_node
		print("[INIT] Info panel found via direct path")
		return true

	# Method 3: Search recursively
	var ui_layer = get_node_or_null("UI_Layer")
	if ui_layer:
		for child in ui_layer.get_children():
			if child.name.contains("InfoPanel") or child.name.contains("StructureInfo"):
				info_panel = child
				info_panel_backup = child
				print("[INIT] Info panel found via search")
				return true

	print("[WARNING] Info panel not found")
	return false


	var parent_node = get_node_or_null("BrainModel")
	if parent_node and parent_node is Node3D:
		brain_model_parent = parent_node
		brain_model_parent_backup = parent_node
		print("[INIT] Brain model parent found via direct path")
		return true

	# Method 3: Search in children
	for child in get_children():
		if child is Node3D and (child.name.contains("BrainModel") or child.name.contains("Model")):
			brain_model_parent = child
			brain_model_parent_backup = child
			print("[INIT] Brain model parent found in children")
			return true

	# Method 4: Create emergency parent
	print("[WARNING] No brain model parent found, creating emergency parent...")
	var emergency_parent = Node3D.new()
	emergency_parent.name = "EmergencyBrainModel"
	add_child(emergency_parent)
	brain_model_parent = emergency_parent
	brain_model_parent_backup = emergency_parent
	print("[INIT] Emergency brain model parent created")
	return true


		var safe_camera = get_safe_camera()
		if safe_camera:
			if camera_controller.has_method("initialize"):
				camera_controller.initialize(safe_camera, get_safe_brain_model_parent())
			if camera_controller.has_method("set_rotation_speed"):
				camera_controller.set_rotation_speed(CAMERA_ROTATION_SPEED)
			if camera_controller.has_method("set_zoom_speed"):
				camera_controller.set_zoom_speed(CAMERA_ZOOM_SPEED)
			if camera_controller.has_method("set_zoom_limits"):
				camera_controller.set_zoom_limits(CAMERA_MIN_DISTANCE, CAMERA_MAX_DISTANCE)

			# Connect signals safely
			if camera_controller.has_signal("camera_animation_finished"):
				camera_controller.camera_animation_finished.connect(_on_camera_animation_finished)
			if camera_controller.has_signal("camera_reset_completed"):
				camera_controller.camera_reset_completed.connect(_on_camera_reset_completed)

			print("[INIT] Camera controller initialized and configured")
		else:
			push_error("[ERROR] Cannot initialize camera controller - no camera available")
	else:
		push_error("[ERROR] Failed to initialize CameraController")
		return


	var ui_layer = get_node_or_null("UI_Layer")
	if ui_layer:
		ui_layer.visible = true
		print("[INIT] UI_Layer visibility set to: ", ui_layer.visible)

	# Initialize object name label
	var safe_label = get_safe_object_label()
	if safe_label:
		safe_label.text = "Selected: None"
		print("[INIT] Object name label initialized")

	# Connect info panel signals
	var safe_info_panel = get_safe_info_panel()
	if safe_info_panel and safe_info_panel.has_signal("panel_closed"):
		safe_info_panel.panel_closed.connect(_on_info_panel_closed)
		safe_info_panel.visible = false
		print("[INIT] Info panel signals connected")

	# Connect selection manager signals
	var safe_selection_manager = get_safe_selection_manager()
	if safe_selection_manager:
		if safe_selection_manager.has_signal("structure_selected"):
			safe_selection_manager.structure_selected.connect(_on_structure_selected)
		if safe_selection_manager.has_signal("structure_deselected"):
			safe_selection_manager.structure_deselected.connect(_on_structure_deselected)

		# Configure selection manager with current highlight settings
		safe_selection_manager.set_highlight_color(highlight_color)
		safe_selection_manager.set_emission_energy(emission_energy)
		print("[INIT] Selection manager signals connected")


		var safe_brain_parent = get_safe_brain_model_parent()
		if safe_brain_parent and model_coordinator:
			if model_coordinator.has_method("set_model_parent"):
				model_coordinator.set_model_parent(safe_brain_parent)

			# Connect to ModelCoordinator signals
			if model_coordinator.has_signal("models_loaded"):
				model_coordinator.models_loaded.connect(_on_models_loaded)
			if model_coordinator.has_signal("model_load_failed"):
				model_coordinator.model_load_failed.connect(_on_model_load_failed)

			if model_coordinator.has_method("load_brain_models"):
				model_coordinator.load_brain_models()
			print("[INIT] Brain models loading initiated via ModelCoordinator")
	else:
		push_error("[ERROR] Failed to initialize model coordinator")
		return

	# Create model control panel
	if has_method("_setup_model_control_panel"):
		_setup_model_control_panel()
		print("[INIT] Model control panel setup complete")
	else:
		push_warning("[WARNING] Failed to setup model control panel")

	# Add debug ray visualization
	if has_method("_setup_debug_ray"):
		_setup_debug_ray()
		print("[INIT] Debug ray visualization setup complete")
	else:
		push_warning("[WARNING] Failed to setup debug ray")

	# Register debug commands
	if has_method("_register_debug_commands"):
		_register_debug_commands()
		print("[INIT] Debug commands registered")
	else:
		push_warning("[WARNING] Failed to register debug commands")

	# Start initial camera animation if available
	var safe_camera_controller = get_safe_camera_controller()
	if safe_camera_controller:
		safe_camera_controller.setup_initial_animation()
		print("[INIT] Initial camera animation started")

	# Print interaction instructions
	_print_interaction_instructions()


# Safe getter functions - these should always be used instead of direct access
	var recovered = get_node_or_null("Camera3D") as Camera3D
	if recovered:
		camera = recovered
		camera_backup = recovered
		return recovered

	return null


	var recovered = get_node_or_null("UI_Layer/ObjectNameLabel") as Label
	if recovered:
		object_name_label = recovered
		object_name_label_backup = recovered
		return recovered

	return null


	var recovered = get_node_or_null("UI_Layer/StructureInfoPanel")
	if recovered:
		info_panel = recovered
		info_panel_backup = recovered
		return recovered

	return null


	var recovered = get_node_or_null("BrainModel") as Node3D
	if recovered:
		brain_model_parent = recovered
		brain_model_parent_backup = recovered
		return recovered

	return null


	var current_time = Time.get_time_dict_from_system()
	var current_seconds = current_time.hour * 3600 + current_time.minute * 60 + current_time.second

	if current_seconds != last_fps_check:
		var fps = Engine.get_frames_per_second()
		if fps < fps_warning_threshold and fps > 0:
			print("[PERFORMANCE] Low FPS detected: ", fps)
		last_fps_check = current_seconds

	# Safe UI layer update
	var safe_info_panel = get_safe_info_panel()
	if safe_info_panel and safe_info_panel.has_method("update_ui"):
		safe_info_panel.update_ui()


	var safe_camera = get_safe_camera_controller()
	if safe_camera and safe_camera.has_method("update_camera"):
		safe_camera.update_camera(delta)
	elif not safe_camera:
		handle_camera_error()


	var camera_handled = false
	var safe_camera_controller = get_safe_camera_controller()
	if safe_camera_controller:
		camera_handled = safe_camera_controller.handle_camera_input(event)

	# If camera controller handled the input, mark as handled and return
	if camera_handled:
		get_viewport().set_input_as_handled()
		return

	# Handle non-camera input (selection)
	if event is InputEventMouseButton:
		# Handle left mouse click for selection
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var safe_selection_manager = get_safe_selection_manager()
			if safe_selection_manager:
				safe_selection_manager.handle_selection_at_position(event.position)
			else:
				handle_selection_error()
			get_viewport().set_input_as_handled()


# Error handling functions
	var safe_label = get_safe_object_label()
	if safe_label:
		safe_label.text = "Selected: " + structure_name
	print("Selected structure: " + structure_name)

	structure_selected.emit(structure_name)
	_display_structure_info(structure_name)


	var safe_label = get_safe_object_label()
	if safe_label:
		safe_label.text = "Selected: None"

	var safe_info_panel = get_safe_info_panel()
	if safe_info_panel:
		safe_info_panel.visible = false

	structure_deselected.emit()


	var safe_info_panel = get_safe_info_panel()
	if not safe_info_panel:
		print("WARNING: Info panel not found!")
		return

	# Make sure knowledge base is loaded
	if not knowledge_base or not knowledge_base.is_loaded:
		print("Warning: Knowledge base not loaded, cannot display structure info.")
		safe_info_panel.visible = false
		return

	print("Displaying info for structure: " + structure_name)

	# Try to find structure ID that matches or contains the mesh name
	var structure_id = _find_structure_id_by_name(structure_name)

	if structure_id.is_empty():
		print("No matching structure found in knowledge base for: " + structure_name)
		safe_info_panel.visible = false
		return

	print("Found structure ID: " + structure_id)

	# Get structure data and display it
	var structure_data = knowledge_base.get_structure(structure_id)
	if not structure_data.is_empty():
		print("Successfully retrieved structure data")

		# Ensure panel's parent (UI_Layer) is visible
		var ui_layer = get_node_or_null("UI_Layer")
		if ui_layer:
			ui_layer.visible = true

		# Explicitly set the panel to visible first
		safe_info_panel.visible = true

		# Call the display function
		if safe_info_panel.has_method("display_structure_data"):
			safe_info_panel.display_structure_data(structure_data)
	else:
		print("Failed to retrieve structure data for ID: " + structure_id)
		safe_info_panel.visible = false


		var mapped_id = neural_net.map_mesh_name_to_structure_id(mesh_name)
		if not mapped_id.is_empty():
			print("Found structure ID via neural net mapping: " + mapped_id)
			return mapped_id

	# Fallback: Convert mesh name to lowercase for case-insensitive matching
	var lower_mesh_name = mesh_name.to_lower()

	# Get all structure IDs
	var structure_ids = knowledge_base.get_all_structure_ids()

	# First, try exact match with display name
	for id in structure_ids:
		var structure = knowledge_base.get_structure(id)
		if structure.has("displayName") and structure.displayName.to_lower() == lower_mesh_name:
			return id

	# Next, try matching the ID directly
	if structure_ids.has(mesh_name):
		return mesh_name

	# Next, try partial match
	for id in structure_ids:
		var structure = knowledge_base.get_structure(id)
		if structure.has("displayName"):
			var display_name = structure.displayName.to_lower()
			if lower_mesh_name.contains(display_name) or display_name.contains(lower_mesh_name):
				return id

	return ""


# Setup functions (keeping existing implementations but adding error handling)
		var model_switcher = get_node("/root/ModelSwitcherGlobal")
		if model_switcher.has_signal("model_visibility_changed"):
			model_switcher.model_visibility_changed.connect(_on_model_visibility_changed)
		else:
			push_warning(
				"[MainSceneRobust] Warning: ModelSwitcherGlobal.model_visibility_changed signal not available"
			)
	else:
		push_warning("[MainSceneRobust] Warning: ModelSwitcherGlobal not available")

	# Connect to panel signals if they exist
	if model_control_panel.has_signal("model_selected"):
		model_control_panel.model_selected.connect(_on_model_selected)

	# Wait for models to be loaded with safe access
	if has_node("/root/ModelSwitcherGlobal"):
		var model_switcher = get_node("/root/ModelSwitcherGlobal")
		if model_switcher.has_method("get_model_names"):
			var model_names = model_switcher.get_model_names()
			if model_names.size() > 0:
				model_control_panel.setup_with_models(model_names)
			else:
				models_loaded.connect(
					func(loaded_model_names):
						model_control_panel.setup_with_models(loaded_model_names)
				)
		else:
			push_warning(
				"[MainSceneRobust] Warning: ModelSwitcherGlobal.get_model_names method not available"
			)
	else:
		models_loaded.connect(
			func(loaded_model_names): model_control_panel.setup_with_models(loaded_model_names)
		)


		var model_switcher = get_node("/root/ModelSwitcherGlobal")
		if model_switcher.has_method("toggle_model_visibility"):
			model_switcher.toggle_model_visibility(model_name)
		else:
			push_warning(
				"[MainSceneRobust] Warning: ModelSwitcherGlobal.toggle_model_visibility method not available"
			)
	else:
		push_warning(
			"[MainSceneRobust] Warning: ModelSwitcherGlobal not available for model selection"
		)


	var immediate_mesh = ImmediateMesh.new()
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(1, 0, 0, 1)
	material.emission_enabled = true
	material.emission = Color(1, 0, 0, 1)
	material.emission_energy_multiplier = 2.0

	var debug_ray_mesh = MeshInstance3D.new()
	debug_ray_mesh.mesh = immediate_mesh
	debug_ray_mesh.material_override = material
	add_child(debug_ray_mesh)

	debug_ray_mesh.visible = DEBUG_MODE


	var safe_camera_controller = get_safe_camera_controller()
	if safe_camera_controller:
		safe_camera_controller.reset_camera_position()
	else:
		print("Warning not available for reset")


		var model_switcher = get_node("/root/ModelSwitcherGlobal")
		if model_switcher.has_method("get_model_names"):
			var model_names = model_switcher.get_model_names()
			print("Registered models (", model_names.size(), "):")
			for model_name in model_names:
				if model_switcher.has_method("is_model_visible"):
					var model_visible = model_switcher.is_model_visible(model_name)
					print("  - ", model_name, " (visible: ", model_visible, ")")
				else:
					print("  - ", model_name, " (visibility check not available)")
		else:
			push_warning(
				"[MainSceneRobust] Warning: ModelSwitcherGlobal.get_model_names method not available"
			)
	else:
		push_warning("[MainSceneRobust] Warning: ModelSwitcherGlobal not available")


	var test_position = get_viewport().get_visible_rect().size / 2.0
	var safe_selection_manager = get_safe_selection_manager()
	if safe_selection_manager:
		safe_selection_manager.handle_selection_at_position(test_position)
	else:
		print("Warning not available for testing")
	print("Selection test completed at screen center")


@onready var camera: Camera3D = $Camera3D
@onready var object_name_label: Label = $UI_Layer/ObjectNameLabel
@onready var info_panel = $UI_Layer/StructureInfoPanel
@onready var brain_model_parent = $BrainModel

# Components (created dynamically with robust references)

func _ready() -> void:
	print("[INIT] Starting robust main scene initialization...")

	# Initialize with comprehensive error checking
	await initialize_safely()

	print("[INIT] Main scene initialization complete")


func _process(delta):
	"""Safe regular processing with error recovery and performance monitoring"""
	if not initialization_complete:
		return

	if error_recovery_active:
		return

	# Performance monitoring
	frame_count += 1
func _physics_process(delta):
	"""Safe physics processing with error recovery"""
	if not initialization_complete:
		return

	if error_recovery_active:
		return

	# Safe camera controller update
func _exit_tree():
	"""Clean up references when node is removed from tree"""
	camera = null
	object_name_label = null
	info_panel = null
	brain_model_parent = null
	selection_manager = null
	camera_controller = null
	camera_backup = null
	object_name_label_backup = null
	info_panel_backup = null
	brain_model_parent_backup = null
	selection_manager_backup = null
	camera_controller_backup = null
	initialization_complete = false

func initialize_safely():
	"""
	Safe initialization with proper error handling and recovery
	"""
	initialization_attempt_count += 1
	print("[INIT] Initialization attempt: ", initialization_attempt_count)

	if initialization_attempt_count > max_initialization_attempts:
		push_error("[CRITICAL] Maximum initialization attempts exceeded!")
		return

	# Initialize core node references first
	await initialize_core_nodes()
	await get_tree().process_frame

	# Initialize knowledge base and systems
	await initialize_systems()
	await get_tree().process_frame

	# Initialize components (CameraController, SelectionManager)
	await initialize_components()
	await get_tree().process_frame

	# Setup UI and connections
	await setup_ui_and_connections()
	await get_tree().process_frame

	# Initialize models and final setup
	await initialize_models_and_final_setup()
	await get_tree().process_frame

	initialization_complete = true
	print("[INIT] All systems initialized successfully")


func initialize_core_nodes():
	"""
	Initialize core node references with multiple fallback methods
	"""
	print("[INIT] Initializing core nodes...")

	# Initialize camera reference
	if not try_initialize_camera():
		push_error("[ERROR] Failed to initialize camera - critical failure!")
		return

	# Initialize UI label reference
	if not try_initialize_object_label():
		push_warning("[WARNING] Failed to initialize object label - UI limited!")

	# Initialize info panel reference
	if not try_initialize_info_panel():
		push_warning("[WARNING] Failed to initialize info panel - info display limited!")

	# Initialize brain model parent reference
	if not try_initialize_brain_model_parent():
		push_error("[ERROR] Failed to initialize brain model parent - model loading limited!")


func try_initialize_camera() -> bool:
	"""
	Robust camera initialization with multiple fallback methods
	"""
	print("[INIT] Initializing camera...")

	# Method 1: Try @onready reference
	if is_instance_valid(camera) and camera is Camera3D:
		camera_backup = camera
		print("[INIT] Camera found via @onready")
		return true

	# Method 2: Try direct path
func try_initialize_object_label() -> bool:
	"""
	Robust object label initialization
	"""
	print("[INIT] Initializing object label...")

	# Method 1: Try @onready reference
	if is_instance_valid(object_name_label) and object_name_label is Label:
		object_name_label_backup = object_name_label
		print("[INIT] Object label found via @onready")
		return true

	# Method 2: Try direct path
func try_initialize_info_panel() -> bool:
	"""
	Robust info panel initialization
	"""
	print("[INIT] Initializing info panel...")

	# Method 1: Try @onready reference
	if is_instance_valid(info_panel):
		info_panel_backup = info_panel
		print("[INIT] Info panel found via @onready")
		return true

	# Method 2: Try direct path
func try_initialize_brain_model_parent() -> bool:
	"""
	Robust brain model parent initialization
	"""
	print("[INIT] Initializing brain model parent...")

	# Method 1: Try @onready reference
	if is_instance_valid(brain_model_parent) and brain_model_parent is Node3D:
		brain_model_parent_backup = brain_model_parent
		print("[INIT] Brain model parent found via @onready")
		return true

	# Method 2: Try direct path
func initialize_systems():
	"""
	Initialize knowledge base, neural net, and other core systems
	"""
	print("[INIT] Initializing systems...")

	# Initialize knowledge base
	knowledge_base = AnatomicalKnowledgeDatabaseScript.new()
	if knowledge_base:
		add_child(knowledge_base)
		knowledge_base.load_knowledge_base()
		print("[INIT] Knowledge base initialized and loaded")
	else:
		push_error("[ERROR] Failed to initialize knowledge base")
		return

	# Initialize neural network module
	neural_net = BrainVisualizationCoreScript.new()
	if neural_net:
		add_child(neural_net)
		print("[INIT] Neural network module initialized")
	else:
		push_error("[ERROR] Failed to initialize neural network")
		return

	# Initialize model switcher
	model_switcher = ModelVisibilityManagerScript.new()
	if model_switcher:
		add_child(model_switcher)
		print("[INIT] Model switcher initialized")
	else:
		push_error("[ERROR] Failed to initialize model switcher")
		return


func initialize_components():
	"""
	Initialize core components with robust error handling
	"""
	print("[INIT] Initializing components...")

	# Create and initialize SelectionManager
	selection_manager = BrainStructureSelectionManagerScript.new()
	if selection_manager:
		add_child(selection_manager)
		selection_manager_backup = selection_manager
		print("[INIT] SelectionManager initialized and added to scene")
	else:
		push_error("[ERROR] Failed to initialize SelectionManager")
		return

	# Create and initialize CameraController
	camera_controller = CameraControllerScene.new()
	if camera_controller:
		add_child(camera_controller)
		camera_controller_backup = camera_controller
		print("[INIT] CameraController initialized and added to scene")

		# Initialize camera controller if camera is available
func setup_ui_and_connections():
	"""
	Setup UI elements and signal connections
	"""
	print("[INIT] Setting up UI and connections...")

	# Setup UI layer visibility
func initialize_models_and_final_setup():
	"""
	Initialize models and complete final setup steps
	"""
	print("[INIT] Initializing models and final setup...")

	# Initialize model coordinator
	model_coordinator = ModelCoordinatorScene.new()
	if model_coordinator:
		add_child(model_coordinator)

		# Setup model coordinator
func get_safe_camera() -> Camera3D:
	"""Returns a valid camera reference or null"""
	if is_instance_valid(camera):
		return camera

	if is_instance_valid(camera_backup):
		camera = camera_backup
		return camera

	# Try to recover the reference
func get_safe_object_label() -> Label:
	"""Returns a valid object label reference or null"""
	if is_instance_valid(object_name_label):
		return object_name_label

	if is_instance_valid(object_name_label_backup):
		object_name_label = object_name_label_backup
		return object_name_label

	# Try to recover the reference
func get_safe_info_panel():
	"""Returns a valid info panel reference or null"""
	if is_instance_valid(info_panel):
		return info_panel

	if is_instance_valid(info_panel_backup):
		info_panel = info_panel_backup
		return info_panel

	# Try to recover the reference
func get_safe_brain_model_parent() -> Node3D:
	"""Returns a valid brain model parent reference or null"""
	if is_instance_valid(brain_model_parent):
		return brain_model_parent

	if is_instance_valid(brain_model_parent_backup):
		brain_model_parent = brain_model_parent_backup
		return brain_model_parent

	# Try to recover the reference
func get_safe_selection_manager():
	"""Returns a valid selection manager reference or null"""
	if is_instance_valid(selection_manager):
		return selection_manager

	if is_instance_valid(selection_manager_backup):
		selection_manager = selection_manager_backup
		return selection_manager

	# Try to find it in children
	for child in get_children():
		if child.get_script() == BrainStructureSelectionManagerScript:
			selection_manager = child
			selection_manager_backup = child
			return child

	return null


func get_safe_camera_controller():
	"""Returns a valid camera controller reference or null"""
	if is_instance_valid(camera_controller):
		return camera_controller

	if is_instance_valid(camera_controller_backup):
		camera_controller = camera_controller_backup
		return camera_controller

	# Try to find it in children
	for child in get_children():
		if child.get_script() == CameraControllerScene:
			camera_controller = child
			camera_controller_backup = child
			return child

	return null


# Process functions with safe execution and performance monitoring
func handle_camera_error():
	"""Handle camera controller errors gracefully"""
	if error_recovery_active:
		return

	error_recovery_active = true
	print("[ERROR] Camera controller lost - attempting recovery...")

	# Attempt recovery
	await get_tree().process_frame
	await initialize_components()

	# Reset error recovery flag after a delay
	await get_tree().create_timer(1.0).timeout
	error_recovery_active = false


func handle_selection_error():
	"""Handle selection manager errors gracefully"""
	if error_recovery_active:
		return

	error_recovery_active = true
	print("[ERROR] Selection manager lost - attempting recovery...")

	# Attempt recovery
	await get_tree().process_frame
	await initialize_components()

	# Reset error recovery flag after a delay
	await get_tree().create_timer(1.0).timeout
	error_recovery_active = false


# Signal handlers and other functions (keeping existing implementations but making them safer)

func _input(event: InputEvent) -> void:
	"""Safe input handling with error recovery"""
	if not initialization_complete:
		return

	if error_recovery_active:
		return

	# First, try to handle camera input
func _on_camera_animation_finished() -> void:
	print("Camera reveal animation completed")


func _on_camera_reset_completed() -> void:
	print("Camera reset completed")


func _on_models_loaded(model_names: Array) -> void:
	print("Models loaded successfully: " + str(model_names))
	models_loaded.emit(model_names)


func _on_model_load_failed(model_path: String, error: String) -> void:
	print("ERROR: Failed to load model " + model_path + ": " + error)


func _on_structure_selected(structure_name: String, _mesh: MeshInstance3D) -> void:
func _on_structure_deselected() -> void:
func _on_info_panel_closed() -> void:
	pass


# Helper functions (keeping existing implementations but adding safety checks)
func _display_structure_info(structure_name: String) -> void:
func _find_structure_id_by_name(mesh_name: String) -> String:
	# First try using our neural net mapping function
	if neural_net != null:
func _setup_model_control_panel() -> void:
	model_control_panel = get_node_or_null("UI_Layer/ModelControlPanel")
	if not model_control_panel:
		print("ERROR: ModelControlPanel not found in scene")
		return

	print("Using model control panel from scene")

	# Connect to model switcher signals if they exist with safe access
	if has_node("/root/ModelSwitcherGlobal"):
func _on_model_selected(model_name: String) -> void:
	if has_node("/root/ModelSwitcherGlobal"):
func _on_model_visibility_changed(model_name: String, model_is_visible: bool) -> void:
	if model_control_panel and model_control_panel.has_method("update_button_state"):
		model_control_panel.update_button_state(model_name, model_is_visible)


func _setup_debug_ray() -> void:
func _register_debug_commands() -> void:
	if not OS.is_debug_build():
		return

	if not is_instance_valid(DebugCmd):
		print("Warning: DebugCmd autoload not available")
		return

	DebugCmd.register_command(
		"reset_camera", _debug_reset_camera, "Reset camera to default position"
	)
	DebugCmd.register_command("list_models", _debug_list_models, "List all registered brain models")
	DebugCmd.register_command(
		"test_selection", _debug_test_selection, "Test structure selection system"
	)
	DebugCmd.register_command("recovery_test", _debug_recovery_test, "Test error recovery system")
	print("Brain scene debug commands registered")


func _debug_reset_camera() -> void:
func _debug_list_models() -> void:
	if has_node("/root/ModelSwitcherGlobal"):
func _debug_test_selection() -> void:
	print("Testing selection system...")
func _debug_recovery_test() -> void:
	print("Testing error recovery system...")
	error_recovery_active = true
	await get_tree().create_timer(2.0).timeout
	error_recovery_active = false
	print("Error recovery test completed")


func _print_interaction_instructions() -> void:
	print("INTERACTION INSTRUCTIONS:")
	print("- Left-click to select brain structures")
	print("- Camera rotation:")
	print("  - Middle-click + drag: Rotate view")
	print("  - Cmd+Left-click + drag (macOS): Rotate view")
	print("  - Ctrl+Left-click + drag (PC): Rotate view")
	print("- Zoom controls:")
	print("  - Mouse wheel or trackpad scroll: Zoom in/out")
	print("  - Hold Shift while scrolling: Slow zoom")
	print("- Camera movement modifiers:")
	print("  - Hold Shift while dragging: Slow movement")
	print("  - Hold Alt while dragging: Fast movement")
	print("- Keyboard controls:")
	print("  - Arrow keys/WASD: Rotate camera")
	print("  - Q/- : Zoom out")
	print("  - E/+ : Zoom in")
	print("  - R: Reset camera view")


# Emergency cleanup function
