# Figma-Enhanced Structure Information Panel
# Professional educational interface with advanced UX patterns

class_name StructureInfoPanel
extends PanelContainer

# ===== ENHANCED UI NODE REFERENCES =====

signal panel_closed
signal structure_bookmarked(structure_id: String, bookmarked: bool)  # NEW
signal related_structure_selected(structure_id: String)  # NEW
signal action_requested(action_type: String, structure_id: String)  # NEW
signal learning_progress_updated(structure_id: String, progress: float)  # NEW


var tween: Tween
var current_structure_id: String = ""
var is_animating: bool = false
var is_bookmarked: bool = false  # NEW: Bookmark state
var learning_progress: float = 0.0  # NEW: Learning progress

# ===== FIGMA-INSPIRED STYLING =====
# Professional color system based on educational psychology
var title_color: Color = UIThemeManager.ACCENT_BLUE
var description_color: Color = UIThemeManager.TEXT_PRIMARY
var function_color: Color = UIThemeManager.ACCENT_GREEN
var bookmark_active_color: Color = UIThemeManager.ACCENT_YELLOW
var bookmark_inactive_color: Color = UIThemeManager.TEXT_SECONDARY

# ===== ENHANCED SIGNALS =====
var margin = MarginContainer.new()
margin.name = "MarginContainer"
margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
margin.add_theme_constant_override("margin_top", UIThemeManager.MARGIN_MEDIUM)
margin.add_theme_constant_override("margin_bottom", UIThemeManager.MARGIN_MEDIUM)
margin.add_theme_constant_override("margin_left", UIThemeManager.MARGIN_MEDIUM)
margin.add_theme_constant_override("margin_right", UIThemeManager.MARGIN_MEDIUM)
add_child(margin)

# FIXED: Orphaned code - var main_vbox = VBoxContainer.new()
main_vbox.name = "MainVBox"
main_vbox.add_theme_constant_override("separation", UIThemeManager.MARGIN_SMALL)
margin.add_child(main_vbox)

# ===== ENHANCED HEADER WITH BOOKMARK =====
var header_container = VBoxContainer.new()
header_container.name = "HeaderContainer"
main_vbox.add_child(header_container)

# Title bar with close and bookmark
var title_bar = HBoxContainer.new()
title_bar.name = "TitleBar"
header_container.add_child(title_bar)

# Structure name (enhanced typography)
structure_name_label = Label.new()
structure_name_label.name = "StructureName"
structure_name_label.text = "Structure Name"
structure_name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
title_bar.add_child(structure_name_label)

# Bookmark button (NEW Figma feature)
bookmark_button = Button.new()
bookmark_button.name = "BookmarkButton"
bookmark_button.text = "★"
bookmark_button.custom_minimum_size = Vector2(32, 32)
bookmark_button.flat = true
bookmark_button.tooltip_text = "Bookmark this structure"
title_bar.add_child(bookmark_button)

# Close button
close_button = Button.new()
close_button.name = "CloseButton"
close_button.text = "✕"
close_button.custom_minimum_size = Vector2(32, 32)
close_button.flat = true
close_button.tooltip_text = "Close panel"
title_bar.add_child(close_button)

# Learning progress bar (NEW)
learning_progress_bar = ProgressBar.new()
learning_progress_bar.name = "LearningProgress"
learning_progress_bar.custom_minimum_size = Vector2(0, 6)
learning_progress_bar.value = 0
learning_progress_bar.max_value = 100
header_container.add_child(learning_progress_bar)

# Difficulty badge (NEW)
# FIXED: Orphaned code - var difficulty_container = HBoxContainer.new()
difficulty_container.name = "DifficultyContainer"
header_container.add_child(difficulty_container)

difficulty_badge = Label.new()
difficulty_badge.name = "DifficultyBadge"
difficulty_badge.text = "Beginner"
difficulty_badge.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
difficulty_container.add_child(difficulty_badge)

# Separator
var separator = HSeparator.new()
separator.add_theme_constant_override("separation", UIThemeManager.MARGIN_SMALL)
main_vbox.add_child(separator)

