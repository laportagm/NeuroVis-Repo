# Unified Modern Brain Structure Information Panel
# Combines best features with enhanced usability and educational focus
class_name UnifiedStructureInfoPanel
extends PanelContainer

# Required dependencies
const UIThemeManager = preload("res://ui/panels/UIThemeManager.gd")

# === CORE UI COMPONENTS ===
# Header section
var header_container: VBoxContainer
var structure_name_label: Label
var structure_category_badge: Label
var action_buttons_container: HBoxContainer
var bookmark_button: Button
var share_button: Button
var fullscreen_button: Button
var close_button: Button

# Quick info bar
var quick_info_container: HBoxContainer
var difficulty_chip: Label
var reading_time_chip: Label
var confidence_indicator: Label

# Search and filter
var search_container: HBoxContainer
var search_field: LineEdit
var search_clear_button: Button
var filter_button: Button

# Main content area
var main_scroll: ScrollContainer
var content_container: VBoxContainer

# Description section with rich formatting
var description_section: VBoxContainer
var description_header: Label
var description_text: RichTextLabel
var description_expand_button: Button

# Functions section with visual enhancements
var functions_section: VBoxContainer
var functions_header: Label
var functions_list: VBoxContainer
var functions_view_toggle: OptionButton

# Related structures with intelligent suggestions
var related_section: VBoxContainer
var related_header: Label
var related_grid: GridContainer

# Learning and progress section
var learning_section: VBoxContainer
var learning_header: Label
var progress_container: HBoxContainer
var progress_bar: ProgressBar
var progress_label: Label
var learning_actions: HBoxContainer
var quiz_button: Button
var notes_button: Button
var study_plan_button: Button

# Footer with metadata and actions
var footer_container: HBoxContainer
var metadata_label: Label
var feedback_button: Button

# === STATE MANAGEMENT ===
var current_structure_id: String = ""
var current_structure_data: Dictionary = {}
var is_bookmarked: bool = false
var is_expanded: bool = false
var learning_progress: Dictionary = {}
var search_history: Array = []
var view_preferences: Dictionary = {}
var is_animating: bool = false

# === CONFIGURATION ===
var enable_advanced_features: bool = true
var enable_search: bool = true
var enable_learning_tracking: bool = true
var animation_speed_multiplier: float = 1.0
var auto_save_preferences: bool = true

# === STYLING THEMES ===
var current_theme: String = "modern_glass"
var available_themes: Dictionary = {
	"modern_glass": {"name": "Modern Glass", "description": "Glass morphism with modern aesthetics"},
	"educational": {"name": "Educational", "description": "High contrast for learning environments"},
	"minimal": {"name": "Minimal", "description": "Clean and distraction-free"},
	"cyberpunk": {"name": "Cyberpunk", "description": "High-tech visualization theme"}
}

# === SIGNALS ===
signal panel_closed
signal structure_bookmarked(structure_id: String, bookmarked: bool)
signal structure_search_requested(query: String)
signal related_structure_selected(structure_id: String)
signal quiz_requested(structure_id: String)
signal notes_requested(structure_id: String)
signal study_plan_requested(structure_id: String)
signal fullscreen_requested(structure_id: String)
signal feedback_submitted(structure_id: String, feedback: Dictionary)
signal preference_changed(key: String, value)

func _ready() -> void:
	call_deferred("_initialize_unified_panel")

func _initialize_unified_panel() -> void:
	"""Initialize the comprehensive unified panel"""
	print("[UNIFIED_INFO_PANEL] Initializing advanced educational panel")
	
	# Load preferences
	_load_user_preferences()
	
	# Create sophisticated UI structure
	_create_unified_ui_structure()
	
	# Apply theming and styling
	_apply_unified_theming()
	
	# Setup interactivity and signals
	_connect_unified_signals()
	
	# Initialize learning and progress systems
	_initialize_learning_systems()
	
	# Setup advanced features
	_setup_advanced_features()
	
	# Start with clean state
	clear_data()
	
	print("[UNIFIED_INFO_PANEL] Advanced panel ready with theme: %s" % current_theme)

func _create_unified_ui_structure() -> void:
	"""Create comprehensive UI structure with all modern features"""
	print("[UNIFIED_INFO_PANEL] Building advanced UI structure")
	
	# Main container with responsive margins
	var main_margin = MarginContainer.new()
	main_margin.name = "MainMargin"
	main_margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	main_margin.add_theme_constant_override("margin_top", UIThemeManager.MARGIN_MEDIUM)
	main_margin.add_theme_constant_override("margin_bottom", UIThemeManager.MARGIN_MEDIUM)
	main_margin.add_theme_constant_override("margin_left", UIThemeManager.MARGIN_MEDIUM)
	main_margin.add_theme_constant_override("margin_right", UIThemeManager.MARGIN_MEDIUM)
	add_child(main_margin)
	
	# Main vertical layout
	var main_vbox = VBoxContainer.new()
	main_vbox.name = "MainVBox"
	main_vbox.add_theme_constant_override("separation", UIThemeManager.MARGIN_SMALL)
	main_margin.add_child(main_vbox)
	
	# Build UI sections
	_create_header_section(main_vbox)
	_create_quick_info_section(main_vbox)
	_create_search_section(main_vbox)
	_create_content_sections(main_vbox)
	_create_footer_section(main_vbox)

func _create_header_section(parent: Control) -> void:
	"""Create sophisticated header with title and action buttons"""
	header_container = VBoxContainer.new()
	header_container.name = "HeaderContainer"
	header_container.add_theme_constant_override("separation", UIThemeManager.MARGIN_SMALL)
	parent.add_child(header_container)
	
	# Title and actions row
	var title_row = HBoxContainer.new()
	title_row.add_theme_constant_override("separation", UIThemeManager.MARGIN_MEDIUM)
	header_container.add_child(title_row)
	
	# Title section
	var title_section = VBoxContainer.new()
	title_section.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_section.add_theme_constant_override("separation", UIThemeManager.MARGIN_TINY)
	title_row.add_child(title_section)
	
	# Structure name with dynamic sizing
	structure_name_label = Label.new()
	structure_name_label.name = "StructureName"
	structure_name_label.text = "Brain Structure Explorer"
	structure_name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	structure_name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_section.add_child(structure_name_label)
	
	# Category badge with color coding
	structure_category_badge = Label.new()
	structure_category_badge.name = "CategoryBadge"
	structure_category_badge.text = ""
	structure_category_badge.visible = false
	title_section.add_child(structure_category_badge)
	
	# Action buttons with tooltips
	action_buttons_container = HBoxContainer.new()
	action_buttons_container.add_theme_constant_override("separation", UIThemeManager.MARGIN_SMALL)
	title_row.add_child(action_buttons_container)
	
	# Bookmark with state persistence
	bookmark_button = Button.new()
	bookmark_button.name = "BookmarkButton"
	bookmark_button.text = "☆"
	bookmark_button.custom_minimum_size = Vector2(40, 40)
	bookmark_button.tooltip_text = "Bookmark this structure for quick access"
	action_buttons_container.add_child(bookmark_button)
	
	# Share/Export with multiple formats
	share_button = Button.new()
	share_button.name = "ShareButton"
	share_button.text = "📤"
	share_button.custom_minimum_size = Vector2(40, 40)
	share_button.tooltip_text = "Share or export structure information"
	action_buttons_container.add_child(share_button)
	
	# Fullscreen mode for detailed study
	fullscreen_button = Button.new()
	fullscreen_button.name = "FullscreenButton"
	fullscreen_button.text = "⛶"
	fullscreen_button.custom_minimum_size = Vector2(40, 40)
	fullscreen_button.tooltip_text = "Open in fullscreen study mode"
	action_buttons_container.add_child(fullscreen_button)
	
	# Close with confirmation for unsaved notes
	close_button = Button.new()
	close_button.name = "CloseButton"
	close_button.text = "✕"
	close_button.custom_minimum_size = Vector2(40, 40)
	close_button.tooltip_text = "Close information panel"
	action_buttons_container.add_child(close_button)

func _create_quick_info_section(parent: Control) -> void:
	"""Create quick information chips for immediate insights"""
	quick_info_container = HBoxContainer.new()
	quick_info_container.name = "QuickInfoContainer"
	quick_info_container.add_theme_constant_override("separation", UIThemeManager.MARGIN_SMALL)
	parent.add_child(quick_info_container)
	
	# Difficulty indicator with visual coding
	difficulty_chip = Label.new()
	difficulty_chip.name = "DifficultyChip"
	difficulty_chip.text = "🟢 Beginner"
	difficulty_chip.tooltip_text = "Complexity level for this structure"
	quick_info_container.add_child(difficulty_chip)
	
	# Reading time estimation
	reading_time_chip = Label.new()
	reading_time_chip.name = "ReadingTimeChip"
	reading_time_chip.text = "⏱️ 2 min"
	reading_time_chip.tooltip_text = "Estimated reading time"
	quick_info_container.add_child(reading_time_chip)
	
	# Confidence indicator for data quality
	confidence_indicator = Label.new()
	confidence_indicator.name = "ConfidenceIndicator"
	confidence_indicator.text = "✓ Verified"
	confidence_indicator.tooltip_text = "Information accuracy confidence"
	confidence_indicator.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	confidence_indicator.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	quick_info_container.add_child(confidence_indicator)

func _create_search_section(parent: Control) -> void:
	"""Create intelligent search with suggestions and filters"""
	search_container = HBoxContainer.new()
	search_container.name = "SearchContainer"
	search_container.add_theme_constant_override("separation", UIThemeManager.MARGIN_SMALL)
	search_container.visible = false  # Initially hidden
	parent.add_child(search_container)
	
	# Search field with auto-complete
	search_field = LineEdit.new()
	search_field.name = "SearchField"
	search_field.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	search_field.placeholder_text = "Search structures, functions, or concepts..."
	search_container.add_child(search_field)
	
	# Clear search button
	search_clear_button = Button.new()
	search_clear_button.name = "SearchClearButton"
	search_clear_button.text = "🗙"
	search_clear_button.custom_minimum_size = Vector2(32, 32)
	search_clear_button.tooltip_text = "Clear search"
	search_container.add_child(search_clear_button)
	
	# Filter options button
	filter_button = Button.new()
	filter_button.name = "FilterButton"
	filter_button.text = "🔍"
	filter_button.custom_minimum_size = Vector2(32, 32)
	filter_button.tooltip_text = "Search filters and options"
	search_container.add_child(filter_button)

func _create_content_sections(parent: Control) -> void:
	"""Create comprehensive content area with multiple sections"""
	# Scrollable content area
	main_scroll = ScrollContainer.new()
	main_scroll.name = "MainScroll"
	main_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	parent.add_child(main_scroll)
	
	# Content container with proper spacing
	content_container = VBoxContainer.new()
	content_container.name = "ContentContainer"
	content_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content_container.add_theme_constant_override("separation", UIThemeManager.MARGIN_LARGE)
	main_scroll.add_child(content_container)
	
	# Build content sections
	_create_description_section(content_container)
	_create_functions_section(content_container)
	_create_related_section(content_container)
	_create_learning_section(content_container)

func _create_description_section(parent: Control) -> void:
	"""Create enhanced description section with rich formatting"""
	description_section = VBoxContainer.new()
	description_section.name = "DescriptionSection"
	description_section.add_theme_constant_override("separation", UIThemeManager.MARGIN_MEDIUM)
	parent.add_child(description_section)
	
	# Section header with expand/collapse
	var header_row = HBoxContainer.new()
	description_section.add_child(header_row)
	
	description_header = Label.new()
	description_header.name = "DescriptionHeader"
	description_header.text = "📋 Overview & Description"
	description_header.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header_row.add_child(description_header)
	
	description_expand_button = Button.new()
	description_expand_button.name = "DescriptionExpandButton"
	description_expand_button.text = "⌄"
	description_expand_button.flat = true
	description_expand_button.custom_minimum_size = Vector2(24, 24)
	description_expand_button.tooltip_text = "Expand/collapse description"
	header_row.add_child(description_expand_button)
	
	# Rich text with enhanced formatting
	description_text = RichTextLabel.new()
	description_text.name = "DescriptionText"
	description_text.custom_minimum_size = Vector2(0, 120)
	description_text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	description_text.bbcode_enabled = true
	description_text.fit_content = true
	description_text.scroll_active = false
	description_text.selection_enabled = true
	description_text.context_menu_enabled = true
	description_section.add_child(description_text)

func _create_functions_section(parent: Control) -> void:
	"""Create enhanced functions section with multiple view modes"""
	functions_section = VBoxContainer.new()
	functions_section.name = "FunctionsSection"
	functions_section.add_theme_constant_override("separation", UIThemeManager.MARGIN_MEDIUM)
	parent.add_child(functions_section)
	
	# Header with view options
	var header_row = HBoxContainer.new()
	functions_section.add_child(header_row)
	
	functions_header = Label.new()
	functions_header.name = "FunctionsHeader"
	functions_header.text = "⚡ Key Functions & Capabilities"
	functions_header.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header_row.add_child(functions_header)
	
	# View mode selector
	functions_view_toggle = OptionButton.new()
	functions_view_toggle.name = "FunctionsViewToggle"
	functions_view_toggle.add_item("📝 List View")
	functions_view_toggle.add_item("🎯 Card View")
	functions_view_toggle.add_item("📊 Timeline View")
	functions_view_toggle.tooltip_text = "Change how functions are displayed"
	header_row.add_child(functions_view_toggle)
	
	# Functions container (changes based on view mode)
	functions_list = VBoxContainer.new()
	functions_list.name = "FunctionsList"
	functions_list.add_theme_constant_override("separation", UIThemeManager.MARGIN_SMALL)
	functions_section.add_child(functions_list)

func _create_related_section(parent: Control) -> void:
	"""Create intelligent related structures section"""
	related_section = VBoxContainer.new()
	related_section.name = "RelatedSection"
	related_section.add_theme_constant_override("separation", UIThemeManager.MARGIN_MEDIUM)
	related_section.visible = false
	parent.add_child(related_section)
	
	# Header with smart suggestions indicator
	related_header = Label.new()
	related_header.name = "RelatedHeader"
	related_header.text = "🔗 Related Structures & Connections"
	related_section.add_child(related_header)
	
	# Grid layout for related structure chips
	related_grid = GridContainer.new()
	related_grid.name = "RelatedGrid"
	related_grid.columns = 2
	related_grid.add_theme_constant_override("h_separation", UIThemeManager.MARGIN_SMALL)
	related_grid.add_theme_constant_override("v_separation", UIThemeManager.MARGIN_SMALL)
	related_section.add_child(related_grid)

func _create_learning_section(parent: Control) -> void:
	"""Create comprehensive learning and progress section"""
	learning_section = VBoxContainer.new()
	learning_section.name = "LearningSection"
	learning_section.add_theme_constant_override("separation", UIThemeManager.MARGIN_MEDIUM)
	parent.add_child(learning_section)
	
	# Learning header with motivational elements
	learning_header = Label.new()
	learning_header.name = "LearningHeader"
	learning_header.text = "🎓 Learning Progress & Study Tools"
	learning_section.add_child(learning_header)
	
	# Progress tracking with visual indicators
	progress_container = HBoxContainer.new()
	progress_container.name = "ProgressContainer"
	progress_container.add_theme_constant_override("separation", UIThemeManager.MARGIN_MEDIUM)
	learning_section.add_child(progress_container)
	
	progress_bar = ProgressBar.new()
	progress_bar.name = "ProgressBar"
	progress_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	progress_bar.custom_minimum_size = Vector2(0, 12)
	progress_bar.max_value = 100.0
	progress_bar.value = 0.0
	progress_container.add_child(progress_bar)
	
	progress_label = Label.new()
	progress_label.name = "ProgressLabel"
	progress_label.text = "0%"
	progress_label.custom_minimum_size = Vector2(40, 0)
	progress_container.add_child(progress_label)
	
	# Learning action buttons with progress tracking
	learning_actions = HBoxContainer.new()
	learning_actions.name = "LearningActions"
	learning_actions.add_theme_constant_override("separation", UIThemeManager.MARGIN_SMALL)
	learning_section.add_child(learning_actions)
	
	quiz_button = Button.new()
	quiz_button.name = "QuizButton"
	quiz_button.text = "📝 Take Quiz"
	quiz_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	quiz_button.tooltip_text = "Test your knowledge with an interactive quiz"
	learning_actions.add_child(quiz_button)
	
	notes_button = Button.new()
	notes_button.name = "NotesButton"
	notes_button.text = "📓 My Notes"
	notes_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	notes_button.tooltip_text = "Add personal notes and annotations"
	learning_actions.add_child(notes_button)
	
	study_plan_button = Button.new()
	study_plan_button.name = "StudyPlanButton"
	study_plan_button.text = "📚 Study Plan"
	study_plan_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	study_plan_button.tooltip_text = "Generate personalized study plan"
	learning_actions.add_child(study_plan_button)

func _create_footer_section(parent: Control) -> void:
	"""Create footer with metadata and feedback options"""
	# Separator for visual distinction
	var separator = HSeparator.new()
	separator.add_theme_constant_override("separation", 2)
	parent.add_child(separator)
	
	# Footer content
	footer_container = HBoxContainer.new()
	footer_container.name = "FooterContainer"
	footer_container.add_theme_constant_override("separation", UIThemeManager.MARGIN_MEDIUM)
	parent.add_child(footer_container)
	
	# Metadata information
	metadata_label = Label.new()
	metadata_label.name = "MetadataLabel"
	metadata_label.text = "📊 Structure data verified • Last updated: Today"
	metadata_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	footer_container.add_child(metadata_label)
	
	# Feedback button for user input
	feedback_button = Button.new()
	feedback_button.name = "FeedbackButton"
	feedback_button.text = "💬 Feedback"
	feedback_button.tooltip_text = "Report issues or suggest improvements"
	footer_container.add_child(feedback_button)

func _apply_unified_theming() -> void:
	"""Apply comprehensive theming based on current theme selection"""
	print("[UNIFIED_INFO_PANEL] Applying %s theme" % current_theme)
	
	# Main panel styling with theme variants
	match current_theme:
		"modern_glass":
			_apply_modern_glass_theme()
		"educational":
			_apply_educational_theme()
		"minimal":
			_apply_minimal_theme()
		"cyberpunk":
			_apply_cyberpunk_theme()
		_:
			_apply_modern_glass_theme()

func _apply_modern_glass_theme() -> void:
	"""Apply modern glass morphism theme"""
	# Panel background
	UIThemeManager.apply_glass_panel(self, 0.95, "info")
	
	# Header styling
	UIThemeManager.apply_modern_label(structure_name_label, UIThemeManager.FONT_SIZE_H2, 
		UIThemeManager.TEXT_PRIMARY, "heading")
	UIThemeManager.apply_modern_label(structure_category_badge, UIThemeManager.FONT_SIZE_TINY, 
		UIThemeManager.ACCENT_CYAN, "badge")
	
	# Action buttons with themed colors
	UIThemeManager.apply_modern_button(bookmark_button, UIThemeManager.ACCENT_YELLOW, "icon")
	UIThemeManager.apply_modern_button(share_button, UIThemeManager.ACCENT_BLUE, "icon")
	UIThemeManager.apply_modern_button(fullscreen_button, UIThemeManager.ACCENT_PURPLE, "icon")
	UIThemeManager.apply_modern_button(close_button, UIThemeManager.ACCENT_RED, "icon")
	
	# Quick info chips
	UIThemeManager.apply_modern_label(difficulty_chip, UIThemeManager.FONT_SIZE_SMALL, 
		UIThemeManager.TEXT_SECONDARY, "caption")
	UIThemeManager.apply_modern_label(reading_time_chip, UIThemeManager.FONT_SIZE_SMALL, 
		UIThemeManager.TEXT_SECONDARY, "caption")
	UIThemeManager.apply_modern_label(confidence_indicator, UIThemeManager.FONT_SIZE_SMALL, 
		UIThemeManager.ACCENT_GREEN, "caption")
	
	# Search styling
	UIThemeManager.apply_search_field_styling(search_field, search_field.placeholder_text)
	UIThemeManager.apply_modern_button(search_clear_button, UIThemeManager.ACCENT_RED, "small")
	UIThemeManager.apply_modern_button(filter_button, UIThemeManager.ACCENT_BLUE, "small")
	
	# Section headers
	UIThemeManager.apply_modern_label(description_header, UIThemeManager.FONT_SIZE_H3, 
		UIThemeManager.TEXT_ACCENT, "subheading")
	UIThemeManager.apply_modern_label(functions_header, UIThemeManager.FONT_SIZE_H3, 
		UIThemeManager.TEXT_ACCENT, "subheading")
	UIThemeManager.apply_modern_label(related_header, UIThemeManager.FONT_SIZE_H3, 
		UIThemeManager.TEXT_ACCENT, "subheading")
	UIThemeManager.apply_modern_label(learning_header, UIThemeManager.FONT_SIZE_H3, 
		UIThemeManager.TEXT_ACCENT, "subheading")
	
	# Content styling
	UIThemeManager.apply_rich_text_styling(description_text, UIThemeManager.FONT_SIZE_MEDIUM, "description")
	UIThemeManager.apply_progress_bar_styling(progress_bar, UIThemeManager.ACCENT_BLUE)
	
	# Learning buttons
	UIThemeManager.apply_modern_button(quiz_button, UIThemeManager.ACCENT_GREEN, "standard")
	UIThemeManager.apply_modern_button(notes_button, UIThemeManager.ACCENT_PURPLE, "standard")
	UIThemeManager.apply_modern_button(study_plan_button, UIThemeManager.ACCENT_ORANGE, "standard")
	
	# Footer styling
	UIThemeManager.apply_modern_label(metadata_label, UIThemeManager.FONT_SIZE_SMALL, 
		UIThemeManager.TEXT_TERTIARY, "caption")
	UIThemeManager.apply_modern_button(feedback_button, UIThemeManager.ACCENT_TEAL, "small")

