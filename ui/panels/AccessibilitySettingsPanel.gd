## AccessibilitySettingsPanel.gd
## Educational accessibility settings interface
## Provides user controls for all accessibility features
##
## This panel allows users to configure accessibility options including:
## - Font size adjustment
## - Contrast modes
## - Motion reduction
## - Screen reader support
## - Keyboard navigation
## - Focus indicators
##
## @tutorial: Accessibility Settings UI
## @version: 1.0

class_name AccessibilitySettingsPanel
extends PanelContainer

# === SIGNALS ===
signal settings_changed(setting: String, value: Variant)
signal panel_closed

# === CONSTANTS ===
const SECTION_SPACING = 20
const CONTROL_SPACING = 10
const MIN_PANEL_WIDTH = 400
const MIN_PANEL_HEIGHT = 500

# === VARIABLES ===
var _scroll_container: ScrollContainer
var _content_container: VBoxContainer

# Section containers
var _visual_section: VBoxContainer
var _audio_section: VBoxContainer
var _interaction_section: VBoxContainer
var _educational_section: VBoxContainer

# Visual controls
var _font_size_slider: HSlider
var _font_size_label: Label
var _contrast_options: OptionButton
var _focus_indicator_check: CheckBox

# Audio controls
var _screen_reader_check: CheckBox
var _audio_descriptions_check: CheckBox
var _captions_check: CheckBox

# Interaction controls
var _keyboard_nav_check: CheckBox
var _motion_reduce_check: CheckBox

# Educational controls
var _learning_hints_check: CheckBox
var _progress_tracking_check: CheckBox

# Buttons
var _apply_button: Button
var _reset_button: Button
var _close_button: Button


# === LIFECYCLE ===
func _ready() -> void:
	"""Initialize accessibility settings panel"""
	_setup_panel_structure()
	_create_visual_settings()
	_create_audio_settings()
	_create_interaction_settings()
	_create_educational_settings()
	_create_action_buttons()
	_connect_signals()
	_apply_theme()
	_load_current_settings()

	# Set initial focus
	if _font_size_slider:
		_font_size_slider.grab_focus()

	print("[AccessibilityPanel] Settings panel initialized")


# === SETUP METHODS ===
func _setup_panel_structure() -> void:
	"""Create the main panel structure"""
	# Configure panel
	custom_minimum_size = Vector2(MIN_PANEL_WIDTH, MIN_PANEL_HEIGHT)

	# Main scroll container
	_scroll_container = ScrollContainer.new()
	_scroll_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(_scroll_container)

	# Content container
	_content_container = VBoxContainer.new()
	_content_container.add_theme_constant_override("separation", SECTION_SPACING)
	_scroll_container.add_child(_content_container)

	# Add title
	var title = Label.new()
	title.text = "Accessibility Settings"
	title.add_theme_font_size_override("font_size", 24)
	title.add_to_group("accessible_text")
	_content_container.add_child(title)

	# Add description
	var description = Label.new()
	description.text = "Configure accessibility features for an optimal learning experience"
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	description.add_to_group("accessible_text")
	_content_container.add_child(description)

	# Add separator
	_content_container.add_child(HSeparator.new())


func _create_visual_settings() -> void:
	"""Create visual accessibility settings"""
	_visual_section = _create_section("Visual Settings", "Adjust display for visual comfort")

	# Font size control
	var font_container = HBoxContainer.new()
	font_container.add_theme_constant_override("separation", CONTROL_SPACING)

	var font_label = Label.new()
	font_label.text = "Font Size:"
	font_label.custom_minimum_size.x = 100
	font_label.add_to_group("accessible_text")
	font_container.add_child(font_label)

	_font_size_slider = HSlider.new()
	_font_size_slider.min_value = AccessibilityManager.MIN_FONT_SIZE
	_font_size_slider.max_value = AccessibilityManager.MAX_FONT_SIZE
	_font_size_slider.step = 1
	_font_size_slider.value = AccessibilityManager.DEFAULT_FONT_SIZE
	_font_size_slider.custom_minimum_size.x = 200
	_font_size_slider.tooltip_text = "Adjust text size throughout the application"
	_font_size_slider.focus_mode = Control.FOCUS_ALL
	_font_size_slider.add_to_group("focusable")
	font_container.add_child(_font_size_slider)

	_font_size_label = Label.new()
	_font_size_label.text = "%d px" % AccessibilityManager.DEFAULT_FONT_SIZE
	_font_size_label.custom_minimum_size.x = 50
	_font_size_label.add_to_group("accessible_text")
	font_container.add_child(_font_size_label)

	_visual_section.add_child(font_container)

	# Contrast mode
	var contrast_container = HBoxContainer.new()
	contrast_container.add_theme_constant_override("separation", CONTROL_SPACING)

	var contrast_label = Label.new()
	contrast_label.text = "Contrast Mode:"
	contrast_label.custom_minimum_size.x = 100
	contrast_label.add_to_group("accessible_text")
	contrast_container.add_child(contrast_label)

	_contrast_options = OptionButton.new()
	_contrast_options.add_item("Normal")
	_contrast_options.add_item("High Contrast")
	_contrast_options.add_item("Inverted")
	_contrast_options.add_item("Custom")
	_contrast_options.selected = 0
	_contrast_options.custom_minimum_size.x = 200
	_contrast_options.tooltip_text = "Select visual contrast mode"
	_contrast_options.focus_mode = Control.FOCUS_ALL
	_contrast_options.add_to_group("focusable")
	contrast_container.add_child(_contrast_options)

	_visual_section.add_child(contrast_container)

	# Focus indicators
	_focus_indicator_check = _create_checkbox(
		"Show Focus Indicators", "Display visual indicators when navigating with keyboard", true
	)
	_visual_section.add_child(_focus_indicator_check)


func _create_audio_settings() -> void:
	"""Create audio accessibility settings"""
	_audio_section = _create_section("Audio Settings", "Configure audio assistance features")

	# Screen reader
	_screen_reader_check = _create_checkbox(
		"Enable Screen Reader Support",
		"Provide text announcements for screen reader software",
		false
	)
	_audio_section.add_child(_screen_reader_check)

	# Audio descriptions
	_audio_descriptions_check = _create_checkbox(
		"Enable Audio Descriptions", "Provide audio descriptions of visual content", false
	)
	_audio_section.add_child(_audio_descriptions_check)

	# Captions
	_captions_check = _create_checkbox(
		"Enable Captions", "Display text captions for audio content", false
	)
	_audio_section.add_child(_captions_check)


func _create_interaction_settings() -> void:
	"""Create interaction accessibility settings"""
	_interaction_section = _create_section("Interaction Settings", "Customize input and navigation")

	# Keyboard navigation
	_keyboard_nav_check = _create_checkbox(
		"Enable Keyboard Navigation", "Navigate the interface using keyboard only", true
	)
	_interaction_section.add_child(_keyboard_nav_check)

	# Motion reduction
	_motion_reduce_check = _create_checkbox(
		"Reduce Motion", "Minimize animations and transitions", false
	)
	_interaction_section.add_child(_motion_reduce_check)


func _create_educational_settings() -> void:
	"""Create educational accessibility settings"""
	_educational_section = _create_section("Educational Features", "Learning assistance options")

	# Learning hints
	_learning_hints_check = _create_checkbox(
		"Show Learning Hints", "Display helpful hints and tips during exploration", true
	)
	_educational_section.add_child(_learning_hints_check)

	# Progress tracking
	_progress_tracking_check = _create_checkbox(
		"Enable Progress Tracking", "Track and display learning progress", true
	)
	_educational_section.add_child(_progress_tracking_check)


func _create_action_buttons() -> void:
	"""Create action buttons"""
	var button_container = HBoxContainer.new()
	button_container.add_theme_constant_override("separation", CONTROL_SPACING)
	button_container.alignment = BoxContainer.ALIGNMENT_END

	_reset_button = Button.new()
	_reset_button.text = "Reset to Defaults"
	_reset_button.tooltip_text = "Reset all settings to default values"
	_reset_button.focus_mode = Control.FOCUS_ALL
	_reset_button.add_to_group("focusable")
	button_container.add_child(_reset_button)

	_apply_button = Button.new()
	_apply_button.text = "Apply"
	_apply_button.tooltip_text = "Apply accessibility settings"
	_apply_button.focus_mode = Control.FOCUS_ALL
	_apply_button.add_to_group("focusable")
	button_container.add_child(_apply_button)

	_close_button = Button.new()
	_close_button.text = "Close"
	_close_button.tooltip_text = "Close settings panel"
	_close_button.focus_mode = Control.FOCUS_ALL
	_close_button.add_to_group("focusable")
	button_container.add_child(_close_button)

	_content_container.add_child(button_container)


