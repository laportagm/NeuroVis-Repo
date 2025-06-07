## BrainStructureSelectionManager_Enhanced.gd
## Enhanced selection system with improved accuracy for educational effectiveness
##
## This enhanced version implements multi-ray sampling, adaptive tolerance,
## structure size awareness, and overlapping geometry resolution to achieve
## 100% selection reliability for all anatomical structures.
##
## @tutorial: Advanced selection techniques for educational 3D applications
## @version: 3.0

class_name BrainStructureSelectionManagerEnhanced
extends Node

# === CONSTANTS ===

signal structure_selected(structure_name: String, mesh: MeshInstance3D)
signal structure_deselected
signal structure_hovered(structure_name: String, mesh: MeshInstance3D)
signal structure_unhovered
signal selection_confidence_changed(confidence: float)


# === PUBLIC METHODS ===

const RAY_LENGTH: float = 1000.0
const HOVER_FADE_SPEED: float = 2.0
const OUTLINE_THICKNESS: float = 0.02

# Multi-ray sampling configuration
const MULTI_RAY_SAMPLES: int = 5  # Center + 4 corners
const SAMPLE_RADIUS: float = 5.0  # Pixels around click point

# Adaptive tolerance based on structure size
const MIN_SELECTION_TOLERANCE: float = 2.0  # Minimum pixels
const MAX_SELECTION_TOLERANCE: float = 20.0  # Maximum pixels
const SMALL_STRUCTURE_THRESHOLD: float = 0.05  # Structures smaller than 5% of screen

# Structure size cache for adaptive tolerance

var structure_sizes: Dictionary = {}  # mesh -> screen_size_percentage
var last_camera_position: Vector3
var last_camera_rotation: Vector3

# === CONFIGURATION VARIABLES ===
var highlight_color: Color = Color(0.2, 0.8, 1.0, 1.0)  # Default cyan
var hover_color: Color = Color(1.0, 0.7, 0.0, 0.6)  # Default orange
var success_color: Color = Color(0.0, 1.0, 0.6, 1.0)  # Default green
var emission_energy: float = 0.8
var outline_enabled: bool = true

# Enhanced selection tracking
var current_selected_mesh: MeshInstance3D = null
var current_hovered_mesh: MeshInstance3D = null
var original_materials: Dictionary = {}  # mesh_instance -> original_material
var hover_tween: Tween

# Selection confidence tracking
var last_selection_confidence: float = 0.0
var selection_candidates: Array[Dictionary] = []

# === SIGNALS ===
var hit_data = _cast_multi_ray_selection(screen_position, false)  # No tolerance for hover
var hit_mesh = hit_data["mesh"] if hit_data else null

# Handle hover state changes
var hit_data = _cast_multi_ray_selection(screen_position, true)

var hit_mesh = hit_data["mesh"]
last_selection_confidence = hit_data["confidence"]

# Apply highlighting
highlight_mesh(hit_mesh)
current_selected_mesh = hit_mesh

# Clear hover since we're now selected
var camera = get_viewport().get_camera_3d()
var nearby_structures = _find_nearby_structures(screen_position, 50.0)  # 50 pixel radius

var smallest_size = 1.0
var size = struct_data["screen_size"]
var tolerance_range = MAX_SELECTION_TOLERANCE - MIN_SELECTION_TOLERANCE
var size_factor = 1.0 - min(smallest_size / 0.2, 1.0)  # Normalize to 0-1
var camera = get_viewport().get_camera_3d()
var candidates: Array[Dictionary] = []
var tolerance = get_adaptive_tolerance(screen_position) if use_tolerance else 0.0

# Sample pattern: center + 4 corners + optional edge samples
var sample_offsets = [
Vector2(0, 0),  # Center
Vector2(-SAMPLE_RADIUS, -SAMPLE_RADIUS),  # Top-left
Vector2(SAMPLE_RADIUS, -SAMPLE_RADIUS),  # Top-right
Vector2(-SAMPLE_RADIUS, SAMPLE_RADIUS),  # Bottom-left
Vector2(SAMPLE_RADIUS, SAMPLE_RADIUS),  # Bottom-right
]

