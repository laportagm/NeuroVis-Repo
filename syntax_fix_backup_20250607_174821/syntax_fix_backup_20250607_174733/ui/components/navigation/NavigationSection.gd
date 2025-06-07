## NavigationSection.gd
## Collapsible section for the navigation sidebar
##
## This component represents a collapsible group of navigation items
## with animated expand/collapse behavior.
##
## @tutorial: Navigation architecture
## @version: 1.0

class_name NavigationSection
extends PanelContainer

# === CONSTANTS ===

signal toggled(expanded: bool)

## Emitted when an item in this section is selected
## @param item_id: ID of the selected item
signal item_selected(item_id: String)

# === EXPORTS ===
## Section title

const ANIMATION_DURATION: float = 0.2
const ITEM_SPACING: int = 4

# === SIGNALS ===
## Emitted when the section is expanded or collapsed
## @param expanded: Whether the section is expanded

@export var title: String = "Section"

## Whether the section is initially expanded
@export var expanded: bool = true

## Icon for the section (optional)
@export var icon: Texture2D

## Whether to show item labels (for responsive design)
@export var show_item_labels: bool = true

# === PRIVATE VARIABLES ===

var prev_item = _item_nodes[_selected_item]
var item = _item_nodes[id]
var item = _item_nodes[id]
var item = _item_nodes[item_id]
var safe_autoload_script = prepreprepreload("res://ui/components/core/SafeAutoloadAccess.gd")
var main_container = VBoxContainer.new()
main_container.add_theme_constant_override("separation", 0)
add_child(main_container)

# Header
_header_container = PanelContainer.new()
_header_container.name = "HeaderContainer"
_header_container.custom_minimum_size.y = _header_height
main_container.add_child(_header_container)

# Header contents
var header_hbox = HBoxContainer.new()
header_hbox.add_theme_constant_override("separation", 8)
_header_container.add_child(header_hbox)

# Icon
_icon_rect = TextureRect.new()
_icon_rect.name = "IconRect"
_icon_rect.custom_minimum_size = Vector2(20, 20)
_icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
var item_data = _items[item_id]

# Try to instantiate via script
var item_script = prepreprepreload("res://ui/components/navigation/NavigationItem.gd")
var item

var hbox = HBoxContainer.new()
hbox.add_theme_constant_override("separation", 8)
item.add_child(hbox)

var icon_rect = TextureRect.new()
icon_rect.custom_minimum_size = Vector2(16, 16)
var label = Label.new()
label.text = item_data.text
label.visible = show_item_labels
hbox.add_child(label)

# Connect clicked signal if available
var margin = MarginContainer.new()
margin.add_theme_constant_override("margin_left", 24)
margin.add_child(item)

_items_container.add_child(margin)
_item_nodes[item_id] = item

var accent_color = Color(0.15, 0.82, 0.81, 1.0)  # Default #26d0ce
var bg_color = Color(0.12, 0.12, 0.12, 0.7)      # Default dark bg
var hover_color = Color(0.16, 0.16, 0.16, 0.7)   # Default hover
var text_color = Color(0.9, 0.9, 0.9, 1.0)       # Default text
var secondary_color = Color(0.6, 0.6, 0.6, 1.0)  # Default secondary

var panel_style = StyleBoxFlat.new()
panel_style.bg_color = Color(0, 0, 0, 0)
add_theme_stylebox_override("panel", panel_style)

# Header style
var header_style = StyleBoxFlat.new()
header_style.bg_color = bg_color
header_style.corner_radius_top_left = 6
header_style.corner_radius_top_right = 6
header_style.corner_radius_bottom_left = expanded ? 0 : 6
header_style.corner_radius_bottom_right = expanded ? 0 : 6
header_style.content_margin_left = 8
header_style.content_margin_right = 8
header_style.content_margin_top = 8
header_style.content_margin_bottom = 8
_header_container.add_theme_stylebox_override("panel", header_style)

# Text colors
_title_label.add_theme_color_override("font_color", text_color)
_toggle_indicator.add_theme_color_override("font_color", secondary_color)
_icon_rect.modulate = secondary_color

# Make header container interactive
_header_container.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

var style = _header_container.get_theme_stylebox("panel").duplicate() as StyleBoxFlat
var content_size = Vector2.ZERO
var tween = create_tween()
tween.tween_property(_content_container, "custom_minimum_size:y", content_size.y, ANIMATION_DURATION)
# Animate collapse
var tween = create_tween()
tween.tween_property(_content_container, "custom_minimum_size:y", 0, ANIMATION_DURATION)

