## AIProviderRegistry.gd
## Service locator for AI providers in NeuroVis
##
## This class implements the Service Locator pattern for AI providers,
## allowing dynamic registration, discovery, and switching between
## different AI service providers (Gemini, Claude, OpenAI, etc.)
##
## @tutorial: AI Provider Integration Guide
## @version: 1.0

class_name AIProviderRegistry
extends Node

# === SIGNALS ===
extends %s

signal provider_registered(provider_id: String)
signal provider_unregistered(provider_id: String)
signal active_provider_changed(provider_id: String)
signal provider_config_changed(provider_id: String, config: Dictionary)

# === CONSTANTS ===

const DEFAULT_PROVIDER_ID = "mock_provider"

# === PROPERTIES ===

var default_provider = _config_manager.get_default_provider()
var config = {}
var old_provider_id = _active_provider_id
_active_provider_id = provider_id

# Update configuration manager if available
var provider = get_provider(provider_id)
var mock_provider = _create_mock_provider()

# Register directly without calling register_provider to avoid recursion
var config_2 = {}
var gemini_provider = GeminiAIProvider.new()
var config_3 = {}
var MockProvider = preprepreload("res://core/ai/providers/MockAIProvider.gd")
var script = GDScript.new()
script.source_code = (
"""
var response = "This is a mock response to: " + question
response_received.emit(response)
var response_2 = "Mock content generated from: " + prompt
response_received.emit(response)
var MockProviderClass = GDScript.new()
MockProviderClass.source_code = script.source_code

var _providers: Dictionary = {}  # Maps provider_id to provider instance
var _active_provider_id: String = ""
var _config_manager: AIConfigurationManager
var _is_initialized: bool = false


# === INITIALIZATION ===

func _ready() -> void:
	# Wait a frame to allow other autoloads to initialize
	await get_tree().process_frame
	initialize()


func initialize() -> void:
	"""Initialize the provider registry"""
	if _is_initialized:
		return

		print("[AIRegistry] Initializing AI Provider Registry...")

		# Setting this flag early to prevent recursive initialization
		_is_initialized = true

		# Get reference to configuration manager
		_config_manager = get_node_or_null("/root/AIConfig") as AIConfigurationManager
		if not _config_manager:
			push_warning("[AIRegistry] AIConfigurationManager not found, creating local instance")
			_config_manager = AIConfigurationManager.new()
			add_child(_config_manager)

			# Connect to configuration manager signals
			if _config_manager:
				_config_manager.configuration_changed.connect(_on_provider_config_changed)
				_config_manager.default_provider_changed.connect(_on_default_provider_changed)

				# Register built-in mock provider
				_register_mock_provider()

				# Restore active provider from configuration
				if _config_manager:
func register_provider(provider_id: String, provider: AIProviderInterface) -> bool:
	"""Register a new AI provider"""
	# Don't call initialize() here to avoid potential recursion

	if _providers.has(provider_id):
		push_warning("[AIRegistry] Provider already registered with ID: %s" % provider_id)
		return false

		_providers[provider_id] = provider

		# Register with configuration manager
func unregister_provider(provider_id: String) -> bool:
	"""Unregister an AI provider"""
	if not _is_initialized or not _providers.has(provider_id):
		return false

		# Can't unregister the default mock provider
		if provider_id == DEFAULT_PROVIDER_ID:
			push_warning("[AIRegistry] Cannot unregister built-in mock provider")
			return false

			# Switch active provider if unregistering active
			if _active_provider_id == provider_id:
				set_active_provider(DEFAULT_PROVIDER_ID)

				# Remove from providers
				_providers.erase(provider_id)

				# Update configuration manager
				_config_manager.unregister_provider(provider_id)

				provider_unregistered.emit(provider_id)
				print("[AIRegistry] Unregistered provider: %s" % provider_id)

				return true


func get_provider(provider_id: String) -> AIProviderInterface:
	"""Get a specific AI provider by ID"""
	# Skip initialization check to avoid recursion

	if not _providers.has(provider_id):
		push_warning("[AIRegistry] Provider not found: %s" % provider_id)
		return null

		return _providers[provider_id]


func get_active_provider() -> AIProviderInterface:
	"""Get the currently active AI provider"""
	# Skip initialization check to avoid recursion

	if _active_provider_id.is_empty() or not _providers.has(_active_provider_id):
		# Fallback to mock provider if it exists
		if _providers.has(DEFAULT_PROVIDER_ID):
			set_active_provider(DEFAULT_PROVIDER_ID)
			elif not _providers.is_empty():
				# Use first available provider
				set_active_provider(_providers.keys()[0])
				else:
					return null

					return _providers[_active_provider_id]


func set_active_provider(provider_id: String) -> bool:
	"""Set the active AI provider"""
	# Skip initialization check to avoid recursion

	if not _providers.has(provider_id):
		push_warning("[AIRegistry] Cannot set non-existing provider as active: %s" % provider_id)
		return false

		if _active_provider_id == provider_id:
			return true  # Already active

func get_all_provider_ids() -> Array:
	"""Get IDs of all registered providers"""
	# Skip initialization check to avoid recursion

	return _providers.keys()


func get_active_provider_id() -> String:
	"""Get the ID of the currently active provider"""
	# Skip initialization check to avoid recursion

	return _active_provider_id


func get_provider_config(provider_id: String) -> Dictionary:
	"""Get configuration for a specific provider"""
	# Skip initialization check to avoid recursion

	if _config_manager:
		return _config_manager.get_provider_config(provider_id)
		return {}


func set_provider_config(provider_id: String, config: Dictionary) -> void:
	"""Update configuration for a specific provider"""
	# Skip initialization check to avoid recursion

	if _config_manager:
		_config_manager.set_provider_config(provider_id, config)

		# Also update provider instance if it has set_configuration method
func initialize() -> bool:
	return true

func setup_api_key(_key: String) -> bool:
	return true

func ask_question(question: String, _context: Dictionary = {}) -> String:
func generate_content(prompt: String) -> String:
func check_setup_status() -> bool:
	return true

func needs_setup() -> bool:
	return false

func validate_api_key(_key: String) -> void:
	api_key_validated.emit(true, "Mock validation successful")

func get_service_status() -> Dictionary:
	return {
	"initialized": true,
	"setup_complete": true,
	"api_configured": true,
	"provider": "mock"
	}

func get_available_models() -> Array:
	return ["mock-model-basic", "mock-model-advanced"]

func set_model(_model_name_or_id) -> void:
	pass

func get_configuration() -> Dictionary:
	return {"provider": "mock", "models": {}}

func save_configuration(_key: String, _model) -> void:
	pass

func reset_settings() -> bool:
	return true
	"""
	% "AIProviderInterface"
	)

	script.reload()

