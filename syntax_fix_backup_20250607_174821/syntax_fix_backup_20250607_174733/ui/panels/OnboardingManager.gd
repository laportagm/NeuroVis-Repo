class_name OnboardingManager
extends Control

signal onboarding_completed

var current_step: int = 0
var steps = [
{
"title": "Welcome to NeuroVis",
"description": "Let's explore the human brain together with advanced 3D visualization",
"action": "start"
},
{
"title": "Navigate in 3D",
"description":
	"Click and drag to orbit around the brain model. Use your mouse to explore different angles.",
	"action": "orbit",
	"gesture": "drag"
	},
	{
	"title": "Zoom In & Out",
	"description":
		"Use your scroll wheel or trackpad to zoom in and out for detailed examination.",
		"action": "zoom",
		"gesture": "scroll"
		},
		{
		"title": "Select Structures",
		"description": "Right-click any brain structure to learn detailed information about it.",
		"action": "select",
		"gesture": "right-click"
		},
		{
		"title": "Toggle Models",
		"description": "Use the control panel to show or hide different brain layers and models.",
		"action": "toggle",
		"gesture": "panel"
		}
		]

var overlay: ColorRect
var tooltip: PanelContainer


var overlay_tween = overlay.create_tween()
	overlay_tween.tween_property(overlay, "modulate:a", 1.0, 0.5)

	# Start with first step
	modulate.a = 0
var main_tween = create_tween()
	main_tween.tween_property(self, "modulate:a", 1.0, 0.5)
	main_tween.tween_callback(func(): show_step(0))


var viewport_size = Vector2(get_viewport().size)
	tooltip.position = (viewport_size - tooltip.size) / 2.0

	# Animate entrance
	_animate_entrance(tooltip)


var panel = PanelContainer.new()
	panel.mouse_filter = Control.MOUSE_FILTER_STOP  # Allow interaction

	# Premium glass morphism style
var style = StyleBoxFlat.new()
	style.bg_color = Color(0.05, 0.05, 0.1, 0.95)
	style.corner_radius_top_left = 20
	style.corner_radius_top_right = 20
	style.corner_radius_bottom_left = 20
	style.corner_radius_bottom_right = 20
	style.border_width_left = 2
	style.border_width_right = 2
	style.border_width_top = 2
	style.border_width_bottom = 2
	style.border_color = Color(1, 1, 1, 0.2)
	style.shadow_size = 32
	style.shadow_color = Color(0, 0, 0, 0.5)
	style.shadow_offset = Vector2(0, 8)
	style.content_margin_left = 40
	style.content_margin_right = 40
	style.content_margin_top = 32
	style.content_margin_bottom = 32
	panel.add_theme_stylebox_override("panel", style)

var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 20)
	vbox.custom_minimum_size.x = 400
	panel.add_child(vbox)

	# Progress indicator
var progress_container = HBoxContainer.new()
	progress_container.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_child(progress_container)

var dot = Panel.new()
	dot.custom_minimum_size = Vector2(12, 12)

var dot_style = StyleBoxFlat.new()
var spacer = Control.new()
	spacer.custom_minimum_size.x = 8
	progress_container.add_child(spacer)

	# Step counter
var counter = Label.new()
	counter.text = "Step %d of %d" % [current_step + 1, steps.size()]
	counter.add_theme_color_override("font_color", Color(1, 1, 1, 0.7))
	counter.add_theme_font_size_override("font_size", 14)
	counter.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(counter)

	# Title with glow effect
var title = Label.new()
	title.text = step.title
	title.add_theme_font_size_override("font_size", 32)
	title.add_theme_color_override("font_color", Color("#00D9FF"))  # Primary cyan
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	# Description
var desc = RichTextLabel.new()
	desc.text = "[center]" + step.description + "[/center]"
	desc.add_theme_font_size_override("normal_font_size", 16)
	desc.add_theme_color_override("default_color", Color("#B8BCC8"))  # Text secondary
	desc.fit_content = true
	desc.custom_minimum_size.y = 60
	vbox.add_child(desc)

	# Gesture hint (if applicable)
var gesture_hint = _create_gesture_hint(step.gesture)
	vbox.add_child(gesture_hint)

	# Action buttons
var button_container = HBoxContainer.new()
	button_container.alignment = BoxContainer.ALIGNMENT_CENTER
	button_container.add_theme_constant_override("separation", 16)
	vbox.add_child(button_container)

	# Skip button (always available)
var skip_btn = _create_modern_button("Skip Tutorial", Color("#B8BCC8"))  # Text secondary
	skip_btn.pressed.connect(complete_onboarding)
	button_container.add_child(skip_btn)

	# Next/Start button
var start_btn = _create_modern_button("Let's Start!", Color("#00D9FF"))  # Primary cyan
	start_btn.pressed.connect(_next_step)
	button_container.add_child(start_btn)
var next_btn = _create_modern_button("Next", Color("#00D9FF"))  # Primary cyan
	next_btn.pressed.connect(_next_step)
	button_container.add_child(next_btn)

var hint_panel = PanelContainer.new()

var hint_style = StyleBoxFlat.new()
	hint_style.bg_color = Color("#FFB700").darkened(0.7)  # Warning amber darkened
	hint_style.corner_radius_top_left = 8
	hint_style.corner_radius_top_right = 8
	hint_style.corner_radius_bottom_left = 8
	hint_style.corner_radius_bottom_right = 8
	hint_style.content_margin_left = 16
	hint_style.content_margin_right = 16
	hint_style.content_margin_top = 8
	hint_style.content_margin_bottom = 8
	hint_panel.add_theme_stylebox_override("panel", hint_style)

