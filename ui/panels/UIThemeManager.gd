# Modern UI Theme Manager for NeuroVis
# Unified design system based on Figma specifications
extends Node

# === DESIGN SYSTEM ===
# Color palette aligned with Figma specs
const COLORS = {
	# Enhanced glassmorphism palette (from info-panel-design-spec.json)
	"enhanced": {
		"panel_bg": Color(15.0/255, 15.0/255, 23.0/255, 0.85),  # rgba(15, 15, 23, 0.85)
		"border": Color(0, 217.0/255, 1, 0.15),                 # rgba(0, 217, 255, 0.15) 
		"border_hover": Color(0, 217.0/255, 1, 0.3),            # rgba(0, 217, 255, 0.3)
		"text_heading": Color("#00D9FF"),                        # Cyan headings
		"text_subheading": Color("#B0B0C0"),                     # Gray subheadings  
		"text_body": Color("#E8E8E8"),                           # Light body text
		"text_accent": Color("#06FFA5"),                         # Green accent
		"text_muted": Color("#808090"),                          # Muted text
		"button_primary": Color("#00D9FF"),                      # Primary actions
		"button_secondary": Color("#7209B7"),                    # Secondary actions
		"button_danger": Color("#FF073A"),                       # Danger actions
		"hover_bg": Color(0, 217.0/255, 1, 0.1),               # Hover background
		"pressed_bg": Color(0, 217.0/255, 1, 0.2)              # Pressed background
	},
	# Minimal palette (from minimal-design-spec.json)
	"minimal": {
		"panel_bg": Color(1, 1, 1, 0.04),                       # rgba(255, 255, 255, 0.04)
		"border": Color(1, 1, 1, 0.08),                         # rgba(255, 255, 255, 0.08)
		"border_hover": Color(1, 1, 1, 0.1),                    # rgba(255, 255, 255, 0.1)
		"text_primary": Color("#FFFFFF"),                        # White primary
		"text_secondary": Color(1, 1, 1, 0.85),                 # White 85% secondary
		"text_tertiary": Color(1, 1, 1, 0.6),                   # White 60% tertiary
		"text_muted": Color(1, 1, 1, 0.3),                      # White 30% muted
		"interactive_default": Color(1, 1, 1, 0.4),             # White 40% default
		"interactive_hover": Color(1, 1, 1, 0.8),               # White 80% hover
		"interactive_active": Color("#FFFFFF"),                  # White active
		"surface_bg": Color(1, 1, 1, 0.04),                     # Surface background
		"surface_hover": Color(1, 1, 1, 0.06)                   # Surface hover
	}
}

# Typography system from Figma specs
const TYPOGRAPHY = {
	"enhanced": {
		"structure_name": {"size": 24, "weight": "bold", "spacing": -0.5, "line_height": 1.2},
		"section_heading": {"size": 14, "weight": "semibold", "spacing": 0.5, "transform": "uppercase"},
		"body_text": {"size": 14, "weight": "normal", "line_height": 1.6},
		"function_item": {"size": 13, "weight": "normal", "line_height": 1.5}
	},
	"minimal": {
		"display": {"size": 28, "weight": 600, "spacing": -0.02, "line_height": 1.2},
		"body": {"size": 15, "weight": 400, "spacing": 0, "line_height": 1.6},
		"caption": {"size": 13, "weight": 500, "spacing": 0.04, "line_height": 1.4},
		"small": {"size": 14, "weight": 400, "spacing": 0, "line_height": 1.5},
		"micro": {"size": 12, "weight": 400, "spacing": 0, "line_height": 1.4}
	}
}

# Spacing system from minimal design spec
const SPACING = {
	"xs": 4, "sm": 8, "md": 16, "lg": 24, "xl": 32, "xxl": 40, "xxxl": 60,
	"panel_padding": 32, "section_gap": 32, "item_gap": 2, "tag_gap": 8,
	# Enhanced spacing
	"enhanced_panel_padding": 24, "enhanced_section_gap": 20, 
	"enhanced_item_gap": 12, "enhanced_inline_gap": 8
}

# Animation system
const ANIMATION = {
	"instant": 0.0, "fast": 0.2, "normal": 0.3, "slow": 0.5,
	"entrance_duration": 0.4, "exit_duration": 0.2, "hover_duration": 0.15,
	"content_fade_duration": 0.3,
	"easing": {
		"default": "cubic-bezier(0.4, 0, 0.2, 1)",
		"ease_in": "cubic-bezier(0.4, 0, 1, 1)", 
		"ease_out": "cubic-bezier(0, 0, 0.2, 1)",
		"spring": "cubic-bezier(0.34, 1.56, 0.64, 1)"
	}
}