func _fix_orphaned_code():
	if not default_provider.is_empty() and _providers.has(default_provider):
		# Set directly to avoid recursion
		_active_provider_id = default_provider
		elif _providers.has(DEFAULT_PROVIDER_ID):
			# Fallback to mock provider
			_active_provider_id = DEFAULT_PROVIDER_ID

			print("[AIRegistry] AI Provider Registry initialized with %d providers" % _providers.size())
			print("[AIRegistry] Active provider: %s" % _active_provider_id)


			# === PUBLIC METHODS ===
func _fix_orphaned_code():
	if provider.has_method("get_configuration"):
		config = provider.get_configuration()
		if _config_manager:
			_config_manager.register_provider(provider_id, config)

			provider_registered.emit(provider_id)
			print("[AIRegistry] Registered provider: %s" % provider_id)

			# Auto-set as active if first provider
			if _active_provider_id.is_empty():
				set_active_provider(provider_id)

				return true


func _fix_orphaned_code():
	if _config_manager:
		_config_manager.set_default_provider(provider_id)

		active_provider_changed.emit(provider_id)
		print("[AIRegistry] Active provider changed: %s -> %s" % [old_provider_id, provider_id])

		return true


func _fix_orphaned_code():
	if provider and provider.has_method("set_configuration"):
		provider.set_configuration(config)


		# === MOCK PROVIDER METHODS ===
func _fix_orphaned_code():
	if not _providers.has(DEFAULT_PROVIDER_ID):
		_providers[DEFAULT_PROVIDER_ID] = mock_provider

		# Register with configuration manager if available
func _fix_orphaned_code():
	if mock_provider.has_method("get_configuration"):
		config = mock_provider.get_configuration()
		if _config_manager:
			_config_manager.register_provider(DEFAULT_PROVIDER_ID, config)

			print("[AIRegistry] Registered mock provider")
			provider_registered.emit(DEFAULT_PROVIDER_ID)

			# Also register Gemini provider if available
			_register_gemini_provider()


func _fix_orphaned_code():
	if not gemini_provider:
		print("[AIRegistry] Failed to create GeminiAIProvider instance")
		return
		gemini_provider.name = "GeminiAI"
		add_child(gemini_provider)

		# Initialize the provider
		if gemini_provider.has_method("initialize"):
			gemini_provider.initialize()

			# Register without calling register_provider to avoid recursion
			_providers["gemini"] = gemini_provider

			# Register with configuration manager if available
func _fix_orphaned_code():
	if gemini_provider.has_method("get_configuration"):
		config = gemini_provider.get_configuration()
		if _config_manager:
			_config_manager.register_provider("gemini", config)

			print("[AIRegistry] Registered Gemini provider")
			provider_registered.emit("gemini")


func _fix_orphaned_code():
	if MockProvider:
		return MockProvider.new()

		# Fallback to creating a basic mock if the file doesn't exist
func _fix_orphaned_code():
	return response

func _fix_orphaned_code():
	return response

func _fix_orphaned_code():
	return MockProviderClass.new()


	# === SIGNAL HANDLERS ===

func _register_mock_provider() -> void:
	"""Register the built-in mock provider for testing"""
	# Create mock provider that implements required interface
func _register_gemini_provider() -> void:
	"""Register the Gemini AI provider"""
	# Check if already registered
	if _providers.has("gemini"):
		return

		# Try to create the Gemini provider instance
func _create_mock_provider() -> AIProviderInterface:
	"""Create a basic mock provider implementation"""
func _on_provider_config_changed(provider_id: String, config: Dictionary) -> void:
	"""Handle provider configuration changes"""
	provider_config_changed.emit(provider_id, config)


func _on_default_provider_changed(provider_id: String) -> void:
	"""Handle default provider changes"""
	if _active_provider_id != provider_id:
		set_active_provider(provider_id)
		@tool
