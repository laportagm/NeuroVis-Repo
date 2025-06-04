# Enhanced Educational Model Control Panel
# Advanced brain model management with search, categories, and learning features
class_name EnhancedModelControlPanel
extends PanelContainer

# UI node references
@onready var header_container: VBoxContainer
@onready var search_container: HBoxContainer
@onready var search_field: LineEdit
@onready var filter_button: Button
@onready var view_mode_button: Button
@onready var category_container: HBoxContainer
@onready var models_scroll: ScrollContainer
@onready var models_container: VBoxContainer
@onready var footer_container: HBoxContainer
@onready var visibility_counter: Label
@onready var reset_button: Button

# State management
var model_cards: Dictionary = {}
var filtered_models: Array = []
var current_filter: String = "all"
var current_view_mode: String = "cards"  # "cards" or "list"
var search_query: String = ""
var total_models: int = 0
var visible_models: int = 0

# Model categories for educational organization
var model_categories: Dictionary = {
	"all": {"name": "All Models", "icon": "🧠", "color": UIThemeManager.ACCENT_BLUE},
	"cortex": {"name": "Cortical", "icon": "🎯", "color": UIThemeManager.ACCENT_BLUE},
	"subcortical": {"name": "Subcortical", "icon": "⚡", "color": UIThemeManager.ACCENT_PURPLE},
	"brainstem": {"name": "Brainstem", "icon": "🌿", "color": UIThemeManager.ACCENT_TEAL},
	"cerebellum": {"name": "Cerebellum", "icon": "🎭", "color": UIThemeManager.ACCENT_CYAN},
	"limbic": {"name": "Limbic", "icon": "❤️", "color": UIThemeManager.ACCENT_PINK},
	"vascular": {"name": "Vascular", "icon": "🩸", "color": UIThemeManager.ACCENT_RED}
}

# Educational metadata for models
var model_metadata: Dictionary = {
	"Half_Brain": {
		"category": "cortex", 
		"difficulty": "beginner",
		"description": "Complete hemisphere showing major cortical regions",
		"learning_objectives": ["Identify major lobes", "Understand cortical organization"],
		"keywords": ["cortex", "hemisphere", "lobes", "frontal", "parietal", "temporal", "occipital"]
	},
	"Internal_Structures": {
		"category": "subcortical",
		"difficulty": "intermediate", 
		"description": "Deep brain structures including thalamus, hippocampus, and basal ganglia",
		"learning_objectives": ["Locate subcortical structures", "Understand deep brain anatomy"],
		"keywords": ["thalamus", "hippocampus", "basal ganglia", "subcortical", "deep brain"]
	},
	"Brainstem": {
		"category": "brainstem",
		"difficulty": "advanced",
		"description": "Midbrain, pons, and medulla with critical life functions",
		"learning_objectives": ["Identify brainstem regions", "Understand vital functions"],
		"keywords": ["midbrain", "pons", "medulla", "brainstem", "vital functions"]
	}
}

# Signals
signal model_selected(model_name: String)
signal model_visibility_changed(model_name: String, visible: bool)
signal category_selected(category: String)
signal search_performed(query: String)
signal learning_mode_requested(model_name: String)

func _ready() -> void:
	call_deferred("_initialize_enhanced_panel")

func _initialize_enhanced_panel() -> void:
	"""Initialize the enhanced educational model control panel"""
	_create_enhanced_ui_structure()
	_apply_enhanced_styling()
	_connect_enhanced_signals()
	_setup_search_functionality()
	_initialize_categories()
	
	print("[ENHANCED_MODEL_PANEL] Advanced model control panel initialized")

func _create_enhanced_ui_structure() -> void:
	"""Create sophisticated UI structure for model management"""
	print("[ENHANCED_MODEL_PANEL] Creating enhanced UI structure")
	
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
	
	# Search and filter section
	_create_search_and_filter_section(main_vbox)
	
	# Category navigation
	_create_category_navigation(main_vbox)
	
	# Models display area
	_create_models_display_area(main_vbox)
	
	# Footer with controls
	_create_enhanced_footer(main_vbox)

