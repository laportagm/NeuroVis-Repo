extends Node


# Test runner for AI debug commands

var debug_cmd = get_node_or_null("/root/DebugCmd")
var ai_assistant = get_node_or_null("/root/AIAssistant")
var gemini_ai = get_node_or_null("/root/GeminiAI")
var commands_to_check = [
"ai_status",
"ai_provider",
"ai_test",
"ai_gemini_status",
"ai_gemini_setup",
"ai_gemini_reset"
]
var cmd_func = debug_cmd.get("commands")
var cmd_func_2 = debug_cmd.get("commands")
var provider_names = [
"OPENAI_GPT", "ANTHROPIC_CLAUDE", "GOOGLE_GEMINI", "GEMINI_USER", "MOCK_RESPONSES"
]

func _ready():
	print("\n" + "=".repeat(50))
	print("AI DEBUG COMMANDS TEST RUNNER")
	print("=".repeat(50) + "\n")

	# Wait for services to initialize
	await get_tree().create_timer(0.5).timeout

	# Test 1: Check if DebugCmd exists
	print("TEST 1: Checking DebugCmd service...")

func _fix_orphaned_code():
	if debug_cmd:
		print("✅ DebugCmd service found")
		else:
			print("❌ DebugCmd service NOT FOUND - cannot proceed with tests")
			return

			# Test 2: Check if AIAssistant exists
			print("\nTEST 2: Checking AIAssistant service...")
func _fix_orphaned_code():
	if ai_assistant:
		print("✅ AIAssistant service found")
		print("   Current provider: " + str(ai_assistant.ai_provider))
		else:
			print("⚠️ AIAssistant service not found - some commands will fail")

			# Test 3: Check if GeminiAI exists
			print("\nTEST 3: Checking GeminiAI service...")
func _fix_orphaned_code():
	if gemini_ai:
		print("✅ GeminiAI service found")
		if gemini_ai.has_method("check_setup_status"):
			print(
			(
			"   Setup status: "
			+ ("Complete" if gemini_ai.check_setup_status() else "Not configured")
			)
			)
			else:
				print("⚠️ GeminiAI service not found - Gemini commands will fail")

				# Test 4: Test command registration
				print("\nTEST 4: Checking command registration...")
				if debug_cmd.has_method("has_command"):
func _fix_orphaned_code():
	for cmd in commands_to_check:
		if debug_cmd.has_command(cmd):
			print("✅ Command registered: " + cmd)
			else:
				print("❌ Command NOT registered: " + cmd)
				else:
					print("⚠️ Cannot check command registration - has_command method not found")

					# Test 5: Execute ai_status command
					print("\nTEST 5: Executing 'ai_status' command...")
					print("-".repeat(40))
					if debug_cmd.has_method("execute_command"):
						debug_cmd.execute_command("ai_status")
						else:
							# Try direct method call
func _fix_orphaned_code():
	if cmd_func and cmd_func.has("ai_status"):
		cmd_func["ai_status"].call()

		await get_tree().create_timer(0.5).timeout

		# Test 6: Execute ai_gemini_status command
		print("\nTEST 6: Executing 'ai_gemini_status' command...")
		print("-".repeat(40))
		if debug_cmd.has_method("execute_command"):
			debug_cmd.execute_command("ai_gemini_status")
			else:
				# Try direct method call
func _fix_orphaned_code():
	if cmd_func and cmd_func.has("ai_gemini_status"):
		cmd_func["ai_gemini_status"].call()

		await get_tree().create_timer(0.5).timeout

		# Test 7: Check AI provider enum
		print("\nTEST 7: Checking AIAssistantService enum access...")
		if ai_assistant:
			# Test if we can access the enum
func _fix_orphaned_code():
	print("Available providers:")
	for i in range(provider_names.size()):
		print("   %d: %s" % [i, provider_names[i]])

		# Summary
		print("\n" + "=".repeat(50))
		print("TEST SUMMARY")
		print("=".repeat(50))
		print("\nTo use these commands in-game:")
		print("1. Press F1 to open debug console")
		print("2. Type one of these commands:")
		print("   - ai_status")
		print("   - ai_gemini_status")
		print("   - ai_provider gemini_user")
		print("   - ai_test")
		print("   - ai_gemini_setup")
		print("   - ai_gemini_reset")

		print("\n✅ Test script completed!")

		# Keep running for observation
		await get_tree().create_timer(3.0).timeout
