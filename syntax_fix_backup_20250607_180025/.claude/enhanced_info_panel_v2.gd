# Enhanced Structure Information Panel - Figma Design Implementation
# Based on professional Figma design specifications

class_name EnhancedInfoPanel
extends PanelContainer

# Design token imports from Figma

signal panel_closed
signal structure_bookmarked(structure_id: String)
signal structure_shared(structure_id: String)

# Responsive breakpoints

const BREAKPOINTS = {"mobile": 768, "tablet": 1024, "desktop": 1366}

# UI Components

var current_structure_id: String = ""
var is_bookmarked: bool = false
var expanded_sections: Dictionary = {}
var viewport_size: Vector2
var current_breakpoint: String = "desktop"

# Node references
var width = viewport_size.x
var config = _get_responsive_config()

# Calculate responsive width
var panel_width = viewport_size.x * config.width_percent
panel_width = clamp(panel_width, config.min_width, config.max_width)

# Set size and position
custom_minimum_size.x = panel_width

# Position panel
var main_container = MarginContainer.new()
main_container.name = "MainContainer"
main_container.add_theme_constant_override("margin_top", 24)
main_container.add_theme_constant_override("margin_bottom", 24)
main_container.add_theme_constant_override("margin_left", 24)
main_container.add_theme_constant_override("margin_right", 24)
add_child(main_container)

# Sections container
sections_container = VBoxContainer.new()
sections_container.name = "SectionsContainer"
sections_container.add_theme_constant_override("separation", 20)
main_container.add_child(sections_container)

# Create header
_create_header_section()

# Create content sections
_create_description_section()
_create_functions_section()
_create_connections_section()
_create_clinical_section()

var button = Button.new()
button.name = button_name.capitalize() + "Button"
button.text = button_icon
button.custom_minimum_size = Vector2(32, 32)
button.flat = true

# Add hover effect
button.mouse_entered.connect(
func():
	_animate_button_hover(button, true)
	)
	button.mouse_exited.connect(
	func():
		_animate_button_hover(button, false)
		)

var description_text = RichTextLabel.new()
	description_text.bbcode_enabled = true
	description_text.fit_content = true
	description_text.custom_minimum_size.y = 80
	description_text.text = "[color=#E8E8E8]The hippocampus is a critical brain structure for memory formation and spatial navigation. It plays a key role in converting short-term memories into long-term memories.[/color]"
	description_section.add_child(description_text)

var functions_list = VBoxContainer.new()
	functions_list.add_theme_constant_override("separation", 12)

var functions = [
	"Memory consolidation and retrieval",
	"Spatial navigation and mapping",
	"Pattern separation and completion",
	"Emotional regulation",
	"Stress response modulation"
	]

var item = _create_list_item(function)
	functions_list.add_child(item)

	functions_section.add_child(functions_list)

var placeholder = Label.new()
	placeholder.text = "Click to view neural connections"
	placeholder.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
	connections_section.add_child(placeholder)

var premium_notice = Label.new()
	premium_notice.text = "🔒 Premium content"
	premium_notice.add_theme_color_override("font_color", Color(0.7, 0.7, 0.3))
	clinical_section.add_child(premium_notice)

var section = VBoxContainer.new()
	section.name = title.replace(" ", "") + "Section"
	sections_container.add_child(section)

	# Section header
var header = HBoxContainer.new()
	section.add_child(header)

	# Collapse indicator
var indicator = Label.new()
	indicator.text = "▼" if expanded else "▶"
	indicator.add_theme_font_size_override("font_size", 12)
	header.add_child(indicator)

	# Make header clickable
	header.gui_input.connect(
	func(event):
var label = Label.new()
	label.text = title.to_upper()
	label.add_theme_font_size_override("font_size", 14)
	label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(label)

	# Item count (if applicable)
var count = Label.new()
	count.text = "(5)" if title == "Functions" else "(12)"
	count.add_theme_font_size_override("font_size", 12)
	count.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
	header.add_child(count)

var container = HBoxContainer.new()
	container.add_theme_constant_override("separation", 8)

	# Bullet
var bullet = Label.new()
	bullet.text = "•"
	bullet.add_theme_color_override("font_color", Color("#06FFA5"))
	container.add_child(bullet)

	# Text
var label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 13)
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	container.add_child(label)

	# Add hover effect
	container.mouse_entered.connect(func(): _animate_list_item_hover(container, true))
	container.mouse_exited.connect(func(): _animate_list_item_hover(container, false))

var style = StyleBoxFlat.new()
	style.bg_color = Color(0.06, 0.06, 0.09, 0.85) # rgba(15, 15, 23, 0.85)
	style.border_color = Color(0, 0.85, 1, 0.15) # rgba(0, 217, 255, 0.15)
	style.border_width_left = 1
	style.border_width_right = 1
	style.border_width_top = 1
	style.border_width_bottom = 1
	style.corner_radius_top_left = 16
	style.corner_radius_top_right = 16
	style.corner_radius_bottom_left = 16
	style.corner_radius_bottom_right = 16

	# Advanced shadow for depth
	style.shadow_size = 32
	style.shadow_color = Color(0, 0, 0, 0.4)
	style.shadow_offset = Vector2(0, 8)

	add_theme_stylebox_override("panel", style)

	# Apply colors to elements
