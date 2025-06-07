# NeuroVis Design System Configuration
# Unified styling and theming configuration

class_name DesignSystem
extends Resource

# === COLOR PALETTE ===
# Based on neuroscience-inspired colors

const COLORS = {
# Primary Colors
"primary": Color("#00D9FF"),  # Cyan - Neural connections
"primary_dark": Color("#0099CC"),
"primary_light": Color("#66E5FF"),
# Secondary Colors
"secondary": Color("#7209B7"),  # Purple - Synaptic activity
"secondary_dark": Color("#560A86"),
"secondary_light": Color("#9B51E0"),
# Accent Colors
"accent_green": Color("#06FFA5"),  # Success, healthy
"accent_orange": Color("#FFB800"),  # Warning, attention
"accent_red": Color("#FF073A"),  # Error, danger
"accent_pink": Color("#FF006E"),  # Highlight, special
# Neutral Colors
"background": Color("#0A0A0F"),  # Deep space black
"surface": Color("#15151F"),  # Panel background
"surface_light": Color("#1F1F2E"),
# Text Colors
"text_primary": Color("#FFFFFF"),
"text_secondary": Color("#B0B0C0"),
"text_muted": Color("#808090"),
"text_disabled": Color("#606060"),
# Semantic Colors
"success": Color("#06FFA5"),
"warning": Color("#FFB800"),
"error": Color("#FF073A"),
"info": Color("#00D9FF")
}

# === TYPOGRAPHY ===
const TYPOGRAPHY = {
# Font families
"font_primary": "res://assets/fonts/Inter-Variable.ttf",
"font_mono": "res://assets/fonts/JetBrainsMono-Regular.ttf",
# Font sizes (in pixels)
"size_h1": 32,
"size_h2": 24,
"size_h3": 20,
"size_h4": 18,
"size_body": 16,
"size_small": 14,
"size_tiny": 12,
# Line heights (multiplier)
"line_height_tight": 1.2,
"line_height_normal": 1.5,
"line_height_relaxed": 1.8,
# Font weights
"weight_light": 300,
"weight_regular": 400,
"weight_medium": 500,
"weight_semibold": 600,
"weight_bold": 700
}

# === SPACING SYSTEM ===
# Based on 8px grid
const SPACING = {"xxs": 4, "xs": 8, "sm": 12, "md": 16, "lg": 24, "xl": 32, "xxl": 48, "xxxl": 64}  # 0.5 * base  # 1 * base  # 1.5 * base  # 2 * base  # 3 * base  # 4 * base  # 6 * base  # 8 * base

# === ANIMATION TIMING ===
const ANIMATION = {
# Durations (in seconds)
"instant": 0.0,
"fast": 0.15,
"normal": 0.25,
"slow": 0.4,
"very_slow": 0.6,
# Easing curves
"ease_in_out": "cubic-bezier(0.4, 0, 0.2, 1)",
"ease_out": "cubic-bezier(0, 0, 0.2, 1)",
"ease_in": "cubic-bezier(0.4, 0, 1, 1)",
"spring": "cubic-bezier(0.34, 1.56, 0.64, 1)",
# Stagger delays for lists
"stagger_delay": 0.05
}

# === ELEVATION SYSTEM ===
const ELEVATION = {
# Shadow definitions
"level_0": {"blur": 0, "offset": Vector2(0, 0), "color": Color(0, 0, 0, 0)},
"level_1": {"blur": 4, "offset": Vector2(0, 2), "color": Color(0, 0, 0, 0.1)},
"level_2": {"blur": 8, "offset": Vector2(0, 4), "color": Color(0, 0, 0, 0.15)},
"level_3": {"blur": 16, "offset": Vector2(0, 8), "color": Color(0, 0, 0, 0.2)},
"level_4": {"blur": 24, "offset": Vector2(0, 12), "color": Color(0, 0, 0, 0.25)}
}

# === BORDER RADIUS ===
const RADIUS = {"none": 0, "sm": 4, "md": 8, "lg": 12, "xl": 16, "full": 9999}

