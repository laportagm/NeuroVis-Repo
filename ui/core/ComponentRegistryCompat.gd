# ComponentRegistry Compatibility Layer
# Routes ComponentRegistry calls to SimplifiedComponentFactory during core development
# Add this to the top of any file that uses ComponentRegistry

class_name ComponentRegistryCompat
extends RefCounted

# Load the simplified factory
const SimplifiedComponentFactory = preload("res://ui/core/SimplifiedComponentFactory.gd")

# === STATIC INTERFACE (Drop-in replacement for ComponentRegistry) ===
static func create_component(component_type: String, config: Dictionary = {}) -> Control:
	return SimplifiedComponentFactory.create_component(component_type, config)

static func get_or_create(component_id: String, component_type: String, config: Dictionary = {}) -> Control:
	return SimplifiedComponentFactory.get_or_create(component_id, component_type, config)

static func register_factory(component_type: String, factory_function: Callable) -> void:
	SimplifiedComponentFactory.register_factory(component_type, factory_function)

static func release_component(component_id: String) -> void:
	SimplifiedComponentFactory.release_component(component_id)

static func destroy_component(component_id: String) -> void:
	SimplifiedComponentFactory.destroy_component(component_id)

static func get_registry_stats() -> Dictionary:
	return SimplifiedComponentFactory.get_registry_stats()

static func print_registry_stats() -> void:
	SimplifiedComponentFactory.print_registry_stats()

# === MIGRATION HELPERS ===
static func set_legacy_mode(enabled: bool) -> void:
	if enabled:
		print("[ComponentRegistryCompat] Running in simplified mode")
	else:
		print("[ComponentRegistryCompat] Warning: Advanced mode not available in core development")

# === CORE DEVELOPMENT MODE INDICATOR ===
static func is_core_development_mode() -> bool:
	return true

static func get_mode_description() -> String:
	return "Core Development Mode - Simplified Component Creation"
