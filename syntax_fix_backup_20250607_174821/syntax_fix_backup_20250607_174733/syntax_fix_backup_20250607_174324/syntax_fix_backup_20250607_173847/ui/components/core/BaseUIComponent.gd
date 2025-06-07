# Base UI Component for NeuroVis
# Provides common functionality, lifecycle management, and consistent interface

class_name BaseUIComponent
extends Control

# === DEPENDENCIES ===

signal component_ready
signal component_destroyed
signal component_updated(property_name: String, old_value, new_value)

# === ACCESSIBILITY ===
signal focus_requested
signal help_requested

# === THEMING ===
signal component_theme_changed(theme_mode: String)

# === COMPONENT STATE ===

enum ComponentState { INITIALIZING, READY, UPDATING, ERROR, DESTROYED }

const SafeAutoloadAccess = preprepreprepreload("res://ui/components/core/SafeAutoloadAccess.gd")

# === COMPONENT LIFECYCLE ===

@export var component_id: String = ""
@export var auto_initialize: bool = true
@export var enable_logging: bool = true
@export var accessibility_enabled: bool = true

# === PRIVATE PROPERTIES ===

var current_state: ComponentState = ComponentState.INITIALIZING

# === CONFIGURATION ===
	var old_config = _component_config.duplicate()

	# Merge new config with existing
	for key in config:
		var old_value = _component_config.get(key)
		_component_config[key] = config[key]
		component_updated.emit(key, old_value, config[key])

	_apply_config_changes(old_config, _component_config)
	current_state = ComponentState.READY


	var theme_applied = SafeAutoloadAccess.apply_theme_safely(self, "panel")

	if not theme_applied:
		_log("Using fallback theming for " + component_id, "info")

	# Apply component-specific theming
	_apply_component_theme()


	var old_value = _component_config.get(key)
	_component_config[key] = value
	component_updated.emit(key, old_value, value)

	if _initialized:
		update_component({key: value})


	var viewport = get_viewport()
	if viewport:
		var vp_size = viewport.get_visible_rect().size
		# Simple responsive calculation
		if vp_size.x < 768:
			return vp_size * 0.9  # Mobile: 90% of viewport
		elif vp_size.x < 1024:
			return vp_size * 0.6  # Tablet: 60% of viewport
		else:
			return vp_size * 0.3  # Desktop: 30% of viewport
	return size


# === ANIMATION HELPERS ===
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, duration)


	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, duration)
	tween.tween_callback(func(): visible = false)


	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE.darkened(0.1), duration * 0.5)
	tween.tween_property(self, "modulate", Color.WHITE, duration * 0.5)


# === INPUT HANDLING ===
	var prefix = "[" + get_class() + ":" + component_id + "] "
	var full_message = prefix + message

	# Add autoload status to error messages for debugging
	if level == "error":
		var status = SafeAutoloadAccess.get_autoload_status()
		var unavailable = []
		for autoload_name in status:
			if not status[autoload_name]:
				unavailable.append(autoload_name)

		if not unavailable.is_empty():
			full_message += " (Unavailable autoloads: " + str(unavailable) + ")"

	match level:
		"error":
			push_error(full_message)
		"warning":
			push_warning(full_message)
		_:
			print(full_message)


	var component_script = load("res://ui/components/" + component_class + ".gd")
	if component_script:
		var component = component_script.new()
		if component is BaseUIComponent:
			component.set_config(config)
			return component
	return null

var _initialized: bool = false
var _component_config: Dictionary = {}
var _theme_mode: String = "enhanced"
var _accessibility_data: Dictionary = {}


func _ready() -> void:
	if auto_initialize:
		call_deferred("initialize_component")


func _exit_tree() -> void:
	cleanup_component()


# === CORE LIFECYCLE METHODS ===

func initialize_component() -> void:
	"""Initialize the component with configuration and styling"""
	if _initialized:
		return

	current_state = ComponentState.INITIALIZING
	_log("Initializing component: " + get_class())

	# Set component ID if not provided
	if component_id.is_empty():
		component_id = get_class() + "_" + str(get_instance_id())

	# Initialize component-specific functionality
	_setup_component()
	_apply_theme()
	_setup_accessibility()

	_initialized = true
	current_state = ComponentState.READY
	_log("Component ready: " + component_id)
	component_ready.emit()


func update_component(config: Dictionary = {}) -> void:
	"""Update component with new configuration"""
	if current_state == ComponentState.DESTROYED:
		_log("Cannot update destroyed component", "warning")
		return

	current_state = ComponentState.UPDATING
func cleanup_component() -> void:
	"""Clean up component resources"""
	if current_state == ComponentState.DESTROYED:
		return

	_log("Cleaning up component: " + component_id)
	current_state = ComponentState.DESTROYED

	_cleanup_resources()
	component_destroyed.emit()


func apply_theme(theme_mode: String = "") -> void:
	"""Apply theme to component"""
	if theme_mode != "":
		_theme_mode = theme_mode

	_apply_theme()
	component_theme_changed.emit(_theme_mode)


