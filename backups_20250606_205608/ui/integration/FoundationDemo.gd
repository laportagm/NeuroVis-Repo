# Foundation Layer Demo - Shows how new systems integrate with existing code
# This demonstrates the migration path and validates foundation layer functionality

extends Control

# === DEPENDENCIES ===

const FeatureFlags = preload("res://core/features/FeatureFlags.gd")
const ComponentRegistry = preload("res://ui/core/ComponentRegistry.gd")
const ComponentStateManager = preload("res://ui/state/ComponentStateManager.gd")
const TestFramework = preload("res://tests/integration/test_component_foundation.gd")

# === UI NODES ===

var status_label: Label
var feature_controls: VBoxContainer
var component_demos: VBoxContainer
var test_button: Button
var results_display: RichTextLabel

# === STATE ===
var demo_running: bool = false


	var main_vbox = VBoxContainer.new()
	add_child(main_vbox)

	# Title
	var title = Label.new()
	title.text = "🏗️ NeuroVis Foundation Layer Demo"
	title.add_theme_font_size_override("font_size", 20)
	main_vbox.add_child(title)

	# Status display
	status_label = Label.new()
	status_label.text = "Initializing foundation layer..."
	status_label.add_theme_color_override("font_color", Color.CYAN)
	main_vbox.add_child(status_label)

	# Test button
	test_button = Button.new()
	test_button.text = "🧪 Run Foundation Tests"
	test_button.pressed.connect(_run_foundation_tests)
	main_vbox.add_child(test_button)

	# Results display
	results_display = RichTextLabel.new()
	results_display.custom_minimum_size = Vector2(600, 300)
	results_display.bbcode_enabled = true
	main_vbox.add_child(results_display)

	# Feature controls section
	var feature_label = Label.new()
	feature_label.text = "🎛️ Feature Flag Controls"
	feature_label.add_theme_font_size_override("font_size", 16)
	main_vbox.add_child(feature_label)

	feature_controls = VBoxContainer.new()
	main_vbox.add_child(feature_controls)

	# Component demos section
	var component_label = Label.new()
	component_label.text = "🧩 Component Demos"
	component_label.add_theme_font_size_override("font_size", 16)
	main_vbox.add_child(component_label)

	component_demos = VBoxContainer.new()
	main_vbox.add_child(component_demos)


	var important_flags = [
		FeatureFlags.UI_MODULAR_COMPONENTS,
		FeatureFlags.UI_COMPONENT_POOLING,
		FeatureFlags.UI_STATE_PERSISTENCE,
		FeatureFlags.ADVANCED_ANIMATIONS,
		FeatureFlags.DEBUG_COMPONENT_INSPECTOR
	]

	for flag_name in important_flags:
		var flag_control = _create_flag_control(flag_name)
		feature_controls.add_child(flag_control)


	var hbox = HBoxContainer.new()

	# Flag toggle
	var checkbox = CheckBox.new()
	checkbox.button_pressed = FeatureFlags.is_enabled(flag_name)
	checkbox.toggled.connect(func(enabled: bool): _on_flag_toggled(flag_name, enabled))
	hbox.add_child(checkbox)

	# Flag name
	var label = Label.new()
	label.text = flag_name.replace("_", " ").capitalize()
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(label)

	# Flag status
	var status = Label.new()
	var status_info = FeatureFlags.get_flag_status(flag_name)
	status.text = status_info.get("source", "unknown")
	status.add_theme_color_override("font_color", Color.GRAY)
	hbox.add_child(status)

	return hbox


	var demos = [
		{"name": "Create Info Panel", "action": "_demo_create_info_panel"},
		{"name": "Test Component Caching", "action": "_demo_component_caching"},
		{"name": "Test State Persistence", "action": "_demo_state_persistence"},
		{"name": "Show Registry Stats", "action": "_demo_registry_stats"},
		{"name": "Legacy vs New System", "action": "_demo_legacy_comparison"}
	]

	for demo in demos:
		var button = Button.new()
		button.text = demo.name
		button.pressed.connect(Callable(self, demo.action))
		component_demos.add_child(button)


	var all_flags = FeatureFlags.get_all_flags()
	for flag_name in all_flags:
		var status = "✅" if all_flags[flag_name] else "❌"
		_log_to_results("%s %s" % [status, flag_name])
	_log_to_results("")


# === EVENT HANDLERS ===
	var test_results = TestFramework.run_foundation_tests()

	# Display results
	_log_to_results("")
	_log_to_results("[b]Test Results:[/b]")
	_log_to_results("Total Tests: %d" % test_results.total_tests)
	_log_to_results("Passed: %d" % test_results.passed_tests)
	_log_to_results("Failed: %d" % test_results.failed_tests)
	_log_to_results("Success Rate: %.1f%%" % test_results.success_rate)

	if test_results.success_rate == 100.0:
		_log_to_results("[color=green]🎉 ALL TESTS PASSED![/color]")
		status_label.text = "🎉 Foundation layer fully validated"
		status_label.add_theme_color_override("font_color", Color.GREEN)
	else:
		_log_to_results("[color=red]⚠️ Some tests failed[/color]")
		status_label.text = "⚠️ Foundation layer has issues"
		status_label.add_theme_color_override("font_color", Color.RED)

	test_button.disabled = false


# === COMPONENT DEMOS ===
	var config = {"structure_name": "hippocampus", "theme": "enhanced"}

	var panel = ComponentRegistry.create_component("info_panel", config)

	if panel:
		_log_to_results("✅ Successfully created info panel: %s" % panel.get_class())
		_log_to_results("   Panel type: %s" % panel.get_meta("component_type", "unknown"))
		_log_to_results(
			(
				"   Creation time: %s"
				% Time.get_datetime_string_from_unix_time(panel.get_meta("creation_time", 0))
			)
		)

		# Cleanup demo panel
		panel.queue_free()
	else:
		_log_to_results("❌ Failed to create info panel")


	var component_id = "demo_cached_panel"
	var config = {"title": "Cached Panel Demo"}

	# First creation
	var start_time = Time.get_ticks_msec()
	var panel1 = ComponentRegistry.get_or_create(component_id, "info_panel", config)
	var creation_time = Time.get_ticks_msec() - start_time

	# Second access (should be cached)
	start_time = Time.get_ticks_msec()
	var panel2 = ComponentRegistry.get_or_create(component_id, "info_panel", config)
	var cache_time = Time.get_ticks_msec() - start_time

	_log_to_results("⏱️ First creation: %d ms" % creation_time)
	_log_to_results("⏱️ Cache access: %d ms" % cache_time)
	_log_to_results("🎯 Same instance: %s" % ("✅" if panel1 == panel2 else "❌"))

	# Show registry stats
	var stats = ComponentRegistry.get_registry_stats()
	_log_to_results("📊 Cache hit ratio: %.1f%%" % (stats.hit_ratio * 100))

	# Cleanup
	ComponentRegistry.release_component(component_id)


	var component_id = "demo_state_component"
	var test_state = {
		"scroll_position": 150,
		"expanded_sections": ["functions", "clinical"],
		"user_notes": "This is a demo note",
		"theme_preference": "enhanced"
	}

	# Save state
	ComponentStateManager.save_component_state(component_id, test_state)
	_log_to_results("💾 Saved state for component: %s" % component_id)

	# Simulate time passing
	await get_tree().process_frame

	# Restore state
	var restored_state = ComponentStateManager.restore_component_state(component_id)

	if not restored_state.is_empty():
		_log_to_results("✅ Successfully restored state:")
		_log_to_results("   Scroll position: %d" % restored_state.get("scroll_position", 0))
		_log_to_results(
			"   Expanded sections: %s" % str(restored_state.get("expanded_sections", []))
		)
		_log_to_results("   User notes: %s" % restored_state.get("user_notes", ""))

		var state_age = ComponentStateManager.get_state_age(component_id)
		_log_to_results("   State age: %.3f seconds" % state_age)
	else:
		_log_to_results("❌ Failed to restore state")

	# Show state stats
	var stats = ComponentStateManager.get_state_stats()
	_log_to_results("📊 Total states: %d" % stats.total_states)
	_log_to_results("📊 Saves performed: %d" % stats.saves_performed)


	var stats = ComponentRegistry.get_registry_stats()

	_log_to_results("Components created: %d" % stats.total_created)
	_log_to_results("Cache hits: %d" % stats.cache_hits)
	_log_to_results("Cache misses: %d" % stats.cache_misses)
	_log_to_results("Hit ratio: %.2f%%" % (stats.hit_ratio * 100))
	_log_to_results("Active components: %d" % stats.active_components)
	_log_to_results("Cached components: %d" % stats.cached_components)
	_log_to_results("Registered factories: %d" % stats.registered_factories)


	var legacy_panel = ComponentRegistry.create_component("info_panel", {})
	_log_to_results(
		"📋 Legacy panel created: %s" % (legacy_panel.get_class() if legacy_panel else "Failed")
	)

	# Test new mode
	ComponentRegistry.set_legacy_mode(false)
	_log_to_results("🔄 Switched to new mode")
	_log_to_results(
		(
			"   Legacy panels: %s"
			% ("✅" if FeatureFlags.is_enabled(FeatureFlags.UI_LEGACY_PANELS) else "❌")
		)
	)
	_log_to_results(
		(
			"   Modular components: %s"
			% ("✅" if FeatureFlags.is_enabled(FeatureFlags.UI_MODULAR_COMPONENTS) else "❌")
		)
	)

	# Create component in new mode
	var new_panel = ComponentRegistry.create_component("info_panel", {})
	_log_to_results("📋 New panel created: %s" % (new_panel.get_class() if new_panel else "Failed"))

	# Cleanup
	if legacy_panel:
		legacy_panel.queue_free()
	if new_panel:
		new_panel.queue_free()


