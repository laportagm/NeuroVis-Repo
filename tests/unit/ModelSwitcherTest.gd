class_name ModelSwitcherUnitTest
extends RefCounted

const TestFramework = preload("res://tests/framework/TestFramework.gd")
var framework

func run_test() -> bool:
	framework = TestFramework.get_instance()
	
	# Test 1: ModelSwitcher Instantiation
	framework.start_test("ModelSwitcher Instantiation")
	var model_switcher = preload("res://core/models/ModelVisibilityManager.gd").new()
	framework.assert_not_null(model_switcher, "ModelSwitcher should instantiate")
	framework.assert_true(model_switcher.has_signal("model_visibility_changed"), "Should have visibility signal")
	var test1_result = framework.end_test()
	
	# Test 2: Model Registration
	framework.start_test("Model Registration")
	var mock_node = TestFramework.MockNode3D.new()
	mock_node.name = "TestModel"
	model_switcher.register_model(mock_node, "Test Model")
	
	var model_names = model_switcher.get_model_names()
	framework.assert_true(model_names.has("Test Model"), "Model should be registered")
	framework.assert_equal(1, model_names.size(), "Should have one registered model")
	var test2_result = framework.end_test()
	
	# Test 3: Model Visibility Toggle
	framework.start_test("Model Visibility Toggle")
	# Initially should be visible
	framework.assert_true(model_switcher.is_model_visible("Test Model"), "Model should be visible by default")
	
	# Toggle visibility
	model_switcher.toggle_model_visibility("Test Model")
	framework.assert_false(model_switcher.is_model_visible("Test Model"), "Model should be hidden after toggle")
	
	# Toggle back
	model_switcher.toggle_model_visibility("Test Model")
	framework.assert_true(model_switcher.is_model_visible("Test Model"), "Model should be visible after second toggle")
	var test3_result = framework.end_test()
	
	# Test 4: Invalid Model Handling
	framework.start_test("Invalid Model Handling")
	var invalid_model_names = model_switcher.get_model_names()
	var initial_count = invalid_model_names.size()
	
	# Try to toggle non-existent model
	model_switcher.toggle_model_visibility("NonExistentModel")
	framework.assert_equal(initial_count, model_switcher.get_model_names().size(), "Model count should remain unchanged")
	
	# Try to register null model
	model_switcher.register_model(null, "NullModel")
	framework.assert_equal(initial_count, model_switcher.get_model_names().size(), "Should not register null model")
	var test4_result = framework.end_test()
	
	# Test 5: Show/Hide All Models
	framework.start_test("Show/Hide All Models")
	# Register another model for testing
	var mock_node2 = TestFramework.MockNode3D.new()
	mock_node2.name = "TestModel2"
	model_switcher.register_model(mock_node2, "Test Model 2")
	
	# Hide all models
	model_switcher.hide_all_models()
	framework.assert_false(model_switcher.is_model_visible("Test Model"), "First model should be hidden")
	framework.assert_false(model_switcher.is_model_visible("Test Model 2"), "Second model should be hidden")
	
	# Show all models
	model_switcher.show_all_models()
	framework.assert_true(model_switcher.is_model_visible("Test Model"), "First model should be visible")
	framework.assert_true(model_switcher.is_model_visible("Test Model 2"), "Second model should be visible")
	var test5_result = framework.end_test()
	
	# Cleanup
	mock_node.queue_free()
	mock_node2.queue_free()
	model_switcher.queue_free()
	
	print("\n📊 Model Switcher Test Summary:")
	var summary = framework.get_test_summary()
	print("Total Tests: %d" % summary.total_tests)
	print("Passed Tests: %d" % summary.passed_tests)
	print("Failed Tests: %d" % summary.failed_tests)
	print("Success Rate: %.1f%%" % summary.success_rate)
	
	return test1_result and test2_result and test3_result and test4_result and test5_result