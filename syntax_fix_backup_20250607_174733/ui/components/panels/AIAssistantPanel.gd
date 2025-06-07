# AI Assistant Panel for NeuroVis
# Interactive chat interface for educational brain anatomy assistance

class_name AIAssistantPanel
extends ResponsiveComponent

# === PANEL SIGNALS ===

signal question_asked(question: String)
signal panel_closed
signal feedback_given(rating: int, comment: String)

# === CONFIGURATION ===

@export var auto_suggestions: bool = true
@export var show_context_info: bool = true
@export var enable_quick_questions: bool = true
@export var max_visible_messages: int = 50

# === UI COMPONENTS ===

var title_bar: HBoxContainer
var context_indicator: Label
var chat_container: ScrollContainer
var messages_list: VBoxContainer
var input_container: VBoxContainer
var question_input: LineEdit
var send_button: Button
var quick_questions_container: HBoxContainer
var status_label: Label
var model_selector_container: HBoxContainer
var model_selector: GeminiModelSelector
var provider_selector: OptionButton

# === STATE ===
var current_structure: String = ""
var ai_service: AIAssistantService
var gemini_service: GeminiAIService
var message_count: int = 0
var is_waiting_for_response: bool = false
var gemini_setup_dialog: GeminiSetupDialog
var rate_limit_container: Control
var rate_limit_bar: ProgressBar
var rate_limit_label: Label

# === QUICK QUESTION TEMPLATES ===
var quick_questions = [
{"text": "Function", "tooltip": "What does this structure do?", "type": "function"},
{"text": "Location", "tooltip": "Where is this structure located?", "type": "location"},
{"text": "Connections", "tooltip": "What connects to this structure?", "type": "connections"},
{"text": "Clinical", "tooltip": "What happens when damaged?", "type": "clinical"}
]


var main_container = VBoxContainer.new()
main_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
main_container.add_theme_constant_override("separation", UIThemeManager.get_spacing("md"))
add_child(main_container)

# Create sections
_create_title_bar()
main_container.add_child(title_bar)

# AI provider selection
_create_provider_selection()
main_container.add_child(model_selector_container)

var icon_label = UIComponentFactory.create_label("🤖", "heading")
icon_label.custom_minimum_size.x = 32
title_bar.add_child(icon_label)

var title_label = UIComponentFactory.create_label("NeuroBot Assistant", "heading")
title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
title_bar.add_child(title_label)

# Close button
var close_btn = UIComponentFactory.create_button(
"✕", "icon", {"custom_minimum_size": Vector2(32, 32)}
)
close_btn.tooltip_text = "Close AI Assistant"
close_btn.pressed.connect(_on_close_pressed)
title_bar.add_child(close_btn)


var provider_label = UIComponentFactory.create_label("AI Provider:", "caption")
provider_label.custom_minimum_size.x = 100
model_selector_container.add_child(provider_label)

# Provider dropdown
provider_selector = OptionButton.new()
provider_selector.size_flags_horizontal = Control.SIZE_EXPAND_FILL

# Add provider options
var providers = ai_service.get_available_providers()
var style = UIThemeManager.create_enhanced_glass_style(0.8)
style.bg_color = UIThemeManager.get_color("button_secondary")
style.corner_radius_top_left = 12
style.corner_radius_top_right = 12
style.corner_radius_bottom_left = 12
style.corner_radius_bottom_right = 12
style.content_margin_left = 12
style.content_margin_right = 12
style.content_margin_top = 6
style.content_margin_bottom = 6

var context_bg = PanelContainer.new()
context_bg.add_theme_stylebox_override("panel", style)
context_bg.add_child(context_indicator)


var gemini = get_node_or_null("/root/GeminiAI")
var btn = UIComponentFactory.create_button(
question_data.text, "secondary", {"custom_minimum_size": Vector2(80, 32)}
)
btn.tooltip_text = question_data.tooltip
btn.pressed.connect(_on_quick_question_pressed.bind(question_data.type))
quick_questions_container.add_child(btn)


