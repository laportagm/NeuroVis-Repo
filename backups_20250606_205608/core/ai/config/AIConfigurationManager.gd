## AIConfigurationManager.gd
## Centralized configuration manager for AI providers in NeuroVis
##
## This class manages AI provider configurations in a centralized way,
## providing a consistent interface for accessing and updating settings
## for different AI providers (Gemini, Claude, OpenAI, etc.)
##
## @tutorial: AI Configuration Guide
## @version: 1.0

class_name AIConfigurationManager
extends Node

# === SIGNALS ===

signal configuration_changed(provider_id: String, config: Dictionary)
signal provider_added(provider_id: String)
signal provider_removed(provider_id: String)
signal default_provider_changed(provider_id: String)

# === CONSTANTS ===

enum ProviderType { OPENAI, ANTHROPIC_CLAUDE, GOOGLE_GEMINI, LOCAL_MODEL, MOCK }

# === PROPERTIES ===

const CONFIG_FILE_PATH = "user://ai_configuration.dat"
const PROVIDER_CONFIG_DIRECTORY = "user://ai_providers/"

# Known provider types

	var dir = DirAccess.open("user://")
	if not dir.dir_exists(PROVIDER_CONFIG_DIRECTORY):
		dir.make_dir(PROVIDER_CONFIG_DIRECTORY)

	# Load saved configurations
	_load_configurations()

	_is_initialized = true
	print("[AIConfig] AI Configuration Manager initialized.")


# === PUBLIC METHODS ===
	var provider_config = get_provider_config(provider_id)

	if not provider_config.has("models") or not provider_config.models.has(model_id):
		return {}

	return provider_config.models[model_id].duplicate()


	var provider_config = get_provider_config(provider_id)

	if not provider_config.has("models"):
		provider_config["models"] = {}

	provider_config.models[model_id] = config.duplicate()
	set_provider_config(provider_id, provider_config)


	var file = FileAccess.open_encrypted_with_pass(
		PROVIDER_CONFIG_DIRECTORY + provider_id + "_key.dat", FileAccess.WRITE, OS.get_unique_id()
	)

	if file:
		file.store_string(api_key)
		file.close()
		print("[AIConfig] API key saved for provider: " + provider_id)

		# Update config to indicate key is saved
		var config = get_provider_config(provider_id)
		config["has_api_key"] = true
		set_provider_config(provider_id, config)
	else:
		push_error("[AIConfig] Failed to save API key for provider: " + provider_id)


	var key_path = PROVIDER_CONFIG_DIRECTORY + provider_id + "_key.dat"

	if not FileAccess.file_exists(key_path):
		return ""

	var file = FileAccess.open_encrypted_with_pass(key_path, FileAccess.READ, OS.get_unique_id())

	if file:
		var api_key = file.get_as_text()
		file.close()
		return api_key

	return ""


	var key_path = PROVIDER_CONFIG_DIRECTORY + provider_id + "_key.dat"

	if FileAccess.file_exists(key_path):
		var dir = DirAccess.open(PROVIDER_CONFIG_DIRECTORY)
		if dir:
			dir.remove(provider_id + "_key.dat")
			print("[AIConfig] API key cleared for provider: " + provider_id)

			# Update config to indicate key is removed
			var config = get_provider_config(provider_id)
			config["has_api_key"] = false
			set_provider_config(provider_id, config)


	var config = get_provider_config(provider_id)
	return config.get("has_api_key", false)


	var dir = DirAccess.open(PROVIDER_CONFIG_DIRECTORY)
	if dir:
		var files = dir.get_files()
		for file in files:
			if file.ends_with("_key.dat"):
				dir.remove(file)

	print("[AIConfig] All configurations reset")


# === PRIVATE METHODS ===
	var file = FileAccess.open(CONFIG_FILE_PATH, FileAccess.READ)
	if not file:
		push_error("[AIConfig] Failed to open configuration file")
		return

	var json_data = file.get_as_text()
	file.close()

	var json = JSON.new()
	var parse_result = json.parse(json_data)

	if parse_result != OK:
		push_error("[AIConfig] Failed to parse configuration JSON")
		return

	var data = json.data
	if data is Dictionary:
		_configurations = data.get("providers", {})
		_default_provider = data.get("default_provider", "")
		print("[AIConfig] Loaded configurations for %d providers" % _configurations.size())
	else:
		push_error("[AIConfig] Invalid configuration data format")
		_configurations = {}
		_default_provider = ""


	var data = {"providers": _configurations, "default_provider": _default_provider, "version": 1}

	var json_data = JSON.stringify(data)

	var file = FileAccess.open(CONFIG_FILE_PATH, FileAccess.WRITE)
	if not file:
		push_error("[AIConfig] Failed to open configuration file for writing")
		return

	file.store_string(json_data)
	file.close()

	print("[AIConfig] Saved configurations")