var hint_label = Label.new()
	hint_label.add_theme_color_override("font_color", Color("#FFB700"))  # Warning amber
	hint_label.add_theme_font_size_override("font_size", 14)
	hint_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	"drag":
		hint_label.text = "🖱️ Click and drag to practice"
		"scroll":
			hint_label.text = "🖱️ Use scroll wheel to practice"
			"right-click":
				hint_label.text = "🖱️ Right-click on brain structures"
				"panel":
					hint_label.text = "🎛️ Try the control panel on the left"
					_:
						hint_label.text = "💡 Try it out!"

						hint_panel.add_child(hint_label)
var btn = Button.new()
	btn.text = text
	btn.custom_minimum_size.x = 120

var btn_style = StyleBoxFlat.new()
	btn_style.bg_color = color
	btn_style.corner_radius_top_left = 12
	btn_style.corner_radius_top_right = 12
	btn_style.corner_radius_bottom_left = 12
	btn_style.corner_radius_bottom_right = 12
	btn_style.content_margin_left = 20
	btn_style.content_margin_right = 20
	btn_style.content_margin_top = 12
	btn_style.content_margin_bottom = 12

var btn_hover = btn_style.duplicate()
	btn_hover.bg_color = color.lightened(0.2)
	btn_hover.shadow_size = 8
	btn_hover.shadow_color = color.darkened(0.3)
	btn_hover.shadow_offset = Vector2(0, 4)

	btn.add_theme_stylebox_override("normal", btn_style)
	btn.add_theme_stylebox_override("hover", btn_hover)
	btn.add_theme_color_override(
	"font_color", Color.WHITE if color != Color("#B8BCC8") else Color.BLACK
	)
	btn.add_theme_font_size_override("font_size", 16)

var config = ConfigFile.new()
	config.set_value("onboarding", "completed", true)
	config.set_value("onboarding", "completed_date", Time.get_datetime_string_from_system())
	config.save("user://settings.cfg")

	# Smooth fade out
var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 0.0, 0.7)
var tween = control.create_tween()
var tween = control.create_tween()
	tween.set_parallel(true)
	tween.tween_property(control, "modulate:a", 0.0, duration)
	tween.tween_property(control, "scale", Vector2(0.9, 0.9), duration)
	tween.tween_callback(control.queue_free)


	# Public method to check if user has completed onboarding
	static func has_completed_onboarding() -> bool:
var config = ConfigFile.new()
var error = config.load("user://settings.cfg")

func _ready() -> void:
	# Set up full screen control
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	visible = false


func start_onboarding():
	visible = true
	current_step = 0

	# Create dark overlay with glass effect
	overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.8)
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(overlay)

	# Fade in overlay
	overlay.modulate.a = 0
func show_step(index: int):
	if index >= steps.size():
		complete_onboarding()
		return

		current_step = index

		# Remove previous tooltip
		if tooltip:
			_animate_exit(tooltip, 0.2)
			await get_tree().create_timer(0.2).timeout

			# Create new tooltip for this step
			tooltip = _create_step_tooltip(steps[index])
			add_child(tooltip)

			# Position tooltip in center
			await get_tree().process_frame
func complete_onboarding():
	print("Onboarding completed")

	# Save completion status

func _fix_orphaned_code():
	for i in range(steps.size()):
func _fix_orphaned_code():
	if i <= current_step:
		dot_style.bg_color = Color("#00D9FF")  # Primary cyan
		else:
			dot_style.bg_color = Color(1, 1, 1, 0.3)
			dot_style.corner_radius_top_left = 6
			dot_style.corner_radius_top_right = 6
			dot_style.corner_radius_bottom_left = 6
			dot_style.corner_radius_bottom_right = 6
			dot.add_theme_stylebox_override("panel", dot_style)

			progress_container.add_child(dot)

			if i < steps.size() - 1:
func _fix_orphaned_code():
	if step.has("gesture"):
func _fix_orphaned_code():
	if step.action == "start":
func _fix_orphaned_code():
	return panel


func _fix_orphaned_code():
	return hint_panel


func _fix_orphaned_code():
	return btn


func _fix_orphaned_code():
	if overlay:
		tween.tween_property(overlay, "modulate:a", 0.0, 0.7)
		tween.tween_callback(
		func():
			onboarding_completed.emit()
			queue_free()
			)


			# Animation helper functions
func _fix_orphaned_code():
	if delay > 0:
		tween.tween_interval(delay)

		tween.set_parallel(true)
		tween.tween_property(control, "modulate:a", 1.0, 0.3).set_ease(Tween.EASE_OUT)
		tween.tween_property(control, "scale", Vector2.ONE, 0.3).set_ease(Tween.EASE_OUT).set_trans(
		Tween.TRANS_BACK
		)


func _fix_orphaned_code():
	if error != OK:
		return false
		return config.get_value("onboarding", "completed", false)

func _create_step_tooltip(step: Dictionary) -> PanelContainer:
func _create_gesture_hint(gesture: String) -> PanelContainer:
func _create_modern_button(text: String, color: Color) -> Button:
func _next_step():
	current_step += 1
	show_step(current_step)


func _animate_entrance(control: Control, delay: float = 0.0) -> void:
	"""Smooth entrance animation for any control"""
	control.modulate.a = 0
	control.scale = Vector2(0.9, 0.9)

func _animate_exit(control: Control, duration: float = 0.2) -> void:
	"""Smooth exit animation"""
