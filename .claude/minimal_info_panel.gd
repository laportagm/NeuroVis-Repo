# Minimal Structure Information Panel - Apple/OpenAI Inspired Design
# Focus on clarity, simplicity, and purposeful interactions
class_name MinimalInfoPanel
extends PanelContainer

# Design philosophy: Every element serves a purpose
# No unnecessary visual noise, focus on content and usability

# UI References
@onready var header_container: HBoxContainer
@onready var structure_name: Label
@onready var structure_category: Label
@onready var bookmark_button: Button
@onready var close_button: Button
@onready var sections_container: VBoxContainer

# Section containers
@onready var overview_section: VBoxContainer
@onready var functions_section: VBoxContainer
@onready var related_section: VBoxContainer

# State
var current_structure_id: String = ""
var is_bookmarked: bool = false
var expanded_sections: Dictionary = {
	"functions": true,
	"related": false
}

# Minimal color palette
const COLORS = {
	"background": Color(1, 1, 1, 0.04),
	"border": Color(1, 1, 1, 0.08),
	"text_primary": Color(1, 1, 1, 1),
	"text_secondary": Color(1, 1, 1, 0.85),
	"text_tertiary": Color(1, 1, 1, 0.6),
	"text_muted": Color(1, 1, 1, 0.3),
	"interactive": Color(1, 1, 1, 0.4),
	"hover": Color(1, 1, 1, 0.06)
}

# Typography scale
const FONT_SIZES = {
	"display": 28,
	"body": 15,
	"small": 14,
	"caption": 13,
	"micro": 12
}

# Spacing system
const SPACING = {
	"xs": 4,
	"sm": 8,
	"md": 16,
	"lg": 24,
	"xl": 32
}

# Animation settings
const ANIM = {
	"fast": 0.2,
	"normal": 0.3,
	"slow": 0.5,
	"curve": Tween.TRANS_CUBIC
}

# Signals
signal panel_closed
signal structure_bookmarked(structure_id: String)
signal structure_selected(structure_id: String)

func _ready() -> void:
	_setup_minimal_design()
	_create_ui_structure()
	_connect_signals()
	_animate_entrance()

func _setup_minimal_design() -> void:
	"""Apply minimal design system"""
	# Panel styling
	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = COLORS.background
	panel_style.border_color = COLORS.border
	panel_style.set_border_width_all(1)
	panel_style.set_corner_radius_all(12)
	
	add_theme_stylebox_override("panel", panel_style)
	
	# Set size
	custom_minimum_size = Vector2(380, 0)
	size_flags_vertical = Control.SIZE_SHRINK_CENTER

func _create_ui_structure() -> void:
	"""Create minimal UI layout"""
	# Main container
	var main_container = MarginContainer.new()
	main_container.add_theme_constant_override("margin_top", SPACING.xl)
	main_container.add_theme_constant_override("margin_bottom", SPACING.xl)
	main_container.add_theme_constant_override("margin_left", SPACING.xl)
	main_container.add_theme_constant_override("margin_right", SPACING.xl)
	add_child(main_container)
	
	# Sections container
	sections_container = VBoxContainer.new()
	sections_container.add_theme_constant_override("separation", SPACING.xl)
	main_container.add_child(sections_container)
	
	# Create sections
	_create_header()
	_create_overview_section()
	_create_functions_section()
	_create_related_section()

func _create_header() -> void:
	"""Create minimal header"""
	header_container = HBoxContainer.new()
	sections_container.add_child(header_container)
	
	# Structure info container
	var info_container = VBoxContainer.new()
	info_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header_container.add_child(info_container)
	
	# Structure name
	structure_name = Label.new()
	structure_name.text = "Hippocampus"
	structure_name.add_theme_font_size_override("font_size", FONT_SIZES.display)
	structure_name.add_theme_color_override("font_color", COLORS.text_primary)
	info_container.add_child(structure_name)
	
	# Structure category
	structure_category = Label.new()
	structure_category.text = "Temporal Lobe Structure"
	structure_category.add_theme_font_size_override("font_size", FONT_SIZES.small)
	structure_category.add_theme_color_override("font_color", COLORS.text_muted)
	info_container.add_child(structure_category)
	
	# Action buttons
	var actions = HBoxContainer.new()
	actions.add_theme_constant_override("separation", SPACING.xs)
	header_container.add_child(actions)
	
	# Bookmark button
	bookmark_button = _create_icon_button("bookmark", 20)
	bookmark_button.pressed.connect(_on_bookmark_pressed)
	actions.add_child(bookmark_button)
	
	# Close button
	close_button = _create_icon_button("close", 16)
	close_button.custom_minimum_size = Vector2(28, 28)
	close_button.pressed.connect(_on_close_pressed)
	actions.add_child(close_button)

