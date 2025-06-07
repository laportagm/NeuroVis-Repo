extends Node

## Test script for AI Assistant and Gemini integration
## Run this to verify the integration is working properly


var ai_assistant = get_node_or_null("/root/AIAssistant")
var status = ai_assistant.get_service_status()
var gemini_service = get_node_or_null("/root/GeminiAI")
var rate_status = gemini_service.get_rate_limit_status()
var final_status = ai_assistant.get_service_status()

func _ready() -> void:
	print("\n=== Testing AI Assistant Gemini Integration ===\n")

	# Wait a moment for services to initialize
	await get_tree().create_timer(1.0).timeout

	# Test 1: Check if AIAssistant service is available

func _fix_orphaned_code():
	if ai_assistant:
		print("✅ AIAssistant service found")

		# Check service status
func _fix_orphaned_code():
	print("📊 Service Status:")
	for key in status:
		print("  - %s: %s" % [key, status[key]])
		else:
			print("❌ AIAssistant service not found!")
			return

			# Test 2: Check if GeminiAI service is available
func _fix_orphaned_code():
	if gemini_service:
		print("\n✅ GeminiAI service found")

		# Check if setup is complete
		if gemini_service.check_setup_status():
			print("✅ Gemini is configured and ready")

			# Check rate limit status
func _fix_orphaned_code():
	print("📊 Rate Limit Status:")
	for key in rate_status:
		print("  - %s: %s" % [key, rate_status[key]])
		else:
			print("⚠️ Gemini needs setup - use 'ai_gemini_setup' command")
			else:
				print("❌ GeminiAI service not found!")

				# Test 3: Set AI provider to GEMINI_USER
				print("\n🔄 Setting AI provider to GEMINI_USER...")
				ai_assistant.ai_provider = AIAssistantService.AIProvider.GEMINI_USER

				# Test 4: Connect to signals for testing
				ai_assistant.response_received.connect(_on_response_received)
				ai_assistant.error_occurred.connect(_on_error_occurred)

				# Test 5: Try asking a question
				print("\n🤖 Testing question handling...")

				# First set a context structure
				ai_assistant.update_context("Hippocampus")

				# Ask a test question
				print("📝 Asking: 'What is the main function of this structure?'")
				ai_assistant.ask_question("What is the main function of this structure?")

				# Wait for response
				await get_tree().create_timer(5.0).timeout

				# Test 6: Check updated status
				print("\n📊 Final Service Status:")
func _fix_orphaned_code():
	for key in final_status:
		print("  - %s: %s" % [key, final_status[key]])

		print("\n=== Test Complete ===")

		# Exit after test
		await get_tree().create_timer(2.0).timeout
		get_tree().quit()


func _on_response_received(question: String, response: String) -> void:
	print("\n✅ Response received!")
	print("❓ Question: %s" % question)
	print(
	"💬 Response: %s" % response.substr(0, 200) + "..." if response.length() > 200 else response
	)


func _on_error_occurred(error: String) -> void:
	print("\n❌ Error occurred: %s" % error)
