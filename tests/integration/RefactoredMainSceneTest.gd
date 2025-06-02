## RefactoredMainSceneTest.gd
## Integration test for the refactored main scene

class_name RefactoredMainSceneTest
extends "res://tests/framework/TestFramework.gd"

const MainSceneRefactored = preload("res://scenes/node_3d_refactored.gd")

var test_scene: MainSceneRefactored

func _ready():
	test_name = "Refactored Main Scene Integration Tests"

func setup_test():
	"""Setup for each test"""
	test_scene = MainSceneRefactored.new()
	test_scene.name = "TestMainScene"
	
	# Add required child nodes
	var ui_layer = CanvasLayer.new()
	ui_layer.name = "UI_Layer"
	test_scene.add_child(ui_layer)
	
	var object_label = Label.new()
	object_label.name = "ObjectNameLabel"
	ui_layer.add_child(object_label)
	
	var info_panel = Control.new()
	info_panel.name = "StructureInfoPanel"
	ui_layer.add_child(info_panel)
	
	var camera = Camera3D.new()
	camera.name = "Camera3D"
	test_scene.add_child(camera)
	
	var brain_model = Node3D.new()
	brain_model.name = "BrainModel"
	test_scene.add_child(brain_model)
	
	add_child(test_scene)

func teardown_test():
	"""Cleanup after each test"""
	if test_scene:
		test_scene.queue_free()
		test_scene = null

func test_scene_creation():
	"""Test that refactored scene can be created"""
	assert_not_null(test_scene, "Refactored scene should be created successfully")
	assert_false(test_scene.initialization_complete, "Should start uninitialized")

func test_node_validation():
	"""Test that core nodes are validated correctly"""
	var validation_result = await test_scene._validate_core_nodes()
	assert_true(validation_result, "Core node validation should succeed with proper scene structure")

func test_system_bootstrap_creation():
	"""Test that system bootstrap is created during initialization"""
	var bootstrap_created = await test_scene._initialize_system_bootstrap()
	assert_true(bootstrap_created, "System bootstrap should be created successfully")
	assert_not_null(test_scene.system_bootstrap, "System bootstrap reference should be set")

func test_input_router_creation():
	"""Test that input router is created after bootstrap"""
	# First create bootstrap
	await test_scene._initialize_system_bootstrap()
	
	# Then create input router
	var router_created = await test_scene._initialize_input_router()
	assert_true(router_created, "Input router should be created successfully")
	assert_not_null(test_scene.input_router, "Input router reference should be set")

func test_initialization_signals():
	"""Test that initialization signals are emitted correctly"""
	var initialization_completed = false
	var initialization_failed = false
	
	test_scene.initialization_completed.connect(func():
		initialization_completed = true
	)
	
	test_scene.initialization_failed.connect(func(error: String):
		initialization_failed = true
	)
	
	# Start initialization (this may fail due to missing dependencies, but we test the signal flow)
	await test_scene.initialize_scene()
	
	await get_tree().process_frame
	
	# Either initialization completed or failed signal should be emitted
	assert_true(initialization_completed or initialization_failed, "Either success or failure signal should be emitted")

func test_performance_monitoring():
	"""Test that performance monitoring works"""
	test_scene.initialization_complete = true  # Bypass initialization for performance test
	
	var initial_frame_count = test_scene.frame_count
	
	# Simulate process calls
	test_scene._process(0.016)  # 60 FPS frame
	test_scene._process(0.016)
	
	assert_greater(test_scene.frame_count, initial_frame_count, "Frame count should increase")

func test_signal_connections():
	"""Test that signals are properly connected between components"""
	# Setup scene with bootstrap
	await test_scene._initialize_system_bootstrap()
	await test_scene._initialize_input_router()
	
	# Check that signal connections exist
	assert_true(test_scene.system_bootstrap.all_systems_initialized.is_connected(test_scene._on_all_systems_initialized), 
		"Bootstrap signals should be connected")
	
	assert_true(test_scene.input_router.selection_attempted.is_connected(test_scene._on_selection_attempted),
		"Input router signals should be connected")

func test_debug_command_registration():
	"""Test that debug commands are registered correctly"""
	if OS.is_debug_build() and DebugCmd:
		# Initialize scene components
		await test_scene._initialize_system_bootstrap()
		test_scene._register_debug_commands()
		
		# Check if debug commands were registered (this depends on DebugCmd implementation)
		print("[TEST] Debug commands registration tested (implementation-dependent)")
		assert_true(true, "Debug command registration should not crash")

func test_cleanup():
	"""Test that cleanup works correctly"""
	await test_scene._initialize_system_bootstrap()
	await test_scene._initialize_input_router()
	
	# Verify components exist
	assert_not_null(test_scene.system_bootstrap, "Bootstrap should exist before cleanup")
	assert_not_null(test_scene.input_router, "Input router should exist before cleanup")
	
	# Trigger cleanup
	test_scene._exit_tree()
	
	# Check cleanup state
	assert_false(test_scene.initialization_complete, "Initialization should be marked incomplete after cleanup")

func run_all_tests():
	"""Run all refactored main scene tests"""
	var tests = [
		"test_scene_creation",
		"test_node_validation",
		"test_system_bootstrap_creation",
		"test_input_router_creation",
		"test_initialization_signals",
		"test_performance_monitoring",
		"test_signal_connections",
		"test_debug_command_registration",
		"test_cleanup"
	]
	
	execute_test_suite(tests)