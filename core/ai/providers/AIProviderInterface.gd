## AIProviderInterface.gd
## A common interface for all AI provider implementations in NeuroVis
##
## This interface defines the required methods that all AI providers
## must implement to ensure consistent behavior and easy swapping between
## different AI services (Gemini, Claude, OpenAI, etc.)
##
## @tutorial: AI Provider Integration Guide
## @version: 1.0

class_name AIProviderInterface
extends Node

# === SIGNALS ===

signal response_received(response: String)
signal error_occurred(error: String)
signal rate_limit_updated(used: int, limit: int)
signal setup_completed
signal api_key_validated(success: bool, message: String)
# signal model_list_updated(models: Array) - Currently unused but may be needed in future
signal config_changed(model_name: String, settings: Dictionary)

# === CONFIGURATION ===
# Each provider should define its own configuration constants

const SETTINGS_PATH = "user://ai_provider_settings.dat"

# === REQUIRED METHODS ===
# These methods must be implemented by all provider classes


var file = FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, OS.get_unique_id())

var json_data = JSON.stringify(data)
file.store_string(json_data)
file.close()
var file_2 = FileAccess.open_encrypted_with_pass(path, FileAccess.READ, OS.get_unique_id())

var json_data_2 = file.get_as_text()
file.close()

var json = JSON.new()
var parse_result = json.parse(json_data)

func initialize() -> bool:
	"""Initialize the AI provider with required services"""
	push_error("AIProviderInterface.initialize() must be implemented by subclass")
	return false


func setup_api_key(_key: String) -> bool:
	"""Set up and validate API key"""
	push_error("AIProviderInterface.setup_api_key() must be implemented by subclass")
	return false


func ask_question(_question: String, _context: Dictionary = {}) -> String:
	"""Send question to AI service and return response (or empty if async)"""
	push_error("AIProviderInterface.ask_question() must be implemented by subclass")
	return ""


func generate_content(_prompt: String) -> String:
	"""Generate content with the specified prompt (or empty if async)"""
	push_error("AIProviderInterface.generate_content() must be implemented by subclass")
	return ""


func check_setup_status() -> bool:
	"""Check if provider is properly set up and ready to use"""
	push_error("AIProviderInterface.check_setup_status() must be implemented by subclass")
	return false


func needs_setup() -> bool:
	"""Check if provider needs initial setup"""
	push_error("AIProviderInterface.needs_setup() must be implemented by subclass")
	return true


func validate_api_key(_key: String) -> void:
	"""Validate API key and emit result signal"""
	push_error("AIProviderInterface.validate_api_key() must be implemented by subclass")
	api_key_validated.emit(false, "Not implemented")


func get_service_status() -> Dictionary:
	"""Get current service status information"""
	push_error("AIProviderInterface.get_service_status() must be implemented by subclass")
	return {"initialized": false, "setup_complete": false, "api_configured": false}


func get_available_models() -> Array:
	"""Get list of available models"""
	push_error("AIProviderInterface.get_available_models() must be implemented by subclass")
	return []


func set_model(_model_name_or_id: String) -> void:
	"""Set model by name or enum value"""
	push_error("AIProviderInterface.set_model() must be implemented by subclass")


func get_configuration() -> Dictionary:
	"""Get current configuration"""
	push_error("AIProviderInterface.get_configuration() must be implemented by subclass")
	return {}


func set_configuration(_config: Dictionary) -> void:
	"""Update provider configuration"""
	push_error("AIProviderInterface.set_configuration() must be implemented by subclass")


func save_configuration(_key: String, _model: String) -> void:
	"""Save configuration"""
	push_error("AIProviderInterface.save_configuration() must be implemented by subclass")


func reset_settings() -> bool:
	"""Clear API key and settings"""
	push_error("AIProviderInterface.reset_settings() must be implemented by subclass")
	return false


	# === OPTIONAL METHODS ===
	# These methods can be implemented by provider classes if needed


func set_safety_settings(settings: Dictionary) -> void:
	"""Update safety settings - implementation optional"""
	pass


func get_safety_settings() -> Dictionary:
	"""Get current safety settings - implementation optional"""
	return {}


func get_rate_limit_status() -> Dictionary:
	"""Get current rate limit status - implementation optional"""
	return {"used": 0, "limit": 0, "reset_in": 0}


func update_available_models() -> void:
	"""Update list of available models - implementation optional"""
	pass


func set_temperature(value: float) -> void:
	"""Set temperature value for responses - implementation optional"""
	pass


func set_max_tokens(value: int) -> void:
	"""Set max tokens for responses - implementation optional"""
	pass


	# === UTILITY METHODS ===
	# These methods can be used by provider implementations


func _fix_orphaned_code():
	if file:
func _fix_orphaned_code():
	return true

	return false


func _fix_orphaned_code():
	if file:
func _fix_orphaned_code():
	if parse_result == OK:
		return json.data

		return {}

func _save_encrypted_settings(data: Dictionary, path: String = SETTINGS_PATH) -> bool:
	"""Save encrypted settings to a file"""
func _load_encrypted_settings(path: String = SETTINGS_PATH) -> Dictionary:
	"""Load encrypted settings from a file"""
	if not FileAccess.file_exists(path):
		return {}

		@tool