# Effects system
const EFFECTS = {
	"enhanced": {
		"backdrop_blur": 24, "background_opacity": 0.85, "border_opacity": 0.15,
		"shadow_color": Color(0, 0, 0, 0.4), "shadow_blur": 32, "shadow_y": 8,
		"hover_scale": 1.02, "glow_color": Color(0, 217.0/255, 1, 0.2), "glow_size": 8
	},
	"minimal": {
		"backdrop_blur": 40, "blur_saturate": 180, "border_radius": 12,
		"shadow_sm": Color(0, 0, 0, 0.05), "shadow_md": Color(0, 0, 0, 0.1),
		"shadow_lg": Color(0, 0, 0, 0.15)
	}
}

# === LEGACY COMPATIBILITY ===
# Keep existing constants for backward compatibility
const FONT_SIZE_LARGE = 24
const FONT_SIZE_MEDIUM = 16
const FONT_SIZE_SMALL = 12
const FONT_SIZE_TINY = 10
const FONT_SIZE_H = 20
const FONT_SIZE_H2 = 20
const FONT_SIZE_H3 = 18

const ACCENT_BLUE = Color("#00D9FF")
const ACCENT_CYAN = Color("#00D9FF")
const ACCENT_GREEN = Color("#06FFA5")
const ACCENT_ORANGE = Color("#FFB800")
const ACCENT_PINK = Color("#FF006E")
const ACCENT_PURPLE = Color("#7209B7")
const ACCENT_RED = Color("#FF073A")
const ACCENT_TEAL = Color("#00BCD4")
const ACCENT_YELLOW = Color("#FFD700")

const TEXT_PRIMARY = Color("#FFFFFF")
const TEXT_SECONDARY = Color("#B0B0C0")
const TEXT_ACCENT = Color("#00D9FF")
const TEXT_TERTIARY = Color("#808080")
const TEXT_DISABLED = Color("#606060")

const MARGIN_TINY = 4
const MARGIN_SMALL = 8
const MARGIN_MEDIUM = 16
const MARGIN_LARGE = 24
const MARGIN_STANDARD = 16

const ANIM_DURATION_FAST = 0.15
const ANIM_DURATION_STANDARD = 0.25
const ANIM_DURATION_SLOW = 0.4

# === CURRENT THEME ===
enum ThemeMode { ENHANCED, MINIMAL }
static var current_mode: ThemeMode = ThemeMode.ENHANCED

# === STYLE CACHE ===
static var _style_cache: Dictionary = {}
static var _cache_enabled: bool = true
static var _max_cache_size: int = 50

# === THEME GETTERS ===
static func get_current_colors() -> Dictionary:
	match current_mode:
		ThemeMode.MINIMAL: return COLORS.minimal
		_: return COLORS.enhanced

static func get_current_typography() -> Dictionary:
	match current_mode:
		ThemeMode.MINIMAL: return TYPOGRAPHY.minimal
		_: return TYPOGRAPHY.enhanced

static func get_current_effects() -> Dictionary:
	match current_mode:
		ThemeMode.MINIMAL: return EFFECTS.minimal
		_: return EFFECTS.enhanced

# === ENHANCED GLASSMORPHISM STYLING ===
static func create_enhanced_glass_style(opacity_override: float = -1.0) -> StyleBoxFlat:
	# Generate cache key
	var cache_key = "glass_%d_%.2f" % [current_mode, opacity_override]
	
	# Check cache first
	if _cache_enabled and _style_cache.has(cache_key):
		return _style_cache[cache_key].duplicate()
	
	var style = StyleBoxFlat.new()
	var colors = get_current_colors()
	var effects = get_current_effects()
	
	# Background with proper glassmorphism
	style.bg_color = colors.get("panel_bg", COLORS.enhanced.panel_bg)
	if opacity_override > 0:
		style.bg_color.a = opacity_override
	
	# Border styling
	var border_color = colors.get("border", COLORS.enhanced.border)
	style.border_width_left = 1
	style.border_width_right = 1
	style.border_width_top = 1
	style.border_width_bottom = 1
	style.border_color = border_color
	
	# Enhanced corner radius
	var radius = effects.get("border_radius", 12)
	style.corner_radius_top_left = radius
	style.corner_radius_top_right = radius
	style.corner_radius_bottom_left = radius
	style.corner_radius_bottom_right = radius
	
	# Enhanced shadow
	if current_mode == ThemeMode.ENHANCED:
		style.shadow_size = effects.get("shadow_blur", 32) / 2.0  # Godot uses different scale
		style.shadow_color = effects.get("shadow_color", COLORS.enhanced.panel_bg)
		style.shadow_offset = Vector2(0, effects.get("shadow_y", 8))
	else:
		style.shadow_size = 8
		style.shadow_color = effects.get("shadow_md", EFFECTS.minimal.shadow_md)
		style.shadow_offset = Vector2(0, 4)
	
	# Store in cache if enabled
	if _cache_enabled:
		_add_to_cache(cache_key, style)
	
	return style

