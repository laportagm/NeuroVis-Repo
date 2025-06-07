class_name LoadingOverlay
extends Control

# Loading states
extends Control

enum LoadingState { HIDDEN, MODELS, KNOWLEDGE_BASE, INITIALIZATION, CUSTOM }

var current_state: LoadingState = LoadingState.HIDDEN
var spinner: Control
var progress_bar: ProgressBar
var status_label: Label
var background: ColorRect


var loading_panel = PanelContainer.new()
loading_panel.custom_minimum_size = Vector2(400, 250)
loading_panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER)

# Glass morphism style
var panel_style = StyleBoxFlat.new()
panel_style.bg_color = Color(0.05, 0.05, 0.1, 0.95)
panel_style.corner_radius_top_left = 20
panel_style.corner_radius_top_right = 20
panel_style.corner_radius_bottom_left = 20
panel_style.corner_radius_bottom_right = 20
panel_style.border_width_left = 2
panel_style.border_width_right = 2
panel_style.border_width_top = 2
panel_style.border_width_bottom = 2
panel_style.border_color = Color(1, 1, 1, 0.2)
panel_style.shadow_size = 32
panel_style.shadow_color = Color(0, 0, 0, 0.6)
panel_style.shadow_offset = Vector2(0, 8)
loading_panel.add_theme_stylebox_override("panel", panel_style)

add_child(loading_panel)

# Content container
var content = VBoxContainer.new()
content.add_theme_constant_override("separation", 24)
content.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
content.add_theme_constant_override("margin_left", 32)
content.add_theme_constant_override("margin_right", 32)
content.add_theme_constant_override("margin_top", 32)
content.add_theme_constant_override("margin_bottom", 32)
loading_panel.add_child(content)

# Title
var title = Label.new()
title.text = "NeuroVis"
title.add_theme_font_size_override("font_size", 32)
title.add_theme_color_override("font_color", Color("#00D9FF"))  # Primary cyan
title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
content.add_child(title)

# Animated spinner
spinner = _create_modern_spinner()
content.add_child(spinner)

# Status label
status_label = Label.new()
status_label.text = "Loading..."
status_label.add_theme_font_size_override("font_size", 16)
status_label.add_theme_color_override("font_color", Color("#B8BCC8"))  # Text secondary
status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
content.add_child(status_label)

# Progress bar
progress_bar = ProgressBar.new()
progress_bar.custom_minimum_size.y = 8
progress_bar.value = 0
progress_bar.max_value = 100

# Style the progress bar
var progress_bg = StyleBoxFlat.new()
progress_bg.bg_color = Color(1, 1, 1, 0.1)
progress_bg.corner_radius_top_left = 4
progress_bg.corner_radius_top_right = 4
progress_bg.corner_radius_bottom_left = 4
progress_bg.corner_radius_bottom_right = 4

var progress_fg = StyleBoxFlat.new()
progress_fg.bg_color = Color("#00D9FF")  # Primary cyan
progress_fg.corner_radius_top_left = 4
progress_fg.corner_radius_top_right = 4
progress_fg.corner_radius_bottom_left = 4
progress_fg.corner_radius_bottom_right = 4

progress_bar.add_theme_stylebox_override("background", progress_bg)
progress_bar.add_theme_stylebox_override("fill", progress_fg)
content.add_child(progress_bar)


var spinner_container = Control.new()
spinner_container.custom_minimum_size = Vector2(60, 60)
spinner_container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER

# Create multiple rotating rings for a complex effect
var ring = Control.new()
ring.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

var ring_draw = SpinnerRing.new()
ring_draw.radius = 20 + (i * 8)
ring_draw.thickness = 3
ring_draw.color = Color("#00D9FF").darkened(i * 0.2)  # Primary cyan darkened
ring_draw.speed = 1.0 + (i * 0.3)
ring.add_child(ring_draw)

spinner_container.add_child(ring)

var tween = create_tween()
tween.set_parallel(true)
tween.tween_property(self, "modulate:a", 1.0, 0.3)
tween.tween_property(self, "scale", Vector2.ONE, 0.3).set_trans(Tween.TRANS_BACK)


var tween_2 = status_label.create_tween()
tween.tween_property(status_label, "modulate:a", 0.0, 0.1)
tween.tween_callback(func(): status_label.text = message)
tween.tween_property(status_label, "modulate:a", 1.0, 0.1)


var tween_3 = create_tween()
tween.set_parallel(true)
tween.tween_property(self, "modulate:a", 0.0, 0.3)
tween.tween_property(self, "scale", Vector2(0.9, 0.9), 0.3)
tween.tween_callback(func(): visible = false)


# Custom spinner ring class for modern animation
class SpinnerRing:
var radius: float = 20
var thickness: float = 3
var color: Color = Color.WHITE
var speed: float = 1.0
var rotation_angle: float = 0.0

var center = size / 2.0
var start_angle = rotation_angle
var end_angle = start_angle + PI * 1.5  # 3/4 circle

# Draw the arc
	_draw_arc_line(center, radius, start_angle, end_angle, color, thickness)

var steps = 32
var angle_step = (end_angle - start_angle) / steps

var angle1 = start_angle + i * angle_step
var angle2 = start_angle + (i + 1) * angle_step

var point1 = center + Vector2(cos(angle1), sin(angle1)) * arc_radius
var point2 = center + Vector2(cos(angle2), sin(angle2)) * arc_radius

	draw_line(point1, point2, arc_color, width, true)

func _ready() -> void:
	# Set up full screen overlay
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP  # Block input while loading
	visible = false

	_create_loading_ui()


func _ready() -> void:
	set_process(true)
	custom_minimum_size = Vector2(radius * 2 + thickness, radius * 2 + thickness)

func _process(delta: float) -> void:
	rotation_angle += delta * speed * 2.0
	queue_redraw()

func show_loading(state: LoadingState, custom_message: String = "") -> void:
	"""Show loading overlay with specific state"""
	current_state = state
	visible = true

	# Update status message based on state
	match state:
		LoadingState.MODELS:
			status_label.text = "Loading 3D brain models..."
			progress_bar.value = 25
			LoadingState.KNOWLEDGE_BASE:
				status_label.text = "Loading anatomical knowledge base..."
				progress_bar.value = 50
				LoadingState.INITIALIZATION:
					status_label.text = "Initializing NeuroVis systems..."
					progress_bar.value = 75
					LoadingState.CUSTOM:
						status_label.text = custom_message if not custom_message.is_empty() else "Loading..."
						progress_bar.value = 0
						_:
							status_label.text = "Loading..."
							progress_bar.value = 0

							# Animate entrance
							modulate.a = 0
							scale = Vector2(0.9, 0.9)

func update_progress(percentage: float, message: String = "") -> void:
	"""Update loading progress"""
	progress_bar.value = percentage

	if not message.is_empty():
		# Animate text change
func hide_loading() -> void:
	"""Hide loading overlay with smooth animation"""

func _fix_orphaned_code():
	for i in range(3):
func _fix_orphaned_code():
	return spinner_container


func _fix_orphaned_code():
	for i in range(steps):
func _create_loading_ui() -> void:
	"""Create the modern loading interface with glass morphism"""

	# Semi-transparent background
	background = ColorRect.new()
	background.color = Color(0, 0, 0, 0.7)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	# Central loading panel with glass effect
func _create_modern_spinner() -> Control:
	"""Create a modern animated spinner"""
func _draw() -> void:
func _draw_arc_line(
	center: Vector2,
	arc_radius: float,
	start_angle: float,
	end_angle: float,
	arc_color: Color,
	width: float
	) -> void:
