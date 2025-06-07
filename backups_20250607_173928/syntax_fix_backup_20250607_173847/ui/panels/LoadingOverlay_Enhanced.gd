# Enhanced Educational Loading Overlay
# Sophisticated loading system with educational content and progress tracking

class_name EnhancedLoadingOverlay
extends Control

# === DEPENDENCIES ===

signal loading_completed
signal loading_phase_changed(phase_name: String, progress: float)
signal educational_tip_changed(tip_index: int, tip_data: Dictionary)


const UIThemeManager = prepreprepreload("res://ui/panels/UIThemeManager.gd")

# UI Components

var loading_tween: Tween
var tip_rotation_timer: Timer
var current_progress: float = 0.0
var target_progress: float = 0.0
var is_showing: bool = false
var current_tip_index: int = 0

# Educational loading tips
var loading_tips: Array = [
	{
		"title": "🧠 Brain Basics",
		"content":
		"The human brain contains approximately 86 billion neurons, each connected to thousands of others, creating a network more complex than any computer ever built.",
		"category": "anatomy"
	},
	{
		"title": "🔬 Neuroplasticity",
		"content":
		"Your brain can reorganize itself throughout your life! This amazing ability, called neuroplasticity, means learning actually changes your brain's structure.",
		"category": "science"
	},
	{
		"title": "💭 Memory Formation",
		"content":
		"The hippocampus acts like a librarian, temporarily storing new memories before transferring important ones to the cortex for long-term storage.",
		"category": "function"
	},
	{
		"title": "⚡ Neural Speed",
		"content":
		"Nerve impulses can travel at speeds up to 120 meters per second! That's faster than most cars drive in the city.",
		"category": "physiology"
	},
	{
		"title": "🎯 Learning Strategy",
		"content":
		"When studying neuroanatomy, try connecting structures to their functions. Ask yourself: 'What does this part DO?' rather than just memorizing names.",
		"category": "study_tips"
	},
	{
		"title": "🌟 Did You Know?",
		"content":
		"The brain uses about 20% of your body's total energy, despite being only 2% of your body weight. It's truly a power-hungry supercomputer!",
		"category": "facts"
	},
	{
		"title": "🔄 Brain Waves",
		"content":
		"Your brain produces electrical waves that can be measured. Different wave patterns correspond to different states like focus, relaxation, or deep sleep.",
		"category": "physiology"
	},
	{
		"title": "🧩 Hemispheres",
		"content":
		"While both brain hemispheres work together, they do have some specialized functions. The left is often associated with language, the right with spatial processing.",
		"category": "anatomy"
	}
]

# Loading phases and tasks
var loading_phases: Dictionary = {
	"initializing":
	{
		"name": "Initializing NeuroVis",
		"progress": 10,
		"tasks": ["Loading core systems", "Preparing UI components", "Setting up theme manager"]
	},
	"loading_models":
	{
		"name": "Loading 3D Brain Models",
		"progress": 40,
		"tasks":
		["Loading brain anatomy meshes", "Processing model data", "Preparing visualization"]
	},
	"loading_data":
	{
		"name": "Loading Educational Content",
		"progress": 70,
		"tasks":
		["Loading anatomical database", "Preparing learning materials", "Setting up knowledge base"]
	},
	"finalizing":
	{
		"name": "Finalizing Setup",
		"progress": 100,
		"tasks": ["Connecting systems", "Applying configurations", "Ready for exploration!"]
	}
}

