## AccessibilityManager.gd
## Manages accessibility settings for the educational platform
##
## This singleton handles colorblind modes, motion preferences, contrast settings,
## and other accessibility features to ensure the platform is usable by all students.
##
## @tutorial: Accessibility in Educational Software
## @version: 1.0

extends Node

# === SIGNALS ===

signal colorblind_mode_changed(mode: String)
signal reduce_motion_changed(enabled: bool)
signal high_contrast_changed(enabled: bool)
signal font_size_changed(size: float)
signal settings_changed

# === CONSTANTS ===

const SETTINGS_FILE: String = "user://accessibility_settings.cfg"

const COLORBLIND_MODES: Array[String] = [
"none", "deuteranope", "protanope", "tritanope", "monochrome"  # Red-green (most common, ~6% of males)  # Red-green (~2% of males)  # Blue-yellow (rare, ~0.01%)  # Complete color blindness
]

const MIN_FONT_SIZE: float = 14.0
const MAX_FONT_SIZE: float = 32.0
const DEFAULT_FONT_SIZE: float = 18.0

# === CONFIGURATION ===

var colorblind_mode: String = "none"
var reduce_motion: bool = false
var high_contrast: bool = false
var enhanced_outlines: bool = false
var font_size: float = DEFAULT_FONT_SIZE
var use_dyslexic_font: bool = false
var keyboard_navigation: bool = true
var screen_reader_hints: bool = true
var auto_pause_animations: bool = false

# === PRIVATE VARIABLES ===
var l1 = _get_relative_luminance(foreground)
var l2 = _get_relative_luminance(background)

var lighter = max(l1, l2)
var darker = min(l1, l2)

var colors = {
	"primary": Color("#00D9FF"),
	"secondary": Color("#FFD700"),
	"success": Color("#06FFA5"),
	"warning": Color("#FFB86C"),
	"error": Color("#FF4757"),
	"text": Color("#FFFFFF"),
	"background": Color("#0A0A0A")
	}

	# Apply colorblind conversions
var color = colors[key]
	color.s = min(color.s * 1.3, 1.0)
	color.v = min(color.v * 1.2, 1.0)
	colors[key] = color

var err = _config.load(SETTINGS_FILE)
var r = _srgb_to_linear(color.r)
var g = _srgb_to_linear(color.g)
var b = _srgb_to_linear(color.b)

# Calculate luminance
var r = color.r
var g = color.g
var b = color.b

# Matrix transformation for deuteranope
var new_r = 0.625 * r + 0.375 * g
var new_g = 0.7 * r + 0.3 * g
var new_b = 0.0 * r + 0.3 * g + 0.7 * b

var r = color.r
var g = color.g
var b = color.b

# Matrix transformation for protanope
var new_r = 0.567 * r + 0.433 * g
var new_g = 0.558 * r + 0.442 * g
var new_b = 0.0 * r + 0.242 * g + 0.758 * b

var r = color.r
var g = color.g
var b = color.b

# Matrix transformation for tritanope
var new_r = 0.95 * r + 0.05 * g
var new_g = 0.0 * r + 0.433 * g + 0.567 * b
var new_b = 0.0 * r + 0.475 * g + 0.525 * b

var gray = 0.299 * color.r + 0.587 * color.g + 0.114 * color.b
var colors = get_recommended_colors()
var bg = colors["background"]

var ratio = check_contrast_ratio(colors[key], bg)
var rating = "FAIL"

var _config: ConfigFile


# === INITIALIZATION ===

func _ready() -> void:
	"""Initialize accessibility manager"""
	_config = ConfigFile.new()
	load_settings()

	# Set process priority high for accessibility
	process_priority = -100

	print("[Accessibility] Manager initialized with mode: %s" % colorblind_mode)


	# === PUBLIC METHODS ===
	## Set colorblind mode

func set_colorblind_mode(mode: String) -> void:
	"""Change colorblind mode and notify systems"""
	if mode in COLORBLIND_MODES:
		colorblind_mode = mode
		colorblind_mode_changed.emit(mode)
		settings_changed.emit()
		save_settings()


		## Toggle reduce motion preference
func set_reduce_motion(enabled: bool) -> void:
	"""Enable/disable motion reduction"""
	reduce_motion = enabled
	reduce_motion_changed.emit(enabled)
	settings_changed.emit()
	save_settings()


	## Toggle high contrast mode
func set_high_contrast(enabled: bool) -> void:
	"""Enable/disable high contrast mode"""
	high_contrast = enabled
	high_contrast_changed.emit(enabled)
	settings_changed.emit()
	save_settings()


	## Set font size
func set_font_size(size: float) -> void:
	"""Set UI font size"""
	font_size = clamp(size, MIN_FONT_SIZE, MAX_FONT_SIZE)
	font_size_changed.emit(font_size)
	settings_changed.emit()
	save_settings()


	## Get colorblind-safe color
func get_safe_color(original_color: Color, _color_type: String = "default") -> Color:
	"""Convert color to colorblind-safe equivalent"""
	match colorblind_mode:
		"deuteranope":
			return _convert_deuteranope(original_color)
			"protanope":
				return _convert_protanope(original_color)
				"tritanope":
					return _convert_tritanope(original_color)
					"monochrome":
						return _convert_monochrome(original_color)
						_:
							return original_color


							## Check if a color pair has sufficient contrast
