# Feature Flag System for NeuroVis
# Enables safe progressive enhancement and A/B testing
extends Node

# === FEATURE DEFINITIONS ===
# Core UI system flags
const UI_MODULAR_COMPONENTS = "ui_modular_components"
const UI_LEGACY_PANELS = "ui_legacy_panels"
const UI_COMPONENT_POOLING = "ui_component_pooling"
const UI_STATE_PERSISTENCE = "ui_state_persistence"

# Advanced features
const ADVANCED_ANIMATIONS = "advanced_animations"
const GESTURE_SUPPORT = "gesture_support"
const ACCESSIBILITY_ENHANCED = "accessibility_enhanced"
const AI_ASSISTANT_V2 = "ai_assistant_v2"

# Performance features
const PERFORMANCE_MONITORING = "performance_monitoring"
const MEMORY_OPTIMIZATION = "memory_optimization"
const LAZY_LOADING = "lazy_loading"

# Development features
const DEBUG_COMPONENT_INSPECTOR = "debug_component_inspector"
const DEBUG_PERFORMANCE_OVERLAY = "debug_performance_overlay"

# Phase 3: Style Engine & Advanced Interactions
const UI_STYLE_ENGINE = "ui_style_engine"
const UI_ADVANCED_INTERACTIONS = "ui_advanced_interactions"
const UI_GESTURE_RECOGNITION = "ui_gesture_recognition"
const UI_CONTEXT_MENUS = "ui_context_menus"
const UI_SMOOTH_ANIMATIONS = "ui_smooth_animations"
const UI_ACCESSIBILITY_MODE = "ui_accessibility_mode"
const UI_MINIMAL_THEME = "ui_minimal_theme"

# === FEATURE FLAG STORAGE ===
static var _flags: Dictionary = {}
static var _listeners: Dictionary = {}
static var _config_loaded: bool = false

# === INITIALIZATION ===
static func _static_init() -> void:
	_load_default_flags()
	_load_user_config()
	_apply_debug_overrides_if_allowed()

static func _load_default_flags() -> void:
	"""Load default feature flag configuration"""

	# Production defaults (conservative approach)
	_flags = {
		# Core UI - gradual migration
		UI_MODULAR_COMPONENTS: false, # New component system (off by default)
		UI_LEGACY_PANELS: true, # Legacy panels (on during transition)
		UI_COMPONENT_POOLING: false, # Component reuse system
		UI_STATE_PERSISTENCE: false, # State preservation

		# Enhanced features
		ADVANCED_ANIMATIONS: true, # Enhanced animations (stable)
		GESTURE_SUPPORT: false, # Touch/gesture input
		ACCESSIBILITY_ENHANCED: true, # Enhanced a11y features
		AI_ASSISTANT_V2: false, # Next-gen AI assistant

		# Performance features
		PERFORMANCE_MONITORING: false, # Performance tracking
		MEMORY_OPTIMIZATION: true, # Memory management improvements
		LAZY_LOADING: false, # Deferred component loading

		# Development features (auto-detect debug builds)
		DEBUG_COMPONENT_INSPECTOR: OS.is_debug_build(),
		DEBUG_PERFORMANCE_OVERLAY: OS.is_debug_build(),

		# Phase 3: Style Engine & Advanced Interactions
		UI_STYLE_ENGINE: false, # New unified style system
		UI_ADVANCED_INTERACTIONS: false, # Drag & drop, gestures, context menus
		UI_GESTURE_RECOGNITION: false, # Touch gesture support
		UI_CONTEXT_MENUS: false, # Right-click context menus
		UI_SMOOTH_ANIMATIONS: true, # Smooth transitions and micro-interactions
		UI_ACCESSIBILITY_MODE: false, # High contrast accessibility mode
		UI_MINIMAL_THEME: false # Clinical/minimal theme mode
	}

	# Debug overrides moved to separate function

