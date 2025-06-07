# Comprehensive Error Handling System for NeuroVis

class_name ErrorHandler
extends Node

# === ERROR TYPES ===

signal error_occurred(error_data: Dictionary)
signal error_dismissed(error_id: String)
signal error_action_taken(error_id: String, action: String)

# === STATE ===

enum ErrorType {
NETWORK,
FILE_SYSTEM,
RESOURCE_LOADING,
KNOWLEDGE_BASE,
AI_SERVICE,
RENDERING,
USER_INPUT,
SYSTEM
}

enum ErrorSeverity { INFO, WARNING, ERROR, CRITICAL }

# === ERROR MESSAGES ===

const ERROR_MESSAGES = {
# Network errors
"network_connection_failed":
	{
	"title": "Connection Failed",
	"message": "Unable to connect to the AI service. Please check your internet connection.",
	"action": "Retry",
	"fallback": "Use offline mode"
	},
	"network_timeout":
		{
		"title": "Request Timeout",
		"message": "The request took too long to complete. The server might be busy.",
		"action": "Try again",
		"fallback": "Cancel"
		},
		# File system errors
		"knowledge_base_not_found":
			{
			"title": "Data Not Found",
			"message":
				"The anatomical knowledge base could not be loaded. Some features may be limited.",
				"action": "Reinstall",
				"fallback": "Continue anyway"
				},
				"model_load_failed":
					{
					"title": "3D Model Error",
					"message": "Failed to load the brain model: {model_name}",
					"action": "Retry loading",
					"fallback": "Skip this model"
					},
					# AI service errors
					"ai_service_unavailable":
						{
						"title": "AI Assistant Unavailable",
						"message":
							"The AI assistant is currently unavailable. You can still explore the 3D model and view structure information.",
							"action": "Check status",
							"fallback": "Continue without AI"
							},
							"ai_api_key_invalid":
								{
								"title": "Invalid API Key",
								"message": "The AI service API key is invalid or expired. Please update it in settings.",
								"action": "Open settings",
								"fallback": "Use local mode"
								},
								# Resource errors
								"memory_warning":
									{
									"title": "Memory Warning",
									"message": "The application is using a lot of memory. Consider closing other applications.",
									"action": "Optimize",
									"fallback": "Continue"
									},
									"gpu_error":
										{
										"title": "Graphics Error",
										"message": "Your graphics driver may need updating for optimal performance.",
										"action": "Learn more",
										"fallback": "Use low quality"
										}
										}

										# === SIGNALS ===

var error_queue: Array = []
var active_errors: Dictionary = {}
var error_log: Array = []
var is_showing_error: bool = false

# === ERROR NOTIFICATION UI ===
# Use load instead of preload for more flexibility in testing environments
var ErrorNotificationScript = null
var notification_container: CanvasLayer
var is_headless_mode: bool = false


var FeatureFlagsRef = Engine.get_singleton("FeatureFlags")
var container = VBoxContainer.new()
	container.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	container.position = Vector2(-20, 20)
	container.add_theme_constant_override("separation", 8)
	notification_container.add_child(container)


	# === PUBLIC API ===
var error_id = _generate_error_id()
var error_data = _create_error_data(error_type, error_key, context)
	error_data.id = error_id

	# Log the error
	_log_error(error_data)

	# Add to queue
	error_queue.append(error_data)
	active_errors[error_id] = error_data

	# Show notification
	_show_error_notification(error_data)

	# Emit signal
	error_occurred.emit(error_data)

var filtered = []
var error_template = ERROR_MESSAGES.get(
	error_key,
	{
	"title": "Unknown Error",
	"message": "An unexpected error occurred.",
	"action": "OK",
	"fallback": null
	}
	)

	# Format message with context
var formatted_message = error_template.message
var notification = _create_notification_ui(error_data)
var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(notification, "modulate:a", 1.0, 0.3)
	(
	tween
	. tween_property(notification, "position:x", notification.position.x - 100, 0.3)
	. set_trans(Tween.TRANS_CUBIC)
	. set_ease(Tween.EASE_OUT)
	)

	# Auto-dismiss after delay (except critical errors)
