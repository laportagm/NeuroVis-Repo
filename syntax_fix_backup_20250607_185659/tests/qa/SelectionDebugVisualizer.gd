## SelectionDebugVisualizer.gd
## Visual debugging tools for selection testing
##
## Provides visual feedback for QA testing including bounds visualization,
## ray visualization, and collision shape debugging.
##
## @tutorial: Educational QA Visual Debugging
## @version: 1.0

class_name SelectionDebugVisualizer
extends Node3D

# === CONSTANTS ===

const BOUNDS_COLOR: Color = Color(1.0, 1.0, 0.0, 0.3)  # Yellow transparent
const RAY_COLOR: Color = Color(0.0, 1.0, 0.0, 1.0)  # Green
const HIT_COLOR: Color = Color(1.0, 0.0, 0.0, 1.0)  # Red
const COLLISION_COLOR: Color = Color(0.0, 0.0, 1.0, 0.5)  # Blue transparent

# === PRIVATE VARIABLES ===

var brain_model_parent = _main_scene.get_node_or_null("BrainModel")
var meshes = _find_structure_meshes(brain_model_parent, structure_name)
var ray_mesh = _create_line_mesh(from, to, RAY_COLOR if not hit else HIT_COLOR)
_ray_lines.append(ray_mesh)
add_child(ray_mesh)

# Create hit marker if hit
var hit_marker = _create_sphere_mesh(hit_point, 0.05, HIT_COLOR)
_ray_lines.append(hit_marker)
add_child(hit_marker)


## Show collision shapes
var brain_model_parent_2 = _main_scene.get_node_or_null("BrainModel")
var color = HIT_COLOR if success else Color(1.0, 0.5, 0.0, 1.0)  # Orange for fail
var marker = _create_sphere_mesh(world_pos, 0.02, color)
_click_markers.append(marker)
add_child(marker)

# Keep only last 50 click markers
var old_marker = _click_markers.pop_front()
old_marker.queue_free()


## Toggle specific visualizations
var meshes_2: Array[MeshInstance3D] = []
var search_name = structure_name.to_lower().replace("_", " ")

var node_name = node.name.to_lower()
var aabb = mesh_instance.get_aabb()
var global_transform = mesh_instance.global_transform

# Create box mesh for AABB
var box_mesh = BoxMesh.new()
# FIXME: Orphaned code - box_mesh.size = aabb.size

var mesh_instance_3d = MeshInstance3D.new()
# FIXME: Orphaned code - mesh_instance_3d.mesh = box_mesh
# FIXME: Orphaned code - mesh_instance_3d.transform = global_transform
# FIXME: Orphaned code - mesh_instance_3d.position = global_transform * aabb.get_center()

# Create transparent material
var material = StandardMaterial3D.new()
# FIXME: Orphaned code - material.albedo_color = BOUNDS_COLOR
# FIXME: Orphaned code - material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
# FIXME: Orphaned code - material.cull_mode = BaseMaterial3D.CULL_DISABLED
# FIXME: Orphaned code - material.no_depth_test = true
# FIXME: Orphaned code - material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED

# FIXME: Orphaned code - mesh_instance_3d.material_override = material

# Store for later cleanup
var mesh_instance = MeshInstance3D.new()
var immediate_mesh = ImmediateMesh.new()
var material_2 = StandardMaterial3D.new()

# FIXME: Orphaned code - material.vertex_color_use_as_albedo = true
# FIXME: Orphaned code - material.albedo_color = color
# FIXME: Orphaned code - material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED

# FIXME: Orphaned code - mesh_instance.mesh = immediate_mesh
# FIXME: Orphaned code - mesh_instance.material_override = material

# Create line geometry
var arrays = []
arrays.resize(Mesh.ARRAY_MAX)

var vertices = PackedVector3Array([from, to])
var colors = PackedColorArray([color, color])

# FIXME: Orphaned code - arrays[Mesh.ARRAY_VERTEX] = vertices
# FIXME: Orphaned code - arrays[Mesh.ARRAY_COLOR] = colors

# Use ArrayMesh instead of ImmediateMesh for lines
var array_mesh = ArrayMesh.new()
array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, arrays)
# FIXME: Orphaned code - mesh_instance.mesh = array_mesh

var sphere_mesh = SphereMesh.new()
# FIXME: Orphaned code - sphere_mesh.radial_segments = 8
# FIXME: Orphaned code - sphere_mesh.rings = 4
# FIXME: Orphaned code - sphere_mesh.radius = radius
# FIXME: Orphaned code - sphere_mesh.height = radius * 2

var mesh_instance_2 = MeshInstance3D.new()
# FIXME: Orphaned code - mesh_instance.mesh = sphere_mesh
# FIXME: Orphaned code - mesh_instance.position = position

var material_3 = StandardMaterial3D.new()
# FIXME: Orphaned code - material.albedo_color = color
# FIXME: Orphaned code - material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED

# FIXME: Orphaned code - mesh_instance.material_override = material

var meshes_3 = _find_structure_meshes(parent, structure_name)

var current = mesh.get_parent()
var mesh_instance_3 = MeshInstance3D.new()

# Create mesh based on shape type
var box_shape = collision_shape.shape as BoxShape3D
var box_mesh_2 = BoxMesh.new()
# FIXME: Orphaned code - box_mesh.size = box_shape.size
# FIXME: Orphaned code - mesh_instance.mesh = box_mesh

var sphere_shape = collision_shape.shape as SphereShape3D
var sphere_mesh_2 = SphereMesh.new()
# FIXME: Orphaned code - sphere_mesh.radius = sphere_shape.radius
# FIXME: Orphaned code - sphere_mesh.height = sphere_shape.radius * 2
# FIXME: Orphaned code - mesh_instance.mesh = sphere_mesh

# Trimesh - create a simple box to indicate presence
var aabb_2 = (
collision_shape.get_parent().get_aabb()
var box_mesh_3 = BoxMesh.new()
# FIXME: Orphaned code - box_mesh.size = aabb.size
# FIXME: Orphaned code - mesh_instance.mesh = box_mesh

# Unknown shape type

# Set transform
# FIXME: Orphaned code - mesh_instance.global_transform = collision_shape.global_transform

# Create material
var material_4 = StandardMaterial3D.new()
# FIXME: Orphaned code - material.albedo_color = COLLISION_COLOR
# FIXME: Orphaned code - material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
# FIXME: Orphaned code - material.cull_mode = BaseMaterial3D.CULL_DISABLED
# FIXME: Orphaned code - material.no_depth_test = true
# FIXME: Orphaned code - material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED

# FIXME: Orphaned code - mesh_instance.material_override = material

_collision_meshes.append(mesh_instance)
add_child(mesh_instance)


var _debug_draw_enabled: bool = false
var _show_bounds: bool = false
var _show_rays: bool = false
var _show_collisions: bool = false
var _show_click_positions: bool = false

var _bounds_meshes: Dictionary = {}  # Structure name -> MeshInstance3D
var _ray_lines: Array[MeshInstance3D] = []
var _click_markers: Array[MeshInstance3D] = []
var _collision_meshes: Array[MeshInstance3D] = []

var _main_scene: Node3D
var _last_ray_origin: Vector3
var _last_ray_end: Vector3
var _last_hit_point: Vector3
var _last_hit_normal: Vector3


# === PUBLIC METHODS ===
## Initialize the debug visualizer

func initialize(main_scene: Node3D) -> void:
	"""Initialize the selection debug visualizer"""
	_main_scene = main_scene
	name = "SelectionDebugVisualizer"

	print("[DebugViz] Selection debug visualizer initialized")


	## Toggle debug visualization
func toggle_debug_draw() -> void:
	"""Toggle all debug visualizations"""
	_debug_draw_enabled = not _debug_draw_enabled

	if _debug_draw_enabled:
		print("[DebugViz] Debug visualization ENABLED")
		else:
			print("[DebugViz] Debug visualization DISABLED")
			_clear_all_visualizations()


			## Show bounds for a specific structure
func show_structure_bounds(structure_name: String) -> void:
	"""Visualize bounds for a specific structure"""
	if not _debug_draw_enabled:
		_debug_draw_enabled = true

		_show_bounds = true
		_clear_bounds_visualization()

		# Find structure meshes
func show_selection_ray(
	from: Vector3, to: Vector3, hit: bool, hit_point: Vector3 = Vector3.ZERO
	) -> void:
		"""Visualize a selection ray"""
func show_collision_shapes(structure_name: String = "") -> void:
	"""Visualize collision shapes for structures"""
	if not _debug_draw_enabled:
		_debug_draw_enabled = true

		_show_collisions = true
		_clear_collision_visualization()

func record_click_position(screen_pos: Vector2, world_pos: Vector3, success: bool) -> void:
	"""Record and visualize a click attempt"""
	if not _debug_draw_enabled or not _show_click_positions:
		return

		# Create click marker
func set_show_bounds(enabled: bool) -> void:
	_show_bounds = enabled
	if not enabled:
		_clear_bounds_visualization()


func set_show_rays(enabled: bool) -> void:
	_show_rays = enabled
	if not enabled:
		_clear_ray_visualization()


func set_show_collisions(enabled: bool) -> void:
	_show_collisions = enabled
	if not enabled:
		_clear_collision_visualization()


func set_show_clicks(enabled: bool) -> void:
	_show_click_positions = enabled
	if not enabled:
		_clear_click_markers()


		## Get visualization status
func get_status() -> Dictionary:
	"""Get current visualization status"""
	return {
	"enabled": _debug_draw_enabled,
	"bounds": _show_bounds,
	"rays": _show_rays,
	"collisions": _show_collisions,
	"clicks": _show_click_positions,
	"active_bounds": _bounds_meshes.size(),
	"active_rays": _ray_lines.size(),
	"active_clicks": _click_markers.size()
	}


	# === PRIVATE METHODS ===

func _fix_orphaned_code():
	if not brain_model_parent:
		push_error("[DebugViz] BrainModel node not found")
		return

func _fix_orphaned_code():
	if meshes.is_empty():
		print("[DebugViz] No meshes found for structure: %s" % structure_name)
		return

		# Create bounds visualization for each mesh
		for mesh in meshes:
			_create_bounds_visualization(mesh, structure_name)

			print("[DebugViz] Showing bounds for %d meshes of %s" % [meshes.size(), structure_name])


			## Show ray visualization for selection
func _fix_orphaned_code():
	if hit:
func _fix_orphaned_code():
	if not brain_model_parent:
		return

		if structure_name.is_empty():
			# Show all collision shapes
			_visualize_all_collisions(brain_model_parent)
			else:
				# Show specific structure's collision shapes
				_visualize_structure_collisions(brain_model_parent, structure_name)


				## Record click position for visualization
func _fix_orphaned_code():
	if _click_markers.size() > 50:
func _fix_orphaned_code():
	if node is MeshInstance3D:
func _fix_orphaned_code():
	if node_name.contains(search_name) or search_name.contains(node_name):
		meshes.append(node)

		for child in node.get_children():
			if child is Node3D:
				meshes.append_array(_find_structure_meshes(child, structure_name))

				return meshes


func _fix_orphaned_code():
	if not _bounds_meshes.has(structure_name):
		_bounds_meshes[structure_name] = []
		_bounds_meshes[structure_name].append(mesh_instance_3d)

		add_child(mesh_instance_3d)


func _fix_orphaned_code():
	return mesh_instance


func _fix_orphaned_code():
	return mesh_instance


func _fix_orphaned_code():
	for mesh in meshes:
		# Look for StaticBody3D parent
func _fix_orphaned_code():
	while current and current != parent:
		if current is StaticBody3D:
			# Found static body, look for collision shapes
			for child in current.get_children():
				if child is CollisionShape3D:
					_create_collision_visualization(child)
					break
					current = current.get_parent()


func _fix_orphaned_code():
	if collision_shape.shape is BoxShape3D:
func _fix_orphaned_code():
	if collision_shape.get_parent() is MeshInstance3D
	else AABB()
	)
func _fix_orphaned_code():
	if not _debug_draw_enabled or not _show_rays:
		return

		_last_ray_origin = from
		_last_ray_end = to

		if hit:
			_last_hit_point = hit_point

			# Clear old ray
			_clear_ray_visualization()

			# Create ray line
func _find_structure_meshes(node: Node3D, structure_name: String) -> Array[MeshInstance3D]:
	"""Find all meshes for a structure"""
func _create_bounds_visualization(mesh_instance: MeshInstance3D, structure_name: String) -> void:
	"""Create AABB visualization for a mesh"""
func _create_line_mesh(from: Vector3, to: Vector3, color: Color) -> MeshInstance3D:
	"""Create a line mesh between two points"""
func _create_sphere_mesh(position: Vector3, radius: float, color: Color) -> MeshInstance3D:
	"""Create a sphere mesh at position"""
func _visualize_all_collisions(node: Node3D) -> void:
	"""Visualize all collision shapes recursively"""
	if node is CollisionShape3D:
		_create_collision_visualization(node)

		for child in node.get_children():
			if child is Node3D:
				_visualize_all_collisions(child)


func _visualize_structure_collisions(parent: Node3D, structure_name: String) -> void:
	"""Visualize collision shapes for specific structure"""
func _create_collision_visualization(collision_shape: CollisionShape3D) -> void:
	"""Create visualization for a collision shape"""
	if not collision_shape.shape:
		return

func _clear_all_visualizations() -> void:
	"""Clear all debug visualizations"""
	_clear_bounds_visualization()
	_clear_ray_visualization()
	_clear_collision_visualization()
	_clear_click_markers()


func _clear_bounds_visualization() -> void:
	"""Clear bounds visualizations"""
	for structure_name in _bounds_meshes:
		for mesh in _bounds_meshes[structure_name]:
			mesh.queue_free()
			_bounds_meshes.clear()


func _clear_ray_visualization() -> void:
	"""Clear ray visualizations"""
	for ray in _ray_lines:
		ray.queue_free()
		_ray_lines.clear()


func _clear_collision_visualization() -> void:
	"""Clear collision visualizations"""
	for mesh in _collision_meshes:
		mesh.queue_free()
		_collision_meshes.clear()


func _clear_click_markers() -> void:
	"""Clear click position markers"""
	for marker in _click_markers:
		marker.queue_free()
		_click_markers.clear()
