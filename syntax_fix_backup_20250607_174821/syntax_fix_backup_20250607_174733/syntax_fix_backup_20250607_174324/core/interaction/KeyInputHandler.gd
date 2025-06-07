extends Node
class_name KeyInputHandler

# Camera control constants - defined locally with reasonable defaults

const CAMERA_ROTATION_SPEED: float = 0.01  # Radians per pixel of mouse movement
const CAMERA_ZOOM_SPEED: float = 0.5  # Units per zoom step
const CAMERA_MIN_DISTANCE: float = 2.0  # Minimum camera distance from target
const CAMERA_MAX_DISTANCE: float = 20.0  # Maximum camera distance from target

# Camera state variables - declared as member variables

var camera_rotation_x: float = 0.3  # Vertical rotation in radians
var camera_rotation_y: float = 0.0  # Horizontal rotation in radians
var camera_distance: float = 10.0  # Distance from camera to target

# Mouse interaction state variables
var is_rotating: bool = false  # Whether middle mouse is held for rotation
var last_mouse_position: Vector2  # Last recorded mouse position

# References to other nodes - will be set via dependency injection or node finding
var camera_3d: Camera3D  # Reference to the 3D camera node
var structure_labeler: Node  # Reference to structure labeling system
var main_scene: Node  # Reference to main scene for selection handling


var parent = get_parent()
var handled = true

match event.keycode:
	# Camera rotation
	KEY_LEFT, KEY_A:  # Rotate camera left
	camera_rotation_y += CAMERA_ROTATION_SPEED * 4.0
	KEY_RIGHT, KEY_D:  # Rotate camera right
	camera_rotation_y -= CAMERA_ROTATION_SPEED * 4.0
	KEY_UP, KEY_W:  # Rotate camera up
	camera_rotation_x += CAMERA_ROTATION_SPEED * 4.0
	KEY_DOWN, KEY_S:  # Rotate camera down
	camera_rotation_x -= CAMERA_ROTATION_SPEED * 4.0

	# Camera zoom
	KEY_Q, KEY_MINUS:  # Zoom out
	camera_distance = min(camera_distance + CAMERA_ZOOM_SPEED, CAMERA_MAX_DISTANCE)
	KEY_E, KEY_PLUS, KEY_EQUAL:  # Zoom in
	camera_distance = max(camera_distance - CAMERA_ZOOM_SPEED, CAMERA_MIN_DISTANCE)

	# Reset camera
	KEY_R:  # Reset camera to default position
	camera_rotation_x = 0.3
	camera_rotation_y = 0.0
	camera_distance = 10.0

	# Toggle structure labels
	KEY_L:  # Toggle structure name labels in 3D view
var motion = event.position - last_mouse_position
	camera_rotation_y -= motion.x * CAMERA_ROTATION_SPEED
	camera_rotation_x -= motion.y * CAMERA_ROTATION_SPEED

	# Limit vertical rotation to avoid flipping
	camera_rotation_x = clamp(camera_rotation_x, -1.2, 1.2)

	_update_camera_transform()
	last_mouse_position = event.position
	get_viewport().set_input_as_handled()


	# Fixed function definition - was missing function body
var target_position = Vector3.ZERO  # Camera looks at origin

# Convert rotation angles to position offset
var x_offset = cos(camera_rotation_y) * cos(camera_rotation_x) * camera_distance
var y_offset = sin(camera_rotation_x) * camera_distance
var z_offset = sin(camera_rotation_y) * cos(camera_rotation_x) * camera_distance

# Set camera position and make it look at target
	camera_3d.position = target_position + Vector3(x_offset, y_offset, z_offset)
	camera_3d.look_at(target_position, Vector3.UP)


	# Added missing selection handling function
var space_state = get_viewport().world_3d.direct_space_state
var from = camera_3d.project_ray_origin(mouse_position)
var to = from + camera_3d.project_ray_normal(mouse_position) * 1000.0

var query = PhysicsRayQueryParameters3D.create(from, to)
var result = space_state.intersect_ray(query)

func _ready() -> void:
	# Find required nodes in the scene tree
	# These should be set by the parent scene or found automatically
	_find_required_nodes()


func set_camera_reference(camera: Camera3D) -> void:
	# Allow external setting of camera reference
	camera_3d = camera


func set_structure_labeler_reference(labeler: Node) -> void:
	# Allow external setting of structure labeler reference
	structure_labeler = labeler


func set_main_scene_reference(scene: Node) -> void:
	# Allow external setting of main scene reference
	main_scene = scene


func get_camera_distance() -> float:
	# Getter for current camera distance
	return camera_distance


func get_camera_rotation() -> Vector2:
	# Getter for current camera rotation
	return Vector2(camera_rotation_x, camera_rotation_y)

func _fix_orphaned_code():
	if parent:
		camera_3d = parent.find_child("Camera3D", true, false)
		structure_labeler = parent.find_child("StructureLabeler", true, false)
		main_scene = parent


func _fix_orphaned_code():
	if structure_labeler and structure_labeler.has_method("toggle_labels_visibility"):
		structure_labeler.toggle_labels_visibility()

		_:  # If no match, mark as not handled
		handled = false

		# If we handled a key, update camera and mark as handled
		if handled:
			# Clamp vertical rotation to prevent camera flipping
			camera_rotation_x = clamp(camera_rotation_x, -1.2, 1.2)
			_update_camera_transform()  # Fixed: removed extra parenthesis
			get_viewport().set_input_as_handled()
			return

			# Handle mouse buttons (selection, rotation)
			if event is InputEventMouseButton:
				if event.button_index == MOUSE_BUTTON_WHEEL_UP:
					# Zoom in
					camera_distance = max(camera_distance - CAMERA_ZOOM_SPEED, CAMERA_MIN_DISTANCE)
					_update_camera_transform()
					get_viewport().set_input_as_handled()

					elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
						# Zoom out
						camera_distance = min(camera_distance + CAMERA_ZOOM_SPEED, CAMERA_MAX_DISTANCE)
						_update_camera_transform()
						get_viewport().set_input_as_handled()

						# Handle middle mouse button for camera rotation
						elif event.button_index == MOUSE_BUTTON_MIDDLE:
							is_rotating = event.pressed
							last_mouse_position = event.position
							get_viewport().set_input_as_handled()

							# Handle left mouse click for selection
							elif event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
								_handle_selection(event.position)
								get_viewport().set_input_as_handled()

								# Handle mouse motion for camera rotation
								elif event is InputEventMouseMotion and is_rotating:
func _fix_orphaned_code():
	if result:
		# Delegate selection handling to main scene if it has the method
		if main_scene and main_scene.has_method("_on_structure_selected"):
			main_scene._on_structure_selected(result.collider)
			else:
				print("Selected object: ", result.collider.name)


				# Public methods for external camera control

func _find_required_nodes() -> void:
	# Try to find camera in parent scene
func _input(event: InputEvent) -> void:
	# Handle keyboard input for camera control
	if event is InputEventKey and event.pressed:
func _update_camera_transform() -> void:
	# Update camera position based on rotation and distance
	if not camera_3d:
		return

		# Calculate camera position using spherical coordinates
func _handle_selection(mouse_position: Vector2) -> void:
	# Handle structure selection via raycasting
	if not camera_3d:
		return

		# Cast ray from camera through mouse position
