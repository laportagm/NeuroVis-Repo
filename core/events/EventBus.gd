## EventBus.gd
## Core event system for decoupled communication between educational components
##
## This system manages events and listeners throughout the NeuroVis educational platform,
## allowing components to communicate without direct references.
##
## @tutorial: Decoupled communication patterns for educational platform
## @version: 1.0

class_name EventBus
extends Node

# === CONSTANTS ===
# Structure interaction events

const STRUCTURE_SELECTED = "structure_selected"
const STRUCTURE_HOVERED = "structure_hover"
const STRUCTURE_DESELECTED = "structure_deselected"
const MULTI_SELECTION_CHANGED = "multi_selection_changed"

# Educational navigation events
const CAMERA_VIEW_CHANGED = "camera_view_changed"
const EDUCATIONAL_VIEW_REQUESTED = "educational_view_requested"
const FOCUS_ON_STRUCTURE = "focus_on_structure"

# UI events
const THEME_CHANGED = "theme_changed"
const PANEL_CREATED = "panel_created"
const PANEL_CLOSED = "panel_closed"
const EDUCATIONAL_CONTENT_LOADED = "educational_content_loaded"

# Model events
const MODEL_CHANGED = "model_changed"
const MODEL_LAYER_TOGGLED = "model_layer_toggled"
const MODEL_LOADED = "model_loaded"

# Educational analytics events
const LEARNING_INTERACTION = "learning_interaction"
const EDUCATIONAL_MILESTONE = "educational_milestone"
const LEARNING_SESSION_STARTED = "learning_session_started"
const LEARNING_SESSION_ENDED = "learning_session_ended"

# Accessibility events
const ACCESSIBILITY_SETTING_CHANGED = "accessibility_setting_changed"
const COLOR_SCHEME_CHANGED = "color_scheme_changed"
const TEXT_SIZE_CHANGED = "text_size_changed"

# === PRIVATE VARIABLES ===
# Map of event names to array of listener callables
const MAX_TRACE_EVENTS = 100


# === INITIALIZATION ===

var removed = _listeners[event_name].erase(callback)
# FIXED: Orphaned code - var listener_count = _listeners[event_name].size()
# FIXED: Orphaned code - var trace_entry = {
"timestamp": Time.get_unix_time_from_system(),
"event": event_name,
"data": str(event_data).substr(0, 100)  # Limit data length
}

_recent_events.append(trace_entry)

# Keep trace history manageable

var _listeners: Dictionary = {}

# Event tracing for debug mode
var _event_trace_enabled: bool = false
var _recent_events: Array = []

func _ready() -> void:
	# Configure event tracing based on debug status
	_event_trace_enabled = OS.is_debug_build()
	print("[EventBus] Initialized with event tracing: %s" % _event_trace_enabled)


	# === PUBLIC API ===
	## Register a listener for an event
	## @param event_name: Name of the event to listen for
	## @param callback: Callable to invoke when event occurs

func register(event_name: String, callback: Callable) -> void:
	"""Register a listener for educational events"""
	if not _listeners.has(event_name):
		_listeners[event_name] = []

		if not _listeners[event_name].has(callback):
			_listeners[event_name].append(callback)
			print("[EventBus] Registered listener for: %s" % event_name)


			## Unregister a listener for an event
			## @param event_name: Name of the event
			## @param callback: Callable to remove
func unregister(event_name: String, callback: Callable) -> void:
	"""Unregister a listener for educational events"""
	if _listeners.has(event_name):
func emit(event_name: String, event_data = null) -> void:
	"""Emit an educational event with optional data"""
	if _event_trace_enabled:
		_trace_event(event_name, event_data)

		if _listeners.has(event_name):
			for callback in _listeners[event_name]:
				if callback.is_valid():
					# Pass both event name and data to allow generic listeners
					callback.call(event_name, event_data)


					## Check if there are any listeners for an event
					## @param event_name: Name of the event to check
					## @returns: true if there are listeners, false otherwise
func has_listeners(event_name: String) -> bool:
	"""Check if an educational event has any listeners"""
	return _listeners.has(event_name) and not _listeners[event_name].is_empty()


	## Get number of listeners for an event
	## @param event_name: Name of the event to check
	## @returns: Number of registered listeners
func get_listener_count(event_name: String) -> int:
	"""Get count of listeners for educational event debugging"""
	if _listeners.has(event_name):
		return _listeners[event_name].size()
		return 0


		## Clear all listeners for an event
		## @param event_name: Name of the event to clear
func clear_listeners(event_name: String) -> void:
	"""Clear all listeners for an educational event"""
	if _listeners.has(event_name):
		_listeners[event_name].clear()
		print("[EventBus] Cleared all listeners for: %s" % event_name)


		## Get all registered event names
		## @returns: Array of event names that have listeners
func get_registered_events() -> Array:
	"""Get all registered educational events for debugging"""
	return _listeners.keys()


	# === DEBUGGING UTILITIES ===
	## Enable or disable event tracing
	## @param enabled: Whether tracing should be enabled
func set_event_tracing(enabled: bool) -> void:
	"""Enable/disable detailed educational event tracing"""
	_event_trace_enabled = enabled
	print("[EventBus] Event tracing: %s" % ("ENABLED" if enabled else "DISABLED"))


	## Get recent event trace (if tracing enabled)
	## @returns: Array of recent events with timestamps
func get_event_trace() -> Array:
	"""Get recent educational events for debugging"""
	return _recent_events.duplicate()


	## Clear the event trace history
func clear_event_trace() -> void:
	"""Clear event trace history"""
	_recent_events.clear()
	print("[EventBus] Event trace cleared")


	## Print current event listener statistics
func print_event_statistics() -> void:
	"""Print educational event statistics for debugging"""
	print("\n=== EVENT BUS STATISTICS ===")
	print("Total registered event types: %d" % _listeners.size())

	if _listeners.is_empty():
		print("No events registered")
		else:
			for event_name in _listeners.keys():

if removed:
	print("[EventBus] Unregistered listener for: %s" % event_name)


	## Emit an event with optional data
	## @param event_name: Name of the event to emit
	## @param event_data: Optional data to pass to listeners
print("Event: %s - %d listener(s)" % [event_name, listener_count])

print("===========================\n")


# === PRIVATE METHODS ===
if _recent_events.size() > MAX_TRACE_EVENTS:
	_recent_events.pop_front()

func _trace_event(event_name: String, event_data) -> void:
	"""Record event for debugging purposes"""
