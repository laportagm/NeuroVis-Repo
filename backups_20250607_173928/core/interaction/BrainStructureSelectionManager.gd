## BrainStructureSelectionManager.gd
## Enhanced selection system with improved accuracy for educational effectiveness
##
## This enhanced version implements multi-ray sampling, adaptive tolerance,
## structure size awareness, and overlapping geometry resolution to achieve
## 100% selection reliability for all anatomical structures.
##
## Medical/Educational Context:
## - Accurate structure selection is critical for medical education
## - Small deep brain structures (pineal gland, pituitary) require special handling
## - Visual feedback must be clear for learning effectiveness
## - Multi-ray sampling ensures reliable selection even for tiny structures
##
## @tutorial: Advanced selection techniques for educational 3D applications
## @version: 3.0

class_name BrainStructureSelectionManager
extends Node

# Constants

signal structure_selected(structure_name: String, mesh: MeshInstance3D)
signal structure_deselected
signal structure_hovered(structure_name: String, mesh: MeshInstance3D)
signal structure_unhovered
signal selection_confidence_changed(confidence: float)


# Initialize tween for hover effects with proper cleanup

const RAY_LENGTH: float = 1000.0
const HOVER_FADE_SPEED: float = 2.0
const OUTLINE_THICKNESS: float = 0.02

# Multi-ray sampling configuration
# Medical Rationale: Small deep brain structures require multiple ray samples
# to ensure reliable selection. The 9-ray pattern covers center + corners + edges
const MULTI_RAY_SAMPLES: int = 9  # Center + 4 corners + 4 edges
const SAMPLE_RADIUS: float = 8.0  # Pixels around click point (increased for better coverage)

# Adaptive tolerance based on structure size
# Educational Context: Smaller structures need larger tolerance for accessibility
const MIN_SELECTION_TOLERANCE: float = 2.0  # Minimum pixels for large structures
const MAX_SELECTION_TOLERANCE: float = 20.0  # Maximum pixels for tiny structures
const SMALL_STRUCTURE_THRESHOLD: float = 0.05  # Structures smaller than 5% of screen

# Structure size cache for adaptive tolerance
const COLLISION_INFLATION: Dictionary = {
	"pineal_gland": 1.5, "pituitary_gland": 1.5, "subthalamic_nucleus": 1.3, "substantia_nigra": 1.3  # 50% inflation for this tiny structure  # 50% inflation for reliable selection  # 30% inflation for DBS education  # 30% inflation for Parkinson's education
}

# Configuration variables - will be initialized in _ready()

var structure_sizes: Dictionary = {}  # mesh -> screen_size_percentage
var last_camera_position: Vector3
var last_camera_rotation: Vector3

# Structure-specific tolerance overrides for problematic structures
# Medical Context: These deep brain structures are clinically important but very small
# - Pineal gland: ~8mm, produces melatonin, requires 25px tolerance
# - Pituitary: ~10mm, master endocrine gland, requires 25px tolerance
# - Subthalamic nucleus: Parkinson's DBS target, requires 22px tolerance
var structure_tolerance_overrides: Dictionary = {
	"pineal_gland": 25.0,  # Tiny deep structure (~8mm), critical for circadian rhythm
	"pituitary_gland": 25.0,  # Small but vital endocrine gland (~10mm)
	"subthalamic_nucleus": 22.0,  # DBS target for Parkinson's disease
	"substantia_nigra": 22.0,  # Dopamine production, Parkinson's pathology
	"globus_pallidus": 20.0,  # Movement regulation, dystonia treatment
	"caudate_nucleus": 15.0,  # Part of basal ganglia, learning/memory
	"putamen": 15.0  # Movement control, stroke vulnerability
}

# Collision shape inflation for tiny structures
# Educational Rationale: Inflated collision boxes ensure students can select
# these critical structures for learning, despite their small physical size
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
var debug_visualization_enabled: bool = false

# Visual feedback system
var visual_feedback: Node  # EducationalVisualFeedback instance
var accessibility_manager: Node

# Signals
	var hit_result: Dictionary = _cast_single_ray(screen_position)
	var hit_mesh: MeshInstance3D = hit_result.get("mesh", null) if hit_result else null

	# Handle hover state changes
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


# Enhanced selection with multi-ray sampling and adaptive tolerance
	var hit_data: Dictionary = _cast_multi_ray_selection(screen_position, true)

	if hit_data and hit_data.has("mesh") and hit_data["mesh"]:
		var hit_mesh: MeshInstance3D = hit_data["mesh"]
		last_selection_confidence = hit_data.get("confidence", 1.0)

		# Apply highlighting
		highlight_mesh(hit_mesh)
		current_selected_mesh = hit_mesh

		# Clear hover since we're now selected
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