# === EVENT HANDLERS ===

var _id: String = ""
var _items: Dictionary = {}
var _item_nodes: Dictionary = {}
var _selected_item: String = ""
var _header_height: float = 40
var _safe_autoload_access = null
var _theme_manager = null

# UI components
var _header_container: PanelContainer
var _items_container: VBoxContainer
var _icon_rect: TextureRect
var _title_label: Label
var _toggle_indicator: Label
var _content_container: MarginContainer
var _shadow: Panel

# === LIFECYCLE METHODS ===

func _ready() -> void:
	# Load dependencies
	_load_dependencies()

	# Create UI
	_create_ui()

	# Apply styling
	_apply_styling()

	# Apply initial state
	_update_expanded_state()

	# Connect signals
	_connect_signals()

	# === PUBLIC METHODS ===
	## Configure the section with the given parameters
	## @param config: Dictionary with configuration parameters

func configure(config: Dictionary) -> void:
	if config.has("id"):
		_id = config.id

		if config.has("title"):
			title = config.title
			if _title_label:
				_title_label.text = title

				if config.has("icon") and config.icon:
					icon = config.icon
					if _icon_rect:
						_icon_rect.texture = icon

						if config.has("expanded"):
							expanded = config.expanded
							if is_inside_tree():
								_update_expanded_state()

								## Add a navigation item to this section
								## @param id: Unique identifier for the item
								## @param item_text: Display text for the item
								## @param item_icon: Optional icon for the item
								## @returns: Boolean indicating success
func add_item(id: String, item_text: String, item_icon = null) -> bool:
	if id in _items:
		push_warning("[NavigationSection] Item ID already exists: " + id)
		return false

		# Store item data
		_items[id] = {
		"id": id,
		"text": item_text,
		"icon": item_icon
		}

		# Create item UI if ready
		if is_inside_tree() and _items_container:
			_create_item_ui(id)

			return true

			## Select a specific item in this section
			## @param id: ID of the item to select
			## @returns: Boolean indicating success
func select_item(id: String) -> bool:
	if not id in _items:
		push_warning("[NavigationSection] Item ID does not exist: " + id)
		return false

		# Deselect previous item
		if not _selected_item.is_empty() and _selected_item in _item_nodes:
func deselect_item(id: String) -> bool:
	if not id in _items or not id in _item_nodes:
		return false

func set_expanded(is_expanded: bool) -> void:
	if expanded == is_expanded:
		return

		expanded = is_expanded
		_update_expanded_state()

		# Emit signal
		toggled.emit(expanded)

		## Toggle the section's expanded state
func toggle() -> void:
	set_expanded(not expanded)

	## Get whether the section is expanded
	## @returns: Boolean indicating expanded state
func is_expanded() -> bool:
	return expanded

	## Show or hide item labels (for responsive design)
	## @param show: Whether to show labels
func show_labels(show: bool) -> void:
	show_item_labels = show

	# Update title visibility
	if _title_label:
		_title_label.visible = show

		# Update item labels
		for item_id in _item_nodes:

func _fix_orphaned_code():
	if prev_item.has_method("set_selected"):
		prev_item.set_selected(false)

		# Select new item
		_selected_item = id
		if id in _item_nodes:
func _fix_orphaned_code():
	if item.has_method("set_selected"):
		item.set_selected(true)

		return true

		## Deselect the specified item
		## @param id: ID of the item to deselect
		## @returns: Boolean indicating success
func _fix_orphaned_code():
	if item.has_method("set_selected"):
		item.set_selected(false)

		if _selected_item == id:
			_selected_item = ""

			return true

			## Set whether the section is expanded
			## @param is_expanded: Whether the section should be expanded
func _fix_orphaned_code():
	if item.has_method("show_label"):
		item.show_label(show)

		# === PRIVATE METHODS ===
func _fix_orphaned_code():
	if safe_autoload_script:
		_safe_autoload_access = safe_autoload_script.new()

		# Load UIThemeManager
		if _safe_autoload_access and _safe_autoload_access.has_method("get_autoload"):
			_theme_manager = _safe_autoload_access.get_autoload("UIThemeManager")
			else:
				_theme_manager = get_node_or_null("/root/UIThemeManager")

