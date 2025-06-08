## Handles all user input and interaction with the 3D scene.
##
## InteractionHandler manages mouse/keyboard input, ray casting for 3D selection,
## hover state management, and input mode switching. It acts as the bridge between
## user input and the visualization components.
##
## @tutorial: https://github.com/project/wiki/interaction-system

class_name InteractionHandler
extends ComponentBase

## Emitted when a brain region is selected

signal region_selected(region_name: String, mesh_instance: MeshInstance3D)

## Emitted when selection is cleared
signal region_deselected

## Emitted when hovering over a brain region
signal region_hovered(region_name: String, mesh_instance: MeshInstance3D)

## Emitted when hover ends
signal region_unhovered

## Emitted when camera input is detected
signal camera_input(delta: Vector2)

## Interaction modes

enum InteractionMode { NAVIGATION, SELECTION, MEASUREMENT }  ## Camera navigation mode  ## Object selection mode  ## Measurement mode (future feature)

# Current interaction state

const BrainStructureSelectionManagerScript = preload(
"res://core/interaction/BrainStructureSelectionManager.gd"
)

@export var selection_button: MouseButton = MOUSE_BUTTON_RIGHT
@export var navigation_button: MouseButton = MOUSE_BUTTON_LEFT

# Preloaded scripts

var current_mode: InteractionMode = InteractionMode.NAVIGATION
var is_interacting: bool = false

# Selection management
var selection_manager = null
var hover_position: Vector2 = Vector2.ZERO

# Camera reference for ray casting
var camera: Camera3D

# Settings


func _initialize_component() -> bool:
	component_name = "InteractionHandler"

	if not _validate_requirements():
		return false

		# Initialize selection manager
		if not _initialize_selection_manager():
			return false

			# Setup input processing
			set_process_input(true)

			return true


func _initialize_selection_manager() -> bool:
	# Create and initialize SelectionManager
	selection_manager = BrainStructureSelectionManagerScript.new()
	if selection_manager == null:
		push_error("[InteractionHandler] Failed to initialize SelectionManager")
		return false

		add_child(selection_manager)

		# Connect selection manager signals
		if selection_manager.has_signal("structure_selected"):
			selection_manager.structure_selected.connect(_on_structure_selected)
			if selection_manager.has_signal("structure_deselected"):
				selection_manager.structure_deselected.connect(_on_structure_deselected)
				if selection_manager.has_signal("structure_hovered"):
					selection_manager.structure_hovered.connect(_on_structure_hovered)
					if selection_manager.has_signal("structure_unhovered"):
						selection_manager.structure_unhovered.connect(_on_structure_unhovered)

						return true


						## Set the current interaction mode


func set_camera(cam: Camera3D) -> void:
	camera = cam


func set_mode(mode: InteractionMode) -> void:
	current_mode = mode
	print("[InteractionHandler] Mode changed to: ", InteractionMode.keys()[mode])


	## Get the current interaction mode
func get_mode() -> InteractionMode:
	return current_mode


	## Check if currently interacting
func is_currently_interacting() -> bool:
	return is_interacting


	## Configure selection highlighting colors
func configure_highlight_colors(select_color: Color, hover_color: Color) -> void:
	if selection_manager and selection_manager.has_method("configure_highlight_colors"):
		selection_manager.configure_highlight_colors(select_color, hover_color)


		## Set emission energy for highlights
func set_emission_energy(energy: float) -> void:
	if selection_manager and selection_manager.has_method("set_emission_energy"):
		selection_manager.set_emission_energy(energy)


		## Enable or disable outline effect
func set_outline_enabled(enabled: bool) -> void:
	if selection_manager and selection_manager.has_method("set_outline_enabled"):
		selection_manager.set_outline_enabled(enabled)


		## Get the currently selected structure name
func get_selected_structure_name() -> String:
	if selection_manager and selection_manager.has_method("get_selected_structure_name"):
		return selection_manager.get_selected_structure_name()
		return ""


		## Handle input events


func _validate_requirements() -> bool:
	if not is_instance_valid(camera):
		push_error("[InteractionHandler] Camera not set")
		return false

		return true


		## Set the camera reference for ray casting
func _input(event: InputEvent) -> void:
	if not is_initialized:
		return

		# Handle keyboard shortcuts
		if event is InputEventKey and event.pressed:
			_handle_keyboard_input(event)

			# Handle mouse motion for hover effects
			elif event is InputEventMouseMotion:
				hover_position = event.position
				if selection_manager:
					selection_manager.handle_hover_at_position(event.position)

					# Track if we're in navigation mode (dragging)
					if is_interacting and current_mode == InteractionMode.NAVIGATION:
						camera_input.emit(event.relative)

						# Handle mouse button input
						elif event is InputEventMouseButton:
							_handle_mouse_button(event)


func _handle_keyboard_input(event: InputEventKey) -> void:
	match event.keycode:
		KEY_1:
			set_mode(InteractionMode.NAVIGATION)
			get_viewport().set_input_as_handled()
			KEY_2:
				set_mode(InteractionMode.SELECTION)
				get_viewport().set_input_as_handled()
				KEY_ESCAPE:
					# Clear selection on escape
					if selection_manager:
						selection_manager.clear_selection()
						get_viewport().set_input_as_handled()


func _handle_mouse_button(event: InputEventMouseButton) -> void:
	# Handle selection (right click by default)
	if event.button_index == selection_button:
		if event.pressed:
			if selection_manager:
				selection_manager.handle_selection_at_position(event.position)
				get_viewport().set_input_as_handled()

				# Handle navigation (left click by default)
				elif event.button_index == navigation_button:
					is_interacting = event.pressed
					if event.pressed:
						current_mode = InteractionMode.NAVIGATION

						# Handle middle mouse for panning
						elif event.button_index == MOUSE_BUTTON_MIDDLE:
							is_interacting = event.pressed


							# Signal handlers from SelectionManager
func _on_structure_selected(structure_name: String, mesh: MeshInstance3D) -> void:
	region_selected.emit(structure_name, mesh)


func _on_structure_deselected() -> void:
	region_deselected.emit()


func _on_structure_hovered(structure_name: String, mesh: MeshInstance3D) -> void:
	region_hovered.emit(structure_name, mesh)


func _on_structure_unhovered() -> void:
	region_unhovered.emit()


func _cleanup_component() -> void:
	selection_manager = null
	camera = null
	set_process_input(false)


func _get_custom_status() -> Dictionary:
	return {
	"current_mode": InteractionMode.keys()[current_mode],
	"is_interacting": is_interacting,
	"selected_structure": get_selected_structure_name(),
	"hover_position": hover_position
	}
