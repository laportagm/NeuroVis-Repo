class_name EnhancedModelLoader
extends Node

## Enhanced Model Loader with proper initialization and error handling
## Ensures models are properly loaded, scaled, and visible

# Signals

signal model_loading_started(total_models: int)
signal model_loaded(model_name: String, index: int)
signal model_load_failed(model_name: String, error: String)
signal all_models_loaded(successful_count: int, total_count: int)
signal model_initialized(model_name: String, mesh_instance: MeshInstance3D)

# Configuration

const BRAINSTEM_SCALE_FIX = Vector3(1.0, 1.0, 1.0)  # Fix for oversized brainstem
const DEFAULT_MODEL_SCALE = Vector3(10.0, 10.0, 10.0)  # Standard scale for models
const DEFAULT_CAMERA_POSITION = Vector3(20, 15, 20)  # Adjusted for proper model viewing
const MODEL_LOAD_TIMEOUT = 5.0

# Model paths
const MODEL_DEFINITIONS = [
{
"name": "Half_Brain",
"path": "res://assets/models/Half_Brain.glb",
"scale": DEFAULT_MODEL_SCALE,
"position": Vector3.ZERO,
"default_visible": true,
"category": "cortex"
},
{
"name": "Internal_Structures",
"path": "res://assets/models/Internal_Structures.glb",
"scale": DEFAULT_MODEL_SCALE,
"position": Vector3.ZERO,
"default_visible": false,  # Start hidden to avoid overlapping
"category": "subcortical"
},
{
"name": "Brainstem",
"path": "res://assets/models/Brainstem(Solid).glb",
"scale": DEFAULT_MODEL_SCALE,  # Use default scale
"position": Vector3.ZERO,
"default_visible": false,  # Start hidden to avoid overlapping
"category": "brainstem"
}
]

# State tracking

var loaded_models: Dictionary = {}
var loading_progress: int = 0
var total_models: int = 0
var model_parent: Node3D


var model_def = MODEL_DEFINITIONS[i]
_load_single_model(model_def, i)

# Finalize loading
_finalize_loading()


var model_name = model_def.get("name", "Unknown")
var model_resource = load(model_def.path)
var model_instance = model_resource.instantiate()
var meshes_found = 0
var model_name = model_def.get("name", "Unknown")

# Process the node if it's a MeshInstance3D
var mesh = model_node as MeshInstance3D
_setup_mesh_instance(mesh, model_def)
meshes_found += 1
model_initialized.emit(model_name, mesh)

# Recursively process children
var model_name = model_def.get("name", "Unknown")
var material = mesh.get_surface_override_material(i)
var std_mat = material as StandardMaterial3D
# Ensure material is visible
std_mat.transparency = BaseMaterial3D.TRANSPARENCY_DISABLED
std_mat.cull_mode = BaseMaterial3D.CULL_BACK


var successful_count = loaded_models.size()
var model_switcher = get_node_or_null("/root/ModelSwitcherGlobal")
var any_visible = false

var model_data = loaded_models[model_name]
var instance = model_data["instance"]

var first_model = loaded_models.values()[0]
var visible_models = model_switcher.get_visible_models()
var first_model_name = loaded_models.keys()[0]
model_switcher.set_model_visibility(first_model_name, true)
var camera = get_viewport().get_camera_3d()
var model_switcher = get_node_or_null("/root/ModelSwitcherGlobal")
var model_data = loaded_models[model_name]
var instance = model_data["instance"]

var instance = loaded_models[model_name]["instance"]
var model_data = loaded_models[model_name]
var meshes = model_data.get("meshes", [])

func _initialize_model_meshes(model_node: Node, model_def: Dictionary) -> void:
	"""Initialize all MeshInstance3D nodes in the model"""

func initialize(parent_node: Node3D) -> void:
	"""Initialize the model loader with a parent node"""
	model_parent = parent_node
	print("[EnhancedModelLoader] Initialized with parent: ", parent_node.name)


func load_all_models() -> void:
	"""Load all brain models with proper error handling"""
	if not model_parent:
		push_error("[EnhancedModelLoader] Model parent not set!")
		return

		total_models = MODEL_DEFINITIONS.size()
		loading_progress = 0
		loaded_models.clear()

		print("[EnhancedModelLoader] Starting to load %d models..." % total_models)
		model_loading_started.emit(total_models)

		# Clear existing models first
		_clear_existing_models()

		# Load each model
		for i in range(MODEL_DEFINITIONS.size()):
func get_loaded_model_names() -> Array:
	"""Get list of successfully loaded model names"""
	return loaded_models.keys()


func get_model_instance(model_name: String) -> Node3D:
	"""Get the instance of a loaded model"""
	if loaded_models.has(model_name):
		return loaded_models[model_name]["instance"]
		return null


func set_model_visibility(model_name: String, visible: bool) -> void:
	"""Set visibility for a specific model"""
	if loaded_models.has(model_name):
func fix_all_model_scales() -> void:
	"""Apply scale fixes to all loaded models"""
	for model_name in loaded_models:

func _fix_orphaned_code():
	print("[EnhancedModelLoader] Loading model: ", model_name)

	# Load the model resource
func _fix_orphaned_code():
	if not model_resource:
		push_error("[EnhancedModelLoader] Failed to load resource: " + model_def.path)
		model_load_failed.emit(model_name, "Resource not found")
		return

		# Instance the model
