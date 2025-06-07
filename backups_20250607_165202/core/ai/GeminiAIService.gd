# Gemini AI Service for NeuroVis
# Handles user's own Gemini API key and requests

extends Node
class_name GeminiAIService

# Models

signal response_received(response: String)
signal error_occurred(error: String)
signal rate_limit_updated(used: int, limit: int)
signal setup_completed
signal api_key_validated(success: bool, message: String)
signal model_list_updated(models: Array)
signal config_changed(model_name: String, settings: Dictionary)

# Configuration

enum GeminiModel { GEMINI_PRO, GEMINI_PRO_VISION, GEMINI_FLASH }

const MODEL_NAMES = {
	GeminiModel.GEMINI_PRO: "gemini-1.5-pro",
	GeminiModel.GEMINI_PRO_VISION: "gemini-1.5-pro-vision",
	GeminiModel.GEMINI_FLASH: "gemini-1.5-flash"
}

# Signals
const SETTINGS_PATH = "user://gemini_settings.dat"
const API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent"
const RATE_LIMIT_PER_MINUTE = 60

# State

var api_key: String = ""
var is_setup_complete: bool = false
var rate_limit_used: int = 0
var rate_limit_reset_time: float = 0
var http_request: HTTPRequest
var current_model: GeminiModel = GeminiModel.GEMINI_PRO
var temperature: float = 0.7
var max_output_tokens: int = 2048
var safety_settings: Dictionary = {
	"HARASSMENT": 2, "HATE_SPEECH": 2, "SEXUALLY_EXPLICIT": 2, "DANGEROUS_CONTENT": 2
}
var available_models: Array = []


	var test_successful = await _test_api_key()
	if test_successful:
		is_setup_complete = true
		_save_settings()
		setup_completed.emit()
		return true
	else:
		api_key = ""
		is_setup_complete = false
		return false


		var wait_time = int(rate_limit_reset_time - Time.get_ticks_msec() / 1000.0)
		error_occurred.emit("Rate limit reached. Please wait %d seconds." % wait_time)
		return ""

	# Build prompt with context
	var prompt = _build_prompt(question, context)

	# Send request
	var headers = ["Content-Type: application/json"]
	var body = {
		"contents": [{"parts": [{"text": prompt}]}],
		"generationConfig": {"temperature": 0.7, "maxOutputTokens": 500}
	}

	var error = http_request.request(
		API_URL + "?key=" + api_key, headers, HTTPClient.METHOD_POST, JSON.stringify(body)
	)

	if error != OK:
		error_occurred.emit("Failed to send request")
		return ""

	# Update rate limit
	rate_limit_used += 1
	rate_limit_updated.emit(rate_limit_used, RATE_LIMIT_PER_MINUTE)

	# Wait for response
	var result = await http_request.request_completed
	return _parse_response(result)


	var setup_needed = not is_setup_complete
	print("[GeminiAI] Setup needed: ", setup_needed)

	# Uncommment this line to force setup dialog for testing
	# return true

	return setup_needed


	var test_successful = await _test_api_key()
	print("[GeminiAI] API test result: ", test_successful)
	api_key_validated.emit(
		test_successful, "API key validation " + ("succeeded" if test_successful else "failed")
	)


		var default_models = []
		for key in MODEL_NAMES:
			default_models.append(MODEL_NAMES[key])
		return default_models

	return available_models


	var old_model = current_model

	# If it's a string, find the corresponding enum value
	if model_name_or_id is String:
		var model_name = model_name_or_id
		for key in MODEL_NAMES:
			if MODEL_NAMES[key] == model_name:
				current_model = key
				print("[GeminiAI] Model set to: " + model_name)
				break
	# If it's a number, use it directly
	elif model_name_or_id is int:
		if model_name_or_id in MODEL_NAMES:
			current_model = model_name_or_id

	# Emit signal if model changed
	if old_model != current_model:
		config_changed.emit(MODEL_NAMES[current_model], get_configuration())


	var result = await ask_question(prompt)

	if result.is_empty():
		return "PENDING"  # To indicate that a request is in progress
	return result


		var err = DirAccess.remove_absolute(SETTINGS_PATH)
		print("[GeminiAI] Settings file removed, result: ", err)
	else:
		print("[GeminiAI] Settings file not found at: ", SETTINGS_PATH)

	print("[GeminiAI] Settings reset")

	# Force need setup flag
	return needs_setup()


	var prompt = "You are NeuroBot, an expert neuroanatomy tutor. "
	prompt += "Provide clear, educational explanations suitable for medical students. "

	if context.has("structure") and context.structure != "":
		prompt += "The user is examining the %s. " % context.structure

	prompt += "\n\nQuestion: " + question
	return prompt


	var test_prompt = "Respond with exactly: 'API key valid'"
	var headers = ["Content-Type: application/json"]
	var body = {
		"contents": [{"parts": [{"text": test_prompt}]}],
		"generationConfig": {"temperature": 0, "maxOutputTokens": 20}
	}

	# Use gemini-1.5-flash-latest for testing
	var test_url = (
		"https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key="
		+ api_key
	)
	print("[GeminiAI] Request URL: ", test_url.substr(0, 80), "...")
	print("[GeminiAI] Request body: ", JSON.stringify(body))

	var error = http_request.request(
		test_url, headers, HTTPClient.METHOD_POST, JSON.stringify(body)
	)

	if error != OK:
		print("[GeminiAI] HTTP request failed with error: ", error)
		return false

	print("[GeminiAI] Waiting for API response...")
	var result = await http_request.request_completed
	print("[GeminiAI] Response received, parsing...")
	var response = await _parse_response(result)
	print("[GeminiAI] Parsed response: ", response)
	return response != ""


	var response_code = result[1]
	var headers = result[2]
	var body = result[3]

	print("[GeminiAI] Response code: ", response_code)
	print("[GeminiAI] Response headers: ", headers)

	if response_code != 200:
		var error_body = body.get_string_from_utf8()
		print("[GeminiAI] Error response body: ", error_body)
		error_occurred.emit("API error: HTTP " + str(response_code) + " - " + error_body)
		return ""

	var json = JSON.new()
	var body_string = body.get_string_from_utf8()
	print("[GeminiAI] Response body: ", body_string.substr(0, 200), "...")
	var parse_result = json.parse(body_string)

	if parse_result != OK:
		error_occurred.emit("Failed to parse API response")
		return ""

	var data = json.data
	if data.has("candidates") and data.candidates.size() > 0:
		var candidate = data.candidates[0]
		if candidate.has("content") and candidate.content.has("parts"):
			var text = candidate.content.parts[0].text
			response_received.emit(text)
			return text

	error_occurred.emit("Invalid API response format")
	return ""


	var file = FileAccess.open_encrypted_with_pass(
		SETTINGS_PATH, FileAccess.WRITE, OS.get_unique_id()
	)
	if file:
		file.store_string(api_key)
		file.close()
		print("[GeminiAI] Settings saved")


	var file = FileAccess.open_encrypted_with_pass(
		SETTINGS_PATH, FileAccess.READ, OS.get_unique_id()
	)
	if file:
		api_key = file.get_as_text()
		file.close()
		is_setup_complete = api_key.length() > 30
		print("[GeminiAI] Settings loaded")

func _ready():
	# Create HTTP client
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

	print("[GeminiAI] Service initialized with TLS enabled")


func _process(_delta):
	# Reset rate limit every minute
	if Time.get_ticks_msec() / 1000.0 > rate_limit_reset_time:
		rate_limit_reset_time = Time.get_ticks_msec() / 1000.0 + 60.0
		rate_limit_used = 0
		rate_limit_updated.emit(rate_limit_used, RATE_LIMIT_PER_MINUTE)


# === PUBLIC API ===

func setup_api_key(key: String) -> bool:
	"""Set up and validate API key"""
	api_key = key.strip_edges()

	# Basic validation
	if api_key.length() < 30:
		error_occurred.emit("Invalid API key format")
		return false

	# Test the key
func ask_question(question: String, context: Dictionary = {}) -> String:
	"""Send question to Gemini API"""
	if not is_setup_complete:
		error_occurred.emit("Gemini AI not set up. Please configure your API key.")
		return ""

	if rate_limit_used >= RATE_LIMIT_PER_MINUTE:
func check_setup_status() -> bool:
	"""Check if Gemini is set up"""
	return is_setup_complete


func needs_setup() -> bool:
	"""Check if setup is needed"""
	# Check if file exists
func is_api_key_valid() -> bool:
	"""Check if API key is valid"""
	return is_setup_complete and api_key.length() >= 30


