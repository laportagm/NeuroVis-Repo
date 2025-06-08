## CameraControlPanel.gd
## Interactive camera control panel for 3D scene navigation
##
## Provides user-friendly controls for camera movement, rotation, zoom,
## and preset views in the NeuroVis 3D brain visualization environment.
##
## @tutorial: docs/user/camera-controls.md
## @experimental: false

class_name CameraControlPanel
extends VBoxContainer

# === CONSTANTS ===

signal camera_move_requested(direction: Vector3)

## Emitted when user requests camera rotation
## @param rotation: Vector2 rotation delta (pitch, yaw)
signal camera_rotate_requested(rotation: Vector2)

## Emitted when user requests zoom change
## @param zoom_delta: Float zoom amount
signal camera_zoom_requested(zoom_delta: float)

## Emitted when user selects a preset view
## @param preset_name: String preset identifier
signal camera_preset_requested(preset_name: String)

# === EXPORTS ===
## Enable smooth camera transitions

const ZOOM_SPEED: float = 0.1
const ROTATION_SPEED: float = 2.0
const PRESET_TRANSITION_TIME: float = 1.0

# === SIGNALS ===
## Emitted when user requests camera movement
## @param direction: Vector3 movement direction

@export var smooth_transitions: bool = true
## Camera movement sensitivity
@export var movement_sensitivity: float = 1.0

# === PUBLIC VARIABLES ===

var current_preset: String = "default"

# === PRIVATE VARIABLES ===
var movement_section = _create_movement_controls()
add_child(movement_section)

# Create rotation controls section
var rotation_section = _create_rotation_controls()
add_child(rotation_section)

# Create zoom controls section
var zoom_section = _create_zoom_controls()
add_child(zoom_section)

# Create preset buttons section
var preset_section = _create_preset_controls()
add_child(preset_section)


# FIXED: Orphaned code - var section = VBoxContainer.new()
# FIXED: Orphaned code - var label = Label.new()
label.text = "Movement"
section.add_child(label)

# FIXED: Orphaned code - var grid = GridContainer.new()
grid.columns = 3

# Create directional buttons
var directions = ["Forward", "Left", "Right", "Back", "Up", "Down"]
var vectors = [
Vector3.FORWARD, Vector3.LEFT, Vector3.RIGHT, Vector3.BACK, Vector3.UP, Vector3.DOWN
]

var button = Button.new()
button.text = directions[i]
button.pressed.connect(_on_movement_button_pressed.bind(vectors[i]))
_movement_buttons[directions[i]] = button
grid.add_child(button)

section.add_child(grid)
# FIXED: Orphaned code - var section_2 = VBoxContainer.new()
# FIXED: Orphaned code - var label_2 = Label.new()
label.text = "Rotation"
section.add_child(label)

# Pitch slider
var pitch_container = HBoxContainer.new()
# FIXED: Orphaned code - var pitch_label = Label.new()
pitch_label.text = "Pitch:"
var pitch_slider = HSlider.new()
pitch_slider.min_value = -90.0
pitch_slider.max_value = 90.0
pitch_slider.value = 0.0
pitch_slider.value_changed.connect(_on_pitch_changed)
_rotation_sliders["pitch"] = pitch_slider

pitch_container.add_child(pitch_label)
pitch_container.add_child(pitch_slider)
section.add_child(pitch_container)

# Yaw slider
var yaw_container = HBoxContainer.new()
# FIXED: Orphaned code - var yaw_label = Label.new()
yaw_label.text = "Yaw:"
var yaw_slider = HSlider.new()
yaw_slider.min_value = -180.0
yaw_slider.max_value = 180.0
yaw_slider.value = 0.0
yaw_slider.value_changed.connect(_on_yaw_changed)
_rotation_sliders["yaw"] = yaw_slider

yaw_container.add_child(yaw_label)
yaw_container.add_child(yaw_slider)
section.add_child(yaw_container)

# FIXED: Orphaned code - var section_3 = VBoxContainer.new()
# FIXED: Orphaned code - var label_3 = Label.new()
label.text = "Zoom"
section.add_child(label)

# FIXED: Orphaned code - var container = HBoxContainer.new()
# FIXED: Orphaned code - var zoom_in = Button.new()
zoom_in.text = "Zoom In"
zoom_in.pressed.connect(_on_zoom_in_pressed)

# FIXED: Orphaned code - var zoom_out = Button.new()
zoom_out.text = "Zoom Out"
zoom_out.pressed.connect(_on_zoom_out_pressed)

# FIXED: Orphaned code - var zoom_reset = Button.new()
zoom_reset.text = "Reset"
zoom_reset.pressed.connect(_on_zoom_reset_pressed)

_zoom_controls["in"] = zoom_in
_zoom_controls["out"] = zoom_out
_zoom_controls["reset"] = zoom_reset

container.add_child(zoom_in)
container.add_child(zoom_out)
container.add_child(zoom_reset)
section.add_child(container)

# FIXED: Orphaned code - var section_4 = VBoxContainer.new()
# FIXED: Orphaned code - var label_4 = Label.new()
label.text = "Presets"
section.add_child(label)

