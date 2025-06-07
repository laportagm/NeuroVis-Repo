# SectionComponent - Individual content section with collapsible functionality
# Reusable section for displaying structured content with expand/collapse

class_name SectionComponent
extends VBoxContainer

# === DEPENDENCIES ===

signal section_toggled(section_name: String, expanded: bool)
signal content_changed(section_name: String, change_data: Dictionary)
signal link_activated(link_data: Dictionary)

# === UI ELEMENTS ===

const FeatureFlags = preload("res://core/features/FeatureFlags.gd")
const UIThemeManager = preload("res://ui/panels/UIThemeManager.gd")

# === SIGNALS ===

var header_button: Button
var content_container: Control
var content_label: RichTextLabel

# === CONFIGURATION ===
var section_name: String = ""
var section_title: String = ""
var is_collapsible: bool = false
var is_expanded: bool = true
var current_theme: String = "enhanced"
var is_mobile: bool = false

# === CONTENT ===
var section_content: String = ""
var content_type: String = "text"  # text, list, rich


	var content_style = StyleBoxFlat.new()
	content_style.bg_color = UIThemeManager.get_color("surface_bg")
	content_style.corner_radius_top_left = 4
	content_style.corner_radius_top_right = 4
	content_style.corner_radius_bottom_left = 4
	content_style.corner_radius_bottom_right = 4
	content_style.content_margin_left = UIThemeManager.get_spacing("md")
	content_style.content_margin_right = UIThemeManager.get_spacing("md")
	content_style.content_margin_top = UIThemeManager.get_spacing("sm")
	content_style.content_margin_bottom = UIThemeManager.get_spacing("sm")

	if content_container is PanelContainer:
		content_container.add_theme_stylebox_override("panel", content_style)


# === PUBLIC API ===
	var highlighted_content = section_content
	var matches = 0

	# Simple highlighting with BBCode
	var regex = RegEx.new()
	regex.compile("(?i)\\b" + search_term + "\\b")
	var results = regex.search_all(highlighted_content)

	if results.size() > 0:
		# Highlight matches
		for result in results:
			var match_text = result.get_string()
			highlighted_content = highlighted_content.replace(
				match_text, "[bgcolor=yellow]" + match_text + "[/bgcolor]"
			)

		matches = results.size()
		content_label.text = highlighted_content

	return matches


	var title_text = section_title.to_upper()

	if is_collapsible:
		var arrow = "▼" if is_expanded else "▶"
		header_button.text = arrow + " " + title_text
		header_button.disabled = false
	else:
		header_button.text = title_text
		header_button.disabled = true


	var lines = content.split("\n")
	var formatted = ""

	for line in lines:
		line = line.strip_edges()
		if line.is_empty():
			continue

		if not line.begins_with("•"):
			formatted += "• " + line + "\n"
		else:
			formatted += line + "\n"

	return formatted.rstrip("\n")


	var tween = create_tween()
	tween.tween_property(content_container, "modulate", Color.WHITE, 0.2)


	var tween = create_tween()
	tween.tween_property(content_container, "modulate", Color.TRANSPARENT, 0.15)
	tween.tween_callback(func(): content_container.visible = false)


# === EVENT HANDLERS ===
	var link_data = {"type": "content_link", "url": str(meta), "section": section_name}

	link_activated.emit(link_data)

	content_changed.emit(section_name, {"action": "link_clicked", "link": str(meta)})


