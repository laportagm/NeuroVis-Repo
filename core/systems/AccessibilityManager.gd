## AccessibilityManager.gd
## Comprehensive accessibility system for educational platform
## Ensures WCAG 2.1 AA compliance for diverse learning needs
##
## This manager provides centralized accessibility features including:
## - Keyboard navigation support
## - Screen reader compatibility
## - High contrast modes
## - Font size adjustment
## - Motion reduction
## - Focus indicators
## - Educational content alternatives
##
## @tutorial: WCAG 2.1 Guidelines
## @version: 2.0

class_name AccessibilityManager
extends Node

# === SIGNALS ===
signal accessibility_changed(feature: String, enabled: bool)
signal font_size_changed(new_size: int)
signal contrast_mode_changed(mode: String)
signal focus_changed(control: Control)
signal announcement_requested(text: String, priority: String)

# === CONSTANTS ===
const SETTINGS_FILE = "user://accessibility_settings.cfg"
const MIN_FONT_SIZE = 12
const MAX_FONT_SIZE = 32
const DEFAULT_FONT_SIZE = 16

# Contrast modes
enum ContrastMode { NORMAL, HIGH_CONTRAST, INVERTED, CUSTOM }

# Focus indicator styles
const FOCUS_STYLES = {
	"default": {"color": Color.CYAN, "width": 3},
	"high_contrast": {"color": Color.YELLOW, "width": 4},
	"inverted": {"color": Color.WHITE, "width": 4}
}

# Keyboard navigation groups
const NAV_GROUPS = {
	"main_ui": ["info_panel", "control_panel", "settings"],
	"3d_controls": ["camera", "selection", "zoom"],
	"educational": ["questions", "notes", "progress"]
}

# === VARIABLES ===
var _config: ConfigFile
var _current_font_size: int = DEFAULT_FONT_SIZE
var _contrast_mode: ContrastMode = ContrastMode.NORMAL
var _screen_reader_enabled: bool = false
var _motion_reduced: bool = false
var _keyboard_nav_enabled: bool = true
var _focus_indicators_visible: bool = true
var _audio_descriptions_enabled: bool = false
var _captions_enabled: bool = false

# Navigation state
var _current_focus: Control = null
var _focus_history: Array[Control] = []
var _nav_group_index: int = 0
var _is_navigating: bool = false

# Screen reader queue
var _announcement_queue: Array = []
var _is_announcing: bool = false


# === LIFECYCLE ===
func _ready() -> void:
	"""Initialize comprehensive accessibility system"""
	_config = ConfigFile.new()
	_load_settings()
	_setup_keyboard_navigation()
	_apply_accessibility_features()

	# Connect to system signals
	get_viewport().gui_focus_changed.connect(_on_focus_changed)

	print("[AccessibilityManager] Comprehensive accessibility system initialized")


func _input(event: InputEvent) -> void:
	"""Handle accessibility input events"""
	if not _keyboard_nav_enabled:
		return

	# Tab navigation
	if event.is_action_pressed("ui_focus_next"):
		_navigate_next()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_focus_prev"):
		_navigate_previous()
		get_viewport().set_input_as_handled()

	# Escape key to return focus
	elif event.is_action_pressed("ui_cancel") and _current_focus:
		_restore_previous_focus()
		get_viewport().set_input_as_handled()

	# Accessibility shortcuts
	elif event is InputEventKey and event.pressed:
		if event.ctrl_pressed:
			match event.keycode:
				KEY_PLUS, KEY_EQUAL:
					increase_font_size()
					get_viewport().set_input_as_handled()
				KEY_MINUS:
					decrease_font_size()
					get_viewport().set_input_as_handled()
				KEY_0:
					reset_font_size()
					get_viewport().set_input_as_handled()


# === PUBLIC METHODS - FONT SIZE ===
func set_font_size(size: int) -> void:
	"""Set educational content font size"""
	_current_font_size = clamp(size, MIN_FONT_SIZE, MAX_FONT_SIZE)
	_apply_font_size()
	_save_settings()
	font_size_changed.emit(_current_font_size)
	accessibility_changed.emit("font_size", true)

	# Announce to screen reader
	announce("Font size changed to %d pixels" % _current_font_size)


func increase_font_size() -> void:
	"""Increase font size by 2 pixels"""
	set_font_size(_current_font_size + 2)


