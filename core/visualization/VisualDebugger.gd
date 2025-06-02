class_name VisualDebugger
extends RefCounted

# Add this script as an autoload in Project Settings > Autoloads

# Internal state - using static for consistency with static methods
static var _enabled: bool = true

# Static settings - accessible from static methods
static var text_color: Color = Color(1, 1, 0)  # Yellow
static var ray_color: Color = Color(1, 0, 0)  # Red
static var collision_color: Color = Color(0, 1, 0, 0.3)  # Green, semi-transparent
static var debug_material: StandardMaterial3D

# Static debug object collections
static var debug_objects: Array = []
static var mesh_highlights: Dictionary = {}

# Static initialization - called once when the class is first referenced
static func _static_init() -> void:
	if not debug_material:
		debug_material = StandardMaterial3D.new()
		debug_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		debug_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		debug_material.albedo_color = Color(0, 1, 0, 0.5)  # Green, semi-transparent

# Add a debug label at the given position
static func add_label(text: String, position: Vector3, parent: Node3D = null) -> Label3D:
	_static_init()  # Ensure static variables are initialized
	if not Engine.is_editor_hint() and not _enabled:
		return null
	
	var label = Label3D.new()
	label.text = text
	label.position = position
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label.font_size = 14
	label.modulate = text_color
	
	if parent:
		parent.add_child(label)
	else:
		# Add to current scene
		var current_scene = Engine.get_main_loop().current_scene
		current_scene.add_child(label)
	
	debug_objects.append(label)
	return label

# Draw a debug ray from origin to destination
static func draw_ray(from: Vector3, to: Vector3, duration: float = 1.0, parent: Node3D = null) -> MeshInstance3D:
	_static_init()  # Ensure static variables are initialized
	if not Engine.is_editor_hint() and not _enabled:
		return null
	
	var immediate_mesh = ImmediateMesh.new()
	immediate_mesh.clear_surfaces()
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	immediate_mesh.surface_add_vertex(from)
	immediate_mesh.surface_add_vertex(to)
	immediate_mesh.surface_end()
	
	var material = StandardMaterial3D.new()
	material.albedo_color = VisualDebugger.ray_color
	material.emission_enabled = true
	material.emission = VisualDebugger.ray_color
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = immediate_mesh
	mesh_instance.material_override = material
	
	if parent:
		parent.add_child(mesh_instance)
	else:
		# Add to current scene
		var current_scene = Engine.get_main_loop().current_scene
		current_scene.add_child(mesh_instance)
	
	debug_objects.append(mesh_instance)
	
	# Set up removal timer
	if duration > 0:
		var timer = Timer.new()
		mesh_instance.add_child(timer)
		timer.wait_time = duration
		timer.one_shot = true
		timer.timeout.connect(func(): 
			debug_objects.erase(mesh_instance)
			mesh_instance.queue_free()
		)
		timer.start()
	
	return mesh_instance

# Draw a box at the given position with the given size
static func draw_box(position: Vector3, size: Vector3 = Vector3.ONE, duration: float = 1.0, parent: Node3D = null) -> MeshInstance3D:
	_static_init()  # Ensure static variables are initialized
	if not Engine.is_editor_hint() and not _enabled:
		return null
	
	var box_mesh = BoxMesh.new()
	box_mesh.size = size
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = box_mesh
	mesh_instance.position = position
	mesh_instance.material_override = debug_material.duplicate()
	
	if parent:
		parent.add_child(mesh_instance)
	else:
		# Add to current scene
		var current_scene = Engine.get_main_loop().current_scene
		current_scene.add_child(mesh_instance)
	
	debug_objects.append(mesh_instance)
	
	# Set up removal timer
	if duration > 0:
		var timer = Timer.new()
		mesh_instance.add_child(timer)
		timer.wait_time = duration
		timer.one_shot = true
		timer.timeout.connect(func(): 
			debug_objects.erase(mesh_instance)
			mesh_instance.queue_free()
		)
		timer.start()
	
	return mesh_instance

# Draw a sphere at the given position with the given radius
static func draw_sphere(position: Vector3, radius: float = 0.5, duration: float = 1.0, parent: Node3D = null) -> MeshInstance3D:
	_static_init()  # Ensure static variables are initialized
	if not Engine.is_editor_hint() and not _enabled:
		return null
	
	var sphere_mesh = SphereMesh.new()
	sphere_mesh.radius = radius
	sphere_mesh.height = radius * 2.0
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = sphere_mesh
	mesh_instance.position = position
	mesh_instance.material_override = debug_material.duplicate()
	
	if parent:
		parent.add_child(mesh_instance)
	else:
		# Add to current scene
		var current_scene = Engine.get_main_loop().current_scene
		current_scene.add_child(mesh_instance)
	
	debug_objects.append(mesh_instance)
	
	# Set up removal timer
	if duration > 0:
		var timer = Timer.new()
		mesh_instance.add_child(timer)
		timer.wait_time = duration
		timer.one_shot = true
		timer.timeout.connect(func(): 
			debug_objects.erase(mesh_instance)
			mesh_instance.queue_free()
		)
		timer.start()
	
	return mesh_instance

# Highlight a mesh instance
static func highlight_mesh(mesh_instance: MeshInstance3D, color: Color = Color(0, 1, 0, 0.5), duration: float = 0.0) -> void:
	_static_init()  # Ensure static variables are initialized
	if not Engine.is_editor_hint() and not _enabled:
		return
	
	if not mesh_instance or not mesh_instance.mesh:
		return
	
	# Store original materials
	var original_materials = []
	for i in range(mesh_instance.get_surface_override_material_count()):
		original_materials.append(mesh_instance.get_surface_override_material(i))
	
	# Create highlight material
	var highlight_material = StandardMaterial3D.new()
	highlight_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	highlight_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	highlight_material.albedo_color = color
	
	# Apply to all surfaces
	for i in range(mesh_instance.mesh.get_surface_count()):
		mesh_instance.set_surface_override_material(i, highlight_material)
	
	# Store in dictionary
	mesh_highlights[mesh_instance] = {
		"original_materials": original_materials,
		"timer": null
	}
	
	# Set up removal timer if duration is set
	if duration > 0:
		var timer = Timer.new()
		mesh_instance.add_child(timer)
		timer.wait_time = duration
		timer.one_shot = true
		timer.timeout.connect(func(): 
			VisualDebugger.remove_highlight(mesh_instance)
		)
		timer.start()
		mesh_highlights[mesh_instance].timer = timer

# Remove highlight from a mesh instance
static func remove_highlight(mesh_instance: MeshInstance3D) -> void:
	_static_init()  # Ensure static variables are initialized
	if not Engine.is_editor_hint() and not _enabled:
		return
	
	if not mesh_instance or not mesh_highlights.has(mesh_instance):
		return
	
	# Restore original materials
	var highlight_data = mesh_highlights[mesh_instance]
	
	for i in range(mesh_instance.get_surface_override_material_count()):
		if i < highlight_data.original_materials.size():
			mesh_instance.set_surface_override_material(i, highlight_data.original_materials[i])
	
	# Clean up timer if it exists
	if highlight_data.timer and highlight_data.timer.is_inside_tree():
		highlight_data.timer.queue_free()
	
	# Remove from dictionary
	mesh_highlights.erase(mesh_instance)

# Clear all debug objects
static func clear_all() -> void:
	_static_init()  # Ensure static variables are initialized
	# Remove all debug objects
	for obj in debug_objects:
		if obj and obj.is_inside_tree():
			obj.queue_free()
	
	debug_objects.clear()
	
	# Remove all mesh highlights
	for mesh_instance in mesh_highlights.keys():
		VisualDebugger.remove_highlight(mesh_instance)

# Get current enabled state
static func is_enabled() -> bool:
	return _enabled

# Enable or disable debug visuals
static func set_enabled(enabled: bool) -> void:
	_static_init()  # Ensure static variables are initialized
	_enabled = enabled
	
	# Hide or show existing objects
	for obj in debug_objects:
		if obj and obj.is_inside_tree():
			obj.visible = enabled

# Toggle debug visuals
static func toggle() -> void:
	set_enabled(not _enabled)

# Visualize a raycast
static func visualize_raycast(click_position: Vector2, camera: Camera3D, length: float = 1000.0, duration: float = 1.0) -> void:
	_static_init()  # Ensure static variables are initialized
	if not Engine.is_editor_hint() and not _enabled:
		return
	
	if not camera:
		return
	
	var from = camera.project_ray_origin(click_position)
	var to = from + camera.project_ray_normal(click_position) * length
	
	draw_ray(from, to, duration)

# Create label for all nodes in a scene - useful for debugging structure names
static func label_all_nodes(parent: Node3D, recursive: bool = true, filter_class: String = "") -> void:
	_static_init()  # Ensure static variables are initialized
	if not Engine.is_editor_hint() and not _enabled:
		return
	
	for child in parent.get_children():
		if child is Node3D:
			var should_add_label = filter_class.is_empty() or child.get_class() == filter_class
			
			if should_add_label:
				add_label(child.name, child.global_position + Vector3(0, 0.2, 0))
			
			if recursive:
				label_all_nodes(child, true, filter_class)

# Visualize collision shapes in a scene
static func visualize_collision_shapes(parent: Node) -> void:
	_static_init()  # Ensure static variables are initialized
	if not Engine.is_editor_hint() and not _enabled:
		return
	
	_visualize_collision_shapes_recursive(parent)

static func _visualize_collision_shapes_recursive(node: Node) -> void:
	if node is CollisionShape3D and node.shape:
		var shape = node.shape
		var mesh_instance = null
		
		if shape is BoxShape3D:
			mesh_instance = draw_box(node.global_position, shape.size, 0.0, node.get_parent())
		elif shape is SphereShape3D:
			mesh_instance = draw_sphere(node.global_position, shape.radius, 0.0, node.get_parent())
		# Add more shape types as needed
		
		if mesh_instance:
			# Make the material slightly transparent
			mesh_instance.material_override.albedo_color = VisualDebugger.collision_color
			
			# Track for removal later
			debug_objects.append(mesh_instance)
	
	# Recursively process children
	for child in node.get_children():
		_visualize_collision_shapes_recursive(child)

# Print a hierarchical view of a node and its children - useful for debugging scene structure
static func print_node_tree(node: Node, indent: String = "") -> void:
	print(indent + node.name + " (" + node.get_class() + ")")
	
	for child in node.get_children():
		print_node_tree(child, indent + "  ")

# Visualize raycasts for selection
static func debug_selection_raycast(main_scene) -> void:
	# Replace the _handle_selection method with a version that visualizes raycasts
	if main_scene.has_method("_handle_selection"):
		var original_method = main_scene._handle_selection
		
		# Replace with debugged version
		main_scene._handle_selection = func(click_position):
			print("DEBUG: Visualizing selection raycast at " + str(click_position))
			visualize_raycast(click_position, main_scene.camera)
			
			# Call the original method
			original_method.call(click_position)
		
		print("DEBUG: Selection raycast visualization enabled")
	else:
		print("DEBUG: Could not find _handle_selection method to debug")