func _create_icon_button(icon_name: String, size: int) -> Button:
	"""Create minimal icon button"""
	var button = Button.new()
	button.flat = true
	button.custom_minimum_size = Vector2(36, 36)
	
	# Style
	var normal_style = StyleBoxFlat.new()
	normal_style.bg_color = Color.TRANSPARENT
	normal_style.set_corner_radius_all(8)
	
	var hover_style = normal_style.duplicate()
	hover_style.bg_color = COLORS.hover
	
	button.add_theme_stylebox_override("normal", normal_style)
	button.add_theme_stylebox_override("hover", hover_style)
	button.add_theme_stylebox_override("pressed", hover_style)
	button.add_theme_color_override("font_color", COLORS.interactive)
	button.add_theme_color_override("font_hover_color", Color(1, 1, 1, 0.8))
	
	# Simple text icons for demo
	if icon_name == "bookmark":
		button.text = "☆"
	elif icon_name == "close":
		button.text = "×"
	
	button.add_theme_font_size_override("font_size", size)
	
	return button

func _create_overview_section() -> void:
	"""Create overview section"""
	overview_section = _create_section("Overview", false)
	
	var description = Label.new()
	description.text = "A critical structure for memory formation and spatial navigation. The hippocampus converts short-term memories into long-term storage and plays an essential role in learning and emotional regulation."
	description.add_theme_font_size_override("font_size", FONT_SIZES.body)
	description.add_theme_color_override("font_color", COLORS.text_secondary)
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	overview_section.add_child(description)

func _create_functions_section() -> void:
	"""Create collapsible functions section"""
	functions_section = _create_section("Key Functions", true, true, 5)
	
	var content = VBoxContainer.new()
	content.name = "FunctionsContent"
	content.add_theme_constant_override("separation", SPACING.xs)
	functions_section.add_child(content)
	
	var functions = [
		"Memory consolidation",
		"Spatial navigation",
		"Pattern separation",
		"Emotional regulation",
		"Stress response"
	]
	
	for function_text in functions:
		var item = _create_list_item(function_text)
		content.add_child(item)

func _create_related_section() -> void:
	"""Create collapsible related structures section"""
	related_section = _create_section("Related Structures", true, false)
	
	var content = VBoxContainer.new()
	content.name = "RelatedContent"
	content.visible = false
	related_section.add_child(content)
	
	# Tag container
	var tag_container = HFlowContainer.new()
	tag_container.add_theme_constant_override("h_separation", SPACING.sm)
	tag_container.add_theme_constant_override("v_separation", SPACING.sm)
	content.add_child(tag_container)
	
	var structures = ["Amygdala", "Entorhinal Cortex", "Fornix", "Mammillary Bodies", "Parahippocampal Gyrus"]
	for structure in structures:
		var tag = _create_tag(structure)
		tag_container.add_child(tag)
	
	# Learn more link
	var learn_more = Button.new()
	learn_more.text = "Explore connections →"
	learn_more.flat = true
	learn_more.add_theme_font_size_override("font_size", FONT_SIZES.caption)
	learn_more.add_theme_color_override("font_color", COLORS.text_muted)
	learn_more.add_theme_color_override("font_hover_color", Color(1, 1, 1, 0.8))
	content.add_child(learn_more)

func _create_section(title: String, collapsible: bool = false, expanded: bool = true, count: int = 0) -> VBoxContainer:
	"""Create a minimal content section"""
	var section = VBoxContainer.new()
	section.add_theme_constant_override("separation", SPACING.md)
	
	# Add separator except for first section
	if sections_container.get_child_count() > 0:
		var separator = HSeparator.new()
		separator.add_theme_color_override("color", COLORS.border)
		sections_container.add_child(separator)
	
	sections_container.add_child(section)
	
	# Header
	var header = HBoxContainer.new()
	section.add_child(header)
	
	# Title with optional collapse indicator
	var title_container = HBoxContainer.new()
	title_container.add_theme_constant_override("separation", SPACING.sm)
	header.add_child(title_container)
	
	if collapsible:
		var indicator = Label.new()
		indicator.name = title.replace(" ", "") + "Indicator"
		indicator.text = "▼" if expanded else "▶"
		indicator.add_theme_font_size_override("font_size", 10)
		indicator.add_theme_color_override("font_color", COLORS.text_muted)
		title_container.add_child(indicator)
		
		# Make header clickable
		header.gui_input.connect(func(event):
			if event is InputEventMouseButton and event.pressed:
				_toggle_section(title.replace(" ", "").to_lower())
		)
		header.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
	var label = Label.new()
	label.text = title.to_upper()
	label.add_theme_font_size_override("font_size", FONT_SIZES.caption)
	label.add_theme_color_override("font_color", COLORS.text_tertiary)
	title_container.add_child(label)
	
	# Spacer
	var spacer = Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(spacer)
	
	# Count
	if count > 0:
		var count_label = Label.new()
		count_label.text = str(count)
		count_label.add_theme_font_size_override("font_size", FONT_SIZES.micro)
		count_label.add_theme_color_override("font_color", COLORS.text_muted)
		header.add_child(count_label)
	
	return section