func check_contrast_ratio(foreground: Color, background: Color) -> float:
	"""Calculate WCAG contrast ratio between two colors"""
func get_recommended_colors() -> Dictionary:
	"""Get color palette optimized for current accessibility settings"""
func load_settings() -> void:
	"""Load settings from file"""
func save_settings() -> void:
	"""Save settings to file"""
	_config.set_value("accessibility", "colorblind_mode", colorblind_mode)
	_config.set_value("accessibility", "reduce_motion", reduce_motion)
	_config.set_value("accessibility", "high_contrast", high_contrast)
	_config.set_value("accessibility", "enhanced_outlines", enhanced_outlines)
	_config.set_value("accessibility", "font_size", font_size)
	_config.set_value("accessibility", "use_dyslexic_font", use_dyslexic_font)
	_config.set_value("accessibility", "keyboard_navigation", keyboard_navigation)
	_config.set_value("accessibility", "screen_reader_hints", screen_reader_hints)
	_config.set_value("accessibility", "auto_pause_animations", auto_pause_animations)

	_config.save(SETTINGS_FILE)


	## Get all current settings
func get_settings() -> Dictionary:
	"""Return all accessibility settings"""
	return {
	"colorblind_mode": colorblind_mode,
	"reduce_motion": reduce_motion,
	"high_contrast": high_contrast,
	"enhanced_outlines": enhanced_outlines,
	"font_size": font_size,
	"use_dyslexic_font": use_dyslexic_font,
	"keyboard_navigation": keyboard_navigation,
	"screen_reader_hints": screen_reader_hints,
	"auto_pause_animations": auto_pause_animations
	}


	# === PRIVATE METHODS ===
func print_contrast_report() -> void:
	"""Print contrast ratio report for current color scheme"""

func _fix_orphaned_code():
	return (lighter + 0.05) / (darker + 0.05)


	## Get recommended colors for current settings
func _fix_orphaned_code():
	for key in colors:
		colors[key] = get_safe_color(colors[key], key)

		# Apply high contrast modifications
		if high_contrast:
			colors["text"] = Color.WHITE
			colors["background"] = Color.BLACK

			# Increase saturation and brightness
			for key in ["primary", "secondary", "success", "warning", "error"]:
func _fix_orphaned_code():
	return colors


	## Load accessibility settings
func _fix_orphaned_code():
	if err != OK:
		# Use defaults
		save_settings()
		return

		# Load values
		colorblind_mode = _config.get_value("accessibility", "colorblind_mode", "none")
		reduce_motion = _config.get_value("accessibility", "reduce_motion", false)
		high_contrast = _config.get_value("accessibility", "high_contrast", false)
		enhanced_outlines = _config.get_value("accessibility", "enhanced_outlines", false)
		font_size = _config.get_value("accessibility", "font_size", DEFAULT_FONT_SIZE)
		use_dyslexic_font = _config.get_value("accessibility", "use_dyslexic_font", false)
		keyboard_navigation = _config.get_value("accessibility", "keyboard_navigation", true)
		screen_reader_hints = _config.get_value("accessibility", "screen_reader_hints", true)
		auto_pause_animations = _config.get_value("accessibility", "auto_pause_animations", false)


		## Save accessibility settings
func _fix_orphaned_code():
	return 0.2126 * r + 0.7152 * g + 0.0722 * b


func _fix_orphaned_code():
	return Color(new_r, new_g, new_b, color.a)


func _fix_orphaned_code():
	return Color(new_r, new_g, new_b, color.a)


func _fix_orphaned_code():
	return Color(new_r, new_g, new_b, color.a)


func _fix_orphaned_code():
	return Color(gray, gray, gray, color.a)


	# === DEBUG METHODS ===
func _fix_orphaned_code():
	print("\n=== Accessibility Contrast Report ===")
	print("Mode: %s | High Contrast: %s" % [colorblind_mode, high_contrast])
	print("Background: %s" % bg.to_html())
	print("\nContrast Ratios (WCAG AA = 4.5:1, AAA = 7:1):")

	for key in colors:
		if key != "background":
func _fix_orphaned_code():
	if ratio >= 7.0:
		rating = "AAA"
		elif ratio >= 4.5:
			rating = "AA"

			print("  %s: %.2f:1 [%s]" % [key.capitalize(), ratio, rating])

			print("=====================================\n")

func _get_relative_luminance(color: Color) -> float:
	"""Calculate relative luminance for WCAG contrast"""
	# Convert to linear RGB
func _srgb_to_linear(value: float) -> float:
	"""Convert sRGB to linear RGB"""
	if value <= 0.04045:
		return value / 12.92
		else:
			return pow((value + 0.055) / 1.055, 2.4)


func _convert_deuteranope(color: Color) -> Color:
	"""Convert color for deuteranope (red-green) colorblindness"""
	# Simplified deuteranope simulation
func _convert_protanope(color: Color) -> Color:
	"""Convert color for protanope (red-green) colorblindness"""
func _convert_tritanope(color: Color) -> Color:
	"""Convert color for tritanope (blue-yellow) colorblindness"""
func _convert_monochrome(color: Color) -> Color:
	"""Convert color to grayscale"""
