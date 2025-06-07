## SystemBootstrap.gd
## Handles system initialization in proper dependency order
## Centralizes startup logic and provides clean separation of concerns

class_name SystemBootstrap
extends Node

# System initialization tracking

signal system_initialized(system_name: String)
signal all_systems_initialized
signal initialization_failed(system_name: String, error: String)


var systems_initialized: Dictionary = {}
# Removed retry logic - systems either work or fail fast
var initialization_complete: bool = false

# System references
var knowledge_base = null
var neural_net = null
var model_switcher = null
var model_coordinator = null
var selection_manager = null
var camera_controller = null

# Signals for system status
var loading_overlay = _create_loading_overlay(main_scene)

# Initialize systems in dependency order
var success = true
# FIXME: Orphaned code - success = success && await _initialize_debug_systems()
# FIXME: Orphaned code - success = success && await _initialize_core_systems(main_scene)
# FIXME: Orphaned code - success = success && await _initialize_model_systems(main_scene)
# FIXME: Orphaned code - success = success && await _initialize_interaction_systems(main_scene)
# FIXME: Orphaned code - success = success && await _initialize_final_systems(main_scene)

var resource_debugger = get_node_or_null("/root/ResourceDebugger")
var resource_tracer = get_node_or_null("/root/ResourceLoadTracer")
var script_path = "res://core/knowledge/AnatomicalKnowledgeDatabase.gd"
var script_resource = _load_script(script_path)
var script_path_2 = "res://core/systems/BrainVisualizationCore.gd"
var script_resource_2 = _load_script(script_path)
var script_path_3 = "res://core/models/ModelVisibilityManager.gd"
var script_resource_3 = _load_script(script_path)
var script_path_4 = "res://core/models/ModelRegistry.gd"
var script_resource_4 = _load_script(script_path)
var brain_parent = main_scene.get_node_or_null("BrainModel")
var script_path_5 = "res://core/interaction/BrainStructureSelectionManager.gd"
var script_resource_5 = _load_script(script_path)
var script_path_6 = "res://core/interaction/CameraBehaviorController.gd"
var script_resource_6 = _load_script(script_path)
var camera = main_scene.get_node_or_null("Camera3D")
var brain_parent_2 = main_scene.get_node_or_null("BrainModel")

var script_resource_7 = load(script_path)
var script_path_7 = "res://ui/panels/LoadingOverlay.gd"
var script_resource_8 = _load_script(script_path)
var loading_overlay_2 = script_resource.new()
# FIXME: Orphaned code - loading_overlay.name = "LoadingOverlay"
main_scene.add_child(loading_overlay)

var loading_state = (
loading_overlay.get_script().get_script_constant_map()["LoadingState"]
)
var critical_systems = ["knowledge_base", "selection_manager", "camera_controller"]

var debug_cmd = get_node_or_null("/root/DebugCmd")
var status = "✓" if systems_initialized[system_name] else "✗"

func _ready() -> void:
	print("[BOOTSTRAP] Starting system bootstrap...")
	name = "SystemBootstrap"


	## Main initialization function
func _initialize_debug_systems() -> bool:
	"""Initialize debug and monitoring systems first"""
	print("[BOOTSTRAP] Initializing debug systems...")

	if OS.is_debug_build():
		# Initialize resource debugger if available
func _initialize_core_systems(main_scene: Node3D) -> bool:
	"""Initialize core business logic systems"""
	print("[BOOTSTRAP] Initializing core systems...")

	# Initialize knowledge base
	if not await _initialize_knowledge_base(main_scene):
		return false

		# Initialize neural network module
		if not await _initialize_neural_net(main_scene):
			return false

			systems_initialized["core_systems"] = true
			await get_tree().process_frame
			return true


			## Model management systems
func _initialize_model_systems(main_scene: Node3D) -> bool:
	"""Initialize model management and coordination systems"""
	print("[BOOTSTRAP] Initializing model systems...")

	# Initialize model switcher
	if not await _initialize_model_switcher(main_scene):
		return false

		# Initialize model coordinator
		if not await _initialize_model_coordinator(main_scene):
			return false

			systems_initialized["model_systems"] = true
			await get_tree().process_frame
			return true


			## Interaction systems (selection, camera)
func _initialize_interaction_systems(main_scene: Node3D) -> bool:
	"""Initialize user interaction systems"""
	print("[BOOTSTRAP] Initializing interaction systems...")

	# Initialize selection manager
	if not await _initialize_selection_manager(main_scene):
		return false

		# Initialize camera controller
		if not await _initialize_camera_controller(main_scene):
			return false

			systems_initialized["interaction_systems"] = true
			await get_tree().process_frame
			return true


			## Final setup and validation
func _initialize_final_systems(main_scene: Node3D) -> bool:
	"""Perform final system setup and validation"""
	print("[BOOTSTRAP] Finalizing system initialization...")

	# Register debug commands if available
	_register_debug_commands()

	# Validate all critical systems
	if not _validate_critical_systems():
		push_error("[BOOTSTRAP] Critical system validation failed")
		return false

		systems_initialized["final_systems"] = true
		await get_tree().process_frame
		return true


		## Individual system initializers
