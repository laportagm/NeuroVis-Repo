## CameraBehaviorController.gd
## Advanced medical education camera controller with tablet support and educational tours
##
## This enhanced camera system provides professional-grade navigation for medical tablets,
## including multi-touch gestures, momentum-based physics, collision detection, and
## educational tour waypoints for guided anatomy lessons.
##
## Touch Gestures:
## - One finger drag: Orbit camera around brain
## - Two finger pinch: Zoom in/out
## - Two finger drag: Pan camera
## - Two finger twist: Rotate view
## - Three finger tap: Reset view
##
## Educational Features:
## - Tour waypoints for guided lessons
## - Collision detection prevents clipping
## - Momentum physics for natural navigation
## - Haptic feedback on supported tablets
##
## @tutorial: Medical tablet navigation for neuroanatomy education
## @version: 3.0 - Enhanced with touch support and educational tours

class_name CameraBehaviorController
extends Node

# ===== SIGNALS =====
signal camera_animation_finished
signal camera_reset_completed
signal waypoint_reached(waypoint_name: String)
signal tour_started(tour_name: String)
signal tour_completed(tour_name: String)
signal gesture_recognized(gesture_type: String)
signal collision_detected(collision_point: Vector3)

# ===== CONSTANTS =====
# Navigation speeds (tuned for 12% scale models)
const ROTATION_SPEED: float = 0.008
const PAN_SPEED: float = 0.0008
const ZOOM_SPEED: float = 0.03
const TOUCH_ROTATION_SPEED: float = 0.012  # Faster for touch
const TOUCH_PAN_SPEED: float = 0.001
const PINCH_ZOOM_SPEED: float = 0.02

# Camera constraints
const ZOOM_MIN: float = 0.3
const ZOOM_MAX: float = 8.0
const VERTICAL_ANGLE_MIN: float = -1.4  # ~80 degrees down
const VERTICAL_ANGLE_MAX: float = 1.4  # ~80 degrees up

# Physics parameters
const SMOOTHING: float = 0.15
const MOMENTUM_DAMPING: float = 0.85
const TOUCH_MOMENTUM_DAMPING: float = 0.92  # Smoother for touch
const COLLISION_MARGIN: float = 0.1
const COLLISION_PUSH_STRENGTH: float = 0.5

# Touch gesture thresholds
const PINCH_THRESHOLD: float = 10.0  # Pixels
const ROTATION_THRESHOLD: float = 0.1  # Radians
const TAP_THRESHOLD: float = 15.0  # Pixels
const TAP_TIME_THRESHOLD: float = 0.3  # Seconds

# Educational tour settings
const WAYPOINT_REACH_DISTANCE: float = 0.1
const TOUR_TRANSITION_DURATION: float = 2.0
const TOUR_PAUSE_DURATION: float = 3.0

# ===== VARIABLES =====
# Core camera state
var camera: Camera3D
var brain_model: Node3D
var pivot_point: Vector3 = Vector3.ZERO
var camera_distance: float = 3.0
var camera_rotation: Vector2 = Vector2(0.3, 0.0)

# Target state for smooth transitions
var target_distance: float = 3.0
var target_rotation: Vector2 = Vector2(0.3, 0.0)
var target_pivot: Vector3 = Vector3.ZERO

# Input state
var is_orbiting: bool = false
var is_panning: bool = false
var last_mouse_pos: Vector2 = Vector2.ZERO

# Touch input tracking
var touches: Dictionary = {}  # touch_id -> TouchData
var initial_pinch_distance: float = 0.0
var initial_rotation_angle: float = 0.0
var last_touch_center: Vector2 = Vector2.ZERO
var gesture_start_time: float = 0.0

# Momentum physics
var rotation_velocity: Vector2 = Vector2.ZERO
var pan_velocity: Vector3 = Vector3.ZERO
var zoom_velocity: float = 0.0

# Collision detection
var collision_shape: SphereShape3D
var last_valid_position: Vector3 = Vector3.ZERO
var collision_recovery_active: bool = false

# Educational tour system
var tour_waypoints: Array[Dictionary] = []
var current_tour_index: int = -1
var tour_active: bool = false
var tour_paused: bool = false
var tour_transition_progress: float = 0.0

# Haptic feedback
var haptic_enabled: bool = true
var last_haptic_time: float = 0.0

# Accessibility options
var gesture_sensitivity: float = 1.0
var invert_vertical: bool = false
var invert_horizontal: bool = false
var reduced_motion: bool = false


# ===== LIFECYCLE METHODS =====
func _ready() -> void:
	"""Initialize the advanced camera controller with tablet support"""
	add_to_group("camera_controller")
	set_process_unhandled_input(true)
	set_physics_process(true)

	# Initialize collision detection
	_initialize_collision_detection()

	# Setup touch input handling
	_setup_touch_input()

	# Load accessibility settings
	_load_accessibility_settings()

	print("[CAMERA] Advanced CameraBehaviorController initialized with tablet support")


func _unhandled_input(event: InputEvent) -> void:
	"""Handle both mouse and touch input for camera control"""
	if not camera or tour_active:
		return

	# Handle touch input
	if event is InputEventScreenTouch:
		_handle_touch_event(event)
		return

	if event is InputEventScreenDrag:
		_handle_touch_drag(event)
		return

	# Handle mouse input
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
				if event.pressed:
					zoom_velocity -= ZOOM_SPEED * 2.0
			MOUSE_BUTTON_WHEEL_DOWN:
				if event.pressed:
					zoom_velocity += ZOOM_SPEED * 2.0

	elif event is InputEventMouseMotion:
		if is_orbiting:
			var delta = event.position - last_mouse_pos
			rotation_velocity.y = -delta.x * ROTATION_SPEED * gesture_sensitivity
			rotation_velocity.x = delta.y * ROTATION_SPEED * gesture_sensitivity
			if invert_vertical:
				rotation_velocity.x *= -1
			if invert_horizontal:
				rotation_velocity.y *= -1
			last_mouse_pos = event.position

		elif (
			is_panning
			or (Input.is_key_pressed(KEY_SHIFT) and event.button_mask == MOUSE_BUTTON_MASK_LEFT)
		):
			var delta = event.position - last_mouse_pos
			var pan_delta = Vector3(
				delta.x * PAN_SPEED * camera_distance, -delta.y * PAN_SPEED * camera_distance, 0.0
			)
			var cam_transform = camera.global_transform
			pan_velocity = cam_transform.basis.x * pan_delta.x + cam_transform.basis.y * pan_delta.y
			last_mouse_pos = event.position

	# Handle keyboard shortcuts
	elif event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_R:
				reset_view()
			KEY_SPACE:
				if tour_active:
					toggle_tour_pause()
			KEY_ESCAPE:
				if tour_active:
					stop_tour()


func _physics_process(delta: float) -> void:
	"""Update camera with physics-based momentum and collision detection"""
	if not camera or not is_instance_valid(camera):
		return

	# Update educational tour if active
	if tour_active and not tour_paused:
		_update_tour(delta)
		return

	# Apply momentum physics
	var needs_update = false

	# Update rotation with momentum
	if rotation_velocity.length() > 0.001:
		target_rotation += rotation_velocity
		rotation_velocity *= MOMENTUM_DAMPING if not touches.is_empty() else TOUCH_MOMENTUM_DAMPING
		needs_update = true

	# Update pan with momentum
	if pan_velocity.length() > 0.001:
		target_pivot += pan_velocity
		pan_velocity *= MOMENTUM_DAMPING if not touches.is_empty() else TOUCH_MOMENTUM_DAMPING
		needs_update = true

	# Update zoom with momentum
	if abs(zoom_velocity) > 0.001:
		target_distance += zoom_velocity
		zoom_velocity *= MOMENTUM_DAMPING if not touches.is_empty() else TOUCH_MOMENTUM_DAMPING
		needs_update = true

	# Validate and clamp values
	if _validate_and_clamp_values():
		needs_update = true

	# Smooth interpolation (reduced for reduced motion mode)
	var smoothing = SMOOTHING if not reduced_motion else 0.5

	if needs_update or _needs_camera_update():
		camera_rotation = camera_rotation.lerp(target_rotation, smoothing)
		camera_distance = lerp(camera_distance, target_distance, smoothing)
		pivot_point = pivot_point.lerp(target_pivot, smoothing)

		# Update camera with collision detection
		_update_camera_with_collision()


# ===== PUBLIC METHODS =====
func initialize(cam: Camera3D, target: Node3D = null) -> bool:
	"""
	Initialize the camera controller with references

	@param cam: The Camera3D node to control
	@param target: The brain model for collision detection
	@returns: Success status
	"""
	camera = cam
	brain_model = target

	if camera:
		# Set initial position
		last_valid_position = camera.global_position
		_update_camera_from_state()

		# Initialize collision shape for brain model
		if brain_model:
			_update_collision_bounds()

		print("[CAMERA] Advanced camera controller initialized with tablet support")
		return true
	else:
		push_error("[CAMERA] Camera reference is null")
		return false


func focus_on_bounds(center: Vector3, size: float, instant: bool = false) -> void:
	"""
	Focus camera on specific bounds with optional instant transition

	@param center: Center point to focus on
	@param size: Size of the bounds
	@param instant: Whether to transition instantly
	"""
	target_pivot = center
	target_distance = clamp(size * 2.0, ZOOM_MIN, ZOOM_MAX)

	if instant:
		pivot_point = target_pivot
		camera_distance = target_distance
		_update_camera_from_state()

	# Trigger haptic feedback for focus action
	_trigger_haptic_feedback("focus")


func reset_view(smooth: bool = true) -> void:
	"""
	Reset camera to default educational view

	@param smooth: Whether to use smooth transition
	"""
	target_rotation = Vector2(0.3, 0.0)
	target_distance = 3.0
	target_pivot = Vector3.ZERO

	# Clear momentum
	rotation_velocity = Vector2.ZERO
	pan_velocity = Vector3.ZERO
	zoom_velocity = 0.0

	if not smooth:
		camera_rotation = target_rotation
		camera_distance = target_distance
		pivot_point = target_pivot
		_update_camera_from_state()

	camera_reset_completed.emit()
	_trigger_haptic_feedback("reset")


func set_view_preset(preset: String) -> void:
	"""
	Set camera to a medical viewing preset

	@param preset: Name of the preset (front, right, top, etc.)
	"""
	match preset:
		"front", "anterior":
			target_rotation = Vector2(0, 0)
		"back", "posterior":
			target_rotation = Vector2(0, PI)
		"right", "sagittal_right":
			target_rotation = Vector2(0, -PI / 2)
		"left", "sagittal_left":
			target_rotation = Vector2(0, PI / 2)
		"top", "superior":
			target_rotation = Vector2(PI / 2 - 0.1, 0)
		"bottom", "inferior":
			target_rotation = Vector2(-PI / 2 + 0.1, 0)
		"clinical":
			target_rotation = Vector2(0.3, 0.785398)  # 45 degrees

	gesture_recognized.emit("preset_view")


# ===== TOUCH INPUT METHODS =====
func _handle_touch_event(event: InputEventScreenTouch) -> void:
	"""
	Handle touch press and release events
	"""
	if event.pressed:
		# Add new touch
		touches[event.index] = {
			"position": event.position,
			"start_position": event.position,
			"start_time": Time.get_ticks_msec() / 1000.0
		}

		# Check for multi-finger gestures
		if touches.size() == 2:
			_start_two_finger_gesture()
		elif touches.size() == 3:
			gesture_start_time = Time.get_ticks_msec() / 1000.0
	else:
		# Remove touch
		if touches.has(event.index):
			var touch_data = touches[event.index]
			var touch_duration = Time.get_ticks_msec() / 1000.0 - touch_data["start_time"]
			var touch_distance = touch_data["position"].distance_to(touch_data["start_position"])

			# Check for tap gesture
			if touch_duration < TAP_TIME_THRESHOLD and touch_distance < TAP_THRESHOLD:
				if touches.size() == 3:  # Three finger tap
					reset_view()
					gesture_recognized.emit("three_finger_tap")

			touches.erase(event.index)


func _handle_touch_drag(event: InputEventScreenDrag) -> void:
	"""
	Handle touch drag events for gestures
	"""
	if not touches.has(event.index):
		return

	# Update touch position
	touches[event.index]["position"] = event.position

	match touches.size():
		1:
			_handle_single_touch_drag(event)
		2:
			_handle_two_finger_drag()


func _handle_single_touch_drag(event: InputEventScreenDrag) -> void:
	"""
	Handle single finger drag for camera orbit
	"""
	# Calculate rotation based on drag
	rotation_velocity.y = -event.relative.x * TOUCH_ROTATION_SPEED * gesture_sensitivity
	rotation_velocity.x = event.relative.y * TOUCH_ROTATION_SPEED * gesture_sensitivity

	if invert_vertical:
		rotation_velocity.x *= -1
	if invert_horizontal:
		rotation_velocity.y *= -1


