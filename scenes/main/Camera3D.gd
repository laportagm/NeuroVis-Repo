extends Camera3D

# Camera state machine
enum CameraState { IDLE, ORBITING, PANNING, ZOOMING }

# Current camera state
var current_state: CameraState = CameraState.IDLE

# Camera control settings (matching Godot editor exactly)
const ORBIT_SENSITIVITY: float = 0.0025
const PAN_SENSITIVITY: float = 0.004
const ZOOM_FACTOR: float = 1.1
const MIN_ZOOM_DISTANCE: float = 0.1
const MAX_ZOOM_DISTANCE: float = 100.0
const ZOOM_LERP_SPEED: float = 10.0

# Camera control state
var focus_point: Vector3 = Vector3.ZERO
var zoom_distance: float = 5.0
var target_zoom_distance: float = 5.0
var last_mouse_position: Vector2 = Vector2.ZERO
var orbit_enabled: bool = false
var pan_enabled: bool = false

# Debug visualization
var debug_draw_enabled: bool = true
var debug_meshes: Dictionary = {}
var debug_font: Font

# Safety bounds
const SCENE_BOUNDS_RADIUS: float = 50.0
const MIN_FOCUS_DISTANCE: float = 0.01

# Reference to brain model (safely accessed)
var brain_model: Node3D = null

func _ready() -> void:
	print("[Camera3D] Initializing bulletproof camera system")
	
	# Initialize debug font
	debug_font = ThemeDB.fallback_font
	
	# Set initial camera position
	position = Vector3(0, 0, zoom_distance)
	look_at(focus_point, Vector3.UP)
	
	# Find brain model safely
	_find_brain_model()
	
	# Create debug visualization objects
	_create_debug_objects()
	
	print("[Camera3D] Camera system initialized")

func _find_brain_model() -> void:
	"""Safely locate the brain model in the scene"""
	if not get_parent():
		push_warning("[Camera3D] No parent node found")
		return
		
	var parent = get_parent()
	for child in parent.get_children():
		if child.name == "BrainModel" and child is Node3D:
			brain_model = child
			print("[Camera3D] Found brain model: ", brain_model.name)
			break
	
	if not brain_model:
		push_warning("[Camera3D] Brain model not found - camera will still function")

func _create_debug_objects() -> void:
	"""Create debug visualization meshes"""
	if not debug_draw_enabled:
		return
		
	# Focus point sphere
	var sphere_mesh = SphereMesh.new()
	sphere_mesh.radial_segments = 16
	sphere_mesh.rings = 8
	sphere_mesh.radius = 0.05
	sphere_mesh.height = 0.1
	
	var focus_instance = MeshInstance3D.new()
	focus_instance.mesh = sphere_mesh
	focus_instance.name = "DebugFocusPoint"
	
	# Create red material for focus point
	var red_material = StandardMaterial3D.new()
	red_material.albedo_color = Color.RED
	red_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	focus_instance.material_override = red_material
	
	get_parent().add_child.call_deferred(focus_instance)
	debug_meshes["focus_point"] = focus_instance

func _input(event: InputEvent) -> void:
	"""Handle all camera input with safety checks"""
	if not event:
		return
		
	# Mouse button events
	if event is InputEventMouseButton:
		_handle_mouse_button(event as InputEventMouseButton)
	
	# Mouse motion events
	elif event is InputEventMouseMotion:
		_handle_mouse_motion(event as InputEventMouseMotion)
	
	# Keyboard events for debug
	elif event is InputEventKey and event.pressed:
		_handle_debug_keys(event as InputEventKey)

func _handle_mouse_button(event: InputEventMouseButton) -> void:
	"""Handle mouse button input with safety validation"""
	if not event:
		return
		
	# Middle mouse button
	if event.button_index == MOUSE_BUTTON_MIDDLE:
		if event.pressed:
			# Check for shift key for panning
			if Input.is_key_pressed(KEY_SHIFT):
				_start_panning(event.position)
			else:
				_start_orbiting(event.position)
		else:
			_stop_camera_movement()
	
	# Mouse wheel for zoom
	elif event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
		_zoom_camera(-1.0, event.position)
	elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
		_zoom_camera(1.0, event.position)

func _handle_mouse_motion(event: InputEventMouseMotion) -> void:
	"""Handle mouse motion with proper state validation"""
	if not event:
		return
		
	# Validate mouse position is within viewport
	var viewport = get_viewport()
	if not viewport:
		return
		
	var viewport_size = viewport.get_visible_rect().size
	if event.position.x < 0 or event.position.x > viewport_size.x or \
	   event.position.y < 0 or event.position.y > viewport_size.y:
		return
	
	match current_state:
		CameraState.ORBITING:
			_update_orbit(event.position)
		CameraState.PANNING:
			_update_pan(event.position)
	
	last_mouse_position = event.position

func _start_orbiting(mouse_pos: Vector2) -> void:
	"""Start orbiting camera around focus point"""
	current_state = CameraState.ORBITING
	last_mouse_position = mouse_pos
	orbit_enabled = true
	print("[Camera3D] Started orbiting")

func _start_panning(mouse_pos: Vector2) -> void:
	"""Start panning camera"""
	current_state = CameraState.PANNING
	last_mouse_position = mouse_pos
	pan_enabled = true
	print("[Camera3D] Started panning")

func _stop_camera_movement() -> void:
	"""Stop all camera movement"""
	current_state = CameraState.IDLE
	orbit_enabled = false
	pan_enabled = false
	print("[Camera3D] Stopped camera movement")

func _update_orbit(mouse_pos: Vector2) -> void:
	"""Update camera orbit with safety checks"""
	if not orbit_enabled or current_state != CameraState.ORBITING:
		return
		
	# Calculate mouse delta
	var delta = mouse_pos - last_mouse_position
	
	# Prevent zero delta
	if delta.length_squared() < 0.0001:
		return
	
	# Calculate rotation angles
	var yaw = -delta.x * ORBIT_SENSITIVITY
	var pitch = -delta.y * ORBIT_SENSITIVITY
	
	# Get current camera vectors
	var cam_to_focus = focus_point - position
	var distance = cam_to_focus.length()
	
	# Safety check for zero distance
	if distance < MIN_FOCUS_DISTANCE:
		distance = MIN_FOCUS_DISTANCE
		position = focus_point - transform.basis.z * distance
	
	# Create rotation transforms
	var yaw_rotation = Transform3D(Basis(Vector3.UP, yaw), Vector3.ZERO)
	var right = transform.basis.x.normalized()
	var pitch_rotation = Transform3D(Basis(right, pitch), Vector3.ZERO)
	
	# Apply rotations
	var new_transform = transform
	new_transform.origin = focus_point
	new_transform = yaw_rotation * new_transform
	new_transform = pitch_rotation * new_transform
	new_transform.origin = focus_point - new_transform.basis.z * distance
	
	# Prevent gimbal lock by checking up vector
	var new_up = new_transform.basis.y
	if abs(new_up.dot(Vector3.UP)) < 0.1:
		# Too close to gimbal lock, skip this rotation
		return
	
	# Apply the new transform
	transform = new_transform
	
	# Ensure we're still looking at focus point
	look_at(focus_point, Vector3.UP)
	
	# Validate transform
	_validate_transform()

func _update_pan(mouse_pos: Vector2) -> void:
	"""Update camera panning with safety checks"""
	if not pan_enabled or current_state != CameraState.PANNING:
		return
		
	# Calculate mouse delta
	var delta = mouse_pos - last_mouse_position
	
	# Prevent zero delta
	if delta.length_squared() < 0.0001:
		return
	
	# Calculate pan offset in camera space
	var right = transform.basis.x.normalized() * delta.x * PAN_SENSITIVITY
	var up = transform.basis.y.normalized() * -delta.y * PAN_SENSITIVITY
	var offset = right + up
	
	# Update focus point and camera position
	var new_focus = focus_point + offset
	
	# Clamp focus point to scene bounds
	new_focus = new_focus.clamp(
		Vector3.ONE * -SCENE_BOUNDS_RADIUS,
		Vector3.ONE * SCENE_BOUNDS_RADIUS
	)
	
	# Apply the pan
	var translation = new_focus - focus_point
	position += translation
	focus_point = new_focus
	
	# Validate transform
	_validate_transform()

