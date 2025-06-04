class_name ModelRegistry
extends Node

## ModelCoordinator handles 3D model loading, setup, and registration
## This component centralizes all model loading logic and integrates with ModelSwitcherGlobal

# Signals
signal models_loaded(model_names: Array)
signal model_load_failed(model_path: String, error: String)

# Configuration
@export var model_definitions: Array[Dictionary] = []
var model_parent: Node3D

# Internal tracking
var loaded_models: Dictionary = {}
var successful_loads: int = 0

func _ready() -> void:
	print("ModelCoordinator: Initialized")

## Set the parent node where models will be instantiated
func set_model_parent(parent: Node3D) -> void:
	model_parent = parent
	print("ModelCoordinator: Model parent set to " + parent.name)

## Add a model definition to be loaded
func add_model_definition(path: String, position: Vector3 = Vector3.ZERO, rotation: Vector3 = Vector3.ZERO, scale: Vector3 = Vector3.ONE) -> void:
	var definition = {
		"path": path,
		"position": position,
		"rotation": rotation,
		"scale": scale
	}
	model_definitions.append(definition)
	print("ModelCoordinator: Added model definition for " + path)

## Load all defined brain models
func load_brain_models() -> void:
	print("ModelCoordinator: Starting to load brain models...")
	
	if not model_parent:
		var error = "Model parent not set. Call set_model_parent() first."
		print("ERROR: " + error)
		model_load_failed.emit("", error)
		return
	
	if model_definitions.is_empty():
		_setup_default_model_definitions()
	
	print("ModelCoordinator: Will attempt to load " + str(model_definitions.size()) + " models")
	
	# Clear existing models
	_clear_existing_models()
	
	# Reset tracking
	successful_loads = 0
	loaded_models.clear()
	var model_names: Array = []
	
	# Load each model
	for model_info in model_definitions:
		var result = _load_single_model(model_info)
		if result.success:
			successful_loads += 1
			model_names.append(result.model_name)
		else:
			model_load_failed.emit(model_info.path, result.error)
	
	print("ModelCoordinator: Successfully loaded " + str(successful_loads) + " of " + str(model_definitions.size()) + " models")
	
	# Emit completion signal
	if successful_loads > 0:
		models_loaded.emit(model_names)
	else:
		model_load_failed.emit("", "No models were successfully loaded")

## Setup default model definitions if none provided
func _setup_default_model_definitions() -> void:
	print("ModelCoordinator: Setting up professional anatomical model definitions")
	
	# Define the default models to load with professional medical standards
	var default_models: Array[Dictionary] = [
		{
			"path": "res://assets/models/Half_Brain.glb",
			"position": Vector3(0, 0, 0),
			"rotation": Vector3(0, 0, 0),  # Let AnatomicalModelManager handle medical orientation
			"scale": Vector3(1.0, 1.0, 1.0),  # Let AnatomicalModelManager handle professional scaling
			"use_professional_loader": true,
			"enable_medical_materials": true,
			"enable_lod": true
		},
		{
			"path": "res://assets/models/Internal_Structures.glb",
			"position": Vector3(0, 0, 0),
			"rotation": Vector3(0, 0, 0),
			"scale": Vector3(1.0, 1.0, 1.0),
			"use_professional_loader": true,
			"enable_medical_materials": true,
			"enable_lod": true
		},
		{
			"path": "res://assets/models/Brainstem(Solid).glb",
			"position": Vector3(0, 0, 0),
			"rotation": Vector3(0, 0, 0),
			"scale": Vector3(1.0, 1.0, 1.0),
			"use_professional_loader": true,
			"enable_medical_materials": true,
			"enable_lod": true
		}
	]
	
	model_definitions = default_models

## Load a single model and return result
func _load_single_model(model_info: Dictionary) -> Dictionary:
	print("ModelCoordinator: Processing model: " + model_info.path)
	
	# Validate file existence
	if not ResourceLoader.exists(model_info.path):
		var error = "Model file not found: " + model_info.path
		print("ERROR: " + error)
		return {"success": false, "error": error}
	
	print("ModelCoordinator: Model file found: " + model_info.path)
	
	# Check if we should use professional loader
	if model_info.get("use_professional_loader", false):
		return _load_professional_model(model_info)
	else:
		return _load_standard_model(model_info)

## Load model using professional AnatomicalModelManager
func _load_professional_model(model_info: Dictionary) -> Dictionary:
	print("ModelCoordinator: Using professional anatomical model loader")
	
	# Create or get AnatomicalModelManager
	var anatomical_manager = _get_or_create_anatomical_manager()
	if not anatomical_manager:
		var error = "Failed to create AnatomicalModelManager"
		print("ERROR: " + error)
		return {"success": false, "error": error}
	
	# Load using professional system
	var model_instance = anatomical_manager.load_anatomical_model(model_info.path, model_parent)
	if not model_instance:
		var error = "Professional model loading failed: " + model_info.path
		print("ERROR: " + error)
		return {"success": false, "error": error}
	
	# Create friendly model name
	var model_name = model_info.path.get_file().replace(".glb", "").replace("(Solid)", "")
	model_instance.name = model_name
	
	print("ModelCoordinator: Professional model loaded successfully")
	_debug_model_structure(model_instance)
	
	# Register with ModelSwitcher
	register_model_with_switcher(model_instance, model_name)
	
	# Track the loaded model
	loaded_models[model_name] = model_instance
	
	print("ModelCoordinator: Professional anatomical model configured: " + model_name)
	return {"success": true, "model_name": model_name, "instance": model_instance}

## Load model using standard system (fallback)
func _load_standard_model(model_info: Dictionary) -> Dictionary:
	print("ModelCoordinator: Using standard model loader")
	
	# Load the scene
	var model_scene = load(model_info.path)
	if not model_scene:
		var error = "Failed to load model scene: " + model_info.path
		print("ERROR: " + error)
		return {"success": false, "error": error}
	
	print("ModelCoordinator: Model scene loaded successfully")
	
	# Instantiate the scene
	var model_instance = model_scene.instantiate()
	if not model_instance:
		var error = "Failed to instantiate model: " + model_info.path
		print("ERROR: " + error)
		return {"success": false, "error": error}
	
	print("ModelCoordinator: Model instantiated with type: " + model_instance.get_class())
	_debug_model_structure(model_instance)
	
	# Apply transform
	model_instance.position = model_info.position
	model_instance.rotation_degrees = model_info.rotation
	model_instance.scale = model_info.scale
	
	# Create friendly model name
	var model_name = model_info.path.get_file().replace(".glb", "").replace("(Solid)", "")
	
	# Add to scene
	model_parent.add_child(model_instance)
	print("ModelCoordinator: Added model to scene: " + model_info.path.get_file())
	
	# Setup collision
	setup_model_collisions(model_instance)
	
	# Register with ModelSwitcher
	register_model_with_switcher(model_instance, model_name)
	
	# Track the loaded model
	loaded_models[model_name] = model_instance
	
	return {"success": true, "model_name": model_name, "instance": model_instance}

## Get or create the AnatomicalModelManager
func _get_or_create_anatomical_manager() -> AnatomicalModelManager:
	var manager = get_node_or_null("AnatomicalModelManager")
	if not manager:
		# Create the manager
		manager = AnatomicalModelManager.new()
		manager.name = "AnatomicalModelManager"
		add_child(manager)
		
		# Configure for medical education
		manager.enable_material_enhancement = true
		manager.enable_lod_system = true
		manager.default_model_scale = 1.0  # Professional scaling will be handled internally
		manager.enable_subsurface_scattering = true
		
		print("ModelCoordinator: Created professional AnatomicalModelManager")
	
	return manager

## Setup collision shapes for all MeshInstance3D nodes in a model
func setup_model_collisions(node: Node) -> void:
	# Process this node if it's a MeshInstance3D
	if node is MeshInstance3D and node.mesh != null:
		_setup_mesh_collision(node)
	
	# Process all children recursively
	for child in node.get_children():
		setup_model_collisions(child)

## Setup collision for a specific MeshInstance3D node
func _setup_mesh_collision(mesh_node: MeshInstance3D) -> void:
	# Check if it already has a StaticBody3D child
	var already_has_collision = false
	for child in mesh_node.get_children():
		if child is StaticBody3D:
			already_has_collision = true
			break
	
	# If no collision body exists, create one
	if not already_has_collision:
		var static_body = StaticBody3D.new()
		mesh_node.add_child(static_body)
		
		# Create collision shape
		var collision_shape = CollisionShape3D.new()
		static_body.add_child(collision_shape)
		
		# Create a shape that matches the mesh
		var shape = mesh_node.mesh.create_trimesh_shape()
		collision_shape.shape = shape
		
		print("ModelCoordinator: Added collision to: " + mesh_node.name)
		
		# Add default material if needed
		_ensure_default_material(mesh_node)

## Ensure a mesh has at least a default material
func _ensure_default_material(mesh_node: MeshInstance3D) -> void:
	var needs_default_material = true
	
	# Check if any surface has a material
	for i in range(mesh_node.mesh.get_surface_count()):
		if mesh_node.mesh.surface_get_material(i) != null:
			needs_default_material = false
			break
	
	if needs_default_material:
		print("ModelCoordinator: Adding default material to: " + mesh_node.name)
		var default_material = StandardMaterial3D.new()
		default_material.albedo_color = Color(0.9, 0.9, 0.9, 1.0)
		default_material.metallic = 0.1
		default_material.roughness = 0.7
		mesh_node.set_surface_override_material(0, default_material)

## Register a model with the global ModelSwitcher
func register_model_with_switcher(model: Node3D, model_name: String) -> void:
	if ModelSwitcherGlobal:
		ModelSwitcherGlobal.register_model(model, model_name)
		print("ModelCoordinator: Registered model '" + model_name + "' with ModelSwitcher")
	else:
		print("WARNING: ModelSwitcherGlobal not available for registration")

## Clear any existing models from the parent
func _clear_existing_models() -> void:
	if not model_parent:
		return
	
	print("ModelCoordinator: Clearing existing models")
	for child in model_parent.get_children():
		model_parent.remove_child(child)
		child.queue_free()

## Debug helper to print model structure
func _debug_model_structure(model_instance: Node) -> void:
	var child_count = model_instance.get_child_count()
	print("ModelCoordinator: Model has " + str(child_count) + " direct children")
	
	for i in range(child_count):
		var child = model_instance.get_child(i)
		print("ModelCoordinator: Child " + str(i) + ": " + child.get_class() + " named '" + child.name + "'")
		
		# If the child is a MeshInstance3D, print its material info
		if child is MeshInstance3D and child.mesh != null:
			var surface_count = child.mesh.get_surface_count()
			print("ModelCoordinator: MeshInstance '" + child.name + "' has " + str(surface_count) + " surfaces")
			
			for s in range(surface_count):
				var material = child.mesh.surface_get_material(s)
				if material:
					print("ModelCoordinator: Surface " + str(s) + " has material of type: " + material.get_class())
				else:
					print("ModelCoordinator: Surface " + str(s) + " has no material")

## Get names of all successfully loaded models
func get_loaded_model_names() -> Array:
	return loaded_models.keys()

## Get a loaded model instance by name
func get_model_instance(model_name: String) -> Node3D:
	return loaded_models.get(model_name, null)

## Check if a specific model is loaded
func is_model_loaded(model_name: String) -> bool:
	return model_name in loaded_models
