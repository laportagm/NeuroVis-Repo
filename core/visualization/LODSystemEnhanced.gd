## LODSystemEnhanced.gd
## Advanced Level of Detail (LOD) system for optimized brain structure visualization
##
## Provides intelligent, context-aware LOD management with educational focus,
## prioritizing structures based on learning context while maintaining
## high performance through optimized mesh simplification and intelligent
## resource management.
##
## @tutorial: docs/dev/advanced-lod-system.md
## @version: 1.0

class_name LODSystemEnhanced
extends Node

# === CONSTANTS ===
## Maximum number of LOD levels

signal lod_level_changed(structure_name: String, new_level: int)

## Emitted when LOD system is enabled or disabled
## @param enabled: bool whether system is enabled
signal lod_system_enabled(enabled: bool)

## Emitted when LOD optimization metrics are updated
## @param metrics: Dictionary containing LOD system metrics
signal lod_metrics_updated(metrics: Dictionary)

## Emitted when a structure changes priority
## @param structure_name: String name of the structure
## @param priority: StructurePriority new priority level
signal structure_priority_changed(structure_name: String, priority: StructurePriority)

# === EXPORTS ===
## Whether LOD system is enabled

enum StructurePriority { PRIMARY, SECONDARY, SUPPORTING, BACKGROUND }  # Current educational focus structure  # Structures related to current focus  # Contextually relevant structures  # Context structures not directly relevant

# === SIGNALS ===
## Emitted when LOD level changes for a model
## @param structure_name: String name of the structure
## @param new_level: int new LOD level

const MAX_LOD_LEVELS: int = 4

## Default transition time between LOD levels in seconds
const DEFAULT_TRANSITION_TIME: float = 0.3

## Structure priority levels for educational context

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
@export_range(0, 2) var memory_strategy: int = 1:
	set(value):
		memory_strategy = value
		_apply_memory_strategy()

		## Custom transition time between LOD levels
@export var transition_time: float = DEFAULT_TRANSITION_TIME

## Focus distance multiplier for prioritized structures
@export_range(1.0, 5.0) var focus_distance_multiplier: float = 1.5

## Educational focus bias (higher = stronger focus on educational structures)
@export_range(0.0, 1.0) var educational_focus_bias: float = 0.6

## Auto-optimize based on frame rate
@export var auto_optimize_enabled: bool = true

## Target framerate for auto-optimization
@export_range(30, 120) var target_framerate: int = 60

# === PUBLIC VARIABLES ===
## Reference to main camera

var camera: Camera3D

# === PRIVATE VARIABLES ===
var update_timer = Timer.new()
	update_timer.wait_time = 1.0  # Update metrics every second
	update_timer.timeout.connect(_update_performance_metrics)
	update_timer.autostart = true
	add_child(update_timer)

	_initialized = true
var structure_data = _structure_data[structure_name]
var distance = _cached_structure_distances.get(structure_name, 0.0)
# FIXED: Orphaned code - var priority = _structure_priorities.get(structure_name, StructurePriority.BACKGROUND)
# FIXED: Orphaned code - var target_lod = _determine_lod_level(distance, priority)

# Switch LOD if needed
var structure_data_2 = {
	"root_node": structure,
	"lod_meshes": {},
	"original_meshes": {},
	"lod_variants": lod_variants,
	"has_variants": not lod_variants.is_empty(),
	"last_distance": 0.0,
	"last_lod_change": Time.get_ticks_msec() / 1000.0
	}

	# Store original meshes for reference
	_store_original_meshes(structure, structure_data)

	# If LOD variants provided, store them
var structure_data_3 = _structure_data[structure_name]
var tween = _transition_tweens[structure_name]
var distance_2 = _cached_structure_distances.get(structure_name, 0.0)
# FIXED: Orphaned code - var target_lod_2 = _determine_lod_level(distance, priority)
	_switch_lod_level(structure_name, target_lod)

# FIXED: Orphaned code - var distance_3 = _cached_structure_distances.get(structure_name, 0.0)
# FIXED: Orphaned code - var target_lod_3 = _determine_lod_level(distance, StructurePriority.PRIMARY)
	_switch_lod_level(structure_name, target_lod, true)  # Force instant transition for focus

var structure = _structure_data[structure_name]
var info = {
	"current_lod": _current_lod_levels.get(structure_name, 0),
	"priority": _structure_priorities.get(structure_name, StructurePriority.BACKGROUND),
	"distance": _cached_structure_distances.get(structure_name, 0.0),
	"is_focus": _focus_structure == structure_name,
	"mesh_count": structure.original_meshes.size(),
	"vertex_reduction": {}
	}

	# Calculate vertex reduction per level
var cameras = get_tree().get_nodes_in_group("Cameras")
# FIXED: Orphaned code - var camera_paths = [
	"/root/MainScene/Camera3D",
	"/root/NeuroVisRoot/SceneManager/MainEducationalScene/Camera3D",
	"/root/Main/CameraRig/Camera3D",
	"/root/Node3D/Camera3D"
	]

var structure_2 = _structure_data[structure_name]
var distance_4 = _calculate_structure_distance(structure.root_node)
	_cached_structure_distances[structure_name] = distance
	structure.last_distance = distance


var model_pos = model.global_position

# If model has an AABB, use its center
var aabb = model.mesh.get_aabb()
	model_pos = model.global_position + model.global_transform.basis * aabb.get_center()

	# Calculate distance
var effective_distance = distance

# Apply educational focus bias
var priority_factor = 1.0
StructurePriority.PRIMARY:
	# Primary structures appear closer to maintain high detail
	priority_factor = 0.5
	StructurePriority.SECONDARY:
		# Secondary structures get moderate priority
		priority_factor = 0.7
		StructurePriority.SUPPORTING:
			# Supporting structures get slight priority
			priority_factor = 0.9

			# Apply educational bias
var adjusted_factor = lerp(1.0, priority_factor, educational_focus_bias)
	effective_distance *= adjusted_factor

	# Find appropriate LOD level based on adjusted distance
var structure_3 = _structure_data[structure_name]
var current_level = _current_lod_levels.get(structure_name, 0)

# FIXED: Orphaned code - var time_now = Time.get_ticks_msec() / 1000.0
var time_since_change = time_now - structure.last_lod_change

# Rate limit LOD changes to prevent thrashing
var tween_2 = _transition_tweens[structure_name]
var material = node.get_surface_override_material(i)
	mesh_dict[node.get_path()].materials.append(material)

	# Process children
var count = 0

var arrays = mesh.surface_get_arrays(surface_idx)
	count += arrays[Mesh.ARRAY_VERTEX].size()

# FIXED: Orphaned code - var original_count = 0
var lod_count = 0

# Sum vertices in original meshes
var original_meshes = structure_data.original_meshes

# Check if we have this structure in cache already
var cache_key = structure_name + "_lod_meshes"
var quality_factor = (
	quality_reduction_factors[level] if level < quality_reduction_factors.size() else 0.25
	)
# FIXED: Orphaned code - var lod_meshes = {}

# FIXED: Orphaned code - var original_data = original_meshes[node_path]

# Create simplified mesh
var simplified_mesh = _simplify_mesh(original_data.mesh, quality_factor)

# Count vertices in simplified mesh
var vertex_count = _get_vertex_count(simplified_mesh)

# Store simplified mesh and materials
	lod_meshes[node_path] = {
	"mesh": simplified_mesh,
	"materials": original_data.materials.duplicate(),
	"vertex_count": vertex_count
	}

	# Store for this LOD level
	structure_data.lod_meshes[level] = lod_meshes

	# Cache the generated LOD meshes for future reuse
	_mesh_cache[cache_key] = structure_data.lod_meshes.duplicate(true)

# FIXED: Orphaned code - var array_mesh = ArrayMesh.new()

# FIXED: Orphaned code - var arrays_2 = original_mesh.surface_get_arrays(surface_idx)
# FIXED: Orphaned code - var vertex_count_2 = arrays[Mesh.ARRAY_VERTEX].size()

# If mesh is small enough, don't simplify further
var stride = int(1.0 / quality_factor)
	stride = max(1, stride)

# FIXED: Orphaned code - var new_arrays = []
	new_arrays.resize(Mesh.ARRAY_MAX)

	# Keep every Nth vertex
var vertices = PackedVector3Array()
# FIXED: Orphaned code - var normals = PackedVector3Array()
# FIXED: Orphaned code - var uvs = PackedVector2Array()

# FIXED: Orphaned code - var indices = PackedInt32Array()
# FIXED: Orphaned code - var original_indices = arrays[Mesh.ARRAY_INDEX]

# Create a mapping from original vertices to simplified vertices
var vertex_map = {}
# FIXED: Orphaned code - var a = original_indices[i]
var b = original_indices[i + 1]
var c = original_indices[i + 2]

# Skip triangles that use vertices we've excluded
var material_2 = original_mesh.surface_get_material(surface_idx)
# FIXED: Orphaned code - var lod_meshes_2 = structure_data.lod_meshes[level]

var node_path = NodePath(node_path_str)
# FIXED: Orphaned code - var node = structure_data.root_node.get_node_or_null(node_path)

# FIXED: Orphaned code - var mesh_data = lod_meshes[node_path_str]
	node.mesh = mesh_data.mesh

	# Apply materials
