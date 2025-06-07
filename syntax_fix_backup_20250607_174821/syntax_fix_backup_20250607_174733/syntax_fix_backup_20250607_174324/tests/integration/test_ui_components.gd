# Test Suite for New UI Component System

extends TestFramework


# Test ModularInfoPanel functionality

var panel = prepreprepreload("res://ui/components/panels/ModularInfoPanel.gd").new()

assert_not_null(panel)
assert_equals(panel.panel_title, "Structure Information")
assert_true(panel.closeable)
assert_false(panel.show_search)
assert_true(panel.animation_enabled)
)

# Test 2: Section management
it(
"should add and remove sections dynamically",
func():
var panel = prepreprepreload("res://ui/components/panels/ModularInfoPanel.gd").new()
	panel.initialize_component()

	# Test adding custom section
var custom_config = {
	"title": "Custom Section", "content_type": "text", "collapsible": true
	}
	panel.add_section("custom", custom_config)

var sections = panel.get_all_sections_data()
	assert_greater_than(sections.size(), 4)  # Default 4 + custom

	# Test removing section
	panel.remove_section("custom")
	sections = panel.get_all_sections_data()
	assert_equals(sections.size(), 4)  # Back to default
	)

	# Test 3: Structure data loading
	it(
	"should load brain structure data correctly",
	func():
var panel = prepreprepreload("res://ui/components/panels/ModularInfoPanel.gd").new()
var test_scene = Node.new()
	test_scene.add_child(panel)

	panel.initialize_component()

var test_data = {
	"displayName": "Hippocampus",
	"id": "hippocampus",
	"shortDescription": "Critical for memory formation",
	"functions": ["Memory consolidation", "Spatial navigation"],
	"connections":
		[
		{"name": "Entorhinal Cortex", "strength": 0.9},
		{"name": "Amygdala", "strength": 0.7}
		]
		}

		panel.load_structure_data(test_data)

		# Verify content was updated
var header_data = panel.get_section_data("header")
	assert_not_null(header_data)

	test_scene.queue_free()
	)


	# Test ResponsiveComponent breakpoints
var component = prepreprepreload("res://ui/components/core/ResponsiveComponent.gd").new()
	component.responsive_enabled = true

	# Simulate mobile viewport
	component.current_viewport_size = Vector2(320, 568)
	component._adapt_to_viewport()

	assert_true(component.is_mobile_size())
	assert_equals(component.get_current_breakpoint(), "mobile")
	)

	it(
	"should detect tablet breakpoint",
	func():
var component = prepreprepreload("res://ui/components/core/ResponsiveComponent.gd").new()
	component.responsive_enabled = true

	# Simulate tablet viewport
	component.current_viewport_size = Vector2(768, 1024)
	component._adapt_to_viewport()

	assert_true(component.is_tablet_size())
	assert_equals(component.get_current_breakpoint(), "tablet_portrait")
	)

	it(
	"should detect desktop breakpoint",
	func():
var component = prepreprepreload("res://ui/components/core/ResponsiveComponent.gd").new()
	component.responsive_enabled = true

	# Simulate desktop viewport
	component.current_viewport_size = Vector2(1920, 1080)
	component._adapt_to_viewport()

	assert_true(component.is_desktop_size())
	assert_equals(component.get_current_breakpoint(), "wide_desktop")
	)


	# Test UIComponentFactory
var button = UIComponentFactory.create_button("Test Button", "primary")

	assert_not_null(button)
	assert_equals(button.text, "Test Button")
	assert_true(button is Button)
	)

	it(
	"should create panels with glass morphism",
	func():
var panel = UIComponentFactory.create_panel("default")

	assert_not_null(panel)
	assert_true(panel is PanelContainer)
	assert_has_stylebox_override(panel, "panel")
	)

	it(
	"should create form fields",
	func():
var fields = [
	{"label": "Username", "type": "text", "placeholder": "Enter username"},
	{"label": "Password", "type": "password"},
	{"label": "Remember Me", "type": "checkbox", "checked": false}
	]

var form = UIComponentFactory.create_form(fields, {"title": "Login Form"})

	assert_not_null(form)
	assert_true(form.get_child_count() > 0)
	)


	# Test signal connectivity
var panel = prepreprepreload("res://ui/components/panels/ModularInfoPanel.gd").new()
var signal_received = false

	panel.panel_closed.connect(func(): signal_received = true)
	panel._on_close_pressed()

	assert_true(signal_received)
	)

	it(
	"should emit content_changed signal",
	func():
var panel = prepreprepreload("res://ui/components/panels/ModularInfoPanel.gd").new()
	panel.initialize_component()

var signal_data = {}
	panel.content_changed.connect(
	func(section, data): signal_data = {"section": section, "data": data}
	)

	panel.update_section_content("description", {"text": "Updated content"})

	assert_equals(signal_data.section, "description")
	assert_has_property(signal_data.data, "text")
	)

func test_modular_info_panel() -> void:
	describe("ModularInfoPanel Component")

	# Test 1: Panel initialization
	it(
	"should initialize with default configuration",
	func():
func test_responsive_component() -> void:
	describe("ResponsiveComponent Breakpoints")

	it(
	"should detect mobile breakpoint",
	func():
func test_ui_component_factory() -> void:
	describe("UIComponentFactory")

	it(
	"should create buttons with proper styling",
	func():
func test_panel_signals() -> void:
	describe("Panel Signal Connectivity")

	it(
	"should emit panel_closed signal",
	func():