# ===== ENHANCED CONTENT AREA =====
var scroll = ScrollContainer.new()
scroll.name = "ScrollContainer"
scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
main_vbox.add_child(scroll)

# FIXED: Orphaned code - var content_vbox = VBoxContainer.new()
content_vbox.name = "ContentVBox"
content_vbox.add_theme_constant_override("separation", UIThemeManager.MARGIN_MEDIUM)
scroll.add_child(content_vbox)

# Description section (enhanced)
# FIXED: Orphaned code - var desc_header = Label.new()
desc_header.text = "📖 Description"
desc_header.add_theme_font_size_override("font_size", UIThemeManager.FONT_SIZES.h3)
desc_header.add_theme_color_override("font_color", UIThemeManager.TEXT_SECONDARY)
content_vbox.add_child(desc_header)

description_text = RichTextLabel.new()
description_text.name = "DescriptionText"
description_text.custom_minimum_size = Vector2(0, 100)
description_text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
description_text.fit_content = true
description_text.scroll_active = false
description_text.bbcode_enabled = true
description_text.selection_enabled = true  # Allow text selection
content_vbox.add_child(description_text)

# Functions section (enhanced)
# FIXED: Orphaned code - var func_header = Label.new()
func_header.text = "⚡ Functions"
func_header.add_theme_font_size_override("font_size", UIThemeManager.FONT_SIZES.h3)
func_header.add_theme_color_override("font_color", UIThemeManager.TEXT_SECONDARY)
content_vbox.add_child(func_header)

functions_list = VBoxContainer.new()
functions_list.name = "FunctionsList"
functions_list.add_theme_constant_override("separation", UIThemeManager.MARGIN_SMALL)
content_vbox.add_child(functions_list)

# Related structures section (NEW)
# FIXED: Orphaned code - var related_header = Label.new()
related_header.text = "🔗 Related Structures"
related_header.add_theme_font_size_override("font_size", UIThemeManager.FONT_SIZES.h3)
related_header.add_theme_color_override("font_color", UIThemeManager.TEXT_SECONDARY)
content_vbox.add_child(related_header)

# FIXED: Orphaned code - var related_scroll = ScrollContainer.new()
related_scroll.custom_minimum_size = Vector2(0, 40)
related_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
content_vbox.add_child(related_scroll)

related_structures_container = HBoxContainer.new()
related_structures_container.name = "RelatedStructures"
related_structures_container.add_theme_constant_override(
"separation", UIThemeManager.MARGIN_SMALL
)
related_scroll.add_child(related_structures_container)

# ===== ACTION BUTTONS BAR (NEW FIGMA FEATURE) =====
var action_separator = HSeparator.new()
main_vbox.add_child(action_separator)

action_buttons_container = HBoxContainer.new()
action_buttons_container.name = "ActionButtons"
action_buttons_container.add_theme_constant_override("separation", UIThemeManager.MARGIN_SMALL)
main_vbox.add_child(action_buttons_container)

# Create action buttons
_create_action_buttons()


# FIXED: Orphaned code - var buttons_data = [
{"text": "📝 Notes", "action": "notes", "color": UIThemeManager.ACCENT_BLUE},
{"text": "🧪 Quiz", "action": "quiz", "color": UIThemeManager.ACCENT_GREEN},
{"text": "📚 Study", "action": "study", "color": UIThemeManager.ACCENT_PURPLE},
{"text": "🔍 Explore", "action": "explore", "color": UIThemeManager.ACCENT_TEAL}
]

var button = Button.new()
button.text = button_data.text
button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
button.custom_minimum_size.y = 36

# Apply Figma-inspired button styling
UIThemeManager.apply_modern_button(button, button_data.color, "secondary")
UIThemeManager.add_hover_effect(button)

# Connect to action handler
button.pressed.connect(_on_action_button_pressed.bind(button_data.action))

action_buttons_container.add_child(button)


# FIXED: Orphaned code - var badge_style = StyleBoxFlat.new()
badge_style.corner_radius_top_left = 12
badge_style.corner_radius_top_right = 12
badge_style.corner_radius_bottom_left = 12
badge_style.corner_radius_bottom_right = 12
badge_style.content_margin_left = 8
badge_style.content_margin_right = 8
badge_style.content_margin_top = 4
badge_style.content_margin_bottom = 4