var original_meshes_2 = structure_data.original_meshes

var node_path_2 = NodePath(node_path_str)
# FIXED: Orphaned code - var node_2 = structure_data.root_node.get_node_or_null(node_path)

# FIXED: Orphaned code - var mesh_data_2 = original_meshes[node_path_str]
	node.mesh = mesh_data.mesh

	# Apply original materials
var current_level_2 = _current_lod_levels.get(structure_name, 0)

# Create a tween for smooth transition
var tween_3 = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	# Store tween reference
	_transition_tweens[structure_name] = tween

	# Apply target meshes immediately
var transition_duration = transition_time
var node_paths
var node_path_3 = NodePath(node_path_str)
# FIXED: Orphaned code - var node_3 = structure_data.root_node.get_node_or_null(node_path)

# FIXED: Orphaned code - var material_3 = node.get_surface_override_material(i)

# FIXED: Orphaned code - var start_alpha = 0.7
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


# FIXED: Orphaned code - var variant_scene = structure_data.lod_variants[level]

# Hide current model
	structure_data.root_node.visible = false

	# Instantiate variant if needed
var variant_key = "variant_instance_" + str(level)
# FIXED: Orphaned code - var variant_instance = variant_scene.instantiate()
	variant_instance.name = structure_data.root_node.name + "_LOD" + str(level)
	structure_data.root_node.get_parent().add_child(variant_instance)
	structure_data[variant_key] = variant_instance

	# Show the variant
	structure_data[variant_key].visible = true

	# This is just a placeholder implementation


var structure_4 = _structure_data[structure_name]
var distance_5 = _cached_structure_distances.get(structure_name, 0.0)
# FIXED: Orphaned code - var priority_2 = _structure_priorities.get(structure_name, StructurePriority.BACKGROUND)
# FIXED: Orphaned code - var target_lod_4 = _determine_lod_level(distance, priority)

# FIXED: Orphaned code - var structure_5 = _structure_data[structure_name]
var current_level_3 = _current_lod_levels.get(structure_name, 0)

# Keep only current LOD level and adjacent levels
var keep_keys = []
var priority_3 = _structure_priorities.get(
	structure_name, StructurePriority.BACKGROUND
	)
# FIXED: Orphaned code - var cached_keys = _mesh_cache.keys()
# FIXED: Orphaned code - var structure_6 = _structure_data[structure_name]

# Regenerate any missing LOD levels
var quality_factor_2 = (
	quality_reduction_factors[level]
var lod_meshes_3 = {}

# FIXED: Orphaned code - var original_data_2 = structure.original_meshes[node_path]

# Create simplified mesh
var simplified_mesh_2 = _simplify_mesh(original_data.mesh, quality_factor)
# FIXED: Orphaned code - var vertex_count_3 = _get_vertex_count(simplified_mesh)

# Store simplified mesh and materials
	lod_meshes[node_path] = {
	"mesh": simplified_mesh,
	"materials": original_data.materials.duplicate(),
	"vertex_count": vertex_count
	}

	# Store for this LOD level
	structure.lod_meshes[level] = lod_meshes

	# Add to cache
var cache_key_2 = structure_name + "_lod_meshes"
var avg_frame_time = 0.0
var high_detail = 0
var mid_detail = 0
var low_detail = 0

var level = _current_lod_levels[structure_name]
0:
	high_detail += 1
	1, 2:
		mid_detail += 1
		_:
			low_detail += 1

			_performance_metrics.high_detail_structures = high_detail
			_performance_metrics.mid_detail_structures = mid_detail
			_performance_metrics.low_detail_structures = low_detail

			# Calculate memory and draw call savings
			_calculate_performance_impact()

			# Emit metrics update signal
			lod_metrics_updated.emit(_performance_metrics)


# FIXED: Orphaned code - var memory_saved = 0
var draw_calls_saved = 0

var structure_7 = _structure_data[structure_name]
var current_level_4 = _current_lod_levels.get(structure_name, 0)

# FIXED: Orphaned code - var reduction = _calculate_vertex_reduction(structure, current_level)

# Estimate memory savings (very approximate)
# FIXED: Orphaned code - var original_vertex_count = 0
var current_fps = _performance_metrics.avg_fps
var target_fps_min = target_framerate * 0.9  # 90% of target

# Check if performance optimization needed
var new_thresholds: Array[float] = []

var default_thresholds = [5.0, 15.0, 30.0, 50.0]

var structure_8 = _structure_data[structure_name]
var cache_key_3 = structure_name + "_lod_meshes"

# Generate LOD meshes if not already cached

var _structure_data: Dictionary = {}
# FIXED: Orphaned code - var _current_lod_levels: Dictionary = {}
# FIXED: Orphaned code - var _structure_priorities: Dictionary = {}
# FIXED: Orphaned code - var _transition_tweens: Dictionary = {}
# FIXED: Orphaned code - var _initialized: bool = false
var _mesh_cache: Dictionary = {}
# FIXED: Orphaned code - var _performance_metrics: Dictionary = {
	"avg_fps": 0.0,
	"draw_calls_saved": 0,
	"memory_saved": 0,
	"high_detail_structures": 0,
	"mid_detail_structures": 0,
	"low_detail_structures": 0
	}
# FIXED: Orphaned code - var _frame_times: Array = []
var _focus_structure: String = ""
var _last_metrics_update: float = 0.0
var _cached_structure_distances: Dictionary = {}


# === LIFECYCLE METHODS ===

func _ready() -> void:
	"""Initialize the advanced LOD system"""
	# Find camera if not set
	if not camera:
		camera = _find_main_camera()

		# Setup performance monitoring
func _process(delta: float) -> void:
	"""Update LOD levels based on camera distance and educational context"""
	if not lod_enabled or not camera:
		return

		# Track frame time for performance metrics
		_frame_times.append(delta)
		if _frame_times.size() > 60:
			_frame_times.remove_at(0)

			# Auto-optimize based on frame rate
			if auto_optimize_enabled and _last_metrics_update + 1.0 < Time.get_ticks_msec() / 1000.0:
				_auto_optimize_lod_levels()
				_last_metrics_update = Time.get_ticks_msec() / 1000.0

				# Update structure distances from camera
				_update_structure_distances()

				# Update LOD levels for each structure
				for structure_name in _structure_data:
func _process_structure_node(node: Node, mesh_dict: Dictionary) -> void:
	"""Process a node in the structure hierarchy"""
	if node is MeshInstance3D and node.mesh != null:
		# Store reference to original mesh
		mesh_dict[node.get_path()] = {
		"mesh": node.mesh, "materials": [], "vertex_count": _get_vertex_count(node.mesh)
		}

		# Store materials
		for i in range(node.get_surface_override_material_count()):

func register_structure(
	structure: Node3D, structure_name: String, lod_variants: Array = []
	) -> bool:
		"""Register a structure for LOD management with educational awareness"""
func unregister_structure(structure_name: String) -> bool:
	"""Unregister a structure from LOD management"""
	if not _structure_data.has(structure_name):
		push_warning("[LODSystem] Structure not registered: " + structure_name)
		return false

		# Restore original meshes if needed
func set_lod_level(structure_name: String, lod_level: int, force_instant: bool = false) -> bool:
	"""Manually set LOD level for a structure"""
	if not _structure_data.has(structure_name):
		push_warning("[LODSystem] Structure not registered: " + structure_name)
		return false

		lod_level = clamp(lod_level, 0, MAX_LOD_LEVELS - 1)
		return _switch_lod_level(structure_name, lod_level, force_instant)


		## Set educational priority for a structure
		## @param structure_name: String name of the structure
		## @param priority: StructurePriority priority level
		## @returns: bool indicating success
func set_structure_priority(structure_name: String, priority: StructurePriority) -> bool:
	"""Set educational priority for a structure"""
	if not _structure_data.has(structure_name):
		push_warning(
		"[LODSystem] Cannot set priority for unregistered structure: " + structure_name
		)
		return false

		# Update priority
		_structure_priorities[structure_name] = priority
		structure_priority_changed.emit(structure_name, priority)

		# If this is the PRIMARY structure, set it as focus
		if priority == StructurePriority.PRIMARY:
			_focus_structure = structure_name

			# Force LOD update for this structure
func set_focus_structure(structure_name: String) -> bool:
	"""Set educational focus structure with automatic priority adjustment"""
	if structure_name.is_empty():
		_focus_structure = ""
		print("[LODSystem] Cleared focus structure")
		return true

		if not _structure_data.has(structure_name):
			push_warning("[LODSystem] Cannot focus unregistered structure: " + structure_name)
			return false

			_focus_structure = structure_name

			# Set priority for this structure
			_structure_priorities[structure_name] = StructurePriority.PRIMARY
			structure_priority_changed.emit(structure_name, StructurePriority.PRIMARY)

			# Force immediate update for focus structure
func update_thresholds(thresholds: Array) -> bool:
	"""Update distance thresholds for LOD levels"""
	if thresholds.size() < MAX_LOD_LEVELS - 1:
		push_warning(
		"[LODSystem] Not enough thresholds provided. Need at least " + str(MAX_LOD_LEVELS - 1)
		)
		return false

		# Validate thresholds are in ascending order
		for i in range(1, thresholds.size()):
			if thresholds[i] <= thresholds[i - 1]:
				push_warning("[LODSystem] Thresholds must be in ascending order")
				return false

				distance_thresholds = thresholds

				# Force update all structures
				_update_lod_state()

				print("[LODSystem] Updated distance thresholds")
				return true


				## Set educational focus bias
				## @param bias: float bias value (0.0-1.0)
				## @returns: bool indicating success
func set_educational_focus_bias(bias: float) -> bool:
	"""Set how strongly the system prioritizes educational focus structures"""
	educational_focus_bias = clamp(bias, 0.0, 1.0)

	# Update LOD state to reflect new bias
	_update_lod_state()

	print("[LODSystem] Updated educational focus bias: %.2f" % educational_focus_bias)
	return true


	## Update memory management strategy
	## @param strategy: int memory strategy (0=Aggressive, 1=Balanced, 2=Quality)
	## @returns: bool indicating success
func update_memory_strategy(strategy: int) -> bool:
	"""Update memory management strategy"""
	if strategy < 0 or strategy > 2:
		push_warning("[LODSystem] Invalid memory strategy: " + str(strategy))
		return false

		memory_strategy = strategy

		# Apply new memory strategy
		_apply_memory_strategy()

		print("[LODSystem] Updated memory strategy to: " + _get_strategy_name(strategy))
		return true


		## Get structure information
		## @param structure_name: String name of the structure
		## @returns: Dictionary with structure information
func get_structure_info(structure_name: String) -> Dictionary:
	"""Get information about a managed structure"""
	if not _structure_data.has(structure_name):
		return {}

func get_system_metrics() -> Dictionary:
	"""Get LOD system performance metrics"""
	return _performance_metrics.duplicate()


	## Force LOD update for all structures
	## @returns: bool indicating success
func force_update() -> bool:
	"""Force LOD update for all structures"""
	return _update_lod_state()


	## Reset all structures to highest detail
	## @returns: bool indicating success
func reset_to_highest_detail() -> bool:
	"""Reset all structures to highest detail level"""
	for structure_name in _structure_data:
		set_lod_level(structure_name, 0, true)

		print("[LODSystem] Reset all structures to highest detail")
		return true


		## Get managed structure names
		## @returns: Array of structure names
func get_managed_structure_names() -> Array:
	"""Get list of all managed structure names"""
	return _structure_data.keys()


	# === PRIVATE METHODS ===
func reset_cache() -> bool:
	"""Reset mesh cache to free memory"""
	_mesh_cache.clear()
	print("[LODSystem] Mesh cache cleared")
	return true


	## Pre-cache LOD meshes for a structure
	## @param structure_name: String name of the structure
	## @param levels: Array of int levels to cache (empty for all)
	## @returns: bool indicating success
func precache_structure(structure_name: String, levels: Array = []) -> bool:
	"""Pre-cache LOD meshes for a structure"""
	if not _structure_data.has(structure_name):
		push_warning("[LODSystem] Cannot precache unregistered structure: " + structure_name)
		return false

func configure_for_educational_scene(is_educational: bool) -> bool:
	"""Configure LOD system for educational or performance focus"""
	if is_educational:
		# Educational focus - prioritize quality for educational structures
		educational_focus_bias = 0.8  # Strong educational bias
		auto_optimize_enabled = true  # Enable auto-optimization
		smooth_transitions = true  # Enable smooth transitions
		else:
			# Performance focus - optimize for frame rate
			educational_focus_bias = 0.4  # Moderate educational bias
			auto_optimize_enabled = true  # Enable auto-optimization
			smooth_transitions = true  # Keep smooth transitions

			_update_lod_state()
			print(
			"[LODSystem] Configured for %s mode" % ("educational" if is_educational else "performance")
			)
			return true

if _initialized:
	_update_lod_state()

	## Distance thresholds for LOD levels (in world units)
print(
"[LODSystemEnhanced] Initialized with educational focus bias: %.2f" % educational_focus_bias
)


if not structure_data.root_node or not structure_data.root_node.is_inside_tree():
	continue

	# Get distance and calculate target LOD
if target_lod != _current_lod_levels.get(structure_name, 0):
	_switch_lod_level(structure_name, target_lod)


	# === PUBLIC METHODS ===
	## Register a structure for LOD management
	## @param structure: Node3D root node of the structure
	## @param structure_name: String name of the structure
	## @param lod_variants: Array of PackedScene LOD variants (optional)
	## @returns: bool indicating success
if structure_data.has_variants:
	# Add variant data
	pass
	else:
		# Generate simplified meshes or use cached versions
		_generate_simplified_meshes(structure_data, structure_name)

		# Add to managed structures
		_structure_data[structure_name] = structure_data
		_current_lod_levels[structure_name] = 0  # Start at highest detail

		# Set initial priority (default to BACKGROUND)
		_structure_priorities[structure_name] = StructurePriority.BACKGROUND

		print("[LODSystem] Registered structure: " + structure_name)
		return true


		## Unregister a structure from LOD management
		## @param structure_name: String name of the structure
		## @returns: bool indicating success
if _current_lod_levels.get(structure_name, 0) != 0:
	_restore_original_meshes(structure_data)

	# Clear any active transitions
	if _transition_tweens.has(structure_name):
if tween and tween.is_valid():
	tween.kill()
	_transition_tweens.erase(structure_name)

	# Remove from managed structures
	_structure_data.erase(structure_name)
	_current_lod_levels.erase(structure_name)
	_structure_priorities.erase(structure_name)
	_cached_structure_distances.erase(structure_name)

	print("[LODSystem] Unregistered structure: " + structure_name)
	return true


	## Set LOD level manually for a structure
	## @param structure_name: String name of the structure
	## @param lod_level: int LOD level to set
	## @param force_instant: bool whether to force instant transition
	## @returns: bool indicating success
print("[LODSystem] Updated priority for %s: %d" % [structure_name, priority])
return true


## Set educational focus structure
## @param structure_name: String name of the focus structure
## @returns: bool indicating success
print("[LODSystem] Set focus structure: " + structure_name)
return true


## Update distance thresholds
## @param thresholds: Array of float distance thresholds
## @returns: bool indicating success
for level in range(1, MAX_LOD_LEVELS):
	if structure.lod_meshes.has(level):
		info.vertex_reduction[level] = _calculate_vertex_reduction(structure, level)

		return info


		## Get LOD system metrics
		## @returns: Dictionary with system metrics
if not cameras.is_empty():
	return cameras[0]

	# Try to find by node path
for path in camera_paths:
	if get_node_or_null(path) != null:
		return get_node(path)

		push_warning("[LODSystem] No camera found. LOD system needs a camera reference.")
		return null


if not structure.root_node or not structure.root_node.is_inside_tree():
	continue

if model is MeshInstance3D and model.mesh != null:
return camera.global_position.distance_to(model_pos)


if priority != StructurePriority.BACKGROUND:
for i in range(distance_thresholds.size()):
	if effective_distance < distance_thresholds[i]:
		return i

		return min(distance_thresholds.size(), MAX_LOD_LEVELS - 1)


if current_level == level:
	return true  # Already at this level

	# Calculate time since last change (for rate limiting)
if not force_instant and time_since_change < 0.1:
	return false  # Too soon since last change

	# Cancel any active transition
	if _transition_tweens.has(structure_name):
if tween and tween.is_valid():
	tween.kill()
	_transition_tweens.erase(structure_name)

	# Determine transition approach
	if structure.has_variants:
		# Switch between variant models
		_switch_variant_model(structure, level)
		else:
			# Apply simplified meshes or transition between them
			if smooth_transitions and not force_instant:
				_transition_to_level(structure, structure_name, level)
				else:
					_apply_lod_level(structure, level)

					# Update current level and last change time
					_current_lod_levels[structure_name] = level
					structure.last_lod_change = time_now

					# Emit signal
					lod_level_changed.emit(structure_name, level)

					# Update performance metrics based on the change
					_calculate_performance_impact()

					return true


for child in node.get_children():
	_process_structure_node(child, mesh_dict)


if mesh is ArrayMesh:
	for surface_idx in range(mesh.get_surface_count()):
return count


for path_str in structure.original_meshes:
	original_count += structure.original_meshes[path_str].vertex_count

	# Sum vertices in LOD meshes
	for path_str in structure.lod_meshes[lod_level]:
		if structure.lod_meshes[lod_level][path_str].has("vertex_count"):
			lod_count += structure.lod_meshes[lod_level][path_str].vertex_count

			if original_count == 0:
				return 0.0

				return 1.0 - (float(lod_count) / original_count)


if _mesh_cache.has(cache_key):
	structure_data.lod_meshes = _mesh_cache[cache_key].duplicate(true)
	print("[LODSystem] Using cached LOD meshes for: " + structure_name)
	return

	# Generate LOD meshes for each level
	for level in range(1, MAX_LOD_LEVELS):
for node_path in original_meshes:
print("[LODSystem] Generated LOD meshes for: " + structure_name)


for surface_idx in range(original_mesh.get_surface_count()):
if vertex_count < 100:
	array_mesh.add_surface_from_arrays(
	original_mesh.surface_get_primitive_type(surface_idx), arrays
	)
	continue

	# Simplify by skipping vertices
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
for i in range(vertices.size()):
	vertex_map[i * stride] = i

	# Remap triangle indices
	for i in range(0, original_indices.size(), 3):
		if i + 2 < original_indices.size():
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
if material:
	array_mesh.surface_set_material(surface_idx, material)

	return array_mesh
	else:
		# For other mesh types, create a simplified placeholder
		return original_mesh


for node_path_str in lod_meshes:
if node and node is MeshInstance3D:
for i in range(mesh_data.materials.size()):
	if i < node.get_surface_override_material_count():
		node.set_surface_override_material(i, mesh_data.materials[i])


for node_path_str in original_meshes:
if node and node is MeshInstance3D:
for i in range(mesh_data.materials.size()):
	if i < node.get_surface_override_material_count():
		node.set_surface_override_material(i, mesh_data.materials[i])


if target_level == 0:
	_restore_original_meshes(structure_data)
	else:
		_apply_lod_level(structure_data, target_level)

		# If transitioning to higher detail, make it faster
if target_level < current_level:
	transition_duration *= 0.7

	# Apply material transition for all affected meshes
if target_level == 0:
	node_paths = structure_data.original_meshes.keys()
	else:
		node_paths = structure_data.lod_meshes[target_level].keys()

		for node_path_str in node_paths:
if node and node is MeshInstance3D:
	# Fade in the new LOD level
	if node.get_surface_override_material_count() > 0:
		for i in range(node.get_surface_override_material_count()):
if material is StandardMaterial3D:
	# Start with slight transparency
if not structure_data.has(variant_key):
if not structure.root_node or not structure.root_node.is_inside_tree():
	continue

if lod_enabled:
	_switch_lod_level(structure_name, target_lod, true)
	else:
		# Force highest detail if LOD is disabled
		_switch_lod_level(structure_name, 0, true)

		return true


for level in range(MAX_LOD_LEVELS):
	if (
	level != current_level
	and level != current_level - 1
	and level != current_level + 1
	):
		if structure.lod_meshes.has(level):
			structure.lod_meshes.erase(level)

			# Also clear mesh cache for structures not in focus
for structure_name in _structure_data:
if priority == StructurePriority.PRIMARY or priority == StructurePriority.SECONDARY:
	keep_keys.append(structure_name + "_lod_meshes")

for key in cached_keys:
	if not key in keep_keys:
		_mesh_cache.erase(key)

		1:  # Balanced
		# Default strategy, no special handling
		pass

		2:  # Quality
		# Ensure all LOD levels are loaded
		for structure_name in _structure_data:
for level in range(1, MAX_LOD_LEVELS):
	if not structure.lod_meshes.has(level):
if level < quality_reduction_factors.size()
else 0.25
)
for node_path in structure.original_meshes:
if not _mesh_cache.has(cache_key):
	_mesh_cache[cache_key] = {}
	_mesh_cache[cache_key][level] = lod_meshes


for time in _frame_times:
	avg_frame_time += time
	avg_frame_time /= _frame_times.size()
	_performance_metrics.avg_fps = 1.0 / avg_frame_time if avg_frame_time > 0 else 0
	else:
		_performance_metrics.avg_fps = Engine.get_frames_per_second()

		# Count structures at each detail level
for structure_name in _current_lod_levels:
for structure_name in _structure_data:
if current_level == 0:
	continue  # No savings for highest detail

	# Calculate vertex reduction
for path_str in structure.original_meshes:
	if structure.original_meshes[path_str].has("vertex_count"):
		original_vertex_count += structure.original_meshes[path_str].vertex_count

		# Rough estimate: 32 bytes per vertex (position, normal, uv, etc)
		memory_saved += int(original_vertex_count * reduction * 32)

		# Estimate draw call savings (1 per mesh that's been simplified significantly)
		if reduction > 0.5:  # If we've reduced by more than half
		draw_calls_saved += structure.original_meshes.size()

		_performance_metrics.memory_saved = memory_saved
		_performance_metrics.draw_calls_saved = draw_calls_saved


if current_fps < target_fps_min:
	# Performance is below target, increase LOD distance thresholds
	if current_fps < target_fps_min * 0.7:
		# Major performance issue, significant adjustment
		_scale_lod_thresholds(0.7)
		else:
			# Minor performance issue, slight adjustment
			_scale_lod_thresholds(0.9)
			elif current_fps > target_framerate * 1.2 and _are_thresholds_reduced():
				# Performance is well above target, reduce LOD distance thresholds
				_scale_lod_thresholds(1.1)  # Increase thresholds by 10%

				# Update structure LOD levels
				_update_lod_state()


for threshold in distance_thresholds:
	new_thresholds.append(threshold * scale_factor)

	# Update thresholds
	distance_thresholds = new_thresholds


if distance_thresholds.size() != default_thresholds.size():
	return true

	# Check if current thresholds are lower than defaults
	for i in range(default_thresholds.size()):
		if distance_thresholds[i] < default_thresholds[i]:
			return true

			return false


			# === INTEGRATION METHODS ===
			## Reset cache to free memory
			## @returns: bool indicating success
if not _mesh_cache.has(cache_key):
	_generate_simplified_meshes(structure, structure_name)
	print("[LODSystem] Precached LOD meshes for: " + structure_name)
	else:
		print("[LODSystem] LOD meshes already cached for: " + structure_name)

		return true


		## Update LOD settings for educational scene
		## @param is_educational: bool whether scene is in educational mode
		## @returns: bool indicating success

if not structure or not structure.is_inside_tree():
	push_warning("[LODSystem] Cannot register invalid structure: " + structure_name)
	return false

	# Initialize structure data
func _find_main_camera() -> Camera3D:
	"""Find the main camera in the scene"""
func _update_structure_distances() -> void:
	"""Update cached distances from camera to structures"""
	if not camera:
		return

		for structure_name in _structure_data:
func _calculate_structure_distance(model: Node3D) -> float:
	"""Calculate distance from camera to structure"""
	if not camera:
		return 0.0

		# Get model center position
func _determine_lod_level(distance: float, priority: StructurePriority) -> int:
	"""Determine appropriate LOD level based on distance and educational priority"""
	# Apply priority-based distance modification
func _switch_lod_level(structure_name: String, level: int, force_instant: bool = false) -> bool:
	"""Switch LOD level for a structure"""
	if not _structure_data.has(structure_name):
		return false

func _store_original_meshes(node: Node3D, structure_data: Dictionary) -> void:
	"""Store original meshes for reference and LOD generation"""
	# Recursively process structure hierarchy
	_process_structure_node(node, structure_data.original_meshes)


func _get_vertex_count(mesh: Mesh) -> int:
	"""Get vertex count from a mesh"""
func _calculate_vertex_reduction(structure: Dictionary, lod_level: int) -> float:
	"""Calculate vertex reduction percentage for a LOD level"""
	if not structure.lod_meshes.has(lod_level):
		return 0.0

func _generate_simplified_meshes(structure_data: Dictionary, structure_name: String) -> void:
	"""Generate simplified meshes for LOD levels with caching"""
func _simplify_mesh(original_mesh: Mesh, quality_factor: float) -> Mesh:
	"""Create a simplified version of a mesh"""
	# Use the existing implementation from LODManager
	if original_mesh is ArrayMesh:
func _apply_lod_level(structure_data: Dictionary, level: int) -> void:
	"""Apply LOD level meshes to a structure"""
	if level == 0:
		# Restore original meshes
		_restore_original_meshes(structure_data)
		return

		# Apply LOD meshes
		if not structure_data.lod_meshes.has(level):
			push_warning("[LODSystem] LOD level " + str(level) + " not available")
			return

func _restore_original_meshes(structure_data: Dictionary) -> void:
	"""Restore original meshes to a structure"""
func _transition_to_level(
	structure_data: Dictionary, structure_name: String, target_level: int
	) -> void:
		"""Smooth transition between LOD levels"""
func _switch_variant_model(structure_data: Dictionary, level: int) -> void:
	"""Switch to a different LOD variant model"""
	# Placeholder for variant-based LOD switching
	# In a real implementation, this would swap entire model variants
	push_warning("[LODSystem] Variant-based LOD switching not fully implemented")

	# For variant models, we would hide/show different versions
	if structure_data.lod_variants.size() > level:
func _update_lod_state() -> bool:
	"""Update LOD state for all structures"""
	if not camera:
		push_warning("[LODSystem] No camera reference. Cannot update LOD state.")
		return false

		# Update structure distances
		_update_structure_distances()

		# Update LOD for each structure
		for structure_name in _structure_data:
func _apply_memory_strategy() -> void:
	"""Apply memory management strategy"""
	match memory_strategy:
		0:  # Aggressive
		# Unload LOD meshes for distant structures
		for structure_name in _structure_data:
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


func _update_performance_metrics() -> void:
	"""Update performance metrics"""
	# Calculate FPS
	if not _frame_times.is_empty():
func _calculate_performance_impact() -> void:
	"""Calculate memory and draw call savings from LOD system"""
func _auto_optimize_lod_levels() -> void:
	"""Automatically adjust LOD parameters based on performance"""
	if not auto_optimize_enabled:
		return

func _scale_lod_thresholds(scale_factor: float) -> void:
	"""Scale LOD distance thresholds by a factor"""
func _are_thresholds_reduced() -> bool:
	"""Check if thresholds are currently reduced from defaults"""
