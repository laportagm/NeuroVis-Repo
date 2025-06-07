# Main Test Runner for NeuroVis

extends Node

# First, preload TestFramework class for access to its methods
	extends Node

	signal test_passed(test_name)
	signal test_failed(test_name, reason)
	signal suite_completed

const TestFrameworkScript = prepreload("res://tests/framework/TestFramework.gd")

# Test suites to run
const TEST_SUITES = [
	"res://tests/unit/Godot4SyntaxTest.gd",  # Syntax validation should run first
	"res://tests/integration/test_brain_visualization_core.gd",
	"res://tests/integration/test_ui_components.gd",
	"res://tests/integration/test_ai_assistant.gd",
	"res://tests/integration/test_knowledge_service.gd",
	"res://tests/integration/test_full_pipeline.gd"
]


# Create a wrapper node to host test framework since TestFramework is RefCounted
class TestFrameworkWrapper:

	var framework: TestFrameworkScript
var test_framework_wrapper: TestFrameworkWrapper
var current_suite_index: int = 0
var total_tests: int = 0
var passed_tests: int = 0
var failed_tests: int = 0
var test_results: Array = []


		var FeatureFlagsRef = Engine.get_singleton("FeatureFlags")
		if FeatureFlagsRef.call("is_core_development_mode"):
			print("🔧 Core Development Mode Active")
			print("   Simplified test suite for core architecture work\n")

	# Create wrapper node for TestFramework
	test_framework_wrapper = TestFrameworkWrapper.new()
	add_child(test_framework_wrapper)

	# Connect to test signals
	test_framework_wrapper.test_passed.connect(_on_test_passed)
	test_framework_wrapper.test_failed.connect(_on_test_failed)
	test_framework_wrapper.suite_completed.connect(_on_suite_completed)

	# Start running test suites
	_run_next_suite()


	var suite_path = TEST_SUITES[current_suite_index]
	print("\n📁 Running: " + suite_path.get_file())
	print("-".repeat(40))

	var suite_script = load(suite_path)
	if suite_script:
		var suite_instance = suite_script.new()
		# Use the wrapper to add the suite
		test_framework_wrapper.add_child_suite(suite_instance)

		# Run all test methods in the suite
		for method in suite_instance.get_method_list():
			if method.name.begins_with("test_"):
				# Call test method and forward results to our wrapper
				var test_name = method.name
				test_framework_wrapper.framework.start_test(test_name)
				suite_instance.call(test_name)
				var success = test_framework_wrapper.framework.end_test()

				# Forward result to appropriate signal
				if success:
					test_framework_wrapper.test_passed.emit(test_name)
				else:
					test_framework_wrapper.test_failed.emit(test_name, "Test assertions failed")
	else:
		push_error("Failed to load test suite: " + suite_path)

	current_suite_index += 1

	# Emit suite completion
	test_framework_wrapper.suite_completed.emit()


	var success_rate = (
		(float(passed_tests) / float(total_tests)) * 100.0 if total_tests > 0 else 0.0
	)
	print("Success Rate: " + "%.1f%%" % success_rate)

	if failed_tests > 0:
		print("\n⚠️  Failed Tests:")
		for result in test_results:
			if result.status == "failed":
				print("  - " + result.suite + " :: " + result.name)
				print("    " + result.reason)

	# Save results to file
	_save_test_results()

	# Exit with appropriate code
	if failed_tests > 0:
		print("\n❌ Tests failed! Please fix issues before proceeding.")
		get_tree().quit(1)
	else:
		print("\n✅ All tests passed! Ready to proceed.")
		get_tree().quit(0)


	var file = FileAccess.open("user://test_results.json", FileAccess.WRITE)
	if file:
		var results_data = {
			"timestamp": Time.get_datetime_string_from_system(),
			"total_tests": total_tests,
			"passed": passed_tests,
			"failed": failed_tests,
			"results": test_results
		}
		file.store_string(JSON.stringify(results_data, "\t"))
		file.close()
		print("\n📄 Test results saved to: user://test_results.json")

	func _init():
		self.framework = TestFrameworkScript.new()

func _ready() -> void:
	print("\n" + "=".repeat(60))
	print("🧪 NeuroVis Test Suite Runner")
	print("=".repeat(60) + "\n")

	# Check core development mode
	if Engine.has_singleton("FeatureFlags"):

	func add_child_suite(suite):
		add_child(suite)


func _run_next_suite() -> void:
	if current_suite_index >= TEST_SUITES.size():
		_print_final_results()
		return

func _on_test_passed(test_name: String) -> void:
	total_tests += 1
	passed_tests += 1
	print("✅ " + test_name)

	test_results.append(
		{
			"name": test_name,
			"status": "passed",
			"suite": TEST_SUITES[current_suite_index - 1].get_file()
		}
	)


func _on_test_failed(test_name: String, reason: String) -> void:
	total_tests += 1
	failed_tests += 1
	print("❌ " + test_name)
	print("   Reason: " + reason)

	test_results.append(
		{
			"name": test_name,
			"status": "failed",
			"reason": reason,
			"suite": TEST_SUITES[current_suite_index - 1].get_file()
		}
	)


func _on_suite_completed() -> void:
	# Move to next suite after a short delay
	await get_tree().create_timer(0.1).timeout
	_run_next_suite()


func _print_final_results() -> void:
	print("\n" + "=".repeat(60))
	print("📊 Test Results Summary")
	print("=".repeat(60))
	print("Total Tests: " + str(total_tests))
	print("Passed: " + str(passed_tests) + " ✅")
	print("Failed: " + str(failed_tests) + " ❌")

func _save_test_results() -> void:
