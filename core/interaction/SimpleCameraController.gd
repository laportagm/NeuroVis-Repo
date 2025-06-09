## SimpleCameraController.gd
## Medical education camera controller for NeuroVis brain anatomy visualization
##
## This enhanced camera system provides standardized anatomical viewing angles
## essential for medical education, including sagittal, coronal, and axial views.
## Designed for both individual study and classroom demonstration scenarios.
##
## Medical Conventions:
## - Superior: Top of the brain (towards skull)
## - Inferior: Bottom of the brain (towards spine)
## - Anterior: Front of the brain (towards face)
## - Posterior: Back of the brain (towards occipital)
## - Left/Right: Patient's perspective (radiological convention)
##
## @tutorial: Medical camera navigation for neuroanatomy education
## @version: 2.0 - Enhanced with medical education features

class_name SimpleCameraController
extends Node

# ===== SIGNALS =====
signal camera_moved
signal zoom_changed(new_distance: float)
signal view_changed(view_name: String)
signal focus_completed(structure_name: String)
signal transition_started(to_view: String)
signal transition_completed

# ===== CONSTANTS =====
# Navigation speeds
const ZOOM_SPEED: float = 0.1
const ROTATION_SPEED: float = 0.01
const PAN_SPEED: float = 0.001
const SMOOTH_ZOOM_SPEED: float = 3.0
const TRANSITION_DURATION: float = 1.5  # Seconds for smooth transitions

# Distance constraints for medical viewing
const MIN_DISTANCE: float = 1.0  # Close enough to see 5mm structures
const MAX_DISTANCE: float = 20.0  # Far enough to see whole brain
const STRUCTURE_ZOOM_PADDING: float = 2.5  # Multiplier for structure focus

# Rotation limits to maintain anatomical orientation
const MIN_VERTICAL_ANGLE: float = -1.4  # ~80 degrees down
const MAX_VERTICAL_ANGLE: float = 1.4  # ~80 degrees up

# Medical view preset configurations
const MEDICAL_VIEWS: Dictionary = {
	"sagittal":
	{
		"rotation": Vector2(0.0, 1.5708),  # 90 degrees
		"distance": 8.0,
		"description": "Side view - Left hemisphere"
	},
	"sagittal_right":
	{
		"rotation": Vector2(0.0, -1.5708),  # -90 degrees
		"distance": 8.0,
		"description": "Side view - Right hemisphere"
	},
	"coronal":
	{"rotation": Vector2(0.0, 0.0), "distance": 8.0, "description": "Front view - Anterior"},
	"coronal_posterior":  # 180 degrees
	{"rotation": Vector2(0.0, 3.14159), "distance": 8.0, "description": "Back view - Posterior"},
	"axial":  # 90 degrees down
	{"rotation": Vector2(1.5708, 0.0), "distance": 8.0, "description": "Top view - Superior"},
	"axial_inferior":  # 90 degrees up
	{"rotation": Vector2(-1.5708, 0.0), "distance": 8.0, "description": "Bottom view - Inferior"},
	"clinical_anterior_lateral":
	{
		"rotation": Vector2(0.3, 0.785398),  # 45 degrees
		"distance": 10.0,
		"description": "Clinical view - Anterior-lateral"
	},
	"default":
	{
		"rotation": Vector2(0.3, 0.785398),
		"distance": 10.0,
		"description": "Default educational view"
	}
}

# Keyboard shortcuts for medical views
const VIEW_SHORTCUTS: Dictionary = {
	KEY_S: "sagittal",
	KEY_C: "coronal",
	KEY_A: "axial",
	KEY_R: "default",
	KEY_1: "sagittal",
	KEY_2: "coronal",
	KEY_3: "axial",
	KEY_4: "clinical_anterior_lateral"
}

# ===== VARIABLES =====
# Node references
var camera: Camera3D
var target: Node3D
var selection_manager: Node  # For focus-on-structure integration

# Camera state
var camera_distance: float = 10.0
var camera_rotation: Vector2 = Vector2(0.3, 0.785398)  # Default clinical view
var pivot_point: Vector3 = Vector3.ZERO
var current_view: String = "default"

# Input state
var is_rotating: bool = false
var is_panning: bool = false
var last_mouse_pos: Vector2

# Transition state
var is_transitioning: bool = false
var transition_start_rotation: Vector2
var transition_start_distance: float
var transition_start_pivot: Vector3
var transition_target_rotation: Vector2
var transition_target_distance: float
var transition_target_pivot: Vector3
var transition_progress: float = 0.0

# Educational features
var enable_smooth_transitions: bool = true
var enable_rotation_limits: bool = true
var classroom_mode: bool = false  # Slower movements for projection


# ===== LIFECYCLE METHODS =====
func _ready() -> void:
	"""Initialize camera controller for medical education"""
	set_process(true)
	set_process_unhandled_input(true)

	# Connect to selection manager if available
	_connect_to_selection_manager()

	print("[MedicalCamera] Enhanced camera controller ready")


func _process(delta: float) -> void:
	"""Handle smooth transitions between views"""
	if is_transitioning and enable_smooth_transitions:
		_update_transition(delta)


# ===== PUBLIC METHODS =====
func initialize(camera_node: Camera3D, target_node: Node3D) -> bool:
	"""
	Initialize the medical camera system

	@param camera_node: The Camera3D node to control
	@param target_node: The brain model parent node
	@returns: Success status
	"""
	camera = camera_node
	target = target_node

	if not camera or not target:
		push_error("[MedicalCamera] Camera or target not provided")
		return false

	# Set initial camera position
	reset_view()

	print("[MedicalCamera] Initialized with medical view presets")
	return true


func set_medical_view(view_name: String, smooth: bool = true) -> void:
	"""
	Transition to a preset medical viewing angle

	@param view_name: Name of the medical view (sagittal, coronal, axial, etc.)
	@param smooth: Whether to use smooth transition
	"""
	if not MEDICAL_VIEWS.has(view_name):
		push_warning("[MedicalCamera] Unknown medical view: " + view_name)
		return

	var view_config = MEDICAL_VIEWS[view_name]

	if smooth and enable_smooth_transitions:
		# Start smooth transition
		_start_view_transition(view_config.rotation, view_config.distance, pivot_point)
		transition_started.emit(view_name)
	else:
		# Instant transition
		camera_rotation = view_config.rotation
		camera_distance = view_config.distance
		update_camera_transform()
		camera_moved.emit()

	current_view = view_name
	view_changed.emit(view_name)

	if OS.is_debug_build():
		print("[MedicalCamera] Changed to view: %s - %s" % [view_name, view_config.description])


func focus_on_structure(mesh: MeshInstance3D, structure_name: String = "") -> void:
	"""
	Focus camera on a specific brain structure with appropriate zoom

	@param mesh: The MeshInstance3D to focus on
	@param structure_name: Optional name for signal emission
	"""
	if not mesh or not mesh.mesh:
		return

	var aabb = mesh.get_aabb()
	var global_aabb = mesh.global_transform * aabb

	# Calculate appropriate distance based on structure size
	var size = global_aabb.size.length()
	var target_distance = size * STRUCTURE_ZOOM_PADDING

	# Adjust for very small structures (like pineal gland ~8mm)
	if size < 0.1:  # Assuming 1 unit = 100mm for brain scale
		target_distance = max(target_distance, 2.0)  # Minimum zoom for small structures

	# Clamp to medical viewing constraints
	target_distance = clamp(target_distance, MIN_DISTANCE, MAX_DISTANCE)

	var target_pivot = global_aabb.get_center()

	if enable_smooth_transitions:
		_start_view_transition(camera_rotation, target_distance, target_pivot)
	else:
		pivot_point = target_pivot
		camera_distance = target_distance
		update_camera_transform()

	if not structure_name.is_empty():
		focus_completed.emit(structure_name)


func set_classroom_mode(enabled: bool) -> void:
	"""
	Enable/disable classroom mode for projection display
	Reduces movement speed for easier following during lectures
	"""
	classroom_mode = enabled
	if classroom_mode:
		print("[MedicalCamera] Classroom mode enabled - reduced movement speed")


# ===== INPUT HANDLING =====
func _unhandled_input(event: InputEvent) -> void:
	"""Handle input for medical camera control"""
	if not camera or is_transitioning:
		return

	# Keyboard shortcuts for medical views
	if event is InputEventKey and event.pressed:
		if VIEW_SHORTCUTS.has(event.keycode):
			set_medical_view(VIEW_SHORTCUTS[event.keycode])
			get_viewport().set_input_as_handled()
			return

		# Additional view controls
		match event.keycode:
			KEY_F:
				# Focus on selected structure
				if selection_manager and selection_manager.has_method("get_selected_mesh"):
					var selected = selection_manager.get_selected_mesh()
					if selected:
						var name = selection_manager.get_selected_structure_name()
						focus_on_structure(selected, name)
						get_viewport().set_input_as_handled()

	# Mouse button events
	elif event is InputEventMouseButton:
		# Skip if UI is capturing input
		if _is_mouse_over_ui():
			return

		match event.button_index:
			MOUSE_BUTTON_LEFT:
				is_rotating = event.pressed
				last_mouse_pos = event.position
			MOUSE_BUTTON_MIDDLE:
				is_panning = event.pressed
				last_mouse_pos = event.position
			MOUSE_BUTTON_WHEEL_UP:
				if event.pressed:
					zoom_in()
			MOUSE_BUTTON_WHEEL_DOWN:
				if event.pressed:
					zoom_out()

	# Mouse motion events
	elif event is InputEventMouseMotion:
		if is_rotating:
			rotate_camera(event.relative)
		elif is_panning:
			pan_camera(event.relative)


# ===== CAMERA MOVEMENT METHODS =====
func rotate_camera(delta: Vector2) -> void:
	"""
	Rotate camera with medical orientation constraints
	"""
	# Apply classroom mode speed reduction
	var speed_mult = 0.3 if classroom_mode else 1.0

	camera_rotation.x -= delta.y * ROTATION_SPEED * speed_mult
	camera_rotation.y -= delta.x * ROTATION_SPEED * speed_mult

	# Apply rotation limits to maintain anatomical orientation
	if enable_rotation_limits:
		camera_rotation.x = clamp(camera_rotation.x, MIN_VERTICAL_ANGLE, MAX_VERTICAL_ANGLE)

	# Cancel any ongoing transition
	is_transitioning = false

	update_camera_transform()
	camera_moved.emit()


func pan_camera(delta: Vector2) -> void:
	"""
	Pan camera for exploring different brain regions
	"""
	# Apply classroom mode speed reduction
	var speed_mult = 0.3 if classroom_mode else 1.0

	var cam_transform = camera.global_transform
	var pan_delta = Vector3(
		delta.x * PAN_SPEED * camera_distance * speed_mult,
		-delta.y * PAN_SPEED * camera_distance * speed_mult,
		0.0
	)

	pivot_point += cam_transform.basis.x * pan_delta.x + cam_transform.basis.y * pan_delta.y

	# Cancel any ongoing transition
	is_transitioning = false

	update_camera_transform()
	camera_moved.emit()


func zoom_in() -> void:
	"""Zoom in with medical viewing constraints"""
	var speed_mult = 0.5 if classroom_mode else 1.0
	camera_distance *= (1.0 - ZOOM_SPEED * speed_mult)
	camera_distance = clamp(camera_distance, MIN_DISTANCE, MAX_DISTANCE)

	# Cancel any ongoing transition
	is_transitioning = false

	update_camera_transform()
	zoom_changed.emit(camera_distance)


func zoom_out() -> void:
	"""Zoom out with medical viewing constraints"""
	var speed_mult = 0.5 if classroom_mode else 1.0
	camera_distance *= (1.0 + ZOOM_SPEED * speed_mult)
	camera_distance = clamp(camera_distance, MIN_DISTANCE, MAX_DISTANCE)

	# Cancel any ongoing transition
	is_transitioning = false

	update_camera_transform()
	zoom_changed.emit(camera_distance)


func update_camera_transform() -> void:
	"""Update camera position maintaining medical viewing conventions"""
	if not camera:
		return

	# Calculate camera position based on spherical coordinates
	var pos = (
		Vector3(
			sin(camera_rotation.y) * cos(camera_rotation.x),
			sin(camera_rotation.x),
			cos(camera_rotation.y) * cos(camera_rotation.x)
		)
		* camera_distance
	)

	camera.position = pivot_point + pos
	camera.look_at(pivot_point, Vector3.UP)


func reset_view() -> void:
	"""Reset to default medical educational view"""
	set_medical_view("default", enable_smooth_transitions)


# ===== TRANSITION METHODS =====
func _start_view_transition(
	target_rotation: Vector2, target_distance: float, target_pivot: Vector3
) -> void:
	"""Start a smooth transition to a new view"""
	if not camera:
		return

	# Store current state
	transition_start_rotation = camera_rotation
	transition_start_distance = camera_distance
	transition_start_pivot = pivot_point

	# Store target state
	transition_target_rotation = target_rotation
	transition_target_distance = target_distance
	transition_target_pivot = target_pivot

	# Start transition
	is_transitioning = true
	transition_progress = 0.0


func _update_transition(delta: float) -> void:
	"""Update smooth transition between views"""
	if not is_transitioning:
		return

	# Update progress
	transition_progress += delta / TRANSITION_DURATION

	if transition_progress >= 1.0:
		# Complete transition
		transition_progress = 1.0
		is_transitioning = false

		camera_rotation = transition_target_rotation
		camera_distance = transition_target_distance
		pivot_point = transition_target_pivot

		update_camera_transform()
		camera_moved.emit()
		transition_completed.emit()
		return

	# Smooth interpolation using ease-in-out
	var t = _ease_in_out_cubic(transition_progress)

	# Interpolate rotation (handling angle wrapping)
	camera_rotation = _lerp_angles(transition_start_rotation, transition_target_rotation, t)

	# Interpolate distance
	camera_distance = lerp(transition_start_distance, transition_target_distance, t)

	# Interpolate pivot point
	pivot_point = transition_start_pivot.lerp(transition_target_pivot, t)

	update_camera_transform()
	camera_moved.emit()


# ===== HELPER METHODS =====
func _get_node_aabb(node: Node3D) -> AABB:
	"""Get combined AABB of all meshes in a node"""
	var aabb = AABB()
	var first = true

	# Recursively collect all MeshInstance3D nodes
	var meshes: Array[MeshInstance3D] = []
	_collect_meshes_recursive(node, meshes)

	for mesh_instance in meshes:
		if mesh_instance.mesh:
			var transform = mesh_instance.global_transform
			var mesh_aabb = mesh_instance.mesh.get_aabb()
			mesh_aabb = transform * mesh_aabb

			if first:
				aabb = mesh_aabb
				first = false
			else:
				aabb = aabb.merge(mesh_aabb)

	return aabb


func _collect_meshes_recursive(node: Node, meshes: Array[MeshInstance3D]) -> void:
	"""Recursively collect all MeshInstance3D nodes"""
	if node is MeshInstance3D:
		meshes.append(node)

	for child in node.get_children():
		_collect_meshes_recursive(child, meshes)


func _ease_in_out_cubic(t: float) -> float:
	"""Cubic ease-in-out function for smooth transitions"""
	if t < 0.5:
		return 4.0 * t * t * t
	else:
		var p = 2.0 * t - 2.0
		return 1.0 + p * p * p / 2.0


func _lerp_angles(from: Vector2, to: Vector2, weight: float) -> Vector2:
	"""Lerp between angles handling wrap-around"""
	var result = Vector2()

	# X component (vertical rotation) - simple lerp
	result.x = lerp(from.x, to.x, weight)

	# Y component (horizontal rotation) - handle wrap-around
	var diff = to.y - from.y

	# Normalize difference to [-PI, PI]
	while diff > PI:
		diff -= TAU
	while diff < -PI:
		diff += TAU

	result.y = from.y + diff * weight

	return result


func _is_mouse_over_ui() -> bool:
	"""Check if mouse is over UI elements"""
	var mouse_pos = get_viewport().get_mouse_position()
	var ui_layer = get_node_or_null("/root/Node3D/UI_Layer")

	if ui_layer:
		for child in ui_layer.get_children():
			if child is Control and child.visible:
				var rect = child.get_global_rect()
				if rect.has_point(mouse_pos):
					return true

	return false


func _connect_to_selection_manager() -> void:
	"""Connect to selection manager for focus-on-structure integration"""
	# Try to find selection manager
	var main_scene = get_node_or_null("/root/Node3D")
	if main_scene:
		selection_manager = main_scene.get_node_or_null("SelectionManager")
		if not selection_manager:
			selection_manager = main_scene.get_node_or_null("BrainStructureSelectionManager")

		if selection_manager:
			# Connect to selection signal for auto-focus option
			if selection_manager.has_signal("structure_selected"):
				selection_manager.structure_selected.connect(_on_structure_selected)
				print("[MedicalCamera] Connected to selection manager")


func _on_structure_selected(structure_name: String, mesh: MeshInstance3D) -> void:
	"""Handle structure selection for optional auto-focus"""
	# Auto-focus could be a setting in the future
	# For now, user must press F to focus on selected structure
	pass


# ===== PUBLIC UTILITY METHODS =====
func get_current_view_name() -> String:
	"""Get the name of the current medical view"""
	return current_view


func get_current_distance() -> float:
	"""Get current camera distance for UI feedback"""
	return camera_distance


func get_available_views() -> Array:
	"""Get list of available medical views for UI"""
	return MEDICAL_VIEWS.keys()


func set_smooth_transitions(enabled: bool) -> void:
	"""Enable/disable smooth camera transitions"""
	enable_smooth_transitions = enabled


func set_rotation_limits(enabled: bool) -> void:
	"""Enable/disable rotation constraints"""
	enable_rotation_limits = enabled