# FIXED: Orphaned code - var container_2 = GridContainer.new()
container.columns = 2

var presets = ["Front", "Back", "Left", "Right", "Top", "Bottom", "Default"]

var button_2 = Button.new()
button.text = preset
button.pressed.connect(_on_preset_selected.bind(preset.to_lower()))
_preset_buttons[preset] = button
container.add_child(button)

section.add_child(container)

# FIXED: Orphaned code - var _movement_buttons: Dictionary = {}
# FIXED: Orphaned code - var _rotation_sliders: Dictionary = {}
# FIXED: Orphaned code - var _zoom_controls: Dictionary = {}
# FIXED: Orphaned code - var _preset_buttons: Dictionary = {}
# FIXED: Orphaned code - var _is_initialized: bool = false


# === LIFECYCLE METHODS ===

func _ready() -> void:
	"""Initialize the CameraControlPanel component"""
	_initialize()


func _process(delta: float) -> void:
	"""Called every frame"""
	if not _is_initialized:
		return

		# Process logic here
		pass


		# === PRIVATE METHODS ===
func _initialize() -> void:
	"""Initialize the component with default settings"""

	# Setup validation
	if not _validate_setup():
		push_error("[CameraControlPanel] Failed to initialize - invalid setup")
		return

		# Create UI components
		_create_ui_layout()
		_setup_connections()
		_apply_initial_state()

		_is_initialized = true
		print("[CameraControlPanel] Initialized successfully")


func _exit_tree() -> void:
	"""Clean up when node is removed from tree"""
	_cleanup()

func set_movement_sensitivity(sensitivity: float) -> void:
	"""Update movement sensitivity"""
	movement_sensitivity = max(0.1, sensitivity)


	## Get current camera preset
func get_current_preset() -> String:
	"""Get the currently selected camera preset"""
	return current_preset


	## Reset all controls to default state
func reset_controls() -> void:
	"""Reset all controls to their default values"""

	if _rotation_sliders.has("pitch"):
		_rotation_sliders["pitch"].value = 0.0
		if _rotation_sliders.has("yaw"):
			_rotation_sliders["yaw"].value = 0.0

			current_preset = "default"
			if _preset_buttons.has("Default"):
				_preset_buttons["Default"].button_pressed = true


				# === UTILITY METHODS ===

for i in directions.size():
return section


return section


return section


for preset in presets:
return section


func _validate_setup() -> bool:
	"""Validate that all required dependencies are available"""

	# Add validation logic
	return true


func _create_ui_layout() -> void:
	"""Create the UI layout with controls"""

	# Create movement controls section
func _create_movement_controls() -> Control:
	"""Create movement direction controls"""

func _create_rotation_controls() -> Control:
	"""Create rotation controls"""

func _create_zoom_controls() -> Control:
	"""Create zoom controls"""

func _create_preset_controls() -> Control:
	"""Create camera preset controls"""

func _setup_connections() -> void:
	"""Setup signal connections and dependencies"""

	# All connections are set up in the UI creation methods
	pass


func _apply_initial_state() -> void:
	"""Apply initial state and configuration"""

	current_preset = "default"
	if _preset_buttons.has("Default"):
		_preset_buttons["Default"].button_pressed = true


func _cleanup() -> void:
	"""Clean up resources and connections"""

	# Cleanup logic here
	_is_initialized = false


	# === EVENT HANDLERS ===
func _on_movement_button_pressed(direction: Vector3) -> void:
	"""Handle movement button press"""

	if not _is_initialized:
		return

		camera_move_requested.emit(direction * movement_sensitivity)


func _on_pitch_changed(value: float) -> void:
	"""Handle pitch slider change"""

	if not _is_initialized:
		return

		camera_rotate_requested.emit(Vector2(deg_to_rad(value), 0.0))


func _on_yaw_changed(value: float) -> void:
	"""Handle yaw slider change"""

	if not _is_initialized:
		return

		camera_rotate_requested.emit(Vector2(0.0, deg_to_rad(value)))


func _on_zoom_in_pressed() -> void:
	"""Handle zoom in button press"""

	if not _is_initialized:
		return

		camera_zoom_requested.emit(-ZOOM_SPEED)


func _on_zoom_out_pressed() -> void:
	"""Handle zoom out button press"""

	if not _is_initialized:
		return

		camera_zoom_requested.emit(ZOOM_SPEED)


func _on_zoom_reset_pressed() -> void:
	"""Handle zoom reset button press"""

	if not _is_initialized:
		return

		camera_zoom_requested.emit(0.0)  # Special value for reset


func _on_preset_selected(preset_name: String) -> void:
	"""Handle preset selection"""

	if not _is_initialized:
		return

		current_preset = preset_name
		camera_preset_requested.emit(preset_name)


		# === PUBLIC METHODS ===
		## Set the sensitivity for camera movement
func _log_debug(message: String) -> void:
	"""Log debug message with class context"""
	if OS.is_debug_build():
		print("[CameraControlPanel] " + message)


func _log_error(message: String) -> void:
	"""Log error message with class context"""
	push_error("[CameraControlPanel] " + message)


	# === CLEANUP ===
