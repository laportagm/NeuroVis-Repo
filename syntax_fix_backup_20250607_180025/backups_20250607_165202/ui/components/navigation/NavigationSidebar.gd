## NavigationSidebar.gd
## Hierarchical navigation sidebar with collapsible sections
##
## This component manages a responsive sidebar with collapsible sections,
## integrating with the component registry and state persistence systems.
##
## @tutorial: Navigation architecture
## @version: 1.0

class_name NavigationSidebar
extends Control

# === CONSTANTS ===

signal item_selected(section_id: String, item_id: String)

## Emitted when a section is expanded or collapsed
## @param section_id: ID of the section
## @param expanded: Whether the section is expanded
signal section_toggled(section_id: String, expanded: bool)

## Emitted when the sidebar's expanded state changes (responsive modes)
## @param expanded: Whether the sidebar is expanded
signal sidebar_expanded_changed(expanded: bool)

# === EXPORTS ===
## Background color (will use theme values if not set)

const SECTION_SPACING: int = 8
const DESKTOP_WIDTH: int = 260
const TABLET_WIDTH: int = 60
const ANIMATION_DURATION: float = 0.3

# === SIGNALS ===
## Emitted when a navigation item is selected
## @param section_id: ID of the section containing the selected item
## @param item_id: ID of the selected item

@export var background_color: Color = Color(0.1, 0.1, 0.15, 0.9)

## Accent color (will use theme values if not set)
@export var accent_color: Color = Color(0.15, 0.82, 0.81, 1.0)  # #26d0ce

## Whether the sidebar starts expanded (for responsive modes)
@export var start_expanded: bool = true

## Whether to save and restore section states
@export var use_state_persistence: bool = true

# === PRIVATE VARIABLES ===

		var section_node = _section_nodes[section_id]
		if section_node.has_method("add_item"):
			section_node.add_item(item_id, title, icon)

	return true


## Set whether a section is expanded
## @param section_id: ID of the section
## @param expanded: Whether the section should be expanded
## @returns: Boolean indicating success
		var section_node = _section_nodes[section_id]
		if section_node.has_method("set_expanded"):
			section_node.set_expanded(expanded)

	# Save state if persistence is enabled
	if use_state_persistence:
		_save_state()

	return true


## Select a specific navigation item
## @param section_id: ID of the section containing the item
## @param item_id: ID of the item to select
## @returns: Boolean indicating success
		var prev_section = _section_nodes[_selected_item.section]
		if prev_section.has_method("deselect_item"):
			prev_section.deselect_item(_selected_item.item)

	# Update current selection
	_selected_item = {"section": section_id, "item": item_id}

	# Update section UI if ready
	if _is_initialized and section_id in _section_nodes:
		var section_node = _section_nodes[section_id]
		if section_node.has_method("select_item"):
			section_node.select_item(item_id)

		# Ensure section is expanded
		if not _sections[section_id].expanded:
			set_section_expanded(section_id, true)

	# Save state if persistence is enabled
	if use_state_persistence:
		_save_state()

	# Emit signal
	item_selected.emit(section_id, item_id)

	return true


