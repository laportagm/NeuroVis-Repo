# Loading State Manager for NeuroVis

class_name LoadingStateManager
extends Node

# Preload UIThemeManager for styling

signal loading_started(loading_id: String)
signal loading_progress(loading_id: String, progress: float)
signal loading_completed(loading_id: String, success: bool)
signal loading_cancelled(loading_id: String)

# === STATE ===

enum LoadingState { IDLE, LOADING, PROCESSING, SUCCESS, ERROR }

# === LOADING TYPES ===
enum LoadingType { FULL_SCREEN, INLINE, SKELETON, PROGRESS_BAR, SHIMMER }

# === SIGNALS ===

const UIThemeManager = preload("res://ui/panels/UIThemeManager.gd")

# === LOADING STATES ===
const LOADING_MESSAGES = {
	"model_loading":
	["Loading brain model...", "Preparing 3D visualization...", "Optimizing mesh data..."],
	"knowledge_loading":
	[
		"Loading anatomical data...",
		"Preparing structure information...",
		"Indexing brain regions..."
	],
	"ai_loading":
	[
		"Connecting to AI assistant...",
		"Preparing conversation context...",
		"Ready to answer your questions!"
	],
	"search_loading":
	["Searching brain structures...", "Finding matches...", "Organizing results..."]
}


# === PUBLIC API ===

var active_loadings: Dictionary = {}
var loading_ui_pool: Array = []

