## SystemIntegrationManager.gd
## Manages transition between legacy and optimized architecture
##
## This system provides a bridge between the original architecture and the
## new optimized scene structure, allowing for incremental migration and
## ensuring educational continuity during transition.
##
## @tutorial: System architecture migration patterns
## @version: 1.0

class_name SystemIntegrationManager
extends Node

# === SIGNALS ===
## Emitted when legacy system has been properly adapted

signal legacy_system_adapted(system_name: String, adapter: Node)

## Emitted when a system has been fully migrated
signal system_migrated(system_name: String)

## Emitted when all migration is complete
signal migration_completed

# === CONSTANTS ===
## Legacy system types that need adaptation

enum LegacySystem {
	SELECTION_MANAGER, CAMERA_CONTROLLER, MODEL_REGISTRY, KNOWLEDGE_SERVICE, INFO_PANEL_FACTORY  # Brain structure selection  # Educational camera behavior  # Brain model management  # Educational content  # Educational UI generation
}

## Migration status tracking
enum MigrationStatus { NOT_STARTED, IN_PROGRESS, COMPLETED, FAILED }  # Migration not yet begun  # Migration is underway  # Migration completed successfully  # Migration encountered errors

# === EXPORTED VARIABLES ===
## Whether to run in compatibility mode (supporting both architectures)

@export var compatibility_mode: bool = true

## Enable detailed migration logging
@export var verbose_logging: bool = true

# === PRIVATE VARIABLES ===
# Track systems and their migration status

	var system_name = LegacySystem.keys()[system_type]
	print("[SystemIntegrationManager] Migrating system: " + system_name)

	# Perform system-specific migration
	var success = false
	match system_type:
		LegacySystem.SELECTION_MANAGER:
			success = _migrate_selection_manager()
		LegacySystem.CAMERA_CONTROLLER:
			success = _migrate_camera_controller()
		LegacySystem.MODEL_REGISTRY:
			success = _migrate_model_registry()
		LegacySystem.KNOWLEDGE_SERVICE:
			success = _migrate_knowledge_service()
		LegacySystem.INFO_PANEL_FACTORY:
			success = _migrate_info_panel_factory()

	# Update status
	if success:
		_system_status[system_type] = MigrationStatus.COMPLETED
		print("[SystemIntegrationManager] Successfully migrated: " + system_name)
		system_migrated.emit(system_name)
	else:
		_system_status[system_type] = MigrationStatus.FAILED
		push_error("[SystemIntegrationManager] Failed to migrate: " + system_name)

	# Check if all systems are migrated
	if _check_all_migrated():
		print("[SystemIntegrationManager] All systems successfully migrated to new architecture")
		migration_completed.emit()

	return success


## Get migration status for a specific system
## @param system_type: The system to check
## @returns: The current migration status
	var adapter_node = Node.new()
	var system_name = LegacySystem.keys()[system_type]
	adapter_node.name = system_name + "Adapter"

	add_child(adapter_node)
	_system_adapters[system_type] = adapter_node

	# Setup system-specific adaptation
	match system_type:
		LegacySystem.SELECTION_MANAGER:
			_setup_selection_adapter(adapter_node)
		LegacySystem.CAMERA_CONTROLLER:
			_setup_camera_adapter(adapter_node)
		LegacySystem.MODEL_REGISTRY:
			_setup_model_adapter(adapter_node)
		LegacySystem.KNOWLEDGE_SERVICE:
			_setup_knowledge_adapter(adapter_node)
		LegacySystem.INFO_PANEL_FACTORY:
			_setup_panel_adapter(adapter_node)

	legacy_system_adapted.emit(system_name, adapter_node)
	print("[SystemIntegrationManager] Created adapter for: " + system_name)


## Setup selection manager adapter
	var legacy_selection = _find_legacy_system("MultiStructureSelectionManager")

	# Find new selection system
	var new_selection = _find_new_system("SelectionSystem/StructureSelector")

	if legacy_selection and new_selection:
		# Connect signals to forward events
		if legacy_selection.has_signal("structure_selected"):
			legacy_selection.structure_selected.connect(
				func(structure_name, mesh):
					if _structure_manager:
						_structure_manager.select_structure(structure_name)
			)

		if verbose_logging:
			print("[SystemIntegrationManager] Connected selection signals between architectures")
	else:
		push_warning(
			"[SystemIntegrationManager] Could not setup selection adapter - components not found"
		)


## Setup camera controller adapter
	var legacy_camera = _find_legacy_system("CameraBehaviorController")

	# Find new camera system
	var new_camera = _find_new_system("InteractionSystem/CameraController")

	if legacy_camera and new_camera:
		# Connect camera methods between systems
		adapter.set_script(prepreload("res://core/systems/adapters/CameraAdapter.gd"))

		if verbose_logging:
			print("[SystemIntegrationManager] Connected camera systems between architectures")
	else:
		push_warning(
			"[SystemIntegrationManager] Could not setup camera adapter - components not found"
		)


