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
const PROVIDER_TYPES = {
"openai": ProviderType.OPENAI,
"anthropic": ProviderType.ANTHROPIC_CLAUDE,
"gemini": ProviderType.GOOGLE_GEMINI,
"local": ProviderType.LOCAL_MODEL,
"mock": ProviderType.MOCK
}

# Default configurations for known providers
const DEFAULT_CONFIGS = {
"gemini":
	{
	"name": "Google Gemini",
	"type": ProviderType.GOOGLE_GEMINI,
	"base_url": "https://generativelanguage.googleapis.com/v1beta/models/",
	"models":
		{
		"gemini-1.5-flash":
			{
			"name": "Gemini 1.5 Flash",
			"max_tokens": 8192,
			"temperature": 0.7,
			"supports_functions": true,
			"supports_vision": true
			},
			"gemini-1.5-pro":
				{
				"name": "Gemini 1.5 Pro",
				"max_tokens": 8192,
				"temperature": 0.7,
				"supports_functions": true,
				"supports_vision": true
				}
				},
				"requires_api_key": true,
				"api_key_pattern": "^[A-Za-z0-9_-]{39}$"
				},
				"openai":
					{
					"name": "OpenAI",
					"type": ProviderType.OPENAI,
					"base_url": "https://api.openai.com/v1/",
					"models":
						{
						"gpt-4":
							{
							"name": "GPT-4",
							"max_tokens": 8192,
							"temperature": 0.7,
							"supports_functions": true,
							"supports_vision": false
							},
							"gpt-3.5-turbo":
								{
								"name": "GPT-3.5 Turbo",
								"max_tokens": 4096,
								"temperature": 0.7,
								"supports_functions": true,
								"supports_vision": false
								}
								},
								"requires_api_key": true,
								"api_key_pattern": "^sk-[A-Za-z0-9]{48}$"
								},
								"anthropic":
									{
									"name": "Anthropic Claude",
									"type": ProviderType.ANTHROPIC_CLAUDE,
									"base_url": "https://api.anthropic.com/v1/",
									"models":
										{
										"claude-3-sonnet":
											{
											"name": "Claude 3 Sonnet",
											"max_tokens": 4096,
											"temperature": 0.7,
											"supports_functions": false,
											"supports_vision": true
											},
											"claude-2.1":
												{
												"name": "Claude 2.1",
												"max_tokens": 100000,
												"temperature": 0.7,
												"supports_functions": false,
												"supports_vision": false
												}
												},
												"requires_api_key": true,
												"api_key_pattern": "^sk-ant-[A-Za-z0-9-_]{95}$"
												},
												"mock":
													{
													"name": "Mock Provider",
													"type": ProviderType.MOCK,
													"base_url": "",
													"models":
														{
														"mock-model":
															{
															"name": "Mock Model",
															"max_tokens": 1000,
															"temperature": 0.7,
															"supports_functions": true,
															"supports_vision": true
															}
															},
															"requires_api_key": false
															}
															}

															# === PRIVATE PROPERTIES ===

var dir = DirAccess.open("user://")
var config = initial_config
var provider_config = get_provider_config(provider_id)

var provider_config = get_provider_config(provider_id)

var file = FileAccess.open_encrypted_with_pass(
	PROVIDER_CONFIG_DIRECTORY + provider_id + "_key.dat", FileAccess.WRITE, OS.get_unique_id()
	)

var config = get_provider_config(provider_id)
	config["has_api_key"] = true
	set_provider_config(provider_id, config)
	push_error("[AIConfig] Failed to save API key for provider: " + provider_id)


var key_path = PROVIDER_CONFIG_DIRECTORY + provider_id + "_key.dat"

var file = FileAccess.open_encrypted_with_pass(key_path, FileAccess.READ, OS.get_unique_id())

var api_key = file.get_as_text()
	file.close()
var key_path = PROVIDER_CONFIG_DIRECTORY + provider_id + "_key.dat"

var dir = DirAccess.open(PROVIDER_CONFIG_DIRECTORY)
var config = get_provider_config(provider_id)
	config["has_api_key"] = false
	set_provider_config(provider_id, config)


var config = get_provider_config(provider_id)
var dir = DirAccess.open(PROVIDER_CONFIG_DIRECTORY)
var file_name = dir.get_next()
var file = FileAccess.open(CONFIG_FILE_PATH, FileAccess.READ)
var data = file.get_var()
	file.close()

var file = FileAccess.open(CONFIG_FILE_PATH, FileAccess.WRITE)
var data = {"configurations": _configurations, "default_provider": _default_provider}
	file.store_var(data)
	file.close()
