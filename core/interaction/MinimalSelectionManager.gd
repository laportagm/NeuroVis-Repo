## MinimalSelectionManager.gd
## Foundational selection system for NeuroVis brain anatomy education
##
## This minimal but reliable selection manager enables medical students and healthcare
## professionals to select anatomical brain structures for educational exploration.
## Designed for accuracy with small structures (8mm+) and clear visual feedback.
##
## Medical Education Considerations:
## - Structure names must match anatomical_data.json exactly for content retrieval
## - Visual feedback must not obscure anatomical features
## - Selection accuracy is critical for learning correct anatomical relationships
## - Debug logging aids in medical validation of structure identification
##
## @tutorial: Foundation for advanced multi-ray selection in future iterations
## @version: 1.0 - Minimal implementation for immediate educational use

class_name MinimalSelectionManager
extends Node

# ===== SIGNALS =====
## Emitted when a brain structure is selected by the user
## Used by UI panels to display educational content about the structure
signal structure_selected(structure_name: String, mesh: MeshInstance3D)

## Emitted when selection is cleared (clicking empty space)
signal structure_deselected

## Emitted for real-time hover feedback during structure exploration
signal structure_hovered(structure_name: String, mesh: MeshInstance3D)

## Emitted when hover state is cleared
signal structure_unhovered

## Debug signal for medical validation logging
signal selection_attempted(screen_position: Vector2, hit_structure: String)

# ===== CONSTANTS =====
## Maximum ray distance for selection (covers entire brain model space)
const RAY_LENGTH: float = 1000.0

## Highlight color meeting WCAG AA 4.5:1 contrast ratio
const HIGHLIGHT_COLOR: Color = Color(0.0, 0.8, 1.0, 0.9)  # Medical cyan
const HOVER_COLOR: Color = Color(1.0, 0.9, 0.0, 0.7)  # Educational yellow

## Material property names for consistent application
const EMISSION_PROPERTY: String = "emission_energy_multiplier"
const ALBEDO_PROPERTY: String = "albedo_color"

# ===== VARIABLES =====
## Current selection state
var selected_mesh: MeshInstance3D = null
var hovered_mesh: MeshInstance3D = null

## Original material storage for restoration
var original_materials: Dictionary = {}  # mesh -> Array of materials

## Reference to camera for raycasting
var camera: Camera3D = null

## Reference to brain model parent for structure search
var brain_model_parent: Node3D = null

## Debug mode for medical validation
var debug_mode: bool = true


# ===== LIFECYCLE METHODS =====
func _ready() -> void:
	"""Initialize the selection manager for educational use"""
	set_process_unhandled_input(true)
	print("[MinimalSelection] Selection manager ready for educational interaction")


func _exit_tree() -> void:
	"""Clean up when removing from scene"""
	# Restore all materials to prevent visual artifacts
	for mesh in original_materials.keys():
		if is_instance_valid(mesh):
			_restore_original_material(mesh)
	original_materials.clear()

	selected_mesh = null
	hovered_mesh = null


# ===== PUBLIC METHODS =====
func initialize(cam: Camera3D, model_parent: Node3D) -> bool:
	"""
	Initialize the selection system with required references

	@param cam: The scene camera for raycasting
	@param model_parent: Parent node containing brain model meshes
	@returns: Success status for initialization validation
	"""
	if not cam or not model_parent:
		push_error("[MinimalSelection] Cannot initialize without camera and model parent")
		return false

	camera = cam
	brain_model_parent = model_parent

	print("[MinimalSelection] Initialized with camera and brain model parent")
	return true


func handle_selection_at_position(screen_position: Vector2) -> void:
	"""
	Process a selection attempt at the given screen position
	Used when user clicks to select a brain structure

	@param screen_position: Mouse position in screen coordinates
	"""
	if not camera:
		push_error("[MinimalSelection] No camera available for selection")
		return

	# Clear any previous selection
	clear_selection()

	# Perform raycast selection
	var hit_result = _perform_raycast_selection(screen_position)

	# Emit debug signal for medical validation
	var structure_name = hit_result.get("structure_name", "none")
	selection_attempted.emit(screen_position, structure_name)

	if hit_result.is_empty():
		# No structure hit - clear selection
		structure_deselected.emit()
		if debug_mode:
			print("[MinimalSelection] No structure at position: ", screen_position)
		return

	# Valid structure selected
	var mesh = hit_result["mesh"]
	selected_mesh = mesh

	# Apply selection highlight
	_apply_selection_highlight(mesh)

	# Emit selection signal with anatomically correct name
	structure_selected.emit(structure_name, mesh)

	if debug_mode:
		print(
			(
				"[MinimalSelection] Selected structure: %s at distance: %.2f"
				% [structure_name, hit_result.get("distance", 0.0)]
			)
		)


func handle_hover_at_position(screen_position: Vector2) -> void:
	"""
	Process hover detection for educational tooltips
	Updates visual feedback as user explores structures

	@param screen_position: Current mouse position
	"""
	if not camera or selected_mesh != null:
		return  # Don't hover while something is selected

	var hit_result = _perform_raycast_selection(screen_position)
	var new_hover_mesh = hit_result.get("mesh") if not hit_result.is_empty() else null

	# Check if hover state changed
	if new_hover_mesh != hovered_mesh:
		# Clear previous hover
		if hovered_mesh:
			_restore_original_material(hovered_mesh)
			structure_unhovered.emit()

		# Apply new hover
		hovered_mesh = new_hover_mesh
		if hovered_mesh:
			_apply_hover_highlight(hovered_mesh)
			structure_hovered.emit(hit_result["structure_name"], hovered_mesh)


func clear_selection() -> void:
	"""Clear current selection and restore original materials"""
	if selected_mesh:
		_restore_original_material(selected_mesh)
		selected_mesh = null


func get_selected_structure_name() -> String:
	"""Get the anatomically correct name of the selected structure"""
	if not selected_mesh:
		return ""
	return _extract_structure_name(selected_mesh)


func set_debug_mode(enabled: bool) -> void:
	"""Toggle debug logging for medical validation"""
	debug_mode = enabled


# ===== PRIVATE METHODS =====
func _unhandled_input(event: InputEvent) -> void:
	"""Process input events for structure selection"""
	if event.is_action_pressed("select_structure"):  # Right-click by default
		handle_selection_at_position(event.position)
		get_viewport().set_input_as_handled()
	elif event is InputEventMouseMotion:
		handle_hover_at_position(event.position)


func _perform_raycast_selection(screen_position: Vector2) -> Dictionary:
	"""
	Cast a ray from camera through screen position to find brain structures

	@param screen_position: Mouse position in screen coordinates
	@returns: Dictionary with mesh, structure_name, distance, and position
	"""
	if not camera:
		return {}

	# Calculate ray from camera
	var from = camera.project_ray_origin(screen_position)
	var to = from + camera.project_ray_normal(screen_position) * RAY_LENGTH

	# Setup physics ray query
	var space_state = camera.get_world_3d().direct_space_state
	var ray_params = PhysicsRayQueryParameters3D.create(from, to)
	ray_params.collision_mask = 0xFFFFFFFF  # Check all layers
	ray_params.collide_with_areas = true  # Include Area3D triggers
	ray_params.hit_from_inside = true  # Handle overlapping structures

	# Perform raycast
	var result = space_state.intersect_ray(ray_params)

	if result.is_empty():
		return {}

	# Extract mesh from collision result
	var mesh = _extract_mesh_from_collider(result["collider"])
	if not mesh:
		return {}

	# Get anatomically correct structure name
	var structure_name = _extract_structure_name(mesh)

	# Validate structure exists in medical database
	if not _validate_structure_name(structure_name):
		if debug_mode:
			push_warning(
				"[MinimalSelection] Structure '%s' not in anatomical database" % structure_name
			)
		# Continue anyway for debugging unmapped structures

	return {
		"mesh": mesh,
		"structure_name": structure_name,
		"distance": from.distance_to(result["position"]),
		"position": result["position"],
		"normal": result.get("normal", Vector3.UP)
	}


func _extract_mesh_from_collider(collider: Object) -> MeshInstance3D:
	"""
	Extract MeshInstance3D from various collider configurations
	Handles different model import structures

	@param collider: The physics body hit by raycast
	@returns: MeshInstance3D if found, null otherwise
	"""
	if not collider:
		return null

	# Direct mesh instance hit
	if collider is MeshInstance3D:
		return collider

	# StaticBody3D configuration (common for imported models)
	if collider is StaticBody3D:
		# Check if mesh is parent of StaticBody3D
		var parent = collider.get_parent()
		if parent is MeshInstance3D:
			return parent

		# Check if mesh is child of StaticBody3D
		for child in collider.get_children():
			if child is MeshInstance3D:
				return child

		# Check siblings for associated mesh
		if parent:
			for sibling in parent.get_children():
				if sibling is MeshInstance3D and sibling != collider:
					return sibling

	# Area3D configuration (for trigger-based selection)
	if collider is Area3D:
		var parent = collider.get_parent()
		if parent is MeshInstance3D:
			return parent

	return null