# Add more samples for small structure detection
var sample_pos = screen_position + offset
var hit_result = _cast_single_ray(sample_pos)

var found = false
var best_candidate = candidates[0]
var total_samples = MULTI_RAY_SAMPLES + (4 if tolerance > 10.0 else 0)
var confidence = float(best_candidate["hit_count"]) / float(total_samples)

# Apply structure size boost for small structures
var avg_dist_a = _calculate_average(a["distances"])
var avg_dist_b = _calculate_average(b["distances"])

var camera = get_viewport().get_camera_3d()
var from = camera.project_ray_origin(screen_position)
var to = from + camera.project_ray_normal(screen_position) * RAY_LENGTH

# Setup raycast
var space_state = get_viewport().world_3d.direct_space_state
var ray_params = PhysicsRayQueryParameters3D.create(from, to)
ray_params.collision_mask = 0xFFFFFFFF
ray_params.collide_with_areas = true
ray_params.hit_from_inside = true  # Important for overlapping geometry

# Perform raycast
var result = space_state.intersect_ray(ray_params)

var mesh = _extract_mesh_from_collision(result)
var nearby: Array = []
var camera = get_viewport().get_camera_3d()
var brain_model = get_node_or_null("/root/Node3D/BrainModel")
var all_meshes = _get_all_meshes_recursive(brain_model)

# Check each mesh
var screen_pos = _get_mesh_screen_position(mesh)
var meshes: Array[MeshInstance3D] = []

var camera = get_viewport().get_camera_3d()
var aabb = mesh.get_aabb()
var center = mesh.global_transform * aabb.get_center()

var camera = get_viewport().get_camera_3d()
var aabb = mesh.get_aabb()
var corners = [
mesh.global_transform * aabb.position, mesh.global_transform * (aabb.position + aabb.size)
]

var screen_min = Vector2.INF
var screen_max = -Vector2.INF

var screen_pos = camera.unproject_position(corner)
screen_min = screen_min.min(screen_pos)
screen_max = screen_max.max(screen_pos)

var screen_size = screen_max - screen_min
var viewport_size = get_viewport().get_visible_rect().size
var size_percentage = (screen_size.length() / viewport_size.length()) * 100.0

structure_sizes[mesh] = size_percentage
var camera = get_viewport().get_camera_3d()
var sum = 0.0
var collider = collision_result.collider

# Direct mesh instance hit
var parent = collider.get_parent()
var aabb = sibling.get_aabb()
var collision_point = collision_result.get("position", Vector3.ZERO)
var local_point = sibling.global_transform.inverse() * collision_point

# Check if collision point is within mesh bounds (with tolerance)
var tolerance = 0.1
var parent = collider.get_parent()
var hover_material = StandardMaterial3D.new()
hover_material.albedo_color = hover_color.lightened(0.3)
hover_material.emission_enabled = true
hover_material.emission = hover_color
hover_material.emission_energy_multiplier = 0.5
hover_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
hover_material.metallic = 0.2
hover_material.roughness = 0.3
hover_material.rim_enabled = true
hover_material.rim_tint = 0.8
hover_material.rim = 0.5

var surface_count = mesh.mesh.get_surface_count()
var highlight_material = StandardMaterial3D.new()
highlight_material.albedo_color = highlight_color.lightened(0.2)
highlight_material.emission_enabled = true
highlight_material.emission = highlight_color
highlight_material.emission_energy_multiplier = emission_energy
highlight_material.metallic = 0.3
highlight_material.roughness = 0.2
highlight_material.rim_enabled = true
highlight_material.rim_tint = 0.8
highlight_material.rim = 0.5
highlight_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
highlight_material.albedo_color.a = 0.8

var surface_count = mesh.mesh.get_surface_count()
var original_material = original_materials[mesh]
var surface_count = mesh.mesh.get_surface_count() if mesh.mesh else 1

var tween = mesh.create_tween()
tween.set_loops()

var original_scale = mesh.scale
var pulse_scale = original_scale * 1.02

tween.tween_property(mesh, "scale", pulse_scale, 0.8)
tween.tween_property(mesh, "scale", original_scale, 0.8)

