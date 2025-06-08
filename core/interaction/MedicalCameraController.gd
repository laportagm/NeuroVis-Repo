## MedicalCameraController.gd
## Advanced camera system for medical visualization with educational presets
##
## Provides specialized camera controls and presets for neuroanatomy education,
## including standard anatomical views, smooth transitions, and focus capabilities.
##
## @tutorial: docs/dev/medical-camera.md
## @experimental: false

class_name MedicalCameraController
extends Node

# === ENUMS ===
## Standard anatomical viewing angles

signal view_changed(view: int)

## Emitted when camera mode changes
## @param mode: CameraMode that was applied
signal mode_changed(mode: int)

## Emitted when camera focuses on a structure
## @param structure_name: String name of focused structure
signal focused_on_structure(structure_name: String)

## Emitted when camera movements are completed
signal camera_movement_completed

# === EXPORTS ===
## Reference to controlled camera (required)

enum AnatomicalView {
ANTERIOR,  # Front view
POSTERIOR,  # Back view
SUPERIOR,  # Top view
INFERIOR,  # Bottom view
LEFT_LATERAL,  # Left side view
RIGHT_LATERAL,  # Right side view
LEFT_OBLIQUE,  # Left oblique (45°) view
RIGHT_OBLIQUE,  # Right oblique (45°) view
CUSTOM  # Custom view
}

## Camera modes for different interaction styles
enum CameraMode { ORBIT, PAN, ZOOM, FLY, FOCUS, LOCKED }  # Orbit around target  # Pan/move the camera  # Zoom in/out  # Free fly mode  # Focus on structure  # Locked (no movement)

# === SIGNALS ===
## Emitted when camera view changes
## @param view: AnatomicalView that was applied

@export var camera: Camera3D

## Camera movement speed
@export_range(0.1, 10.0, 0.1) var movement_speed: float = 2.0

## Camera orbit speed
@export_range(0.1, 5.0, 0.1) var orbit_speed: float = 1.0

## Camera zoom speed
@export_range(0.1, 5.0, 0.1) var zoom_speed: float = 1.0

## Smooth camera transition time (seconds)
@export_range(0.1, 3.0, 0.1) var transition_time: float = 0.8

## Enable camera collision with objects
@export var collision_enabled: bool = true

## Current camera mode
@export var camera_mode: CameraMode = CameraMode.ORBIT:
	set(value):
		camera_mode = value
		mode_changed.emit(camera_mode)

		## Minimum zoom distance
@export var min_zoom_distance: float = 1.0

## Maximum zoom distance
@export var max_zoom_distance: float = 50.0

## Enable depth of field effect
@export var depth_of_field_enabled: bool = false:
	set(value):
		depth_of_field_enabled = value
		_update_depth_of_field()

		## Depth of field strength
@export_range(0.0, 1.0, 0.05) var depth_of_field_strength: float = 0.5:
	set(value):
		depth_of_field_strength = value
		_update_depth_of_field()

		## Initial anatomical view
@export var initial_view: AnatomicalView = AnatomicalView.ANTERIOR

# === PUBLIC VARIABLES ===
## Current anatomical view

var current_view: int = AnatomicalView.CUSTOM

## Target position (center of orbit)
# FIXED: Orphaned code - var target_position: Vector3 = Vector3.ZERO

## Whether camera is currently transitioning
var is_transitioning: bool = false

## Whether camera inputs are enabled
var inputs_enabled: bool = true

# === PRIVATE VARIABLES ===
var preset = _view_presets[view]

# Apply view transform
var center = Vector3.ZERO
var radius = 1.0

var aabb = mesh_instance.mesh.get_aabb()
	center = mesh_instance.global_transform * aabb.get_center()
	radius = aabb.size.length() / 2.0
	center = mesh_instance.global_position

	# Calculate camera position based on current view direction
var view_dir = (camera.global_position - target_position).normalized()
# FIXED: Orphaned code - var distance = radius * 2.5 * distance_factor
	distance = clamp(distance, min_zoom_distance, max_zoom_distance)

# FIXED: Orphaned code - var new_camera_pos = center + view_dir * distance
var new_transform = camera.global_transform
	new_transform.origin = new_camera_pos

	# Look at structure center
	new_transform = new_transform.looking_at(center)

	# Transition to new view
	_transition_to_transform(new_transform)

	# Update state
	target_position = center
	_camera_distance = distance
	current_view = AnatomicalView.CUSTOM
	_focused_structure = structure_name

	# Enable depth of field for focus mode
var mesh_instances = []
	_find_visible_meshes(get_tree().root, mesh_instances)

# FIXED: Orphaned code - var combined_aabb = AABB()
# FIXED: Orphaned code - var first = true

var mesh_aabb = mesh_instance.mesh.get_aabb()
# FIXED: Orphaned code - var global_aabb = AABB(
	mesh_instance.global_transform * mesh_aabb.position,
	mesh_instance.global_transform.basis * mesh_aabb.size
	)

# FIXED: Orphaned code - var center_2 = combined_aabb.get_center()
# FIXED: Orphaned code - var radius_2 = combined_aabb.size.length() / 2.0

# Calculate camera position based on current view direction
var view_dir_2 = (camera.global_position - target_position).normalized()
# FIXED: Orphaned code - var distance_2 = radius * 2.0 * distance_factor
	distance = clamp(distance, min_zoom_distance, max_zoom_distance)

# FIXED: Orphaned code - var new_camera_pos_2 = center + view_dir * distance
var new_transform_2 = camera.global_transform
	new_transform.origin = new_camera_pos

	# Look at model center
	new_transform = new_transform.looking_at(center)

	# Transition to new view
	_transition_to_transform(new_transform)

	# Update state
	target_position = center
	_camera_distance = distance
	current_view = AnatomicalView.CUSTOM
	_focused_structure = ""

var original_dof = depth_of_field_enabled
var original_env = camera.environment

# Set up optimized screenshot settings
	depth_of_field_enabled = true
	depth_of_field_strength = 0.3

	# Create enhanced environment for screenshot
var screenshot_env = _create_screenshot_environment()
	camera.environment = screenshot_env

	# Allow settings to apply
	await get_tree().process_frame

	# Take screenshot
var image

var result = image.save_png(file_path)

# Restore original settings
	depth_of_field_enabled = original_dof
	camera.environment = original_env

var input_dir = Vector2.ZERO

# Get input direction from keyboard or from mouse if button is pressed
var viewport_size = get_viewport().get_visible_rect().size
var mouse_position = _input_mouse_position

# Calculate input direction from mouse movement
var mouse_speed = orbit_speed * 0.5
	input_dir.x = Input.get_last_mouse_velocity().x / viewport_size.x * mouse_speed
	input_dir.y = Input.get_last_mouse_velocity().y / viewport_size.y * mouse_speed
	# Keyboard input
var offset = Vector3.ZERO
	offset.x = sin(_orbit_rotation.x) * cos(_orbit_rotation.y) * _camera_distance
	offset.z = cos(_orbit_rotation.x) * cos(_orbit_rotation.y) * _camera_distance
	offset.y = sin(_orbit_rotation.y) * _camera_distance

	camera.global_position = target_position + offset
	camera.look_at(target_position)

	# Mark as custom view
	current_view = AnatomicalView.CUSTOM

	# Handle zoom input
var zoom_input = 0.0
var direction = (camera.global_position - target_position).normalized()
	camera.global_position = target_position + direction * _camera_distance


var input_dir_2 = Vector3.ZERO

# Get input direction
var viewport_size_2 = get_viewport().get_visible_rect().size
var mouse_velocity = Input.get_last_mouse_velocity()

# Convert mouse movement to pan input
var pan_speed = movement_speed * 0.02
	input_dir.x -= mouse_velocity.x / viewport_size.x * pan_speed * _camera_distance
	input_dir.y += mouse_velocity.y / viewport_size.y * pan_speed * _camera_distance

	# Apply movement
var move_vec = (
	camera.global_transform.basis
	* input_dir.normalized()
	* movement_speed
	* delta
	* _camera_distance
	* 0.5
	)

	camera.global_position += move_vec
	target_position += move_vec

	# Mark as custom view
	current_view = AnatomicalView.CUSTOM


var zoom_input_2 = 0.0

# Get input from keyboard
var direction_2 = (camera.global_position - target_position).normalized()
	camera.global_position = target_position + direction * _camera_distance

	# Mark as custom view
	current_view = AnatomicalView.CUSTOM


var input_dir_3 = Vector3.ZERO

# Get input direction
var move_vec_2 = (
	camera.global_transform.basis * input_dir.normalized() * movement_speed * delta * 5.0
	)
	camera.global_position += move_vec

	# Update target position to match camera's forward direction
var forward_dir = -camera.global_transform.basis.z
	target_position = camera.global_position + forward_dir * _camera_distance

	# Mark as custom view
	current_view = AnatomicalView.CUSTOM

	# Handle rotation with mouse
var viewport_size_3 = get_viewport().get_visible_rect().size
var mouse_velocity_2 = Input.get_last_mouse_velocity()

# Convert mouse movement to rotation
var rot_x = -mouse_velocity.x / viewport_size.x * orbit_speed * 0.5
var rot_y = -mouse_velocity.y / viewport_size.y * orbit_speed * 0.5

# Apply rotation
	camera.rotate_y(rot_x)
	camera.rotate_object_local(Vector3(1, 0, 0), rot_y)

	# Update target position
var forward_dir_2 = -camera.global_transform.basis.z
	target_position = camera.global_position + forward_dir * _camera_distance


var original_basis = camera.global_transform.basis

	_current_tween.tween_method(
	func(t: float):
		# Interpolate basis (can't directly tween it)
		camera.global_transform.basis = original_basis.slerp(target_transform.basis, t),
		0.0,
		1.0,
		transition_time
		)


# FIXED: Orphaned code - var dir = (camera.global_position - target_position).normalized()
	_orbit_rotation.y = asin(dir.y)
	_orbit_rotation.x = atan2(dir.x, dir.z)

	# Emit completion signal
	camera_movement_completed.emit()


# FIXED: Orphaned code - var screenshot_env_2 = _environment.duplicate()

# Enhanced settings for screenshots
	screenshot_env.ssao_enabled = true
	screenshot_env.ssao_radius = 1.0
	screenshot_env.ssao_intensity = 1.0
	screenshot_env.ssao_detail = 0.5

	# Subtle bloom
	screenshot_env.glow_enabled = true
	screenshot_env.glow_intensity = 0.4
	screenshot_env.glow_bloom = 0.2

	# Depth of field
	screenshot_env.dof_blur_far_enabled = true
	screenshot_env.dof_blur_far_distance = _camera_distance * 1.2
	screenshot_env.dof_blur_far_transition = _camera_distance * 0.7
	screenshot_env.dof_blur_far_amount = 0.3

var _orbit_rotation: Vector2 = Vector2.ZERO
var _camera_distance: float = 10.0
var _initial_transform: Transform3D
var _view_presets: Dictionary = {}
# FIXED: Orphaned code - var _target_transform: Transform3D
var _focused_structure: String = ""
var _environment: Environment
var _is_initialized: bool = false
var _input_mouse_position: Vector2 = Vector2.ZERO
var _current_tween: Tween


# === LIFECYCLE METHODS ===

func _ready() -> void:
	"""Initialize the camera controller"""
	if not camera:
		push_error("[MedicalCameraController] No camera assigned! Controller will not function.")
		return

		# Store initial state
		_initial_transform = camera.global_transform
		_camera_distance = camera.global_position.distance_to(target_position)

		# Set up depth of field environment
		_setup_environment()

		# Initialize view presets
		_initialize_view_presets()

		# Apply initial view
		apply_anatomical_view(initial_view)

		_is_initialized = true
		print("[MedicalCameraController] Initialized with camera: " + camera.name)


func _process(delta: float) -> void:
	"""Process camera movement"""
	if not _is_initialized or not camera or is_transitioning:
		return

		if inputs_enabled:
			_handle_input(delta)


func _initialize_view_presets() -> void:
	"""Initialize standard anatomical view presets"""
	# Anterior view (front)
	_view_presets[AnatomicalView.ANTERIOR] = {
	"name": "Anterior",
	"transform": Transform3D(Basis(Vector3(0, 1, 0), PI), Vector3(0, 0, 10)),
	"use_dof": false
	}

	# Posterior view (back)
	_view_presets[AnatomicalView.POSTERIOR] = {
	"name": "Posterior",
	"transform": Transform3D(Basis(Vector3(0, 1, 0), 0), Vector3(0, 0, -10)),
	"use_dof": false
	}

	# Superior view (top)
	_view_presets[AnatomicalView.SUPERIOR] = {
	"name": "Superior",
	"transform": Transform3D(Basis(Vector3(1, 0, 0), -PI / 2), Vector3(0, 10, 0)),
	"use_dof": false
	}

	# Inferior view (bottom)
	_view_presets[AnatomicalView.INFERIOR] = {
	"name": "Inferior",
	"transform": Transform3D(Basis(Vector3(1, 0, 0), PI / 2), Vector3(0, -10, 0)),
	"use_dof": false
	}

	# Left lateral view
	_view_presets[AnatomicalView.LEFT_LATERAL] = {
	"name": "Left Lateral",
	"transform": Transform3D(Basis(Vector3(0, 1, 0), -PI / 2), Vector3(-10, 0, 0)),
	"use_dof": false
	}

	# Right lateral view
	_view_presets[AnatomicalView.RIGHT_LATERAL] = {
	"name": "Right Lateral",
	"transform": Transform3D(Basis(Vector3(0, 1, 0), PI / 2), Vector3(10, 0, 0)),
	"use_dof": false
	}

	# Left oblique view (45°)
	_view_presets[AnatomicalView.LEFT_OBLIQUE] = {
	"name": "Left Oblique",
	"transform": Transform3D(Basis(Vector3(0, 1, 0), -PI / 4), Vector3(-7, 0, 7)),
	"use_dof": false
	}

	# Right oblique view (45°)
	_view_presets[AnatomicalView.RIGHT_OBLIQUE] = {
	"name": "Right Oblique",
	"transform": Transform3D(Basis(Vector3(0, 1, 0), PI / 4), Vector3(7, 0, 7)),
	"use_dof": false
	}

	# Custom view placeholder
	_view_presets[AnatomicalView.CUSTOM] = {
	"name": "Custom", "transform": Transform3D(), "use_dof": false
	}


func apply_anatomical_view(view: int, instant: bool = false) -> bool:
	"""Apply a standard anatomical view"""
	if not _is_initialized or not camera:
		return false

		if view < 0 or view > AnatomicalView.CUSTOM:
			push_warning("[MedicalCameraController] Invalid anatomical view: " + str(view))
			return false

			if not _view_presets.has(view):
				push_warning("[MedicalCameraController] View preset not found: " + str(view))
				return false

func focus_on_structure(
	mesh_instance: MeshInstance3D, structure_name: String, distance_factor: float = 1.0
	) -> bool:
		"""Focus camera on a specific structure"""
func focus_on_model_bounds(distance_factor: float = 1.0) -> bool:
	"""Focus camera to see the entire model"""
	if not _is_initialized or not camera:
		return false

		# Find all visible MeshInstance3D nodes
func reset_camera() -> bool:
	"""Reset camera to initial position and state"""
	if not _is_initialized or not camera:
		return false

		_transition_to_transform(_initial_transform)

		# Reset state
		target_position = Vector3.ZERO
		_camera_distance = _initial_transform.origin.length()
		current_view = initial_view
		_focused_structure = ""
		depth_of_field_enabled = false
		camera_mode = CameraMode.ORBIT

		return true


		## Take a screenshot optimized for educational purposes
		## @param file_path: String path to save screenshot
		## @param width: int screenshot width (0 for current resolution)
		## @param height: int screenshot height (0 for current resolution)
		## @returns: bool indicating success
func take_educational_screenshot(file_path: String, width: int = 0, height: int = 0) -> bool:
	"""Take a screenshot optimized for educational purposes"""
	if not _is_initialized or not camera:
		return false

		# Remember current state to restore later
func add_custom_view_preset(name: String, transform: Transform3D, use_dof: bool = false) -> bool:
	"""Add a custom anatomical view preset"""
	if not _is_initialized:
		return false

		_view_presets[AnatomicalView.CUSTOM] = {
		"name": name, "transform": transform, "use_dof": use_dof
		}

		return true


		## Update camera movement parameters
		## @param params: Dictionary of parameters to update
		## @returns: bool indicating success
func update_camera_parameters(params: Dictionary) -> bool:
	"""Update camera movement parameters"""
	if params.has("movement_speed"):
		movement_speed = params.movement_speed

		if params.has("orbit_speed"):
			orbit_speed = params.orbit_speed

			if params.has("zoom_speed"):
				zoom_speed = params.zoom_speed

				if params.has("transition_time"):
					transition_time = params.transition_time

					if params.has("min_zoom_distance"):
						min_zoom_distance = params.min_zoom_distance

						if params.has("max_zoom_distance"):
							max_zoom_distance = params.max_zoom_distance

							if params.has("collision_enabled"):
								collision_enabled = params.collision_enabled

								return true


								# === PRIVATE METHODS ===

if instant:
	_apply_transform(preset.transform)
	else:
		_transition_to_transform(preset.transform)

		# Update state
		current_view = view

		# Apply depth of field if specified
		if preset.has("use_dof"):
			depth_of_field_enabled = preset.use_dof

			# Emit signal
			view_changed.emit(view)

			return true


			## Focus camera on a specific structure
			## @param mesh_instance: MeshInstance3D to focus on
			## @param structure_name: String name of the structure
			## @param distance_factor: float for zoom level (1.0 = default)
			## @returns: bool indicating success
if mesh_instance.mesh:
if camera_mode == CameraMode.FOCUS:
	depth_of_field_enabled = true

	# Emit signal
	focused_on_structure.emit(structure_name)

	return true


	## Focus camera on the entire model bounds
	## @param distance_factor: float for zoom level (1.0 = default)
	## @returns: bool indicating success
if mesh_instances.is_empty():
	push_warning("[MedicalCameraController] No visible mesh instances found")
	return false

	# Calculate combined bounds
for mesh_instance in mesh_instances:
	if mesh_instance.mesh:
if first:
	combined_aabb = global_aabb
	first = false
	else:
		combined_aabb = combined_aabb.merge(global_aabb)

		if combined_aabb.size == Vector3.ZERO:
			push_warning("[MedicalCameraController] Could not calculate model bounds")
			return false

			# Calculate center and radius
return true


## Reset camera to initial state
## @returns: bool indicating success
if width > 0 and height > 0:
	# Custom resolution screenshot
	image = get_viewport().get_texture().get_image()
	image.resize(width, height)
	else:
		# Current resolution screenshot
		image = get_viewport().get_texture().get_image()

		# Save to file
return result == OK


## Add a custom anatomical view preset
## @param name: String name for the preset
## @param transform: Transform3D camera transform
## @param use_dof: bool whether to enable depth of field
## @returns: bool indicating success
if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
if Input.is_key_pressed(KEY_LEFT):
	input_dir.x += 1
	if Input.is_key_pressed(KEY_RIGHT):
		input_dir.x -= 1
		if Input.is_key_pressed(KEY_UP):
			input_dir.y += 1
			if Input.is_key_pressed(KEY_DOWN):
				input_dir.y -= 1

				# Apply orbit rotation
				if input_dir != Vector2.ZERO:
					_orbit_rotation.x += input_dir.x * orbit_speed * delta
					_orbit_rotation.y += input_dir.y * orbit_speed * delta

					# Limit vertical rotation
					_orbit_rotation.y = clamp(_orbit_rotation.y, -PI / 2 + 0.1, PI / 2 - 0.1)

					# Calculate new camera position based on orbit
if Input.is_key_pressed(KEY_Q):
	zoom_input -= 1.0
	if Input.is_key_pressed(KEY_E):
		zoom_input += 1.0

		# Apply zoom
		if zoom_input != 0.0:
			_camera_distance += zoom_input * zoom_speed * delta * _camera_distance * 0.5
			_camera_distance = clamp(_camera_distance, min_zoom_distance, max_zoom_distance)

			# Update camera position
if Input.is_key_pressed(KEY_W):
	input_dir.z -= 1
	if Input.is_key_pressed(KEY_S):
		input_dir.z += 1
		if Input.is_key_pressed(KEY_A):
			input_dir.x -= 1
			if Input.is_key_pressed(KEY_D):
				input_dir.x += 1
				if Input.is_key_pressed(KEY_Q):
					input_dir.y -= 1
					if Input.is_key_pressed(KEY_E):
						input_dir.y += 1

						# Mouse pan
						if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
if input_dir != Vector3.ZERO:
if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
	zoom_input -= 1.0
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		zoom_input += 1.0

		# Get input from mouse wheel
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_UP):
			zoom_input -= 1.0
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_DOWN):
				zoom_input += 1.0

				# Apply zoom
				if zoom_input != 0.0:
					_camera_distance += zoom_input * zoom_speed * delta * _camera_distance * 0.5
					_camera_distance = clamp(_camera_distance, min_zoom_distance, max_zoom_distance)

					# Update camera position
if Input.is_key_pressed(KEY_W):
	input_dir.z -= 1
	if Input.is_key_pressed(KEY_S):
		input_dir.z += 1
		if Input.is_key_pressed(KEY_A):
			input_dir.x -= 1
			if Input.is_key_pressed(KEY_D):
				input_dir.x += 1
				if Input.is_key_pressed(KEY_Q):
					input_dir.y -= 1
					if Input.is_key_pressed(KEY_E):
						input_dir.y += 1

						# Apply movement
						if input_dir != Vector3.ZERO:
if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
return screenshot_env


if not _is_initialized or not camera or not mesh_instance:
	return false

	# Calculate structure center and bounding sphere
func _input(event: InputEvent) -> void:
	"""Handle input events"""
	if not _is_initialized or not camera or not inputs_enabled:
		return

		if event is InputEventMouseMotion:
			_input_mouse_position = event.position

			# Handle view hotkeys
			if event is InputEventKey and event.is_pressed() and not event.is_echo():
				match event.keycode:
					KEY_1:
						apply_anatomical_view(AnatomicalView.ANTERIOR)
						KEY_2:
							apply_anatomical_view(AnatomicalView.POSTERIOR)
							KEY_3:
								apply_anatomical_view(AnatomicalView.RIGHT_LATERAL)
								KEY_4:
									apply_anatomical_view(AnatomicalView.LEFT_LATERAL)
									KEY_7:
										apply_anatomical_view(AnatomicalView.SUPERIOR)
										KEY_8:
											apply_anatomical_view(AnatomicalView.INFERIOR)
											KEY_F:
												focus_on_model_bounds()
												KEY_R:
													reset_camera()


													# === PUBLIC METHODS ===
													## Apply a standard anatomical view
													## @param view: AnatomicalView to apply
													## @param instant: bool whether to transition instantly
													## @returns: bool indicating success
func _setup_environment() -> void:
	"""Set up camera environment and effects"""
	# Create environment if camera doesn't have one
	if camera.environment:
		_environment = camera.environment
		else:
			_environment = Environment.new()
			camera.environment = _environment

			# Set up depth of field
			_environment.dof_blur_far_enabled = false
			_environment.dof_blur_near_enabled = false

			# Initialize depth of field based on setting
			_update_depth_of_field()


func _handle_input(delta: float) -> void:
	"""Handle camera input for different modes"""
	if camera_mode == CameraMode.LOCKED:
		return

		match camera_mode:
			CameraMode.ORBIT:
				_handle_orbit_input(delta)
				CameraMode.PAN:
					_handle_pan_input(delta)
					CameraMode.ZOOM:
						_handle_zoom_input(delta)
						CameraMode.FLY:
							_handle_fly_input(delta)
							CameraMode.FOCUS:
								_handle_focus_input(delta)


func _handle_orbit_input(delta: float) -> void:
	"""Handle orbit camera input"""
func _handle_pan_input(delta: float) -> void:
	"""Handle pan camera input"""
func _handle_zoom_input(delta: float) -> void:
	"""Handle zoom camera input"""
func _handle_fly_input(delta: float) -> void:
	"""Handle fly camera input"""
func _handle_focus_input(delta: float) -> void:
	"""Handle focus mode input (limited movement)"""
	# Only allow orbit in focus mode
	_handle_orbit_input(delta * 0.5)  # Slower movement in focus mode


func _transition_to_transform(target_transform: Transform3D) -> void:
	"""Smoothly transition camera to a target transform"""
	if not camera:
		return

		# Cancel any active transition
		if _current_tween and _current_tween.is_valid():
			_current_tween.kill()

			is_transitioning = true

			# Create tween for smooth transition
			_current_tween = create_tween()
			_current_tween.set_trans(Tween.TRANS_SINE)
			_current_tween.set_ease(Tween.EASE_IN_OUT)

			# Interpolate position
			_current_tween.tween_property(
			camera, "global_position", target_transform.origin, transition_time
			)

			# Store target for basis transition (can't directly tween basis)
			_target_transform = target_transform

			# Connect to tween completion
			_current_tween.tween_callback(_on_transition_completed)
			_current_tween.play()

			# During transition, interpolate basis in _process
func _apply_transform(transform: Transform3D) -> void:
	"""Immediately apply a transform to the camera"""
	if not camera:
		return

		camera.global_transform = transform

		# Update camera state
		_camera_distance = (camera.global_position - target_position).length()

		# Emit completion signal
		camera_movement_completed.emit()


func _on_transition_completed() -> void:
	"""Handle camera transition completion"""
	is_transitioning = false

	# Ensure final transform is applied exactly
	if _target_transform:
		camera.global_transform = _target_transform

		# Update camera state
		_camera_distance = (camera.global_position - target_position).length()

		# Calculate orbit rotation for current position
func _update_depth_of_field() -> void:
	"""Update depth of field effect based on settings"""
	if not _environment:
		return

		if depth_of_field_enabled:
			# Set up depth of field for focus on target
			_environment.dof_blur_far_enabled = true
			_environment.dof_blur_far_distance = _camera_distance * 1.5
			_environment.dof_blur_far_transition = _camera_distance * 0.5
			_environment.dof_blur_far_amount = depth_of_field_strength * 0.2

			# Near blur for very close objects
			_environment.dof_blur_near_enabled = true
			_environment.dof_blur_near_distance = _camera_distance * 0.5
			_environment.dof_blur_near_transition = _camera_distance * 0.3
			_environment.dof_blur_near_amount = depth_of_field_strength * 0.1
			else:
				# Disable depth of field
				_environment.dof_blur_far_enabled = false
				_environment.dof_blur_near_enabled = false


func _create_screenshot_environment() -> Environment:
	"""Create optimized environment for screenshots"""
func _find_visible_meshes(node: Node, result: Array) -> void:
	"""Recursively find all visible mesh instances in the scene"""
	if node is MeshInstance3D and node.visible:
		if node.mesh:
			result.append(node)

			for child in node.get_children():
				_find_visible_meshes(child, result)
