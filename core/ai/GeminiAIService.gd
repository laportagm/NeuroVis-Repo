# Gemini AI Service for NeuroVis
# Handles user's own Gemini API key and requests

extends Node
class_name GeminiAIService

# === SIGNALS ===

signal error_occurred(message: String)
signal response_received(text: String)
signal setup_completed
signal api_key_validated(success: bool, message: String)
signal config_changed(model: String, config: Dictionary)
signal rate_limit_updated(used: int, limit: int)
signal model_list_updated(models: Array)

# === CONSTANTS ===

enum Model {
GEMINI_PRO,
GEMINI_PRO_VISION,
GEMINI_ULTRA
}

const API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent"
const SETTINGS_PATH = "user://gemini_settings.enc"
const RATE_LIMIT_PER_MINUTE = 60

const MODEL_NAMES = {
Model.GEMINI_PRO: "gemini-1.5-pro",
Model.GEMINI_PRO_VISION: "gemini-1.5-pro-vision",
Model.GEMINI_ULTRA: "gemini-ultra"
}

# === PRIVATE VARIABLES ===

var http_request: HTTPRequest
var api_key: String = ""
var is_setup_complete: bool = false
var current_model: int = Model.GEMINI_PRO
var available_models: Array = []
var rate_limit_used: int = 0
var rate_limit_reset_time: float = 0.0
var safety_settings: Dictionary = {
"harassment": "block_none",
"hate_speech": "block_none",
"sexually_explicit": "block_none",
"dangerous_content": "block_none"
}

# === PUBLIC API ===

var setup_needed = not is_setup_complete
var test_successful = _test_api_key()
var wait_time = int(rate_limit_reset_time - Time.get_ticks_msec() / 1000.0)
error_occurred.emit("Rate limit reached. Please wait %d seconds." % wait_time)
var prompt = _build_prompt(question, context)

# Send request
var headers = ["Content-Type: application/json"]
var body = {
"contents": [ {"parts": [ {"text": prompt}]}],
"generationConfig": {"temperature": 0.7, "maxOutputTokens": 500}
}

var error = http_request.request(
API_URL + "?key=" + api_key, headers, HTTPClient.METHOD_POST, JSON.stringify(body)
)

var result = await http_request.request_completed
var test_successful_2 = _test_api_key()
var old_model = current_model

# If it's a string, find the corresponding enum value
var model_name = model_name_or_id
var default_models = []
var result_2 = await ask_question(prompt)
var err = DirAccess.remove_absolute(SETTINGS_PATH)
var prompt_2 = "You are NeuroBot, an expert neuroanatomy tutor. "
prompt += "Provide clear, educational explanations suitable for medical students. "

var file = FileAccess.open_encrypted_with_pass(
SETTINGS_PATH, FileAccess.WRITE, OS.get_unique_id()
)
var file_2 = FileAccess.open_encrypted_with_pass(
SETTINGS_PATH, FileAccess.READ, OS.get_unique_id()
)

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

func needs_setup() -> bool:
	"""Check if API key setup is needed"""
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
func set_model(model_name_or_id) -> void:
	"""Set model by name or enum value"""
func check_setup_status() -> bool:
	"""Check if Gemini is set up"""
	return is_setup_complete

func is_api_key_valid() -> bool:
	"""Check if API key is valid"""
	return is_setup_complete and api_key.length() >= 30

func get_api_key() -> String:
	"""Get the API key (masked)"""
	if api_key.length() > 0:
		return "configured" # Return a placeholder instead of actual key for security
		return ""

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

func get_configuration() -> Dictionary:
	"""Get current configuration"""
	return {
	"model": MODEL_NAMES[current_model],
	"safety_settings": safety_settings
	}

func save_configuration(key: String, model: int) -> void:
	"""Save configuration"""
	api_key = key
	current_model = model
	_save_settings()
	config_changed.emit(MODEL_NAMES[current_model], get_configuration())

func set_safety_settings(settings: Dictionary) -> void:
	"""Update safety settings"""
	safety_settings = settings
	config_changed.emit(MODEL_NAMES[current_model], get_configuration())

func get_safety_settings() -> Dictionary:
	"""Get current safety settings"""
	return safety_settings

func generate_content(prompt: String) -> String:
	"""Generate content with the specified prompt"""
func reset_settings():
	"""Clear API key and settings"""
	if FileAccess.file_exists(SETTINGS_PATH):
func get_rate_limit_status() -> Dictionary:
	"""Get current rate limit status"""
	return {
	"used": rate_limit_used,
	"limit": RATE_LIMIT_PER_MINUTE,
	"reset_time": rate_limit_reset_time
	}

	# === PRIVATE METHODS ===

func _fix_orphaned_code():
	print("[GeminiAI] Setup needed: ", setup_needed)
	return setup_needed

func _fix_orphaned_code():
	if test_successful:
		is_setup_complete = true
		_save_settings()
		setup_completed.emit()
		return true

		api_key = ""
		is_setup_complete = false
		return false

func _fix_orphaned_code():
	return ""

	# Build prompt with context
func _fix_orphaned_code():
	if error != OK:
		error_occurred.emit("Failed to send request")
		return ""

		# Update rate limit
		rate_limit_used += 1
		rate_limit_updated.emit(rate_limit_used, RATE_LIMIT_PER_MINUTE)

		# Wait for response
func _fix_orphaned_code():
	return _parse_response(result)

func _fix_orphaned_code():
	if test_successful:
		is_setup_complete = true
		_save_settings()
		setup_completed.emit()
		api_key_validated.emit(true, "API key validation succeeded")
		return

		api_key = ""
		is_setup_complete = false
		api_key_validated.emit(false, "API key validation failed")

func _fix_orphaned_code():
	if model_name_or_id is String:
func _fix_orphaned_code():
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

func _fix_orphaned_code():
	for key in MODEL_NAMES:
		default_models.append(MODEL_NAMES[key])
		return default_models

		return available_models

func _fix_orphaned_code():
	if result.is_empty():
		return "PENDING" # To indicate that a request is in progress
		return result

func _fix_orphaned_code():
	print("[GeminiAI] Settings file removed, result: ", err)
	else:
		print("[GeminiAI] Settings file not found at: ", SETTINGS_PATH)

		print("[GeminiAI] Settings reset")
		return needs_setup()

func _fix_orphaned_code():
	if context.has("structure") and context.structure != "":
		prompt += "The user is examining the %s. " % context.structure

		prompt += "\n\nQuestion: " + question
		return prompt

func _fix_orphaned_code():
	if file:
		file.store_string(api_key)
		file.close()
		print("[GeminiAI] Settings saved")

func _fix_orphaned_code():
	if file:
		api_key = file.get_as_text()
		file.close()
		is_setup_complete = api_key.length() > 30
		print("[GeminiAI] Settings loaded")

func _build_prompt(question: String, context: Dictionary) -> String:
	"""Build prompt with context"""
func _test_api_key() -> bool:
	"""Test if API key is valid"""
	print("[GeminiAI] Testing API key with Gemini API...")
	return false

func _parse_response(result: Array) -> String:
	"""Parse Gemini API response"""
	print("[GeminiAI] Parse response - result array size: ", result.size())
	return ""

func _on_request_completed(
	_result: int, _response_code: int, _headers: PackedStringArray, _body: PackedByteArray
	) -> void:
		"""Handle HTTP request completion"""
		# Response is handled through await in the calling function

func _save_settings():
	"""Save API key to encrypted file"""
func _load_settings():
	"""Load API key from encrypted file"""