## Setup model registry adapter
	var legacy_model = _find_legacy_system("ModelRegistry")

	# Find new model system
	var new_model = _find_new_system("ModelSets")

	if legacy_model and new_model:
		# Connect model loading events
		if legacy_model.has_signal("models_loaded"):
			legacy_model.models_loaded.connect(
				func(model_names):
					if _new_root:
						_new_root.models_loaded.emit(model_names)
			)

		if verbose_logging:
			print("[SystemIntegrationManager] Connected model systems between architectures")
	else:
		push_warning(
			"[SystemIntegrationManager] Could not setup model adapter - components not found"
		)


## Setup knowledge service adapter
	var legacy_factory = _find_legacy_system("InfoPanelFactory")

	if legacy_factory and _new_root:
		# Redirect panel creation to component pool
		adapter.set_script(prepreload("res://core/systems/adapters/PanelAdapter.gd"))
		adapter.root = _new_root

		if verbose_logging:
			print("[SystemIntegrationManager] Connected panel factory to component pool")
	else:
		push_warning(
			"[SystemIntegrationManager] Could not setup panel adapter - components not found"
		)


## Find a legacy system by name
	var system = _legacy_root.get_node_or_null(system_name)
	if system:
		return system

	# Try as autoload
	system = _legacy_root.get_node_or_null("/root/" + system_name)
	if system:
		return system

	# Try to find recursively
	return _find_node_recursive(_legacy_root, system_name)


## Find a new system by path
	var systems_path = "SceneManager/MainEducationalScene/Systems/"
	var system = _new_root.get_node_or_null(systems_path + system_path)
	if system:
		return system

	# Try direct path
	return _new_root.get_node_or_null(system_path)


## Find a service in the new architecture
		var result = _find_node_recursive(child, node_name)
		if result:
			return result

	return null


## Migrate selection manager

var _system_status: Dictionary = {}

# Adapter nodes for legacy systems
var _system_adapters: Dictionary = {}

# Reference to legacy and new architecture nodes
var _legacy_root: Node
var _new_root: OptimizedNeuroVisRoot

# Reference to core services
var _scene_manager: SceneManager
var _structure_manager: StructureManager


# === LIFECYCLE METHODS ===

func _ready() -> void:
	print("[SystemIntegrationManager] Initializing")

	# Initialize system status tracking
	for system in LegacySystem.keys():
		_system_status[LegacySystem[system]] = MigrationStatus.NOT_STARTED

	# Find required nodes
	_find_architecture_nodes()

	# Setup adapter layer for compatible components
	if compatibility_mode:
		_setup_compatibility_layer()


# === PUBLIC METHODS ===
## Initialize the integration manager
## @param legacy_root: The root node of the legacy architecture
## @param new_root: The root node of the new optimized architecture

func initialize(legacy_root: Node, new_root: OptimizedNeuroVisRoot) -> bool:
	"""Initialize with reference to both architecture root nodes"""
	if not legacy_root or not new_root:
		push_error("[SystemIntegrationManager] Invalid root nodes provided")
		return false

	_legacy_root = legacy_root
	_new_root = new_root

	# Connect to new services
	_scene_manager = _find_service("SceneManager")
	_structure_manager = _find_service("StructureManager")

	if not _scene_manager or not _structure_manager:
		push_warning("[SystemIntegrationManager] Some required services not found")

	print("[SystemIntegrationManager] Initialized with legacy and new architecture roots")
	return true


## Migrate a specific system to the new architecture
## @param system_type: The system to migrate from LegacySystem enum
## @returns: Whether migration was successful
func migrate_system(system_type: LegacySystem) -> bool:
	"""Migrate a specific educational system to the new architecture"""
	if not _system_status.has(system_type):
		push_error("[SystemIntegrationManager] Invalid system type: " + str(system_type))
		return false

	# Skip if already migrated
	if _system_status[system_type] == MigrationStatus.COMPLETED:
		print(
			(
				"[SystemIntegrationManager] System already migrated: "
				+ LegacySystem.keys()[system_type]
			)
		)
		return true

	# Set status to in-progress
	_system_status[system_type] = MigrationStatus.IN_PROGRESS

func get_migration_status(system_type: LegacySystem) -> MigrationStatus:
	"""Get the current migration status of an educational system"""
	return _system_status.get(system_type, MigrationStatus.NOT_STARTED)


## Check if all systems are migrated
## @returns: True if all systems have been migrated
func are_all_systems_migrated() -> bool:
	"""Check if all educational systems have been migrated"""
	return _check_all_migrated()


## Get adapter for a legacy system
## @param system_type: The legacy system type
## @returns: The adapter node or null
func get_adapter(system_type: LegacySystem) -> Node:
	"""Get adapter node for a legacy educational system"""
	return _system_adapters.get(system_type)


