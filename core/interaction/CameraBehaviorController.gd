# Professional 3D Camera Controller - Nomad/Blender style (Updated existing CameraController)

class_name CameraBehaviorController
extends Node

# Tuned for 12% scale models

signal camera_animation_finished
signal camera_reset_completed


const ROTATION_SPEED: float = 0.008
const PAN_SPEED: float = 0.0008
const ZOOM_SPEED: float = 0.03
const ZOOM_MIN: float = 0.3
const ZOOM_MAX: float = 8.0
const SMOOTHING: float = 0.15
const MOMENTUM_DAMPING: float = 0.85

var camera: Camera3D
var pivot_point: Vector3 = Vector3.ZERO
var camera_distance: float = 3.0
var camera_rotation: Vector2 = Vector2(0.3, 0.0)

# FIXED: Orphaned code - var is_orbiting: bool = false
var is_panning: bool = false
var last_mouse_pos: Vector2 = Vector2.ZERO
var touches: Dictionary = {}

# FIXED: Orphaned code - var target_distance: float = 3.0
var target_rotation: Vector2 = Vector2(0.3, 0.0)
# FIXED: Orphaned code - var target_pivot: Vector3 = Vector3.ZERO
var rotation_velocity: Vector2 = Vector2.ZERO
var pan_velocity: Vector3 = Vector3.ZERO
var zoom_velocity: float = 0.0

# Legacy compatibility signals
var delta = event.position - last_mouse_pos

var pan_delta = Vector3(
delta.x * PAN_SPEED * camera_distance, -delta.y * PAN_SPEED * camera_distance, 0.0
)
# FIXED: Orphaned code - var cam_transform = camera.global_transform
pan_velocity = cam_transform.basis.x * pan_delta.x + cam_transform.basis.y * pan_delta.y

last_mouse_pos = event.position

var pan_delta_2 = Vector3(
event.delta.x * PAN_SPEED * camera_distance * 0.5,
-event.delta.y * PAN_SPEED * camera_distance * 0.5,
0.0
)
# FIXED: Orphaned code - var cam_transform_2 = camera.global_transform
pan_velocity += cam_transform.basis.x * pan_delta.x + cam_transform.basis.y * pan_delta.y

zoom_velocity -= (event.factor - 1.0) * ZOOM_SPEED * 10.0


var needs_update = false

var pos = Vector3()
pos.x = camera_distance * cos(camera_rotation.x) * sin(camera_rotation.y)
pos.y = camera_distance * sin(camera_rotation.x)
pos.z = camera_distance * cos(camera_rotation.x) * cos(camera_rotation.y)

# Validate position before applying
var new_position = pivot_point + pos
var changed = false

# Validate and fix target_rotation
var clamped_x = clamp(target_rotation.x, -PI / 2 + 0.1, PI / 2 - 0.1)
# FIXED: Orphaned code - var clamped_distance = clamp(target_distance, ZOOM_MIN, ZOOM_MAX)
# FIXED: Orphaned code - var position_diff = camera_rotation.distance_to(target_rotation)
# FIXED: Orphaned code - var distance_diff = abs(camera_distance - target_distance)
# FIXED: Orphaned code - var pivot_diff = pivot_point.distance_to(target_pivot)

func _ready() -> void:
	add_to_group("camera_controller")
	set_process_unhandled_input(true)
	set_physics_process(true)
	print("Professional CameraController initialized and added to group")


func _unhandled_input(event: InputEvent) -> void:
	if not camera:
		return

		if event is InputEventMouseButton:
			match event.button_index:
				MOUSE_BUTTON_LEFT:
					is_orbiting = event.pressed
					if event.pressed:
						last_mouse_pos = event.position
						MOUSE_BUTTON_MIDDLE:
							is_panning = event.pressed
							if event.pressed:
								last_mouse_pos = event.position
								MOUSE_BUTTON_WHEEL_UP:
									zoom_velocity -= ZOOM_SPEED * 2.0
									MOUSE_BUTTON_WHEEL_DOWN:
										zoom_velocity += ZOOM_SPEED * 2.0

										elif event is InputEventMouseMotion:
func _physics_process(_delta: float) -> void:
	if not camera or not is_instance_valid(camera):
		return

		# Performance optimization: early exit if no changes needed

func initialize(cam: Camera3D, _target: Node3D = null) -> bool:
	camera = cam
	if camera:
		_update_camera_from_state()
		print("[CAMERA] Camera controller initialized successfully")
		return true
		else:
			push_error("[CAMERA] Camera reference is null")
			return false


func focus_on_bounds(center: Vector3, size: float) -> void:
	target_pivot = center
	target_distance = clamp(size * 2.0, ZOOM_MIN, ZOOM_MAX)


func reset_view() -> void:
	target_rotation = Vector2(0.3, 0.0)
	target_distance = 3.0
	target_pivot = Vector3.ZERO
	camera_reset_completed.emit()


func set_view_preset(preset: String) -> void:
	match preset:
		"front":
			target_rotation = Vector2(0, 0)
			"right":
				target_rotation = Vector2(0, -PI / 2)
				"top":
					target_rotation = Vector2(PI / 2 - 0.1, 0)


					# Legacy compatibility methods
func handle_camera_input(_event: InputEvent) -> bool:
	# Input is now handled in _unhandled_input
	return false


func reset_camera_position() -> void:
	reset_view()


func setup_initial_animation() -> void:
	reset_view()
	camera_animation_finished.emit()


func set_rotation_speed(_speed: float) -> void:
	# Compatibility method - rotation speed is now constant
	pass


func set_zoom_speed(_speed: float) -> void:
	# Compatibility method - zoom speed is now constant
	pass


func set_zoom_limits(_min_dist: float, _max_dist: float) -> void:
	# Compatibility method - limits are now constants
	pass


	# Health monitoring methods for compatibility
func get_camera_transform() -> Transform3D:
	if camera:
		return camera.global_transform
		return Transform3D()


func is_healthy() -> bool:
	return camera != null


func get_health_status() -> Dictionary:
	return {
	"healthy": is_healthy(),
	"camera_valid": camera != null,
	"position": camera.global_position if camera else Vector3.ZERO,
	"rotation": camera_rotation
	}

if is_orbiting:
	rotation_velocity.y = -delta.x * ROTATION_SPEED
	rotation_velocity.x = delta.y * ROTATION_SPEED  # Fixed: removed negative to make vertical feel natural
	elif (
	is_panning
	or (Input.is_key_pressed(KEY_SHIFT) and event.button_mask == MOUSE_BUTTON_MASK_LEFT)
	):
if rotation_velocity.length() > 0.001:
	target_rotation += rotation_velocity
	rotation_velocity *= MOMENTUM_DAMPING
	needs_update = true

	if pan_velocity.length() > 0.001:
		target_pivot += pan_velocity
		pan_velocity *= MOMENTUM_DAMPING
		needs_update = true

		if abs(zoom_velocity) > 0.001:
			target_distance += zoom_velocity
			zoom_velocity *= MOMENTUM_DAMPING
			needs_update = true

			# Validate and clamp values to prevent invalid camera positions
			if _validate_and_clamp_values():
				needs_update = true

				# Only update camera if there are actual changes
				if needs_update or _needs_camera_update():
					camera_rotation = camera_rotation.lerp(target_rotation, SMOOTHING)
					camera_distance = lerp(camera_distance, target_distance, SMOOTHING)
					pivot_point = pivot_point.lerp(target_pivot, SMOOTHING)

					_update_camera_from_state_safe()


					# Optimized camera update with safety checks
if _is_valid_vector3(pos) and _is_valid_vector3(pivot_point):
if _is_valid_vector3(new_position):
	camera.global_position = new_position
	camera.look_at(pivot_point, Vector3.UP)
	else:
		push_warning(
		"[CameraController] State error: Invalid camera position calculated, skipping update"
		)
		else:
			push_warning(
			"[CameraController] Calculation error: Invalid camera calculation values, resetting"
			)
			_reset_to_safe_values()


			# Legacy method for compatibility
if not _is_valid_vector2(target_rotation):
	target_rotation = Vector2(0.3, 0.0)
	changed = true
	else:
if abs(clamped_x - target_rotation.x) > 0.001:
	target_rotation.x = clamped_x
	changed = true

	# Validate and fix target_distance
	if not is_finite(target_distance) or target_distance <= 0:
		target_distance = 3.0
		changed = true
		else:
if abs(clamped_distance - target_distance) > 0.001:
	target_distance = clamped_distance
	changed = true

	# Validate pivot point
	if not _is_valid_vector3(target_pivot):
		target_pivot = Vector3.ZERO
		changed = true

		return changed


		# Check if camera needs updating (positions differ significantly)
return position_diff > 0.001 or distance_diff > 0.001 or pivot_diff > 0.001


# Validate Vector3 for NaN and infinity

func _update_camera_from_state_safe() -> void:
	if not camera or not is_instance_valid(camera):
		return

		# Calculate new position with validation
func _update_camera_from_state() -> void:
	_update_camera_from_state_safe()


	# Validate and clamp all values to prevent NaN or infinite values
func _validate_and_clamp_values() -> bool:
func _needs_camera_update() -> bool:
func _is_valid_vector3(v: Vector3) -> bool:
	return is_finite(v.x) and is_finite(v.y) and is_finite(v.z)


	# Validate Vector2 for NaN and infinity
func _is_valid_vector2(v: Vector2) -> bool:
	return is_finite(v.x) and is_finite(v.y)


	# Reset camera to safe default values
func _reset_to_safe_values() -> void:
	camera_rotation = Vector2(0.3, 0.0)
	camera_distance = 3.0
	pivot_point = Vector3.ZERO
	target_rotation = Vector2(0.3, 0.0)
	target_distance = 3.0
	target_pivot = Vector3.ZERO
	rotation_velocity = Vector2.ZERO
	pan_velocity = Vector3.ZERO
	zoom_velocity = 0.0
	print("[CAMERA] Reset to safe values")
