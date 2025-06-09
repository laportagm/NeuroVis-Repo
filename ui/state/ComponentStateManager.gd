# Component State Manager - Handles component state persistence and restoration
# Enables seamless component reuse while preserving user context

class_name ComponentStateManager
extends RefCounted

# === DEPENDENCIES ===

const FeatureFlags = preload("res://core/features/FeatureFlags.gd")

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

	var state_entry = {
"data": state_data.duplicate(),
"timestamp": Time.get_unix_time_from_system(),
"component_type": state_data.get("component_type", "unknown"),
"persist": persist
	}

	# Store in appropriate location
	var state_entry_2 = _component_states.get(component_id, {})

	# FIXED: Orphaned code - var current_time = Time.get_unix_time_from_system()
	# FIXED: Orphaned code - var age = current_time - state_entry.get("timestamp", 0)

	# FIXED: Orphaned code - var restored_data = state_entry.get("data", {})
	# ORPHANED REF: _notify_state_listeners(component_id, "restored", restored_data)

	# FIXED: Orphaned code - var state_entry_3 = _component_states.get(component_id, {})
	# FIXED: Orphaned code - var current_time_2 = Time.get_unix_time_from_system()
	# FIXED: Orphaned code - var restored_states = {}
	# FIXED: Orphaned code - var state = restore_component_state(component_id)
	# FIXED: Orphaned code - var state_entry_4 = _component_states[component_id]
	var filtered_states = {}

	# FIXED: Orphaned code - var state_entry_5 = _component_states[component_id]
	var recent_states = {}
	# FIXED: Orphaned code - var current_time_3 = Time.get_unix_time_from_system()

	# FIXED: Orphaned code - var state_entry_6 = _component_states[component_id]
	# ORPHANED REF: var age_2 = current_time - state_entry.get("timestamp", 0)

	# FIXED: Orphaned code - var persistent_data = {}
	# FIXED: Orphaned code - var config = ConfigFile.new()
	# FIXED: Orphaned code - var loaded_states = config.get_value("persistence", "states", {})

# Validate and migrate loaded states
	# ORPHANED REF: var state_entry_7 = loaded_states[component_id]
	var config_2 = ConfigFile.new()
	# ORPHANED REF: config.set_value("persistence", "states", _persistent_states)
	# ORPHANED REF: config.set_value("persistence", "saved_at", Time.get_unix_time_from_system())
	# ORPHANED REF: config.save("user://component_states.cfg")


	# === CLEANUP ===
static func _setup_auto_cleanup() -> void:
	# ORPHANED REF: """Setup automatic cleanup of old states"""
		# Note: In a real implementation, you'd want to create a proper timer
		# For now, we'll rely on manual cleanup calls
	pass


static func cleanup_old_states() -> void:
	# ORPHANED REF: """Clean up old and invalid states"""
	var current_time_4 = Time.get_unix_time_from_system()
	# FIXED: Orphaned code - var cleaned_states = []

# Clean up old session states
	var state_entry_8 = _session_states[component_id]
	# ORPHANED REF: var age_3 = current_time - state_entry.get("timestamp", 0)

	# FIXED: Orphaned code - var type_states = {}

# Group states by type
	var state_entry_9 = _component_states[component_id]
	var component_type = state_entry.get("component_type", "unknown")

	# FIXED: Orphaned code - var states = type_states[component_type]

	var removed_count = 0
	# ORPHANED REF: var state_info = states[i]
	var stats = get_state_stats()
	# FIXED: Orphaned code - var state_entry_10 = _component_states.get(component_id, {})

	# FIXED: Orphaned code - var current_time_5 = Time.get_unix_time_from_system()
	# FIXED: Orphaned code - var age_4 = current_time - state_entry.get("timestamp", 0)

	# FIXED: Orphaned code - var export_data = {
