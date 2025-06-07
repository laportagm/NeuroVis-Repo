class_name ModelControlPanel
extends PanelContainer

signal model_selected(model_name: String)

var model_cards = {}

var style = StyleBoxFlat.new()
style.bg_color = Color(0.1, 0.1, 0.15, 0.9)
style.corner_radius_top_left = 12
style.corner_radius_top_right = 12
style.corner_radius_bottom_left = 12
style.corner_radius_bottom_right = 12
style.border_width_left = 1
style.border_width_right = 1
style.border_width_top = 1
style.border_width_bottom = 1
style.border_color = Color(1, 1, 1, 0.1)
style.shadow_size = 16
style.shadow_color = Color(0, 0, 0, 0.3)
style.shadow_offset = Vector2(0, 4)
add_theme_stylebox_override("panel", style)

var header = _create_panel_header()
models_container.add_child(header)

# Create modern toggle cards
var card = _create_model_card(model_names[i])
models_container.add_child(card)
model_cards[model_names[i]] = card

# Stagger animations for visual appeal
_animate_entrance(card, i * 0.1)

var container = VBoxContainer.new()
container.add_theme_constant_override("separation", 4)

var title = Label.new()
title.text = "Brain Models"
title.add_theme_font_size_override("font_size", 20)
title.add_theme_color_override("font_color", Color("#00D9FF"))  # Primary cyan
title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
container.add_child(title)

var subtitle = Label.new()
subtitle.text = "Toggle layer visibility"
subtitle.add_theme_font_size_override("font_size", 12)
subtitle.add_theme_color_override("font_color", Color(1, 1, 1, 0.6))
subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
container.add_child(subtitle)

# Add spacer
var spacer = Control.new()
spacer.custom_minimum_size.y = 8
container.add_child(spacer)

var card = PanelContainer.new()

# Modern card styling
var card_style = StyleBoxFlat.new()
card_style.bg_color = Color("#16213E").darkened(0.1)  # Surface light darkened
card_style.corner_radius_top_left = 8
card_style.corner_radius_top_right = 8
card_style.corner_radius_bottom_left = 8
card_style.corner_radius_bottom_right = 8
card_style.content_margin_left = 12
card_style.content_margin_right = 12
card_style.content_margin_top = 12
card_style.content_margin_bottom = 12
card_style.border_width_left = 1
card_style.border_width_right = 1
card_style.border_width_top = 1
card_style.border_width_bottom = 1
card_style.border_color = Color(1, 1, 1, 0.05)
card.add_theme_stylebox_override("panel", card_style)

var hbox = HBoxContainer.new()
hbox.add_theme_constant_override("separation", 12)
card.add_child(hbox)

# Model info section
var info = VBoxContainer.new()
info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
info.add_theme_constant_override("separation", 2)
hbox.add_child(info)

var name_label = Label.new()
name_label.text = model_name
name_label.add_theme_font_size_override("font_size", 16)
name_label.add_theme_color_override("font_color", Color("#FFFFFF"))  # White text
info.add_child(name_label)

var status = Label.new()
status.text = "Visible"
status.add_theme_color_override("font_color", Color("#06FFA5"))  # Success green
status.add_theme_font_size_override("font_size", 12)
info.add_child(status)

# Modern toggle switch
var toggle = CheckButton.new()
toggle.button_pressed = true
toggle.toggled.connect(_on_model_toggled.bind(model_name, status))

# Style the toggle
var toggle_style = StyleBoxFlat.new()
toggle_style.bg_color = Color("#00D9FF")  # Primary cyan
toggle_style.corner_radius_top_left = 12
toggle_style.corner_radius_top_right = 12
toggle_style.corner_radius_bottom_left = 12
toggle_style.corner_radius_bottom_right = 12
toggle.add_theme_stylebox_override("normal", toggle_style)

hbox.add_child(toggle)