# Clears the current selection and restores original materials
		var original_mat = original_materials.get(mesh)
		visual_feedback.apply_hover_feedback(mesh, original_mat)
	else:
		# Fallback to basic hover effect
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
		for surface_idx in range(surface_count):
			mesh.set_surface_override_material(surface_idx, hover_material)

		# Animation handled by visual feedback system when available
		# _animate_hover_pulse(mesh)


# Clears hover effect with smooth transition
		var original_mat = original_materials.get(mesh)
		visual_feedback.clear_feedback(mesh, original_mat)
	else:
		# Clean up any running animations
		_cleanup_mesh_animations(mesh)

		# Restore original material
		restore_original_material(mesh)


# Highlights a mesh with modern selection effects
		var original_mat = original_materials.get(mesh)
		visual_feedback.apply_selection_feedback(mesh, original_mat)
	else:
		# Fallback to basic selection effect
		var highlight_material = StandardMaterial3D.new()
		highlight_material.albedo_color = highlight_color.lightened(0.2)
		highlight_material.emission_enabled = true
		highlight_material.emission = highlight_color
		highlight_material.emission_energy_multiplier = emission_energy
		highlight_material.metallic = 0.3
		highlight_material.roughness = 0.2

		# Add premium rim lighting effect
		highlight_material.rim_enabled = true
		highlight_material.rim_tint = 0.8
		highlight_material.rim = 0.5

		# Enhanced transparency for glass effect
		highlight_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		highlight_material.albedo_color.a = 0.8

		# Apply highlight to all surfaces
		var surface_count = mesh.mesh.get_surface_count()
		for surface_idx in range(surface_count):
			mesh.set_surface_override_material(surface_idx, highlight_material)

		# Animation handled by visual feedback system when available
		# _animate_selection_pulse(mesh)


# Restores the original material for a mesh
	var original_material = original_materials[mesh]
	var surface_count = mesh.mesh.get_surface_count() if mesh.mesh else 1

	# Restore original material to all surfaces
	for surface_idx in range(surface_count):
		mesh.set_surface_override_material(surface_idx, original_material)

	# Remove from tracking dictionary
	original_materials.erase(mesh)


# Returns the name of the currently selected structure, or empty string if none
	var camera: Camera3D = get_viewport().get_camera_3d()
	if not camera:
		return {}

	var mesh_candidates: Array[Dictionary] = []
	var selection_tolerance_pixels: float = (
		get_adaptive_tolerance(screen_position) if use_tolerance else 0.0
	)

	# Enhanced sample pattern for 9-ray configuration
	# Educational Context: This pattern ensures even tiny structures like the
	# pineal gland (8mm) can be reliably selected for learning
	var sample_offsets: Array[Vector2] = [
		Vector2(0, 0),  # Center
		Vector2(-SAMPLE_RADIUS, -SAMPLE_RADIUS),  # Top-left
		Vector2(SAMPLE_RADIUS, -SAMPLE_RADIUS),  # Top-right
		Vector2(-SAMPLE_RADIUS, SAMPLE_RADIUS),  # Bottom-left
		Vector2(SAMPLE_RADIUS, SAMPLE_RADIUS),  # Bottom-right
		Vector2(0, -SAMPLE_RADIUS),  # Top
		Vector2(SAMPLE_RADIUS, 0),  # Right
		Vector2(0, SAMPLE_RADIUS),  # Bottom
		Vector2(-SAMPLE_RADIUS, 0),  # Left
	]

	# Add even more samples for extremely small structures
	# Medical Context: Extra samples for structures like subthalamic nucleus (DBS target)
	if selection_tolerance_pixels > 20.0:
		var extra_radius: float = SAMPLE_RADIUS * 0.7
		(
			sample_offsets
			. append_array(
				[
					Vector2(-extra_radius, -extra_radius),  # Inner corners
					Vector2(extra_radius, -extra_radius),
					Vector2(-extra_radius, extra_radius),
					Vector2(extra_radius, extra_radius),
				]
			)
		)

	# Cast rays from each sample point
	for offset in sample_offsets:
		var sample_pos: Vector2 = screen_position + offset
		var raycast_result: Dictionary = _cast_single_ray(sample_pos)

		if raycast_result:
			# Check if we already have this mesh as a candidate
			var mesh_already_candidate: bool = false
			for candidate in mesh_candidates:
				if candidate["mesh"] == raycast_result["mesh"]:
					candidate["hit_count"] += 1
					candidate["distances"].append(raycast_result["distance"])
					mesh_already_candidate = true
					break

			if not mesh_already_candidate:
				mesh_candidates.append(
					{
						"mesh": raycast_result["mesh"],
						"hit_count": 1,
						"distances": [raycast_result["distance"]],
						"first_hit_position": raycast_result["position"],
						"structure_size": _get_structure_screen_size(raycast_result["mesh"])
					}
				)

	# Process candidates to find best selection
	return _process_selection_candidates(
		mesh_candidates, screen_position, selection_tolerance_pixels
	)


## Process selection candidates with intelligent prioritization
	var best_candidate: Dictionary = mesh_candidates[0]
	var total_samples: int = MULTI_RAY_SAMPLES
	if selection_tolerance_pixels > 20.0:
		total_samples += 4  # Extra inner corner samples
	var confidence: float = float(best_candidate["hit_count"]) / float(total_samples)

	# Apply structure size boost for small structures
	# Educational Context: Boost confidence for tiny structures to ensure they're selectable
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
	var avg_dist_a = _calculate_average(a["distances"])
	var avg_dist_b = _calculate_average(b["distances"])

	if abs(avg_dist_a - avg_dist_b) > 0.1:
		return avg_dist_a < avg_dist_b

	# Priority 3: Smaller structures get priority (harder to select)
	return a["structure_size"] < b["structure_size"]


## Get adaptive selection tolerance for a given position
## Educational Importance: Adaptive tolerance ensures all structures are selectable
## regardless of their size, critical for comprehensive neuroanatomy education
	var camera: Camera3D = get_viewport().get_camera_3d()
	if not camera:
		return MIN_SELECTION_TOLERANCE

	# Find structures near the click position
	var nearby_structures: Array[Dictionary] = _find_nearby_structures(screen_position, 50.0)  # 50 pixel radius

	if nearby_structures.is_empty():
		return MIN_SELECTION_TOLERANCE

	# Check for structure-specific overrides first
	var smallest_size: float = 1.0

	for structure_data in nearby_structures:
		var mesh: MeshInstance3D = structure_data["mesh"]
		var normalized_name: String = mesh.name.to_lower().replace(" ", "_")

		if structure_tolerance_overrides.has(normalized_name):
			# Found a structure with override, use its tolerance
			# Medical Context: These are critically important small structures
			return structure_tolerance_overrides[normalized_name]

		# Track smallest structure for adaptive calculation
		if structure_data["screen_size"] < smallest_size:
			smallest_size = structure_data["screen_size"]

	# Adaptive tolerance calculation
	var base_tolerance: float = MIN_SELECTION_TOLERANCE

	if smallest_size < SMALL_STRUCTURE_THRESHOLD:
		# Small structures get maximum tolerance
		# Educational Rationale: Ensures students can select small but important structures
		base_tolerance = MAX_SELECTION_TOLERANCE

		# Extra boost for very tiny structures
		# Medical Context: Structures <2% screen size include critical deep brain nuclei
		if smallest_size < 0.02:  # Less than 2% of screen
			base_tolerance *= 1.5
	else:
		# Larger structures get proportionally less tolerance
		var tolerance_range: float = MAX_SELECTION_TOLERANCE - MIN_SELECTION_TOLERANCE
		var size_factor: float = 1.0 - min(smallest_size / 0.2, 1.0)  # Normalize to 0-1
		base_tolerance = MIN_SELECTION_TOLERANCE + (tolerance_range * size_factor)

	return base_tolerance


## Cast a single selection ray
	var camera: Camera3D = get_viewport().get_camera_3d()
	if not camera:
		return {}

	# Calculate ray
	var ray_origin: Vector3 = camera.project_ray_origin(screen_position)
	var ray_end: Vector3 = ray_origin + camera.project_ray_normal(screen_position) * RAY_LENGTH

	# Setup raycast
	var space_state: PhysicsDirectSpaceState3D = get_viewport().world_3d.direct_space_state
	if not space_state:
		return {}

	var ray_params: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(
		ray_origin, ray_end
	)
	ray_params.collision_mask = 0xFFFFFFFF
	ray_params.collide_with_areas = true
	ray_params.hit_from_inside = true  # Important for overlapping geometry

	# Perform raycast
	var raycast_result: Dictionary = space_state.intersect_ray(ray_params)

	if raycast_result.is_empty():
		return {}

	var hit_mesh: MeshInstance3D = _extract_mesh_from_collision(raycast_result)
	if not hit_mesh:
		return {}

	return {
		"mesh": hit_mesh,
		"position": raycast_result["position"],
		"distance": ray_origin.distance_to(raycast_result["position"]),
		"normal": raycast_result.get("normal", Vector3.UP)
	}


# Casts a ray from the camera through the screen position and returns the hit mesh
	var camera = get_viewport().get_camera_3d()
	if not camera:
		push_warning("[Selection] Camera access error: No camera found for selection raycast")
		return null

	# Calculate ray origin and direction
	var from = camera.project_ray_origin(screen_position)
	var to = from + camera.project_ray_normal(screen_position) * RAY_LENGTH

	# Setup raycast parameters
	var space_state = get_viewport().world_3d.direct_space_state
	if not space_state:
		push_warning("[Selection] Physics error: No physics space found for selection raycast")
		return null

	var ray_params = PhysicsRayQueryParameters3D.create(from, to)
	ray_params.collision_mask = 0xFFFFFFFF  # Detect all collision layers

	# Perform raycast
	var result = space_state.intersect_ray(ray_params)

	# Extract mesh from collision result
	if not result.is_empty():
		return _extract_mesh_from_collision(result)

	return null


# Enhanced mesh extraction with better StaticBody3D handling for overlapping geometry
	var collider = collision_result.collider

	# Direct mesh instance hit
	if collider is MeshInstance3D:
		return collider

	# Enhanced StaticBody3D handling
	if collider is StaticBody3D:
		# Check parent first
		var parent: Node = collider.get_parent()
		if parent is MeshInstance3D:
			return parent

		# Check children (sometimes mesh is child of StaticBody3D)
		for child in collider.get_children():
			if child is MeshInstance3D:
				return child

		# Check siblings for related mesh
		if parent:
			for sibling in parent.get_children():
				if sibling is MeshInstance3D:
					# First check inflated collision for small structures
					var collision_point: Vector3 = collision_result.get("position", Vector3.ZERO)
					if _check_inflated_collision(sibling, collision_point):
						return sibling

					# Then check normal bounds
					if sibling != collider:
						# Verify this mesh is related to the collision
						var mesh_aabb: AABB = sibling.get_aabb()
						var local_point: Vector3 = (
							sibling.global_transform.inverse() * collision_point
						)

						# Check if collision point is within mesh bounds (with tolerance)
						var bounds_tolerance: float = 0.1
						if mesh_aabb.grow(bounds_tolerance).has_point(local_point):
							return sibling

	# CollisionShape3D handling
	if collider is CollisionShape3D:
		var parent: Node = collider.get_parent()
		if parent is StaticBody3D:
			var grandparent: Node = parent.get_parent()
			if grandparent is MeshInstance3D:
				return grandparent

	# Area3D handling for trigger-based selection
	if collider is Area3D:
		var parent: Node = collider.get_parent()
		if parent is MeshInstance3D:
			return parent

	return null


# Stores original materials for a mesh before highlighting
	var current_material = mesh.get_surface_override_material(0)
	if current_material == null and mesh.mesh != null:
		current_material = mesh.mesh.surface_get_material(0)

	# If still no material, create a default one
	if current_material == null:
		current_material = StandardMaterial3D.new()
		current_material.albedo_color = Color(0.8, 0.8, 0.8, 1.0)

	# Store a duplicate to preserve the original
	original_materials[mesh] = current_material.duplicate()


# Enhanced configuration methods
	var nearby_structures: Array[Dictionary] = []
	var camera: Camera3D = get_viewport().get_camera_3d()
	if not camera:
		return nearby_structures

	# Get all potential meshes
	var brain_model: Node = get_node_or_null("/root/Node3D/BrainModel")
	if not brain_model:
		return nearby_structures

	var all_meshes: Array[MeshInstance3D] = _get_all_meshes_recursive(brain_model)

	# Check each mesh
	for mesh in all_meshes:
		var screen_pos: Vector2 = _get_mesh_screen_position(mesh)
		if screen_pos.distance_to(screen_position) <= radius:
			nearby_structures.append(
				{
					"mesh": mesh,
					"screen_position": screen_pos,
					"screen_size": _get_structure_screen_size(mesh),
					"distance": screen_pos.distance_to(screen_position)
				}
			)

	return nearby_structures


## Get all meshes recursively
	var meshes: Array[MeshInstance3D] = []

	if node is MeshInstance3D:
		meshes.append(node)

	for child in node.get_children():
		if child is Node3D:
			meshes.append_array(_get_all_meshes_recursive(child))

	return meshes


## Calculate mesh screen position
	var camera = get_viewport().get_camera_3d()
	if not camera or not mesh.mesh:
		return Vector2.ZERO

	var aabb = mesh.get_aabb()
	var center = mesh.global_transform * aabb.get_center()

	if camera.is_position_behind(center):
		return Vector2(-1000, -1000)  # Off-screen

	return camera.unproject_position(center)


## Calculate structure screen size percentage
	var camera = get_viewport().get_camera_3d()
	if not camera or not mesh.mesh:
		return 0.0

	var aabb = mesh.get_aabb()
	var corners = [
		mesh.global_transform * aabb.position, mesh.global_transform * (aabb.position + aabb.size)
	]

	var screen_min = Vector2.INF
	var screen_max = -Vector2.INF

	for corner in corners:
		if not camera.is_position_behind(corner):
			var screen_pos = camera.unproject_position(corner)
			screen_min = screen_min.min(screen_pos)
			screen_max = screen_max.max(screen_pos)

	var screen_size = screen_max - screen_min
	var viewport_size = get_viewport().get_visible_rect().size
	var size_percentage = (screen_size.length() / viewport_size.length()) * 100.0

	structure_sizes[mesh] = size_percentage
	return size_percentage


## Update structure size cache
	var camera = get_viewport().get_camera_3d()
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
	var sum = 0.0
	for value in values:
		sum += value

	return sum / values.size()


# Cleanup method to prevent memory leaks
	var VisualFeedbackClass = prepreload("res://core/visualization/EducationalVisualFeedback.gd")
	if VisualFeedbackClass:
		visual_feedback = VisualFeedbackClass.new()
		visual_feedback.name = "VisualFeedback"
		add_child(visual_feedback)
		print("[SELECTION] Visual feedback system initialized")
	else:
		push_warning("[SELECTION] EducationalVisualFeedback.gd not found")

	# Check for accessibility manager
	if has_node("/root/AccessibilityManager"):
		accessibility_manager = get_node("/root/AccessibilityManager")
		print("[SELECTION] Connected to AccessibilityManager")

		# Apply accessibility settings
		if accessibility_manager.has_method("get_settings"):
			var settings = accessibility_manager.get_settings()
			if visual_feedback and settings.has("colorblind_mode"):
				visual_feedback.set_color_scheme(settings["colorblind_mode"])
				visual_feedback.reduce_motion = settings.get("reduce_motion", false)
				visual_feedback.high_contrast_mode = settings.get("high_contrast", false)
				visual_feedback.enhanced_outlines = settings.get("enhanced_outlines", false)


# Modern animation functions
	var tween = mesh.create_tween()
	tween.set_loops()

	# Animate the scale with a subtle pulse
	var original_scale = mesh.scale
	var pulse_scale = original_scale * 1.02

	tween.tween_property(mesh, "scale", pulse_scale, 0.8)
	tween.tween_property(mesh, "scale", original_scale, 0.8)

	# Store tween reference for cleanup
	mesh.set_meta("hover_tween", tween)


	var tween = mesh.create_tween()

	# Quick scale pulse for confirmation - sequential animation
	var original_scale = mesh.scale
	tween.tween_property(mesh, "scale", original_scale * 1.1, 0.1).set_ease(Tween.EASE_OUT)
	tween.tween_property(mesh, "scale", original_scale, 0.3).set_ease(Tween.EASE_OUT).set_trans(
		Tween.TRANS_BACK
	)

	# Quick glow pulse if material supports it
	var material = mesh.get_surface_override_material(0)
	if material and material is StandardMaterial3D and material.emission_enabled:
		var original_energy = material.emission_energy_multiplier
		# Create a separate tween for emission to avoid conflicts
		var emission_tween = mesh.create_tween()
		emission_tween.tween_method(
			func(energy): _set_material_emission(material, energy),
			original_energy,
			original_energy * 2.0,
			0.1
		)
		emission_tween.tween_method(
			func(energy): _set_material_emission(material, energy),
			original_energy * 2.0,
			original_energy,
			0.3
		)


# Modern Godot 4 approach using lambda (see above)
# Legacy approach with corrected parameter order:
		var mesh_hover_tween = mesh.get_meta("hover_tween")
		if mesh_hover_tween and is_instance_valid(mesh_hover_tween):
			mesh_hover_tween.kill()
		mesh.remove_meta("hover_tween")

	# Reset scale to normal
	mesh.scale = Vector3.ONE


