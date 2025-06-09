# Modular Information Panel for NeuroVis
# Replaces multiple info panel variations with configurable sections

class_name ModularInfoPanel
extends ResponsiveComponent

# === PANEL SIGNALS ===

signal panel_closed
signal content_changed(section: String, data: Dictionary)
signal section_toggled(section: String, visible: bool)
signal action_triggered(action: String, data: Dictionary)

# === PANEL CONFIGURATION ===

const SECTION_TYPES = {
"header":
	{
	"title": "Structure Name",
	"content_type": "rich_text",
	"collapsible": false,
	"style": "heading"
	},
	"description":
		{"title": "Description", "content_type": "rich_text", "collapsible": true, "style": "body"},
		"functions":
			{"title": "Functions", "content_type": "list", "collapsible": true, "style": "list"},
			"connections":
				{
				"title": "Neural Connections",
				"content_type": "grid",
				"collapsible": true,
				"style": "connections"
				},
				"research":
					{"title": "Research Notes", "content_type": "cards", "collapsible": true, "style": "research"},
					"related":
						{
						"title": "Related Structures",
						"content_type": "buttons",
						"collapsible": true,
						"style": "navigation"
						}
						}


@export var panel_title: String = "Structure Information"
@export var closeable: bool = true
@export var collapsible_sections: bool = true
@export var show_search: bool = false
@export var animation_enabled: bool = true

# === PANEL SECTIONS ===

var sections: Dictionary = {}
# FIXED: Orphaned code - var section_order: Array = []
var section_configs: Dictionary = {}

# === UI REFERENCES ===
var title_bar: HBoxContainer
var title_label: Label
var close_button: Button
var search_container: Control
var search_field: LineEdit
var content_container: VBoxContainer
var scroll_container: ScrollContainer

# === BUILT-IN SECTION TYPES ===
var main_container = VBoxContainer.new()
	main_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	main_container.add_theme_constant_override("separation", UIThemeManager.get_spacing("md"))
	add_child(main_container)

	# Create title bar
	_create_title_bar()
	main_container.add_child(title_bar)

	# Create search container (initially hidden)
# FIXED: Orphaned code - var search_label = UIComponentFactory.create_label("Search:", "caption")
	search_field = UIComponentFactory.create_text_input("Search content...")

	search_container.add_child(search_label)
	search_container.add_child(search_field)
	search_container.visible = show_search


var section_widget = _create_section_widget(section_id, config)
	sections[section_id] = section_widget
	content_container.add_child(section_widget)

	_log("Added section: " + section_id)


# FIXED: Orphaned code - var section_widget_2 = sections[section_id]
	content_container.remove_child(section_widget)
	section_widget.queue_free()

	sections.erase(section_id)
	section_configs.erase(section_id)
	section_order.erase(section_id)


# FIXED: Orphaned code - var section_widget_3 = sections[section_id]
var content_type = section_configs[section_id].get("content_type", "text")

	_update_section_content(section_widget, content_type, content_data)
	content_changed.emit(section_id, content_data)


# FIXED: Orphaned code - var section_container = VBoxContainer.new()
	section_container.name = section_id + "_section"

	# Section header
var header = _create_section_header(section_id, config)
	section_container.add_child(header)

	# Section content
var content = _create_section_content(section_id, config)
	section_container.add_child(content)

	# Store references
	section_container.set_meta("header", header)
	section_container.set_meta("content", content)
	section_container.set_meta("config", config)

# FIXED: Orphaned code - var header_container = HBoxContainer.new()

# Section title
var title = UIComponentFactory.create_label(
	config.get("title", section_id.capitalize()), "subheading"
	)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header_container.add_child(title)

	# Collapse button (if collapsible)
# FIXED: Orphaned code - var collapse_btn = UIComponentFactory.create_button(
	"▼", "icon", {"custom_minimum_size": Vector2(24, 24)}
	)
	collapse_btn.tooltip_text = "Toggle section"
	collapse_btn.pressed.connect(_on_section_toggle.bind(section_id))
	header_container.add_child(collapse_btn)

	# Store reference for rotation animation
	header_container.set_meta("collapse_button", collapse_btn)

# FIXED: Orphaned code - var content_type_2 = config.get("content_type", "text")

"rich_text":
var rich_text = RichTextLabel.new()
	rich_text.name = "content"
	rich_text.bbcode_enabled = true
	rich_text.fit_content = true
	rich_text.scroll_active = false
	rich_text.custom_minimum_size.y = 60

	UIThemeManager.apply_rich_text_styling(rich_text, UIThemeManager.FONT_SIZE_MEDIUM)
# FIXED: Orphaned code - var list_container = VBoxContainer.new()
	list_container.name = "content"
	list_container.add_theme_constant_override("separation", UIThemeManager.get_spacing("sm"))
# FIXED: Orphaned code - var grid_container = GridContainer.new()
	grid_container.name = "content"
	grid_container.columns = 2
	grid_container.add_theme_constant_override("h_separation", UIThemeManager.get_spacing("sm"))
	grid_container.add_theme_constant_override("v_separation", UIThemeManager.get_spacing("sm"))
# FIXED: Orphaned code - var cards_container = VBoxContainer.new()
	cards_container.name = "content"
	cards_container.add_theme_constant_override("separation", UIThemeManager.get_spacing("md"))
# FIXED: Orphaned code - var buttons_container = VBoxContainer.new()
	buttons_container.name = "content"
	buttons_container.add_theme_constant_override("separation", UIThemeManager.get_spacing("sm"))
# FIXED: Orphaned code - var label = UIComponentFactory.create_label("", "body")
	label.name = "content"
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
var content_node = section_widget.get_meta("content")

"rich_text":
	_update_rich_text_content(content_node, data)
	"list":
		_update_list_content(content_node, data)
		"grid":
			_update_grid_content(content_node, data)
			"cards":
				_update_cards_content(content_node, data)
				"buttons":
					_update_buttons_content(content_node, data)
					_:
						_update_text_content(content_node, data)


# FIXED: Orphaned code - var text = data.get("text", "")
# FIXED: Orphaned code - var subtitle = data.get("subtitle", "")

# FIXED: Orphaned code - var items = data.get("items", [])
# FIXED: Orphaned code - var empty_label = UIComponentFactory.create_label("No items available", "caption")
	list_container.add_child(empty_label)

	# Add list items
var item_container = HBoxContainer.new()

# Bullet point
var bullet = UIComponentFactory.create_label("•", "body")
	bullet.custom_minimum_size.x = 20
var bullet_color = Color.from_hsv(float(i) * 0.15, 0.6, 0.9)
	bullet.add_theme_color_override("font_color", bullet_color)

	# Item text
var item_label = UIComponentFactory.create_label(str(items[i]), "body")
	item_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	item_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	item_container.add_child(bullet)
	item_container.add_child(item_label)
	list_container.add_child(item_container)


# FIXED: Orphaned code - var connections = data.get("connections", [])
# FIXED: Orphaned code - var label_2 = UIComponentFactory.create_label(connection.get("name", "Unknown"), "caption")
# FIXED: Orphaned code - var strength = UIComponentFactory.create_progress_bar(100.0)
	strength.value = connection.get("strength", 0) * 100

	grid_container.add_child(label)
	grid_container.add_child(strength)


# FIXED: Orphaned code - var cards = data.get("cards", [])
# FIXED: Orphaned code - var card = _create_content_card(card_data)
	cards_container.add_child(card)


# FIXED: Orphaned code - var buttons = data.get("buttons", [])
# FIXED: Orphaned code - var button = UIComponentFactory.create_button(
	button_data.get("text", "Button"), button_data.get("style", "secondary")
	)
	button.pressed.connect(_on_action_button_pressed.bind(button_data.get("action", "")))
	buttons_container.add_child(button)


# FIXED: Orphaned code - var card_2 = UIComponentFactory.create_panel("default")
# FIXED: Orphaned code - var card_content = VBoxContainer.new()

# Card title
var title_2 = UIComponentFactory.create_label(card_data.title, "subheading")
	card_content.add_child(title)

	# Card description
var desc = UIComponentFactory.create_label(card_data.description, "body")
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	card_content.add_child(desc)

	card.add_child(card_content)
# FIXED: Orphaned code - var section_widget_4 = sections[section_id]
var content_node_2 = section_widget.get_meta("content")
# FIXED: Orphaned code - var header_node = section_widget.get_meta("header")
# FIXED: Orphaned code - var collapse_btn_2 = header_node.get_meta("collapse_button")

# FIXED: Orphaned code - var is_visible = content_node.visible
	content_node.visible = not is_visible

	# Animate collapse button rotation
var tween = create_tween()
# FIXED: Orphaned code - var target_rotation = PI if not is_visible else 0
	tween.tween_property(collapse_btn, "rotation", target_rotation, 0.2)

	section_toggled.emit(section_id, not is_visible)


# FIXED: Orphaned code - var search_lower = search_text.to_lower()

# FIXED: Orphaned code - var section_config = section_configs[section_id]
var title_3 = section_config.get("title", "").to_lower()
# FIXED: Orphaned code - var visible = title.contains(search_lower)

	set_section_visibility(section_id, visible)


# FIXED: Orphaned code - var section_widget_5 = sections[section_id]
var config = section_widget.get_meta("config")
# FIXED: Orphaned code - var result = []

func add_section(section_id: String, config: Dictionary) -> void:
	"""Add a new section to the panel"""
	if section_id in sections:
		_log("Section already exists: " + section_id, "warning")
		return

		section_configs[section_id] = config
		section_order.append(section_id)

func remove_section(section_id: String) -> void:
	"""Remove a section from the panel"""
	if not section_id in sections:
		return

func update_section_content(section_id: String, content_data: Dictionary) -> void:
	"""Update content for a specific section"""
	if not section_id in sections:
		_log("Section not found: " + section_id, "warning")
		return

func set_section_visibility(section_id: String, visible: bool) -> void:
	"""Show/hide a section"""
	if not section_id in sections:
		return

		sections[section_id].visible = visible
		section_toggled.emit(section_id, visible)


func clear_all_content() -> void:
	"""Clear content from all sections"""
	for section_id in sections:
		update_section_content(section_id, {})


func load_structure_data(structure_data: Dictionary) -> void:
	"""Load brain structure data into appropriate sections"""
	# Update header section
	if "header" in sections:
		update_section_content(
		"header",
		{
		"text": structure_data.get("displayName", "Unknown Structure"),
		"subtitle": structure_data.get("id", "")
		}
		)

		# Update description section
		if "description" in sections:
			update_section_content(
			"description",
			{"text": structure_data.get("shortDescription", "No description available.")}
			)

			# Update functions section
			if "functions" in sections:
				update_section_content("functions", {"items": structure_data.get("functions", [])})

				# Update connections section if available
				if "connections" in sections and structure_data.has("connections"):
					update_section_content(
					"connections", {"connections": structure_data.get("connections", [])}
					)


					# === SECTION CREATION ===
func get_section_data(section_id: String) -> Dictionary:
	"""Get current data for a section"""
	if not section_id in sections:
		return {}

func get_all_sections_data() -> Array:
	"""Get data for all sections"""

if show_search:
	_create_search_container()
	main_container.add_child(search_container)

	# Create content area
	_create_content_area()
	main_container.add_child(scroll_container)


return section_container


if collapsible_sections and config.get("collapsible", true):
return header_container


return _create_rich_text_content()
"list":
	return _create_list_content()
	"grid":
		return _create_grid_content()
		"cards":
			return _create_cards_content()
			"buttons":
				return _create_buttons_content()
				_:
					return _create_text_content()


return rich_text


return list_container


return grid_container


return cards_container


return buttons_container


return label


# === CONTENT UPDATES ===
if subtitle != "":
	text = (
	"[font_size=18][b]"
	+ text
	+ "[/b][/font_size]\n[font_size=12][color=#B0B0C0]"
	+ subtitle
	+ "[/color][/font_size]"
	)

	rich_text.text = text


if items.is_empty():
for i in range(items.size()):
for connection in connections:
for card_data in cards:
for button_data in buttons:
if card_data.has("title"):
if card_data.has("description"):
return card


# === EVENT HANDLERS ===
if collapse_btn:
for section_id in sections:
return {
"id": section_id,
"title": config.get("title", ""),
"content_type": config.get("content_type", "text"),
"visible": section_widget.visible
}


for section_id in section_order:
	result.append(get_section_data(section_id))
	return result

func _setup_component() -> void:
	"""Setup the modular panel structure"""
	super._setup_component()

	_create_panel_structure()
	_setup_default_sections()
	_connect_panel_signals()


func _create_panel_structure() -> void:
	"""Create the basic panel structure"""
	# Main container with proper styling
	custom_minimum_size = Vector2(320, 400)

	# Apply enhanced panel styling
	UIThemeManager.apply_enhanced_panel_style(self, "elevated")

	# Main layout container