static func _load_user_config() -> void:
	"""Load user-specific feature overrides"""
	var config = ConfigFile.new()

	if config.load("user://feature_flags.cfg") == OK:
		for flag_name in _flags.keys():
			if config.has_section_key("features", flag_name):
				var user_value = config.get_value("features", flag_name)
				_flags[flag_name] = user_value
				print("[FeatureFlags] User override: %s = %s" % [flag_name, user_value])

	_config_loaded = true

static func _apply_debug_overrides_if_allowed() -> void:
	"""Apply debug overrides only if not explicitly disabled"""
	if not OS.is_debug_build():
		return

	# Check if user has disabled debug overrides
	var config = ConfigFile.new()
	if config.load("user://feature_flags.cfg") == OK:
		if config.has_section_key("system", "ignore_debug_overrides"):
			var ignore_overrides = config.get_value("system", "ignore_debug_overrides", false)
			if ignore_overrides:
				print("[FeatureFlags] Debug overrides disabled by user configuration")
				return

	# Apply debug overrides if not disabled
	print("[FeatureFlags] Applying debug build overrides")
	_flags[UI_MODULAR_COMPONENTS] = true # Enable new system in dev
	_flags[UI_COMPONENT_POOLING] = true
	_flags[UI_STATE_PERSISTENCE] = true
	_flags[PERFORMANCE_MONITORING] = true
	# Enable Phase 3 features in development
	_flags[UI_STYLE_ENGINE] = true
	_flags[UI_ADVANCED_INTERACTIONS] = true
	_flags[UI_GESTURE_RECOGNITION] = true
	_flags[UI_CONTEXT_MENUS] = true

# === PUBLIC API ===
static func is_enabled(flag_name: String) -> bool:
	"""Check if a feature flag is enabled"""
	if not _config_loaded:
		_static_init()

	return _flags.get(flag_name, false)

static func enable_feature(flag_name: String, persist: bool = false) -> void:
	"""Enable a feature flag"""
	var old_value = _flags.get(flag_name, false)
	_flags[flag_name] = true

	_notify_listeners(flag_name, old_value, true)

	if persist:
		_save_user_override(flag_name, true)

	print("[FeatureFlags] Enabled: %s" % flag_name)

static func disable_feature(flag_name: String, persist: bool = false) -> void:
	"""Disable a feature flag"""
	var old_value = _flags.get(flag_name, true)
	_flags[flag_name] = false

	_notify_listeners(flag_name, old_value, false)

	if persist:
		_save_user_override(flag_name, false)

	print("[FeatureFlags] Disabled: %s" % flag_name)

static func toggle_feature(flag_name: String, persist: bool = false) -> bool:
	"""Toggle a feature flag and return new state"""
	var current_state = is_enabled(flag_name)
	var new_state = not current_state

	if new_state:
		enable_feature(flag_name, persist)
	else:
		disable_feature(flag_name, persist)

	return new_state

static func get_all_flags() -> Dictionary:
	"""Get all feature flags (for debugging/admin interfaces)"""
	if not _config_loaded:
		_static_init()

	return _flags.duplicate()

static func get_flag_status(flag_name: String) -> Dictionary:
	"""Get detailed flag status"""
	return {
		"name": flag_name,
		"enabled": is_enabled(flag_name),
		"source": _get_flag_source(flag_name),
		"description": _get_flag_description(flag_name)
	}

# === LISTENER SYSTEM ===
static func add_listener(flag_name: String, callback: Callable) -> void:
	"""Add listener for feature flag changes"""
	if not _listeners.has(flag_name):
		_listeners[flag_name] = []

	_listeners[flag_name].append(callback)

static func remove_listener(flag_name: String, callback: Callable) -> void:
	"""Remove listener for feature flag changes"""
	if _listeners.has(flag_name):
		_listeners[flag_name].erase(callback)

static func _notify_listeners(flag_name: String, old_value: bool, new_value: bool) -> void:
	"""Notify all listeners of flag change"""
	if _listeners.has(flag_name):
		for callback in _listeners[flag_name]:
			if callback.is_valid():
				callback.call(flag_name, old_value, new_value)

