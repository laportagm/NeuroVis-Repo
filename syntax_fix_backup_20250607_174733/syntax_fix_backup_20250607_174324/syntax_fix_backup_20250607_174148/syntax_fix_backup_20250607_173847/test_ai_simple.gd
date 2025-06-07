## test_ai_simple.gd
## Simple test for the AI integration architecture
##
## This script tests that the classes can be instantiated without errors.
## Use this test to verify basic class structure is correct.
##
## @version: 1.0

extends Node

# UI elements

var info_label: Label


	var panel = PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.custom_minimum_size = Vector2(500, 300)
	add_child(panel)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 20)
	panel.add_child(vbox)

	var title = Label.new()
	title.text = "AI Architecture Simple Test"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 24)
	vbox.add_child(title)

	info_label = Label.new()
	info_label.text = "Testing..."
	info_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	info_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	info_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(info_label)

	var button = Button.new()
	button.text = "Close"
	button.custom_minimum_size = Vector2(100, 40)
	button.pressed.connect(func(): queue_free())

	var button_container = HBoxContainer.new()
	button_container.alignment = BoxContainer.ALIGNMENT_CENTER
	button_container.add_child(button)
	vbox.add_child(button_container)


	var results = []

	# Test AIProviderInterface
	results.append(
		test_class("AIProviderInterface", "res://core/ai/providers/AIProviderInterface.gd")
	)

	# Test AIConfigurationManager
	results.append(
		test_class("AIConfigurationManager", "res://core/ai/config/AIConfigurationManager.gd")
	)

	# Test AIProviderRegistry
	results.append(test_class("AIProviderRegistry", "res://core/ai/AIProviderRegistry.gd"))

	# Test AIIntegrationManager
	results.append(test_class("AIIntegrationManager", "res://core/ai/AIIntegrationManager.gd"))

	# Test MockAIProvider
	results.append(test_class("MockAIProvider", "res://core/ai/providers/MockAIProvider.gd"))

	# Test GeminiAIProvider
	results.append(test_class("GeminiAIProvider", "res://core/ai/providers/GeminiAIProvider.gd"))

	# Update UI with results
	update_ui(results)


	var result = {"class": class_type, "path": path, "success": false, "message": ""}

	# Check if file exists
	if not FileAccess.file_exists(path):
		result.message = "File not found"
		return result

	# Try to load class
	var script = load(path)
	if not script:
		result.message = "Failed to load script"
		return result

	# Try to instantiate class
	var instance = null

	if class_type == "AIProviderInterface":
		# Skip instantiation for interface
		result.success = true
		result.message = "Script loaded (interface)"
	else:
		# Try to instantiate
		instance = script.new()
		if instance:
			result.success = true
			result.message = "Successfully instantiated"
			# Clean up
			if instance is Node:
				instance.queue_free()
			else:
				instance.free()
		else:
			result.message = "Failed to instantiate"

	return result


	var text = "Test Results:\n\n"

	var all_success = true

	for result in results:
		var status = "✅ PASS" if result.success else "❌ FAIL"
		text += "%s: %s - %s\n" % [result.class, status, result.message]

		if not result.success:
			all_success = false

	text += "\n\nOverall Test: %s" % ("✅ PASSED" if all_success else "❌ FAILED")

	info_label.text = text
	print(text)

func _ready() -> void:
	print("Starting simple AI architecture test...")

	# Create UI
	create_ui()

	# Test class loading
	test_class_loading()


func create_ui() -> void:
	"""Create a simple UI to display test results"""
func test_class_loading() -> void:
	"""Test that all classes can be loaded and instantiated"""
func test_class(class_type: String, path: String) -> Dictionary:
	"""Test if a class can be loaded and instantiated"""
	print("Testing class: " + class_type)

func update_ui(results: Array) -> void:
	"""Update the UI with test results"""
@tool
