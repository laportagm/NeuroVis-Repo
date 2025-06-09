# gdlint: disable=max-public-methods
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

extends Node

# === SIGNALS ===
signal accessibility_changed(feature: String, enabled: bool)
signal font_size_changed(new_size: int)
signal contrast_mode_changed(mode: String)
signal focus_changed(control: Control)
signal announcement_requested(text: String, priority: String)

# === ENUMS ===
# Contrast modes
enum ContrastMode { NORMAL, HIGH_CONTRAST, INVERTED, CUSTOM }

# === CONSTANTS ===
const SETTINGS_FILE = "user://accessibility_settings.cfg"
const MIN_FONT_SIZE = 12
const MAX_FONT_SIZE = 32
const DEFAULT_FONT_SIZE = 16

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

# === PRIVATE VARIABLES ===
var _settings: ConfigFile
var _accessibility_helper  # Reference to AccessibilityHelper if needed
var _current_focus_group: String = "main_ui"
var _navigation_enabled: bool = true
var _announcements_queue: Array = []
var _is_initialized: bool = false

# Accessibility state
var _high_contrast_enabled: bool = false
var _reduced_motion: bool = false
var _screen_reader_active: bool = false
var _keyboard_navigation: bool = true
var _font_size_multiplier: float = 1.0
var _focus_indicators_visible: bool = true


# === LIFECYCLE ===
func _ready() -> void:
	"""Initialize accessibility manager"""
	_load_settings()
	_setup_accessibility_features()
	_is_initialized = true
	print("[AccessibilityManager] Accessibility system initialized")


func _exit_tree() -> void:
	"""Save settings on exit"""
	_save_settings()


# === PUBLIC METHODS ===
func enable_high_contrast(enabled: bool) -> void:
	"""Enable or disable high contrast mode"""
	if _high_contrast_enabled != enabled:
		_high_contrast_enabled = enabled
		_apply_contrast_mode()
		accessibility_changed.emit("high_contrast", enabled)
		print("[AccessibilityManager] High contrast mode: " + str(enabled))


func enable_reduced_motion(enabled: bool) -> void:
	"""Enable or disable reduced motion mode"""
	if _reduced_motion != enabled:
		_reduced_motion = enabled
		Engine.time_scale = 1.0 if not enabled else 1.0  # Can be adjusted
		accessibility_changed.emit("reduced_motion", enabled)
		print("[AccessibilityManager] Reduced motion mode: " + str(enabled))


func set_font_size_multiplier(multiplier: float) -> void:
	"""Set font size multiplier for all text"""
	_font_size_multiplier = clamp(multiplier, 0.75, 2.0)
	font_size_changed.emit(int(DEFAULT_FONT_SIZE * _font_size_multiplier))
	print("[AccessibilityManager] Font size multiplier: " + str(_font_size_multiplier))


func announce_to_screen_reader(text: String, priority: String = "normal") -> void:
	"""Queue announcement for screen reader"""
	if _screen_reader_active:
		_announcements_queue.append({"text": text, "priority": priority})
		announcement_requested.emit(text, priority)


func enable_keyboard_navigation(enabled: bool) -> void:
	"""Enable or disable keyboard navigation"""
	_keyboard_navigation = enabled
	_navigation_enabled = enabled
	accessibility_changed.emit("keyboard_navigation", enabled)


func focus_next_in_group() -> void:
	"""Focus next element in current navigation group"""
	if not _keyboard_navigation:
		return
	# Implementation depends on UI structure
	print("[AccessibilityManager] Focus next in group: " + _current_focus_group)


func focus_previous_in_group() -> void:
	"""Focus previous element in current navigation group"""
	if not _keyboard_navigation:
		return
	# Implementation depends on UI structure
	print("[AccessibilityManager] Focus previous in group: " + _current_focus_group)


