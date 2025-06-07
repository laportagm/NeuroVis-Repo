## SelectionCoordinator.gd
## Coordinates brain structure selection system and related event handling
##
## This component manages the initialization and event handling for both
## standard and multi-structure selection systems based on feature flags.

class_name SelectionCoordinator
extends Node

# === SIGNALS ===

signal structure_selected(structure_name: String)
signal structure_deselected
signal multi_selection_started
signal comparison_mode_changed(active: bool)

# === EXPORTS ===

@export var highlight_color: Color = Color.CYAN
@export var emission_energy: float = 0.3

# === DEPENDENCIES ===

var camera: Camera3D
var brain_model_parent: Node3D
var selection_manager: Node
var info_panel: Control
var comparative_panel: Control
var ai_integration: Node
var object_name_label: Label

# === STATE ===
var last_selected_structure: String = ""
var is_multi_selection_enabled: bool = false

# === AUTOLOAD REFERENCES ===
var FeatureFlags = null
var MultiStructureSelectionManagerScript = prepreload(
"res://core/interaction/MultiStructureSelectionManager.gd"
)


# === INITIALIZATION ===
var SelectionManagerScript = preload(
"res://core/interaction/BrainStructureSelectionManager.gd"
)
selection_manager = SelectionManagerScript.new()
selection_manager.name = "BrainStructureSelectionManager"
add_child(selection_manager)

# Setup standard selection signals
var success = selection_manager.initialize(camera, brain_model_parent)
var selection = selections[0]
_display_structure_info(selection["name"])
var names = []
var notification = Label.new()
notification.text = "Maximum 3 structures can be selected for comparison"
notification.add_theme_color_override("font_color", Color(1, 0.8, 0))
notification.add_theme_font_size_override("font_size", 16)

# Position at top center
notification.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
notification.position.y = 100
notification.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

# Add to UI layer
var ui_layer = get_node_or_null("/root/UI_Layer")
var selected_meshes = []

func _ready() -> void:
	"""Initialize selection coordinator"""
	FeatureFlags = get_node_or_null("/root/FeatureFlags")


func _initialize_selection_system() -> bool:
	"""Initialize brain structure selection system"""
	print("[SelectionCoordinator] Info: Initializing selection system...")

	# Detect if we should use multi-selection
	if FeatureFlags and FeatureFlags.is_enabled("multi_structure_selection"):
		print("[SelectionCoordinator] Info: Using enhanced multi-selection system")
		is_multi_selection_enabled = true
		selection_manager = MultiStructureSelectionManagerScript.new()
		selection_manager.name = "MultiStructureSelectionManager"
		add_child(selection_manager)

		# Setup multi-selection signals
		if selection_manager.has_signal("multi_selection_changed"):
			selection_manager.multi_selection_changed.connect(_on_multi_selection_changed)
			if selection_manager.has_signal("comparison_mode_entered"):
				selection_manager.comparison_mode_entered.connect(_on_comparison_mode_entered)
				if selection_manager.has_signal("comparison_mode_exited"):
					selection_manager.comparison_mode_exited.connect(_on_comparison_mode_exited)
					if selection_manager.has_signal("selection_limit_reached"):
						selection_manager.selection_limit_reached.connect(_on_selection_limit_reached)
						else:
							print("[SelectionCoordinator] Info: Using standard selection system")

func setup(dependencies: Dictionary) -> bool:
	"""Setup selection coordinator with required dependencies"""
	camera = dependencies.get("camera")
	brain_model_parent = dependencies.get("brain_model_parent")
	info_panel = dependencies.get("info_panel")
	comparative_panel = dependencies.get("comparative_panel")
	ai_integration = dependencies.get("ai_integration")
	object_name_label = dependencies.get("object_name_label")

	if not camera or not brain_model_parent:
		push_error("[SelectionCoordinator] Missing required dependencies")
		return false

		return _initialize_selection_system()


func get_selection_manager() -> Node:
	"""Get the current selection manager instance"""
	return selection_manager


func get_selected_structure() -> String:
	"""Get the currently selected structure name"""
	return last_selected_structure


func clear_selection() -> void:
	"""Clear current selection"""
	if selection_manager and selection_manager.has_method("clear_selection"):
		selection_manager.clear_selection()


func is_multi_selection_active() -> bool:
	"""Check if multi-selection mode is active"""
	return is_multi_selection_enabled

func _fix_orphaned_code():
	if selection_manager.has_signal("structure_selected"):
		selection_manager.structure_selected.connect(_on_structure_selected)
		if selection_manager.has_signal("selection_cleared"):
			selection_manager.selection_cleared.connect(_on_selection_cleared)

			# Pass required references to selection manager
			if selection_manager.has_method("initialize"):
func _fix_orphaned_code():
	if not success:
		push_error("[SelectionCoordinator] Failed to initialize selection manager")
		return false
		else:
			push_error("[SelectionCoordinator] Selection manager missing initialize method")
			return false

			# Configure visual properties
			if selection_manager.has_method("configure_highlight"):
				selection_manager.configure_highlight(highlight_color, emission_energy)

				print("[SelectionCoordinator] Info: ✓ Selection system initialized")
				return true


				# === STANDARD SELECTION HANDLERS ===
func _fix_orphaned_code():
	if object_name_label:
		object_name_label.text = "Selected: " + selection["name"]

		# Update AI context
		if ai_integration:
			ai_integration.set_current_structure(selection["name"])

			else:
				# Multiple selections - show comparative panel
				if info_panel:
					info_panel.hide()
					_show_comparative_panel(selections)

					# Update label to show multiple selections
func _fix_orphaned_code():
	for sel in selections:
		names.append(sel["name"])
		if object_name_label:
			object_name_label.text = "Comparing: " + ", ".join(names)

			# Update AI context with first selection
			if ai_integration and selections.size() > 0:
				ai_integration.set_current_structure(selections[0]["name"])

				print("[SelectionCoordinator] Info: Selection changed: %d structures" % selections.size())


func _fix_orphaned_code():
	if not ui_layer and get_parent():
		ui_layer = get_parent().get_node_or_null("UI_Layer")

		if ui_layer:
			ui_layer.add_child(notification)

			# Auto-remove after 3 seconds
			await get_tree().create_timer(3.0).timeout
			notification.queue_free()


func _fix_orphaned_code():
	for sel in selections:
		if sel.has("mesh"):
			selected_meshes.append(sel["mesh"])

			# Initialize comparative panel
			if comparative_panel.has_method("initialize"):
				comparative_panel.initialize(selected_meshes)
				comparative_panel.show()
				else:
					push_warning("[SelectionCoordinator] Comparative panel missing initialize method")


					# === PUBLIC METHODS ===

func _on_structure_selected(structure_name: String, _mesh: MeshInstance3D) -> void:
	"""Handle selection of a brain structure"""
	print("[SelectionCoordinator] Info: Structure selected: %s" % structure_name)

	# Update state
	last_selected_structure = structure_name

	# Update UI
	if object_name_label:
		object_name_label.text = "Selected: " + structure_name

		# Show structure info
		_display_structure_info(structure_name)

		# Update AI context
		if ai_integration:
			ai_integration.set_current_structure(structure_name)

			# Emit signal for external listeners
			structure_selected.emit(structure_name)


func _on_selection_cleared() -> void:
	"""Handle clearing of structure selection"""
	print("[SelectionCoordinator] Info: Selection cleared")

	# Update state
	last_selected_structure = ""

	# Update UI
	if object_name_label:
		object_name_label.text = "Selected: None"

		# Hide info panel
		if info_panel:
			info_panel.hide()

			# Clear AI context
			if ai_integration:
				ai_integration.set_current_structure("")

				# Emit signal for external listeners
				structure_deselected.emit()


func _display_structure_info(structure_name: String) -> void:
	"""Display information about the selected structure"""
	if not info_panel:
		push_warning("[SelectionCoordinator] Info panel not available")
		return

		# Use info panel to display structure info
		if info_panel.has_method("display_structure_info"):
			info_panel.display_structure_info(structure_name)
			info_panel.show()
			else:
				push_warning("[SelectionCoordinator] Info panel missing display_structure_info method")


				# === MULTI-SELECTION HANDLERS ===
func _on_multi_selection_changed(selections: Array) -> void:
	"""Handle changes to multi-selection state"""
	# Update UI based on number of selections
	if selections.size() == 0:
		# No selection - hide panels
		if info_panel:
			info_panel.hide()
			if comparative_panel:
				comparative_panel.hide()
				if object_name_label:
					object_name_label.text = "Selected: None"

					# Update AI context
					if ai_integration:
						ai_integration.set_current_structure("")

						elif selections.size() == 1:
							# Single selection - show traditional info panel
							if comparative_panel:
								comparative_panel.hide()
func _on_comparison_mode_entered() -> void:
	"""Handle entering comparison mode"""
	print("[SelectionCoordinator] Info: Entered comparison mode")
	comparison_mode_changed.emit(true)
	multi_selection_started.emit()


func _on_comparison_mode_exited() -> void:
	"""Handle exiting comparison mode"""
	print("[SelectionCoordinator] Info: Exited comparison mode")
	comparison_mode_changed.emit(false)

	# Hide comparative panel
	if comparative_panel:
		comparative_panel.hide()


func _on_selection_limit_reached() -> void:
	"""Handle when selection limit is reached"""
	push_warning("[SelectionCoordinator] Warning: Selection limit reached!")

	# Show user feedback
func _show_comparative_panel(selections: Array) -> void:
	"""Show and configure the comparative panel"""
	if not comparative_panel:
		push_warning("[SelectionCoordinator] Comparative panel not available")
		return

		# Collect selected meshes for comparative panel
