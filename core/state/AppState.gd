## AppState.gd
## Application state management for NeuroVis educational platform
##
## This system manages global application state with persistence,
## state change notification, and educational session tracking.
##
## @tutorial: State management for educational platform
## @version: 1.0

class_name AppState
extends Node

# === SIGNALS ===
## Emitted when a state value changes
signal state_changed(key: String, old_value, new_value)

## Emitted when a state group is updated
signal state_group_changed(group_name: String)

## Emitted when state is saved to disk
signal state_saved()

## Emitted when state is loaded from disk
signal state_loaded()

# === CONSTANTS ===
const STATE_FILE_PATH = "user://app_state.cfg"
const EDUCATIONAL_SESSION_GROUP = "educational_session"
const USER_PREFERENCES_GROUP = "user_preferences"
const MODEL_STATE_GROUP = "model_state"
const UI_STATE_GROUP = "ui_state"

# === PRIVATE VARIABLES ===
# Main state storage
var _state: Dictionary = {}

# Change listeners by key
var _listeners: Dictionary = {}

# Group mappings
var _groups: Dictionary = {}

# Dirty flag for auto-save
var _state_dirty: bool = false
var _auto_save_enabled: bool = true

# === INITIALIZATION ===
func _ready() -> void:
	# Initialize with defaults
	_initialize_default_state()
	
	# Load saved state if available
	load_state()
	
	print("[AppState] Educational state management initialized")
	
	# Setup auto-save timer if enabled
	if _auto_save_enabled:
		var timer = Timer.new()
		timer.wait_time = 30.0 # 30 seconds
		timer.autostart = true
		timer.timeout.connect(_on_auto_save_timer)
		add_child(timer)

func _initialize_default_state() -> void:
	"""Initialize default application state"""
	# Educational session defaults
	_register_state_group(EDUCATIONAL_SESSION_GROUP, [
		"current_structure",
		"viewed_structures",
		"learning_progress",
		"session_start_time",
		"session_duration",
		"interactions_count"
	])
	
	# User preferences defaults
	_register_state_group(USER_PREFERENCES_GROUP, [
		"theme_mode",
		"accessibility_settings",
		"camera_sensitivity",
		"audio_enabled",
		"tooltip_delay",
		"content_detail_level"
	])
	
	# 3D model state
	_register_state_group(MODEL_STATE_GROUP, [
		"current_model",
		"visible_layers",
		"last_camera_position",
		"last_camera_rotation",
		"cross_section_enabled",
		"cross_section_plane"
	])
	
	# UI state
	_register_state_group(UI_STATE_GROUP, [
		"panel_positions",
		"panel_visibility",
		"expanded_sections",
		"last_search_query",
		"panel_layout"
	])
	
	# Initialize with default values
	_state = {
		# Educational session
		"current_structure": "",
		"viewed_structures": [],
		"learning_progress": {},
		"session_start_time": 0,
		"session_duration": 0,
		"interactions_count": 0,
		
		# User preferences
		"theme_mode": "enhanced",
		"accessibility_settings": {
			"high_contrast": false,
			"reduced_motion": false,
			"text_size": 1.0,
			"color_blind_mode": "normal"
		},
		"camera_sensitivity": 1.0,
		"audio_enabled": true,
		"tooltip_delay": 0.5,
		"content_detail_level": "standard",
		
		# 3D model state
		"current_model": "internal_structures",
		"visible_layers": ["cortex", "subcortical", "ventricles"],
		"last_camera_position": Vector3(0, 0, 5),
		"last_camera_rotation": Vector3(0, 0, 0),
		"cross_section_enabled": false,
		"cross_section_plane": Plane(Vector3(1, 0, 0), 0),
		
		# UI state
		"panel_positions": {},
		"panel_visibility": {"info_panel": true, "model_control": true},
		"expanded_sections": ["quick_facts"],
		"last_search_query": "",
		"panel_layout": "right"
	}

# === PUBLIC API ===
## Get a state value
## @param key: State key to retrieve
## @param default_value: Value to return if key not found
## @returns: The state value or default_value if not found
func get_state(key: String, default_value = null):
	"""Get an educational state value with fallback"""
	return _state.get(key, default_value)