"session_states": _session_states,
"persistent_states": _persistent_states,
"export_timestamp": Time.get_unix_time_from_system(),
"version": "1.0"
	}

	# FIXED: Orphaned code - var json = JSON.new()
	# FIXED: Orphaned code - var parse_result = json.parse(json_string)

	# FIXED: Orphaned code - var import_data = json.data
	var backup_data = export_states_to_json()
	# FIXED: Orphaned code - var file = FileAccess.open("user://component_states_backup.json", FileAccess.WRITE)
	# FIXED: Orphaned code - var file_2 = FileAccess.open("user://component_states_backup.json", FileAccess.READ)
	# FIXED: Orphaned code - var backup_data_2 = file.get_as_text()
	# ORPHANED REF: file.close()

	# FIXED: Orphaned code - var _type_counts = {}

	if not _initialized:
	_load_persistent_states()
	_setup_auto_cleanup()
	_initialized = true


	# === PUBLIC API ===
	static func save_component_state(
component_id: String, state_data: Dictionary, persist: bool = false
	) -> void:
	# ORPHANED REF: """Save component state with optional persistence"""
	_ensure_initialized()

	if not FeatureFlags.is_enabled(FeatureFlags.UI_STATE_PERSISTENCE):
	return

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
	# ORPHANED REF: print("[StateManager] Saved state for: %s (persist: %s)" % [component_id, persist])


static func restore_component_state(component_id: String) -> Dictionary:
	# ORPHANED REF: """Restore component state if available"""
	_ensure_initialized()

	if not FeatureFlags.is_enabled(FeatureFlags.UI_STATE_PERSISTENCE):
	return {}

	if state_entry.is_empty():
	return {}

	# Check if state is too old
	# ORPHANED REF: if age > _max_state_age:
	remove_component_state(component_id)
	return {}

	_restore_count += 1
	if FeatureFlags.is_enabled(FeatureFlags.DEBUG_COMPONENT_INSPECTOR):
	# ORPHANED REF: print("[StateManager] Restored state for: %s (age: %.1fs)" % [component_id, age])

	# ORPHANED REF: return restored_data


static func remove_component_state(component_id: String) -> void:
	# ORPHANED REF: """Remove component state"""
	_component_states.erase(component_id)
	_session_states.erase(component_id)

	if _persistent_states.has(component_id):
	_persistent_states.erase(component_id)
	_save_persistent_states()

	_notify_state_listeners(component_id, "removed", {})

	if FeatureFlags.is_enabled(FeatureFlags.DEBUG_COMPONENT_INSPECTOR):
	# ORPHANED REF: print("[StateManager] Removed state for: %s" % component_id)


static func has_component_state(component_id: String) -> bool:
	# ORPHANED REF: """Check if component has saved state"""
	_ensure_initialized()
	return _component_states.has(component_id)


static func get_state_age(component_id: String) -> float:
	# ORPHANED REF: """Get age of component state in seconds"""
	if state_entry.is_empty():
	return -1.0

	# ORPHANED REF: return current_time - state_entry.get("timestamp", 0)


# === BULK OPERATIONS ===
	# ORPHANED REF: static func save_multiple_states(states: Dictionary, persist: bool = false) -> void:
	# ORPHANED REF: """Save multiple component states at once"""
	# ORPHANED REF: for component_id in states:
	# ORPHANED REF: save_component_state(component_id, states[component_id], persist)


static func restore_multiple_states(component_ids: Array) -> Dictionary:
	# ORPHANED REF: """Restore multiple component states"""
	for component_id in component_ids:
	# ORPHANED REF: if not state.is_empty():
	# ORPHANED REF: restored_states[component_id] = state
	# ORPHANED REF: return restored_states


static func clear_session_states() -> void:
	# ORPHANED REF: """Clear all session states (non-persistent)"""
	_session_states.clear()

		# Remove session states from main dictionary
	for component_id in _component_states.keys():
	if not state_entry.get("persist", false):
	_component_states.erase(component_id)

	# ORPHANED REF: print("[StateManager] Cleared session states")


static func clear_all_states() -> void:
	# ORPHANED REF: """Clear all states including persistent ones"""
	_component_states.clear()
	_session_states.clear()
	_persistent_states.clear()
	_save_persistent_states()

	# ORPHANED REF: print("[StateManager] Cleared all states")


		# === STATE FILTERING ===
static func get_states_by_type(component_type: String) -> Dictionary:
	# ORPHANED REF: """Get all states for a specific component type"""
	for component_id in _component_states:
	if state_entry.get("component_type", "") == component_type:
	filtered_states[component_id] = state_entry.get("data", {})

	return filtered_states


static func get_recent_states(max_age: float = 300.0) -> Dictionary:
	# ORPHANED REF: """Get states that are newer than max_age seconds"""
	for component_id in _component_states:
	# ORPHANED REF: if age <= max_age:
	recent_states[component_id] = state_entry.get("data", {})

	return recent_states


static func get_persistent_states() -> Dictionary:
	# ORPHANED REF: """Get all persistent states"""
	for component_id in _persistent_states:
	# ORPHANED REF: persistent_data[component_id] = _persistent_states[component_id].get("data", {})
	# ORPHANED REF: return persistent_data


	# === STATE LISTENERS ===
static func add_state_listener(component_id: String, callback: Callable) -> void:
	# ORPHANED REF: """Add listener for state changes"""
	if not _state_listeners.has(component_id):
	_state_listeners[component_id] = []

	_state_listeners[component_id].append(callback)


static func remove_state_listener(component_id: String, callback: Callable) -> void:
	# ORPHANED REF: """Remove state change listener"""
	if _state_listeners.has(component_id):
	_state_listeners[component_id].erase(callback)


	static func _notify_state_listeners(
component_id: String, event_type: String, state_data: Dictionary
	) -> void:
	# ORPHANED REF: """Notify listeners of state changes"""
	if _state_listeners.has(component_id):
	for callback in _state_listeners[component_id]:
	if callback.is_valid():
	callback.call(component_id, event_type, state_data)


									# === PERSISTENCE ===
static func _load_persistent_states() -> void:
	# ORPHANED REF: """Load persistent states from disk"""
	if not _persist_to_disk:
	return

	# ORPHANED REF: if config.load("user://component_states.cfg") == OK:
	# ORPHANED REF: for component_id in loaded_states:
	if typeof(state_entry) == TYPE_DICTIONARY and state_entry.has("data"):
	_persistent_states[component_id] = state_entry
	_component_states[component_id] = state_entry

	# ORPHANED REF: print("[StateManager] Loaded %d persistent states" % _persistent_states.size())


static func _save_persistent_states() -> void:
	# ORPHANED REF: """Save persistent states to disk"""
	if not _persist_to_disk:
	return

	for component_id in _session_states.keys():
	# ORPHANED REF: if age > _max_state_age:
	_session_states.erase(component_id)
	_component_states.erase(component_id)
	# ORPHANED REF: cleaned_states.append(component_id)

	# Limit states per type to prevent memory bloat
	_limit_states_per_type()

	# ORPHANED REF: _cleanup_count += cleaned_states.size()

	# ORPHANED REF: if cleaned_states.size() > 0:
	# ORPHANED REF: print("[StateManager] Cleaned up %d old states" % cleaned_states.size())


static func _limit_states_per_type() -> void:
	# ORPHANED REF: """Limit the number of states per component type"""
	for component_id in _component_states:
	# ORPHANED REF: if not type_states.has(component_type):
	# ORPHANED REF: type_states[component_type] = []

	# ORPHANED REF: type_states[component_type].append(
	{
"id": component_id,
"timestamp": state_entry.get("timestamp", 0),
"persist": state_entry.get("persist", false)
	}
	)

	# Sort by timestamp and remove oldest non-persistent states
	# ORPHANED REF: for component_type in type_states:
	# ORPHANED REF: if states.size() > _max_states_per_type:
	# Sort by timestamp (newest first)
	# ORPHANED REF: states.sort_custom(func(a, b): return a.timestamp > b.timestamp)

	# Remove excess non-persistent states
	# ORPHANED REF: for i in range(_max_states_per_type, states.size()):
	if not state_info.persist:
	remove_component_state(state_info.id)
	removed_count += 1

	if removed_count > 0:
	print(
	(
	# ORPHANED REF: "[StateManager] Limited %s states: removed %d oldest"
	% [component_type, removed_count]
	)
	)


		# === DEBUGGING AND STATS ===
static func get_state_stats() -> Dictionary:
	# ORPHANED REF: """Get state management statistics"""
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
	# ORPHANED REF: """Print state management statistics"""
	print("\n=== COMPONENT STATE STATS ===")
	# ORPHANED REF: print("Total states: %d" % stats.total_states)
	# ORPHANED REF: print("Session states: %d" % stats.session_states)
	# ORPHANED REF: print("Persistent states: %d" % stats.persistent_states)
	print("Saves performed: %d" % stats.saves_performed)
	print("Restores performed: %d" % stats.restores_performed)
	print("Cleanups performed: %d" % stats.cleanups_performed)
	print("Listeners registered: %d" % stats.listeners_registered)
	print("=============================\n")


static func get_component_state_info(component_id: String) -> Dictionary:
	# ORPHANED REF: """Get detailed information about a component's state"""
	if state_entry.is_empty():
	return {"exists": false}

	return {
"exists": true,
"component_type": state_entry.get("component_type", "unknown"),
	# ORPHANED REF: "age_seconds": age,
"persistent": state_entry.get("persist", false),
"data_size": str(state_entry.get("data", {})).length(),
"timestamp": state_entry.get("timestamp", 0)
	}


static func list_all_component_states() -> Array:
	# ORPHANED REF: """List all component state IDs"""
	return _component_states.keys()


	# === UTILITY METHODS ===
static func export_states_to_json() -> String:
	# ORPHANED REF: """Export all states to JSON string (for backup/debugging)"""
	# ORPHANED REF: return JSON.stringify(export_data)


static func import_states_from_json(json_string: String) -> bool:
	# ORPHANED REF: """Import states from JSON string"""
	# ORPHANED REF: if parse_result != OK:
	# ORPHANED REF: push_error("[StateManager] Failed to parse JSON: " + json.get_error_message())
	return false

	# ORPHANED REF: if typeof(import_data) != TYPE_DICTIONARY:
	push_error("[StateManager] Invalid import data format")
	return false

	# Import session states
	# ORPHANED REF: if import_data.has("session_states"):
	# ORPHANED REF: _session_states = import_data.session_states

		# Import persistent states
	# ORPHANED REF: if import_data.has("persistent_states"):
	# ORPHANED REF: _persistent_states = import_data.persistent_states
	_save_persistent_states()

			# Rebuild main states dictionary
	_component_states.clear()
	for component_id in _session_states:
	_component_states[component_id] = _session_states[component_id]
	for component_id in _persistent_states:
	_component_states[component_id] = _persistent_states[component_id]

	# ORPHANED REF: print("[StateManager] Imported states from JSON")
	return true


					# === MIGRATION HELPERS ===
static func migrate_legacy_states() -> void:
	# ORPHANED REF: """Migrate states from legacy systems"""
						# This would be implemented based on existing state storage
	# ORPHANED REF: print("[StateManager] Legacy state migration not implemented")


static func backup_current_states() -> void:
	# ORPHANED REF: """Create backup of current states"""
	# ORPHANED REF: if file:
	# ORPHANED REF: file.store_string(backup_data)
	# ORPHANED REF: file.close()
	# ORPHANED REF: print("[StateManager] States backed up to component_states_backup.json")


static func restore_from_backup() -> bool:
	# ORPHANED REF: """Restore states from backup"""
	# ORPHANED REF: if file:
	return import_states_from_json(backup_data)
	return false
