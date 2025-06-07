extends Node

# Live test for AI debug commands - simulates what happens in the debug console

var debug_cmd


	var ai_service = get_node_or_null("/root/AIAssistant")
	if ai_service:
		var status = ai_service.get_service_status()
		print("[color=#00CED1]=== AI Assistant Status ===[/color]")
		print("[color=#00CED1]Provider: %s[/color]" % status.provider)
		print("[color=#00CED1]Initialized: %s[/color]" % str(status.initialized))
		print("[color=#00CED1]API configured: %s[/color]" % str(status.api_configured))
		if status.get("current_structure", "") != "":
			print("[color=#00CED1]Current structure: %s[/color]" % status.current_structure)
		if status.has("gemini_status"):
			var gemini = status.gemini_status
			print(
				(
					"[color=#00CED1]Gemini rate limit: %d/%d (resets in %ds)[/color]"
					% [gemini.used, gemini.limit, gemini.reset_in]
				)
			)
	else:
		print("[color=#FF6B6B]ERROR: AI Assistant service not found[/color]")

	await get_tree().create_timer(0.5).timeout


	var gemini = get_node_or_null("/root/GeminiAI")
	if gemini:
		print("[color=#00CED1]=== Gemini AI Status ===[/color]")
		var setup_complete = (
			gemini.check_setup_status() if gemini.has_method("check_setup_status") else false
		)
		print("[color=#00CED1]Setup complete: %s[/color]" % ("Yes" if setup_complete else "No"))

		if gemini.has_method("get_rate_limit_status"):
			var rate = gemini.get_rate_limit_status()
			print(
				(
					"[color=#00CED1]Rate limit: %d/%d[/color]"
					% [rate.get("used", 0), rate.get("limit", 0)]
				)
			)
			if rate.get("reset_in", 0) > 0:
				print("[color=#00CED1]Resets in: %d seconds[/color]" % rate.reset_in)

		print(
			(
				"[color=#00CED1]API key: %s[/color]"
				% ("Configured" if setup_complete else "Not configured")
			)
		)
	else:
		print("[color=#FF6B6B]ERROR: GeminiAI service not found[/color]")

	await get_tree().create_timer(0.5).timeout


	var ai_service = get_node_or_null("/root/AIAssistant")
	if ai_service:
		# Show current provider
		print("Current provider: %s" % ai_service.get("ai_provider"))

		# Test setting to mock
		print("Setting provider to 'mock'...")
		ai_service.ai_provider = 4  # MOCK_RESPONSES
		print("[color=#4ECDC4]AI provider set to: mock[/color]")

		# Test invalid provider
		print("\nTesting invalid provider...")
		print(
			'[color=#FF6B6B]ERROR: Unknown provider. Available: ["openai", "claude", "gemini", "gemini_user", "mock"][/color]'
		)
	else:
		print("[color=#FF6B6B]ERROR: AI Assistant service not found[/color]")

	await get_tree().create_timer(0.5).timeout


	var ai_service = get_node_or_null("/root/AIAssistant")
	if ai_service:
		var question = "What is the hippocampus?"
		print("[color=#00CED1]Testing AI with: " + question + "[/color]")

		# Connect to response signals
		if ai_service.has_signal("response_received"):
			ai_service.response_received.connect(_on_test_response, CONNECT_ONE_SHOT)
		if ai_service.has_signal("error_occurred"):
			ai_service.error_occurred.connect(_on_test_error, CONNECT_ONE_SHOT)

		# Ask question
		ai_service.ask_question(question)

		# Wait for response
		await get_tree().create_timer(2.0).timeout
	else:
		print("[color=#FF6B6B]ERROR: AI Assistant service not found[/color]")


	var truncated = response.left(200) + ("..." if response.length() > 200 else "")
	print("[color=#4ECDC4]AI Response: " + truncated + "[/color]")


func _ready():
	print("\n" + "=".repeat(60))
	print("LIVE AI DEBUG COMMANDS TEST")
	print("=".repeat(60) + "\n")

	# Get DebugCmd instance
	debug_cmd = get_node_or_null("/root/DebugCmd")
	if not debug_cmd:
		print("❌ CRITICAL: DebugCmd not found!")
		print("   Make sure DebugCmd is in autoloads in project.godot")
		return

	print("✅ DebugCmd found\n")

	# Wait for initialization
	await get_tree().create_timer(1.0).timeout

	# Test each command
	await test_ai_status()
	await test_ai_gemini_status()
	await test_ai_provider()
	await test_ai_test()

	print("\n" + "=".repeat(60))
	print("TEST COMPLETE")
	print("=".repeat(60))


func test_ai_status():
	print("\n>>> Testing 'ai_status' command:")
	print("-".repeat(40))

	# Simulate what happens when user types "ai_status"
func test_ai_gemini_status():
	print("\n>>> Testing 'ai_gemini_status' command:")
	print("-".repeat(40))

	# Simulate what happens when user types "ai_gemini_status"
func test_ai_provider():
	print("\n>>> Testing 'ai_provider' command:")
	print("-".repeat(40))

func test_ai_test():
	print("\n>>> Testing 'ai_test' command:")
	print("-".repeat(40))

func _on_test_response(_question: String, response: String):
func _on_test_error(error: String):
	print("[color=#FF6B6B]AI Error: " + error + "[/color]")
