extends Node

# Test standalone AI components directly without dependencies on the main scene

# References to the components we're testing

var config_manager
var provider_registry
var mock_provider
var gemini_provider

# UI for displaying test results
var results_label


var panel = PanelContainer.new()
panel.set_anchors_preset(Control.PRESET_CENTER)
panel.custom_minimum_size = Vector2(600, 400)
add_child(panel)

# Add container
var vbox = VBoxContainer.new()
panel.add_child(vbox)

# Add title
var title = Label.new()
title.text = "AI Architecture Minimal Test"
title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
title.add_theme_font_size_override("font_size", 24)
vbox.add_child(title)

# Add results label
results_label = Label.new()
results_label.text = "Running tests..."
results_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
results_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
results_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
results_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
vbox.add_child(results_label)

# Add close button
var button = Button.new()
button.text = "Close"
button.custom_minimum_size = Vector2(100, 40)
button.pressed.connect(func(): get_tree().quit())

# FIXED: Orphaned code - var button_container = HBoxContainer.new()
button_container.alignment = BoxContainer.ALIGNMENT_CENTER
button_container.add_child(button)
vbox.add_child(button_container)


# FIXED: Orphaned code - var result_text = "[%s] %s" % [test_name, "PASS ✅" if success else "FAIL ❌"]
var success = false
var details = ""

# Load class
var AIConfigManagerScript = preload("res://core/ai/config/AIConfigurationManager.gd")

# FIXED: Orphaned code - var config = config_manager.get_provider_config("test_provider")

success = config.has("test") and config.test == true
details = "Successfully created and used configuration manager"
details = "Missing initialize method"
details = "Failed to load AIConfigurationManager script"

log_result("Configuration Manager", success, details)


# FIXED: Orphaned code - var success_2 = false
var details_2 = ""

# Load class
var AIProviderRegistryScript = preload("res://core/ai/AIProviderRegistry.gd")

# FIXED: Orphaned code - var providers = provider_registry.get_all_provider_ids()
success = providers.has("mock_provider")
details = "Successfully created registry with default mock provider"
details = "Missing initialize method"
details = "Failed to load AIProviderRegistry script"

log_result("Provider Registry", success, details)


# FIXED: Orphaned code - var success_3 = false
var details_3 = ""

# Get mock provider from registry
mock_provider = provider_registry.get_provider("mock_provider")

# FIXED: Orphaned code - var setup_status = mock_provider.check_setup_status()
# FIXED: Orphaned code - var response_connected = false

# Connect to signals
var success_4 = false
var details_4 = ""

# Load class
var GeminiAIProviderScript = preload("res://core/ai/providers/GeminiAIProvider.gd")

# FIXED: Orphaned code - var init_result = gemini_provider.initialize()

# Check if HTTP request node was created
success = gemini_provider.http_request != null and init_result
details = "Successfully created and initialized Gemini provider"

# Register with registry
var providers_2 = provider_registry.get_all_provider_ids()
# FIXED: Orphaned code - var success_5 = false
var details_5 = ""

var initial_provider = provider_registry.get_active_provider_id()

# Switch to Gemini
var switch_to_gemini = provider_registry.set_active_provider("gemini")
# FIXED: Orphaned code - var gemini_active = provider_registry.get_active_provider_id() == "gemini"

# Switch back to mock
var switch_to_mock = provider_registry.set_active_provider("mock_provider")
# FIXED: Orphaned code - var mock_active = provider_registry.get_active_provider_id() == "mock_provider"

success = switch_to_gemini and gemini_active and switch_to_mock and mock_active
details = "Successfully switched between providers"
details = "Provider registry not available"

log_result("Provider Switching", success, details)

func _ready():
	print("=== MINIMAL AI ARCHITECTURE TEST ===")

	# Create a simple UI
	setup_ui()

	# Run tests one by one
	test_config_manager()
	test_provider_registry()
	test_mock_provider()
	test_gemini_provider()
	test_provider_switching()

	print("=== TEST COMPLETE ===")


func setup_ui():
	# Create a panel
func log_result(test_name: String, success: bool, details: String = ""):
func test_config_manager():
	print("Testing AIConfigurationManager...")
func test_provider_registry():
	print("Testing AIProviderRegistry...")
func test_mock_provider():
	print("Testing MockAIProvider...")
func test_gemini_provider():
	print("Testing GeminiAIProvider...")
func test_provider_switching():
	print("Testing provider switching...")

if details:
	result_text += " - " + details
	print(result_text)

	# Update UI
	results_label.text += "\n" + result_text


if AIConfigManagerScript:
	# Try to instantiate
	config_manager = AIConfigManagerScript.new()
	add_child(config_manager)

	# Test basic functions
	if config_manager.has_method("initialize"):
		config_manager.initialize()

		# Test provider configuration methods
		config_manager.register_provider("test_provider", {"test": true})
if AIProviderRegistryScript:
	# Try to instantiate
	provider_registry = AIProviderRegistryScript.new()
	add_child(provider_registry)

	# Set the config manager reference
	provider_registry._config_manager = config_manager

	# Test basic functions
	if provider_registry.has_method("initialize"):
		provider_registry.initialize()

		# Check if mock provider was registered
if mock_provider:
	# Test methods
if mock_provider.has_signal("response_received"):
	mock_provider.response_received.connect(
	func(response):
		print("Mock response received: " + response.substr(0, 30) + "...")
		log_result("Mock Provider Response", true, "Got response")
		)
		response_connected = true

		# Set structure context
		if mock_provider.has_method("set_current_structure"):
			mock_provider.set_current_structure("hippocampus")

			# Ask test question
			if mock_provider.has_method("ask_question"):
				mock_provider.ask_question("What does the hippocampus do?")

				success = setup_status and response_connected
				details = "Mock provider functioning correctly"
				else:
					details = "Failed to get mock provider from registry"

					log_result("Mock Provider", success, details)


if GeminiAIProviderScript:
	# Try to instantiate
	gemini_provider = GeminiAIProviderScript.new()
	add_child(gemini_provider)

	# Initialize
	if gemini_provider.has_method("initialize"):
if success and provider_registry.has_method("register_provider"):
	provider_registry.register_provider("gemini", gemini_provider)

	# Check registration
if providers.has("gemini"):
	details += " and registered with registry"
	else:
		success = false
		details += " but failed to register with registry"
		else:
			details = "Missing initialize method"
			else:
				details = "Failed to load GeminiAIProvider script"

				log_result("Gemini Provider", success, details)


if provider_registry:
	# Get current provider
