## UITransformationDemo.gd
## Demo script for integrating the new NavigationSidebar
##
## This script demonstrates how to integrate the new NavigationSidebar
## into the main scene, including setting up sections and items.
##
## @tutorial: UI Transformation Guide
## @version: 1.0

extends Node

# Navigation sidebar reference

var navigation_sidebar: NavigationSidebar

# Demo data for sections and items
var navigation_sections = {
	"navigation":
	{
		"title": "NAVIGATION",
		"icon": null,
		"items":
		{
			"brain_regions": {"text": "Brain Regions", "icon": null},
			"neural_networks": {"text": "Neural Networks", "icon": null},
			"connectivity": {"text": "Connectivity Maps", "icon": null},
			"time_series": {"text": "Time Series", "icon": null}
		}
	},
	"projects":
	{
		"title": "PROJECTS",
		"icon": null,
		"items":
		{
			"recent": {"text": "Recent Projects", "icon": null},
			"all": {"text": "All Projects", "icon": null},
			"favorites": {"text": "Favorites", "icon": null}
		}
	},
	"workspace":
	{
		"title": "WORKSPACE TOOLS",
		"icon": null,
		"items":
		{
			"selection": {"text": "Selection Tools", "icon": null},
			"camera": {"text": "Camera Presets", "icon": null},
			"layers": {"text": "Layer Management", "icon": null}
		}
	},
	"analysis":
	{
		"title": "ANALYSIS",
		"icon": null,
		"items":
		{
			"measurements": {"text": "Measurements", "icon": null},
			"annotations": {"text": "Annotations", "icon": null},
			"comparisons": {"text": "Comparisons", "icon": null}
		}
	},
	"export":
	{
		"title": "EXPORT",
		"icon": null,
		"items":
		{
			"screenshots": {"text": "Screenshots", "icon": null},
			"reports": {"text": "Reports", "icon": null},
			"presentations": {"text": "Presentations", "icon": null}
		}
	}
}


	var main_container = Control.new()
	main_container.name = "UIDemo"
	main_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	get_tree().root.add_child(main_container)

	# Apply dark theme
	if NeuroVisDarkTheme and NeuroVisDarkTheme.has_method("apply_to_node"):
		NeuroVisDarkTheme.apply_to_node(main_container)

	# Set dark background
	var bg_panel = Panel.new()
	bg_panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var bg_style = StyleBoxFlat.new()
	bg_style.bg_color = Color("#0a0a0a")
	bg_panel.add_theme_stylebox_override("panel", bg_style)
	main_container.add_child(bg_panel)

	# Create three-panel layout
	var h_split = HSplitContainer.new()
	h_split.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	h_split.split_offset = 280  # Left panel width
	main_container.add_child(h_split)

	# Left Panel - NEW NavigationSidebar
	_setup_navigation_sidebar(h_split)

	# Right side split (center + right panel)
	var right_split = HSplitContainer.new()
	right_split.split_offset = -320  # Right panel width from right edge
	h_split.add_child(right_split)

	# Center Panel - Workspace
	var center_panel = Panel.new()
	var center_style = StyleBoxFlat.new()
	center_style.bg_color = Color("#0f0f0f")
	center_panel.add_theme_stylebox_override("panel", center_style)
	right_split.add_child(center_panel)

	# Add workspace content
	var workspace_vbox = VBoxContainer.new()
	workspace_vbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	center_panel.add_child(workspace_vbox)

	# Workspace header
	var header_container = PanelContainer.new()
	header_container.custom_minimum_size.y = 60
	var header_style = StyleBoxFlat.new()
	header_style.bg_color = Color("#1a1a1a")
	header_style.border_width_bottom = 1
	header_style.border_color = Color("#333333")
	header_style.content_margin_left = 24
	header_style.content_margin_right = 24
	header_style.content_margin_top = 16
	header_style.content_margin_bottom = 16
	header_container.add_theme_stylebox_override("panel", header_style)
	workspace_vbox.add_child(header_container)

	var header_hbox = HBoxContainer.new()
	header_container.add_child(header_hbox)

	var workspace_title = Label.new()
	workspace_title.text = "Neural Visualization Workspace"
	workspace_title.add_theme_font_size_override("font_size", 20)
	header_hbox.add_child(workspace_title)

	# Spacer
	var spacer = Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header_hbox.add_child(spacer)

	# Live button
	var live_button = Button.new()
	live_button.text = "Live"
	live_button.custom_minimum_size = Vector2(80, 32)
	var live_style_normal = StyleBoxFlat.new()
	live_style_normal.bg_color = Color("#26d0ce")
	live_style_normal.corner_radius_top_left = 6
	live_style_normal.corner_radius_top_right = 6
	live_style_normal.corner_radius_bottom_left = 6
	live_style_normal.corner_radius_bottom_right = 6
	live_button.add_theme_stylebox_override("normal", live_style_normal)
	live_button.add_theme_color_override("font_color", Color("#0a0a0a"))
	live_button.add_theme_font_override(
		"font",
		(
			preload("res://assets/fonts/Inter-Bold.ttf")
			if ResourceLoader.exists("res://assets/fonts/Inter-Bold.ttf")
			else null
		)
	)
	header_hbox.add_child(live_button)

	# 3D Viewport area (placeholder)
	var viewport_container = Panel.new()
	viewport_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var viewport_style = StyleBoxFlat.new()
	viewport_style.bg_color = Color("#050505")
	viewport_container.add_theme_stylebox_override("panel", viewport_style)
	workspace_vbox.add_child(viewport_container)

	# Bottom input bar
	var input_container = PanelContainer.new()
	input_container.custom_minimum_size.y = 60
	var input_panel_style = StyleBoxFlat.new()
	input_panel_style.bg_color = Color("#1a1a1a")
	input_panel_style.border_width_top = 1
	input_panel_style.border_color = Color("#333333")
	input_panel_style.content_margin_left = 24
	input_panel_style.content_margin_right = 24
	input_panel_style.content_margin_top = 12
	input_panel_style.content_margin_bottom = 12
	input_container.add_theme_stylebox_override("panel", input_panel_style)
	workspace_vbox.add_child(input_container)

	var input_hbox = HBoxContainer.new()
	input_hbox.add_theme_constant_override("separation", 12)
	input_container.add_child(input_hbox)

	var input_field = LineEdit.new()
	input_field.placeholder_text = "Describe what you want to analyze or visualize..."
	input_field.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	input_hbox.add_child(input_field)

	# Right Panel - Tools
	var tools_panel = Panel.new()
	tools_panel.custom_minimum_size.x = 320
	var tools_style = StyleBoxFlat.new()
	tools_style.bg_color = Color("#1a1a1a")
	tools_style.border_width_left = 1
	tools_style.border_color = Color("#333333")
	tools_panel.add_theme_stylebox_override("panel", tools_style)
	right_split.add_child(tools_panel)

	# Tools content
	var tools_vbox = VBoxContainer.new()
	tools_vbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	tools_vbox.add_theme_constant_override("margin_left", 16)
	tools_vbox.add_theme_constant_override("margin_right", 16)
	tools_vbox.add_theme_constant_override("margin_top", 16)
	tools_vbox.add_theme_constant_override("margin_bottom", 16)
	tools_vbox.add_theme_constant_override("separation", 24)
	tools_panel.add_child(tools_vbox)

	var tools_header = Label.new()
	tools_header.text = "Workspace Tools"
	tools_header.add_theme_font_size_override("font_size", 18)
	tools_vbox.add_child(tools_header)

	# Properties section
	_create_tools_section(
		tools_vbox, "PROPERTIES", ["Selection Details", "Measurements", "Statistics"]
	)

	# Analysis section
	_create_tools_section(
		tools_vbox, "ANALYSIS", ["Graph Theory", "Signal Processing", "ML Models"]
	)

	# Export section
	_create_tools_section(tools_vbox, "EXPORT", ["Images", "Video", "Reports"])

	print("UI Transformation Demo loaded! Check the running window.")


	var sidebar_scene = load("res://ui/components/navigation/NavigationSidebar.tscn")
	if sidebar_scene:
		navigation_sidebar = sidebar_scene.instantiate()
	else:
		# Fallback to creating instance directly
		var sidebar_script = prepreload("res://ui/components/navigation/NavigationSidebar.gd")
		if sidebar_script:
			navigation_sidebar = sidebar_script.new()
		else:
			push_error("[UI Transformation] Failed to load NavigationSidebar script")
			return

	# Configure sidebar
	navigation_sidebar.name = "NavigationSidebar"
	navigation_sidebar.custom_minimum_size.x = 260
	navigation_sidebar.anchor_bottom = 1.0
	navigation_sidebar.size_flags_vertical = Control.SIZE_EXPAND_FILL

	# Add to parent
	parent_node.add_child(navigation_sidebar)

	# Add sections and items
	for section_id in navigation_sections:
		var section_data = navigation_sections[section_id]

		# Add section
		navigation_sidebar.add_section(section_id, section_data.title, section_data.icon)

		# Add items to section
		for item_id in section_data.items:
			var item_data = section_data.items[item_id]
			navigation_sidebar.add_item(section_id, item_id, item_data.text, item_data.icon)

	# Select initial item
	navigation_sidebar.select_item("navigation", "brain_regions")

	# Connect signals
	if navigation_sidebar.has_signal("item_selected"):
		navigation_sidebar.item_selected.connect(_on_navigation_item_selected)

	if navigation_sidebar.has_signal("section_toggled"):
		navigation_sidebar.section_toggled.connect(_on_navigation_section_toggled)

	print("[UI Transformation] Navigation sidebar setup complete")


	var section = VBoxContainer.new()
	section.add_theme_constant_override("separation", 8)
	parent.add_child(section)

	# Section header
	var header = Label.new()
	header.text = title
	header.add_theme_font_size_override("font_size", 12)
	header.add_theme_color_override("font_color", Color("#a0a0a0"))
	section.add_child(header)

	# Items
	for item in items:
		var item_container = HBoxContainer.new()
		item_container.add_theme_constant_override("separation", 8)
		section.add_child(item_container)

		# Icon placeholder
		var icon = Panel.new()
		icon.custom_minimum_size = Vector2(20, 20)
		var icon_style = StyleBoxFlat.new()
		icon_style.bg_color = Color("#333333")
		icon_style.corner_radius_top_left = 4
		icon_style.corner_radius_top_right = 4
		icon_style.corner_radius_bottom_left = 4
		icon_style.corner_radius_bottom_right = 4
		icon.add_theme_stylebox_override("panel", icon_style)
		item_container.add_child(icon)

		# Label
		var label = Label.new()
		label.text = item
		label.add_theme_font_size_override("font_size", 14)
		item_container.add_child(label)