mesh.set_meta("hover_tween", tween)


var tween = mesh.create_tween()
tween.set_parallel(true)

var original_scale = mesh.scale
tween.tween_property(mesh, "scale", original_scale * 1.1, 0.1).set_ease(Tween.EASE_OUT)
tween.tween_property(mesh, "scale", original_scale, 0.3).set_ease(Tween.EASE_OUT).set_trans(
Tween.TRANS_BACK
)

var material = mesh.get_surface_override_material(0)
var original_energy = material.emission_energy_multiplier
tween.tween_method(
func(energy): _set_material_emission(material, energy),
original_energy,
original_energy * 2.0,
0.1
)
tween.tween_method(
func(energy): _set_material_emission(material, energy),
original_energy * 2.0,
original_energy,
0.3
)


var current_material = mesh.get_surface_override_material(0)
var mesh_hover_tween = mesh.get_meta("hover_tween")
var connections = get_signal_connection_list("structure_selected")

func _ready() -> void:
	set_process_unhandled_input(true)
	_initialize_modern_colors()

	# Start structure size caching
	_update_structure_sizes()


	## Enhanced hover with multi-ray sampling
func _process_selection_candidates(
	candidates: Array, _click_position: Vector2, tolerance: float
	) -> Dictionary:
		"""Process multi-ray candidates to determine best selection"""
func _exit_tree() -> void:
	current_selected_mesh = null
	current_hovered_mesh = null

	for mesh in original_materials.keys():
		if is_instance_valid(mesh):
			restore_original_material(mesh)
			original_materials.clear()

			print("[SELECTION] Enhanced SelectionManager cleaned up")


func _initialize_modern_colors() -> void:
	"""Initialize colors from UIThemeManager if available"""
	highlight_color = Color("#00D9FF")  # Primary cyan
	hover_color = Color("#FF006E")  # Secondary magenta
	success_color = Color("#06FFA5")  # Success green
	print("[SELECTION] Modern UI colors applied")


	# === ANIMATION FUNCTIONS (Unchanged) ===


func handle_hover_at_position(screen_position: Vector2) -> void:
func handle_selection_at_position(screen_position: Vector2) -> void:
	# Clear previous selection
	clear_current_selection()

	# Use enhanced multi-ray selection with adaptive tolerance
func get_adaptive_tolerance(screen_position: Vector2) -> float:
	"""Calculate adaptive tolerance based on nearby structure sizes"""
func clear_current_selection() -> void:
	if current_selected_mesh != null:
		restore_original_material(current_selected_mesh)
		current_selected_mesh = null


func apply_hover_effect(mesh: MeshInstance3D) -> void:
	if not mesh or not mesh.mesh:
		return

		_store_original_materials(mesh)

		# Create modern hover material with glass effect
func clear_hover_effect(mesh: MeshInstance3D) -> void:
	if not mesh or not original_materials.has(mesh):
		return

		_cleanup_mesh_animations(mesh)
		restore_original_material(mesh)


func highlight_mesh(mesh: MeshInstance3D) -> void:
	if not mesh or not mesh.mesh:
		return

		_cleanup_mesh_animations(mesh)
		_store_original_materials(mesh)

		# Create modern selection material with glass effect
func restore_original_material(mesh: MeshInstance3D) -> void:
	if not mesh or not original_materials.has(mesh):
		return

func get_selected_structure_name() -> String:
	if current_selected_mesh:
		return current_selected_mesh.name
		return ""


func get_selected_mesh() -> MeshInstance3D:
	return current_selected_mesh


func set_highlight_color(color: Color) -> void:
	highlight_color = color


func set_emission_energy(energy: float) -> void:
	emission_energy = energy


func configure_highlight_colors(selection_color: Color, hover_color_param: Color) -> void:
	highlight_color = selection_color
	hover_color = hover_color_param


func set_outline_enabled(enabled: bool) -> void:
	outline_enabled = enabled


func get_hovered_structure_name() -> String:
	if current_hovered_mesh:
		return current_hovered_mesh.name
		return ""