# === HELPER METHODS ===
func _create_section(title: String, description: String) -> VBoxContainer:
	"""Create a settings section"""
	var section = VBoxContainer.new()
	section.add_theme_constant_override("separation", CONTROL_SPACING)

	# Section title
	var title_label = Label.new()
	title_label.text = title
	title_label.add_theme_font_size_override("font_size", 18)
	title_label.add_to_group("accessible_text")
	section.add_child(title_label)

	# Section description
	if not description.is_empty():
		var desc_label = Label.new()
		desc_label.text = description
		desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		desc_label.modulate.a = 0.8
		desc_label.add_to_group("accessible_text")
		section.add_child(desc_label)

	_content_container.add_child(section)
	return section


func _create_checkbox(text: String, tooltip: String, default_value: bool) -> CheckBox:
	"""Create an accessible checkbox"""
	var checkbox = CheckBox.new()
	checkbox.text = text
	checkbox.tooltip_text = tooltip
	checkbox.button_pressed = default_value
	checkbox.focus_mode = Control.FOCUS_ALL
	checkbox.add_to_group("focusable")
	checkbox.add_to_group("accessible_ui")
	return checkbox


# === SIGNAL CONNECTIONS ===
func _connect_signals() -> void:
	"""Connect UI signals"""
	# Visual settings
	_font_size_slider.value_changed.connect(_on_font_size_changed)
	_contrast_options.item_selected.connect(_on_contrast_changed)
	_focus_indicator_check.toggled.connect(_on_focus_indicators_toggled)

	# Audio settings
	_screen_reader_check.toggled.connect(_on_screen_reader_toggled)
	_audio_descriptions_check.toggled.connect(_on_audio_descriptions_toggled)
	_captions_check.toggled.connect(_on_captions_toggled)

	# Interaction settings
	_keyboard_nav_check.toggled.connect(_on_keyboard_nav_toggled)
	_motion_reduce_check.toggled.connect(_on_motion_reduce_toggled)

	# Educational settings
	_learning_hints_check.toggled.connect(_on_learning_hints_toggled)
	_progress_tracking_check.toggled.connect(_on_progress_tracking_toggled)

	# Action buttons
	_apply_button.pressed.connect(_on_apply_pressed)
	_reset_button.pressed.connect(_on_reset_pressed)
	_close_button.pressed.connect(_on_close_pressed)


# === SETTINGS MANAGEMENT ===
func _load_current_settings() -> void:
	"""Load current accessibility settings"""
	var accessibility = get_node_or_null("/root/AccessibilityManager")
	if not accessibility:
		return

	# Visual settings
	_font_size_slider.value = accessibility.get_font_size()
	_font_size_label.text = "%d px" % accessibility.get_font_size()
	_contrast_options.selected = accessibility.get_contrast_mode()

	# Other settings would be loaded similarly
	# This is a simplified version


func _apply_settings() -> void:
	"""Apply all settings to AccessibilityManager"""
	var accessibility = get_node_or_null("/root/AccessibilityManager")
	if not accessibility:
		return

	# Visual settings
	accessibility.set_font_size(int(_font_size_slider.value))
	accessibility.set_contrast_mode(_contrast_options.selected)
	accessibility.show_focus_indicators(_focus_indicator_check.button_pressed)

	# Audio settings
	accessibility.enable_screen_reader(_screen_reader_check.button_pressed)
	accessibility.enable_audio_descriptions(_audio_descriptions_check.button_pressed)
	accessibility.enable_captions(_captions_check.button_pressed)

	# Interaction settings
	accessibility.enable_keyboard_navigation(_keyboard_nav_check.button_pressed)
	accessibility.reduce_motion(_motion_reduce_check.button_pressed)

	# Educational settings are handled separately
	settings_changed.emit("all", null)