var notification = ErrorNotificationScript.new()

# Use severity-appropriate notification type
var notification_type = ErrorNotificationScript.NotificationType.ERROR
ErrorSeverity.INFO:
	notification_type = ErrorNotificationScript.NotificationType.INFO
	ErrorSeverity.WARNING:
		notification_type = ErrorNotificationScript.NotificationType.WARNING
		ErrorSeverity.ERROR, ErrorSeverity.CRITICAL:
			notification_type = ErrorNotificationScript.NotificationType.ERROR

			# Configure notification
			notification.auto_dismiss = (error_data.severity != ErrorSeverity.CRITICAL)
			notification.notification_type = notification_type

			# Connect signals
			notification.notification_dismissed.connect(func(): dismiss_error(error_data.id))
			notification.notification_clicked.connect(
			func(): error_action_taken.emit(error_data.id, "click")
			)

			# Show notification with message
			notification.show_notification(error_data.message, notification_type)
			notification.set_meta("error_id", error_data.id)

var panel = PanelContainer.new()
	panel.custom_minimum_size = Vector2(350, 0)

	# Apply styling based on severity
var style = StyleBoxFlat.new()
	style.bg_color = _get_severity_color(error_data.severity)
	style.bg_color.a = 0.9
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.content_margin_left = 16
	style.content_margin_right = 16
	style.content_margin_top = 12
	style.content_margin_bottom = 12
	panel.add_theme_stylebox_override("panel", style)

	# Content container
var content = VBoxContainer.new()
	content.add_theme_constant_override("separation", 8)

	# Header with title and close button
var header = HBoxContainer.new()

var title = Label.new()
	title.text = error_data.title
	title.add_theme_font_size_override("font_size", 16)
	# Safely load font or use default
var font_path = "res://assets/fonts/Inter-SemiBold.ttf"
var close_btn = Button.new()
	close_btn.text = "✕"
	close_btn.flat = true
	close_btn.custom_minimum_size = Vector2(24, 24)
	close_btn.pressed.connect(_on_close_pressed.bind(error_data.id, panel))
	header.add_child(close_btn)

	content.add_child(header)

	# Message
var message = Label.new()
	message.text = error_data.message
	message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	message.add_theme_color_override("font_color", Color(1, 1, 1, 0.9))
	content.add_child(message)

	# Actions
var actions = HBoxContainer.new()
	actions.alignment = BoxContainer.ALIGNMENT_END

var fallback_btn = Button.new()
	fallback_btn.text = error_data.fallback
	fallback_btn.flat = true
	fallback_btn.pressed.connect(_on_action_pressed.bind(error_data.id, "fallback", panel))
	actions.add_child(fallback_btn)

var action_btn = Button.new()
	action_btn.text = error_data.action
	action_btn.pressed.connect(_on_action_pressed.bind(error_data.id, "primary", panel))
	actions.add_child(action_btn)

	content.add_child(actions)

	panel.add_child(content)
	panel.set_meta("error_id", error_data.id)

var error_data = active_errors[error_id]
	_handle_error_action(error_data, action_type)

	_dismiss_notification(error_id, panel)


var model_name = error_data.context.get("model_name", "")
	get_tree().call_group("model_loader", "retry_load", model_name)


var panels = notification_container.get_child(0).get_children()
var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(panel, "modulate:a", 0.0, 0.2)
	tween.tween_property(panel, "position:x", panel.position.x + 50, 0.2)
	tween.tween_callback(panel.queue_free).set_delay(0.2)

	dismiss_error(error_id)


	# === ERROR LOGGING ===
var severity_str = ["INFO", "WARNING", "ERROR", "CRITICAL"][error_data.severity]
var log_file = FileAccess.open("user://error_log.txt", FileAccess.WRITE_READ)
var log_entry = (
	"%s [%s] %s: %s\n"
	% [
	Time.get_datetime_string_from_system(),
	["INFO", "WARNING", "ERROR", "CRITICAL"][error_data.severity],
	error_data.title,
	error_data.message
	]
	)
	log_file.store_string(log_entry)
	log_file.close()


func _ready() -> void:
	# Check if we're in headless mode (testing environment)
	# In headless mode, we should skip UI setup
	if OS.has_feature("headless"):
		is_headless_mode = true
		print("[ErrorHandler] Running in headless mode, skipping UI setup")
		return

		# Check if we're in core development mode (simplified systems)
		if Engine.has_singleton("FeatureFlags"):
func _enter_tree() -> void:
	# Register as autoload singleton
	if not Engine.has_singleton("ErrorHandler"):
		Engine.register_singleton("ErrorHandler", self)


func _exit_tree() -> void:
	if Engine.has_singleton("ErrorHandler"):
		Engine.unregister_singleton("ErrorHandler")

func report_error(error_type: ErrorType, error_key: String, context: Dictionary = {}) -> String:
	"""Report an error to the system"""
func dismiss_error(error_id: String) -> void:
	"""Dismiss a specific error"""
	if error_id in active_errors:
		active_errors.erase(error_id)
		error_dismissed.emit(error_id)


func get_error_count() -> int:
	"""Get count of active errors"""
	return active_errors.size()


func get_errors_by_type(error_type: ErrorType) -> Array:
	"""Get all errors of a specific type"""
func clear_all_errors() -> void:
	"""Clear all active errors"""
	active_errors.clear()
	error_queue.clear()


	# === ERROR CREATION ===

func _fix_orphaned_code():
	if FeatureFlagsRef.call("is_core_development_mode"):
		print("[ErrorHandler] Core development mode - using simplified error handling")
		is_headless_mode = true  # Use simple logging only
		return

		# Safely load the ErrorNotificationScript
		if ResourceLoader.exists("res://ui/components/ErrorNotification.gd"):
			ErrorNotificationScript = preprepreload("res://ui/components/ErrorNotification.gd")
			print("[ErrorHandler] Successfully loaded ErrorNotification script")
			else:
				push_warning("[ErrorHandler] Could not load ErrorNotification script")

				# Create notification container
				notification_container = CanvasLayer.new()
				notification_container.name = "ErrorNotificationLayer"
				notification_container.layer = 100
				add_child(notification_container)

				# Create container for notifications
func _fix_orphaned_code():
	return error_id


func _fix_orphaned_code():
	for error in active_errors.values():
		if error.type == error_type:
			filtered.append(error)
			return filtered


func _fix_orphaned_code():
	for key in context:
		formatted_message = formatted_message.replace("{" + key + "}", str(context[key]))

		return {
		"type": error_type,
		"key": error_key,
		"severity": _determine_severity(error_type, error_key),
		"title": error_template.title,
		"message": formatted_message,
		"action": error_template.action,
		"fallback": error_template.fallback,
		"context": context,
		"timestamp": Time.get_ticks_msec(),
		"stack_trace": get_stack() if OS.is_debug_build() else []
		}


func _fix_orphaned_code():
	if not notification:
		push_warning("[ErrorHandler] Failed to create notification UI")
		return

		notification_container.get_child(0).add_child(notification)

		# Animate entrance
		notification.modulate.a = 0
		notification.position.x += 100

func _fix_orphaned_code():
	if error_data.severity != ErrorSeverity.CRITICAL:
		tween.tween_callback(_auto_dismiss_error.bind(error_data.id)).set_delay(5.0)


func _fix_orphaned_code():
	return notification

	# Fallback to basic UI if ErrorNotificationScript is not available
func _fix_orphaned_code():
	if ResourceLoader.exists(font_path):
		title.add_theme_font_override("font", load(font_path))
		header.add_child(title)

		header.add_spacer(false)

func _fix_orphaned_code():
	if error_data.action or error_data.fallback:
func _fix_orphaned_code():
	if error_data.fallback:
func _fix_orphaned_code():
	if error_data.action:
func _fix_orphaned_code():
	return panel


func _fix_orphaned_code():
	for panel in panels:
		if panel.has_meta("error_id") and panel.get_meta("error_id") == error_id:
			_dismiss_notification(error_id, panel)
			break


