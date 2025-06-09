## AIProviderInterface.gd
## Base interface for AI providers in NeuroVis
##
## This interface defines the contract that all AI providers must implement
## to work with the NeuroVis AI system. It provides a consistent API for
## asking questions, generating content, and managing provider configuration.
##
## @tutorial: AI Provider Implementation Guide
## @version: 1.0

class_name AIProviderInterface
extends Node

# === SIGNALS ===

signal response_received(response: String)
signal error_occurred(error_message: String)
signal setup_completed
signal setup_cancelled
signal config_changed(model_name: String, config: Dictionary)
signal api_key_validated(valid: bool, message: String)
signal rate_limit_updated(used: int, limit: int)

# === REQUIRED METHODS ===
# These methods must be implemented by all providers


func initialize() -> bool:
	"""Initialize the AI provider"""
	push_error("AIProviderInterface.initialize() not implemented")
	return false


func setup_api_key(key: String) -> bool:
	"""Set up and validate API key"""
	push_error("AIProviderInterface.setup_api_key() not implemented")
	return false


func ask_question(question: String, context: Dictionary = {}) -> String:
	"""Send a question to the AI provider"""
	push_error("AIProviderInterface.ask_question() not implemented")
	return ""


func generate_content(prompt: String) -> String:
	"""Generate content with the specified prompt"""
	push_error("AIProviderInterface.generate_content() not implemented")
	return ""


func check_setup_status() -> bool:
	"""Check if provider is set up"""
	push_error("AIProviderInterface.check_setup_status() not implemented")
	return false


func needs_setup() -> bool:
	"""Check if setup is needed"""
	push_error("AIProviderInterface.needs_setup() not implemented")
	return true


func validate_api_key(key: String) -> void:
	"""Validate API key and emit result signal"""
	push_error("AIProviderInterface.validate_api_key() not implemented")


func get_service_status() -> Dictionary:
	"""Get current service status"""
	push_error("AIProviderInterface.get_service_status() not implemented")
	return {}


func get_available_models() -> Array:
	"""Get list of available models"""
	push_error("AIProviderInterface.get_available_models() not implemented")
	return []


func set_model(model_name_or_id) -> void:
	"""Set model by name or ID"""
	push_error("AIProviderInterface.set_model() not implemented")


func get_configuration() -> Dictionary:
	"""Get current configuration"""
	push_error("AIProviderInterface.get_configuration() not implemented")
	return {}


func set_configuration(config: Dictionary) -> void:
	"""Update provider configuration"""
	push_error("AIProviderInterface.set_configuration() not implemented")


func save_configuration(key: String, model) -> void:
	"""Save configuration"""
	push_error("AIProviderInterface.save_configuration() not implemented")


func reset_settings() -> bool:
	"""Reset settings to defaults"""
	push_error("AIProviderInterface.reset_settings() not implemented")
	return false