func get_theme_mode() -> String:
	"""Get current theme mode"""
	return _theme_mode


# === ACCESSIBILITY SYSTEM ===
func set_accessibility_data(data: Dictionary) -> void:
	"""Set accessibility information"""
	_accessibility_data = data

	if data.has("description"):
		set_meta("accessible_description", data.description)
	if data.has("role"):
		set_meta("accessible_role", data.role)
	if data.has("help_text"):
		tooltip_text = data.help_text


func get_accessibility_data() -> Dictionary:
	"""Get accessibility information"""
	return _accessibility_data


func request_focus() -> void:
	"""Request focus for this component"""
	grab_focus()
	focus_requested.emit()


# === CONFIGURATION MANAGEMENT ===
func set_config(config: Dictionary) -> void:
	"""Set component configuration"""
	_component_config = config
	if _initialized:
		update_component(config)


func get_config() -> Dictionary:
	"""Get component configuration"""
	return _component_config.duplicate()


func set_config_value(key: String, value) -> void:
	"""Set a single configuration value"""
func get_config_value(key: String, default_value = null):
	"""Get a single configuration value"""
	return _component_config.get(key, default_value)


# === STATE MANAGEMENT ===
func get_component_state() -> ComponentState:
	"""Get current component state"""
	return current_state


func is_ready() -> bool:
	"""Check if component is ready"""
	return current_state == ComponentState.READY


func set_error_state(error_message: String = "") -> void:
	"""Set component to error state"""
	current_state = ComponentState.ERROR
	_log("Component error: " + error_message, "error")


# === RESPONSIVE DESIGN ===
func get_responsive_size() -> Vector2:
	"""Get responsive size based on parent/viewport"""
func animate_show(duration: float = 0.3) -> void:
	"""Animate component entrance"""
	modulate.a = 0.0
	visible = true
func animate_hide(duration: float = 0.2) -> void:
	"""Animate component exit"""
func animate_update(duration: float = 0.2) -> void:
	"""Animate component update"""
func get_component_info() -> Dictionary:
	"""Get component information for debugging"""
	return {
		"id": component_id,
		"class": get_class(),
		"state": ComponentState.keys()[current_state],
		"initialized": _initialized,
		"theme_mode": _theme_mode,
		"accessibility_enabled": accessibility_enabled,
		"config": _component_config
	}


# === SIGNAL HELPERS ===
func connect_to_signal(signal_name: String, target: Object, method: String) -> void:
	"""Safe signal connection"""
	if has_signal(signal_name) and target and target.has_method(method):
		if not is_connected(signal_name, Callable(target, method)):
			connect(signal_name, Callable(target, method))


func disconnect_from_signal(signal_name: String, target: Object, method: String) -> void:
	"""Safe signal disconnection"""
	if has_signal(signal_name) and target and is_connected(signal_name, Callable(target, method)):
		disconnect(signal_name, Callable(target, method))


# === FACTORY HELPER ===
static func create_component(component_class: String, config: Dictionary = {}) -> BaseUIComponent:
	"""Factory method to create components"""

func _setup_component() -> void:
	"""Override in derived classes for component-specific setup"""
	pass


func _apply_config_changes(_old_config: Dictionary, _new_config: Dictionary) -> void:
	"""Override in derived classes to handle config changes"""
	pass


func _cleanup_resources() -> void:
	"""Override in derived classes for cleanup"""
	pass


# === THEMING SYSTEM ===
func _apply_theme() -> void:
	"""Apply theme safely with fallbacks"""
	# Try to apply advanced theming first
func _apply_component_theme() -> void:
	"""Override in derived classes for component-specific theming"""
	pass


func _setup_accessibility() -> void:
	"""Setup accessibility features"""
	if not accessibility_enabled:
		return

	# Set accessible name if not set (check property existence)
	if not has_meta("accessible_name") or str(get_meta("accessible_name", "")).is_empty():
		set_meta("accessible_name", component_id.replace("_", " ").capitalize())

	# Set accessible role (use meta for custom accessibility data)
	if not has_meta("accessible_role"):
		set_meta("accessible_role", 0)  # Generic role

	# Setup keyboard navigation
	if focus_mode == Control.FOCUS_NONE:
		focus_mode = Control.FOCUS_CLICK


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_RESIZED:
			_handle_resize()


func _handle_resize() -> void:
	"""Handle component resize - override in derived classes"""
	pass


func _gui_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		_handle_key_input(event)


func _handle_key_input(event: InputEventKey) -> void:
	"""Handle keyboard input - override in derived classes"""
	match event.keycode:
		KEY_F1:
			if accessibility_enabled:
				help_requested.emit()
		KEY_ESCAPE:
			if has_method("close") or has_method("hide"):
				call("close") if has_method("close") else call("hide")


# === UTILITY METHODS ===
func _log(message: String, level: String = "info") -> void:
	"""Component logging with autoload status on errors"""
	if not enable_logging:
		return