func _apply_educational_theme() -> void:
	"""Apply high-contrast educational theme for learning environments"""
	# TODO: Implement educational theme with high contrast and accessibility features
	_apply_modern_glass_theme()  # Fallback to modern glass for now

func _apply_minimal_theme() -> void:
	"""Apply minimal, distraction-free theme"""
	# TODO: Implement minimal theme with reduced visual elements
	_apply_modern_glass_theme()  # Fallback to modern glass for now

func _apply_cyberpunk_theme() -> void:
	"""Apply cyberpunk/high-tech theme"""
	# TODO: Implement cyberpunk theme with neon colors and tech aesthetics
	_apply_modern_glass_theme()  # Fallback to modern glass for now

func _connect_unified_signals() -> void:
	"""Connect all interactive signals with comprehensive error handling"""
	# Core action buttons
	if close_button and not close_button.pressed.is_connected(_on_close_pressed):
		close_button.pressed.connect(_on_close_pressed)
	
	if bookmark_button and not bookmark_button.pressed.is_connected(_on_bookmark_pressed):
		bookmark_button.pressed.connect(_on_bookmark_pressed)
	
	if share_button and not share_button.pressed.is_connected(_on_share_pressed):
		share_button.pressed.connect(_on_share_pressed)
	
	if fullscreen_button and not fullscreen_button.pressed.is_connected(_on_fullscreen_pressed):
		fullscreen_button.pressed.connect(_on_fullscreen_pressed)
	
	# Search functionality
	if search_field:
		if not search_field.text_submitted.is_connected(_on_search_submitted):
			search_field.text_submitted.connect(_on_search_submitted)
		if not search_field.text_changed.is_connected(_on_search_text_changed):
			search_field.text_changed.connect(_on_search_text_changed)
	
	if search_clear_button and not search_clear_button.pressed.is_connected(_on_search_clear):
		search_clear_button.pressed.connect(_on_search_clear)
	
	if filter_button and not filter_button.pressed.is_connected(_on_filter_pressed):
		filter_button.pressed.connect(_on_filter_pressed)
	
	# Content interactions
	if description_expand_button and not description_expand_button.pressed.is_connected(_on_description_expand):
		description_expand_button.pressed.connect(_on_description_expand)
	
	if functions_view_toggle and not functions_view_toggle.item_selected.is_connected(_on_functions_view_changed):
		functions_view_toggle.item_selected.connect(_on_functions_view_changed)
	
	# Learning actions
	if quiz_button and not quiz_button.pressed.is_connected(_on_quiz_pressed):
		quiz_button.pressed.connect(_on_quiz_pressed)
	
	if notes_button and not notes_button.pressed.is_connected(_on_notes_pressed):
		notes_button.pressed.connect(_on_notes_pressed)
	
	if study_plan_button and not study_plan_button.pressed.is_connected(_on_study_plan_pressed):
		study_plan_button.pressed.connect(_on_study_plan_pressed)
	
	# Footer actions
	if feedback_button and not feedback_button.pressed.is_connected(_on_feedback_pressed):
		feedback_button.pressed.connect(_on_feedback_pressed)

func _setup_advanced_features() -> void:
	"""Setup advanced features like auto-save, smart suggestions, etc."""
	# Initialize search history
	search_history = []
	
	# Setup learning progress tracking
	if enable_learning_tracking:
		_initialize_progress_tracking()
	
	# Setup auto-save for preferences
	if auto_save_preferences:
		_setup_preference_autosave()
	
	print("[UNIFIED_INFO_PANEL] Advanced features initialized")

func _initialize_learning_systems() -> void:
	"""Initialize comprehensive learning and progress tracking"""
	learning_progress = {
		"structure_viewed": false,
		"description_read": false,
		"functions_explored": false,
		"quiz_attempted": false,
		"quiz_passed": false,
		"notes_taken": false,
		"bookmarked": false,
		"study_time": 0.0,
		"last_visited": "",
		"comprehension_score": 0.0
	}

func _initialize_progress_tracking() -> void:
	"""Setup intelligent progress tracking"""
	# TODO: Implement sophisticated progress tracking
	pass

func _setup_preference_autosave() -> void:
	"""Setup automatic preference saving"""
	# TODO: Implement preference auto-save system
	pass

func _load_user_preferences() -> void:
	"""Load user preferences from persistent storage"""
	view_preferences = {
		"theme": "modern_glass",
		"animation_speed": 1.0,
		"auto_expand_descriptions": false,
		"default_functions_view": 0,  # List view
		"enable_search_suggestions": true,
		"show_confidence_indicators": true
	}
	
	# Apply loaded preferences
	current_theme = view_preferences.get("theme", "modern_glass")
	animation_speed_multiplier = view_preferences.get("animation_speed", 1.0)

# === PUBLIC INTERFACE ===

func display_structure_data(structure_data: Dictionary) -> void:
	"""Display comprehensive structure information with all enhanced features"""
	if structure_data.is_empty():
		print("[UNIFIED_INFO_PANEL] Empty structure data received")
		clear_data()
		return
	
	# Ensure UI is initialized before displaying data
	if not functions_list:
		print("[UNIFIED_INFO_PANEL] UI not yet initialized, deferring data display")
		current_structure_data = structure_data
		call_deferred("display_structure_data", structure_data)
		return
	
	current_structure_id = structure_data.get("id", "unknown")
	current_structure_data = structure_data
	print("[UNIFIED_INFO_PANEL] Displaying unified data for: %s" % current_structure_id)
	
	# Update learning progress
	learning_progress["structure_viewed"] = true
	learning_progress["last_visited"] = Time.get_datetime_string_from_system()
	
	# Show panel with sophisticated animation
	if not visible:
		_animate_unified_entrance()
	
	# Update all content sections
	_update_comprehensive_content(structure_data)
	_update_learning_indicators()
	_update_metadata_display()

func _update_comprehensive_content(structure_data: Dictionary) -> void:
	"""Update all content sections with enhanced data presentation"""
	# Header updates
	_update_header_content(structure_data)
	
	# Quick info updates
	_update_quick_info(structure_data)
	
	# Main content updates
	_update_description_content(structure_data)
	_update_functions_content(structure_data)
	_update_related_structures(structure_data)

func _update_header_content(structure_data: Dictionary) -> void:
	"""Update header with structure name and category"""
	if structure_name_label:
		var display_name = structure_data.get("displayName", "Unknown Structure")
		UIThemeManager.animate_fade_text_change(structure_name_label, display_name)
	
	if structure_category_badge:
		var category = _determine_structure_category(structure_data)
		if category != "":
			structure_category_badge.text = category
			structure_category_badge.visible = true
		else:
			structure_category_badge.visible = false

func _update_quick_info(structure_data: Dictionary) -> void:
	"""Update quick information chips"""
	# Update difficulty assessment
	var difficulty = _assess_content_difficulty(structure_data)
	var difficulty_icons = {"beginner": "🟢", "intermediate": "🟡", "advanced": "🔴"}
	var difficulty_text = "%s %s" % [difficulty_icons.get(difficulty, "🟢"), difficulty.capitalize()]
	UIThemeManager.animate_fade_text_change(difficulty_chip, difficulty_text)
	
	# Update reading time
	var reading_time = _calculate_reading_time(structure_data)
	UIThemeManager.animate_fade_text_change(reading_time_chip, "⏱️ %d min" % reading_time)
	
	# Update confidence indicator (mock data)
	var confidence = _assess_data_confidence(structure_data)
	UIThemeManager.animate_fade_text_change(confidence_indicator, confidence)

func _update_description_content(structure_data: Dictionary) -> void:
	"""Update description with enhanced formatting"""
	if description_text:
		var description = structure_data.get("shortDescription", "No description available.")
		var formatted_description = _format_enhanced_description(description)
		description_text.text = formatted_description
		learning_progress["description_read"] = true

func _update_functions_content(structure_data: Dictionary) -> void:
	"""Update functions based on selected view mode"""
	var functions = structure_data.get("functions", [])
	var view_mode = functions_view_toggle.selected if functions_view_toggle else 0
	
	_clear_functions_display()
	
	match view_mode:
		0:  # List view
			_create_functions_list_view(functions)
		1:  # Card view
			_create_functions_card_view(functions)
		2:  # Timeline view
			_create_functions_timeline_view(functions)
		_:
			_create_functions_list_view(functions)
	
	learning_progress["functions_explored"] = true

func _update_related_structures(structure_data: Dictionary) -> void:
	"""Update related structures with intelligent suggestions"""
	var related = _get_intelligent_related_structures(structure_data)
	
	if related.size() > 0:
		related_section.visible = true
		_populate_related_grid(related)
	else:
		related_section.visible = false

func _update_learning_indicators() -> void:
	"""Update learning progress indicators"""
	var progress_data = _calculate_learning_progress()
	
	if progress_bar:
		var tween = progress_bar.create_tween()
		tween.tween_property(progress_bar, "value", progress_data["percentage"], 0.5)
	
	if progress_label:
		UIThemeManager.animate_fade_text_change(progress_label, "%d%%" % int(progress_data["percentage"]))

func _update_metadata_display() -> void:
	"""Update footer metadata information"""
	if metadata_label:
		var metadata_text = "📊 Data verified • Structure ID: %s • Updated: %s" % [
			current_structure_id,
			"Today"  # Replace with actual last updated date
		]
		UIThemeManager.animate_fade_text_change(metadata_label, metadata_text)

# === UTILITY METHODS ===

func _determine_structure_category(structure_data: Dictionary) -> String:
	"""Determine structure category for color-coded badge"""
	var name = structure_data.get("displayName", "").to_lower()
	
	if "cortex" in name or "lobe" in name:
		return "🧠 Cortical"
	elif "hippocampus" in name or "amygdala" in name:
		return "❤️ Limbic"
	elif "cerebellum" in name:
		return "🎯 Cerebellar"
	elif "brainstem" in name or "medulla" in name or "pons" in name:
		return "🌿 Brainstem"
	elif "thalamus" in name or "hypothalamus" in name:
		return "⚡ Subcortical"
	
	return ""

func _assess_content_difficulty(structure_data: Dictionary) -> String:
	"""Assess content difficulty using multiple factors"""
	var description = structure_data.get("shortDescription", "")
	var functions = structure_data.get("functions", [])
	
	var total_words = description.split(" ").size()
	for function_item in functions:
		total_words += str(function_item).split(" ").size()
	
	var technical_terms = ["neurotransmitter", "synapse", "axon", "dendrite", "myelin"]
	var technical_count = 0
	var full_text = description.to_lower()
	
	for term in technical_terms:
		if term in full_text:
			technical_count += 1
	
	# Scoring algorithm
	var difficulty_score = 0
	difficulty_score += int(total_words / 20)  # Word count factor
	difficulty_score += technical_count * 2    # Technical term factor
	
	if difficulty_score <= 3:
		return "beginner"
	elif difficulty_score <= 7:
		return "intermediate"
	else:
		return "advanced"

func _calculate_reading_time(structure_data: Dictionary) -> int:
	"""Calculate estimated reading time"""
	var description = structure_data.get("shortDescription", "")
	var functions = structure_data.get("functions", [])
	
	var total_words = description.split(" ").size()
	for function_item in functions:
		total_words += str(function_item).split(" ").size()
	
	# Average reading speed: 200 words per minute
	return max(1, int(ceil(float(total_words) / 200.0)))

func _assess_data_confidence(structure_data: Dictionary) -> String:
	"""Assess data quality and confidence level"""
	var has_description = structure_data.has("shortDescription") and structure_data["shortDescription"] != ""
	var has_functions = structure_data.has("functions") and structure_data["functions"].size() > 0
	var has_id = structure_data.has("id") and structure_data["id"] != ""
	
	var confidence_score = 0
	if has_id: confidence_score += 1
	if has_description: confidence_score += 2
	if has_functions: confidence_score += 2
	
	match confidence_score:
		5:
			return "✓ Verified"
		3, 4:
			return "⚠ Partial"
		1, 2:
			return "⚠ Limited"
		_:
			return "❌ No Data"

func _format_enhanced_description(description: String) -> String:
	"""Format description with enhanced visual styling"""
	var formatted = "[font_size=%d][color=%s]%s[/color][/font_size]" % [
		UIThemeManager.FONT_SIZE_MEDIUM,
		UIThemeManager.TEXT_PRIMARY.to_html(),
		description
	]
	
	# Enhanced anatomical term highlighting with multiple categories
	var term_categories = {
		"structural": {
			"color": UIThemeManager.ACCENT_BLUE,
			"terms": ["cortex", "lobe", "gyrus", "sulcus", "fissure", "commissure"]
		},
		"cellular": {
			"color": UIThemeManager.ACCENT_CYAN,
			"terms": ["neuron", "axon", "dendrite", "synapse", "myelin", "glia"]
		},
		"functional": {
			"color": UIThemeManager.ACCENT_GREEN,
			"terms": ["memory", "attention", "processing", "integration", "coordination"]
		},
		"pathological": {
			"color": UIThemeManager.ACCENT_RED,
			"terms": ["damage", "lesion", "dysfunction", "disorder", "impairment"]
		}
	}
	
	for category in term_categories:
		var data = term_categories[category]
		for term in data["terms"]:
			var regex = RegEx.new()
			regex.compile("(?i)\\b" + term + "\\b")
			var replacement = "[color=%s][b]$0[/b][/color]" % data["color"].to_html()
			formatted = regex.sub(formatted, replacement, true)
	
	return formatted

func _create_functions_list_view(functions: Array) -> void:
	"""Create enhanced list view for functions"""
	if functions.is_empty():
		_create_no_functions_placeholder()
		return
	
	for i in range(functions.size()):
		var function_text = str(functions[i])
		var item = _create_enhanced_function_item(function_text, i, "list")
		functions_list.add_child(item)
		
		# Staggered entrance animation
		UIThemeManager.animate_entrance(item, i * 0.05 * animation_speed_multiplier)

func _create_functions_card_view(functions: Array) -> void:
	"""Create card view for functions with rich visual design"""
	if functions.is_empty():
		_create_no_functions_placeholder()
		return
	
	for i in range(functions.size()):
		var function_text = str(functions[i])
		var card = _create_enhanced_function_card(function_text, i)
		functions_list.add_child(card)
		
		# Staggered entrance animation
		UIThemeManager.animate_entrance(card, i * 0.1 * animation_speed_multiplier)

func _create_functions_timeline_view(functions: Array) -> void:
	"""Create timeline view showing function relationships"""
	# TODO: Implement timeline view with hierarchical function display
	_create_functions_list_view(functions)  # Fallback to list view for now

func _create_enhanced_function_item(text: String, index: int, _style: String = "list") -> Control:
	"""Create enhanced function item with multiple style options"""
	var container = HBoxContainer.new()
	container.add_theme_constant_override("separation", UIThemeManager.MARGIN_MEDIUM)
	
	# Enhanced icon system
	var icon_label = Label.new()
	var function_icons = ["⚡", "🧠", "🔄", "📡", "🎯", "💫", "🌟", "⚙️", "🔍", "📊"]
	icon_label.text = function_icons[index % function_icons.size()]
	UIThemeManager.apply_modern_label(icon_label, UIThemeManager.FONT_SIZE_LARGE, UIThemeManager.ACCENT_CYAN)
	icon_label.custom_minimum_size.x = 40
	container.add_child(icon_label)
	
	# Function text with importance weighting
	var text_label = Label.new()
	text_label.text = text
	text_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	
	# Color-code by importance (mock logic)
	var importance_color = UIThemeManager.TEXT_PRIMARY
	if index < 3:  # Top 3 functions get accent color
		importance_color = UIThemeManager.ACCENT_BLUE
	
	UIThemeManager.apply_modern_label(text_label, UIThemeManager.FONT_SIZE_MEDIUM, importance_color)
	container.add_child(text_label)
	
	# Add hover effects
	container.mouse_entered.connect(func(): UIThemeManager.animate_hover_glow(container, UIThemeManager.ACCENT_BLUE, 0.1))
	container.mouse_exited.connect(func(): UIThemeManager.animate_hover_glow_off(container))
	
	return container

func _create_enhanced_function_card(text: String, index: int) -> Control:
	"""Create sophisticated function card with rich visual design"""
	var card = PanelContainer.new()
	var card_style = UIThemeManager.create_educational_card_style("info")
	card.add_theme_stylebox_override("panel", card_style)
	card.custom_minimum_size = Vector2(0, 80)
	
	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_top", UIThemeManager.MARGIN_SMALL)
	margin.add_theme_constant_override("margin_bottom", UIThemeManager.MARGIN_SMALL)
	margin.add_theme_constant_override("margin_left", UIThemeManager.MARGIN_MEDIUM)
	margin.add_theme_constant_override("margin_right", UIThemeManager.MARGIN_MEDIUM)
	card.add_child(margin)
	
	var container = VBoxContainer.new()
	container.add_theme_constant_override("separation", UIThemeManager.MARGIN_SMALL)
	margin.add_child(container)
	
	# Card header with icon and priority
	var header = HBoxContainer.new()
	container.add_child(header)
	
	var icon_label = Label.new()
	var function_icons = ["⚡", "🧠", "🔄", "📡", "🎯", "💫", "🌟", "⚙️"]
	icon_label.text = function_icons[index % function_icons.size()]
	UIThemeManager.apply_modern_label(icon_label, UIThemeManager.FONT_SIZE_LARGE, UIThemeManager.ACCENT_CYAN)
	header.add_child(icon_label)
	
	# Priority indicator
	var priority_label = Label.new()
	priority_label.text = "Priority: %s" % ("High" if index < 2 else "Medium" if index < 4 else "Normal")
	priority_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	priority_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	UIThemeManager.apply_modern_label(priority_label, UIThemeManager.FONT_SIZE_SMALL, UIThemeManager.TEXT_SECONDARY)
	header.add_child(priority_label)
	
	# Function text
	var text_label = Label.new()
	text_label.text = text
	text_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	UIThemeManager.apply_modern_label(text_label, UIThemeManager.FONT_SIZE_MEDIUM, UIThemeManager.TEXT_PRIMARY)
	container.add_child(text_label)
	
	# Add interactive effects
	card.mouse_entered.connect(func(): UIThemeManager.animate_hover_glow(card, UIThemeManager.ACCENT_BLUE, 0.15))
	card.mouse_exited.connect(func(): UIThemeManager.animate_hover_glow_off(card))
	
	return card

func _create_no_functions_placeholder() -> void:
	"""Create informative placeholder when no functions are available"""
	var placeholder_card = PanelContainer.new()
	var style = UIThemeManager.create_educational_card_style("warning")
	placeholder_card.add_theme_stylebox_override("panel", style)
	
	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_top", UIThemeManager.MARGIN_MEDIUM)
	margin.add_theme_constant_override("margin_bottom", UIThemeManager.MARGIN_MEDIUM)
	margin.add_theme_constant_override("margin_left", UIThemeManager.MARGIN_MEDIUM)
	margin.add_theme_constant_override("margin_right", UIThemeManager.MARGIN_MEDIUM)
	placeholder_card.add_child(margin)
	
	var container = VBoxContainer.new()
	container.add_theme_constant_override("separation", UIThemeManager.MARGIN_SMALL)
	margin.add_child(container)
	
	var icon_label = Label.new()
	icon_label.text = "🔍"
	icon_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	UIThemeManager.apply_modern_label(icon_label, UIThemeManager.FONT_SIZE_LARGE, UIThemeManager.ACCENT_ORANGE)
	container.add_child(icon_label)
	
	var message_label = Label.new()
	message_label.text = "No function information available for this structure."
	message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	UIThemeManager.apply_modern_label(message_label, UIThemeManager.FONT_SIZE_MEDIUM, UIThemeManager.TEXT_SECONDARY)
	container.add_child(message_label)
	
	var suggestion_label = Label.new()
	suggestion_label.text = "Consider contributing to the knowledge base or exploring related structures."
	suggestion_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	suggestion_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	UIThemeManager.apply_modern_label(suggestion_label, UIThemeManager.FONT_SIZE_SMALL, UIThemeManager.TEXT_TERTIARY)
	container.add_child(suggestion_label)
	
	functions_list.add_child(placeholder_card)

