## UISystem.gd
## Wrapper system for UI management functionality
## Handles structure info display, status messages, and UI updates

class_name UISystem
extends Node

# UI component references

signal ui_initialized
signal structure_info_displayed(structure_name: String)
signal structure_info_hidden


var ui_layer: CanvasLayer = null
var object_name_label: Label = null
var info_panel: Control = null

# Dependencies (injected during initialization)
# FIXED: Orphaned code - var system_bootstrap: Node = null
var ModernInfoDisplay = null

# Current UI state
var current_structure_name: String = ""
var info_display_visible: bool = false

# Signals
var structure_name = data.name
current_structure_name = structure_name

var hover_text = (
"Hover: " + structure_name if not structure_name.is_empty() else "Hover: None"
)
object_name_label.text = hover_text


var modern_theme = Theme.new()

# FIXED: Orphaned code - var tween = object_name_label.create_tween()
tween.tween_property(object_name_label, "modulate:a", 0.0, 0.1)
tween.tween_callback(func(): object_name_label.text = text)
tween.tween_property(object_name_label, "modulate:a", 1.0, 0.1)


# FIXED: Orphaned code - var knowledge_base = system_bootstrap.get_knowledge_base()
# FIXED: Orphaned code - var structure_id = _find_structure_id_by_name(structure_name)
# FIXED: Orphaned code - var structure_data = knowledge_base.get_structure(structure_id)
# FIXED: Orphaned code - var modern_info = ModernInfoDisplay.new()
modern_info.name = "ModernInfoDisplay"
modern_info.position = Vector2(get_viewport().size.x - 360, 100)

ui_layer.add_child(modern_info)
modern_info.display_structure_data(structure_data)
# FIXED: Orphaned code - var existing_display = ui_layer.get_node_or_null("ModernInfoDisplay")
# FIXED: Orphaned code - var neural_net = system_bootstrap.get_neural_net()
# FIXED: Orphaned code - var knowledge_base_2 = system_bootstrap.get_knowledge_base()

# Try neural net mapping first
var mapped_id = neural_net.map_mesh_name_to_structure_id(mesh_name)
# FIXED: Orphaned code - var structure_ids = knowledge_base.get_all_structure_ids()
# FIXED: Orphaned code - var lower_mesh_name = mesh_name.to_lower()

# Try exact match first
var structure = knowledge_base.get_structure(id)
# FIXED: Orphaned code - var structure_2 = knowledge_base.get_structure(id)
# FIXED: Orphaned code - var display_name = structure.displayName.to_lower()
# FIXED: Orphaned code - var script_path = "res://ui/panels/ModernInfoDisplay.gd"
var status = get_ui_status()

func _ready() -> void:
	print("[UI_SYSTEM] Initializing UISystem...")
	name = "UISystem"


	## Public interface methods


func _exit_tree() -> void:
	"""Clean up when node is removed from tree"""
	_hide_modern_info_display()

	ui_layer = null
	object_name_label = null
	info_panel = null
	system_bootstrap = null
	ModernInfoDisplay = null

	current_structure_name = ""
	info_display_visible = false

	print("[UI_SYSTEM] UISystem cleaned up")

func display_structure_info(data: Dictionary) -> void:
	"""Display structure information panel"""
	if not data.has("name"):
		print("[UI_SYSTEM] Warning: Structure data missing name field")
		return

func hide_structure_info() -> void:
	"""Hide structure information panel"""
	print("[UI_SYSTEM] Hiding structure info")

	# Update object name label
	_update_object_label("Selected: None")

	# Hide info panel
	if info_panel:
		info_panel.visible = false

		# Hide modern info display
		_hide_modern_info_display()

		current_structure_name = ""
		info_display_visible = false
		structure_info_hidden.emit()


func show_status(message: String) -> void:
	"""Show status message in UI"""
	print("[UI_SYSTEM] Status: ", message)

	if object_name_label:
		_update_object_label(message)


func update_hover_status(structure_name: String) -> void:
	"""Update UI for structure hover (only if nothing selected)"""
	if current_structure_name.is_empty() and object_name_label:
func setup_ui_layer() -> void:
	"""Setup and configure the UI layer"""
	if ui_layer:
		ui_layer.visible = true
		ui_layer.add_to_group("ui_layer")
		print("[UI_SYSTEM] UI layer configured")


func apply_modern_theme() -> void:
	"""Apply modern theming to UI elements"""
	if not ui_layer:
		print("[UI_SYSTEM] Warning: No UI layer available for theming")
		return

func initialize_with_ui_components(
	ui_layer_ref: CanvasLayer, object_label: Label, info_panel_ref: Control, bootstrap: Node
	) -> void:
		"""Initialize with UI component references"""
		ui_layer = ui_layer_ref
		object_name_label = object_label
		info_panel = info_panel_ref
		system_bootstrap = bootstrap

func set_modern_info_display_script(script_class) -> void:
	"""Set the ModernInfoDisplay script class"""
	ModernInfoDisplay = script_class


	## UI Helper methods


func get_ui_status() -> Dictionary:
	"""Get current UI status information"""
	return {
	"ui_layer_available": ui_layer != null,
	"object_label_available": object_name_label != null,
	"info_panel_available": info_panel != null,
	"current_structure": current_structure_name,
	"info_visible": info_display_visible,
	"has_bootstrap": system_bootstrap != null,
	"has_modern_display": ModernInfoDisplay != null
	}


func print_ui_status() -> void:
	"""Print current UI status for debugging"""
	print("=== UI SYSTEM STATUS ===")

print("[UI_SYSTEM] Displaying structure info for: ", structure_name)

# Update object name label with animation
_update_object_label("Selected: " + structure_name)

# Display detailed info using modern display
_display_structure_info_modern(structure_name)

info_display_visible = true
structure_info_displayed.emit(structure_name)


for child in ui_layer.get_children():
	if child is Control:
		child.set_theme(modern_theme)

		print("[UI_SYSTEM] Modern theme applied")


		## Configuration and setup


if not knowledge_base or not knowledge_base.is_loaded:
	print("[UI_SYSTEM] Knowledge base not ready for structure info")
	return

	# Find structure ID
if structure_id.is_empty():
	print("[UI_SYSTEM] No structure found for: ", structure_name)
	return

	# Get structure data
if structure_data.is_empty():
	print("[UI_SYSTEM] No data found for structure: ", structure_id)
	return

	# Create modern info display
	_hide_modern_info_display()  # Clear any existing display

	if ModernInfoDisplay and ui_layer:
print("[UI_SYSTEM] Modern info display created")
else:
	print("[UI_SYSTEM] ModernInfoDisplay not available, using fallback")
	_display_fallback_info(structure_data)


if existing_display:
	existing_display.queue_free()


if neural_net:
if not mapped_id.is_empty():
	return mapped_id

	# Fallback to knowledge base search
	if knowledge_base:
for id in structure_ids:
if structure.has("displayName") and structure.displayName.to_lower() == lower_mesh_name:
	return id

	# Try partial match
	for id in structure_ids:
if structure.has("displayName"):
if lower_mesh_name.contains(display_name) or display_name.contains(lower_mesh_name):
	return id

	return ""


if ResourceLoader.exists(script_path):
	ModernInfoDisplay = load(script_path)
	print("[UI_SYSTEM] ModernInfoDisplay script loaded")
	else:
		print("[UI_SYSTEM] ModernInfoDisplay script not found, using fallback")


		## Status and debugging


for key in status.keys():
	print("  ", key, ": ", status[key])


	## Cleanup


print("[UI_SYSTEM] Initialized with UI components")

# Setup initial UI state
if object_name_label:
	object_name_label.text = "Selected: None"

	# Load ModernInfoDisplay script
	_load_modern_info_display()

	ui_initialized.emit()


func _update_object_label(text: String) -> void:
	"""Update object label with smooth animation"""
	if not object_name_label:
		return

func _display_structure_info_modern(structure_name: String) -> void:
	"""Display structure information using modern UI"""
	if not system_bootstrap:
		print("[UI_SYSTEM] Warning: No system bootstrap available")
		return

func _hide_modern_info_display() -> void:
	"""Hide/remove modern info display"""
	if not ui_layer:
		return

func _display_fallback_info(structure_data: Dictionary) -> void:
	"""Display structure info using fallback info panel"""
	if info_panel:
		info_panel.visible = true
		# Basic fallback display - could be enhanced
		print(
		"[UI_SYSTEM] Displaying fallback info for: ",
		structure_data.get("displayName", "Unknown")
		)


func _find_structure_id_by_name(mesh_name: String) -> String:
	"""Find structure ID by mesh name using neural net mapping"""
	if not system_bootstrap:
		return ""

func _load_modern_info_display() -> void:
	"""Load ModernInfoDisplay script if available"""
