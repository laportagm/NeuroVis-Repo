# Educational Tooltip Manager
# Sophisticated tooltip system for educational context and learning aids

class_name EducationalTooltipManager
extends Control

# === DEPENDENCIES ===

signal tooltip_shown(target_node: Control, content: Dictionary)
signal tooltip_hidden(target_node: Control)


const UIThemeManager = prepreload("res://ui/panels/UIThemeManager.gd")

# Tooltip components
const HOVER_DELAY = 0.5
const FADE_DURATION = 0.2
const TOOLTIP_OFFSET = Vector2(10, -10)
const MAX_WIDTH = 300

# Educational content database

var current_target: Control = null
var hover_timer: Timer
var fade_timer: Timer
var is_showing: bool = false
var tooltip_data: Dictionary = {}

# Configuration
var educational_tooltips: Dictionary = {
	"brain_structures":
	{
		"Hippocampus":
		{
			"title": "🧠 Hippocampus",
			"description":
			"Critical for learning and memory formation. Part of the limbic system that converts short-term memories to long-term storage.",
			"category": "Limbic System",
			"difficulty": "intermediate",
			"quick_facts":
			[
				"Named after its seahorse-like shape",
				"Essential for spatial navigation",
				"Can regenerate neurons throughout life"
			],
			"learning_tip": "Remember: 'Hip-po-campus' = 'Horse-shaped campus' for learning!"
		},
		"Thalamus":
		{
			"title": "⚡ Thalamus",
			"description":
			"The brain's relay station. Processes and forwards sensory information to the cerebral cortex.",
			"category": "Diencephalon",
			"difficulty": "beginner",
			"quick_facts":
			[
				"Located at the brain's center",
				"Has over 50 distinct nuclei",
				"Regulates consciousness and sleep"
			],
			"learning_tip": "Think 'Thalamus' = 'Through-all-of-us' - everything passes through!"
		},
		"Striatum":
		{
			"title": "🎯 Striatum",
			"description":
			"Part of the basal ganglia controlling movement, habit formation, and reward processing.",
			"category": "Basal Ganglia",
			"difficulty": "advanced",
			"quick_facts":
			[
				"Includes caudate nucleus and putamen",
				"Rich in dopamine receptors",
				"Critical for motor learning"
			],
			"learning_tip": "Striatum = 'Striped' appearance under microscope"
		}
	},
	"ui_elements":
	{
		"search_field":
		{
			"title": "🔍 Smart Search",
			"description":
			"Search brain structures, functions, or anatomical terms. Use keywords like 'memory', 'movement', or specific structure names.",
			"category": "Navigation",
			"difficulty": "beginner",
			"quick_facts":
			[
				"Supports partial matching",
				"Searches descriptions and functions",
				"Case-insensitive search"
			],
			"learning_tip": "Try searching by function (e.g., 'memory') to find related structures!"
		},
		"difficulty_indicator":
		{
			"title": "📊 Difficulty Levels",
			"description":
			"Content complexity indicator to help pace your learning journey through neuroanatomy.",
			"category": "Learning Aid",
			"difficulty": "beginner",
			"quick_facts":
			[
				"🟢 Beginner: Basic concepts",
				"🟡 Intermediate: Detailed anatomy",
				"🔴 Advanced: Complex relationships"
			],
			"learning_tip": "Start with beginner content and progress gradually!"
		},
		"bookmark_system":
		{
			"title": "⭐ Learning Bookmarks",
			"description":
			"Save important structures for quick review and create your personal study collection.",
			"category": "Study Tools",
			"difficulty": "beginner",
			"quick_facts":
			[
				"Quick access to saved content",
				"Organize your learning path",
				"Track study progress"
			],
			"learning_tip": "Bookmark structures you find challenging for focused review!"
		}
	}
}

	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_top", UIThemeManager.MARGIN_MEDIUM)
	margin.add_theme_constant_override("margin_bottom", UIThemeManager.MARGIN_MEDIUM)
	margin.add_theme_constant_override("margin_left", UIThemeManager.MARGIN_MEDIUM)
	margin.add_theme_constant_override("margin_right", UIThemeManager.MARGIN_MEDIUM)
	tooltip_panel.add_child(margin)

	tooltip_content = VBoxContainer.new()
	tooltip_content.name = "TooltipContent"
	tooltip_content.add_theme_constant_override("separation", UIThemeManager.MARGIN_SMALL)
	margin.add_child(tooltip_content)

	# Header with title and category
	var header_container = HBoxContainer.new()
	header_container.add_theme_constant_override("separation", UIThemeManager.MARGIN_MEDIUM)
	tooltip_content.add_child(header_container)

	# Title
	tooltip_header = Label.new()
	tooltip_header.name = "TooltipHeader"
	tooltip_header.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	UIThemeManager.apply_modern_label(
		tooltip_header, UIThemeManager.FONT_SIZE_MEDIUM, UIThemeManager.TEXT_PRIMARY, "heading"
	)
	header_container.add_child(tooltip_header)

	# Category badge
	tooltip_category = Label.new()
	tooltip_category.name = "TooltipCategory"
	UIThemeManager.apply_modern_label(
		tooltip_category, UIThemeManager.FONT_SIZE_TINY, UIThemeManager.ACCENT_CYAN, "badge", true
	)
	header_container.add_child(tooltip_category)

	# Main description
	tooltip_body = RichTextLabel.new()
	tooltip_body.name = "TooltipBody"
	tooltip_body.custom_minimum_size = Vector2(MAX_WIDTH, 0)
	tooltip_body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tooltip_body.bbcode_enabled = true
	tooltip_body.fit_content = true
	tooltip_body.scroll_active = false
	UIThemeManager.apply_rich_text_styling(
		tooltip_body, UIThemeManager.FONT_SIZE_SMALL, "description"
	)
	tooltip_content.add_child(tooltip_body)

	# Footer with difficulty and learning tip
	tooltip_footer = HBoxContainer.new()
	tooltip_footer.name = "TooltipFooter"
	tooltip_footer.add_theme_constant_override("separation", UIThemeManager.MARGIN_MEDIUM)
	tooltip_content.add_child(tooltip_footer)

	# Difficulty indicator
	tooltip_difficulty = Label.new()
	tooltip_difficulty.name = "TooltipDifficulty"
	tooltip_difficulty.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	UIThemeManager.apply_modern_label(
		tooltip_difficulty, UIThemeManager.FONT_SIZE_TINY, UIThemeManager.TEXT_SECONDARY, "caption"
	)
	tooltip_footer.add_child(tooltip_difficulty)


		var display_name = structure_data.get("displayName", structure_id)
		var description = structure_data.get("shortDescription", "Brain structure")
		var functions = structure_data.get("functions", [])

		educational_tooltips["brain_structures"][structure_id] = {
			"title": "🧠 " + display_name,
			"description": description,
			"category": "Brain Structure",
			"difficulty": _assess_difficulty(description, functions),
			"quick_facts": _extract_quick_facts(functions),
			"learning_tip": _generate_learning_tip(display_name)
		}

	register_tooltip(target, structure_id, "brain_structures")


	var word_count = description.split(" ").size()
	var function_count = functions.size()
	var complexity_score = word_count + (function_count * 10)

	if complexity_score < 30:
		return "beginner"
	elif complexity_score < 60:
		return "intermediate"
	else:
		return "advanced"


	var facts = []
	for i in range(min(3, functions.size())):
		var function_text = str(functions[i])
		# Simplify to key phrase
		if function_text.length() > 50:
			function_text = function_text.substr(0, 47) + "..."
		facts.append(function_text)
	return facts


	var tips = {
		"Hippocampus": "Remember: 'Hip-po-campus' = Horse-shaped learning center!",
		"Thalamus": "Think: 'Through-all-of-us' - everything passes through!",
		"Amygdala": "Almond-shaped emotion center - 'A-MYG-dala' = 'Ah, my fear!'",
		"Cerebellum": "Little brain that coordinates - 'Balance like a gymnast!'",
		"Cortex": "Gray matter that matters - where thinking happens!"
	}

	return tips.get(structure_name, "Break down the name to remember its function!")


	var category_data = educational_tooltips.get(category, {})
	tooltip_data = category_data.get(tooltip_id, {})

	if tooltip_data.is_empty():
		print(
			(
				"[TOOLTIP_MANAGER] No tooltip data found for: %s in category: %s"
				% [tooltip_id, category]
			)
		)
		return

	current_target = target
	_update_tooltip_content()
	_position_tooltip(target)
	_show_with_animation()

	tooltip_shown.emit(target, tooltip_data)


	var description = tooltip_data.get("description", "")
	var quick_facts = tooltip_data.get("quick_facts", [])
	var learning_tip = tooltip_data.get("learning_tip", "")

	var content = (
		"[font_size=%d][color=%s]%s[/color][/font_size]"
		% [UIThemeManager.FONT_SIZE_SMALL, UIThemeManager.TEXT_PRIMARY.to_html(), description]
	)

	# Add quick facts if available
	if quick_facts.size() > 0:
		content += (
			"\n\n[font_size=%d][color=%s][b]Quick Facts:[/b][/color][/font_size]"
			% [UIThemeManager.FONT_SIZE_TINY, UIThemeManager.ACCENT_CYAN.to_html()]
		)

		for fact in quick_facts:
			content += (
				"\n[font_size=%d][color=%s]• %s[/color][/font_size]"
				% [
					UIThemeManager.FONT_SIZE_TINY,
					UIThemeManager.TEXT_SECONDARY.to_html(),
					str(fact)
				]
			)

	# Add learning tip if available
	if learning_tip != "":
		content += (
			"\n\n[font_size=%d][color=%s][b]💡 Learning Tip:[/b][/color][/font_size]"
			% [UIThemeManager.FONT_SIZE_TINY, UIThemeManager.ACCENT_YELLOW.to_html()]
		)
		content += (
			"\n[font_size=%d][color=%s][i]%s[/i][/color][/font_size]"
			% [UIThemeManager.FONT_SIZE_TINY, UIThemeManager.TEXT_SECONDARY.to_html(), learning_tip]
		)

	tooltip_body.text = content

	# Difficulty indicator
	var difficulty = tooltip_data.get("difficulty", "beginner")
	var difficulty_icon = _get_difficulty_icon(difficulty)
	var difficulty_color = _get_difficulty_color(difficulty)

	tooltip_difficulty.text = "%s %s" % [difficulty_icon, difficulty.capitalize()]
	UIThemeManager.apply_modern_label(
		tooltip_difficulty, UIThemeManager.FONT_SIZE_TINY, difficulty_color, "caption"
	)


	var target_global_pos = target.global_position
	var target_size = target.size

	# Get viewport size
	var viewport_size = get_viewport().get_visible_rect().size

	# Calculate preferred position (above and to the right of target)
	var preferred_pos = target_global_pos + Vector2(target_size.x, 0) + TOOLTIP_OFFSET

	# Ensure tooltip fits within viewport
	var tooltip_size = tooltip_panel.get_combined_minimum_size()

	# Adjust horizontal position if needed
	if preferred_pos.x + tooltip_size.x > viewport_size.x:
		preferred_pos.x = target_global_pos.x - tooltip_size.x - TOOLTIP_OFFSET.x

	# Adjust vertical position if needed
	if preferred_pos.y + tooltip_size.y > viewport_size.y:
		preferred_pos.y = target_global_pos.y - tooltip_size.y + TOOLTIP_OFFSET.y

	# Ensure not off-screen
	preferred_pos.x = max(10, min(preferred_pos.x, viewport_size.x - tooltip_size.x - 10))
	preferred_pos.y = max(10, min(preferred_pos.y, viewport_size.y - tooltip_size.y - 10))

	global_position = preferred_pos


	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 1.0, UIThemeManager.ANIM_DURATION_FAST).set_ease(
		Tween.EASE_OUT
	)
	(
		tween
		. tween_property(self, "scale", Vector2.ONE, UIThemeManager.ANIM_DURATION_FAST)
		. set_ease(Tween.EASE_OUT)
		. set_trans(Tween.TRANS_BACK)
	)


	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 0.0, UIThemeManager.ANIM_DURATION_FAST).set_ease(
		Tween.EASE_IN
	)
	(
		tween
		. tween_property(self, "scale", Vector2(0.8, 0.8), UIThemeManager.ANIM_DURATION_FAST)
		. set_ease(Tween.EASE_IN)
	)

	tween.tween_callback(
		func():
			visible = false
			is_showing = false
			current_target = null
			tooltip_hidden.emit(current_target)
	)


