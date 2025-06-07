extends Node
## Quick test script to verify the Success Celebration state


var dialog = GeminiSetupDialog.new()
get_tree().root.add_child(dialog)
dialog.show_dialog()

# Set a dummy API key to simulate having completed setup
dialog.api_key_input = LineEdit.new()
dialog.api_key_input.text = "AIzaSyAbCdEfGhIjKlMnOpQrStUvWxYz123456789"

# Navigate directly to success state for testing
await get_tree().create_timer(1.0).timeout

func _ready() -> void:
	print("=== Testing Gemini Setup Dialog Success State ===")

	# Create and show the dialog

func _fix_orphaned_code():
	print("[TEST] Navigating directly to success state")
	dialog.current_state = GeminiSetupDialog.SetupState.SUCCESS
	dialog._show_success_state()

	print("[TEST] Success state should display:")
	print("[TEST] - Green checkmark with animation")
	print("[TEST] - Title: 'You're Connected!'")
	print("[TEST] - Success message about Gemini being ready")
	print("[TEST] - Example questions in a subtle box")
	print("[TEST] - 'Start Using Gemini' button with green styling")
	print("[TEST] - Celebration particle effects")

	# Connect to signals to verify functionality
	dialog.setup_completed.connect(
	func(success, key):
		print("[TEST] Setup completed signal received!")
		print("[TEST] Success: ", success)
		print("[TEST] Key length: ", key.length())
		)
		dialog.setup_cancelled.connect(func(): print("[TEST] Setup cancelled"))

		# Wait to see animations
		await get_tree().create_timer(3.0).timeout
		print("[TEST] Checkmark animation should have completed")
		print("[TEST] Particle effects should be visible")

		# Test button functionality after more time
		await get_tree().create_timer(5.0).timeout
		print("[TEST] Testing button click...")
		if dialog.is_inside_tree():
			print("[TEST] Dialog still active - simulating button press")
			dialog._on_success_button_pressed()
			else:
				print("[TEST] Dialog already closed")

				# Clean up
				await get_tree().create_timer(1.0).timeout
				print("[TEST] Test complete")
				queue_free()
