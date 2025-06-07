extends Node
## Test script to verify loading states during API validation


var dialog = GeminiSetupDialog.new()
get_tree().root.add_child(dialog)
dialog.show_dialog()

# Navigate directly to key input state
dialog.current_state = GeminiSetupDialog.SetupState.RETURN_WITH_KEY
dialog._show_return_state()

await get_tree().create_timer(1.0).timeout

# Set a valid-looking key
dialog.api_key_input.text = "AIzaSyAbCdEfGhIjKlMnOpQrStUvWxYz123456789"
dialog._on_key_input_changed(dialog.api_key_input.text)

await get_tree().create_timer(0.5).timeout

var initial_button_state = dialog.next_button.disabled
var initial_status_text = dialog.status_label.text

var gemini_service = get_node_or_null("/root/GeminiAI")

func _ready() -> void:
	print("=== Testing Validation Loading States ===")
	print("")

	# Create and show the dialog

func _fix_orphaned_code():
	print("[TEST] Initial state:")
	print("[TEST] - Status text: '", dialog.status_label.text, "'")
	print("[TEST] - Button enabled: ", not dialog.next_button.disabled)
	print("[TEST] - Button should be enabled for valid format")

	# Monitor state changes
func _fix_orphaned_code():
	print("\n[TEST] Clicking Connect button...")
	dialog._on_connect_button_pressed()

	# Check immediate state change
	print("\n[TEST] Loading state (immediate):")
	print("[TEST] - Status text: '", dialog.status_label.text, "'")
	print("[TEST] - Button enabled: ", not dialog.next_button.disabled)
	print("[TEST] - Expected: Button disabled, status shows 'Validating API key...'")

	if dialog.next_button.disabled and dialog.status_label.text == "Validating API key...":
		print("[TEST] ✓ Loading state correctly displayed")
		else:
			print("[TEST] ✗ Loading state not properly set!")

			# Wait a bit to see if state changes
			await get_tree().create_timer(1.0).timeout

			print("\n[TEST] State after 1 second:")
			print("[TEST] - Status text: '", dialog.status_label.text, "'")
			print("[TEST] - Button enabled: ", not dialog.next_button.disabled)

			# Mock a validation response if service is not available
func _fix_orphaned_code():
	if not gemini_service:
		print("\n[TEST] No GeminiAI service - simulating validation response...")
		# Simulate validation failure
		dialog._on_api_key_validated_for_save(false, "Invalid API key")

		await get_tree().create_timer(0.5).timeout

		print("\n[TEST] After simulated failure:")
		print("[TEST] - Status text: '", dialog.status_label.text, "'")
		print("[TEST] - Button enabled: ", not dialog.next_button.disabled)
		print("[TEST] - Expected: Error message shown, button re-enabled")

		if not dialog.next_button.disabled:
			print("[TEST] ✓ Button correctly re-enabled after failure")
			else:
				print("[TEST] ✗ Button still disabled after failure!")

				# Test success scenario
				await get_tree().create_timer(1.0).timeout
				print("\n[TEST] Simulating successful validation...")

				# Click again
				dialog._on_connect_button_pressed()
				await get_tree().create_timer(0.1).timeout

				# Simulate success
				dialog._on_api_key_validated_for_save(true, "API key validated successfully")

				await get_tree().create_timer(1.0).timeout

				print("\n[TEST] After simulated success:")
				print("[TEST] - Current state: ", dialog.current_state)
				print("[TEST] - Expected: Should be in SUCCESS state")

				if dialog.current_state == GeminiSetupDialog.SetupState.SUCCESS:
					print("[TEST] ✓ Successfully transitioned to success state")
					else:
						print("[TEST] ✗ Failed to transition to success state!")

						# Test color coding
						print("\n[TEST] Testing status message colors:")
						print("[TEST] The status messages should use appropriate colors:")
						print("[TEST] - Loading: text_secondary (gray/neutral)")
						print("[TEST] - Error: text_error (red)")
						print("[TEST] - Success: text_success (green)")

						await get_tree().create_timer(3.0).timeout

						# Cleanup
						dialog.queue_free()
						print("\n[TEST] === Validation Loading States Test Complete ===")
						queue_free()
