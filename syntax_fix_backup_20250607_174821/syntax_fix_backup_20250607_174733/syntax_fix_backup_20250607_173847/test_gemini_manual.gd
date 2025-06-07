extends Control

# Manual test scene for Gemini API

var api_key_input: LineEdit
var test_button: Button
var result_label: RichTextLabel
var gemini_service: GeminiAIService


	var vbox = VBoxContainer.new()
	vbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	vbox.add_theme_constant_override("separation", 20)
	add_child(vbox)

	# Title
	var title = Label.new()
	title.text = "Gemini API Test"
	title.add_theme_font_size_override("font_size", 24)
	vbox.add_child(title)

	# API Key input
	var key_label = Label.new()
	key_label.text = "API Key:"
	vbox.add_child(key_label)

	api_key_input = LineEdit.new()
	api_key_input.placeholder_text = "Enter your API key here"
	api_key_input.custom_minimum_size.y = 40
	vbox.add_child(api_key_input)

	# Test button
	test_button = Button.new()
	test_button.text = "Test API Key"
	test_button.custom_minimum_size.y = 40
	test_button.pressed.connect(_on_test_pressed)
	vbox.add_child(test_button)

	# Result display
	var result_label_title = Label.new()
	result_label_title.text = "Results:"
	vbox.add_child(result_label_title)

	result_label = RichTextLabel.new()
	result_label.custom_minimum_size.y = 300
	result_label.bbcode_enabled = true
	vbox.add_child(result_label)

	# Add margins
	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 20)
	margin.add_theme_constant_override("margin_right", 20)
	margin.add_theme_constant_override("margin_top", 20)
	margin.add_theme_constant_override("margin_bottom", 20)
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(margin)
	margin.add_child(vbox)


	var key = api_key_input.text.strip_edges()
	if key.is_empty():
		result_label.append_text("[color=red]Please enter an API key![/color]\n")
		return

	test_button.disabled = true
	test_button.text = "Testing..."

	result_label.append_text("Key: " + key.substr(0, 10) + "...\n")
	result_label.append_text("Validating with Gemini API...\n\n")

	# Validate the key
	gemini_service.validate_api_key(key)


		var response = await gemini_service.ask_question("What is 2+2? Answer in one word.")

		if response != "":
			result_label.append_text("[color=green]Query successful![/color]\n")
			result_label.append_text("Response: " + response + "\n")
		else:
			result_label.append_text(
				"[color=red]Query failed - check console for details[/color]\n"
			)
	else:
		result_label.append_text("[color=red]❌ API Key Invalid![/color]\n")
		result_label.append_text("Message: " + message + "\n")
		result_label.append_text("\nPossible issues:\n")
		result_label.append_text("• API key is incorrect\n")
		result_label.append_text("• Gemini API not enabled in Google Cloud Console\n")
		result_label.append_text("• Billing not set up in Google Cloud\n")
		result_label.append_text("• API quota exceeded\n")


func _ready():
	print("[TEST] Manual Gemini test scene ready")

	# Get Gemini service
	gemini_service = get_node_or_null("/root/GeminiAI")
	if not gemini_service:
		print("[TEST] ERROR: GeminiAI service not found!")
		return

	# Connect to signals
	gemini_service.api_key_validated.connect(_on_api_key_validated)
	gemini_service.response_received.connect(_on_response_received)
	gemini_service.error_occurred.connect(_on_error_occurred)

	# Set up UI
	_setup_ui()

	# Pre-fill the API key for testing
	api_key_input.text = "AIzaSyCWuf9EQXHHngsb3ZITHxesnq3Yq_pxFvs"


func _setup_ui():
func _on_test_pressed():
	result_label.clear()
	result_label.append_text("[color=yellow]Testing API key...[/color]\n")

func _on_api_key_validated(success: bool, message: String):
	test_button.disabled = false
	test_button.text = "Test API Key"

	if success:
		result_label.append_text("[color=green]✅ API Key Valid![/color]\n")
		result_label.append_text("Message: " + message + "\n\n")

		# Try a test query
		result_label.append_text("[color=yellow]Testing query...[/color]\n")
func _on_response_received(response: String):
	result_label.append_text("\n[color=cyan]Response received:[/color]\n")
	result_label.append_text(response + "\n")


func _on_error_occurred(error: String):
	result_label.append_text("\n[color=red]Error:[/color] " + error + "\n")
