extends Node
class_name UpdatedInputHandlerFixed

# Camera control constants with reasonable defaults
const CAMERA_ROTATION_SPEED: float = 0.01
const CAMERA_ZOOM_SPEED: float = 0.5
const CAMERA_MIN_DISTANCE: float = 2.0
const CAMERA_MAX_DISTANCE: float = 20.0

# Camera state variables
var camera_rotation_x: float = 0.3
var camera_rotation_y: float = 0.0
var camera_distance: float = 10.0

# Mouse interaction state
var is_rotating: bool = false
var last_mouse_position: Vector2

# Node references
var camera_3d: Camera3D
var structure_labeler: Node
var main_scene: Node

func _ready() -> void:
	_find_required_nodes()

func _find_required_nodes() -> void:
	var parent = get_parent()
	if parent:
		camera_3d = parent.find_child("Camera3D", true, false)
		structure_labeler = parent.find_child("StructureLabeler", true, false)
		main_scene = parent

func _input(event: InputEvent) -> void:
	# Handle keyboard input
	if event is InputEventKey and event.pressed:
		var handled = true
		
		match event.keycode:
			KEY_LEFT, KEY_A:
				camera_rotation_y += CAMERA_ROTATION_SPEED * 4.0
				print("Camera rotating left")
			KEY_RIGHT, KEY_D:
				camera_rotation_y -= CAMERA_ROTATION_SPEED * 4.0
				print("Camera rotating right")
			KEY_UP, KEY_W:
				camera_rotation_x += CAMERA_ROTATION_SPEED * 4.0
				print("Camera rotating up")
			KEY_DOWN, KEY_S:
				camera_rotation_x -= CAMERA_ROTATION_SPEED * 4.0
				print("Camera rotating down")
			KEY_Q, KEY_MINUS:
				camera_distance = min(camera_distance + CAMERA_ZOOM_SPEED, CAMERA_MAX_DISTANCE)
				print("Camera zooming out: ", camera_distance)
			KEY_E, KEY_PLUS, KEY_EQUAL:
				camera_distance = max(camera_distance - CAMERA_ZOOM_SPEED, CAMERA_MIN_DISTANCE)
				print("Camera zooming in: ", camera_distance)
			KEY_R:
				camera_rotation_x = 0.3
				camera_rotation_y = 0.0
				camera_distance = 10.0
				print("Camera reset")
			KEY_L:
				if structure_labeler and structure_labeler.has_method("toggle_labels_visibility"):
					structure_labeler.toggle_labels_visibility()
					var labels_visible = structure_labeler.get("labels_visible")
					if labels_visible != null:
						print("Structure labels toggled - now visible: ", labels_visible)
					else:
						print("Structure labels toggled")
			_:
				handled = false
				
		if handled:
			camera_rotation_x = clamp(camera_rotation_x, -1.2, 1.2)
			_update_camera_transform()
			get_viewport().set_input_as_handled()
			return
	
	# Handle mouse buttons
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			camera_distance = max(camera_distance - CAMERA_ZOOM_SPEED, CAMERA_MIN_DISTANCE)
			_update_camera_transform()
			print("Mouse wheel zoom in: ", camera_distance)
			get_viewport().set_input_as_handled()
			
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camera_distance = min(camera_distance + CAMERA_ZOOM_SPEED, CAMERA_MAX_DISTANCE)
			_update_camera_transform()
			print("Mouse wheel zoom out: ", camera_distance)
			get_viewport().set_input_as_handled()
			
		elif event.button_index == MOUSE_BUTTON_MIDDLE:
			is_rotating = event.pressed
			last_mouse_position = event.position
			print("Middle button rotation: ", is_rotating)
			get_viewport().set_input_as_handled()
			
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			is_rotating = event.pressed
			last_mouse_position = event.position
			print("Right button rotation: ", is_rotating)
			get_viewport().set_input_as_handled()
			
		elif event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if Input.is_key_pressed(KEY_ALT):
				is_rotating = true
				last_mouse_position = event.position
				print("Alt+Left button rotation active")
				get_viewport().set_input_as_handled()
			else:
				_handle_selection(event.position)
				get_viewport().set_input_as_handled()
				
		elif event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and Input.is_key_pressed(KEY_ALT):
			is_rotating = false
			print("Alt+Left button rotation ended")
			get_viewport().set_input_as_handled()
	
	# Handle mouse motion
	elif event is InputEventMouseMotion:
		if event.button_mask != 0:
			print("Motion with button mask: ", event.button_mask)
			
		if event.button_mask & 0x2:  # Right button
			is_rotating = true
		elif event.button_mask & 0x4:  # Middle button
			is_rotating = true
		elif (event.button_mask & 0x1) and Input.is_key_pressed(KEY_ALT):  # Left + Alt
			is_rotating = true
			
		if is_rotating:
			var motion = event.position - last_mouse_position
			camera_rotation_y -= motion.x * CAMERA_ROTATION_SPEED
			camera_rotation_x -= motion.y * CAMERA_ROTATION_SPEED
			camera_rotation_x = clamp(camera_rotation_x, -1.2, 1.2)
			_update_camera_transform()
			get_viewport().set_input_as_handled()
		
		last_mouse_position = event.position

func _update_camera_transform() -> void:
	if not camera_3d:
		return
		
	var target_position = Vector3.ZERO
	var x_offset = cos(camera_rotation_y) * cos(camera_rotation_x) * camera_distance
	var y_offset = sin(camera_rotation_x) * camera_distance  
	var z_offset = sin(camera_rotation_y) * cos(camera_rotation_x) * camera_distance
	
	camera_3d.position = target_position + Vector3(x_offset, y_offset, z_offset)
	camera_3d.look_at(target_position, Vector3.UP)

func _handle_selection(mouse_position: Vector2) -> void:
	if not camera_3d:
		return
		
	var space_state = get_viewport().world_3d.direct_space_state
	var from = camera_3d.project_ray_origin(mouse_position)
	var to = from + camera_3d.project_ray_normal(mouse_position) * 1000.0
	
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)
	
	if result:
		if main_scene and main_scene.has_method("_on_structure_selected"):
			main_scene._on_structure_selected(result.collider)
		else:
			print("Selected object: ", result.collider.name)

# Public interface methods
func set_camera_reference(camera: Camera3D) -> void:
	camera_3d = camera

func set_structure_labeler_reference(labeler: Node) -> void:
	structure_labeler = labeler

func set_main_scene_reference(scene: Node) -> void:
	main_scene = scene

func get_camera_distance() -> float:
	return camera_distance

func get_camera_rotation() -> Vector2:
	return Vector2(camera_rotation_x, camera_rotation_y)