# === UTILITY METHODS ===
static func _save_user_override(flag_name: String, value: bool) -> void:
	"""Save user override to config file"""
	var config = ConfigFile.new()
	config.load("user://feature_flags.cfg") # Load existing or create new

	config.set_value("features", flag_name, value)
	config.save("user://feature_flags.cfg")

static func _get_flag_source(flag_name: String) -> String:
	"""Determine source of flag value (default, user, etc.)"""
	var config = ConfigFile.new()
	if config.load("user://feature_flags.cfg") == OK:
		if config.has_section_key("features", flag_name):
			return "user_override"

	if OS.is_debug_build():
		return "debug_default"

	return "production_default"

static func _get_flag_description(flag_name: String) -> String:
	"""Get human-readable description of flag"""
	var descriptions = {
		UI_MODULAR_COMPONENTS: "New component-based UI system",
		UI_LEGACY_PANELS: "Legacy panel system (for compatibility)",
		UI_COMPONENT_POOLING: "Component reuse and memory optimization",
		UI_STATE_PERSISTENCE: "Preserve component state between interactions",
		ADVANCED_ANIMATIONS: "Enhanced animations and transitions",
		GESTURE_SUPPORT: "Touch and gesture input support",
		ACCESSIBILITY_ENHANCED: "Enhanced accessibility features",
		AI_ASSISTANT_V2: "Next-generation AI assistant",
		PERFORMANCE_MONITORING: "Real-time performance monitoring",
		MEMORY_OPTIMIZATION: "Memory management improvements",
		LAZY_LOADING: "Deferred component loading",
		DEBUG_COMPONENT_INSPECTOR: "Developer component inspection tools",
		DEBUG_PERFORMANCE_OVERLAY: "Developer performance overlay"
	}

	return descriptions.get(flag_name, "No description available")

# === MIGRATION HELPERS ===
static func begin_migration(from_flag: String, to_flag: String, rollback_capable: bool = true) -> void:
	"""Begin migration from one system to another"""
	print("[FeatureFlags] Beginning migration: %s → %s" % [from_flag, to_flag])

	# Enable new system
	enable_feature(to_flag)

	# Keep old system as fallback if rollback capable
	if rollback_capable:
		print("[FeatureFlags] Keeping %s as fallback" % from_flag)
	else:
		disable_feature(from_flag)

static func complete_migration(from_flag: String, _to_flag: String) -> void:
	"""Complete migration by disabling old system"""
	print("[FeatureFlags] Completing migration: disabling %s" % from_flag)
	disable_feature(from_flag)

static func rollback_migration(from_flag: String, to_flag: String) -> void:
	"""Rollback to previous system"""
	print("[FeatureFlags] Rolling back migration: %s ← %s" % [from_flag, to_flag])
	enable_feature(from_flag)
	disable_feature(to_flag)

# === CORE DEVELOPMENT MODE ===
static func is_core_development_mode() -> bool:
	"""Check if core development mode is enabled"""
	# Check environment variable first
	if OS.has_environment("NEUROVIS_CORE_DEV"):
		return OS.get_environment("NEUROVIS_CORE_DEV") == "1"

	# Check user config
	var config = ConfigFile.new()
	if config.load("user://feature_flags.cfg") == OK:
		if config.has_section_key("system", "core_development_mode"):
			return config.get_value("system", "core_development_mode", false)

	# Default to false
	return false

static func enable_core_development_mode() -> void:
	"""Enable core development mode - simplifies systems for architecture work"""
	print("[FeatureFlags] Enabling Core Development Mode...")

	# Save to config
	var config = ConfigFile.new()
	config.load("user://feature_flags.cfg")
	config.set_value("system", "core_development_mode", true)
	config.save("user://feature_flags.cfg")

	# Apply core development preset
	apply_preset("core_development")

	print("[FeatureFlags] Core Development Mode ENABLED")

static func disable_core_development_mode() -> void:
	"""Disable core development mode - restores full functionality"""
	print("[FeatureFlags] Disabling Core Development Mode...")

	# Save to config
	var config = ConfigFile.new()
	config.load("user://feature_flags.cfg")
	config.set_value("system", "core_development_mode", false)
	config.save("user://feature_flags.cfg")

	# Apply production preset
	apply_preset("production")

	print("[FeatureFlags] Core Development Mode DISABLED")

# === DEBUG UTILITIES ===
static func print_flag_status() -> void:
	"""Print all flag statuses (for debugging)"""
	print("\n=== FEATURE FLAGS STATUS ===")

	if is_core_development_mode():
		print("🔧 CORE DEVELOPMENT MODE ACTIVE 🔧")

	for flag_name in _flags.keys():
		var status = get_flag_status(flag_name)
		var enabled_text = "✓" if status.enabled else "✗"
		print("%s %s (%s)" % [enabled_text, flag_name, status.source])

	print("============================\n")

static func reset_to_defaults() -> void:
	"""Reset all flags to default values (for testing)"""
	_load_default_flags()
	print("[FeatureFlags] Reset to default values")

# === PRESETS ===
static func apply_preset(preset_name: String) -> void:
	"""Apply predefined flag presets"""
	match preset_name:
		"development":
			_apply_development_preset()
		"production":
			_apply_production_preset()
		"migration_test":
			_apply_migration_test_preset()
		"performance_test":
			_apply_performance_test_preset()
		"core_development":
			_apply_core_development_preset()
		_:
			push_warning("[FeatureFlags] Unknown preset: " + preset_name)

static func _apply_development_preset() -> void:
	"""Enable all development features"""
	enable_feature(UI_MODULAR_COMPONENTS)
	enable_feature(UI_COMPONENT_POOLING)
	enable_feature(UI_STATE_PERSISTENCE)
	enable_feature(DEBUG_COMPONENT_INSPECTOR)
	enable_feature(DEBUG_PERFORMANCE_OVERLAY)
	enable_feature(PERFORMANCE_MONITORING)

static func _apply_production_preset() -> void:
	"""Conservative production settings"""
	disable_feature(UI_MODULAR_COMPONENTS)
	enable_feature(UI_LEGACY_PANELS)
	disable_feature(DEBUG_COMPONENT_INSPECTOR)
	disable_feature(DEBUG_PERFORMANCE_OVERLAY)

static func _apply_migration_test_preset() -> void:
	"""Settings for testing migration"""
	enable_feature(UI_MODULAR_COMPONENTS)
	enable_feature(UI_LEGACY_PANELS) # Keep both for comparison
	enable_feature(UI_STATE_PERSISTENCE)
	enable_feature(PERFORMANCE_MONITORING)

static func _apply_performance_test_preset() -> void:
	"""Settings for performance testing"""
	enable_feature(UI_COMPONENT_POOLING)
	enable_feature(MEMORY_OPTIMIZATION)
	enable_feature(LAZY_LOADING)
	enable_feature(PERFORMANCE_MONITORING)

static func _apply_core_development_preset() -> void:
	"""Core development mode - minimal features for architecture work"""
	# Disable all complex UI features
	disable_feature(UI_MODULAR_COMPONENTS)
	disable_feature(UI_COMPONENT_POOLING)
	disable_feature(UI_STATE_PERSISTENCE)
	disable_feature(UI_STYLE_ENGINE)
	disable_feature(UI_ADVANCED_INTERACTIONS)
	disable_feature(UI_GESTURE_RECOGNITION)
	disable_feature(UI_CONTEXT_MENUS)
	disable_feature(AI_ASSISTANT_V2)
	disable_feature(LAZY_LOADING)

	# Keep only essential features
	enable_feature(UI_LEGACY_PANELS)
	enable_feature(ADVANCED_ANIMATIONS)
	enable_feature(ACCESSIBILITY_ENHANCED)
	enable_feature(MEMORY_OPTIMIZATION)

	# Enable debugging tools
	enable_feature(DEBUG_COMPONENT_INSPECTOR)
	enable_feature(DEBUG_PERFORMANCE_OVERLAY)
	enable_feature(PERFORMANCE_MONITORING)

	print("[FeatureFlags] Core development preset applied")

# Initialize on first access
static var _initialized: bool = false
static func _ensure_initialized() -> void:
	if not _initialized:
		_static_init()
		_initialized = true
