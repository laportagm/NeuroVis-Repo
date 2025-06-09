## EnhancedInformationPanel.gd
## Primary educational information display panel for brain structure learning
##
## This panel provides the main interface for displaying anatomical information
## about brain structures in an educational context. It follows modern UI design
## principles with glassmorphism effects and responsive layouts while maintaining
## educational accessibility standards for diverse learners.
##
## Educational Learning Objectives:
## - Present anatomical information in a clear, hierarchical manner
## - Support progressive disclosure of complex medical information
## - Enable interactive learning through collapsible sections
## - Maintain accessibility for students with diverse needs
## - Track learning engagement through interaction analytics
##
## @tutorial: Educational UI Patterns
## @tutorial: Accessibility in Medical Education
## @version: 3.0 - Complete restoration with medical education features

class_name EnhancedInformationPanel
extends PanelContainer

# === CONSTANTS ===
const ENHANCED_COLORS = {
	"primary": Color("#00D9FF"),  # Cyan for main accents
	"secondary": Color("#FF006E"),  # Magenta for interactive elements
	"success": Color("#06FFA5"),  # Green for correct answers
	"warning": Color("#FFD93D"),  # Yellow for cautions
	"text_primary": Color.WHITE,
	"text_secondary": Color(0.8, 0.8, 0.8),
	"background": Color(0.1, 0.1, 0.15, 0.95),
	"border": Color(0.3, 0.6, 0.9, 0.8)
}

const ANIMATION_DURATION = 0.3
const PANEL_MIN_SIZE = Vector2(380, 500)
const PANEL_MAX_SIZE = Vector2(500, 800)

# === SIGNALS ===
signal panel_closed
signal section_toggled(section_name: String, expanded: bool)
signal bookmark_toggled(structure_id: String, bookmarked: bool)
signal related_structure_selected(structure_id: String)
signal quiz_answered(question_id: String, correct: bool)
signal learning_time_tracked(structure_id: String, seconds: int)

# === UI ELEMENTS ===
# Main containers
var main_container: VBoxContainer
var scroll_container: ScrollContainer
var content_container: VBoxContainer

# Header elements
var header_container: HBoxContainer
var structure_name_label: Label
var location_label: Label
var action_buttons_container: HBoxContainer
var bookmark_button: Button
var share_button: Button
var close_button: Button

# Quick info section
var quick_info_container: PanelContainer
var quick_info_grid: GridContainer
var size_label: Label
var type_label: Label
var system_label: Label

# Content sections
var anatomy_section: VBoxContainer
var anatomy_header: Button
var anatomy_content: VBoxContainer

var function_section: VBoxContainer
var function_header: Button
var function_content: VBoxContainer

var clinical_section: VBoxContainer
var clinical_header: Button
var clinical_content: VBoxContainer

var connections_section: VBoxContainer
var connections_header: Button
var connections_content: VBoxContainer

var education_section: VBoxContainer
var education_header: Button
var education_content: VBoxContainer

# === STATE MANAGEMENT ===
var current_structure: Dictionary = {}
var panel_is_visible: bool = false
var bookmarked_structures: Array[String] = []
var learning_start_time: int = 0
var section_states: Dictionary = {
	"anatomy": true, "function": true, "clinical": false, "connections": false, "education": false  # Default expanded  # Default expanded  # Default collapsed  # Default collapsed  # Default collapsed
}


# === LIFECYCLE ===
func _ready() -> void:
	"""Initialize the enhanced information panel"""
	set_process_unhandled_input(true)
	_setup_panel_structure()
	_apply_enhanced_styling()
	_setup_interactions()
	visible = false

	# Track learning time
	learning_start_time = Time.get_ticks_msec()


func _exit_tree() -> void:
	"""Clean up when panel is removed"""
	if panel_is_visible and current_structure.has("id"):
		var learning_time = (Time.get_ticks_msec() - learning_start_time) / 1000
		learning_time_tracked.emit(current_structure.id, learning_time)


# === PUBLIC INTERFACE ===
func display_structure_info(structure_data: Dictionary) -> void:
	"""Display comprehensive information for a brain structure"""
	if structure_data.is_empty():
		push_error("[EnhancedInfoPanel] Empty structure data provided")
		return

	current_structure = structure_data
	learning_start_time = Time.get_ticks_msec()

	# Update header
	_update_header_info()

	# Update quick info
	_update_quick_info()

	# Update all content sections
	_update_anatomy_section()
	_update_function_section()
	_update_clinical_section()
	_update_connections_section()
	_update_education_section()

	# Show panel with animation
	show_panel()


func show_panel() -> void:
	"""Show panel with enhanced animation"""
	if panel_is_visible:
		return

	panel_is_visible = true
	visible = true
	modulate.a = 0.0

	# Entrance animation
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 1.0, ANIMATION_DURATION)

	# Slight scale effect
	scale = Vector2(0.95, 0.95)
	tween.parallel().tween_property(self, "scale", Vector2.ONE, ANIMATION_DURATION)

	# Focus for accessibility
	structure_name_label.grab_focus()


func hide_panel() -> void:
	"""Hide panel with enhanced animation"""
	if not panel_is_visible:
		return

	panel_is_visible = false

	# Track learning time
	if current_structure.has("id"):
		var learning_time = (Time.get_ticks_msec() - learning_start_time) / 1000
		learning_time_tracked.emit(current_structure.id, learning_time)

	# Exit animation
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "modulate:a", 0.0, ANIMATION_DURATION * 0.8)
	tween.parallel().tween_property(self, "scale", Vector2(0.95, 0.95), ANIMATION_DURATION * 0.8)
	tween.tween_callback(func(): visible = false)


func toggle_bookmark() -> void:
	"""Toggle bookmark state for current structure"""
	if current_structure.is_empty():
		return

	var structure_id = current_structure.get("id", "")
	if structure_id in bookmarked_structures:
		bookmarked_structures.erase(structure_id)
		bookmark_button.text = "⭐"
		bookmark_button.modulate = Color.WHITE
	else:
		bookmarked_structures.append(structure_id)
		bookmark_button.text = "★"
		bookmark_button.modulate = ENHANCED_COLORS.success

	bookmark_toggled.emit(structure_id, structure_id in bookmarked_structures)


# === PRIVATE SETUP METHODS ===
func _setup_panel_structure() -> void:
	"""Create the enhanced panel structure for medical education"""
	# Base panel styling
	custom_minimum_size = PANEL_MIN_SIZE
	size_flags_horizontal = Control.SIZE_SHRINK_END
	size_flags_vertical = Control.SIZE_SHRINK_CENTER

	# Main container
	main_container = VBoxContainer.new()
	main_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(main_container)

	# Create header
	_create_header_section()

	# Create scrollable content area
	scroll_container = ScrollContainer.new()
	scroll_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main_container.add_child(scroll_container)

	# Content container
	content_container = VBoxContainer.new()
	content_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content_container.add_theme_constant_override("separation", 12)
	scroll_container.add_child(content_container)

	# Create quick info section
	_create_quick_info_section()

	# Create all content sections
	_create_anatomy_section()
	_create_function_section()
	_create_clinical_section()
	_create_connections_section()
	_create_education_section()


func _create_header_section() -> void:
	"""Create the panel header with structure name and actions"""
	# Header background
	var header_bg = PanelContainer.new()
	header_bg.custom_minimum_size.y = 60
	main_container.add_child(header_bg)

	# Header content
	header_container = HBoxContainer.new()
	header_container.add_theme_constant_override("separation", 8)
	header_bg.add_child(header_container)

	# Structure info container
	var info_container = VBoxContainer.new()
	info_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header_container.add_child(info_container)

	# Structure name
	structure_name_label = Label.new()
	structure_name_label.text = "Structure Name"
	structure_name_label.add_theme_font_size_override("font_size", 20)
	structure_name_label.add_theme_color_override("font_color", ENHANCED_COLORS.text_primary)
	info_container.add_child(structure_name_label)

	# Location label
	location_label = Label.new()
	location_label.text = "Location in brain"
	location_label.add_theme_font_size_override("font_size", 14)
	location_label.add_theme_color_override("font_color", ENHANCED_COLORS.text_secondary)
	info_container.add_child(location_label)

	# Action buttons
	action_buttons_container = HBoxContainer.new()
	action_buttons_container.add_theme_constant_override("separation", 4)
	header_container.add_child(action_buttons_container)

	# Bookmark button
	bookmark_button = Button.new()
	bookmark_button.text = "⭐"
	bookmark_button.custom_minimum_size = Vector2(40, 40)
	bookmark_button.tooltip_text = "Bookmark this structure for study"
	bookmark_button.flat = true
	action_buttons_container.add_child(bookmark_button)

	# Share button
	share_button = Button.new()
	share_button.text = "📤"
	share_button.custom_minimum_size = Vector2(40, 40)
	share_button.tooltip_text = "Share structure information"
	share_button.flat = true
	action_buttons_container.add_child(share_button)

	# Close button
	close_button = Button.new()
	close_button.text = "✕"
	close_button.custom_minimum_size = Vector2(40, 40)
	close_button.tooltip_text = "Close panel (ESC)"
	close_button.flat = true
	action_buttons_container.add_child(close_button)


func _create_quick_info_section() -> void:
	"""Create quick info section with key facts"""
	quick_info_container = PanelContainer.new()
	quick_info_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content_container.add_child(quick_info_container)

	quick_info_grid = GridContainer.new()
	quick_info_grid.columns = 3
	quick_info_grid.add_theme_constant_override("h_separation", 20)
	quick_info_grid.add_theme_constant_override("v_separation", 8)
	quick_info_container.add_child(quick_info_grid)

	# Size info
	var size_title = Label.new()
	size_title.text = "SIZE"
	size_title.add_theme_color_override("font_color", ENHANCED_COLORS.text_secondary)
	size_title.add_theme_font_size_override("font_size", 12)
	quick_info_grid.add_child(size_title)

	# Type info
	var type_title = Label.new()
	type_title.text = "TYPE"
	type_title.add_theme_color_override("font_color", ENHANCED_COLORS.text_secondary)
	type_title.add_theme_font_size_override("font_size", 12)
	quick_info_grid.add_child(type_title)

	# System info
	var system_title = Label.new()
	system_title.text = "SYSTEM"
	system_title.add_theme_color_override("font_color", ENHANCED_COLORS.text_secondary)
	system_title.add_theme_font_size_override("font_size", 12)
	quick_info_grid.add_child(system_title)

	# Values
	size_label = Label.new()
	size_label.text = "~3.5 cm"
	size_label.add_theme_font_size_override("font_size", 16)
	quick_info_grid.add_child(size_label)

	type_label = Label.new()
	type_label.text = "Gray Matter"
	type_label.add_theme_font_size_override("font_size", 16)
	quick_info_grid.add_child(type_label)

	system_label = Label.new()
	system_label.text = "Limbic"
	system_label.add_theme_font_size_override("font_size", 16)
	quick_info_grid.add_child(system_label)


func _create_anatomy_section() -> void:
	"""Create anatomy section with structure details"""
	anatomy_section = _create_collapsible_section("anatomy", "🧠 ANATOMY & STRUCTURE", true)
	anatomy_header = anatomy_section.get_child(0)
	anatomy_content = anatomy_section.get_child(1)


func _create_function_section() -> void:
	"""Create function section"""
	function_section = _create_collapsible_section("function", "⚡ FUNCTIONS", true)
	function_header = function_section.get_child(0)
	function_content = function_section.get_child(1)


func _create_clinical_section() -> void:
	"""Create clinical relevance section"""
	clinical_section = _create_collapsible_section("clinical", "🏥 CLINICAL RELEVANCE", false)
	clinical_header = clinical_section.get_child(0)
	clinical_content = clinical_section.get_child(1)


func _create_connections_section() -> void:
	"""Create anatomical connections section"""
	connections_section = _create_collapsible_section("connections", "🔗 CONNECTIONS", false)
	connections_header = connections_section.get_child(0)
	connections_content = connections_section.get_child(1)


func _create_education_section() -> void:
	"""Create educational content section"""
	education_section = _create_collapsible_section("education", "📚 STUDY MATERIALS", false)
	education_header = education_section.get_child(0)
	education_content = education_section.get_child(1)


func _create_collapsible_section(
	section_id: String, title: String, expanded: bool
) -> VBoxContainer:
	"""Helper to create a collapsible section"""
	var section = VBoxContainer.new()
	section.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	section.add_theme_constant_override("separation", 8)
	content_container.add_child(section)

	# Header button
	var header = Button.new()
	header.text = ("▼ " if expanded else "▶ ") + title
	header.alignment = HORIZONTAL_ALIGNMENT_LEFT
	header.flat = true
	header.add_theme_font_size_override("font_size", 16)
	header.focus_mode = Control.FOCUS_ALL
	section.add_child(header)

	# Content container
	var content = VBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 8)
	content.visible = expanded
	section.add_child(content)

	# Connect toggle
	header.pressed.connect(func(): _toggle_section(section_id))

	return section


# === CONTENT UPDATE METHODS ===
func _update_header_info() -> void:
	"""Update header with structure information"""
	var name = current_structure.get("displayName", "Unknown Structure")
	structure_name_label.text = name

	# Update location based on structure
	var location = _get_structure_location(current_structure.get("id", ""))
	location_label.text = location

	# Update bookmark state
	var structure_id = current_structure.get("id", "")
	if structure_id in bookmarked_structures:
		bookmark_button.text = "★"
		bookmark_button.modulate = ENHANCED_COLORS.success
	else:
		bookmark_button.text = "⭐"
		bookmark_button.modulate = Color.WHITE


func _update_quick_info() -> void:
	"""Update quick info section"""
	var structure_id = current_structure.get("id", "")

	# Get structure-specific info
	var info = _get_structure_info(structure_id)
	size_label.text = info.get("size", "Variable")
	type_label.text = info.get("type", "Neural Tissue")
	system_label.text = info.get("system", "Central Nervous")


func _update_anatomy_section() -> void:
	"""Update anatomy section with detailed information"""
	# Clear existing content
	for child in anatomy_content.get_children():
		child.queue_free()

	# Description
	var desc_label = RichTextLabel.new()
	desc_label.bbcode_enabled = true
	desc_label.fit_content = true
	desc_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	desc_label.text = (
		"[color=#CCCCCC]"
		+ current_structure.get("shortDescription", "No description available.")
		+ "[/color]"
	)
	anatomy_content.add_child(desc_label)

	# Add separator
	var sep = HSeparator.new()
	anatomy_content.add_child(sep)

	# Anatomical details
	var details_label = Label.new()
	details_label.text = "Anatomical Details:"
	details_label.add_theme_color_override("font_color", ENHANCED_COLORS.primary)
	anatomy_content.add_child(details_label)

	var structure_id = current_structure.get("id", "")
	var details = _get_anatomical_details(structure_id)

	for detail in details:
		var detail_item = Label.new()
		detail_item.text = "• " + detail
		detail_item.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		detail_item.add_theme_color_override("font_color", ENHANCED_COLORS.text_secondary)
		anatomy_content.add_child(detail_item)


func _update_function_section() -> void:
	"""Update functions section"""
	# Clear existing content
	for child in function_content.get_children():
		child.queue_free()

	var functions = current_structure.get("functions", [])

	# Update header count
	function_header.text = (
		("▼ " if section_states.function else "▶ ") + "⚡ FUNCTIONS (" + str(functions.size()) + ")"
	)

	if functions.is_empty():
		var no_func_label = Label.new()
		no_func_label.text = "No functions documented"
		no_func_label.add_theme_color_override("font_color", ENHANCED_COLORS.text_secondary)
		function_content.add_child(no_func_label)
		return

	# Add each function
	for i in range(functions.size()):
		var func_container = HBoxContainer.new()
		func_container.add_theme_constant_override("separation", 8)
		function_content.add_child(func_container)

		# Function number
		var num_label = Label.new()
		num_label.text = str(i + 1) + "."
		num_label.add_theme_color_override("font_color", ENHANCED_COLORS.primary)
		num_label.custom_minimum_size.x = 20
		func_container.add_child(num_label)

		# Function text
		var func_label = Label.new()
		func_label.text = functions[i]
		func_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		func_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		func_container.add_child(func_label)


