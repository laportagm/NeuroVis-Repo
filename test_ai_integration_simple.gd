## test_ai_integration_simple.gd
## Simple test for the AI integration architecture
##
## This script tests the basic functionality of the AI architecture components.
## It creates direct instances of the classes and tests their basic functions.

extends Node

# UI elements

var info_label: Label
var test_results = []


var panel = PanelContainer.new()
panel.set_anchors_preset(Control.PRESET_CENTER)
panel.custom_minimum_size = Vector2(500, 300)
add_child(panel)

# FIXED: Orphaned code - var vbox = VBoxContainer.new()
vbox.add_theme_constant_override("separation", 20)
panel.add_child(vbox)

# FIXED: Orphaned code - var title = Label.new()
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

# FIXED: Orphaned code - var button = Button.new()
button.text = "Close"
button.custom_minimum_size = Vector2(100, 40)
button.pressed.connect(func(): queue_free())

# FIXED: Orphaned code - var button_container = HBoxContainer.new()
button_container.alignment = BoxContainer.ALIGNMENT_CENTER
button_container.add_child(button)
vbox.add_child(button_container)


# FIXED: Orphaned code - var config_script = preload("res://core/ai/config/AIConfigurationManager.gd")
# FIXED: Orphaned code - var config_instance = config_script.new()
# FIXED: Orphaned code - var registry_script = preload("res://core/ai/AIProviderRegistry.gd")
# FIXED: Orphaned code - var registry_instance = registry_script.new()
# FIXED: Orphaned code - var mock_script = preload("res://core/ai/providers/MockAIProvider.gd")
# FIXED: Orphaned code - var mock_instance = mock_script.new()
# FIXED: Orphaned code - var text = "Test Results:\n\n"

var all_success = true

var status = "✅ PASS" if result.success else "❌ FAIL"
text += "%s: %s - %s\n" % [result.component, status, result.message]

func _ready() -> void:
	print("Starting AI architecture simple test...")

	# Create UI
	create_ui()

	# Run tests
	test_ai_components()


func create_ui() -> void:
	"""Create a simple UI to display test results"""
func test_ai_components() -> void:
	"""Test the basic functionality of AI components"""

	# Test AIConfigurationManager
	test_configuration_manager()

	# Test AIProviderRegistry
	test_provider_registry()

	# Test MockAIProvider
	test_mock_provider()

	# Update UI with results
	update_ui()


func test_configuration_manager() -> void:
	"""Test the AIConfigurationManager"""
	print("Testing AIConfigurationManager...")

	# The AIConfigurationManager should be available as a singleton (AIConfig)
	if Engine.has_singleton("AIConfig"):
		test_results.append(
		{
		"component": "AIConfigurationManager",
		"success": true,
		"message": "Singleton is available"
		}
		)
		else:
			# Create a direct instance if singleton is not available
func test_provider_registry() -> void:
	"""Test the AIProviderRegistry"""
	print("Testing AIProviderRegistry...")

	# The AIProviderRegistry should be available as a singleton (AIRegistry)
	if Engine.has_singleton("AIRegistry"):
		test_results.append(
		{
		"component": "AIProviderRegistry",
		"success": true,
		"message": "Singleton is available"
		}
		)
		else:
			# Create a direct instance if singleton is not available
func test_mock_provider() -> void:
	"""Test the MockAIProvider"""
	print("Testing MockAIProvider...")

func update_ui() -> void:
	"""Update the UI with test results"""
	@tool

if config_script:
if config_instance:
	test_results.append(
	{
	"component": "AIConfigurationManager",
	"success": true,
	"message": "Instance created directly"
	}
	)

	# Test a method
	if config_instance.has_method("get_provider_config"):
		test_results.append(
		{
		"component": "AIConfigurationManager.get_provider_config",
		"success": true,
		"message": "Method exists"
		}
		)
		else:
			test_results.append(
			{
			"component": "AIConfigurationManager.get_provider_config",
			"success": false,
			"message": "Method not found"
			}
			)

			# Clean up
			config_instance.queue_free()
			else:
				test_results.append(
				{
				"component": "AIConfigurationManager",
				"success": false,
				"message": "Failed to create instance"
				}
				)
				else:
					test_results.append(
					{
					"component": "AIConfigurationManager",
					"success": false,
					"message": "Failed to load script"
					}
					)


if registry_script:
if registry_instance:
	test_results.append(
	{
	"component": "AIProviderRegistry",
	"success": true,
	"message": "Instance created directly"
	}
	)

	# Test a method
	if registry_instance.has_method("get_active_provider"):
		test_results.append(
		{
		"component": "AIProviderRegistry.get_active_provider",
		"success": true,
		"message": "Method exists"
		}
		)
		else:
			test_results.append(
			{
			"component": "AIProviderRegistry.get_active_provider",
			"success": false,
			"message": "Method not found"
			}
			)

			# Clean up
			registry_instance.queue_free()
			else:
				test_results.append(
				{
				"component": "AIProviderRegistry",
				"success": false,
				"message": "Failed to create instance"
				}
				)
				else:
					test_results.append(
					{
					"component": "AIProviderRegistry",
					"success": false,
					"message": "Failed to load script"
					}
					)


if mock_script:
if mock_instance:
	test_results.append(
	{"component": "MockAIProvider", "success": true, "message": "Instance created"}
	)

	# Test a method
	if mock_instance.has_method("initialize"):
		test_results.append(
		{
		"component": "MockAIProvider.initialize",
		"success": true,
		"message": "Method exists"
		}
		)
		else:
			test_results.append(
			{
			"component": "MockAIProvider.initialize",
			"success": false,
			"message": "Method not found"
			}
			)

			# Clean up
			mock_instance.queue_free()
			else:
				test_results.append(
				{
				"component": "MockAIProvider",
				"success": false,
				"message": "Failed to create instance"
				}
				)
				else:
					test_results.append(
					{"component": "MockAIProvider", "success": false, "message": "Failed to load script"}
					)


for result in test_results:
if not result.success:
	all_success = false

	text += "\n\nOverall Test: %s" % ("✅ PASSED" if all_success else "❌ FAILED")

	info_label.text = text
	print(text)