func dispose() -> void:
	clear_current_selection()
	if current_hovered_mesh:
		clear_hover_effect(current_hovered_mesh)

		if has_signal("structure_selected"):

func _fix_orphaned_code():
	if hit_mesh != current_hovered_mesh:
		# Clear previous hover
		if current_hovered_mesh and current_hovered_mesh != current_selected_mesh:
			clear_hover_effect(current_hovered_mesh)
			structure_unhovered.emit()

			# Apply new hover
			current_hovered_mesh = hit_mesh
			if current_hovered_mesh and current_hovered_mesh != current_selected_mesh:
				apply_hover_effect(current_hovered_mesh)
				structure_hovered.emit(current_hovered_mesh.name, current_hovered_mesh)


				## Enhanced selection with multi-ray sampling and adaptive tolerance
func _fix_orphaned_code():
	if hit_data and hit_data["mesh"]:
func _fix_orphaned_code():
	if current_hovered_mesh == hit_mesh:
		current_hovered_mesh = null

		# Emit signals
		structure_selected.emit(hit_mesh.name, hit_mesh)
		selection_confidence_changed.emit(last_selection_confidence)

		# Log selection details for debugging
		if OS.is_debug_build():
			print(
			(
			"[Selection] Selected: %s (Confidence: %.1f%%, Method: %s)"
			% [
			hit_mesh.name,
			last_selection_confidence * 100,
			hit_data.get("method", "unknown")
			]
			)
			)
			else:
				structure_deselected.emit()


				## Get adaptive selection tolerance for a given position
func _fix_orphaned_code():
	if not camera:
		return MIN_SELECTION_TOLERANCE

		# Find structures near the click position
func _fix_orphaned_code():
	if nearby_structures.is_empty():
		return MIN_SELECTION_TOLERANCE

		# Calculate tolerance based on smallest nearby structure
func _fix_orphaned_code():
	for struct_data in nearby_structures:
func _fix_orphaned_code():
	if size < smallest_size:
		smallest_size = size

		# Adaptive tolerance calculation
		if smallest_size < SMALL_STRUCTURE_THRESHOLD:
			# Small structures get maximum tolerance
			return MAX_SELECTION_TOLERANCE
			else:
				# Larger structures get proportionally less tolerance
func _fix_orphaned_code():
	return MIN_SELECTION_TOLERANCE + (tolerance_range * size_factor)


	# === ENHANCED SELECTION METHODS ===


	## Multi-ray selection with adaptive tolerance
func _fix_orphaned_code():
	if not camera:
		return {}

func _fix_orphaned_code():
	if tolerance > 10.0:
		(
		sample_offsets
		. append_array(
		[
		Vector2(0, -SAMPLE_RADIUS),  # Top
		Vector2(SAMPLE_RADIUS, 0),  # Right
		Vector2(0, SAMPLE_RADIUS),  # Bottom
		Vector2(-SAMPLE_RADIUS, 0),  # Left
		]
		)
		)

		# Cast rays from each sample point
		for offset in sample_offsets:
func _fix_orphaned_code():
	if hit_result:
		# Check if we already have this mesh as a candidate
func _fix_orphaned_code():
	for candidate in candidates:
		if candidate["mesh"] == hit_result["mesh"]:
			candidate["hit_count"] += 1
			candidate["distances"].append(hit_result["distance"])
			found = true
			break

			if not found:
				candidates.append(
				{
				"mesh": hit_result["mesh"],
				"hit_count": 1,
				"distances": [hit_result["distance"]],
				"first_hit_position": hit_result["position"],
				"structure_size": _get_structure_screen_size(hit_result["mesh"])
				}
				)

				# Process candidates to find best selection
				return _process_selection_candidates(candidates, screen_position, tolerance)


				## Process selection candidates with intelligent prioritization
func _fix_orphaned_code():
	if best_candidate["structure_size"] < SMALL_STRUCTURE_THRESHOLD:
		confidence = min(confidence * 1.5, 1.0)

		return {
		"mesh": best_candidate["mesh"],
		"confidence": confidence,
		"method": "multi_ray",
		"hit_count": best_candidate["hit_count"],
		"avg_distance": _calculate_average(best_candidate["distances"])
		}


		## Compare function for sorting selection candidates
