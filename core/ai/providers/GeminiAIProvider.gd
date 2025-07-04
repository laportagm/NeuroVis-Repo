## GeminiAIProvider.gd
## Google Gemini AI provider implementation for NeuroVis
##
## This provider implements the AIProviderInterface for Google's Gemini
## AI models, providing integration with the Gemini API for educational
## neuroanatomy assistance.
##
## @tutorial: Gemini AI Integration Guide
## @version: 1.0

class_name GeminiAIProvider
extends AIProviderInterface

# === CONSTANTS ===

enum GeminiModel { GEMINI_PRO, GEMINI_PRO_VISION, GEMINI_FLASH }

const GEMINI_SETTINGS_PATH = "user://gemini_settings.dat"
const API_URL_BASE = "https://generativelanguage.googleapis.com/v1beta/models/"
const RATE_LIMIT_PER_MINUTE = 60

# === MODELS ===
const MODEL_NAMES = {
GeminiModel.GEMINI_PRO: "gemini-1.5-pro",
GeminiModel.GEMINI_PRO_VISION: "gemini-1.5-pro-vision",
GeminiModel.GEMINI_FLASH: "gemini-1.5-flash"
}

# === STATE ===

var api_key: String = ""
var is_setup_complete: bool = false
var is_initialized: bool = false
var rate_limit_used: int = 0
var rate_limit_reset_time: float = 0
var http_request: HTTPRequest
var current_model: GeminiModel = GeminiModel.GEMINI_PRO
var temperature: float = 0.7
var max_output_tokens: int = 2048
var safety_settings: Dictionary = {
"HARASSMENT": 2, "HATE_SPEECH": 2, "SEXUALLY_EXPLICIT": 2, "DANGEROUS_CONTENT": 2
}
# FIXED: Orphaned code - var available_models: Array = []
var current_structure: String = ""

# === EDUCATIONAL CONTEXT ===
var educational_prompts = {
"system_prompt":
	"You are NeuroBot, an expert neuroanatomy tutor. Provide clear, educational explanations about brain structures, their functions, and relationships. Keep responses concise but informative, suitable for medical students.",
	"structure_context_template":
		"The user is currently examining the {structure_name}. Answer questions in this context.",
		"question_types":
			{
			"function": "Explain the primary functions of the {structure_name}.",
			"location": "Describe where the {structure_name} is located in the brain.",
			"connections": "What structures does the {structure_name} connect to?",
			"clinical": "What happens when the {structure_name} is damaged?",
			"development": "How does the {structure_name} develop?",
			"comparison": "How does the {structure_name} compare to {other_structure}?"
			}
			}


			# === IMPLEMENTATION OF REQUIRED METHODS ===
var result = await _test_api_key()
# FIXED: Orphaned code - var wait_time = int(rate_limit_reset_time - Time.get_ticks_msec() / 1000.0)
	push_warning("[GeminiAI] API limit: Rate limit reached - wait %d seconds" % wait_time)
	error_occurred.emit("Rate limit reached. Please wait %d seconds." % wait_time)
# FIXED: Orphaned code - var prompt = _build_educational_prompt(question)

# Send request to Gemini API
var url = _get_api_url_for_model() + ":generateContent?key=" + api_key
var headers = ["Content-Type: application/json"]
var body = {
	"contents": [{"parts": [{"text": prompt}]}],
	"generationConfig": {"temperature": temperature, "maxOutputTokens": max_output_tokens}
	}

# FIXED: Orphaned code - var error = http_request.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(body))

# FIXED: Orphaned code - var test_key = key.strip_edges()

# Basic validation
var temp_api_key = api_key
	api_key = test_key

var result_2 = await _test_api_key()

# Restore original key
	api_key = temp_api_key

	# Emit result
	api_key_validated.emit(result, "API key validation " + ("succeeded" if result else "failed"))


# FIXED: Orphaned code - var old_model = current_model

# If it's a string, find the corresponding enum value
var model_name = model_name_or_id
var err = DirAccess.remove_absolute(GEMINI_SETTINGS_PATH)
# FIXED: Orphaned code - var prompt_2 = educational_prompts.system_prompt

# Add structure context if available
var model_name_2 = MODEL_NAMES[current_model]
var test_prompt = "Respond with exactly: 'API key valid'"
var headers_2 = ["Content-Type: application/json"]
var body_2 = {
	"contents": [{"parts": [{"text": test_prompt}]}],
	"generationConfig": {"temperature": 0, "maxOutputTokens": 20}
	}

	# Use the fastest model for testing