var warnings: PackedStringArray = []

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
		print("[AIConfig] Configuration updated for provider: " + provider_id)


func register_provider(provider_id: String, initial_config: Dictionary = {}) -> void:
	"""Register a new AI provider"""
	if _configurations.has(provider_id):
		push_warning("[AIConfig] Provider already registered: " + provider_id)
		return

		# Use default config if available, otherwise use provided config
func unregister_provider(provider_id: String) -> void:
	"""Unregister an AI provider"""
	if not _configurations.has(provider_id):
		push_warning("[AIConfig] Provider not found: " + provider_id)
		return

		# Clear API key if exists
		clear_api_key(provider_id)

		# Remove configuration
		_configurations.erase(provider_id)

		# If this was the default provider, clear it
		if _default_provider == provider_id:
			_default_provider = ""

			_save_configurations()

			provider_removed.emit(provider_id)
			print("[AIConfig] Provider unregistered: " + provider_id)


func get_all_providers() -> Array:
	"""Get list of all registered providers"""
	return _configurations.keys()


func get_default_provider() -> String:
	"""Get the default provider ID"""
	return _default_provider


func set_default_provider(provider_id: String) -> void:
	"""Set the default provider"""
	if not _configurations.has(provider_id):
		push_error("[AIConfig] Cannot set default provider - not registered: " + provider_id)
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

func _fix_orphaned_code():
	if not dir.dir_exists(PROVIDER_CONFIG_DIRECTORY):
		dir.make_dir(PROVIDER_CONFIG_DIRECTORY)

		# Load saved configurations
		_load_configurations()

		_is_initialized = true
		print("[AIConfig] AI Configuration Manager initialized.")


		# === PUBLIC METHODS ===


func _fix_orphaned_code():
	if DEFAULT_CONFIGS.has(provider_id) and initial_config.is_empty():
		config = DEFAULT_CONFIGS[provider_id].duplicate()

		_configurations[provider_id] = config
		_save_configurations()

		provider_added.emit(provider_id)
		print("[AIConfig] Provider registered: " + provider_id)


func _fix_orphaned_code():
	if not provider_config.has("models") or not provider_config.models.has(model_id):
		return {}

		return provider_config.models[model_id].duplicate()


func _fix_orphaned_code():
	if not provider_config.has("models"):
		provider_config["models"] = {}

		provider_config.models[model_id] = config.duplicate()
		set_provider_config(provider_id, provider_config)


func _fix_orphaned_code():
	if file:
		file.store_string(api_key)
		file.close()
		print("[AIConfig] API key saved for provider: " + provider_id)

		# Update config to indicate key is saved
func _fix_orphaned_code():
	if not FileAccess.file_exists(key_path):
		return ""

func _fix_orphaned_code():
	if file:
func _fix_orphaned_code():
	return api_key

	return ""


func _fix_orphaned_code():
	if FileAccess.file_exists(key_path):
func _fix_orphaned_code():
	if dir:
		dir.remove(provider_id + "_key.dat")
		print("[AIConfig] API key cleared for provider: " + provider_id)

		# Update config to indicate key is removed
func _fix_orphaned_code():
	return config.get("has_api_key", false)


func _fix_orphaned_code():
	if dir:
		dir.list_dir_begin()
func _fix_orphaned_code():
	while file_name != "":
		if file_name.ends_with("_key.dat"):
			dir.remove(file_name)
			file_name = dir.get_next()
			dir.list_dir_end()

			print("[AIConfig] All configurations reset")


			# === PRIVATE METHODS ===


func _fix_orphaned_code():
	if file:
func _fix_orphaned_code():
	if data is Dictionary:
		_configurations = data.get("configurations", {})
		_default_provider = data.get("default_provider", "")
		print("[AIConfig] Configurations loaded from disk.")
		else:
			push_error("[AIConfig] Failed to load configurations.")


func _fix_orphaned_code():
	if file:
func _fix_orphaned_code():
	print("[AIConfig] Configurations saved.")
	else:
		push_error("[AIConfig] Failed to save configurations.")


		# === TOOL SUPPORT ===

		@tool


func _fix_orphaned_code():
	if not FileAccess.file_exists(CONFIG_FILE_PATH):
		warnings.append("No configuration file found. Will be created on first use.")

		if _configurations.is_empty():
			warnings.append("No AI providers configured.")

			return warnings

func _load_configurations() -> void:
	"""Load all configurations from disk"""
	if not FileAccess.file_exists(CONFIG_FILE_PATH):
		_configurations = {}
		_default_provider = ""
		return

func _save_configurations() -> void:
	"""Save all configurations to disk"""
func _get_configuration_warnings() -> PackedStringArray:
	"""Get configuration warnings for the editor"""