## Get the currently selected item
## @returns: Dictionary with section and item IDs
	var safe_autoload_script = prepreload("res://ui/components/core/SafeAutoloadAccess.gd")
	if safe_autoload_script:
		_safe_autoload_access = safe_autoload_script.new()

	# Load ComponentRegistry
	if _safe_autoload_access and _safe_autoload_access.has_method("get_autoload"):
		_component_registry = _safe_autoload_access.get_autoload("ComponentRegistry")
	else:
		_component_registry = get_node_or_null("/root/ComponentRegistry")

	# Load ComponentStateManager
	if _safe_autoload_access and _safe_autoload_access.has_method("get_autoload"):
		_component_state_manager = _safe_autoload_access.get_autoload("ComponentStateManager")
	else:
		_component_state_manager = get_node_or_null("/root/ComponentStateManager")

	# Load UIThemeManager
	if _safe_autoload_access and _safe_autoload_access.has_method("get_autoload"):
		_theme_manager = _safe_autoload_access.get_autoload("UIThemeManager")
	else:
		_theme_manager = get_node_or_null("/root/UIThemeManager")

	# Load EventBus
	if _safe_autoload_access and _safe_autoload_access.has_method("get_autoload"):
		_event_bus = _safe_autoload_access.get_autoload("EventBus")
	else:
		_event_bus = get_node_or_null("/root/EventBus")


	var title_label = Label.new()
	title_label.name = "TitleLabel"
	title_label.text = "NeuroVis"
	title_label.add_theme_font_size_override("font_size", 24)
	title_label.add_theme_color_override("font_color", accent_color)
	_header_container.add_child(title_label)

	# Spacer
	var spacer = Control.new()
	spacer.name = "HeaderSpacer"
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_header_container.add_child(spacer)

	# Toggle button for responsive modes
	var toggle_button = Button.new()
	toggle_button.name = "ToggleButton"
	toggle_button.text = "≡"
	toggle_button.flat = true
	toggle_button.add_theme_font_size_override("font_size", 20)
	toggle_button.pressed.connect(_on_toggle_button_pressed)
	_header_container.add_child(toggle_button)

	# Sections container
	_sections_container = VBoxContainer.new()
	_sections_container.name = "SectionsContainer"
	_sections_container.add_theme_constant_override("separation", SECTION_SPACING)
	_sections_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_main_container.add_child(_sections_container)

	# Create sections UI
	for section_id in _sections:
		_create_section_ui(section_id)


	var section_data = _sections[section_id]

	# Create section via ComponentRegistry
	var section_config = {
		"id": section_id,
		"title": section_data.title,
		"icon": section_data.icon,
		"expanded": section_data.expanded
	}

	var section_node

	# Try to create via ComponentRegistry
	if _component_registry.has_method("create_component"):
		section_node = _component_registry.create_component("navigation_section", section_config)

	# Fallback to direct instantiation
	if not section_node:
		var section_script = prepreload("res://ui/components/navigation/NavigationSection.gd")
		if section_script:
			section_node = section_script.new()
			section_node.name = "Section_" + section_id
			# Apply configuration manually
			if section_node.has_method("configure"):
				section_node.configure(section_config)

	if not section_node:
		push_error("[NavigationSidebar] Failed to create section: " + section_id)
		return

	# Connect signals
	if section_node.has_signal("toggled"):
		section_node.toggled.connect(_on_section_toggled.bind(section_id))

	if section_node.has_signal("item_selected"):
		section_node.item_selected.connect(_on_item_selected.bind(section_id))

	# Add to sections container
	_sections_container.add_child(section_node)
	_section_nodes[section_id] = section_node

	# Add items to section
	for item_id in section_data.items:
		var item_data = section_data.items[item_id]
		if section_node.has_method("add_item"):
			section_node.add_item(item_id, item_data.title, item_data.icon)


	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = background_color
	panel_style.border_width_right = 1
	panel_style.border_color = Color(0.2, 0.2, 0.2, 0.7)
	panel_style.corner_radius_top_right = 8
	panel_style.corner_radius_bottom_right = 8
	add_theme_stylebox_override("panel", panel_style)


	var old_mode = _responsive_mode

	# Determine responsive mode
	if _viewport_size.x >= 1200:
		_responsive_mode = 0  # Desktop
	elif _viewport_size.x >= 768:
		_responsive_mode = 1  # Tablet
	else:
		_responsive_mode = 2  # Mobile

	# Update UI if mode changed
	if old_mode != _responsive_mode:
		_update_responsive_state()


			var tween = create_tween()
			tween.tween_property(self, "size:x", custom_minimum_size.x, ANIMATION_DURATION)

		2:  # Mobile
			if _is_expanded:
				# Full width overlay
				custom_minimum_size.x = _viewport_size.x * 0.8
				_show_labels(true)
				# TODO: Show overlay background
			else:
				# Hidden off-screen
				custom_minimum_size.x = 0
				# TODO: Hide overlay background

			# Animate width change
			var tween = create_tween()
			tween.tween_property(self, "size:x", custom_minimum_size.x, ANIMATION_DURATION)


		var section_node = _section_nodes[section_id]
		if section_node.has_method("show_labels"):
			section_node.show_labels(show)


	var state = {"is_expanded": _is_expanded, "selected_item": _selected_item, "sections": {}}

	# Save section expanded states
	for section_id in _sections:
		state.sections[section_id] = {"expanded": _sections[section_id].expanded}

	# Save to state manager
	_component_state_manager.save_component_state("navigation_sidebar", state)


	var state = _component_state_manager.restore_component_state("navigation_sidebar")
	if state.is_empty():
		return

	# Restore expanded state
	if "is_expanded" in state:
		_is_expanded = state.is_expanded
		_update_responsive_state()

	# Restore section states
	if "sections" in state:
		for section_id in state.sections:
			if section_id in _sections and "expanded" in state.sections[section_id]:
				_sections[section_id].expanded = state.sections[section_id].expanded

				# Update section UI
				if section_id in _section_nodes:
					var section_node = _section_nodes[section_id]
					if section_node.has_method("set_expanded"):
						section_node.set_expanded(_sections[section_id].expanded)

	# Restore selected item
	if "selected_item" in state and not state.selected_item.section.is_empty():
		var section_id = state.selected_item.section
		var item_id = state.selected_item.item

		if section_id in _sections and item_id in _sections[section_id].items:
			_selected_item = {"section": section_id, "item": item_id}

			# Update section UI
			if section_id in _section_nodes:
				var section_node = _section_nodes[section_id]
				if section_node.has_method("select_item"):
					section_node.select_item(item_id)


# === EVENT HANDLERS ===

var _sections: Dictionary = {}
var _section_nodes: Dictionary = {}
var _is_expanded: bool = true
var _is_initialized: bool = false
var _selected_item: Dictionary = {"section": "", "item": ""}
var _viewport_size: Vector2
var _responsive_mode: int = 0  # 0: Desktop, 1: Tablet, 2: Mobile
var _safe_autoload_access = null
var _component_registry = null
var _component_state_manager = null
var _theme_manager = null
var _event_bus = null

# Main container for sections
var _main_container: VBoxContainer
var _header_container: HBoxContainer
var _sections_container: VBoxContainer


# === LIFECYCLE METHODS ===

func _ready() -> void:
	# Load dependencies safely
	_load_dependencies()

	# Create UI structure
	_create_ui()

	# Apply styling
	_apply_styling()

	# Setup responsive behavior
	_setup_responsive_behavior()

	# Restore state if available
	if use_state_persistence:
		_restore_state()

	_is_initialized = true
	print("[NavigationSidebar] Initialized")


func add_section(id: String, title: String, icon = null) -> bool:
	if id in _sections:
		push_warning("[NavigationSidebar] Section ID already exists: " + id)
		return false

	# Store section configuration
	_sections[id] = {"id": id, "title": title, "icon": icon, "items": {}, "expanded": true}

	# Create section if UI is ready
	if _is_initialized and _sections_container:
		_create_section_ui(id)

	return true


## Add a navigation item to a section
## @param section_id: ID of the parent section
## @param item_id: Unique identifier for the item
## @param title: Display title for the item
## @param icon: Optional icon for the item
## @returns: Boolean indicating success
func add_item(section_id: String, item_id: String, title: String, icon = null) -> bool:
	if not section_id in _sections:
		push_warning("[NavigationSidebar] Section does not exist: " + section_id)
		return false

	if item_id in _sections[section_id].items:
		push_warning("[NavigationSidebar] Item ID already exists in section: " + item_id)
		return false

	# Store item configuration
	_sections[section_id].items[item_id] = {"id": item_id, "title": title, "icon": icon}

	# Add item to section UI if ready
	if _is_initialized and section_id in _section_nodes:
func set_section_expanded(section_id: String, expanded: bool) -> bool:
	if not section_id in _sections:
		push_warning("[NavigationSidebar] Section does not exist: " + section_id)
		return false

	# Update section configuration
	_sections[section_id].expanded = expanded

	# Update section UI if ready
	if _is_initialized and section_id in _section_nodes:
func select_item(section_id: String, item_id: String) -> bool:
	if not section_id in _sections:
		push_warning("[NavigationSidebar] Section does not exist: " + section_id)
		return false

	if not item_id in _sections[section_id].items:
		push_warning("[NavigationSidebar] Item does not exist in section: " + item_id)
		return false

	# Clear previous selection
	if not _selected_item.section.is_empty() and _selected_item.section in _section_nodes:
func get_selected_item() -> Dictionary:
	return _selected_item


## Set whether the sidebar is expanded (for responsive modes)
## @param expanded: Whether the sidebar should be expanded
func set_expanded(expanded: bool) -> void:
	if _is_expanded == expanded:
		return

	_is_expanded = expanded

	# Update UI for responsive modes
	_update_responsive_state()

	# Save state if persistence is enabled
	if use_state_persistence:
		_save_state()

	# Emit signal
	sidebar_expanded_changed.emit(expanded)


