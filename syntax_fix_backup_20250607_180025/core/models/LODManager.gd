## LODManager.gd
## Level of Detail (LOD) system for optimizing brain model rendering
##
## Manages automatic switching between different detail levels of models
## based on distance, with smooth transitions and memory optimization.
##
## @tutorial: docs/dev/lod-system.md
## @experimental: false

class_name LODManager
extends Node

# === CONSTANTS ===
## Maximum number of LOD levels

signal lod_level_changed(model_name: String, new_level: int)

## Emitted when LOD system is enabled or disabled
## @param enabled: bool whether system is enabled
signal lod_system_enabled(enabled: bool)

# === EXPORTS ===
## Whether LOD system is enabled

const MAX_LOD_LEVELS: int = 4

## Transition time between LOD levels in seconds
const DEFAULT_TRANSITION_TIME: float = 0.3

# === SIGNALS ===
## Emitted when LOD level changes for a model
## @param model_name: String name of the model
## @param new_level: int new LOD level

@export var lod_enabled: bool = true:
	set(value):
		lod_enabled = value
		lod_system_enabled.emit(lod_enabled)
@export var distance_thresholds: Array[float] = [5.0, 15.0, 30.0, 50.0]

## Quality reduction per LOD level (0.0-1.0)
@export var quality_reduction_factors: Array[float] = [1.0, 0.75, 0.5, 0.25]

## Enable smooth transitions between LOD levels
@export var smooth_transitions: bool = true

## Memory management strategy (0=Aggressive, 1=Balanced, 2=Quality)
@export var memory_strategy: int = 1

## Custom transition time between LOD levels
@export var transition_time: float = DEFAULT_TRANSITION_TIME

# === PUBLIC VARIABLES ===
## Reference to main camera

var camera: Camera3D

# === PRIVATE VARIABLES ===
var model_data = _lod_models[model_name]
var distance = _calculate_model_distance(model_data.root_node)
var target_lod = _determine_lod_level(distance)

var model_data = {
	"root_node": model, "lod_meshes": {}, "original_meshes": {}, "lod_variants": lod_variants
	}

	# Store original meshes for reference
	_store_original_meshes(model, model_data)

	# If LOD variants provided, store them
var model_data = _lod_models[model_name]
var tween = _transition_tweens[model_name]
var cameras = get_tree().get_nodes_in_group("Cameras")
var camera_paths = [
	"/root/Main/Camera3D", "/root/Main/CameraRig/Camera3D", "/root/Node3D/Camera3D"
	]

var model_pos = model.global_position

# If model has an AABB, use its center
var aabb = model.mesh.get_aabb()
	model_pos = model.global_position + model.global_transform.basis * aabb.get_center()

	# Calculate distance
var model_data = _lod_models[model_name]
var current_level = _current_lod_levels.get(model_name, 0)

var tween = _transition_tweens[model_name]
var material = node.get_surface_override_material(i)
	mesh_dict[node.get_path()].materials.append(material)

	# Process children
var original_meshes = model_data.original_meshes

# Generate LOD meshes for each level
var quality_factor = (
	quality_reduction_factors[level] if level < quality_reduction_factors.size() else 0.25
	)
var lod_meshes = {}

var original_data = original_meshes[node_path]

# Create simplified mesh
var simplified_mesh = _simplify_mesh(original_data.mesh, quality_factor)

# Store simplified mesh and materials
	lod_meshes[node_path] = {
	"mesh": simplified_mesh, "materials": original_data.materials.duplicate()
	}

	# Store for this LOD level
	model_data.lod_meshes[level] = lod_meshes


var simplified_mesh

var array_mesh = ArrayMesh.new()

var arrays = original_mesh.surface_get_arrays(surface_idx)
var vertex_count = arrays[Mesh.ARRAY_VERTEX].size()

# If mesh is small enough, don't simplify further
var stride = int(1.0 / quality_factor)
	stride = max(1, stride)

var new_arrays = []
	new_arrays.resize(Mesh.ARRAY_MAX)

	# Keep every Nth vertex
var vertices = PackedVector3Array()
var normals = PackedVector3Array()
var uvs = PackedVector2Array()

var indices = PackedInt32Array()
var original_indices = arrays[Mesh.ARRAY_INDEX]

# Create a mapping from original vertices to simplified vertices
var vertex_map = {}
var a = original_indices[i]
var b = original_indices[i + 1]
var c = original_indices[i + 2]

# Skip triangles that use vertices we've excluded
var material = original_mesh.surface_get_material(surface_idx)
var lod_meshes = model_data.lod_meshes[level]

var node_path = NodePath(node_path_str)
var node = model_data.root_node.get_node_or_null(node_path)

var mesh_data = lod_meshes[node_path_str]
	node.mesh = mesh_data.mesh

	# Apply materials
var original_meshes = model_data.original_meshes

var node_path = NodePath(node_path_str)
var node = model_data.root_node.get_node_or_null(node_path)

var mesh_data = original_meshes[node_path_str]
	node.mesh = mesh_data.mesh

	# Apply original materials
var current_level = _current_lod_levels.get(model_name, 0)

# Create a tween for smooth transition
var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	# Store tween reference
	_transition_tweens[model_name] = tween

	# Apply target meshes immediately
var transition_duration = transition_time
var node_paths
var node_path = NodePath(node_path_str)
var node = model_data.root_node.get_node_or_null(node_path)

var material = node.get_surface_override_material(i)

var start_alpha = 0.7
var end_alpha = 1.0

	material.albedo_color.a = start_alpha
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA

	# Tween to full opacity
	tween.tween_property(
	material, "albedo_color:a", end_alpha, transition_duration
	)

	# Set a callback to disable transparency when done
	(
	tween
	. tween_callback(
	func(): material.transparency = BaseMaterial3D.TRANSPARENCY_DISABLED
	)
	. set_delay(transition_duration)
	)


var model_data = _lod_models[model_name]
var distance = _calculate_model_distance(model_data.root_node)
var target_lod = _determine_lod_level(distance)

var model_data = _lod_models[model_name]
var current_level = _current_lod_levels.get(model_name, 0)

# Keep only current LOD level and adjacent levels
var model_data = _lod_models[model_name]

# Regenerate any missing LOD levels
var quality_factor = (
	quality_reduction_factors[level]
var lod_meshes = {}

var original_data = model_data.original_meshes[node_path]

# Create simplified mesh
var simplified_mesh = _simplify_mesh(original_data.mesh, quality_factor)

# Store simplified mesh and materials
	lod_meshes[node_path] = {
	"mesh": simplified_mesh,
	"materials": original_data.materials.duplicate()
	}

	# Store for this LOD level
	model_data.lod_meshes[level] = lod_meshes


var _lod_models: Dictionary = {}
var _current_lod_levels: Dictionary = {}
var _transition_tweens: Dictionary = {}
var _initialized: bool = false


# === LIFECYCLE METHODS ===

func _ready() -> void:
	"""Initialize the LOD manager"""
	_initialized = true

	# Find camera if not set
	if not camera:
		camera = _find_main_camera()

		print("[LODManager] Initialized with " + str(MAX_LOD_LEVELS) + " LOD levels")


func _process(_delta: float) -> void:
	"""Update LOD levels based on camera distance"""
	if not lod_enabled or not camera:
		return

		for model_name in _lod_models:
func _process_model_node(node: Node, mesh_dict: Dictionary) -> void:
	"""Process a node in the model hierarchy"""
	if node is MeshInstance3D and node.mesh != null:
		# Store reference to original mesh
		mesh_dict[node.get_path()] = {"mesh": node.mesh, "materials": []}

		# Store materials
		for i in range(node.get_surface_override_material_count()):

func register_model(model: Node3D, model_name: String, lod_variants: Array = []) -> bool:
	"""Register a model for LOD management"""
	if not model or not model.is_inside_tree():
		push_warning("[LODManager] Cannot register invalid model: " + model_name)
		return false

		# Initialize model data
func unregister_model(model_name: String) -> bool:
	"""Unregister a model from LOD management"""
	if not _lod_models.has(model_name):
		push_warning("[LODManager] Model not registered: " + model_name)
		return false

		# Restore original meshes if needed
func set_lod_level(model_name: String, lod_level: int, force_instant: bool = false) -> bool:
	"""Manually set LOD level for a model"""
	if not _lod_models.has(model_name):
		push_warning("[LODManager] Model not registered: " + model_name)
		return false

		lod_level = clamp(lod_level, 0, MAX_LOD_LEVELS - 1)
		return _switch_lod_level(model_name, lod_level, force_instant)


		## Update LOD thresholds
		## @param thresholds: Array of float distance thresholds
		## @returns: bool indicating success
func update_thresholds(thresholds: Array) -> bool:
	"""Update distance thresholds for LOD levels"""
	if thresholds.size() < MAX_LOD_LEVELS - 1:
		push_warning(
		"[LODManager] Not enough thresholds provided. Need at least " + str(MAX_LOD_LEVELS - 1)
		)
		return false

		# Validate thresholds are in ascending order
		for i in range(1, thresholds.size()):
			if thresholds[i] <= thresholds[i - 1]:
				push_warning("[LODManager] Thresholds must be in ascending order")
				return false

				distance_thresholds = thresholds

				# Force update all models
				_update_lod_state()

				print("[LODManager] Updated distance thresholds")
				return true


				## Update memory management strategy
				## @param strategy: int memory strategy (0=Aggressive, 1=Balanced, 2=Quality)
				## @returns: bool indicating success
func update_memory_strategy(strategy: int) -> bool:
	"""Update memory management strategy"""
	if strategy < 0 or strategy > 2:
		push_warning("[LODManager] Invalid memory strategy: " + str(strategy))
		return false

		memory_strategy = strategy

		# Apply new memory strategy
		_apply_memory_strategy()

		print("[LODManager] Updated memory strategy to: " + _get_strategy_name(strategy))
		return true


		## Force LOD update for all models
		## @returns: bool indicating success
func force_update() -> bool:
	"""Force LOD update for all models"""
	return _update_lod_state()


	## Reset all models to highest detail
	## @returns: bool indicating success
func reset_to_highest_detail() -> bool:
	"""Reset all models to highest detail level"""
	for model_name in _lod_models:
		set_lod_level(model_name, 0, true)

		print("[LODManager] Reset all models to highest detail")
		return true


		# === PRIVATE METHODS ===

func _fix_orphaned_code():
	if _initialized:
		_update_lod_state()

		## Distance thresholds for LOD levels (in world units)
func _fix_orphaned_code():
	if not model_data.root_node or not model_data.root_node.is_inside_tree():
		continue

func _fix_orphaned_code():
	if target_lod != _current_lod_levels.get(model_name, 0):
		_switch_lod_level(model_name, target_lod)


		# === PUBLIC METHODS ===
		## Register a model for LOD management
		## @param model: Node3D root node of the model
		## @param model_name: String name of the model
		## @param lod_variants: Array of PackedScene LOD variants (optional)
		## @returns: bool indicating success
func _fix_orphaned_code():
	if not lod_variants.is_empty():
		model_data.has_variants = true
		else:
			# Generate simplified meshes
			_generate_simplified_meshes(model_data)

			# Add to managed models
			_lod_models[model_name] = model_data
			_current_lod_levels[model_name] = 0  # Start at highest detail

			print("[LODManager] Registered model: " + model_name)
			return true


			## Unregister a model from LOD management
			## @param model_name: String name of the model
			## @returns: bool indicating success
func _fix_orphaned_code():
	if _current_lod_levels.get(model_name, 0) != 0:
		_restore_original_meshes(model_data)

		# Clear any active transitions
		if _transition_tweens.has(model_name):
func _fix_orphaned_code():
	if tween and tween.is_valid():
		tween.kill()
		_transition_tweens.erase(model_name)

		# Remove from managed models
		_lod_models.erase(model_name)
		_current_lod_levels.erase(model_name)

		print("[LODManager] Unregistered model: " + model_name)
		return true


		## Set LOD level manually for a model
		## @param model_name: String name of the model
		## @param lod_level: int LOD level to set
		## @param force_instant: bool whether to force instant transition
		## @returns: bool indicating success
func _fix_orphaned_code():
	if not cameras.is_empty():
		return cameras[0]

		# Try to find by node path
func _fix_orphaned_code():
	for path in camera_paths:
		if get_node_or_null(path) != null:
			return get_node(path)

			push_warning("[LODManager] No camera found. LOD system needs a camera reference.")
			return null


func _fix_orphaned_code():
	if model is MeshInstance3D and model.mesh != null:
func _fix_orphaned_code():
	return camera.global_position.distance_to(model_pos)


func _fix_orphaned_code():
	if current_level == level:
		return true  # Already at this level

		# Cancel any active transition
		if _transition_tweens.has(model_name):
func _fix_orphaned_code():
	if tween and tween.is_valid():
		tween.kill()
		_transition_tweens.erase(model_name)

		# Determine transition approach
		if model_data.has_variants:
			# Switch between variant models
			_switch_variant_model(model_data, level)
			else:
				# Apply simplified meshes or transition between them
				if smooth_transitions and not force_instant:
					_transition_to_level(model_data, model_name, level)
					else:
						_apply_lod_level(model_data, level)

						# Update current level
						_current_lod_levels[model_name] = level

						# Emit signal
						lod_level_changed.emit(model_name, level)

						return true


func _fix_orphaned_code():
	for child in node.get_children():
		_process_model_node(child, mesh_dict)


func _fix_orphaned_code():
	for level in range(1, MAX_LOD_LEVELS):
func _fix_orphaned_code():
	for node_path in original_meshes:
func _fix_orphaned_code():
	if original_mesh is ArrayMesh:
		# For array meshes, we can create a simplified version
func _fix_orphaned_code():
	for surface_idx in range(original_mesh.get_surface_count()):
func _fix_orphaned_code():
	if vertex_count < 100:
		array_mesh.add_surface_from_arrays(
		original_mesh.surface_get_primitive_type(surface_idx), arrays
		)
		continue

		# Simplify by skipping vertices
func _fix_orphaned_code():
	for i in range(0, vertex_count, stride):
		if i < arrays[Mesh.ARRAY_VERTEX].size():
			vertices.append(arrays[Mesh.ARRAY_VERTEX][i])

			if arrays[Mesh.ARRAY_NORMAL].size() > i:
				normals.append(arrays[Mesh.ARRAY_NORMAL][i])

				if arrays[Mesh.ARRAY_TEX_UV].size() > i:
					uvs.append(arrays[Mesh.ARRAY_TEX_UV][i])

					new_arrays[Mesh.ARRAY_VERTEX] = vertices

					if not normals.is_empty():
						new_arrays[Mesh.ARRAY_NORMAL] = normals

						if not uvs.is_empty():
							new_arrays[Mesh.ARRAY_TEX_UV] = uvs

							# Create simplified indices if present
							if arrays[Mesh.ARRAY_INDEX].size() > 0:
func _fix_orphaned_code():
	for i in range(vertices.size()):
		vertex_map[i * stride] = i

		# Remap triangle indices
		for i in range(0, original_indices.size(), 3):
			if i + 2 < original_indices.size():
func _fix_orphaned_code():
	if vertex_map.has(a) and vertex_map.has(b) and vertex_map.has(c):
		indices.append(vertex_map[a])
		indices.append(vertex_map[b])
		indices.append(vertex_map[c])

		new_arrays[Mesh.ARRAY_INDEX] = indices

		# Add the simplified surface
		array_mesh.add_surface_from_arrays(
		original_mesh.surface_get_primitive_type(surface_idx), new_arrays
		)

		# Copy material if present
func _fix_orphaned_code():
	if material:
		array_mesh.surface_set_material(surface_idx, material)

		simplified_mesh = array_mesh
		else:
			# For other mesh types, create a simplified placeholder
			# In a real implementation, you would properly simplify these meshes
			simplified_mesh = original_mesh

			return simplified_mesh


func _fix_orphaned_code():
	for node_path_str in lod_meshes:
func _fix_orphaned_code():
	if node and node is MeshInstance3D:
func _fix_orphaned_code():
	for i in range(mesh_data.materials.size()):
		if i < node.get_surface_override_material_count():
			node.set_surface_override_material(i, mesh_data.materials[i])


func _fix_orphaned_code():
	for node_path_str in original_meshes:
func _fix_orphaned_code():
	if node and node is MeshInstance3D:
func _fix_orphaned_code():
	for i in range(mesh_data.materials.size()):
		if i < node.get_surface_override_material_count():
			node.set_surface_override_material(i, mesh_data.materials[i])


func _fix_orphaned_code():
	if target_level == 0:
		_restore_original_meshes(model_data)
		else:
			_apply_lod_level(model_data, target_level)

			# If transitioning to higher detail, make it faster
func _fix_orphaned_code():
	if target_level < current_level:
		transition_duration *= 0.7

		# Apply material transition for all affected meshes
func _fix_orphaned_code():
	if target_level == 0:
		node_paths = model_data.original_meshes.keys()
		else:
			node_paths = model_data.lod_meshes[target_level].keys()

			for node_path_str in node_paths:
func _fix_orphaned_code():
	if node and node is MeshInstance3D:
		# Fade in the new LOD level
		if node.get_surface_override_material_count() > 0:
			for i in range(node.get_surface_override_material_count()):
func _fix_orphaned_code():
	if material is StandardMaterial3D:
		# Start with slight transparency
func _fix_orphaned_code():
	if not model_data.root_node or not model_data.root_node.is_inside_tree():
		continue

func _fix_orphaned_code():
	if lod_enabled:
		_switch_lod_level(model_name, target_lod, true)
		else:
			# Force highest detail if LOD is disabled
			_switch_lod_level(model_name, 0, true)

			return true


func _fix_orphaned_code():
	for level in range(MAX_LOD_LEVELS):
		if (
		level != current_level
		and level != current_level - 1
		and level != current_level + 1
		):
			if model_data.lod_meshes.has(level):
				model_data.lod_meshes.erase(level)

				1:  # Balanced
				# Default strategy, no special handling
				pass

				2:  # Quality
				# Ensure all LOD levels are loaded
				for model_name in _lod_models:
func _fix_orphaned_code():
	for level in range(1, MAX_LOD_LEVELS):
		if not model_data.lod_meshes.has(level):
func _fix_orphaned_code():
	if level < quality_reduction_factors.size()
	else 0.25
	)
func _fix_orphaned_code():
	for node_path in model_data.original_meshes:
func _find_main_camera() -> Camera3D:
	"""Find the main camera in the scene"""
func _calculate_model_distance(model: Node3D) -> float:
	"""Calculate distance from camera to model"""
	if not camera:
		return 0.0

		# Get model center position
func _determine_lod_level(distance: float) -> int:
	"""Determine appropriate LOD level based on distance"""
	for i in range(distance_thresholds.size()):
		if distance < distance_thresholds[i]:
			return i

			return min(distance_thresholds.size(), MAX_LOD_LEVELS - 1)


func _switch_lod_level(model_name: String, level: int, force_instant: bool = false) -> bool:
	"""Switch LOD level for a model"""
	if not _lod_models.has(model_name):
		return false

func _store_original_meshes(model: Node3D, model_data: Dictionary) -> void:
	"""Store original meshes for reference and LOD generation"""
	# Recursively process model hierarchy
	_process_model_node(model, model_data.original_meshes)


func _generate_simplified_meshes(model_data: Dictionary) -> void:
	"""Generate simplified meshes for LOD levels"""
func _simplify_mesh(original_mesh: Mesh, quality_factor: float) -> Mesh:
	"""Create a simplified version of a mesh"""
	# In a real implementation, this would use mesh simplification algorithms
	# For this example, we'll create a simplified mesh by reducing indices

	# Create a placeholder simplified mesh (in production, use actual simplification)
func _apply_lod_level(model_data: Dictionary, level: int) -> void:
	"""Apply LOD level meshes to a model"""
	if level == 0:
		# Restore original meshes
		_restore_original_meshes(model_data)
		return

		# Apply LOD meshes
		if not model_data.lod_meshes.has(level):
			push_warning("[LODManager] LOD level " + str(level) + " not available")
			return

func _restore_original_meshes(model_data: Dictionary) -> void:
	"""Restore original meshes to a model"""
func _transition_to_level(model_data: Dictionary, model_name: String, target_level: int) -> void:
	"""Smooth transition between LOD levels"""
func _switch_variant_model(model_data: Dictionary, level: int) -> void:
	"""Switch to a different LOD variant model"""
	# Placeholder for variant-based LOD switching
	# In a real implementation, this would swap entire model variants
	push_warning("[LODManager] Variant-based LOD switching not fully implemented")


func _update_lod_state() -> bool:
	"""Update LOD state for all models"""
	if not camera:
		push_warning("[LODManager] No camera reference. Cannot update LOD state.")
		return false

		for model_name in _lod_models:
func _apply_memory_strategy() -> void:
	"""Apply memory management strategy"""
	match memory_strategy:
		0:  # Aggressive
		# Unload LOD meshes for distant models
		for model_name in _lod_models:
func _get_strategy_name(strategy: int) -> String:
	"""Get the name of a memory strategy"""
	match strategy:
		0:
			return "Aggressive"
			1:
				return "Balanced"
				2:
					return "Quality"
					_:
						return "Unknown"
