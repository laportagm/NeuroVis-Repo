## Manages application state and coordinates component communication.
##
## StateManager acts as a central hub for component coordination, maintaining
## application state and facilitating communication between components that
## shouldn't directly depend on each other.
##
## @tutorial: https://github.com/project/wiki/state-management

class_name StateManager
extends ComponentBase

## Emitted when the application state changes

signal state_changed(state_name: String, state_data: Dictionary)

## Emitted when a brain structure is selected (forwarded from InteractionHandler)
signal structure_selected(structure_name: String)

## Emitted when structure info should be displayed
signal display_structure_info(structure_data: Dictionary)

# Component references

const AnatomicalKnowledgeDatabaseScript = preload(
"res://core/knowledge/AnatomicalKnowledgeDatabase.gd"
)


# FIXED: Orphaned code - var brain_visualizer: BrainVisualizer
var ui_manager: UIManager
var interaction_handler: InteractionHandler

# Knowledge base reference
var knowledge_base = null

# Current application state
var current_state: Dictionary = {
"selected_structure": "",
"visible_models": [],
"ui_panels_visible": [],
"camera_mode": "navigation"
}

# Preloaded scripts
var structure_id = _find_structure_id_by_name(structure_name)
# FIXED: Orphaned code - var structure_data = knowledge_base.get_structure(structure_id)
# FIXED: Orphaned code - var mapped_id = brain_visualizer.map_mesh_name_to_structure_id(mesh_name)
# FIXED: Orphaned code - var lower_mesh_name = mesh_name.to_lower()
# FIXED: Orphaned code - var structure_ids = knowledge_base.get_all_structure_ids()

# Try exact match with display name
var structure = knowledge_base.get_structure(id)
# FIXED: Orphaned code - var structure_2 = knowledge_base.get_structure(id)
# FIXED: Orphaned code - var display_name = structure.displayName.to_lower()

func _initialize_component() -> bool:
	component_name = "StateManager"

	# Initialize knowledge base first
	if not _initialize_knowledge_base():
		return false

		# Validate component references
		if not _validate_requirements():
			return false

			# Connect component signals
			_connect_component_signals()

			return true


func _initialize_knowledge_base() -> bool:
	# Initialize knowledge base
	knowledge_base = AnatomicalKnowledgeDatabaseScript.new()
	if knowledge_base == null:
		push_error("[StateManager] Failed to initialize knowledge base")
		return false

		add_child(knowledge_base)
		knowledge_base.load_knowledge_base()
		print("[StateManager] Knowledge base initialized and loaded")

		return true


		## Set component references

func set_components(
	visualizer: BrainVisualizer, ui: UIManager, interaction: InteractionHandler
	) -> void:
		brain_visualizer = visualizer
		ui_manager = ui
		interaction_handler = interaction

		# Pass knowledge base to visualizer
func get_state() -> Dictionary:
	return current_state.duplicate()


	## Get knowledge base reference
func get_knowledge_base():
	return knowledge_base


if structure_id.is_empty():
	print("[StateManager] No matching structure found for: ", structure_name)
	return

	# Get structure data
if structure_data.is_empty():
	print("[StateManager] No data found for structure: ", structure_id)
	return

	# Display in UI
	if ui_manager:
		ui_manager.show_panel("info", {"structure_data": structure_data})

		# Emit signal
		display_structure_info.emit(structure_data)


		## Find structure ID by mesh name
if not mapped_id.is_empty():
	return mapped_id

	# Fallback to knowledge base search
	if not knowledge_base:
		return ""

for id in structure_ids:
if structure.has("displayName") and structure.displayName.to_lower() == lower_mesh_name:
	return id

	# Try matching the ID directly
	if structure_ids.has(mesh_name):
		return mesh_name

		# Try partial match
		for id in structure_ids:
if structure.has("displayName"):
if lower_mesh_name.contains(display_name) or display_name.contains(lower_mesh_name):
	return id

	return ""


	## Get current application state

if brain_visualizer and knowledge_base:
	brain_visualizer.set_knowledge_base(knowledge_base)


