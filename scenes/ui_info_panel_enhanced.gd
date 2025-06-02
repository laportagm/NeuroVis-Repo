# Enhanced Educational Information Panel
# Modern glass morphism design with advanced educational features
class_name EnhancedStructureInfoPanel
extends PanelContainer

# UI node references - main structure
@onready var header_container: VBoxContainer
@onready var search_container: HBoxContainer
@onready var search_field: LineEdit
@onready var search_clear_btn: Button
@onready var structure_name_label: Label
@onready var structure_id_badge: Label
@onready var close_button: Button
@onready var bookmark_button: Button
@onready var share_button: Button

# Content nodes
@onready var main_scroll: ScrollContainer
@onready var content_container: VBoxContainer
@onready var description_section: VBoxContainer
@onready var description_header: Label
@onready var description_text: RichTextLabel
@onready var functions_section: VBoxContainer
@onready var functions_header: Label
@onready var functions_list: VBoxContainer
@onready var related_section: VBoxContainer
@onready var related_header: Label
@onready var related_chips_container: HBoxContainer

# Learning features
@onready var learning_section: VBoxContainer
@onready var learning_header: Label
@onready var progress_container: HBoxContainer
@onready var progress_bar: ProgressBar
@onready var progress_label: Label
@onready var quiz_button: Button
@onready var notes_button: Button

# Footer with actions
@onready var footer_container: HBoxContainer
@onready var difficulty_indicator: Label
@onready var reading_time_label: Label

# State management
var current_structure_id: String = ""
var current_structure_data: Dictionary = {}
var is_bookmarked: bool = false
var learning_progress: Dictionary = {}
var search_results: Array = []
var is_animating: bool = false

# Educational data
var difficulty_levels: Dictionary = {
	"beginner": {"color": UIThemeManager.ACCENT_GREEN, "text": "Beginner"},
	"intermediate": {"color": UIThemeManager.ACCENT_ORANGE, "text": "Intermediate"},
	"advanced": {"color": UIThemeManager.ACCENT_RED, "text": "Advanced"}
}

var anatomical_categories: Dictionary = {
	"cortex": {"color": UIThemeManager.ACCENT_BLUE, "icon": "🧠"},
	"subcortical": {"color": UIThemeManager.ACCENT_PURPLE, "icon": "⚡"},
	"brainstem": {"color": UIThemeManager.ACCENT_TEAL, "icon": "🌿"},
	"cerebellum": {"color": UIThemeManager.ACCENT_CYAN, "icon": "🎯"},
	"limbic": {"color": UIThemeManager.ACCENT_PINK, "icon": "❤️"}
}

# Signals
signal panel_closed
signal structure_bookmarked(structure_id: String, bookmarked: bool)
signal quiz_requested(structure_id: String)
signal notes_requested(structure_id: String)
signal related_structure_selected(structure_id: String)
signal search_performed(query: String)

func _ready() -> void:
	call_deferred("_initialize_enhanced_panel")

func _initialize_enhanced_panel() -> void:
	"""Initialize the enhanced educational panel"""
	_create_enhanced_ui_structure()
	_apply_enhanced_styling()
	_connect_enhanced_signals()
	_setup_search_functionality()
	_initialize_learning_features()
	
	clear_data()
	print("[ENHANCED_INFO_PANEL] Educational panel initialized with advanced features")

func _create_enhanced_ui_structure() -> void:
	"""Create sophisticated UI structure for educational content"""
	print("[ENHANCED_INFO_PANEL] Creating enhanced UI structure")
	
	# Main container with enhanced margins
	var main_margin = MarginContainer.new()
	main_margin.name = "MainMargin"
	main_margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	main_margin.add_theme_constant_override("margin_top", UIThemeManager.MARGIN_STANDARD)
	main_margin.add_theme_constant_override("margin_bottom", UIThemeManager.MARGIN_STANDARD)
	main_margin.add_theme_constant_override("margin_left", UIThemeManager.MARGIN_STANDARD)
	main_margin.add_theme_constant_override("margin_right", UIThemeManager.MARGIN_STANDARD)
	add_child(main_margin)
	
	# Main vertical container
	var main_vbox = VBoxContainer.new()
	main_vbox.name = "MainVBox"
	main_vbox.add_theme_constant_override("separation", UIThemeManager.MARGIN_MEDIUM)
	main_margin.add_child(main_vbox)
	
	# Enhanced header section
	_create_enhanced_header(main_vbox)
	
	# Search section
	_create_search_section(main_vbox)
	
	# Enhanced content area
	_create_enhanced_content_area(main_vbox)
	
	# Learning features section
	_create_learning_section(main_vbox)
	
	# Footer with metadata
	_create_enhanced_footer(main_vbox)

func _create_enhanced_header(parent: Control) -> void:
	"""Create sophisticated header with title and actions"""
	header_container = VBoxContainer.new()
	header_container.name = "HeaderContainer"
	header_container.add_theme_constant_override("separation", UIThemeManager.MARGIN_SMALL)
	parent.add_child(header_container)
	
	# Title bar with actions
	var title_bar = HBoxContainer.new()
	title_bar.name = "TitleBar"
	title_bar.add_theme_constant_override("separation", UIThemeManager.MARGIN_SMALL)
	header_container.add_child(title_bar)
	
	# Structure name and badge container
	var name_container = VBoxContainer.new()
	name_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_container.add_theme_constant_override("separation", UIThemeManager.MARGIN_TINY)
	title_bar.add_child(name_container)
	
	# Structure name
	structure_name_label = Label.new()
	structure_name_label.name = "StructureName"
	structure_name_label.text = "Structure Information"
	structure_name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	structure_name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	name_container.add_child(structure_name_label)
	
	# Structure ID badge
	structure_id_badge = Label.new()
	structure_id_badge.name = "StructureIDBadge"
	structure_id_badge.text = ""
	structure_id_badge.visible = false
	name_container.add_child(structure_id_badge)
	
	# Action buttons container
	var actions_container = HBoxContainer.new()
	actions_container.add_theme_constant_override("separation", UIThemeManager.MARGIN_SMALL)
	title_bar.add_child(actions_container)
	
	# Bookmark button
	bookmark_button = Button.new()
	bookmark_button.name = "BookmarkButton"
	bookmark_button.text = "⭐"
	bookmark_button.custom_minimum_size = Vector2(36, 36)
	bookmark_button.tooltip_text = "Bookmark this structure"
	actions_container.add_child(bookmark_button)
	
	# Share/Export button
	share_button = Button.new()
	share_button.name = "ShareButton"
	share_button.text = "📤"
	share_button.custom_minimum_size = Vector2(36, 36)
	share_button.tooltip_text = "Share or export information"
	actions_container.add_child(share_button)
	
	# Close button
	close_button = Button.new()
	close_button.name = "CloseButton"
	close_button.text = "✕"
	close_button.custom_minimum_size = Vector2(36, 36)
	close_button.tooltip_text = "Close panel"
	actions_container.add_child(close_button)

func _create_search_section(parent: Control) -> void:
	"""Create intelligent search functionality"""
	search_container = HBoxContainer.new()
	search_container.name = "SearchContainer"
	search_container.add_theme_constant_override("separation", UIThemeManager.MARGIN_SMALL)
	search_container.visible = false  # Hidden by default, shown when needed
	parent.add_child(search_container)
	
	# Search field
	search_field = LineEdit.new()
	search_field.name = "SearchField"
	search_field.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	search_field.placeholder_text = "Search brain structures, functions..."
	search_container.add_child(search_field)
	
	# Search clear button
	search_clear_btn = Button.new()
	search_clear_btn.name = "SearchClearButton"
	search_clear_btn.text = "🗙"
	search_clear_btn.custom_minimum_size = Vector2(32, 32)
	search_clear_btn.tooltip_text = "Clear search"
	search_container.add_child(search_clear_btn)

func _create_enhanced_content_area(parent: Control) -> void:
	"""Create sophisticated content area with sections"""
	# Scroll container for content
	main_scroll = ScrollContainer.new()
	main_scroll.name = "MainScroll"
	main_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	parent.add_child(main_scroll)
	
	# Content container
	content_container = VBoxContainer.new()
	content_container.name = "ContentContainer"
	content_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content_container.add_theme_constant_override("separation", UIThemeManager.MARGIN_LARGE)
	main_scroll.add_child(content_container)
	
	# Description section
	_create_description_section(content_container)
	
	# Functions section
	_create_functions_section(content_container)
	
	# Related structures section
	_create_related_section(content_container)

func _create_description_section(parent: Control) -> void:
	"""Create enhanced description section"""
	description_section = VBoxContainer.new()
	description_section.name = "DescriptionSection"
	description_section.add_theme_constant_override("separation", UIThemeManager.MARGIN_MEDIUM)
	parent.add_child(description_section)
	
	# Section header
	description_header = Label.new()
	description_header.name = "DescriptionHeader"
	description_header.text = "📋 Description"
	description_section.add_child(description_header)
	
	# Description text with rich formatting
	description_text = RichTextLabel.new()
	description_text.name = "DescriptionText"
	description_text.custom_minimum_size = Vector2(0, 120)
	description_text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	description_text.bbcode_enabled = true
	description_text.fit_content = true
	description_text.scroll_active = false
	description_text.selection_enabled = true
	description_section.add_child(description_text)

func _create_functions_section(parent: Control) -> void:
	"""Create enhanced functions section with visual indicators"""
	functions_section = VBoxContainer.new()
	functions_section.name = "FunctionsSection"
	functions_section.add_theme_constant_override("separation", UIThemeManager.MARGIN_MEDIUM)
	parent.add_child(functions_section)
	
	# Section header
	functions_header = Label.new()
	functions_header.name = "FunctionsHeader"
	functions_header.text = "⚡ Key Functions"
	functions_section.add_child(functions_header)
	
	# Functions list container
	functions_list = VBoxContainer.new()
	functions_list.name = "FunctionsList"
	functions_list.add_theme_constant_override("separation", UIThemeManager.MARGIN_SMALL)
	functions_section.add_child(functions_list)

func _create_related_section(parent: Control) -> void:
	"""Create related structures section with clickable chips"""
	related_section = VBoxContainer.new()
	related_section.name = "RelatedSection"
	related_section.add_theme_constant_override("separation", UIThemeManager.MARGIN_MEDIUM)
	related_section.visible = false  # Hidden until we have related data
	parent.add_child(related_section)
	
	# Section header
	related_header = Label.new()
	related_header.name = "RelatedHeader"
	related_header.text = "🔗 Related Structures"
	related_section.add_child(related_header)
	
	# Chips container
	related_chips_container = HBoxContainer.new()
	related_chips_container.name = "RelatedChipsContainer"
	related_chips_container.add_theme_constant_override("separation", UIThemeManager.MARGIN_SMALL)
	related_section.add_child(related_chips_container)

func _create_learning_section(parent: Control) -> void:
	"""Create learning and progress tracking section"""
	learning_section = VBoxContainer.new()
	learning_section.name = "LearningSection"
	learning_section.add_theme_constant_override("separation", UIThemeManager.MARGIN_MEDIUM)
	parent.add_child(learning_section)
	
	# Section header
	learning_header = Label.new()
	learning_header.name = "LearningHeader"
	learning_header.text = "🎓 Learning Progress"
	learning_section.add_child(learning_header)
	
	# Progress container
	progress_container = HBoxContainer.new()
	progress_container.name = "ProgressContainer"
	progress_container.add_theme_constant_override("separation", UIThemeManager.MARGIN_MEDIUM)
	learning_section.add_child(progress_container)
	
	# Progress bar
	progress_bar = ProgressBar.new()
	progress_bar.name = "ProgressBar"
	progress_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	progress_bar.custom_minimum_size = Vector2(0, 8)
	progress_bar.max_value = 100.0
	progress_bar.value = 0.0
	progress_container.add_child(progress_bar)
	
	# Progress label
	progress_label = Label.new()
	progress_label.name = "ProgressLabel"
	progress_label.text = "0%"
	progress_container.add_child(progress_label)
	
	# Learning actions
	var actions_container = HBoxContainer.new()
	actions_container.add_theme_constant_override("separation", UIThemeManager.MARGIN_SMALL)
	learning_section.add_child(actions_container)
	
	# Quiz button
	quiz_button = Button.new()
	quiz_button.name = "QuizButton"
	quiz_button.text = "📝 Take Quiz"
	quiz_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	actions_container.add_child(quiz_button)
	
	# Notes button
	notes_button = Button.new()
	notes_button.name = "NotesButton"
	notes_button.text = "📓 My Notes"
	notes_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	actions_container.add_child(notes_button)

func _create_enhanced_footer(parent: Control) -> void:
	"""Create footer with metadata and difficulty indicator"""
	# Separator
	var separator = HSeparator.new()
	separator.add_theme_constant_override("separation", 2)
	parent.add_child(separator)
	
	# Footer container
	footer_container = HBoxContainer.new()
	footer_container.name = "FooterContainer"
	footer_container.add_theme_constant_override("separation", UIThemeManager.MARGIN_MEDIUM)
	parent.add_child(footer_container)
	
	# Difficulty indicator
	difficulty_indicator = Label.new()
	difficulty_indicator.name = "DifficultyIndicator"
	difficulty_indicator.text = "🟢 Beginner"
	difficulty_indicator.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	footer_container.add_child(difficulty_indicator)
	
	# Reading time
	reading_time_label = Label.new()
	reading_time_label.name = "ReadingTimeLabel"
	reading_time_label.text = "⏱️ 2 min read"
	reading_time_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	footer_container.add_child(reading_time_label)

func _apply_enhanced_styling() -> void:
	"""Apply sophisticated educational styling"""
	# Main panel styling
	UIThemeManager.apply_glass_panel(self, 0.95, "info")
	
	# Header styling
	UIThemeManager.apply_modern_label(structure_name_label, UIThemeManager.FONT_SIZE_H2, UIThemeManager.TEXT_PRIMARY, "heading")
	UIThemeManager.apply_modern_label(structure_id_badge, UIThemeManager.FONT_SIZE_TINY, UIThemeManager.TEXT_ACCENT, "badge")
	
	# Button styling
	UIThemeManager.apply_modern_button(bookmark_button, UIThemeManager.ACCENT_YELLOW, "icon")
	UIThemeManager.apply_modern_button(share_button, UIThemeManager.ACCENT_BLUE, "icon")
	UIThemeManager.apply_modern_button(close_button, UIThemeManager.ACCENT_RED, "icon")
	UIThemeManager.apply_modern_button(quiz_button, UIThemeManager.ACCENT_GREEN, "standard")
	UIThemeManager.apply_modern_button(notes_button, UIThemeManager.ACCENT_PURPLE, "standard")
	
	# Search field styling
	UIThemeManager.apply_search_field_styling(search_field, "Search brain structures, functions...")
	UIThemeManager.apply_modern_button(search_clear_btn, UIThemeManager.ACCENT_RED, "small")
	
	# Section headers
	UIThemeManager.apply_modern_label(description_header, UIThemeManager.FONT_SIZE_H3, UIThemeManager.TEXT_ACCENT, "subheading")
	UIThemeManager.apply_modern_label(functions_header, UIThemeManager.FONT_SIZE_H3, UIThemeManager.TEXT_ACCENT, "subheading")
	UIThemeManager.apply_modern_label(related_header, UIThemeManager.FONT_SIZE_H3, UIThemeManager.TEXT_ACCENT, "subheading")
	UIThemeManager.apply_modern_label(learning_header, UIThemeManager.FONT_SIZE_H3, UIThemeManager.TEXT_ACCENT, "subheading")
	
	# Content styling
	UIThemeManager.apply_rich_text_styling(description_text, UIThemeManager.FONT_SIZE_MEDIUM, "description")
	UIThemeManager.apply_progress_bar_styling(progress_bar, UIThemeManager.ACCENT_BLUE)
	
	# Footer styling
	UIThemeManager.apply_modern_label(difficulty_indicator, UIThemeManager.FONT_SIZE_SMALL, UIThemeManager.TEXT_SECONDARY, "caption")
	UIThemeManager.apply_modern_label(reading_time_label, UIThemeManager.FONT_SIZE_SMALL, UIThemeManager.TEXT_SECONDARY, "caption")
	UIThemeManager.apply_modern_label(progress_label, UIThemeManager.FONT_SIZE_SMALL, UIThemeManager.TEXT_PRIMARY)

func _connect_enhanced_signals() -> void:
	"""Connect all interactive signals"""
	if close_button and not close_button.pressed.is_connected(_on_close_pressed):
		close_button.pressed.connect(_on_close_pressed)
	
	if bookmark_button and not bookmark_button.pressed.is_connected(_on_bookmark_pressed):
		bookmark_button.pressed.connect(_on_bookmark_pressed)
	
	if share_button and not share_button.pressed.is_connected(_on_share_pressed):
		share_button.pressed.connect(_on_share_pressed)
	
	if quiz_button and not quiz_button.pressed.is_connected(_on_quiz_pressed):
		quiz_button.pressed.connect(_on_quiz_pressed)
	
	if notes_button and not notes_button.pressed.is_connected(_on_notes_pressed):
		notes_button.pressed.connect(_on_notes_pressed)
	
	if search_field and not search_field.text_submitted.is_connected(_on_search_submitted):
		search_field.text_submitted.connect(_on_search_submitted)
		search_field.text_changed.connect(_on_search_text_changed)
	
	if search_clear_btn and not search_clear_btn.pressed.is_connected(_on_search_clear):
		search_clear_btn.pressed.connect(_on_search_clear)

func _setup_search_functionality() -> void:
	"""Setup intelligent search features"""
	# TODO: Implement search autocomplete and suggestions
	pass

func _initialize_learning_features() -> void:
	"""Initialize learning progress and educational features"""
	learning_progress = {
		"viewed": false,
		"quiz_completed": false,
		"notes_taken": false,
		"bookmarked": false,
		"time_spent": 0.0
	}

# Enhanced public interface
func display_structure_data(structure_data: Dictionary) -> void:
	"""Display structure information with enhanced educational features"""
	if structure_data.is_empty():
		print("[ENHANCED_INFO_PANEL] Empty structure data received")
		clear_data()
		return
	
	current_structure_id = structure_data.get("id", "unknown")
	current_structure_data = structure_data
	print("[ENHANCED_INFO_PANEL] Displaying enhanced data for: " + current_structure_id)
	
	# Show panel with sophisticated animation
	if not visible:
		_animate_enhanced_entrance()
	
	# Update all content sections
	_update_enhanced_content(structure_data)
	_update_learning_progress()
	_update_difficulty_assessment()
	_update_reading_time_estimate()

func _update_enhanced_content(structure_data: Dictionary) -> void:
	"""Update content with enhanced formatting and features"""
	# Update structure name with enhanced styling
	if structure_name_label:
		var display_name = structure_data.get("displayName", "Unknown Structure")
		structure_name_label.text = display_name
		UIThemeManager.animate_fade_text_change(structure_name_label, display_name)
	
	# Update ID badge
	if structure_id_badge:
		structure_id_badge.text = "ID: " + current_structure_id
		structure_id_badge.visible = true
	
	# Update description with enhanced formatting
	if description_text:
		var description = structure_data.get("shortDescription", "No description available.")
		description_text.text = _format_enhanced_rich_text(description)
	
	# Update functions with visual enhancements
	var functions = structure_data.get("functions", [])
	_update_enhanced_functions(functions)
	
	# Update related structures (mock data for now)
	_update_related_structures()

func _format_enhanced_rich_text(text: String) -> String:
	"""Enhanced text formatting with educational focus"""
	var formatted = "[font_size=%d][color=%s]%s[/color][/font_size]" % [
		UIThemeManager.FONT_SIZE_MEDIUM,
		UIThemeManager.TEXT_PRIMARY.to_html(),
		text
	]
	
	# Enhanced term highlighting with categories
	var anatomical_terms = {
		"brain": UIThemeManager.ACCENT_BLUE,
		"cortex": UIThemeManager.ACCENT_BLUE,
		"neuron": UIThemeManager.ACCENT_CYAN,
		"cerebral": UIThemeManager.ACCENT_BLUE,
		"temporal": UIThemeManager.ACCENT_TEAL,
		"frontal": UIThemeManager.ACCENT_TEAL,
		"parietal": UIThemeManager.ACCENT_TEAL,
		"occipital": UIThemeManager.ACCENT_TEAL,
		"hippocampus": UIThemeManager.ACCENT_PURPLE,
		"amygdala": UIThemeManager.ACCENT_PINK,
		"thalamus": UIThemeManager.ACCENT_ORANGE,
		"cerebellum": UIThemeManager.ACCENT_GREEN,
		"brainstem": UIThemeManager.ACCENT_GREEN
	}
	
	for term in anatomical_terms:
		var color = anatomical_terms[term]
		var regex = RegEx.new()
		regex.compile("(?i)\\b" + term + "\\b")
		var replacement = "[color=%s][b]$0[/b][/color]" % color.to_html()
		formatted = regex.sub(formatted, replacement, true)
	
	return formatted

func _update_enhanced_functions(functions_array: Array) -> void:
	"""Update functions with enhanced visual design"""
	_clear_functions()
	
	if functions_array.is_empty():
		var placeholder = Label.new()
		placeholder.text = "🔍 No function information available"
		UIThemeManager.apply_modern_label(placeholder, UIThemeManager.FONT_SIZE_SMALL, UIThemeManager.TEXT_TERTIARY)
		functions_list.add_child(placeholder)
		return
	
	# Create enhanced function items
	for i in range(functions_array.size()):
		var function_text = str(functions_array[i])
		var function_card = _create_enhanced_function_card(function_text, i)
		functions_list.add_child(function_card)
		
		# Staggered entrance animation
		UIThemeManager.animate_entrance(function_card, i * 0.1, UIThemeManager.ANIM_DURATION_STANDARD, "slide_up")

func _create_enhanced_function_card(text: String, index: int) -> Control:
	"""Create sophisticated function card with visual indicators"""
	var card = PanelContainer.new()
	var card_style = UIThemeManager.create_educational_card_style("info")
	card.add_theme_stylebox_override("panel", card_style)
	
	var container = HBoxContainer.new()
	container.add_theme_constant_override("separation", UIThemeManager.MARGIN_MEDIUM)
	card.add_child(container)
	
	# Function icon/indicator
	var icon_label = Label.new()
	var function_icons = ["⚡", "🎯", "🔄", "📡", "🧠", "💫", "🌟", "⚙️"]
	icon_label.text = function_icons[index % function_icons.size()]
	UIThemeManager.apply_modern_label(icon_label, UIThemeManager.FONT_SIZE_LARGE, UIThemeManager.ACCENT_CYAN)
	icon_label.custom_minimum_size.x = 32
	container.add_child(icon_label)
	
	# Function text
	var text_label = Label.new()
	text_label.text = text
	text_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	UIThemeManager.apply_modern_label(text_label, UIThemeManager.FONT_SIZE_SMALL, UIThemeManager.TEXT_PRIMARY)
	container.add_child(text_label)
	
	# Add subtle hover effect
	card.mouse_entered.connect(func(): UIThemeManager.animate_hover_glow(card, UIThemeManager.ACCENT_BLUE, 0.1))
	card.mouse_exited.connect(func(): UIThemeManager.animate_hover_glow_off(card))
	
	return card

func _update_related_structures() -> void:
	"""Update related structures with interactive chips"""
	# Clear existing chips
	for child in related_chips_container.get_children():
		child.queue_free()
	
	# Mock related structures based on current structure
	var related_structures = _get_mock_related_structures()
	
	if related_structures.size() > 0:
		related_section.visible = true
		
		for structure in related_structures:
			var chip = _create_structure_chip(structure)
			related_chips_container.add_child(chip)
	else:
		related_section.visible = false

func _create_structure_chip(structure_name: String) -> Button:
	"""Create interactive structure navigation chip"""
	var chip = Button.new()
	chip.text = structure_name
	chip.flat = false
	
	# Apply chip styling
	UIThemeManager.apply_modern_button(chip, UIThemeManager.ACCENT_TEAL, "small")
	
	# Connect navigation
	chip.pressed.connect(func(): emit_signal("related_structure_selected", structure_name))
	
	return chip

func _get_mock_related_structures() -> Array:
	"""Get mock related structures (replace with real data)"""
	var related_mapping = {
		"Hippocampus": ["Amygdala", "Temporal Cortex", "Fornix"],
		"Thalamus": ["Hypothalamus", "Cortex", "Brainstem"],
		"Striatum": ["Substantia Nigra", "Globus Pallidus", "Cortex"]
	}
	
	return related_mapping.get(current_structure_data.get("displayName", ""), [])

func _update_learning_progress() -> void:
	"""Update learning progress indicators"""
	# Mock progress calculation
	var completed_items = 0
	var total_items = 4  # viewed, quiz, notes, bookmark
	
	if learning_progress.get("viewed", false):
		completed_items += 1
	if learning_progress.get("quiz_completed", false):
		completed_items += 1
	if learning_progress.get("notes_taken", false):
		completed_items += 1
	if learning_progress.get("bookmarked", false):
		completed_items += 1
	
	var progress_data = UIThemeManager.create_learning_progress_indicator(0.0, total_items, completed_items)
	
	# Update progress bar
	if progress_bar:
		progress_bar.value = progress_data["percentage"]
		UIThemeManager.apply_progress_bar_styling(progress_bar, progress_data["color"])
	
	# Update progress label
	if progress_label:
		progress_label.text = "%d%%" % int(progress_data["percentage"])
		UIThemeManager.apply_modern_label(progress_label, UIThemeManager.FONT_SIZE_SMALL, progress_data["color"])

func _update_difficulty_assessment() -> void:
	"""Update difficulty indicator based on content complexity"""
	var difficulty = _assess_content_difficulty()
	var difficulty_data = difficulty_levels.get(difficulty, difficulty_levels["beginner"])
	
	if difficulty_indicator:
		var icon = "🟢" if difficulty == "beginner" else "🟡" if difficulty == "intermediate" else "🔴"
		difficulty_indicator.text = icon + " " + difficulty_data["text"]
		UIThemeManager.apply_modern_label(difficulty_indicator, UIThemeManager.FONT_SIZE_SMALL, difficulty_data["color"])

func _assess_content_difficulty() -> String:
	"""Assess content difficulty based on text complexity"""
	var description = current_structure_data.get("shortDescription", "")
	var functions = current_structure_data.get("functions", [])
	
	var total_words = description.split(" ").size()
	for function_item in functions:
		total_words += str(function_item).split(" ").size()
	
	# Simple heuristic
	if total_words < 50:
		return "beginner"
	elif total_words < 100:
		return "intermediate"
	else:
		return "advanced"

func _update_reading_time_estimate() -> void:
	"""Update estimated reading time"""
	var description = current_structure_data.get("shortDescription", "")
	var functions = current_structure_data.get("functions", [])
	
	var total_words = description.split(" ").size()
	for function_item in functions:
		total_words += str(function_item).split(" ").size()
	
	# Average reading speed: 200 words per minute
	var reading_time_minutes = max(1, int(total_words / 200.0 * 60))
	
	if reading_time_label:
		reading_time_label.text = "⏱️ %d min read" % reading_time_minutes

func _animate_enhanced_entrance() -> void:
	"""Enhanced entrance animation with educational feel"""
	if is_animating:
		return
	
	is_animating = true
	UIThemeManager.animate_entrance(self, 0.0, UIThemeManager.ANIM_DURATION_STANDARD, "slide_left")
	
	# Animate content sections sequentially
	get_tree().create_timer(0.1).timeout.connect(func():
		if header_container:
			UIThemeManager.animate_entrance(header_container, 0.0, UIThemeManager.ANIM_DURATION_FAST, "fade_scale")
	)
	
	get_tree().create_timer(0.2).timeout.connect(func():
		if description_section:
			UIThemeManager.animate_entrance(description_section, 0.0, UIThemeManager.ANIM_DURATION_FAST, "slide_up")
	)
	
	get_tree().create_timer(0.3).timeout.connect(func():
		is_animating = false
	)

func clear_data() -> void:
	"""Clear panel content with enhanced feedback"""
	current_structure_id = ""
	current_structure_data = {}
	
	if structure_name_label:
		structure_name_label.text = "Brain Structure Information"
	
	if structure_id_badge:
		structure_id_badge.visible = false
	
	if description_text:
		description_text.text = "[center][font_size=%d][color=%s][i]Select a brain structure to explore detailed information, functions, and learning resources.[/i][/color][/font_size][/center]" % [
			UIThemeManager.FONT_SIZE_MEDIUM,
			UIThemeManager.TEXT_TERTIARY.to_html()
		]
	
	_clear_functions()
	related_section.visible = false
	_reset_learning_progress()
	visible = false

func _clear_functions() -> void:
	"""Clear functions list safely"""
	if not functions_list:
		return
	
	for child in functions_list.get_children():
		functions_list.remove_child(child)
		child.queue_free()

func _reset_learning_progress() -> void:
	"""Reset learning progress indicators"""
	if progress_bar:
		progress_bar.value = 0
	if progress_label:
		progress_label.text = "0%"

# Enhanced signal handlers
func _on_close_pressed() -> void:
	"""Handle close with enhanced animation"""
	UIThemeManager.animate_exit(self, UIThemeManager.ANIM_DURATION_FAST, "slide_right")
	get_tree().create_timer(UIThemeManager.ANIM_DURATION_FAST).timeout.connect(func():
		emit_signal("panel_closed")
	)

func _on_bookmark_pressed() -> void:
	"""Handle bookmark toggle with visual feedback"""
	is_bookmarked = !is_bookmarked
	learning_progress["bookmarked"] = is_bookmarked
	
	# Update button appearance
	bookmark_button.text = "⭐" if is_bookmarked else "☆"
	UIThemeManager.animate_button_press(bookmark_button, UIThemeManager.ACCENT_YELLOW)
	
	# Update learning progress
	_update_learning_progress()
	
	emit_signal("structure_bookmarked", current_structure_id, is_bookmarked)

func _on_share_pressed() -> void:
	"""Handle share/export functionality"""
	UIThemeManager.animate_button_press(share_button, UIThemeManager.ACCENT_BLUE)
	# TODO: Implement share functionality

func _on_quiz_pressed() -> void:
	"""Handle quiz request with educational feedback"""
	UIThemeManager.animate_button_press(quiz_button, UIThemeManager.ACCENT_GREEN)
	emit_signal("quiz_requested", current_structure_id)

func _on_notes_pressed() -> void:
	"""Handle notes request"""
	UIThemeManager.animate_button_press(notes_button, UIThemeManager.ACCENT_PURPLE)
	learning_progress["notes_taken"] = true
	_update_learning_progress()
	emit_signal("notes_requested", current_structure_id)

func _on_search_submitted(text: String) -> void:
	"""Handle search submission"""
	emit_signal("search_performed", text)

func _on_search_text_changed(text: String) -> void:
	"""Handle real-time search updates"""
	# TODO: Implement live search suggestions
	pass

func _on_search_clear() -> void:
	"""Clear search field"""
	search_field.text = ""
	search_field.grab_focus()

# Public interface enhancements
func show_search_section() -> void:
	"""Show search functionality"""
	search_container.visible = true
	UIThemeManager.animate_entrance(search_container, 0.0, UIThemeManager.ANIM_DURATION_FAST, "slide_up")

func hide_search_section() -> void:
	"""Hide search functionality"""
	UIThemeManager.animate_exit(search_container, UIThemeManager.ANIM_DURATION_FAST, "slide_down")

func update_bookmark_status(bookmarked: bool) -> void:
	"""Update bookmark status from external source"""
	is_bookmarked = bookmarked
	learning_progress["bookmarked"] = bookmarked
	bookmark_button.text = "⭐" if bookmarked else "☆"
	_update_learning_progress()

func mark_structure_viewed() -> void:
	"""Mark structure as viewed for progress tracking"""
	learning_progress["viewed"] = true
	_update_learning_progress()

func mark_quiz_completed() -> void:
	"""Mark quiz as completed"""
	learning_progress["quiz_completed"] = true
	_update_learning_progress()

# Cleanup
func dispose() -> void:
	"""Enhanced cleanup"""
	clear_data()

func _exit_tree() -> void:
	"""Cleanup on removal"""
	dispose()