func _create_enhanced_header(parent: Control) -> void:
	"""Create sophisticated header with title and view controls"""
	header_container = VBoxContainer.new()
	header_container.name = "HeaderContainer"
	header_container.add_theme_constant_override("separation", UIThemeManager.MARGIN_SMALL)
	parent.add_child(header_container)
	
	# Title bar with controls
	var title_bar = HBoxContainer.new()
	title_bar.name = "TitleBar"
	title_bar.add_theme_constant_override("separation", UIThemeManager.MARGIN_MEDIUM)
	header_container.add_child(title_bar)
	
	# Title section
	var title_section = VBoxContainer.new()
	title_section.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_section.add_theme_constant_override("separation", UIThemeManager.MARGIN_TINY)
	title_bar.add_child(title_section)
	
	# Main title
	var title = Label.new()
	title.name = "MainTitle"
	title.text = "🧠 Brain Models"
	title_section.add_child(title)
	
	# Subtitle
	var subtitle = Label.new()
	subtitle.name = "Subtitle"
	subtitle.text = "Interactive 3D visualization control"
	title_section.add_child(subtitle)
	
	# View controls
	var view_controls = HBoxContainer.new()
	view_controls.add_theme_constant_override("separation", UIThemeManager.MARGIN_SMALL)
	title_bar.add_child(view_controls)
	
	# View mode toggle
	view_mode_button = Button.new()
	view_mode_button.name = "ViewModeButton"
	view_mode_button.text = "📋"
	view_mode_button.custom_minimum_size = Vector2(36, 36)
	view_mode_button.tooltip_text = "Toggle view mode"
	view_controls.add_child(view_mode_button)

func _create_search_and_filter_section(parent: Control) -> void:
	"""Create search and filtering interface"""
	search_container = HBoxContainer.new()
	search_container.name = "SearchContainer"
	search_container.add_theme_constant_override("separation", UIThemeManager.MARGIN_SMALL)
	parent.add_child(search_container)
	
	# Search field
	search_field = LineEdit.new()
	search_field.name = "SearchField"
	search_field.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	search_field.placeholder_text = "Search brain models, regions..."
	search_container.add_child(search_field)
	
	# Filter button
	filter_button = Button.new()
	filter_button.name = "FilterButton"
	filter_button.text = "🔍"
	filter_button.custom_minimum_size = Vector2(36, 36)
	filter_button.tooltip_text = "Advanced filters"
	search_container.add_child(filter_button)

func _create_category_navigation(parent: Control) -> void:
	"""Create category navigation chips"""
	# Category scroll container
	var category_scroll = ScrollContainer.new()
	category_scroll.name = "CategoryScroll"
	category_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	category_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	parent.add_child(category_scroll)
	
	category_container = HBoxContainer.new()
	category_container.name = "CategoryContainer"
	category_container.add_theme_constant_override("separation", UIThemeManager.MARGIN_SMALL)
	category_scroll.add_child(category_container)

func _create_models_display_area(parent: Control) -> void:
	"""Create models display area with scroll"""
	models_scroll = ScrollContainer.new()
	models_scroll.name = "ModelsScroll"
	models_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	models_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	parent.add_child(models_scroll)
	
	models_container = VBoxContainer.new()
	models_container.name = "ModelsContainer"
	models_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	models_container.add_theme_constant_override("separation", UIThemeManager.MARGIN_MEDIUM)
	models_scroll.add_child(models_container)

func _create_enhanced_footer(parent: Control) -> void:
	"""Create footer with statistics and controls"""
	# Separator
	var separator = HSeparator.new()
	parent.add_child(separator)
	
	footer_container = HBoxContainer.new()
	footer_container.name = "FooterContainer"
	footer_container.add_theme_constant_override("separation", UIThemeManager.MARGIN_MEDIUM)
	parent.add_child(footer_container)
	
	# Visibility counter
	visibility_counter = Label.new()
	visibility_counter.name = "VisibilityCounter"
	visibility_counter.text = "0/0 models visible"
	visibility_counter.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	footer_container.add_child(visibility_counter)
	
	# Reset button
	reset_button = Button.new()
	reset_button.name = "ResetButton"
	reset_button.text = "🔄 Reset"
	reset_button.tooltip_text = "Reset all model visibility"
	footer_container.add_child(reset_button)

