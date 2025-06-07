## GeminiSetupDialog.gd
## Streamlined setup dialog for Google Gemini AI in NeuroVis educational platform
##
## Moved from ui/panels/ to core/ai/ui/setup/ for better organization
##
## This dialog provides a simplified, user-friendly setup process for the
## Google Gemini AI integration with a state-machine based flow designed
## for medical students and non-technical users.
##
## @tutorial: Gemini Integration Guide
## @version: 2.0

class_name GeminiSetupDialog
extends Control

# === SIGNALS ===

signal setup_completed(successful: bool, api_key: String)
signal setup_cancelled

# === STATE MACHINE ===

enum SetupState { INITIAL, GOOGLE_CONSOLE, RETURN_WITH_KEY, SUCCESS }  # Welcome screen  # Browser integration  # API key input  # Setup complete

# === NODE REFERENCES ===

const GOOGLE_CONSOLE_URL = "https://console.cloud.google.com/apis/credentials"
const DIALOG_SIZE = Vector2(480, 500)
const AUTO_VALIDATION_DELAY = 0.5  # seconds
const SUCCESS_AUTO_CLOSE_DELAY = 3.0  # seconds

# Default optimal educational settings
const DEFAULT_MODEL = GeminiAIService.GeminiModel.GEMINI_PRO
const DEFAULT_TEMPERATURE = 0.7
const DEFAULT_MAX_TOKENS = 2048
const DEFAULT_SAFETY_SETTINGS = {
"HARASSMENT": 2, "HATE_SPEECH": 2, "SEXUALLY_EXPLICIT": 2, "DANGEROUS_CONTENT": 2  # Block most  # Block most  # Block most  # Block most
}


var main_container: VBoxContainer
var state_containers: Dictionary = {}
var api_key_input: LineEdit
var validation_indicator: TextureRect
var next_button: Button
var cancel_button: Button
var status_label: Label

# === STATE ===
var current_state: SetupState = SetupState.INITIAL
var gemini_service: GeminiAIService
var is_validating: bool = false
var is_api_key_valid: bool = false
var auto_validation_timer: Timer

# === RESOURCES ===
var success_icon: Texture2D
var error_icon: Texture2D

# === CONFIGURATION ===
var background = ColorRect.new()
# FIXME: Orphaned code - background.color = Color(0, 0, 0, 0.7)
# FIXME: Orphaned code - background.anchors_preset = Control.PRESET_FULL_RECT
add_child(background)

# Main dialog panel
var dialog_panel = PanelContainer.new()
dialog_panel.set_anchors_preset(Control.PRESET_CENTER)
# FIXME: Orphaned code - dialog_panel.custom_minimum_size = DIALOG_SIZE
# FIXME: Orphaned code - dialog_panel.size_flags_horizontal = SIZE_SHRINK_CENTER
# FIXME: Orphaned code - dialog_panel.size_flags_vertical = SIZE_SHRINK_CENTER

# Set accessible description for screen readers
dialog_panel.set_meta("_accessible_description", "Gemini AI setup dialog")

# Apply NeuroVis theme styling using UIThemeManager
var padding_container = MarginContainer.new()
padding_container.add_theme_constant_override("margin_left", 24)
padding_container.add_theme_constant_override("margin_right", 24)
padding_container.add_theme_constant_override("margin_top", 24)
padding_container.add_theme_constant_override("margin_bottom", 24)
padding_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
dialog_panel.add_child(padding_container)

# Main container for all states
# FIXME: Orphaned code - main_container = VBoxContainer.new()
main_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
main_container.add_theme_constant_override("separation", 24)
# FIXME: Orphaned code - main_container.custom_minimum_size = DIALOG_SIZE - Vector2(48, 48)  # Account for padding
# FIXME: Orphaned code - main_container.size_flags_horizontal = Control.SIZE_FILL
# FIXME: Orphaned code - main_container.size_flags_vertical = Control.SIZE_FILL

# Keep consistent 24px spacing for simplicity

padding_container.add_child(main_container)


var container = _create_state_container(state)
# FIXME: Orphaned code - state_containers[state] = container
main_container.add_child(container)
container.hide()  # Hide initially


var container_2 = VBoxContainer.new()
# FIXME: Orphaned code - container.size_flags_horizontal = Control.SIZE_FILL
# FIXME: Orphaned code - container.size_flags_vertical = Control.SIZE_FILL
container.add_theme_constant_override("separation", 24)

SetupState.INITIAL:
	_create_initial_state_ui(container)
	SetupState.GOOGLE_CONSOLE:
		_create_google_console_state_ui(container)
		SetupState.RETURN_WITH_KEY:
			_create_return_with_key_state_ui(container)
			SetupState.SUCCESS:
				_create_success_state_ui(container)

var title = UIComponentFactory.create_label("Connect to Gemini AI", "heading")
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.set_meta("_accessible_description", "Dialog title: Connect to Gemini AI")
	container.add_child(title)

	# Logo/Image
var image_container = CenterContainer.new()
var image = TextureRect.new()
	image.custom_minimum_size = Vector2(150, 150)
	image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	image.set_meta("_accessible_description", "Gemini AI logo")  # For screen readers

	# Try to load the Gemini icon if available
var texture_path = "res://assets/textures/gemini_logo.png"
var description = UIComponentFactory.create_label(
	(
	"Enhance your learning with AI-powered neuroanatomy assistance. "
	+ "Connect to Google Gemini to ask questions about brain structures "
	+ "and get detailed educational explanations."
	),
	"body"
	)
	description.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	# Ensure font size meets accessibility standards (minimum 16px)
var min_font_size = 16
var current_size = description.get_theme_font_size("font_size")
var spacer = Control.new()
	spacer.custom_minimum_size.y = 20
	container.add_child(spacer)

	# Connect button
var button_container = CenterContainer.new()
var connect_button = UIComponentFactory.create_button("Let's Get Started", "primary")
	connect_button.custom_minimum_size.x = 200
	connect_button.custom_minimum_size.y = 44  # WCAG minimum touch target size
	connect_button.pressed.connect(_on_next_button_pressed)

	# Enable keyboard focus and navigation
	connect_button.focus_mode = Control.FOCUS_ALL
	connect_button.grab_focus()  # Auto-focus on the primary action

	# Set accessible description for screen readers
	connect_button.set_meta("_accessible_description", "Begin Gemini AI setup process")

	button_container.add_child(connect_button)
	container.add_child(button_container)

	# Store reference
	next_button = connect_button


var title_2 = UIComponentFactory.create_label("Get Your API Key", "heading")
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	container.add_child(title)

	# Instructions
var instructions = VBoxContainer.new()
	instructions.add_theme_constant_override("separation", 16)

var step1 = _create_step_label("1", "Google Cloud Console will open in your browser")
var step2 = _create_step_label("2", "Sign in with your Google account")
var step3 = _create_step_label("3", "Create a new API key or use an existing one")
var step4 = _create_step_label("4", "Copy your API key and return here")

	instructions.add_child(step1)
	instructions.add_child(step2)
	instructions.add_child(step3)
	instructions.add_child(step4)
	container.add_child(instructions)

	# Note
var note_container = HBoxContainer.new()
var note_icon = TextureRect.new()
var note_text = UIComponentFactory.create_label(
	"Your key stays on your device and is never shared.", "caption"
	)
	note_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	note_container.add_child(note_icon)
	note_container.add_child(note_text)
	container.add_child(note_container)

	# Button container
var button_container_2 = HBoxContainer.new()
	button_container.alignment = BoxContainer.ALIGNMENT_CENTER
	button_container.add_theme_constant_override("separation", 16)

	# Cancel button
	cancel_button = UIComponentFactory.create_button("Cancel", "secondary")
	cancel_button.custom_minimum_size.x = 120
	cancel_button.pressed.connect(_on_cancel_pressed)

	# Continue button
var continue_button = UIComponentFactory.create_button("I Have My Key", "primary")
	continue_button.custom_minimum_size.x = 120
	continue_button.pressed.connect(_on_next_button_pressed)

	button_container.add_child(cancel_button)
	button_container.add_child(continue_button)
	container.add_child(button_container)

	# Store reference
	next_button = continue_button


var title_3 = UIComponentFactory.create_label("Enter Your API Key", "heading")
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.set_meta("_accessible_description", "Dialog title: Enter Your API Key")
	container.add_child(title)

	# API key input
var input_container = VBoxContainer.new()
	input_container.add_theme_constant_override("separation", 12)  # Increased for readability

var key_label = UIComponentFactory.create_label("Paste your API key below:", "body")
# Create proper ARIA label relationship for screen readers
	key_label.set_meta("_accessible_description", "Label for API key input field")
	input_container.add_child(key_label)

var key_input_row = HBoxContainer.new()
	key_input_row.add_theme_constant_override("separation", 8)

	api_key_input = LineEdit.new()
	api_key_input.placeholder_text = "API key starts with 'AIza...'"
	api_key_input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	api_key_input.custom_minimum_size.y = 44  # WCAG minimum touch target size
	api_key_input.text_changed.connect(_on_api_key_changed)

	# Accessible relationships
	api_key_input.set_meta(
	"_accessible_description", "API key input field - paste your Gemini API key here"
	)

	# Enable keyboard navigation
	api_key_input.focus_mode = Control.FOCUS_ALL

var contrast_color = UIThemeManager.get_color("text_primary")
var educational_note = UIComponentFactory.create_label(
	(
	"Your API key lets you access Gemini AI's neuroanatomy knowledge, "
	+ "providing detailed explanations of brain structures and functions "
	+ "as you explore the 3D model."
	),
	"body"
	)
	educational_note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	# Ensure minimum font size
var min_font_size_2 = 16
var current_size_2 = educational_note.get_theme_font_size("font_size")
var button_container_3 = HBoxContainer.new()
	button_container.alignment = BoxContainer.ALIGNMENT_CENTER
	button_container.add_theme_constant_override("separation", 16)

	# Back button
var back_button = UIComponentFactory.create_button("Back", "secondary")
	back_button.custom_minimum_size.x = 120
	back_button.custom_minimum_size.y = 44  # WCAG minimum touch target size
	back_button.pressed.connect(_on_back_button_pressed)
	back_button.focus_mode = Control.FOCUS_ALL
	back_button.set_meta("_accessible_description", "Go back to previous screen")

	# Connect button
var connect_button_2 = UIComponentFactory.create_button("Connect", "primary")
	connect_button.custom_minimum_size.x = 120
	connect_button.custom_minimum_size.y = 44  # WCAG minimum touch target size
	connect_button.pressed.connect(_on_next_button_pressed)
	connect_button.disabled = true
	connect_button.focus_mode = Control.FOCUS_ALL
	connect_button.set_meta("_accessible_description", "Connect using this API key")

	button_container.add_child(back_button)
	button_container.add_child(connect_button)
	container.add_child(button_container)

	# Store reference
	next_button = connect_button


var title_4 = UIComponentFactory.create_label("🎉 Setup Complete!", "heading")
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.set_meta("_accessible_description", "Setup complete - success message")
	container.add_child(title)

	# Success icon
var icon_container = CenterContainer.new()
var success_texture = TextureRect.new()

# Use appropriate success icon instead of warning icon
var tween = success_texture.create_tween()
	tween.set_loops(1)
	tween.tween_property(success_texture, "scale", Vector2(1.2, 1.2), 0.3)
	tween.tween_property(success_texture, "scale", Vector2(1.0, 1.0), 0.3)

	# Success message with improved contrast and readability
var success_message = UIComponentFactory.create_label(
	(
	"Gemini AI is now ready to enhance your learning experience. "
	+ "Ask questions about brain structures to deepen your understanding "
	+ "of neuroanatomy and clinical relevance."
	),
	"body"
	)
	success_message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	success_message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	# Ensure minimum font size and proper contrast
var min_font_size_3 = 16
var current_size_3 = success_message.get_theme_font_size("font_size")
var examples_title = UIComponentFactory.create_label("Try asking about:", "subheading")
	examples_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	examples_title.set_meta("_accessible_description", "Example questions section")
	container.add_child(examples_title)

var examples_container = VBoxContainer.new()
	examples_container.add_theme_constant_override("separation", 12)  # Increased for readability
	examples_container.set_meta("_accessible_description", "List of example questions")

var examples = [
	"• Functions of the hippocampus",
	"• Clinical relevance of the basal ganglia",
	"• Relationship between the thalamus and cortex",
	"• Vascular supply to the brainstem"
	]

var example = examples[i]
var example_label = UIComponentFactory.create_label(example, "caption")
	example_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	# Make captions more readable with proper contrast
var button_container_4 = CenterContainer.new()
var get_started_button = UIComponentFactory.create_button("Get Started", "primary")
	get_started_button.custom_minimum_size.x = 200
	get_started_button.custom_minimum_size.y = 44  # WCAG minimum touch target size
	get_started_button.pressed.connect(_on_success_button_pressed)

	# Enable keyboard focus and navigation
	get_started_button.focus_mode = Control.FOCUS_ALL
	get_started_button.grab_focus()  # Auto-focus on the primary action
	get_started_button.set_meta("_accessible_description", "Close dialog and begin using Gemini AI")

	button_container.add_child(get_started_button)
	container.add_child(button_container)

	# Add auto-close notice for accessibility
var auto_close_notice = UIComponentFactory.create_label(
	"This dialog will automatically close in " + str(SUCCESS_AUTO_CLOSE_DELAY) + " seconds",
	"caption"
	)
	auto_close_notice.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	container.add_child(auto_close_notice)

	# Store reference
	next_button = get_started_button


var container_3 = HBoxContainer.new()
	container.add_theme_constant_override("separation", 16)

var number = Label.new()
	number.text = step_number
	number.add_theme_color_override("font_color", Color(0, 0.84, 1))  # Cyan
var content = Label.new()
	content.text = text
	content.size_flags_horizontal = SIZE_EXPAND_FILL
var auto_close_timer = get_tree().create_timer(SUCCESS_AUTO_CLOSE_DELAY)
	auto_close_timer.timeout.connect(_on_success_timeout)

	# Update current state
	current_state = new_state


var key = api_key_input.text.strip_edges()

# Basic format validation
var root_rect = get_viewport().get_visible_rect()
	position.x = (root_rect.size.x - size.x) / 2
	position.y = (root_rect.size.y - size.y) / 2


var key_2 = api_key_input.text.strip_edges()

# Skip if key is not valid
var key_3 = ""
var tween_2 = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.3)

	# Show initial state
	_show_initial_state()


	# === SIMPLIFIED STATE MANAGEMENT ===
var content_container = VBoxContainer.new()
	content_container.size_flags_horizontal = Control.SIZE_FILL
	content_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_container.add_theme_constant_override("separation", 32)
	content_container.alignment = BoxContainer.ALIGNMENT_CENTER
	main_container.add_child(content_container)

	# Add spacer at top for vertical centering
var top_spacer = Control.new()
	top_spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_container.add_child(top_spacer)

	# Create title - "Connect to Gemini"
var title_5 = UIComponentFactory.create_label("Connect to Gemini", "heading")
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 28)
	content_container.add_child(title)

	# Create subtitle explaining the 3-step process
var subtitle = UIComponentFactory.create_label(
	(
	"Set up Google's Gemini AI in 3 simple steps:\n"
	+ "1. Get an API key from Google\n"
	+ "2. Enter your key\n"
	+ "3. Start learning with AI assistance"
	),
	"body"
	)
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	subtitle.add_theme_font_size_override("font_size", 16)

	# Apply proper text color for readability
var button_spacer = Control.new()
	button_spacer.custom_minimum_size.y = 48
	content_container.add_child(button_spacer)

	# Create primary button - "Let's Get Started"
var button_container_5 = HBoxContainer.new()
	button_container.alignment = BoxContainer.ALIGNMENT_CENTER
	content_container.add_child(button_container)

var start_button = UIComponentFactory.create_button("Let's Get Started", "primary")
	start_button.custom_minimum_size = Vector2(200, 48)
	start_button.pressed.connect(_on_start_button_pressed)
	button_container.add_child(start_button)

	# Add bottom spacer for vertical centering
var bottom_spacer = Control.new()
	bottom_spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_container.add_child(bottom_spacer)

	# Store reference to button for keyboard navigation
var content_container_2 = VBoxContainer.new()
	content_container.size_flags_horizontal = Control.SIZE_FILL
	content_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_container.add_theme_constant_override("separation", 24)
	content_container.alignment = BoxContainer.ALIGNMENT_CENTER
	main_container.add_child(content_container)

	# Add top spacer for vertical centering
var top_spacer_2 = Control.new()
	top_spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_container.add_child(top_spacer)

	# Create title - "Almost There!"
var title_6 = UIComponentFactory.create_label("Almost There!", "heading")
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 28)
	content_container.add_child(title)

	# Create instruction text
var instruction = UIComponentFactory.create_label(
	"Google Console just opened in your browser.\n" + "Follow these simple steps:", "body"
	)
	instruction.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	instruction.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	instruction.add_theme_font_size_override("font_size", 16)
var visual_container = MarginContainer.new()
	visual_container.add_theme_constant_override("margin_left", 40)
	visual_container.add_theme_constant_override("margin_right", 40)
	visual_container.add_theme_constant_override("margin_top", 16)
	visual_container.add_theme_constant_override("margin_bottom", 16)
	content_container.add_child(visual_container)

	# Create bordered box as visual placeholder
var console_preview = PanelContainer.new()
	console_preview.custom_minimum_size = Vector2(360, 180)
	console_preview.size_flags_horizontal = Control.SIZE_SHRINK_CENTER

	# Apply a bordered style
var style_box = StyleBoxFlat.new()
	style_box.set_border_width_all(2)
	style_box.border_color = UIThemeManager.get_color("border_subtle")
	style_box.bg_color = UIThemeManager.get_color("surface_subtle")
	style_box.corner_radius_top_left = 8
	style_box.corner_radius_top_right = 8
	style_box.corner_radius_bottom_left = 8
	style_box.corner_radius_bottom_right = 8
	console_preview.add_theme_stylebox_override("panel", style_box)

	visual_container.add_child(console_preview)

	# Add content inside the preview box
var preview_content = VBoxContainer.new()
	preview_content.add_theme_constant_override("separation", 16)
	console_preview.add_child(preview_content)

	# Add padding inside the preview
var inner_margin = MarginContainer.new()
	inner_margin.add_theme_constant_override("margin_left", 20)
	inner_margin.add_theme_constant_override("margin_right", 20)
	inner_margin.add_theme_constant_override("margin_top", 20)
	inner_margin.add_theme_constant_override("margin_bottom", 20)
	preview_content.add_child(inner_margin)

var inner_content = VBoxContainer.new()
	inner_content.add_theme_constant_override("separation", 12)
	inner_margin.add_child(inner_content)

	# Add Google icon placeholder
var google_label = UIComponentFactory.create_label("Google AI Studio", "subheading")
	google_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	inner_content.add_child(google_label)

	# Add steps inside the preview
var steps_container = VBoxContainer.new()
	steps_container.add_theme_constant_override("separation", 8)
	inner_content.add_child(steps_container)

var step1_2 = UIComponentFactory.create_label("1. Sign in with Google", "caption")
var step2_2 = UIComponentFactory.create_label('2. Click "Get API key"', "caption")
var step3_2 = UIComponentFactory.create_label('3. Click "Create API key"', "caption")
var step4_2 = UIComponentFactory.create_label("4. Copy your key", "caption")

var help_text = UIComponentFactory.create_label(
	'Look for the blue "Create API key" button.\n' + 'Your key will start with "AIza..."',
	"body"
	)
	help_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	help_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
var button_spacer_2 = Control.new()
	button_spacer.custom_minimum_size.y = 24
	content_container.add_child(button_spacer)

	# Create button container
var button_container_6 = HBoxContainer.new()
	button_container.alignment = BoxContainer.ALIGNMENT_CENTER
	content_container.add_child(button_container)

	# Create "I Have My Key" button
var continue_button_2 = UIComponentFactory.create_button("I Have My Key", "primary")
	continue_button.custom_minimum_size = Vector2(200, 48)
	continue_button.pressed.connect(_on_continue_button_pressed)
	button_container.add_child(continue_button)

	# Add bottom spacer for vertical centering
var bottom_spacer_2 = Control.new()
	bottom_spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_container.add_child(bottom_spacer)

	# Focus the continue button
var content_container_3 = VBoxContainer.new()
	content_container.size_flags_horizontal = Control.SIZE_FILL
	content_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_container.add_theme_constant_override("separation", 24)
	content_container.alignment = BoxContainer.ALIGNMENT_CENTER
	main_container.add_child(content_container)

	# Add top spacer for vertical centering
var top_spacer_3 = Control.new()
	top_spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_container.add_child(top_spacer)

	# Create title - "Perfect! Now Paste Your Key"
var title_7 = UIComponentFactory.create_label("Perfect! Now Paste Your Key", "heading")
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 28)
	content_container.add_child(title)

	# Create instruction text
var instruction_2 = UIComponentFactory.create_label(
	"Copy your API key from Google Console and paste it below.", "body"
	)
	instruction.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	instruction.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	instruction.add_theme_font_size_override("font_size", 16)
var tip_container = HBoxContainer.new()
	tip_container.alignment = BoxContainer.ALIGNMENT_CENTER
	content_container.add_child(tip_container)

var tip_icon = TextureRect.new()
	tip_icon.custom_minimum_size = Vector2(16, 16)
	tip_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tip_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
var tip_spacer = Control.new()
	tip_spacer.custom_minimum_size.x = 8
	tip_container.add_child(tip_spacer)

var tip_text = UIComponentFactory.create_label(
	'Your key should start with "AIza" and be about 39 characters long', "caption"
	)
var input_container_2 = MarginContainer.new()
	input_container.add_theme_constant_override("margin_left", 60)
	input_container.add_theme_constant_override("margin_right", 60)
	input_container.add_theme_constant_override("margin_top", 16)
	input_container.add_theme_constant_override("margin_bottom", 8)
	content_container.add_child(input_container)

	# Create the API key input field
	api_key_input = LineEdit.new()
	api_key_input.placeholder_text = "Paste your API key here (e.g., AIzaSy...)"
	api_key_input.custom_minimum_size = Vector2(360, 48)
	api_key_input.size_flags_horizontal = Control.SIZE_SHRINK_CENTER

	# Style the input field
var style = api_key_input.get_theme_stylebox("normal")
var new_style = style.duplicate()
	new_style.content_margin_left = 16
	new_style.content_margin_right = 16
	new_style.content_margin_top = 12
	new_style.content_margin_bottom = 12
	api_key_input.add_theme_stylebox_override("normal", new_style)
	api_key_input.add_theme_stylebox_override("focus", new_style)

	# Connect input changes to validation
	api_key_input.text_changed.connect(_on_key_input_changed)
	api_key_input.gui_input.connect(_on_key_input_gui_event)

	input_container.add_child(api_key_input)

	# Create status label for validation feedback
	status_label = UIComponentFactory.create_label("", "caption")
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.custom_minimum_size.y = 20  # Reserve space even when empty
	content_container.add_child(status_label)

	# Add some spacing before the button
var button_spacer_3 = Control.new()
	button_spacer.custom_minimum_size.y = 16
	content_container.add_child(button_spacer)

	# Create button container
var button_container_7 = HBoxContainer.new()
	button_container.alignment = BoxContainer.ALIGNMENT_CENTER
	content_container.add_child(button_container)

	# Create "Connect Gemini" button (initially disabled)
	next_button = UIComponentFactory.create_button("Connect Gemini", "primary")
	next_button.custom_minimum_size = Vector2(200, 48)
	next_button.disabled = true
	next_button.pressed.connect(_on_connect_button_pressed)
	button_container.add_child(next_button)

	# Add bottom spacer for vertical centering
var bottom_spacer_3 = Control.new()
	bottom_spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_container.add_child(bottom_spacer)

	# Focus the input field
	api_key_input.grab_focus()


var key_4 = text.strip_edges()

# Basic validation
var key_event = event as InputEventKey
# Check for Ctrl+V or Cmd+V
var key_to_validate = api_key_input.text.strip_edges()

# Validate the API key using the service
var content_container_4 = VBoxContainer.new()
	content_container.size_flags_horizontal = Control.SIZE_FILL
	content_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_container.add_theme_constant_override("separation", 32)
	content_container.alignment = BoxContainer.ALIGNMENT_CENTER
	main_container.add_child(content_container)

	# Add top spacer for vertical centering
var top_spacer_4 = Control.new()
	top_spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_container.add_child(top_spacer)

	# Create checkmark container
var checkmark_container = CenterContainer.new()
	content_container.add_child(checkmark_container)

	# Create checkmark symbol using a large icon or custom drawing
var checkmark = TextureRect.new()
	checkmark.custom_minimum_size = Vector2(80, 80)
	checkmark.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	checkmark.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

	# Try to use a checkmark icon
var image_2 = Image.create(80, 80, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))
var dist = Vector2(x - 40, y - 40).length()
var texture = ImageTexture.create_from_image(image)
	checkmark.texture = texture

	# Apply green tint to checkmark
	checkmark.modulate = Color(0.2, 0.9, 0.3)  # Bright green
	checkmark_container.add_child(checkmark)

	# Animate the checkmark with a subtle bounce
var tween_3 = checkmark.create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.set_ease(Tween.EASE_OUT)
	checkmark.scale = Vector2(0.0, 0.0)
	tween.tween_property(checkmark, "scale", Vector2(1.2, 1.2), 0.4)
	tween.tween_property(checkmark, "scale", Vector2(1.0, 1.0), 0.2)

	# Add slight rotation animation
var rotate_tween = checkmark.create_tween()
	rotate_tween.set_loops(1)
	rotate_tween.tween_property(checkmark, "rotation", deg_to_rad(360), 0.6)

	# Create title - "You're Connected!"
var title_8 = UIComponentFactory.create_label("You're Connected!", "heading")
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 32)
var message = UIComponentFactory.create_label(
	(
	"Gemini AI is ready to help you explore neuroanatomy!\n"
	+ "Ask questions about any brain structure to enhance your learning."
	),
	"body"
	)
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	message.add_theme_font_size_override("font_size", 16)
var examples_container_2 = VBoxContainer.new()
	examples_container.add_theme_constant_override("separation", 8)
	content_container.add_child(examples_container)

var examples_title_2 = UIComponentFactory.create_label("Try asking:", "caption")
	examples_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
var examples_box = PanelContainer.new()
	examples_box.size_flags_horizontal = Control.SIZE_SHRINK_CENTER

var style_2 = StyleBoxFlat.new()
	style.bg_color = UIThemeManager.get_color("surface_subtle")
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.content_margin_left = 20
	style.content_margin_right = 20
	style.content_margin_top = 12
	style.content_margin_bottom = 12
	examples_box.add_theme_stylebox_override("panel", style)

	examples_container.add_child(examples_box)

var examples_list = VBoxContainer.new()
	examples_list.add_theme_constant_override("separation", 4)
	examples_box.add_child(examples_list)

var example1 = UIComponentFactory.create_label('• "What does the hippocampus do?"', "caption")
var example2 = UIComponentFactory.create_label(
	'• "How is the thalamus connected to the cortex?"', "caption"
	)
var example3 = UIComponentFactory.create_label(
	'• "What happens if the cerebellum is damaged?"', "caption"
	)

var button_spacer_4 = Control.new()
	button_spacer.custom_minimum_size.y = 24
	content_container.add_child(button_spacer)

	# Create button container
var button_container_8 = HBoxContainer.new()
	button_container.alignment = BoxContainer.ALIGNMENT_CENTER
	content_container.add_child(button_container)

	# Create "Start Using Gemini" button with success styling
var start_button_2 = UIComponentFactory.create_button("Start Using Gemini", "primary")
	start_button.custom_minimum_size = Vector2(220, 52)

	# Add a subtle green tint to the button
var button_style = start_button.get_theme_stylebox("normal")
var success_style = button_style.duplicate()
	success_style.bg_color = Color(0.2, 0.7, 0.3, 1.0)
	start_button.add_theme_stylebox_override("normal", success_style)

var hover_style = button_style.duplicate()
	hover_style.bg_color = Color(0.3, 0.8, 0.4, 1.0)
	start_button.add_theme_stylebox_override("hover", hover_style)

var pressed_style = button_style.duplicate()
	pressed_style.bg_color = Color(0.1, 0.6, 0.2, 1.0)
	start_button.add_theme_stylebox_override("pressed", pressed_style)

	start_button.pressed.connect(_on_success_button_pressed)
	button_container.add_child(start_button)

	# Add celebration particles effect (optional)
	_create_celebration_particles(content_container)

	# Add bottom spacer for vertical centering
var bottom_spacer_4 = Control.new()
	bottom_spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_container.add_child(bottom_spacer)

	# Focus the start button
var auto_close_timer_2 = get_tree().create_timer(30.0)
	auto_close_timer.timeout.connect(_on_success_auto_close)


var particle = Control.new()
	particle.size = Vector2(8, 8)
	particle.position = Vector2(randf_range(-100, 100), randf_range(-50, -100))
	parent.add_child(particle)

	# Create a small colored rect
var rect = ColorRect.new()
	rect.size = Vector2(8, 8)
	rect.color = Color(randf_range(0.2, 0.4), randf_range(0.7, 0.9), randf_range(0.3, 0.5), 0.8)
	particle.add_child(rect)

	# Animate the particle
var tween_4 = particle.create_tween()
	tween.set_parallel(true)
	tween.tween_property(
	particle,
	"position:y",
	particle.position.y + randf_range(100, 200),
	randf_range(2.0, 3.0)
	)
	tween.tween_property(particle, "modulate:a", 0.0, randf_range(2.0, 3.0))
	tween.chain().tween_callback(particle.queue_free)


var key_5 = ""
var key_6 = ""

func _ready() -> void:
	"""Initialize dialog with state machine approach"""
	gemini_service = get_node_or_null("/root/GeminiAI")
	if not gemini_service:
		push_warning(
		"[GeminiSetupDialog] GeminiAI service not found - some features may be limited"
		)

		# Load resources
		_load_resources()

		# Set up dialog structure
		_setup_dialog()
		_setup_state_containers()
		_setup_signals()

		# Auto-validation timer
		auto_validation_timer = Timer.new()
		auto_validation_timer.one_shot = true
		auto_validation_timer.wait_time = AUTO_VALIDATION_DELAY
		auto_validation_timer.timeout.connect(_on_auto_validation_timer_timeout)
		add_child(auto_validation_timer)

		# Start with initial state
		_change_state(SetupState.INITIAL)

		# Show welcome screen using simplified approach
		_show_initial_state()

		# Center dialog in window
		_center_dialog()


func show_dialog() -> void:
	"""Show the dialog with animation"""
	if not is_inside_tree():
		get_tree().root.add_child.call_deferred(self)

		# Center in window
		_center_dialog()

		# Show with fade animation
		modulate = Color(1, 1, 1, 0)
		show()

func _fix_orphaned_code():
	if UIThemeManager:
		UIThemeManager.apply_enhanced_panel_style(dialog_panel, "elevated")

		add_child(dialog_panel)

		# Add padding to improve readability
func _fix_orphaned_code():
	return container


func _fix_orphaned_code():
	if ResourceLoader.exists(texture_path):
		image.texture = load(texture_path)

		image_container.add_child(image)
		container.add_child(image_container)

		# Description text
func _fix_orphaned_code():
	if UIThemeManager:
func _fix_orphaned_code():
	if current_size < min_font_size:
		description.add_theme_font_size_override("font_size", min_font_size)

		container.add_child(description)

		# Spacer
func _fix_orphaned_code():
	if has_theme_icon("NodeWarning", "EditorIcons"):
		note_icon.texture = get_theme_icon("NodeWarning", "EditorIcons")
		note_icon.custom_minimum_size = Vector2(24, 24)
		note_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		note_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

func _fix_orphaned_code():
	if UIThemeManager:
		UIThemeManager.apply_search_field_styling(api_key_input)

		# Ensure contrast meets WCAG AA standard (4.5:1 ratio)
func _fix_orphaned_code():
	if contrast_color.get_luminance() < 0.5:
		# If dark text on light background, darken text further
		api_key_input.add_theme_color_override("font_color", contrast_color.darkened(0.2))
		else:
			# If light text on dark background, lighten text further
			api_key_input.add_theme_color_override("font_color", contrast_color.lightened(0.2))

			validation_indicator = TextureRect.new()
			validation_indicator.custom_minimum_size = Vector2(24, 24)
			validation_indicator.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			validation_indicator.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			validation_indicator.visible = false
			validation_indicator.set_meta("_accessible_description", "Validation status indicator")

			key_input_row.add_child(api_key_input)
			key_input_row.add_child(validation_indicator)
			input_container.add_child(key_input_row)

			status_label = UIComponentFactory.create_label("", "caption")
			status_label.set_meta("_accessible_description", "API key validation status")
			input_container.add_child(status_label)

			container.add_child(input_container)

			# Educational note
func _fix_orphaned_code():
	if UIThemeManager:
func _fix_orphaned_code():
	if current_size < min_font_size:
		educational_note.add_theme_font_size_override("font_size", min_font_size)

		container.add_child(educational_note)

		# Button container
func _fix_orphaned_code():
	if success_icon:
		success_texture.texture = success_icon
		elif has_theme_icon("StatusSuccess", "EditorIcons"):
			success_texture.texture = get_theme_icon("StatusSuccess", "EditorIcons")
			elif has_theme_icon("GuiChecked", "EditorIcons"):
				success_texture.texture = get_theme_icon("GuiChecked", "EditorIcons")

				success_texture.modulate = Color(0, 1, 0.5)  # Green tint
				success_texture.custom_minimum_size = Vector2(100, 100)
				success_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
				success_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
				success_texture.set_meta("_accessible_description", "Success checkmark icon")

				icon_container.add_child(success_texture)
				container.add_child(icon_container)

				# Create a celebratory animation
func _fix_orphaned_code():
	if UIThemeManager:
func _fix_orphaned_code():
	if current_size < min_font_size:
		success_message.add_theme_font_size_override("font_size", min_font_size)

		# Ensure high contrast for readability
		success_message.add_theme_color_override(
		"font_color", UIThemeManager.get_color("text_primary")
		)

		container.add_child(success_message)

		# Example questions
func _fix_orphaned_code():
	for i in range(examples.size()):
func _fix_orphaned_code():
	if UIThemeManager:
		example_label.add_theme_color_override(
		"font_color", UIThemeManager.get_color("text_secondary")
		)

		example_label.set_meta("_accessible_description", "Example question " + str(i + 1))
		examples_container.add_child(example_label)

		container.add_child(examples_container)

		# Get started button
func _fix_orphaned_code():
	if UIThemeManager:
		number.add_theme_font_size_override("font_size", 18)

func _fix_orphaned_code():
	if UIThemeManager:
		content.add_theme_font_size_override("font_size", 14)

		container.add_child(number)
		container.add_child(content)

		return container


func _fix_orphaned_code():
	if key.length() < 30 or not key.begins_with("AIza"):
		_update_validation_ui(false)
		return

		# Set validating state
		is_validating = true
		status_label.text = "Validating..."
		if UIThemeManager:
			status_label.add_theme_color_override(
			"font_color", UIThemeManager.get_color("text_secondary")
			)

			# Call validation service
			if gemini_service:
				gemini_service.validate_api_key(key)
				else:
					# Simulate validation for testing
					await get_tree().create_timer(1.0).timeout
					_on_api_key_validated(true, "API key validated")


func _fix_orphaned_code():
	if not is_api_key_valid or key.strip_edges().is_empty():
		return

		# Save configuration with educational defaults
		if gemini_service:
			gemini_service.save_configuration(key, DEFAULT_MODEL)
			gemini_service.set_safety_settings(DEFAULT_SAFETY_SETTINGS)
			gemini_service.temperature = DEFAULT_TEMPERATURE
			gemini_service.max_output_tokens = DEFAULT_MAX_TOKENS

			# Signal completion
			setup_completed.emit(true, key)


			# === SIGNAL HANDLERS ===
func _fix_orphaned_code():
	if is_instance_valid(api_key_input):
		key = api_key_input.text.strip_edges()
		setup_completed.emit(true, key)
		queue_free()


func _fix_orphaned_code():
	if UIThemeManager:
		subtitle.add_theme_color_override("font_color", UIThemeManager.get_color("text_secondary"))

		content_container.add_child(subtitle)

		# Add some spacing before the button
func _fix_orphaned_code():
	if start_button.focus_mode == Control.FOCUS_ALL:
		start_button.grab_focus()


func _fix_orphaned_code():
	if UIThemeManager:
		instruction.add_theme_color_override("font_color", UIThemeManager.get_color("text_primary"))
		content_container.add_child(instruction)

		# Add visual placeholder for Google Console
func _fix_orphaned_code():
	if UIThemeManager:
func _fix_orphaned_code():
	for step in [step1, step2, step3, step4]:
		step.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		if UIThemeManager:
			step.add_theme_color_override("font_color", UIThemeManager.get_color("text_secondary"))
			steps_container.add_child(step)

			# Add helpful text
func _fix_orphaned_code():
	if UIThemeManager:
		help_text.add_theme_color_override("font_color", UIThemeManager.get_color("text_secondary"))
		content_container.add_child(help_text)

		# Add some spacing before the button
func _fix_orphaned_code():
	if continue_button.focus_mode == Control.FOCUS_ALL:
		continue_button.grab_focus()


func _fix_orphaned_code():
	if UIThemeManager:
		instruction.add_theme_color_override("font_color", UIThemeManager.get_color("text_primary"))
		content_container.add_child(instruction)

		# Add helpful tip about key format
func _fix_orphaned_code():
	if has_theme_icon("NodeInfo", "EditorIcons"):
		tip_icon.texture = get_theme_icon("NodeInfo", "EditorIcons")
		tip_icon.modulate = Color(0.7, 0.8, 1.0)  # Light blue tint
		tip_container.add_child(tip_icon)

func _fix_orphaned_code():
	if UIThemeManager:
		tip_text.add_theme_color_override("font_color", UIThemeManager.get_color("text_secondary"))
		tip_container.add_child(tip_text)

		# Add input field container with margins
func _fix_orphaned_code():
	if UIThemeManager:
		UIThemeManager.apply_search_field_styling(api_key_input)
		# Add some padding
func _fix_orphaned_code():
	if style and style is StyleBoxFlat:
func _fix_orphaned_code():
	if key.is_empty():
		status_label.text = ""
		next_button.disabled = true
		is_api_key_valid = false
		elif not key.begins_with("AIza"):
			status_label.text = 'Key should start with "AIza"'
			if UIThemeManager:
				status_label.add_theme_color_override(
				"font_color", UIThemeManager.get_color("text_error")
				)
				next_button.disabled = true
				is_api_key_valid = false
				elif key.length() < 35:
					status_label.text = "Key seems too short (should be ~39 characters)"
					if UIThemeManager:
						status_label.add_theme_color_override(
						"font_color", UIThemeManager.get_color("text_warning")
						)
						next_button.disabled = true
						is_api_key_valid = false
						elif key.length() > 45:
							status_label.text = "Key seems too long (should be ~39 characters)"
							if UIThemeManager:
								status_label.add_theme_color_override(
								"font_color", UIThemeManager.get_color("text_warning")
								)
								next_button.disabled = true
								is_api_key_valid = false
								else:
									# Key format looks valid
									status_label.text = "Key format looks good!"
									if UIThemeManager:
										status_label.add_theme_color_override(
										"font_color", UIThemeManager.get_color("text_success")
										)
										next_button.disabled = false
										is_api_key_valid = true


func _fix_orphaned_code():
	if key_event.pressed and key_event.keycode == KEY_V:
		if key_event.ctrl_pressed or key_event.meta_pressed:
			# Give visual feedback for paste action
			print("[GeminiSetupDialog] User pasted content")


func _fix_orphaned_code():
	if gemini_service:
		# Connect to validation signal if not already connected
		if not gemini_service.api_key_validated.is_connected(_on_api_key_validated_for_save):
			gemini_service.api_key_validated.connect(_on_api_key_validated_for_save)

			# Start validation
			gemini_service.validate_api_key(key_to_validate)
			else:
				# Fallback if service not available
				push_warning("[GeminiSetupDialog] GeminiAI service not available, skipping validation")
				_save_configuration()
				current_state = SetupState.SUCCESS
				_show_success_state()


func _fix_orphaned_code():
	if has_theme_icon("GuiChecked", "EditorIcons"):
		checkmark.texture = get_theme_icon("GuiChecked", "EditorIcons")
		elif has_theme_icon("StatusSuccess", "EditorIcons"):
			checkmark.texture = get_theme_icon("StatusSuccess", "EditorIcons")
			else:
				# Fallback - create a simple green circle
func _fix_orphaned_code():
	for x in range(80):
		for y in range(80):
func _fix_orphaned_code():
	if dist < 35:
		image.set_pixel(x, y, Color(0.2, 0.8, 0.3, 1.0))
func _fix_orphaned_code():
	if UIThemeManager:
		title.add_theme_color_override("font_color", UIThemeManager.get_color("text_primary"))
		content_container.add_child(title)

		# Create success message
func _fix_orphaned_code():
	if UIThemeManager:
		message.add_theme_color_override("font_color", UIThemeManager.get_color("text_secondary"))
		content_container.add_child(message)

		# Add some example questions with subtle styling
func _fix_orphaned_code():
	if UIThemeManager:
		examples_title.add_theme_color_override(
		"font_color", UIThemeManager.get_color("text_tertiary")
		)
		examples_container.add_child(examples_title)

		# Add example questions in a subtle box
func _fix_orphaned_code():
	if UIThemeManager:
func _fix_orphaned_code():
	for example in [example1, example2, example3]:
		example.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		if UIThemeManager:
			example.add_theme_color_override(
			"font_color", UIThemeManager.get_color("text_tertiary")
			)
			examples_list.add_child(example)

			# Add some spacing before the button
func _fix_orphaned_code():
	if UIThemeManager:
func _fix_orphaned_code():
	if button_style and button_style is StyleBoxFlat:
func _fix_orphaned_code():
	if start_button.focus_mode == Control.FOCUS_ALL:
		start_button.grab_focus()

		# Auto-close after a delay if not interacted with
func _fix_orphaned_code():
	if is_instance_valid(api_key_input):
		key = api_key_input.text.strip_edges()
		setup_completed.emit(true, key)
		queue_free()


func _fix_orphaned_code():
	if is_instance_valid(api_key_input):
		key = api_key_input.text.strip_edges()
		setup_completed.emit(true, key)
		queue_free()


func _load_resources() -> void:
	"""Load required resources"""
	# Try to load success icon with multiple fallbacks
	if has_theme_icon("checked", "CheckBox"):
		success_icon = get_theme_icon("checked", "CheckBox")
		elif has_theme_icon("GuiChecked", "EditorIcons"):
			success_icon = get_theme_icon("GuiChecked", "EditorIcons")
			elif has_theme_icon("StatusSuccess", "EditorIcons"):
				success_icon = get_theme_icon("StatusSuccess", "EditorIcons")
				else:
					push_warning("[GeminiSetupDialog] Could not load success icon")

					# Try to load error icon with multiple fallbacks
					if has_theme_icon("close", "TabBar"):
						error_icon = get_theme_icon("close", "TabBar")
						elif has_theme_icon("GuiClose", "EditorIcons"):
							error_icon = get_theme_icon("GuiClose", "EditorIcons")
							elif has_theme_icon("StatusError", "EditorIcons"):
								error_icon = get_theme_icon("StatusError", "EditorIcons")
								else:
									push_warning("[GeminiSetupDialog] Could not load error icon")


func _setup_dialog() -> void:
	"""Setup base dialog structure with accessible elements"""
	# Dialog size
	custom_minimum_size = DIALOG_SIZE

	# For accessibility - ensure dialog can be navigated
	focus_mode = Control.FOCUS_ALL

	# Background panel
func _setup_state_containers() -> void:
	"""Create containers for each state"""
	# Create containers for each state
	for state in SetupState.values():
func _create_state_container(state: int) -> Control:
	"""Create UI container for a specific state"""
func _create_initial_state_ui(container: Control) -> void:
	"""Create welcome screen UI with accessibility focus"""
	# Title
func _create_google_console_state_ui(container: Control) -> void:
	"""Create Google Console guidance UI"""
	# Title
func _create_return_with_key_state_ui(container: Control) -> void:
	"""Create API key input UI with accessibility enhancements"""
	# Title
func _create_success_state_ui(container: Control) -> void:
	"""Create success confirmation UI with accessibility enhancements"""
	# Title with celebration emoji
func _create_step_label(step_number: String, text: String) -> Control:
	"""Create a step label with number and text"""
func _setup_signals() -> void:
	"""Connect signals for dialog interaction"""
	# Connect to Gemini service signals
	if gemini_service:
		# Remove previous connections if they exist
		if gemini_service.api_key_validated.is_connected(_on_api_key_validated):
			gemini_service.api_key_validated.disconnect(_on_api_key_validated)

			gemini_service.api_key_validated.connect(_on_api_key_validated)

			# Focus key input when entering key state
			api_key_input.focus_entered.connect(func(): api_key_input.select_all())


func _change_state(new_state: SetupState) -> void:
	"""Change dialog state and update UI"""
	# Hide all state containers
	for state_container in state_containers.values():
		state_container.hide()

		# Show the new state container
		if state_containers.has(new_state):
			state_containers[new_state].show()

			# Perform state-specific actions
			match new_state:
				SetupState.INITIAL:
					# Reset state
					is_api_key_valid = false

					SetupState.GOOGLE_CONSOLE:
						# Open Google Console in browser
						OS.shell_open(GOOGLE_CONSOLE_URL)

						SetupState.RETURN_WITH_KEY:
							# Focus key input
							api_key_input.grab_focus()
							# Clear validation
							_update_validation_ui(null)

							SetupState.SUCCESS:
								# Start auto-close timer
func _update_validation_ui(is_valid: Variant = null) -> void:
	"""Update validation UI based on API key validity"""
	# Check if UI elements are still valid before accessing them
	if (
	not is_instance_valid(validation_indicator)
	or not is_instance_valid(status_label)
	or not is_instance_valid(next_button)
	):
		return

		if is_valid == null:
			# Hide validation UI when no validation result
			validation_indicator.visible = false
			status_label.text = ""
			next_button.disabled = true
			return

			validation_indicator.visible = true

			if is_valid:
				validation_indicator.texture = success_icon
				validation_indicator.modulate = Color(0, 1, 0.5)  # Green
				status_label.text = "API key is valid"
				status_label.add_theme_color_override("font_color", Color(0, 1, 0.5))  # Green
				next_button.disabled = false
				else:
					validation_indicator.texture = error_icon
					validation_indicator.modulate = Color(1, 0.3, 0.3)  # Red
					status_label.text = "Invalid API key format or key not validated"
					status_label.add_theme_color_override("font_color", Color(1, 0.3, 0.3))  # Red
					next_button.disabled = true


func _validate_api_key() -> void:
	"""Validate API key with service"""
	# Check if UI elements are still valid before accessing them
	if not is_instance_valid(api_key_input) or not is_instance_valid(status_label):
		return

func _center_dialog() -> void:
	"""Center dialog in window"""
func _save_configuration() -> void:
	"""Save configuration with educational defaults"""
	# Check if api_key_input is still valid before accessing it
	if not is_instance_valid(api_key_input):
		return

func _on_next_button_pressed() -> void:
	"""Handle next button press based on current state"""
	match current_state:
		SetupState.INITIAL:
			_change_state(SetupState.GOOGLE_CONSOLE)

			SetupState.GOOGLE_CONSOLE:
				_change_state(SetupState.RETURN_WITH_KEY)

				SetupState.RETURN_WITH_KEY:
					if is_api_key_valid:
						_save_configuration()
						_change_state(SetupState.SUCCESS)

						SetupState.SUCCESS:
							_on_success_button_pressed()


func _on_back_button_pressed() -> void:
	"""Handle back button press"""
	match current_state:
		SetupState.GOOGLE_CONSOLE:
			_change_state(SetupState.INITIAL)

			SetupState.RETURN_WITH_KEY:
				_change_state(SetupState.GOOGLE_CONSOLE)

				_:
					pass  # No back action for other states


func _on_cancel_pressed() -> void:
	"""Handle cancel button press"""
	setup_cancelled.emit()
	queue_free()


func _on_success_timeout() -> void:
	"""Auto-close dialog after success state timeout"""
func _on_api_key_changed(_new_text: String) -> void:
	"""Handle API key input changes with auto-validation"""
	# Reset validation state
	is_api_key_valid = false
	_update_validation_ui(null)

	# Restart auto-validation timer
	auto_validation_timer.stop()
	auto_validation_timer.start()


func _on_auto_validation_timer_timeout() -> void:
	"""Validate API key after typing stops"""
	_validate_api_key()


func _on_api_key_validated(success: bool, message: String) -> void:
	"""Handle API key validation result"""
	is_validating = false
	is_api_key_valid = success

	# Update UI
	_update_validation_ui(success)

	if success:
		status_label.text = "✓ " + message
		if UIThemeManager:
			status_label.add_theme_color_override(
			"font_color", UIThemeManager.get_color("text_success")
			)
			else:
				status_label.text = "✗ " + message
				if UIThemeManager:
					status_label.add_theme_color_override(
					"font_color", UIThemeManager.get_color("text_error")
					)


					# === PUBLIC API ===
func _clear_state_container() -> void:
	"""Clear all children from the main container"""
	# Clear node references before freeing to prevent access to freed instances
	api_key_input = null
	validation_indicator = null
	next_button = null
	cancel_button = null
	status_label = null

	for child in main_container.get_children():
		child.queue_free()


func _show_initial_state() -> void:
	"""Build and display the welcome screen UI"""
	# Clear any existing content
	_clear_state_container()

	# Create centered container for welcome content
func _on_start_button_pressed() -> void:
	"""Handle the start button press from welcome screen"""
	print("[GeminiSetupDialog] Start button pressed")
	# Transition to Google Console guidance state
	current_state = SetupState.GOOGLE_CONSOLE
	_show_google_console_state()


func _show_google_console_state() -> void:
	"""Build and display the Google Console guidance screen"""
	# Clear any existing content
	_clear_state_container()

	# Open Google Console in browser
	OS.shell_open(GOOGLE_CONSOLE_URL)

	# Create centered container for guidance content
func _on_continue_button_pressed() -> void:
	"""Handle the continue button press from Google Console state"""
	print("[GeminiSetupDialog] Continue button pressed - moving to API key input")
	# Transition to API key input state
	current_state = SetupState.RETURN_WITH_KEY
	_show_return_state()


func _show_return_state() -> void:
	"""Build and display the API key input screen"""
	# Clear any existing content
	_clear_state_container()

	# Create centered container for key input content
func _on_key_input_changed(text: String) -> void:
	"""Handle changes to the API key input field"""
func _on_key_input_gui_event(event: InputEvent) -> void:
	"""Handle paste events in the key input field"""
	if event is InputEventKey:
func _on_connect_button_pressed() -> void:
	"""Handle the connect button press from key input state"""
	print("[GeminiSetupDialog] Connect button pressed - validating API key")

	# Check if UI elements are still valid before accessing them
	if (
	not is_instance_valid(next_button)
	or not is_instance_valid(status_label)
	or not is_instance_valid(api_key_input)
	):
		return

		# Disable button and show loading state
		next_button.disabled = true
		status_label.text = "Validating API key..."
		if UIThemeManager:
			status_label.add_theme_color_override(
			"font_color", UIThemeManager.get_color("text_secondary")
			)

			# Store the key for later
func _show_success_state() -> void:
	"""Build and display the success celebration screen"""
	# Clear any existing content
	_clear_state_container()

	# Create centered container for success content
func _create_celebration_particles(parent: Control) -> void:
	"""Create subtle celebration particle effects"""
	# Create a few small animated elements that fade in and out
	for i in range(5):
func _on_success_button_pressed() -> void:
	"""Handle the start button press from success state"""
	print("[GeminiSetupDialog] Start Using Gemini pressed - closing dialog")
func _on_success_auto_close() -> void:
	"""Auto-close the dialog after timeout"""
	print("[GeminiSetupDialog] Auto-closing success dialog")
func _on_api_key_validated_for_save(success: bool, message: String) -> void:
	"""Handle API key validation result when saving"""
	print("[GeminiSetupDialog] API key validation result: ", success, " - ", message)

	if success:
		# Validation successful - save configuration and proceed
		status_label.text = "API key validated successfully!"
		if UIThemeManager:
			status_label.add_theme_color_override(
			"font_color", UIThemeManager.get_color("text_success")
			)

			# Save configuration with educational defaults
			_save_configuration()

			# Small delay for user to see success message
			await get_tree().create_timer(0.5).timeout

			# Transition to success state
			current_state = SetupState.SUCCESS
			_show_success_state()

			# Disconnect the signal to avoid duplicate calls
			if (
			gemini_service
			and gemini_service.api_key_validated.is_connected(_on_api_key_validated_for_save)
			):
				gemini_service.api_key_validated.disconnect(_on_api_key_validated_for_save)
				else:
					# Validation failed - show error and re-enable button
					status_label.text = "API key validation failed: " + message
					if UIThemeManager:
						status_label.add_theme_color_override(
						"font_color", UIThemeManager.get_color("text_error")
						)

						# Re-enable the button so user can try again
						next_button.disabled = false

						# Clear the is_api_key_valid flag
						is_api_key_valid = false
