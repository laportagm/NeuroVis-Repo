extends Node

## Visual Test script for Gemini AI integration
## Attach this script to a test scene to run visual tests
## For manual testing, follow docs/dev/GEMINI_TESTING_GUIDE.md

signal test_completed(success: bool, error_message: String)

# Test components

var gemini_service = null
var ai_assistant = null
var test_panel = null

	var status = ai_assistant.get_service_status()
	print("- Provider: " + status.provider)
	print("- Initialized: " + str(status.initialized))

	await get_tree().create_timer(0.5).timeout

	var panel = PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.custom_minimum_size = Vector2(600, 500)
	panel.position = Vector2(100, 100)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	panel.add_child(vbox)

	# Title
	var title = Label.new()
	title.text = "Gemini AI Integration Test"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	# Provider selection
	var provider_container = HBoxContainer.new()
	vbox.add_child(provider_container)

	var provider_label = Label.new()
	provider_label.text = "AI Provider:"
	provider_container.add_child(provider_label)

	var provider_option = OptionButton.new()
	provider_option.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	# Add provider options
	if ai_assistant:
		var providers = ai_assistant.get_available_providers()
		for i in range(providers.size()):
			provider_option.add_item(providers[i])
			if i == ai_assistant.ai_provider:
				provider_option.select(i)

	provider_container.add_child(provider_option)

	# Create the setup button
	var setup_btn = Button.new()
	setup_btn.text = "Setup Gemini API Key"
	vbox.add_child(setup_btn)

	# Create input area
	var question_input = LineEdit.new()
	question_input.placeholder_text = "Ask a question about brain anatomy..."
	question_input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_child(question_input)

	var send_btn = Button.new()
	send_btn.text = "Send"
	vbox.add_child(send_btn)

	# Create output area
	var scroll = ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(scroll)

	var output_container = VBoxContainer.new()
	output_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(output_container)

	var output = RichTextLabel.new()
	output.fit_content = true
	output.text = "Test the Gemini integration by selecting GEMINI_USER from the provider dropdown and sending a question."
	output_container.add_child(output)

	# Connect signals
	setup_btn.pressed.connect(func():
		if gemini_service and gemini_service.has_method("needs_setup"):
			if gemini_service.needs_setup():
				_show_setup_dialog()
			else:
				output.text += "\nGemini API already configured."
	)

	provider_option.item_selected.connect(func(index):
		if ai_assistant:
			var provider_name = provider_option.get_item_text(index)
			var provider = ai_assistant.AIProvider.get(provider_name)
			ai_assistant.set_provider(provider)
			output.text += "\nSwitched to " + provider_name + " provider."

			if provider_name == "GEMINI_USER" and gemini_service and gemini_service.has_method("needs_setup"):
				if gemini_service.needs_setup():
				    output.text += "\nGemini setup needed. Click the Setup button."
	)

	send_btn.pressed.connect(func():
		var question = question_input.text.strip_edges()
		if question.is_empty():
			return

		output.text += "\n\nQ: " + question

		if ai_assistant:
			ai_assistant.ask_question(question)
			output.text += "\nSending question to AI provider..."
			question_input.text = ""

			# Connect to response signal if not already connected
			if not ai_assistant.response_received.is_connected(_on_ai_response):
				ai_assistant.response_received.connect(_on_ai_response)
			if not ai_assistant.error_occurred.is_connected(_on_ai_error):
				ai_assistant.error_occurred.connect(_on_ai_error)
	)

	# Add to scene
	add_child(panel)
	test_panel = panel

	# Store references for later access
	panel.set_meta("output", output)
	panel.set_meta("question_input", question_input)

	print("✅ Test UI created")
	await get_tree().create_timer(0.5).timeout

		var dialog_script = preprepreload("res://ui/panels/GeminiSetupDialog.gd")
		var dialog = dialog_script.new()
		add_child(dialog)

		# Connect signals
		dialog.setup_completed.connect(func(successful, _api_key):
			var output = test_panel.get_meta("output")
			if successful:
				output.text += "\nGemini API setup successful!"
			else:
				output.text += "\nGemini API setup failed."
		)

		dialog.show_dialog()
	else:
		var output = test_panel.get_meta("output")
		output.text += "\nError: GeminiSetupDialog not found."

	var output = test_panel.get_meta("output")
	output.text += "\n\nA: " + response

	var output = test_panel.get_meta("output")
	output.text += "\n\nError: " + error

func _ready():
	print("=== Visual Gemini Integration Test ===")
	call_deferred("run_tests")

func run_tests():
	await verify_services()
	await create_test_ui()

	print("✅ Test script completed. Use the UI to manually test Gemini integration.")

func verify_services():
	print("\nVerifying services...")

	# Check for GeminiAI service
	gemini_service = get_node_or_null("/root/GeminiAI")
	if gemini_service:
		print("✅ GeminiAI service found")
	else:
		print("❌ GeminiAI service not found")
		test_completed.emit(false, "GeminiAI service not found")
		return

	# Check for AIAssistant service
	ai_assistant = get_node_or_null("/root/AIAssistant")
	if ai_assistant:
		print("✅ AIAssistant service found")
	else:
		print("❌ AIAssistant service not found")
		test_completed.emit(false, "AIAssistant service not found")
		return

	# Check GeminiAI state
	print("GeminiAI service status:")
	print("- Is setup complete: " + str(gemini_service.check_setup_status()))
	print("- Current model: " + gemini_service.get_model_name())
	print("- Available models: " + str(gemini_service.get_model_list()))

	# Check AIAssistant state
	print("\nAIAssistant service status:")
func create_test_ui():
	print("\nCreating test UI...")

	# Create a simple control panel

func _show_setup_dialog():
	# Try to load GeminiSetupDialog
	if ResourceLoader.exists("res://ui/panels/GeminiSetupDialog.gd"):
func _on_ai_response(question: String, response: String):
	if not is_instance_valid(test_panel):
		return

func _on_ai_error(error: String):
	if not is_instance_valid(test_panel):
		return