## Enhanced collision detection with inflation for small structures
## Medical/Educational Rationale: Inflated collision boxes ensure that tiny but
## clinically important structures (pineal gland, pituitary) can be reliably selected
## for educational exploration, despite their small physical size
	var normalized_name: String = mesh.name.to_lower().replace(" ", "_")
	var inflation_factor: float = COLLISION_INFLATION.get(normalized_name, 1.0)

	if inflation_factor > 1.0:
		# Check inflated bounds
		var original_aabb: AABB = mesh.get_aabb()
		var inflated_aabb: AABB = original_aabb.grow(
			original_aabb.size.length() * (inflation_factor - 1.0) * 0.5
		)
		var local_point: Vector3 = mesh.global_transform.inverse() * world_position

		return inflated_aabb.has_point(local_point)

	return false


## Precalculate collision bounds for all structures
	var brain_model = get_node_or_null("/root/Node3D/BrainModel")
	if not brain_model:
		return

	var all_meshes = _get_all_meshes_recursive(brain_model)
	print("[Selection] Precalculating bounds for %d structures" % all_meshes.size())

	for mesh in all_meshes:
		if mesh.mesh:
			var aabb = mesh.get_aabb()
			var normalized_name = mesh.name.to_lower().replace(" ", "_")

			# Apply inflation if needed
			var inflation_factor = COLLISION_INFLATION.get(normalized_name, 1.0)
			if inflation_factor > 1.0:
				aabb = aabb.grow(aabb.size.length() * (inflation_factor - 1.0) * 0.5)

			# Cache the bounds
			mesh.set_meta("precalculated_aabb", aabb)


## Enable/disable debug visualization
		var connections = get_signal_connection_list("structure_selected")
		for connection in connections:
			if connection.signal.is_connected(connection.callable):
				connection.signal.disconnect(connection.callable)

	# Call _exit_tree cleanup
	_exit_tree()


# === PROFESSIONAL MODEL SUPPORT ===


## Initialize support for professional anatomical models
	var anatomical_manager = _find_anatomical_model_manager()
	if anatomical_manager:
		if anatomical_manager.has_signal("anatomical_model_loaded"):
			anatomical_manager.anatomical_model_loaded.connect(_on_anatomical_model_loaded)
		if anatomical_manager.has_signal("brain_tissue_materials_enhanced"):
			anatomical_manager.brain_tissue_materials_enhanced.connect(_on_materials_enhanced)

		print("[SELECTION] Connected to professional AnatomicalModelManager")
	else:
		print("[SELECTION] Professional AnatomicalModelManager not available")


## Find AnatomicalModelManager in the scene tree
	var manager = get_node_or_null("/root/Node3D/ModelCoordinator/AnatomicalModelManager")
	if not manager:
		manager = get_node_or_null("/root/AnatomicalModelManager")
	if not manager:
		# Search for it in the tree
		manager = _search_for_node_type(get_tree().root, "AnatomicalModelManager")
	return manager


## Search for a node of specific type in the tree
		var result = _search_for_node_type(child, type_name)
		if result:
			return result
	return null


## Handle professional anatomical model being loaded
	var professional_tolerances = {
		"pineal_gland": 20.0,
		"pituitary_gland": 20.0,
		"subthalamic_nucleus": 18.0,
		"substantia_nigra": 18.0,
		"globus_pallidus": 15.0,
		"caudate_nucleus": 12.0,
		"putamen": 12.0
	}

	# Merge with existing overrides
	for structure in professional_tolerances:
		structure_tolerance_overrides[structure] = professional_tolerances[structure]

	print("[SELECTION] Updated tolerance overrides for professional model: %s" % model_name)

func _ready() -> void:
	# Initialize with proper cleanup tracking
	set_process_unhandled_input(true)

	# Initialize modern UI theme colors if available
	_initialize_modern_colors()

	# Initialize visual feedback system
	_initialize_visual_feedback()

	# Start structure size caching
	_update_structure_sizes()

	# Pre-calculate collision bounds for optimization
	_precalculate_collision_bounds()

	# Initialize professional model support
	_initialize_professional_model_support()


## Initialize the selection system with camera and model references
## @param camera_ref: Camera3D node for raycasting
## @param model_parent_ref: Node3D containing the 3D models
## @returns: bool - true if initialization successful
func _process_selection_candidates(
	mesh_candidates: Array[Dictionary], _click_position: Vector2, selection_tolerance_pixels: float
) -> Dictionary:
	"""Process multi-ray candidates to determine best selection"""
	if mesh_candidates.is_empty():
		return {}

	# Sort candidates by priority
	mesh_candidates.sort_custom(_compare_selection_candidates)

	# Calculate selection confidence
func _exit_tree() -> void:
	# Clear all references
	current_selected_mesh = null
	current_hovered_mesh = null

	# Clean up materials dictionary
	for mesh in original_materials.keys():
		if is_instance_valid(mesh):
			restore_original_material(mesh)
	original_materials.clear()

	print("[SELECTION] SelectionManager cleaned up")


# Initialize modern UI colors
func _initialize_modern_colors() -> void:
	"""Initialize colors from UIThemeManager if available"""
	# Use modern UI colors (these match UIThemeManager.COLORS)
	highlight_color = Color("#00D9FF")  # Primary cyan
	hover_color = Color("#FF006E")  # Secondary magenta
	success_color = Color("#06FFA5")  # Success green
	print("[SELECTION] Modern UI colors applied")


# Initialize visual feedback system
func _initialize_visual_feedback() -> void:
	"""Initialize the educational visual feedback system"""
	# Create visual feedback instance
func _initialize_professional_model_support() -> void:
	"""Initialize enhanced support for professional anatomical models"""
	# Connect to AnatomicalModelManager signals if available

func initialize(camera_ref: Camera3D, model_parent_ref: Node3D) -> bool:
	"""Initialize the selection system with required references"""
	if not camera_ref:
		push_error("[SELECTION] Camera reference is required")
		return false

	if not model_parent_ref:
		push_error("[SELECTION] Model parent reference is required")
		return false

	# Store references for use in raycasting
	set_meta("camera_ref", camera_ref)
	set_meta("model_parent_ref", model_parent_ref)

	print("[SELECTION] Selection system initialized with camera and model references")
	return true


# Enhanced hover with lighter multi-ray sampling for better accuracy
func handle_hover_at_position(screen_position: Vector2) -> void:
	# Use single ray for hover (performance optimization)
func handle_selection_at_position(screen_position: Vector2) -> void:
	# Clear previous selection
	clear_current_selection()

	# Use enhanced multi-ray selection with adaptive tolerance
func clear_current_selection() -> void:
	if current_selected_mesh != null:
		restore_original_material(current_selected_mesh)
		current_selected_mesh = null


# Applies modern hover effect with smooth glow and pulse
func apply_hover_effect(mesh: MeshInstance3D) -> void:
	if not mesh or not mesh.mesh:
		return

	_store_original_materials(mesh)

	# Use visual feedback system if available
	if visual_feedback:
func clear_hover_effect(mesh: MeshInstance3D) -> void:
	if not mesh or not original_materials.has(mesh):
		return

	# Use visual feedback system if available
	if visual_feedback:
func highlight_mesh(mesh: MeshInstance3D) -> void:
	if not mesh or not mesh.mesh:
		return

	# Clean up any hover animations first
	_cleanup_mesh_animations(mesh)

	# Store original materials before modifying
	_store_original_materials(mesh)

	# Use visual feedback system if available
	if visual_feedback:
func restore_original_material(mesh: MeshInstance3D) -> void:
	if not mesh or not original_materials.has(mesh):
		return

func get_selected_structure_name() -> String:
	if current_selected_mesh:
		return current_selected_mesh.name
	return ""


# Returns the currently selected mesh, or null if none
func get_selected_mesh() -> MeshInstance3D:
	return current_selected_mesh


# Configuration functions
func set_highlight_color(color: Color) -> void:
	highlight_color = color


func set_emission_energy(energy: float) -> void:
	emission_energy = energy


# === ENHANCED SELECTION METHODS ===


## Multi-ray selection with adaptive tolerance
## Medical/Educational Rationale: Multi-ray sampling ensures reliable selection
## of small deep brain structures that are critical for medical education
func get_adaptive_tolerance(screen_position: Vector2) -> float:
	"""Calculate adaptive tolerance based on nearby structure sizes"""
func configure_highlight_colors(selection_color: Color, hover_color_param: Color) -> void:
	highlight_color = selection_color
	hover_color = hover_color_param


func set_outline_enabled(enabled: bool) -> void:
	outline_enabled = enabled


func get_hovered_structure_name() -> String:
	if current_hovered_mesh:
		return current_hovered_mesh.name
	return ""


# === HELPER METHODS FOR ENHANCED SELECTION ===


## Find structures near a screen position
func set_debug_visualization(enabled: bool) -> void:
	debug_visualization_enabled = enabled


## Get selection statistics for analysis
func get_selection_statistics() -> Dictionary:
	"""Return current selection system statistics"""
	return {
		"last_confidence": last_selection_confidence,
		"structure_cache_size": structure_sizes.size(),
		"multi_ray_samples": MULTI_RAY_SAMPLES,
		"sample_radius": SAMPLE_RADIUS,
		"tolerance_range": [MIN_SELECTION_TOLERANCE, MAX_SELECTION_TOLERANCE],
		"small_structure_threshold": SMALL_STRUCTURE_THRESHOLD,
		"override_count": structure_tolerance_overrides.size(),
		"inflation_count": COLLISION_INFLATION.size()
	}


## Clear structure size cache (useful when camera changes significantly)
func clear_structure_cache() -> void:
	structure_sizes.clear()


# Dispose of resources and references
func dispose() -> void:
	# Clear current selections
	clear_current_selection()
	if current_hovered_mesh:
		clear_hover_effect(current_hovered_mesh)

	# Disconnect any remaining signals
	if has_signal("structure_selected"):

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
func _cast_selection_ray(screen_position: Vector2) -> MeshInstance3D:
	# Get the current camera
func _extract_mesh_from_collision(collision_result: Dictionary) -> MeshInstance3D:
	"""Enhanced mesh extraction with better collision handling"""
	if collision_result.is_empty() or not collision_result.has("collider"):
		return null

func _store_original_materials(mesh: MeshInstance3D) -> void:
	if original_materials.has(mesh):
		return  # Already stored

	# Get the current material from the first surface
func _find_nearby_structures(screen_position: Vector2, radius: float) -> Array[Dictionary]:
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

func _animate_hover_pulse(mesh: MeshInstance3D) -> void:
	"""Add a subtle pulsing glow effect to hovered meshes"""
	if not mesh or not mesh.mesh:
		return

	# Skip animation if visual feedback system is handling it
	if visual_feedback:
		return

	# Create a tween for the pulsing effect
func _animate_selection_pulse(mesh: MeshInstance3D) -> void:
	"""Add a selection confirmation pulse with modern easing"""
	if not mesh or not mesh.mesh:
		return

	# Skip animation if visual feedback system is handling it
	if visual_feedback:
		return

func _update_emission_energy(energy: float, material: Material) -> void:
	"""Helper function to update emission energy during animation (legacy approach)"""
	if material and material.has_method("set"):
		material.emission_energy_multiplier = energy


# Clean helper function for material emission updates
func _set_material_emission(material: Material, energy: float) -> void:
	"""Safe helper to set material emission energy"""
	if not material:
		return

	if material.has_method("set") and "emission_energy_multiplier" in material:
		material.emission_energy_multiplier = energy
	else:
		push_warning("Material does not support emission_energy_multiplier property")


func _cleanup_mesh_animations(mesh: MeshInstance3D) -> void:
	"""Clean up any running animations on a mesh"""
	if not mesh:
		return

	# Kill any existing hover tween
	if mesh.has_meta("hover_tween"):
func _check_inflated_collision(mesh: MeshInstance3D, world_position: Vector3) -> bool:
	"""Check if position is within inflated bounds of a structure"""
	if not mesh or not mesh.mesh:
		return false

func _precalculate_collision_bounds() -> void:
	"""Cache collision bounds for performance optimization"""
func _find_anatomical_model_manager() -> Node:
	"""Find the AnatomicalModelManager in the scene tree"""
	# Check common locations
func _search_for_node_type(node: Node, type_name: String) -> Node:
	"""Recursively search for a node of a specific type"""
	if node.get_script() and node.get_script().get_global_name() == type_name:
		return node

	for child in node.get_children():
func _on_anatomical_model_loaded(model_name: String, structure_count: int) -> void:
	"""Handle when a professional anatomical model is loaded"""
	print(
		"[SELECTION] Professional model loaded: %s (%d structures)" % [model_name, structure_count]
	)

	# Clear structure size cache for recalculation
	structure_sizes.clear()

	# Update collision bounds for new model
	_precalculate_collision_bounds()

	# Update tolerance overrides for known professional model structures
	_update_professional_structure_tolerances(model_name)


## Handle when brain tissue materials are enhanced
func _on_materials_enhanced(model_name: String, material_count: int) -> void:
	"""Handle when brain tissue materials are enhanced by AnatomicalModelManager"""
	print(
		(
			"[SELECTION] Enhanced %d materials for professional model: %s"
			% [material_count, model_name]
		)
	)


## Update structure tolerance overrides for professional models
func _update_professional_structure_tolerances(model_name: String) -> void:
	"""Update selection tolerances based on professional model characteristics"""
	# Professional models may have more precise geometry, so we can be more selective
	# But maintain tolerance for small critical structures