func _update_clinical_section() -> void:
	"""Update clinical relevance section"""
	# Clear existing content
	for child in clinical_content.get_children():
		child.queue_free()

	var structure_id = current_structure.get("id", "")
	var clinical_info = _get_clinical_info(structure_id)

	# Associated conditions
	if clinical_info.has("conditions"):
		var conditions_label = Label.new()
		conditions_label.text = "Associated Conditions:"
		conditions_label.add_theme_color_override("font_color", ENHANCED_COLORS.warning)
		clinical_content.add_child(conditions_label)

		for condition in clinical_info.conditions:
			var cond_button = Button.new()
			cond_button.text = "• " + condition
			cond_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
			cond_button.flat = true
			cond_button.add_theme_color_override("font_color", ENHANCED_COLORS.text_secondary)
			clinical_content.add_child(cond_button)

		clinical_content.add_child(HSeparator.new())

	# Clinical notes
	if clinical_info.has("notes"):
		var notes_label = RichTextLabel.new()
		notes_label.bbcode_enabled = true
		notes_label.fit_content = true
		notes_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		notes_label.text = "[color=#CCCCCC]" + clinical_info.notes + "[/color]"
		clinical_content.add_child(notes_label)


func _update_connections_section() -> void:
	"""Update anatomical connections section"""
	# Clear existing content
	for child in connections_content.get_children():
		child.queue_free()

	var structure_id = current_structure.get("id", "")
	var connections = _get_structure_connections(structure_id)

	# Update header count
	connections_header.text = (
		("▼ " if section_states.connections else "▶ ")
		+ "🔗 CONNECTIONS ("
		+ str(connections.size())
		+ ")"
	)

	if connections.is_empty():
		var no_conn_label = Label.new()
		no_conn_label.text = "No connections documented"
		no_conn_label.add_theme_color_override("font_color", ENHANCED_COLORS.text_secondary)
		connections_content.add_child(no_conn_label)
		return

	# Add connections
	for conn in connections:
		var conn_button = Button.new()
		conn_button.text = "→ " + conn.name + " (" + conn.type + ")"
		conn_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		conn_button.flat = true
		conn_button.tooltip_text = "Click to learn about " + conn.name
		connections_content.add_child(conn_button)

		# Connect to related structure signal
		conn_button.pressed.connect(func(): related_structure_selected.emit(conn.id))


func _update_education_section() -> void:
	"""Update educational content section"""
	# Clear existing content
	for child in education_content.get_children():
		child.queue_free()

	var structure_id = current_structure.get("id", "")

	# Key points
	var key_points_label = Label.new()
	key_points_label.text = "📌 Key Learning Points:"
	key_points_label.add_theme_color_override("font_color", ENHANCED_COLORS.primary)
	education_content.add_child(key_points_label)

	var key_points = _get_key_learning_points(structure_id)
	for point in key_points:
		var point_label = Label.new()
		point_label.text = "• " + point
		point_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		point_label.add_theme_color_override("font_color", ENHANCED_COLORS.text_secondary)
		education_content.add_child(point_label)

	education_content.add_child(HSeparator.new())

	# Mnemonic
	var mnemonic = _get_mnemonic(structure_id)
	if mnemonic != "":
		var mnem_label = Label.new()
		mnem_label.text = "💡 Memory Aid:"
		mnem_label.add_theme_color_override("font_color", ENHANCED_COLORS.success)
		education_content.add_child(mnem_label)

		var mnem_text = Label.new()
		mnem_text.text = mnemonic
		mnem_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		mnem_text.add_theme_style_override("font", preload("res://assets/fonts/Inter-Bold.tres"))
		education_content.add_child(mnem_text)

		education_content.add_child(HSeparator.new())

	# Study question
	var question_label = Label.new()
	question_label.text = "❓ Test Your Knowledge:"
	question_label.add_theme_color_override("font_color", ENHANCED_COLORS.secondary)
	education_content.add_child(question_label)

	var question = _get_study_question(structure_id)
	var q_label = Label.new()
	q_label.text = question.text
	q_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	education_content.add_child(q_label)

	# Answer buttons
	var answer_container = HBoxContainer.new()
	answer_container.add_theme_constant_override("separation", 8)
	education_content.add_child(answer_container)

	for i in range(question.options.size()):
		var opt_button = Button.new()
		opt_button.text = question.options[i]
		opt_button.toggle_mode = true
		answer_container.add_child(opt_button)

		var correct_answer = i == question.correct
		opt_button.pressed.connect(func(): _on_quiz_answer(question.id, correct_answer, opt_button))


# === INTERACTION HANDLERS ===
func _toggle_section(section_name: String) -> void:
	"""Toggle visibility of a collapsible section"""
	var was_expanded = section_states.get(section_name, false)
	var new_state = not was_expanded
	section_states[section_name] = new_state

	# Get the section elements
	var header: Button
	var content: Control

	match section_name:
		"anatomy":
			header = anatomy_header
			content = anatomy_content
		"function":
			header = function_header
			content = function_content
		"clinical":
			header = clinical_header
			content = clinical_content
		"connections":
			header = connections_header
			content = connections_content
		"education":
			header = education_header
			content = education_content
		_:
			return

	# Update header arrow
	var header_text = header.text
	if header_text.begins_with("▼") or header_text.begins_with("▶"):
		header_text = header_text.substr(2)
	header.text = ("▼ " if new_state else "▶ ") + header_text

	# Animate content visibility
	if new_state:
		content.visible = true
		content.modulate.a = 0.0
		var tween = create_tween()
		tween.tween_property(content, "modulate:a", 1.0, ANIMATION_DURATION * 0.5)
	else:
		var tween = create_tween()
		tween.tween_property(content, "modulate:a", 0.0, ANIMATION_DURATION * 0.5)
		tween.tween_callback(func(): content.visible = false)

	section_toggled.emit(section_name, new_state)


func _on_quiz_answer(question_id: String, correct: bool, button: Button) -> void:
	"""Handle quiz answer selection"""
	# Visual feedback
	if correct:
		button.modulate = ENHANCED_COLORS.success
		button.text = "✓ " + button.text
	else:
		button.modulate = Color(1.0, 0.3, 0.3)
		button.text = "✗ " + button.text

	# Disable all answer buttons
	var parent = button.get_parent()
	for child in parent.get_children():
		if child is Button:
			child.disabled = true

	quiz_answered.emit(question_id, correct)


# === EDUCATIONAL DATA METHODS ===
func _get_structure_location(structure_id: String) -> String:
	"""Get anatomical location description"""
	var locations = {
		"Hippocampus": "Medial temporal lobe",
		"Striatum": "Basal ganglia, subcortical",
		"Thalamus": "Diencephalon, central brain",
		"Ventricles": "Throughout brain interior",
		"Amygdala": "Medial temporal lobe",
		"Cerebellum": "Posterior fossa",
		"Cortex": "Outer brain surface"
	}
	return locations.get(structure_id, "Central nervous system")


func _get_structure_info(structure_id: String) -> Dictionary:
	"""Get quick info data for structure"""
	var info_data = {
		"Hippocampus": {"size": "~3.5 cm", "type": "Gray Matter", "system": "Limbic"},
		"Striatum": {"size": "~6 cm", "type": "Gray Matter", "system": "Basal Ganglia"},
		"Thalamus": {"size": "~3 cm", "type": "Gray Matter", "system": "Diencephalon"},
		"Ventricles": {"size": "~150 mL", "type": "CSF Space", "system": "Ventricular"},
		"Amygdala": {"size": "~1.5 cm", "type": "Gray Matter", "system": "Limbic"},
		"Cerebellum": {"size": "~10 cm", "type": "Mixed", "system": "Cerebellar"},
		"Cortex": {"size": "2-4 mm thick", "type": "Gray Matter", "system": "Cerebral"}
	}
	return info_data.get(structure_id, {})


func _get_anatomical_details(structure_id: String) -> Array:
	"""Get detailed anatomical information"""
	var details = {
		"Hippocampus":
		[
			"C-shaped structure in medial temporal lobe",
			"Divided into CA fields (CA1-CA4) and dentate gyrus",
			"Part of the limbic system",
			"Connected to entorhinal cortex via perforant pathway",
			"Bilateral structure (one in each hemisphere)"
		],
		"Striatum":
		[
			"Largest component of basal ganglia",
			"Composed of caudate nucleus and putamen",
			"Separated by internal capsule fibers",
			"Rich in dopamine receptors",
			"Contains medium spiny neurons (95%)"
		],
		"Thalamus":
		[
			"Egg-shaped paired structure",
			"Contains multiple nuclei with specific functions",
			"Central relay station for sensory information",
			"Connected by interthalamic adhesion",
			"Surrounded by internal capsule"
		]
	}
	return details.get(structure_id, ["Detailed anatomical information not available"])


func _get_clinical_info(structure_id: String) -> Dictionary:
	"""Get clinical relevance information"""
	var clinical_data = {
		"Hippocampus":
		{
			"conditions": ["Alzheimer's Disease", "Temporal Lobe Epilepsy", "Amnesia", "PTSD"],
			"notes":
			"The hippocampus is often the first region affected in Alzheimer's disease, showing significant atrophy. Bilateral damage results in profound anterograde amnesia (inability to form new memories)."
		},
		"Striatum":
		{
			"conditions": ["Parkinson's Disease", "Huntington's Disease", "OCD", "Addiction"],
			"notes":
			"Dopamine depletion in the striatum is central to Parkinson's disease pathology. The caudate shows early degeneration in Huntington's disease."
		},
		"Thalamus":
		{
			"conditions":
			[
				"Thalamic Pain Syndrome",
				"Fatal Familial Insomnia",
				"Wernicke-Korsakoff",
				"Absence Seizures"
			],
			"notes":
			"Thalamic strokes can cause severe chronic pain syndromes. The thalamus is critical for consciousness and sleep-wake cycles."
		}
	}
	return clinical_data.get(
		structure_id, {"conditions": [], "notes": "Clinical information not available"}
	)


func _get_structure_connections(structure_id: String) -> Array:
	"""Get anatomical connections for structure"""
	var connections_data = {
		"Hippocampus":
		[
			{"id": "Amygdala", "name": "Amygdala", "type": "Direct"},
			{"id": "EntorhinalCortex", "name": "Entorhinal Cortex", "type": "Input"},
			{"id": "Fornix", "name": "Fornix", "type": "Output"},
			{"id": "SeptumPellucidum", "name": "Septum", "type": "Bidirectional"}
		],
		"Striatum":
		[
			{"id": "SubstantiaNigra", "name": "Substantia Nigra", "type": "Dopaminergic"},
			{"id": "Cortex", "name": "Cerebral Cortex", "type": "Corticostriatal"},
			{"id": "Thalamus", "name": "Thalamus", "type": "Output"},
			{"id": "GlobusPallidus", "name": "Globus Pallidus", "type": "Direct"}
		],
		"Thalamus":
		[
			{"id": "Cortex", "name": "Cerebral Cortex", "type": "Thalamocortical"},
			{"id": "Striatum", "name": "Striatum", "type": "Input"},
			{"id": "Cerebellum", "name": "Cerebellum", "type": "Input"},
			{"id": "Brainstem", "name": "Brainstem", "type": "Ascending"}
		]
	}
	return connections_data.get(structure_id, [])


func _get_key_learning_points(structure_id: String) -> Array:
	"""Get key educational points for structure"""
	var learning_points = {
		"Hippocampus":
		[
			"Essential for converting short-term to long-term memories",
			"Critical for spatial navigation and cognitive mapping",
			"One of few brain regions with adult neurogenesis",
			"Highly vulnerable to hypoxia and stress hormones",
			"Shows distinctive theta rhythm during learning"
		],
		"Striatum":
		[
			"Primary input structure of basal ganglia",
			"Critical for motor control and habit formation",
			"Involved in reward processing and motivation",
			"Contains distinct direct and indirect pathways",
			"Target for deep brain stimulation in movement disorders"
		],
		"Thalamus":
		[
			"Relay station for all sensory info except smell",
			"Essential for consciousness and arousal",
			"Contains specific nuclei for different functions",
			"Involved in cortico-thalamo-cortical loops",
			"Damage can cause sensory loss or pain syndromes"
		]
	}
	return learning_points.get(structure_id, ["Study this structure's unique characteristics"])


func _get_mnemonic(structure_id: String) -> String:
	"""Get memory aid for structure"""
	var mnemonics = {
		"Hippocampus": "HIPPO-CAMPUS: Where memories go to 'study'",
		"Striatum": "STRI-atum: STRIpes of gray matter for movement",
		"Thalamus": "THAL-amus: THe ALl-important relay station",
		"Ventricles": "Ventricles are Vents for CSF flow",
		"Amygdala": "AMYG-dala: Almond-shaped fear center"
	}
	return mnemonics.get(structure_id, "")


func _get_study_question(structure_id: String) -> Dictionary:
	"""Get an interactive study question"""
	var questions = {
		"Hippocampus":
		{
			"id": "hippo_q1",
			"text": "Which type of memory is the hippocampus most critical for?",
			"options": ["Procedural", "Declarative", "Working"],
			"correct": 1
		},
		"Striatum":
		{
			"id": "stri_q1",
			"text": "What neurotransmitter is most important in striatal function?",
			"options": ["Serotonin", "GABA", "Dopamine"],
			"correct": 2
		},
		"Thalamus":
		{
			"id": "thal_q1",
			"text": "Which sensory modality does NOT relay through the thalamus?",
			"options": ["Vision", "Smell", "Hearing"],
			"correct": 1
		}
	}
	return questions.get(
		structure_id,
		{
			"id": "default_q",
			"text": "What makes this structure unique?",
			"options": ["Location", "Function", "Both"],
			"correct": 2
		}
	)


# === STYLING AND ANIMATION ===
func _apply_enhanced_styling() -> void:
	"""Apply glassmorphism and modern styling"""
	# Panel background
	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = ENHANCED_COLORS.background
	panel_style.border_color = ENHANCED_COLORS.border
	panel_style.set_border_width_all(1)
	panel_style.set_corner_radius_all(12)
	panel_style.shadow_color = Color(0, 0, 0, 0.3)
	panel_style.shadow_size = 8
	panel_style.shadow_offset = Vector2(0, 4)
	add_theme_stylebox_override("panel", panel_style)

	# Header background style
	if header_container:
		var header_parent = header_container.get_parent()
		if header_parent is PanelContainer:
			var header_style = StyleBoxFlat.new()
			header_style.bg_color = Color(0.05, 0.05, 0.08, 0.98)
			header_style.set_corner_radius_individual(12, 12, 0, 0)
			header_parent.add_theme_stylebox_override("panel", header_style)

	# Quick info panel style
	if quick_info_container:
		var info_style = StyleBoxFlat.new()
		info_style.bg_color = Color(0.15, 0.15, 0.2, 0.4)
		info_style.border_color = ENHANCED_COLORS.primary.darkened(0.5)
		info_style.set_border_width_all(1)
		info_style.set_corner_radius_all(8)
		info_style.set_content_margin_all(12)
		quick_info_container.add_theme_stylebox_override("panel", info_style)

	# Button hover effects
	_add_button_hover_effects()


func _add_button_hover_effects() -> void:
	"""Add hover effects to all buttons"""
	var all_buttons = [
		bookmark_button,
		share_button,
		close_button,
		anatomy_header,
		function_header,
		clinical_header,
		connections_header,
		education_header
	]

	for button in all_buttons:
		if button:
			button.mouse_entered.connect(func(): _on_button_hover(button, true))
			button.mouse_exited.connect(func(): _on_button_hover(button, false))


func _on_button_hover(button: Button, hovering: bool) -> void:
	"""Handle button hover animation"""
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)

	if hovering:
		tween.tween_property(button, "modulate", Color(1.2, 1.2, 1.2), 0.1)
	else:
		tween.tween_property(button, "modulate", Color.WHITE, 0.1)


# === INTERACTION SETUP ===
func _setup_interactions() -> void:
	"""Setup all button interactions and signals"""
	# Header buttons
	close_button.pressed.connect(_on_close_pressed)
	bookmark_button.pressed.connect(toggle_bookmark)
	share_button.pressed.connect(_on_share_pressed)

	# Keyboard shortcuts
	set_process_unhandled_key_input(true)


func _unhandled_key_input(event: InputEvent) -> void:
	"""Handle keyboard shortcuts"""
	if not panel_is_visible:
		return

	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_ESCAPE:
				hide_panel()
				panel_closed.emit()
				get_viewport().set_input_as_handled()
			KEY_B:
				if event.ctrl_pressed or event.meta_pressed:
					toggle_bookmark()
					get_viewport().set_input_as_handled()


func _on_close_pressed() -> void:
	"""Handle close button press"""
	hide_panel()
	panel_closed.emit()


func _on_share_pressed() -> void:
	"""Handle share button press"""
	print("[EnhancedInfoPanel] Share: " + current_structure.get("displayName", "Unknown"))
	# TODO: Implement sharing functionality
