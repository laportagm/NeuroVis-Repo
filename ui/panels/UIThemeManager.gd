extends Node

## UI Theme Manager for Educational Interfaces
## Manages Enhanced and Minimal themes for different learning contexts
## @version: 2.0

# === ENUMS ===
enum ThemeMode { ENHANCED, MINIMAL }  # Gaming/engaging style for students  # Professional/clinical style

# === SIGNALS ===
signal theme_changed(new_theme: ThemeMode)

# === VARIABLES ===
var current_theme: ThemeMode = ThemeMode.ENHANCED
var _is_initialized: bool = false


# === LIFECYCLE ===
func _ready() -> void:
	"""Initialize theme manager"""
	_initialize_themes()


# === PUBLIC METHODS ===
func set_theme_mode(mode: ThemeMode) -> void:
	"""Set the active theme mode"""
	if current_theme != mode:
		current_theme = mode
		_apply_theme()
		theme_changed.emit(mode)
		print("[UIThemeManager] Theme changed to: " + _get_theme_name(mode))


func get_current_theme() -> ThemeMode:
	"""Get the current theme mode"""
	return current_theme


func is_enhanced_mode() -> bool:
	"""Check if currently in enhanced mode"""
	return current_theme == ThemeMode.ENHANCED


func is_minimal_mode() -> bool:
	"""Check if currently in minimal mode"""
	return current_theme == ThemeMode.MINIMAL


# === PRIVATE METHODS ===
func _initialize_themes() -> void:
	"""Initialize the theme system"""
	print("[UIThemeManager] Initializing theme system...")
	_apply_theme()
	_is_initialized = true
	print("[UIThemeManager] Theme system ready")


func _apply_theme() -> void:
	"""Apply the current theme to UI elements"""
	match current_theme:
		ThemeMode.ENHANCED:
			_apply_enhanced_theme()
		ThemeMode.MINIMAL:
			_apply_minimal_theme()


func _apply_enhanced_theme() -> void:
	"""Apply enhanced theme styling"""
	print("[UIThemeManager] Applying enhanced theme")
	# Enhanced theme implementation


func _apply_minimal_theme() -> void:
	"""Apply minimal theme styling"""
	print("[UIThemeManager] Applying minimal theme")
	# Minimal theme implementation


func _get_theme_name(mode: ThemeMode) -> String:
	"""Get theme name for logging"""
	match mode:
		ThemeMode.ENHANCED:
			return "Enhanced"
		ThemeMode.MINIMAL:
			return "Minimal"
		_:
			return "Unknown"


# === ACCESSIBILITY INTEGRATION ===
func apply_contrast_mode(mode_name: String) -> void:
	"""Apply contrast mode for accessibility"""
	print("[UIThemeManager] Applying contrast mode: %s" % mode_name)

	# Get all UI elements that need contrast adjustment
	var all_controls = get_tree().get_nodes_in_group("accessible_ui")

	match mode_name.to_lower():
		"high contrast":
			_apply_high_contrast(all_controls)
		"inverted":
			_apply_inverted_contrast(all_controls)
		"normal":
			_apply_normal_contrast(all_controls)


func _apply_high_contrast(controls: Array) -> void:
	"""Apply high contrast colors to controls"""
	for control in controls:
		if control is Control:
			# Text colors
			if control.has_theme_color("font_color"):
				control.add_theme_color_override("font_color", Color.WHITE)

			# Background colors
			if control is PanelContainer or control is Panel:
				var style = StyleBoxFlat.new()
				style.bg_color = Color.BLACK
				style.border_color = Color.WHITE
				style.set_border_width_all(2)
				control.add_theme_stylebox_override("panel", style)

			# Button styles
			if control is Button:
				var normal_style = StyleBoxFlat.new()
				normal_style.bg_color = Color.BLACK
				normal_style.border_color = Color.WHITE
				normal_style.set_border_width_all(2)
				control.add_theme_stylebox_override("normal", normal_style)

				var hover_style = StyleBoxFlat.new()
				hover_style.bg_color = Color(0.2, 0.2, 0.2)
				hover_style.border_color = Color.YELLOW
				hover_style.set_border_width_all(3)
				control.add_theme_stylebox_override("hover", hover_style)


func _apply_inverted_contrast(controls: Array) -> void:
	"""Apply inverted colors to controls"""
	for control in controls:
		if control is Control:
			# Get current colors and invert them
			if control.has_theme_color("font_color"):
				var current = control.get_theme_color("font_color")
				var inverted = Color(1.0 - current.r, 1.0 - current.g, 1.0 - current.b, current.a)
				control.add_theme_color_override("font_color", inverted)


func _apply_normal_contrast(controls: Array) -> void:
	"""Reset to normal contrast"""
	for control in controls:
		if control is Control:
			# Remove overrides to restore defaults
			control.remove_theme_color_override("font_color")
			control.remove_theme_stylebox_override("panel")
			control.remove_theme_stylebox_override("normal")
			control.remove_theme_stylebox_override("hover")


# === MOTION REDUCTION ===
func get_animation_duration(animation_type: String) -> float:
	"""Get animation duration based on accessibility settings"""
	var accessibility = get_node_or_null("/root/AccessibilityManager")
	if accessibility and accessibility.is_motion_reduced():
		return 0.0  # No animation

	# Default durations
	match animation_type:
		"entrance":
			return 0.3
		"exit":
			return 0.2
		"transition":
			return 0.4
		"content_fade_duration":
			return 0.2
		"exit_duration":
			return 0.2
		_:
			return 0.3


func animate_enhanced_entrance(control: Control, delay: float = 0.0) -> void:
	"""Animate control entrance with accessibility awareness"""
	var accessibility = get_node_or_null("/root/AccessibilityManager")
	if accessibility and accessibility.is_motion_reduced():
		# No animation, just show
		control.modulate.a = 1.0
		control.visible = true
		return

	# Normal animation
	control.modulate.a = 0.0
	control.visible = true

	var tween = control.create_tween()
	if delay > 0:
		tween.tween_interval(delay)
	tween.tween_property(control, "modulate:a", 1.0, get_animation_duration("entrance"))


func animate_exit(control: Control, duration: float) -> void:
	"""Animate control exit with accessibility awareness"""
	var accessibility = get_node_or_null("/root/AccessibilityManager")
	if accessibility and accessibility.is_motion_reduced():
		# No animation, just hide
		control.visible = false
		return

	# Normal animation
	var tween = control.create_tween()
	tween.tween_property(control, "modulate:a", 0.0, duration)
	tween.tween_callback(func(): control.visible = false)


# === FONT SIZE ADJUSTMENT ===
func apply_enhanced_typography(control: Control, style: String) -> void:
	"""Apply typography with accessibility font size"""
	var accessibility = get_node_or_null("/root/AccessibilityManager")
	var base_size = _get_base_font_size(style)

	if accessibility:
		var adjusted_size = accessibility.get_accessible_font_size(base_size)
		control.add_theme_font_size_override("font_size", adjusted_size)
	else:
		control.add_theme_font_size_override("font_size", base_size)


func _get_base_font_size(style: String) -> int:
	"""Get base font size for a typography style"""
	match style:
		"heading":
			return 24
		"subheading":
			return 18
		"body":
			return 14
		"small":
			return 12
		_:
			return 14


# === PANEL STYLING ===
func apply_enhanced_panel_style(panel: PanelContainer, style_type: String) -> void:
	"""Apply enhanced panel styling with accessibility support"""
	var accessibility = get_node_or_null("/root/AccessibilityManager")

	var style = StyleBoxFlat.new()

	# Base styling
	match style_type:
		"default":
			style.bg_color = Color(0.1, 0.1, 0.15, 0.95)
			style.border_color = Color(0.3, 0.6, 0.9, 0.8)
		"settings":
			style.bg_color = Color(0.05, 0.05, 0.1, 0.98)
			style.border_color = Color(0.4, 0.4, 0.6, 0.9)
		_:
			style.bg_color = Color(0.1, 0.1, 0.1, 0.9)
			style.border_color = Color(0.5, 0.5, 0.5, 0.8)

	# Apply accessibility adjustments
	if accessibility:
		match accessibility.get_contrast_mode():
			1:  # HIGH_CONTRAST
				style.bg_color = Color.BLACK
				style.border_color = Color.WHITE
				style.set_border_width_all(3)
			2:  # INVERTED
				style.bg_color = Color(1.0 - style.bg_color.r, 1.0 - style.bg_color.g, 1.0 - style.bg_color.b, style.bg_color.a)
				style.border_color = Color(1.0 - style.border_color.r, 1.0 - style.border_color.g, 1.0 - style.border_color.b, style.border_color.a)

	style.set_border_width_all(2)
	style.set_corner_radius_all(8)
	style.set_expand_margin_all(10)

	panel.add_theme_stylebox_override("panel", style)


# === SPACING HELPERS ===
func get_spacing(size: String) -> int:
	"""Get spacing value for UI layout"""
	match size:
		"xs": return 4
		"sm": return 8
		"md": return 16
		"lg": return 24
		"xl": return 32
		_: return 16


# === HOVER EFFECTS ===
func add_hover_effect(control: Control) -> void:
	"""Add hover effect with accessibility awareness"""
	var accessibility = get_node_or_null("/root/AccessibilityManager")

	if control is Button:
		control.mouse_entered.connect(func():
			if not (accessibility and accessibility.is_motion_reduced()):
				var tween = control.create_tween()
				tween.tween_property(control, "modulate", Color(1.2, 1.2, 1.2), 0.1)
		)

		control.mouse_exited.connect(func():
			if not (accessibility and accessibility.is_motion_reduced()):
				var tween = control.create_tween()
				tween.tween_property(control, "modulate", Color.WHITE, 0.1)
		)