func _reset_settings() -> void:
	"""Reset all settings to defaults"""
	# Visual
	_font_size_slider.value = AccessibilityManager.DEFAULT_FONT_SIZE
	_contrast_options.selected = 0
	_focus_indicator_check.button_pressed = true

	# Audio
	_screen_reader_check.button_pressed = false
	_audio_descriptions_check.button_pressed = false
	_captions_check.button_pressed = false

	# Interaction
	_keyboard_nav_check.button_pressed = true
	_motion_reduce_check.button_pressed = false

	# Educational
	_learning_hints_check.button_pressed = true
	_progress_tracking_check.button_pressed = true


# === THEME APPLICATION ===
func _apply_theme() -> void:
	"""Apply accessibility-aware theme"""
	var theme_manager = get_node_or_null("/root/UIThemeManager")
	if theme_manager and theme_manager.has_method("apply_enhanced_panel_style"):
		theme_manager.apply_enhanced_panel_style(self, "settings")

	# Add all controls to accessible groups
	for child in _content_container.get_children():
		if child is Control:
			child.add_to_group("accessible_ui")


# === SIGNAL HANDLERS ===
func _on_font_size_changed(value: float) -> void:
	"""Handle font size slider change"""
	_font_size_label.text = "%d px" % int(value)
	settings_changed.emit("font_size", int(value))

	# Live preview
	var accessibility = get_node_or_null("/root/AccessibilityManager")
	if accessibility:
		accessibility.set_font_size(int(value))


func _on_contrast_changed(index: int) -> void:
	"""Handle contrast mode change"""
	settings_changed.emit("contrast_mode", index)


func _on_focus_indicators_toggled(pressed: bool) -> void:
	"""Handle focus indicators toggle"""
	settings_changed.emit("focus_indicators", pressed)


func _on_screen_reader_toggled(pressed: bool) -> void:
	"""Handle screen reader toggle"""
	settings_changed.emit("screen_reader", pressed)


func _on_audio_descriptions_toggled(pressed: bool) -> void:
	"""Handle audio descriptions toggle"""
	settings_changed.emit("audio_descriptions", pressed)


func _on_captions_toggled(pressed: bool) -> void:
	"""Handle captions toggle"""
	settings_changed.emit("captions", pressed)


func _on_keyboard_nav_toggled(pressed: bool) -> void:
	"""Handle keyboard navigation toggle"""
	settings_changed.emit("keyboard_nav", pressed)


func _on_motion_reduce_toggled(pressed: bool) -> void:
	"""Handle motion reduction toggle"""
	settings_changed.emit("motion_reduce", pressed)


func _on_learning_hints_toggled(pressed: bool) -> void:
	"""Handle learning hints toggle"""
	settings_changed.emit("learning_hints", pressed)


func _on_progress_tracking_toggled(pressed: bool) -> void:
	"""Handle progress tracking toggle"""
	settings_changed.emit("progress_tracking", pressed)


func _on_apply_pressed() -> void:
	"""Handle apply button press"""
	_apply_settings()

	# Announce to screen reader
	var accessibility = get_node_or_null("/root/AccessibilityManager")
	if accessibility:
		accessibility.announce("Settings applied")


func _on_reset_pressed() -> void:
	"""Handle reset button press"""
	_reset_settings()
	settings_changed.emit("reset", null)

	# Announce to screen reader
	var accessibility = get_node_or_null("/root/AccessibilityManager")
	if accessibility:
		accessibility.announce("Settings reset to defaults")


func _on_close_pressed() -> void:
	"""Handle close button press"""
	panel_closed.emit()
	queue_free()


# === INPUT HANDLING ===
func _input(event: InputEvent) -> void:
	"""Handle accessibility shortcuts"""
	if event.is_action_pressed("ui_cancel"):
		_on_close_pressed()
		get_viewport().set_input_as_handled()


# === PUBLIC METHODS ===
func show_panel() -> void:
	"""Show the accessibility settings panel"""
	show()
	_load_current_settings()

	# Set focus to first control
	if _font_size_slider:
		_font_size_slider.grab_focus()

	# Announce to screen reader
	var accessibility = get_node_or_null("/root/AccessibilityManager")
	if accessibility:
		accessibility.announce("Accessibility settings panel opened")


func hide_panel() -> void:
	"""Hide the accessibility settings panel"""
	hide()
	panel_closed.emit()