func _fix_orphaned_code():
	if not model_instance:
		push_error("[EnhancedModelLoader] Failed to instantiate model: " + model_name)
		model_load_failed.emit(model_name, "Instantiation failed")
		return

		# Set up the model
		model_instance.name = model_name
		model_instance.position = model_def.get("position", Vector3.ZERO)

		# Apply scale fixes
		if model_instance is Node3D:
			model_instance.scale = model_def.get("scale", Vector3.ONE)

			# Set initial visibility based on definition
			model_instance.visible = model_def.get("default_visible", true)

			# Add to parent
			model_parent.add_child(model_instance)

			# Process the model to ensure proper initialization
			_initialize_model_meshes(model_instance, model_def)

			# Track loaded model
			loaded_models[model_name] = {"instance": model_instance, "definition": model_def, "meshes": []}

			# Update progress
			loading_progress += 1
			model_loaded.emit(model_name, index)

			print("[EnhancedModelLoader] Successfully loaded: ", model_name)


func _fix_orphaned_code():
	if model_node is MeshInstance3D:
func _fix_orphaned_code():
	for child in model_node.get_children():
		_initialize_model_meshes(child, model_def)

		if meshes_found > 0:
			print("[EnhancedModelLoader] Initialized %d meshes for %s" % [meshes_found, model_name])


func _fix_orphaned_code():
	if loaded_models.has(model_name):
		loaded_models[model_name]["meshes"].append(mesh)

		# Set up materials if needed
		_setup_mesh_materials(mesh)


func _fix_orphaned_code():
	if material and material is StandardMaterial3D:
func _fix_orphaned_code():
	print(
	(
	"[EnhancedModelLoader] Loading complete: %d/%d models loaded successfully"
	% [successful_count, total_models]
	)
	)

	# Register models with ModelSwitcherGlobal
	_register_models_with_switcher()

	# Ensure at least one model is visible
	_ensure_model_visibility()

	# Set up camera position
	_optimize_camera_position()

	all_models_loaded.emit(successful_count, total_models)


func _fix_orphaned_code():
	if not model_switcher:
		# Fallback to direct visibility control
func _fix_orphaned_code():
	for model_name in loaded_models:
func _fix_orphaned_code():
	if instance and instance.visible:
		any_visible = true
		break

		# If no models are visible, show the first one
		if not any_visible and loaded_models.size() > 0:
func _fix_orphaned_code():
	if first_model["instance"]:
		first_model["instance"].visible = true
		print("[EnhancedModelLoader] Made first model visible")
		return

		# Use ModelSwitcher to check visibility
func _fix_orphaned_code():
	if visible_models.is_empty() and loaded_models.size() > 0:
		# Show the first model
func _fix_orphaned_code():
	print("[EnhancedModelLoader] Made %s visible via ModelSwitcher" % first_model_name)


func _fix_orphaned_code():
	if camera:
		camera.position = DEFAULT_CAMERA_POSITION
		camera.look_at(Vector3.ZERO, Vector3.UP)
		print("[EnhancedModelLoader] Camera position optimized")


func _fix_orphaned_code():
	if not model_switcher:
		push_warning(
		"[EnhancedModelLoader] ModelSwitcherGlobal not found - models won't be registered"
		)
		return

		for model_name in loaded_models:
func _fix_orphaned_code():
	if instance:
		model_switcher.register_model(instance, model_name)
		print("[EnhancedModelLoader] Registered %s with ModelSwitcher" % model_name)


func _fix_orphaned_code():
	if instance:
		instance.visible = visible
		print("[EnhancedModelLoader] Set %s visibility to %s" % [model_name, visible])


func _fix_orphaned_code():
	for mesh in meshes:
		if mesh and "brainstem" in mesh.name.to_lower():
			if mesh.scale.x > 10.0:
				mesh.scale = BRAINSTEM_SCALE_FIX
				print("[EnhancedModelLoader] Fixed scale for: ", mesh.name)

func _clear_existing_models() -> void:
	"""Remove any existing models from the parent"""
	for child in model_parent.get_children():
		if child is MeshInstance3D or child is Node3D:
			print("[EnhancedModelLoader] Removing existing model: ", child.name)
			child.queue_free()


func _load_single_model(model_def: Dictionary, index: int) -> void:
	"""Load a single model with proper initialization"""
func _setup_mesh_instance(mesh: MeshInstance3D, model_def: Dictionary) -> void:
	"""Setup individual mesh instance with proper settings"""
	# Don't override visibility of individual meshes - let parent control it
	# mesh.visible = model_def.get("default_visible", true)

	# Check for abnormal scale and fix if needed
	if mesh.scale.x > 50.0:
		print(
		(
		"[EnhancedModelLoader] Fixing abnormal scale on mesh: %s (was %s)"
		% [mesh.name, mesh.scale]
		)
		)
		mesh.scale = Vector3.ONE  # Reset to normal scale, parent will handle overall scale

		# Store mesh reference
func _setup_mesh_materials(mesh: MeshInstance3D) -> void:
	"""Ensure mesh has proper materials"""
	if not mesh.mesh:
		return

		# Set cast shadows
		mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON

		# Ensure materials are set up
		for i in range(mesh.get_surface_override_material_count()):
func _finalize_loading() -> void:
	"""Finalize the loading process"""
func _ensure_model_visibility() -> void:
	"""Ensure at least one model is visible"""
func _optimize_camera_position() -> void:
	"""Set camera to optimal viewing position"""
func _register_models_with_switcher() -> void:
	"""Register all loaded models with the ModelSwitcherGlobal autoload"""