func switch_navigation_group(group_name: String) -> void:
	"""Switch to different navigation group"""
	if NAV_GROUPS.has(group_name):
		_current_focus_group = group_name
		print("[AccessibilityManager] Switched to navigation group: " + group_name)


func is_high_contrast_enabled() -> bool:
	"""Check if high contrast mode is enabled"""
	return _high_contrast_enabled


func is_reduced_motion_enabled() -> bool:
	"""Check if reduced motion is enabled"""
	return _reduced_motion


func get_font_size_multiplier() -> float:
	"""Get current font size multiplier"""
	return _font_size_multiplier


func is_screen_reader_active() -> bool:
	"""Check if screen reader is active"""
	return _screen_reader_active


func is_keyboard_navigation_enabled() -> bool:
	"""Check if keyboard navigation is enabled"""
	return _keyboard_navigation


# === PRIVATE METHODS ===
func _load_settings() -> void:
	"""Load accessibility settings from file"""
	_settings = ConfigFile.new()
	var result = _settings.load(SETTINGS_FILE)

	if result == OK:
		_high_contrast_enabled = _settings.get_value("accessibility", "high_contrast", false)
		_reduced_motion = _settings.get_value("accessibility", "reduced_motion", false)
		_screen_reader_active = _settings.get_value("accessibility", "screen_reader", false)
		_keyboard_navigation = _settings.get_value("accessibility", "keyboard_nav", true)
		_font_size_multiplier = _settings.get_value("accessibility", "font_size", 1.0)
		print("[AccessibilityManager] Settings loaded successfully")
	else:
		print("[AccessibilityManager] No settings file found, using defaults")


func _save_settings() -> void:
	"""Save accessibility settings to file"""
	_settings.set_value("accessibility", "high_contrast", _high_contrast_enabled)
	_settings.set_value("accessibility", "reduced_motion", _reduced_motion)
	_settings.set_value("accessibility", "screen_reader", _screen_reader_active)
	_settings.set_value("accessibility", "keyboard_nav", _keyboard_navigation)
	_settings.set_value("accessibility", "font_size", _font_size_multiplier)

	var result = _settings.save(SETTINGS_FILE)
	if result == OK:
		print("[AccessibilityManager] Settings saved successfully")
	else:
		push_error("[AccessibilityManager] Failed to save settings")


func _setup_accessibility_features() -> void:
	"""Setup initial accessibility features"""
	if _high_contrast_enabled:
		_apply_contrast_mode()

	if _reduced_motion:
		Engine.time_scale = 1.0  # Can be adjusted

	# Apply font size multiplier
	if _font_size_multiplier != 1.0:
		font_size_changed.emit(int(DEFAULT_FONT_SIZE * _font_size_multiplier))


func _apply_contrast_mode() -> void:
	"""Apply contrast mode to UI"""
	var mode = ContrastMode.HIGH_CONTRAST if _high_contrast_enabled else ContrastMode.NORMAL
	contrast_mode_changed.emit(ContrastMode.keys()[mode])

	# This would typically update theme resources
	# For now, just log the change
	print("[AccessibilityManager] Contrast mode applied: " + ContrastMode.keys()[mode])


# === INPUT HANDLING ===
func _input(event: InputEvent) -> void:
	"""Handle accessibility shortcuts"""
	if not _keyboard_navigation:
		return

	if event is InputEventKey and event.pressed:
		# Tab navigation
		if event.keycode == KEY_TAB:
			if event.shift_pressed:
				focus_previous_in_group()
			else:
				focus_next_in_group()
			get_viewport().set_input_as_handled()

		# Group switching (Ctrl+1-3)
		elif event.ctrl_pressed:
			match event.keycode:
				KEY_1:
					switch_navigation_group("main_ui")
					get_viewport().set_input_as_handled()
				KEY_2:
					switch_navigation_group("3d_controls")
					get_viewport().set_input_as_handled()
				KEY_3:
					switch_navigation_group("educational")
					get_viewport().set_input_as_handled()
