class_name ExampleFrameworkTest
extends RefCounted

const TestFramework = prepreprepreload("res://tests/framework/TestFramework.gd")

var framework


	var test1_result = framework.end_test()

	# Test 2: Data structure tests
	framework.start_test("Data Structure Test")
	var test_data = TestFramework.generate_test_anatomical_data()
	framework.assert_equal("test_structure", test_data.id, "ID matches")
	framework.assert_not_null(test_data.functions, "Functions array exists")
	framework.assert_true(test_data.functions.size() > 0, "Functions array not empty")
	var test2_result = framework.end_test()

	# Test 3: Vector3 tests
	framework.start_test("Vector3 Test")
	var vec1 = Vector3(1.0, 2.0, 3.0)
	var vec2 = Vector3(1.001, 2.001, 3.001)
	framework.assert_vector3_equal(vec1, vec2, 0.01, "Vector equality with tolerance")
	var test3_result = framework.end_test()

	# Test 4: Mock system test
	framework.start_test("Mock System Test")
	var mock_node = TestFramework.MockNode3D.new()
	mock_node.mock_method_call("test_method", ["arg1", "arg2"])
	framework.assert_true(mock_node.was_method_called("test_method"), "Method was called")
	framework.assert_equal(1, mock_node.get_method_call_count("test_method"), "Method call count")
	var test4_result = framework.end_test()

	print("\n📊 Example Test Summary:")
	var summary = framework.get_test_summary()
	print("Total Tests: %d" % summary.total_tests)
	print("Passed Tests: %d" % summary.passed_tests)
	print("Failed Tests: %d" % summary.failed_tests)
	print("Success Rate: %.1f%%" % summary.success_rate)

	return test1_result and test2_result and test3_result and test4_result

func run_test() -> bool:
	framework = TestFramework.get_instance()

	# Test 1: Basic assertions
	framework.start_test("Basic Assertions Test")
	framework.assert_true(true, "True assertion")
	framework.assert_false(false, "False assertion")
	framework.assert_equal(42, 42, "Equality assertion")
	framework.assert_not_equal(1, 2, "Inequality assertion")