func _fix_orphaned_code():
	if abs(avg_dist_a - avg_dist_b) > 0.1:
		return avg_dist_a < avg_dist_b

		# Priority 3: Smaller structures get priority (harder to select)
		return a["structure_size"] < b["structure_size"]


		## Cast a single selection ray
func _fix_orphaned_code():
	if not camera:
		return {}

		# Calculate ray
func _fix_orphaned_code():
	if not space_state:
		return {}

func _fix_orphaned_code():
	if result.is_empty():
		return {}

func _fix_orphaned_code():
	if not mesh:
		return {}

		return {
		"mesh": mesh,
		"position": result["position"],
		"distance": from.distance_to(result["position"]),
		"normal": result.get("normal", Vector3.UP)
		}


		## Find structures near a screen position
func _fix_orphaned_code():
	if not camera:
		return nearby

		# Get all potential meshes
func _fix_orphaned_code():
	if not brain_model:
		return nearby

func _fix_orphaned_code():
	for mesh in all_meshes:
func _fix_orphaned_code():
	if screen_pos.distance_to(screen_position) <= radius:
		nearby.append(
		{
		"mesh": mesh,
		"screen_position": screen_pos,
		"screen_size": _get_structure_screen_size(mesh),
		"distance": screen_pos.distance_to(screen_position)
		}
		)

		return nearby


		## Get all meshes recursively
func _fix_orphaned_code():
	if node is MeshInstance3D:
		meshes.append(node)

		for child in node.get_children():
			if child is Node3D:
				meshes.append_array(_get_all_meshes_recursive(child))

				return meshes


				## Calculate mesh screen position
func _fix_orphaned_code():
	if not camera or not mesh.mesh:
		return Vector2.ZERO

func _fix_orphaned_code():
	if camera.is_position_behind(center):
		return Vector2(-1000, -1000)  # Off-screen

		return camera.unproject_position(center)


		## Calculate structure screen size percentage
func _fix_orphaned_code():
	if not camera or not mesh.mesh:
		return 0.0

func _fix_orphaned_code():
	for corner in corners:
		if not camera.is_position_behind(corner):
func _fix_orphaned_code():
	return size_percentage


	## Update structure size cache
func _fix_orphaned_code():
	if not camera:
		return

		# Check if camera has moved significantly
		if (
		camera.position.distance_to(last_camera_position) > 0.1
		or camera.rotation.distance_to(last_camera_rotation) > 0.01
		):
			structure_sizes.clear()
			last_camera_position = camera.position
			last_camera_rotation = camera.rotation


			## Calculate average of an array
func _fix_orphaned_code():
	for value in values:
		sum += value

		return sum / values.size()


		# === EXISTING METHODS (Enhanced) ===


func _fix_orphaned_code():
	if collider is MeshInstance3D:
		return collider

		# Enhanced StaticBody3D handling
		if collider is StaticBody3D:
			# Check parent first
func _fix_orphaned_code():
	if parent is MeshInstance3D:
		return parent

		# Check children (sometimes mesh is child of StaticBody3D)
		for child in collider.get_children():
			if child is MeshInstance3D:
				return child

				# Check siblings
				if parent:
					for sibling in parent.get_children():
						if sibling is MeshInstance3D and sibling != collider:
							# Verify this mesh is related to the collision
func _fix_orphaned_code():
	if aabb.grow(tolerance).has_point(local_point):
		return sibling

		# Area3D handling for trigger-based selection
		if collider is Area3D:
func _fix_orphaned_code():
	if parent is MeshInstance3D:
		return parent

		return null


		# === VISUAL FEEDBACK (Unchanged from original) ===


func _fix_orphaned_code():
	for surface_idx in range(surface_count):
		mesh.set_surface_override_material(surface_idx, hover_material)

		_animate_hover_pulse(mesh)


func _fix_orphaned_code():
	for surface_idx in range(surface_count):
		mesh.set_surface_override_material(surface_idx, highlight_material)

		_animate_selection_pulse(mesh)


