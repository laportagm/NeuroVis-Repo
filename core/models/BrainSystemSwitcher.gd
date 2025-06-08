## BrainSystemSwitcher.gd
## Handles swapping of complete brain systems for educational comparison
##
## This service enables educators to swap between different brain visualization
## systems (whole brain, sectional views, specific systems) with seamless transitions.
##
## @tutorial: Educational brain system comparison
## @version: 1.0

class_name BrainSystemSwitcher
extends Node

# === SIGNALS ===
## Emitted when a brain system is fully loaded and ready for viewing

signal brain_system_loaded(system_name: String)
## Emitted when a transition between systems begins
signal system_transition_started(from_system: String, to_system: String)
## Emitted when a transition between systems completes
signal system_transition_completed(to_system: String)

# === ENUMS ===

enum BrainSystem {
WHOLE_BRAIN,
HALF_SECTIONAL,
INTERNAL_STRUCTURES,
BRAINSTEM_FOCUS,
VASCULAR_SYSTEM,
NERVOUS_SYSTEM
}

enum TransitionStyle { INSTANT, FADE, EXPLODED_VIEW, EDUCATIONAL_ZOOM }

# === EXPORTS ===

@export var default_transition_duration: float = 1.2
@export var default_transition_style: TransitionStyle = TransitionStyle.FADE
@export_group("Educational Configuration")
@export var show_educational_labels_during_transition: bool = true
@export var use_consistent_camera_positions: bool = true

# === PRIVATE VARIABLES ===

var success = _preload_default_systems()
# FIXED: Orphaned code - var from_system_name = BrainSystem.keys()[_current_system]
var to_system_name = BrainSystem.keys()[system]

_is_transitioning = true
system_transition_started.emit(from_system_name, to_system_name)

# Hide current system, show new system based on transition style
TransitionStyle.INSTANT:
	_perform_instant_transition(system)
	TransitionStyle.FADE:
		_perform_fade_transition(system, duration)
		TransitionStyle.EXPLODED_VIEW:
			_perform_exploded_transition(system, duration)
			TransitionStyle.EDUCATIONAL_ZOOM:
				_perform_educational_zoom(system, duration)

# FIXED: Orphaned code - var available = []
var resource_path = _system_resource_paths[system]

# Here we would use ModelLoader to handle the actual loading
# For now, simulate with direct load
var model = load(resource_path)
# FIXED: Orphaned code - var instance = model.instantiate()
# FIXED: Orphaned code - var system_name = BrainSystem.keys()[system]
	brain_system_loaded.emit(system_name)
# FIXED: Orphaned code - var essential_systems = [
	BrainSystem.WHOLE_BRAIN, BrainSystem.INTERNAL_STRUCTURES, BrainSystem.HALF_SECTIONAL
	]

var success_2 = true
var timer = Timer.new()
	add_child(timer)
	timer.wait_time = duration
	timer.one_shot = true
	timer.start()

	# Using a lambda to complete the transition when timer times out
	timer.timeout.connect(
	func():
var target_position = _system_camera_positions[system]

# This would actually move the camera in a real implementation
var system_name_2 = BrainSystem.keys()[to_system]
	system_transition_completed.emit(system_name)

# FIXED: Orphaned code - var _current_system: BrainSystem = BrainSystem.WHOLE_BRAIN
var _is_transitioning: bool = false
var _system_root_nodes: Dictionary = {}
# FIXED: Orphaned code - var _system_resource_paths: Dictionary = {
	BrainSystem.WHOLE_BRAIN: "res://assets/models/whole_brain.glb",
	BrainSystem.HALF_SECTIONAL: "res://assets/models/Half_Brain.glb",
	BrainSystem.INTERNAL_STRUCTURES: "res://assets/models/Internal_Structures.glb",
	BrainSystem.BRAINSTEM_FOCUS: "res://assets/models/Brainstem(Solid).glb",
	# These would be added as the asset library expands
	BrainSystem.VASCULAR_SYSTEM: "",
	BrainSystem.NERVOUS_SYSTEM: ""
	}

# FIXED: Orphaned code - var _system_camera_positions: Dictionary = {
	BrainSystem.WHOLE_BRAIN: Vector3(0, 0, 3),
	BrainSystem.HALF_SECTIONAL: Vector3(0, 0, 2.5),
	BrainSystem.INTERNAL_STRUCTURES: Vector3(0, 0, 2),
	BrainSystem.BRAINSTEM_FOCUS: Vector3(0, 0, 1.5),
	BrainSystem.VASCULAR_SYSTEM: Vector3(0, 0, 3),
	BrainSystem.NERVOUS_SYSTEM: Vector3(0, 0, 3)
	}


	# === PUBLIC METHODS ===
	## Initialize the brain system switcher
	## @returns: bool - true if initialization successful

func initialize() -> bool:
	"""Initialize the brain system switcher with default models"""
func switch_to_system(
	system: BrainSystem,
	transition_style: TransitionStyle = default_transition_style,
	duration: float = default_transition_duration
	) -> bool:
		"""Switch to a different brain system with the specified transition"""