func _create_title_bar() -> void:
	"""Create the panel title bar"""
	title_bar = HBoxContainer.new()
	title_bar.name = "TitleBar"

	# Title label
	title_label = UIComponentFactory.create_label(panel_title, "heading")
	title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_bar.add_child(title_label)

	# Close button
	if closeable:
		close_button = UIComponentFactory.create_button(
		"✕", "icon", {"custom_minimum_size": Vector2(32, 32)}
		)
		close_button.tooltip_text = "Close panel"
		title_bar.add_child(close_button)


func _create_search_container() -> void:
	"""Create search functionality"""
	search_container = VBoxContainer.new()
	search_container.name = "SearchContainer"

func _create_content_area() -> void:
	"""Create scrollable content area"""
	scroll_container = ScrollContainer.new()
	scroll_container.name = "ScrollContainer"
	scroll_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll_container.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED

	content_container = VBoxContainer.new()
	content_container.name = "ContentContainer"
	content_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content_container.add_theme_constant_override("separation", UIThemeManager.get_spacing("md"))

	scroll_container.add_child(content_container)


func _setup_default_sections() -> void:
	"""Setup default sections for brain structure info"""
	add_section("header", SECTION_TYPES.header)
	add_section("description", SECTION_TYPES.description)
	add_section("functions", SECTION_TYPES.functions)
	add_section("connections", SECTION_TYPES.connections)


func _connect_panel_signals() -> void:
	"""Connect panel signals"""
	if close_button:
		close_button.pressed.connect(_on_close_pressed)

		if search_field:
			search_field.text_changed.connect(_on_search_text_changed)


			# === PUBLIC API ===
func _create_section_widget(section_id: String, config: Dictionary) -> Control:
	"""Create a section widget based on configuration"""
func _create_section_header(section_id: String, config: Dictionary) -> Control:
	"""Create section header with title and optional collapse button"""
func _create_section_content(section_id: String, config: Dictionary) -> Control:
	"""Create section content based on content type"""
func _create_rich_text_content() -> Control:
	"""Create rich text content area"""
func _create_list_content() -> Control:
	"""Create list content area"""
func _create_grid_content() -> Control:
	"""Create grid content area"""
func _create_cards_content() -> Control:
	"""Create cards content area"""
func _create_buttons_content() -> Control:
	"""Create buttons content area"""
func _create_text_content() -> Control:
	"""Create simple text content area"""
func _update_section_content(
	section_widget: Control, content_type: String, data: Dictionary
	) -> void:
		"""Update section content based on type"""
func _update_rich_text_content(rich_text: RichTextLabel, data: Dictionary) -> void:
	"""Update rich text content"""
func _update_list_content(list_container: VBoxContainer, data: Dictionary) -> void:
	"""Update list content"""
	# Clear existing items
	for child in list_container.get_children():
		child.queue_free()

func _update_grid_content(grid_container: GridContainer, data: Dictionary) -> void:
	"""Update grid content"""
	# Clear existing content
	for child in grid_container.get_children():
		child.queue_free()

func _update_cards_content(cards_container: VBoxContainer, data: Dictionary) -> void:
	"""Update cards content"""
	# Clear existing cards
	for child in cards_container.get_children():
		child.queue_free()

func _update_buttons_content(buttons_container: VBoxContainer, data: Dictionary) -> void:
	"""Update buttons content"""
	# Clear existing buttons
	for child in buttons_container.get_children():
		child.queue_free()

func _update_text_content(label: Label, data: Dictionary) -> void:
	"""Update simple text content"""
	label.text = data.get("text", "")


func _create_content_card(card_data: Dictionary) -> Control:
	"""Create a content card"""
func _on_close_pressed() -> void:
	"""Handle close button press"""
	if animation_enabled:
		animate_hide()
		else:
			visible = false
			panel_closed.emit()


func _on_section_toggle(section_id: String) -> void:
	"""Handle section collapse/expand"""
func _on_search_text_changed(text: String) -> void:
	"""Handle search text changes"""
	if text.is_empty():
		_show_all_sections()
		else:
			_filter_sections(text)


func _on_action_button_pressed(action: String) -> void:
	"""Handle action button presses"""
	action_triggered.emit(action, {})


	# === UTILITY METHODS ===
func _show_all_sections() -> void:
	"""Show all sections"""
	for section_id in sections:
		set_section_visibility(section_id, true)


func _filter_sections(search_text: String) -> void:
	"""Filter sections based on search text"""
