# Enhanced AI Assistant for NeuroVis

class_name EnhancedAIAssistant
extends BaseUIComponent

# === SIGNALS ===

signal question_asked(question: String, context: Dictionary)
signal answer_received(answer: String, metadata: Dictionary)
signal mode_changed(mode: String)
signal suggestion_selected(suggestion: String)
signal feedback_submitted(rating: int, comment: String)

# === EDUCATIONAL MODES ===

enum EducationalMode { BEGINNER, STUDENT, PROFESSIONAL, RESEARCH, QUICK_FACTS }  # Simple language, basic concepts  # Medical/science student level  # Healthcare professional level  # Advanced research level  # Bullet points, concise info

# === QUESTION TYPES ===
enum QuestionType { GENERAL, FUNCTION, CLINICAL, COMPARISON, PATHWAY, DEVELOPMENT, RESEARCH }  # General information  # How does it work?  # Medical relevance  # Compare structures  # Neural pathways  # Developmental aspects  # Latest research

# === CONFIGURATION ===

@export var max_history_size: int = 100
@export var suggestion_count: int = 4
@export var auto_suggest: bool = true
@export var show_sources: bool = true
@export var enable_voice: bool = true

# === STATE ===

var current_mode: EducationalMode = EducationalMode.STUDENT
var current_structure: String = ""
var conversation_history: Array = []
var suggested_questions: Array = []
var is_processing: bool = false
var current_language: String = "en"

# === UI COMPONENTS ===
var mode_selector: OptionButton
var chat_container: ScrollContainer
var chat_messages: VBoxContainer
var input_field: LineEdit
var send_button: Button
var voice_button: Button
var suggestions_container: HBoxContainer
var source_panel: Panel
var feedback_dialog: AcceptDialog

# === AI SERVICE ===
var ai_service: Node
var context_builder: ContextBuilder
var response_formatter: ResponseFormatter


var main_container = VBoxContainer.new()
main_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
main_container.add_theme_constant_override("separation", 8)
add_child(main_container)

# Header with mode selector
var header = _create_header()
main_container.add_child(header)

# Chat area
chat_container = _create_chat_area()
main_container.add_child(chat_container)

# Suggestions
suggestions_container = _create_suggestions_area()
main_container.add_child(suggestions_container)

# Input area
var input_area = _create_input_area()
main_container.add_child(input_area)

# Source panel (initially hidden)
source_panel = _create_source_panel()
add_child(source_panel)


var header = HBoxContainer.new()
header.add_theme_constant_override("separation", 12)

# Title
var title = Label.new()
title.text = "AI Assistant"
title.add_theme_font_size_override("font_size", 18)
header.add_child(title)

header.add_spacer(false)

# Mode selector
var mode_label = Label.new()
mode_label.text = "Mode:"
header.add_child(mode_label)

mode_selector = OptionButton.new()
mode_selector.add_item("Beginner", EducationalMode.BEGINNER)
mode_selector.add_item("Student", EducationalMode.STUDENT)
mode_selector.add_item("Professional", EducationalMode.PROFESSIONAL)
mode_selector.add_item("Research", EducationalMode.RESEARCH)
mode_selector.add_item("Quick Facts", EducationalMode.QUICK_FACTS)
mode_selector.selected = EducationalMode.STUDENT
mode_selector.item_selected.connect(_on_mode_changed)
header.add_child(mode_selector)

# Settings button
var settings_btn = Button.new()
settings_btn.text = "⚙"
settings_btn.tooltip_text = "AI Settings"
settings_btn.custom_minimum_size = Vector2(32, 32)
settings_btn.pressed.connect(_on_settings_pressed)
header.add_child(settings_btn)

var scroll = ScrollContainer.new()
scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
scroll.custom_minimum_size.y = 400

chat_messages = VBoxContainer.new()
chat_messages.size_flags_horizontal = Control.SIZE_EXPAND_FILL
chat_messages.add_theme_constant_override("separation", 12)
scroll.add_child(chat_messages)

# Add welcome message
_add_system_message(
"Hello! I'm your AI assistant for learning about brain anatomy. Select a structure and ask me anything!"
)

var container = HBoxContainer.new()
container.add_theme_constant_override("separation", 8)

# Suggestions label
var label = Label.new()
label.text = "Suggested questions:"
label.add_theme_color_override("font_color", DesignSystem.get_color("text_secondary"))
container.add_child(label)

# Suggestion buttons will be added dynamically

var container = HBoxContainer.new()
container.add_theme_constant_override("separation", 8)

