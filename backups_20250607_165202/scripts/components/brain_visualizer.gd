## Handles 3D brain visualization and model management.
##
## BrainVisualizer manages the loading, display, and interaction with 3D brain models.
## It coordinates between brain regions, neurons, and visual highlighting.
##
## @tutorial: https://github.com/project/wiki/brain-visualization

class_name BrainVisualizer
extends Node

# Import ComponentBase

signal component_ready
signal component_error(message: String)

## Emitted when a brain model is successfully loaded
signal model_loaded(model_name: String)

## Emitted when a brain model fails to load
signal model_load_failed(model_name: String, error: String)

## Emitted when all models have finished loading
signal all_models_loaded(model_names: Array)

## Emitted when a brain region is highlighted
signal region_highlighted(region_name: String)

## Emitted when highlighting is cleared
signal highlighting_cleared

# Model management

const ComponentBase = prepreload("res://scripts/components/component_base.gd")

# ComponentBase implementation
const ModelCoordinatorScene = prepreload("res://core/models/ModelRegistry.gd")
const BrainVisualizationCoreScript = prepreload("res://core/systems/BrainVisualizationCore.gd")
const ModelVisibilityManagerScript = prepreload("res://core/models/ModelVisibilityManager.gd")


var is_initialized: bool = false
var component_name: String = "BrainVisualizer"
var model_parent: Node3D
var model_coordinator = null
var loaded_models: Dictionary = {}
var current_model: String = ""

# References from main scene that we'll need
var knowledge_base = null
var neural_net = null
var model_switcher = null

# Preloaded scripts
	var success = _initialize_component()

	if success:
		is_initialized = true
		print("[%s] Component initialized successfully" % component_name)
		component_ready.emit()
	else:
		var error_msg = "[%s] Component initialization failed" % component_name
		push_error(error_msg)
		component_error.emit(error_msg)


func _ready() -> void:
	# Defer initialization to allow scene tree to settle
	call_deferred("initialize")


func _initialize_component() -> bool:
	component_name = "BrainVisualizer"

	# Validate requirements
	if not _validate_requirements():
		return false

	# Initialize core systems
	if not _initialize_visualization_systems():
		return false

	# Initialize model coordinator
	if not _initialize_model_coordinator():
		return false

	return true


func _initialize_visualization_systems() -> bool:
	# Initialize neural network module (for mesh name mapping)
	neural_net = BrainVisualizationCoreScript.new()
	if neural_net == null:
		push_error("[BrainVisualizer] Failed to initialize neural network")
		return false
	add_child(neural_net)

	# Initialize model switcher
	model_switcher = ModelVisibilityManagerScript.new()
	if model_switcher == null:
		push_error("[BrainVisualizer] Failed to initialize model switcher")
		return false
	add_child(model_switcher)

	return true


func _initialize_model_coordinator() -> bool:
	# Initialize model coordinator
	model_coordinator = ModelCoordinatorScene.new()
	if model_coordinator == null:
		push_error("[BrainVisualizer] Failed to initialize model coordinator")
		return false

	add_child(model_coordinator)
	model_coordinator.set_model_parent(model_parent)

	# Connect to ModelCoordinator signals
	if model_coordinator.has_signal("models_loaded"):
		model_coordinator.models_loaded.connect(_on_models_loaded)
	if model_coordinator.has_signal("model_load_failed"):
		model_coordinator.model_load_failed.connect(_on_model_load_failed)

	return true


## Set the parent node for brain models

func initialize() -> void:
	if is_initialized:
		push_warning("[%s] Component already initialized" % component_name)
		return

	print("[%s] Initializing component..." % component_name)

func set_model_parent(parent: Node3D) -> void:
	model_parent = parent
	if is_initialized and model_coordinator:
		model_coordinator.set_model_parent(parent)


## Set the knowledge base reference for anatomical data
func set_knowledge_base(kb) -> void:
	knowledge_base = kb


## Load all brain models
func load_brain_models() -> void:
	if not is_initialized:
		push_error("[BrainVisualizer] Component not initialized")
		return

	if not model_coordinator:
		push_error("[BrainVisualizer] Model coordinator not available")
		return

	print("[BrainVisualizer] Loading brain models...")
	model_coordinator.load_brain_models()


## Load a specific brain model by name
func load_brain_model(model_name: String) -> bool:
	if not is_initialized:
		push_error("[BrainVisualizer] Component not initialized")
		return false

	# For now, models are loaded as a batch
	# TODO: Implement individual model loading
	print("[BrainVisualizer] Individual model loading not yet implemented")
	return false


## Show or hide a specific model
func set_model_visibility(model_name: String, visible: bool) -> void:
	if ModelSwitcherGlobal:
		ModelSwitcherGlobal.set_model_visibility(model_name, visible)


## Toggle visibility of a specific model
func toggle_model_visibility(model_name: String) -> void:
	if ModelSwitcherGlobal:
		ModelSwitcherGlobal.toggle_model_visibility(model_name)


## Get list of loaded model names
func get_loaded_models() -> Array:
	if ModelSwitcherGlobal:
		return ModelSwitcherGlobal.get_model_names()
	return []


## Check if a model is currently visible
func is_model_visible(model_name: String) -> bool:
	if ModelSwitcherGlobal:
		return ModelSwitcherGlobal.is_model_visible(model_name)
	return false


## Highlight a brain region
func highlight_region(region_name: String, color: Color = Color.GREEN) -> void:
	# This will be implemented in conjunction with SelectionManager
	print("[BrainVisualizer] Highlighting region: ", region_name)
	region_highlighted.emit(region_name)


## Clear all highlighting
func clear_highlighting() -> void:
	print("[BrainVisualizer] Clearing highlighting")
	highlighting_cleared.emit()


## Get the neural network mapping module
func get_neural_net():
	return neural_net


## Map a mesh name to a structure ID using neural net
func map_mesh_name_to_structure_id(mesh_name: String) -> String:
	if neural_net and neural_net.has_method("map_mesh_name_to_structure_id"):
		return neural_net.map_mesh_name_to_structure_id(mesh_name)
	return ""


# Signal handlers
func get_status() -> Dictionary:
	return {
		"name": component_name, "initialized": is_initialized, "custom_status": _get_custom_status()
	}


func _validate_requirements() -> bool:
	# Model parent must be set before initialization
	if not is_instance_valid(model_parent):
		push_error("[BrainVisualizer] Model parent not set")
		return false

	return true


func _on_models_loaded(model_names: Array) -> void:
	print("[BrainVisualizer] Models loaded successfully: ", model_names)
	for model_name in model_names:
		loaded_models[model_name] = true
		model_loaded.emit(model_name)
	all_models_loaded.emit(model_names)


func _on_model_load_failed(model_path: String, error: String) -> void:
	print("[BrainVisualizer] ERROR: Failed to load model ", model_path, ": ", error)
	model_load_failed.emit(model_path, error)


func _cleanup_component() -> void:
	# Clean up references
	model_coordinator = null
	neural_net = null
	model_switcher = null
	knowledge_base = null
	loaded_models.clear()


func _get_custom_status() -> Dictionary:
	return {
		"loaded_models": loaded_models.keys(),
		"current_model": current_model,
		"model_parent_valid": is_instance_valid(model_parent)
	}