var test_url = API_URL_BASE + "gemini-1.5-flash:generateContent?key=" + api_key

var error_2 = http_request.request(
	test_url, headers, HTTPClient.METHOD_POST, JSON.stringify(body)
	)

# FIXED: Orphaned code - var result_3 = await http_request.request_completed
var response_code = result[1]

# Check if response code indicates success
var error_body = body.get_string_from_utf8()
	push_error("[GeminiAI] Error: API returned HTTP " + str(response_code) + " - " + error_body)
	error_occurred.emit("API error: HTTP " + str(response_code) + " - " + error_body)

	# Parse response
var json = JSON.new()
# FIXED: Orphaned code - var parse_result = json.parse(body.get_string_from_utf8())

# FIXED: Orphaned code - var data = json.data

# Extract response text
var response_text = ""
var candidate = data.candidates[0]
var file = FileAccess.open_encrypted_with_pass(
	GEMINI_SETTINGS_PATH, FileAccess.WRITE, OS.get_unique_id()
	)

# FIXED: Orphaned code - var data_2 = {
	"api_key": api_key,
	"model": current_model,
	"temperature": temperature,
	"max_output_tokens": max_output_tokens,
	"safety_settings": safety_settings
	}

	file.store_string(JSON.stringify(data))
	file.close()
# FIXED: Orphaned code - var file_2 = FileAccess.open_encrypted_with_pass(
	GEMINI_SETTINGS_PATH, FileAccess.READ, OS.get_unique_id()
	)

# FIXED: Orphaned code - var json_data = file.get_as_text()
	file.close()

# FIXED: Orphaned code - var json_2 = JSON.new()
# FIXED: Orphaned code - var parse_result_2 = json.parse(json_data)

# FIXED: Orphaned code - var data_3 = json.data

# Load settings

func _process(_delta) -> void:
	"""Handle rate limit reset"""
	if not is_initialized:
		return

		# Reset rate limit every minute
		if Time.get_ticks_msec() / 1000.0 > rate_limit_reset_time:
			rate_limit_reset_time = Time.get_ticks_msec() / 1000.0 + 60.0
			rate_limit_used = 0
			rate_limit_updated.emit(rate_limit_used, RATE_LIMIT_PER_MINUTE)


func initialize() -> bool:
	"""Initialize the Gemini AI provider"""
	if is_initialized:
		return true

		print("[GeminiAI] Info: Initializing Gemini AI provider...")

		# Create HTTP request node for API calls
		http_request = HTTPRequest.new()
		add_child(http_request)
		http_request.request_completed.connect(_on_request_completed)
		http_request.timeout = 30.0

		# Ensure SSL certificates are properly validated
		http_request.set_tls_options(TLSOptions.client())

		# Load saved settings
		_load_settings()

		# Start rate limit timer
		set_process(true)

		is_initialized = true
		print("[GeminiAI] Info: Gemini AI provider initialized")
		return true


func setup_api_key(key: String) -> bool:
	"""Set up and validate API key"""
	print("[GeminiAI] Info: Setting up API key...")
	api_key = key.strip_edges()

	# Basic validation
	if api_key.length() < 30:
		push_error("[GeminiAI] Configuration error: Invalid API key format - key too short")
		error_occurred.emit("Invalid API key format")
		return false

		# Test the key
func ask_question(question: String, context: Dictionary = {}) -> String:
	"""Send question to Gemini API"""
	if OS.is_debug_build():
		print("[GeminiAI] Debug: Asking question: %s" % question)

		if not is_setup_complete:
			push_error("[GeminiAI] Configuration error: Gemini AI not set up - API key not configured")
			error_occurred.emit("Gemini AI not set up. Please configure your API key.")
			return ""

			if rate_limit_used >= RATE_LIMIT_PER_MINUTE:
func generate_content(prompt: String) -> String:
	"""Generate content with the specified prompt"""
	print("[GeminiAI] Info: Generating content with prompt")

	if not is_setup_complete:
		push_error("[GeminiAI] Error: Cannot generate content - API key not configured")
		error_occurred.emit("Gemini AI not set up. Please configure your API key.")
		return ""

		# Use ask_question implementation for consistency
		return ask_question(prompt)


func check_setup_status() -> bool:
	"""Check if Gemini is set up"""
	return is_setup_complete and is_api_key_valid()


func needs_setup() -> bool:
	"""Check if setup is needed"""
	return not is_setup_complete or api_key.is_empty()


func is_api_key_valid() -> bool:
	"""Check if API key is valid"""
	return is_setup_complete and api_key.length() >= 30


func validate_api_key(key: String) -> void:
	"""Validate API key and emit result signal"""
	print("[GeminiAI] Info: Validating API key")

func get_service_status() -> Dictionary:
	"""Get current service status"""
	return {
	"initialized": is_initialized,
	"setup_complete": is_setup_complete,
	"api_configured": is_api_key_valid(),
	"provider": "gemini",
	"model": MODEL_NAMES[current_model],
	"rate_limit":
		{
		"used": rate_limit_used,
		"limit": RATE_LIMIT_PER_MINUTE,
		"reset_in": int(max(0, rate_limit_reset_time - Time.get_ticks_msec() / 1000.0))
		},
		"current_structure": current_structure
		}


func get_available_models() -> Array:
	"""Get list of available models"""
	if available_models.is_empty():
		# Return default models if none available yet
		return MODEL_NAMES.values()

		return available_models


func set_model(model_name_or_id) -> void:
	"""Set model by name or enum value"""
func get_configuration() -> Dictionary:
	"""Get current configuration"""
	return {
	"provider": "gemini",
	"model": current_model,
	"model_name": MODEL_NAMES[current_model],
	"temperature": temperature,
	"max_output_tokens": max_output_tokens,
	"safety_settings": safety_settings,
	"models":
		{
		MODEL_NAMES[GeminiModel.GEMINI_PRO]: {"description": "General text model"},
		MODEL_NAMES[GeminiModel.GEMINI_PRO_VISION]: {"description": "Text and vision model"},
		MODEL_NAMES[GeminiModel.GEMINI_FLASH]: {"description": "Fast response model"}
		}
		}


func set_configuration(config: Dictionary) -> void:
	"""Update provider configuration"""
	if config.has("model"):
		set_model(config.model)

		if config.has("temperature"):
			set_temperature(config.temperature)

			if config.has("max_output_tokens"):
				set_max_tokens(config.max_output_tokens)

				if config.has("safety_settings"):
					set_safety_settings(config.safety_settings)

					print("[GeminiAI] Info: Configuration updated")
					config_changed.emit(MODEL_NAMES[current_model], get_configuration())


func save_configuration(key: String, model) -> void:
	"""Save configuration"""
	if key.strip_edges() != "":
		api_key = key.strip_edges()

		if model is int and MODEL_NAMES.has(model):
			current_model = model

			_save_settings()

			config_changed.emit(MODEL_NAMES[current_model], get_configuration())
			print("[GeminiAI] Info: Configuration saved")


func reset_settings() -> bool:
	"""Clear API key and settings"""
	api_key = ""
	is_setup_complete = false
	rate_limit_used = 0

	# Delete saved settings
	if FileAccess.file_exists(GEMINI_SETTINGS_PATH):
func set_current_structure(structure_name: String) -> void:
	"""Set the current brain structure for context"""
	current_structure = structure_name
	print("[GeminiAI] Info: Current structure set to: " + structure_name)


func get_rate_limit_status() -> Dictionary:
	"""Get current rate limit status"""
	return {
	"used": rate_limit_used,
	"limit": RATE_LIMIT_PER_MINUTE,
	"reset_in": int(max(0, rate_limit_reset_time - Time.get_ticks_msec() / 1000.0))
	}


func set_temperature(value: float) -> void:
	"""Set temperature value"""
	temperature = clamp(value, 0.0, 1.0)


func set_max_tokens(value: int) -> void:
	"""Set max tokens value"""
	max_output_tokens = max(1, value)


func set_safety_settings(settings: Dictionary) -> void:
	"""Update safety settings"""
	for category in settings:
		if safety_settings.has(category):
			safety_settings[category] = settings[category]

			print("[GeminiAI] Info: Safety settings updated")


func get_safety_settings() -> Dictionary:
	"""Get current safety settings"""
	return safety_settings.duplicate()


	# === PRIVATE METHODS ===

if result:
	is_setup_complete = true
	_save_settings()
	setup_completed.emit()
	if OS.is_debug_build():
		print("[GeminiAI] Debug: API key setup successful")
		return true
		else:
			api_key = ""
			is_setup_complete = false
			push_error("[GeminiAI] API validation error: Failed to validate API key with Gemini API")
			error_occurred.emit("Failed to validate API key")
			return false


return ""

# Update current structure from context
if context.has("structure"):
	current_structure = context.structure

	# Build prompt with educational context
if error != OK:
	push_error("[GeminiAI] Error: Failed to send HTTP request - error code: " + str(error))
	error_occurred.emit("Failed to send request to Gemini API")
	return ""

	# Update rate limit
	rate_limit_used += 1
	rate_limit_updated.emit(rate_limit_used, RATE_LIMIT_PER_MINUTE)

	# Return empty string as we'll emit the response via signal when it's ready
	return ""


if test_key.length() < 30:
	push_warning("[GeminiAI] Warning: API key validation failed - key too short")
	api_key_validated.emit(false, "Invalid API key format")
	return

	# Test with API
if model_name_or_id is String:
for key in MODEL_NAMES:
	if MODEL_NAMES[key] == model_name:
		current_model = key
		print("[GeminiAI] Info: Model set to: " + model_name)
		break
		# If it's a number, use it directly
		elif model_name_or_id is int:
			if model_name_or_id in MODEL_NAMES:
				current_model = model_name_or_id

				# Emit signal if model changed
				if old_model != current_model:
					config_changed.emit(MODEL_NAMES[current_model], get_configuration())


if err == OK:
	print("[GeminiAI] Info: Settings file removed successfully")
	else:
		push_warning("[GeminiAI] Warning: Failed to remove settings file - error: " + str(err))

		print("[GeminiAI] Info: Settings reset")
		return true


if not current_structure.is_empty():
	prompt += (
	" "
	+ educational_prompts.structure_context_template.format(
	{"structure_name": current_structure}
	)
	)

	# Add question
	prompt += "\n\nQuestion: " + question

	return prompt


return API_URL_BASE + model_name


if error != OK:
	push_error(
	"[GeminiAI] Error: HTTP request failed during API key test - error code: " + str(error)
	)
	return false

	# Wait for response
return response_code == 200


if parse_result != OK:
	push_error(
	"[GeminiAI] Error: Failed to parse API response - parse error: " + str(parse_result)
	)
	error_occurred.emit("Failed to parse API response")
	return

if data.has("candidates") and data.candidates.size() > 0:
if candidate.has("content") and candidate.content.has("parts"):
	response_text = candidate.content.parts[0].text

	if response_text.is_empty():
		push_warning("[GeminiAI] Warning: Empty response received from Gemini API")
		error_occurred.emit("Empty response from Gemini API")
		return

		# Emit response
		response_received.emit(response_text)


if file:
print("[GeminiAI] Info: Settings saved")
else:
	push_error("[GeminiAI] Error: Failed to save settings - could not open file")


if file:
if parse_result == OK:
if data.has("api_key"):
	api_key = data.api_key
	is_setup_complete = api_key.length() >= 30

	if data.has("model"):
		current_model = data.model

		if data.has("temperature"):
			temperature = data.temperature

			if data.has("max_output_tokens"):
				max_output_tokens = data.max_output_tokens

				if data.has("safety_settings"):
					safety_settings = data.safety_settings

					print("[GeminiAI] Info: Settings loaded")
					else:
						push_error(
						(
						"[GeminiAI] Error: Failed to parse settings file - parse error: "
						+ str(parse_result)
						)
						)
						else:
							push_error("[GeminiAI] Error: Failed to open settings file - could not decrypt")

func _build_educational_prompt(question: String) -> String:
	"""Build an educational prompt with appropriate context"""
func _get_api_url_for_model() -> String:
	"""Get the API URL for the current model"""
func _test_api_key() -> bool:
	"""Test if API key is valid"""
	print("[GeminiAI] Info: Testing API key with Gemini API...")

	# Use a simple test prompt
func _on_request_completed(
	result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray
	) -> void:
		"""Handle API response"""
if result != HTTPRequest.RESULT_SUCCESS:
	push_error("[GeminiAI] Error: API request failed - result code: " + str(result))
	error_occurred.emit("API request failed")
	return

	if response_code != 200:
func _save_settings() -> void:
	"""Save settings to an encrypted file"""
func _load_settings() -> void:
	"""Load settings from an encrypted file"""
	if not FileAccess.file_exists(GEMINI_SETTINGS_PATH):
		print("[GeminiAI] Info: No settings file found")
		return