func decrease_font_size() -> void:
	"""Decrease font size by 2 pixels"""
	set_font_size(_current_font_size - 2)


func reset_font_size() -> void:
	"""Reset to default font size"""
	set_font_size(DEFAULT_FONT_SIZE)


func get_font_size() -> int:
	"""Get current educational font size"""
	return _current_font_size


# === PUBLIC METHODS - CONTRAST ===
func set_contrast_mode(mode: ContrastMode) -> void:
	"""Set contrast mode for visual accessibility"""
	_contrast_mode = mode
	_apply_contrast_mode()
	_save_settings()

	var mode_name = _get_contrast_mode_name(mode)
	contrast_mode_changed.emit(mode_name)
	accessibility_changed.emit("contrast", true)
	announce("Contrast mode changed to %s" % mode_name)


func enable_high_contrast(enabled: bool) -> void:
	"""Enable/disable high contrast mode"""
	if enabled:
		set_contrast_mode(ContrastMode.HIGH_CONTRAST)
	else:
		set_contrast_mode(ContrastMode.NORMAL)


func get_contrast_mode() -> ContrastMode:
	"""Get current contrast mode"""
	return _contrast_mode


func is_high_contrast_enabled() -> bool:
	"""Check if high contrast is enabled"""
	return _contrast_mode == ContrastMode.HIGH_CONTRAST


# === PUBLIC METHODS - SCREEN READER ===
func enable_screen_reader(enabled: bool) -> void:
	"""Enable screen reader support"""
	_screen_reader_enabled = enabled
	_save_settings()
	accessibility_changed.emit("screen_reader", enabled)

	if enabled:
		announce("Screen reader support enabled")
		_setup_screen_reader_hints()
	else:
		announce("Screen reader support disabled")


func announce(text: String, priority: String = "normal") -> void:
	"""Announce text to screen reader"""
	if not _screen_reader_enabled:
		return

	_announcement_queue.append({"text": text, "priority": priority})
	announcement_requested.emit(text, priority)

	if not _is_announcing:
		_process_announcement_queue()


func announce_educational_content(structure_name: String, description: String) -> void:
	"""Announce educational content with proper structure"""
	if not _screen_reader_enabled:
		return

	var announcement = "Selected structure: %s. %s" % [structure_name, description]
	announce(announcement, "high")


# === PUBLIC METHODS - MOTION ===
func reduce_motion(enabled: bool) -> void:
	"""Reduce motion for educational animations"""
	_motion_reduced = enabled
	_save_settings()
	accessibility_changed.emit("motion_reduced", enabled)

	if enabled:
		_disable_animations()
		announce("Motion reduced mode enabled")
	else:
		_enable_animations()
		announce("Motion reduced mode disabled")


func is_motion_reduced() -> bool:
	"""Check if motion is reduced"""
	return _motion_reduced


# === PUBLIC METHODS - KEYBOARD NAVIGATION ===
func enable_keyboard_navigation(enabled: bool) -> void:
	"""Enable/disable keyboard navigation"""
	_keyboard_nav_enabled = enabled
	_save_settings()
	accessibility_changed.emit("keyboard_nav", enabled)

	if enabled:
		announce("Keyboard navigation enabled. Use Tab to navigate.")


func set_focus_to(control: Control) -> void:
	"""Set focus to specific control"""
	if control and is_instance_valid(control):
		control.grab_focus()
		_current_focus = control
		focus_changed.emit(control)


func get_current_focus() -> Control:
	"""Get currently focused control"""
	return _current_focus


# === PUBLIC METHODS - AUDIO DESCRIPTIONS ===
func enable_audio_descriptions(enabled: bool) -> void:
	"""Enable audio descriptions for visual content"""
	_audio_descriptions_enabled = enabled
	_save_settings()
	accessibility_changed.emit("audio_descriptions", enabled)


func enable_captions(enabled: bool) -> void:
	"""Enable captions for audio content"""
	_captions_enabled = enabled
	_save_settings()
	accessibility_changed.emit("captions", enabled)


# === PUBLIC METHODS - FOCUS INDICATORS ===
func show_focus_indicators(visible: bool) -> void:
	"""Show/hide focus indicators"""
	_focus_indicators_visible = visible
	_update_focus_indicator()
	_save_settings()
	accessibility_changed.emit("focus_indicators", visible)


# === PUBLIC METHODS - UTILITIES ===
func get_accessible_color(base_color: Color) -> Color:
	"""Get accessible version of color based on contrast mode"""
	match _contrast_mode:
		ContrastMode.HIGH_CONTRAST:
			# Increase contrast
			if base_color.get_luminance() > 0.5:
				return Color.WHITE
			else:
				return Color.BLACK
		ContrastMode.INVERTED:
			# Invert colors
			return Color(1.0 - base_color.r, 1.0 - base_color.g, 1.0 - base_color.b, base_color.a)
		_:
			return base_color


func get_accessible_font_size(base_size: int) -> int:
	"""Get adjusted font size based on accessibility settings"""
	var scale = float(_current_font_size) / float(DEFAULT_FONT_SIZE)
	return int(base_size * scale)


func create_accessible_button(text: String, tooltip: String = "") -> Button:
	"""Create button with accessibility features"""
	var button = Button.new()
	button.text = text
	button.tooltip_text = tooltip if tooltip else text

	# Apply accessibility features
	_apply_accessible_theme_to_control(button)

	# Add to navigation
	button.focus_mode = Control.FOCUS_ALL

	return button


# === PRIVATE METHODS - SETTINGS ===
func _load_settings() -> void:
	"""Load accessibility settings from disk"""
	var err = _config.load(SETTINGS_FILE)
	if err == OK:
		_current_font_size = _config.get_value("accessibility", "font_size", DEFAULT_FONT_SIZE)
		_contrast_mode = _config.get_value("accessibility", "contrast_mode", ContrastMode.NORMAL)
		_screen_reader_enabled = _config.get_value("accessibility", "screen_reader", false)
		_motion_reduced = _config.get_value("accessibility", "motion_reduced", false)
		_keyboard_nav_enabled = _config.get_value("accessibility", "keyboard_nav", true)
		_focus_indicators_visible = _config.get_value("accessibility", "focus_indicators", true)
		_audio_descriptions_enabled = _config.get_value(
			"accessibility", "audio_descriptions", false
		)
		_captions_enabled = _config.get_value("accessibility", "captions", false)


func _save_settings() -> void:
	"""Save accessibility settings to disk"""
	_config.set_value("accessibility", "font_size", _current_font_size)
	_config.set_value("accessibility", "contrast_mode", _contrast_mode)
	_config.set_value("accessibility", "screen_reader", _screen_reader_enabled)
	_config.set_value("accessibility", "motion_reduced", _motion_reduced)
	_config.set_value("accessibility", "keyboard_nav", _keyboard_nav_enabled)
	_config.set_value("accessibility", "focus_indicators", _focus_indicators_visible)
	_config.set_value("accessibility", "audio_descriptions", _audio_descriptions_enabled)
	_config.set_value("accessibility", "captions", _captions_enabled)
	_config.save(SETTINGS_FILE)


# === PRIVATE METHODS - APPLY FEATURES ===
func _apply_accessibility_features() -> void:
	"""Apply all current accessibility settings"""
	_apply_font_size()
	_apply_contrast_mode()

	if _motion_reduced:
		_disable_animations()

	if _screen_reader_enabled:
		_setup_screen_reader_hints()


func _apply_font_size() -> void:
	"""Apply font size to all UI elements"""
	# Get all text-based nodes in the scene
	var all_nodes = get_tree().get_nodes_in_group("accessible_text")
	for node in all_nodes:
		if node.has_method("set_theme_font_size"):
			node.set_theme_font_size("font_size", _current_font_size)


func _apply_contrast_mode() -> void:
	"""Apply contrast mode to entire UI"""
	# Apply to theme manager if available
	var theme_manager = get_node_or_null("/root/UIThemeManager")
	if theme_manager and theme_manager.has_method("apply_contrast_mode"):
		theme_manager.apply_contrast_mode(_get_contrast_mode_name(_contrast_mode))

	# Apply to all UI elements
	var all_controls = get_tree().get_nodes_in_group("accessible_ui")
	for control in all_controls:
		_apply_accessible_theme_to_control(control)


