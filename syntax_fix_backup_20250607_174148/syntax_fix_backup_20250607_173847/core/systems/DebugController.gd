class_name DebugController
extends Control

# Preload DebugVisualizer class
class_name ModelSwitcherTest
extends Node

# Signal to report test results

signal test_completed(test_name: String, success: bool, message: String)

# References to child nodes
@onready
signal test_completed(success: bool, message: String)

# Initialize references

const DebugVisualizer = prepreprepreload("res://core/visualization/DebugVisualizer.gd")

# Signal when a test is completed

var test_results_container = $VBoxContainer/TabContainer/TestResults/TestResults/ResultsContainer
var debug_visualizations_enabled: bool = true
var show_raycasts: bool = true
var show_collision_shapes: bool = true
var show_model_labels: bool = true

# Reference to scenes
var main_scene_path = "res://scenes/node_3d.tscn"
var main_scene_instance = null
var test_container_path = "res://tests"


	var info_label = Label.new()
	info_label.text = "Select a test to run from the toolbar above"
	test_results_container.add_child(info_label)

	# Check if the test directory exists and create it if not
	var dir = DirAccess.open("res://")
	if not dir.dir_exists("tests"):
		dir.make_dir("tests")
		_log_message("Created tests directory")


	var test_scripts = _get_test_scripts()

	for test_script in test_scripts:
		_run_test(test_script)

	# Run the new direct script tests
	var direct_tests = [
		"ui_info_panel_test",
		"knowledge_base_test",
		"camera_controls_test",
		"structure_selection_test"
	]
	for test_name in direct_tests:
		_run_direct_script_test(test_name)

	_update_status("All tests completed")


	var test_name = test_script.get_file().get_basename()
	var test_header = Label.new()
	test_header.text = "Running test: " + test_name
	test_results_container.add_child(test_header)

	# Load test scene
	var test_scene = load(test_script)
	if not test_scene:
		_log_test_result(test_name, false, "Failed to load test script")
		return

	# Instance test scene
	var test_instance = test_scene.instantiate()
	if not test_instance:
		_log_test_result(test_name, false, "Failed to instantiate test")
		return

	# Connect test completed signal
	if test_instance.has_signal("test_completed"):
		test_instance.test_completed.connect(
			func(success, message): _log_test_result(test_name, success, message)
		)

	# Add to scene tree
	add_child(test_instance)

	# If the test has a run method, call it
	if test_instance.has_method("run_test"):
		test_instance.run_test()

	# Clean up
	await get_tree().create_timer(1.0).timeout
	test_instance.queue_free()


	var is_direct_script_test = (
		test_name
		in [
			"ui_info_panel_test",
			"knowledge_base_test",
			"camera_controls_test",
			"structure_selection_test"
		]
	)

	if is_direct_script_test:
		_run_direct_script_test(test_name)
		return

	# Run the test scene
	var test_path = "res://tests/" + test_name + ".tscn"
	if FileAccess.file_exists(test_path):
		_run_scene(test_path)
	else:
		_log_message("Test scene not found: " + test_path, true)
		_update_status("Test not found")


	var scene = load(scene_path)
	if not scene:
		_log_message("Failed to load scene: " + scene_path, true)
		_update_status("Failed to load scene")
		return

	main_scene_instance = scene.instantiate()
	if not main_scene_instance:
		_log_message("Failed to instantiate scene: " + scene_path, true)
		_update_status("Failed to instantiate scene")
		return

	# Add debug component to scene if it's the main scene
	if scene_path == main_scene_path:
		_add_debug_component_to_scene(main_scene_instance)

	# Add to scene tree
	add_child(main_scene_instance)

	_log_message("Running scene: " + scene_path)
	_update_status("Running scene: " + scene_path.get_file())

	# Refresh scene tree
	_refresh_scene_tree()


	var debug_visualizer = preprepreload("res://core/visualization/DebugVisualizer.gd").new()
	debug_visualizer.name = "DebugVisualizer"
	debug_visualizer.visualizations_enabled = debug_visualizations_enabled
	debug_visualizer.show_raycasts = show_raycasts
	debug_visualizer.show_collision_shapes = show_collision_shapes
	debug_visualizer.show_model_labels = show_model_labels

	scene_instance.add_child(debug_visualizer)
	_log_message("Added debug visualizer to scene")


	var result_label = Label.new()
	if success:
		result_label.text = "✓ " + test_name + ": " + message
		result_label.add_theme_color_override("font_color", Color(0, 0.8, 0, 1))
	else:
		result_label.text = "❌ " + test_name + ": " + message
		result_label.add_theme_color_override("font_color", Color(0.8, 0, 0, 1))

	test_results_container.add_child(result_label)

	# Also log to debug output
	_log_message("Test " + test_name + ": " + ("Passed" if success else "Failed") + " - " + message)


	var time = Time.get_time_string_from_system()
	var formatted_message = "[" + time + "] " + message

	# Print to console
	if is_error:
		printerr(formatted_message)
	else:
		print(formatted_message)

	# Add to debug log
	var message_label = Label.new()
	message_label.text = formatted_message
	if is_error:
		message_label.add_theme_color_override("font_color", Color(0.8, 0, 0, 1))

	debug_messages.add_child(message_label)

	# Auto-scroll to bottom
	await get_tree().process_frame
	var scroll_container = debug_messages.get_parent().get_parent()
	scroll_container.scroll_vertical = scroll_container.get_v_scroll_bar().max_value


	var root = scene_tree.create_item()
	root.set_text(0, "Scene Tree")

	# Add child nodes
	if main_scene_instance:
		_add_node_to_tree(root, main_scene_instance)


	var item = scene_tree.create_item(parent_item)

	# Format node info
	var node_class = node.get_class()
	var node_name = node.name

	item.set_text(0, node_name + " (" + node_class + ")")

	# Add children
	for child in node.get_children():
		_add_node_to_tree(item, child)


	var test_header = Label.new()
	test_header.text = "Running test: " + test_name
	test_results_container.add_child(test_header)

	# Check if the script exists
	var script_path = "res://tests/" + test_name + ".gd"
	if not FileAccess.file_exists(script_path):
		_log_message("Test script not found: " + script_path, true)
		_log_test_result(test_name, false, "Script not found: " + script_path)
		return

	# Make sure we have main scene running
	if main_scene_instance == null or not main_scene_instance.get_class() == "Node3D":
		# Try to launch main scene first
		_run_scene(main_scene_path)
		await get_tree().create_timer(0.5).timeout

	# Load the test script
	var test_script = load(script_path)
	if not test_script:
		_log_message("Failed to load test script: " + script_path, true)
		_log_test_result(test_name, false, "Failed to load test script")
		return

	# Instance the test script
	var test_instance = test_script.new()
	if not test_instance:
		_log_message("Failed to instantiate test: " + test_name, true)
		_log_test_result(test_name, false, "Failed to instantiate test")
		return

	# Connect to the test completed signal
	if test_instance.has_signal("test_completed"):
		test_instance.test_completed.connect(
			func(success, message): _log_test_result(test_name, success, message)
		)

	# Add to scene tree
	add_child(test_instance)

	# Run the test
	if test_instance.has_method("run_test"):
		test_instance.run_test()

	# Set a timeout to remove the test instance
	var cleanup_timer = Timer.new()
	add_child(cleanup_timer)
	cleanup_timer.wait_time = 5.0  # Allow up to 5 seconds for test to complete
	cleanup_timer.one_shot = true
	cleanup_timer.timeout.connect(
		func():
			if test_instance and is_instance_valid(test_instance):
				test_instance.queue_free()
			cleanup_timer.queue_free()
	)
	cleanup_timer.start()


	var test_scripts = []
	var dir = DirAccess.open(test_container_path)

	if not dir:
		_log_message("Failed to open test directory", true)
		return test_scripts

	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if file_name.ends_with(".gd") and not file_name.begins_with("."):
			test_scripts.append(test_container_path + "/" + file_name)
		file_name = dir.get_next()

	return test_scripts


	var dir = DirAccess.open("res://")
	if not dir.dir_exists("tests"):
		dir.make_dir("tests")

	# Create model switcher test script
	var script_path = "res://tests/model_switcher_test.gd"
	var script_content = """
var main_scene = null
var model_switcher = null
var model_control_panel = null
var timer = null

	var main_scene = get_tree().current_scene
	if main_scene.get_class() == "Control" and main_scene.name == "DebugScene":
		for child in main_scene.get_children():
			if child.get_class() == "Node3D" and child.name == "MainScene":
				main_scene = child
				break

	if not main_scene or main_scene.get_class() != "Node3D":
		_report_failure("Failed to get main scene")
		return

	print("Test 1: Checking for model switcher reference")
	model_switcher = main_scene.model_switcher
	if not model_switcher:
		_report_failure("Failed to find model_switcher in main scene")
		return
	print("✓ Model switcher found")

	print("Test 2: Checking for model control panel")
	model_control_panel = main_scene.model_control_panel
	if not model_control_panel:
		_report_failure("Failed to find model_control_panel in main scene")
		return
	print("✓ Model control panel found")

	print("Test 3: Checking for registered models")
	var model_names = model_switcher.get_model_names()
	if model_names.size() == 0:
		_report_failure("No models registered with model_switcher")
		return
	print("✓ Found " + str(model_names.size()) + " registered models: " + str(model_names))

	print("Test 4: Testing model visibility toggling")
	# Test toggling the first model
	if model_names.size() > 0:
		var test_model_name = model_names[0]
		var initial_visibility = model_switcher.is_model_visible(test_model_name)

		print("  - Initial visibility of " + test_model_name + ": " + str(initial_visibility))
		print("  - Toggling visibility...")

		# Toggle via model switcher
		model_switcher.toggle_model_visibility(test_model_name)

		# Check if toggle worked
		var new_visibility = model_switcher.is_model_visible(test_model_name)
		print("  - New visibility: " + str(new_visibility))

		if new_visibility == initial_visibility:
			_report_failure("Failed to toggle model visibility")
			return

		# Toggle back to initial state
		model_switcher.toggle_model_visibility(test_model_name)
		print("  - Reset to initial visibility")

		print("✓ Model visibility toggle works")

	print("Test 5: Testing UI control connection")
	if model_names.size() > 0:
		var test_model_name = model_names[0]

		# Check if model control panel has method to update button state
		if not model_control_panel.has_method("update_button_state"):
			_report_failure("Model control panel doesn't have expected method")
			return

		print("  - UI control methods verified")

		# Check buttons exist in UI
		var has_buttons = false
		if model_control_panel.has_node("MarginContainer/VBoxContainer/ModelsContainer"):
			for child in model_control_panel.get_node("MarginContainer/VBoxContainer/ModelsContainer").get_children():
				if child is CheckButton:
					has_buttons = true
					break
		else:
			print("  - Warning: ModelsContainer node path not found")

		if not has_buttons:
			_report_failure("Model control panel doesn't have expected buttons")
			return

		print("✓ UI control setup verified")

	print("Test 6: Validating model references")
	var brain_model_parent = main_scene.brain_model_parent
	if not brain_model_parent:
		_report_failure("Brain model parent not found")
		return

	if brain_model_parent.get_child_count() == 0:
		_report_failure("No model children found in brain_model_parent")
		return

	print("✓ Model references valid")

	# All tests passed
	_report_success("All model switcher tests passed successfully!")

	var script_file = FileAccess.open(script_path, FileAccess.WRITE)
	script_file.store_string(script_content)
	script_file.close()

	# Create model switcher test scene
	var scene_path = "res://tests/model_switcher_test.tscn"

	# Create the scene programmatically since we can't use Godot's scene editor here
	var scene_content = """[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://tests/model_switcher_test.gd" id="1_jcwed"]

[node name="ModelSwitcherTest" type="Node"]
script = ExtResource("1_jcwed")
"""

	# Save the scene
	var scene_file = FileAccess.open(scene_path, FileAccess.WRITE)
	scene_file.store_string(scene_content)
	scene_file.close()

	_log_message("Created model switcher test")

@onready var debug_messages = $VBoxContainer/TabContainer/Debug/LogContainer/DebugMessages
@onready var status_label = $VBoxContainer/StatusBar/StatusLabel
@onready var scene_tree = $VBoxContainer/TabContainer/SceneViewer/ViewerContainer/SceneTree

# Debug settings

func _ready() -> void:
	# Print welcome message
	print("=== NeuroVis Debug Console Started ===")
	_log_message("Debug console initialized")
	_update_status("Ready")

	# Connect to the test_completed signal emitted by test scripts
	self.test_completed.connect(_on_test_completed)

	# Add default test information
func _ready() -> void:
	# Don't run the test automatically in the scene
	if get_parent().name == "tests":
		return

	# Run the test
	run_test()

func run_test() -> void:
	print("\\n===== MODEL SWITCHER TEST SUITE =====")

	# Set up timer for delayed execution
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.5
	timer.one_shot = true
	timer.timeout.connect(_run_tests)
	timer.start()

	print("Model switcher test initialized. Tests will run shortly...")

func _on_run_main_scene_btn_pressed() -> void:
	_run_scene(main_scene_path)


func _on_run_model_switcher_test_pressed() -> void:
	_run_test_scene("model_switcher_test")


func _on_run_info_panel_test_pressed() -> void:
	_run_direct_script_test("ui_info_panel_test")


func _on_run_kb_test_pressed() -> void:
	_run_direct_script_test("knowledge_base_test")


func _on_run_camera_test_pressed() -> void:
	_run_direct_script_test("camera_controls_test")


func _on_run_selection_test_pressed() -> void:
	_run_direct_script_test("structure_selection_test")


func _on_run_all_tests_pressed() -> void:
	_clear_test_results()
	_update_status("Running all tests...")

	# Get all test scripts in the tests directory
func _run_test(test_script: String) -> void:
	# Create test header
func _run_test_scene(test_name: String) -> void:
	_update_status("Running test: " + test_name)

	# Create the model switcher test scene if it doesn't exist
	if (
		test_name == "model_switcher_test"
		and not FileAccess.file_exists("res://tests/model_switcher_test.tscn")
	):
		_create_model_switcher_test()

	# Check if it's a new test without a TSCN file
func _run_scene(scene_path: String) -> void:
	if not FileAccess.file_exists(scene_path):
		_log_message("Scene not found: " + scene_path, true)
		_update_status("Scene not found")
		return

	# Clean up existing instance if any
	if main_scene_instance != null:
		main_scene_instance.queue_free()
		main_scene_instance = null

	# Load and instantiate the scene
func _add_debug_component_to_scene(scene_instance) -> void:
	# Check if scene already has a debug component
	for child in scene_instance.get_children():
		if child is DebugVisualizer:
			return

	# Create and add debug visualizer
func _on_toggle_debug_mode_btn_pressed() -> void:
	debug_visualizations_enabled = !debug_visualizations_enabled
	_update_debug_mode(debug_visualizations_enabled)


func _on_enable_debug_visuals_toggled(enabled: bool) -> void:
	debug_visualizations_enabled = enabled
	_update_debug_mode(debug_visualizations_enabled)


func _on_show_raycasts_toggled(enabled: bool) -> void:
	show_raycasts = enabled
	_update_debug_settings()


func _on_show_collision_shapes_toggled(enabled: bool) -> void:
	show_collision_shapes = enabled
	_update_debug_settings()


func _on_show_model_labels_toggled(enabled: bool) -> void:
	show_model_labels = enabled
	_update_debug_settings()


func _update_debug_mode(enabled: bool) -> void:
	if main_scene_instance == null:
		return

	# Find debug visualizer component
	for child in main_scene_instance.get_children():
		if child is DebugVisualizer:
			child.visualizations_enabled = enabled
			child.show_raycasts = show_raycasts
			child.show_collision_shapes = show_collision_shapes
			child.show_model_labels = show_model_labels
			_log_message("Debug visualizations " + ("enabled" if enabled else "disabled"))
			return

	# If no debug visualizer found, add one
	if enabled:
		_add_debug_component_to_scene(main_scene_instance)


func _update_debug_settings() -> void:
	if main_scene_instance == null:
		return

	# Find debug visualizer component
	for child in main_scene_instance.get_children():
		if child is DebugVisualizer:
			child.show_raycasts = show_raycasts
			child.show_collision_shapes = show_collision_shapes
			child.show_model_labels = show_model_labels
			_log_message("Updated debug visualization settings")
			return


func _on_clear_results_btn_pressed() -> void:
	_clear_test_results()


func _on_clear_log_btn_pressed() -> void:
	_clear_debug_log()


func _on_refresh_btn_pressed() -> void:
	_refresh_scene_tree()


func _on_test_completed(test_name: String, success: bool, message: String) -> void:
	_log_test_result(test_name, success, message)


func _log_test_result(test_name: String, success: bool, message: String) -> void:
func _log_message(message: String, is_error: bool = false) -> void:
	# Add timestamp
func _update_status(message: String) -> void:
	status_label.text = message


func _clear_test_results() -> void:
	for child in test_results_container.get_children():
		child.queue_free()


func _clear_debug_log() -> void:
	for child in debug_messages.get_children():
		child.queue_free()


func _refresh_scene_tree() -> void:
	scene_tree.clear()

	# Create root item
func _add_node_to_tree(parent_item, node) -> void:
func _run_direct_script_test(test_name: String) -> void:
	_update_status("Running test: " + test_name)

	# Create test header in UI
func _get_test_scripts() -> Array:
func _create_model_switcher_test() -> void:
	# Create directory if it doesn't exist
func _run_tests() -> void:
	# Get required references
func _report_success(message: String) -> void:
	print("\\n✓ TEST SUITE PASSED: " + message)
	print("===== END OF MODEL SWITCHER TEST SUITE =====\\n")
	emit_signal("test_completed", true, message)

func _report_failure(message: String) -> void:
	printerr("\\n❌ TEST SUITE FAILED: " + message)
	print("===== END OF MODEL SWITCHER TEST SUITE =====\\n")
	emit_signal("test_completed", false, message)
"""

	# Save the script
