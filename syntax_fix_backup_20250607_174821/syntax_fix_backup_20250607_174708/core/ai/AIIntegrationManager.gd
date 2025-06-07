## AIIntegrationManager.gd
## Manages AI integration with the main application
##
## This class centralizes AI setup, initialization, and management,
## providing a clean interface for the main scene to interact with
## AI functionality without direct coupling to specific providers.
##
## @tutorial: AI Integration Guide
## @version: 1.0

class_name AIIntegrationManager
extends Node

# === SIGNALS ===

signal ai_setup_completed(provider_id: String)
signal ai_setup_cancelled
signal ai_provider_changed(provider_id: String)
signal ai_initialized(success: bool)
signal ai_response_received(question: String, response: String)
signal ai_error_occurred(error_message: String)

# === EXPORTS ===

@export var auto_setup_on_start: bool = true
@export var default_provider_id: String = "gemini"

# === PRIVATE VARIABLES ===

var provider = _registry.get_provider(provider_id)
var provider = _registry.get_active_provider()
var provider = _registry.get_active_provider()
var provider = _registry.get_provider(provider_id)
var root = get_tree().root
var main_scene = root.get_child(root.get_child_count() - 1)
var ui_layer = main_scene.get_node_or_null("UI_Layer")
var dialog_scene = load("res://core/ai/ui/setup/GeminiSetupDialog.tscn")
var provider = _registry.get_provider(provider_id)
	_connect_provider_signals(provider)

	# Update current structure on the provider
var provider = _registry.get_provider("gemini")
var question = "Unknown question"

# Forward the response
	ai_response_received.emit(question, response)


var _registry: AIProviderRegistry
var _config_manager: AIConfigurationManager
var _setup_dialog: Control
var _current_setup_provider_id: String = ""

# === STATE ===
var _is_initialized: bool = false
var _setup_shown: bool = false
var _current_structure: String = ""

# === INITIALIZATION ===


func _ready() -> void:
	await get_tree().process_frame
	initialize()


func initialize() -> void:
	"""Initialize AI integration"""
	if _is_initialized:
		return

		print("[AIIntegration] Initializing AI Integration Manager...")

		# Get references to required services
		_registry = get_node_or_null("/root/AIRegistry") as AIProviderRegistry
		_config_manager = get_node_or_null("/root/AIConfig") as AIConfigurationManager

		if not _registry:
			push_warning("[AIIntegration] AIProviderRegistry not found, creating local instance")
			_registry = AIProviderRegistry.new()
			add_child(_registry)

			if not _config_manager:
				push_warning(
				"[AIIntegration] AIConfigurationManager not found, using instance from registry"
				)
				_config_manager = _registry._config_manager

				# Connect to registry signals
				_registry.active_provider_changed.connect(_on_active_provider_changed)

				# If auto setup is enabled, check if setup is needed
				if auto_setup_on_start:
					get_tree().create_timer(0.5).timeout.connect(
					func(): check_provider_setup(default_provider_id)
					)

					_is_initialized = true
					ai_initialized.emit(true)
					print("[AIIntegration] AI Integration Manager initialized")


					# === PUBLIC METHODS ===


func check_provider_setup(provider_id: String = "") -> bool:
	"""Check if a provider needs setup and show setup dialog if needed"""
	if not _is_initialized:
		initialize()

		# If no provider specified, use active provider
		if provider_id.is_empty():
			provider_id = _registry.get_active_provider_id()

func show_setup_dialog(provider_id: String = "") -> void:
	"""Show the setup dialog for a specific provider"""
	if _setup_shown:
		print("[AIIntegration] Setup dialog already shown")
		return

		# If no provider specified, use active provider
		if provider_id.is_empty():
			provider_id = _registry.get_active_provider_id()

			_current_setup_provider_id = provider_id

			# Get the appropriate setup dialog for this provider
			match provider_id:
				"gemini":
					_show_gemini_setup_dialog()
					_:
						push_warning("[AIIntegration] No setup dialog available for provider: %s" % provider_id)
						# Show generic setup dialog or first available
						_show_gemini_setup_dialog()

						_setup_shown = true


func ask_question(question: String, context: Dictionary = {}) -> void:
	"""Ask a question using the active AI provider"""
	if not _is_initialized:
		initialize()

func set_current_structure(structure_name: String) -> void:
	"""Set the current brain structure for context"""
	_current_structure = structure_name

	# Also update the active provider if it has this method
func get_current_structure() -> String:
	"""Get the current structure context"""
	return _current_structure


func set_active_provider(provider_id: String) -> bool:
	"""Set the active AI provider"""
	if not _is_initialized:
		initialize()

		return _registry.set_active_provider(provider_id)


func get_active_provider_id() -> String:
	"""Get the ID of the currently active provider"""
	if not _is_initialized:
		initialize()

		return _registry.get_active_provider_id()


func get_available_providers() -> Array:
	"""Get list of available provider IDs"""
	if not _is_initialized:
		initialize()

		return _registry.get_all_provider_ids()


func get_provider_status(provider_id: String = "") -> Dictionary:
	"""Get status information for a provider"""
	if not _is_initialized:
		initialize()

		# If no provider specified, use active provider
		if provider_id.is_empty():
			provider_id = _registry.get_active_provider_id()

