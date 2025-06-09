## EnhancedModelLoader.gd
## Progressive model loading system with layer-based visibility for medical education
##
## This enhanced loader provides sophisticated model management for neuroanatomy education,
## including progressive loading feedback, anatomical layer organization, metadata preservation,
## and scale normalization for accurate medical visualization.
##
## Features:
## - Progressive loading with percentage-based feedback
## - Layer-based visibility (cortex, subcortical, brainstem, ventricles)
## - Metadata extraction and preservation for educational content
## - Scale normalization ensuring anatomically accurate proportions
## - Graceful error handling with educational fallbacks
##
## @tutorial: Medical model organization and layer conventions
## @version: 2.0 - Fixed orphaned code and enhanced for medical education

class_name EnhancedModelLoader
extends Node

# ===== SIGNALS =====
signal model_loading_started(total_models: int)
signal model_loaded(model_name: String, index: int)
signal model_load_progress(percent: float, current_model: String)
signal model_load_failed(model_name: String, error: String)
signal all_models_loaded(successful_count: int, total_count: int)
signal model_initialized(model_name: String, mesh_instance: MeshInstance3D)
signal layer_visibility_changed(layer_name: String, visible: bool)
signal metadata_extracted(model_name: String, metadata: Dictionary)

# ===== CONSTANTS =====
# Medical scale normalization
const ANATOMICAL_SCALE: float = 0.12  # 12% of real size for visualization
const BRAINSTEM_SCALE_FIX: Vector3 = Vector3(1.0, 1.0, 1.0)
const DEFAULT_MODEL_SCALE: Vector3 = Vector3(10.0, 10.0, 10.0)
const DEFAULT_CAMERA_POSITION: Vector3 = Vector3(20, 15, 20)
const MODEL_LOAD_TIMEOUT: float = 5.0

# Anatomical layer definitions
const ANATOMICAL_LAYERS: Dictionary = {
	"cortex":
	{
		"display_name": "Cerebral Cortex",
		"color": Color(0.9, 0.8, 0.8, 1.0),
		"default_visible": true,
		"educational_note": "Outer layer responsible for higher cognitive functions"
	},
	"subcortical":
	{
		"display_name": "Subcortical Structures",
		"color": Color(0.8, 0.7, 0.9, 1.0),
		"default_visible": false,
		"educational_note": "Deep brain structures including basal ganglia and limbic system"
	},
	"brainstem":
	{
		"display_name": "Brainstem",
		"color": Color(0.7, 0.8, 0.7, 1.0),
		"default_visible": false,
		"educational_note": "Controls vital functions: breathing, heart rate, consciousness"
	},
	"ventricles":
	{
		"display_name": "Ventricular System",
		"color": Color(0.6, 0.8, 1.0, 0.5),
		"default_visible": false,
		"educational_note": "CSF-filled spaces providing cushioning and nutrient transport"
	},
	"vascular":
	{
		"display_name": "Vascular System",
		"color": Color(1.0, 0.4, 0.4, 0.8),
		"default_visible": false,
		"educational_note": "Blood vessels supplying oxygen and nutrients to brain tissue"
	}
}

# Model definitions with medical metadata
const MODEL_DEFINITIONS: Array[Dictionary] = [
	{
		"name": "Half_Brain",
		"path": "res://assets/models/Half_Brain.glb",
		"scale": DEFAULT_MODEL_SCALE,
		"position": Vector3.ZERO,
		"default_visible": true,
		"layer": "cortex",
		"metadata":
		{
			"structures": ["frontal_lobe", "parietal_lobe", "temporal_lobe", "occipital_lobe"],
			"clinical_relevance": "Shows major cortical divisions and sulci patterns",
			"teaching_order": 1
		}
	},
	{
		"name": "Internal_Structures",
		"path": "res://assets/models/Internal_Structures.glb",
		"scale": DEFAULT_MODEL_SCALE,
		"position": Vector3.ZERO,
		"default_visible": false,
		"layer": "subcortical",
		"metadata":
		{
			"structures": ["hippocampus", "amygdala", "thalamus", "basal_ganglia"],
			"clinical_relevance": "Critical for memory, emotion, and movement disorders",
			"teaching_order": 2
		}
	},
	{
		"name": "Brainstem",
		"path": "res://assets/models/Brainstem(Solid).glb",
		"scale": DEFAULT_MODEL_SCALE,
		"position": Vector3.ZERO,
		"default_visible": false,
		"layer": "brainstem",
		"metadata":
		{
			"structures": ["midbrain", "pons", "medulla_oblongata"],
			"clinical_relevance": "Vital for life support functions and cranial nerves",
			"teaching_order": 3
		}
	}
]

