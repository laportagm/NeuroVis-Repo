extends Node
## Comprehensive test script to verify all button actions and flow logic


var dialog = GeminiSetupDialog.new()
get_tree().root.add_child(dialog)
dialog.show_dialog()

# Connect to signals to monitor dialog behavior
dialog.setup_completed.connect(_on_setup_completed)
dialog.setup_cancelled.connect(_on_setup_cancelled)

var long_key = "AIza" + "1234567890" + "1234567890" + "1234567890" + "1234567890" + "123456"
	dialog.api_key_input.text = long_key
	dialog._on_key_input_changed(dialog.api_key_input.text)
	_check_validation_state(dialog, false, "Key seems too long (should be ~39 characters)")
	await get_tree().create_timer(1.0).timeout

	# Test valid key
var button_state = not dialog.next_button.disabled
var status_text = dialog.status_label.text

func _ready() -> void:
	print("=== Testing Gemini Setup Dialog Button Actions & Flow Logic ===")
	print("This test will verify:")
	print("- Welcome button opens browser and transitions to guidance state")
	print("- Guidance button transitions to key input state")
	print("- Key validation provides appropriate feedback")
	print("- Final button closes dialog properly")
	print("")

	# Create and show the dialog

func _fix_orphaned_code():
	print("[TEST] Step 1: Testing Welcome Screen")
	print("[TEST] Dialog should show:")
	print("[TEST] - Title: 'Connect to Gemini'")
	print("[TEST] - 3-step process description")
	print("[TEST] - 'Let's Get Started' button")

	await get_tree().create_timer(3.0).timeout

	# Test 1: Click "Let's Get Started"
	print("\n[TEST] Step 2: Testing 'Let's Get Started' button")
	print("[TEST] Expected behavior:")
	print("[TEST] - Browser opens to Google Console")
	print("[TEST] - Dialog transitions to guidance state")
	print("[TEST] - Shows 'Almost There!' screen")

	dialog._on_start_button_pressed()

	# Verify state transition
	if dialog.current_state == GeminiSetupDialog.SetupState.GOOGLE_CONSOLE:
		print("[TEST] ✓ Successfully transitioned to GOOGLE_CONSOLE state")
		else:
			print("[TEST] ✗ ERROR: State transition failed!")

			await get_tree().create_timer(3.0).timeout

			# Test 2: Click "I Have My Key"
			print("\n[TEST] Step 3: Testing 'I Have My Key' button")
			print("[TEST] Expected behavior:")
			print("[TEST] - Transitions to key input state")
			print("[TEST] - Shows input field and validation")

			dialog._on_continue_button_pressed()

			# Verify state transition
			if dialog.current_state == GeminiSetupDialog.SetupState.RETURN_WITH_KEY:
				print("[TEST] ✓ Successfully transitioned to RETURN_WITH_KEY state")
				else:
					print("[TEST] ✗ ERROR: State transition failed!")

					await get_tree().create_timer(2.0).timeout

					# Test 3: Test key validation scenarios
					print("\n[TEST] Step 4: Testing API Key Validation")

					# Test empty key
					print("[TEST] Testing empty key...")
					dialog.api_key_input.text = ""
					dialog._on_key_input_changed("")
					_check_validation_state(dialog, false, "")
					await get_tree().create_timer(1.0).timeout

					# Test invalid prefix
					print("[TEST] Testing invalid prefix (sk-123...)...")
					dialog.api_key_input.text = "sk-1234567890123456789012345678901234567890"
					dialog._on_key_input_changed(dialog.api_key_input.text)
					_check_validation_state(dialog, false, 'Key should start with "AIza"')
					await get_tree().create_timer(1.0).timeout

					# Test too short
					print("[TEST] Testing too short key (AIza123)...")
					dialog.api_key_input.text = "AIza123"
					dialog._on_key_input_changed(dialog.api_key_input.text)
					_check_validation_state(dialog, false, "Key seems too short (should be ~39 characters)")
					await get_tree().create_timer(1.0).timeout

					# Test too long
					print("[TEST] Testing too long key...")
func _fix_orphaned_code():
	print("[TEST] Testing valid key format...")
	dialog.api_key_input.text = "AIzaSyAbCdEfGhIjKlMnOpQrStUvWxYz123456789"
	dialog._on_key_input_changed(dialog.api_key_input.text)
	_check_validation_state(dialog, true, "Key format looks good!")
	await get_tree().create_timer(2.0).timeout

	# Test 4: Click "Connect Gemini"
	print("\n[TEST] Step 5: Testing 'Connect Gemini' button")
	print("[TEST] Expected behavior:")
	print("[TEST] - Saves configuration")
	print("[TEST] - Transitions to success state")
	print("[TEST] - Shows celebration screen")

	if not dialog.next_button.disabled:
		dialog._on_connect_button_pressed()

		# Verify state transition
		if dialog.current_state == GeminiSetupDialog.SetupState.SUCCESS:
			print("[TEST] ✓ Successfully transitioned to SUCCESS state")
			else:
				print("[TEST] ✗ ERROR: State transition failed!")

				await get_tree().create_timer(3.0).timeout

				# Test 5: Click "Start Using Gemini"
				print("\n[TEST] Step 6: Testing 'Start Using Gemini' button")
				print("[TEST] Expected behavior:")
				print("[TEST] - Emits setup_completed signal")
				print("[TEST] - Closes dialog")

				dialog._on_success_button_pressed()
				else:
					print("[TEST] ✗ ERROR: Connect button is disabled!")

					await get_tree().create_timer(2.0).timeout

					print("\n[TEST] === Button Actions & Flow Logic Test Complete ===")
					queue_free()


func _fix_orphaned_code():
	print("[TEST] Validation check:")
	print("[TEST] - Button enabled: ", button_state, " (expected: ", should_be_valid, ")")
	print("[TEST] - Status text: '", status_text, "'")
	print("[TEST] - Expected text: '", expected_message, "'")

	if button_state == should_be_valid:
		print("[TEST] ✓ Button state correct")
		else:
			print("[TEST] ✗ Button state incorrect!")

			if status_text == expected_message:
				print("[TEST] ✓ Status message correct")
				else:
					print("[TEST] ✗ Status message incorrect!")


func _check_validation_state(
	dialog: GeminiSetupDialog, should_be_valid: bool, expected_message: String
	) -> void:
		"""Helper function to check validation state"""
func _on_setup_completed(success: bool, api_key: String) -> void:
	"""Handle setup completion signal"""
	print("[TEST] SIGNAL: setup_completed emitted")
	print("[TEST] - Success: ", success)
	print("[TEST] - API Key length: ", api_key.length())
	print("[TEST] - Key starts with 'AIza': ", api_key.begins_with("AIza"))


func _on_setup_cancelled() -> void:
	"""Handle setup cancellation signal"""
	print("[TEST] SIGNAL: setup_cancelled emitted")