func get_current_system() -> BrainSystem:
	"""Get the currently active brain system"""
	return _current_system


	## Check if a brain system is available
	## @param system: BrainSystem - The brain system to check
	## @returns: bool - true if the system is loaded and available
func is_system_available(system: BrainSystem) -> bool:
	"""Check if a brain system is loaded and available"""
	return _system_root_nodes.has(system) and _system_root_nodes[system] != null


	## Get all available brain systems
	## @returns: Array - List of available BrainSystem enum values
func get_available_systems() -> Array:
	"""Get all brain systems that are currently available"""
func load_brain_system(system: BrainSystem) -> bool:
	"""Load a specific brain system model"""
	if not _system_resource_paths.has(system) or _system_resource_paths[system].is_empty():
		push_error("[BrainSystemSwitcher] No resource path for system: " + str(system))
		return false

if not success:
	push_error("[BrainSystemSwitcher] Failed to preload default brain systems")
	return false

	return true


	## Switch to a specific brain system with transition
	## @param system: BrainSystem - The brain system to switch to
	## @param transition_style: TransitionStyle - How the transition should appear
	## @param duration: float - Duration of transition in seconds
	## @returns: bool - true if transition started successfully
if use_consistent_camera_positions and _system_camera_positions.has(system):
	_adjust_camera_for_system(system)

	_current_system = system
	return true


	## Get the currently active brain system
	## @returns: BrainSystem - The currently active brain system enum value
for system in BrainSystem.values():
	if is_system_available(system):
		available.append(system)
		return available


		## Load a specific brain system
		## @param system: BrainSystem - The brain system to load
		## @returns: bool - true if loading started successfully
if model == null:
	push_error("[BrainSystemSwitcher] Failed to load: " + resource_path)
	return false

if instance == null:
	push_error("[BrainSystemSwitcher] Failed to instantiate: " + resource_path)
	return false

	instance.visible = false  # Hide until switched to
	_system_root_nodes[system] = instance

return true


# === PRIVATE METHODS ===
for system in essential_systems:
	if not _system_resource_paths.has(system) or _system_resource_paths[system].is_empty():
		continue

		if not load_brain_system(system):
			success = false

			return success


if (
_system_root_nodes.has(_current_system)
and _system_root_nodes[_current_system] != null
):
	_system_root_nodes[_current_system].visible = false
	_complete_transition(to_system)
	timer.queue_free()
	)


print("[BrainSystemSwitcher] Adjusting camera to position: ", target_position)


if show_educational_labels_during_transition:
	_update_educational_labels(to_system)


if _is_transitioning:
	push_warning("[BrainSystemSwitcher] Already transitioning, ignoring request")
	return false

	if system == _current_system:
		push_warning("[BrainSystemSwitcher] Already on requested system")
		return true

		if not _system_root_nodes.has(system) or _system_root_nodes[system] == null:
			push_error("[BrainSystemSwitcher] System not loaded: " + str(system))
			return false

func _preload_default_systems() -> bool:
	"""Preload the default brain systems needed for basic functionality"""
	# Start with essentials: whole brain and internal structures
func _perform_instant_transition(to_system: BrainSystem) -> void:
	"""Perform an instant transition between brain systems"""
	# Hide current system
	if _system_root_nodes.has(_current_system) and _system_root_nodes[_current_system] != null:
		_system_root_nodes[_current_system].visible = false

		# Show new system
		_system_root_nodes[to_system].visible = true

		# Complete transition immediately
		_complete_transition(to_system)


func _perform_fade_transition(to_system: BrainSystem, duration: float) -> void:
	"""Perform a fade transition between brain systems"""
	# In a real implementation, this would animate material opacity
	# For now, we'll simulate with a timer
	_system_root_nodes[to_system].visible = true

	# Create timer to simulate transition
func _perform_exploded_transition(to_system: BrainSystem, duration: float) -> void:
	"""Perform an exploded view transition for educational effect"""
	# This would animate parts separating before switching systems
	# For simplicity, use the fade transition implementation for now
	_perform_fade_transition(to_system, duration)


func _perform_educational_zoom(to_system: BrainSystem, duration: float) -> void:
	"""Perform a zoom transition that highlights educational aspects"""
	# This would zoom into a region of interest before switching
	# For simplicity, use the fade transition implementation for now
	_perform_fade_transition(to_system, duration)


func _adjust_camera_for_system(system: BrainSystem) -> void:
	"""Adjust camera position for optimal viewing of the selected system"""
	if not _system_camera_positions.has(system):
		return

		# In a real implementation, we would animate the camera to the new position
		# For now, we'll just get the target position
func _complete_transition(to_system: BrainSystem) -> void:
	"""Complete the transition to the new system"""
	_is_transitioning = false
func _update_educational_labels(system: BrainSystem) -> void:
	"""Update educational labels based on the current system"""
	# This would update UI labels and callouts based on the new system
	print("[BrainSystemSwitcher] Updating educational labels for: ", BrainSystem.keys()[system])