# Input field
input_field = LineEdit.new()
input_field.placeholder_text = "Ask about the selected brain structure..."
input_field.size_flags_horizontal = Control.SIZE_EXPAND_FILL
input_field.text_submitted.connect(_on_input_submitted)
container.add_child(input_field)

# Voice input button
var panel = Panel.new()
panel.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
panel.custom_minimum_size.y = 100
panel.visible = false

var style = StyleBoxFlat.new()
style.bg_color = DesignSystem.get_color("surface")
style.bg_color.a = 0.95
style.corner_radius_top_left = 8
style.corner_radius_top_right = 8
panel.add_theme_stylebox_override("panel", style)

var content = VBoxContainer.new()
content.add_theme_constant_override("separation", 4)

var header = HBoxContainer.new()
var title = Label.new()
title.text = "Sources"
title.add_theme_font_size_override("font_size", 14)
header.add_child(title)

header.add_spacer(false)

var close_btn = Button.new()
close_btn.text = "✕"
close_btn.pressed.connect(func(): panel.visible = false)
header.add_child(close_btn)

content.add_child(header)
content.add_child(HSeparator.new())

panel.add_child(content)

var question = input_field.text.strip_edges()
var typing_indicator = _add_typing_indicator()

# Build context
var context = _build_context(question)

# Emit signal
question_asked.emit(question, context)

# Send to AI service
ai_service.send_message(question, context)
var response = await ai_service.response_received

# Remove typing indicator
typing_indicator.queue_free()

# Process and display response
_process_response(response)

is_processing = false
send_button.disabled = false

# Update suggestions based on conversation
_update_suggestions()


var lower_question = question.to_lower()

var formatted_response = response_formatter.format_response(response, current_mode)

# Add AI message
_add_ai_message(formatted_response.text)

# Show sources if available
var suggestion = suggested_questions[i]
var btn = Button.new()
btn.text = suggestion
btn.add_theme_stylebox_override("normal", _create_suggestion_style())
btn.pressed.connect(_on_suggestion_pressed.bind(suggestion))
suggestions_container.add_child(btn)


var suggestions = []

var message = _create_message_bubble(text, true)
chat_messages.add_child(message)
_scroll_to_bottom()


var message = _create_message_bubble(text, false)
chat_messages.add_child(message)
_scroll_to_bottom()


var message = Label.new()
message.text = text
message.add_theme_color_override("font_color", DesignSystem.get_color("text_muted"))
message.add_theme_font_size_override("font_size", 12)
message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
chat_messages.add_child(message)
_scroll_to_bottom()


var container = HBoxContainer.new()

var bubble = PanelContainer.new()
bubble.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
bubble.custom_minimum_size.x = 100

var style = StyleBoxFlat.new()
var label = RichTextLabel.new()
label.bbcode_enabled = true
label.fit_content = true
label.text = text
bubble.add_child(label)

container.add_child(bubble)

var indicator = _create_message_bubble("...", false)
chat_messages.add_child(indicator)

# Animate dots
var label = indicator.get_node("PanelContainer/RichTextLabel")
var tween = create_tween()
tween.set_loops()
tween.tween_callback(func(): label.text = ".").set_delay(0.3)
tween.tween_callback(func(): label.text = "..").set_delay(0.3)
tween.tween_callback(func(): label.text = "...").set_delay(0.3)

var dialog = AcceptDialog.new()
dialog.title = "AI Assistant Settings"
dialog.dialog_hide_on_ok = true

var content = VBoxContainer.new()
content.add_theme_constant_override("separation", 8)

# Show sources toggle
var sources_check = CheckBox.new()
sources_check.text = "Show sources"
sources_check.button_pressed = show_sources
sources_check.toggled.connect(func(pressed): show_sources = pressed)
content.add_child(sources_check)

# Auto-suggest toggle
var suggest_check = CheckBox.new()
suggest_check.text = "Show question suggestions"
suggest_check.button_pressed = auto_suggest
suggest_check.toggled.connect(
func(pressed):
	auto_suggest = pressed
	suggestions_container.visible = pressed
	)
	content.add_child(suggest_check)

	# Language selector
var lang_container = HBoxContainer.new()
var lang_label = Label.new()
	lang_label.text = "Language:"
	lang_container.add_child(lang_label)

var lang_selector = OptionButton.new()
	lang_selector.add_item("English", 0)
	lang_selector.add_item("Spanish", 1)
	lang_selector.add_item("French", 2)
	lang_selector.add_item("German", 3)
	lang_selector.item_selected.connect(_on_language_changed)
	lang_container.add_child(lang_selector)
	content.add_child(lang_container)

	dialog.add_child(content)
	add_child(dialog)
	dialog.popup_centered(Vector2(300, 200))


	# === UTILITY METHODS ===
var data = KnowledgeService.get_structure(structure_id)
var start = max(0, conversation_history.size() - count)
var style = StyleBoxFlat.new()
	style.bg_color = DesignSystem.get_color("surface_light")
	style.corner_radius_top_left = 16
	style.corner_radius_top_right = 16
	style.corner_radius_bottom_left = 16
	style.corner_radius_bottom_right = 16
	style.content_margin_left = 12
	style.content_margin_right = 12
	style.content_margin_top = 6
	style.content_margin_bottom = 6
var content = source_panel.get_child(0)

# Clear existing sources
var label = Label.new()
	label.text = "• " + source
	label.add_theme_color_override("font_color", DesignSystem.get_color("text_secondary"))
	content.add_child(label)


var context = {
	"timestamp": Time.get_unix_time_from_system(),
	"structure": params.get("structure", ""),
	"educational_mode": params.get("mode", EducationalMode.STUDENT),
	"question_type": params.get("question_type", QuestionType.GENERAL),
	"language": params.get("language", "en"),
	"include_sources": params.get("include_sources", true)
	}

	# Add conversation history
var structure_data = KnowledgeService.get_structure(context.structure)
var formatted = {
	"text": response.get("content", ""), "metadata": response.get("metadata", {})
	}

	# Apply mode-specific formatting
	EducationalMode.BEGINNER:
		formatted.text = _simplify_language(formatted.text)
		EducationalMode.QUICK_FACTS:
			formatted.text = _convert_to_bullet_points(formatted.text)
			EducationalMode.RESEARCH:
var lines = text.split("\n")
var bullet_text = ""

var cited_text = text

func _initialize_services() -> void:
	"""Initialize AI and support services"""
	# AI Service
	ai_service = preprepreprepreload("res://core/services/AIService.gd").new()
	add_child(ai_service)

	# Context Builder
	context_builder = ContextBuilder.new()
	add_child(context_builder)

	# Response Formatter
	response_formatter = ResponseFormatter.new()
	add_child(response_formatter)


func _process_question(question: String) -> void:
	"""Process user question"""
	is_processing = true
	send_button.disabled = true

	# Add user message to chat
	_add_user_message(question)

	# Show typing indicator
func _process_response(response: Dictionary) -> void:
	"""Process AI response and display"""

func set_educational_mode(mode: EducationalMode) -> void:
	"""Set the educational mode"""
	current_mode = mode
	mode_selector.selected = mode
	_update_suggestions()
	mode_changed.emit(_get_mode_name(mode))


func set_current_structure(structure_id: String) -> void:
	"""Set the current brain structure context"""
	if current_structure != structure_id:
		current_structure = structure_id
		_add_system_message("Now viewing: " + _get_structure_name(structure_id))
		_update_suggestions()


func ask_question(question: String, auto_send: bool = true) -> void:
	"""Ask a question programmatically"""
	input_field.text = question
	if auto_send:
		_on_send_pressed()


func clear_history() -> void:
	"""Clear conversation history"""
	conversation_history.clear()
	for child in chat_messages.get_children():
		child.queue_free()
		_add_system_message("Conversation history cleared.")


		# === QUESTION HANDLING ===
func build_context(params: Dictionary) -> Dictionary:
func format_response(response: Dictionary, mode: EducationalMode) -> Dictionary:

func _fix_orphaned_code():
	return header


func _fix_orphaned_code():
	return scroll


func _fix_orphaned_code():
	return container


func _fix_orphaned_code():
	if enable_voice:
		voice_button = Button.new()
		voice_button.text = "🎤"
		voice_button.tooltip_text = "Voice input"
		voice_button.custom_minimum_size = Vector2(40, 40)
		voice_button.pressed.connect(_on_voice_pressed)
		container.add_child(voice_button)

		# Send button
		send_button = Button.new()
		send_button.text = "Send"
		send_button.pressed.connect(_on_send_pressed)
		container.add_child(send_button)

		return container


func _fix_orphaned_code():
	return panel


	# === PUBLIC API ===
func _fix_orphaned_code():
	if question.is_empty() or is_processing:
		return

		_process_question(question)
		input_field.clear()


func _fix_orphaned_code():
	if "how does" in lower_question or "function" in lower_question:
		return QuestionType.FUNCTION
		elif (
		"disease" in lower_question or "disorder" in lower_question or "clinical" in lower_question
		):
			return QuestionType.CLINICAL
			elif "compare" in lower_question or "difference" in lower_question:
				return QuestionType.COMPARISON
				elif "pathway" in lower_question or "connection" in lower_question:
					return QuestionType.PATHWAY
					elif "develop" in lower_question or "growth" in lower_question:
						return QuestionType.DEVELOPMENT
						elif "research" in lower_question or "study" in lower_question:
							return QuestionType.RESEARCH
							else:
								return QuestionType.GENERAL


func _fix_orphaned_code():
	if formatted_response.has("sources") and show_sources:
		_show_sources(formatted_response.sources)

		# Add to history
		conversation_history.append(
		{
		"role": "assistant",
		"content": formatted_response.text,
		"metadata": formatted_response.get("metadata", {})
		}
		)

		# Emit signal
		answer_received.emit(formatted_response.text, formatted_response.get("metadata", {}))


		# === SUGGESTIONS SYSTEM ===
func _fix_orphaned_code():
	if current_structure.is_empty():
		# General suggestions
		suggestions = [
		"What is the hippocampus?",
		"How does memory formation work?",
		"What are the main parts of the brain?",
		"Explain neural pathways"
		]
		else:
			# Structure-specific suggestions based on mode
			match current_mode:
				EducationalMode.BEGINNER:
					suggestions = [
					"What does the " + current_structure + " do?",
					"Why is the " + current_structure + " important?",
					"Can you explain this simply?",
					"What happens if it's damaged?"
					]
					EducationalMode.STUDENT:
						suggestions = [
						"Explain the function of " + current_structure,
						"What are the neural connections?",
						"Clinical significance of " + current_structure,
						"Related anatomical structures?"
						]
						EducationalMode.PROFESSIONAL:
							suggestions = [
							"Pathophysiology involving " + current_structure,
							"Diagnostic approaches for " + current_structure + " disorders",
							"Recent research on " + current_structure,
							"Surgical considerations?"
							]
							EducationalMode.RESEARCH:
								suggestions = [
								"Latest findings on " + current_structure + " function",
								"Molecular mechanisms in " + current_structure,
								"Experimental models for studying this region",
								"Open research questions?"
								]
								EducationalMode.QUICK_FACTS:
									suggestions = [
									"Key facts about " + current_structure,
									"Quick summary of functions",
									"Main connections",
									"Clinical relevance summary"
									]

									return suggestions


func _fix_orphaned_code():
	if is_user:
		container.add_spacer(false)

func _fix_orphaned_code():
	if is_user:
		style.bg_color = DesignSystem.get_color("primary")
		style.bg_color.a = 0.2
		else:
			style.bg_color = DesignSystem.get_color("surface_light")

			style.corner_radius_top_left = 12
			style.corner_radius_top_right = 12
			style.corner_radius_bottom_left = 12 if not is_user else 4
			style.corner_radius_bottom_right = 12 if is_user else 4
			style.content_margin_left = 12
			style.content_margin_right = 12
			style.content_margin_top = 8
			style.content_margin_bottom = 8

			bubble.add_theme_stylebox_override("panel", style)

func _fix_orphaned_code():
	if not is_user:
		container.add_spacer(false)

		return container


func _fix_orphaned_code():
	return indicator


func _fix_orphaned_code():
	if data and data.has("displayName"):
		return data.displayName
		return structure_id.capitalize()


func _fix_orphaned_code():
	return conversation_history.slice(start)


func _fix_orphaned_code():
	return style


func _fix_orphaned_code():
	for child in content.get_children():
		if child is Label and child.text != "Sources":
			child.queue_free()

			# Add sources
			for source in sources:
func _fix_orphaned_code():
	if params.has("conversation_history"):
		context["history"] = params.conversation_history

		# Add structure data if available
		if context.structure != "" and KnowledgeService and KnowledgeService.is_ready():
func _fix_orphaned_code():
	if structure_data:
		context["structure_data"] = {
		"name": structure_data.get("displayName", ""),
		"functions": structure_data.get("functions", []),
		"connections": structure_data.get("connections", [])
		}

		return context


		class ResponseFormatter:
			"""Formats AI responses based on mode"""

func _fix_orphaned_code():
	if response.has("citations"):
		formatted.text = _add_citations(formatted.text, response.citations)

		# Extract sources if present
		if response.has("sources"):
			formatted["sources"] = response.sources

			return formatted

func _fix_orphaned_code():
	for line in lines:
		if line.strip_edges() != "":
			bullet_text += "• " + line.strip_edges() + "\n"

			return bullet_text

func _fix_orphaned_code():
	for i in range(citations.size()):
		cited_text += "\n[" + str(i + 1) + "] " + citations[i]

		return cited_text

func _setup_component() -> void:
	"""Setup enhanced AI assistant interface"""
	super._setup_component()

	panel_title = "AI Assistant"

	# Initialize services
	_initialize_services()

	# Create UI
	_create_enhanced_ui()

	# Setup default suggestions
	_update_suggestions()


func _create_enhanced_ui() -> void:
	"""Create enhanced UI with all features"""
func _create_header() -> Control:
	"""Create header with mode selector"""
func _create_chat_area() -> ScrollContainer:
	"""Create scrollable chat area"""
func _create_suggestions_area() -> HBoxContainer:
	"""Create question suggestions area"""
func _create_input_area() -> Control:
	"""Create input area with text field and buttons"""
func _create_source_panel() -> Panel:
	"""Create panel for showing sources"""
func _on_send_pressed() -> void:
	"""Handle send button press"""
func _on_input_submitted(text: String) -> void:
	"""Handle enter key in input field"""
	_on_send_pressed()


func _build_context(question: String) -> Dictionary:
	"""Build context for AI request"""
	return context_builder.build_context(
	{
	"structure": current_structure,
	"mode": current_mode,
	"question_type": _detect_question_type(question),
	"conversation_history": _get_recent_history(5),
	"language": current_language,
	"include_sources": show_sources
	}
	)


func _detect_question_type(question: String) -> QuestionType:
	"""Detect the type of question being asked"""
func _update_suggestions() -> void:
	"""Update question suggestions based on context"""
	if not auto_suggest:
		return

		# Clear existing suggestions
		for child in suggestions_container.get_children():
			if child is Button:
				child.queue_free()

				# Generate new suggestions
				suggested_questions = _generate_suggestions()

				# Create suggestion buttons
				for i in range(min(suggestion_count, suggested_questions.size())):
func _generate_suggestions() -> Array:
	"""Generate contextual question suggestions"""
func _on_suggestion_pressed(suggestion: String) -> void:
	"""Handle suggestion button press"""
	input_field.text = suggestion
	_on_send_pressed()
	suggestion_selected.emit(suggestion)


	# === UI HELPERS ===
func _add_user_message(text: String) -> void:
	"""Add user message to chat"""
func _add_ai_message(text: String) -> void:
	"""Add AI message to chat"""
func _add_system_message(text: String) -> void:
	"""Add system message to chat"""
func _create_message_bubble(text: String, is_user: bool) -> Control:
	"""Create a chat message bubble"""
func _add_typing_indicator() -> Control:
	"""Add typing indicator"""
func _scroll_to_bottom() -> void:
	"""Scroll chat to bottom"""
	await get_tree().process_frame
	chat_container.scroll_vertical = chat_container.get_v_scroll_bar().max_value


	# === VOICE INPUT ===
func _on_voice_pressed() -> void:
	"""Handle voice input button"""
	# TODO: Implement voice input
	_add_system_message("Voice input not yet implemented")


	# === SETTINGS ===
func _on_settings_pressed() -> void:
	"""Open AI settings dialog"""
func _get_mode_name(mode: EducationalMode) -> String:
	"""Get display name for mode"""
	match mode:
		EducationalMode.BEGINNER:
			return "Beginner"
			EducationalMode.STUDENT:
				return "Student"
				EducationalMode.PROFESSIONAL:
					return "Professional"
					EducationalMode.RESEARCH:
						return "Research"
						EducationalMode.QUICK_FACTS:
							return "Quick Facts"
							_:
								return "Unknown"


func _get_structure_name(structure_id: String) -> String:
	"""Get display name for structure"""
	# Query knowledge service
	if KnowledgeService and KnowledgeService.is_ready():
func _get_recent_history(count: int) -> Array:
	"""Get recent conversation history"""
func _create_suggestion_style() -> StyleBoxFlat:
	"""Create style for suggestion buttons"""
func _show_sources(sources: Array) -> void:
	"""Show sources panel"""
	source_panel.visible = true

func _on_mode_changed(index: int) -> void:
	"""Handle mode change"""
	set_educational_mode(index)


func _on_language_changed(index: int) -> void:
	"""Handle language change"""
	match index:
		0:
			current_language = "en"
			1:
				current_language = "es"
				2:
					current_language = "fr"
					3:
						current_language = "de"


						# === INNER CLASSES ===
						class ContextBuilder:
							"""Builds context for AI requests"""

func _simplify_language(text: String) -> String:
	# TODO: Implement language simplification
	return text

func _convert_to_bullet_points(text: String) -> String:
func _add_citations(text: String, citations: Array) -> String:
