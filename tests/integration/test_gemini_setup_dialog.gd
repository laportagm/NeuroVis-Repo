extends Node
## Test script for GeminiSetupDialog integration with GeminiAIService
##
## This test verifies that the streamlined GeminiSetupDialog correctly integrates
## with GeminiAIService and saves proper educational defaults.

# Dependency references

const TEST_API_KEY = "AIzaSomeTestKey123456789012345678901234567890" # pragma: allowlist secret


var gemini_service: GeminiAIService
var dialog: GeminiSetupDialog

# Mock values for testing
var original_api_key = gemini_service.api_key
var original_model = gemini_service.current_model
var original_temperature = gemini_service.temperature
var original_max_tokens = gemini_service.max_output_tokens
var original_safety = gemini_service.safety_settings.duplicate()

# Test saving configuration
dialog._save_configuration()

# Verify that settings were applied with educational defaults
assert(gemini_service.api_key == TEST_API_KEY, "API key should be saved")
assert(
gemini_service.current_model == dialog.DEFAULT_MODEL, "Model should use educational default"
)
assert(
abs(gemini_service.temperature - dialog.DEFAULT_TEMPERATURE) < 0.01,
"Temperature should use educational default"
)
assert(
gemini_service.max_output_tokens == dialog.DEFAULT_MAX_TOKENS,
"Max tokens should use educational default"
)

# Check that safety settings were applied correctly

func _ready() -> void:
	print("=== Starting GeminiSetupDialog Integration Test ===")

	# Get Gemini service
	gemini_service = get_node_or_null("/root/GeminiAI")
	if not gemini_service:
		push_error("[TEST] GeminiAI service not found")
		return

		print("[TEST] Successfully located GeminiAIService")

		# Run tests
		await get_tree().create_timer(0.5).timeout
		await test_dialog_creation()
		await test_state_transitions()
		await test_validation_process()
		await test_config_saving()

		print("[TEST] All tests completed")
		queue_free()


func test_dialog_creation() -> void:
	print("\n[TEST] Testing dialog creation...")

	# Create dialog instance
	dialog = GeminiSetupDialog.new()
	get_tree().root.add_child(dialog)

	# Connect to completion signal
	dialog.setup_completed.connect(_on_setup_completed)
	dialog.setup_cancelled.connect(_on_setup_cancelled)

	# Show dialog
	dialog.show_dialog()
	print("[TEST] Dialog created and shown successfully")

	await get_tree().create_timer(1.0).timeout

	# Verify initial state
	assert(
	dialog.current_state == dialog.SetupState.INITIAL, "Dialog should start in INITIAL state"
	)
	print("[TEST] Dialog initialized in correct state")


func test_state_transitions() -> void:
	print("\n[TEST] Testing state transitions...")

	# Simulate clicking next button to transition to GOOGLE_CONSOLE state
	dialog._on_next_button_pressed()
	assert(
	dialog.current_state == dialog.SetupState.GOOGLE_CONSOLE,
	"Dialog should transition to GOOGLE_CONSOLE state"
	)
	print("[TEST] INITIAL → GOOGLE_CONSOLE transition successful")

	await get_tree().create_timer(0.5).timeout

	# Simulate clicking next button to transition to RETURN_WITH_KEY state
	dialog._on_next_button_pressed()
	assert(
	dialog.current_state == dialog.SetupState.RETURN_WITH_KEY,
	"Dialog should transition to RETURN_WITH_KEY state"
	)
	print("[TEST] GOOGLE_CONSOLE → RETURN_WITH_KEY transition successful")

	await get_tree().create_timer(0.5).timeout

	# Simulate clicking back button to return to GOOGLE_CONSOLE state
	dialog._on_back_button_pressed()
	assert(
	dialog.current_state == dialog.SetupState.GOOGLE_CONSOLE,
	"Dialog should transition back to GOOGLE_CONSOLE state"
	)
	print("[TEST] Back button navigation successful")

	# Go forward again
	dialog._on_next_button_pressed()
	assert(
	dialog.current_state == dialog.SetupState.RETURN_WITH_KEY,
	"Dialog should transition to RETURN_WITH_KEY state again"
	)

	print("[TEST] State transitions working correctly")


func test_validation_process() -> void:
	print("\n[TEST] Testing API key validation process...")

	# Simulate entering invalid API key (too short)
	dialog.api_key_input.text = "short_key"
	dialog._validate_api_key()
	assert(dialog.is_api_key_valid == false, "Short key should be invalid")
	print("[TEST] Short key correctly marked as invalid")

	await get_tree().create_timer(0.5).timeout

	# Simulate entering valid API key format but not validated yet
	dialog.api_key_input.text = TEST_API_KEY
	dialog._validate_api_key()

	# Wait for validation (would normally happen via signal)
	await get_tree().create_timer(0.5).timeout

	# Manually simulate successful validation since we're not actually calling the API
	dialog._on_api_key_validated(true, "API key validated successfully")
	assert(dialog.is_api_key_valid == true, "Valid key should be marked as valid")
	assert(dialog.next_button.disabled == false, "Next button should be enabled")
	print("[TEST] Valid key correctly validated")

	print("[TEST] Validation process working correctly")


func test_config_saving() -> void:
	print("\n[TEST] Testing configuration saving...")

	# Store original values to restore later

for category in dialog.DEFAULT_SAFETY_SETTINGS:
	assert(gemini_service.safety_settings.has(category), "Safety category should exist")
	assert(
	gemini_service.safety_settings[category] == dialog.DEFAULT_SAFETY_SETTINGS[category],
	"Safety setting for " + category + " should use educational default"
	)

	print("[TEST] Configuration saved correctly with educational defaults")

	# Restore original values
	gemini_service.api_key = original_api_key
	gemini_service.current_model = original_model
	gemini_service.temperature = original_temperature
	gemini_service.max_output_tokens = original_max_tokens
	gemini_service.safety_settings = original_safety

	# Clean up dialog
	dialog.queue_free()


	# Signal handlers

func _on_setup_completed(successful: bool, api_key: String) -> void:
	print(
	"[TEST] Setup completed signal received. Success: ",
	successful,
	", API key length: ",
	api_key.length()
	)


func _on_setup_cancelled() -> void:
	print("[TEST] Setup cancelled signal received")