# === PRIVATE METHODS ===
## Find architecture nodes in scene tree

func _find_architecture_nodes() -> void:
	"""Locate both legacy and new architecture nodes"""
	# Try to find optimized root node
	_new_root = get_node_or_null("/root/NeuroVisRoot")

	if not _new_root:
		# Try to find within scene
		_new_root = get_tree().current_scene.get_node_or_null("NeuroVisRoot")

	# Try to find legacy main scene
	_legacy_root = get_node_or_null("/root/MainScene")

	if not _legacy_root:
		# Try to find within scene
		_legacy_root = get_tree().current_scene
		if _legacy_root.name != "MainScene" and _legacy_root.get_node_or_null("BrainModel") == null:
			_legacy_root = _legacy_root.get_node_or_null("MainScene")

	if verbose_logging:
		print("[SystemIntegrationManager] Architecture nodes found:")
		print("  - Legacy root: " + (_legacy_root.name if _legacy_root else "Not found"))
		print("  - New root: " + (_new_root.name if _new_root else "Not found"))


## Setup compatibility layer for both architectures
func _setup_compatibility_layer() -> void:
	"""Create adapters for legacy systems to work with new architecture"""
	if not _legacy_root or not _new_root:
		push_error(
			"[SystemIntegrationManager] Cannot setup compatibility layer - missing architecture roots"
		)
		return

	print("[SystemIntegrationManager] Setting up compatibility layer")

	# Create adapters for each legacy system
	_create_adapter(LegacySystem.SELECTION_MANAGER)
	_create_adapter(LegacySystem.CAMERA_CONTROLLER)
	_create_adapter(LegacySystem.MODEL_REGISTRY)
	_create_adapter(LegacySystem.KNOWLEDGE_SERVICE)
	_create_adapter(LegacySystem.INFO_PANEL_FACTORY)

	print("[SystemIntegrationManager] Compatibility layer established")


## Create an adapter for a legacy system
func _create_adapter(system_type: LegacySystem) -> void:
	"""Create adapter node to bridge legacy and new architectures"""
func _setup_selection_adapter(adapter: Node) -> void:
	"""Connect legacy selection manager to new architecture"""
	# Find legacy selection manager
func _setup_camera_adapter(adapter: Node) -> void:
	"""Connect legacy camera controller to new architecture"""
	# Find legacy camera controller
func _setup_model_adapter(adapter: Node) -> void:
	"""Connect legacy model registry to new architecture"""
	# Find legacy model registry
func _setup_knowledge_adapter(adapter: Node) -> void:
	"""Connect legacy knowledge service to new architecture"""
	# New StructureManager will handle this automatically through KnowledgeService
	if verbose_logging:
		print("[SystemIntegrationManager] Knowledge service compatible through StructureManager")


## Setup panel factory adapter
func _setup_panel_adapter(adapter: Node) -> void:
	"""Connect legacy panel factory to new architecture"""
	# Find legacy panel factory
func _find_legacy_system(system_name: String) -> Node:
	"""Find a legacy system node by name"""
	if not _legacy_root:
		return null

	# Try direct child first
func _find_new_system(system_path: String) -> Node:
	"""Find a system in the new architecture by path"""
	if not _new_root:
		return null

	# Try in systems first
func _find_service(service_name: String) -> Node:
	"""Find a service node in the new architecture"""
	if not _new_root:
		return null

	return _new_root.get_node_or_null("Services/" + service_name)


## Check if all systems have been migrated
func _check_all_migrated() -> bool:
	"""Check if all educational systems have been migrated"""
	for system_type in _system_status:
		if _system_status[system_type] != MigrationStatus.COMPLETED:
			return false
	return true


## Find a node by name recursively
func _find_node_recursive(root: Node, node_name: String) -> Node:
	"""Recursively search for a node by name"""
	if root.name == node_name:
		return root

	for child in root.get_children():
func _migrate_selection_manager() -> bool:
	"""Migrate selection system to new architecture"""
	# This would contain actual migration logic
	# For now, return success
	return true


## Migrate camera controller
func _migrate_camera_controller() -> bool:
	"""Migrate camera controller to new architecture"""
	# This would contain actual migration logic
	# For now, return success
	return true


## Migrate model registry
func _migrate_model_registry() -> bool:
	"""Migrate model registry to new architecture"""
	# This would contain actual migration logic
	# For now, return success
	return true


## Migrate knowledge service
func _migrate_knowledge_service() -> bool:
	"""Migrate knowledge service to new architecture"""
	# This would contain actual migration logic
	# For now, return success
	return true


## Migrate info panel factory
func _migrate_info_panel_factory() -> bool:
	"""Migrate info panel factory to new architecture"""
	# This would contain actual migration logic
	# For now, return success
	return true