# === LOADING MESSAGES ===
	var loading_id = _generate_loading_id()

	var loading_data = {
		"id": loading_id,
		"type": loading_type,
		"state": LoadingState.LOADING,
		"progress": 0.0,
		"start_time": Time.get_ticks_msec(),
		"context": context,
		"ui_element": null
	}

	active_loadings[loading_id] = loading_data

	# Create appropriate UI
	loading_data.ui_element = _create_loading_ui(loading_type, context)

	loading_started.emit(loading_id)

	return loading_id


		var loading_data = active_loadings[loading_id]
		loading_data.progress = clamp(progress, 0.0, 1.0)

		if loading_data.ui_element:
			_update_loading_ui(loading_data.ui_element, progress, message)

		loading_progress.emit(loading_id, progress)


		var loading_data = active_loadings[loading_id]
		loading_data.state = LoadingState.SUCCESS if success else LoadingState.ERROR

		# Show completion animation
		if loading_data.ui_element:
			_animate_completion(loading_data.ui_element, success)

		# Remove after delay
		await get_tree().create_timer(0.5).timeout
		_remove_loading(loading_id)

		loading_completed.emit(loading_id, success)


	var overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.8)
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.z_index = 1000

	var center_container = CenterContainer.new()
	center_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var content = VBoxContainer.new()
	content.alignment = BoxContainer.ALIGNMENT_CENTER
	content.add_theme_constant_override("separation", 24)

	# Loading spinner
	var spinner = _create_spinner()
	content.add_child(spinner)

	# Loading text
	var label = Label.new()
	label.text = context.get("message", "Loading...")
	label.add_theme_font_size_override("font_size", 18)
	label.add_theme_color_override("font_color", Color.WHITE)
	content.add_child(label)

	# Progress bar (optional)
	if context.get("show_progress", false):
		var progress = ProgressBar.new()
		progress.custom_minimum_size = Vector2(300, 6)
		progress.value = 0
		var progress_style = StyleBoxFlat.new()
		progress_style.bg_color = Color(1, 1, 1, 0.2)
		progress_style.corner_radius_top_left = 3
		progress_style.corner_radius_top_right = 3
		progress_style.corner_radius_bottom_left = 3
		progress_style.corner_radius_bottom_right = 3
		progress.add_theme_stylebox_override("background", progress_style)
		content.add_child(progress)

	center_container.add_child(content)
	overlay.add_child(center_container)

	# Add to scene
	get_viewport().add_child(overlay)

	# Animate entrance
	overlay.modulate.a = 0
	var tween = create_tween()
	tween.tween_property(overlay, "modulate:a", 1.0, 0.3)

	return overlay


	var container = HBoxContainer.new()
	container.add_theme_constant_override("separation", 8)

	# Small spinner
	var spinner = _create_spinner(16)
	container.add_child(spinner)

	# Loading text
	var label = Label.new()
	label.text = context.get("message", "Loading...")
	label.add_theme_color_override("font_color", UIThemeManager.TEXT_SECONDARY)
	container.add_child(label)

	# Add to parent if specified
	if context.has("parent"):
		context.parent.add_child(container)

	return container


	var skeleton = VBoxContainer.new()
	skeleton.add_theme_constant_override("separation", 12)

	# Create skeleton lines based on context
	var line_count = context.get("lines", 3)
	for i in range(line_count):
		var line = Panel.new()
		line.custom_minimum_size = Vector2(
			randf_range(200, 400) if i < line_count - 1 else randf_range(100, 200),
			context.get("line_height", 20)
		)

		var line_style = StyleBoxFlat.new()
		line_style.bg_color = UIThemeManager.get_color("surface_bg")
		line_style.corner_radius_top_left = 4
		line_style.corner_radius_top_right = 4
		line_style.corner_radius_bottom_left = 4
		line_style.corner_radius_bottom_right = 4
		line.add_theme_stylebox_override("panel", line_style)

		skeleton.add_child(line)

		# Add shimmer animation
		_add_shimmer_animation(line)

	# Add to parent if specified
	if context.has("parent"):
		context.parent.add_child(skeleton)

	return skeleton


	var container = VBoxContainer.new()
	container.add_theme_constant_override("separation", 8)

	# Label
	var label = Label.new()
	label.text = context.get("message", "Loading...")
	container.add_child(label)

	# Progress bar
	var progress = ProgressBar.new()
	progress.custom_minimum_size = Vector2(context.get("width", 200), 8)
	progress.value = 0
	progress.show_percentage = context.get("show_percentage", true)

	# Style the progress bar
	var bg_style = StyleBoxFlat.new()
	bg_style.bg_color = UIThemeManager.get_color("surface_bg")
	bg_style.corner_radius_top_left = 4
	bg_style.corner_radius_top_right = 4
	bg_style.corner_radius_bottom_left = 4
	bg_style.corner_radius_bottom_right = 4
	progress.add_theme_stylebox_override("background", bg_style)

	var fill_style = StyleBoxFlat.new()
	fill_style.bg_color = UIThemeManager.ACCENT_BLUE
	fill_style.corner_radius_top_left = 4
	fill_style.corner_radius_top_right = 4
	fill_style.corner_radius_bottom_left = 4
	fill_style.corner_radius_bottom_right = 4
	progress.add_theme_stylebox_override("fill", fill_style)

	container.add_child(progress)

	# Add to parent if specified
	if context.has("parent"):
		context.parent.add_child(container)

	return container


	var shimmer_container = Panel.new()
	shimmer_container.custom_minimum_size = context.get("size", Vector2(200, 100))

	var style = StyleBoxFlat.new()
	style.bg_color = UIThemeManager.get_color("panel_bg")
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	shimmer_container.add_theme_stylebox_override("panel", style)

	_add_shimmer_animation(shimmer_container)

	# Add to parent if specified
	if context.has("parent"):
		context.parent.add_child(shimmer_container)

	return shimmer_container


# === SPINNER CREATION ===
	var spinner = Control.new()
	spinner.custom_minimum_size = Vector2(size, size)

	# Create spinner visual
	var texture_rect = TextureRect.new()
	texture_rect.custom_minimum_size = Vector2(size, size)
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

	# Create spinning animation
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(texture_rect, "rotation", TAU, 1.0)

	spinner.add_child(texture_rect)

	# Draw custom spinner if no texture
	if not texture_rect.texture:
		texture_rect.draw.connect(_draw_spinner.bind(texture_rect, size))

	return spinner


	var center = Vector2(size / 2.0, size / 2.0)
	var radius = size / 2.0 - 2

	# Draw arc
	var color = UIThemeManager.ACCENT_BLUE
	var start_angle = 0
	var end_angle = PI * 1.5

	control.draw_arc(center, radius, start_angle, end_angle, 32, color, 3.0, true)