# Signal handlers
	var tooltip_entry = educational_tooltips["brain_structures"][structure_id]

	# Update with new data
	var display_name = structure_data.get("displayName", structure_id)
	var description = structure_data.get("shortDescription", "Brain structure")
	var functions = structure_data.get("functions", [])

	tooltip_entry["title"] = "🧠 " + display_name
	tooltip_entry["description"] = description
	tooltip_entry["difficulty"] = _assess_difficulty(description, functions)
	tooltip_entry["quick_facts"] = _extract_quick_facts(functions)

	print("[TOOLTIP_MANAGER] Updated structure data: %s" % structure_id)


@onready var tooltip_panel: PanelContainer
@onready var tooltip_content: VBoxContainer
@onready var tooltip_header: Label
@onready var tooltip_body: RichTextLabel
@onready var tooltip_footer: HBoxContainer
@onready var tooltip_category: Label
@onready var tooltip_difficulty: Label

# State management

func _ready() -> void:
	_setup_tooltip_ui()
	_setup_timers()

	# Start hidden
	visible = false
	z_index = 1000  # Ensure tooltips appear above everything

	print("[TOOLTIP_MANAGER] Educational tooltip system initialized")


func _exit_tree() -> void:
	"""Cleanup on removal"""
	dispose()

func register_tooltip(
	target: Control, tooltip_id: String, category: String = "ui_elements"
) -> void:
	"""Register a control for educational tooltips"""
	if not target:
		print("[TOOLTIP_MANAGER] Warning: Null target provided for tooltip registration")
		return

	# Connect hover signals
	if not target.mouse_entered.is_connected(_on_target_mouse_entered):
		target.mouse_entered.connect(_on_target_mouse_entered.bind(target, tooltip_id, category))

	if not target.mouse_exited.is_connected(_on_target_mouse_exited):
		target.mouse_exited.connect(_on_target_mouse_exited.bind(target))

	print("[TOOLTIP_MANAGER] Registered tooltip for: %s" % tooltip_id)


