## {{SINGLETON_NAME}}.gd
## {{SINGLETON_DESCRIPTION}}
##
## This autoload singleton provides {{FUNCTIONALITY_DESCRIPTION}}
## and is globally accessible throughout the application.
##
## Access via: {{SINGLETON_NAME}}.method_name()
## @autoload: {{SINGLETON_NAME}}

extends Node

# === CONSTANTS ===

signal initialized

## Emitted when critical error occurs
signal error_occurred(error_message: String)

# === CONFIGURATION ===
## Enable debug logging

const SINGLETON_NAME: String = "{{SINGLETON_NAME}}"
const VERSION: String = "1.0.0"

# === SIGNALS ===
## Emitted when the singleton is fully initialized

var debug_mode: bool = OS.is_debug_build()

## Enable performance monitoring
var monitor_performance: bool = false

# === STATE VARIABLES ===
var start_time = Time.get_ticks_msec()

# Load configuration
_load_configuration()

# Initialize subsystems
_initialize_subsystems()

# Setup monitoring if enabled
var setting_prefix = "{{SINGLETON_NAME_LOWER}}"

var setting_path = setting_prefix + "/" + key
var entry = {"value": value, "created_at": Time.get_unix_time_from_system(), "ttl": ttl}

_cache.entries[key] = entry
_cache.current_size += 1

# Check cache size limits
_enforce_cache_limits()


## Retrieve value from cache
var entry = _cache.entries[key]

# Check if expired
var age = Time.get_unix_time_from_system() - entry.created_at
var max_size = _cache.get("max_size", 100)

var oldest_key = ""
var oldest_time = Time.get_unix_time_from_system()

var entry_time = _cache.entries[key].created_at
var full_message = "[" + SINGLETON_NAME + "] " + message

push_error(full_message)
error_occurred.emit(message)


# === LOGGING ===
var info = get_debug_info()

var _is_initialized: bool = false
var _initialization_time: float = 0.0
var _error_count: int = 0

# === DATA STORAGE ===
var _data: Dictionary = {}
var _cache: Dictionary = {}
var _settings: Dictionary = {}


# === LIFECYCLE METHODS ===

func _ready() -> void:
	"""Initialize the singleton on startup"""
	name = SINGLETON_NAME
	_initialize_singleton()


func _exit_tree() -> void:
	"""Clean up singleton resources"""
	_cleanup_singleton()


	# === INITIALIZATION ===
func _initialize_singleton() -> void:
	"""Initialize the singleton with default configuration"""

	_log_debug("Initializing " + SINGLETON_NAME + " singleton...")
func _initialize_subsystems() -> void:
	"""Initialize singleton subsystems"""

	# Initialize data structures
	_data.clear()
	_cache.clear()

	# Setup default data
	_setup_default_data()

	# Initialize cache if enabled
	if _settings.get("cache_enabled", true):
		_initialize_cache()


func _initialize_cache() -> void:
	"""Initialize caching system"""

	_cache = {"max_size": _settings.get("max_cache_size", 100), "current_size": 0, "entries": {}}


func is_initialized() -> bool:
	"""Check if the singleton is fully initialized"""
	return _is_initialized


	## Get singleton version
func get_version() -> String:
	"""Get the singleton version"""
	return VERSION


	## Get initialization time
func get_initialization_time() -> float:
	"""Get the time taken to initialize in seconds"""
	return _initialization_time


	## Get error count
func get_error_count() -> int:
	"""Get the number of errors that have occurred"""
	return _error_count


	# === DATA MANAGEMENT ===
	## Store data with key
func set_data(key: String, value: Variant) -> void:
	"""Store data with the specified key"""

	if key.is_empty():
		_handle_error("Data key cannot be empty")
		return

		_data[key] = value
		_log_debug("Data stored: " + key)


		## Retrieve data by key
func get_data(key: String, default_value: Variant = null) -> Variant:
	"""Retrieve data by key, return default if not found"""

	if key.is_empty():
		_handle_error("Data key cannot be empty")
		return default_value

		return _data.get(key, default_value)


		## Check if data exists
func has_data(key: String) -> bool:
	"""Check if data exists for the specified key"""
	return _data.has(key)


	## Remove data by key
func remove_data(key: String) -> bool:
	"""Remove data by key, return true if existed"""

	if _data.has(key):
		_data.erase(key)
		_log_debug("Data removed: " + key)
		return true

		return false


		## Clear all data
func clear_data() -> void:
	"""Clear all stored data"""
	_data.clear()
	_log_debug("All data cleared")


	# === CACHE MANAGEMENT ===
	## Store value in cache
func cache_set(key: String, value: Variant, ttl: float = 0.0) -> void:
	"""Store value in cache with optional time-to-live"""

	if not _settings.get("cache_enabled", true):
		return

func cache_get(key: String, default_value: Variant = null) -> Variant:
	"""Retrieve value from cache, return default if not found or expired"""

	if not _settings.get("cache_enabled", true):
		return default_value

		if not _cache.entries.has(key):
			return default_value

