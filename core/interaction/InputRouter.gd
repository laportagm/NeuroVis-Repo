## InputRouter.gd
## Centralized input handling and routing to appropriate systems
## Provides clean separation between input detection and action handling

class_name InputRouter
extends Node

# Input handling settings
@export var enable_debug_input: bool = true
@export var enable_camera_shortcuts: bool = true
@export var enable_selection_input: bool = true

# System references (injected during initialization)
var camera_controller = null
var selection_manager = null
var main_scene = null

# Input state tracking
var input_enabled: bool = true
var mouse_hover_position: Vector2
var last_input_time: float = 0.0

# Input configuration
const HOVER_UPDATE_INTERVAL: float = 0.016  # ~60fps for hover updates
const DOUBLE_CLICK_TIME: float = 0.5
var last_click_time: float = 0.0

# Signals for input events
signal input_processed(input_type: String, handled: bool)
signal camera_shortcut_triggered(shortcut: String)
signal selection_attempted(position: Vector2, button: int)
signal hover_position_changed(position: Vector2)

func _ready() -> void:
	print("[INPUT_ROUTER] Input router initialized")
	name = "InputRouter"
	process_mode = Node.PROCESS_MODE_ALWAYS

## Initialize the input router with system references
func initialize(p_main_scene: Node3D, p_camera_controller, p_selection_manager) -> void:
	"""
	Initialize the input router with references to systems that handle input
	"""
	main_scene = p_main_scene
	camera_controller = p_camera_controller
	selection_manager = p_selection_manager
	
	print("[INPUT_ROUTER] Initialized with system references")
	
	# Validate system references
	if not camera_controller:
		push_warning("[INPUT_ROUTER] Camera controller not provided - camera shortcuts disabled")
		enable_camera_shortcuts = false
	
	if not selection_manager:
		push_warning("[INPUT_ROUTER] Selection manager not provided - selection input disabled")
		enable_selection_input = false

## Main input handler - processes all input events
func _input(event: InputEvent) -> void:
	"""
	Main input event handler - routes input to appropriate systems
	"""
	if not input_enabled:
		return
	
	var handled = false
	var input_type = ""
	
	# Update last input time for activity tracking
	last_input_time = Time.get_ticks_msec() / 1000.0
	
	# Route input based on type
	if event is InputEventKey:
		input_type = "keyboard"
		handled = _handle_keyboard_input(event)
	elif event is InputEventMouseButton:
		input_type = "mouse_button"
		handled = _handle_mouse_button_input(event)
	elif event is InputEventMouseMotion:
		input_type = "mouse_motion"
		handled = _handle_mouse_motion_input(event)
	
	# Emit signal for input tracking
	input_processed.emit(input_type, handled)
	
	# Mark input as handled if we processed it
	if handled:
		get_viewport().set_input_as_handled()

## Keyboard input handling
func _handle_keyboard_input(event: InputEventKey) -> bool:
	"""
	Handle keyboard input events - primarily camera shortcuts
	"""
	if not event.pressed:
		return false
	
	# Debug shortcuts (only in debug builds)
	if enable_debug_input and OS.is_debug_build():
		if _handle_debug_shortcuts(event):
			return true
	
	# Camera shortcuts
	if enable_camera_shortcuts and camera_controller:
		return _handle_camera_shortcuts(event)
	
	return false

func _handle_camera_shortcuts(event: InputEventKey) -> bool:
	"""
	Handle camera-related keyboard shortcuts
	"""
	var shortcut_triggered = ""
	
	match event.keycode:
		KEY_F:
			# Focus on bounds
			if camera_controller.has_method("focus_on_bounds"):
				camera_controller.focus_on_bounds(Vector3.ZERO, 2.0)
				shortcut_triggered = "focus"
		
		KEY_1, KEY_KP_1:
			# Front view
			if camera_controller.has_method("set_view_preset"):
				camera_controller.set_view_preset("front")
				shortcut_triggered = "front_view"
		
		KEY_3, KEY_KP_3:
			# Right view
			if camera_controller.has_method("set_view_preset"):
				camera_controller.set_view_preset("right")
				shortcut_triggered = "right_view"
		
		KEY_7, KEY_KP_7:
			# Top view
			if camera_controller.has_method("set_view_preset"):
				camera_controller.set_view_preset("top")
				shortcut_triggered = "top_view"
		
		KEY_R:
			# Reset view
			if camera_controller.has_method("reset_view"):
				camera_controller.reset_view()
				shortcut_triggered = "reset_view"
		
		_:
			return false
	
	if not shortcut_triggered.is_empty():
		print("[INPUT_ROUTER] Camera shortcut triggered: ", shortcut_triggered)
		camera_shortcut_triggered.emit(shortcut_triggered)
		return true
	
	return false

func _handle_debug_shortcuts(event: InputEventKey) -> bool:
	"""
	Handle debug-related keyboard shortcuts
	"""
	# Debug shortcuts can be added here
	match event.keycode:
		KEY_F12:
			# Toggle debug overlay or similar
			print("[INPUT_ROUTER] Debug shortcut F12 triggered")
			return true
		_:
			return false

