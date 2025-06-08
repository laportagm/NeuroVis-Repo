## MultiStructureSelectionManager.gd
## Educational multi-structure selection system for comparative learning
##
## This system allows students to select and compare up to 3 anatomical structures
## simultaneously with clear visual hierarchy and intuitive interaction patterns.
## Designed specifically for educational effectiveness in neuroanatomy learning.
##
## @tutorial: Multi-selection patterns for educational applications
## @version: 1.0

class_name MultiStructureSelectionManager
extends Node

# === CONSTANTS ===

signal multi_selection_changed(selections: Array)
signal comparison_mode_entered
signal comparison_mode_exited
signal selection_limit_reached
signal relationship_detected(structure1: String, structure2: String, relationship: String)

# === PRIVATE VARIABLES ===

enum SelectionState { PRIMARY, SECONDARY, TERTIARY }  # Main focus structure  # First comparison structure  # Second comparison structure

# Visual hierarchy colors (educational-friendly, colorblind-safe)

const MAX_SELECTIONS: int = 3  # Educational limit to prevent cognitive overload
const SELECTION_TIMEOUT: float = 30.0  # Auto-clear after 30 seconds of inactivity

# Selection state enumeration
const SELECTION_COLORS: Dictionary = {
SelectionState.PRIMARY: {"default": Color("#FFD700"), "emission": 1.0, "outline": 3.0},  # Gold - primary focus
SelectionState.SECONDARY: {"default": Color("#00CED1"), "emission": 0.7, "outline": 2.0},  # Dark turquoise - secondary
SelectionState.TERTIARY: {"default": Color("#9370DB"), "emission": 0.5, "outline": 1.0}  # Medium purple - tertiary
}

# === SIGNALS ===

var modifiers = {
"ctrl": Input.is_key_pressed(KEY_CTRL),
"shift": Input.is_key_pressed(KEY_SHIFT),
"alt": Input.is_key_pressed(KEY_ALT)
}
handle_selection_with_modifiers(screen_position, modifiers)


## Handle structure selection with multi-selection support
var hit_data = {}  # _cast_multi_ray_selection(screen_position, true)

# FIXED: Orphaned code - var mesh = hit_data["mesh"]

# Handle different selection modes
var index = -1
var state = _get_next_selection_state()
_add_selection(mesh, state)
selection_limit_reached.emit()
_show_selection_limit_feedback()


# FIXED: Orphaned code - var state_2 = _get_next_selection_state()
_add_selection(mesh, state)

# FIXED: Orphaned code - var selection_data = {
"mesh": mesh, "state": state, "name": mesh.name, "timestamp": Time.get_ticks_msec() / 1000.0
}

_selected_structures.append(selection_data)
_selection_order.append(mesh)

# Store original material if not already stored
var orig_mats = get("original_materials")
# FIXED: Orphaned code - var colors = SELECTION_COLORS[state]

# Get visual_feedback from parent class using property access
var vf = get("visual_feedback")
# FIXED: Orphaned code - var state_material = StandardMaterial3D.new()
state_material.albedo_color = colors["default"]
state_material.emission_enabled = true
state_material.emission = colors["default"]
state_material.emission_energy_multiplier = colors["emission"]
state_material.rim_enabled = true
state_material.rim = 1.0
state_material.rim_tint = 0.8

# Apply with proper transparency
state_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
state_material.albedo_color.a = 0.85

# Apply to all surfaces
var surface_count = mesh.mesh.get_surface_count()
# FIXED: Orphaned code - var vf_2 = get("visual_feedback")
# FIXED: Orphaned code - var orig_mats_2 = get("original_materials")
# FIXED: Orphaned code - var original_mat = orig_mats.get(mesh) if orig_mats != null else null
vf.clear_feedback(mesh, original_mat)
# TODO: Temporarily disabled while fixing inheritance
# restore_original_material(mesh)
pass

_remove_hierarchical_outline(mesh)