# === Z-INDEX LAYERS ===
const Z_INDEX = {
"background": -1,
"default": 0,
"elevated": 10,
"sticky": 100,
"dropdown": 200,
"modal": 300,
"tooltip": 400,
"notification": 500
}

# === BREAKPOINTS ===
const BREAKPOINTS = {"mobile": 480, "tablet": 768, "desktop": 1024, "wide": 1440, "ultrawide": 1920}

# === ICON SIZES ===
const ICON_SIZES = {"xs": 16, "sm": 20, "md": 24, "lg": 32, "xl": 48}


# === UTILITY FUNCTIONS ===
static func get_color(color_name: String) -> Color:

var theme = Theme.new()

# Create button styles
var normal = StyleBoxFlat.new()
var hover = StyleBoxFlat.new()
var pressed = StyleBoxFlat.new()
var disabled = StyleBoxFlat.new()

# Configure based on variant
"primary":
	normal.bg_color = get_color("primary")
	hover.bg_color = get_color("primary_light")
	pressed.bg_color = get_color("primary_dark")
	"secondary":
		normal.bg_color = get_color("secondary")
		hover.bg_color = get_color("secondary_light")
		pressed.bg_color = get_color("secondary_dark")
		"ghost":
			normal.bg_color = Color.TRANSPARENT
			hover.bg_color = Color(1, 1, 1, 0.1)
			pressed.bg_color = Color(1, 1, 1, 0.2)

			disabled.bg_color = get_color("surface_light")

			# Apply common properties
var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = get_color("surface")
	panel_style.corner_radius_top_left = get_radius("lg")
	panel_style.corner_radius_top_right = get_radius("lg")
	panel_style.corner_radius_bottom_left = get_radius("lg")
	panel_style.corner_radius_bottom_right = get_radius("lg")
	control.add_theme_stylebox_override("panel", panel_style)

func _fix_orphaned_code():
	return COLORS.get(color_name, COLORS.text_primary)


	static func get_semantic_color(type: String) -> Color:
		match type:
			"success":
				return COLORS.success
				"warning":
					return COLORS.warning
					"error":
						return COLORS.error
						"info":
							return COLORS.info
							_:
								return COLORS.text_primary


								static func get_spacing(size: String) -> int:
									return SPACING.get(size, SPACING.md)


									static func get_font_size(size: String) -> int:
										return TYPOGRAPHY.get("size_" + size, TYPOGRAPHY.size_body)


										static func get_animation_duration(speed: String) -> float:
											return ANIMATION.get(speed, ANIMATION.normal)


											static func get_elevation_style(level: int) -> Dictionary:
												return ELEVATION.get("level_" + str(level), ELEVATION.level_0)


												static func get_radius(size: String) -> int:
													return RADIUS.get(size, RADIUS.md)


													# === THEME CREATION ===
													static func create_button_theme(variant: String = "primary") -> Theme:
func _fix_orphaned_code():
	for style in [normal, hover, pressed, disabled]:
		style.corner_radius_top_left = get_radius("md")
		style.corner_radius_top_right = get_radius("md")
		style.corner_radius_bottom_left = get_radius("md")
		style.corner_radius_bottom_right = get_radius("md")
		style.content_margin_left = get_spacing("md")
		style.content_margin_right = get_spacing("md")
		style.content_margin_top = get_spacing("sm")
		style.content_margin_bottom = get_spacing("sm")

		# Apply to theme
		theme.set_stylebox("normal", "Button", normal)
		theme.set_stylebox("hover", "Button", hover)
		theme.set_stylebox("pressed", "Button", pressed)
		theme.set_stylebox("disabled", "Button", disabled)

		# Set font properties
		theme.set_font_size("font_size", "Button", get_font_size("body"))
		theme.set_color("font_color", "Button", get_color("text_primary"))
		theme.set_color("font_disabled_color", "Button", get_color("text_disabled"))

		return theme


		static func apply_design_system(control: Control) -> void:
			"""Apply design system to any control"""
			if control is Button:
				control.theme = create_button_theme()
				elif control is Label:
					control.add_theme_font_size_override("font_size", get_font_size("body"))
					control.add_theme_color_override("font_color", get_color("text_primary"))
					elif control is PanelContainer:
