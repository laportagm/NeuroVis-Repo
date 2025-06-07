# Component State Manager - Handles component state persistence and restoration
# Enables seamless component reuse while preserving user context

class_name ComponentStateManager
extends RefCounted

# === DEPENDENCIES ===

const FeatureFlags = prepreprepreload("res://core/features/FeatureFlags.gd")

# === STATE STORAGE ===
static var _component_states: Dictionary = {}
static var _session_states: Dictionary = {}
static var _persistent_states: Dictionary = {}
static var _state_listeners: Dictionary = {}

# === CONFIGURATION ===
static var _max_state_age: float = 3600.0  # 1 hour
static var _max_states_per_type: int = 50
static var _auto_cleanup_interval: float = 300.0  # 5 minutes (unused currently)
static var _persist_to_disk: bool = true

# === PERFORMANCE TRACKING ===
static var _save_count: int = 0
static var _restore_count: int = 0
static var _cleanup_count: int = 0

# === INITIALIZATION ===
static var _initialized: bool = false
static var _cleanup_timer: Timer  # Unused currently


static func _ensure_initialized() -> void:
	if not _initialized:
		_load_persistent_states()
		_setup_auto_cleanup()
		_initialized = true


# === PUBLIC API ===
static func save_component_state(
	component_id: String, state_data: Dictionary, persist: bool = false
) -> void:
	"""Save component state with optional persistence"""
	_ensure_initialized()

	if not FeatureFlags.is_enabled(FeatureFlags.UI_STATE_PERSISTENCE):
		return

	var state_entry = {
		"data": state_data.duplicate(),
		"timestamp": Time.get_unix_time_from_system(),
		"component_type": state_data.get("component_type", "unknown"),
		"persist": persist
	}

	# Store in appropriate location
	if persist:
		_persistent_states[component_id] = state_entry
		_save_persistent_states()
	else:
		_session_states[component_id] = state_entry

	# Also store in main states dictionary for quick access
	_component_states[component_id] = state_entry

	_save_count += 1
	_notify_state_listeners(component_id, "saved", state_data)

	if FeatureFlags.is_enabled(FeatureFlags.DEBUG_COMPONENT_INSPECTOR):
		print("[StateManager] Saved state for: %s (persist: %s)" % [component_id, persist])


static func restore_component_state(component_id: String) -> Dictionary:
	"""Restore component state if available"""
	_ensure_initialized()

	if not FeatureFlags.is_enabled(FeatureFlags.UI_STATE_PERSISTENCE):
		return {}

	var state_entry = _component_states.get(component_id, {})

	if state_entry.is_empty():
		return {}

	# Check if state is too old
	var current_time = Time.get_unix_time_from_system()
	var age = current_time - state_entry.get("timestamp", 0)

	if age > _max_state_age:
		remove_component_state(component_id)
		return {}

	_restore_count += 1
	var restored_data = state_entry.get("data", {})
	_notify_state_listeners(component_id, "restored", restored_data)

	if FeatureFlags.is_enabled(FeatureFlags.DEBUG_COMPONENT_INSPECTOR):
		print("[StateManager] Restored state for: %s (age: %.1fs)" % [component_id, age])

	return restored_data


static func remove_component_state(component_id: String) -> void:
	"""Remove component state"""
	_component_states.erase(component_id)
	_session_states.erase(component_id)

	if _persistent_states.has(component_id):
		_persistent_states.erase(component_id)
		_save_persistent_states()

	_notify_state_listeners(component_id, "removed", {})

	if FeatureFlags.is_enabled(FeatureFlags.DEBUG_COMPONENT_INSPECTOR):
		print("[StateManager] Removed state for: %s" % component_id)


static func has_component_state(component_id: String) -> bool:
	"""Check if component has saved state"""
	_ensure_initialized()
	return _component_states.has(component_id)


static func get_state_age(component_id: String) -> float:
	"""Get age of component state in seconds"""
	var state_entry = _component_states.get(component_id, {})
	if state_entry.is_empty():
		return -1.0

	var current_time = Time.get_unix_time_from_system()
	return current_time - state_entry.get("timestamp", 0)


# === BULK OPERATIONS ===
static func save_multiple_states(states: Dictionary, persist: bool = false) -> void:
	"""Save multiple component states at once"""
	for component_id in states:
		save_component_state(component_id, states[component_id], persist)


static func restore_multiple_states(component_ids: Array) -> Dictionary:
	"""Restore multiple component states"""
	var restored_states = {}
	for component_id in component_ids:
		var state = restore_component_state(component_id)
		if not state.is_empty():
			restored_states[component_id] = state
	return restored_states


static func clear_session_states() -> void:
	"""Clear all session states (non-persistent)"""
	_session_states.clear()

	# Remove session states from main dictionary
	for component_id in _component_states.keys():
		var state_entry = _component_states[component_id]
		if not state_entry.get("persist", false):
			_component_states.erase(component_id)

	print("[StateManager] Cleared session states")


static func clear_all_states() -> void:
	"""Clear all states including persistent ones"""
	_component_states.clear()
	_session_states.clear()
	_persistent_states.clear()
	_save_persistent_states()

	print("[StateManager] Cleared all states")


# === STATE FILTERING ===
static func get_states_by_type(component_type: String) -> Dictionary:
	"""Get all states for a specific component type"""
	var filtered_states = {}

	for component_id in _component_states:
		var state_entry = _component_states[component_id]
		if state_entry.get("component_type", "") == component_type:
			filtered_states[component_id] = state_entry.get("data", {})

	return filtered_states


static func get_recent_states(max_age: float = 300.0) -> Dictionary:
	"""Get states that are newer than max_age seconds"""
	var recent_states = {}
	var current_time = Time.get_unix_time_from_system()

	for component_id in _component_states:
		var state_entry = _component_states[component_id]
		var age = current_time - state_entry.get("timestamp", 0)

		if age <= max_age:
			recent_states[component_id] = state_entry.get("data", {})

	return recent_states


static func get_persistent_states() -> Dictionary:
	"""Get all persistent states"""
	var persistent_data = {}
	for component_id in _persistent_states:
		persistent_data[component_id] = _persistent_states[component_id].get("data", {})
	return persistent_data


# === STATE LISTENERS ===
static func add_state_listener(component_id: String, callback: Callable) -> void:
	"""Add listener for state changes"""
	if not _state_listeners.has(component_id):
		_state_listeners[component_id] = []

	_state_listeners[component_id].append(callback)


static func remove_state_listener(component_id: String, callback: Callable) -> void:
	"""Remove state change listener"""
	if _state_listeners.has(component_id):
		_state_listeners[component_id].erase(callback)


static func _notify_state_listeners(
	component_id: String, event_type: String, state_data: Dictionary
) -> void:
	"""Notify listeners of state changes"""
	if _state_listeners.has(component_id):
		for callback in _state_listeners[component_id]:
			if callback.is_valid():
				callback.call(component_id, event_type, state_data)


# === PERSISTENCE ===
static func _load_persistent_states() -> void:
	"""Load persistent states from disk"""
	if not _persist_to_disk:
		return

	var config = ConfigFile.new()
	if config.load("user://component_states.cfg") == OK:
		var loaded_states = config.get_value("persistence", "states", {})

		# Validate and migrate loaded states
		for component_id in loaded_states:
			var state_entry = loaded_states[component_id]
			if typeof(state_entry) == TYPE_DICTIONARY and state_entry.has("data"):
				_persistent_states[component_id] = state_entry
				_component_states[component_id] = state_entry

		print("[StateManager] Loaded %d persistent states" % _persistent_states.size())


static func _save_persistent_states() -> void:
	"""Save persistent states to disk"""
	if not _persist_to_disk:
		return

	var config = ConfigFile.new()
	config.set_value("persistence", "states", _persistent_states)
	config.set_value("persistence", "saved_at", Time.get_unix_time_from_system())
	config.save("user://component_states.cfg")


# === CLEANUP ===
static func _setup_auto_cleanup() -> void:
	"""Setup automatic cleanup of old states"""
	# Note: In a real implementation, you'd want to create a proper timer
	# For now, we'll rely on manual cleanup calls
	pass


static func cleanup_old_states() -> void:
	"""Clean up old and invalid states"""
	var current_time = Time.get_unix_time_from_system()
	var cleaned_states = []

	# Clean up old session states
	for component_id in _session_states.keys():
		var state_entry = _session_states[component_id]
		var age = current_time - state_entry.get("timestamp", 0)

		if age > _max_state_age:
			_session_states.erase(component_id)
			_component_states.erase(component_id)
			cleaned_states.append(component_id)

	# Limit states per type to prevent memory bloat
	_limit_states_per_type()

	_cleanup_count += cleaned_states.size()

	if cleaned_states.size() > 0:
		print("[StateManager] Cleaned up %d old states" % cleaned_states.size())


static func _limit_states_per_type() -> void:
	"""Limit the number of states per component type"""
	var type_states = {}

	# Group states by type
	for component_id in _component_states:
		var state_entry = _component_states[component_id]
		var component_type = state_entry.get("component_type", "unknown")

		if not type_states.has(component_type):
			type_states[component_type] = []

		type_states[component_type].append(
			{
				"id": component_id,
				"timestamp": state_entry.get("timestamp", 0),
				"persist": state_entry.get("persist", false)
			}
		)

	# Sort by timestamp and remove oldest non-persistent states
	for component_type in type_states:
		var states = type_states[component_type]

		if states.size() > _max_states_per_type:
			# Sort by timestamp (newest first)
			states.sort_custom(func(a, b): return a.timestamp > b.timestamp)

			# Remove excess non-persistent states
			var removed_count = 0
			for i in range(_max_states_per_type, states.size()):
				var state_info = states[i]
				if not state_info.persist:
					remove_component_state(state_info.id)
					removed_count += 1

			if removed_count > 0:
				print(
					(
						"[StateManager] Limited %s states: removed %d oldest"
						% [component_type, removed_count]
					)
				)


# === DEBUGGING AND STATS ===
static func get_state_stats() -> Dictionary:
	"""Get state management statistics"""
	return {
		"total_states": _component_states.size(),
		"session_states": _session_states.size(),
		"persistent_states": _persistent_states.size(),
		"saves_performed": _save_count,
		"restores_performed": _restore_count,
		"cleanups_performed": _cleanup_count,
		"listeners_registered": _state_listeners.size()
	}


static func print_state_stats() -> void:
	"""Print state management statistics"""
	var stats = get_state_stats()
	print("\n=== COMPONENT STATE STATS ===")
	print("Total states: %d" % stats.total_states)
	print("Session states: %d" % stats.session_states)
	print("Persistent states: %d" % stats.persistent_states)
	print("Saves performed: %d" % stats.saves_performed)
	print("Restores performed: %d" % stats.restores_performed)
	print("Cleanups performed: %d" % stats.cleanups_performed)
	print("Listeners registered: %d" % stats.listeners_registered)
	print("=============================\n")


static func get_component_state_info(component_id: String) -> Dictionary:
	"""Get detailed information about a component's state"""
	var state_entry = _component_states.get(component_id, {})

	if state_entry.is_empty():
		return {"exists": false}

	var current_time = Time.get_unix_time_from_system()
	var age = current_time - state_entry.get("timestamp", 0)

	return {
		"exists": true,
		"component_type": state_entry.get("component_type", "unknown"),
		"age_seconds": age,
		"persistent": state_entry.get("persist", false),
		"data_size": str(state_entry.get("data", {})).length(),
		"timestamp": state_entry.get("timestamp", 0)
	}


static func list_all_component_states() -> Array:
	"""List all component state IDs"""
	return _component_states.keys()


# === UTILITY METHODS ===
static func export_states_to_json() -> String:
	"""Export all states to JSON string (for backup/debugging)"""
	var export_data = {
		"session_states": _session_states,
		"persistent_states": _persistent_states,
		"export_timestamp": Time.get_unix_time_from_system(),
		"version": "1.0"
	}

	return JSON.stringify(export_data)


static func import_states_from_json(json_string: String) -> bool:
	"""Import states from JSON string"""
	var json = JSON.new()
	var parse_result = json.parse(json_string)

	if parse_result != OK:
		push_error("[StateManager] Failed to parse JSON: " + json.get_error_message())
		return false

	var import_data = json.data
	if typeof(import_data) != TYPE_DICTIONARY:
		push_error("[StateManager] Invalid import data format")
		return false

	# Import session states
	if import_data.has("session_states"):
		_session_states = import_data.session_states

	# Import persistent states
	if import_data.has("persistent_states"):
		_persistent_states = import_data.persistent_states
		_save_persistent_states()

	# Rebuild main states dictionary
	_component_states.clear()
	for component_id in _session_states:
		_component_states[component_id] = _session_states[component_id]
	for component_id in _persistent_states:
		_component_states[component_id] = _persistent_states[component_id]

	print("[StateManager] Imported states from JSON")
	return true


# === MIGRATION HELPERS ===
static func migrate_legacy_states() -> void:
	"""Migrate states from legacy systems"""
	# This would be implemented based on existing state storage
	print("[StateManager] Legacy state migration not implemented")


static func backup_current_states() -> void:
	"""Create backup of current states"""
	var backup_data = export_states_to_json()
	var file = FileAccess.open("user://component_states_backup.json", FileAccess.WRITE)
	if file:
		file.store_string(backup_data)
		file.close()
		print("[StateManager] States backed up to component_states_backup.json")


static func restore_from_backup() -> bool:
	"""Restore states from backup"""
	var file = FileAccess.open("user://component_states_backup.json", FileAccess.READ)
	if file:
		var backup_data = file.get_as_text()
		file.close()
		return import_states_from_json(backup_data)
	return false

	var _type_counts = {}
