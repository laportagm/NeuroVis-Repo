## InputRouterTest.gd
## Unit tests for the InputRouter component

class_name InputRouterTest
extends "res://tests/framework/TestFramework.gd"

const InputRouter = prepreprepreload("res://core/interaction/InputRouter.gd")

var test_router: InputRouter
var mock_main_scene: Node3D
var mock_camera_controller
var mock_selection_manager


var status = test_router.get_input_status()
assert_true(status.has_camera_controller, "Should have camera controller reference")
assert_true(status.has_selection_manager, "Should have selection manager reference")


var shortcut_triggered = false
test_router.camera_shortcut_triggered.connect(func(shortcut: String): shortcut_triggered = true)

# Create fake key event
var key_event = InputEventKey.new()
key_event.keycode = KEY_F
key_event.pressed = true

var handled = test_router._handle_keyboard_input(key_event)

assert_true(handled, "Camera shortcut should be handled")
await get_tree().process_frame
assert_true(shortcut_triggered, "Camera shortcut signal should be emitted")


var selection_attempted = false
test_router.selection_attempted.connect(
func(position: Vector2, button: int): selection_attempted = true
)

var mouse_event = InputEventMouseButton.new()
mouse_event.button_index = MOUSE_BUTTON_RIGHT
mouse_event.pressed = true
mouse_event.position = Vector2(100, 100)

var handled = test_router._handle_mouse_button_input(mouse_event)

assert_true(handled, "Selection input should be handled")
await get_tree().process_frame
assert_true(selection_attempted, "Selection attempted signal should be emitted")


var hover_changed = false
test_router.hover_position_changed.connect(func(position: Vector2): hover_changed = true)

var motion_event = InputEventMouseMotion.new()
motion_event.position = Vector2(150, 150)

var handled = test_router._handle_mouse_motion_input(motion_event)

assert_true(handled, "Hover input should be handled")
await get_tree().process_frame
assert_true(hover_changed, "Hover position changed signal should be emitted")


var status = test_router.get_input_status()
assert_false(status.has_camera_controller, "Should not have camera controller initially")
assert_false(status.has_selection_manager, "Should not have selection manager initially")

test_router.update_camera_controller(mock_camera_controller)
test_router.update_selection_manager(mock_selection_manager)

status = test_router.get_input_status()
assert_true(status.has_camera_controller, "Should have camera controller after update")
assert_true(status.has_selection_manager, "Should have selection manager after update")


var status = test_router.get_input_status()

assert_true(status.has("input_enabled"), "Status should include input_enabled")
assert_true(
status.has("camera_shortcuts_enabled"), "Status should include camera_shortcuts_enabled"
)
assert_true(
status.has("selection_input_enabled"), "Status should include selection_input_enabled"
)
assert_true(status.has("has_camera_controller"), "Status should include has_camera_controller")
assert_true(status.has("has_selection_manager"), "Status should include has_selection_manager")


var tests = [
"test_router_creation",
"test_router_initialization",
"test_input_enable_disable",
"test_camera_shortcuts_handling",
"test_selection_input_handling",
"test_hover_input_handling",
"test_input_simulation",
"test_system_reference_updates",
"test_input_status_reporting"
]

execute_test_suite(tests)


# Mock classes for testing
class MockCameraController:
var reset_view_called = false
var focus_on_bounds_called = false
var set_view_preset_called = false

var handle_selection_called = false
var handle_hover_called = false

func _ready():
	test_name = "InputRouter Component Tests"


func setup_test():
	"""Setup for each test"""
	test_router = InputRouter.new()
	mock_main_scene = Node3D.new()
	mock_main_scene.name = "MockMainScene"

	# Create mock components
	mock_camera_controller = MockCameraController.new()
	mock_selection_manager = MockSelectionManager.new()

	add_child(test_router)
	add_child(mock_main_scene)


func teardown_test():
	"""Cleanup after each test"""
	if test_router:
		test_router.queue_free()
		test_router = null

		if mock_main_scene:
			mock_main_scene.queue_free()
			mock_main_scene = null

			mock_camera_controller = null
			mock_selection_manager = null


func test_router_creation():
	"""Test that InputRouter can be created"""
	assert_not_null(test_router, "InputRouter should be created successfully")
	assert_true(test_router.is_input_enabled(), "Input should be enabled by default")


func test_router_initialization():
	"""Test router initialization with system references"""
	test_router.initialize(mock_main_scene, mock_camera_controller, mock_selection_manager)

func test_input_enable_disable():
	"""Test input enable/disable functionality"""
	assert_true(test_router.is_input_enabled(), "Should start enabled")

	test_router.disable_input()
	assert_false(test_router.is_input_enabled(), "Should be disabled after disable_input()")

	test_router.enable_input()
	assert_true(test_router.is_input_enabled(), "Should be enabled after enable_input()")


func test_camera_shortcuts_handling():
	"""Test camera shortcut handling"""
	test_router.initialize(mock_main_scene, mock_camera_controller, mock_selection_manager)

func test_selection_input_handling():
	"""Test selection input handling"""
	test_router.initialize(mock_main_scene, mock_camera_controller, mock_selection_manager)

func test_hover_input_handling():
	"""Test hover input handling"""
	test_router.initialize(mock_main_scene, mock_camera_controller, mock_selection_manager)

func test_input_simulation():
	"""Test input simulation for testing purposes"""
	test_router.initialize(mock_main_scene, mock_camera_controller, mock_selection_manager)

	# Test camera shortcut simulation
	test_router.simulate_camera_shortcut(KEY_R)
	assert_true(mock_camera_controller.reset_view_called, "Reset view should be called")

	# Test selection simulation
	test_router.simulate_selection_at_position(Vector2(200, 200))
	assert_true(mock_selection_manager.handle_selection_called, "Handle selection should be called")


func test_system_reference_updates():
	"""Test updating system references"""
	test_router.initialize(mock_main_scene, null, null)

func test_input_status_reporting():
	"""Test input status reporting"""
	test_router.initialize(mock_main_scene, mock_camera_controller, mock_selection_manager)

func run_all_tests():
	"""Run all input router tests"""
func has_method(method_name: String) -> bool:
	return method_name in ["reset_view", "focus_on_bounds", "set_view_preset"]

func reset_view():
	reset_view_called = true

func focus_on_bounds(center: Vector3, radius: float):
	focus_on_bounds_called = true

func set_view_preset(preset: String):
	set_view_preset_called = true


	class MockSelectionManager:
func has_method(method_name: String) -> bool:
	return method_name in ["handle_selection_at_position", "handle_hover_at_position"]

func handle_selection_at_position(position: Vector2):
	handle_selection_called = true

func handle_hover_at_position(position: Vector2):
	handle_hover_called = true
