extends Node3D

# Import SafeAutoloadAccess for safer autoload handling

signal structure_selected(structure_name: String)
signal structure_deselected
signal models_loaded(model_names: Array)


const SafeAutoloadAccess = prepreload("res://ui/components/core/SafeAutoloadAccess.gd")

# Preload custom classes
const CameraControllerScene = prepreload("res://core/interaction/CameraBehaviorController.gd")
const ModelCoordinatorScene = prepreload("res://core/models/ModelRegistry.gd")

# Constants
const RAY_LENGTH: float = 1000.0
const CAMERA_ROTATION_SPEED: float = 0.01  # Speed of rotation with middle mouse button
const CAMERA_ZOOM_SPEED: float = 0.5  # Increased for better responsiveness
const CAMERA_MIN_DISTANCE: float = 2.0  # Closer minimum zoom
const CAMERA_MAX_DISTANCE: float = 25.0  # Further maximum zoom
const DEBUG_MODE: bool = true  # Set to true to enable debugging features

# Export variables for customizing highlight appearance

@export var highlight_color: Color = Color(0.0, 1.0, 0.0, 1.0)  # Green highlight
@export var emission_energy: float = 0.5

# Camera control variables (now handled by CameraController)
# var camera_distance: float = 10.0
# var camera_rotation_x: float = 0.3  # Initial vertical angle
# var camera_rotation_y: float = 0.0  # Initial horizontal angle
# var is_rotating: bool = false
# var last_mouse_position: Vector2 = Vector2.ZERO

# Continuous camera movement variables (now handled by CameraController)
# var camera_input_vector = Vector2.ZERO
# var camera_zoom_input = 0.0
# var continuous_movement_active = false

# Node references

var selection_manager = null
var camera_controller = null

# System references
var knowledge_base = null
var neural_net = null
var model_control_panel = null
var model_switcher = null
var model_coordinator = null

# Selection tracking variables (now handled by SelectionManager)
# var current_selected_mesh: MeshInstance3D = null
# var original_material: Material = null

# Signals
	var debug_cmd = SafeAutoloadAccess.get_autoload("DebugCmd")
	if not debug_cmd:
		print("Warning: DebugCmd autoload not available")
		return

	# Register scene-specific debug commands
	if debug_cmd.has_method("register_command"):
		debug_cmd.register_command(
			"reset_camera", _debug_reset_camera, "Reset camera to default position"
		)
		debug_cmd.register_command(
			"toggle_debug_ray", _debug_toggle_ray, "Toggle debug ray visualization"
		)
		debug_cmd.register_command(
			"list_models", _debug_list_models, "List all registered brain models"
		)
		debug_cmd.register_command(
			"test_selection", _debug_test_selection, "Test structure selection system"
		)
	print("Brain scene debug commands registered")


# Debug command implementations
	var model_names = ModelSwitcherGlobal.get_model_names()
	print("Registered models (" + str(model_names.size()) + "):")
	for model_name in model_names:
		var model_visible = ModelSwitcherGlobal.is_model_visible(model_name)
		print("  - " + model_name + " (visible: " + str(model_visible) + ")")


	var test_position = get_viewport().get_visible_rect().size / 2.0
	if selection_manager:
		selection_manager.handle_selection_at_position(test_position)
	else:
		print("Warning: BrainStructureSelectionManager not available for testing")
	print("Selection test completed at screen center")


# Setup the model control panel
	var structure_id = _find_structure_id_by_name(structure_name)

	if structure_id.is_empty():
		print("No matching structure found in knowledge base for: " + structure_name)
		info_panel.visible = false
		return

	print("Found structure ID: " + structure_id)

	# Get structure data and display it
	var structure_data = knowledge_base.get_structure(structure_id)
	if not structure_data.is_empty():
		print("Successfully retrieved structure data")

		# Ensure panel's parent (UI_Layer) is visible
		$UI_Layer.visible = true

		# Explicitly set the panel to visible first
		info_panel.visible = true

		# Call the display function
		info_panel.display_structure_data(structure_data)
	else:
		print("Failed to retrieve structure data for ID: " + structure_id)
		info_panel.visible = false


# Find a structure ID by name matching (helper function)
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

	# Next, try partial match (if mesh name contains structure name or vice versa)
	for id in structure_ids:
		var structure = knowledge_base.get_structure(id)
		if structure.has("displayName"):
			var display_name = structure.displayName.to_lower()
			if lower_mesh_name.contains(display_name) or display_name.contains(lower_mesh_name):
				return id

	# No match found
	return ""


# Process function for input handling
	var camera_handled = false
	if camera_controller:
		camera_handled = camera_controller.handle_camera_input(event)

	# If camera controller handled the input, mark as handled and return
	if camera_handled:
		get_viewport().set_input_as_handled()
		return

	# Handle non-camera input (selection)
	if event is InputEventMouseButton:
		# Handle left mouse click for selection
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if selection_manager:
				selection_manager.handle_selection_at_position(event.position)
			else:
				print("Warning: BrainStructureSelectionManager not available")
			get_viewport().set_input_as_handled()


# Update camera transform based on orbital parameters (DEPRECATED - now handled by CameraController)
# func _update_camera_transform() -> void:
#	# Calculate new camera position using spherical coordinates
#	var x = camera_distance * sin(camera_rotation_x) * sin(camera_rotation_y)
#	var y = camera_distance * cos(camera_rotation_x)
#	var z = camera_distance * sin(camera_rotation_x) * cos(camera_rotation_y)
#
#	# Set camera position - use global position for absolute positioning
#	camera.global_position = Vector3(x, y, z)
#
#	# Look at center of brain model
#	camera.look_at(brain_model_parent.global_position)

# Camera animation variables (DEPRECATED - now handled by CameraController)
# var target_rotation_x: float = 0.3
# var target_rotation_y: float = 0.0
# var animation_progress: float = 0.0
# var animation_duration: float = 2.0  # Seconds
# var animation_active: bool = false

# Animate camera to smoothly transition to default view (DEPRECATED - now handled by CameraController)
# func _animate_camera() -> void:
#	# Cancel animation if user is manually rotating
#	if is_rotating:
#		animation_active = false
#		return
#
#	if not animation_active:
#		animation_active = true
#		animation_progress = 0.0
#
#	# Progress the animation
#	animation_progress += 0.02  # Timer wait time
#	var t = min(animation_progress / animation_duration, 1.0)
#
#	# Use smoothstep for easing
#	var ease_factor = t * t * (3.0 - 2.0 * t)
#
#	# Interpolate camera rotation
#	camera_rotation_x = lerp(camera_rotation_x, target_rotation_x, ease_factor * 0.05)
#	camera_rotation_y = lerp(camera_rotation_y, target_rotation_y, ease_factor * 0.05)
#
#	# Update camera
#	_update_camera_transform()
#
#	# Stop animation when done
#	if t >= 1.0:
#		animation_active = false

# Debug ray visualization for raycasting
var debug_ray_mesh: MeshInstance3D = null
var debug_ray_visible: bool = false


# Setup debug ray visualization for easier debugging
	var immediate_mesh = ImmediateMesh.new()
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(1, 0, 0, 1)  # Red
	material.emission_enabled = true
	material.emission = Color(1, 0, 0, 1)
	material.emission_energy = 2.0

	# Create mesh instance
	debug_ray_mesh = MeshInstance3D.new()
	debug_ray_mesh.mesh = immediate_mesh
	debug_ray_mesh.material_override = material
	add_child(debug_ray_mesh)

	# Set visibility based on debug mode
	debug_ray_visible = DEBUG_MODE
	debug_ray_mesh.visible = debug_ray_visible

@onready var camera: Camera3D = $Camera3D
@onready var object_name_label: Label = $UI_Layer/ObjectNameLabel
@onready var info_panel = $UI_Layer/StructureInfoPanel  # Removed type annotation
@onready var brain_model_parent = $BrainModel
# Components (created dynamically)