"beginner":
	badge_style.bg_color = Color(
	UIThemeManager.ACCENT_GREEN.r,
	UIThemeManager.ACCENT_GREEN.g,
	UIThemeManager.ACCENT_GREEN.b,
	0.2
	)
	difficulty_badge.add_theme_color_override("font_color", UIThemeManager.ACCENT_GREEN)
	"intermediate":
		badge_style.bg_color = Color(
		UIThemeManager.ACCENT_YELLOW.r,
		UIThemeManager.ACCENT_YELLOW.g,
		UIThemeManager.ACCENT_YELLOW.b,
		0.2
		)
		difficulty_badge.add_theme_color_override("font_color", UIThemeManager.ACCENT_YELLOW)
		"advanced":
			badge_style.bg_color = Color(
			UIThemeManager.ACCENT_RED.r,
			UIThemeManager.ACCENT_RED.g,
			UIThemeManager.ACCENT_RED.b,
			0.2
			)
			difficulty_badge.add_theme_color_override("font_color", UIThemeManager.ACCENT_RED)

			difficulty_badge.add_theme_stylebox_override("normal", badge_style)


# FIXED: Orphaned code - var display_name = structure_data.get("displayName", "Unknown Structure")
	UIThemeManager.animate_fade_text_change(structure_name_label, display_name)

	# ===== ENHANCED DESCRIPTION =====
var description = structure_data.get("shortDescription", "No description available.")
	description_text.text = _format_enhanced_rich_text(description)

	# ===== DIFFICULTY ASSESSMENT =====
var difficulty = _assess_content_difficulty(structure_data)
# FIXED: Orphaned code - var functions = structure_data.get("functions", [])
	_update_enhanced_functions(functions)

	# ===== RELATED STRUCTURES (NEW) =====
var related = structure_data.get("related", _generate_related_structures(structure_data))
	_update_related_structures(related)


# FIXED: Orphaned code - var functions_count = structure_data.get("functions", []).size()
# FIXED: Orphaned code - var description_length = structure_data.get("shortDescription", "").length()

# Simple heuristic for difficulty assessment
var formatted = "[color=%s]%s[/color]" % [UIThemeManager.TEXT_PRIMARY.to_html(), text]

# Enhanced anatomical term highlighting with colors
var term_categories = {
"brain_regions":
	{
	"terms": ["hippocampus", "amygdala", "thalamus", "cortex", "cerebellum", "brainstem"],
	"color": UIThemeManager.ACCENT_BLUE.to_html()
	},
	"functions":
		{
		"terms": ["memory", "learning", "emotion", "motor", "sensory", "cognitive"],
		"color": UIThemeManager.ACCENT_GREEN.to_html()
		},
		"connections":
			{
			"terms": ["neural", "synaptic", "pathway", "network", "circuit"],
			"color": UIThemeManager.ACCENT_TEAL.to_html()
			}
			}

# FIXED: Orphaned code - var data = term_categories[category]
var regex = RegEx.new()
	regex.compile("(?i)\\b" + term + "\\b")
	formatted = regex.sub(formatted, "[color=%s][b]$0[/b][/color]" % data.color, true)

# FIXED: Orphaned code - var placeholder = Label.new()
	placeholder.text = "No functions information available"
	UIThemeManager.apply_modern_label(
	placeholder, UIThemeManager.FONT_SIZES.caption, UIThemeManager.TEXT_TERTIARY
	)
	functions_list.add_child(placeholder)

	# Create enhanced function items with staggered animation
var function_text = str(functions_array[i])
# FIXED: Orphaned code - var item = _create_enhanced_function_item(function_text, i)
	functions_list.add_child(item)

	# Staggered entrance animation
	UIThemeManager.animate_entrance(
	item, i * 0.05, UIThemeManager.ANIMATION.normal, "slide_fade"
	)


# FIXED: Orphaned code - var card = PanelContainer.new()

