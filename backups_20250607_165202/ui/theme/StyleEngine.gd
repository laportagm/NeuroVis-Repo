## StyleEngine.gd
## Centralized style management system for NeuroVis educational platform
##
## Provides unified theme management, responsive design, animation coordination,
## and educational accessibility features across all UI components.
##
## @tutorial: Educational styling patterns
## @version: 3.0

class_name StyleEngine
extends RefCounted

# === DEPENDENCIES ===

enum ThemeMode { ENHANCED, MINIMAL, HIGH_CONTRAST, CUSTOM }  # Student-friendly, engaging, gamified  # Clinical, professional, clean  # Accessibility-focused  # User-defined customizations

enum InteractionMode { EDUCATIONAL, CLINICAL, ACCESSIBILITY, ADVANCED }  # Learning-focused interactions  # Professional workflow  # Accessible input methods  # Power user features

# === STATIC STATE ===
static var _current_theme: ThemeMode = ThemeMode.ENHANCED
static var _current_interaction_mode: InteractionMode = InteractionMode.EDUCATIONAL
static var _responsive_scale: float = 1.0
static var _animation_enabled: bool = true
static var _accessibility_enabled: bool = false
static var _style_cache: Dictionary = {}
static var _component_styles: Dictionary = {}

# === INITIALIZATION ===
static var _initialized: bool = false


static func _ensure_initialized() -> void:
	if not _initialized:
		_load_style_configuration()
		_setup_responsive_system()
		_initialize_animation_system()
		_initialized = true
		print("[StyleEngine] Initialized with theme: %s" % ThemeMode.keys()[_current_theme])


static func _load_style_configuration() -> void:
	"""Load style configuration from feature flags and user preferences"""

	# Check theme preference from feature flags
	if FeatureFlags.is_enabled(FeatureFlags.UI_MINIMAL_THEME):
		_current_theme = ThemeMode.MINIMAL
	else:
		_current_theme = ThemeMode.ENHANCED

	# Check accessibility features
	if FeatureFlags.is_enabled(FeatureFlags.UI_ACCESSIBILITY_MODE):
		_accessibility_enabled = true
		_current_theme = ThemeMode.HIGH_CONTRAST

	# Animation preferences
	_animation_enabled = FeatureFlags.is_enabled(FeatureFlags.UI_SMOOTH_ANIMATIONS)


static func _setup_responsive_system() -> void:
	"""Setup responsive design system"""

const FeatureFlags = preprepreload("res://core/features/FeatureFlags.gd")

# === STYLE CONSTANTS ===
const EDUCATIONAL_COLORS = {
	"primary": Color(0.2, 0.6, 1.0),  # Learning blue
	"secondary": Color(0.4, 0.8, 0.6),  # Success green
	"accent": Color(1.0, 0.6, 0.2),  # Attention orange
	"neutral": Color(0.5, 0.5, 0.5),  # Gray
	"background": Color(0.1, 0.1, 0.15),  # Dark background
	"surface": Color(0.15, 0.15, 0.2),  # Surface
	"text_primary": Color(0.95, 0.95, 0.95),  # Light text
	"text_secondary": Color(0.8, 0.8, 0.8)  # Secondary text
}

const CLINICAL_COLORS = {
	"primary": Color(0.3, 0.3, 0.4),  # Professional gray
	"secondary": Color(0.2, 0.4, 0.6),  # Medical blue
	"accent": Color(0.6, 0.2, 0.2),  # Alert red
	"neutral": Color(0.4, 0.4, 0.4),  # Neutral gray
	"background": Color(0.98, 0.98, 0.99),  # Clean white
	"surface": Color(0.95, 0.95, 0.96),  # Surface white
	"text_primary": Color(0.1, 0.1, 0.1),  # Dark text
	"text_secondary": Color(0.4, 0.4, 0.4)  # Secondary dark
}

const ANIMATION_DURATIONS = {
	"micro": 0.1, "short": 0.2, "medium": 0.4, "long": 0.8, "educational": 1.2  # Button hover, quick feedback  # Panel slide, fade in/out  # Panel transitions, theme switching  # Complex animations, scene transitions  # Learning-focused slower animations
}

const RESPONSIVE_BREAKPOINTS = {"mobile": 768, "tablet": 1024, "desktop": 1440, "ultrawide": 2560}