## Get whether the sidebar is expanded
## @returns: Boolean indicating expanded state
func is_expanded() -> bool:
	return _is_expanded


## Toggle the sidebar expanded state
func toggle_expanded() -> void:
	set_expanded(not _is_expanded)


## Save current state (expand states, selection)
func save_state() -> void:
	_save_state()


## Restore saved state
func restore_state() -> void:
	_restore_state()


# === PRIVATE METHODS ===

func _notification(what: int) -> void:
	# Handle viewport size changes for responsive design
	if what == NOTIFICATION_RESIZED:
		_check_responsive_mode()


# === PUBLIC METHODS ===
## Add a new section to the sidebar
## @param id: Unique identifier for the section
## @param title: Display title for the section
## @param icon: Optional icon for the section
## @returns: Boolean indicating success
func _load_dependencies() -> void:
	"""Load required dependencies safely"""
	# Try to load SafeAutoloadAccess first if available
func _create_ui() -> void:
	"""Create the sidebar UI structure"""
	# Main container
	_main_container = VBoxContainer.new()
	_main_container.name = "MainContainer"
	_main_container.add_theme_constant_override("separation", 16)
	_main_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_main_container.add_theme_constant_override("margin_left", 16)
	_main_container.add_theme_constant_override("margin_right", 16)
	_main_container.add_theme_constant_override("margin_top", 16)
	_main_container.add_theme_constant_override("margin_bottom", 16)
	add_child(_main_container)

	# Header container
	_header_container = HBoxContainer.new()
	_header_container.name = "HeaderContainer"
	_main_container.add_child(_header_container)

	# App title
func _create_section_ui(section_id: String) -> void:
	"""Create UI for a section"""
	if not _component_registry:
		push_error("[NavigationSidebar] ComponentRegistry not available")
		return

func _apply_styling() -> void:
	"""Apply styling to the sidebar"""
	# Use theme manager if available (with static call)
	if _theme_manager:
		UIThemeManager.apply_glass_panel(self)
		return

	# Fallback styling
func _setup_responsive_behavior() -> void:
	"""Setup responsive behavior based on viewport size"""
	# Get initial viewport size
	_viewport_size = get_viewport().get_visible_rect().size

	# Set initial custom minimum size
	custom_minimum_size.x = DESKTOP_WIDTH

	# Initial responsive mode check
	_check_responsive_mode()


func _check_responsive_mode() -> void:
	"""Check and update responsive mode based on viewport size"""
	if not is_inside_tree():
		return

	_viewport_size = get_viewport().get_visible_rect().size
func _update_responsive_state() -> void:
	"""Update UI based on responsive mode and expanded state"""
	match _responsive_mode:
		0:  # Desktop
			# Always expanded on desktop
			_is_expanded = true
			custom_minimum_size.x = DESKTOP_WIDTH
			_show_labels(true)

		1:  # Tablet
			if _is_expanded:
				custom_minimum_size.x = DESKTOP_WIDTH
				_show_labels(true)
			else:
				custom_minimum_size.x = TABLET_WIDTH
				_show_labels(false)

			# Animate width change
func _show_labels(show: bool) -> void:
	"""Show or hide text labels in sections and items"""
	for section_id in _section_nodes:
func _save_state() -> void:
	"""Save current state using ComponentStateManager"""
	if (
		not _component_state_manager
		or not _component_state_manager.has_method("save_component_state")
	):
		return

	# Collect state data
func _restore_state() -> void:
	"""Restore state from ComponentStateManager"""
	if (
		not _component_state_manager
		or not _component_state_manager.has_method("restore_component_state")
	):
		return

func _on_toggle_button_pressed() -> void:
	"""Handle sidebar toggle button press"""
	toggle_expanded()


func _on_section_toggled(expanded: bool, section_id: String) -> void:
	"""Handle section toggle"""
	if not section_id in _sections:
		return

	# Update section state
	_sections[section_id].expanded = expanded

	# Save state if persistence is enabled
	if use_state_persistence:
		_save_state()

	# Emit signal
	section_toggled.emit(section_id, expanded)


func _on_item_selected(item_id: String, section_id: String) -> void:
	"""Handle item selection"""
	select_item(section_id, item_id)
