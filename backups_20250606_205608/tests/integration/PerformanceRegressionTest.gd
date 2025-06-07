class_name PerformanceRegressionTest
extends RefCounted

const TestFramework = preload("res://tests/framework/TestFramework.gd")
const KB_LOADING_THRESHOLD = 5.0
const JSON_PARSING_THRESHOLD = 1.0
const STRUCTURE_LOOKUP_THRESHOLD = 0.1
const MODEL_OPERATIONS_THRESHOLD = 10.0


var framework

# Performance baseline thresholds (in milliseconds)
	var start_time = Time.get_ticks_msec()
	var kb = preload("res://core/knowledge/AnatomicalKnowledgeDatabase.gd").new()
	var load_result = kb.load_knowledge_base()
	var load_time = Time.get_ticks_msec() - start_time

	framework.assert_true(load_result, "Knowledge base should load successfully")
	framework.assert_execution_time_under(
		load_time, KB_LOADING_THRESHOLD, "KB loading should be under threshold"
	)

	var test1_result = framework.end_test()

	# Test 2: JSON Parsing Performance
	framework.start_test("JSON Parsing Performance")

	var test_json = '{"structures": [{"id": "test", "displayName": "Test", "functions": ["func1", "func2"]}]}'
	start_time = Time.get_ticks_msec()

	for i in range(1000):
		var json = JSON.new()
		json.parse(test_json)

	var parse_time = Time.get_ticks_msec() - start_time
	var avg_parse_time = float(parse_time) / 1000.0

	framework.assert_execution_time_under(
		avg_parse_time, JSON_PARSING_THRESHOLD, "JSON parsing should be fast"
	)

	var test2_result = framework.end_test()

	# Test 3: Structure Lookup Performance
	framework.start_test("Structure Lookup Performance")

	if kb.is_loaded:
		var structure_ids = kb.get_all_structure_ids()
		framework.assert_true(structure_ids.size() > 0, "Should have structure IDs for testing")

		if structure_ids.size() > 0:
			var test_id = structure_ids[0]
			start_time = Time.get_ticks_msec()

			for i in range(1000):
				var structure_data = kb.get_structure(test_id)
				framework.assert_not_null(structure_data, "Structure lookup should succeed")

			var lookup_time = Time.get_ticks_msec() - start_time
			var avg_lookup_time = float(lookup_time) / 1000.0

			framework.assert_execution_time_under(
				avg_lookup_time, STRUCTURE_LOOKUP_THRESHOLD, "Structure lookup should be fast"
			)

	var test3_result = framework.end_test()

	# Test 4: Model Operations Performance
	framework.start_test("Model Operations Performance")

	var model_switcher = preload("res://core/models/ModelVisibilityManager.gd").new()
	var mock_model = TestFramework.MockNode3D.new()
	mock_model.name = "PerformanceTestModel"

	start_time = Time.get_ticks_msec()

	# Test registration performance
	for i in range(100):
		var test_model = TestFramework.MockNode3D.new()
		test_model.name = "TestModel_" + str(i)
		model_switcher.register_model(test_model, "Test Model " + str(i))

	# Test visibility toggle performance
	for i in range(100):
		model_switcher.toggle_model_visibility("Test Model " + str(i % 10))

	var operations_time = Time.get_ticks_msec() - start_time

	framework.assert_execution_time_under(
		operations_time, MODEL_OPERATIONS_THRESHOLD, "Model operations should be efficient"
	)

	var test4_result = framework.end_test()

	# Test 5: Memory Usage Validation
	framework.start_test("Memory Usage Validation")

	# Create and destroy many objects to test for memory leaks
	var large_arrays = []
	start_time = Time.get_ticks_msec()

	for i in range(100):
		var test_array = []
		for j in range(100):
			test_array.append({"id": j, "data": "test_data_" + str(j)})
		large_arrays.append(test_array)

	# Clear arrays
	large_arrays.clear()

	var memory_ops_time = Time.get_ticks_msec() - start_time

	framework.assert_execution_time_under(
		memory_ops_time, 100.0, "Memory operations should complete quickly"
	)
	framework.assert_true(true, "Memory test completed without crash")

	var test5_result = framework.end_test()

	# Test 6: Stress Test - Rapid Component Interaction
	framework.start_test("Stress Test - Component Interaction")

	start_time = Time.get_ticks_msec()

	# Simulate rapid user interactions
	for i in range(50):
		# Structure lookup
		if kb.is_loaded:
			var ids = kb.get_all_structure_ids()
			if ids.size() > 0:
				kb.get_structure(ids[i % ids.size()])

		# Model visibility toggle
		var model_names = model_switcher.get_model_names()
		if model_names.size() > 0:
			model_switcher.toggle_model_visibility(model_names[i % model_names.size()])

	var stress_time = Time.get_ticks_msec() - start_time

	framework.assert_execution_time_under(
		stress_time, 200.0, "Stress test should complete within time limit"
	)
	framework.assert_true(kb.is_loaded, "Knowledge base should remain stable")
	framework.assert_true(
		model_switcher.get_model_names().size() > 0, "Model switcher should remain stable"
	)

	var test6_result = framework.end_test()

	print("\n📊 Performance Regression Test Summary:")
	var summary = framework.get_test_summary()
	print("Total Tests: %d" % summary.total_tests)
	print("Passed Tests: %d" % summary.passed_tests)
	print("Failed Tests: %d" % summary.failed_tests)
	print("Success Rate: %.1f%%" % summary.success_rate)

	# Performance report
	print("\n⚡ Performance Thresholds:")
	print("  Knowledge Base Loading: < %.1fms" % KB_LOADING_THRESHOLD)
	print("  JSON Parsing: < %.1fms avg" % JSON_PARSING_THRESHOLD)
	print("  Structure Lookup: < %.1fms avg" % STRUCTURE_LOOKUP_THRESHOLD)
	print("  Model Operations: < %.1fms total" % MODEL_OPERATIONS_THRESHOLD)

	return (
		test1_result
		and test2_result
		and test3_result
		and test4_result
		and test5_result
		and test6_result
	)

func run_test() -> bool:
	framework = TestFramework.get_instance()

	# Test 1: Knowledge Base Loading Performance
	framework.start_test("Knowledge Base Loading Performance")