# === ANIMATIONS ===
	var gradient = Gradient.new()
	gradient.set_color(0, Color(1, 1, 1, 0))
	gradient.set_color(0.5, Color(1, 1, 1, 0.1))
	gradient.set_color(1, Color(1, 1, 1, 0))

	var tween = create_tween()
	tween.set_loops()
	tween.tween_method(
		func(offset: float):
			if control.material:
				control.material.set_shader_parameter("shimmer_offset", offset),
		-1.0,
		2.0,
		2.0
	)


	var progress_bars = ui_element.find_children("", "ProgressBar", true, false)
	for bar in progress_bars:
		bar.value = progress * 100

	# Update message
	var labels = ui_element.find_children("", "Label", true, false)
	if labels.size() > 0 and message != "":
		labels[0].text = message


	var tween = create_tween()

	if success:
		# Success animation
		tween.tween_property(ui_element, "modulate", UIThemeManager.ACCENT_GREEN, 0.2)
		tween.tween_property(ui_element, "scale", Vector2(1.1, 1.1), 0.1)
		tween.tween_property(ui_element, "scale", Vector2.ONE, 0.1)
	else:
		# Error animation
		tween.tween_property(ui_element, "modulate", UIThemeManager.ACCENT_RED, 0.2)
		# Shake animation
		for i in range(3):
			tween.tween_property(ui_element, "position:x", ui_element.position.x + 5, 0.05)
			tween.tween_property(ui_element, "position:x", ui_element.position.x - 5, 0.05)


		var loading_data = active_loadings[loading_id]

		if loading_data.ui_element:
			# Animate removal
			var tween = create_tween()
			tween.tween_property(loading_data.ui_element, "modulate:a", 0.0, 0.3)
			tween.tween_callback(loading_data.ui_element.queue_free)

		active_loadings.erase(loading_id)


func _enter_tree() -> void:
	if not Engine.has_singleton("LoadingStateManager"):
		Engine.register_singleton("LoadingStateManager", self)


func _exit_tree() -> void:
	if Engine.has_singleton("LoadingStateManager"):
		Engine.unregister_singleton("LoadingStateManager")

func show_loading(loading_type: LoadingType, context: Dictionary = {}) -> String:
	"""Show loading indicator"""
func update_progress(loading_id: String, progress: float, message: String = "") -> void:
	"""Update loading progress"""
	if loading_id in active_loadings:
func complete_loading(loading_id: String, success: bool = true) -> void:
	"""Complete loading process"""
	if loading_id in active_loadings:
func cancel_loading(loading_id: String) -> void:
	"""Cancel loading process"""
	if loading_id in active_loadings:
		_remove_loading(loading_id)
		loading_cancelled.emit(loading_id)


# === UI CREATION ===

func _create_loading_ui(loading_type: LoadingType, context: Dictionary) -> Control:
	"""Create loading UI based on type"""
	match loading_type:
		LoadingType.FULL_SCREEN:
			return _create_fullscreen_loading(context)
		LoadingType.INLINE:
			return _create_inline_loading(context)
		LoadingType.SKELETON:
			return _create_skeleton_loading(context)
		LoadingType.PROGRESS_BAR:
			return _create_progress_loading(context)
		LoadingType.SHIMMER:
			return _create_shimmer_loading(context)
		_:
			return _create_inline_loading(context)


func _create_fullscreen_loading(context: Dictionary) -> Control:
	"""Create fullscreen loading overlay"""
func _create_inline_loading(context: Dictionary) -> Control:
	"""Create inline loading indicator"""
func _create_skeleton_loading(context: Dictionary) -> Control:
	"""Create skeleton loading placeholder"""
func _create_progress_loading(context: Dictionary) -> Control:
	"""Create progress bar loading"""
func _create_shimmer_loading(context: Dictionary) -> Control:
	"""Create shimmer effect loading"""
func _create_spinner(size: int = 32) -> Control:
	"""Create animated loading spinner"""
func _draw_spinner(control: Control, size: int) -> void:
	"""Draw custom spinner"""
func _add_shimmer_animation(control: Control) -> void:
	"""Add shimmer animation to control"""
func _update_loading_ui(ui_element: Control, progress: float, message: String) -> void:
	"""Update loading UI with progress"""
	# Find progress bar
func _animate_completion(ui_element: Control, success: bool) -> void:
	"""Animate loading completion"""
func _remove_loading(loading_id: String) -> void:
	"""Remove loading indicator"""
	if loading_id in active_loadings:
func _generate_loading_id() -> String:
	"""Generate unique loading ID"""
	return "load_" + str(Time.get_ticks_msec()) + "_" + str(randi() % 1000)


# === SINGLETON SETUP ===
