## ModelSystem.gd
## Wrapper system for 3D model loading functionality
## Provides simple interface for loading and managing brain models

class_name ModelSystem
extends Node

# Internal model coordinator reference
var model_coordinator: Node = null

# Current model state
var current_models: Array = []
var models_loaded_successfully: bool = false
var brain_model_parent: Node3D = null

# Signals
signal model_loaded(model_name: String)
signal model_load_failed(error: String)
signal all_models_loaded(model_names: Array)

func _ready() -> void:
	print("[MODEL_SYSTEM] Initializing ModelSystem...")
	name = "ModelSystem"

## Public interface methods

func load_model(path: String) -> bool:
	"""Load a single model from path"""
	if not model_coordinator:
		print("[MODEL_SYSTEM] Warning: No model coordinator available")
		return false
	
	if not ResourceLoader.exists(path):
		var error = "Model file not found: " + path
		print("[MODEL_SYSTEM] Error: ", error)
		model_load_failed.emit(error)
		return false
	
	# Add model definition to coordinator
	if model_coordinator.has_method("add_model_definition"):
		model_coordinator.add_model_definition(path)
		print("[MODEL_SYSTEM] Added model definition: ", path)
	
	# Load the models (this will load all defined models)
	if model_coordinator.has_method("load_brain_models"):
		model_coordinator.load_brain_models()
		return true
	
	return false

func load_default_models() -> bool:
	"""Load the default brain models"""
	if not model_coordinator:
		print("[MODEL_SYSTEM] Warning: No model coordinator available")
		return false
	
	print("[MODEL_SYSTEM] Loading default brain models...")
	
	# The ModelRegistry will set up default models automatically
	if model_coordinator.has_method("load_brain_models"):
		model_coordinator.load_brain_models()
		return true
	
	return false

func get_current_model() -> Node3D:
	"""Get the current model parent node"""
	return brain_model_parent

func get_loaded_models() -> Array:
	"""Get array of currently loaded model names"""
	return current_models

func clear_model() -> void:
	"""Clear all loaded models"""
	if brain_model_parent:
		# Clear all children of the brain model parent
		for child in brain_model_parent.get_children():
			child.queue_free()
		
		current_models.clear()
		models_loaded_successfully = false
		print("[MODEL_SYSTEM] All models cleared")

func get_model_count() -> int:
	"""Get the number of loaded models"""
	return current_models.size()

func is_model_loaded(model_name: String) -> bool:
	"""Check if a specific model is loaded"""
	return model_name in current_models

## Configuration and setup

func initialize_with_model_coordinator(coordinator: Node, brain_parent: Node3D = null) -> void:
	"""Initialize with reference to the model coordinator"""
	if not coordinator:
		print("[MODEL_SYSTEM] Error: Cannot initialize with null model coordinator")
		return
	
	model_coordinator = coordinator
	brain_model_parent = brain_parent
	print("[MODEL_SYSTEM] Initialized with model coordinator")
	
	# Set the brain model parent in the coordinator
	if brain_parent and model_coordinator.has_method("set_model_parent"):
		model_coordinator.set_model_parent(brain_parent)
		print("[MODEL_SYSTEM] Set brain model parent: ", brain_parent.name)
	
	# Connect to model coordinator signals
	if model_coordinator.has_signal("models_loaded"):
		model_coordinator.models_loaded.connect(_on_coordinator_models_loaded)
	if model_coordinator.has_signal("model_load_failed"):
		model_coordinator.model_load_failed.connect(_on_coordinator_model_load_failed)

func set_brain_model_parent(parent: Node3D) -> void:
	"""Set the parent node for brain models"""
	brain_model_parent = parent
	if model_coordinator and model_coordinator.has_method("set_model_parent"):
		model_coordinator.set_model_parent(parent)
		print("[MODEL_SYSTEM] Updated brain model parent: ", parent.name)

## Model management helpers

func add_model_definition(path: String, position: Vector3 = Vector3.ZERO, rotation: Vector3 = Vector3.ZERO, scale: Vector3 = Vector3.ONE) -> void:
	"""Add a model definition for loading"""
	if model_coordinator and model_coordinator.has_method("add_model_definition"):
		model_coordinator.add_model_definition(path, position, rotation, scale)
		print("[MODEL_SYSTEM] Added model definition: ", path)

func get_model_definitions() -> Array:
	"""Get current model definitions from coordinator"""
	if model_coordinator and model_coordinator.has_method("get_model_definitions"):
		return model_coordinator.get_model_definitions()
	return []

## Signal handlers

func _on_coordinator_models_loaded(model_names: Array) -> void:
	"""Handle models loaded from the coordinator"""
	current_models = model_names
	models_loaded_successfully = true
	
	print("[MODEL_SYSTEM] Coordinator reported models loaded: ", model_names)
	
	# Emit individual model loaded signals
	for model_name in model_names:
		model_loaded.emit(model_name)
	
	# Emit all models loaded signal
	all_models_loaded.emit(model_names)

func _on_coordinator_model_load_failed(model_path: String, error: String) -> void:
	"""Handle model load failure from the coordinator"""
	var error_msg = "Model load failed"
	if not model_path.is_empty():
		error_msg += " for " + model_path
	if not error.is_empty():
		error_msg += ": " + error
	
	print("[MODEL_SYSTEM] Coordinator reported model load failed: ", error_msg)
	model_load_failed.emit(error_msg)

## Status and debugging

func get_load_status() -> Dictionary:
	"""Get detailed load status information"""
	return {
		"models_loaded": models_loaded_successfully,
		"model_count": current_models.size(),
		"model_names": current_models,
		"has_coordinator": model_coordinator != null,
		"has_brain_parent": brain_model_parent != null
	}

func print_status() -> void:
	"""Print current status for debugging"""
	print("=== MODEL SYSTEM STATUS ===")
	var status = get_load_status()
	for key in status.keys():
		print("  ", key, ": ", status[key])

## Cleanup

func _exit_tree() -> void:
	"""Clean up when node is removed from tree"""
	if model_coordinator:
		# Disconnect signals
		if model_coordinator.has_signal("models_loaded") and model_coordinator.models_loaded.is_connected(_on_coordinator_models_loaded):
			model_coordinator.models_loaded.disconnect(_on_coordinator_models_loaded)
		if model_coordinator.has_signal("model_load_failed") and model_coordinator.model_load_failed.is_connected(_on_coordinator_model_load_failed):
			model_coordinator.model_load_failed.disconnect(_on_coordinator_model_load_failed)
	
	model_coordinator = null
	brain_model_parent = null
	current_models.clear()
	models_loaded_successfully = false
	
	print("[MODEL_SYSTEM] ModelSystem cleaned up")