# Signals
	var center_container = CenterContainer.new()
	center_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background_panel.add_child(center_container)

	content_container = VBoxContainer.new()
	content_container.name = "ContentContainer"
	content_container.custom_minimum_size = Vector2(500, 600)
	content_container.add_theme_constant_override("separation", UIThemeManager.MARGIN_LARGE)
	center_container.add_child(content_container)

	# Logo and branding section
	_create_logo_section()

	# Progress section
	_create_progress_section()

	# Educational content section
	_create_educational_section()


	var progress_bar_container = VBoxContainer.new()
	progress_bar_container.add_theme_constant_override("separation", UIThemeManager.MARGIN_SMALL)
	progress_container.add_child(progress_bar_container)

	# Current task label
	current_task_label = Label.new()
	current_task_label.name = "CurrentTaskLabel"
	current_task_label.text = "Initializing..."
	current_task_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	progress_bar_container.add_child(current_task_label)

	# Progress bar with percentage
	var progress_wrapper = HBoxContainer.new()
	progress_wrapper.add_theme_constant_override("separation", UIThemeManager.MARGIN_MEDIUM)
	progress_bar_container.add_child(progress_wrapper)

	# Progress bar
	progress_bar = ProgressBar.new()
	progress_bar.name = "ProgressBar"
	progress_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	progress_bar.custom_minimum_size = Vector2(0, 12)
	progress_bar.max_value = 100.0
	progress_bar.value = 0.0
	progress_wrapper.add_child(progress_bar)

	# Progress percentage
	progress_percentage = Label.new()
	progress_percentage.name = "ProgressPercentage"
	progress_percentage.text = "0%"
	progress_percentage.custom_minimum_size = Vector2(40, 0)
	progress_percentage.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	progress_wrapper.add_child(progress_percentage)

	# Detailed progress label
	progress_label = Label.new()
	progress_label.name = "ProgressLabel"
	progress_label.text = "Starting up..."
	progress_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	progress_bar_container.add_child(progress_label)


	var separator = HSeparator.new()
	educational_content.add_child(separator)

	# Tip header
	tip_header = Label.new()
	tip_header.name = "TipHeader"
	tip_header.text = "💡 While You Wait - Brain Facts"
	tip_header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	educational_content.add_child(tip_header)

	# Tip content area
	var tip_content_container = PanelContainer.new()
	tip_content_container.custom_minimum_size = Vector2(0, 120)
	educational_content.add_child(tip_content_container)

	var tip_margin = MarginContainer.new()
	tip_margin.add_theme_constant_override("margin_top", UIThemeManager.MARGIN_MEDIUM)
	tip_margin.add_theme_constant_override("margin_bottom", UIThemeManager.MARGIN_MEDIUM)
	tip_margin.add_theme_constant_override("margin_left", UIThemeManager.MARGIN_MEDIUM)
	tip_margin.add_theme_constant_override("margin_right", UIThemeManager.MARGIN_MEDIUM)
	tip_content_container.add_child(tip_margin)

	tip_content = RichTextLabel.new()
	tip_content.name = "TipContent"
	tip_content.bbcode_enabled = true
	tip_content.fit_content = true
	tip_content.scroll_active = false
	tip_margin.add_child(tip_content)

	# Tip navigation
	tip_navigation = HBoxContainer.new()
	tip_navigation.name = "TipNavigation"
	tip_navigation.add_theme_constant_override("separation", UIThemeManager.MARGIN_MEDIUM)
	educational_content.add_child(tip_navigation)

	# Previous tip button
	prev_tip_btn = Button.new()
	prev_tip_btn.name = "PrevTipButton"
	prev_tip_btn.text = "◀ Previous"
	prev_tip_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tip_navigation.add_child(prev_tip_btn)

	# Tip indicator
	tip_indicator = Label.new()
	tip_indicator.name = "TipIndicator"
	tip_indicator.text = "1 / " + str(loading_tips.size())
	tip_indicator.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tip_indicator.custom_minimum_size = Vector2(80, 0)
	tip_navigation.add_child(tip_indicator)

	# Next tip button
	next_tip_btn = Button.new()
	next_tip_btn.name = "NextTipButton"
	next_tip_btn.text = "Next ▶"
	next_tip_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tip_navigation.add_child(next_tip_btn)


	var bg_style = UIThemeManager.create_glass_panel(0.98, "hero")
	bg_style.bg_color = Color(0.02, 0.05, 0.1, 0.95)  # Very dark background
	background_panel.add_theme_stylebox_override("panel", bg_style)

	# Logo styling
	UIThemeManager.apply_modern_label(app_logo, 64, UIThemeManager.ACCENT_CYAN, "title")
	UIThemeManager.apply_modern_label(
		app_title, UIThemeManager.FONT_SIZE_HERO, UIThemeManager.TEXT_PRIMARY, "title"
	)
	UIThemeManager.apply_modern_label(
		app_subtitle, UIThemeManager.FONT_SIZE_MEDIUM, UIThemeManager.TEXT_SECONDARY, "caption"
	)

	# Progress styling
	UIThemeManager.apply_modern_label(
		current_task_label, UIThemeManager.FONT_SIZE_LARGE, UIThemeManager.ACCENT_BLUE, "heading"
	)
	UIThemeManager.apply_modern_label(
		progress_label, UIThemeManager.FONT_SIZE_SMALL, UIThemeManager.TEXT_SECONDARY, "caption"
	)
	UIThemeManager.apply_modern_label(
		progress_percentage, UIThemeManager.FONT_SIZE_MEDIUM, UIThemeManager.ACCENT_CYAN
	)
	UIThemeManager.apply_progress_bar_styling(progress_bar, UIThemeManager.ACCENT_BLUE)

	# Educational content styling
	UIThemeManager.apply_modern_label(
		tip_header, UIThemeManager.FONT_SIZE_H3, UIThemeManager.ACCENT_YELLOW, "subheading"
	)
	UIThemeManager.apply_rich_text_styling(
		tip_content, UIThemeManager.FONT_SIZE_MEDIUM, "description"
	)

	# Navigation buttons
	UIThemeManager.apply_modern_button(prev_tip_btn, UIThemeManager.ACCENT_TEAL, "small")
	UIThemeManager.apply_modern_button(next_tip_btn, UIThemeManager.ACCENT_TEAL, "small")
	UIThemeManager.apply_modern_label(
		tip_indicator, UIThemeManager.FONT_SIZE_SMALL, UIThemeManager.TEXT_SECONDARY, "caption"
	)

	# Tip content panel
	var tip_panel = educational_content.find_child("TipContent").get_parent().get_parent()
	if tip_panel:
		UIThemeManager.apply_glass_panel(tip_panel, 0.8, "card")


	var phase_data = loading_phases.get(phase, {"name": "Loading...", "progress": percentage})
	target_progress = percentage

	# Update task label
	if current_task_label:
		var task_text = phase_data["name"]
		if task_description != "":
			task_text = task_description

		UIThemeManager.animate_fade_text_change(current_task_label, task_text)

	# Animate progress bar
	_animate_progress_update()

	# Update detailed progress
	if progress_label:
		var detail_text = "Loading educational content and 3D models..."
		if phase_data.has("tasks"):
			var tasks = phase_data["tasks"]
			if tasks.size() > 0:
				detail_text = tasks[randi() % tasks.size()]

		UIThemeManager.animate_fade_text_change(progress_label, detail_text)

	loading_phase_changed.emit(phase, percentage)
	print("[LOADING_OVERLAY] Progress updated: %s - %.1f%%" % [phase, percentage])


	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, UIThemeManager.ANIM_DURATION_STANDARD).set_ease(
		Tween.EASE_OUT
	)

	# Stagger content animations
	if logo_container:
		UIThemeManager.animate_entrance(
			logo_container, 0.2, UIThemeManager.ANIM_DURATION_STANDARD, "fade_scale"
		)

	if progress_container:
		UIThemeManager.animate_entrance(
			progress_container, 0.4, UIThemeManager.ANIM_DURATION_STANDARD, "slide_up"
		)

	if educational_content:
		UIThemeManager.animate_entrance(
			educational_content, 0.6, UIThemeManager.ANIM_DURATION_STANDARD, "slide_up"
		)


	var tween = create_tween()
	tween.set_parallel(true)

	# Fade out everything
	tween.tween_property(self, "modulate:a", 0.0, UIThemeManager.ANIM_DURATION_STANDARD).set_ease(
		Tween.EASE_IN
	)

	# Scale down content
	if content_container:
		(
			tween
			. tween_property(
				content_container, "scale", Vector2(0.9, 0.9), UIThemeManager.ANIM_DURATION_STANDARD
			)
			. set_ease(Tween.EASE_IN)
		)


