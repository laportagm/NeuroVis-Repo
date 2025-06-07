extends Node
## Test script to verify browser opening functionality


var expected_url = "https://console.cloud.google.com/apis/credentials"
var dialog = GeminiSetupDialog.new()
get_tree().root.add_child(dialog)

func _ready() -> void:
	print("=== Testing Browser Opening Functionality ===")
	print("")

	# Test the Google Console URL constant

func _fix_orphaned_code():
	print("[TEST] Expected URL: ", expected_url)

	# Create dialog to access the constant
func _fix_orphaned_code():
	print("[TEST] Dialog URL constant: ", dialog.GOOGLE_CONSOLE_URL)

	if dialog.GOOGLE_CONSOLE_URL == expected_url:
		print("[TEST] ✓ URL constant is correct")
		else:
			print("[TEST] ✗ URL constant is incorrect!")

			# Test OS.shell_open() directly
			print("\n[TEST] Testing direct OS.shell_open() call...")
			print("[TEST] NOTE: This should open your default browser to Google Console")
			print("[TEST] Please verify the browser opened to the correct page")

			OS.shell_open(dialog.GOOGLE_CONSOLE_URL)

			await get_tree().create_timer(3.0).timeout

			# Test through dialog flow
			print("\n[TEST] Testing browser opening through dialog flow...")
			dialog.show_dialog()

			await get_tree().create_timer(2.0).timeout

			print("[TEST] Clicking 'Let's Get Started' button...")
			dialog._on_start_button_pressed()

			print("[TEST] Browser should have opened again to Google Console")
			print("[TEST] Dialog should now show 'Almost There!' screen")

			await get_tree().create_timer(3.0).timeout

			# Cleanup
			dialog.queue_free()
			await get_tree().create_timer(1.0).timeout

			print("\n[TEST] === Browser Opening Test Complete ===")
			print("[TEST] Please confirm:")
			print("[TEST] 1. Browser opened twice to Google Console")
			print("[TEST] 2. URL was: https://console.cloud.google.com/apis/credentials")
			print("[TEST] 3. Dialog showed guidance screen after button click")

			queue_free()
