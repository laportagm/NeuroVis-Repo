# ContentComponent - Modular content display with collapsible sections
# Reusable content fragment for displaying structured information

class_name ContentComponent
extends VBoxContainer

# === DEPENDENCIES ===

signal section_toggled(section_name: String, expanded: bool)
signal content_changed(change_data: Dictionary)
signal link_activated(link_data: Dictionary)

# === CONTENT SECTIONS ===

const FeatureFlags = prepreload("res://core/features/FeatureFlags.gd")
const ComponentRegistry = prepreload("res://ui/core/ComponentRegistry.gd")
const UIThemeManager = prepreload("res://ui/panels/UIThemeManager.gd")

# === SIGNALS ===

var sections: Dictionary = {}
var section_configs: Dictionary = {}
var section_states: Dictionary = {}

# === CONFIGURATION ===
var content_config: Dictionary = {}
var current_theme: String = "enhanced"
var is_mobile: bool = false

# === CURRENT DATA ===
var structure_data: Dictionary = {}


		var section = sections[section_name]
		if section.has_method("update_responsive_config"):
			section.update_responsive_config(config)


		var section = sections[section_name]
		if section.has_method("apply_theme"):
			section.apply_theme(theme)


# === PRIVATE METHODS ===
	var section = ComponentRegistry.create_component(
		"section",
		{
			"name": section_name,
			"expanded": section_states.get(section_name, true),
			"collapsible": content_config.get("collapsible_sections", []).has(section_name)
		}
	)

	if section:
		add_child(section)
		sections[section_name] = section

		# Connect section signals
		if section.has_signal("section_toggled"):
			section.section_toggled.connect(_on_section_toggled)
		if section.has_signal("content_changed"):
			section.content_changed.connect(_on_section_content_changed)


		var section = sections[section_name]
		if section.has_method("set_collapsible"):
			section.set_collapsible(true)


		var section = sections[section_name]
		if section.has_method("set_expanded"):
			section.set_expanded(expanded)


# === SECTION UPDATE METHODS ===
	var section = sections.description
	var description = data.get(
		"shortDescription", data.get("description", "No description available.")
	)

	if section.has_method("set_content"):
		section.set_content(_format_description(description))


	var section = sections.functions
	var functions = data.get("functions", [])

	if section.has_method("set_content"):
		section.set_content(_format_functions_list(functions))


	var section = sections.connections
	var connections = data.get("connections", [])

	if section.has_method("set_content"):
		section.set_content(_format_connections_list(connections))


	var section = sections.clinical
	var clinical_notes = data.get("clinicalNotes", data.get("clinicalRelevance", ""))

	if section.has_method("set_content"):
		section.set_content(_format_clinical_notes(clinical_notes))


# === CONTENT FORMATTING ===
	var formatted = description

	# Make first sentence bold if it's a definition
	if formatted.contains("."):
		var first_sentence = formatted.split(".")[0] + "."
		formatted = "[b]" + first_sentence + "[/b]" + formatted.substr(first_sentence.length())

	return formatted


	var formatted = ""
	for i in range(functions.size()):
		var function_text = str(functions[i])
		formatted += "• " + function_text
		if i < functions.size() - 1:
			formatted += "\n"

	return formatted


	var formatted = ""
	for i in range(connections.size()):
		var connection = str(connections[i])
		# Make connections clickable links
		formatted += "→ [url=" + connection + "]" + connection + "[/url]"
		if i < connections.size() - 1:
			formatted += "\n"

	return formatted


	var formatted = clinical_text
	var clinical_keywords = [
		"pathology", "disease", "disorder", "syndrome", "damage", "lesion", "dysfunction"
	]

	for keyword in clinical_keywords:
		var regex = RegEx.new()
		regex.compile("(?i)\\b" + keyword + "\\b")
		formatted = regex.sub(formatted, "[i]" + keyword + "[/i]", true)

	return formatted


# === EVENT HANDLERS ===
	var link_data = {
		"type": "structure_link",
		"target": link_text,
		"source_structure": structure_data.get("id", "")
	}

	link_activated.emit(link_data)
	content_changed.emit({"action": "link_activated", "link": link_text})


# === SEARCH AND HIGHLIGHTING ===
	var total_matches = 0

	for section_name in sections:
		var section = sections[section_name]
		if section.has_method("highlight_text"):
			var matches = section.highlight_text(search_term)
			total_matches += matches

	return total_matches


		var section = sections[section_name]
		if section.has_method("clear_highlights"):
			section.clear_highlights()


# === FACTORY METHOD ===
static func create_with_config(config: Dictionary) -> ContentComponent:
	"""Factory method to create configured content"""
	var content = ContentComponent.new()
	content.configure_content(config)
	return content

func _ready() -> void:
	_setup_content_structure()
	_apply_content_styling()


