## SystemBootstrap.gd
## Handles system initialization in proper dependency order
## Centralizes startup logic and provides clean separation of concerns

class_name SystemBootstrap
extends Node

# System initialization tracking
signal system_initialized(system_name: String)
signal all_systems_initialized
signal initialization_failed(system_name: String, error: String)

# System initialization tracking
var initialization_complete: bool = false

# System references
var knowledge_base = null
var neural_net = null
var model_switcher = null
var model_coordinator = null
var selection_manager = null
var camera_controller = null


func _ready() -> void:
	print("[BOOTSTRAP] Starting system bootstrap...")
	name = "SystemBootstrap"


# Main bootstrap function
func initialize_all_systems(main_scene: Node) -> bool:
	"""Initialize all systems in proper dependency order"""
	var loading_overlay = _create_loading_overlay(main_scene)

	# Initialize systems in dependency order
	var success = true
	success = success && await _initialize_debug_systems()
	success = success && await _initialize_core_systems(main_scene)
	success = success && await _initialize_model_systems(main_scene)
	success = success && await _initialize_interaction_systems(main_scene)
	success = success && await _initialize_final_systems(main_scene)

	initialization_complete = success
	if success:
		all_systems_initialized.emit()

	return success


## Main initialization function
func _initialize_debug_systems() -> bool:
	"""Initialize debug and monitoring systems first"""
	print("[BOOTSTRAP] Initializing debug systems...")

	if OS.is_debug_build():
		# Initialize resource debugger if available
		var debug_cmd = get_node_or_null("/root/DebugCmd")
		if debug_cmd:
			print("[BOOTSTRAP] Debug systems available")

	return true


func _initialize_core_systems(main_scene: Node) -> bool:
	"""Initialize core business logic systems"""
	print("[BOOTSTRAP] Initializing core systems...")

	# Initialize knowledge base
	if not await _initialize_knowledge_base(main_scene):
		return false

	# Initialize neural network module
	if not await _initialize_neural_net(main_scene):
		return false

	await get_tree().process_frame
	return true


func _initialize_model_systems(main_scene: Node) -> bool:
	"""Initialize model management and coordination systems"""
	print("[BOOTSTRAP] Initializing model systems...")

	# Initialize model switcher
	if not await _initialize_model_switcher(main_scene):
		return false

	# Initialize model coordinator
	if not await _initialize_model_coordinator(main_scene):
		return false

	await get_tree().process_frame
	return true


func _initialize_interaction_systems(main_scene: Node) -> bool:
	"""Initialize interaction and input systems"""
	print("[BOOTSTRAP] Initializing interaction systems...")

	# Initialize selection manager
	if not await _initialize_selection_manager(main_scene):
		return false

	# Initialize camera controller
	if not await _initialize_camera_controller(main_scene):
		return false

	await get_tree().process_frame
	return true


func _initialize_final_systems(main_scene: Node) -> bool:
	"""Initialize final cleanup systems"""
	print("[BOOTSTRAP] Initializing final systems...")

	# Register debug commands if available
	_register_debug_commands()

	# Validate all critical systems
	if not _validate_critical_systems():
		push_error("[BOOTSTRAP] Critical system validation failed")
		return false

	await get_tree().process_frame
	return true


func _initialize_knowledge_base(main_scene: Node) -> bool:
	"""Initialize knowledge base system"""
	knowledge_base = get_node_or_null("/root/KnowledgeService")
	return knowledge_base != null


func _initialize_neural_net(main_scene: Node) -> bool:
	"""Initialize neural network system"""
	# Placeholder for neural network initialization
	return true


# Helper functions for system initialization
func _initialize_model_switcher(main_scene: Node) -> bool:
	"""Initialize model switcher system"""
	model_switcher = get_node_or_null("/root/ModelSwitcherGlobal")
	return model_switcher != null


func _initialize_model_coordinator(main_scene: Node) -> bool:
	"""Initialize model coordinator system"""
	# Placeholder for model coordinator initialization
	return true


func _initialize_selection_manager(main_scene: Node) -> bool:
	"""Initialize selection manager system"""
	# Placeholder for selection manager initialization
	return true


func _initialize_camera_controller(main_scene: Node) -> bool:
	"""Initialize camera controller system"""
	# Placeholder for camera controller initialization
	return true


func _register_debug_commands() -> void:
	"""Register debug commands if available"""
	var debug_cmd = get_node_or_null("/root/DebugCmd")
	if debug_cmd:
		print("[BOOTSTRAP] Debug commands registered")


func _validate_critical_systems() -> bool:
	"""Validate that all critical systems are functional"""
	var critical_systems = ["KnowledgeService", "ModelSwitcherGlobal"]

	for system_name in critical_systems:
		var system_node = get_node_or_null("/root/" + system_name)
		if not system_node:
			push_error("[BOOTSTRAP] Critical system missing: " + system_name)
			return false

	return true


# Helper function to load scripts safely
func _load_script(script_path: String) -> Script:
	"""Load a script resource safely with error handling"""
	if FileAccess.file_exists(script_path):
		return load(script_path)
	else:
		push_error("[SystemBootstrap] Script not found: " + script_path)
		return null


# Helper function to create loading overlay
func _create_loading_overlay(main_scene: Node) -> Control:
	"""Create and configure the loading overlay"""
	var script_path = "res://ui/panels/LoadingOverlay.gd"
	var script_resource = _load_script(script_path)
	if script_resource:
		var loading_overlay = script_resource.new()
		loading_overlay.name = "LoadingOverlay"
		main_scene.add_child(loading_overlay)
		return loading_overlay
	return null


func _exit_tree():
	"""Clean up system references"""
	knowledge_base = null
	neural_net = null
	model_switcher = null
	model_coordinator = null
	selection_manager = null
	camera_controller = null
	initialization_complete = false
