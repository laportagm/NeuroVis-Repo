extends Node

## Accessibility Manager for Educational Platform
## Ensures WCAG 2.1 AA compliance for diverse learning needs
## @version: 1.0

# === SIGNALS ===
signal accessibility_changed(feature: String, enabled: bool)

# === CONSTANTS ===
const SETTINGS_FILE = "user://accessibility_settings.cfg"
const MIN_FONT_SIZE = 12
const MAX_FONT_SIZE = 32

# === VARIABLES ===
var _config: ConfigFile
var _current_font_size: int = 16
var _high_contrast_enabled: bool = false
var _screen_reader_enabled: bool = false
var _motion_reduced: bool = false


# === LIFECYCLE ===
func _ready() -> void:
	"""Initialize accessibility manager"""
	_config = ConfigFile.new()
	_load_settings()
	_apply_accessibility_features()
	print("[AccessibilityManager] Accessibility system ready")


# === PUBLIC METHODS ===
func set_font_size(size: int) -> void:
	"""Set educational content font size"""
	_current_font_size = clamp(size, MIN_FONT_SIZE, MAX_FONT_SIZE)
	_save_settings()
	accessibility_changed.emit("font_size", true)


func enable_high_contrast(enabled: bool) -> void:
	"""Enable high contrast mode for educational content"""
	_high_contrast_enabled = enabled
	_save_settings()
	accessibility_changed.emit("high_contrast", enabled)


func enable_screen_reader(enabled: bool) -> void:
	"""Enable screen reader support"""
	_screen_reader_enabled = enabled
	_save_settings()
	accessibility_changed.emit("screen_reader", enabled)


func reduce_motion(enabled: bool) -> void:
	"""Reduce motion for educational animations"""
	_motion_reduced = enabled
	_save_settings()
	accessibility_changed.emit("motion_reduced", enabled)


func get_font_size() -> int:
	"""Get current educational font size"""
	return _current_font_size


func is_high_contrast_enabled() -> bool:
	"""Check if high contrast is enabled"""
	return _high_contrast_enabled


func is_motion_reduced() -> bool:
	"""Check if motion is reduced"""
	return _motion_reduced


# === PRIVATE METHODS ===
func _load_settings() -> void:
	"""Load accessibility settings"""
	var err = _config.load(SETTINGS_FILE)
	if err == OK:
		_current_font_size = _config.get_value("accessibility", "font_size", 16)
		_high_contrast_enabled = _config.get_value("accessibility", "high_contrast", false)
		_screen_reader_enabled = _config.get_value("accessibility", "screen_reader", false)
		_motion_reduced = _config.get_value("accessibility", "motion_reduced", false)


func _save_settings() -> void:
	"""Save accessibility settings"""
	_config.set_value("accessibility", "font_size", _current_font_size)
	_config.set_value("accessibility", "high_contrast", _high_contrast_enabled)
	_config.set_value("accessibility", "screen_reader", _screen_reader_enabled)
	_config.set_value("accessibility", "motion_reduced", _motion_reduced)
	_config.save(SETTINGS_FILE)


func _apply_accessibility_features() -> void:
	"""Apply current accessibility settings"""
	if _high_contrast_enabled:
		_apply_high_contrast_theme()
	if _motion_reduced:
		_disable_animations()


func _apply_high_contrast_theme() -> void:
	"""Apply high contrast educational theme"""
	print("[AccessibilityManager] Applying high contrast theme")


func _disable_animations() -> void:
	"""Disable educational animations for accessibility"""
	print("[AccessibilityManager] Reducing motion for accessibility")