func configure_content(config: Dictionary) -> void:
	"""Configure content with settings"""
	content_config = config.duplicate()

	# Setup sections
	if config.has("sections"):
		_setup_sections(config.sections)

	# Set section states
	if config.has("section_states"):
		section_states = config.section_states.duplicate()
	else:
		# Default states
		section_states = {
			"description": true, "functions": true, "connections": false, "clinical": false
		}

	# Configure collapsible sections
	if config.has("collapsible_sections"):
		for section_name in config.collapsible_sections:
			if sections.has(section_name):
				_make_section_collapsible(section_name)


func display_structure_data(data: Dictionary) -> void:
	"""Display brain structure information"""
	structure_data = data.duplicate()

	# Update each section with relevant data
	_update_description_section(data)
	_update_functions_section(data)
	_update_connections_section(data)
	_update_clinical_section(data)

	content_changed.emit({"action": "structure_loaded", "structure": data.get("displayName", "")})


func restore_section_states(states: Dictionary) -> void:
	"""Restore section expanded/collapsed states"""
	section_states = states.duplicate()

	for section_name in section_states:
		if sections.has(section_name):
			_set_section_expanded(section_name, section_states[section_name])


func update_responsive_config(config: Dictionary) -> void:
	"""Update content for responsive layout"""
	is_mobile = config.get("is_mobile", false)

	# Update sections for mobile
	for section_name in sections:
func apply_theme(theme: String) -> void:
	"""Apply theme to content"""
	current_theme = theme

	# Update all sections with new theme
	for section_name in sections:
func highlight_text(search_term: String) -> int:
	"""Highlight search term in content and return number of matches"""
func clear_highlights() -> void:
	"""Clear all text highlights"""
	for section_name in sections:

func _setup_content_structure() -> void:
	"""Setup the content layout"""

	# Configure container
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_theme_constant_override("separation", UIThemeManager.get_spacing("enhanced_section_gap"))


func _apply_content_styling() -> void:
	"""Apply styling to content elements"""

	# Add content padding
	add_theme_constant_override("margin_left", UIThemeManager.get_spacing("md"))
	add_theme_constant_override("margin_right", UIThemeManager.get_spacing("md"))
	add_theme_constant_override("margin_top", UIThemeManager.get_spacing("sm"))
	add_theme_constant_override("margin_bottom", UIThemeManager.get_spacing("sm"))


# === PUBLIC API ===
func _setup_sections(section_list: Array) -> void:
	"""Setup content sections"""

	# Clear existing sections
	for child in get_children():
		child.queue_free()
	sections.clear()

	# Create new sections
	for section_name in section_list:
		_create_section(section_name)


func _create_section(section_name: String) -> void:
	"""Create a content section"""

func _make_section_collapsible(section_name: String) -> void:
	"""Make a section collapsible"""
	if sections.has(section_name):
func _set_section_expanded(section_name: String, expanded: bool) -> void:
	"""Set section expanded state"""
	if sections.has(section_name):
func _update_description_section(data: Dictionary) -> void:
	"""Update description section with structure data"""
	if not sections.has("description"):
		return

func _update_functions_section(data: Dictionary) -> void:
	"""Update functions section with structure data"""
	if not sections.has("functions"):
		return

func _update_connections_section(data: Dictionary) -> void:
	"""Update connections section with structure data"""
	if not sections.has("connections"):
		return

func _update_clinical_section(data: Dictionary) -> void:
	"""Update clinical section with structure data"""
	if not sections.has("clinical"):
		return

func _format_description(description: String) -> String:
	"""Format description text"""
	if description.is_empty():
		return "No description available for this structure."

	# Add basic formatting for rich text
func _format_functions_list(functions: Array) -> String:
	"""Format functions as bulleted list"""
	if functions.is_empty():
		return "No specific functions listed for this structure."

func _format_connections_list(connections: Array) -> String:
	"""Format connections as linked list"""
	if connections.is_empty():
		return "No connections listed for this structure."

func _format_clinical_notes(clinical_text: String) -> String:
	"""Format clinical notes"""
	if clinical_text.is_empty():
		return "No clinical information available for this structure."

	# Add emphasis to key clinical terms
func _on_section_toggled(section_name: String, expanded: bool) -> void:
	"""Handle section toggle"""
	section_states[section_name] = expanded
	section_toggled.emit(section_name, expanded)
	content_changed.emit(
		{"action": "section_toggled", "section": section_name, "expanded": expanded}
	)


func _on_section_content_changed(section_name: String, change_data: Dictionary) -> void:
	"""Handle section content changes"""
	content_changed.emit(
		{"action": "section_content_changed", "section": section_name, "change_data": change_data}
	)


func _on_link_activated(link_text: String) -> void:
	"""Handle link activation in content"""
	# Parse link and emit appropriate signal