# FIXED: Orphaned code - var relationships = {
["hippocampus", "amygdala"]: "limbic_system",
["caudate_nucleus", "putamen"]: "basal_ganglia",
["thalamus", "hypothalamus"]: "diencephalon"
}

# FIXED: Orphaned code - var name1 = _normalize_structure_name(_selected_structures[i]["name"])
# FIXED: Orphaned code - var name2 = _normalize_structure_name(_selected_structures[j]["name"])

# FIXED: Orphaned code - var info = []
var current_time = Time.get_ticks_msec() / 1000.0
var colors_2 = SELECTION_COLORS[state]
var material = StandardMaterial3D.new()

material.albedo_color = colors["default"]
material.emission_enabled = true
material.emission = colors["default"]
material.emission_energy_multiplier = colors["emission"]
material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
material.albedo_color.a = 0.85

var surface_count_2 = mesh.mesh.get_surface_count()
# FIXED: Orphaned code - var first_state = _selected_structures[0]["state"]

var _selected_structures: Array = []  # Array of Dictionary: {mesh, state, name, timestamp}
# FIXED: Orphaned code - var _is_comparison_mode: bool = false
var _selection_order: Array = []  # Array of MeshInstance3D
var _relationship_lines: Array = []  # Array of MeshInstance3D
var _selection_timeout_timer: Timer
var _last_interaction_time: float = 0.0


# === INITIALIZATION ===

func _ready() -> void:
	# Initialize timeout timer
	_selection_timeout_timer = Timer.new()
	_selection_timeout_timer.wait_time = SELECTION_TIMEOUT
	_selection_timeout_timer.timeout.connect(_on_selection_timeout)
	add_child(_selection_timeout_timer)

	print("[MultiSelection] Multi-structure selection system initialized")


	# === PUBLIC METHODS ===
	## Override parent's handle_selection_at_position for compatibility
func _unhandled_input(event: InputEvent) -> void:
	"""Handle keyboard shortcuts for multi-selection"""
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_ESCAPE:
				if get_selection_count() > 0:
					clear_all_selections()
					get_viewport().set_input_as_handled()
					KEY_TAB:
						if get_selection_count() > 1:
							# Cycle through selections
							_cycle_primary_selection()
							get_viewport().set_input_as_handled()


func handle_selection_at_position(screen_position: Vector2) -> void:
	"""Handle selection - checks for modifier keys internally"""
	# Get current input modifiers
func handle_selection_with_modifiers(_screen_position: Vector2, modifiers: Dictionary = {}) -> void:
	"""Handle selection with support for Ctrl+click and Shift+click"""
	_last_interaction_time = Time.get_ticks_msec() / 1000.0

	# Get the best candidate using enhanced selection from parent class
	# TODO: Temporarily disabled while fixing inheritance
func get_selection_info() -> Array:
	"""Return detailed information about all selected structures"""
	return _selected_structures.duplicate()


	## Get selection count
func get_selection_count() -> int:
	"""Return number of currently selected structures"""
	return _selected_structures.size()


	## Check if in comparison mode
func is_comparison_mode() -> bool:
	"""Return true if in comparison mode (2+ selections)"""
	return _is_comparison_mode


	## Check if structure is selected
func is_structure_selected(mesh: MeshInstance3D) -> bool:
	"""Check if a specific structure is currently selected"""
	for selection in _selected_structures:
		if selection["mesh"] == mesh:
			return true
			return false


			## Get selection state of a structure
func get_selection_state(mesh: MeshInstance3D) -> Variant:
	"""Get the selection state of a specific structure"""
	for selection in _selected_structures:
		if selection["mesh"] == mesh:
			return selection["state"]
			return null  # Not selected


			## Clear all selections
func clear_all_selections() -> void:
	"""Clear all selected structures and exit comparison mode"""
	for selection in _selected_structures:
		_clear_selection_visual(selection["mesh"])

		_selected_structures.clear()
		_selection_order.clear()
		_is_comparison_mode = false

		# Clear relationship indicators
		_clear_relationship_lines()

		# Stop timeout timer
		_selection_timeout_timer.stop()

		multi_selection_changed.emit([])
		comparison_mode_exited.emit()

		print("[MultiSelection] All selections cleared")


		## Clear specific selection