func _fix_orphaned_code():
	for surface_idx in range(surface_count):
		mesh.set_surface_override_material(surface_idx, original_material)

		original_materials.erase(mesh)


func _fix_orphaned_code():
	if material and material.emission_enabled:
func _fix_orphaned_code():
	if current_material == null and mesh.mesh != null:
		current_material = mesh.mesh.surface_get_material(0)

		if current_material == null:
			current_material = StandardMaterial3D.new()
			current_material.albedo_color = Color(0.8, 0.8, 0.8, 1.0)

			original_materials[mesh] = current_material.duplicate()


func _fix_orphaned_code():
	if mesh_hover_tween and is_instance_valid(mesh_hover_tween):
		mesh_hover_tween.kill()
		mesh.remove_meta("hover_tween")

		mesh.scale = Vector3.ONE


func _fix_orphaned_code():
	for connection in connections:
		if connection.signal.is_connected(connection.callable):
			connection.signal.disconnect(connection.callable)

			_exit_tree()

func _fix_orphaned_code():
	if candidates.is_empty():
		return {}

		# Sort candidates by priority
		candidates.sort_custom(_compare_selection_candidates)

		# Calculate selection confidence
func _cast_multi_ray_selection(screen_position: Vector2, use_tolerance: bool) -> Dictionary:
	"""Cast multiple rays for improved selection accuracy"""
func _compare_selection_candidates(a: Dictionary, b: Dictionary) -> bool:
	"""Sort candidates by hit count, then by average distance"""
	# Priority 1: More hits is better
	if a["hit_count"] != b["hit_count"]:
		return a["hit_count"] > b["hit_count"]

		# Priority 2: Closer average distance is better
func _cast_single_ray(screen_position: Vector2) -> Dictionary:
	"""Cast a single ray and return hit information"""
func _find_nearby_structures(screen_position: Vector2, radius: float) -> Array:
	"""Find all structures within a screen radius of the given position"""
func _get_all_meshes_recursive(node: Node3D) -> Array[MeshInstance3D]:
	"""Recursively collect all mesh instances"""
func _get_mesh_screen_position(mesh: MeshInstance3D) -> Vector2:
	"""Get the screen position of a mesh's center"""
func _get_structure_screen_size(mesh: MeshInstance3D) -> float:
	"""Calculate the screen size of a structure as a percentage"""
	if structure_sizes.has(mesh):
		return structure_sizes[mesh]

func _update_structure_sizes() -> void:
	"""Update cached structure sizes when camera changes"""
func _calculate_average(values: Array) -> float:
	"""Calculate the average of an array of floats"""
	if values.is_empty():
		return 0.0

func _extract_mesh_from_collision(collision_result: Dictionary) -> MeshInstance3D:
	"""Enhanced mesh extraction with better StaticBody3D handling"""
	if collision_result.is_empty() or not collision_result.has("collider"):
		return null

func _animate_hover_pulse(mesh: MeshInstance3D) -> void:
	"""Add a subtle pulsing glow effect to hovered meshes"""
	if not mesh or not mesh.mesh:
		return

func _animate_selection_pulse(mesh: MeshInstance3D) -> void:
	"""Add a selection confirmation pulse with modern easing"""
	if not mesh or not mesh.mesh:
		return

func _update_emission_energy(energy: float, material: Material) -> void:
	"""Helper function to update emission energy during animation"""
	if material and material.has_method("set"):
		material.emission_energy_multiplier = energy


func _set_material_emission(material: Material, energy: float) -> void:
	"""Safe helper to set material emission energy"""
	if not material:
		return

		if material.has_method("set") and "emission_energy_multiplier" in material:
			material.emission_energy_multiplier = energy
			else:
				push_warning("Material does not support emission_energy_multiplier property")


func _store_original_materials(mesh: MeshInstance3D) -> void:
	if original_materials.has(mesh):
		return

func _cleanup_mesh_animations(mesh: MeshInstance3D) -> void:
	"""Clean up any running animations on a mesh"""
	if not mesh:
		return

		if mesh.has_meta("hover_tween"):