# Educational content management
	var tip = loading_tips[current_tip_index]

	# Update tip content
	if tip_content:
		var formatted_content = (
			"[center][font_size=%d][color=%s][b]%s[/b][/color][/font_size][/center]\n\n[font_size=%d][color=%s]%s[/color][/font_size]"
			% [
				UIThemeManager.FONT_SIZE_MEDIUM,
				UIThemeManager.ACCENT_CYAN.to_html(),
				tip["title"],
				UIThemeManager.FONT_SIZE_SMALL,
				UIThemeManager.TEXT_PRIMARY.to_html(),
				tip["content"]
			]
		)

		tip_content.text = formatted_content

	# Update indicator
	if tip_indicator:
		tip_indicator.text = "%d / %d" % [current_tip_index + 1, loading_tips.size()]

	educational_tip_changed.emit(current_tip_index, tip)


@onready var background_panel: PanelContainer
@onready var content_container: VBoxContainer
@onready var logo_container: VBoxContainer
@onready var progress_container: VBoxContainer
@onready var educational_content: VBoxContainer

# Logo and branding
@onready var app_logo: Label
@onready var app_title: Label
@onready var app_subtitle: Label

# Progress indicators
@onready var progress_bar: ProgressBar
@onready var progress_label: Label
@onready var current_task_label: Label
@onready var progress_percentage: Label