func _apply_enhanced_styling() -> void:
	"""Apply sophisticated educational styling"""
	# Main panel styling
	UIThemeManager.apply_glass_panel(self, 0.95, "control")
	
	# Header styling
	var title = header_container.find_child("MainTitle")
	if title:
		UIThemeManager.apply_modern_label(title, UIThemeManager.FONT_SIZE_H2, UIThemeManager.TEXT_PRIMARY, "heading")
	
	var subtitle = header_container.find_child("Subtitle")
	if subtitle:
		UIThemeManager.apply_modern_label(subtitle, UIThemeManager.FONT_SIZE_SMALL, UIThemeManager.TEXT_SECONDARY, "caption")
	
	# Button styling
	UIThemeManager.apply_modern_button(view_mode_button, UIThemeManager.ACCENT_BLUE, "icon")
	UIThemeManager.apply_modern_button(filter_button, UIThemeManager.ACCENT_TEAL, "icon")
	UIThemeManager.apply_modern_button(reset_button, UIThemeManager.ACCENT_ORANGE, "small")
	
	# Search field styling
	UIThemeManager.apply_search_field_styling(search_field, "Search brain models, regions...")
	
	# Footer styling
	UIThemeManager.apply_modern_label(visibility_counter, UIThemeManager.FONT_SIZE_SMALL, UIThemeManager.TEXT_SECONDARY)

func _connect_enhanced_signals() -> void:
	"""Connect all interactive signals"""
	if search_field and not search_field.text_submitted.is_connected(_on_search_submitted):
		search_field.text_submitted.connect(_on_search_submitted)
		search_field.text_changed.connect(_on_search_text_changed)
	
	if filter_button and not filter_button.pressed.is_connected(_on_filter_pressed):
		filter_button.pressed.connect(_on_filter_pressed)
	
	if view_mode_button and not view_mode_button.pressed.is_connected(_on_view_mode_pressed):
		view_mode_button.pressed.connect(_on_view_mode_pressed)
	
	if reset_button and not reset_button.pressed.is_connected(_on_reset_pressed):
		reset_button.pressed.connect(_on_reset_pressed)

func _setup_search_functionality() -> void:
	"""Setup intelligent search with autocomplete"""
	# TODO: Implement search suggestions and autocomplete
	pass

func _initialize_categories() -> void:
	"""Create category navigation chips"""
	for category_id in model_categories:
		var category_data = model_categories[category_id]
		var chip = _create_category_chip(category_id, category_data)
		category_container.add_child(chip)

func _create_category_chip(category_id: String, category_data: Dictionary) -> Button:
	"""Create interactive category chip"""
	var chip = Button.new()
	chip.name = "CategoryChip_" + category_id
	chip.text = category_data["icon"] + " " + category_data["name"]
	chip.toggle_mode = true
	chip.button_pressed = (category_id == "all")
	
	# Apply chip styling
	var accent_color = category_data["color"] if category_id != "all" else UIThemeManager.ACCENT_BLUE
	UIThemeManager.apply_modern_button(chip, accent_color, "small")
	
	# Connect selection
	chip.toggled.connect(func(pressed: bool): _on_category_selected(category_id, pressed))
	
	return chip

func setup_with_models(model_names: Array) -> void:
	"""Setup panel with enhanced model management"""
	print("[ENHANCED_MODEL_PANEL] Setting up with " + str(model_names.size()) + " models")
	
	total_models = model_names.size()
	visible_models = model_names.size()
	
	# Clear existing models
	_clear_models()
	
	# Create enhanced model cards
	for i in range(model_names.size()):
		var model_name = model_names[i]
		var card = _create_enhanced_model_card(model_name, i)
		models_container.add_child(card)
		model_cards[model_name] = card
		
		# Stagger entrance animations
		UIThemeManager.animate_entrance(card, i * 0.1, UIThemeManager.ANIM_DURATION_STANDARD, "slide_up")
	
	# Update footer
	_update_visibility_counter()
	
	# Apply initial filter
	_apply_current_filter()