var input_row = HBoxContainer.new()
input_row.add_theme_constant_override("separation", UIThemeManager.get_spacing("sm"))

# Question input field
question_input = UIComponentFactory.create_text_input("Ask about brain anatomy...")
question_input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
question_input.custom_minimum_size.y = 40
question_input.text_submitted.connect(_on_question_submitted)
input_row.add_child(question_input)

# Send button
send_button = UIComponentFactory.create_button(
"Send", "primary", {"custom_minimum_size": Vector2(80, 40)}
)
send_button.pressed.connect(_on_send_pressed)
input_row.add_child(send_button)

input_container.add_child(input_row)


var welcome_text = "Hello! I'm NeuroBot, your brain anatomy assistant. I can help explain brain structures, their functions, and how they work together. Select a brain structure and ask me questions!"
_add_message("assistant", welcome_text, "Welcome")


# === AI SERVICE INTEGRATION ===
var gemini = get_node_or_null("/root/GeminiAI")
var provider_name = provider_selector.get_item_text(index)
var provider = AIAssistantService.AIProvider.get(provider_name)

# Update AI service provider
ai_service.set_provider(provider)

# Show/hide Gemini selector based on provider
var user_gemini = get_node_or_null("/root/GeminiAI")
var setup_message = "Your Gemini AI service requires setup. Please enter your API key to continue."
_add_message("assistant", setup_message, "Gemini AI Setup Required")

# Create API key input dialog
var api_key_dialog = _create_api_key_dialog()
add_child(api_key_dialog)
api_key_dialog.popup_centered()


var dialog = ConfirmationDialog.new()
dialog.title = "Gemini API Key Setup"
dialog.dialog_text = "Enter your Google Gemini API key:"
dialog.min_size = Vector2(400, 200)

# Create input field for API key
var vbox = VBoxContainer.new()
dialog.add_child(vbox)

var label = Label.new()
label.text = "You can get a free API key from https://ai.google.dev/"
vbox.add_child(label)

var input = LineEdit.new()
input.name = "APIKeyInput"
input.placeholder_text = "Enter your API key here"
input.secret = true
input.custom_minimum_size.y = 40
vbox.add_child(input)

