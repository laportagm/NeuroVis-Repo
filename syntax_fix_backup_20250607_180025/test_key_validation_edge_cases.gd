extends Node
## Test script for edge cases in API key validation


var dialog = GeminiSetupDialog.new()
get_tree().root.add_child(dialog)
dialog.show_dialog()

# Navigate directly to key input state
dialog.current_state = GeminiSetupDialog.SetupState.RETURN_WITH_KEY
dialog._show_return_state()

await get_tree().create_timer(2.0).timeout

# Test various edge cases
var test_cases = [
# [input, expected_valid, expected_message]
["", false, ""],  # Empty string
[" ", false, ""],  # Just spaces
["AIza", false, "Key seems too short (should be ~39 characters)"],  # Just prefix
["AIza ", false, "Key seems too short (should be ~39 characters)"],  # Prefix with space
["aiza1234567890123456789012345678901234567", false, 'Key should start with "AIza"'],  # Lowercase prefix
["AIZA1234567890123456789012345678901234567", false, 'Key should start with "AIza"'],  # Uppercase prefix
["AIza1234567890123456789012345678901234", true, "Key format looks good!"],  # 38 chars (valid)
["AIza12345678901234567890123456789012345", true, "Key format looks good!"],  # 39 chars (valid)
["AIza123456789012345678901234567890123456", true, "Key format looks good!"],  # 40 chars (valid)
[
"AIza1234567890123456789012345678901234567890123",
false,
"Key seems too long (should be ~39 characters)"
],  # 47 chars
["  AIza12345678901234567890123456789012345  ", true, "Key format looks good!"],  # Valid with spaces (should be trimmed)
["AIza-1234567890123456789012345678901234", true, "Key format looks good!"],  # With hyphen
["AIza_1234567890123456789012345678901234", true, "Key format looks good!"],  # With underscore
["AIzaSyAbCdEfGhIjKlMnOpQrStUvWxYz123456789", true, "Key format looks good!"],  # Real-looking key
]

var test_case = test_cases[i]
var input = test_case[0]
var expected_valid = test_case[1]
var expected_message = test_case[2]

var button_enabled = not dialog.next_button.disabled
var status_text = dialog.status_label.text

var paste_event = InputEventKey.new()
paste_event.pressed = true
paste_event.keycode = KEY_V
paste_event.ctrl_pressed = true

dialog._on_key_input_gui_event(paste_event)

func _ready() -> void:
	print("=== Testing API Key Validation Edge Cases ===")
	print("")

	# Create and show the dialog

func _fix_orphaned_code():
	print("[TEST] Testing ", test_cases.size(), " edge cases...")
	print("")

	for i in range(test_cases.size()):
func _fix_orphaned_code():
	print("[TEST] Test case ", i + 1, ": '", input, "'")
	print("[TEST] Input length: ", input.length(), " chars")

	# Set input and trigger validation
	dialog.api_key_input.text = input
	dialog._on_key_input_changed(input)

	# Check results
func _fix_orphaned_code():
	print("[TEST] Button enabled: ", button_enabled, " (expected: ", expected_valid, ")")
	print("[TEST] Status text: '", status_text, "'")
	print("[TEST] Expected: '", expected_message, "'")

	if button_enabled == expected_valid:
		print("[TEST] ✓ Validation state correct")
		else:
			print("[TEST] ✗ Validation state INCORRECT!")

			if status_text == expected_message:
				print("[TEST] ✓ Status message correct")
				else:
					print("[TEST] ✗ Status message INCORRECT!")

					print("")
					await get_tree().create_timer(0.5).timeout

					# Test paste simulation
					print("[TEST] Testing paste simulation...")
					dialog.api_key_input.text = ""
					await get_tree().create_timer(0.5).timeout

					# Simulate paste event
func _fix_orphaned_code():
	print("[TEST] Simulated Ctrl+V paste event")

	# Now simulate actual paste by setting text
	dialog.api_key_input.text = "AIzaSyAbCdEfGhIjKlMnOpQrStUvWxYz123456789"
	dialog._on_key_input_changed(dialog.api_key_input.text)
	print("[TEST] Pasted valid key")

	await get_tree().create_timer(2.0).timeout

	# Cleanup
	dialog.queue_free()
	print("\n[TEST] === Key Validation Edge Cases Test Complete ===")
	queue_free()
