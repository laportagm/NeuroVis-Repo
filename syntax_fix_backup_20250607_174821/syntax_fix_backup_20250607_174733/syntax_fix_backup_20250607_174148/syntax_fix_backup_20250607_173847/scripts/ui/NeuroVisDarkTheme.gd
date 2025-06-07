extends Theme
class_name NeuroVisDarkTheme

# This script creates a comprehensive dark theme for NeuroVis
# matching the target UI design


static func create_theme() -> Theme:

	var theme = Theme.new()

	# Color Palette
	var colors = {
		"background": Color("#0a0a0a"),  # Main background
		"panel_bg": Color("#1a1a1a"),  # Panel backgrounds
		"panel_header": Color("#252525"),  # Panel headers
		"accent": Color("#26d0ce"),  # Teal accent color
		"accent_hover": Color("#3ae5e3"),  # Lighter teal for hover
		"text_primary": Color("#e5e5e5"),  # Primary text
		"text_secondary": Color("#a0a0a0"),  # Secondary text
		"text_disabled": Color("#606060"),  # Disabled text
		"border": Color("#333333"),  # Subtle borders
		"hover_bg": Color("#2a2a2a"),  # Hover background
		"selected_bg": Color("#1f3a3a"),  # Selected item background
		"error": Color("#ff4444"),  # Error color
		"success": Color("#44ff44"),  # Success color
		"warning": Color("#ffaa44")  # Warning color
	}

	# Fonts - Initialize as null and load at runtime to prevent parse-time failures
	var font_regular = null
	var font_bold = null
	var font_mono = null

	# Safe runtime font loading - check for both .ttf and .tres extensions
	if ResourceLoader.exists("res://assets/fonts/Inter-Regular.ttf"):
		font_regular = load("res://assets/fonts/Inter-Regular.ttf")
	elif ResourceLoader.exists("res://assets/fonts/Inter-Regular.tres"):
		font_regular = load("res://assets/fonts/Inter-Regular.tres")

	if ResourceLoader.exists("res://assets/fonts/Inter-Bold.ttf"):
		font_bold = load("res://assets/fonts/Inter-Bold.ttf")
	elif ResourceLoader.exists("res://assets/fonts/Inter-Bold.tres"):
		font_bold = load("res://assets/fonts/Inter-Bold.tres")

	if ResourceLoader.exists("res://assets/fonts/JetBrainsMono-Regular.ttf"):
		font_mono = load("res://assets/fonts/JetBrainsMono-Regular.ttf")
	elif ResourceLoader.exists("res://assets/fonts/JetBrainsMono-Regular.tres"):
		font_mono = load("res://assets/fonts/JetBrainsMono-Regular.tres")

	# Font Sizes
	var font_sizes = {"h1": 24, "h2": 20, "h3": 18, "body": 14, "small": 12, "tiny": 10}

	# Panel StyleBox
	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = colors.panel_bg
	panel_style.border_width_left = 1
	panel_style.border_width_right = 1
	panel_style.border_width_top = 1
	panel_style.border_width_bottom = 1
	panel_style.border_color = colors.border
	panel_style.corner_radius_top_left = 8
	panel_style.corner_radius_top_right = 8
	panel_style.corner_radius_bottom_left = 8
	panel_style.corner_radius_bottom_right = 8
	panel_style.content_margin_left = 16
	panel_style.content_margin_right = 16
	panel_style.content_margin_top = 16
	panel_style.content_margin_bottom = 16

	theme.set_stylebox("panel", "Panel", panel_style)

	# Button Styles
	var button_normal = StyleBoxFlat.new()
	button_normal.bg_color = colors.panel_header
	button_normal.border_width_left = 1
	button_normal.border_width_right = 1
	button_normal.border_width_top = 1
	button_normal.border_width_bottom = 1
	button_normal.border_color = colors.border
	button_normal.corner_radius_top_left = 6
	button_normal.corner_radius_top_right = 6
	button_normal.corner_radius_bottom_left = 6
	button_normal.corner_radius_bottom_right = 6
	button_normal.content_margin_left = 16
	button_normal.content_margin_right = 16
	button_normal.content_margin_top = 8
	button_normal.content_margin_bottom = 8

	var button_hover = button_normal.duplicate()
	button_hover.bg_color = colors.hover_bg
	button_hover.border_color = colors.accent

	var button_pressed = button_normal.duplicate()
	button_pressed.bg_color = colors.selected_bg
	button_pressed.border_color = colors.accent

	theme.set_stylebox("normal", "Button", button_normal)
	theme.set_stylebox("hover", "Button", button_hover)
	theme.set_stylebox("pressed", "Button", button_pressed)
	theme.set_color("font_color", "Button", colors.text_primary)
	theme.set_color("font_hover_color", "Button", colors.accent)
	theme.set_color("font_pressed_color", "Button", colors.accent)
	if font_regular:
		theme.set_font("font", "Button", font_regular)
	theme.set_font_size("font_size", "Button", font_sizes.body)

	# Accent Button (like "Live" button)
	var accent_button_normal = button_normal.duplicate()
	accent_button_normal.bg_color = colors.accent
	accent_button_normal.border_color = colors.accent

	var accent_button_hover = accent_button_normal.duplicate()
	accent_button_hover.bg_color = colors.accent_hover

	# Label Styles
	theme.set_color("font_color", "Label", colors.text_primary)
	if font_regular:
		theme.set_font("font", "Label", font_regular)
	theme.set_font_size("font_size", "Label", font_sizes.body)

	# LineEdit Styles
	var line_edit_normal = StyleBoxFlat.new()
	line_edit_normal.bg_color = colors.panel_header
	line_edit_normal.border_width_left = 1
	line_edit_normal.border_width_right = 1
	line_edit_normal.border_width_top = 1
	line_edit_normal.border_width_bottom = 1
	line_edit_normal.border_color = colors.border
	line_edit_normal.corner_radius_top_left = 6
	line_edit_normal.corner_radius_top_right = 6
	line_edit_normal.corner_radius_bottom_left = 6
	line_edit_normal.corner_radius_bottom_right = 6
	line_edit_normal.content_margin_left = 12
	line_edit_normal.content_margin_right = 12
	line_edit_normal.content_margin_top = 8
	line_edit_normal.content_margin_bottom = 8

	var line_edit_focus = line_edit_normal.duplicate()
	line_edit_focus.border_color = colors.accent
	line_edit_focus.border_width_left = 2
	line_edit_focus.border_width_right = 2
	line_edit_focus.border_width_top = 2
	line_edit_focus.border_width_bottom = 2

	theme.set_stylebox("normal", "LineEdit", line_edit_normal)
	theme.set_stylebox("focus", "LineEdit", line_edit_focus)
	theme.set_color("font_color", "LineEdit", colors.text_primary)
	theme.set_color("font_placeholder_color", "LineEdit", colors.text_disabled)
	if font_regular:
		theme.set_font("font", "LineEdit", font_regular)
	theme.set_font_size("font_size", "LineEdit", font_sizes.body)

	# Tree/ItemList Styles (for navigation)
	var tree_bg = StyleBoxFlat.new()
	tree_bg.bg_color = Color.TRANSPARENT

	var tree_selected = StyleBoxFlat.new()
	tree_selected.bg_color = colors.selected_bg
	tree_selected.corner_radius_top_left = 6
	tree_selected.corner_radius_top_right = 6
	tree_selected.corner_radius_bottom_left = 6
	tree_selected.corner_radius_bottom_right = 6
	tree_selected.content_margin_left = 8
	tree_selected.content_margin_right = 8
	tree_selected.content_margin_top = 4
	tree_selected.content_margin_bottom = 4

	var tree_hover = tree_selected.duplicate()
	tree_hover.bg_color = colors.hover_bg

	theme.set_stylebox("panel", "Tree", tree_bg)
	theme.set_stylebox("selected", "Tree", tree_selected)
	theme.set_stylebox("selected_focus", "Tree", tree_selected)
	theme.set_stylebox("cursor", "Tree", tree_hover)
	theme.set_stylebox("cursor_unfocused", "Tree", tree_hover)
	theme.set_color("font_color", "Tree", colors.text_primary)
	theme.set_color("font_selected_color", "Tree", colors.accent)

	# ScrollBar Styles
	var scrollbar_bg = StyleBoxFlat.new()
	scrollbar_bg.bg_color = colors.panel_bg
	scrollbar_bg.content_margin_left = 2
	scrollbar_bg.content_margin_right = 2

	var scrollbar_grabber = StyleBoxFlat.new()
	scrollbar_grabber.bg_color = colors.border
	scrollbar_grabber.corner_radius_top_left = 4
	scrollbar_grabber.corner_radius_top_right = 4
	scrollbar_grabber.corner_radius_bottom_left = 4
	scrollbar_grabber.corner_radius_bottom_right = 4

	var scrollbar_grabber_hover = scrollbar_grabber.duplicate()
	scrollbar_grabber_hover.bg_color = colors.text_disabled

	theme.set_stylebox("scroll", "VScrollBar", scrollbar_bg)
	theme.set_stylebox("grabber", "VScrollBar", scrollbar_grabber)
	theme.set_stylebox("grabber_highlight", "VScrollBar", scrollbar_grabber_hover)
	theme.set_stylebox("grabber_pressed", "VScrollBar", scrollbar_grabber_hover)

	# TabContainer Styles
	var tab_selected = StyleBoxFlat.new()
	tab_selected.bg_color = colors.panel_bg
	tab_selected.border_width_bottom = 2
	tab_selected.border_color = colors.accent
	tab_selected.content_margin_left = 16
	tab_selected.content_margin_right = 16
	tab_selected.content_margin_top = 8
	tab_selected.content_margin_bottom = 8

	var tab_unselected = tab_selected.duplicate()
	tab_unselected.bg_color = colors.panel_header
	tab_unselected.border_width_bottom = 0

	theme.set_stylebox("tab_selected", "TabContainer", tab_selected)
	theme.set_stylebox("tab_unselected", "TabContainer", tab_unselected)
	theme.set_color("font_selected_color", "TabContainer", colors.accent)
	theme.set_color("font_unselected_color", "TabContainer", colors.text_secondary)

	# Separator Styles
	var separator_style = StyleBoxLine.new()
	separator_style.color = colors.border
	separator_style.thickness = 1
	theme.set_stylebox("separator", "VSeparator", separator_style)
	theme.set_stylebox("separator", "HSeparator", separator_style)

	# CheckBox Styles
	theme.set_color("font_color", "CheckBox", colors.text_primary)
	theme.set_color("font_hover_color", "CheckBox", colors.accent)

	# OptionButton Styles
	theme.set_stylebox("normal", "OptionButton", button_normal)
	theme.set_stylebox("hover", "OptionButton", button_hover)
	theme.set_stylebox("pressed", "OptionButton", button_pressed)
	theme.set_color("font_color", "OptionButton", colors.text_primary)
	theme.set_color("font_hover_color", "OptionButton", colors.accent)

	# PopupMenu Styles
	var popup_bg = panel_style.duplicate()
	popup_bg.bg_color = colors.panel_header
	popup_bg.shadow_size = 8
	popup_bg.shadow_color = Color(0, 0, 0, 0.3)

	theme.set_stylebox("panel", "PopupMenu", popup_bg)
	theme.set_stylebox("hover", "PopupMenu", tree_hover)
	theme.set_color("font_color", "PopupMenu", colors.text_primary)
	theme.set_color("font_hover_color", "PopupMenu", colors.accent)

	# ProgressBar Styles
	var progress_bg = StyleBoxFlat.new()
	progress_bg.bg_color = colors.panel_header
	progress_bg.corner_radius_top_left = 4
	progress_bg.corner_radius_top_right = 4
	progress_bg.corner_radius_bottom_left = 4
	progress_bg.corner_radius_bottom_right = 4

	var progress_fill = progress_bg.duplicate()
	progress_fill.bg_color = colors.accent

	theme.set_stylebox("background", "ProgressBar", progress_bg)
	theme.set_stylebox("fill", "ProgressBar", progress_fill)

	# Slider Styles
	var slider_bg = StyleBoxFlat.new()
	slider_bg.bg_color = colors.panel_header
	slider_bg.content_margin_top = 10
	slider_bg.content_margin_bottom = 10

	var slider_grabber = StyleBoxFlat.new()
	slider_grabber.bg_color = colors.accent
	slider_grabber.corner_radius_top_left = 8
	slider_grabber.corner_radius_top_right = 8
	slider_grabber.corner_radius_bottom_left = 8
	slider_grabber.corner_radius_bottom_right = 8
	slider_grabber.expand_margin_left = 4
	slider_grabber.expand_margin_right = 4
	slider_grabber.expand_margin_top = 4
	slider_grabber.expand_margin_bottom = 4

	theme.set_stylebox("slider", "HSlider", slider_bg)
	theme.set_stylebox("grabber_area", "HSlider", slider_grabber)

	# Custom Section Header Style
	if font_bold:
		var header_font = font_bold.duplicate()
		theme.set_font("section_header", "Label", header_font)
	theme.set_font_size("section_header_size", "Label", font_sizes.small)
	theme.set_color("section_header_color", "Label", colors.text_secondary)

	return theme


# Helper function to apply the theme to a node and its children
static func apply_to_node(node: Node) -> void:
	var theme = create_theme()

	if node is Control:
		node.theme = theme

	# Also apply to all child controls
	for child in node.get_children():
		apply_to_node(child)
