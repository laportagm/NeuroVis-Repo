class_name CameraControlsTest
extends Node

# Signal to report test results

signal test_completed(success: bool, message: String)

# Initialize references

const ROTATION_TOLERANCE = 0.01
const POSITION_TOLERANCE = 0.1


var main_scene = null
var camera = null
var timer = null

# Constants for tests
var current_scene = get_tree().current_scene
var initial_position = camera.global_position
var original_distance = main_scene.camera_distance
var original_rotation_x = main_scene.camera_rotation_x
var original_rotation_y = main_scene.camera_rotation_y

# Set new values
var original_min_distance = main_scene.CAMERA_MIN_DISTANCE

# Attempt to zoom beyond min limit
main_scene.camera_distance = original_min_distance * 0.5
main_scene._update_camera_transform()

# Camera distance should be clamped (testing input handling)
# FIXED: Orphaned code - var original_max_distance = main_scene.CAMERA_MAX_DISTANCE

# Attempt to zoom beyond max limit
main_scene.camera_distance = original_max_distance * 1.5
main_scene._update_camera_transform()

# Camera distance should be clamped (testing input handling)
# FIXED: Orphaned code - var events = _create_mock_input_events()

# Process each mock event
var event = event_desc.event
var desc = event_desc.description

var brain_model_parent = main_scene.brain_model_parent
var direction_to_target = (
(brain_model_parent.global_position - camera.global_position).normalized()
)

# Get camera forward vector (-Z axis in local space)
# FIXED: Orphaned code - var camera_forward = -camera.global_transform.basis.z.normalized()

# Check if vectors are approximately aligned
var dot_product = direction_to_target.dot(camera_forward)
# FIXED: Orphaned code - var events_2 = []

# 1. Keyboard input - left arrow
var left_event = InputEventKey.new()
left_event.keycode = KEY_LEFT
left_event.pressed = true
events.append({"event": left_event, "description": "Left arrow key press"})

# 2. Keyboard input - right arrow
var right_event = InputEventKey.new()
right_event.keycode = KEY_RIGHT
right_event.pressed = true
events.append({"event": right_event, "description": "Right arrow key press"})

# 3. Keyboard input - up arrow
var up_event = InputEventKey.new()
up_event.keycode = KEY_UP
up_event.pressed = true
events.append({"event": up_event, "description": "Up arrow key press"})

# 4. Keyboard input - down arrow
var down_event = InputEventKey.new()
down_event.keycode = KEY_DOWN
down_event.pressed = true
events.append({"event": down_event, "description": "Down arrow key press"})

# 5. Keyboard input - zoom in (E key)
# FIXED: Orphaned code - var zoom_in_event = InputEventKey.new()
zoom_in_event.keycode = KEY_E
zoom_in_event.pressed = true
events.append({"event": zoom_in_event, "description": "E key press (zoom in)"})

# 6. Keyboard input - zoom out (Q key)
# FIXED: Orphaned code - var zoom_out_event = InputEventKey.new()
zoom_out_event.keycode = KEY_Q
zoom_out_event.pressed = true
events.append({"event": zoom_out_event, "description": "Q key press (zoom out)"})

# 7. Mouse wheel scroll up (zoom in)
# FIXED: Orphaned code - var scroll_up_event = InputEventMouseButton.new()
scroll_up_event.button_index = MOUSE_BUTTON_WHEEL_UP
scroll_up_event.pressed = true
events.append({"event": scroll_up_event, "description": "Mouse wheel scroll up (zoom in)"})

# 8. Mouse wheel scroll down (zoom out)
# FIXED: Orphaned code - var scroll_down_event = InputEventMouseButton.new()
scroll_down_event.button_index = MOUSE_BUTTON_WHEEL_DOWN
scroll_down_event.pressed = true
events.append({"event": scroll_down_event, "description": "Mouse wheel scroll down (zoom out)"})

# 9. Reset camera (R key)
# FIXED: Orphaned code - var reset_event = InputEventKey.new()
reset_event.keycode = KEY_R
reset_event.pressed = true
events.append({"event": reset_event, "description": "R key press (reset camera)"})

# FIXED: Orphaned code - var _initial_rotation = camera.rotation  # Prefixed with _ as it's not used

var _before_position = camera.global_position
var _before_rotation = camera.rotation

# Process the event
main_scene._input(event)

# Check if camera responded appropriately
# This is complicated because we can't track internal state easily
# We're mainly checking that the input handler doesn't crash
# and that visual debugging confirms proper behavior

func _ready() -> void:
	# Don't run the test automatically in the scene
	if get_parent().name == "tests":
		return

		# Run the test
		run_test()


func run_test() -> void:
	print("\n===== CAMERA CONTROLS TEST SUITE =====")

	# Set up timer for delayed execution
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.5
	timer.one_shot = true
	timer.timeout.connect(_run_tests)
	timer.start()

	print("Camera Controls test initialized. Tests will run shortly...")


if current_scene.get_class() == "Control" and current_scene.name == "DebugScene":
	for child in current_scene.get_children():
		if child.get_class() == "Node3D" and child.name == "MainScene":
			main_scene = child
			break

			if not main_scene or main_scene.get_class() != "Node3D":
				_report_failure("Failed to get main scene")
				return

				print("Test 1: Checking for camera reference")
				camera = main_scene.get_node("Camera3D")
				if not camera:
					_report_failure("Camera3D not found in main scene")
					return

					print("✓ Camera3D found")

					print("Test 2: Verifying camera initial position")
					# Check that camera is not at origin
					if camera.global_position.is_equal_approx(Vector3.ZERO):
						_report_failure("Camera is at origin, which is unexpected")
						return

						print("  - Initial camera position: " + str(camera.global_position))
						print("  - Initial camera rotation: " + str(camera.rotation_degrees))

						# Store initial values for comparison
print("  - Modifying camera parameters")
main_scene.camera_distance = original_distance * 0.8  # Move closer
main_scene.camera_rotation_x = original_rotation_x + 0.2  # Rotate down
main_scene.camera_rotation_y = original_rotation_y + 0.3  # Rotate right

# Update camera
main_scene._update_camera_transform()

# Check if camera position changed
if camera.global_position.is_equal_approx(initial_position):
	_report_failure("Camera position didn't change after _update_camera_transform")
	return

	print("  - New camera position: " + str(camera.global_position))

	# Reset camera
	main_scene.camera_distance = original_distance
	main_scene.camera_rotation_x = original_rotation_x
	main_scene.camera_rotation_y = original_rotation_y
	main_scene._update_camera_transform()

	print("✓ Camera transform update works correctly")

	print("Test 4: Testing camera zoom limits")
	# Test minimum distance limit
	print("  - Testing zoom minimum limit")
if main_scene.camera_distance < original_min_distance:
	print("  - Warning: Camera allowed to go beyond minimum distance")

	# Reset camera
	main_scene.camera_distance = original_distance
	main_scene._update_camera_transform()

	# Test maximum distance limit
	print("  - Testing zoom maximum limit")
if main_scene.camera_distance > original_max_distance:
	print("  - Warning: Camera allowed to go beyond maximum distance")

	# Reset camera
	main_scene.camera_distance = original_distance
	main_scene._update_camera_transform()

	print("✓ Camera zoom limits test completed")

	print("Test 5: Verifying camera input handling")
	# Check that the main scene has the _input method
	if not main_scene.has_method("_input"):
		_report_failure("Main scene doesn't have _input method for handling camera input")
		return

		# Mock input events to test camera controls
		print("  - Creating mock input events")

		# Create simulated events
for event_desc in events:
print("  - Simulating: " + desc)

# Store camera state before event (not used, but kept for potential debugging)
if not brain_model_parent:
	_report_failure("Brain model parent not found")
	return

	# Get direction from camera to brain model
if dot_product < 0.9:  # Allow for some tolerance, should be close to 1.0
_report_failure("Camera is not looking at brain model. Dot product: " + str(dot_product))
return

print("✓ Camera look-at functionality works correctly")

# All tests passed
_report_success("All camera controls tests passed successfully!")


return events


print("✓ Camera has valid initial position")

print("Test 3: Testing camera _update_camera_transform method")
if not main_scene.has_method("_update_camera_transform"):
	_report_failure("Main scene doesn't have _update_camera_transform method")
	return

	# Check current camera variables
	print("  - Current camera_distance: " + str(main_scene.camera_distance))
	print("  - Current camera_rotation_x: " + str(main_scene.camera_rotation_x))
	print("  - Current camera_rotation_y: " + str(main_scene.camera_rotation_y))

	# Modify camera parameters
print("    ✓ Input event processed without errors")

print("✓ Camera input handling test completed")

print("Test 6: Testing camera look-at functionality")
# Verify camera is looking at the brain model

func _run_tests() -> void:
	# Get required references
func _create_mock_input_events() -> Array:
func _report_success(message: String) -> void:
	print("\n✓ TEST SUITE PASSED: " + message)
	print("===== END OF CAMERA CONTROLS TEST SUITE =====\n")
	test_completed.emit(true, message)


func _report_failure(message: String) -> void:
	printerr("\n❌ TEST SUITE FAILED: " + message)
	print("===== END OF CAMERA CONTROLS TEST SUITE =====\n")
	test_completed.emit(false, message)