func register_structure_tooltip(
	target: Control, structure_id: String, structure_data: Dictionary = {}
) -> void:
	"""Register tooltip for brain structure with dynamic content"""
	if not target:
		return

	# Create or update tooltip data for this structure
	if not educational_tooltips["brain_structures"].has(structure_id):
		# Generate tooltip from structure data
func show_tooltip(target: Control, tooltip_id: String, category: String = "ui_elements") -> void:
	"""Display educational tooltip with rich content"""
	if is_showing and current_target == target:
		return

	# Get tooltip data
func hide_tooltip() -> void:
	"""Hide tooltip with smooth animation"""
	if not is_showing:
		return

func add_educational_content(
	tooltip_id: String, content: Dictionary, category: String = "ui_elements"
) -> void:
	"""Add custom educational content to tooltip system"""
	if not educational_tooltips.has(category):
		educational_tooltips[category] = {}

	educational_tooltips[category][tooltip_id] = content
	print("[TOOLTIP_MANAGER] Added educational content: %s" % tooltip_id)


func update_structure_data(structure_id: String, structure_data: Dictionary) -> void:
	"""Update tooltip data for a brain structure"""
	if not educational_tooltips["brain_structures"].has(structure_id):
		educational_tooltips["brain_structures"][structure_id] = {}

func set_hover_delay(delay: float) -> void:
	"""Set custom hover delay"""
	hover_timer.wait_time = delay


func force_hide() -> void:
	"""Force hide tooltip immediately"""
	hover_timer.stop()
	fade_timer.stop()
	visible = false
	is_showing = false
	current_target = null


# Cleanup
func dispose() -> void:
	"""Clean up tooltip manager"""
	force_hide()
	educational_tooltips.clear()


func _setup_tooltip_ui() -> void:
	"""Create sophisticated tooltip UI structure"""
	# Main tooltip panel
	tooltip_panel = PanelContainer.new()
	tooltip_panel.name = "TooltipPanel"
	add_child(tooltip_panel)

	# Apply glass morphism styling
	UIThemeManager.apply_glass_panel(tooltip_panel, 0.95, "card")

	# Main content container
func _setup_timers() -> void:
	"""Setup timing controls for tooltip behavior"""
	# Hover delay timer
	hover_timer = Timer.new()
	hover_timer.wait_time = HOVER_DELAY
	hover_timer.one_shot = true
	hover_timer.timeout.connect(_on_hover_timeout)
	add_child(hover_timer)

	# Fade timer
	fade_timer = Timer.new()
	fade_timer.wait_time = FADE_DURATION
	fade_timer.one_shot = true
	fade_timer.timeout.connect(_on_fade_timeout)
	add_child(fade_timer)


func _assess_difficulty(description: String, functions: Array) -> String:
	"""Assess content difficulty based on complexity"""
func _extract_quick_facts(functions: Array) -> Array:
	"""Extract quick facts from function list"""
func _generate_learning_tip(structure_name: String) -> String:
	"""Generate mnemonic or learning tip"""
func _update_tooltip_content() -> void:
	"""Update tooltip content with educational information"""
	# Header
	tooltip_header.text = tooltip_data.get("title", "Information")

	# Category badge
	tooltip_category.text = tooltip_data.get("category", "General")

	# Main content with rich formatting
func _get_difficulty_icon(difficulty: String) -> String:
	"""Get icon for difficulty level"""
	match difficulty:
		"beginner":
			return "🟢"
		"intermediate":
			return "🟡"
		"advanced":
			return "🔴"
		_:
			return "⚪"


func _get_difficulty_color(difficulty: String) -> Color:
	"""Get color for difficulty level"""
	match difficulty:
		"beginner":
			return UIThemeManager.ACCENT_GREEN
		"intermediate":
			return UIThemeManager.ACCENT_ORANGE
		"advanced":
			return UIThemeManager.ACCENT_RED
		_:
			return UIThemeManager.TEXT_SECONDARY


func _position_tooltip(target: Control) -> void:
	"""Position tooltip relative to target with smart positioning"""
	if not target:
		return

	# Get target's global position and size
func _show_with_animation() -> void:
	"""Show tooltip with educational-style animation"""
	visible = true
	is_showing = true

	# Start with fade and scale
	modulate.a = 0.0
	scale = Vector2(0.8, 0.8)

	# Animate entrance
func _on_target_mouse_entered(target: Control, tooltip_id: String, category: String) -> void:
	"""Handle mouse entering registered target"""
	if current_target == target:
		return

	# Cancel any existing timers
	hover_timer.stop()
	fade_timer.stop()

	# Start hover delay
	hover_timer.start()
	hover_timer.timeout.connect(
		func(): show_tooltip(target, tooltip_id, category), CONNECT_ONE_SHOT
	)


func _on_target_mouse_exited(target: Control) -> void:
	"""Handle mouse exiting registered target"""
	if current_target != target:
		return

	# Cancel hover timer if still waiting
	hover_timer.stop()

	# Hide tooltip
	hide_tooltip()


func _on_hover_timeout() -> void:
	"""Handle hover delay timeout"""
	# This will be connected dynamically in _on_target_mouse_entered
	pass


func _on_fade_timeout() -> void:
	"""Handle fade delay timeout"""
	hide_tooltip()


# Public interface