func _ready() -> void:
	# Initialize the UI label
	object_name_label.text = "Selected: None"
	print("Main scene initialized.")

	# Initialize knowledge base
	knowledge_base = AnatomicalKnowledgeDatabase.new()
	add_child(knowledge_base)
	knowledge_base.load_knowledge_base()
	print("Knowledge base initialized and loaded.")

	# Initialize neural network module
	neural_net = BrainVisualizationCore.new()
	add_child(neural_net)
	print("Neural network module initialized.")

	# Initialize model switcher
	model_switcher = ModelVisibilityManager.new()
	add_child(model_switcher)
	print("Model switcher initialized.")

	# Setup UI layer
	$UI_Layer.visible = true  # Ensure UI layer is visible
	print("DEBUG: UI_Layer visibility set to: " + str($UI_Layer.visible))

	# Connect info panel signals
	if info_panel and info_panel.has_signal("panel_closed"):
		info_panel.panel_closed.connect(_on_info_panel_closed)

	# Hide info panel until needed
	if info_panel:
		info_panel.visible = false
		print("DEBUG: Info panel reference valid: " + str(info_panel != null))

	print("DEBUG: Object name label reference valid: " + str(object_name_label != null))

	# Initialize model coordinator
	model_coordinator = ModelCoordinatorScene.new()
	add_child(model_coordinator)

	# Setup and load 3D brain models using ModelCoordinator
	_setup_model_coordinator()
	model_coordinator.load_brain_models()
	print("Brain models loading initiated via ModelCoordinator.")

	# Create model control panel
	_setup_model_control_panel()

	# Add debug ray visualization
	_setup_debug_ray()

	# Print interaction instructions
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

	# Register debug commands
	_register_debug_commands()

	# Initialize components
	_initialize_components()

	# Connect selection manager signals
	_connect_selection_signals()

	# Initialize camera controller
	_setup_camera_controller()


# Initialize core components (SelectionManager and CameraController)
func _initialize_components() -> void:
	# Create and initialize SelectionManager
	selection_manager = BrainStructureSelectionManager.new()
	add_child(selection_manager)
	print("SelectionManager initialized and added to scene")

	# Create and initialize CameraController
	camera_controller = CameraBehaviorController.new()
	add_child(camera_controller)
	print("CameraController initialized and added to scene")


# Setup model coordinator

func _setup_model_coordinator() -> void:
	if model_coordinator:
		# Set the parent node where models will be instantiated
		model_coordinator.set_model_parent(brain_model_parent)

		# Connect to ModelCoordinator signals
		model_coordinator.models_loaded.connect(_on_models_loaded)
		model_coordinator.model_load_failed.connect(_on_model_load_failed)

		print("ModelCoordinator configured and signals connected")
	else:
		print("ERROR: ModelCoordinator node not found")


# Handle models loaded from ModelCoordinator
func _on_models_loaded(model_names: Array) -> void:
	print("Models loaded successfully: " + str(model_names))
	# Emit the legacy signal for compatibility
	models_loaded.emit(model_names)


# Handle model load failure from ModelCoordinator
func _on_model_load_failed(model_path: String, error: String) -> void:
	print("ERROR: Failed to load model " + model_path + ": " + error)


# Connect selection manager signals
func _connect_selection_signals() -> void:
	if selection_manager:
		selection_manager.structure_selected.connect(_on_structure_selected)
		selection_manager.structure_deselected.connect(_on_structure_deselected)

		# Configure selection manager with current highlight settings
		selection_manager.set_highlight_color(highlight_color)
		selection_manager.set_emission_energy(emission_energy)
		print("Selection manager signals connected")
	else:
		print("Warning: BrainStructureSelectionManager node not found")


# Setup camera controller
func _setup_camera_controller() -> void:
	if camera_controller:
		# Initialize with camera and target references
		camera_controller.initialize(camera, brain_model_parent)

		# Configure camera controller settings
		camera_controller.set_rotation_speed(CAMERA_ROTATION_SPEED)
		camera_controller.set_zoom_speed(CAMERA_ZOOM_SPEED)
		camera_controller.set_zoom_limits(CAMERA_MIN_DISTANCE, CAMERA_MAX_DISTANCE)

		# Connect signals
		camera_controller.camera_animation_finished.connect(_on_camera_animation_finished)
		camera_controller.camera_reset_completed.connect(_on_camera_reset_completed)

		# Start initial reveal animation
		camera_controller.setup_initial_animation()

		print("Camera controller initialized and configured")
	else:
		print("Warning: CameraBehaviorController node not found")


# Handle camera animation finished
func _on_camera_animation_finished() -> void:
	print("Camera reveal animation completed")


# Handle camera reset completed
func _on_camera_reset_completed() -> void:
	print("Camera reset completed")


# Register debug commands for this scene
func _register_debug_commands() -> void:
	# Only register debug commands in debug builds
	if not OS.is_debug_build():
		return

	# Check if DebugCmd autoload is available with safe access
func _debug_reset_camera() -> void:
	if camera_controller:
		camera_controller.reset_camera_position()
	else:
		print("Warning: CameraBehaviorController not available for reset")