func _apply_accessible_theme_to_control(control: Control) -> void:
	"""Apply accessible theme to individual control"""
	if not control:
		return

	# Adjust colors based on contrast mode
	if control.has_theme_color("font_color"):
		var base_color = control.get_theme_color("font_color")
		control.add_theme_color_override("font_color", get_accessible_color(base_color))

	# Adjust font size
	if control.has_theme_font_size("font_size"):
		var base_size = control.get_theme_font_size("font_size")
		control.add_theme_font_size_override("font_size", get_accessible_font_size(base_size))


# === PRIVATE METHODS - ANIMATIONS ===
func _disable_animations() -> void:
	"""Disable all non-essential animations"""
	# Set global animation speed to 0
	Engine.time_scale = 1.0  # Keep game time normal

	# Notify all animated elements
	get_tree().call_group("animated_elements", "_disable_animation")

	print("[AccessibilityManager] Animations disabled for accessibility")


func _enable_animations() -> void:
	"""Re-enable animations"""
	get_tree().call_group("animated_elements", "_enable_animation")
	print("[AccessibilityManager] Animations enabled")


# === PRIVATE METHODS - KEYBOARD NAVIGATION ===
func _setup_keyboard_navigation() -> void:
	"""Setup keyboard navigation system"""
	# Create navigation actions if they don't exist
	if not InputMap.has_action("ui_focus_next"):
		InputMap.add_action("ui_focus_next")
		var tab_event = InputEventKey.new()
		tab_event.keycode = KEY_TAB
		InputMap.action_add_event("ui_focus_next", tab_event)

	if not InputMap.has_action("ui_focus_prev"):
		InputMap.add_action("ui_focus_prev")
		var shift_tab_event = InputEventKey.new()
		shift_tab_event.keycode = KEY_TAB
		shift_tab_event.shift_pressed = true
		InputMap.action_add_event("ui_focus_prev", shift_tab_event)


func _navigate_next() -> void:
	"""Navigate to next focusable element"""
	_is_navigating = true

	# Get all focusable controls
	var focusable = _get_focusable_controls()
	if focusable.is_empty():
		return

	# Find current index
	var current_index = -1
	if _current_focus:
		current_index = focusable.find(_current_focus)

	# Move to next
	var next_index = (current_index + 1) % focusable.size()
	set_focus_to(focusable[next_index])

	_is_navigating = false


func _navigate_previous() -> void:
	"""Navigate to previous focusable element"""
	_is_navigating = true

	# Get all focusable controls
	var focusable = _get_focusable_controls()
	if focusable.is_empty():
		return

	# Find current index
	var current_index = -1
	if _current_focus:
		current_index = focusable.find(_current_focus)

	# Move to previous
	var prev_index = (current_index - 1) % focusable.size()
	if prev_index < 0:
		prev_index = focusable.size() - 1

	set_focus_to(focusable[prev_index])

	_is_navigating = false


func _get_focusable_controls() -> Array[Control]:
	"""Get all focusable controls in current context"""
	var focusable: Array[Control] = []

	# Get all controls in the current scene
	var all_controls = get_tree().get_nodes_in_group("focusable")

	# Add default focusable controls if group is empty
	if all_controls.is_empty():
		all_controls = []
		_get_all_focusable_recursive(get_tree().root, all_controls)

	# Filter visible and focusable
	for control in all_controls:
		if control is Control and control.visible and control.focus_mode != Control.FOCUS_NONE:
			focusable.append(control)

	# Sort by position for logical navigation
	focusable.sort_custom(_sort_by_position)

	return focusable


func _get_all_focusable_recursive(node: Node, result: Array) -> void:
	"""Recursively find all focusable controls"""
	if node is Control and node.focus_mode != Control.FOCUS_NONE:
		result.append(node)

	for child in node.get_children():
		_get_all_focusable_recursive(child, result)


func _sort_by_position(a: Control, b: Control) -> bool:
	"""Sort controls by visual position (top-left to bottom-right)"""
	var pos_a = a.global_position
	var pos_b = b.global_position

	# First sort by Y position (top to bottom)
	if abs(pos_a.y - pos_b.y) > 10:
		return pos_a.y < pos_b.y

	# Then by X position (left to right)
	return pos_a.x < pos_b.x


func _restore_previous_focus() -> void:
	"""Restore focus to previous control"""
	if _focus_history.size() > 1:
		_focus_history.pop_back()  # Remove current
		var previous = _focus_history[-1]
		if is_instance_valid(previous):
			set_focus_to(previous)


