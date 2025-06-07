extends Panel
class_name NavigationPanel

# Main navigation panel for NeuroVis
# Contains navigation items, projects, and data layers sections

signal navigation_item_selected(item_name: String)
signal project_selected(project_name: String)

# Navigation items

var nav_items = {
	"brain_regions":
	{
		"text": "Brain Regions",
		"icon":
		(
			preload("res://assets/icons/brain.svg")
			if ResourceLoader.exists("res://assets/icons/brain.svg")
			else null
		)
	},
	"neural_networks":
	{
		"text": "Neural Networks",
		"icon":
		(
			preload("res://assets/icons/network.svg")
			if ResourceLoader.exists("res://assets/icons/network.svg")
			else null
		)
	},
	"connectivity_maps":
	{
		"text": "Connectivity Maps",
		"icon":
		(
			preload("res://assets/icons/connections.svg")
			if ResourceLoader.exists("res://assets/icons/connections.svg")
			else null
		)
	},
	"time_series":
	{
		"text": "Time Series",
		"icon":
		(
			preload("res://assets/icons/chart.svg")
			if ResourceLoader.exists("res://assets/icons/chart.svg")
			else null
		)
	}
}

var current_nav_selection: String = "brain_regions"
var nav_item_nodes: Dictionary = {}

# Recent projects (mock data for now)
var recent_projects = ["Default Mode Network", "Visual Cortex Mapping", "Hippocampal Study"]

