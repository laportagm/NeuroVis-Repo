extends Node

# Direct test of Gemini API key validation
# Run this with F6 to test the API key directly


	var gemini_service = get_node_or_null("/root/GeminiAI")
	if not gemini_service:
		print("ERROR: GeminiAI service not found in autoloads!")
		return

	print("GeminiAI service found, connecting to validation signal...")

	# Connect to the validation signal
	if not gemini_service.api_key_validated.is_connected(_on_validation_result):
		gemini_service.api_key_validated.connect(_on_validation_result)

	# Start validation
	print("Starting API key validation...")
	gemini_service.validate_api_key("AIzaSyCWuf9EQXHHngsb3ZITHxesnq3Yq_pxFvs")


		var gemini_service = get_node("/root/GeminiAI")
		print("Testing a simple query...")
		var response = await gemini_service.ask_question("Say 'Hello NeuroVis!'")
		print("Query response: ", response)
	else:
		print("❌ API key validation FAILED")
		print("Please check:")
		print("1. API key is correct")
		print("2. API key has Gemini API enabled in Google Cloud Console")
		print("3. Internet connection is working")
		print("4. No firewall blocking requests to generativelanguage.googleapis.com")

	print("\nTest completed.")

	# Wait a bit before quitting
	await get_tree().create_timer(2.0).timeout
	get_tree().quit()

func _ready():
	print("\n=== DIRECT GEMINI API KEY TEST ===")
	print("Testing API key: AIzaSyCWuf9EQXHHngsb3ZITHxesnq3Yq_pxFvs")

	# Get the GeminiAI service

func _on_validation_result(success: bool, message: String):
	print("\n=== VALIDATION RESULT ===")
	print("Success: ", success)
	print("Message: ", message)

	if success:
		print("✅ API key is VALID!")