# Store references in card metadata
card.set_meta("status_label", status)
card.set_meta("toggle", toggle)
card.set_meta("model_name", model_name)

# Add hover effect
_add_hover_effect(card)

var tween = card.create_tween()
tween.tween_property(card, "modulate", Color(1.1, 1.1, 1.1, 1.0), 0.1)

var tween = card.create_tween()
tween.tween_property(card, "modulate", Color.WHITE, 0.1)

var tween = status_label.create_tween()
tween.tween_property(status_label, "modulate:a", 0.0, 0.1)
tween.tween_callback(func():
var card = model_cards[model_name]
var toggle = card.get_meta("toggle") as CheckButton
var status = card.get_meta("status_label") as Label

var tween = status.create_tween()
	tween.tween_property(status, "modulate:a", 0.0, 0.1)
	tween.tween_callback(func():
var tween = control.create_tween()

@onready var models_container = $MarginContainer/VBoxContainer/ModelsContainer

func _ready() -> void:
	# Apply modern glass morphism theme

func setup_with_models(model_names: Array) -> void:
	print("Setting up modern model control panel with " + str(model_names.size()) + " models")

	# Clear existing
	for child in models_container.get_children():
		child.queue_free()
		model_cards.clear()

		# Add modern header
func update_button_state(model_name: String, visibility: bool) -> void:
	if not model_cards.has(model_name):
		print("Warning: Model card not found for: " + model_name)
		return

func _fix_orphaned_code():
	print("Modern ModelControlPanel initialized")

func _fix_orphaned_code():
	for i in range(model_names.size()):
func _fix_orphaned_code():
	return container

func _fix_orphaned_code():
	return card

func _fix_orphaned_code():
	if pressed:
		status_label.text = "Visible"
		status_label.add_theme_color_override("font_color", Color("#06FFA5"))  # Success green
		else:
			status_label.text = "Hidden"
			status_label.add_theme_color_override("font_color", Color(1, 1, 1, 0.5))
			)
			tween.tween_property(status_label, "modulate:a", 1.0, 0.1)

			model_selected.emit(model_name)

func _fix_orphaned_code():
	if not toggle or not status:
		print("Warning: Card components not found for: " + model_name)
		return

		# Update toggle without triggering signal
		toggle.set_block_signals(true)
		toggle.button_pressed = visibility
		toggle.set_block_signals(false)

		# Update status with animation
func _fix_orphaned_code():
	if visibility:
		status.text = "Visible"
		status.add_theme_color_override("font_color", Color("#06FFA5"))  # Success green
		else:
			status.text = "Hidden"
			status.add_theme_color_override("font_color", Color(1, 1, 1, 0.5))
			)
			tween.tween_property(status, "modulate:a", 1.0, 0.1)

			# Animation helper function
func _fix_orphaned_code():
	if delay > 0:
		tween.tween_interval(delay)

		tween.set_parallel(true)
		tween.tween_property(control, "modulate:a", 1.0, 0.3).set_ease(Tween.EASE_OUT)
		tween.tween_property(control, "scale", Vector2.ONE, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func _create_panel_header() -> VBoxContainer:
func _create_model_card(model_name: String) -> PanelContainer:
func _add_hover_effect(card: PanelContainer) -> void:
	card.mouse_entered.connect(_on_card_hover_enter.bind(card))
	card.mouse_exited.connect(_on_card_hover_exit.bind(card))

func _on_card_hover_enter(card: PanelContainer) -> void:
func _on_card_hover_exit(card: PanelContainer) -> void:
func _on_model_toggled(pressed: bool, model_name: String, status_label: Label) -> void:
	print("Model '" + model_name + "' toggled to: " + str(pressed))

	# Update status with smooth animation
func _animate_entrance(control: Control, delay: float = 0.0) -> void:
	"""Smooth entrance animation for any control"""
	control.modulate.a = 0
	control.scale = Vector2(0.9, 0.9)
