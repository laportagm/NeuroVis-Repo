## CameraSystem.gd
## Focused camera management system extracted from main scene
## Owns the Camera3D node and provides high-level camera operations

class_name CameraSystem
extends Node3D

# Camera node reference

signal camera_ready
signal focus_completed
signal reset_completed


var camera_distance: float = 5.0
var camera_rotation: Vector2 = Vector2(0.3, 0.0)
var pivot_point: Vector3 = Vector3.ZERO

# Camera behavior controller reference
var camera_controller = null

# Initialization state
var initialization_complete: bool = false

# Signals
	var center = bounds.get_center()
	var size = bounds.size.length()
	var distance = max(size * 1.5, 2.0)

	# Position camera to look at the center
	var direction = Vector3(0, 0, 1).normalized()
	camera.global_position = center + direction * distance
	camera.look_at(center, Vector3.UP)

	print("[CAMERA_SYSTEM] Manual focus on bounds completed")
	focus_completed.emit()


	var direction = Vector3(0, 0, 1).normalized()
	camera.global_position = center + direction * distance
	camera.look_at(center, Vector3.UP)

	print("[CAMERA_SYSTEM] Manual focus on center completed")
	focus_completed.emit()


	var cam_position: Vector3
	var target = Vector3.ZERO

	match preset:
		"front":
			cam_position = Vector3(0, 0, 10)
		"back":
			cam_position = Vector3(0, 0, -10)
		"right":
			cam_position = Vector3(10, 0, 0)
		"left":
			cam_position = Vector3(-10, 0, 0)
		"top":
			cam_position = Vector3(0, 10, 0)
		"bottom":
			cam_position = Vector3(0, -10, 0)
		_:
			print("[CAMERA_SYSTEM] Unknown preset: ", preset)
			return

	camera.global_position = cam_position
	camera.look_at(target, Vector3.UP)

	print("[CAMERA_SYSTEM] Manual view preset '", preset, "' set")


## Camera information methods

@onready var camera: Camera3D = $Camera3D

# Camera state variables

func _ready() -> void:
	print("[CAMERA_SYSTEM] Camera system initialized")
	name = "CameraSystem"

	# Create simple camera controller if none exists
	if not camera_controller:
		_create_simple_controller()

	camera_ready.emit()


func initialize_camera_controller(controller) -> void:
	"""Initialize the camera controller with our camera reference"""
	camera_controller = controller
	if camera_controller and camera:
		camera_controller.initialize(camera)
		print("[CAMERA_SYSTEM] Camera controller initialized with camera reference")


func set_initialization_complete(complete: bool) -> void:
	"""Set initialization state"""
	initialization_complete = complete
	print("[CAMERA_SYSTEM] Initialization state set to: ", complete)


## Public camera methods
func get_camera() -> Camera3D:
	"""Get the camera node reference"""
	return camera


func focus_on_bounds(bounds: AABB) -> void:
	"""Focus camera on given bounds"""
	if not initialization_complete:
		print("[CAMERA_SYSTEM] Cannot focus - system not initialized")
		return

	if camera_controller and camera_controller.has_method("focus_on_bounds"):
		camera_controller.focus_on_bounds(bounds.get_center(), bounds.size.length())
		print("[CAMERA_SYSTEM] Focusing on bounds: ", bounds)
		focus_completed.emit()
	else:
		# Fallback manual focus
		_manual_focus_on_bounds(bounds)


func focus_on_center(center: Vector3, distance: float = 5.0) -> void:
	"""Focus camera on a specific point"""
	if not camera:
		print("[CAMERA_SYSTEM] Cannot focus - camera not found")
		return

	# Always use manual focus for simple controller
	_manual_focus_on_center(center, distance)


func reset_view() -> void:
	"""Reset camera to default position"""
	if not camera:
		print("[CAMERA_SYSTEM] Cannot reset - camera not found")
		return

	# Always use manual reset for simple controller
	_manual_reset_view()


func set_view_preset(preset: String) -> void:
	"""Set camera to a view preset (front, right, top, etc.)"""
	if not camera:
		print("[CAMERA_SYSTEM] Cannot set preset - camera not found")
		return

	# Always use manual preset for simple controller
	_manual_set_view_preset(preset)


## Camera validation
func validate_camera() -> bool:
	"""Validate that camera node exists and is properly configured"""
	if camera == null:
		print("[CAMERA_SYSTEM] ERROR: Camera not found")
		return false

	if not camera is Camera3D:
		print("[CAMERA_SYSTEM] ERROR: Camera node is not a Camera3D")
		return false

	print("[CAMERA_SYSTEM] Camera validation successful")
	return true


## Manual camera operations (fallback when no controller available)
func get_camera_position() -> Vector3:
	"""Get current camera position"""
	return camera.global_position if camera else Vector3.ZERO


func get_camera_rotation() -> Vector3:
	"""Get current camera rotation"""
	return camera.global_rotation_degrees if camera else Vector3.ZERO


func get_camera_distance() -> float:
	"""Get current camera distance from pivot"""
	return camera_distance


func is_camera_available() -> bool:
	"""Check if camera is available and valid"""
	return camera != null and camera is Camera3D


## Debug methods
func print_camera_info() -> void:
	"""Print camera information for debugging"""
	if not camera:
		print("[CAMERA_SYSTEM] No camera available")
		return

	print("=== CAMERA SYSTEM INFO ===")
	print("Position: ", camera.global_position)
	print("Rotation: ", camera.global_rotation_degrees)
	print("Distance: ", camera_distance)
	print("Controller: ", "Available" if camera_controller else "Not available")
	print("Initialized: ", initialization_complete)

func _manual_focus_on_bounds(bounds: AABB) -> void:
	"""Manual focus implementation"""
	if not camera:
		return

func _manual_focus_on_center(center: Vector3, distance: float) -> void:
	"""Manual focus on center implementation"""
	if not camera:
		return

	# Position camera to look at the center
func _manual_reset_view() -> void:
	"""Manual camera reset implementation"""
	if not camera:
		return

	# Reset to default position
	camera.global_position = Vector3(0, 5, 10)
	camera.look_at(Vector3.ZERO, Vector3.UP)
	camera_distance = 5.0
	camera_rotation = Vector2(0.3, 0.0)

	print("[CAMERA_SYSTEM] Manual camera reset completed")
	reset_completed.emit()


func _create_simple_controller() -> void:
	"""Create a simple internal camera controller"""
	camera_controller = {"initialized": true, "camera": camera}
	initialization_complete = true
	print("[CAMERA_SYSTEM] Simple internal camera controller created")


func _manual_set_view_preset(preset: String) -> void:
	"""Manual view preset implementation"""
	if not camera:
		return