var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate", Color.WHITE, 0.4).set_trans(Tween.TRANS_CUBIC).set_ease(
	Tween.EASE_OUT
	)
	tween.tween_property(self, "scale", Vector2.ONE, 0.4).set_trans(Tween.TRANS_BACK).set_ease(
	Tween.EASE_OUT
	)

var tween = button.create_tween()

var tween = item.create_tween()

var is_expanded = expanded_sections.get(section_id, false)
	expanded_sections[section_id] = not is_expanded

	# Update indicator
var header = section.get_child(0)
var indicator = header.get_child(0)

# Animate indicator rotation
var tween = indicator.create_tween()
var tween = bookmark_button.create_tween()
	tween.tween_property(bookmark_button, "scale", Vector2(1.3, 1.3), 0.1)
	tween.tween_property(bookmark_button, "scale", Vector2.ONE, 0.1)

	emit_signal("structure_bookmarked", current_structure_id)

var tween = share_button.create_tween()
	tween.tween_property(share_button, "rotation_degrees", 360, 0.3)
	tween.tween_callback(func(): share_button.rotation_degrees = 0)

	emit_signal("structure_shared", current_structure_id)

var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.2)
	tween.tween_property(self, "scale", Vector2(0.95, 0.95), 0.2)
	tween.tween_callback(emit_signal.bind("panel_closed"))

var new_breakpoint = _get_current_breakpoint()
var tween = create_tween()
	tween.tween_property(sections_container, "modulate:a", 0, 0.15)
	tween.tween_callback(_update_all_content.bind(structure_data))
	tween.tween_property(sections_container, "modulate:a", 1, 0.15)

@onready var header_container: HBoxContainer
@onready var structure_name_label: Label
@onready var action_buttons: HBoxContainer
@onready var bookmark_button: Button
@onready var share_button: Button
@onready var close_button: Button

# Content sections
@onready var sections_container: VBoxContainer
@onready var description_section: Control
@onready var functions_section: Control
@onready var connections_section: Control
@onready var clinical_section: Control

func _ready() -> void:
	# Initialize responsive system
	_setup_responsive_layout()

	# Create UI structure
	_create_enhanced_ui()

	# Apply Figma design tokens
	_apply_figma_design()

	# Setup animations
	_setup_animations()

	# Connect viewport resize
	get_viewport().size_changed.connect(_on_viewport_resized)

func display_structure_data(structure_data: Dictionary) -> void:
	"""Display structure with enhanced animations"""
	current_structure_id = structure_data.get("id", "")

	# Update content
	if structure_name_label:
		structure_name_label.text = structure_data.get("displayName", "Unknown")

		# Animate content change

func _fix_orphaned_code():
	if width < BREAKPOINTS.mobile:
		return "mobile"
		if width < BREAKPOINTS.tablet:
			return "tablet"
			return "desktop"

func _fix_orphaned_code():
	if config.position == "right":
		position.x = viewport_size.x - panel_width - config.offset
		position.y = config.offset
		size.y = viewport_size.y - (config.offset * 2)
		elif config.position == "bottom":
			position.x = (viewport_size.x - panel_width) / 2
			position.y = viewport_size.y * 0.5
			size.y = viewport_size.y * 0.5 - config.offset

func _fix_orphaned_code():
	return button

func _fix_orphaned_code():
	for function in functions:
func _fix_orphaned_code():
	if collapsible:
func _fix_orphaned_code():
	if event is InputEventMouseButton and event.pressed:
		_toggle_section(section, title.to_lower())
		)

		# Section title
func _fix_orphaned_code():
	if collapsible and not premium:
func _fix_orphaned_code():
	return section

func _fix_orphaned_code():
	return container

func _fix_orphaned_code():
	if structure_name_label:
		structure_name_label.add_theme_color_override("font_color", Color("#00D9FF"))

func _fix_orphaned_code():
	if hovering:
		tween.tween_property(button, "scale", Vector2(1.1, 1.1), 0.15).set_trans(Tween.TRANS_BACK)
		button.modulate = Color(1.1, 1.1, 1.1)
		else:
			tween.tween_property(button, "scale", Vector2.ONE, 0.15).set_trans(Tween.TRANS_BACK)
			button.modulate = Color.WHITE

func _fix_orphaned_code():
	if hovering:
		tween.tween_property(item, "modulate", Color(1.05, 1.05, 1.05), 0.15)
		# Subtle translate effect
		tween.parallel().tween_property(item, "position:x", 4, 0.15)
		else:
			tween.tween_property(item, "modulate", Color.WHITE, 0.15)
			tween.parallel().tween_property(item, "position:x", 0, 0.15)