func _initialize_knowledge_base(main_scene: Node3D) -> bool:
	"""Initialize the anatomical knowledge database"""
func _initialize_neural_net(main_scene: Node3D) -> bool:
	"""Initialize the brain visualization core"""
func _initialize_model_switcher(main_scene: Node3D) -> bool:
	"""Initialize the model visibility manager"""
func _initialize_model_coordinator(main_scene: Node3D) -> bool:
	"""Initialize the model coordination system"""
func _initialize_selection_manager(main_scene: Node3D) -> bool:
	"""Initialize the brain structure selection manager"""
func _initialize_camera_controller(main_scene: Node3D) -> bool:
	"""Initialize the camera behavior controller"""
func _exit_tree():
	"""Clean up system references"""
	knowledge_base = null
	neural_net = null
	model_switcher = null
	model_coordinator = null
	selection_manager = null
	camera_controller = null
	systems_initialized.clear()
	initialization_complete = false

func initialize_all_systems(main_scene: Node3D) -> bool:
	"""
	Initialize all systems in proper dependency order
	Returns true if all systems initialized successfully
	"""
	print("[BOOTSTRAP] Beginning system initialization...")

	# Show loading overlay
func get_knowledge_base():
	"""Get the knowledge base system reference"""
	return knowledge_base


func get_neural_net():
	"""Get the neural net system reference"""
	return neural_net


func get_model_switcher():
	"""Get the model switcher system reference"""
	return model_switcher


func get_model_coordinator():
	"""Get the model coordinator system reference"""
	return model_coordinator


func get_selection_manager():
	"""Get the selection manager system reference"""
	return selection_manager


func get_camera_controller():
	"""Get the camera controller system reference"""
	return camera_controller


func is_system_initialized(system_name: String) -> bool:
	"""Check if a specific system is initialized"""
	return systems_initialized.get(system_name, false)


func is_initialization_complete() -> bool:
	"""Check if all systems are initialized"""
	return initialization_complete


	## Cleanup

func _fix_orphaned_code():
	if success:
		initialization_complete = true
		print("[BOOTSTRAP] All systems initialized successfully")
		all_systems_initialized.emit()
		else:
			print("[BOOTSTRAP] System initialization failed")

			# Hide loading overlay
			if loading_overlay:
				loading_overlay.hide_loading()
				await get_tree().create_timer(0.5).timeout
				loading_overlay.queue_free()

				return success


				## Debug systems initialization (highest priority)
func _fix_orphaned_code():
	if resource_debugger and resource_debugger.has_method("initialize"):
		resource_debugger.initialize()
		systems_initialized["ResourceDebugger"] = true
		system_initialized.emit("ResourceDebugger")

		# Initialize resource load tracer
func _fix_orphaned_code():
	if resource_tracer and resource_tracer.has_method("initialize"):
		resource_tracer.initialize()
		if resource_tracer.has_method("diagnose_common_issues"):
			resource_tracer.diagnose_common_issues()
			systems_initialized["ResourceLoadTracer"] = true
			system_initialized.emit("ResourceLoadTracer")

			systems_initialized["debug_systems"] = true
			await get_tree().process_frame
			return true


			## Core systems initialization (knowledge base, neural net)
func _fix_orphaned_code():
	if not script_resource:
		return false

		knowledge_base = script_resource.new()
		if knowledge_base == null:
			push_error("[BOOTSTRAP] Failed to create knowledge base instance")
			initialization_failed.emit("knowledge_base", "Instance creation failed")
			return false

			main_scene.add_child(knowledge_base)
			if knowledge_base.has_method("load_knowledge_base"):
				knowledge_base.load_knowledge_base()

				systems_initialized["knowledge_base"] = true
				system_initialized.emit("knowledge_base")
				print("[BOOTSTRAP] Knowledge base initialized successfully")
				return true


func _fix_orphaned_code():
	if not script_resource:
		return false

		neural_net = script_resource.new()
		if neural_net == null:
			push_error("[BOOTSTRAP] Failed to create neural net instance")
			initialization_failed.emit("neural_net", "Instance creation failed")
			return false

			main_scene.add_child(neural_net)

			systems_initialized["neural_net"] = true
			system_initialized.emit("neural_net")
			print("[BOOTSTRAP] Neural network module initialized successfully")
			return true


func _fix_orphaned_code():
	if not script_resource:
		return false

		model_switcher = script_resource.new()
		if model_switcher == null:
			push_error("[BOOTSTRAP] Failed to create model switcher instance")
			initialization_failed.emit("model_switcher", "Instance creation failed")
			return false

			main_scene.add_child(model_switcher)

			systems_initialized["model_switcher"] = true
			system_initialized.emit("model_switcher")
			print("[BOOTSTRAP] Model switcher initialized successfully")
			return true


func _fix_orphaned_code():
	if not script_resource:
		return false

		model_coordinator = script_resource.new()
		if model_coordinator == null:
			push_error("[BOOTSTRAP] Failed to create model coordinator instance")
			initialization_failed.emit("model_coordinator", "Instance creation failed")
			return false

			main_scene.add_child(model_coordinator)

			# Setup brain model parent if available
func _fix_orphaned_code():
	if brain_parent and model_coordinator.has_method("set_model_parent"):
		model_coordinator.set_model_parent(brain_parent)

		systems_initialized["model_coordinator"] = true
		system_initialized.emit("model_coordinator")
		print("[BOOTSTRAP] Model coordinator initialized successfully")
		return true


func _fix_orphaned_code():
	if not script_resource:
		return false

		selection_manager = script_resource.new()
		if selection_manager == null:
			push_error("[BOOTSTRAP] Failed to create selection manager instance")
			initialization_failed.emit("selection_manager", "Instance creation failed")
			return false

			main_scene.add_child(selection_manager)

			systems_initialized["selection_manager"] = true
			system_initialized.emit("selection_manager")
			print("[BOOTSTRAP] Selection manager initialized successfully")
			return true


func _fix_orphaned_code():
	if not script_resource:
		return false

		camera_controller = script_resource.new()
		if camera_controller == null:
			push_error("[BOOTSTRAP] Failed to create camera controller instance")
			initialization_failed.emit("camera_controller", "Instance creation failed")
			return false

			main_scene.add_child(camera_controller)

			# Initialize with camera and brain model parent
func _fix_orphaned_code():
	if camera and camera_controller.has_method("initialize"):
		camera_controller.initialize(camera, brain_parent)
		else:
			push_warning("[BOOTSTRAP] No camera found for camera controller")

			systems_initialized["camera_controller"] = true
			system_initialized.emit("camera_controller")
			print("[BOOTSTRAP] Camera controller initialized successfully")
			return true


			## Helper functions
func _fix_orphaned_code():
	if not script_resource:
		push_error("[BOOTSTRAP] Script loading failed: Could not load script from " + script_path)
		return null

		return script_resource


func _fix_orphaned_code():
	if not script_resource:
		push_warning(
		"[BOOTSTRAP] UI component missing: LoadingOverlay not available, continuing without loading screen"
		)
		return null

func _fix_orphaned_code():
	if loading_overlay.has_method("show_loading"):
		# Try to get the LoadingState enum, fallback to basic loading
		if loading_overlay.get_script().get_script_constant_map().has("LoadingState"):
func _fix_orphaned_code():
	if loading_state.has("INITIALIZATION"):
		loading_overlay.show_loading(loading_state.INITIALIZATION)
		else:
			loading_overlay.show_loading(0)  # Fallback to first enum value
			else:
				loading_overlay.show_loading(0)  # Fallback

				return loading_overlay


func _fix_orphaned_code():
	for system in critical_systems:
		if not systems_initialized.has(system) or not systems_initialized[system]:
			push_error("[BOOTSTRAP] Critical system not initialized: " + system)
			return false

			return true


func _fix_orphaned_code():
	if debug_cmd:
		debug_cmd.register_command(
		"system_status", _debug_system_status, "Show system initialization status"
		)
		debug_cmd.register_command(
		"reinit_system", _debug_reinit_system, "Reinitialize a specific system"
		)
		print("[BOOTSTRAP] Debug commands registered")


		## Debug command implementations
func _fix_orphaned_code():
	print("  ", status, " ", system_name)


func _load_script(script_path: String):
	"""Load a script resource"""
	if not ResourceLoader.exists(script_path):
		push_error("[BOOTSTRAP] Script loading failed: Script not found at path " + script_path)
		return null

func _create_loading_overlay(main_scene: Node3D):
	"""Create and show loading overlay"""
func _validate_autoload(autoload_name: String) -> bool:
	"""Validate that an autoload exists and is accessible"""
	return Engine.has_singleton(autoload_name) or get_node_or_null("/root/" + autoload_name) != null


func _validate_critical_systems() -> bool:
	"""Validate that all critical systems are properly initialized"""
func _register_debug_commands() -> void:
	"""Register debug commands if debug system is available"""
	if not OS.is_debug_build():
		return

		if not _validate_autoload("DebugCmd"):
			return

func _debug_system_status() -> void:
	"""Show status of all systems"""
	print("=== SYSTEM STATUS ===")
	print("Initialization complete: ", initialization_complete)
	print("Systems:")
	for system_name in systems_initialized.keys():
func _debug_reinit_system(system_name: String = "") -> void:
	"""Reinitialize a specific system (for debugging)"""
	if system_name.is_empty():
		print("Usage: reinit_system <system_name>")
		print("Available systems: ", systems_initialized.keys())
		return

		print("Reinitializing system: ", system_name)
		# Implementation would depend on specific system requirements
		print("System reinitialization not yet implemented")


		## Getters for system references