func _extract_structure_name(mesh: MeshInstance3D) -> String:
	"""
	Extract anatomically correct structure name from mesh node
	Handles various naming conventions from model imports

	@param mesh: The mesh instance to extract name from
	@returns: Normalized structure name matching anatomical_data.json
	"""
	if not mesh:
		return ""

	var raw_name = mesh.name

	# Remove common suffixes from model imports
	var clean_name = raw_name
	var suffixes_to_remove = [
		"_mesh", "_Mesh", "-mesh", "-Mesh", "_001", "_002", "(Clone)", " Instance"
	]
	for suffix in suffixes_to_remove:
		clean_name = clean_name.replace(suffix, "")

	# Handle special cases for known structure variations
	# These mappings ensure medical accuracy
	var name_mappings = {
		"Hipp and Others": "Hippocampus",
		"Hipp_and_Others": "Hippocampus",
		"Striatum (good)": "Striatum",
		"Amygdala_R": "Amygdala",
		"Amygdala_L": "Amygdala",
		"Thalamus_Right": "Thalamus",
		"Thalamus_Left": "Thalamus"
	}

	for variant in name_mappings:
		if variant in clean_name:
			return name_mappings[variant]

	# Remove parenthetical additions
	if "(" in clean_name:
		clean_name = clean_name.split("(")[0].strip()

	# Capitalize first letter for consistency
	if clean_name.length() > 0:
		clean_name = clean_name[0].to_upper() + clean_name.substr(1)

	return clean_name


func _validate_structure_name(structure_name: String) -> bool:
	"""
	Validate structure name exists in medical knowledge base
	Future: Check against KnowledgeService for valid structures

	@param structure_name: The structure name to validate
	@returns: True if structure is recognized in medical database
	"""
	# TODO: Integrate with KnowledgeService.has_structure() when available
	# For now, return true to allow all selections during development
	return true


func _apply_selection_highlight(mesh: MeshInstance3D) -> void:
	"""
	Apply medical-appropriate highlight to selected structure
	Maintains visibility of anatomical features

	@param mesh: The mesh to highlight
	"""
	if not mesh or not mesh.mesh:
		return

	# Store original materials before modification
	_store_original_materials(mesh)

	# Create selection material with medical visualization standards
	var highlight_material = StandardMaterial3D.new()
	highlight_material.albedo_color = HIGHLIGHT_COLOR
	highlight_material.emission_enabled = true
	highlight_material.emission = HIGHLIGHT_COLOR
	highlight_material.emission_energy_multiplier = 0.3  # Subtle glow
	highlight_material.rim_enabled = true
	highlight_material.rim = 0.6
	highlight_material.rim_tint = 0.5
	highlight_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	highlight_material.cull_mode = BaseMaterial3D.CULL_DISABLED  # Show both sides

	# Apply to all surfaces
	var surface_count = mesh.mesh.get_surface_count()
	for i in range(surface_count):
		mesh.set_surface_override_material(i, highlight_material)


func _apply_hover_highlight(mesh: MeshInstance3D) -> void:
	"""
	Apply educational hover effect for structure exploration
	More subtle than selection to avoid distraction

	@param mesh: The mesh to apply hover effect to
	"""
	if not mesh or not mesh.mesh:
		return

	_store_original_materials(mesh)

	# Create hover material - subtle for exploration
	var hover_material = StandardMaterial3D.new()
	hover_material.albedo_color = HOVER_COLOR
	hover_material.emission_enabled = true
	hover_material.emission = HOVER_COLOR
	hover_material.emission_energy_multiplier = 0.2  # Very subtle
	hover_material.rim_enabled = true
	hover_material.rim = 0.4
	hover_material.rim_tint = 0.3
	hover_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	hover_material.albedo_color.a = 0.7  # More transparent than selection

	# Apply to all surfaces
	var surface_count = mesh.mesh.get_surface_count()
	for i in range(surface_count):
		mesh.set_surface_override_material(i, hover_material)


func _store_original_materials(mesh: MeshInstance3D) -> void:
	"""
	Store original materials for restoration after selection
	Preserves medical visualization properties

	@param mesh: The mesh whose materials to store
	"""
	if original_materials.has(mesh):
		return  # Already stored

	var materials = []
	var surface_count = mesh.mesh.get_surface_count() if mesh.mesh else 0

	for i in range(surface_count):
		# Get override material first, then fall back to mesh material
		var material = mesh.get_surface_override_material(i)
		if not material:
			material = mesh.mesh.surface_get_material(i)
		materials.append(material)

	original_materials[mesh] = materials


func _restore_original_material(mesh: MeshInstance3D) -> void:
	"""
	Restore original anatomical visualization materials

	@param mesh: The mesh to restore
	"""
	if not mesh or not original_materials.has(mesh):
		return

	var materials = original_materials[mesh]
	var surface_count = mesh.mesh.get_surface_count() if mesh.mesh else 0

	for i in range(min(surface_count, materials.size())):
		mesh.set_surface_override_material(i, materials[i])

	original_materials.erase(mesh)

# ===== FUTURE ENHANCEMENTS =====
# TODO: Multi-ray sampling for small structure accuracy (pineal gland, etc.)
# TODO: Adaptive tolerance based on structure size and viewing angle
# TODO: Structure occlusion detection for overlapping anatomy
# TODO: Touch gesture support for tablet-based medical education
# TODO: Haptic feedback integration for medical training devices
# TODO: Selection confidence scoring for validation studies
# TODO: Integration with medical imaging overlays (MRI/CT correlation)