# Apply card styling
var card_style = UIThemeManager.create_educational_card_style("default")
	card_style.content_margin_left = UIThemeManager.MARGIN_SMALL
	card_style.content_margin_right = UIThemeManager.MARGIN_SMALL
	card_style.content_margin_top = UIThemeManager.MARGIN_SMALL
	card_style.content_margin_bottom = UIThemeManager.MARGIN_SMALL
	card.add_theme_stylebox_override("panel", card_style)

# FIXED: Orphaned code - var hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", UIThemeManager.MARGIN_SMALL)
	card.add_child(hbox)

	# Enhanced bullet with color coding
var bullet = Label.new()
# FIXED: Orphaned code - var color = Color.from_hsv(float(index) * 0.15, 0.7, 0.9)
	bullet.text = "●"
	UIThemeManager.apply_modern_label(bullet, UIThemeManager.FONT_SIZES.body, color)
	bullet.custom_minimum_size.x = 20
	hbox.add_child(bullet)

	# Enhanced function text
var label = Label.new()
	label.text = text
	UIThemeManager.apply_modern_label(label, UIThemeManager.FONT_SIZES.body, function_color)
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hbox.add_child(label)

	# Add hover effect to card
	UIThemeManager.add_hover_effect(card)

# FIXED: Orphaned code - var structure_name = str(related_array[i])
# FIXED: Orphaned code - var chip = _create_structure_chip(structure_name, i)
	related_structures_container.add_child(chip)


# FIXED: Orphaned code - var chip_2 = Button.new()
	chip.text = structure_name
	chip.flat = true
	chip.custom_minimum_size.y = 28

	# Chip styling
var chip_style = StyleBoxFlat.new()
	chip_style.bg_color = Color(
	UIThemeManager.ACCENT_BLUE.r,
	UIThemeManager.ACCENT_BLUE.g,
	UIThemeManager.ACCENT_BLUE.b,
	0.2
	)
	chip_style.border_color = UIThemeManager.ACCENT_BLUE
	chip_style.border_width_left = 1
	chip_style.border_width_right = 1
	chip_style.border_width_top = 1
	chip_style.border_width_bottom = 1
	chip_style.corner_radius_top_left = 14
	chip_style.corner_radius_top_right = 14
	chip_style.corner_radius_bottom_left = 14
	chip_style.corner_radius_bottom_right = 14
	chip_style.content_margin_left = UIThemeManager.MARGIN_SMALL
	chip_style.content_margin_right = UIThemeManager.MARGIN_SMALL
	chip_style.content_margin_top = 4
	chip_style.content_margin_bottom = 4

	chip.add_theme_stylebox_override("normal", chip_style)
	UIThemeManager.apply_modern_label(
	chip, UIThemeManager.FONT_SIZES.caption, UIThemeManager.ACCENT_BLUE
	)

	# Connect to selection
	chip.pressed.connect(_on_related_structure_selected.bind(structure_name))

	# Add interaction effects
	UIThemeManager.add_hover_effect(chip)

	# Staggered entrance
	UIThemeManager.animate_entrance(chip, index * 0.1)

# FIXED: Orphaned code - var structure_name_2 = structure_data.get("displayName", "").to_lower()

# FIXED: Orphaned code - var tween_2 = learning_progress_bar.create_tween()
	tween.tween_property(learning_progress_bar, "value", learning_progress, 0.5)

	# Emit progress signal
	learning_progress_updated.emit(current_structure_id, learning_progress)


# FIXED: Orphaned code - var color_2 = bookmark_active_color if is_bookmarked else bookmark_inactive_color
	UIThemeManager.apply_modern_button(bookmark_button, color, "icon")


	# ===== ENHANCED ANIMATIONS =====


var tween_3 = create_tween()
	tween.set_parallel(true)

	# Slide in from right
	(
	tween
	. tween_property(self, "position:x", position.x - 50, 0.4)
	. set_trans(Tween.TRANS_QUART)
	. set_ease(Tween.EASE_OUT)
	)

	# Fade in
	tween.tween_property(self, "modulate:a", 1.0, 0.3).set_ease(Tween.EASE_OUT)

	# Scale to normal
	tween.tween_property(self, "scale", Vector2.ONE, 0.35).set_trans(Tween.TRANS_BACK).set_ease(
	Tween.EASE_OUT
	)

	# Complete animation
	tween.tween_callback(func(): is_animating = false).set_delay(0.4)


	# ===== ENHANCED SIGNAL HANDLERS =====