# === CONTENT TEMPLATES ===
	var description = data.get("shortDescription", data.get("description", ""))
	content_type = "rich"

	if description.is_empty():
		set_content("No description available for this structure.")
	else:
		# Format with emphasis on first sentence
		var formatted = description
		if formatted.contains("."):
			var first_sentence = formatted.split(".")[0] + "."
			formatted = "[b]" + first_sentence + "[/b]" + formatted.substr(first_sentence.length())
		set_content(formatted)


	var functions = data.get("functions", [])
	content_type = "list"

	if functions.is_empty():
		set_content("No specific functions listed for this structure.")
	else:
		var content = ""
		for function in functions:
			content += str(function) + "\n"
		set_content(content.rstrip("\n"))


	var connections = data.get("connections", [])
	content_type = "rich"

	if connections.is_empty():
		set_content("No connections listed for this structure.")
	else:
		var content = ""
		for connection in connections:
			content += "→ [url=" + str(connection) + "]" + str(connection) + "[/url]\n"
		set_content(content.rstrip("\n"))


	var clinical = data.get("clinicalNotes", data.get("clinicalRelevance", ""))
	content_type = "rich"

	if clinical.is_empty():
		set_content("No clinical information available for this structure.")
	else:
		# Emphasize clinical keywords
		var formatted = clinical
		var keywords = ["pathology", "disease", "disorder", "syndrome", "damage", "lesion"]
		for keyword in keywords:
			var regex = RegEx.new()
			regex.compile("(?i)\\b" + keyword + "\\b")
			formatted = regex.sub(formatted, "[i]" + keyword + "[/i]", true)
		set_content(formatted)


# === FACTORY METHOD ===
static func create_with_config(config: Dictionary) -> SectionComponent:
	"""Factory method to create configured section"""
	var section = SectionComponent.new()
	section.configure_section(config)
	return section

func _ready() -> void:
	_setup_section_structure()
	_apply_section_styling()


func configure_section(config: Dictionary) -> void:
	"""Configure section with settings"""

	# Set section properties
	section_name = config.get("name", "section")
	section_title = config.get("title", section_name.capitalize())
	is_collapsible = config.get("collapsible", false)
	is_expanded = config.get("expanded", true)
	content_type = config.get("content_type", "text")

	# Only update UI elements if they exist (after _ready)
	if is_inside_tree() and header_button:
		# Update header
		_update_header()

		# Apply initial state
		_update_expanded_state()

	# Set initial content
	if config.has("content"):
		set_content(config.content)


func set_section_name(name: String) -> void:
	"""Set section name"""
	section_name = name
	section_title = name.capitalize()
	if header_button:
		_update_header()


func set_collapsible(collapsible: bool) -> void:
	"""Set section collapsible state"""
	is_collapsible = collapsible
	if header_button:
		_update_header()


func set_expanded(expanded: bool) -> void:
	"""Set section expanded state"""
	if not is_collapsible:
		is_expanded = true
		return

	is_expanded = expanded
	_update_expanded_state()


func get_expanded() -> bool:
	"""Get current expanded state"""
	return is_expanded


func set_content(content: String) -> void:
	"""Set section content"""
	section_content = content
	_update_content_display()


func get_content() -> String:
	"""Get section content"""
	return section_content


func append_content(additional_content: String) -> void:
	"""Append content to section"""
	section_content += "\n" + additional_content
	_update_content_display()


func clear_content() -> void:
	"""Clear section content"""
	section_content = ""
	_update_content_display()


func update_responsive_config(config: Dictionary) -> void:
	"""Update section for responsive layout"""
	is_mobile = config.get("is_mobile", false)

	if is_mobile:
		# Smaller header and content on mobile
		header_button.custom_minimum_size.y = 28
		UIThemeManager.apply_enhanced_typography(header_button, "small")
		UIThemeManager.apply_enhanced_typography(content_label, "small")
	else:
		# Regular size for desktop
		header_button.custom_minimum_size.y = 32
		UIThemeManager.apply_enhanced_typography(header_button, "subheading")
		UIThemeManager.apply_enhanced_typography(content_label, "body")


func apply_theme(theme: String) -> void:
	"""Apply theme to section"""
	current_theme = theme

	# Update header styling
	UIThemeManager.apply_enhanced_typography(header_button, "subheading")

	# Update content styling
	UIThemeManager.apply_enhanced_typography(content_label, "body")