# === PRIVATE METHODS - SCREEN READER ===
func _setup_screen_reader_hints() -> void:
	"""Setup screen reader hints for UI elements"""
	# Add screen reader hints to all controls
	var all_controls = get_tree().get_nodes_in_group("accessible_ui")
	for control in all_controls:
		_add_screen_reader_hint(control)


func _add_screen_reader_hint(control: Control) -> void:
	"""Add screen reader hint to control"""
	if not control:
		return

	# Set accessible name and description
	if control is Button:
		if control.tooltip_text.is_empty():
			control.tooltip_text = control.text
	elif control is Label:
		control.mouse_filter = Control.MOUSE_FILTER_PASS  # Make labels readable

	# Add to accessible group
	control.add_to_group("accessible_ui")


func _process_announcement_queue() -> void:
	"""Process queued screen reader announcements"""
	if _announcement_queue.is_empty():
		_is_announcing = false
		return

	_is_announcing = true

	# Sort by priority
	_announcement_queue.sort_custom(func(a, b): return a["priority"] == "high")

	# Process first announcement
	var announcement = _announcement_queue.pop_front()
	print("[ScreenReader] %s" % announcement["text"])

	# Simulate announcement time
	get_tree().create_timer(0.1).timeout.connect(_process_announcement_queue)


# === PRIVATE METHODS - FOCUS INDICATORS ===
func _update_focus_indicator() -> void:
	"""Update focus indicator visibility"""
	if not _current_focus or not _focus_indicators_visible:
		return

	# Apply focus style based on contrast mode
	var style = FOCUS_STYLES.get(
		_get_contrast_mode_name(_contrast_mode).to_lower(), FOCUS_STYLES["default"]
	)

	if _current_focus.has_theme_stylebox("focus"):
		var focus_style = StyleBoxFlat.new()
		focus_style.border_width_left = style["width"]
		focus_style.border_width_right = style["width"]
		focus_style.border_width_top = style["width"]
		focus_style.border_width_bottom = style["width"]
		focus_style.border_color = style["color"]
		focus_style.bg_color = Color.TRANSPARENT
		_current_focus.add_theme_stylebox_override("focus", focus_style)


# === SIGNAL HANDLERS ===
func _on_focus_changed(control: Control) -> void:
	"""Handle focus change events"""
	if _is_navigating or not control:
		return

	# Update focus tracking
	if _current_focus != control:
		_focus_history.append(control)
		if _focus_history.size() > 10:
			_focus_history.pop_front()

	_current_focus = control
	focus_changed.emit(control)

	# Update focus indicator
	if _focus_indicators_visible:
		_update_focus_indicator()

	# Announce to screen reader
	if _screen_reader_enabled and control:
		var announcement = _get_control_announcement(control)
		if not announcement.is_empty():
			announce(announcement)


func _get_control_announcement(control: Control) -> String:
	"""Get screen reader announcement for control"""
	var announcement = ""

	if control is Button:
		announcement = "Button: %s" % control.text
		if not control.tooltip_text.is_empty() and control.tooltip_text != control.text:
			announcement += ". %s" % control.tooltip_text
	elif control is LineEdit:
		announcement = "Text field"
		if control.placeholder_text:
			announcement += ": %s" % control.placeholder_text
	elif control is TextEdit:
		announcement = "Text area"
	elif control is CheckBox:
		announcement = (
			"Checkbox: %s. %s"
			% [control.text, "Checked" if control.button_pressed else "Not checked"]
		)
	elif control is OptionButton:
		announcement = (
			"Dropdown: %s. Selected: %s"
			% [control.get_meta("label", ""), control.get_item_text(control.selected)]
		)
	elif control is Slider:
		announcement = "Slider: Value %d" % control.value
	elif control is Label:
		announcement = "Text: %s" % control.text

	return announcement


# === UTILITY METHODS ===
func _get_contrast_mode_name(mode: ContrastMode) -> String:
	"""Get human-readable name for contrast mode"""
	match mode:
		ContrastMode.NORMAL:
			return "Normal"
		ContrastMode.HIGH_CONTRAST:
			return "High Contrast"
		ContrastMode.INVERTED:
			return "Inverted"
		ContrastMode.CUSTOM:
			return "Custom"
		_:
			return "Unknown"