var tween_4 = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 0.0, 0.25)
	(
	tween
	. tween_property(self, "position:x", position.x + 30, 0.25)
	. set_trans(Tween.TRANS_QUART)
	. set_ease(Tween.EASE_IN)
	)
	(
	tween
	. tween_callback(
	func():
		visible = false
		is_animating = false
		panel_closed.emit()
		)
		. set_delay(0.25)
		)


@onready var structure_name_label: Label
@onready var close_button: Button
@onready var bookmark_button: Button  # NEW: Figma-inspired bookmark
@onready var description_text: RichTextLabel
@onready var functions_list: VBoxContainer
@onready var related_structures_container: HBoxContainer  # NEW: Related structure chips
@onready var action_buttons_container: HBoxContainer  # NEW: Action buttons bar
@onready var learning_progress_bar: ProgressBar  # NEW: Learning progress indicator
@onready var difficulty_badge: Label  # NEW: Difficulty indicator

# ===== ANIMATION AND STATE =====

func _ready() -> void:
	call_deferred("_initialize_enhanced_panel")


func _initialize_enhanced_panel() -> void:
	"""Initialize panel with Figma-inspired enhancements"""
	# Create enhanced UI structure
	if not _find_ui_nodes():
		_create_figma_enhanced_ui()

		# Apply professional styling
		_setup_figma_styling()
		_connect_enhanced_signals()

		# Initialize enhanced state
		clear_data()
		print("[ENHANCED_INFO_PANEL] Figma-inspired panel initialized")


func _exit_tree() -> void:
	"""Cleanup on removal"""
	dispose()

func display_structure_data(structure_data: Dictionary) -> void:
	"""Display structure information with enhanced Figma UX"""
	if structure_data.is_empty():
		print("[ENHANCED_INFO_PANEL] Empty structure data received")
		clear_data()
		return

		current_structure_id = structure_data.get("id", "unknown")
		print("[ENHANCED_INFO_PANEL] Displaying: " + current_structure_id)

		# Show panel with enhanced animation
		if not visible:
			_animate_figma_entrance()

			# Update all content with enhanced features
			_update_enhanced_content(structure_data)
			_update_learning_progress()
			_update_bookmark_state()


func clear_data() -> void:
	"""Enhanced clear data with all new features"""
	current_structure_id = ""
	is_bookmarked = false
	learning_progress = 0.0

	if structure_name_label:
		structure_name_label.text = "No Structure Selected"

		if description_text:
			description_text.text = (
			"[color=%s][i]Select a structure to view information[/i][/color]"
			% UIThemeManager.TEXT_TERTIARY.to_html()
			)

			if learning_progress_bar:
				learning_progress_bar.value = 0

				if difficulty_badge:
					difficulty_badge.text = "Unknown"
					_style_difficulty_badge("beginner")

					_clear_functions()
					_clear_related_structures()
					visible = false


					# Keep all existing methods for compatibility
func hide_panel() -> void:
	"""Hide panel with animation"""
	_animate_exit()


func show_panel() -> void:
	"""Show panel with animation"""
	_animate_figma_entrance()


func dispose() -> void:
	"""Clean up resources"""
	if tween:
		tween.kill()
		clear_data()


for button_data in buttons_data:
if description_text:
if difficulty_badge:
	difficulty_badge.text = difficulty.capitalize()
	_style_difficulty_badge(difficulty)
	UIThemeManager.animate_entrance(difficulty_badge, 0.2)

	# ===== ENHANCED FUNCTIONS LIST =====
if functions_count <= 2 and description_length < 200:
	return "beginner"
	elif functions_count <= 4 and description_length < 400:
		return "intermediate"
		else:
			return "advanced"


for category in term_categories:
for term in data.terms:
return formatted


for i in range(functions_array.size()):
return card


return chip


if "hippocampus" in structure_name:
	return ["Amygdala", "Fornix", "Temporal Lobe"]
	elif "cortex" in structure_name:
		return ["Thalamus", "Corpus Callosum", "White Matter"]
		else:
			return ["Related Structure 1", "Related Structure 2"]


func _find_ui_nodes() -> bool:
	"""Try to find existing and new UI nodes"""
	structure_name_label = find_child("StructureName", true, false) as Label
	close_button = find_child("CloseButton", true, false) as Button
	bookmark_button = find_child("BookmarkButton", true, false) as Button
	description_text = find_child("DescriptionText", true, false) as RichTextLabel
	functions_list = find_child("FunctionsList", true, false) as VBoxContainer
	related_structures_container = find_child("RelatedStructures", true, false) as HBoxContainer
	action_buttons_container = find_child("ActionButtons", true, false) as HBoxContainer
	learning_progress_bar = find_child("LearningProgress", true, false) as ProgressBar
	difficulty_badge = find_child("DifficultyBadge", true, false) as Label

	return (
	structure_name_label != null
	and close_button != null
	and description_text != null
	and functions_list != null
	)


func _create_figma_enhanced_ui() -> void:
	"""Create Figma-inspired UI structure with professional layout"""
	print("[ENHANCED_INFO_PANEL] Creating Figma-enhanced UI structure")

	# ===== MAIN CONTAINER SYSTEM =====
func _create_action_buttons() -> void:
	"""Create Figma-inspired action buttons"""
func _setup_figma_styling() -> void:
	"""Apply Figma-inspired professional styling"""

	# ===== PANEL GLASS MORPHISM =====
	UIThemeManager.apply_glass_panel(self, UIThemeManager.COLORS.surface.a, "elevated")

	# ===== ENHANCED TYPOGRAPHY =====
	if structure_name_label:
		UIThemeManager.apply_modern_label(
		structure_name_label, UIThemeManager.FONT_SIZES.h1, title_color, "heading"
		)

		# ===== BOOKMARK BUTTON STYLING =====
		if bookmark_button:
			UIThemeManager.apply_modern_button(bookmark_button, bookmark_inactive_color, "icon")
			UIThemeManager.add_hover_effect(bookmark_button)

			# ===== CLOSE BUTTON STYLING =====
			if close_button:
				UIThemeManager.apply_modern_button(close_button, UIThemeManager.ACCENT_RED, "icon")
				UIThemeManager.add_hover_effect(close_button)

				# ===== PROGRESS BAR STYLING =====
				if learning_progress_bar:
					UIThemeManager.apply_progress_bar_styling(learning_progress_bar, UIThemeManager.ACCENT_BLUE)

					# ===== DIFFICULTY BADGE STYLING =====
					if difficulty_badge:
						_style_difficulty_badge("beginner")  # Default styling

						# ===== ENHANCED RICH TEXT =====
						if description_text:
							UIThemeManager.apply_rich_text_styling(
							description_text, UIThemeManager.FONT_SIZES.body, "description"
							)

							print("[ENHANCED_INFO_PANEL] Figma professional styling applied")


func _style_difficulty_badge(difficulty: String) -> void:
	"""Apply difficulty-specific styling"""
	if not difficulty_badge:
		return

func _connect_enhanced_signals() -> void:
	"""Connect enhanced UI signals"""
	if close_button and not close_button.pressed.is_connected(_on_close_pressed):
		close_button.pressed.connect(_on_close_pressed)

		if bookmark_button and not bookmark_button.pressed.is_connected(_on_bookmark_pressed):
			bookmark_button.pressed.connect(_on_bookmark_pressed)


			# ===== ENHANCED PUBLIC INTERFACE =====


func _update_enhanced_content(structure_data: Dictionary) -> void:
	"""Update content with Figma-enhanced features"""

	# ===== STRUCTURE NAME WITH ANIMATION =====
	if structure_name_label:
func _assess_content_difficulty(structure_data: Dictionary) -> String:
	"""Assess content difficulty for educational scaffolding"""