func cache_clear() -> void:
	"""Clear all cache entries"""
	_cache.entries.clear()
	_cache.current_size = 0
	_log_debug("Cache cleared")


	# === SETTINGS MANAGEMENT ===
	## Get setting value
func get_setting(key: String, default_value: Variant = null) -> Variant:
	"""Get setting value with fallback to default"""
	return _settings.get(key, default_value)


	## Set setting value
func set_setting(key: String, value: Variant) -> void:
	"""Set setting value"""
	_settings[key] = value
	_apply_setting_change(key, value)


	## Apply setting change
func get_debug_info() -> Dictionary:
	"""Get debug information about the singleton"""

	return {
	"name": SINGLETON_NAME,
	"version": VERSION,
	"initialized": _is_initialized,
	"initialization_time": _initialization_time,
	"error_count": _error_count,
	"data_entries": _data.size(),
	"cache_entries": _cache.entries.size() if _cache.has("entries") else 0,
	"settings": _settings.duplicate()
	}


func print_debug_info() -> void:
	"""Print debug information to console"""

func _fix_orphaned_code():
	if monitor_performance:
		_setup_performance_monitoring()

		# Mark as initialized
		_is_initialized = true
		_initialization_time = (Time.get_ticks_msec() - start_time) / 1000.0

		initialized.emit()
		_log_debug(SINGLETON_NAME + " initialized in " + str(_initialization_time) + "s")


func _fix_orphaned_code():
	for key in _settings.keys():
func _fix_orphaned_code():
	if ProjectSettings.has_setting(setting_path):
		_settings[key] = ProjectSettings.get_setting(setting_path)


func _fix_orphaned_code():
	if entry.ttl > 0:
func _fix_orphaned_code():
	if age > entry.ttl:
		_cache.entries.erase(key)
		_cache.current_size -= 1
		return default_value

		return entry.value


		## Clear cache
func _fix_orphaned_code():
	while _cache.current_size > max_size:
		# Remove oldest entry
func _fix_orphaned_code():
	for key in _cache.entries.keys():
func _fix_orphaned_code():
	if entry_time < oldest_time:
		oldest_time = entry_time
		oldest_key = key

		if not oldest_key.is_empty():
			_cache.entries.erase(oldest_key)
			_cache.current_size -= 1


			# === ERROR HANDLING ===
func _fix_orphaned_code():
	print("=== " + SINGLETON_NAME + " DEBUG INFO ===")
	for key in info.keys():
		print("  " + key + ": " + str(info[key]))
		print("==========================")

func _load_configuration() -> void:
	"""Load singleton configuration from settings"""

	# Default settings
	_settings = {
	"debug_mode": OS.is_debug_build(),
	"cache_enabled": true,
	"max_cache_size": 100,
	"auto_save": true
	}

	# Load from project settings if available
	_load_project_settings()

	# Apply loaded settings
	debug_mode = _settings.get("debug_mode", false)


func _load_project_settings() -> void:
	"""Load settings from project configuration"""

func _setup_default_data() -> void:
	"""Setup default data structures"""

	_data = {
	"version": VERSION,
	"created_at": Time.get_unix_time_from_system(),
	"session_id": _generate_session_id()
	}


func _setup_performance_monitoring() -> void:
	"""Setup performance monitoring if enabled"""

	if not monitor_performance:
		return

		# Setup performance tracking
		_log_debug("Performance monitoring enabled")


		# === PUBLIC API ===
		## Check if singleton is initialized
func _apply_setting_change(key: String, value: Variant) -> void:
	"""Apply setting change to singleton behavior"""

	match key:
		"debug_mode":
			debug_mode = value
			"cache_enabled":
				if not value:
					cache_clear()
					"monitor_performance":
						monitor_performance = value


						# === UTILITY METHODS ===
func _generate_session_id() -> String:
	"""Generate unique session identifier"""
	return str(Time.get_unix_time_from_system()) + "_" + str(randi())


func _enforce_cache_limits() -> void:
	"""Enforce cache size limits"""

func _handle_error(message: String) -> void:
	"""Handle error with logging and signal emission"""

	_error_count += 1
func _log_debug(message: String) -> void:
	"""Log debug message if debug mode is enabled"""
	if debug_mode:
		print("[" + SINGLETON_NAME + "] " + message)


func _log_info(message: String) -> void:
	"""Log info message"""
	print("[" + SINGLETON_NAME + "] " + message)


func _log_warning(message: String) -> void:
	"""Log warning message"""
	push_warning("[" + SINGLETON_NAME + "] " + message)


	# === CLEANUP ===
func _cleanup_singleton() -> void:
	"""Clean up singleton resources"""

	# Save data if auto-save is enabled
	if _settings.get("auto_save", true):
		_save_persistent_data()

		# Clear caches
		cache_clear()

		# Clear data
		_data.clear()
		_settings.clear()

		_is_initialized = false
		_log_debug(SINGLETON_NAME + " cleaned up")


func _save_persistent_data() -> void:
	"""Save persistent data to storage"""

	# Override in derived classes to implement specific persistence
	_log_debug("Saving persistent data")


	# === DEBUG METHODS ===