func _handle_two_finger_drag() -> void:
	"""
	Handle two finger gestures (pinch, pan, rotate)
	"""
	var keys = touches.keys()
	if keys.size() < 2:
		return

	var touch1 = touches[keys[0]]
	var touch2 = touches[keys[1]]
	var pos1 = touch1["position"]
	var pos2 = touch2["position"]

	# Calculate gesture metrics
	var current_distance = pos1.distance_to(pos2)
	var current_center = (pos1 + pos2) * 0.5
	var current_angle = (pos2 - pos1).angle()

	# Pinch zoom
	if abs(current_distance - initial_pinch_distance) > PINCH_THRESHOLD:
		var zoom_factor = (current_distance - initial_pinch_distance) / initial_pinch_distance
		zoom_velocity = -zoom_factor * PINCH_ZOOM_SPEED * gesture_sensitivity
		initial_pinch_distance = current_distance

	# Two finger pan
	if last_touch_center != Vector2.ZERO:
		var pan_delta = current_center - last_touch_center
		var pan_3d = Vector3(
			pan_delta.x * TOUCH_PAN_SPEED * camera_distance,
			-pan_delta.y * TOUCH_PAN_SPEED * camera_distance,
			0.0
		)
		var cam_transform = camera.global_transform
		pan_velocity = cam_transform.basis.x * pan_3d.x + cam_transform.basis.y * pan_3d.y

	# Two finger rotation
	if abs(current_angle - initial_rotation_angle) > ROTATION_THRESHOLD:
		var rotation_delta = current_angle - initial_rotation_angle
		rotation_velocity.y += rotation_delta * TOUCH_ROTATION_SPEED * 0.5
		initial_rotation_angle = current_angle

	last_touch_center = current_center


func _start_two_finger_gesture() -> void:
	"""
	Initialize two finger gesture tracking
	"""
	var keys = touches.keys()
	if keys.size() >= 2:
		var pos1 = touches[keys[0]]["position"]
		var pos2 = touches[keys[1]]["position"]
		initial_pinch_distance = pos1.distance_to(pos2)
		initial_rotation_angle = (pos2 - pos1).angle()
		last_touch_center = (pos1 + pos2) * 0.5
		gesture_recognized.emit("two_finger_start")


# ===== EDUCATIONAL TOUR METHODS =====
func start_tour(tour_name: String, waypoints: Array[Dictionary]) -> void:
	"""
	Start an educational camera tour with waypoints

	@param tour_name: Name of the educational tour
	@param waypoints: Array of waypoint dictionaries with position, rotation, distance, and info
	"""
	if waypoints.is_empty():
		push_warning("[CAMERA] Cannot start tour with no waypoints")
		return

	tour_waypoints = waypoints
	current_tour_index = 0
	tour_active = true
	tour_paused = false
	tour_transition_progress = 0.0

	# Clear any momentum
	rotation_velocity = Vector2.ZERO
	pan_velocity = Vector3.ZERO
	zoom_velocity = 0.0

	tour_started.emit(tour_name)
	_trigger_haptic_feedback("tour_start")


func stop_tour() -> void:
	"""
	Stop the current educational tour
	"""
	if tour_active:
		tour_active = false
		tour_waypoints.clear()
		current_tour_index = -1
		tour_completed.emit("stopped")


func toggle_tour_pause() -> void:
	"""
	Pause or resume the current tour
	"""
	if tour_active:
		tour_paused = !tour_paused


func next_waypoint() -> void:
	"""
	Skip to the next waypoint in the tour
	"""
	if tour_active and current_tour_index < tour_waypoints.size() - 1:
		current_tour_index += 1
		tour_transition_progress = 0.0


func previous_waypoint() -> void:
	"""
	Go to the previous waypoint in the tour
	"""
	if tour_active and current_tour_index > 0:
		current_tour_index -= 1
		tour_transition_progress = 0.0


func create_waypoint_from_current() -> Dictionary:
	"""
	Create a waypoint dictionary from current camera state

	@returns: Waypoint dictionary
	"""
	return {
		"position": pivot_point,
		"rotation": camera_rotation,
		"distance": camera_distance,
		"name": "Waypoint %d" % (tour_waypoints.size() + 1),
		"duration": TOUR_PAUSE_DURATION,
		"info": ""
	}


func _update_tour(delta: float) -> void:
	"""
	Update tour progression and transitions
	"""
	if current_tour_index >= tour_waypoints.size():
		tour_active = false
		tour_completed.emit("completed")
		return

	var waypoint = tour_waypoints[current_tour_index]

	# Transition to waypoint
	if tour_transition_progress < 1.0:
		tour_transition_progress += delta / TOUR_TRANSITION_DURATION
		tour_transition_progress = min(tour_transition_progress, 1.0)

		# Smooth interpolation to waypoint
		var t = _ease_in_out_cubic(tour_transition_progress)

		if waypoint.has("position"):
			pivot_point = pivot_point.lerp(waypoint["position"], t)
		if waypoint.has("rotation"):
			camera_rotation = camera_rotation.lerp(waypoint["rotation"], t)
		if waypoint.has("distance"):
			camera_distance = lerp(camera_distance, waypoint["distance"], t)

		_update_camera_from_state()

		# Emit waypoint reached when transition completes
		if tour_transition_progress >= 1.0:
			waypoint_reached.emit(waypoint.get("name", "Waypoint %d" % current_tour_index))
			_trigger_haptic_feedback("waypoint")

	# Wait at waypoint
	else:
		var pause_duration = waypoint.get("duration", TOUR_PAUSE_DURATION)
		tour_transition_progress += delta / pause_duration

		if tour_transition_progress >= 2.0:  # 1.0 for transition + 1.0 for pause
			# Move to next waypoint
			current_tour_index += 1
			tour_transition_progress = 0.0


# ===== COLLISION DETECTION METHODS =====
func _initialize_collision_detection() -> void:
	"""
	Initialize collision detection system
	"""
	collision_shape = SphereShape3D.new()
	collision_shape.radius = COLLISION_MARGIN


func _update_collision_bounds() -> void:
	"""
	Update collision bounds based on brain model
	"""
	if not brain_model:
		return

	# Calculate brain model bounds for collision
	var aabb = _get_model_aabb(brain_model)
	if aabb.size.length() > 0:
		# Set collision sphere to encompass brain
		collision_shape.radius = aabb.size.length() * 0.5 + COLLISION_MARGIN


func _update_camera_with_collision() -> void:
	"""
	Update camera position with collision detection
	"""
	if not camera:
		return

	# Calculate desired camera position
	var pos = Vector3(
		camera_distance * cos(camera_rotation.x) * sin(camera_rotation.y),
		camera_distance * sin(camera_rotation.x),
		camera_distance * cos(camera_rotation.x) * cos(camera_rotation.y)
	)

	var desired_position = pivot_point + pos

	# Check for collision with brain model
	if brain_model and collision_shape:
		var collision_position = _check_camera_collision(desired_position)
		if collision_position != desired_position:
			# Collision detected - adjust position
			collision_detected.emit(collision_position)
			desired_position = collision_position

			# Apply gentle push away from collision
			if not collision_recovery_active:
				collision_recovery_active = true
				var push_direction = (desired_position - pivot_point).normalized()
				camera_distance += COLLISION_PUSH_STRENGTH
				_trigger_haptic_feedback("collision")
		else:
			collision_recovery_active = false

	# Validate position before applying
	if _is_valid_vector3(desired_position):
		camera.global_position = desired_position
		camera.look_at(pivot_point, Vector3.UP)
		last_valid_position = desired_position
	else:
		# Fallback to last valid position
		camera.global_position = last_valid_position
		camera.look_at(pivot_point, Vector3.UP)


func _check_camera_collision(desired_position: Vector3) -> Vector3:
	"""
	Check if camera position would collide with brain model

	@param desired_position: The desired camera position
	@returns: Adjusted position if collision detected
	"""
	if not brain_model:
		return desired_position

	# Simple sphere-based collision for now
	# Could be enhanced with actual mesh collision
	var brain_center = brain_model.global_position
	var distance_to_center = desired_position.distance_to(brain_center)

	if distance_to_center < collision_shape.radius:
		# Push camera outside collision sphere
		var direction = (desired_position - brain_center).normalized()
		return brain_center + direction * collision_shape.radius

	return desired_position


func _get_model_aabb(node: Node3D) -> AABB:
	"""
	Get combined AABB of all meshes in a node
	"""
	var aabb = AABB()
	var first = true

	# Recursively collect all MeshInstance3D nodes
	var meshes: Array[MeshInstance3D] = []
	_collect_meshes_recursive(node, meshes)

	for mesh_instance in meshes:
		if mesh_instance.mesh:
			var mesh_aabb = mesh_instance.get_aabb()
			mesh_aabb = mesh_instance.global_transform * mesh_aabb

			if first:
				aabb = mesh_aabb
				first = false
			else:
				aabb = aabb.merge(mesh_aabb)

	return aabb


func _collect_meshes_recursive(node: Node, meshes: Array[MeshInstance3D]) -> void:
	"""
	Recursively collect all MeshInstance3D nodes
	"""
	if node is MeshInstance3D:
		meshes.append(node)

	for child in node.get_children():
		_collect_meshes_recursive(child, meshes)


# ===== HAPTIC FEEDBACK METHODS =====
func _trigger_haptic_feedback(action: String) -> void:
	"""
	Trigger haptic feedback on supported devices

	@param action: Type of action for haptic intensity
	"""
	if not haptic_enabled:
		return

	# Prevent haptic spam
	var current_time = Time.get_ticks_msec() / 1000.0
	if current_time - last_haptic_time < 0.1:
		return

	last_haptic_time = current_time

	# Trigger haptic based on action type
	match action:
		"collision":
			Input.vibrate_handheld(50)  # 50ms vibration
		"waypoint":
			Input.vibrate_handheld(30)
		"focus":
			Input.vibrate_handheld(20)
		"reset":
			Input.vibrate_handheld(40)
		"tour_start":
			Input.vibrate_handheld(60)
		_:
			Input.vibrate_handheld(10)  # Light feedback


# ===== ACCESSIBILITY METHODS =====
func _setup_touch_input() -> void:
	"""
	Setup touch input handling for tablets
	"""
	# Enable multi-touch
	if OS.has_feature("mobile") or OS.has_feature("web"):
		print("[CAMERA] Touch input enabled for tablet/mobile device")


func _load_accessibility_settings() -> void:
	"""
	Load accessibility settings from user preferences
	"""
	# Check for accessibility manager
	var accessibility = get_node_or_null("/root/AccessibilityManager")
	if accessibility and accessibility.has_method("get_settings"):
		var settings = accessibility.get_settings()
		gesture_sensitivity = settings.get("gesture_sensitivity", 1.0)
		invert_vertical = settings.get("invert_vertical", false)
		invert_horizontal = settings.get("invert_horizontal", false)
		reduced_motion = settings.get("reduce_motion", false)
		haptic_enabled = settings.get("haptic_feedback", true)


func set_gesture_sensitivity(sensitivity: float) -> void:
	"""
	Set gesture sensitivity for accessibility

	@param sensitivity: Multiplier for gesture speed (0.1 to 2.0)
	"""
	gesture_sensitivity = clamp(sensitivity, 0.1, 2.0)


func set_invert_controls(vertical: bool, horizontal: bool) -> void:
	"""
	Set inverted controls for accessibility

	@param vertical: Invert vertical camera movement
	@param horizontal: Invert horizontal camera movement
	"""
	invert_vertical = vertical
	invert_horizontal = horizontal


func set_reduced_motion(enabled: bool) -> void:
	"""
	Enable reduced motion mode for accessibility

	@param enabled: Whether to reduce motion effects
	"""
	reduced_motion = enabled


func set_haptic_enabled(enabled: bool) -> void:
	"""
	Enable/disable haptic feedback

	@param enabled: Whether haptic feedback is enabled
	"""
	haptic_enabled = enabled


# ===== HELPER METHODS =====
func _update_camera_from_state() -> void:
	"""
	Update camera transform from current state (legacy compatibility)
	"""
	_update_camera_with_collision()


func _validate_and_clamp_values() -> bool:
	"""
	Validate and clamp all camera values to prevent invalid states

	@returns: Whether any values were changed
	"""
	var changed = false

	# Clamp rotation
	var clamped_x = clamp(target_rotation.x, VERTICAL_ANGLE_MIN, VERTICAL_ANGLE_MAX)
	if abs(clamped_x - target_rotation.x) > 0.001:
		target_rotation.x = clamped_x
		changed = true

	# Clamp distance
	var clamped_distance = clamp(target_distance, ZOOM_MIN, ZOOM_MAX)
	if abs(clamped_distance - target_distance) > 0.001:
		target_distance = clamped_distance
		changed = true

	# Validate vectors
	if not _is_valid_vector2(target_rotation):
		target_rotation = Vector2(0.3, 0.0)
		changed = true

	if not _is_valid_vector3(target_pivot):
		target_pivot = Vector3.ZERO
		changed = true

	return changed


func _needs_camera_update() -> bool:
	"""
	Check if camera needs updating

	@returns: Whether camera position differs from target
	"""
	var position_diff = camera_rotation.distance_to(target_rotation)
	var distance_diff = abs(camera_distance - target_distance)
	var pivot_diff = pivot_point.distance_to(target_pivot)

	return position_diff > 0.001 or distance_diff > 0.001 or pivot_diff > 0.001


func _is_valid_vector3(v: Vector3) -> bool:
	"""
	Validate Vector3 for NaN and infinity

	@param v: Vector to validate
	@returns: Whether vector is valid
	"""
	return is_finite(v.x) and is_finite(v.y) and is_finite(v.z)


func _is_valid_vector2(v: Vector2) -> bool:
	"""
	Validate Vector2 for NaN and infinity

	@param v: Vector to validate
	@returns: Whether vector is valid
	"""
	return is_finite(v.x) and is_finite(v.y)


func _reset_to_safe_values() -> void:
	"""
	Reset camera to safe default values
	"""
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


func _ease_in_out_cubic(t: float) -> float:
	"""
	Cubic ease-in-out function for smooth transitions

	@param t: Progress value (0-1)
	@returns: Eased value
	"""
	if t < 0.5:
		return 4.0 * t * t * t
	else:
		var p = 2.0 * t - 2.0
		return 1.0 + p * p * p / 2.0


# ===== LEGACY COMPATIBILITY METHODS =====
func handle_camera_input(_event: InputEvent) -> bool:
	"""Legacy compatibility - input is now handled in _unhandled_input"""
	return false


func reset_camera_position() -> void:
	"""Legacy compatibility - reset camera view"""
	reset_view()


func setup_initial_animation() -> void:
	"""Legacy compatibility - setup initial view"""
	reset_view()
	camera_animation_finished.emit()


func set_rotation_speed(speed: float) -> void:
	"""Legacy compatibility - adjust gesture sensitivity instead"""
	gesture_sensitivity = speed / ROTATION_SPEED


func set_zoom_speed(speed: float) -> void:
	"""Legacy compatibility - adjust gesture sensitivity for zoom"""
	# Convert to gesture sensitivity factor
	pass


func set_zoom_limits(min_dist: float, max_dist: float) -> void:
	"""Legacy compatibility - limits are now constants"""
	push_warning("[CAMERA] Zoom limits are now constants, cannot be changed")


func get_camera_transform() -> Transform3D:
	"""Get current camera transform"""
	if camera:
		return camera.global_transform
	return Transform3D()


func is_healthy() -> bool:
	"""Check if camera controller is healthy"""
	return camera != null and is_instance_valid(camera)


func get_health_status() -> Dictionary:
	"""Get detailed health status"""
	return {
		"healthy": is_healthy(),
		"camera_valid": camera != null,
		"position": camera.global_position if camera else Vector3.ZERO,
		"rotation": camera_rotation,
		"distance": camera_distance,
		"tour_active": tour_active,
		"touch_count": touches.size(),
		"collision_enabled": brain_model != null
	}


# ===== PUBLIC GETTERS =====
func get_current_pivot() -> Vector3:
	"""Get current pivot point"""
	return pivot_point


func get_current_distance() -> float:
	"""Get current camera distance"""
	return camera_distance


func get_current_rotation() -> Vector2:
	"""Get current camera rotation"""
	return camera_rotation


func is_tour_active() -> bool:
	"""Check if educational tour is active"""
	return tour_active


func get_tour_progress() -> float:
	"""Get current tour progress (0-1)"""
	if tour_active and not tour_waypoints.is_empty():
		return float(current_tour_index) / float(tour_waypoints.size())
	return 0.0