# === NEW NAVIGATION SIGNAL HANDLERS ===

func _ready() -> void:
	print("Starting NeuroVis UI Transformation Demo...")

	# Create main window with dark theme

func _setup_navigation_sidebar(parent_node: Node) -> void:
	"""Setup the navigation sidebar with sections and items"""
	print("[UI Transformation] Setting up navigation sidebar...")

	# Create navigation sidebar
func _create_tools_section(parent: Container, title: String, items: Array):
func _on_navigation_item_selected(section_id: String, item_id: String) -> void:
	"""Handle navigation item selection"""
	print("[Navigation] Selected: %s > %s" % [section_id, item_id])

	# Handle navigation logic based on selection
	match section_id:
		"navigation":
			_handle_navigation_selection(item_id)
		"projects":
			_handle_projects_selection(item_id)
		"workspace":
			_handle_workspace_selection(item_id)
		"analysis":
			_handle_analysis_selection(item_id)
		"export":
			_handle_export_selection(item_id)


func _on_navigation_section_toggled(section_id: String, expanded: bool) -> void:
	"""Handle navigation section toggle"""
	print("[Navigation] Section %s %s" % [section_id, "expanded" if expanded else "collapsed"])


# === LEGACY HANDLERS (for backward compatibility) ===
func _on_navigation_selected(item_name: String):
	print("[Legacy] Navigation selected: ", item_name)


