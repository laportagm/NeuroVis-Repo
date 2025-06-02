class_name DebugVisualizer
extends Node

# Debug visualization settings
var visualizations_enabled: bool = true
var show_raycasts: bool = true
var show_collision_shapes: bool = true
var show_model_labels: bool = true

# Visualization objects
var ray_visuals = []
var collision_visuals = []
var label_visuals = []

# Ray visualization properties
var ray_color: Color = Color(1, 0, 0, 1)
var ray_width: float = 2.0
var ray_length: float = 1000.0

# Parent scene reference
var main_scene = null

# Debug font
var debug_font: Font = null

func _ready() -> void:
	print("DebugVisualizer initialized")
	
	# Get the main scene
	main_scene = get_parent()
	
	# Set up debug font
	debug_font = ThemeDB.fallback_font
	
	# Create visualization containers
	_create_visualization_containers()
	
	# Add visualization update to physics process
	set_physics_process(visualizations_enabled)
	
	# Connect to selection signals if they exist
	if main_scene.has_signal("structure_selected"):
		main_scene.structure_selected.connect(_on_structure_selected)
	
	# Hook into the scene's input event handler to capture raycasts
	if main_scene.has_method("_handle_selection"):
		# Store the original method
		var original_method = main_scene._handle_selection
		
		# Replace with our debugged version
		main_scene._handle_selection = func(click_position):
			# Call the original method
			original_method.call(click_position)
			
			# Visualize the raycast if enabled
			if visualizations_enabled and show_raycasts:
				_visualize_raycast(click_position)
	
	# Add model labels if enabled
	if visualizations_enabled and show_model_labels:
		_update_model_labels()

func _physics_process(_delta: float) -> void:
	if not visualizations_enabled:
		return
	
	# Update ray visualizations if needed
	if show_raycasts:
		_update_ray_visualizations()
	
	# Update collision shape visualizations if needed
	if show_collision_shapes:
		_update_collision_visualizations()
	
	# Update model labels if needed
	if show_model_labels:
		_update_model_labels()

func _create_visualization_containers() -> void:
	# Create containers for visualizations
	var ray_container = Node3D.new()
	ray_container.name = "RayVisualizations"
	add_child(ray_container)
	
	var collision_container = Node3D.new()
	collision_container.name = "CollisionVisualizations"
	add_child(collision_container)
	
	var label_container = Node3D.new()
	label_container.name = "LabelVisualizations"
	add_child(label_container)

func _visualize_raycast(click_position: Vector2) -> void:
	# Get camera and create ray
	var camera = main_scene.camera
	if not camera:
		return
	
	var from = camera.project_ray_origin(click_position)
	var to = from + camera.project_ray_normal(click_position) * ray_length
	
	# Create a 3D line for visualization
	var ray_container = get_node("RayVisualizations")
	
	# Create immediate geometry
	var immediate_mesh = ImmediateMesh.new()
	var material = StandardMaterial3D.new()
	material.albedo_color = ray_color
	material.emission_enabled = true
	material.emission = ray_color
	material.emission_energy_multiplier = 2.0
	
	# Draw the line
	immediate_mesh.clear_surfaces()
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	immediate_mesh.surface_add_vertex(from)
	immediate_mesh.surface_add_vertex(to)
	immediate_mesh.surface_end()
	
	# Create mesh instance and add to scene
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = immediate_mesh
	mesh_instance.material_override = material
	
	# Store in ray container
	ray_container.add_child(mesh_instance)
	ray_visuals.append(mesh_instance)
	
	# Add a timer to remove the visualization after a few seconds
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 3.0
	timer.one_shot = true
	timer.timeout.connect(func():
		if mesh_instance and mesh_instance.is_inside_tree():
			mesh_instance.queue_free()
		if timer and timer.is_inside_tree():
			timer.queue_free()
		if ray_visuals.has(mesh_instance):
			ray_visuals.erase(mesh_instance)
	)
	timer.start()

func _update_ray_visualizations() -> void:
	# This function could update any dynamic raycasts, like continuous collision detection
	pass

func _update_collision_visualizations() -> void:
	# Only recreate if needed
	if collision_visuals.size() == 0:
		_create_collision_visualizations()

func _create_collision_visualizations() -> void:
	# Clear existing collision visuals
	for visual in collision_visuals:
		if visual and visual.is_inside_tree():
			visual.queue_free()
	collision_visuals.clear()
	
	# Get the collision container
	var collision_container = get_node("CollisionVisualizations")
	
	# Find all collision shapes in the scene
	_visualize_collision_shapes(main_scene, collision_container)

func _visualize_collision_shapes(node: Node, container: Node) -> void:
	# Handle collision shapes
	if node is CollisionShape3D and node.shape != null:
		# Create a visual representation of the collision shape
		var visual = _create_collision_shape_visual(node)
		if visual:
			container.add_child(visual)
			collision_visuals.append(visual)
	
	# Recursively check children
	for child in node.get_children():
		_visualize_collision_shapes(child, container)

func _create_collision_shape_visual(collision_shape: CollisionShape3D) -> MeshInstance3D:
	var mesh_instance = MeshInstance3D.new()
	var material = StandardMaterial3D.new()
	
	# Set up material
	material.albedo_color = Color(0, 1, 0, 0.3) # Green, semi-transparent
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	
	# Create mesh based on shape type
	var shape = collision_shape.shape
	var mesh = null
	
	if shape is BoxShape3D:
		mesh = BoxMesh.new()
		mesh.size = shape.size
	elif shape is SphereShape3D:
		mesh = SphereMesh.new()
		mesh.radius = shape.radius
		mesh.height = shape.radius * 2
	elif shape is CapsuleShape3D:
		mesh = CapsuleMesh.new()
		mesh.radius = shape.radius
		mesh.height = shape.height
	elif shape is CylinderShape3D:
		mesh = CylinderMesh.new()
		mesh.radius = shape.radius
		mesh.height = shape.height
	else:
		# For other shapes, use a simple box
		mesh = BoxMesh.new()
		mesh.size = Vector3(0.1, 0.1, 0.1)
	
	# Set up mesh instance
	mesh_instance.mesh = mesh
	mesh_instance.material_override = material
	
	# Match the transform of the collision shape
	mesh_instance.transform = collision_shape.global_transform
	
	return mesh_instance

func _update_model_labels() -> void:
	# Only recreate if needed
	if label_visuals.size() == 0:
		_create_model_labels()

func _create_model_labels() -> void:
	# Clear existing labels
	for label in label_visuals:
		if label and label.is_inside_tree():
			label.queue_free()
	label_visuals.clear()
	
	# Get label container
	var label_container = get_node("LabelVisualizations")
	
	# Get brain model nodes
	if main_scene.has_node("BrainModel"):
		var brain_model = main_scene.get_node("BrainModel")
		
		# Add labels for each child
		for child in brain_model.get_children():
			_add_label_for_node(child, label_container)

func _add_label_for_node(node: Node3D, container: Node) -> void:
	if not (node is Node3D):
		return
	
	# Create a 3D text label
	var label_3d = Label3D.new()
	label_3d.text = node.name
	label_3d.font = debug_font
	label_3d.font_size = 14
	label_3d.no_depth_test = true
	label_3d.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label_3d.fixed_size = true
	label_3d.modulate = Color(1, 1, 0) # Yellow
	
	# Position the label
	label_3d.position = node.global_position + Vector3(0, 0.5, 0) # Offset to position above the object
	
	# Add to container
	container.add_child(label_3d)
	label_visuals.append(label_3d)
	
	# Recursively add labels for children that are MeshInstance3D
	for child in node.get_children():
		if child is MeshInstance3D:
			_add_label_for_node(child, container)

func _on_structure_selected(structure_name: String) -> void:
	# Update visualization to highlight selected structure
	if not visualizations_enabled:
		return
	
	print("Debug: Structure selected: " + structure_name)