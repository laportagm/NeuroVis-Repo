## Manages all UI panels and their lifecycle.
##
## UIManager provides centralized control over UI panels, handling their visibility,
## animations, and inter-panel communication. It uses a registry pattern to manage panels.
##
## @tutorial: https://github.com/project/wiki/ui-management

class_name UIManager
extends ComponentBase

## Emitted when a panel is shown

signal panel_shown(panel_name: String)

## Emitted when a panel is hidden
signal panel_hidden(panel_name: String)

## Emitted when a panel is registered
signal panel_registered(panel_name: String)

# UI References

@export var panel_animation_duration: float = 0.3


var ui_layer: CanvasLayer
var object_name_label: Label
var info_panel: Control
var model_control_panel: Control

# Panel registry
var panels: Dictionary = {}

# Animation settings
			var panel_id = panel.get_meta("panel_id")
			register_panel(panel_id, panel)

	# Register known panels if not already registered
	if object_name_label and not panels.has("object_label"):
		register_panel("object_label", object_name_label)

	if info_panel and not panels.has("info"):
		register_panel("info", info_panel)

	if model_control_panel and not panels.has("model_control"):
		register_panel("model_control", model_control_panel)


## Register a panel with the UI manager
	var panel = panels[panel_id]
	if not is_instance_valid(panel):
		push_warning("[UIManager] Panel instance invalid: ", panel_id)
		panels.erase(panel_id)
		return

	# Update panel content if it has the method
	if panel.has_method("update_content") and not data.is_empty():
		panel.update_content(data)
	elif panel.has_method("display_structure_data") and data.has("structure_data"):
		panel.display_structure_data(data["structure_data"])

	# Show the panel
	if animate and panel_animation_duration > 0:
		_animate_panel_show(panel)
	else:
		panel.visible = true

	panel_shown.emit(panel_id)


## Hide a specific panel
	var panel = panels[panel_id]
	if not is_instance_valid(panel):
		panels.erase(panel_id)
		return

	if animate and panel_animation_duration > 0:
		_animate_panel_hide(panel)
	else:
		panel.visible = false

	panel_hidden.emit(panel_id)


## Toggle a panel's visibility
	var panel = panels[panel_id]
	if is_instance_valid(panel):
		if panel.visible:
			hide_panel(panel_id)
		else:
			show_panel(panel_id)


## Hide all panels
		var tween = object_name_label.create_tween()
		tween.tween_property(object_name_label, "modulate:a", 0.0, 0.1)
		tween.tween_callback(func(): object_name_label.text = text)
		tween.tween_property(object_name_label, "modulate:a", 1.0, 0.1)
	else:
		object_name_label.text = text


## Setup initial UI state
	var tween = panel.create_tween()
	tween.tween_property(panel, "modulate:a", 1.0, panel_animation_duration)


## Animate panel hiding
	var tween = panel.create_tween()
	tween.tween_property(panel, "modulate:a", 0.0, panel_animation_duration)
	tween.tween_callback(func(): panel.visible = false)


	var visible_panels = []
	for panel_id in panels:
		if is_panel_visible(panel_id):
			visible_panels.append(panel_id)

	return {
		"registered_panels": panels.keys(),
		"visible_panels": visible_panels,
		"ui_layer_valid": is_instance_valid(ui_layer)
	}

func _initialize_component() -> bool:
	component_name = "UIManager"

	# Validate UI structure
	if not _validate_requirements():
		return false

	# Discover and register panels
	_discover_panels()

	# Setup initial UI state
	_setup_initial_state()

	return true


func set_ui_layer(layer: CanvasLayer) -> void:
	ui_layer = layer


## Set the object name label reference
func set_object_name_label(label: Label) -> void:
	object_name_label = label
	if label:
		panels["object_label"] = label


## Set the info panel reference
func set_info_panel(panel: Control) -> void:
	info_panel = panel
	if panel:
		panels["info"] = panel


## Set the model control panel reference
func set_model_control_panel(panel: Control) -> void:
	model_control_panel = panel
	if panel:
		panels["model_control"] = panel


func register_panel(panel_id: String, panel: Control) -> void:
	panels[panel_id] = panel
	print("[UIManager] Registered panel: ", panel_id)
	panel_registered.emit(panel_id)


## Show a specific panel with optional data
func show_panel(panel_id: String, data: Dictionary = {}, animate: bool = true) -> void:
	if not panel_id in panels:
		push_warning("[UIManager] Panel not found: ", panel_id)
		return

func hide_panel(panel_id: String, animate: bool = true) -> void:
	if not panel_id in panels:
		return

func toggle_panel(panel_id: String) -> void:
	if not panel_id in panels:
		return

func hide_all_panels(animate: bool = true) -> void:
	for panel_id in panels:
		hide_panel(panel_id, animate)


## Get a panel by ID
func get_panel(panel_id: String) -> Control:
	if panel_id in panels:
		return panels[panel_id]
	return null


## Check if a panel is currently visible
func is_panel_visible(panel_id: String) -> bool:
	if panel_id in panels and is_instance_valid(panels[panel_id]):
		return panels[panel_id].visible
	return false


## Update the object name label
func update_object_label(text: String, animate: bool = true) -> void:
	if not is_instance_valid(object_name_label):
		return

	if animate:

func _validate_requirements() -> bool:
	# UI Layer must exist
	if not is_instance_valid(ui_layer):
		push_error("[UIManager] UI layer not set")
		return false

	return true


## Set the UI layer reference
func _discover_panels() -> void:
	if not ui_layer:
		return

	print("[UIManager] Discovering UI panels...")

	# Auto-discover panels by group
	for panel in get_tree().get_nodes_in_group("ui_panels"):
		if panel.has_meta("panel_id"):
func _setup_initial_state() -> void:
	# Ensure UI layer is visible
	if ui_layer:
		ui_layer.visible = true

	# Set initial label text
	if object_name_label:
		object_name_label.text = "Selected: None"

	# Hide info panel initially
	if info_panel:
		info_panel.visible = false

	# Show model control panel
	if model_control_panel:
		model_control_panel.visible = true


## Animate panel showing
func _animate_panel_show(panel: Control) -> void:
	panel.modulate.a = 0.0
	panel.visible = true

func _animate_panel_hide(panel: Control) -> void:
func _cleanup_component() -> void:
	panels.clear()
	ui_layer = null
	object_name_label = null
	info_panel = null
	model_control_panel = null


func _get_custom_status() -> Dictionary:
