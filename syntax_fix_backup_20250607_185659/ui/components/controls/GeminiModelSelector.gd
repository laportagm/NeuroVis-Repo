# GeminiModelSelector.gd
# UI component for selecting Google Gemini AI model in NeuroVis

class_name GeminiModelSelector
extends HBoxContainer

# === SIGNALS ===

signal model_changed(model_name: String)
signal settings_requested

# === NODE REFERENCES ===

var model_dropdown: OptionButton
var settings_button: Button
var status_indicator: TextureRect

# === STATE ===
var current_model: String = ""
var gemini_service: GeminiAIService
var ai_assistant: AIAssistantService


var model_label = UIComponentFactory.create_label("Gemini Model:", "caption")
# FIXME: Orphaned code - model_label.custom_minimum_size.x = 100
add_child(model_label)

# Model dropdown
# FIXME: Orphaned code - model_dropdown = OptionButton.new()
# FIXME: Orphaned code - model_dropdown.size_flags_horizontal = SIZE_EXPAND_FILL
add_child(model_dropdown)

# Settings button
# FIXME: Orphaned code - settings_button = UIComponentFactory.create_button("⚙️", "icon")
# FIXME: Orphaned code - settings_button.tooltip_text = "Gemini AI Settings"
# FIXME: Orphaned code - settings_button.custom_minimum_size = Vector2(32, 32)
add_child(settings_button)

# Status indicator
# FIXME: Orphaned code - status_indicator = TextureRect.new()
# FIXME: Orphaned code - status_indicator.custom_minimum_size = Vector2(16, 16)
# FIXME: Orphaned code - status_indicator.expand_mode = TextureRect.EXPAND_KEEP_ASPECT_CENTERED
# FIXME: Orphaned code - status_indicator.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
add_child(status_indicator)

# Set initial status (will be updated after service check)
_set_status("unknown")


var is_configured = gemini_service.is_api_key_valid()
_set_status("configured" if is_configured else "unconfigured")

# Connect signals from Gemini service
gemini_service.model_list_updated.connect(_on_model_list_updated)
gemini_service.config_changed.connect(_on_config_changed)

# Load current model
# FIXME: Orphaned code - current_model = gemini_service.get_model_name()
_set_status("unavailable")
# FIXME: Orphaned code - model_dropdown.disabled = true


var models = gemini_service.get_model_list()

# If no models available yet, use default list
var color = Color.WHITE
var tooltip = ""

"configured":
	color = Color.GREEN
	tooltip = "Gemini AI configured and ready"
	"unconfigured":
		color = Color.YELLOW
		tooltip = "Gemini AI service available but not configured"
		"unavailable":
			color = Color.RED
			tooltip = "Gemini AI service unavailable"
			"error":
				color = Color.RED
				tooltip = "Error with Gemini AI service"
				_:  # unknown
				color = Color.DARK_GRAY
				tooltip = "Gemini AI status unknown"

				# Create colored circle
var image = Image.create(16, 16, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))

	# Draw circle with given color
var distance = Vector2(x - 8, y - 8).length()
var texture = ImageTexture.create_from_image(image)
	status_indicator.texture = texture
	status_indicator.tooltip_text = tooltip


	# === SIGNAL HANDLERS ===

func _ready() -> void:
	"""Initialize the model selector"""
	_create_component()
	_setup_signals()
	_load_service_references()
	_update_model_list()


func get_current_model() -> String:
	"""Get currently selected model name"""
	return current_model


func set_model(model_name: String) -> bool:
	"""Set model by name"""
	for i in range(model_dropdown.item_count):
		if model_dropdown.get_item_text(i) == model_name:
			model_dropdown.select(i)
			current_model = model_name
			return true

			return false


func refresh_status() -> void:
	"""Refresh the status indicator"""
	if not gemini_service:
		_set_status("unavailable")
		return

		if gemini_service.is_api_key_valid():
			_set_status("configured")
			else:
				_set_status("unconfigured")

func _fix_orphaned_code():
	if models.is_empty():
		models = []
		for key in gemini_service.MODEL_NAMES:
			models.append(gemini_service.MODEL_NAMES[key])

			# Add models to dropdown
			for model_name in models:
				model_dropdown.add_item(model_name)

				# Select current model
				if model_name == current_model:
					model_dropdown.select(model_dropdown.item_count - 1)
					else:
						# Fallback models if service not available
						model_dropdown.add_item("gemini-pro")
						model_dropdown.add_item("gemini-pro-vision")
						model_dropdown.add_item("gemini-flash")


func _fix_orphaned_code():
	for x in range(16):
		for y in range(16):
func _fix_orphaned_code():
	if distance <= 6:
		image.set_pixel(x, y, color)

func _create_component() -> void:
	"""Create the component UI"""
	add_theme_constant_override("separation", UIThemeManager.get_spacing("sm"))
	size_flags_horizontal = SIZE_EXPAND_FILL

	# Model label
func _setup_signals() -> void:
	"""Connect component signals"""
	model_dropdown.item_selected.connect(_on_model_selected)
	settings_button.pressed.connect(_on_settings_pressed)


func _load_service_references() -> void:
	"""Load references to required services"""
	# Try to get references to services
	gemini_service = get_node_or_null("/root/GeminiAI")
	ai_assistant = get_node_or_null("/root/AIAssistant")

	# Update status based on service availability
	if gemini_service:
func _update_model_list() -> void:
	"""Update the model dropdown list"""
	model_dropdown.clear()

	if gemini_service:
		# Get models from service if available
func _set_status(status: String) -> void:
	"""Set the status indicator"""
func _on_model_selected(index: int) -> void:
	"""Handle model selection"""
	if index < 0 or not model_dropdown.has_focus():
		return

		current_model = model_dropdown.get_item_text(index)

		if gemini_service:
			gemini_service.set_model(current_model)

			model_changed.emit(current_model)
			print("[GeminiSelector] Model changed to:", current_model)


func _on_settings_pressed() -> void:
	"""Open settings dialog"""
	settings_requested.emit()


func _on_model_list_updated(models: Array) -> void:
	"""Update model list when service updates available models"""
	_update_model_list()


func _on_config_changed(model_name: String, _settings: Dictionary) -> void:
	"""Handle configuration changes"""
	if model_name != current_model:
		current_model = model_name

		# Update dropdown selection without triggering signal
		for i in range(model_dropdown.item_count):
			if model_dropdown.get_item_text(i) == current_model:
				model_dropdown.select(i)
				break


				# === PUBLIC API ===