func _validate_requirements() -> bool:
	if not is_instance_valid(brain_visualizer):
		push_error("[StateManager] BrainVisualizer not set")
		return false

		if not is_instance_valid(ui_manager):
			push_error("[StateManager] UIManager not set")
			return false

			if not is_instance_valid(interaction_handler):
				push_error("[StateManager] InteractionHandler not set")
				return false

				return true


func _connect_component_signals() -> void:
	print("[StateManager] Connecting component signals...")

	# Connect InteractionHandler signals
	if interaction_handler:
		interaction_handler.region_selected.connect(_on_region_selected)
		interaction_handler.region_deselected.connect(_on_region_deselected)
		interaction_handler.region_hovered.connect(_on_region_hovered)
		interaction_handler.region_unhovered.connect(_on_region_unhovered)

		# Connect BrainVisualizer signals
		if brain_visualizer:
			brain_visualizer.all_models_loaded.connect(_on_models_loaded)
			brain_visualizer.region_highlighted.connect(_on_region_highlighted)

			# Connect UIManager signals
			if ui_manager:
				ui_manager.panel_shown.connect(_on_panel_shown)
				ui_manager.panel_hidden.connect(_on_panel_hidden)


				## Handle region selection
func _on_region_selected(region_name: String, _mesh: MeshInstance3D) -> void:
	print("[StateManager] Region selected: ", region_name)

	# Update state
	current_state["selected_structure"] = region_name

	# Update UI
	if ui_manager:
		ui_manager.update_object_label("Selected: " + region_name)

		# Display structure info
		_display_structure_info(region_name)

		# Emit signals
		structure_selected.emit(region_name)
		state_changed.emit("structure_selected", {"structure": region_name})


		## Handle region deselection
func _on_region_deselected() -> void:
	print("[StateManager] Region deselected")

	# Update state
	current_state["selected_structure"] = ""

	# Update UI
	if ui_manager:
		ui_manager.update_object_label("Selected: None")
		ui_manager.hide_panel("info")

		state_changed.emit("structure_deselected", {})


		## Handle region hover
func _on_region_hovered(region_name: String, _mesh: MeshInstance3D) -> void:
	# Only show hover if nothing is selected
	if current_state["selected_structure"].is_empty() and ui_manager:
		ui_manager.update_object_label("Hover: " + region_name, false)


		## Handle region unhover
func _on_region_unhovered() -> void:
	# Only clear hover if nothing is selected
	if current_state["selected_structure"].is_empty() and ui_manager:
		ui_manager.update_object_label("Hover: None", false)


		## Handle models loaded
func _on_models_loaded(model_names: Array) -> void:
	print("[StateManager] Models loaded: ", model_names)
	current_state["visible_models"] = model_names
	state_changed.emit("models_loaded", {"models": model_names})


	## Handle region highlighting
func _on_region_highlighted(region_name: String) -> void:
	state_changed.emit("region_highlighted", {"region": region_name})


	## Handle panel shown
func _on_panel_shown(panel_name: String) -> void:
	if not panel_name in current_state["ui_panels_visible"]:
		current_state["ui_panels_visible"].append(panel_name)
		state_changed.emit("panel_shown", {"panel": panel_name})


		## Handle panel hidden
func _on_panel_hidden(panel_name: String) -> void:
	current_state["ui_panels_visible"].erase(panel_name)
	state_changed.emit("panel_hidden", {"panel": panel_name})


	## Display structure information
func _display_structure_info(structure_name: String) -> void:
	if not knowledge_base or not knowledge_base.is_loaded:
		print("[StateManager] Knowledge base not ready")
		return

		# Find structure ID
func _find_structure_id_by_name(mesh_name: String) -> String:
	# First try using neural net mapping
	if brain_visualizer:
func _cleanup_component() -> void:
	brain_visualizer = null
	ui_manager = null
	interaction_handler = null
	knowledge_base = null
	current_state.clear()


func _get_custom_status() -> Dictionary:
	return {
	"current_state": current_state,
	"knowledge_base_loaded": knowledge_base != null and knowledge_base.is_loaded,
	"components_connected":
		brain_visualizer != null and ui_manager != null and interaction_handler != null
		}