# === SEARCH AND HIGHLIGHTING ===
func highlight_text(search_term: String) -> int:
	"""Highlight search term in content and return number of matches"""
	if section_content.is_empty():
		return 0

func clear_highlights() -> void:
	"""Clear all text highlights"""
	_update_content_display()


# === PRIVATE METHODS ===
func apply_content_template(template_name: String, data: Dictionary) -> void:
	"""Apply a content template with data"""
	match template_name:
		"description":
			_apply_description_template(data)
		"functions":
			_apply_functions_template(data)
		"connections":
			_apply_connections_template(data)
		"clinical":
			_apply_clinical_template(data)


func _setup_section_structure() -> void:
	"""Setup the section layout"""

	# Configure container
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_theme_constant_override("separation", UIThemeManager.get_spacing("enhanced_item_gap"))

	# Create header button (always present)
	header_button = Button.new()
	header_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	header_button.flat = true
	header_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header_button.custom_minimum_size.y = 32
	UIThemeManager.apply_enhanced_typography(header_button, "subheading")
	add_child(header_button)

	# Create content container
	content_container = VBoxContainer.new()
	content_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(content_container)

	# Create content label
	content_label = RichTextLabel.new()
	content_label.bbcode_enabled = true
	content_label.fit_content = true
	content_label.scroll_active = false
	content_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content_label.custom_minimum_size = Vector2(0, 60)
	UIThemeManager.apply_enhanced_typography(content_label, "body")
	content_container.add_child(content_label)

	# Connect signals
	header_button.pressed.connect(_on_header_pressed)
	content_label.meta_clicked.connect(_on_content_link_clicked)


func _apply_section_styling() -> void:
	"""Apply styling to section elements"""

	# Add subtle spacing
	add_theme_constant_override("margin_bottom", UIThemeManager.get_spacing("sm"))

	# Style content container with subtle background
func _update_header() -> void:
	"""Update section header display"""
	# Safety check for header_button
	if not header_button:
		push_warning("[SectionComponent] header_button is null in _update_header")
		return

func _update_expanded_state() -> void:
	"""Update section expanded/collapsed state"""
	if not content_container:
		push_warning("[SectionComponent] content_container is null in _update_expanded_state")
		return

	content_container.visible = is_expanded
	_update_header()

	# Animate expansion if supported
	if FeatureFlags.is_enabled(FeatureFlags.ADVANCED_ANIMATIONS):
		if is_expanded:
			_animate_expand()
		else:
			_animate_collapse()


func _update_content_display() -> void:
	"""Update content display based on type"""
	if not content_label:
		push_warning("[SectionComponent] content_label is null in _update_content_display")
		return

	match content_type:
		"text":
			content_label.text = section_content
		"list":
			content_label.text = _format_as_list(section_content)
		"rich":
			content_label.text = section_content  # Assume already formatted
		_:
			content_label.text = section_content


func _format_as_list(content: String) -> String:
	"""Format content as bulleted list"""
	if content.is_empty():
		return ""

func _animate_expand() -> void:
	"""Animate section expansion"""
	content_container.modulate = Color.TRANSPARENT
	content_container.visible = true

func _animate_collapse() -> void:
	"""Animate section collapse"""
func _on_header_pressed() -> void:
	"""Handle header button press"""
	if not is_collapsible:
		return

	set_expanded(not is_expanded)
	section_toggled.emit(section_name, is_expanded)

	content_changed.emit(section_name, {"action": "toggled", "expanded": is_expanded})


func _on_content_link_clicked(meta: Variant) -> void:
	"""Handle link clicks in content"""
func _apply_description_template(data: Dictionary) -> void:
	"""Apply description template"""
func _apply_functions_template(data: Dictionary) -> void:
	"""Apply functions template"""
func _apply_connections_template(data: Dictionary) -> void:
	"""Apply connections template"""
func _apply_clinical_template(data: Dictionary) -> void:
	"""Apply clinical template"""