## Set a state value
## @param key: State key to set
## @param value: New value to store
## @param persist: Whether to persist this change immediately
func set_state(key: String, value, persist: bool = false) -> void:
	"""Set an educational state value with optional persistence"""
	# Get current value for comparison
	var old_value = _state.get(key)
	
	# Skip if unchanged
	if old_value == value:
		return
	
	# Update state
	_state[key] = value
	_state_dirty = true
	
	# Find associated group
	var group_name = _get_group_for_key(key)
	
	# Notify listeners
	_notify_listeners(key, old_value, value)
	
	# Notify group listeners if applicable
	if group_name:
		state_group_changed.emit(group_name)
	
	# Persist immediately if requested
	if persist:
		save_state()

## Get multiple state values by group
## @param group_name: Name of the state group
## @returns: Dictionary with group state values
func get_state_group(group_name: String) -> Dictionary:
	"""Get a group of related educational state values"""
	var result = {}
	
	if _groups.has(group_name):
		for key in _groups[group_name]:
			if _state.has(key):
				result[key] = _state[key]
	
	return result

## Update multiple state values in a group
## @param group_name: Name of the state group
## @param values: Dictionary of key/value pairs to update
## @param persist: Whether to persist these changes immediately
func update_state_group(group_name: String, values: Dictionary, persist: bool = false) -> void:
	"""Update a group of related educational state values"""
	if not _groups.has(group_name):
		push_warning("[AppState] Unknown state group: %s" % group_name)
		return
	
	var changes_made = false
	
	# Update each provided value
	for key in values:
		if _groups[group_name].has(key):
			var old_value = _state.get(key)
			if old_value != values[key]:
				_state[key] = values[key]
				_notify_listeners(key, old_value, values[key])
				changes_made = true
	
	if changes_made:
		_state_dirty = true
		state_group_changed.emit(group_name)
		
		if persist:
			save_state()

## Register a listener for state changes
## @param key: State key to listen for
## @param callback: Callable to invoke when state changes
func register_listener(key: String, callback: Callable) -> void:
	"""Register listener for educational state changes"""
	if not _listeners.has(key):
		_listeners[key] = []
	
	if not _listeners[key].has(callback):
		_listeners[key].append(callback)

## Unregister a listener
## @param key: State key the listener was registered for
## @param callback: Callable to remove
func unregister_listener(key: String, callback: Callable) -> void:
	"""Unregister listener for educational state changes"""
	if _listeners.has(key):
		_listeners[key].erase(callback)

## Save state to disk
## @returns: true if save successful, false otherwise
func save_state() -> bool:
	"""Save educational state to persistent storage"""
	var config = ConfigFile.new()
	
	# Save each group to its own section
	for group_name in _groups:
		for key in _groups[group_name]:
			if _state.has(key):
				var value = _state[key]
				
				# Special handling for certain types
				if value is Object and value.has_method("to_dict"):
					# Convert objects with to_dict method
					value = value.to_dict()
				elif value is Vector2 or value is Vector3 or value is Color:
					# Built-in types are handled automatically
					pass
				
				config.set_value(group_name, key, value)
	
	# Save to file
	var error = config.save(STATE_FILE_PATH)
	
	if error == OK:
		print("[AppState] Educational state saved successfully")
		_state_dirty = false
		state_saved.emit()
		return true
	else:
		push_error("[AppState] Failed to save state: Error %d" % error)
		return false

## Load state from disk
## @returns: true if load successful, false otherwise
func load_state() -> bool:
	"""Load educational state from persistent storage"""
	var config = ConfigFile.new()
	var error = config.load(STATE_FILE_PATH)
	
	if error != OK:
		print("[AppState] No saved state found or error loading: %d" % error)
		return false
	
	# Track changes for notifications
	var changed_keys = []
	var changed_groups = {}
	
	# Load each saved value
	for section in config.get_sections():
		for key in config.get_section_keys(section):
			var old_value = _state.get(key)
			var new_value = config.get_value(section, key)
			
			# Only update if different
			if old_value != new_value:
				_state[key] = new_value
				changed_keys.append(key)
				
				# Track changed group
				var group = _get_group_for_key(key)
				if group:
					changed_groups[group] = true
	
	# Notify listeners of changes
	for key in changed_keys:
		_notify_listeners(key, null, _state[key])
	
	# Notify group listeners
	for group_name in changed_groups:
		state_group_changed.emit(group_name)
	
	print("[AppState] Educational state loaded successfully")
	state_loaded.emit()
	return true