func _fix_orphaned_code():
	if not provider:
		push_warning("[AIIntegration] Provider not found: %s" % provider_id)
		return false

		# Check if setup is needed
		if provider.needs_setup():
			print("[AIIntegration] Provider %s needs setup, showing dialog" % provider_id)
			show_setup_dialog(provider_id)
			return true

			print("[AIIntegration] Provider %s already configured" % provider_id)
			return false


func _fix_orphaned_code():
	if not provider:
		ai_error_occurred.emit("No active AI provider")
		return

		# Ensure the provider is set up
		if provider.needs_setup():
			show_setup_dialog()
			ai_error_occurred.emit("AI provider not set up")
			return

			# Add current structure to context if not already present
			if not context.has("structure") and not _current_structure.is_empty():
				context["structure"] = _current_structure

				print("[AIIntegration] Asking question: %s" % question)
				provider.ask_question(question, context)


func _fix_orphaned_code():
	if provider and provider.has_method("set_current_structure"):
		provider.set_current_structure(structure_name)

		print("[AIIntegration] Current structure set to: %s" % structure_name)


func _fix_orphaned_code():
	if not provider:
		return {"error": "Provider not found", "provider_id": provider_id}

		return provider.get_service_status()


		# === PRIVATE METHODS ===


func _fix_orphaned_code():
	if not ui_layer:
		ui_layer = main_scene  # Fallback

		# Create and add dialog
func _fix_orphaned_code():
	if not dialog_scene:
		push_error("[AIIntegration] GeminiSetupDialog scene not found")
		return

		_setup_dialog = dialog_scene.instantiate()
		if not _setup_dialog:
			push_error("[AIIntegration] Failed to instantiate GeminiSetupDialog")
			return

			_setup_dialog.name = "GeminiSetupDialog"

			# Connect signals
			if _setup_dialog.has_signal("setup_completed"):
				if _setup_dialog.is_connected("setup_completed", _on_gemini_setup_completed):
					_setup_dialog.disconnect("setup_completed", _on_gemini_setup_completed)
					_setup_dialog.connect("setup_completed", _on_gemini_setup_completed)

					if _setup_dialog.has_signal("setup_cancelled"):
						if _setup_dialog.is_connected("setup_cancelled", _on_gemini_setup_cancelled):
							_setup_dialog.disconnect("setup_cancelled", _on_gemini_setup_cancelled)
							_setup_dialog.connect("setup_cancelled", _on_gemini_setup_cancelled)

							# Add to scene
							ui_layer.add_child(_setup_dialog)

							# Show dialog
							_setup_dialog.visible = true
							if _setup_dialog.has_method("show_dialog"):
								_setup_dialog.call_deferred("show_dialog")

								print("[AIIntegration] Gemini setup dialog shown")


func _fix_orphaned_code():
	if not _current_structure.is_empty() and provider.has_method("set_current_structure"):
		provider.set_current_structure(_current_structure)

		ai_provider_changed.emit(provider_id)


func _fix_orphaned_code():
	if not provider:
		# TODO: Create and register Gemini provider
		pass

		# Emit completion signal
		ai_setup_completed.emit(_current_setup_provider_id)

		# Update Gemini as active provider
		set_active_provider("gemini")

		_current_setup_provider_id = ""


func _show_gemini_setup_dialog() -> void:
	"""Show the Gemini setup dialog"""
	# Find the parent node to add dialog to
func _connect_provider_signals(provider: AIProviderInterface) -> void:
	"""Connect to provider signals"""
	if not provider:
		return

		# Disconnect existing connections first
		if provider.response_received.is_connected(_on_ai_response_received):
			provider.response_received.disconnect(_on_ai_response_received)

			if provider.error_occurred.is_connected(_on_ai_error_occurred):
				provider.error_occurred.disconnect(_on_ai_error_occurred)

				# Connect signals
				provider.response_received.connect(_on_ai_response_received)
				provider.error_occurred.connect(_on_ai_error_occurred)


				# === SIGNAL HANDLERS ===


func _on_active_provider_changed(provider_id: String) -> void:
	"""Handle active provider change"""
	print("[AIIntegration] Active provider changed to: %s" % provider_id)

	# Connect to provider signals
func _on_gemini_setup_completed(successful: bool, api_key: String) -> void:
	"""Handle successful Gemini setup completion"""
	print("[AIIntegration] Gemini setup completed successfully: %s" % str(successful))

	if _setup_dialog:
		_setup_dialog.queue_free()
		_setup_dialog = null

		_setup_shown = false

		if successful:
			# Update AI provider in the registry if needed
func _on_gemini_setup_cancelled() -> void:
	"""Handle cancelled Gemini setup"""
	print("[AIIntegration] Gemini setup cancelled")

	if _setup_dialog:
		_setup_dialog.queue_free()
		_setup_dialog = null

		_setup_shown = false
		_current_setup_provider_id = ""

		ai_setup_cancelled.emit()


func _on_ai_response_received(response: String) -> void:
	"""Handle AI response received"""
	# Determine the last question from context
func _on_ai_error_occurred(error_message: String) -> void:
	"""Handle AI error"""
	ai_error_occurred.emit(error_message)