func get_api_key() -> String:
	"""Get the API key (masked)"""
	if api_key.length() > 0:
		return "configured"  # Return a placeholder instead of actual key for security
	return ""


func validate_api_key(key: String) -> void:
	"""Validate API key and emit result signal"""
	print("[GeminiAI] Validating API key: ", key.substr(0, 10), "...")
	api_key = key.strip_edges()

	# Basic validation
	if api_key.length() < 30:
		print("[GeminiAI] API key too short: ", api_key.length(), " characters")
		api_key_validated.emit(false, "Invalid API key format")
		return

	print("[GeminiAI] API key format looks valid, testing with API...")
	# Do the validation test
func get_model_name() -> String:
	"""Get current model name"""
	return MODEL_NAMES[current_model]


func get_model_list() -> Array:
	"""Get available models"""
	if available_models.is_empty():
		# Return default models if none available yet
func update_available_models() -> void:
	"""Update list of available models"""
	# In a real implementation, this would query the API
	# For now, just use the predefined models
	available_models = []
	for key in MODEL_NAMES:
		available_models.append(MODEL_NAMES[key])

	print("[GeminiAI] Updated available models: ", available_models)
	model_list_updated.emit(available_models)


func set_model(model_name_or_id) -> void:
	"""Set model by name or enum value"""
func get_configuration() -> Dictionary:
	"""Get current configuration"""
	return {
		"model": current_model,
		"temperature": temperature,
		"max_output_tokens": max_output_tokens,
		"safety_settings": safety_settings
	}


func save_configuration(key: String, model: int) -> void:
	"""Save configuration"""
	if key.strip_edges() != "":
		api_key = key.strip_edges()
	current_model = model as GeminiModel

	_save_settings()

	print("[GeminiAI] Configuration saved successfully")
	config_changed.emit(MODEL_NAMES[current_model], get_configuration())


func set_safety_settings(settings: Dictionary) -> void:
	"""Update safety settings"""
	for category in settings:
		if category in safety_settings:
			safety_settings[category] = settings[category]

	print("[GeminiAI] Safety settings updated")
	config_changed.emit(MODEL_NAMES[current_model], get_configuration())


func get_safety_settings() -> Dictionary:
	"""Get current safety settings"""
	return safety_settings


func generate_content(prompt: String) -> String:
	"""Generate content with the specified prompt"""
	if not is_setup_complete:
		return "API not configured"
	# This is a simplified version - full implementation would use HTTP requests
func reset_settings():
	"""Clear API key and settings"""
	api_key = ""
	is_setup_complete = false
	rate_limit_used = 0

	# Delete saved settings
	if FileAccess.file_exists(SETTINGS_PATH):
func get_rate_limit_status() -> Dictionary:
	"""Get current rate limit status"""
	return {
		"used": rate_limit_used,
		"limit": RATE_LIMIT_PER_MINUTE,
		"reset_in": int(max(0, rate_limit_reset_time - Time.get_ticks_msec() / 1000.0))
	}


# === PRIVATE METHODS ===

func _build_prompt(question: String, context: Dictionary) -> String:
	"""Build prompt with educational context"""
func _test_api_key() -> bool:
	"""Test if API key is valid"""
	print("[GeminiAI] Testing API key with Gemini API...")
func _parse_response(result: Array) -> String:
	"""Parse Gemini API response"""
	print("[GeminiAI] Parse response - result array size: ", result.size())
func _on_request_completed(
	_result: int, _response_code: int, _headers: PackedStringArray, _body: PackedByteArray
):
	"""Handle HTTP request completion"""
	# Response is handled through await in the calling function
	pass


func _save_settings():
	"""Save API key to encrypted file"""
func _load_settings():
	"""Load API key from encrypted file"""
	if not FileAccess.file_exists(SETTINGS_PATH):
		return