func _create_enhanced_model_card(model_name: String, index: int) -> Control:
	"""Create sophisticated model card with educational features"""
	var card = PanelContainer.new()
	card.name = "ModelCard_" + model_name
	
	# Get model metadata
	var metadata = model_metadata.get(model_name, {
		"category": "all",
		"difficulty": "beginner", 
		"description": "Brain structure model",
		"learning_objectives": [],
		"keywords": []
	})
	
	# Card styling based on view mode
	var card_style = UIThemeManager.create_educational_card_style("info")
	card.add_theme_stylebox_override("panel", card_style)
	
	if current_view_mode == "cards":
		_create_card_view_content(card, model_name, metadata)
	else:
		_create_list_view_content(card, model_name, metadata)
	
	# Store metadata in card
	card.set_meta("model_name", model_name)
	card.set_meta("metadata", metadata)
	card.set_meta("visible", true)
	
	# Add interactive effects
	_add_enhanced_card_interactions(card)
	
	return card

func _create_card_view_content(card: PanelContainer, model_name: String, metadata: Dictionary) -> void:
	"""Create card view layout"""
	var main_container = VBoxContainer.new()
	main_container.add_theme_constant_override("separation", UIThemeManager.MARGIN_MEDIUM)
	card.add_child(main_container)
	
	# Header with toggle and info
	var header = HBoxContainer.new()
	header.add_theme_constant_override("separation", UIThemeManager.MARGIN_MEDIUM)
	main_container.add_child(header)
	
	# Model info section
	var info_section = VBoxContainer.new()
	info_section.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info_section.add_theme_constant_override("separation", UIThemeManager.MARGIN_TINY)
	header.add_child(info_section)
	
	# Model name with icon
	var name_container = HBoxContainer.new()
	name_container.add_theme_constant_override("separation", UIThemeManager.MARGIN_SMALL)
	info_section.add_child(name_container)
	
	# Category icon
	var category_data = model_categories.get(metadata.get("category", "all"), model_categories["all"])
	var icon_label = Label.new()
	icon_label.text = category_data["icon"]
	icon_label.custom_minimum_size = Vector2(24, 24)
	UIThemeManager.apply_modern_label(icon_label, UIThemeManager.FONT_SIZE_LARGE, category_data["color"])
	name_container.add_child(icon_label)
	
	# Model name
	var name_label = Label.new()
	name_label.text = model_name.replace("_", " ")
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	UIThemeManager.apply_modern_label(name_label, UIThemeManager.FONT_SIZE_MEDIUM, UIThemeManager.TEXT_PRIMARY)
	name_container.add_child(name_label)
	
	# Status and difficulty
	var status_container = HBoxContainer.new()
	status_container.add_theme_constant_override("separation", UIThemeManager.MARGIN_MEDIUM)
	info_section.add_child(status_container)
	
	# Status label
	var status_label = Label.new()
	status_label.name = "StatusLabel"
	status_label.text = "👁️ Visible"
	status_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	UIThemeManager.apply_modern_label(status_label, UIThemeManager.FONT_SIZE_SMALL, UIThemeManager.ACCENT_GREEN)
	status_container.add_child(status_label)
	
	# Difficulty badge
	var difficulty = metadata.get("difficulty", "beginner")
	var difficulty_label = Label.new()
	difficulty_label.text = _get_difficulty_icon(difficulty) + " " + difficulty.capitalize()
	UIThemeManager.apply_modern_label(difficulty_label, UIThemeManager.FONT_SIZE_TINY, _get_difficulty_color(difficulty), "badge", true)
	status_container.add_child(difficulty_label)
	
	# Toggle switch
	var toggle = CheckButton.new()
	toggle.name = "ModelToggle"
	toggle.button_pressed = true
	toggle.custom_minimum_size = Vector2(48, 32)
	header.add_child(toggle)
	
	# Description
	var description = metadata.get("description", "Brain structure model")
	var desc_label = Label.new()
	desc_label.text = description
	desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc_label.custom_minimum_size = Vector2(0, 40)
	UIThemeManager.apply_modern_label(desc_label, UIThemeManager.FONT_SIZE_SMALL, UIThemeManager.TEXT_SECONDARY)
	main_container.add_child(desc_label)
	
	# Action buttons
	var actions = HBoxContainer.new()
	actions.add_theme_constant_override("separation", UIThemeManager.MARGIN_SMALL)
	main_container.add_child(actions)
	
	# Learn button
	var learn_button = Button.new()
	learn_button.name = "LearnButton"
	learn_button.text = "📚 Learn"
	learn_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	UIThemeManager.apply_modern_button(learn_button, UIThemeManager.ACCENT_GREEN, "small")
	actions.add_child(learn_button)
	
	# Focus button
	var focus_button = Button.new()
	focus_button.name = "FocusButton"
	focus_button.text = "🎯 Focus"
	focus_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	UIThemeManager.apply_modern_button(focus_button, UIThemeManager.ACCENT_BLUE, "small")
	actions.add_child(focus_button)
	
	# Connect signals
	toggle.toggled.connect(_on_model_toggled.bind(model_name, status_label))
	learn_button.pressed.connect(_on_learn_pressed.bind(model_name))
	focus_button.pressed.connect(_on_focus_pressed.bind(model_name))