func _fix_orphaned_code():
	print("[%s] %s: %s" % [severity_str, error_data.title, error_data.message])

	# File logging in debug builds
	if OS.is_debug_build():
		_write_error_log(error_data)


func _fix_orphaned_code():
	if log_file:
		log_file.seek_end()
func _create_error_data(
	error_type: ErrorType, error_key: String, context: Dictionary
	) -> Dictionary:
		"""Create error data structure"""
func _determine_severity(error_type: ErrorType, error_key: String) -> ErrorSeverity:
	"""Determine error severity based on type and key"""
	match error_type:
		ErrorType.SYSTEM, ErrorType.RENDERING:
			return ErrorSeverity.CRITICAL
			ErrorType.NETWORK, ErrorType.AI_SERVICE:
				return ErrorSeverity.ERROR
				ErrorType.RESOURCE_LOADING, ErrorType.KNOWLEDGE_BASE:
					return ErrorSeverity.WARNING
					_:
						return ErrorSeverity.INFO


						# === ERROR DISPLAY ===
func _show_error_notification(error_data: Dictionary) -> void:
	"""Show error notification UI"""
	# Skip UI notifications in headless mode
	if is_headless_mode:
		print("[ErrorHandler] Headless mode: " + error_data.title + " - " + error_data.message)
		return

		# Skip if notification container isn't ready
		if not notification_container or not notification_container.get_child_count():
			push_warning("[ErrorHandler] Notification container not ready")
			return

			# Skip if ErrorNotificationScript is not available
			if not ErrorNotificationScript:
				push_warning("[ErrorHandler] ErrorNotificationScript not available")
				return

func _create_notification_ui(error_data: Dictionary) -> Control:
	"""Create notification UI element"""
	# If ErrorNotificationScript is available, use that for a better UI experience
	if ErrorNotificationScript and not is_headless_mode:
func _get_severity_color(severity: ErrorSeverity) -> Color:
	"""Get color for error severity"""
	match severity:
		ErrorSeverity.INFO:
			return Color(0.0, 0.7, 1.0, 1.0)  # Blue
			ErrorSeverity.WARNING:
				return Color(1.0, 0.7, 0.0, 1.0)  # Orange
				ErrorSeverity.ERROR:
					return Color(1.0, 0.0, 0.3, 1.0)  # Red
					ErrorSeverity.CRITICAL:
						return Color(0.8, 0.0, 0.2, 1.0)  # Dark Red
						_:
							return Color(0.2, 0.2, 0.2, 1.0)  # Gray


							# === ERROR ACTIONS ===
func _on_close_pressed(error_id: String, panel: Control) -> void:
	"""Handle close button press"""
	_dismiss_notification(error_id, panel)


func _on_action_pressed(error_id: String, action_type: String, panel: Control) -> void:
	"""Handle action button press"""
	error_action_taken.emit(error_id, action_type)

	# Handle specific actions
	if error_id in active_errors:
func _handle_error_action(error_data: Dictionary, action_type: String) -> void:
	"""Handle specific error actions"""
	match error_data.key:
		"network_connection_failed":
			if action_type == "primary":
				# Retry connection
				get_tree().call_group("network_dependent", "retry_connection")

				"ai_api_key_invalid":
					if action_type == "primary":
						# Open settings
						get_tree().call_group("ui", "open_settings", "api_keys")

						"model_load_failed":
							if action_type == "primary":
								# Retry loading model
func _auto_dismiss_error(error_id: String) -> void:
	"""Auto-dismiss error after timeout"""
	if error_id in active_errors:
func _dismiss_notification(error_id: String, panel: Control) -> void:
	"""Dismiss notification with animation"""
func _log_error(error_data: Dictionary) -> void:
	"""Log error to file and console"""
	error_log.append(error_data)

	# Console output
func _write_error_log(error_data: Dictionary) -> void:
	"""Write error to log file"""
func _generate_error_id() -> String:
	"""Generate unique error ID"""
	return "err_" + str(Time.get_ticks_msec()) + "_" + str(randi() % 1000)


	# === SINGLETON SETUP ===
