## AccessibilitySettingsPanel.gd
## UI panel for accessibility settings in the educational platform
##
## This panel allows users to configure colorblind modes, motion preferences,
## contrast settings, and other accessibility features.
##
## @tutorial: Accessibility UI Design
## @version: 1.0

extends PanelContainer

# === SIGNALS ===

signal settings_changed
signal panel_closed

# === PRELOADS ===

const ICON_EYE = (
preload("res://assets/icons/eye.svg")
const ICON_MOTION = (
preload("res://assets/icons/motion.svg")
const ICON_CONTRAST = (
preload("res://assets/icons/contrast.svg")

var accessibility_manager: Node
var visual_feedback_system: Node
var original_settings: Dictionary = {}


# === INITIALIZATION ===
var settings = accessibility_manager.get_settings()
original_settings = settings.duplicate()

# Apply to UI
var colors = accessibility_manager.get_recommended_colors()

# Apply to panel
var panel_style = StyleBoxFlat.new()
panel_style.bg_color = colors["background"]
panel_style.border_color = colors["primary"]
panel_style.set_border_width_all(2)
panel_style.set_corner_radius_all(8)
panel_style.content_margin_left = 16
panel_style.content_margin_right = 16
panel_style.content_margin_top = 16
panel_style.content_margin_bottom = 16

add_theme_stylebox_override("panel", panel_style)

# Apply to buttons
var button_style = StyleBoxFlat.new()
button_style.bg_color = colors["primary"]
button_style.set_corner_radius_all(4)
apply_button.add_theme_stylebox_override("normal", button_style)
apply_button.add_theme_color_override("font_color", colors["background"])

var reset_style = StyleBoxFlat.new()
reset_style.bg_color = colors["secondary"]
reset_style.set_corner_radius_all(4)
reset_button.add_theme_stylebox_override("normal", reset_style)
reset_button.add_theme_color_override("font_color", colors["background"])


var preview_container = VBoxContainer.new()
preview_area.add_child(preview_container)

# Sample text
var sample_label = Label.new()
sample_label.text = "Sample Text: The quick brown fox jumps over the lazy dog"
sample_label.add_theme_font_size_override("font_size", int(font_size_slider.value))
preview_container.add_child(sample_label)

# Color samples
var color_container = HBoxContainer.new()
preview_container.add_child(color_container)

var colors_2 = accessibility_manager.get_recommended_colors() if accessibility_manager else {}

var color_rect = ColorRect.new()
color_rect.color = colors[color_name]
color_rect.custom_minimum_size = Vector2(40, 40)
color_rect.tooltip_text = color_name.capitalize()
color_container.add_child(color_rect)

# Add spacing
var spacer = Control.new()
spacer.custom_minimum_size = Vector2(8, 0)
color_container.add_child(spacer)


# === SIGNAL CALLBACKS ===
var modes = ["none", "deuteranope", "protanope", "tritanope", "monochrome"]
var confirm_dialog = AcceptDialog.new()
confirm_dialog.dialog_text = "Accessibility settings applied successfully!"
confirm_dialog.title = "Settings Applied"
get_tree().root.add_child(confirm_dialog)
confirm_dialog.popup_centered()
confirm_dialog.popup_hide.connect(func(): confirm_dialog.queue_free())


@onready var colorblind_option: OptionButton = $VBox/ColorblindSection/ColorblindOption
@onready var reduce_motion_check: CheckBox = $VBox/MotionSection/ReduceMotionCheck
@onready var high_contrast_check: CheckBox = $VBox/ContrastSection/HighContrastCheck
@onready var enhanced_outlines_check: CheckBox = $VBox/ContrastSection/EnhancedOutlinesCheck
@onready var font_size_slider: HSlider = $VBox/TextSection/FontSizeSlider
@onready var font_size_label: Label = $VBox/TextSection/FontSizeLabel
@onready var preview_area: Control = $VBox/PreviewSection/PreviewArea
@onready var apply_button: Button = $VBox/ButtonContainer/ApplyButton
@onready var reset_button: Button = $VBox/ButtonContainer/ResetButton

# === PRIVATE VARIABLES ===

func _ready() -> void:
	"""Initialize accessibility settings panel"""
	# Get accessibility manager
	if has_node("/root/AccessibilityManager"):
		accessibility_manager = get_node("/root/AccessibilityManager")
		_load_current_settings()
		else:
			push_warning("[AccessibilityPanel] AccessibilityManager not found")

			# Setup UI
			_setup_ui()
			_connect_signals()

			# Apply theme
			_apply_theme()


			# === PRIVATE METHODS ===

func show_panel() -> void:
	"""Show the accessibility settings panel"""
	show()
	_load_current_settings()
	_update_preview()


	## Hide the accessibility panel
func hide_panel() -> void:
	"""Hide the accessibility settings panel"""
	hide()
	panel_closed.emit()

func _fix_orphaned_code():
	if FileAccess.file_exists("res://assets/icons/eye.svg")
	else null
	)
func _fix_orphaned_code():
	if FileAccess.file_exists("res://assets/icons/motion.svg")
	else null
	)
func _fix_orphaned_code():
	if FileAccess.file_exists("res://assets/icons/contrast.svg")
	else null
	)

	# === NODES ===

