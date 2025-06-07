## InputSystem.gd
## Focused input handling system extracted from main scene
## Handles keyboard shortcuts and mouse input with signal-based communication

class_name InputSystem
extends Node

# Signals for input events

signal structure_select_requested(position: Vector2)
signal camera_focus_requested
signal camera_reset_requested
signal camera_view_preset_requested(preset: String)

# Input state

var initialization_complete: bool = false


func _ready() -> void:
	print("[INPUT_SYSTEM] Input system initialized")
	name = "InputSystem"
	process_mode = Node.PROCESS_MODE_ALWAYS


func _unhandled_input(event: InputEvent) -> void:
	"""Handle unhandled input events"""
	if not initialization_complete:
		return

	# Handle mouse motion for hover effects if needed
	if event is InputEventMouseMotion:
		# This could emit hover signals if needed in the future
		pass


func set_initialization_complete(complete: bool) -> void:
	"""Set initialization state"""
	initialization_complete = complete
	print("[INPUT_SYSTEM] Initialization state set to: ", complete)


## Main input handler


func _input(event: InputEvent) -> void:
	"""Handle input events and emit appropriate signals"""
	if not initialization_complete:
		return

	# Handle keyboard shortcuts for camera controls
	if event is InputEventKey and event.pressed:
		if _handle_keyboard_input(event):
			get_viewport().set_input_as_handled()
			return

	# Handle mouse input - selection uses right click to avoid conflicts with camera orbiting (left click)
	if event is InputEventMouseButton:
		if _handle_mouse_input(event):
			get_viewport().set_input_as_handled()
			return


func _handle_keyboard_input(event: InputEventKey) -> bool:
	"""Handle keyboard shortcuts"""
	match event.keycode:
		KEY_F:
			# Focus on bounds
			print("[INPUT_SYSTEM] Camera focus requested")
			camera_focus_requested.emit()
			return true

		KEY_1, KEY_KP_1:
			# Front view
			print("[INPUT_SYSTEM] Front view requested")
			camera_view_preset_requested.emit("front")
			return true

		KEY_3, KEY_KP_3:
			# Right view
			print("[INPUT_SYSTEM] Right view requested")
			camera_view_preset_requested.emit("right")
			return true

		KEY_7, KEY_KP_7:
			# Top view
			print("[INPUT_SYSTEM] Top view requested")
			camera_view_preset_requested.emit("top")
			return true

		KEY_R:
			# Reset view
			print("[INPUT_SYSTEM] Camera reset requested")
			camera_reset_requested.emit()
			return true

		_:
			return false


func _handle_mouse_input(event: InputEventMouseButton) -> bool:
	"""Handle mouse button input"""
	# Handle right mouse click for selection (left is used by camera controller for orbiting)
	if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		print("[INPUT_SYSTEM] Structure selection requested at: ", event.position)
		structure_select_requested.emit(event.position)
		return true

	return false

## Unhandled input (for mouse motion and other events)