# === UTILITY METHODS ===
	var window = Window.new()
	window.title = "NeuroVis Foundation Demo"
	window.size = Vector2i(800, 600)

	var demo_script = preload("res://ui/integration/FoundationDemo.gd")
	var demo = demo_script.new()
	window.add_child(demo)

	return window

func _ready() -> void:
	_setup_demo_ui()
	_setup_feature_controls()
	_setup_component_demos()
	_run_initial_validation()


func _setup_demo_ui() -> void:
	"""Setup demo interface"""

	# Main layout
func _setup_feature_controls() -> void:
	"""Setup feature flag controls"""

func _create_flag_control(flag_name: String) -> Control:
	"""Create control for a feature flag"""
func _setup_component_demos() -> void:
	"""Setup component demonstration buttons"""

func _run_initial_validation() -> void:
	"""Run initial validation of foundation layer"""
	status_label.text = "✅ Foundation layer loaded successfully"

	_log_to_results("[b]Foundation Layer Status[/b]")
	_log_to_results("FeatureFlags: ✅ Loaded")
	_log_to_results("ComponentRegistry: ✅ Loaded")
	_log_to_results("ComponentStateManager: ✅ Loaded")
	_log_to_results("")

	# Show current flag states
	_log_to_results("[b]Current Feature Flags:[/b]")
func _on_flag_toggled(flag_name: String, enabled: bool) -> void:
	"""Handle feature flag toggle"""
	if enabled:
		FeatureFlags.enable_feature(flag_name)
	else:
		FeatureFlags.disable_feature(flag_name)

	_log_to_results("🎛️ %s: %s" % [flag_name, "enabled" if enabled else "disabled"])


func _run_foundation_tests() -> void:
	"""Run comprehensive foundation tests"""
	_log_to_results("[b]🧪 Running Foundation Tests...[/b]")
	test_button.disabled = true

	# Run tests
func _demo_create_info_panel() -> void:
	"""Demo: Create info panel through new system"""
	_log_to_results("[b]📋 Creating Info Panel Demo[/b]")

	# Enable new systems for demo
	FeatureFlags.enable_feature(FeatureFlags.UI_MODULAR_COMPONENTS)
	FeatureFlags.enable_feature(FeatureFlags.UI_COMPONENT_POOLING)

func _demo_component_caching() -> void:
	"""Demo: Component caching system"""
	_log_to_results("[b]🔄 Component Caching Demo[/b]")

	FeatureFlags.enable_feature(FeatureFlags.UI_COMPONENT_POOLING)

func _demo_state_persistence() -> void:
	"""Demo: State persistence system"""
	_log_to_results("[b]💾 State Persistence Demo[/b]")

	FeatureFlags.enable_feature(FeatureFlags.UI_STATE_PERSISTENCE)

func _demo_registry_stats() -> void:
	"""Demo: Show component registry statistics"""
	_log_to_results("[b]📊 Component Registry Statistics[/b]")

func _demo_legacy_comparison() -> void:
	"""Demo: Compare legacy vs new system"""
	_log_to_results("[b]🔄 Legacy vs New System Comparison[/b]")

	# Test legacy mode
	ComponentRegistry.set_legacy_mode(true)
	_log_to_results("🔄 Switched to legacy mode")
	_log_to_results(
		(
			"   Legacy panels: %s"
			% ("✅" if FeatureFlags.is_enabled(FeatureFlags.UI_LEGACY_PANELS) else "❌")
		)
	)
	_log_to_results(
		(
			"   Modular components: %s"
			% ("✅" if FeatureFlags.is_enabled(FeatureFlags.UI_MODULAR_COMPONENTS) else "❌")
		)
	)

	# Create component in legacy mode
func _log_to_results(message: String) -> void:
	"""Log message to results display"""
	results_display.append_text(message + "\n")
	results_display.scroll_to_line(results_display.get_line_count())


# === STANDALONE DEMO RUNNER ===
static func create_demo_window() -> Window:
	"""Create standalone demo window"""