# ===== VARIABLES =====
# State tracking
var loaded_models: Dictionary = {}  # model_name -> {instance, definition, meshes, metadata}
var loading_progress: float = 0.0
var current_loading_model: String = ""
var total_models: int = 0
var models_loaded_count: int = 0
var model_parent: Node3D

# Layer management
var layer_visibility: Dictionary = {}  # layer_name -> bool
var layer_models: Dictionary = {}  # layer_name -> Array[model_names]

# Loading state
var is_loading: bool = false
var load_start_time: float = 0.0
var failed_models: Array[String] = []


# ===== LIFECYCLE METHODS =====
func _ready() -> void:
	"""Initialize layer visibility from defaults"""
	for layer_name in ANATOMICAL_LAYERS:
		layer_visibility[layer_name] = ANATOMICAL_LAYERS[layer_name]["default_visible"]
		layer_models[layer_name] = []

	print(
		"[EnhancedModelLoader] Ready with %d anatomical layers defined" % ANATOMICAL_LAYERS.size()
	)


# ===== PUBLIC METHODS =====
func initialize(parent_node: Node3D) -> void:
	"""Initialize the model loader with a parent node"""
	if not parent_node:
		push_error("[EnhancedModelLoader] Parent node cannot be null!")
		return

	model_parent = parent_node
	print("[EnhancedModelLoader] Initialized with parent: %s" % parent_node.name)


func load_all_models() -> void:
	"""Load all brain models with progressive feedback"""
	if not model_parent:
		push_error("[EnhancedModelLoader] Model parent not set! Call initialize() first.")
		return

	if is_loading:
		push_warning("[EnhancedModelLoader] Already loading models!")
		return

	# Initialize loading state
	is_loading = true
	load_start_time = Time.get_ticks_msec()
	total_models = MODEL_DEFINITIONS.size()
	models_loaded_count = 0
	loading_progress = 0.0
	loaded_models.clear()
	failed_models.clear()

	print("[EnhancedModelLoader] Starting progressive load of %d models..." % total_models)
	model_loading_started.emit(total_models)

	# Clear existing models
	_clear_existing_models()

	# Load each model progressively
	for i in range(MODEL_DEFINITIONS.size()):
		var model_def = MODEL_DEFINITIONS[i]
		await _load_single_model_async(model_def, i)

	# Finalize loading
	_finalize_loading()


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
	if not loaded_models.has(model_name):
		push_warning("[EnhancedModelLoader] Model not found: %s" % model_name)
		return

	var instance = loaded_models[model_name]["instance"]
	if instance:
		instance.visible = visible
		print("[EnhancedModelLoader] Set %s visibility to %s" % [model_name, visible])


func set_layer_visibility(layer_name: String, visible: bool) -> void:
	"""Set visibility for all models in an anatomical layer"""
	if not ANATOMICAL_LAYERS.has(layer_name):
		push_warning("[EnhancedModelLoader] Unknown layer: %s" % layer_name)
		return

	layer_visibility[layer_name] = visible

	# Update all models in this layer
	if layer_models.has(layer_name):
		for model_name in layer_models[layer_name]:
			set_model_visibility(model_name, visible)

	layer_visibility_changed.emit(layer_name, visible)
	print("[EnhancedModelLoader] Set layer '%s' visibility to %s" % [layer_name, visible])


func get_layer_visibility(layer_name: String) -> bool:
	"""Get current visibility state of a layer"""
	return layer_visibility.get(layer_name, false)


func get_model_metadata(model_name: String) -> Dictionary:
	"""Get educational metadata for a model"""
	if loaded_models.has(model_name):
		return loaded_models[model_name].get("metadata", {})
	return {}


func get_layer_info(layer_name: String) -> Dictionary:
	"""Get educational information about an anatomical layer"""
	return ANATOMICAL_LAYERS.get(layer_name, {})


func show_teaching_sequence(order: int) -> void:
	"""Show models based on teaching order"""
	for model_name in loaded_models:
		var model_data = loaded_models[model_name]
		var teaching_order = model_data["metadata"].get("teaching_order", 999)
		set_model_visibility(model_name, teaching_order <= order)


func fix_all_model_scales() -> void:
	"""Apply scale normalization to ensure anatomical accuracy"""
	for model_name in loaded_models:
		var model_data = loaded_models[model_name]
		var instance = model_data["instance"]
		if instance:
			_normalize_model_scale(instance, model_data["definition"])


# ===== PRIVATE METHODS =====
func _load_single_model_async(model_def: Dictionary, index: int) -> void:
	"""Load a single model with progressive feedback"""
	var model_name = model_def.get("name", "Unknown")
	current_loading_model = model_name

	print("[EnhancedModelLoader] Loading model %d/%d: %s" % [index + 1, total_models, model_name])

	# Update progress
	loading_progress = float(index) / float(total_models) * 100.0
	model_load_progress.emit(loading_progress, model_name)

	# Load the model resource
	var model_resource = load(model_def.path)
	if not model_resource:
		push_error("[EnhancedModelLoader] Failed to load resource: %s" % model_def.path)
		model_load_failed.emit(model_name, "Resource not found")
		failed_models.append(model_name)
		return

	# Instance the model
	var model_instance = model_resource.instantiate()
	if not model_instance:
		push_error("[EnhancedModelLoader] Failed to instantiate model: %s" % model_name)
		model_load_failed.emit(model_name, "Instantiation failed")
		failed_models.append(model_name)
		return

	# Set up the model
	model_instance.name = model_name
	model_instance.position = model_def.get("position", Vector3.ZERO)

	# Apply scale normalization
	_normalize_model_scale(model_instance, model_def)

	# Set initial visibility based on layer
	var layer = model_def.get("layer", "")
	model_instance.visible = layer_visibility.get(layer, model_def.get("default_visible", true))

	# Add to parent
	model_parent.add_child(model_instance)

	# Process the model
	await _process_model_async(model_instance, model_def, index)

	# Track by layer
	if layer and layer_models.has(layer):
		layer_models[layer].append(model_name)

	models_loaded_count += 1


func _process_model_async(model_instance: Node3D, model_def: Dictionary, index: int) -> void:
	"""Process model after loading with metadata extraction"""
	var model_name = model_def.get("name", "Unknown")
	var meshes_found: Array[MeshInstance3D] = []

	# Initialize model meshes
	_collect_model_meshes(model_instance, meshes_found)

	# Extract and preserve metadata
	var metadata = model_def.get("metadata", {}).duplicate()
	metadata["mesh_count"] = meshes_found.size()
	metadata["load_time"] = Time.get_ticks_msec() - load_start_time
	metadata["layer"] = model_def.get("layer", "unknown")

	# Apply medical material enhancements
	for mesh in meshes_found:
		_enhance_medical_materials(mesh)

	# Store model data
	loaded_models[model_name] = {
		"instance": model_instance,
		"definition": model_def,
		"meshes": meshes_found,
		"metadata": metadata
	}

	# Emit signals
	model_loaded.emit(model_name, index)
	metadata_extracted.emit(model_name, metadata)

	if meshes_found.size() > 0:
		model_initialized.emit(model_name, meshes_found[0])

	print(
		(
			"[EnhancedModelLoader] Processed %s: %d meshes, layer '%s'"
			% [model_name, meshes_found.size(), model_def.get("layer", "unknown")]
		)
	)


func _collect_model_meshes(node: Node, meshes: Array[MeshInstance3D]) -> void:
	"""Recursively collect all MeshInstance3D nodes"""
	if node is MeshInstance3D:
		meshes.append(node)

	for child in node.get_children():
		_collect_model_meshes(child, meshes)


func _normalize_model_scale(model_instance: Node3D, model_def: Dictionary) -> void:
	"""Normalize model scale for anatomical accuracy"""
	var base_scale = model_def.get("scale", DEFAULT_MODEL_SCALE)

	# Apply anatomical scale factor
	model_instance.scale = base_scale * ANATOMICAL_SCALE

	# Special handling for known problematic models
	if "brainstem" in model_instance.name.to_lower() and model_instance.scale.x > 50.0:
		print("[EnhancedModelLoader] Fixing oversized brainstem scale")
		model_instance.scale = BRAINSTEM_SCALE_FIX * ANATOMICAL_SCALE


func _enhance_medical_materials(mesh: MeshInstance3D) -> void:
	"""Enhance materials for medical visualization"""
	if not mesh.mesh:
		return

	# Enable proper shadows for depth perception
	mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON

	# Process each surface material
	for i in range(mesh.get_surface_override_material_count()):
		var material = mesh.get_surface_override_material(i)
		if not material:
			material = mesh.mesh.surface_get_material(i)

		if material is StandardMaterial3D:
			var std_mat = material as StandardMaterial3D

			# Ensure material is properly visible
			std_mat.transparency = BaseMaterial3D.TRANSPARENCY_DISABLED
			std_mat.cull_mode = BaseMaterial3D.CULL_BACK

			# Add subtle medical visualization enhancements
			std_mat.roughness = 0.85  # Organic tissue appearance
			std_mat.metallic = 0.0  # Non-metallic biological material

			# Add rim lighting for better structure definition
			std_mat.rim_enabled = true
			std_mat.rim = 0.3
			std_mat.rim_tint = 0.5


func _clear_existing_models() -> void:
	"""Remove any existing models from the parent"""
	for child in model_parent.get_children():
		if child is MeshInstance3D or child is Node3D:
			print("[EnhancedModelLoader] Removing existing model: %s" % child.name)
			child.queue_free()


func _finalize_loading() -> void:
	"""Finalize the loading process"""
	is_loading = false
	var total_time = Time.get_ticks_msec() - load_start_time
	var successful_count = loaded_models.size()

	print("[EnhancedModelLoader] Loading complete in %.2f seconds" % (total_time / 1000.0))
	print("[EnhancedModelLoader] Success: %d/%d models" % [successful_count, total_models])

	if failed_models.size() > 0:
		print("[EnhancedModelLoader] Failed models: %s" % str(failed_models))
		_provide_educational_fallback()

	# Register models with switcher
	_register_models_with_switcher()

	# Ensure educational visibility
	_ensure_educational_visibility()

	# Optimize camera
	_optimize_camera_position()

	# Final progress update
	loading_progress = 100.0
	model_load_progress.emit(loading_progress, "Complete")

	all_models_loaded.emit(successful_count, total_models)


func _provide_educational_fallback() -> void:
	"""Provide educational context when models fail to load"""
	if failed_models.has("Internal_Structures"):
		push_warning(
			"[EnhancedModelLoader] Deep brain structures unavailable - using cortex-only view"
		)
		# Ensure cortex is visible for basic education
		set_layer_visibility("cortex", true)

	if failed_models.has("Brainstem"):
		push_warning(
			"[EnhancedModelLoader] Brainstem model unavailable - vital functions teaching limited"
		)


func _register_models_with_switcher() -> void:
	"""Register all loaded models with the ModelSwitcherGlobal autoload"""
	var model_switcher = get_node_or_null("/root/ModelSwitcherGlobal")
	if not model_switcher:
		push_warning(
			"[EnhancedModelLoader] ModelSwitcherGlobal not found - layer switching limited"
		)
		return

	for model_name in loaded_models:
		var model_data = loaded_models[model_name]
		var instance = model_data["instance"]
		if instance and model_switcher.has_method("register_model"):
			model_switcher.register_model(instance, model_name)
			print("[EnhancedModelLoader] Registered %s with ModelSwitcher" % model_name)


func _ensure_educational_visibility() -> void:
	"""Ensure at least one model is visible for education"""
	var any_visible = false

	# Check if any model is visible
	for model_name in loaded_models:
		var instance = loaded_models[model_name]["instance"]
		if instance and instance.visible:
			any_visible = true
			break

	# If nothing visible, show cortex layer (primary teaching layer)
	if not any_visible and loaded_models.size() > 0:
		print("[EnhancedModelLoader] No models visible - showing cortex layer")
		set_layer_visibility("cortex", true)


func _optimize_camera_position() -> void:
	"""Set camera to optimal medical viewing position"""
	var camera = get_viewport().get_camera_3d()
	if camera:
		camera.position = DEFAULT_CAMERA_POSITION
		camera.look_at(Vector3.ZERO, Vector3.UP)
		print("[EnhancedModelLoader] Camera positioned for medical viewing")


# ===== PUBLIC UTILITY METHODS =====
func get_loading_progress() -> float:
	"""Get current loading progress percentage"""
	return loading_progress


func get_current_loading_model() -> String:
	"""Get name of model currently being loaded"""
	return current_loading_model


func is_currently_loading() -> bool:
	"""Check if models are currently loading"""
	return is_loading


func get_layer_model_count(layer_name: String) -> int:
	"""Get number of models in a specific layer"""
	return layer_models.get(layer_name, []).size()


func get_all_layers() -> Array:
	"""Get list of all anatomical layers"""
	return ANATOMICAL_LAYERS.keys()


func reset_to_default_visibility() -> void:
	"""Reset all layers to their default visibility"""
	for layer_name in ANATOMICAL_LAYERS:
		var default_visible = ANATOMICAL_LAYERS[layer_name]["default_visible"]
		set_layer_visibility(layer_name, default_visible)