func _debug_toggle_ray() -> void:
	if debug_ray_mesh:
		debug_ray_visible = !debug_ray_visible
		debug_ray_mesh.visible = debug_ray_visible
		print("Debug ray visibility: " + str(debug_ray_visible))


func _debug_list_models() -> void:
func _debug_test_selection() -> void:
	print("Testing selection system...")
func _setup_model_control_panel() -> void:
	# Check if model_control_panel is already set up from scene
	model_control_panel = $UI_Layer/ModelControlPanel
	if not model_control_panel:
		print("ERROR: ModelControlPanel not found in scene")
		return

	print("Using model control panel from scene")

	# Connect to model switcher signals if they exist
	if ModelSwitcherGlobal.has_signal("model_visibility_changed"):
		ModelSwitcherGlobal.model_visibility_changed.connect(_on_model_visibility_changed)

	# Connect to panel signals if they exist
	if model_control_panel.has_signal("model_selected"):
		model_control_panel.model_selected.connect(_on_model_selected)

	# Wait for models to be loaded
	if ModelSwitcherGlobal.get_model_names().size() > 0:
		# Models already loaded, set up panel
		model_control_panel.setup_with_models(ModelSwitcherGlobal.get_model_names())
	else:
		# Connect to models_loaded signal to set up panel when models are loaded
		models_loaded.connect(func(model_names): model_control_panel.setup_with_models(model_names))

	print("Model control panel set up")


# Handle structure selection from SelectionManager
func _on_structure_selected(structure_name: String, _mesh: MeshInstance3D) -> void:
	# Update UI
	object_name_label.text = "Selected: " + structure_name
	print("Selected structure: " + structure_name)

	# Emit signal for other systems that might need it
	structure_selected.emit(structure_name)

	# Display structure information if available
	_display_structure_info(structure_name)


# Handle structure deselection from SelectionManager
func _on_structure_deselected() -> void:
	object_name_label.text = "Selected: None"
	if info_panel:
		info_panel.visible = false
	structure_deselected.emit()


# Handle model selected from the UI
func _on_model_selected(model_name: String) -> void:
	# Toggle visibility of the model
	ModelSwitcherGlobal.toggle_model_visibility(model_name)


# Handle model visibility change from the model switcher
func _on_model_visibility_changed(model_name: String, model_is_visible: bool) -> void:
	# Update UI
	if model_control_panel:
		model_control_panel.update_button_state(model_name, model_is_visible)


