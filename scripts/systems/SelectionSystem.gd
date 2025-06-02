## SelectionSystem.gd
## Wrapper system for structure selection functionality
## Provides simple interface for scene-level selection handling

class_name SelectionSystem
extends Node

# Internal selection manager reference
var selection_manager: Node = null

# Current selection state
var currently_selected_structure: String = ""
var selected_structure_data: Dictionary = {}

# Signals
signal structure_selected(structure_name: String, structure_data: Dictionary)
signal structure_deselected()

func _ready() -> void:
	print("[SELECTION_SYSTEM] Initializing SelectionSystem...")
	name = "SelectionSystem"

## Public interface methods

func select_structure(structure_name: String) -> void:
	"""Select a structure by name"""
	if not selection_manager:
		print("[SELECTION_SYSTEM] Warning: No selection manager available")
		return
	
	# For now, we'll emit the signal with basic data
	# In future, this could integrate with knowledge base
	currently_selected_structure = structure_name
	selected_structure_data = {"name": structure_name, "display_name": structure_name}
	
	print("[SELECTION_SYSTEM] Structure selected: ", structure_name)
	structure_selected.emit(structure_name, selected_structure_data)

func deselect_structure() -> void:
	"""Deselect the currently selected structure"""
	if selection_manager:
		selection_manager.clear_current_selection()
	
	currently_selected_structure = ""
	selected_structure_data.clear()
	
	print("[SELECTION_SYSTEM] Structure deselected")
	structure_deselected.emit()

func get_structure_at_position(screen_pos: Vector2) -> String:
	"""Get structure name at screen position using raycast"""
	if not selection_manager:
		print("[SELECTION_SYSTEM] Warning: No selection manager available for raycast")
		return ""
	
	# Use the selection manager's internal raycast method
	var hit_mesh = selection_manager._cast_selection_ray(screen_pos)
	if hit_mesh:
		return hit_mesh.name
	
	return ""

func handle_selection_at_position(screen_pos: Vector2) -> void:
	"""Handle selection attempt at screen position"""
	if not selection_manager:
		print("[SELECTION_SYSTEM] Warning: No selection manager available for selection")
		return
	
	# Get structure at position
	var structure_name = get_structure_at_position(screen_pos)
	
	if structure_name.is_empty():
		# No structure found, deselect
		deselect_structure()
	else:
		# Structure found, select it
		select_structure(structure_name)
		
		# Also tell the selection manager to handle highlighting
		selection_manager.handle_selection_at_position(screen_pos)

## Configuration and setup

func initialize_with_selection_manager(manager: Node) -> void:
	"""Initialize with reference to the selection manager"""
	if not manager:
		print("[SELECTION_SYSTEM] Error: Cannot initialize with null selection manager")
		return
	
	selection_manager = manager
	print("[SELECTION_SYSTEM] Initialized with selection manager")
	
	# Connect to selection manager signals
	if selection_manager.has_signal("structure_selected"):
		selection_manager.structure_selected.connect(_on_manager_structure_selected)
	if selection_manager.has_signal("structure_deselected"):
		selection_manager.structure_deselected.connect(_on_manager_structure_deselected)

func get_selected_structure_name() -> String:
	"""Get the name of the currently selected structure"""
	return currently_selected_structure

func get_selected_structure_data() -> Dictionary:
	"""Get the data of the currently selected structure"""
	return selected_structure_data

func is_structure_selected() -> bool:
	"""Check if any structure is currently selected"""
	return not currently_selected_structure.is_empty()

## Signal handlers

func _on_manager_structure_selected(structure_name: String, mesh: MeshInstance3D) -> void:
	"""Handle selection from the underlying selection manager"""
	currently_selected_structure = structure_name
	selected_structure_data = {"name": structure_name, "display_name": structure_name, "mesh": mesh}
	
	print("[SELECTION_SYSTEM] Manager reported structure selected: ", structure_name)
	structure_selected.emit(structure_name, selected_structure_data)

func _on_manager_structure_deselected() -> void:
	"""Handle deselection from the underlying selection manager"""
	currently_selected_structure = ""
	selected_structure_data.clear()
	
	print("[SELECTION_SYSTEM] Manager reported structure deselected")
	structure_deselected.emit()

## Cleanup

func _exit_tree() -> void:
	"""Clean up when node is removed from tree"""
	if selection_manager:
		# Disconnect signals
		if selection_manager.has_signal("structure_selected") and selection_manager.structure_selected.is_connected(_on_manager_structure_selected):
			selection_manager.structure_selected.disconnect(_on_manager_structure_selected)
		if selection_manager.has_signal("structure_deselected") and selection_manager.structure_deselected.is_connected(_on_manager_structure_deselected):
			selection_manager.structure_deselected.disconnect(_on_manager_structure_deselected)
	
	selection_manager = null
	currently_selected_structure = ""
	selected_structure_data.clear()
	
	print("[SELECTION_SYSTEM] SelectionSystem cleaned up")