func _fix_orphaned_code():
	if colorblind_option:
		match settings.get("colorblind_mode", "none"):
			"deuteranope":
				colorblind_option.select(1)
				"protanope":
					colorblind_option.select(2)
					"tritanope":
						colorblind_option.select(3)
						"monochrome":
							colorblind_option.select(4)
							_:
								colorblind_option.select(0)

								if reduce_motion_check:
									reduce_motion_check.button_pressed = settings.get("reduce_motion", false)

									if high_contrast_check:
										high_contrast_check.button_pressed = settings.get("high_contrast", false)

										if enhanced_outlines_check:
											enhanced_outlines_check.button_pressed = settings.get("enhanced_outlines", false)

											if font_size_slider:
												font_size_slider.value = settings.get("font_size", 18.0)
												_update_font_size_label(font_size_slider.value)


func _fix_orphaned_code():
	if apply_button:
func _fix_orphaned_code():
	if reset_button:
func _fix_orphaned_code():
	for color_name in ["primary", "secondary", "success", "warning", "error"]:
		if colors.has(color_name):
func _fix_orphaned_code():
	if color_name != "error":
func _fix_orphaned_code():
	if index < modes.size():
		accessibility_manager.set_colorblind_mode(modes[index])
		_update_preview()
		_apply_theme()


func _setup_ui() -> void:
	"""Setup UI elements"""
	# Configure colorblind options
	if colorblind_option:
		colorblind_option.clear()
		colorblind_option.add_item("None (Normal Vision)")
		colorblind_option.add_item("Deuteranope (Red-Green)")
		colorblind_option.add_item("Protanope (Red-Green)")
		colorblind_option.add_item("Tritanope (Blue-Yellow)")
		colorblind_option.add_item("Monochrome (Grayscale)")

		# Add tooltips
		colorblind_option.tooltip_text = "Select color vision mode for optimal visibility"

		# Configure motion settings
		if reduce_motion_check:
			reduce_motion_check.tooltip_text = "Reduce animations and transitions for motion sensitivity"

			# Configure contrast settings
			if high_contrast_check:
				high_contrast_check.tooltip_text = "Increase contrast for better visibility"

				if enhanced_outlines_check:
					enhanced_outlines_check.tooltip_text = "Add thicker outlines to selectable structures"

					# Configure font size
					if font_size_slider:
						font_size_slider.min_value = 14.0
						font_size_slider.max_value = 32.0
						font_size_slider.step = 1.0
						font_size_slider.value = 18.0
						font_size_slider.tooltip_text = "Adjust text size for better readability"


func _connect_signals() -> void:
	"""Connect UI signals"""
	if colorblind_option:
		colorblind_option.item_selected.connect(_on_colorblind_mode_changed)

		if reduce_motion_check:
			reduce_motion_check.toggled.connect(_on_reduce_motion_toggled)

			if high_contrast_check:
				high_contrast_check.toggled.connect(_on_high_contrast_toggled)

				if enhanced_outlines_check:
					enhanced_outlines_check.toggled.connect(_on_enhanced_outlines_toggled)

					if font_size_slider:
						font_size_slider.value_changed.connect(_on_font_size_changed)

						if apply_button:
							apply_button.pressed.connect(_on_apply_pressed)

							if reset_button:
								reset_button.pressed.connect(_on_reset_pressed)


func _load_current_settings() -> void:
	"""Load current settings from accessibility manager"""
	if not accessibility_manager:
		return

func _apply_theme() -> void:
	"""Apply UI theme based on current settings"""
	if not accessibility_manager:
		return

func _update_preview() -> void:
	"""Update preview area with current settings"""
	if not preview_area:
		return

		# Clear previous preview
		for child in preview_area.get_children():
			child.queue_free()

			# Create preview elements
func _on_colorblind_mode_changed(index: int) -> void:
	"""Handle colorblind mode change"""
	if not accessibility_manager:
		return

func _on_reduce_motion_toggled(enabled: bool) -> void:
	"""Handle reduce motion toggle"""
	if accessibility_manager:
		accessibility_manager.set_reduce_motion(enabled)


func _on_high_contrast_toggled(enabled: bool) -> void:
	"""Handle high contrast toggle"""
	if accessibility_manager:
		accessibility_manager.set_high_contrast(enabled)
		_update_preview()
		_apply_theme()


func _on_enhanced_outlines_toggled(enabled: bool) -> void:
	"""Handle enhanced outlines toggle"""
	if accessibility_manager:
		accessibility_manager.enhanced_outlines = enabled
		accessibility_manager.save_settings()


func _on_font_size_changed(value: float) -> void:
	"""Handle font size change"""
	_update_font_size_label(value)
	if accessibility_manager:
		accessibility_manager.set_font_size(value)
		_update_preview()


func _update_font_size_label(size: float) -> void:
	"""Update font size label"""
	if font_size_label:
		font_size_label.text = "%d px" % int(size)


func _on_apply_pressed() -> void:
	"""Apply and save settings"""
	if accessibility_manager:
		accessibility_manager.save_settings()
		settings_changed.emit()

		# Show confirmation
func _on_reset_pressed() -> void:
	"""Reset to original settings"""
	if not accessibility_manager or original_settings.is_empty():
		return

		# Restore original settings
		if original_settings.has("colorblind_mode"):
			accessibility_manager.set_colorblind_mode(original_settings["colorblind_mode"])

			if original_settings.has("reduce_motion"):
				accessibility_manager.set_reduce_motion(original_settings["reduce_motion"])

				if original_settings.has("high_contrast"):
					accessibility_manager.set_high_contrast(original_settings["high_contrast"])

					if original_settings.has("enhanced_outlines"):
						accessibility_manager.enhanced_outlines = original_settings["enhanced_outlines"]

						if original_settings.has("font_size"):
							accessibility_manager.set_font_size(original_settings["font_size"])

							# Reload UI
							_load_current_settings()
							_update_preview()
							_apply_theme()


							# === PUBLIC METHODS ===
							## Show the accessibility panel