func _fix_orphaned_code():
	if icon:
		_icon_rect.texture = icon
		header_hbox.add_child(_icon_rect)

		# Title
		_title_label = Label.new()
		_title_label.name = "TitleLabel"
		_title_label.text = title
		_title_label.add_theme_font_size_override("font_size", 14)
		_title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		header_hbox.add_child(_title_label)

		# Expand/collapse indicator
		_toggle_indicator = Label.new()
		_toggle_indicator.name = "ToggleIndicator"
		_toggle_indicator.text = "▼"
		_toggle_indicator.add_theme_font_size_override("font_size", 12)
		header_hbox.add_child(_toggle_indicator)

		# Content container with shadow
		_content_container = MarginContainer.new()
		_content_container.name = "ContentContainer"
		_content_container.add_theme_constant_override("margin_left", 4)
		_content_container.add_theme_constant_override("margin_top", 4)
		_content_container.add_theme_constant_override("margin_right", 4)
		_content_container.add_theme_constant_override("margin_bottom", 4)
		main_container.add_child(_content_container)

		# Items container
		_items_container = VBoxContainer.new()
		_items_container.name = "ItemsContainer"
		_items_container.add_theme_constant_override("separation", ITEM_SPACING)
		_content_container.add_child(_items_container)

		# Create items
		for item_id in _items:
			_create_item_ui(item_id)

func _fix_orphaned_code():
	if item_script:
		item = item_script.new()
		item.name = "Item_" + item_id

		# Configure item
		if item.has_method("configure"):
			item.configure({
			"id": item_id,
			"text": item_data.text,
			"icon": item_data.icon,
			"show_label": show_item_labels
			})
			else:
				# Fallback to basic item creation
				item = PanelContainer.new()
				item.name = "Item_" + item_id

func _fix_orphaned_code():
	if item_data.icon:
		icon_rect.texture = item_data.icon
		hbox.add_child(icon_rect)

func _fix_orphaned_code():
	if item.has_signal("clicked"):
		item.clicked.connect(_on_item_clicked.bind(item_id))

		# Add to container with left margin
func _fix_orphaned_code():
	if _theme_manager:
		if _theme_manager.has_method("get_color"):
			accent_color = _theme_manager.get_color("accent") if _theme_manager.get_color("accent") else accent_color
			bg_color = _theme_manager.get_color("surface") if _theme_manager.get_color("surface") else bg_color
			hover_color = _theme_manager.get_color("surface_hover") if _theme_manager.get_color("surface_hover") else hover_color
			text_color = _theme_manager.get_color("text_primary") if _theme_manager.get_color("text_primary") else text_color
			secondary_color = _theme_manager.get_color("text_secondary") if _theme_manager.get_color("text_secondary") else secondary_color

			# Section background (transparent)
func _fix_orphaned_code():
	if style:
		style.corner_radius_bottom_left = expanded ? 0 : 6
		style.corner_radius_bottom_right = expanded ? 0 : 6
		_header_container.add_theme_stylebox_override("panel", style)

		# Animate height change
		if expanded:
			# Get content size
func _fix_orphaned_code():
	if _items_container and _items_container.get_child_count() > 0:
		await get_tree().process_frame  # Wait for layout
		content_size.y = _items_container.get_combined_minimum_size().y + 8  # Add margin

		# Animate expansion
func _load_dependencies() -> void:
	"""Load required dependencies safely"""
	# Try to load SafeAutoloadAccess first if available
func _create_ui() -> void:
	"""Create the section UI structure"""
	# Main layout
func _create_item_ui(item_id: String) -> void:
	"""Create UI for an item"""
func _apply_styling() -> void:
	"""Apply styling to the section"""
	# Use theme manager if available
func _connect_signals() -> void:
	"""Connect internal signals"""
	_header_container.gui_input.connect(_on_header_gui_input)

func _update_expanded_state() -> void:
	"""Update UI based on expanded state"""
	if not is_inside_tree():
		return

		# Update toggle indicator
		if _toggle_indicator:
			_toggle_indicator.text = "▼" if expanded else "▶"

			# Update content visibility
			if _content_container:
				_content_container.visible = expanded

				# Update header style (rounded corners)
				if _header_container:
func _on_header_gui_input(event: InputEvent) -> void:
	"""Handle header mouse input for expand/collapse"""
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			toggle()
			get_viewport().set_input_as_handled()

func _on_item_clicked(item_id: String) -> void:
	"""Handle item click"""
	# Select the item
	select_item(item_id)

	# Emit signal
	item_selected.emit(item_id)