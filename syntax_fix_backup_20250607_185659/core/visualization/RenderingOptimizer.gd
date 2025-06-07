## RenderingOptimizer.gd
## Performance optimization system for brain visualization rendering
##
## Implements various optimization techniques including frustum culling,
## occlusion culling, material batching, and automatic LOD management.
##
## @tutorial: docs/dev/rendering-optimization.md
## @experimental: false

class_name RenderingOptimizer
extends Node

# === SIGNALS ===
## Emitted when optimization settings change
## @param setting_name: String name of the changed setting

signal optimization_setting_changed(setting_name: String)

## Emitted when optimization statistics are updated
## @param stats: Dictionary containing performance statistics
signal optimization_stats_updated(stats: Dictionary)

# === EXPORTS ===
## Enable frustum culling (hiding objects outside camera view)

@export var frustum_culling_enabled: bool = true:
	set(value):
		frustum_culling_enabled = value
		_update_culling_settings()
		optimization_setting_changed.emit("frustum_culling_enabled")

		## Enable occlusion culling (hiding objects behind other objects)
@export var occlusion_culling_enabled: bool = true:
	set(value):
		occlusion_culling_enabled = value
		_update_culling_settings()
		optimization_setting_changed.emit("occlusion_culling_enabled")

		## Enable material batching (reducing draw calls)
@export var material_batching_enabled: bool = true:
	set(value):
		material_batching_enabled = value
		_update_material_settings()
		optimization_setting_changed.emit("material_batching_enabled")

		## Occlusion culling depth (objects behind this many others are culled)
@export_range(1, 10, 1) var occlusion_depth: int = 3:
	set(value):
		occlusion_depth = value
		_update_culling_settings()
		optimization_setting_changed.emit("occlusion_depth")

		## Material batching threshold (materials with similar properties are batched)
@export_range(0.5, 1.0, 0.01) var material_similarity_threshold: float = 0.9:
	set(value):
		material_similarity_threshold = value
		_update_material_settings()
		optimization_setting_changed.emit("material_similarity_threshold")

		## Automatically enable LOD based on performance
@export var auto_lod_enabled: bool = true:
	set(value):
		auto_lod_enabled = value
		_update_lod_settings()
		optimization_setting_changed.emit("auto_lod_enabled")

		## Target framerate for automatic LOD adjustment
@export_range(30, 120, 5) var target_framerate: int = 60:
	set(value):
		target_framerate = value
		_update_lod_settings()
		optimization_setting_changed.emit("target_framerate")

		## Interval between optimization passes (seconds)
@export_range(0.1, 5.0, 0.1) var optimization_interval: float = 0.5:
	set(value):
		optimization_interval = value

var performance_stats: Dictionary = {
	"fps": 0,
	"draw_calls": 0,
	"visible_objects": 0,
	"culled_objects": 0,
	"batched_materials": 0,
	"lod_level": 0,
	"memory_usage": 0
	}

	# === PRIVATE VARIABLES ===
var mesh_instances = []
	_collect_mesh_instances(model, mesh_instances)

var needs_culling_update = false
var needs_material_update = false
var needs_lod_update = false

var stats = performance_stats.duplicate(true)

# Add additional detailed information
	stats["memory_usage_formatted"] = _format_memory_size(stats.memory_usage)
	stats["batched_material_groups"] = _batching_groups.size()
	stats["occlusion_groups"] = _occlusion_objects.size()
	stats["render_thread_time"] = Performance.get_monitor(Performance.RENDER_TOTAL_RENDER_TIME)
	stats["physics_thread_time"] = Performance.get_monitor(Performance.PHYSICS_TOTAL_PHYSICS_TIME)
	stats["frametime_avg"] = _calculate_average_frametime()

var cameras = get_tree().get_nodes_in_group("Cameras")
var camera_paths = [
	"/root/Main/Camera3D", "/root/Main/CameraRig/Camera3D", "/root/Node3D/Camera3D"
	]

var lod_nodes = get_tree().get_nodes_in_group("LODManagers")
var nodes = get_tree().get_nodes_in_group("autoload")
var mesh_instances_2 = []
	_collect_mesh_instances(get_tree().root, mesh_instances)

	_scene_objects = mesh_instances
	_visible_objects = mesh_instances.duplicate()

var initial_level = 0
var frustum = _camera.get_frustum()
var culled_count = 0

var aabb = obj.mesh.get_aabb()
var global_aabb = AABB(
	obj.global_transform * aabb.position, obj.global_transform.basis * aabb.size
	)

	# Check if object is within frustum
var in_frustum = false
var plane = frustum[i]
var sorted_groups = []
var group = _occlusion_objects[group_name]
var center = group.center
var distance = _camera.global_position.distance_to(center)

	sorted_groups.append({"name": group_name, "distance": distance, "group": group})

	# Sort by distance (closest to farthest)
	sorted_groups.sort_custom(func(a, b): return a.distance < b.distance)

	# Apply occlusion (hide objects beyond occlusion_depth)
var visible_groups = occlusion_depth
var current_group = 0

var group_2 = group_data.group
var is_visible = current_group < visible_groups

# Update visibility of all objects in this group
var parent = obj.get_parent()
var group_name = "default"
var priority = 0

# Try to find a meaningful parent name
var group_3 = _occlusion_objects[group_name]
var center_2 = Vector3.ZERO

var material_groups = {}

var material = obj.get_surface_override_material(i)
var signature = _generate_material_signature(material)

# Check if similar material already exists
var found_group = false
var group_4 = material_groups[group_id]
var group_id = str(signature.hash())
	material_groups[group_id] = {
	"signature": signature,
	"materials": [material],
	"meshes": [{"mesh": obj, "surface_idx": i}],
	"batched_material": null
	}

	# Create batched materials for groups with multiple materials
var group_5 = material_groups[group_id]
var batched_material = _create_batched_material(group.materials)
	group.batched_material = batched_material

	# Apply to all meshes in group
var affected_meshes = []
var original_materials = []

var mesh = mesh_info.mesh
var surface_idx = mesh_info.surface_idx

var material_groups_2 = {}

var material_2 = obj.get_surface_override_material(i)
var signature_2 = _generate_material_signature(material)

# Check if similar material already exists
var found_group_2 = false
var group_6 = material_groups[group_id]
var group_id_2 = model_name + "_" + str(signature.hash())
	material_groups[group_id] = {
	"signature": signature,
	"materials": [material],
	"meshes": [{"mesh": obj, "surface_idx": i}],
	"batched_material": null
	}

	# Create batched materials for groups with multiple materials
var group_7 = material_groups[group_id]
var batched_material_2 = _create_batched_material(group.materials)
	group.batched_material = batched_material

	# Apply to all meshes in group
var affected_meshes_2 = []
var original_materials_2 = []

var mesh_2 = mesh_info.mesh
var surface_idx_2 = mesh_info.surface_idx

var priority_2 = 0

# Determine priority based on name
var center_3 = Vector3.ZERO
var signature_3 = {}

var params = []
# In a complete implementation, we would enumerate shader parameters
	signature.param_count = 0  # Placeholder

var param_similarity = (
	1.0 - abs(sig1.param_count - sig2.param_count) / max(sig1.param_count, 1.0)
	)
var matches = 0
var total = 0

# Essential properties
var distance_2 = color1.distance_to(color2)
var base_material = materials[0]

var batched = StandardMaterial3D.new()

# Copy key properties
	batched.albedo_color = base_material.albedo_color
	batched.metallic = base_material.metallic
	batched.roughness = base_material.roughness
	batched.emission_enabled = base_material.emission_enabled

var batched_2 = ShaderMaterial.new()
	batched.shader = base_material.shader

	# Copy parameters
var avg_frame_time = _calculate_average_frametime()
	performance_stats.fps = 1.0 / avg_frame_time if avg_frame_time > 0 else 0
	performance_stats.fps = Engine.get_frames_per_second()

	# Get draw calls
	performance_stats.draw_calls = Performance.get_monitor(
	Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME
	)

	# Count visible objects
var visible_count = 0
var sum = 0.0
var current_fps = performance_stats.fps
var target_fps_min = target_framerate * 0.9  # 90% of target