## Mouse input handling
func _handle_mouse_button_input(event: InputEventMouseButton) -> bool:
	"""
	Handle mouse button input events - primarily selection
	"""
	if not event.pressed:
		return false
	
	# Track click timing for double-click detection
	var current_time = Time.get_ticks_msec() / 1000.0
	var is_double_click = (current_time - last_click_time) < DOUBLE_CLICK_TIME
	last_click_time = current_time
	
	# Right mouse button - structure selection
	if event.button_index == MOUSE_BUTTON_RIGHT and enable_selection_input:
		return _handle_selection_input(event.position, event.button_index, is_double_click)
	
	# Left mouse button - could be used for other interactions
	# Currently handled by camera controller for orbiting
	
	return false

func _handle_selection_input(position: Vector2, button: int, is_double_click: bool) -> bool:
	"""
	Handle selection input at the given screen position
	"""
	if not selection_manager:
		push_warning("[INPUT_ROUTER] Selection attempted but no selection manager available")
		return false
	
	print("[INPUT_ROUTER] Selection input at position: ", position)
	selection_attempted.emit(position, button)
	
	# Route to selection manager
	if selection_manager.has_method("handle_selection_at_position"):
		selection_manager.handle_selection_at_position(position)
		return true
	else:
		push_warning("[INPUT_ROUTER] Selection manager missing handle_selection_at_position method")
		return false

func _handle_mouse_motion_input(event: InputEventMouseMotion) -> bool:
	"""
	Handle mouse motion input events - primarily hover effects
	"""
	mouse_hover_position = event.position
	
	# Throttle hover updates to improve performance
	var current_time = Time.get_ticks_msec() / 1000.0
	if current_time - last_input_time < HOVER_UPDATE_INTERVAL:
		return false
	
	hover_position_changed.emit(mouse_hover_position)
	
	# Route hover to selection manager if available
	if enable_selection_input and selection_manager:
		if selection_manager.has_method("handle_hover_at_position"):
			selection_manager.handle_hover_at_position(event.position)
			return true
	
	return false

## Input control functions
func enable_input() -> void:
	"""Enable input processing"""
	input_enabled = true
	print("[INPUT_ROUTER] Input enabled")

func disable_input() -> void:
	"""Disable input processing"""
	input_enabled = false
	print("[INPUT_ROUTER] Input disabled")

func set_input_enabled(enabled: bool) -> void:
	"""Set input enabled state"""
	input_enabled = enabled
	print("[INPUT_ROUTER] Input ", "enabled" if enabled else "disabled")

func is_input_enabled() -> bool:
	"""Check if input is currently enabled"""
	return input_enabled

## System enable/disable functions
func enable_camera_input(enabled: bool = true) -> void:
	"""Enable or disable camera input handling"""
	enable_camera_shortcuts = enabled
	print("[INPUT_ROUTER] Camera input ", "enabled" if enabled else "disabled")

func enable_selection_input_handling(enabled: bool = true) -> void:
	"""Enable or disable selection input handling"""
	enable_selection_input = enabled
	print("[INPUT_ROUTER] Selection input ", "enabled" if enabled else "disabled")

func enable_debug_input_handling(enabled: bool = true) -> void:
	"""Enable or disable debug input handling"""
	enable_debug_input = enabled
	print("[INPUT_ROUTER] Debug input ", "enabled" if enabled else "disabled")

## System reference updates
func update_camera_controller(new_camera_controller) -> void:
	"""Update the camera controller reference"""
	camera_controller = new_camera_controller
	enable_camera_shortcuts = camera_controller != null
	print("[INPUT_ROUTER] Camera controller reference updated")

func update_selection_manager(new_selection_manager) -> void:
	"""Update the selection manager reference"""
	selection_manager = new_selection_manager
	enable_selection_input = selection_manager != null
	print("[INPUT_ROUTER] Selection manager reference updated")

## Debug and status functions
func get_input_status() -> Dictionary:
	"""Get current input router status for debugging"""
	return {
		"input_enabled": input_enabled,
		"camera_shortcuts_enabled": enable_camera_shortcuts,
		"selection_input_enabled": enable_selection_input,
		"debug_input_enabled": enable_debug_input,
		"has_camera_controller": camera_controller != null,
		"has_selection_manager": selection_manager != null,
		"last_input_time": last_input_time,
		"mouse_position": mouse_hover_position
	}

func print_input_status() -> void:
	"""Print current input status for debugging"""
	var status = get_input_status()
	print("=== INPUT ROUTER STATUS ===")
	for key in status.keys():
		print("  ", key, ": ", status[key])

## Input simulation for testing
func simulate_camera_shortcut(shortcut_key: int) -> void:
	"""Simulate a camera shortcut for testing purposes"""
	if not enable_camera_shortcuts:
		print("[INPUT_ROUTER] Camera shortcuts disabled, simulation ignored")
		return
	
	var fake_event = InputEventKey.new()
	fake_event.keycode = shortcut_key
	fake_event.pressed = true
	
	print("[INPUT_ROUTER] Simulating camera shortcut: ", shortcut_key)
	_handle_camera_shortcuts(fake_event)

func simulate_selection_at_position(position: Vector2) -> void:
	"""Simulate a selection input for testing purposes"""
	if not enable_selection_input:
		print("[INPUT_ROUTER] Selection input disabled, simulation ignored")
		return
	
	print("[INPUT_ROUTER] Simulating selection at: ", position)
	_handle_selection_input(position, MOUSE_BUTTON_RIGHT, false)

## Cleanup
func _exit_tree():
	"""Clean up references when node is removed from tree"""
	camera_controller = null
	selection_manager = null
	main_scene = null
	input_enabled = false