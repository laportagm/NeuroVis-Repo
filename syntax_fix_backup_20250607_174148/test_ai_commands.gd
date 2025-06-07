extends Node

# Quick test script for new AI debug commands


	var debug_cmd = get_node_or_null("/root/DebugCmd")
	if not debug_cmd:
		print("ERROR: DebugCmd not found!")
		return

	print("✅ DebugCmd found\n")

	# Test ai_status command
	print("Testing 'ai_status' command:")
	if debug_cmd.has_method("execute_command"):
		debug_cmd.execute_command("ai_status")

	await get_tree().create_timer(0.5).timeout

	# Test ai_gemini_status command
	print("\nTesting 'ai_gemini_status' command:")
	if debug_cmd.has_method("execute_command"):
		debug_cmd.execute_command("ai_gemini_status")

	print("\n=== Test Complete ===")
	print("You can now test these commands in-game by pressing F1 and typing:")
	print("- ai_status")
	print("- ai_gemini_status")
	print("- ai_provider gemini_user")
	print("- ai_test")
	print("- ai_gemini_setup")

	# Exit after test
	await get_tree().create_timer(2.0).timeout
	get_tree().quit()

func _ready():
	print("\n=== Testing AI Debug Commands ===\n")

	# Wait for services to initialize
	await get_tree().create_timer(1.0).timeout

	# Get debug commands instance