func _on_project_selected(project_name: String):
	print("[Legacy] Project selected: ", project_name)


# === NAVIGATION HANDLERS ===
func _handle_navigation_selection(item_id: String) -> void:
	"""Handle navigation section selection"""
	match item_id:
		"brain_regions":
			print("[Navigation] Switching to Brain Regions view")
		"neural_networks":
			print("[Navigation] Switching to Neural Networks view")
		"connectivity":
			print("[Navigation] Switching to Connectivity Maps view")
		"time_series":
			print("[Navigation] Switching to Time Series view")


func _handle_projects_selection(item_id: String) -> void:
	"""Handle projects section selection"""
	match item_id:
		"recent":
			print("[Navigation] Showing Recent Projects")
		"all":
			print("[Navigation] Showing All Projects")
		"favorites":
			print("[Navigation] Showing Favorite Projects")


func _handle_workspace_selection(item_id: String) -> void:
	"""Handle workspace section selection"""
	match item_id:
		"selection":
			print("[Navigation] Opening Selection Tools")
		"camera":
			print("[Navigation] Opening Camera Presets")
		"layers":
			print("[Navigation] Opening Layer Management")


func _handle_analysis_selection(item_id: String) -> void:
	"""Handle analysis section selection"""
	match item_id:
		"measurements":
			print("[Navigation] Opening Measurements panel")
		"annotations":
			print("[Navigation] Opening Annotations panel")
		"comparisons":
			print("[Navigation] Opening Comparisons panel")


func _handle_export_selection(item_id: String) -> void:
	"""Handle export section selection"""
	match item_id:
		"screenshots":
			print("[Navigation] Opening Screenshots panel")
		"reports":
			print("[Navigation] Opening Reports panel")
		"presentations":
			print("[Navigation] Opening Presentations panel")