# Educational content
@onready var tip_header: Label
@onready var tip_content: RichTextLabel
@onready var tip_navigation: HBoxContainer
@onready var prev_tip_btn: Button
@onready var next_tip_btn: Button
@onready var tip_indicator: Label

# Animation and state

func _ready() -> void:
	_create_enhanced_loading_ui()
	_apply_enhanced_styling()
	_setup_animations()
	_connect_signals()

	# Start hidden
	visible = false

	print("[LOADING_OVERLAY] Enhanced educational loading overlay initialized")


func _exit_tree() -> void:
	"""Cleanup on removal"""
	dispose()

func show_loading() -> void:
	"""Show loading overlay with educational content"""
	if is_showing:
		return

	is_showing = true
	visible = true
	current_progress = 0.0
	current_tip_index = 0

	# Reset progress
	if progress_bar:
		progress_bar.value = 0.0

	if progress_percentage:
		progress_percentage.text = "0%"

	# Show first tip
	_update_educational_content()

	# Start tip rotation
	tip_rotation_timer.start()

	# Animate entrance
	_animate_entrance()

	print("[LOADING_OVERLAY] Showing enhanced loading overlay")


func hide_loading() -> void:
	"""Hide loading overlay with completion animation"""
	if not is_showing:
		return

	# Stop tip rotation
	tip_rotation_timer.stop()

	# Animate exit
	_animate_exit()

	# Complete loading after animation
	get_tree().create_timer(UIThemeManager.ANIM_DURATION_STANDARD).timeout.connect(
		func():
			is_showing = false
			visible = false
			loading_completed.emit()
	)

	print("[LOADING_OVERLAY] Hiding loading overlay")


func update_progress(phase: String, percentage: float, task_description: String = "") -> void:
	"""Update loading progress with educational context"""
	if not is_showing:
		return

func add_custom_tip(tip_data: Dictionary) -> void:
	"""Add custom educational tip"""
	loading_tips.append(tip_data)
	print("[LOADING_OVERLAY] Added custom tip: " + tip_data.get("title", "Unknown"))


func set_tip_rotation_interval(seconds: float) -> void:
	"""Set tip rotation interval"""
	tip_rotation_timer.wait_time = seconds


func get_current_tip() -> Dictionary:
	"""Get currently displayed tip"""
	if current_tip_index < loading_tips.size():
		return loading_tips[current_tip_index]
	return {}


func show_completion_message() -> void:
	"""Show completion message before hiding"""
	if current_task_label:
		UIThemeManager.animate_fade_text_change(current_task_label, "🎉 Welcome to NeuroVis!")

	if progress_label:
		UIThemeManager.animate_fade_text_change(progress_label, "Ready to explore the brain!")

	# Pulse the logo
	if app_logo:
		UIThemeManager.animate_pulse(app_logo, UIThemeManager.ACCENT_GREEN, 0.5)


# Cleanup
func dispose() -> void:
	"""Clean up loading overlay"""
	if loading_tween:
		loading_tween.kill()

	if tip_rotation_timer:
		tip_rotation_timer.stop()

	loading_tips.clear()


func _create_enhanced_loading_ui() -> void:
	"""Create sophisticated loading UI with educational elements"""
	# Full screen background
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	# Background panel with glass effect
	background_panel = PanelContainer.new()
	background_panel.name = "BackgroundPanel"
	background_panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background_panel)

	# Main content container
func _create_logo_section() -> void:
	"""Create logo and branding area"""
	logo_container = VBoxContainer.new()
	logo_container.name = "LogoContainer"
	logo_container.add_theme_constant_override("separation", UIThemeManager.MARGIN_MEDIUM)
	content_container.add_child(logo_container)

	# App logo (using text for now)
	app_logo = Label.new()
	app_logo.name = "AppLogo"
	app_logo.text = "🧠"
	app_logo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	logo_container.add_child(app_logo)

	# App title
	app_title = Label.new()
	app_title.name = "AppTitle"
	app_title.text = "NeuroVis"
	app_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	logo_container.add_child(app_title)

	# App subtitle
	app_subtitle = Label.new()
	app_subtitle.name = "AppSubtitle"
	app_subtitle.text = "AI-Enhanced Brain Anatomy Visualizer"
	app_subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	logo_container.add_child(app_subtitle)


func _create_progress_section() -> void:
	"""Create progress tracking section"""
	progress_container = VBoxContainer.new()
	progress_container.name = "ProgressContainer"
	progress_container.add_theme_constant_override("separation", UIThemeManager.MARGIN_MEDIUM)
	content_container.add_child(progress_container)

	# Progress bar container
func _create_educational_section() -> void:
	"""Create educational content section"""
	educational_content = VBoxContainer.new()
	educational_content.name = "EducationalContent"
	educational_content.add_theme_constant_override("separation", UIThemeManager.MARGIN_MEDIUM)
	content_container.add_child(educational_content)

	# Separator
func _apply_enhanced_styling() -> void:
	"""Apply sophisticated educational styling"""
	# Background with dark glass effect
func _setup_animations() -> void:
	"""Setup loading animations and timers"""
	# Auto-rotation timer for tips
	tip_rotation_timer = Timer.new()
	tip_rotation_timer.wait_time = 8.0  # Change tip every 8 seconds
	tip_rotation_timer.timeout.connect(_rotate_tip)
	add_child(tip_rotation_timer)


func _connect_signals() -> void:
	"""Connect interactive signals"""
	if prev_tip_btn:
		prev_tip_btn.pressed.connect(_show_previous_tip)

	if next_tip_btn:
		next_tip_btn.pressed.connect(_show_next_tip)


# Public interface
func _animate_progress_update() -> void:
	"""Smoothly animate progress bar update"""
	if not progress_bar or not progress_percentage:
		return

	if loading_tween:
		loading_tween.kill()

	loading_tween = create_tween()
	loading_tween.set_parallel(true)

	# Animate progress bar
	loading_tween.tween_property(progress_bar, "value", target_progress, 0.5).set_ease(
		Tween.EASE_OUT
	)

	# Animate percentage text
	(
		loading_tween
		. tween_method(_update_percentage_text, current_progress, target_progress, 0.5)
		. set_ease(Tween.EASE_OUT)
	)

	current_progress = target_progress


func _update_percentage_text(value: float) -> void:
	"""Update percentage text during animation"""
	if progress_percentage:
		progress_percentage.text = "%.0f%%" % value


func _animate_entrance() -> void:
	"""Animate loading overlay entrance"""
	# Start with fade
	modulate.a = 0.0

	# Fade in background
func _animate_exit() -> void:
	"""Animate loading overlay exit"""
func _update_educational_content() -> void:
	"""Update educational tip content"""
	if current_tip_index >= loading_tips.size():
		current_tip_index = 0

func _show_previous_tip() -> void:
	"""Show previous educational tip"""
	current_tip_index = (current_tip_index - 1) % loading_tips.size()
	_update_educational_content()

	# Restart rotation timer
	tip_rotation_timer.stop()
	tip_rotation_timer.start()


func _show_next_tip() -> void:
	"""Show next educational tip"""
	current_tip_index = (current_tip_index + 1) % loading_tips.size()
	_update_educational_content()

	# Restart rotation timer
	tip_rotation_timer.stop()
	tip_rotation_timer.start()


func _rotate_tip() -> void:
	"""Auto-rotate to next tip"""
	_show_next_tip()


# Public utility functions