func _create_list_item(text: String) -> Control:
	"""Create minimal list item"""
	var item = Label.new()
	item.text = "    " + text  # Simple indent instead of bullet
	item.add_theme_font_size_override("font_size", FONT_SIZES.small)
	item.add_theme_color_override("font_color", Color(1, 1, 1, 0.8))
	
	# Add subtle hover effect
	item.mouse_entered.connect(func():
		var tween = create_tween()
		tween.tween_property(item, "modulate", Color(1.1, 1.1, 1.1), ANIM.fast)
	)
	
	item.mouse_exited.connect(func():
		var tween = create_tween()
		tween.tween_property(item, "modulate", Color.WHITE, ANIM.fast)
	)
	
	return item

func _create_tag(text: String) -> Button:
	"""Create minimal tag button"""
	var tag = Button.new()
	tag.text = text
	tag.flat = true
	
	# Minimal styling
	var style = StyleBoxFlat.new()
	style.bg_color = COLORS.hover
	style.border_color = COLORS.border
	style.set_border_width_all(1)
	style.set_corner_radius_all(16)
	style.set_content_margin_all(6)
	
	var hover_style = style.duplicate()
	hover_style.bg_color = COLORS.border
	hover_style.border_color = Color(1, 1, 1, 0.12)
	
	tag.add_theme_stylebox_override("normal", style)
	tag.add_theme_stylebox_override("hover", hover_style)
	tag.add_theme_font_size_override("font_size", FONT_SIZES.micro)
	tag.add_theme_color_override("font_color", Color(1, 1, 1, 0.7))
	tag.add_theme_color_override("font_hover_color", Color(1, 1, 1, 0.9))
	
	tag.pressed.connect(func(): emit_signal("structure_selected", text))
	
	return tag

func _connect_signals() -> void:
	"""Connect UI signals"""
	# Signals are connected during creation

func _animate_entrance() -> void:
	"""Subtle fade-in animation"""
	modulate.a = 0
	position.y += 20
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 1.0, ANIM.slow).set_trans(ANIM.curve)
	tween.tween_property(self, "position:y", position.y - 20, ANIM.slow).set_trans(ANIM.curve)

func _toggle_section(section_id: String) -> void:
	"""Toggle section with smooth animation"""
	expanded_sections[section_id] = not expanded_sections.get(section_id, false)
	
	# Find the section
	var section_node: VBoxContainer
	match section_id:
		"keyfunctions", "functions":
			section_node = functions_section
		"relatedstructures", "related":
			section_node = related_section
	
	if not section_node:
		return
	
	# Update indicator
	var indicator = section_node.find_child("*Indicator", true, false)
	if indicator:
		var tween = create_tween()
		if expanded_sections[section_id]:
			tween.tween_property(indicator, "rotation", 0, ANIM.normal)
			indicator.text = "▼"
		else:
			tween.tween_property(indicator, "rotation", deg_to_rad(-90), ANIM.normal)
			indicator.text = "▶"
	
	# Toggle content visibility
	var content = section_node.get_child(section_node.get_child_count() - 1)
	if content:
		content.visible = expanded_sections[section_id]

# Public API
func display_structure_data(data: Dictionary) -> void:
	"""Display structure with minimal animation"""
	current_structure_id = data.get("id", "")
	
	# Fade content out
	var tween = create_tween()
	tween.tween_property(sections_container, "modulate:a", 0, ANIM.fast)
	tween.tween_callback(_update_content.bind(data))
	tween.tween_property(sections_container, "modulate:a", 1, ANIM.fast)

func _update_content(data: Dictionary) -> void:
	"""Update panel content"""
	if structure_name:
		structure_name.text = data.get("displayName", "Unknown")
	
	if structure_category:
		var category = data.get("category", "Neural Structure")
		structure_category.text = category

# Signal handlers
func _on_bookmark_pressed() -> void:
	"""Handle bookmark with minimal feedback"""
	is_bookmarked = not is_bookmarked
	
	if is_bookmarked:
		bookmark_button.text = "★"
		bookmark_button.add_theme_color_override("font_color", COLORS.text_primary)
	else:
		bookmark_button.text = "☆"
		bookmark_button.add_theme_color_override("font_color", COLORS.interactive)
	
	emit_signal("structure_bookmarked", current_structure_id)

func _on_close_pressed() -> void:
	"""Close with subtle animation"""
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 0, ANIM.normal)
	tween.tween_property(self, "position:y", position.y + 20, ANIM.normal)
	tween.tween_callback(emit_signal.bind("panel_closed"))

# Responsive handling
func _on_viewport_resized() -> void:
	"""Adjust for different screen sizes"""
	var viewport_width = get_viewport().size.x
	
	if viewport_width < 768:  # Mobile
		custom_minimum_size.x = viewport_width * 0.9
		# Adjust padding for mobile
		var container = get_child(0) as MarginContainer
		if container:
			container.add_theme_constant_override("margin_left", SPACING.lg)
			container.add_theme_constant_override("margin_right", SPACING.lg)
	else:  # Desktop/Tablet
		custom_minimum_size.x = 380
		# Reset to default padding
		var container = get_child(0) as MarginContainer
		if container:
			container.add_theme_constant_override("margin_left", SPACING.xl)
			container.add_theme_constant_override("margin_right", SPACING.xl)