func _format_enhanced_rich_text(text: String) -> String:
	"""Enhanced rich text formatting with educational highlighting"""
func _update_enhanced_functions(functions_array: Array) -> void:
	"""Update functions with enhanced visual design"""
	_clear_functions()

	if functions_array.is_empty():
func _create_enhanced_function_item(text: String, index: int) -> Control:
	"""Create Figma-inspired function list item"""
func _update_related_structures(related_array: Array) -> void:
	"""Update related structures with clickable chips"""
	_clear_related_structures()

	if related_array.is_empty():
		return

		for i in range(min(related_array.size(), 5)):  # Limit to 5 related structures
func _create_structure_chip(structure_name: String, index: int) -> Button:
	"""Create clickable structure chip with Figma styling"""
func _generate_related_structures(structure_data: Dictionary) -> Array:
	"""Generate related structures based on current structure"""
	# This would typically come from your knowledge base
	# For demo, return some sample related structures
func _update_learning_progress() -> void:
	"""Update learning progress based on interaction history"""
	# This would connect to your learning analytics system
	# For demo, simulate progress
	learning_progress += 10.0
	if learning_progress > 100.0:
		learning_progress = 100.0

		if learning_progress_bar:
func _update_bookmark_state() -> void:
	"""Update bookmark button state"""
	# This would check your bookmark system
	# For demo, cycle bookmark state
	if bookmark_button:
func _animate_figma_entrance() -> void:
	"""Figma-inspired entrance animation with professional timing"""
	if is_animating:
		return

		is_animating = true
		visible = true

		# Multi-stage entrance animation
		position.x += 50
		modulate.a = 0.0
		scale = Vector2(0.95, 0.95)

func _on_bookmark_pressed() -> void:
	"""Handle bookmark button with visual feedback"""
	is_bookmarked = !is_bookmarked
	_update_bookmark_state()

	# Visual feedback
	UIThemeManager.animate_button_press(
	bookmark_button, bookmark_active_color if is_bookmarked else bookmark_inactive_color
	)

	# Emit signal
	structure_bookmarked.emit(current_structure_id, is_bookmarked)
	print("[ENHANCED_INFO_PANEL] Bookmark toggled: %s = %s" % [current_structure_id, is_bookmarked])


func _on_related_structure_selected(structure_name: String) -> void:
	"""Handle related structure selection"""
	related_structure_selected.emit(structure_name)
	print("[ENHANCED_INFO_PANEL] Related structure selected: " + structure_name)


func _on_action_button_pressed(action_type: String) -> void:
	"""Handle action button presses"""
	action_requested.emit(action_type, current_structure_id)
	print("[ENHANCED_INFO_PANEL] Action requested: %s for %s" % [action_type, current_structure_id])


	# ===== CLEANUP AND UTILITIES =====


func _clear_related_structures() -> void:
	"""Clear related structures safely"""
	if not related_structures_container:
		return

		for child in related_structures_container.get_children():
			related_structures_container.remove_child(child)
			child.queue_free()


func _animate_exit() -> void:
	"""Enhanced exit animation"""
	if is_animating:
		return

		is_animating = true

func _on_close_pressed() -> void:
	"""Handle close button press"""
	print("[ENHANCED_INFO_PANEL] Close button pressed")
	hide_panel()


	# Keep existing methods for backward compatibility
func _update_content(structure_data: Dictionary) -> void:
	"""Legacy method - redirects to enhanced version"""
	_update_enhanced_content(structure_data)


func _format_rich_text(text: String) -> String:
	"""Legacy method - redirects to enhanced version"""
	return _format_enhanced_rich_text(text)


func _update_functions(functions_array: Array) -> void:
	"""Legacy method - redirects to enhanced version"""
	_update_enhanced_functions(functions_array)


func _create_function_item(text: String, index: int) -> Control:
	"""Legacy method - redirects to enhanced version"""
	return _create_enhanced_function_item(text, index)


func _clear_functions() -> void:
	"""Clear functions list safely"""
	if not functions_list:
		return

		for child in functions_list.get_children():
			functions_list.remove_child(child)
			child.queue_free()


			# Keep cleanup methods
