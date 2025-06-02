extends Node
## Test script for API key validation and auto-save functionality

func _ready() -> void:
	print("=== Testing API Key Validation and Auto-Save ===")
	print("")
	
	# Create and show the dialog
	var dialog = GeminiSetupDialog.new()
	get_tree().root.add_child(dialog)
	dialog.show_dialog()
	
	# Connect to signals
	dialog.setup_completed.connect(_on_setup_completed)
	dialog.setup_cancelled.connect(_on_setup_cancelled)
	
	# Navigate directly to key input state for testing
	dialog.current_state = GeminiSetupDialog.SetupState.RETURN_WITH_KEY
	dialog._show_return_state()
	
	await get_tree().create_timer(2.0).timeout
	
	print("[TEST] Step 1: Testing validation with invalid key")
	print("[TEST] Setting an invalid API key...")
	dialog.api_key_input.text = "AIzaINVALID123456789012345678901234567"
	dialog._on_key_input_changed(dialog.api_key_input.text)
	
	await get_tree().create_timer(1.0).timeout
	
	# Check if button is enabled (it should be, as format looks valid)
	if not dialog.next_button.disabled:
		print("[TEST] ✓ Connect button enabled for valid format")
		print("[TEST] Clicking Connect to test validation...")
		dialog._on_connect_button_pressed()
		
		print("[TEST] Expected behavior:")
		print("[TEST] - Button becomes disabled")
		print("[TEST] - Status shows 'Validating API key...'")
		print("[TEST] - Validation fails with error message")
		print("[TEST] - Button re-enables for retry")
		
		await get_tree().create_timer(5.0).timeout
		
		# Check validation result
		print("[TEST] Current status: ", dialog.status_label.text)
		print("[TEST] Button enabled: ", not dialog.next_button.disabled)
	else:
		print("[TEST] ✗ ERROR: Connect button is disabled when it should be enabled!")
	
	await get_tree().create_timer(2.0).timeout
	
	print("\n[TEST] Step 2: Testing validation with valid key")
	print("[TEST] NOTE: This requires a real API key to test properly")
	print("[TEST] Setting a properly formatted key...")
	dialog.api_key_input.text = "AIzaSyAbCdEfGhIjKlMnOpQrStUvWxYz123456789"
	dialog._on_key_input_changed(dialog.api_key_input.text)
	
	await get_tree().create_timer(1.0).timeout
	
	print("[TEST] If you have a real API key, replace the test key above")
	print("[TEST] Expected behavior with valid key:")
	print("[TEST] - Validation succeeds")
	print("[TEST] - Configuration auto-saves with educational defaults")
	print("[TEST] - Dialog transitions to success state")
	
	# Check if GeminiAI service exists
	var gemini_service = get_node_or_null("/root/GeminiAI")
	if gemini_service:
		print("\n[TEST] GeminiAI service found!")
		print("[TEST] Current configuration:")
		print("[TEST] - Model: ", gemini_service.get_model_name())
		print("[TEST] - Temperature: ", gemini_service.temperature)
		print("[TEST] - Max tokens: ", gemini_service.max_output_tokens)
		print("[TEST] - Safety settings: ", gemini_service.get_safety_settings())
		
		# Test educational defaults
		print("\n[TEST] Checking educational defaults:")
		var expected_model = "gemini-pro"
		var expected_temp = 0.7
		var expected_tokens = 2048
		
		if gemini_service.get_model_name() == expected_model:
			print("[TEST] ✓ Model is set to educational default: ", expected_model)
		else:
			print("[TEST] ✗ Model mismatch! Expected: ", expected_model, ", Got: ", gemini_service.get_model_name())
		
		if abs(gemini_service.temperature - expected_temp) < 0.01:
			print("[TEST] ✓ Temperature is set to educational default: ", expected_temp)
		else:
			print("[TEST] ✗ Temperature mismatch! Expected: ", expected_temp, ", Got: ", gemini_service.temperature)
		
		if gemini_service.max_output_tokens == expected_tokens:
			print("[TEST] ✓ Max tokens set to educational default: ", expected_tokens)
		else:
			print("[TEST] ✗ Max tokens mismatch! Expected: ", expected_tokens, ", Got: ", gemini_service.max_output_tokens)
		
		var safety = gemini_service.get_safety_settings()
		var all_safe = true
		for category in safety:
			if safety[category] != 2:  # 2 = "Block most"
				all_safe = false
				break
		
		if all_safe:
			print("[TEST] ✓ Safety settings configured for educational use (Block most)")
		else:
			print("[TEST] ✗ Safety settings not properly configured!")
	else:
		print("\n[TEST] WARNING: GeminiAI service not found - cannot verify configuration")
	
	# Wait for test completion
	await get_tree().create_timer(5.0).timeout
	
	# Cleanup
	dialog.queue_free()
	print("\n[TEST] === API Key Validation and Auto-Save Test Complete ===")
	queue_free()

func _on_setup_completed(success: bool, api_key: String) -> void:
	"""Handle setup completion"""
	print("[TEST] SIGNAL: setup_completed received")
	print("[TEST] - Success: ", success)
	print("[TEST] - Key configured: ", api_key.length() > 0)

func _on_setup_cancelled() -> void:
	"""Handle setup cancellation"""
	print("[TEST] SIGNAL: setup_cancelled received")