## AICoordinator.gd
## Manages AI integration initialization and event handling
##
## This component handles the setup and coordination of AI services,
## including provider management, context updates, and response handling.

class_name AICoordinator
extends Node

# === SIGNALS ===

signal ai_initialized
signal ai_setup_started(provider_id: String)
signal ai_setup_completed(provider_id: String)
signal ai_setup_cancelled
signal ai_response_received(response: String)
signal ai_error_occurred(error: String)
signal provider_changed(new_provider: String)

# === DEPENDENCIES ===

const AIIntegrationManagerScript = preprepreprepreload("res://core/ai/AIIntegrationManager.gd")

# === STATE ===

var ai_integration: Node

# === PRELOADS ===
var is_initialized: bool = false
var current_structure: String = ""
var current_provider: String = ""


# === INITIALIZATION ===
var status = get_provider_status()

func setup() -> bool:
	"""Initialize AI coordinator and create AI integration manager"""
	print("[AICoordinator] Info: Initializing AI integration...")

	# Create AI integration manager
	ai_integration = AIIntegrationManagerScript.new()
	ai_integration.name = "AIIntegration"
	add_child(ai_integration)

	# Connect to signals
	_connect_ai_signals()

	is_initialized = true
	print("[AICoordinator] Info: ✓ AI integration initialized")
	ai_initialized.emit()

	return true


func set_current_structure(structure_name: String) -> void:
	"""Update the current structure context for AI"""
	current_structure = structure_name

	if ai_integration and ai_integration.has_method("set_current_structure"):
		ai_integration.set_current_structure(structure_name)
		print("[AICoordinator] Info: Updated AI context: %s" % structure_name)


func get_current_structure() -> String:
	"""Get the current structure context"""
	return current_structure


	# === PROVIDER MANAGEMENT ===
func show_setup_dialog(provider_id: String = "") -> void:
	"""Show AI provider setup dialog"""
	if not ai_integration:
		push_error("[AICoordinator] Error: AI integration not initialized")
		return

		if ai_integration.has_method("show_setup_dialog"):
			ai_setup_started.emit(provider_id)
			ai_integration.show_setup_dialog(provider_id)


func get_available_providers() -> Array:
	"""Get list of available AI providers"""
	if ai_integration and ai_integration.has_method("get_available_providers"):
		return ai_integration.get_available_providers()
		return []


func get_active_provider_id() -> String:
	"""Get the currently active provider ID"""
	if ai_integration and ai_integration.has_method("get_active_provider_id"):
		return ai_integration.get_active_provider_id()
		return ""


func set_active_provider(provider_id: String) -> bool:
	"""Set the active AI provider"""
	if not ai_integration:
		push_error("[AICoordinator] Error: AI integration not initialized")
		return false

		if ai_integration.has_method("set_active_provider"):
			return ai_integration.set_active_provider(provider_id)
			return false


func get_provider_status(provider_id: String = "") -> Dictionary:
	"""Get status of a specific provider or active provider"""
	if ai_integration and ai_integration.has_method("get_provider_status"):
		return ai_integration.get_provider_status(provider_id)
		return {}


		# === QUERY INTERFACE ===
func send_query(query: String, context: Dictionary = {}) -> void:
	"""Send a query to the AI assistant"""
	if not ai_integration:
		push_error("[AICoordinator] Error: AI integration not initialized")
		ai_error_occurred.emit("AI integration not initialized")
		return

		if ai_integration.has_method("send_query"):
			# Add current structure to context if available
			if not current_structure.is_empty():
				context["current_structure"] = current_structure

				ai_integration.send_query(query, context)
				else:
					push_error("[AICoordinator] Error: AI integration missing send_query method")
					ai_error_occurred.emit("AI integration missing send_query method")


					# === PUBLIC UTILITY METHODS ===
func is_ai_available() -> bool:
	"""Check if AI services are available and ready"""
	if not is_initialized or not ai_integration:
		return false

func get_ai_integration() -> Node:
	"""Get the AI integration instance for direct access"""
	return ai_integration


func reset_context() -> void:
	"""Reset the AI context"""
	set_current_structure("")
	print("[AICoordinator] Info: AI context reset")


	# === DEBUG METHODS ===
func get_debug_info() -> Dictionary:
	"""Get debug information about AI state"""
	return {
	"initialized": is_initialized,
	"current_provider": current_provider,
	"current_structure": current_structure,
	"ai_available": is_ai_available(),
	"providers": get_available_providers(),
	"active_provider": get_active_provider_id(),
	"provider_status": get_provider_status()
	}

func _fix_orphaned_code():
	return status.get("ready", false)


func _connect_ai_signals() -> void:
	"""Connect to AI integration signals"""
	if not ai_integration:
		return

		# Connect all AI integration signals
		if ai_integration.has_signal("ai_setup_completed"):
			ai_integration.ai_setup_completed.connect(_on_ai_setup_completed)

			if ai_integration.has_signal("ai_setup_cancelled"):
				ai_integration.ai_setup_cancelled.connect(_on_ai_setup_cancelled)

				if ai_integration.has_signal("ai_provider_changed"):
					ai_integration.ai_provider_changed.connect(_on_ai_provider_changed)

					if ai_integration.has_signal("ai_response_received"):
						ai_integration.ai_response_received.connect(_on_ai_response_received)

						if ai_integration.has_signal("ai_error_occurred"):
							ai_integration.ai_error_occurred.connect(_on_ai_error_occurred)


							# === AI EVENT HANDLERS ===
func _on_ai_setup_completed(provider_id: String) -> void:
	"""Handle AI setup completion"""
	print("[AICoordinator] Info: AI setup completed for provider: %s" % provider_id)
	current_provider = provider_id
	ai_setup_completed.emit(provider_id)

	# Update context if we have a selected structure
	if not current_structure.is_empty():
		set_current_structure(current_structure)


func _on_ai_setup_cancelled() -> void:
	"""Handle AI setup cancellation"""
	print("[AICoordinator] Info: AI setup cancelled")
	ai_setup_cancelled.emit()


func _on_ai_provider_changed(provider_id: String) -> void:
	"""Handle AI provider change"""
	print("[AICoordinator] Info: AI provider changed to: %s" % provider_id)
	current_provider = provider_id
	provider_changed.emit(provider_id)


func _on_ai_response_received(response: String) -> void:
	"""Handle AI response"""
	print("[AICoordinator] Info: AI response received: %s" % response.substr(0, 100) + "...")
	ai_response_received.emit(response)


func _on_ai_error_occurred(error: String) -> void:
	"""Handle AI error"""
	push_error("[AICoordinator] Error: AI error: %s" % error)
	ai_error_occurred.emit(error)


	# === CONTEXT MANAGEMENT ===