func _fix_orphaned_code():
	if expanded_sections[section_id]:
		tween.tween_property(indicator, "rotation_degrees", 0, 0.3)
		indicator.text = "▼"
		else:
			tween.tween_property(indicator, "rotation_degrees", -90, 0.3)
			indicator.text = "▶"

			# TODO: Animate content visibility

func _fix_orphaned_code():
	if new_breakpoint != current_breakpoint:
		current_breakpoint = new_breakpoint
		_update_panel_layout()

func _get_current_breakpoint() -> String:
func _update_panel_layout() -> void:
func _create_enhanced_ui() -> void:
	"""Create the enhanced UI structure based on Figma design"""
	# Main container with padding
func _create_header_section() -> void:
	"""Create header with title and action buttons"""
	header_container = HBoxContainer.new()
	header_container.name = "HeaderContainer"
	header_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sections_container.add_child(header_container)

	# Structure name
	structure_name_label = Label.new()
	structure_name_label.name = "StructureName"
	structure_name_label.text = "Hippocampus"
	structure_name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	structure_name_label.add_theme_font_size_override("font_size", 24)
	header_container.add_child(structure_name_label)

	# Action buttons container
	action_buttons = HBoxContainer.new()
	action_buttons.add_theme_constant_override("separation", 8)
	header_container.add_child(action_buttons)

	# Bookmark button
	bookmark_button = _create_icon_button("bookmark", "🔖")
	bookmark_button.pressed.connect(_on_bookmark_pressed)
	action_buttons.add_child(bookmark_button)

	# Share button
	share_button = _create_icon_button("share", "📤")
	share_button.pressed.connect(_on_share_pressed)
	action_buttons.add_child(share_button)

	# Close button
	close_button = _create_icon_button("close", "✕")
	close_button.pressed.connect(_on_close_pressed)
	action_buttons.add_child(close_button)

func _create_icon_button(button_name: String, button_icon: String) -> Button:
	"""Create a styled icon button"""
func _create_description_section() -> void:
	"""Create description section"""
	description_section = _create_section("Description", false)

func _create_functions_section() -> void:
	"""Create collapsible functions section"""
	functions_section = _create_section("Functions", true, true)
	expanded_sections["functions"] = true

func _create_connections_section() -> void:
	"""Create collapsible connections section"""
	connections_section = _create_section("Connections", true, false)
	expanded_sections["connections"] = false

func _create_clinical_section() -> void:
	"""Create premium clinical notes section"""
	clinical_section = _create_section("Clinical Notes", true, false, true)
	expanded_sections["clinical"] = false

func _create_section(
	title: String, collapsible: bool = false, expanded: bool = true, premium: bool = false
	) -> VBoxContainer:
		"""Create a content section with optional collapse functionality"""
func _create_list_item(text: String) -> Control:
	"""Create a styled list item"""
func _apply_figma_design() -> void:
	"""Apply Figma design tokens to the panel"""
	# Enhanced glass morphism
func _setup_animations() -> void:
	"""Setup entrance and interaction animations"""
	# Entrance animation
	modulate = Color.TRANSPARENT
	scale = Vector2(0.95, 0.95)

func _animate_button_hover(button: Button, hovering: bool) -> void:
	"""Animate button hover state"""
func _animate_list_item_hover(item: Control, hovering: bool) -> void:
	"""Animate list item hover"""
func _toggle_section(section: Control, section_id: String) -> void:
	"""Toggle section expanded state with animation"""
func _update_all_content(_data: Dictionary) -> void:
	"""Update all section content"""
	# Update each section with new data

	# Signal handlers
func _on_bookmark_pressed() -> void:
	"""Handle bookmark toggle"""
	is_bookmarked = not is_bookmarked
	bookmark_button.text = "🔖" if is_bookmarked else "🔖"
	bookmark_button.modulate = Color("#FFD700") if is_bookmarked else Color.WHITE

	# Animate bookmark
func _on_share_pressed() -> void:
	"""Handle share action"""
	# Animate share button
func _on_close_pressed() -> void:
	"""Handle close with exit animation"""
func _on_viewport_resized() -> void:
	"""Handle viewport resize for responsive behavior"""
	viewport_size = get_viewport().get_visible_rect().size

func _setup_responsive_layout() -> void:
	"""Setup responsive positioning based on viewport"""
	viewport_size = get_viewport().get_visible_rect().size
	current_breakpoint = _get_current_breakpoint()
	_update_panel_layout()

func _get_responsive_config() -> Dictionary:
	"""Get layout configuration for current breakpoint"""
	match current_breakpoint:
		"mobile":
			return {
			"width_percent": 0.9,
			"min_width": 280,
			"max_width": 400,
			"position": "bottom",
			"offset": 16
			}
			"tablet":
				return {
				"width_percent": 0.4,
				"min_width": 320,
				"max_width": 400,
				"position": "right",
				"offset": 16
				}
				_: # desktop
				return {
				"width_percent": 0.25,
				"min_width": 320,
				"max_width": 480,
				"position": "right",
				"offset": 24
				}
