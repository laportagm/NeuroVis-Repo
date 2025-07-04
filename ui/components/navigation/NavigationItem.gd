## NavigationItem.gd
## Interactive navigation item for the sidebar
##
## Enhanced version of NavItem with additional features like badges,
## tooltips, and better integration with the component system.
##
## @tutorial: Navigation architecture
## @version: 1.0

class_name NavigationItem
extends PanelContainer

# === SIGNALS ===
## Emitted when the item is clicked

signal clicked

# === EXPORTS ===
## Item text

@export var text: String = "Navigation Item":
set(value):
text = value
@export var icon_texture: Texture2D:
set(value):
icon_texture = value
@export var is_selected: bool = false:
set(value):
@export var show_label: bool = true:
set(value):
show_label = value
@export var badge_text: String = "":
set(value):
badge_text = value
_update_badge()

		# === PRIVATE VARIABLES ===

var safe_autoload_script = preload("res://ui/components/core/SafeAutoloadAccess.gd")
# FIXED: Orphaned code - var badge_bg = StyleBoxFlat.new()
	# ORPHANED REF: badge_bg.bg_color = _color_accent
	# ORPHANED REF: badge_bg.corner_radius_top_left = 8
	# ORPHANED REF: badge_bg.corner_radius_top_right = 8
	# ORPHANED REF: badge_bg.corner_radius_bottom_left = 8
	# ORPHANED REF: badge_bg.corner_radius_bottom_right = 8
	# ORPHANED REF: badge_bg.content_margin_left = 4
	# ORPHANED REF: badge_bg.content_margin_right = 4
	# ORPHANED REF: badge_bg.content_margin_top = 0
	# ORPHANED REF: badge_bg.content_margin_bottom = 0
	# ORPHANED REF: _badge.add_theme_stylebox_override("normal", badge_bg)


	# === EVENT HANDLERS ===
var scene = PackedScene.new()

# Root node
var root = PanelContainer.new()
root.name = "NavigationItem"
root.custom_minimum_size = Vector2(0, 32)
root.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	# HBoxContainer for layout
var hbox = HBoxContainer.new()
hbox.name = "HBoxContainer"
hbox.add_theme_constant_override("separation", 8)
root.add_child(hbox)

	# Icon
var icon = TextureRect.new()
icon.name = "Icon"
icon.custom_minimum_size = Vector2(18, 18)
icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
hbox.add_child(icon)

	# Label
var label = Label.new()
label.name = "Label"
label.text = "Navigation Item"
label.add_theme_font_size_override("font_size", 14)
label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
hbox.add_child(label)

	# Badge
var badge = Label.new()
badge.name = "Badge"
badge.add_theme_font_size_override("font_size", 12)
badge.visible = false
hbox.add_child(badge)

	# Pack the scene
scene.pack(root)

# FIXED: Orphaned code - var _id: String = ""
var _safe_autoload_access = null
var _theme_manager = null

# Theme colors with defaults
var _color_text_primary: Color = Color(0.9, 0.9, 0.9, 1.0)
# FIXED: Orphaned code - var _color_text_secondary: Color = Color(0.6, 0.6, 0.6, 1.0)
# FIXED: Orphaned code - var _color_accent: Color = Color(0.15, 0.82, 0.81, 1.0)  # #26d0ce
var _color_bg_hover: Color = Color(0.16, 0.16, 0.16, 1.0)
# FIXED: Orphaned code - var _color_bg_selected: Color = Color(0.08, 0.24, 0.24, 1.0)

# UI components
var _hbox: HBoxContainer
var _icon: TextureRect
var _label: Label
var _badge: Label
var _default_style: StyleBoxFlat
var _hover_style: StyleBoxFlat
var _selected_style: StyleBoxFlat


# === LIFECYCLE METHODS ===

func _ready() -> void:
	# Load dependencies
	_load_dependencies()

	# Load theme colors
	_load_theme_colors()

	# Create UI
	_create_ui()

	# Create styles
	_create_styles()

	# Apply initial style
	_update_style()

	# Connect signals
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	gui_input.connect(_on_gui_input)


	# === PUBLIC METHODS ===
	## Configure the item with the given parameters
	## @param config: Dictionary with configuration parameters

func configure(config: Dictionary) -> void:
	if config.has("id"):
	# ORPHANED REF: _id = config.id

	if config.has("text"):
	text = config.text

	if config.has("icon"):
	icon_texture = config.icon

	if config.has("selected"):
	is_selected = config.selected

	if config.has("show_label"):
	show_label = config.show_label

	if config.has("badge"):
	badge_text = config.badge


							## Set whether the item is selected
							## @param selected: Whether the item should be selected
func set_selected(selected: bool) -> void:
	is_selected = selected


	## Set badge text (for notifications/counts)
	## @param value: Badge text to display
func set_badge(value: String) -> void:
	badge_text = value


	## Set whether to show the text label (for responsive design)
	## @param show: Whether to show the label
func show_label(show: bool) -> void:
	show_label = show


	## Get the item's ID
	## @returns: Item ID
