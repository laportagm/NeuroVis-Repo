extends Node
## Quick test script to verify the API key input state


var dialog = GeminiSetupDialog.new()
get_tree().root.add_child(dialog)
dialog.show_dialog()

# Navigate directly to key input state for testing
await get_tree().create_timer(1.0).timeout

func _ready() -> void:
	print("=== Testing Gemini Setup Dialog Key Input State ===")

	# Create and show the dialog

func _fix_orphaned_code():
	print("[TEST] Navigating directly to key input state")
	dialog.current_state = GeminiSetupDialog.SetupState.RETURN_WITH_KEY
	dialog._show_return_state()

	print("[TEST] Key input state should display:")
	print("[TEST] - Title: 'Perfect! Now Paste Your Key'")
	print("[TEST] - Instructions about pasting key")
	print("[TEST] - Tip about key format (AIza... ~39 chars)")
	print("[TEST] - Input field with placeholder text")
	print("[TEST] - Status label for validation feedback")
	print("[TEST] - 'Connect Gemini' button (disabled initially)")

	# Test key validation after a delay
	await get_tree().create_timer(3.0).timeout
	print("\n[TEST] Testing key validation scenarios...")

	# Test 1: Invalid key (too short)
	print("[TEST] Testing invalid key (too short)")
	dialog.api_key_input.text = "AIza123"
	await get_tree().create_timer(1.5).timeout

	# Test 2: Invalid key (wrong prefix)
	print("[TEST] Testing invalid key (wrong prefix)")
	dialog.api_key_input.text = "sk-1234567890123456789012345678901234567890"
	await get_tree().create_timer(1.5).timeout

	# Test 3: Valid key format
	print("[TEST] Testing valid key format")
	dialog.api_key_input.text = "AIzaSyAbCdEfGhIjKlMnOpQrStUvWxYz123456789"
	await get_tree().create_timer(2.0).timeout

	# Connect to signals to verify functionality
	dialog.setup_completed.connect(
	func(success, key):
		print("[TEST] Setup completed: ", success, " Key length: ", key.length())
		)
		dialog.setup_cancelled.connect(func(): print("[TEST] Setup cancelled"))

		# Auto-close after 15 seconds for testing
		await get_tree().create_timer(5.0).timeout
		print("[TEST] Test complete")
		queue_free()