# All projects (mock data for now)
var all_projects = ["Cortical Analysis", "Network Modeling"]


	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = Color("#1a1a1a")
	panel_style.border_width_right = 1
	panel_style.border_color = Color("#333333")
	add_theme_stylebox_override("panel", panel_style)

	# Build UI structure
	_build_ui()


	var main_container = VBoxContainer.new()
	main_container.name = "MainContainer"
	main_container.add_theme_constant_override("separation", 24)
	main_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	main_container.set_offsets_preset(Control.PRESET_FULL_RECT)
	main_container.add_theme_constant_override("margin_left", 16)
	main_container.add_theme_constant_override("margin_right", 16)
	main_container.add_theme_constant_override("margin_top", 16)
	main_container.add_theme_constant_override("margin_bottom", 16)
	add_child(main_container)

	# Header
	var header = Label.new()
	header.text = "NeuroVis"
	header.add_theme_font_size_override("font_size", 24)
	header.add_theme_color_override("font_color", Color("#26d0ce"))
	main_container.add_child(header)

	# Navigation Section
	_create_navigation_section(main_container)

	# Projects Section
	_create_projects_section(main_container)

	# Data Layers Section
	_create_data_layers_section(main_container)

	# Spacer to push everything to top
	var spacer = Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main_container.add_child(spacer)


	var nav_section = VBoxContainer.new()
	nav_section.add_theme_constant_override("separation", 4)
	parent.add_child(nav_section)

	# Section header
	var header = Label.new()
	header.text = "NAVIGATION"
	header.add_theme_font_size_override("font_size", 12)
	header.add_theme_color_override("font_color", Color("#a0a0a0"))
	nav_section.add_child(header)

	# Add some spacing
	var spacer = Control.new()
	spacer.custom_minimum_size.y = 8
	nav_section.add_child(spacer)

	# Create navigation items
	for key in nav_items:
		var item_data = nav_items[key]
		var nav_item = _create_nav_item(key, item_data.text, item_data.icon)
		nav_section.add_child(nav_item)
		nav_item_nodes[key] = nav_item

		# Set initial selection
		if key == current_nav_selection:
			nav_item.set_selected(true)


	var container = PanelContainer.new()
	container.custom_minimum_size = Vector2(0, 40)
	container.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	# Create style
	var style = StyleBoxFlat.new()
	style.bg_color = Color.TRANSPARENT
	style.corner_radius_top_left = 6
	style.corner_radius_top_right = 6
	style.corner_radius_bottom_left = 6
	style.corner_radius_bottom_right = 6
	style.content_margin_left = 12
	style.content_margin_right = 12
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	container.add_theme_stylebox_override("panel", style)

	# Create HBox for content
	var hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 12)
	container.add_child(hbox)

	# Icon
	var icon_rect = TextureRect.new()
	icon_rect.custom_minimum_size = Vector2(20, 20)
	icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon_rect.modulate = Color("#a0a0a0")
	if icon:
		icon_rect.texture = icon
	hbox.add_child(icon_rect)

	# Label
	var label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 14)
	hbox.add_child(label)

	# Store references for easy access
	container.set_meta("id", id)
	container.set_meta("icon", icon_rect)
	container.set_meta("label", label)
	container.set_meta("style", style)

	# Connect events
	container.gui_input.connect(_on_nav_item_input.bind(container))
	container.mouse_entered.connect(_on_nav_item_mouse_entered.bind(container))
	container.mouse_exited.connect(_on_nav_item_mouse_exited.bind(container))

	return container


	var projects_section = VBoxContainer.new()
	projects_section.add_theme_constant_override("separation", 4)
	parent.add_child(projects_section)

	# Section header with collapse button
	var header_container = HBoxContainer.new()
	projects_section.add_child(header_container)

	var header = Label.new()
	header.text = "PROJECTS"
	header.add_theme_font_size_override("font_size", 12)
	header.add_theme_color_override("font_color", Color("#a0a0a0"))
	header_container.add_child(header)

	# Spacer
	var spacer = Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header_container.add_child(spacer)

	# Add some spacing
	var spacing = Control.new()
	spacing.custom_minimum_size.y = 8
	projects_section.add_child(spacing)

	# Recent projects subsection
	var recent_label = Label.new()
	recent_label.text = "RECENT"
	recent_label.add_theme_font_size_override("font_size", 11)
	recent_label.add_theme_color_override("font_color", Color("#606060"))
	projects_section.add_child(recent_label)

	# Recent projects list
	for project in recent_projects:
		var project_item = _create_project_item(project)
		projects_section.add_child(project_item)

	# Spacing between sections
	var section_spacing = Control.new()
	section_spacing.custom_minimum_size.y = 12
	projects_section.add_child(section_spacing)

	# All projects subsection
	var all_label = Label.new()
	all_label.text = "ALL PROJECTS"
	all_label.add_theme_font_size_override("font_size", 11)
	all_label.add_theme_color_override("font_color", Color("#606060"))
	projects_section.add_child(all_label)

	# All projects list
	for project in all_projects:
		var project_item = _create_project_item(project)
		projects_section.add_child(project_item)


	var item = Button.new()
	item.text = project_name
	item.flat = true
	item.alignment = HORIZONTAL_ALIGNMENT_LEFT
	item.add_theme_font_size_override("font_size", 13)
	item.add_theme_color_override("font_color", Color("#a0a0a0"))
	item.add_theme_color_override("font_hover_color", Color("#e5e5e5"))
	item.add_theme_color_override("font_pressed_color", Color("#26d0ce"))

	# Custom style to remove button appearance
	var normal_style = StyleBoxEmpty.new()
	var hover_style = StyleBoxFlat.new()
	hover_style.bg_color = Color("#2a2a2a")
	hover_style.corner_radius_top_left = 4
	hover_style.corner_radius_top_right = 4
	hover_style.corner_radius_bottom_left = 4
	hover_style.corner_radius_bottom_right = 4
	hover_style.content_margin_left = 24
	hover_style.content_margin_right = 8
	hover_style.content_margin_top = 4
	hover_style.content_margin_bottom = 4

	item.add_theme_stylebox_override("normal", normal_style)
	item.add_theme_stylebox_override("hover", hover_style)
	item.add_theme_stylebox_override("pressed", hover_style)
	item.add_theme_stylebox_override("focus", StyleBoxEmpty.new())

	# Add left margin for indent
	var margin_container = MarginContainer.new()
	margin_container.add_theme_constant_override("margin_left", 24)
	margin_container.add_child(item)

	item.pressed.connect(_on_project_selected.bind(project_name))

	return margin_container


	var layers_section = VBoxContainer.new()
	layers_section.add_theme_constant_override("separation", 4)
	parent.add_child(layers_section)

	# Section header
	var header_container = HBoxContainer.new()
	layers_section.add_child(header_container)

	var header = Label.new()
	header.text = "DATA LAYERS"
	header.add_theme_font_size_override("font_size", 12)
	header.add_theme_color_override("font_color", Color("#a0a0a0"))
	header_container.add_child(header)

	# Collapse/expand indicator
	var indicator = Label.new()
	indicator.text = "▼"
	indicator.add_theme_font_size_override("font_size", 10)
	indicator.add_theme_color_override("font_color", Color("#606060"))
	header_container.add_child(indicator)


# Event handlers
			var item_id = item.get_meta("id")
			_select_nav_item(item_id)


		var style = item.get_meta("style") as StyleBoxFlat
		style.bg_color = Color("#2a2a2a")
		item.add_theme_stylebox_override("panel", style)

		var label = item.get_meta("label") as Label
		var icon = item.get_meta("icon") as TextureRect
		label.modulate = Color("#e5e5e5")
		icon.modulate = Color("#e5e5e5")

	item.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND


		var style = item.get_meta("style") as StyleBoxFlat
		style.bg_color = Color.TRANSPARENT
		style.border_width_left = 0
		item.add_theme_stylebox_override("panel", style)

		var label = item.get_meta("label") as Label
		var icon = item.get_meta("icon") as TextureRect
		label.modulate = Color("#e5e5e5")
		icon.modulate = Color("#a0a0a0")


		var prev_item = nav_item_nodes[current_nav_selection]
		var prev_style = prev_item.get_meta("style") as StyleBoxFlat
		prev_style.bg_color = Color.TRANSPARENT
		prev_style.border_width_left = 0
		prev_item.add_theme_stylebox_override("panel", prev_style)

		var prev_label = prev_item.get_meta("label") as Label
		var prev_icon = prev_item.get_meta("icon") as TextureRect
		prev_label.modulate = Color("#e5e5e5")
		prev_icon.modulate = Color("#a0a0a0")

	# Select new
	current_nav_selection = item_id
	if item_id in nav_item_nodes:
		var item = nav_item_nodes[item_id]
		var style = item.get_meta("style") as StyleBoxFlat
		style.bg_color = Color("#1f3a3a")
		style.border_width_left = 3
		style.border_color = Color("#26d0ce")
		style.content_margin_left = 9  # Compensate for border
		item.add_theme_stylebox_override("panel", style)

		var label = item.get_meta("label") as Label
		var icon = item.get_meta("icon") as TextureRect
		label.modulate = Color("#26d0ce")
		icon.modulate = Color("#26d0ce")

	navigation_item_selected.emit(nav_items[item_id].text)


func _ready():
	# Apply dark theme
	NeuroVisDarkTheme.apply_to_node(self)

	# Set panel background

func set_selected_item(item_id: String):
	if item_id in nav_items:
		_select_nav_item(item_id)

func _build_ui():
func _create_navigation_section(parent: Container):
func _create_nav_item(id: String, text: String, icon: Texture2D) -> Control:
	# Create container
func _create_projects_section(parent: Container):
func _create_project_item(project_name: String) -> Control:
func _create_data_layers_section(parent: Container):
func _on_nav_item_input(event: InputEvent, item: Control):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
func _on_nav_item_mouse_entered(item: Control):
	if item.get_meta("id") != current_nav_selection:
func _on_nav_item_mouse_exited(item: Control):
	if item.get_meta("id") != current_nav_selection:
func _select_nav_item(item_id: String):
	# Deselect previous
	if current_nav_selection in nav_item_nodes:
func _on_project_selected(project_name: String):
	project_selected.emit(project_name)


# Public methods