# Determine if LOD adjustment is needed
var models = _lod_manager.get_method("get_managed_model_names")
var model_names = models.call()
var update_method = _lod_manager.get_method("force_update")

var _scene_objects: Array = []
var _visible_objects: Array = []
var _batched_materials: Dictionary = {}
var _occlusion_objects: Dictionary = {}
var _optimization_timer: Timer
var _lod_manager: LODManager
var _initialized: bool = false
var _camera: Camera3D
var _last_auto_lod_adjustment: float = 0
var _frame_times: Array = []
var _culling_info: Dictionary = {}
var _batching_groups: Dictionary = {}


# === LIFECYCLE METHODS ===

func _ready() -> void:
	"""Initialize the rendering optimizer"""
	_setup_timers()

	# Find camera and LOD manager if available
	_find_dependencies()

	# Initial optimization scan
	_collect_scene_objects()
	_update_culling_settings()
	_update_material_settings()
	_update_lod_settings()

	_initialized = true
	print("[RenderingOptimizer] Initialized with " + str(_scene_objects.size()) + " objects")


func _process(delta: float) -> void:
	"""Update optimization in real-time"""
	if not _initialized:
		return

		# Track frame times for FPS calculation
		_frame_times.append(delta)
		if _frame_times.size() > 60:
			_frame_times.remove_at(0)

			# Update performance stats every frame
			_update_performance_stats()

			# Automatic LOD adjustment if enabled (less frequent than other optimizations)
			if auto_lod_enabled and (_last_auto_lod_adjustment + 1.0) < Time.get_ticks_msec() / 1000.0:
				_adjust_lod_based_on_performance()
				_last_auto_lod_adjustment = Time.get_ticks_msec() / 1000.0


				# === PUBLIC METHODS ===
				## Optimize a specific model for rendering
				## @param model: Node3D root node of the model
				## @param model_name: String name of the model
				## @returns: bool indicating success

func optimize_model(model: Node3D, model_name: String) -> bool:
	"""Apply optimization techniques to a specific model"""
	if not _initialized or not model or not model.is_inside_tree():
		return false

func force_optimization_update() -> bool:
	"""Force an immediate optimization update"""
	if not _initialized:
		return false

		_optimization_update()
		return true


		## Update optimization settings
		## @param settings: Dictionary of settings to update
		## @returns: bool indicating success
func update_settings(settings: Dictionary) -> bool:
	"""Update multiple optimization settings at once"""
func get_detailed_stats() -> Dictionary:
	"""Get detailed performance statistics"""
func reset_optimizations() -> bool:
	"""Reset all optimizations to default state"""
	if not _initialized:
		return false

		# Clear batched materials
		for material_group in _batched_materials.values():
			for mesh_instance in material_group.affected_meshes:
				if mesh_instance and mesh_instance.is_inside_tree():
					for i in range(material_group.original_materials.size()):
						if i < mesh_instance.get_surface_override_material_count():
							mesh_instance.set_surface_override_material(
							i, material_group.original_materials[i]
							)

							_batched_materials.clear()
							_batching_groups.clear()

							# Reset visibility of all objects
							for obj in _scene_objects:
								if obj and obj.is_inside_tree():
									obj.visible = true

									_occlusion_objects.clear()
									_culling_info.clear()

									# Reset LOD if available
									if _lod_manager:
										_lod_manager.reset_to_highest_detail()

										# Re-collect scene objects
										_collect_scene_objects()

										# Re-apply optimizations with default settings
										_update_culling_settings()
										_update_material_settings()
										_update_lod_settings()

										print("[RenderingOptimizer] Reset all optimizations to default state")
										return true


										# === PRIVATE METHODS ===

func _fix_orphaned_code():
	if _optimization_timer:
		_optimization_timer.wait_time = optimization_interval
		optimization_setting_changed.emit("optimization_interval")

		# === PUBLIC VARIABLES ===
		## Current performance statistics

func _fix_orphaned_code():
	if mesh_instances.is_empty():
		push_warning("[RenderingOptimizer] No mesh instances found in model: " + model_name)
		return false

		# Apply material batching if enabled
		if material_batching_enabled:
			_batch_model_materials(mesh_instances, model_name)

			# Set up occlusion and frustum culling data
			if occlusion_culling_enabled or frustum_culling_enabled:
				_setup_culling_for_model(model, mesh_instances, model_name)

				# Update object lists
				for mesh in mesh_instances:
					if not _scene_objects.has(mesh):
						_scene_objects.append(mesh)

						print(
						(
						"[RenderingOptimizer] Optimized model: "
						+ model_name
						+ " with "
						+ str(mesh_instances.size())
						+ " meshes"
						)
						)
						return true


						## Force immediate optimization update
						## @returns: bool indicating success
func _fix_orphaned_code():
	if settings.has("frustum_culling_enabled"):
		frustum_culling_enabled = settings.frustum_culling_enabled
		needs_culling_update = true

		if settings.has("occlusion_culling_enabled"):
			occlusion_culling_enabled = settings.occlusion_culling_enabled
			needs_culling_update = true

			if settings.has("material_batching_enabled"):
				material_batching_enabled = settings.material_batching_enabled
				needs_material_update = true

				if settings.has("occlusion_depth"):
					occlusion_depth = settings.occlusion_depth
					needs_culling_update = true

					if settings.has("material_similarity_threshold"):
						material_similarity_threshold = settings.material_similarity_threshold
						needs_material_update = true

						if settings.has("auto_lod_enabled"):
							auto_lod_enabled = settings.auto_lod_enabled
							needs_lod_update = true

							if settings.has("target_framerate"):
								target_framerate = settings.target_framerate
								needs_lod_update = true

								if settings.has("optimization_interval"):
									optimization_interval = settings.optimization_interval
									if _optimization_timer:
										_optimization_timer.wait_time = optimization_interval

										# Apply changes if needed
										if needs_culling_update:
											_update_culling_settings()

											if needs_material_update:
												_update_material_settings()

												if needs_lod_update:
													_update_lod_settings()

													return true


													## Get detailed performance statistics
													## @returns: Dictionary with detailed performance data
func _fix_orphaned_code():
	return stats


	## Reset all optimizations to default state
	## @returns: bool indicating success
func _fix_orphaned_code():
	if not cameras.is_empty():
		_camera = cameras[0]
		else:
			# Try to find camera by node path
func _fix_orphaned_code():
	for path in camera_paths:
		if get_node_or_null(path) != null:
			_camera = get_node(path)
			break

			if not _camera:
				push_warning("[RenderingOptimizer] No camera found. Some optimizations will be limited.")

				# Find LOD manager
func _fix_orphaned_code():
	if not lod_nodes.is_empty():
		_lod_manager = lod_nodes[0]
		else:
			# Try to find LOD manager by node path or type
func _fix_orphaned_code():
	for node in nodes:
		if node is LODManager:
			_lod_manager = node
			break

			if not _lod_manager:
				push_warning(
				"[RenderingOptimizer] No LOD manager found. LOD optimizations will be disabled."
				)


func _fix_orphaned_code():
	print("[RenderingOptimizer] Collected " + str(_scene_objects.size()) + " scene objects")


func _fix_orphaned_code():
	if _scene_objects.size() > 200:
		initial_level = 1
		if _scene_objects.size() > 500:
			initial_level = 2

			_adjust_lod_level(initial_level)
			else:
				# Reset to highest detail
				_adjust_lod_level(0)


func _fix_orphaned_code():
	for obj in _scene_objects:
		if not obj or not obj.is_inside_tree() or not obj is MeshInstance3D or not obj.mesh:
			continue

			# Skip objects already hidden by other optimizations
			if _culling_info.has(obj) and _culling_info[obj].hidden_by != "":
				continue

				# Get object bounds
func _fix_orphaned_code():
	for i in range(frustum.size()):
func _fix_orphaned_code():
	if plane.is_point_over(global_aabb.get_center()):
		in_frustum = true
		break

		# Update visibility
		if not in_frustum:
			obj.visible = false
			culled_count += 1

			# Update culling info
			if not _culling_info.has(obj):
				_culling_info[obj] = {"hidden_by": "frustum", "distance": 0.0, "priority": 0}
				else:
					_culling_info[obj].hidden_by = "frustum"
					elif _culling_info.has(obj) and _culling_info[obj].hidden_by == "frustum":
						obj.visible = true
						_culling_info[obj].hidden_by = ""

						# Update stats
						performance_stats.culled_objects = culled_count


func _fix_orphaned_code():
	for group_name in _occlusion_objects:
func _fix_orphaned_code():
	for group_data in sorted_groups:
func _fix_orphaned_code():
	for obj in group.objects:
		if not obj or not obj.is_inside_tree():
			continue

			# Skip objects already hidden by frustum culling
			if _culling_info.has(obj) and _culling_info[obj].hidden_by == "frustum":
				continue

				if is_visible:
					obj.visible = true
					if _culling_info.has(obj) and _culling_info[obj].hidden_by == "occlusion":
						_culling_info[obj].hidden_by = ""
						else:
							obj.visible = false

							# Update culling info
							if not _culling_info.has(obj):
								_culling_info[obj] = {
								"hidden_by": "occlusion",
								"distance": group_data.distance,
								"priority": group.priority
								}
								else:
									_culling_info[obj].hidden_by = "occlusion"
									_culling_info[obj].distance = group_data.distance

									current_group += 1


func _fix_orphaned_code():
	while parent:
		if (
		parent.name.contains("Model")
		or parent.name.contains("Brain")
		or parent.name.contains("Structure")
		):
			group_name = parent.name
			break
			parent = parent.get_parent()

			# Assign priority based on naming
			if obj.name.to_lower().contains("important") or group_name.to_lower().contains("important"):
				priority = 10
				elif obj.name.to_lower().contains("major") or group_name.to_lower().contains("major"):
					priority = 5

					# Add to occlusion group
					if not _occlusion_objects.has(group_name):
						_occlusion_objects[group_name] = {
						"objects": [], "center": Vector3.ZERO, "priority": priority
						}

						_occlusion_objects[group_name].objects.append(obj)

						# Calculate center point for each group
						for group_name in _occlusion_objects:
func _fix_orphaned_code():
	for obj in group.objects:
		center += obj.global_position

		if not group.objects.is_empty():
			center /= group.objects.size()

			group.center = center


func _fix_orphaned_code():
	for obj in _scene_objects:
		if not obj or not obj.is_inside_tree() or not obj is MeshInstance3D:
			continue

			for i in range(obj.get_surface_override_material_count()):
func _fix_orphaned_code():
	if not material:
		continue

		# Generate material signature for similarity comparison
func _fix_orphaned_code():
	for group_id in material_groups:
func _fix_orphaned_code():
	if (
	_compare_material_signatures(signature, group.signature)
	>= material_similarity_threshold
	):
		group.materials.append(material)
		group.meshes.append({"mesh": obj, "surface_idx": i})
		found_group = true
		break

		# Create new group if no similar material found
		if not found_group:
func _fix_orphaned_code():
	for group_id in material_groups:
func _fix_orphaned_code():
	if group.materials.size() < 2:
		continue  # Skip groups with only one material

		# Create batched material
func _fix_orphaned_code():
	for mesh_info in group.meshes:
func _fix_orphaned_code():
	if not mesh or not mesh.is_inside_tree():
		continue

		# Store original material for later restoration
		original_materials.append(mesh.get_surface_override_material(surface_idx))

		# Apply batched material
		mesh.set_surface_override_material(surface_idx, batched_material)
		affected_meshes.append(mesh)

		# Store batching information
		_batched_materials[group_id] = {
		"batched_material": batched_material,
		"affected_meshes": affected_meshes,
		"original_materials": original_materials
		}

		# Update statistics
		_batching_groups[group_id] = {
		"material_count": group.materials.size(), "mesh_count": affected_meshes.size()
		}


func _fix_orphaned_code():
	for obj in mesh_instances:
		if not obj or not obj.is_inside_tree() or not obj is MeshInstance3D:
			continue

			for i in range(obj.get_surface_override_material_count()):
func _fix_orphaned_code():
	if not material:
		continue

		# Generate material signature for similarity comparison
func _fix_orphaned_code():
	for group_id in material_groups:
func _fix_orphaned_code():
	if (
	_compare_material_signatures(signature, group.signature)
	>= material_similarity_threshold
	):
		group.materials.append(material)
		group.meshes.append({"mesh": obj, "surface_idx": i})
		found_group = true
		break

		# Create new group if no similar material found
		if not found_group:
func _fix_orphaned_code():
	for group_id in material_groups:
func _fix_orphaned_code():
	if group.materials.size() < 2:
		continue  # Skip groups with only one material

		# Create batched material
func _fix_orphaned_code():
	for mesh_info in group.meshes:
func _fix_orphaned_code():
	if not mesh or not mesh.is_inside_tree():
		continue

		# Store original material for later restoration
		original_materials.append(mesh.get_surface_override_material(surface_idx))

		# Apply batched material
		mesh.set_surface_override_material(surface_idx, batched_material)
		affected_meshes.append(mesh)

		# Store batching information
		_batched_materials[group_id] = {
		"batched_material": batched_material,
		"affected_meshes": affected_meshes,
		"original_materials": original_materials
		}

		# Update statistics
		_batching_groups[group_id] = {
		"material_count": group.materials.size(), "mesh_count": affected_meshes.size()
		}


func _fix_orphaned_code():
	if model_name.to_lower().contains("important"):
		priority = 10
		elif model_name.to_lower().contains("major"):
			priority = 5

			# Calculate center point
func _fix_orphaned_code():
	for obj in mesh_instances:
		center += obj.global_position
		center /= mesh_instances.size()

		# Add to occlusion groups
		_occlusion_objects[model_name] = {
		"objects": mesh_instances.duplicate(), "center": center, "priority": priority
		}


func _fix_orphaned_code():
	if material is StandardMaterial3D:
		# Add properties that identify the material
		signature.albedo_color = material.albedo_color
		signature.metallic = material.metallic
		signature.roughness = material.roughness
		signature.emission_enabled = material.emission_enabled

		if material.emission_enabled:
			signature.emission = material.emission

			signature.transparency = material.transparency
			signature.cull_mode = material.cull_mode

			# Additional properties for more specific matching
			if material.normal_enabled:
				signature.normal_enabled = true

				if material.subsurf_scatter_enabled:
					signature.subsurf_scatter_enabled = true

					elif material is ShaderMaterial:
						# For shader materials, use shader and parameter count as signature
						signature.shader = material.shader

func _fix_orphaned_code():
	return signature


func _fix_orphaned_code():
	return param_similarity

	# For standard materials, check key properties
func _fix_orphaned_code():
	if sig1.transparency == sig2.transparency:
		matches += 1
		total += 1

		if sig1.cull_mode == sig2.cull_mode:
			matches += 1
			total += 1

			# Compare colors with tolerance
			if _colors_similar(sig1.albedo_color, sig2.albedo_color):
				matches += 1
				total += 1

				# Compare numeric properties with tolerance
				if abs(sig1.metallic - sig2.metallic) < 0.1:
					matches += 1
					total += 1

					if abs(sig1.roughness - sig2.roughness) < 0.1:
						matches += 1
						total += 1

						# Compare boolean properties
						if sig1.emission_enabled == sig2.emission_enabled:
							matches += 1

							if sig1.emission_enabled and sig2.emission_enabled:
								if _colors_similar(sig1.emission, sig2.emission):
									matches += 1
									total += 1
									total += 1

									# Optional properties
									if sig1.has("normal_enabled") == sig2.has("normal_enabled"):
										matches += 1
										total += 1

										if sig1.has("subsurf_scatter_enabled") == sig2.has("subsurf_scatter_enabled"):
											matches += 1
											total += 1

											return float(matches) / total


func _fix_orphaned_code():
	return distance < 0.2


func _fix_orphaned_code():
	if base_material is StandardMaterial3D:
func _fix_orphaned_code():
	if base_material.emission_enabled:
		batched.emission = base_material.emission
		batched.emission_energy_multiplier = base_material.emission_energy_multiplier

		batched.transparency = base_material.transparency
		batched.cull_mode = base_material.cull_mode

		return batched
		elif base_material is ShaderMaterial:
			# For shader materials, create a duplicate
func _fix_orphaned_code():
	for param in base_material.get_shader_parameter_list():
		batched.set_shader_parameter(param, base_material.get_shader_parameter(param))

		return batched

		return base_material


func _fix_orphaned_code():
	for obj in _scene_objects:
		if obj and obj.is_inside_tree() and obj.visible:
			visible_count += 1

			performance_stats.visible_objects = visible_count
			performance_stats.culled_objects = _scene_objects.size() - visible_count

			# Count batched materials
			performance_stats.batched_materials = _batched_materials.size()

			# Get LOD level if available
			if _lod_manager:
				# In a real implementation, we would get the average LOD level
				# For now, use a placeholder
				performance_stats.lod_level = 0

				# Get memory usage
				performance_stats.memory_usage = (
				Performance.get_monitor(Performance.MEMORY_STATIC)
				+ Performance.get_monitor(Performance.MEMORY_DYNAMIC)
				)

				# Emit signal
				optimization_stats_updated.emit(performance_stats)


func _fix_orphaned_code():
	for time in _frame_times:
		sum += time

		return sum / _frame_times.size()


func _fix_orphaned_code():
	if current_fps < target_fps_min:
		# Performance is below target, increase LOD level (reduce quality)
		if current_fps < target_fps_min * 0.7:
			# Significant performance issue, jump to higher LOD
			_adjust_lod_level(2)
			else:
				_adjust_lod_level(1)
				elif current_fps > target_framerate * 1.2 and performance_stats.lod_level > 0:
					# Performance is well above target, decrease LOD level (increase quality)
					_adjust_lod_level(performance_stats.lod_level - 1)


func _fix_orphaned_code():
	if models:
func _fix_orphaned_code():
	for model_name in model_names:
		_lod_manager.set_lod_level(model_name, level)

		# Otherwise try to apply globally
		else:
			# Force update LOD level
func _fix_orphaned_code():
	if update_method:
		update_method.call()

		performance_stats.lod_level = level


func _setup_timers() -> void:
	"""Set up optimization timer"""
	_optimization_timer = Timer.new()
	_optimization_timer.wait_time = optimization_interval
	_optimization_timer.autostart = true
	_optimization_timer.timeout.connect(_on_optimization_timer_timeout)
	add_child(_optimization_timer)


func _find_dependencies() -> void:
	"""Find camera and LOD manager in the scene"""
	# Find camera
func _collect_scene_objects() -> void:
	"""Collect all relevant objects in the scene for optimization"""
	_scene_objects.clear()

	# Find all mesh instances in the scene
func _collect_mesh_instances(node: Node, result: Array) -> void:
	"""Recursively collect all mesh instances in the scene"""
	if node is MeshInstance3D and node.visible:
		if node.mesh:
			result.append(node)

			for child in node.get_children():
				_collect_mesh_instances(child, result)


func _update_culling_settings() -> void:
	"""Update culling settings for all objects"""
	if not _initialized:
		return

		# Reset culling state
		for obj in _scene_objects:
			if obj and obj.is_inside_tree():
				obj.visible = true

				_visible_objects = _scene_objects.duplicate()

				# Skip if both culling methods disabled
				if not frustum_culling_enabled and not occlusion_culling_enabled:
					return

					# Organize objects by model if needed for occlusion culling
					if occlusion_culling_enabled:
						_organize_occlusion_objects()


func _update_material_settings() -> void:
	"""Update material batching settings"""
	if not _initialized:
		return

		# Clear existing batched materials
		for material_group in _batched_materials.values():
			for mesh_instance in material_group.affected_meshes:
				if mesh_instance and mesh_instance.is_inside_tree():
					for i in range(material_group.original_materials.size()):
						if i < mesh_instance.get_surface_override_material_count():
							mesh_instance.set_surface_override_material(
							i, material_group.original_materials[i]
							)

							_batched_materials.clear()
							_batching_groups.clear()

							# Skip if batching disabled
							if not material_batching_enabled:
								return

								# Apply material batching to all objects
								_batch_scene_materials()


func _update_lod_settings() -> void:
	"""Update LOD settings"""
	if not _initialized or not _lod_manager:
		return

		# Configure LOD manager
		_lod_manager.lod_enabled = auto_lod_enabled

		if auto_lod_enabled:
			# Initial LOD level based on object count
func _on_optimization_timer_timeout() -> void:
	"""Regular optimization update"""
	_optimization_update()


func _optimization_update() -> void:
	"""Perform optimization update"""
	if not _initialized:
		return

		# Update culling
		if frustum_culling_enabled and _camera:
			_perform_frustum_culling()

			if occlusion_culling_enabled and _camera:
				_perform_occlusion_culling()

				# Update statistics
				_update_performance_stats()


func _perform_frustum_culling() -> void:
	"""Perform frustum culling to hide objects outside camera view"""
	if not _camera:
		return

func _perform_occlusion_culling() -> void:
	"""Perform occlusion culling to hide objects behind other objects"""
	if not _camera or not _occlusion_objects:
		return

		# Sort objects by distance from camera
func _organize_occlusion_objects() -> void:
	"""Organize objects into groups for occlusion culling"""
	_occlusion_objects.clear()

	# Group objects by parent model
	for obj in _scene_objects:
		if not obj or not obj.is_inside_tree() or not obj is MeshInstance3D:
			continue

			# Find parent model
func _batch_scene_materials() -> void:
	"""Apply material batching to the scene"""
	# Group materials by properties
func _batch_model_materials(mesh_instances: Array, model_name: String) -> void:
	"""Apply material batching to a specific model"""
	# Group materials by properties
func _setup_culling_for_model(model: Node3D, mesh_instances: Array, model_name: String) -> void:
	"""Set up culling for a specific model"""
	if mesh_instances.is_empty():
		return

		# Add to occlusion objects if occlusion culling enabled
		if occlusion_culling_enabled:
func _generate_material_signature(material: Material) -> Dictionary:
	"""Generate a signature to compare material properties"""
func _compare_material_signatures(sig1: Dictionary, sig2: Dictionary) -> float:
	"""Compare material signatures and return similarity (0.0-1.0)"""
	# For different material types, no similarity
	if sig1.has("shader") != sig2.has("shader"):
		return 0.0

		# For shader materials, check shader equality
		if sig1.has("shader"):
			if sig1.shader != sig2.shader:
				return 0.0

				# Simple comparison based on parameter count
func _colors_similar(color1: Color, color2: Color) -> bool:
	"""Check if two colors are similar within a threshold"""
func _create_batched_material(materials: Array) -> Material:
	"""Create a batched material from a group of similar materials"""
	# In a complete implementation, this would create an optimized material
	# For now, we'll use the first material as representative
func _update_performance_stats() -> void:
	"""Update performance statistics"""
	# Calculate FPS
	if not _frame_times.is_empty():
func _calculate_average_frametime() -> float:
	"""Calculate average frametime from recent frames"""
	if _frame_times.is_empty():
		return 0.0

func _adjust_lod_based_on_performance() -> void:
	"""Automatically adjust LOD level based on performance"""
	if not _lod_manager or not auto_lod_enabled:
		return

func _adjust_lod_level(level: int) -> void:
	"""Adjust LOD level if different from current"""
	if not _lod_manager:
		return

		if level != performance_stats.lod_level:
			# Apply to all models
func _format_memory_size(bytes: int) -> String:
	"""Format memory size for display"""
	if bytes < 1024:
		return str(bytes) + " B"
		elif bytes < 1024 * 1024:
			return str(bytes / 1024.0).pad_decimals(2) + " KB"
			elif bytes < 1024 * 1024 * 1024:
				return str(bytes / (1024.0 * 1024.0)).pad_decimals(2) + " MB"
				else:
					return str(bytes / (1024.0 * 1024.0 * 1024.0)).pad_decimals(2) + " GB"