# Connect confirmation signal
dialog.confirmed.connect(
func():
var key = input.text.strip_edges()
var gemini_ai = get_node_or_null("/root/GeminiAI")
var setup_success = await gemini_ai.setup_api_key(key)

var message_container = VBoxContainer.new()
	message_container.add_theme_constant_override("separation", UIThemeManager.get_spacing("xs"))

	# Message header with sender and timestamp
var header = HBoxContainer.new()

var sender_label = UIComponentFactory.create_label("", "caption")
var timestamp = UIComponentFactory.create_label(Time.get_time_string_from_system(), "caption")
	timestamp.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	timestamp.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	header.add_child(sender_label)
	header.add_child(timestamp)
	message_container.add_child(header)

	# Title (if provided)
var title_label = UIComponentFactory.create_label(title, "subheading")
	message_container.add_child(title_label)

	# Message content
var content_label = RichTextLabel.new()
	content_label.bbcode_enabled = true
	content_label.fit_content = true
	content_label.scroll_active = false
	content_label.text = content
	content_label.custom_minimum_size.y = 30

	UIThemeManager.apply_rich_text_styling(content_label, UIThemeManager.FONT_SIZE_MEDIUM)

	# Style message bubble
var bubble = PanelContainer.new()
var bubble_style = UIThemeManager.create_enhanced_glass_style(0.6)

var oldest_message = messages_list.get_child(0)
	messages_list.remove_child(oldest_message)
	oldest_message.queue_free()
	message_count -= 1

	# Scroll to bottom
	await get_tree().process_frame
	chat_container.scroll_vertical = chat_container.get_v_scroll_bar().max_value


var suggestions = [
	"What does the %s do?" % structure_name,
	"Where is the %s located?" % structure_name,
	"What connects to the %s?" % structure_name
	]

var suggestion_text = "💡 Try asking:\n"
var question = ""
"function":
	question = "What are the main functions of the %s?" % current_structure
	"location":
		question = "Where is the %s located?" % current_structure
		"connections":
			question = "What does the %s connect to?" % current_structure
			"clinical":
				question = "What happens when the %s is damaged?" % current_structure

				ask_question(question)


var color = UIThemeManager.ACCENT_GREEN
var response = "I'm currently in offline mode. For full AI assistance, please ensure an internet connection and API configuration. In the meantime, you can explore the 3D brain model and view structure information in the information panel."

	_add_message("assistant", response, "Offline Mode")
	is_waiting_for_response = false
	_update_status("Offline mode")
	send_button.disabled = false


	# === UTILITY METHODS ===
var export_text = "NeuroVis AI Assistant Conversation\n"
	export_text += "Generated: " + Time.get_datetime_string_from_system() + "\n"
	export_text += "Structure Context: " + current_structure + "\n\n"

var history = get_chat_history()

func set_current_structure(structure_name: String) -> void:
	"""Update the current brain structure context"""
	current_structure = structure_name

	if ai_service:
		ai_service.set_current_structure(structure_name)

		# Update context indicator
		if context_indicator:
			if structure_name.is_empty():
				context_indicator.text = "No structure selected"
				else:
					context_indicator.text = "📍 " + structure_name

					# Auto-suggest relevant questions
					if auto_suggestions and not structure_name.is_empty():
						_show_structure_suggestions(structure_name)


func ask_question(question: String) -> void:
	"""Ask a question to the AI assistant"""
	if question.strip() == "":
		return

		# Add user message to chat
		_add_message("user", question)

		# Clear input
		if question_input:
			question_input.text = ""

			# Set waiting state
			is_waiting_for_response = true
			_update_status("NeuroBot is thinking...")
			send_button.disabled = true

			# Send to AI service
			if ai_service:
				ai_service.ask_question(question)
				question_asked.emit(question)
				else:
					# Fallback for when AI service is not available
					_handle_offline_response(question)


					# === GEMINI INTEGRATION ===
func clear_chat() -> void:
	"""Clear all chat messages"""
	for child in messages_list.get_children():
		child.queue_free()
		message_count = 0
		_create_welcome_message()


func get_chat_history() -> Array:
	"""Get current chat history"""
	if ai_service:
		return ai_service.get_conversation_history()
		return []


func export_conversation() -> String:
	"""Export conversation as text"""

func _fix_orphaned_code():
	if show_context_info:
		_create_context_indicator()
		main_container.add_child(context_indicator)

		# Add rate limit indicator for Gemini
		if ai_service and ai_service.ai_provider == AIAssistantService.AIProvider.GEMINI_USER:
			_create_rate_limit_indicator()
			main_container.add_child(rate_limit_container)

			_create_chat_area()
			main_container.add_child(chat_container)

			if enable_quick_questions:
				_create_quick_questions()
				main_container.add_child(quick_questions_container)

				_create_input_area()
				main_container.add_child(input_container)

				_create_status_area()
				main_container.add_child(status_label)


func _fix_orphaned_code():
	if ai_service:
func _fix_orphaned_code():
	for i in range(providers.size()):
		provider_selector.add_item(providers[i])
		if i == ai_service.ai_provider:
			provider_selector.select(i)
			else:
				provider_selector.add_item("MOCK_RESPONSES")

				provider_selector.item_selected.connect(_on_provider_selected)
				model_selector_container.add_child(provider_selector)

				# Create and add Gemini model selector (initially hidden)
				model_selector = GeminiModelSelector.new()
				model_selector.visible = (
				ai_service and ai_service.ai_provider == AIAssistantService.AIProvider.GOOGLE_GEMINI
				)
				model_selector.settings_requested.connect(_on_gemini_settings_requested)
				model_selector_container.add_child(model_selector)


func _fix_orphaned_code():
	if gemini:
		gemini.rate_limit_updated.connect(_on_rate_limit_updated)


func _fix_orphaned_code():
	if gemini:
		if not gemini.check_setup_status():
			_update_status("Gemini AI not configured - run ai_gemini_setup")

			_update_status("Connected to AI Assistant")


func _fix_orphaned_code():
	if model_selector:
		model_selector.visible = provider == AIAssistantService.AIProvider.GOOGLE_GEMINI

		# If switching to Gemini, check if it's configured
		if provider == AIAssistantService.AIProvider.GOOGLE_GEMINI:
			if not gemini_service or not gemini_service.is_api_key_valid():
				# Show setup dialog on first use
				_show_gemini_setup_dialog()

				# If switching to user's Gemini, check if it's configured
				if provider == AIAssistantService.AIProvider.GEMINI_USER:
func _fix_orphaned_code():
	if user_gemini and user_gemini.has_method("needs_setup") and user_gemini.needs_setup():
		# Show setup message for user's Gemini service
		_show_user_gemini_setup_message()


func _fix_orphaned_code():
	if key.is_empty():
		return

func _fix_orphaned_code():
	if gemini_ai:
		_handle_user_gemini_setup(gemini_ai, key)
		else:
			_add_message(
			"assistant",
			"Unable to access GeminiAI service. Please restart the application.",
			"Error"
			)
			)

			return dialog


func _fix_orphaned_code():
	if setup_success:
		_add_message(
		"assistant",
		"Gemini API configured successfully! You can now ask questions using your own API key.",
		"Setup Complete"
		)
		_update_status("Using your Gemini API key")
		else:
			_add_message(
			"assistant",
			"Failed to configure Gemini API. Please check your API key and try again.",
			"Setup Failed"
			)
			_update_status("Gemini API setup failed")


func _fix_orphaned_code():
	if sender == "user":
		sender_label.text = "👤 You"
		sender_label.add_theme_color_override("font_color", UIThemeManager.get_color("text_accent"))
		else:
			sender_label.text = "🤖 NeuroBot"
			sender_label.add_theme_color_override(
			"font_color", UIThemeManager.get_color("button_primary")
			)

func _fix_orphaned_code():
	if title != "":
func _fix_orphaned_code():
	if sender == "user":
		bubble_style.bg_color = UIThemeManager.get_color("surface_hover")
		else:
			bubble_style.bg_color = UIThemeManager.get_color("surface_bg")

			bubble.add_theme_stylebox_override("panel", bubble_style)
			bubble.add_child(content_label)
			message_container.add_child(bubble)

			# Add to messages list
			messages_list.add_child(message_container)
			message_count += 1

			# Limit message history
			if message_count > max_visible_messages:
func _fix_orphaned_code():
	for suggestion in suggestions:
		suggestion_text += "• " + suggestion + "\n"

		_add_message("assistant", suggestion_text, "Suggestions")


		# === EVENT HANDLERS ===
func _fix_orphaned_code():
	if used > limit * 0.8:
		color = UIThemeManager.ACCENT_RED
		elif used > limit * 0.5:
			color = UIThemeManager.ACCENT_ORANGE

			UIThemeManager.apply_progress_bar_styling(rate_limit_bar, color)


			# === OFFLINE FALLBACK ===
func _fix_orphaned_code():
	for entry in history:
		export_text += "%s: %s\n\n" % [entry.role.capitalize(), entry.content]

		return export_text

func _setup_component() -> void:
	"""Setup the AI assistant panel"""
	super._setup_component()

	# Get reference to AI services
	ai_service = get_node("/root/AIAssistant") if get_node_or_null("/root/AIAssistant") else null
	gemini_service = get_node("/root/GeminiAI") if get_node_or_null("/root/GeminiAI") else null

	_create_panel_structure()
	_setup_ai_connections()
	_create_welcome_message()


func _create_panel_structure() -> void:
	"""Create the AI panel UI structure"""
	# Set panel properties
	custom_minimum_size = Vector2(400, 500)

	# Apply modern panel styling
	UIThemeManager.apply_enhanced_panel_style(self, "elevated")

	# Main container
func _create_title_bar() -> void:
	"""Create the panel title bar"""
	title_bar = HBoxContainer.new()
	title_bar.name = "TitleBar"

	# AI icon and title
func _create_provider_selection() -> void:
	"""Create AI provider selection controls"""
	model_selector_container = HBoxContainer.new()
	model_selector_container.name = "ProviderSelector"
	model_selector_container.add_theme_constant_override(
	"separation", UIThemeManager.get_spacing("sm")
	)

	# Provider label
func _create_context_indicator() -> void:
	"""Create context indicator showing current structure"""
	context_indicator = UIComponentFactory.create_label("No structure selected", "caption")
	context_indicator.name = "ContextIndicator"

	# Style as info badge
func _create_rate_limit_indicator() -> void:
	"""Create rate limit indicator for Gemini"""
	rate_limit_container = VBoxContainer.new()
	rate_limit_container.name = "RateLimitContainer"

	# Create progress bar
	rate_limit_bar = ProgressBar.new()
	rate_limit_bar.max_value = 60
	rate_limit_bar.value = 0
	rate_limit_bar.custom_minimum_size.y = 20
	UIThemeManager.apply_progress_bar_styling(rate_limit_bar, UIThemeManager.ACCENT_GREEN)

	# Create label
	rate_limit_label = UIComponentFactory.create_label("60 queries remaining", "small")
	rate_limit_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	rate_limit_container.add_child(rate_limit_bar)
	rate_limit_container.add_child(rate_limit_label)

	# Connect to Gemini for updates
func _create_chat_area() -> void:
	"""Create scrollable chat message area"""
	chat_container = ScrollContainer.new()
	chat_container.name = "ChatContainer"
	chat_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	chat_container.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED

	messages_list = VBoxContainer.new()
	messages_list.name = "MessagesList"
	messages_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	messages_list.add_theme_constant_override("separation", UIThemeManager.get_spacing("sm"))

	chat_container.add_child(messages_list)


func _create_quick_questions() -> void:
	"""Create quick question buttons"""
	quick_questions_container = HBoxContainer.new()
	quick_questions_container.name = "QuickQuestions"
	quick_questions_container.add_theme_constant_override(
	"separation", UIThemeManager.get_spacing("sm")
	)

	for question_data in quick_questions:
func _create_input_area() -> void:
	"""Create message input area"""
	input_container = VBoxContainer.new()
	input_container.name = "InputContainer"

func _create_status_area() -> void:
	"""Create status indicator"""
	status_label = UIComponentFactory.create_label("Ready", "caption")
	status_label.name = "StatusLabel"
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER


func _create_welcome_message() -> void:
	"""Create initial welcome message"""
func _setup_ai_connections() -> void:
	"""Setup connections to AI service"""
	if not ai_service:
		_update_status("AI Service not available - using offline mode")
		return

		# Connect AI service signals
		ai_service.response_received.connect(_on_ai_response_received)
		ai_service.error_occurred.connect(_on_ai_error)
		ai_service.context_updated.connect(_on_ai_context_updated)

		# Check if using Gemini
		if ai_service.ai_provider == AIAssistantService.AIProvider.GEMINI_USER:
func _on_provider_selected(index: int) -> void:
	"""Handle AI provider selection"""
	if not ai_service or index < 0:
		return

func _on_gemini_settings_requested() -> void:
	"""Open Gemini settings dialog"""
	_show_gemini_setup_dialog()


func _show_gemini_setup_dialog() -> void:
	"""Show the Gemini setup dialog"""
	if is_instance_valid(gemini_setup_dialog):
		return

		gemini_setup_dialog = GeminiSetupDialog.new()
		gemini_setup_dialog.setup_completed.connect(_on_gemini_setup_completed)
		gemini_setup_dialog.setup_cancelled.connect(_on_gemini_setup_cancelled)
		add_child(gemini_setup_dialog)
		gemini_setup_dialog.show_dialog()


func _show_user_gemini_setup_message() -> void:
	"""Show message for setting up user's Gemini service"""
func _create_api_key_dialog() -> ConfirmationDialog:
	"""Create a simple dialog for entering the API key"""
func _handle_user_gemini_setup(gemini_ai: Node, key: String) -> void:
	"""Handle user's Gemini API key setup"""
	_add_message("assistant", "Setting up Gemini API... Please wait.", "Setup in Progress")

	# Use async/await to wait for the setup result
func _on_gemini_setup_completed(successful: bool, api_key: String) -> void:
	"""Handle Gemini setup completion"""
	if successful:
		_update_status("Gemini API configured successfully")

		# Update model selector status
		if model_selector:
			model_selector.refresh_status()
			else:
				_update_status("Gemini API configuration failed")

				gemini_setup_dialog = null


func _on_gemini_setup_cancelled() -> void:
	"""Handle Gemini setup cancellation"""
	# If Gemini was not configured, switch back to mock responses
	if ai_service and ai_service.ai_provider == AIAssistantService.AIProvider.GOOGLE_GEMINI:
		if not gemini_service or not gemini_service.is_api_key_valid():
			# Find MOCK_RESPONSES index
			for i in range(provider_selector.item_count):
				if provider_selector.get_item_text(i) == "MOCK_RESPONSES":
					provider_selector.select(i)
					ai_service.set_provider(AIAssistantService.AIProvider.MOCK_RESPONSES)
					break

					gemini_setup_dialog = null


					# === MESSAGE MANAGEMENT ===
func _add_message(sender: String, content: String, title: String = "") -> void:
	"""Add a message to the chat"""
func _show_structure_suggestions(structure_name: String) -> void:
	"""Show suggested questions for the current structure"""
func _on_question_submitted(text: String) -> void:
	"""Handle question submission via Enter key"""
	ask_question(text)


func _on_send_pressed() -> void:
	"""Handle send button press"""
	ask_question(question_input.text)


func _on_quick_question_pressed(question_type: String) -> void:
	"""Handle quick question button press"""
	if current_structure.is_empty():
		_add_message(
		"assistant",
		"Please select a brain structure first, then I can answer specific questions about it!"
		)
		return

		if ai_service:
			ai_service.ask_about_current_structure(question_type)
			else:
				# Fallback questions
func _on_close_pressed() -> void:
	"""Handle close button press"""
	panel_closed.emit()
	if animation_enabled:
		animate_hide()
		else:
			visible = false


func _on_ai_response_received(question: String, response: String) -> void:
	"""Handle AI response"""
	_add_message("assistant", response)
	is_waiting_for_response = false
	_update_status("Ready")
	send_button.disabled = false


func _on_ai_error(error_message: String) -> void:
	"""Handle AI service error"""
	if "Rate limit" in error_message:
		_add_message("assistant", error_message, "Rate Limit")
		elif "not set up" in error_message:
			_add_message(
			"assistant",
			error_message + "\n\nUse the command 'ai_gemini_setup' to configure.",
			"Setup Required"
			)
			else:
				_add_message("assistant", "Sorry, I'm having trouble right now. " + error_message, "Error")
				is_waiting_for_response = false
				_update_status("Error occurred")
				send_button.disabled = false


func _on_ai_context_updated(structure_name: String) -> void:
	"""Handle AI context update"""
	set_current_structure(structure_name)


func _on_rate_limit_updated(used: int, limit: int) -> void:
	"""Handle Gemini rate limit updates"""
	if rate_limit_bar:
		rate_limit_bar.value = limit - used
		rate_limit_label.text = "%d queries remaining" % (limit - used)

		# Change color based on remaining
func _handle_offline_response(question: String) -> void:
	"""Handle questions when AI service is not available"""
	await get_tree().create_timer(1.0).timeout  # Simulate processing

func _update_status(status: String) -> void:
	"""Update status label"""
	if status_label:
		status_label.text = status