func _create_list_view_content(card: PanelContainer, model_name: String, metadata: Dictionary) -> void:
	"""Create compact list view layout"""
	var container = HBoxContainer.new()
	container.add_theme_constant_override("separation", UIThemeManager.MARGIN_MEDIUM)
	card.add_child(container)
	
	# Category icon
	var category_data = model_categories.get(metadata.get("category", "all"), model_categories["all"])
	var icon_label = Label.new()
	icon_label.text = category_data["icon"]
	icon_label.custom_minimum_size = Vector2(32, 32)
	UIThemeManager.apply_modern_label(icon_label, UIThemeManager.FONT_SIZE_LARGE, category_data["color"])
	container.add_child(icon_label)
	
	# Model info
	var info_section = VBoxContainer.new()
	info_section.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info_section.add_theme_constant_override("separation", UIThemeManager.MARGIN_TINY)
	container.add_child(info_section)
	
	# Name
	var name_label = Label.new()
	name_label.text = model_name.replace("_", " ")
	UIThemeManager.apply_modern_label(name_label, UIThemeManager.FONT_SIZE_MEDIUM, UIThemeManager.TEXT_PRIMARY)
	info_section.add_child(name_label)
	
	# Status
	var status_label = Label.new()
	status_label.name = "StatusLabel"
	status_label.text = "Visible"
	UIThemeManager.apply_modern_label(status_label, UIThemeManager.FONT_SIZE_SMALL, UIThemeManager.ACCENT_GREEN)
	info_section.add_child(status_label)
	
	# Toggle
	var toggle = CheckButton.new()
	toggle.name = "ModelToggle"
	toggle.button_pressed = true
	toggle.custom_minimum_size = Vector2(48, 32)
	container.add_child(toggle)
	
	# Connect signal
	toggle.toggled.connect(_on_model_toggled.bind(model_name, status_label))

func _add_enhanced_card_interactions(card: PanelContainer) -> void:
	"""Add sophisticated hover and interaction effects"""
	card.mouse_entered.connect(func(): _on_card_hover_enter(card))
	card.mouse_exited.connect(func(): _on_card_hover_exit(card))

func _on_card_hover_enter(card: PanelContainer) -> void:
	"""Enhanced hover effect with glow"""
	UIThemeManager.animate_hover_glow(card, UIThemeManager.ACCENT_CYAN, 0.15)

func _on_card_hover_exit(card: PanelContainer) -> void:
	"""Remove hover effect"""
	UIThemeManager.animate_hover_glow_off(card)

func _get_difficulty_icon(difficulty: String) -> String:
	"""Get icon for difficulty level"""
	match difficulty:
		"beginner": return "🟢"
		"intermediate": return "🟡"
		"advanced": return "🔴"
		_: return "⚪"

func _get_difficulty_color(difficulty: String) -> Color:
	"""Get color for difficulty level"""
	match difficulty:
		"beginner": return UIThemeManager.ACCENT_GREEN
		"intermediate": return UIThemeManager.ACCENT_ORANGE
		"advanced": return UIThemeManager.ACCENT_RED
		_: return UIThemeManager.TEXT_SECONDARY

func _apply_current_filter() -> void:
	"""Apply current filter and search to models"""
	for model_name in model_cards:
		var card = model_cards[model_name]
		var metadata = card.get_meta("metadata", {})
		
		var should_show = _should_show_model(model_name, metadata)
		
		if should_show != card.visible:
			if should_show:
				UIThemeManager.animate_entrance(card, 0.0, UIThemeManager.ANIM_DURATION_FAST, "fade_scale")
			else:
				UIThemeManager.animate_exit(card, UIThemeManager.ANIM_DURATION_FAST, "fade_scale")

func _should_show_model(model_name: String, metadata: Dictionary) -> bool:
	"""Determine if model should be shown based on filters"""
	# Category filter
	if current_filter != "all":
		var model_category = metadata.get("category", "all")
		if model_category != current_filter:
			return false
	
	# Search filter
	if search_query != "":
		var search_lower = search_query.to_lower()
		var model_lower = model_name.to_lower()
		var description_lower = metadata.get("description", "").to_lower()
		var keywords = metadata.get("keywords", [])
		
		# Check model name
		if model_lower.contains(search_lower):
			return true
		
		# Check description
		if description_lower.contains(search_lower):
			return true
		
		# Check keywords
		for keyword in keywords:
			if str(keyword).to_lower().contains(search_lower):
				return true
		
		return false
	
	return true

func _update_visibility_counter() -> void:
	"""Update the visibility counter in footer"""
	if visibility_counter:
		visibility_counter.text = "%d/%d models visible" % [visible_models, total_models]

func _clear_models() -> void:
	"""Clear all model cards safely"""
	for child in models_container.get_children():
		models_container.remove_child(child)
		child.queue_free()
	model_cards.clear()

# Enhanced signal handlers
func _on_model_toggled(pressed: bool, model_name: String, status_label: Label) -> void:
	"""Handle model visibility toggle with enhanced feedback"""
	print("[ENHANCED_MODEL_PANEL] Model '%s' toggled to: %s" % [model_name, str(pressed)])
	
	# Update status with smooth animation
	UIThemeManager.animate_fade_text_change(status_label, "👁️ Visible" if pressed else "👁️‍🗨️ Hidden")
	
	# Update status color
	var new_color = UIThemeManager.ACCENT_GREEN if pressed else UIThemeManager.TEXT_DISABLED
	UIThemeManager.apply_modern_label(status_label, UIThemeManager.FONT_SIZE_SMALL, new_color)
	
	# Update counter
	if pressed:
		visible_models += 1
	else:
		visible_models -= 1
	_update_visibility_counter()
	
	model_visibility_changed.emit(model_name, pressed)

func _on_learn_pressed(model_name: String) -> void:
	"""Handle learn button press"""
	print("[ENHANCED_MODEL_PANEL] Learn mode requested for: " + model_name)
	learning_mode_requested.emit(model_name)

func _on_focus_pressed(model_name: String) -> void:
	"""Handle focus button press"""
	print("[ENHANCED_MODEL_PANEL] Focus requested for: " + model_name)
	model_selected.emit(model_name)

func _on_category_selected(category_id: String, pressed: bool) -> void:
	"""Handle category selection"""
	if not pressed:
		return
	
	# Unpress other category chips
	for child in category_container.get_children():
		if child != category_container.find_child("CategoryChip_" + category_id):
			if child is Button:
				child.button_pressed = false
	
	current_filter = category_id
	print("[ENHANCED_MODEL_PANEL] Category selected: " + category_id)
	
	_apply_current_filter()
	category_selected.emit(category_id)

func _on_search_submitted(text: String) -> void:
	"""Handle search submission"""
	search_query = text
	print("[ENHANCED_MODEL_PANEL] Search performed: " + text)
	_apply_current_filter()
	search_performed.emit(text)

func _on_search_text_changed(text: String) -> void:
	"""Handle real-time search"""
	search_query = text
	_apply_current_filter()

func _on_filter_pressed() -> void:
	"""Handle advanced filter button"""
	print("[ENHANCED_MODEL_PANEL] Advanced filters requested")
	# TODO: Implement advanced filter dialog

func _on_view_mode_pressed() -> void:
	"""Toggle between card and list view modes"""
	current_view_mode = "list" if current_view_mode == "cards" else "cards"
	
	# Update button icon
	view_mode_button.text = "🗃️" if current_view_mode == "cards" else "📋"
	view_mode_button.tooltip_text = "Switch to %s view" % ("list" if current_view_mode == "cards" else "card")
	
	print("[ENHANCED_MODEL_PANEL] View mode changed to: " + current_view_mode)
	
	# Rebuild model cards with new view mode
	var model_names = model_cards.keys()
	var model_states = {}
	
	# Save current states
	for model_name in model_names:
		var card = model_cards[model_name]
		var toggle = card.find_child("ModelToggle")
		if toggle:
			model_states[model_name] = toggle.button_pressed
	
	# Recreate cards
	_clear_models()
	
	for i in range(model_names.size()):
		var model_name = model_names[i]
		var card = _create_enhanced_model_card(model_name, i)
		models_container.add_child(card)
		model_cards[model_name] = card
		
		# Restore state
		if model_states.has(model_name):
			var toggle = card.find_child("ModelToggle")
			if toggle:
				toggle.button_pressed = model_states[model_name]
		
		# Animate entrance
		UIThemeManager.animate_entrance(card, i * 0.05, UIThemeManager.ANIM_DURATION_FAST, "fade_scale")

