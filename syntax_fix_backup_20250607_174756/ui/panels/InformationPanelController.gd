# Streamlined Information Panel Controller
# Simple, direct implementation for structure information display

class_name InformationPanelController
extends Control

# Core components

signal panel_closed


var title_label: Label
var description_label: RichTextLabel
var functions_container: VBoxContainer
var close_button: Button

# State
var current_structure: Dictionary = {}
var panel_visible: bool = false

# Styling
var primary_color: Color = Color(0.2, 0.7, 1.0, 1.0)
var text_color: Color = Color(0.9, 0.9, 0.9, 1.0)
var function_color: Color = Color(0.7, 1.0, 0.7, 1.0)

# Signals
var main_container = VBoxContainer.new()
main_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
add_child(main_container)

# Header with title and close button
var header = HBoxContainer.new()
main_container.add_child(header)

title_label = Label.new()
title_label.text = "Structure Information"
title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
header.add_child(title_label)

close_button = Button.new()
close_button.text = "×"
close_button.custom_minimum_size = Vector2(30, 30)
close_button.flat = true
close_button.pressed.connect(_on_close_pressed)
header.add_child(close_button)

# Content area
var scroll = ScrollContainer.new()
scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
main_container.add_child(scroll)

var content = VBoxContainer.new()
scroll.add_child(content)

# Description
var desc_header = Label.new()
desc_header.text = "Description"
content.add_child(desc_header)

description_label = RichTextLabel.new()
description_label.custom_minimum_size = Vector2(0, 100)
description_label.fit_content = true
description_label.bbcode_enabled = true
content.add_child(description_label)

# Functions
var func_header = Label.new()
func_header.text = "Functions"
content.add_child(func_header)

functions_container = VBoxContainer.new()
content.add_child(functions_container)


var style = StyleBoxFlat.new()
style.bg_color = Color(0.1, 0.1, 0.15, 0.9)
style.border_color = Color(0.3, 0.3, 0.4, 0.7)
style.border_width_top = 2
style.border_width_bottom = 2
style.border_width_left = 2
style.border_width_right = 2
style.corner_radius_top_left = 10
style.corner_radius_top_right = 10
style.corner_radius_bottom_left = 10
style.corner_radius_bottom_right = 10
add_theme_stylebox_override("panel", style)

# Title styling
var display_name = structure_data.get("displayName", "Unknown Structure")
title_label.text = display_name

# Update description
var description = structure_data.get("shortDescription", "No description available.")
description_label.text = "[color=#E0E0E0]%s[/color]" % description

# Update functions
_update_functions(structure_data.get("functions", []))

# Show panel
show_panel()


var tween = create_tween()
tween.tween_property(self, "modulate:a", 1.0, 0.3)


var tween = create_tween()
tween.tween_property(self, "modulate:a", 0.0, 0.2)
tween.tween_callback(
func():
	visible = false
	modulate.a = 1.0
	panel_closed.emit()
	)


var placeholder = Label.new()
	placeholder.text = "No functions information available"
	placeholder.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6, 1.0))
	functions_container.add_child(placeholder)

	# Add function items
var function_text = str(functions_array[i])
var item = _create_function_item(function_text, i)
	functions_container.add_child(item)


var container = HBoxContainer.new()

# Bullet
var bullet = Label.new()
	bullet.text = "•"
var color = Color.from_hsv(float(index) * 0.2, 0.7, 1.0)
	bullet.add_theme_color_override("font_color", color)
	bullet.custom_minimum_size.x = 15

	# Function text
var label = Label.new()
	label.text = text
	label.add_theme_color_override("font_color", function_color)
	label.add_theme_font_size_override("font_size", 12)
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	container.add_child(bullet)
	container.add_child(label)

func _ready() -> void:
	_create_ui()
	_setup_styling()
	visible = false


func display_structure_data(structure_data: Dictionary) -> void:
	"""Display structure information"""
	if structure_data.is_empty():
		hide_panel()
		return

		current_structure = structure_data

		# Update title
func show_panel() -> void:
	"""Show the panel with animation"""
	if panel_visible:
		return

		panel_visible = true
		visible = true

		# Simple fade-in animation
		modulate.a = 0.0
func hide_panel() -> void:
	"""Hide the panel with animation"""
	if not panel_visible:
		return

		panel_visible = false

		# Simple fade-out animation
func dispose() -> void:
	"""Clean up resources"""
	current_structure.clear()
	hide_panel()

func _fix_orphaned_code():
	if title_label:
		title_label.add_theme_color_override("font_color", primary_color)
		title_label.add_theme_font_size_override("font_size", 16)

		# Close button styling
		if close_button:
			close_button.add_theme_color_override("font_color", Color(1.0, 0.4, 0.4, 1.0))
			close_button.add_theme_font_size_override("font_size", 18)


			# Public interface
func _fix_orphaned_code():
	for i in range(functions_array.size()):
func _fix_orphaned_code():
	return container


func _create_ui() -> void:
	"""Create streamlined UI structure"""
	# Main panel setup
	custom_minimum_size = Vector2(350, 200)
	size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	size_flags_vertical = Control.SIZE_SHRINK_CENTER

	# Main container
func _setup_styling() -> void:
	"""Apply modern styling"""
	# Panel background
func _update_functions(functions_array: Array) -> void:
	"""Update the functions list"""
	# Clear existing functions
	for child in functions_container.get_children():
		child.queue_free()

		if functions_array.is_empty():
func _create_function_item(text: String, index: int) -> Control:
	"""Create a function list item"""
func _on_close_pressed() -> void:
	"""Handle close button press"""
	hide_panel()


