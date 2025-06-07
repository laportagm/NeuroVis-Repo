extends Node

## AI Assistant Service for Educational Support
## Provides AI-powered educational assistance for NeuroVis
## @version: 2.0

# === CONSTANTS ===
const DEFAULT_MODEL = "gemini-1.5-flash"

# === SIGNALS ===
signal response_received(response: String)
signal error_occurred(error: String)

# === VARIABLES ===
var _current_provider: String = ""
var _is_initialized: bool = false
var _provider_registry


# === LIFECYCLE ===
func _ready() -> void:
	"""Initialize AI assistant service"""
	_initialize_service()


# === PUBLIC METHODS ===
func is_available() -> bool:
	"""Check if AI assistant is available"""
	return _is_initialized and not _current_provider.is_empty()


func ask_question(question: String, context: Dictionary = {}) -> void:
	"""Ask a question to the AI assistant"""
	if not is_available():
		error_occurred.emit("AI Assistant not available")
		return

	print("[AIAssistant] Processing question: " + question)
	# Simulate response for now
	response_received.emit("Educational response about: " + question)


func set_provider(provider_name: String) -> bool:
	"""Set the active AI provider"""
	_current_provider = provider_name
	print("[AIAssistant] Provider set to: " + provider_name)
	return true


# === PRIVATE METHODS ===
func _initialize_service() -> void:
	"""Initialize the AI service"""
	print("[AIAssistant] Initializing AI assistant service...")
	# Initialize without AIProviderRegistry for now
	_provider_registry = null
	_is_initialized = true
	print("[AIAssistant] AI assistant service ready")