# Load 3D brain models from assets/models/ directory (DEPRECATED - now handled by ModelCoordinator)
# func _load_brain_models() -> void:
#	print("DEBUG: Starting to load brain models...")
#
#	# Get the brain model parent node
#	if not brain_model_parent:
#		print("ERROR: BrainModel node not found in scene")
#		return
#	else:
#		print("DEBUG: BrainModel node found at position " + str(brain_model_parent.global_position))
#
#	# Define the models to load
#	var models_to_load = [
#		{
#			"path": "res://assets/models/Half_Brain.glb",
#			"position": Vector3(0, 0, 0),
#			"rotation": Vector3(0, 180, 0),  # Rotate 180 degrees to face camera
#			"scale": Vector3(0.7, 0.7, 0.7)  # Increase scale to 70%
#		},
#		{
#			"path": "res://assets/models/Internal_Structures.glb",
#			"position": Vector3(0, 0, 0),
#			"rotation": Vector3(0, 180, 0),  # Rotate 180 degrees to face camera
#			"scale": Vector3(0.7, 0.7, 0.7)  # Increase scale to 70%
#		},
#		{
#			"path": "res://assets/models/Brainstem(Solid).glb",
#			"position": Vector3(0, 0, 0),
#			"rotation": Vector3(0, 180, 0),  # Rotate 180 degrees to face camera
#			"scale": Vector3(0.7, 0.7, 0.7)  # Increase scale to 70%
#		}
#	]
#
#	print("DEBUG: Will attempt to load " + str(models_to_load.size()) + " models")
#
#	# Track successful loads
#	var successful_loads = 0
#	var model_names = []
#
#	# First remove any existing models
#	for child in brain_model_parent.get_children():
#		brain_model_parent.remove_child(child)
#		child.queue_free()
#
#	# Load each model
#	for model_info in models_to_load:
#		print("DEBUG: Processing model: " + model_info.path)
#
#		# Check if the file exists
#		if not ResourceLoader.exists(model_info.path):
#			print("ERROR: Model file not found: " + model_info.path)
#			continue
#		else:
#			print("DEBUG: Model file found: " + model_info.path)
#
#		# Load the scene
#		var model_scene = load(model_info.path)
#		if not model_scene:
#			print("ERROR: Failed to load model: " + model_info.path)
#			continue
#		else:
#			print("DEBUG: Model scene loaded successfully")
#
#		# Instantiate the scene
#		var model_instance = model_scene.instantiate()
#		if not model_instance:
#			print("ERROR: Failed to instantiate model: " + model_info.path)
#			continue
#		else:
#			print("DEBUG: Model instantiated with type: " + model_instance.get_class())
#
#			# List children to understand model structure
#			var child_count = model_instance.get_child_count()
#			print("DEBUG: Model has " + str(child_count) + " direct children")
#			for i in range(child_count):
#				var child = model_instance.get_child(i)
#				print("DEBUG: Child " + str(i) + ": " + child.get_class() + " named '" + child.name + "'")
#
#				# If the child is a MeshInstance3D, print its material info
#				if child is MeshInstance3D and child.mesh != null:
#					var surface_count = child.mesh.get_surface_count()
#					print("DEBUG: MeshInstance '" + child.name + "' has " + str(surface_count) + " surfaces")
#
#					for s in range(surface_count):
#						var material = child.mesh.surface_get_material(s)
#						if material:
#							print("DEBUG: Surface " + str(s) + " has material of type: " + material.get_class())
#						else:
#							print("DEBUG: Surface " + str(s) + " has no material")
#
#		# Set transform
#		model_instance.position = model_info.position
#		model_instance.rotation_degrees = model_info.rotation
#		model_instance.scale = model_info.scale
#
#		# Create a friendly model name
#		var model_name = model_info.path.get_file().replace(".glb", "").replace("(Solid)", "")
#
#		# Add as child of brain model parent
#		brain_model_parent.add_child(model_instance)
#		print("DEBUG: Added model to scene: " + model_info.path.get_file())
#		successful_loads += 1
#
#		# Set up collision for all MeshInstance3D nodes in the model
#		_setup_mesh_collisions(model_instance)
#
#		# Register model with model switcher
#		ModelSwitcherGlobal.register_model(model_instance, model_name)
#		model_names.append(model_name)
#
#	print("DEBUG: Successfully loaded " + str(successful_loads) + " of " + str(models_to_load.size()) + " models")
#
#	# Emit signal that models are loaded
#	models_loaded.emit(model_names)

# Set up collision bodies for mesh instances (DEPRECATED - now handled by ModelCoordinator)
# func _setup_mesh_collisions(node: Node) -> void:
#	# Process this node if it's a MeshInstance3D
#	if node is MeshInstance3D and node.mesh != null:
#		# Check if it already has a StaticBody3D parent
#		var already_has_collision = false
#		for child in node.get_children():
#			if child is StaticBody3D:
#				already_has_collision = true
#				break
#
#		# If no collision body exists, create one
#		if not already_has_collision:
#			var static_body = StaticBody3D.new()
#			node.add_child(static_body)
#
#			# Create collision shape
#			var collision_shape = CollisionShape3D.new()
#			static_body.add_child(collision_shape)
#
#			# Create a shape that matches the mesh
#			var shape = node.mesh.create_trimesh_shape()
#			collision_shape.shape = shape
#
#			print("DEBUG: Added collision to: " + node.name)
#
#			# Check if the mesh has a material, if not add a default one
#			var needs_default_material = true
#
#			for i in range(node.mesh.get_surface_count()):
#				if node.mesh.surface_get_material(i) != null:
#					needs_default_material = false
#					break
#
#			if needs_default_material:
#				print("DEBUG: Adding default material to: " + node.name)
#				var default_material = StandardMaterial3D.new()
#				default_material.albedo_color = Color(0.9, 0.9, 0.9, 1.0)
#				default_material.metallic = 0.1
#				default_material.roughness = 0.7
#				node.set_surface_override_material(0, default_material)
#
#	# Check all children recursively
#	for child in node.get_children():
#		_setup_mesh_collisions(child)


# Handle info panel closed signal
func _on_info_panel_closed() -> void:
	# Optional: you can add additional logic here if needed
	pass


# Event handlers and helper functions for camera, selection, rendering, etc. remain the same
# (Keeping these sections unchanged to avoid adding unneeded complexity to this demo)

# Handle selection (DEPRECATED - now handled by SelectionManager)
# func _handle_selection(click_position: Vector2) -> void:
#	print("DEBUG: Handling selection at position " + str(click_position))
#	# Clear previous selection
#	if current_selected_mesh != null:
#		if current_selected_mesh.mesh and current_selected_mesh.mesh.get_surface_count() > 1:
#			for surface_idx in range(current_selected_mesh.mesh.get_surface_count()):
#				current_selected_mesh.set_surface_override_material(surface_idx, null)
#			current_selected_mesh.set_surface_override_material(0, original_material)
#		else:
#			current_selected_mesh.set_surface_override_material(0, original_material)
#
#		current_selected_mesh = null
#		original_material = null
#
#	# Cast ray from camera through click position
#	var from = camera.project_ray_origin(click_position)
#	var to = from + camera.project_ray_normal(click_position) * RAY_LENGTH
#
#	var space_state = get_world_3d().direct_space_state
#	var ray_params = PhysicsRayQueryParameters3D.create(from, to)
#	# Configure collision mask to detect all objects
#	ray_params.collision_mask = 0xFFFFFFFF  # All bits set, detect all layers
#
#	# Try ray cast
#	var result = space_state.intersect_ray(ray_params)
#
#	# Process selection result
#	if not result.is_empty():
#		print("DEBUG: Ray hit object: " + str(result.collider.name))
#
#		# Handle both direct mesh instance hits and static body hits
#		var mesh_instance = null
#		if result.collider is MeshInstance3D:
#			mesh_instance = result.collider
#		elif result.collider is StaticBody3D:
#			# Find parent mesh instance
#			if result.collider.get_parent() is MeshInstance3D:
#				mesh_instance = result.collider.get_parent()
#
#		if mesh_instance != null:
#			# Update selection variables
#			current_selected_mesh = mesh_instance
#
#			# Get original material
#			var current_material = current_selected_mesh.get_surface_override_material(0)
#			if current_material == null and current_selected_mesh.mesh != null:
#				current_material = current_selected_mesh.mesh.surface_get_material(0)
#
#			# Handle case where no material exists
#			if current_material == null:
#				current_material = StandardMaterial3D.new()
#				current_material.albedo_color = Color(0.8, 0.8, 0.8, 1.0)
#
#			# Store original material
#			original_material = current_material.duplicate()
#
#			# Create highlight material
#			var highlight_material = StandardMaterial3D.new()
#			highlight_material.albedo_color = highlight_color
#			highlight_material.emission_enabled = true
#			highlight_material.emission = highlight_color
#			highlight_material.emission_energy = emission_energy
#
#			# Apply highlight to all surfaces if there are multiple
#			if current_selected_mesh.mesh and current_selected_mesh.mesh.get_surface_count() > 1:
#				for surface_idx in range(current_selected_mesh.mesh.get_surface_count()):
#					current_selected_mesh.set_surface_override_material(surface_idx, highlight_material)
#			else:
#				current_selected_mesh.set_surface_override_material(0, highlight_material)
#
#			# Update UI
#			var structure_name = current_selected_mesh.name
#			object_name_label.text = "Selected: " + structure_name
#			print("Selected structure: " + structure_name)
#
#			# Emit signal
#			structure_selected.emit(structure_name)
#
#			# Display structure information if available
#			_display_structure_info(structure_name)
#			return
#
#	# If we reach here, nothing was selected
#	object_name_label.text = "Selected: None"
#	if info_panel:
#		info_panel.visible = false
#	structure_deselected.emit()


# Display structure information in the info panel
func _display_structure_info(structure_name: String) -> void:
	if not info_panel:
		print("WARNING: Info panel not found!")
		return

	# Make sure knowledge base is loaded
	if not knowledge_base or not knowledge_base.is_loaded:
		print("Warning: Knowledge base not loaded, cannot display structure info.")
		info_panel.visible = false
		return

	print("Displaying info for structure: " + structure_name)

	# Try to find structure ID that matches or contains the mesh name
func _find_structure_id_by_name(mesh_name: String) -> String:
	# First try using our neural net mapping function
	if neural_net != null:
func _input(event: InputEvent) -> void:
	# First, try to handle camera input
func _setup_debug_ray() -> void:
	# Create ray mesh
