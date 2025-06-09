## AccessibilityHelper.gd
## Utility class for UI accessibility features
## Provides helper functions and constants for accessibility compliance
##
## @version: 2.0

class_name AccessibilityHelper
extends RefCounted

# === ENUMS ===
enum AnnouncementPriority { LOW, MEDIUM, HIGH, URGENT }

# === CONSTANTS ===
const MIN_FONT_SIZE: float = 12.0
const MAX_FONT_SIZE: float = 24.0
const DEFAULT_FONT_SIZE: float = 16.0

const WCAG_CONTRAST_RATIOS = {
	"AA_normal": 4.5, "AA_large": 3.0, "AAA_normal": 7.0, "AAA_large": 4.5
}

const TOUCH_TARGET_SIZES = {"minimum": 44, "recommended": 48, "comfortable": 56}

# === STATIC VARIABLES ===
static var accessibility_enabled: bool = true
static var screen_reader_enabled: bool = false
static var keyboard_navigation_enabled: bool = true
static var high_contrast_mode: bool = false
static var reduced_motion: bool = false
static var font_size_scale: float = 1.0
static var focus_indicators_enhanced: bool = true

# === ACCESSIBILITY HELPER FUNCTIONS ===


## Calculate contrast ratio between two colors
static func calculate_contrast_ratio(color1: Color, color2: Color) -> float:
	var l1 = _get_relative_luminance(color1)
	var l2 = _get_relative_luminance(color2)

	var lighter = max(l1, l2)
	var darker = min(l1, l2)

	return (lighter + 0.05) / (darker + 0.05)


## Check if contrast ratio meets WCAG standards
static func meets_wcag_contrast(color1: Color, color2: Color, level: String = "AA_normal") -> bool:
	var ratio = calculate_contrast_ratio(color1, color2)
	return ratio >= WCAG_CONTRAST_RATIOS.get(level, 4.5)


## Get appropriate font size based on scale
static func get_scaled_font_size(base_size: float) -> float:
	return clamp(base_size * font_size_scale, MIN_FONT_SIZE, MAX_FONT_SIZE)


## Check if touch target meets minimum size requirements
static func meets_touch_target_size(size: Vector2, level: String = "minimum") -> bool:
	var min_size = TOUCH_TARGET_SIZES.get(level, 44)
	return size.x >= min_size and size.y >= min_size


## Apply accessibility styling to a control
static func apply_accessibility_styling(control: Control) -> void:
	if not control:
		return

	# Enhanced focus indicators
	if focus_indicators_enhanced:
		control.focus_mode = Control.FOCUS_ALL

	# High contrast mode adjustments
	if high_contrast_mode:
		_apply_high_contrast_styling(control)


## Private helper functions
static func _get_relative_luminance(color: Color) -> float:
	var r = _gamma_correct(color.r)
	var g = _gamma_correct(color.g)
	var b = _gamma_correct(color.b)

	return 0.2126 * r + 0.7152 * g + 0.0722 * b


static func _gamma_correct(value: float) -> float:
	if value <= 0.03928:
		return value / 12.92
	else:
		return pow((value + 0.055) / 1.055, 2.4)


static func _apply_high_contrast_styling(control: Control) -> void:
	# Apply high contrast colors
	if control.has_method("add_theme_color_override"):
		control.add_theme_color_override("font_color", Color.WHITE)
		control.add_theme_color_override("font_color_hover", Color.YELLOW)