# === THEME SYSTEM ===

	var viewport_size = DisplayServer.screen_get_size()
	var width = viewport_size.x

	# Calculate responsive scale based on screen size
	if width <= RESPONSIVE_BREAKPOINTS.mobile:
		_responsive_scale = 0.8
	elif width <= RESPONSIVE_BREAKPOINTS.tablet:
		_responsive_scale = 0.9
	elif width <= RESPONSIVE_BREAKPOINTS.desktop:
		_responsive_scale = 1.0
	else:
		_responsive_scale = 1.1

	print(
		(
			"[StyleEngine] Responsive scale: %.1f (screen: %dx%d)"
			% [_responsive_scale, width, viewport_size.y]
		)
	)


static func _initialize_animation_system() -> void:
	"""Initialize animation coordination system"""
	_style_cache.clear()
	print("[StyleEngine] Animation system initialized (enabled: %s)" % _animation_enabled)


# === PUBLIC THEME API ===
static func set_theme_mode(mode: ThemeMode) -> void:
	"""Set the global theme mode"""
	_ensure_initialized()

	if _current_theme != mode:
		var old_theme = _current_theme
		_current_theme = mode
		_style_cache.clear()  # Clear cache when theme changes

		print(
			(
				"[StyleEngine] Theme changed: %s → %s"
				% [ThemeMode.keys()[old_theme], ThemeMode.keys()[mode]]
			)
		)

		# Notify components of theme change
		_broadcast_theme_change()


static func get_theme_mode() -> ThemeMode:
	"""Get current theme mode"""
	_ensure_initialized()
	return _current_theme


static func set_interaction_mode(mode: InteractionMode) -> void:
	"""Set the global interaction mode"""
	_ensure_initialized()
	_current_interaction_mode = mode
	print("[StyleEngine] Interaction mode: %s" % InteractionMode.keys()[mode])


static func get_interaction_mode() -> InteractionMode:
	"""Get current interaction mode"""
	_ensure_initialized()
	return _current_interaction_mode


# === COLOR SYSTEM ===
static func get_color(color_name: String) -> Color:
	"""Get color for current theme"""
	_ensure_initialized()

	var cache_key = "color_%s_%s" % [color_name, _current_theme]
	if _style_cache.has(cache_key):
		return _style_cache[cache_key]

	var color: Color

	match _current_theme:
		ThemeMode.ENHANCED:
			color = EDUCATIONAL_COLORS.get(color_name, Color.MAGENTA)
		ThemeMode.MINIMAL:
			color = CLINICAL_COLORS.get(color_name, Color.MAGENTA)
		ThemeMode.HIGH_CONTRAST:
			color = _get_high_contrast_color(color_name)
		_:
			color = EDUCATIONAL_COLORS.get(color_name, Color.MAGENTA)

	_style_cache[cache_key] = color
	return color


static func _get_high_contrast_color(color_name: String) -> Color:
	"""Get high contrast color for accessibility"""
	var contrast_colors = {
		"primary": Color.WHITE,
		"secondary": Color.BLACK,
		"accent": Color.YELLOW,
		"background": Color.BLACK,
		"surface": Color(0.1, 0.1, 0.1),
		"text_primary": Color.WHITE,
		"text_secondary": Color(0.8, 0.8, 0.8)
	}
	return contrast_colors.get(color_name, Color.WHITE)


static func get_color_palette() -> Dictionary:
	"""Get complete color palette for current theme"""
	_ensure_initialized()

	var palette = {}
	var source = EDUCATIONAL_COLORS if _current_theme == ThemeMode.ENHANCED else CLINICAL_COLORS

	for color_name in source.keys():
		palette[color_name] = get_color(color_name)

	return palette


# === RESPONSIVE DESIGN ===
static func get_responsive_size(base_size: Vector2) -> Vector2:
	"""Get responsive size based on screen scale"""
	_ensure_initialized()
	return base_size * _responsive_scale


static func get_responsive_scale() -> float:
	"""Get current responsive scale factor"""
	_ensure_initialized()
	return _responsive_scale


static func get_font_size(size_category: String) -> int:
	"""Get responsive font size"""
	_ensure_initialized()

	var base_sizes = {"small": 12, "body": 14, "title": 18, "heading": 24, "display": 32}

	var base_size = base_sizes.get(size_category, 14)
	return int(base_size * _responsive_scale)


static func is_mobile_layout() -> bool:
	"""Check if mobile layout should be used"""
	var screen_width = DisplayServer.screen_get_size().x
	return screen_width <= RESPONSIVE_BREAKPOINTS.mobile


static func is_tablet_layout() -> bool:
	"""Check if tablet layout should be used"""
	var screen_width = DisplayServer.screen_get_size().x
	return (
		screen_width <= RESPONSIVE_BREAKPOINTS.tablet
		and screen_width > RESPONSIVE_BREAKPOINTS.mobile
	)


# === ANIMATION SYSTEM ===
static func get_animation_duration(duration_type: String) -> float:
	"""Get animation duration for current settings"""
	_ensure_initialized()

	if not _animation_enabled:
		return 0.0

	var base_duration = ANIMATION_DURATIONS.get(duration_type, 0.2)

	# Adjust for accessibility
	if _accessibility_enabled:
		base_duration *= 0.5  # Faster animations for accessibility

	return base_duration


static func create_fade_transition(
	control: Control, fade_in: bool = true, duration: float = -1.0
) -> Tween:
	"""Create fade transition animation"""
	_ensure_initialized()

	if duration < 0:
		duration = get_animation_duration("short")

	var tween = control.create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)

	if fade_in:
		control.modulate.a = 0.0
		tween.tween_property(control, "modulate:a", 1.0, duration)
	else:
		tween.tween_property(control, "modulate:a", 0.0, duration)

	return tween


static func create_slide_transition(
	control: Control, from_pos: Vector2, to_pos: Vector2, duration: float = -1.0
) -> Tween:
	"""Create slide transition animation"""
	_ensure_initialized()

	if duration < 0:
		duration = get_animation_duration("medium")

	control.position = from_pos

	var tween = control.create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(control, "position", to_pos, duration)

	return tween


static func create_scale_animation(
	control: Control, from_scale: Vector2, to_scale: Vector2, duration: float = -1.0
) -> Tween:
	"""Create scale animation"""
	_ensure_initialized()

	if duration < 0:
		duration = get_animation_duration("short")

	control.scale = from_scale

	var tween = control.create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(control, "scale", to_scale, duration)

	return tween


# === COMPONENT STYLING ===
static func apply_component_style(component: Control, style_config: Dictionary) -> void:
	"""Apply unified styling to a component"""
	_ensure_initialized()

	var component_type = style_config.get("type", "generic")
	var theme_variant = style_config.get("variant", "default")

	# Cache key for this style combination
	var cache_key = "style_%s_%s_%s" % [component_type, theme_variant, _current_theme]

	if _component_styles.has(cache_key):
		_apply_cached_style(component, _component_styles[cache_key])
		return

	# Generate new style
	var computed_style = _compute_component_style(component_type, theme_variant, style_config)
	_component_styles[cache_key] = computed_style
	_apply_cached_style(component, computed_style)


static func _compute_component_style(
	component_type: String, variant: String, config: Dictionary
) -> Dictionary:
	"""Compute styling for a component type"""
	var style = {}

	match component_type:
		"panel":
			style = _compute_panel_style(variant, config)
		"button":
			style = _compute_button_style(variant, config)
		"label":
			style = _compute_label_style(variant, config)
		"header":
			style = _compute_header_style(variant, config)
		_:
			style = _compute_generic_style(variant, config)

	return style


static func _compute_panel_style(variant: String, config: Dictionary) -> Dictionary:
	"""Compute panel styling"""
	var style = {
		"background_color": get_color("surface"),
		"border_color": get_color("primary"),
		"border_width": 2 if _current_theme == ThemeMode.ENHANCED else 1,
		"corner_radius": 12 if _current_theme == ThemeMode.ENHANCED else 4,
		"shadow_enabled": _current_theme == ThemeMode.ENHANCED,
		"padding": get_responsive_size(Vector2(16, 16))
	}

	match variant:
		"primary":
			style.background_color = get_color("primary").lerp(get_color("surface"), 0.9)
		"secondary":
			style.background_color = get_color("secondary").lerp(get_color("surface"), 0.9)
		"educational":
			style.border_color = get_color("accent")
			style.corner_radius = 16

	return style


static func _compute_button_style(variant: String, config: Dictionary) -> Dictionary:
	"""Compute button styling"""
	var style = {
		"background_color": get_color("primary"),
		"text_color": get_color("text_primary"),
		"hover_color": get_color("primary").lightened(0.2),
		"pressed_color": get_color("primary").darkened(0.2),
		"border_width": 0,
		"corner_radius": 8,
		"font_size": get_font_size("body"),
		"padding": get_responsive_size(Vector2(12, 8))
	}

	match variant:
		"secondary":
			style.background_color = get_color("secondary")
		"accent":
			style.background_color = get_color("accent")
		"ghost":
			style.background_color = Color.TRANSPARENT
			style.border_width = 2
			style.text_color = get_color("primary")

	return style