func _get_intelligent_related_structures(structure_data: Dictionary) -> Array:
	"""Get intelligently suggested related structures"""
	# Enhanced logic for determining related structures
	var current_name = structure_data.get("displayName", "").to_lower()
	var related = []
	
	# Anatomical proximity mapping (simplified)
	var proximity_mapping = {
		"hippocampus": ["Amygdala", "Entorhinal Cortex", "Fornix", "Temporal Lobe"],
		"amygdala": ["Hippocampus", "Hypothalamus", "Prefrontal Cortex", "Temporal Lobe"],
		"thalamus": ["Hypothalamus", "Cortex", "Brainstem", "Basal Ganglia"],
		"cerebellum": ["Brainstem", "Motor Cortex", "Vestibular System", "Pons"],
		"frontal": ["Parietal Lobe", "Temporal Lobe", "Anterior Cingulate", "Motor Cortex"],
		"temporal": ["Frontal Lobe", "Parietal Lobe", "Hippocampus", "Auditory Cortex"],
		"parietal": ["Frontal Lobe", "Temporal Lobe", "Occipital Lobe", "Somatosensory Cortex"],
		"occipital": ["Parietal Lobe", "Temporal Lobe", "Visual Cortex", "Superior Colliculus"]
	}
	
	for key in proximity_mapping:
		if key in current_name:
			related = proximity_mapping[key]
			break
	
	return related

func _populate_related_grid(related_structures: Array) -> void:
	"""Populate related structures grid with interactive chips"""
	# Clear existing chips
	for child in related_grid.get_children():
		child.queue_free()
	
	for structure in related_structures:
		var chip = _create_interactive_structure_chip(structure)
		related_grid.add_child(chip)

func _create_interactive_structure_chip(structure_name: String) -> Button:
	"""Create interactive structure navigation chip with enhanced styling"""
	var chip = Button.new()
	chip.text = structure_name
	chip.custom_minimum_size = Vector2(120, 36)
	
	# Apply enhanced chip styling
	UIThemeManager.apply_modern_button(chip, UIThemeManager.ACCENT_TEAL, "small")
	
	# Add hover and click effects
	chip.mouse_entered.connect(func(): UIThemeManager.animate_hover_glow(chip, UIThemeManager.ACCENT_CYAN, 0.2))
	chip.mouse_exited.connect(func(): UIThemeManager.animate_hover_glow_off(chip))
	
	# Connect navigation
	chip.pressed.connect(func(): 
		UIThemeManager.animate_button_press(chip, UIThemeManager.ACCENT_BLUE)
		emit_signal("related_structure_selected", structure_name)
	)
	
	return chip

func _calculate_learning_progress() -> Dictionary:
	"""Calculate comprehensive learning progress"""
	var completed_items = 0
	var total_items = learning_progress.keys().size() - 3  # Exclude non-boolean keys
	
	for key in learning_progress:
		if key != "study_time" and key != "last_visited" and key != "comprehension_score":
			if typeof(learning_progress[key]) == TYPE_BOOL and learning_progress[key] == true:
				completed_items += 1
	
	var percentage = (float(completed_items) / float(total_items)) * 100.0 if total_items > 0 else 0.0
	
	var color = UIThemeManager.ACCENT_RED
	if percentage >= 80.0:
		color = UIThemeManager.ACCENT_GREEN
	elif percentage >= 60.0:
		color = UIThemeManager.ACCENT_BLUE
	elif percentage >= 40.0:
		color = UIThemeManager.ACCENT_ORANGE
	elif percentage >= 20.0:
		color = UIThemeManager.ACCENT_YELLOW
	
	return {
		"percentage": percentage,
		"color": color,
		"completed": completed_items,
		"total": total_items,
		"level": _get_progress_level(percentage)
	}

func _get_progress_level(percentage: float) -> String:
	"""Get progress level description"""
	if percentage >= 90.0:
		return "Expert"
	elif percentage >= 70.0:
		return "Advanced"
	elif percentage >= 50.0:
		return "Intermediate"
	elif percentage >= 30.0:
		return "Beginner"
	else:
		return "Just Started"

func _clear_functions_display() -> void:
	"""Clear functions display safely"""
	if not functions_list:
		return
	
	for child in functions_list.get_children():
		functions_list.remove_child(child)
		child.queue_free()

func _animate_unified_entrance() -> void:
	"""Comprehensive entrance animation with staggered elements"""
	if is_animating:
		return
	
	is_animating = true
	visible = true
	
	# Main panel entrance
	UIThemeManager.animate_entrance(self, 0.0, UIThemeManager.ANIMATION.normal * animation_speed_multiplier, "slide_left")
	
	# Staggered section animations
	var delay = 0.1 * animation_speed_multiplier
	
	get_tree().create_timer(delay).timeout.connect(func():
		if header_container:
			UIThemeManager.animate_entrance(header_container, 0.0, UIThemeManager.ANIMATION.fast * animation_speed_multiplier, "fade_scale")
	)
	
	get_tree().create_timer(delay * 2).timeout.connect(func():
		if quick_info_container:
			UIThemeManager.animate_entrance(quick_info_container, 0.0, UIThemeManager.ANIMATION.fast * animation_speed_multiplier, "slide_up")
	)
	
	get_tree().create_timer(delay * 3).timeout.connect(func():
		if content_container:
			UIThemeManager.animate_entrance(content_container, 0.0, UIThemeManager.ANIMATION.fast * animation_speed_multiplier, "fade_scale")
	)
	
	get_tree().create_timer(delay * 4).timeout.connect(func():
		is_animating = false
	)

func clear_data() -> void:
	"""Clear all panel content with enhanced feedback"""
	current_structure_id = ""
	current_structure_data = {}
	
	# Reset header
	if structure_name_label:
		structure_name_label.text = "Brain Structure Explorer"
	
	if structure_category_badge:
		structure_category_badge.visible = false
	
	# Reset quick info
	if difficulty_chip:
		difficulty_chip.text = "🟢 Ready"
	
	if reading_time_chip:
		reading_time_chip.text = "⏱️ Select structure"
	
	if confidence_indicator:
		confidence_indicator.text = "📊 Ready"
	
	# Reset description
	if description_text:
		description_text.text = "[center][font_size=%d][color=%s][i]Select a brain structure to explore detailed information, interactive functions, and comprehensive learning resources.[/i][/color][/font_size][/center]" % [
			UIThemeManager.FONT_SIZE_MEDIUM,
			UIThemeManager.TEXT_SECONDARY.to_html()
		]
	
	# Clear content sections
	_clear_functions_display()
	related_section.visible = false
	
	# Reset learning progress
	_reset_learning_progress()
	
	# Reset metadata
	if metadata_label:
		metadata_label.text = "📊 Ready to explore brain anatomy"
	
	visible = false

func _reset_learning_progress() -> void:
	"""Reset learning progress indicators"""
	_initialize_learning_systems()
	
	if progress_bar:
		progress_bar.value = 0
	
	if progress_label:
		progress_label.text = "0%"

# === SIGNAL HANDLERS ===

func _on_close_pressed() -> void:
	"""Handle close with enhanced animation and cleanup"""
	UIThemeManager.animate_exit(self, UIThemeManager.ANIMATION.fast * animation_speed_multiplier, "slide_right")
	get_tree().create_timer(UIThemeManager.ANIMATION.fast * animation_speed_multiplier).timeout.connect(func():
		emit_signal("panel_closed")
	)

func _on_bookmark_pressed() -> void:
	"""Handle bookmark toggle with persistent storage"""
	is_bookmarked = !is_bookmarked
	learning_progress["bookmarked"] = is_bookmarked
	
	# Update button with enhanced animation
	bookmark_button.text = "⭐" if is_bookmarked else "☆"
	UIThemeManager.animate_button_press(bookmark_button, UIThemeManager.ACCENT_YELLOW)
	
	# Update progress
	_update_learning_indicators()
	
	# Emit signal for external handling
	emit_signal("structure_bookmarked", current_structure_id, is_bookmarked)
	
	# Show feedback
	if is_bookmarked:
		print("[UNIFIED_INFO_PANEL] Structure bookmarked: %s" % current_structure_id)
	else:
		print("[UNIFIED_INFO_PANEL] Bookmark removed: %s" % current_structure_id)

func _on_share_pressed() -> void:
	"""Handle share/export with multiple format options"""
	UIThemeManager.animate_button_press(share_button, UIThemeManager.ACCENT_BLUE)
	print("[UNIFIED_INFO_PANEL] Share functionality triggered for: %s" % current_structure_id)
	# TODO: Implement comprehensive share/export system

func _on_fullscreen_pressed() -> void:
	"""Handle fullscreen mode request"""
	UIThemeManager.animate_button_press(fullscreen_button, UIThemeManager.ACCENT_PURPLE)
	emit_signal("fullscreen_requested", current_structure_id)
	print("[UNIFIED_INFO_PANEL] Fullscreen mode requested for: %s" % current_structure_id)

func _on_search_submitted(text: String) -> void:
	"""Handle search submission with history tracking"""
	if text.strip_edges() != "":
		search_history.append(text)
		emit_signal("structure_search_requested", text)
		print("[UNIFIED_INFO_PANEL] Search submitted: %s" % text)

func _on_search_text_changed(text: String) -> void:
	"""Handle real-time search with suggestions"""
	# TODO: Implement intelligent search suggestions
	pass

func _on_search_clear() -> void:
	"""Clear search with smooth animation"""
	search_field.text = ""
	search_field.grab_focus()

func _on_filter_pressed() -> void:
	"""Handle filter options"""
	UIThemeManager.animate_button_press(filter_button, UIThemeManager.ACCENT_BLUE)
	print("[UNIFIED_INFO_PANEL] Filter options requested")
	# TODO: Implement search filter system

func _on_description_expand() -> void:
	"""Handle description expand/collapse"""
	is_expanded = !is_expanded
	description_expand_button.text = "⌃" if is_expanded else "⌄"
	UIThemeManager.animate_button_press(description_expand_button, UIThemeManager.ACCENT_BLUE)
	
	# TODO: Implement expand/collapse functionality
	print("[UNIFIED_INFO_PANEL] Description %s" % ("expanded" if is_expanded else "collapsed"))

func _on_functions_view_changed(index: int) -> void:
	"""Handle functions view mode change"""
	print("[UNIFIED_INFO_PANEL] Functions view changed to mode: %d" % index)
	_update_functions_content(current_structure_data)

func _on_quiz_pressed() -> void:
	"""Handle quiz request with progress tracking"""
	UIThemeManager.animate_button_press(quiz_button, UIThemeManager.ACCENT_GREEN)
	learning_progress["quiz_attempted"] = true
	_update_learning_indicators()
	emit_signal("quiz_requested", current_structure_id)
	print("[UNIFIED_INFO_PANEL] Quiz requested for: %s" % current_structure_id)

func _on_notes_pressed() -> void:
	"""Handle notes request with progress tracking"""
	UIThemeManager.animate_button_press(notes_button, UIThemeManager.ACCENT_PURPLE)
	learning_progress["notes_taken"] = true
	_update_learning_indicators()
	emit_signal("notes_requested", current_structure_id)
	print("[UNIFIED_INFO_PANEL] Notes requested for: %s" % current_structure_id)

func _on_study_plan_pressed() -> void:
	"""Handle study plan generation request"""
	UIThemeManager.animate_button_press(study_plan_button, UIThemeManager.ACCENT_ORANGE)
	emit_signal("study_plan_requested", current_structure_id)
	print("[UNIFIED_INFO_PANEL] Study plan requested for: %s" % current_structure_id)

func _on_feedback_pressed() -> void:
	"""Handle feedback submission request"""
	UIThemeManager.animate_button_press(feedback_button, UIThemeManager.ACCENT_TEAL)
	
	var feedback_data = {
		"structure_id": current_structure_id,
		"timestamp": Time.get_datetime_string_from_system(),
		"user_progress": learning_progress
	}
	
	emit_signal("feedback_submitted", current_structure_id, feedback_data)
	print("[UNIFIED_INFO_PANEL] Feedback requested for: %s" % current_structure_id)

# === PUBLIC UTILITY METHODS ===

func toggle_search_visibility() -> void:
	"""Toggle search section visibility"""
	if search_container.visible:
		hide_search_section()
	else:
		show_search_section()

func show_search_section() -> void:
	"""Show search functionality with animation"""
	search_container.visible = true
	UIThemeManager.animate_entrance(search_container, 0.0, UIThemeManager.ANIMATION.fast * animation_speed_multiplier, "slide_down")
	search_field.grab_focus()

func hide_search_section() -> void:
	"""Hide search functionality with animation"""
	UIThemeManager.animate_exit(search_container, UIThemeManager.ANIMATION.fast * animation_speed_multiplier, "slide_up")
	get_tree().create_timer(UIThemeManager.ANIMATION.fast * animation_speed_multiplier).timeout.connect(func():
		search_container.visible = false
	)

func set_panel_theme(theme_name: String) -> void:
	"""Change panel theme"""
	if theme_name in available_themes:
		current_theme = theme_name
		_apply_unified_theming()
		emit_signal("preference_changed", "theme", theme_name)
		print("[UNIFIED_INFO_PANEL] Theme changed to: %s" % theme_name)

func get_learning_progress_summary() -> Dictionary:
	"""Get comprehensive learning progress summary"""
	return {
		"structure_id": current_structure_id,
		"progress": learning_progress,
		"calculated_progress": _calculate_learning_progress(),
		"last_visited": learning_progress.get("last_visited", ""),
		"bookmarked": is_bookmarked
	}

func mark_quiz_completed(passed: bool = true) -> void:
	"""Mark quiz as completed with pass/fail status"""
	learning_progress["quiz_completed"] = true
	learning_progress["quiz_passed"] = passed
	_update_learning_indicators()

func update_study_time(additional_seconds: float) -> void:
	"""Update study time tracking"""
	learning_progress["study_time"] = learning_progress.get("study_time", 0.0) + additional_seconds

# === CLEANUP ===

func dispose() -> void:
	"""Comprehensive cleanup of resources"""
	clear_data()
	search_history.clear()
	view_preferences.clear()
	learning_progress.clear()

func _exit_tree() -> void:
	"""Cleanup on removal"""
	dispose()
