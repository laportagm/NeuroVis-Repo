## CoreSystemsBootstrap.gd
## Educational systems bootstrap with dependency resolution for NeuroVis
##
## This system manages initialization of core educational systems in the correct order,
## resolving dependencies and providing a central access point.
##
## @tutorial: System initialization for educational platform
## @version: 1.0

class_name CoreSystemsBootstrap
extends Node

# === SIGNALS ===
## Emitted when all systems are fully initialized

signal initialization_complete(duration: float)

## Emitted when a single system is initialized
signal system_initialized(system_name: String)

## Emitted when initialization fails
signal initialization_failed(system_name: String, error: String)

# === CONSTANTS ===
# System dependencies definition

const SYSTEM_DEPENDENCIES = {
	"event_bus": [],
	"app_state": ["event_bus"],
	"service_locator": ["event_bus"],
	"resource_manager": ["event_bus"],
	"accessibility": ["event_bus", "app_state"],
	"visual_feedback": ["accessibility", "event_bus"],
	"multi_selection": ["visual_feedback", "event_bus"],
	"camera_controller": ["event_bus"],
	"model_coordinator": ["resource_manager", "event_bus"],
	"ui_theme_manager": ["accessibility", "app_state"],
	"comparative_panel": ["multi_selection", "event_bus"],
	"knowledge_service": ["event_bus"]
}

# Core systems in initialization order

	var initialized_count = _initialized_systems.size()
	return (float(initialized_count) / float(_initialization_sequence.size())) * 100.0

## Get a list of all initialized systems
## @returns: Array of initialized system names
	var system_name = _initialization_sequence[index]
	
	# Skip if already initialized
	if _initialized_systems.has(system_name):
		_process_next_system(index + 1)
		return
	
	# Check dependencies first
	if not _check_dependencies(system_name):
		# Failed due to dependencies - move to next
		_failed_systems.append(system_name)
		_process_next_system(index + 1)
		return
	
	# Initialize system
	var success = _initialize_system(system_name)
	
	if not success:
		_failed_systems.append(system_name)
	
	# Continue with next system
	_process_next_system(index + 1)

	var dependencies = SYSTEM_DEPENDENCIES[system_name]
	var all_satisfied = true
	
	for dependency in dependencies:
		if not _initialized_systems.has(dependency):
			push_warning("[Bootstrap] Dependency not initialized: %s (required by %s)" % [dependency, system_name])
			all_satisfied = false
	
	return all_satisfied

	var system = _create_system_instance(system_name)
	if not system:
		push_error("[Bootstrap] Failed to create system: %s" % system_name)
		initialization_failed.emit(system_name, "Failed to create system instance")
		return false
	
	# Register system with registry
	_registry.register_system(system_name, system)
	
	# Gather dependencies
	var dependencies = {}
	if SYSTEM_DEPENDENCIES.has(system_name):
		for dependency in SYSTEM_DEPENDENCIES[system_name]:
			if _initialized_systems.has(dependency):
				dependencies[dependency] = _initialized_systems[dependency]
	
	# Initialize the system
	var init_success = true
	if system.has_method("initialize"):
		if dependencies.is_empty():
			init_success = system.initialize()
		else:
			init_success = system.initialize(dependencies)
	
	if init_success:
		_initialized_systems[system_name] = system
		if OS.is_debug_build():
			print("[Bootstrap] Debug: ✓ Successfully initialized %s" % system_name)
		system_initialized.emit(system_name)
		return true
	else:
		push_error("[Bootstrap] System initialization failed: %s" % system_name)
		initialization_failed.emit(system_name, "Initialization method returned false")
		return false

	var script_path = ""
	
	match system_name:
		"event_bus":
			script_path = "res://core/events/EventBus.gd"
		
		"app_state":
			script_path = "res://core/state/AppState.gd"
		
		"service_locator":
			script_path = "res://core/services/ServiceLocator.gd"
		
		"resource_manager":
			script_path = "res://core/resources/ResourceManager.gd"
		
		"accessibility":
			script_path = "res://core/accessibility/AccessibilityManager.gd"
			# Fallback to existing autoload
			if not ResourceLoader.exists(script_path) and Engine.has_singleton("AccessibilityManager"):
				return Engine.get_singleton("AccessibilityManager")
		
		"visual_feedback":
			script_path = "res://core/visualization/EducationalVisualFeedback.gd"
		
		"selection_system":
			# Use factory pattern for selection system
			return _create_selection_system()
		
		"camera_controller":
			script_path = "res://core/interaction/CameraBehaviorController.gd"
		
		"model_coordinator":
			script_path = "res://core/models/ModelRegistry.gd"
		
		"ui_theme_manager":
			script_path = "res://ui/panels/UIThemeManager.gd"
			# Fallback to existing autoload
			if not ResourceLoader.exists(script_path) and Engine.has_singleton("UIThemeManager"):
				return Engine.get_singleton("UIThemeManager")
		
		"educational_panels":
			# Create panel registry
			var panel_registry = Node.new()
			panel_registry.name = "PanelRegistry"
			return panel_registry
		
		"knowledge_service":
			script_path = "res://core/knowledge/KnowledgeService.gd"
			# Fallback to existing autoload
			if not ResourceLoader.exists(script_path) and Engine.has_singleton("KnowledgeService"):
				return Engine.get_singleton("KnowledgeService")
		
		_:
			push_warning("[Bootstrap] Unknown system: %s" % system_name)
			return null
	
	# Load script and create instance
	if ResourceLoader.exists(script_path):
		var script = load(script_path)
		if script:
			var instance = script.new()
			return instance
	
	# Check for existing autoload
	var potential_autoload = _find_autoload_by_name(system_name)
	if potential_autoload:
		return potential_autoload
	
	push_warning("[Bootstrap] Failed to create system '%s': Script not found at %s" % [system_name, script_path])
	return null

	var use_multi_selection = true
	
	# Try loading FeatureFlags
	var feature_flags = preprepreload("res://core/features/FeatureFlags.gd")
	if feature_flags and feature_flags.has_method("is_enabled"):
		if feature_flags.has_method("is_enabled"):
			use_multi_selection = feature_flags.is_enabled("MULTI_SELECTION_SYSTEM")
	
	# Load appropriate script
	var script_path = use_multi_selection ? "res://core/interaction/MultiStructureSelectionManager.gd" : "res://core/interaction/BrainStructureSelectionManager.gd"
	
	if ResourceLoader.exists(script_path):
		var script = load(script_path)
		if script:
			var instance = script.new()
			
			# Configure instance
			if instance.has_method("configure_highlight_colors"):
				instance.configure_highlight_colors(Color(0.0, 1.0, 0.0, 1.0), Color(1.0, 0.7, 0.0, 0.6))
			
			if instance.has_method("set_emission_energy"):
				instance.set_emission_energy(0.5)
			
			return instance
	
	push_warning("[Bootstrap] Failed to create selection system: Script not found at %s" % script_path)
	return null

	var autoload_map = {
		"event_bus": "EventBus",
		"app_state": "AppState",
		"service_locator": "ServiceLocator",
		"resource_manager": "ResourceManager",
		"accessibility": "AccessibilityManager",
		"visual_feedback": "VisualFeedback",
		"ui_theme_manager": "UIThemeManager",
		"knowledge_service": "KnowledgeService"
	}
	
	if autoload_map.has(system_name):
		var autoload_name = autoload_map[system_name]
		if Engine.has_singleton(autoload_name):
			return Engine.get_singleton(autoload_name)
	
	return null

	var duration = (Time.get_ticks_msec() - _start_time) / 1000.0
	
	# Log results
	var success_count = _initialized_systems.size()
	var total_count = _initialization_sequence.size()
	var failed_count = _failed_systems.size()
	
	if OS.is_debug_build():
		print("[Bootstrap] Debug: Initialization completed in %.2f seconds" % duration)
	if OS.is_debug_build():
		print("[Bootstrap] Debug: Systems initialized: %d/%d" % [success_count, total_count])
	
	if failed_count > 0:
		push_error("[Bootstrap] Initialization errors: Failed systems: %s" % _failed_systems)
	
	# Update state
	_initialization_in_progress = false
	_initialization_complete = true
	
	# Notify listeners
	initialization_complete.emit(duration)

var _initialization_sequence = [
	"event_bus",
	"app_state",
	"service_locator",
	"resource_manager",
	"accessibility",
	"ui_theme_manager",
	"visual_feedback",
	"selection_system",
	"camera_controller",
	"model_coordinator",
	"educational_panels",
	"knowledge_service"
]

# === PRIVATE VARIABLES ===
# Initialization tracking
var _initialized_systems: Dictionary = {}
var _initialization_complete: bool = false
var _initialization_in_progress: bool = false
var _failed_systems: Array = []

# Registry reference
var _registry: CoreSystemsRegistry

# Initialization time tracking
var _start_time: int = 0

# === INITIALIZATION ===

func _ready() -> void:
	# Create systems registry if not provided
	if not _registry:
		_registry = CoreSystemsRegistry.new()
		add_child(_registry)
	
	# Start asynchronous initialization
	if not _initialization_in_progress and not _initialization_complete:
		call_deferred("initialize_systems")

# === PUBLIC API ===
## Initialize all core educational systems
## @param registry: Optional registry to use (will create one if not provided)
## @returns: true if initialization was started, false otherwise
func _process_next_system(index: int) -> void:
	"""Process the next system in the initialization sequence"""
	if index >= _initialization_sequence.size():
		_complete_initialization()
		return
	
func _initialize_system(system_name: String) -> bool:
	"""Initialize a specific system"""
	if OS.is_debug_build():
		print("[Bootstrap] Debug: Initializing system %s" % system_name)
	
	# Create system instance

func initialize_systems(registry: CoreSystemsRegistry = null) -> bool:
	"""Initialize all core educational systems in proper order"""
	if _initialization_in_progress:
		push_warning("[Bootstrap] Initialization already in progress")
		return false
	
	if _initialization_complete:
		push_warning("[Bootstrap] Initialization already completed")
		return true
	
	if OS.is_debug_build():
		print("[Bootstrap] Debug: Starting core educational systems initialization")
	_initialization_in_progress = true
	
	# Use provided registry or the one created in _ready
	if registry:
		_registry = registry
	elif not _registry:
		_registry = CoreSystemsRegistry.new()
		add_child(_registry)
	
	# Track start time for performance monitoring
	_start_time = Time.get_ticks_msec()
	
	# Start initialization sequence
	_process_next_system(0)
	return true

## Get an initialized system by name
## @param system_name: Name of the system to retrieve
## @returns: The system instance or null if not found or not initialized
func get_system(system_name: String) -> Node:
	"""Get an educational system by name"""
	if _registry:
		return _registry.get_system(system_name)
	return null

## Check if a specific system is initialized
## @param system_name: Name of the system to check
## @returns: true if the system is initialized, false otherwise
func is_system_initialized(system_name: String) -> bool:
	"""Check if a specific educational system is initialized"""
	return _initialized_systems.has(system_name)

## Check if all systems are fully initialized
## @returns: true if all systems are initialized, false otherwise
func is_initialized() -> bool:
	"""Check if all educational systems are initialized"""
	return _initialization_complete

## Get initialization progress as a percentage
## @returns: Percentage of systems initialized (0-100)
func get_initialization_progress() -> float:
	"""Get educational system initialization progress"""
	if _initialization_sequence.is_empty():
		return 100.0
	
func get_initialized_systems() -> Array:
	"""Get list of initialized educational systems"""
	return _initialized_systems.keys()

## Get a list of systems that failed to initialize
## @returns: Array of failed system names
func get_failed_systems() -> Array:
	"""Get list of educational systems that failed to initialize"""
	return _failed_systems.duplicate()

# === PRIVATE METHODS ===

func _check_dependencies(system_name: String) -> bool:
	"""Check if all dependencies for a system are initialized"""
	if not SYSTEM_DEPENDENCIES.has(system_name):
		return true  # No dependencies defined
	
func _create_system_instance(system_name: String) -> Node:
	"""Create instance of a specific system"""
func _create_selection_system() -> Node:
	"""Create selection system with appropriate configuration"""
	# Check if we should use multi-selection
func _find_autoload_by_name(system_name: String) -> Node:
	"""Try to find an existing autoload for a system"""
func _complete_initialization() -> void:
	"""Complete initialization process"""
	# Calculate duration
