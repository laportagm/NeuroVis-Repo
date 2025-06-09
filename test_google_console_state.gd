extends Node
## Quick test script to verify the Google Console guidance state


var dialog = GeminiSetupDialog.new()
get_tree().root.add_child(dialog)
dialog.show_dialog()

# Wait a bit then simulate clicking "Let's Get Started"
await get_tree().create_timer(2.0).timeout

func _ready() -> void:
	print("=== Testing Gemini Setup Dialog Google Console State ===")

	# Create and show the dialog

print("[TEST] Simulating start button press to navigate to Google Console state")
dialog._on_start_button_pressed()

print("[TEST] Google Console state should display:")
print("[TEST] - Title: 'Almost There!'")
print("[TEST] - Instructions about Google Console")
print("[TEST] - Visual placeholder box with steps")
print("[TEST] - 'I Have My Key' button")
print("[TEST] - Browser should open Google Console")

# Connect to signals to verify functionality
dialog.setup_completed.connect(func(success, key): print("[TEST] Setup completed: ", success))
dialog.setup_cancelled.connect(func(): print("[TEST] Setup cancelled"))

# Auto-close after 15 seconds for testing
await get_tree().create_timer(15.0).timeout
print("[TEST] Test complete")
queue_free()