static func create_enhanced_button_style(button_type: String = "primary") -> StyleBoxFlat:
	var style = create_enhanced_glass_style(0.8)
	var colors = get_current_colors()
	
	match button_type:
		"primary":
			style.bg_color = colors.get("button_primary", ACCENT_BLUE)
		"secondary":
			style.bg_color = colors.get("button_secondary", ACCENT_PURPLE)
		"danger":
			style.bg_color = colors.get("button_danger", ACCENT_RED)
		_:
			style.bg_color = colors.get("interactive_default", Color(1, 1, 1, 0.4))
	
	style.bg_color.a = 0.8
	return style

# === COMPONENT STYLING METHODS ===
static func apply_enhanced_panel_style(control: Control, style_variant: String = "default") -> void:
	if not control:
		return
	
	var style = create_enhanced_glass_style()
	
	match style_variant:
		"elevated":
			style.shadow_size = 16
			style.border_color = get_current_colors().get("border_hover", COLORS.enhanced.border_hover)
		"subtle":
			style.bg_color.a = 0.6
			style.shadow_size = 4
		_: # default
			pass
	
	if control is Panel or control is PanelContainer:
		control.add_theme_stylebox_override("panel", style)

static func apply_enhanced_typography(control: Control, text_style: String, content: String = "") -> void:
	if not control:
		return
	
	var typography = get_current_typography()
	var colors = get_current_colors()
	
	# Set content if provided
	if content != "" and control.has_method("set_text"):
		control.text = content
	elif content != "" and control.has_method("set_placeholder"):
		control.placeholder_text = content
	
	# Apply typography based on style
	match text_style:
		"heading", "structure_name", "display":
			var style_data = typography.get("structure_name", typography.get("display", {"size": 24}))
			control.add_theme_font_size_override("font_size", style_data.get("size", 24))
			control.add_theme_color_override("font_color", colors.get("text_heading", colors.get("text_primary", TEXT_PRIMARY)))
			
		"subheading", "section_heading", "caption":
			var style_data = typography.get("section_heading", typography.get("caption", {"size": 14}))
			control.add_theme_font_size_override("font_size", style_data.get("size", 14))
			control.add_theme_color_override("font_color", colors.get("text_subheading", colors.get("text_secondary", TEXT_SECONDARY)))
			
		"body", "body_text":
			var style_data = typography.get("body_text", typography.get("body", {"size": 14}))
			control.add_theme_font_size_override("font_size", style_data.get("size", 14))
			control.add_theme_color_override("font_color", colors.get("text_body", colors.get("text_primary", TEXT_PRIMARY)))
			
		"small", "function_item", "micro":
			var style_data = typography.get("function_item", typography.get("small", {"size": 13}))
			control.add_theme_font_size_override("font_size", style_data.get("size", 13))
			control.add_theme_color_override("font_color", colors.get("text_body", colors.get("text_secondary", TEXT_SECONDARY)))
			
		_: # default body text
			control.add_theme_font_size_override("font_size", 14)
			control.add_theme_color_override("font_color", colors.get("text_body", TEXT_PRIMARY))

static func apply_enhanced_button_style(button: Button, button_type: String = "primary") -> void:
	if not button:
		return
	
	var normal_style = create_enhanced_button_style(button_type)
	var hover_style = create_enhanced_button_style(button_type)
	var pressed_style = create_enhanced_button_style(button_type)
	
	# Adjust hover and pressed states
	hover_style.bg_color = hover_style.bg_color.lightened(0.2)
	pressed_style.bg_color = pressed_style.bg_color.darkened(0.1)
	
	button.add_theme_stylebox_override("normal", normal_style)
	button.add_theme_stylebox_override("hover", hover_style)
	button.add_theme_stylebox_override("pressed", pressed_style)
	
	# Apply text color
	var colors = get_current_colors()
	button.add_theme_color_override("font_color", colors.get("text_primary", TEXT_PRIMARY))

# === ENHANCED ANIMATIONS ===
static func animate_enhanced_entrance(control: Control, delay: float = 0.0) -> void:
	if not control:
		return
	
	var effects = get_current_effects()
	var duration = ANIMATION.get("entrance_duration", 0.4)
	var _scale_factor = effects.get("hover_scale", 1.02)
	
	# Start state
	control.modulate = Color.TRANSPARENT
	control.scale = Vector2(0.9, 0.9)
	
	var tween = control.create_tween()
	tween.set_parallel(true)
	
	if delay > 0:
		tween.tween_interval(delay)
	
	# Enhanced entrance with spring easing
	tween.tween_property(control, "modulate", Color.WHITE, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(control, "scale", Vector2.ONE, duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

static func animate_enhanced_hover_in(control: Control) -> void:
	if not control:
		return
	
	var effects = get_current_effects()
	var scale = effects.get("hover_scale", 1.02)
	var glow_color = effects.get("glow_color", ACCENT_BLUE)
	
	var tween = control.create_tween()
	tween.set_parallel(true)
	tween.tween_property(control, "scale", Vector2(scale, scale), ANIMATION.hover_duration)
	tween.tween_property(control, "modulate", glow_color.lightened(0.1), ANIMATION.hover_duration)

static func animate_enhanced_hover_out(control: Control) -> void:
	if not control:
		return
	
	var tween = control.create_tween()
	tween.set_parallel(true)
	tween.tween_property(control, "scale", Vector2.ONE, ANIMATION.hover_duration)
	tween.tween_property(control, "modulate", Color.WHITE, ANIMATION.hover_duration)

# === RESPONSIVE LAYOUT HELPERS ===
static func get_responsive_panel_size(viewport_size: Vector2) -> Dictionary:
	var width = viewport_size.x
	
	if width <= 768:  # Mobile
		return {"width_percent": 0.9, "position": "bottom", "height_percent": 0.5}
	elif width <= 1024:  # Tablet
		return {"width_percent": 0.4, "min_width": 320, "max_width": 400, "position": "right"}
	else:  # Desktop
		return {"width_percent": 0.25, "min_width": 320, "max_width": 480, "position": "right"}

static func apply_responsive_panel_sizing(panel: Control, viewport_size: Vector2) -> void:
	if not panel:
		return
	
	var responsive_data = get_responsive_panel_size(viewport_size)
	var width = viewport_size.x * responsive_data.get("width_percent", 0.25)
	
	# Apply constraints
	if responsive_data.has("min_width"):
		width = max(width, responsive_data.min_width)
	if responsive_data.has("max_width"):
		width = min(width, responsive_data.max_width)
	
	panel.custom_minimum_size.x = width
	
	# Position panel
	match responsive_data.get("position", "right"):
		"right":
			panel.anchor_left = 1.0
			panel.anchor_right = 1.0
			panel.offset_left = -width - SPACING.lg
			panel.offset_right = -SPACING.lg
		"bottom":
			panel.anchor_top = 1.0
			panel.anchor_bottom = 1.0
			panel.anchor_left = 0.5
			panel.anchor_right = 0.5
			var height = viewport_size.y * responsive_data.get("height_percent", 0.5)
			panel.offset_top = -height - SPACING.lg
			panel.offset_bottom = -SPACING.lg

# === LEGACY COMPATIBILITY METHODS ===
# Keep existing method signatures for backward compatibility
static func create_glass_style() -> StyleBoxFlat:
	return create_enhanced_glass_style()

static func create_button_style(color: Color = ACCENT_BLUE) -> StyleBoxFlat:
	var style = create_enhanced_glass_style(0.8)
	style.bg_color = color
	return style

static func create_panel_style() -> StyleBoxFlat:
	return create_enhanced_glass_style()

static func apply_glass_panel(control: Control, _opacity: float = 0.9, _style_type: String = "default") -> void:
	apply_enhanced_panel_style(control, "default")

static func apply_modern_label(label: Label, font_size: int, color: Color, _style_type: String = "default") -> void:
	if not label:
		return
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)

static func apply_modern_button(button: Button, _color: Color, _style_type: String = "default") -> void:
	apply_enhanced_button_style(button, "primary")

static func animate_entrance(control: Control, param1 = null, _param2 = null, _param3 = null) -> void:
	var delay = 0.0
	if param1 != null:
		delay = float(param1) if param1 is float or param1 is int else 0.0
	animate_enhanced_entrance(control, delay)

static func animate_exit(control: Control, param1 = null, _param2 = null) -> void:
	if not control:
		return
	var duration = ANIMATION.exit_duration
	if param1 != null:
		duration = float(param1) if param1 is float or param1 is int else duration
	
	var tween = control.create_tween()
	tween.set_parallel(true)
	tween.tween_property(control, "modulate", Color.TRANSPARENT, duration)
	tween.tween_property(control, "scale", Vector2(0.8, 0.8), duration)
	tween.tween_callback(control.queue_free).set_delay(duration)

static func add_hover_effect(control: Control) -> void:
	if not control:
		return
	control.mouse_entered.connect(func(): animate_enhanced_hover_in(control))
	control.mouse_exited.connect(func(): animate_enhanced_hover_out(control))

static func animate_fade_text_change(label: Label, new_text: String, duration: float = ANIMATION.normal) -> void:
	if not label:
		return
	
	var tween = label.create_tween()
	tween.tween_property(label, "modulate:a", 0.0, duration * 0.5)
	tween.tween_callback(func(): label.text = new_text)
	tween.tween_property(label, "modulate:a", 1.0, duration * 0.5)

# === UTILITY METHODS ===
static func set_theme_mode(mode: ThemeMode) -> void:
	if current_mode != mode:
		current_mode = mode
		clear_style_cache()  # Clear cache when theme changes
		print("[UIThemeManager] Theme mode changed to: ", ["ENHANCED", "MINIMAL"][mode])

static func get_color(color_name: String) -> Color:
	var colors = get_current_colors()
	return colors.get(color_name, TEXT_PRIMARY)

static func get_spacing(spacing_name: String) -> int:
	return SPACING.get(spacing_name, SPACING.md)

static func get_animation_duration(duration_name: String) -> float:
	return ANIMATION.get(duration_name, ANIMATION.normal)

# === ADDITIONAL LEGACY COMPATIBILITY METHODS ===
# Methods that may be called from other scripts

static func apply_search_field_styling(line_edit: LineEdit, placeholder: String = "") -> void:
	"""Apply enhanced styling to search/input fields"""
	if not line_edit:
		return
	
	var colors = get_current_colors()
	var style = StyleBoxFlat.new()
	
	# Background styling
	style.bg_color = colors.get("surface_bg", Color(1, 1, 1, 0.04))
	style.border_color = colors.get("border", Color(1, 1, 1, 0.08))
	style.border_width_left = 1
	style.border_width_right = 1
	style.border_width_top = 1
	style.border_width_bottom = 1
	
	# Corner radius
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	
	# Apply styling
	line_edit.add_theme_stylebox_override("normal", style)
	line_edit.add_theme_color_override("font_color", colors.get("text_primary", TEXT_PRIMARY))
	line_edit.add_theme_color_override("font_placeholder_color", colors.get("text_muted", Color(1, 1, 1, 0.3)))
	
	# Set placeholder if provided
	if placeholder != "":
		line_edit.placeholder_text = placeholder

static func apply_progress_bar_styling(progress_bar: ProgressBar, color: Color = ACCENT_BLUE) -> void:
	"""Apply enhanced styling to progress bars"""
	if not progress_bar:
		return
	
	# Background style
	var bg_style = StyleBoxFlat.new()
	bg_style.bg_color = Color(color.r, color.g, color.b, 0.2)
	bg_style.corner_radius_top_left = 4
	bg_style.corner_radius_top_right = 4
	bg_style.corner_radius_bottom_left = 4
	bg_style.corner_radius_bottom_right = 4
	
	# Fill style
	var fill_style = StyleBoxFlat.new()
	fill_style.bg_color = color
	fill_style.corner_radius_top_left = 4
	fill_style.corner_radius_top_right = 4
	fill_style.corner_radius_bottom_left = 4
	fill_style.corner_radius_bottom_right = 4
	
	progress_bar.add_theme_stylebox_override("background", bg_style)
	progress_bar.add_theme_stylebox_override("fill", fill_style)

static func create_educational_card_style(style_type: String = "default") -> StyleBoxFlat:
	"""Create educational card styles for different content types"""
	var style = create_enhanced_glass_style()
	var colors = get_current_colors()
	
	match style_type:
		"info":
			style.bg_color = Color(ACCENT_BLUE.r, ACCENT_BLUE.g, ACCENT_BLUE.b, 0.1)
			style.border_color = ACCENT_BLUE
		"success":
			style.bg_color = Color(ACCENT_GREEN.r, ACCENT_GREEN.g, ACCENT_GREEN.b, 0.1)
			style.border_color = ACCENT_GREEN
		"warning":
			style.bg_color = Color(ACCENT_ORANGE.r, ACCENT_ORANGE.g, ACCENT_ORANGE.b, 0.1)
			style.border_color = ACCENT_ORANGE
		_:
			style.bg_color = colors.get("panel_bg", COLORS.enhanced.panel_bg)
			style.border_color = colors.get("border", COLORS.enhanced.border)
	
	return style

static func apply_rich_text_styling(rich_text: RichTextLabel, font_size: int, _style_type: String = "default") -> void:
	"""Apply enhanced styling to RichTextLabel controls"""
	if not rich_text:
		return
	
	var colors = get_current_colors()
	rich_text.add_theme_font_size_override("normal_font_size", font_size)
	rich_text.add_theme_color_override("default_color", colors.get("text_body", TEXT_PRIMARY))
	
	# Enable better text rendering
	rich_text.bbcode_enabled = true
	rich_text.fit_content = true

static func animate_button_press(button: Button, color: Color = ACCENT_BLUE) -> void:
	"""Animate button press with enhanced effects"""
	if not button:
		return
	
	var tween = button.create_tween()
	tween.set_parallel(true)
	
	# Quick scale and color pulse
	tween.tween_property(button, "scale", Vector2(0.95, 0.95), 0.1)
	tween.tween_property(button, "modulate", color.lightened(0.2), 0.1)
	
	# Return to normal with chained animations
	tween.tween_property(button, "scale", Vector2.ONE, 0.1).set_delay(0.1)
	tween.tween_property(button, "modulate", Color.WHITE, 0.1).set_delay(0.1)

static func animate_hover_glow(control: Control, color: Color = ACCENT_BLUE, intensity: float = 0.2) -> void:
	"""Add hover glow effect to controls"""
	if not control:
		return
	
	var tween = control.create_tween()
	var glow_color = color
	glow_color.a = intensity
	tween.tween_property(control, "modulate", glow_color, ANIMATION.hover_duration)

static func animate_hover_glow_off(control: Control) -> void:
	"""Remove hover glow effect"""
	if not control:
		return
	
	var tween = control.create_tween()
	tween.tween_property(control, "modulate", Color.WHITE, ANIMATION.hover_duration)

static func apply_theme_to_control(control: Control) -> void:
	"""Apply current theme to any control"""
	if not control:
		return
	
	var theme = Theme.new()
	
	# Apply panel style if it's a Panel or PanelContainer
	if control is Panel or control is PanelContainer:
		theme.set_stylebox("panel", "Panel", create_enhanced_glass_style())
	
	# Apply button styles if it's a Button
	if control is Button:
		theme.set_stylebox("normal", "Button", create_enhanced_button_style())
		theme.set_stylebox("hover", "Button", create_enhanced_button_style("secondary"))
		theme.set_stylebox("pressed", "Button", create_enhanced_button_style("primary"))
	
	control.theme = theme

static func create_styled_label(text: String, font_size_key: String = "body") -> Label:
	"""Create a properly styled label with current theme"""
	var label = Label.new()
	label.text = text
	
	var _colors = get_current_colors()
	var _typography = get_current_typography()
	
	apply_enhanced_typography(label, font_size_key)
	return label

# === CACHE MANAGEMENT ===
static func _add_to_cache(key: String, style: StyleBoxFlat) -> void:
	"""Add a style to the cache with size management"""
	if _style_cache.size() >= _max_cache_size:
		# Remove oldest entry (first key)
		var keys = _style_cache.keys()
		if keys.size() > 0:
			_style_cache.erase(keys[0])
	
	_style_cache[key] = style

static func clear_style_cache() -> void:
	"""Clear all cached styles"""
	_style_cache.clear()
	print("[UIThemeManager] Style cache cleared")

static func set_cache_enabled(enabled: bool) -> void:
	"""Enable or disable style caching"""
	_cache_enabled = enabled
	if not enabled:
		clear_style_cache()