func get_id() -> String:
	# ORPHANED REF: return _id


	# === PRIVATE METHODS ===

	if _label:
	_label.text = value

	## Item icon
	if _icon:
	_icon.texture = value

	## Whether the item is selected
	if is_selected != value:
	is_selected = value
	_update_style()

	## Whether to show the text label (for responsive design)
	if _label:
	_label.visible = value

	## Badge text (for notifications/counts)
	if safe_autoload_script:
	_safe_autoload_access = safe_autoload_script.new()

	# Load UIThemeManager
	if _safe_autoload_access and _safe_autoload_access.has_method("get_autoload"):
	_theme_manager = _safe_autoload_access.get_autoload("UIThemeManager")
else:
	_theme_manager = get_node_or_null("/root/UIThemeManager")


	return scene

func _load_dependencies() -> void:
	"""Load required dependencies safely"""
	# Try to load SafeAutoloadAccess first if available
func _load_theme_colors() -> void:
	"""Load theme colors from UIThemeManager if available"""
	if _theme_manager:
	if _theme_manager.has_method("get_color"):
	# ORPHANED REF: _color_accent = (
	_theme_manager.get_color("accent")
	if _theme_manager.get_color("accent")
	# ORPHANED REF: else _color_accent
	)
	_color_text_primary = (
	_theme_manager.get_color("text_primary")
	if _theme_manager.get_color("text_primary")
	else _color_text_primary
	)
	# ORPHANED REF: _color_text_secondary = (
	_theme_manager.get_color("text_secondary")
	if _theme_manager.get_color("text_secondary")
	# ORPHANED REF: else _color_text_secondary
	)
	_color_bg_hover = (
	_theme_manager.get_color("surface_hover")
	if _theme_manager.get_color("surface_hover")
	else _color_bg_hover
	)
	# ORPHANED REF: _color_bg_selected = (
	_theme_manager.get_color("surface_selected")
	if _theme_manager.get_color("surface_selected")
	# ORPHANED REF: else _color_bg_selected
	)


func _create_ui() -> void:
	"""Create the item UI structure"""
	custom_minimum_size = Vector2(0, 32)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL

	# Main layout
	_hbox = HBoxContainer.new()
	_hbox.add_theme_constant_override("separation", 8)
	add_child(_hbox)

	# Icon
	_icon = TextureRect.new()
	_icon.custom_minimum_size = Vector2(18, 18)
	_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	if icon_texture:
	_icon.texture = icon_texture
	_hbox.add_child(_icon)

		# Label
	_label = Label.new()
	_label.text = text
	_label.add_theme_font_size_override("font_size", 14)
	_label.visible = show_label
	_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_hbox.add_child(_label)

		# Badge (for notifications)
	_badge = Label.new()
	_badge.add_theme_font_size_override("font_size", 12)
	_badge.visible = false
	_hbox.add_child(_badge)

		# Update badge
	_update_badge()


func _create_styles() -> void:
	"""Create the item styles"""
	# Default style (transparent background)
	_default_style = StyleBoxFlat.new()
	_default_style.bg_color = Color.TRANSPARENT
	_default_style.corner_radius_top_left = 4
	_default_style.corner_radius_top_right = 4
	_default_style.corner_radius_bottom_left = 4
	_default_style.corner_radius_bottom_right = 4
	_default_style.content_margin_left = 8
	_default_style.content_margin_right = 8
	_default_style.content_margin_top = 4
	_default_style.content_margin_bottom = 4

	# Hover style
	_hover_style = _default_style.duplicate()
	_hover_style.bg_color = _color_bg_hover

	# Selected style
	_selected_style = _default_style.duplicate()
	# ORPHANED REF: _selected_style.bg_color = _color_bg_selected
	_selected_style.border_width_left = 3
	# ORPHANED REF: _selected_style.border_color = _color_accent
	_selected_style.content_margin_left = 5  # Compensate for border


func _update_style() -> void:
	"""Update the item style based on state"""
	if is_selected:
	add_theme_stylebox_override("panel", _selected_style)
	if _label:
	# ORPHANED REF: _label.add_theme_color_override("font_color", _color_accent)
	if _icon:
	# ORPHANED REF: _icon.modulate = _color_accent
else:
	add_theme_stylebox_override("panel", _default_style)
	if _label:
	_label.add_theme_color_override("font_color", _color_text_primary)
	if _icon:
	# ORPHANED REF: _icon.modulate = _color_text_secondary


func _update_badge() -> void:
	"""Update badge visibility and text"""
	if not _badge:
	return

	if badge_text.is_empty():
	_badge.visible = false
else:
	_badge.text = badge_text
	_badge.visible = true

				# Apply badge styling
	_badge.add_theme_color_override("font_color", Color.WHITE)

				# Add background color
func _on_mouse_entered() -> void:
	"""Handle mouse enter event"""
	if not is_selected:
	add_theme_stylebox_override("panel", _hover_style)
	if _label:
	_label.add_theme_color_override("font_color", _color_text_primary)
	if _icon:
	_icon.modulate = _color_text_primary

	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND


func _on_mouse_exited() -> void:
	"""Handle mouse exit event"""
	if not is_selected:
	_update_style()


func _on_gui_input(event: InputEvent) -> void:
	"""Handle GUI input"""
	if event is InputEventMouseButton:
	if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
	clicked.emit()
	get_viewport().set_input_as_handled()


			# Static method to create the scene structure
static func create_scene() -> PackedScene:
	"""Create a packed scene for this component"""

	return null