var _configurations: Dictionary = {}
var _default_provider: String = ""
var _is_initialized: bool = false


# === INITIALIZATION ===

func _ready() -> void:
	initialize()


func initialize() -> void:
	"""Initialize the configuration manager"""
	if _is_initialized:
		return

	print("[AIConfig] Initializing AI Configuration Manager...")

	# Create provider config directory if needed
func get_provider_config(provider_id: String) -> Dictionary:
	"""Get configuration for a specific provider"""
	if not _configurations.has(provider_id):
		return {}

	return _configurations[provider_id].duplicate()


func set_provider_config(provider_id: String, config: Dictionary) -> void:
	"""Update configuration for a specific provider"""
	if not _is_initialized:
		initialize()

	_configurations[provider_id] = config.duplicate()
	_save_configurations()

	configuration_changed.emit(provider_id, config)
	print("[AIConfig] Updated configuration for provider: " + provider_id)


func register_provider(provider_id: String, initial_config: Dictionary = {}) -> void:
	"""Register a new AI provider with optional initial configuration"""
	if not _is_initialized:
		initialize()

	if not _configurations.has(provider_id):
		_configurations[provider_id] = initial_config.duplicate()
		_save_configurations()

		provider_added.emit(provider_id)
		print("[AIConfig] Registered new provider: " + provider_id)

		# Set as default if it's the first provider
		if _default_provider.is_empty():
			set_default_provider(provider_id)
	else:
		# Update config if already registered
		set_provider_config(provider_id, initial_config)


func unregister_provider(provider_id: String) -> void:
	"""Unregister an AI provider"""
	if not _is_initialized:
		return

	if _configurations.has(provider_id):
		_configurations.erase(provider_id)
		_save_configurations()

		provider_removed.emit(provider_id)
		print("[AIConfig] Unregistered provider: " + provider_id)

		# Update default provider if needed
		if _default_provider == provider_id:
			if _configurations.size() > 0:
				_default_provider = _configurations.keys()[0]
				default_provider_changed.emit(_default_provider)
			else:
				_default_provider = ""


func get_all_providers() -> Array:
	"""Get list of all registered provider IDs"""
	return _configurations.keys()


func get_default_provider() -> String:
	"""Get the default provider ID"""
	return _default_provider


func set_default_provider(provider_id: String) -> void:
	"""Set the default provider"""
	if provider_id.is_empty() or not _configurations.has(provider_id):
		push_warning("[AIConfig] Cannot set invalid provider as default: " + provider_id)
		return

	_default_provider = provider_id
	_save_configurations()

	default_provider_changed.emit(provider_id)
	print("[AIConfig] Default provider set to: " + provider_id)


func get_model_config(provider_id: String, model_id: String) -> Dictionary:
	"""Get configuration for a specific model of a provider"""
func set_model_config(provider_id: String, model_id: String, config: Dictionary) -> void:
	"""Set configuration for a specific model of a provider"""
func save_api_key(provider_id: String, api_key: String) -> void:
	"""Save API key for a provider in a secure way"""
	if api_key.is_empty():
		push_warning("[AIConfig] Empty API key not saved for provider: " + provider_id)
		return

	# Create a separate encrypted file for the API key
func load_api_key(provider_id: String) -> String:
	"""Load API key for a provider"""
func clear_api_key(provider_id: String) -> void:
	"""Clear saved API key for a provider"""
func has_api_key(provider_id: String) -> bool:
	"""Check if API key exists for a provider"""
func reset_all_configurations() -> void:
	"""Reset all configurations to defaults"""
	_configurations.clear()
	_default_provider = ""
	_save_configurations()

	# Also remove all API keys

func _load_configurations() -> void:
	"""Load all configurations from disk"""
	if not FileAccess.file_exists(CONFIG_FILE_PATH):
		_configurations = {}
		_default_provider = ""
		return

func _save_configurations() -> void:
	"""Save all configurations to disk"""
@tool