func _on_reset_pressed() -> void:
	"""Reset all model visibility"""
	print("[ENHANCED_MODEL_PANEL] Resetting all model visibility")
	
	for model_name in model_cards:
		var card = model_cards[model_name]
		var toggle = card.find_child("ModelToggle")
		var status_label = card.find_child("StatusLabel")
		
		if toggle and status_label:
			toggle.set_block_signals(true)
			toggle.button_pressed = true
			toggle.set_block_signals(false)
			
			# Update status
			UIThemeManager.animate_fade_text_change(status_label, "👁️ Visible")
			UIThemeManager.apply_modern_label(status_label, UIThemeManager.FONT_SIZE_SMALL, UIThemeManager.ACCENT_GREEN)
	
	visible_models = total_models
	_update_visibility_counter()
	
	# Animate reset feedback
	UIThemeManager.animate_button_press(reset_button, UIThemeManager.ACCENT_ORANGE)

# Public interface enhancements
func update_model_state(model_name: String, visibility: bool) -> void:
	"""Update model state from external source"""
	if not model_cards.has(model_name):
		return
	
	var card = model_cards[model_name]
	var toggle = card.find_child("ModelToggle")
	var status_label = card.find_child("StatusLabel")
	
	if toggle and status_label:
		toggle.set_block_signals(true)
		toggle.button_pressed = visibility
		toggle.set_block_signals(false)
		
		# Update status
		var status_text = "👁️ Visible" if visibility else "👁️‍🗨️ Hidden"
		var status_color = UIThemeManager.ACCENT_GREEN if visibility else UIThemeManager.TEXT_DISABLED
		UIThemeManager.animate_fade_text_change(status_label, status_text)
		UIThemeManager.apply_modern_label(status_label, UIThemeManager.FONT_SIZE_SMALL, status_color)

func set_search_query(query: String) -> void:
	"""Set search query programmatically"""
	search_field.text = query
	search_query = query
	_apply_current_filter()

func set_category_filter(category: String) -> void:
	"""Set category filter programmatically"""
	current_filter = category
	
	# Update chip states
	for child in category_container.get_children():
		if child is Button:
			child.button_pressed = (child.name == "CategoryChip_" + category)
	
	_apply_current_filter()

func get_visible_models() -> Array:
	"""Get list of currently visible models"""
	var visible = []
	for model_name in model_cards:
		var card = model_cards[model_name]
		var toggle = card.find_child("ModelToggle")
		if toggle and toggle.button_pressed:
			visible.append(model_name)
	return visible

func get_learning_recommendations() -> Array:
	"""Get recommended learning sequence based on difficulty"""
	var recommendations = []
	var sorted_models = []
	
	# Sort by difficulty
	for model_name in model_cards:
		var card = model_cards[model_name]
		var metadata = card.get_meta("metadata", {})
		var difficulty = metadata.get("difficulty", "beginner")
		
		var priority = 1 if difficulty == "beginner" else 2 if difficulty == "intermediate" else 3
		sorted_models.append({"name": model_name, "priority": priority, "metadata": metadata})
	
	sorted_models.sort_custom(func(a, b): return a["priority"] < b["priority"])
	
	for item in sorted_models:
		recommendations.append({
			"model_name": item["name"],
			"difficulty": item["metadata"].get("difficulty", "beginner"),
			"learning_objectives": item["metadata"].get("learning_objectives", [])
		})
	
	return recommendations

# Cleanup
func dispose() -> void:
	"""Enhanced cleanup"""
	_clear_models()

func _exit_tree() -> void:
	"""Cleanup on removal"""
	dispose()