## Reset state to default values
## @param group_name: Optional group to reset (or all if not specified)
## @param persist: Whether to persist these changes immediately
func reset_state(group_name: String = "", persist: bool = true) -> void:
	"""Reset educational state to defaults"""
	# Initialize a clean state
	var default_state = {}
	_initialize_default_state()
	default_state = _state.duplicate(true)
	
	# Reset all or just specified group
	if group_name.is_empty():
		print("[AppState] Resetting all educational state to defaults")
		_state = default_state
		for g in _groups:
			state_group_changed.emit(g)
	else:
		if not _groups.has(group_name):
			push_warning("[AppState] Unknown state group: %s" % group_name)
			return
		
		print("[AppState] Resetting state group: %s" % group_name)
		for key in _groups[group_name]:
			if default_state.has(key):
				var old_value = _state.get(key)
				_state[key] = default_state[key]
				_notify_listeners(key, old_value, _state[key])
		
		state_group_changed.emit(group_name)
	
	_state_dirty = true
	
	if persist:
		save_state()

## Check if state has unsaved changes
## @returns: true if state has unsaved changes, false otherwise
func has_unsaved_changes() -> bool:
	"""Check if educational state has unsaved changes"""
	return _state_dirty

## Enable or disable auto-save
## @param enabled: Whether auto-save should be enabled
func set_auto_save(enabled: bool) -> void:
	"""Configure educational state auto-save feature"""
	_auto_save_enabled = enabled
	print("[AppState] Auto-save %s" % ("enabled" if enabled else "disabled"))

## Start tracking a new educational session
func start_educational_session() -> void:
	"""Start tracking a new educational learning session"""
	update_state_group(EDUCATIONAL_SESSION_GROUP, {
		"session_start_time": Time.get_unix_time_from_system(),
		"session_duration": 0,
		"interactions_count": 0,
		"viewed_structures": []
	})
	
	print("[AppState] Started new educational session")

## Update session with structure view
## @param structure_name: Name of the structure viewed
func record_structure_view(structure_name: String) -> void:
	"""Record educational structure view for learning analytics"""
	var viewed = get_state("viewed_structures", []).duplicate()
	
	# Only add if not already viewed
	if not viewed.has(structure_name):
		viewed.append(structure_name)
		set_state("viewed_structures", viewed)
	
	# Increment interactions
	var count = get_state("interactions_count", 0)
	set_state("interactions_count", count + 1)
	
	# Update current structure
	set_state("current_structure", structure_name)

## Get educational session statistics
## @returns: Dictionary with session statistics
func get_session_statistics() -> Dictionary:
	"""Get educational session statistics for learning analytics"""
	var start_time = get_state("session_start_time", 0)
	var current_time = Time.get_unix_time_from_system()
	var duration = current_time - start_time
	
	# Update duration in state
	set_state("session_duration", duration)
	
	var viewed = get_state("viewed_structures", [])
	var interactions = get_state("interactions_count", 0)
	
	return {
		"duration_seconds": duration,
		"duration_formatted": _format_duration(duration),
		"structures_viewed": viewed.size(),
		"unique_structures": viewed,
		"interactions_count": interactions,
		"interaction_rate": interactions / (duration / 60.0) if duration > 0 else 0 # per minute
	}

# === DEBUGGING ===
## Print current state for debugging
func print_state() -> void:
	"""Print educational state for debugging"""
	print("\n=== EDUCATIONAL APP STATE ===")
	
	for group_name in _groups:
		print("\nGroup: %s" % group_name)
		for key in _groups[group_name]:
			if _state.has(key):
				print("- %s: %s" % [key, _state[key]])
	
	print("\nDirty: %s" % _state_dirty)
	print("==============================\n")

# === PRIVATE METHODS ===
func _register_state_group(group_name: String, keys: Array) -> void:
	"""Register a group of related state keys"""
	_groups[group_name] = keys

func _notify_listeners(key: String, old_value, new_value) -> void:
	"""Notify all listeners of state change"""
	# Emit general signal
	state_changed.emit(key, old_value, new_value)
	
	# Notify specific listeners
	if _listeners.has(key):
		for callback in _listeners[key]:
			if callback.is_valid():
				callback.call(key, old_value, new_value)

func _get_group_for_key(key: String) -> String:
	"""Find which group a key belongs to"""
	for group_name in _groups:
		if _groups[group_name].has(key):
			return group_name
	return ""

func _format_duration(seconds: float) -> String:
	"""Format duration in seconds to human-readable string"""
	var hours = int(seconds) / 3600.0
	var minutes = (int(seconds) % 3600) / 60.0
	var secs = int(seconds) % 60
	
	if hours > 0:
		return "%d:%02d:%02d" % [hours, minutes, secs]
	else:
		return "%d:%02d" % [minutes, secs]

func _on_auto_save_timer() -> void:
	"""Auto-save timer callback"""
	if _auto_save_enabled and _state_dirty:
		save_state()