func clear_selection(mesh: MeshInstance3D) -> void:
	"""Clear a specific structure from selection"""

if not hit_data or not hit_data.has("mesh") or not hit_data["mesh"]:
	if not modifiers.get("ctrl", false) and not modifiers.get("shift", false):
		clear_all_selections()
		return

if modifiers.get("ctrl", false):
	_handle_ctrl_selection(mesh)
	elif modifiers.get("shift", false):
		_handle_shift_selection(mesh)
		else:
			_handle_normal_selection(mesh)

			# Update visual feedback
			_update_all_visual_states()

			# Emit change signal
			multi_selection_changed.emit(_get_selection_info())

			# Check for relationships
			_check_anatomical_relationships()

			# Reset timeout
			_selection_timeout_timer.start()


			## Get current selection information
for i in range(_selected_structures.size()):
	if _selected_structures[i]["mesh"] == mesh:
		index = i
		break

		if index >= 0:
			_clear_selection_visual(mesh)
			_selected_structures.remove_at(index)
			_selection_order.erase(mesh)

			# Reorder remaining selections
			_reorder_selections()
			_update_all_visual_states()

			multi_selection_changed.emit(_get_selection_info())

			if _selected_structures.is_empty():
				_is_comparison_mode = false
				comparison_mode_exited.emit()


				# === PRIVATE METHODS ===
if _selected_structures.size() > 1 and not _is_comparison_mode:
	_is_comparison_mode = true
	comparison_mode_entered.emit()
	else:
		selection_limit_reached.emit()
		_show_selection_limit_feedback()


if orig_mats != null and not orig_mats.has(mesh):
	# TODO: Temporarily disabled while fixing inheritance
	# _store_original_materials(mesh)
	pass

	print("[MultiSelection] Added %s as %s selection" % [mesh.name, _get_state_name(state)])


if vf != null and is_instance_valid(vf):
	# Use visual feedback system with state-specific colors
	vf.set_color_scheme("default")  # Reset to default first

	# Create state-specific material
for i in range(surface_count):
	mesh.set_surface_override_material(i, state_material)

	# Add outline effect based on hierarchy
	_add_hierarchical_outline(mesh, colors["outline"])
	else:
		# Fallback visual application
		_apply_fallback_selection_visual(mesh, state)


if vf != null and is_instance_valid(vf):
for i in range(_selected_structures.size()):
	for j in range(i + 1, _selected_structures.size()):
for key in relationships:
	if (name1 in key) and (name2 in key):
		relationship_detected.emit(name1, name2, relationships[key])
		print("[MultiSelection] Relationship detected: %s" % relationships[key])


for selection in _selected_structures:
	info.append(
	{
	"name": selection["name"],
	"state": _get_state_name(selection["state"]),
	"color": SELECTION_COLORS[selection["state"]]["default"]
	}
	)
	return info


if current_time - _last_interaction_time >= SELECTION_TIMEOUT:
	print("[MultiSelection] Selection timeout - clearing all selections")
	clear_all_selections()


for i in range(surface_count):
	mesh.set_surface_override_material(i, material)


	# === INPUT HANDLING ===
for i in range(_selected_structures.size() - 1):
	_selected_structures[i]["state"] = _selected_structures[i + 1]["state"]
	_selected_structures[_selected_structures.size() - 1]["state"] = first_state

	_update_all_visual_states()
	multi_selection_changed.emit(_get_selection_info())

	print("[MultiSelection] Cycled primary selection")

func _handle_normal_selection(mesh: MeshInstance3D) -> void:
	"""Handle normal click selection (replaces all)"""
	clear_all_selections()
	_add_selection(mesh, SelectionState.PRIMARY)


func _handle_ctrl_selection(mesh: MeshInstance3D) -> void:
	"""Handle Ctrl+click selection (toggle)"""
	if is_structure_selected(mesh):
		clear_selection(mesh)
		else:
			if _selected_structures.size() < MAX_SELECTIONS:
func _handle_shift_selection(mesh: MeshInstance3D) -> void:
	"""Handle Shift+click selection (add to comparison)"""
	if not is_structure_selected(mesh) and _selected_structures.size() < MAX_SELECTIONS:
func _add_selection(mesh: MeshInstance3D, state: SelectionState) -> void:
	"""Add a structure to the selection"""
func _get_next_selection_state() -> SelectionState:
	"""Determine the next available selection state"""
	match _selected_structures.size():
		0:
			return SelectionState.PRIMARY
			1:
				return SelectionState.SECONDARY
				2:
					return SelectionState.TERTIARY
					_:
						return SelectionState.TERTIARY


func _reorder_selections() -> void:
	"""Reorder selections to maintain proper hierarchy"""
	for i in range(_selected_structures.size()):
		match i:
			0:
				_selected_structures[i]["state"] = SelectionState.PRIMARY
				1:
					_selected_structures[i]["state"] = SelectionState.SECONDARY
					2:
						_selected_structures[i]["state"] = SelectionState.TERTIARY


func _update_all_visual_states() -> void:
	"""Update visual states for all selected structures"""
	for selection in _selected_structures:
		_apply_selection_visual(selection["mesh"], selection["state"])

		# Update relationship indicators if in comparison mode
		if _is_comparison_mode and _selected_structures.size() > 1:
			_update_relationship_lines()


func _apply_selection_visual(mesh: MeshInstance3D, state: SelectionState) -> void:
	"""Apply visual feedback for selection state"""
func _clear_selection_visual(mesh: MeshInstance3D) -> void:
	"""Clear visual effects from a deselected structure"""
func _add_hierarchical_outline(_mesh: MeshInstance3D, _thickness: float) -> void:
	"""Add outline effect with thickness based on selection hierarchy"""
	# TODO: Implement proper outline shader or technique
	# For now, using enhanced rim lighting as indicator
	pass


func _remove_hierarchical_outline(_mesh: MeshInstance3D) -> void:
	"""Remove outline effect from mesh"""
	pass


func _check_anatomical_relationships() -> void:
	"""Check for known anatomical relationships between selected structures"""
	if _selected_structures.size() < 2:
		return

		# Example relationships (extend with actual anatomical data)
func _normalize_structure_name(structure_name: String) -> String:
	"""Normalize structure name for comparison"""
	return structure_name.to_lower().replace(" ", "_").replace("(good)", "").strip_edges()


func _update_relationship_lines() -> void:
	"""Update visual indicators showing relationships between structures"""
	_clear_relationship_lines()

	# Create subtle connection lines between selected structures
	if _selected_structures.size() >= 2:
		# TODO: Implement 3D relationship visualization
		pass


func _clear_relationship_lines() -> void:
	"""Clear all relationship visual indicators"""
	for line in _relationship_lines:
		line.queue_free()
		_relationship_lines.clear()


func _show_selection_limit_feedback() -> void:
	"""Show visual feedback when selection limit is reached"""
	# TODO: Implement UI notification
	print("[MultiSelection] Selection limit reached (%d/%d)" % [MAX_SELECTIONS, MAX_SELECTIONS])


func _get_state_name(state: SelectionState) -> String:
	"""Get human-readable name for selection state"""
	match state:
		SelectionState.PRIMARY:
			return "Primary"
			SelectionState.SECONDARY:
				return "Secondary"
				SelectionState.TERTIARY:
					return "Tertiary"
					_:
						return "Unknown"


func _get_selection_info() -> Array:
	"""Get formatted selection information for UI"""
func _on_selection_timeout() -> void:
	"""Handle selection timeout for educational clarity"""
func _apply_fallback_selection_visual(mesh: MeshInstance3D, state: SelectionState) -> void:
	"""Apply fallback visual when visual feedback system unavailable"""
func _cycle_primary_selection() -> void:
	"""Cycle which structure is the primary selection"""
	if _selected_structures.size() < 2:
		return

		# Rotate selection states
