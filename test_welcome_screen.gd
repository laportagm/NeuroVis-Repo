extends Node
## Quick test script to verify the Gemini setup dialog welcome screen


var dialog = GeminiSetupDialog.new()
get_tree().root.add_child(dialog)
dialog.show_dialog()

func _ready() -> void:
	print("=== Testing Gemini Setup Dialog Welcome Screen ===")

	# Create and show the dialog

print("[TEST] Dialog created and shown")
print("[TEST] Welcome screen should display:")
print("[TEST] - Title: 'Connect to Gemini'")
print("[TEST] - Subtitle with 3-step process")
print("[TEST] - 'Let's Get Started' button")

# Connect to signals to verify functionality
dialog.setup_completed.connect(func(success, key): print("[TEST] Setup completed: ", success))
dialog.setup_cancelled.connect(func(): print("[TEST] Setup cancelled"))

# Auto-close after 10 seconds for testing
await get_tree().create_timer(10.0).timeout
print("[TEST] Test complete")
queue_free()
