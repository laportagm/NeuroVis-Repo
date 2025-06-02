extends Node
## Test script that walks through the full Gemini setup flow

func _ready() -> void:
	print("=== Testing Full Gemini Setup Flow ===")
	
	# Create and show the dialog
	var dialog = GeminiSetupDialog.new()
	get_tree().root.add_child(dialog)
	dialog.show_dialog()
	
	print("[TEST] Step 1: Welcome Screen")
	await get_tree().create_timer(3.0).timeout
	
	# Click "Let's Get Started"
	print("[TEST] Clicking 'Let's Get Started'...")
	dialog._on_start_button_pressed()
	
	print("[TEST] Step 2: Google Console Guidance")
	await get_tree().create_timer(3.0).timeout
	
	# Click "I Have My Key"
	print("[TEST] Clicking 'I Have My Key'...")
	dialog._on_continue_button_pressed()
	
	print("[TEST] Step 3: API Key Input")
	await get_tree().create_timer(2.0).timeout
	
	# Simulate entering a valid API key
	print("[TEST] Entering sample API key...")
	dialog.api_key_input.text = "AIzaSyAbCdEfGhIjKlMnOpQrStUvWxYz123456789"
	dialog._on_key_input_changed(dialog.api_key_input.text)
	
	await get_tree().create_timer(2.0).timeout
	
	# Click "Connect Gemini"
	print("[TEST] Clicking 'Connect Gemini'...")
	if not dialog.next_button.disabled:
		dialog._on_connect_button_pressed()
		
		# Wait for validation
		print("[TEST] Validating API key...")
		print("[TEST] Note: With a real API key, this would contact Google's servers")
		await get_tree().create_timer(2.0).timeout
		
		# If no real service, simulate success
		var gemini_service = get_node_or_null("/root/GeminiAI")
		if not gemini_service:
			print("[TEST] Simulating successful validation...")
			dialog._on_api_key_validated_for_save(true, "API key validated successfully")
	else:
		print("[TEST] ERROR: Connect button is still disabled!")
	
	print("[TEST] Step 4: Success State")
	await get_tree().create_timer(3.0).timeout
	
	print("[TEST] Celebration screen should show:")
	print("[TEST] - Animated green checkmark")
	print("[TEST] - Success message")
	print("[TEST] - Example questions")
	print("[TEST] - Particle effects")
	
	# Connect to signals
	dialog.setup_completed.connect(func(success, key): 
		print("[TEST] Setup completed successfully!")
		print("[TEST] Dialog will close automatically")
	)
	dialog.setup_cancelled.connect(func(): print("[TEST] Setup was cancelled"))
	
	# Wait to see full celebration
	await get_tree().create_timer(5.0).timeout
	
	# Test final button
	print("[TEST] Testing 'Start Using Gemini' button...")
	if dialog.is_inside_tree():
		dialog._on_success_button_pressed()
	
	await get_tree().create_timer(2.0).timeout
	print("[TEST] Full flow test complete")
	queue_free()