static func _compute_label_style(variant: String, config: Dictionary) -> Dictionary:
	"""Compute label styling"""
	var style = {
		"text_color": get_color("text_primary"),
		"font_size": get_font_size("body"),
		"line_spacing": 1.2
	}

	match variant:
		"title":
			style.font_size = get_font_size("title")
			style.text_color = get_color("primary")
		"heading":
			style.font_size = get_font_size("heading")
		"secondary":
			style.text_color = get_color("text_secondary")

	return style


static func _compute_header_style(variant: String, config: Dictionary) -> Dictionary:
	"""Compute header styling"""
	var style = {
		"background_color": get_color("primary"),
		"text_color": get_color("text_primary"),
		"font_size": get_font_size("title"),
		"height": get_responsive_size(Vector2(0, 48)).y,
		"padding": get_responsive_size(Vector2(16, 12))
	}

	return style


static func _compute_generic_style(variant: String, config: Dictionary) -> Dictionary:
	"""Compute generic component styling"""
	return {
		"background_color": get_color("surface"),
		"text_color": get_color("text_primary"),
		"border_color": get_color("neutral"),
		"padding": get_responsive_size(Vector2(8, 8))
	}


static func _apply_cached_style(component: Control, style: Dictionary) -> void:
	"""Apply cached style to component"""
	for property in style.keys():
		_apply_style_property(component, property, style[property])


static func _apply_style_property(component: Control, property: String, value) -> void:
	"""Apply individual style property"""
	match property:
		"background_color":
			if component.has_method("add_theme_color_override"):
				component.add_theme_color_override("bg_color", value)
		"text_color":
			if component.has_method("add_theme_color_override"):
				component.add_theme_color_override("font_color", value)
		"font_size":
			if component.has_method("add_theme_font_size_override"):
				component.add_theme_font_size_override("font_size", value)
		"padding":
			if component.has_method("add_theme_constant_override"):
				component.add_theme_constant_override("margin_left", value.x)
				component.add_theme_constant_override("margin_right", value.x)
				component.add_theme_constant_override("margin_top", value.y)
				component.add_theme_constant_override("margin_bottom", value.y)


# === ACCESSIBILITY ===
static func enable_accessibility_mode(enabled: bool) -> void:
	"""Enable/disable accessibility mode"""
	_ensure_initialized()
	_accessibility_enabled = enabled

	if enabled:
		_current_theme = ThemeMode.HIGH_CONTRAST
		_animation_enabled = false

	_style_cache.clear()
	print("[StyleEngine] Accessibility mode: %s" % enabled)


static func is_accessibility_enabled() -> bool:
	"""Check if accessibility mode is enabled"""
	_ensure_initialized()
	return _accessibility_enabled


# === UTILITY METHODS ===
static func _broadcast_theme_change() -> void:
	"""Broadcast theme change to listening components"""
	# This would notify all registered components about theme changes
	# For now, we'll use a simple signal system when needed
	print("[StyleEngine] Broadcasting theme change to components")


static func clear_style_cache() -> void:
	"""Clear all cached styles (useful for theme switching)"""
	_style_cache.clear()
	_component_styles.clear()
	print("[StyleEngine] Style cache cleared")


static func get_style_stats() -> Dictionary:
	"""Get style engine statistics"""
	return {
		"theme_mode": ThemeMode.keys()[_current_theme],
		"interaction_mode": InteractionMode.keys()[_current_interaction_mode],
		"responsive_scale": _responsive_scale,
		"animation_enabled": _animation_enabled,
		"accessibility_enabled": _accessibility_enabled,
		"cached_styles": _style_cache.size(),
		"component_styles": _component_styles.size()
	}


static func print_style_stats() -> void:
	"""Print style engine statistics"""
	var stats = get_style_stats()
	print("\n=== STYLE ENGINE STATS ===")
	print("Theme: %s" % stats.theme_mode)
	print("Interaction: %s" % stats.interaction_mode)
	print("Scale: %.1f" % stats.responsive_scale)
	print("Animation: %s" % stats.animation_enabled)
	print("Accessibility: %s" % stats.accessibility_enabled)
	print("Cache entries: %d" % stats.cached_styles)
	print("Component styles: %d" % stats.component_styles)
	print("========================\n")