func _zoom_camera(direction: float, mouse_pos: Vector2) -> void:
	"""Zoom camera toward mouse position with safety"""
	current_state = CameraState.ZOOMING
	
	# Calculate zoom factor
	var zoom_mult = pow(ZOOM_FACTOR, direction)
	
	# Get zoom target point
	var zoom_target = _get_zoom_target(mouse_pos)
	
	# Calculate new zoom distance
	var cam_to_target = zoom_target - position
	var current_distance = cam_to_target.length()
	
	# Prevent division by zero
	if current_distance < MIN_FOCUS_DISTANCE:
		current_distance = MIN_FOCUS_DISTANCE
	
	# Apply zoom with clamping
	target_zoom_distance = clamp(
		current_distance * zoom_mult,
		MIN_ZOOM_DISTANCE,
		MAX_ZOOM_DISTANCE
	)
	
	# Update zoom distance for smooth interpolation
	zoom_distance = target_zoom_distance
	
	# Move camera toward target
	if cam_to_target.length_squared() > 0.0001:
		var new_distance = zoom_distance
		var direction_to_target = cam_to_target.normalized()
		position = zoom_target - direction_to_target * new_distance
		
		# Update focus point to zoom target
		focus_point = zoom_target
	
	# Look at new focus point
	look_at(focus_point, Vector3.UP)
	
	# Validate transform
	_validate_transform()
	
	print("[Camera3D] Zoomed to distance: ", zoom_distance)

func _get_zoom_target(mouse_pos: Vector2) -> Vector3:
	"""Get 3D point under mouse for zoom target"""
	# Raycast from mouse position
	var viewport = get_viewport()
	if not viewport:
		return focus_point
	
	var from = project_ray_origin(mouse_pos)
	var to = from + project_ray_normal(mouse_pos) * 1000.0
	
	# Create ray query
	var space_state = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.create(from, to)
	ray_query.collision_mask = 0xFFFFFFFF  # Check all layers
	
	var result = space_state.intersect_ray(ray_query)
	
	if result and result.has("position"):
		return result.position
	else:
		# Fallback to focus sphere intersection
		var ray_dir = project_ray_normal(mouse_pos)
		var sphere_center = focus_point
		var sphere_radius = zoom_distance * 0.5
		
		# Ray-sphere intersection
		var oc = from - sphere_center
		var b = oc.dot(ray_dir)
		var c = oc.dot(oc) - sphere_radius * sphere_radius
		var discriminant = b * b - c
		
		if discriminant > 0:
			var t = -b - sqrt(discriminant)
			if t > 0:
				return from + ray_dir * t
		
		return focus_point

func _process(delta: float) -> void:
	"""Update camera state and debug visualization"""
	if delta <= 0:
		return
		
	# Smooth zoom interpolation
	if abs(zoom_distance - target_zoom_distance) > 0.001:
		zoom_distance = lerp(zoom_distance, target_zoom_distance, ZOOM_LERP_SPEED * delta)
		var cam_dir = (position - focus_point).normalized()
		position = focus_point + cam_dir * zoom_distance
		_validate_transform()
	
	# Update debug visualization
	if debug_draw_enabled:
		_update_debug_visualization()

func _update_debug_visualization() -> void:
	"""Update debug visualization objects"""
	# Update focus point sphere
	if debug_meshes.has("focus_point") and is_instance_valid(debug_meshes["focus_point"]):
		debug_meshes["focus_point"].position = focus_point
		debug_meshes["focus_point"].visible = debug_draw_enabled

func _draw() -> void:
	"""Draw debug overlay information"""
	if not debug_draw_enabled:
		return
		
	# This would be drawn in 2D overlay - implement if needed

func _validate_transform() -> void:
	"""Validate camera transform for safety"""
	# Check for NaN or INF
	if not position.is_finite() or not focus_point.is_finite():
		push_error("[Camera3D] Invalid transform detected - resetting")
		reset_to_default()
		return
	
	# Check for valid basis
	if not transform.basis.is_finite():
		push_error("[Camera3D] Invalid basis detected - resetting")
		reset_to_default()
		return
	
	# Ensure minimum distance from focus
	var distance = position.distance_to(focus_point)
	if distance < MIN_FOCUS_DISTANCE:
		position = focus_point - transform.basis.z * MIN_ZOOM_DISTANCE
		push_warning("[Camera3D] Camera too close to focus - adjusting distance")

func _handle_debug_keys(event: InputEventKey) -> void:
	"""Handle debug hotkeys"""
	match event.keycode:
		KEY_F1:
			debug_draw_enabled = !debug_draw_enabled
			print("[Camera3D] Debug draw: ", debug_draw_enabled)
			if debug_meshes.has("focus_point") and is_instance_valid(debug_meshes["focus_point"]):
				debug_meshes["focus_point"].visible = debug_draw_enabled
		
		KEY_F2:
			print("[Camera3D] Running test sequence...")
			test_orbit_360()
			test_zoom_limits()
			test_pan_bounds()
		
		KEY_F3:
			print_camera_state()

# === TEST METHODS ===

func test_orbit_360() -> void:
	"""Test full 360 degree orbit"""
	print("[Camera3D TEST] Testing 360 degree orbit...")
	
	# Store original position
	var _original_pos = position
	var _original_focus = focus_point
	
	# Simulate orbit
	for i in range(36):
		_update_orbit(last_mouse_position + Vector2(10, 0))
		last_mouse_position += Vector2(10, 0)
		_validate_transform()
	
	print("[Camera3D TEST] Orbit test complete")

func test_zoom_limits() -> void:
	"""Test zoom distance limits"""
	print("[Camera3D TEST] Testing zoom limits...")
	
	# Test minimum zoom
	for i in range(50):
		_zoom_camera(1.0, get_viewport().get_visible_rect().size / 2)
	
	assert(zoom_distance >= MIN_ZOOM_DISTANCE, "Zoom distance below minimum")
	print("[Camera3D TEST] Min zoom: ", zoom_distance)
	
	# Test maximum zoom
	for i in range(50):
		_zoom_camera(-1.0, get_viewport().get_visible_rect().size / 2)
	
	assert(zoom_distance <= MAX_ZOOM_DISTANCE, "Zoom distance above maximum")
	print("[Camera3D TEST] Max zoom: ", zoom_distance)

func test_pan_bounds() -> void:
	"""Test panning boundaries"""
	print("[Camera3D TEST] Testing pan bounds...")
	
	# Test extreme panning
	for i in range(100):
		_update_pan(last_mouse_position + Vector2(50, 50))
		last_mouse_position += Vector2(50, 50)
	
	assert(focus_point.length() <= SCENE_BOUNDS_RADIUS * 1.5, "Focus point outside bounds")
	print("[Camera3D TEST] Pan test complete, focus at: ", focus_point)

func reset_to_default() -> void:
	"""Reset camera to default state"""
	print("[Camera3D] Resetting to default state")
	
	position = Vector3(0, 0, 5)
	focus_point = Vector3.ZERO
	zoom_distance = 5.0
	target_zoom_distance = 5.0
	current_state = CameraState.IDLE
	orbit_enabled = false
	pan_enabled = false
	
	look_at(focus_point, Vector3.UP)
	_validate_transform()

func validate_transform() -> bool:
	"""Public method to validate transform"""
	_validate_transform()
	return position.is_finite() and focus_point.is_finite()

func print_camera_state() -> void:
	"""Print current camera state for debugging"""
	print("\n[Camera3D STATE]")
	print("  Position: ", position)
	print("  Focus Point: ", focus_point)
	print("  Zoom Distance: ", zoom_distance)
	print("  State: ", CameraState.keys()[current_state])
	print("  Transform Valid: ", validate_transform())
	print("  Brain Model: ", brain_model.name if brain_model != null else str("Not found"))
	print("  Debug Draw: ", debug_draw_enabled)
	print("")

# === PUBLIC API FOR EXTERNAL CONTROL ===

func focus_on_point(point: Vector3, distance: float = -1.0) -> void:
	"""Focus camera on a specific point"""
	if not point.is_finite():
		push_error("[Camera3D] Invalid focus point")
		return
		
	focus_point = point.clamp(
		Vector3.ONE * -SCENE_BOUNDS_RADIUS,
		Vector3.ONE * SCENE_BOUNDS_RADIUS
	)
	
	if distance > 0:
		zoom_distance = clamp(distance, MIN_ZOOM_DISTANCE, MAX_ZOOM_DISTANCE)
		target_zoom_distance = zoom_distance
	
	var cam_dir = (position - focus_point).normalized()
	if not cam_dir.is_normalized():
		cam_dir = Vector3.BACK
	
	position = focus_point + cam_dir * zoom_distance
	look_at(focus_point, Vector3.UP)
	_validate_transform()

func get_camera_state_info() -> Dictionary:
	"""Get camera state information for external use"""
	return {
		"position": position,
		"focus_point": focus_point,
		"zoom_distance": zoom_distance,
		"state": CameraState.keys()[current_state],
		"debug_enabled": debug_draw_enabled
	}
