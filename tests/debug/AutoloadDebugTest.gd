class_name AutoloadDebugTest
extends RefCounted

const TestFramework = preload("res://tests/framework/TestFramework.gd")

# FIXED: Orphaned code - var framework


var expected_autoloads = [
"KB", "ModelSwitcherGlobal", "DebugCmd", "ProjectProfiler", "DevConsole", "TestRunner"
]

var accessible_autoloads = 0
var test1_result = framework.end_test()

# Test 2: Knowledge Base Autoload Debug
framework.start_test("Knowledge Base Autoload")

# FIXED: Orphaned code - var kb_available = Engine.has_singleton("KB")
framework.assert_true(kb_available, "KB autoload should be available")

# FIXED: Orphaned code - var kb = Engine.get_singleton("KB")
framework.assert_not_null(kb, "KB singleton should be accessible")

# FIXED: Orphaned code - var load_result = kb.load_knowledge_base()
framework.assert_true(load_result, "KB should load successfully")

# FIXED: Orphaned code - var structure_ids = kb.get_all_structure_ids()
framework.assert_true(structure_ids.size() > 0, "KB should contain structures")
# FIXED: Orphaned code - var test2_result = framework.end_test()

# Test 3: Model Switcher Autoload Debug
framework.start_test("Model Switcher Autoload")

# FIXED: Orphaned code - var model_switcher_available = Engine.has_singleton("ModelSwitcherGlobal")
framework.assert_true(model_switcher_available, "ModelSwitcherGlobal should be available")

# FIXED: Orphaned code - var model_switcher = Engine.get_singleton("ModelSwitcherGlobal")
framework.assert_not_null(model_switcher, "ModelSwitcherGlobal should be accessible")

# FIXED: Orphaned code - var model_names = model_switcher.get_model_names()
# FIXED: Orphaned code - var test3_result = framework.end_test()

# Test 4: Debug Commands Autoload Debug
framework.start_test("Debug Commands Autoload")

# FIXED: Orphaned code - var debug_cmd_available = Engine.has_singleton("DebugCmd")

# FIXED: Orphaned code - var debug_cmd = Engine.get_singleton("DebugCmd")
framework.assert_not_null(debug_cmd, "DebugCmd should be accessible")

# FIXED: Orphaned code - var test4_result = framework.end_test()

# Test 5: Performance Profiler Autoload Debug
framework.start_test("Performance Profiler Autoload")

# FIXED: Orphaned code - var profiler_available = Engine.has_singleton("ProjectProfiler")
framework.assert_true(profiler_available, "ProjectProfiler should be available")

# FIXED: Orphaned code - var profiler = Engine.get_singleton("ProjectProfiler")
framework.assert_not_null(profiler, "ProjectProfiler should be accessible")

# FIXED: Orphaned code - var expected_methods = ["start_timer", "end_timer", "get_performance_data"]
var test5_result = framework.end_test()

# Test 6: Development Console Autoload Debug
framework.start_test("Development Console Autoload")

# FIXED: Orphaned code - var dev_console_available = Engine.has_singleton("DevConsole")
framework.assert_true(dev_console_available, "DevConsole should be available")

# FIXED: Orphaned code - var dev_console = Engine.get_singleton("DevConsole")
framework.assert_not_null(dev_console, "DevConsole should be accessible")

# FIXED: Orphaned code - var test6_result = framework.end_test()

# Test 7: Test Runner Autoload Debug
framework.start_test("Test Runner Autoload")

# FIXED: Orphaned code - var test_runner_available = Engine.has_singleton("TestRunner")
framework.assert_true(test_runner_available, "TestRunner should be available")

# FIXED: Orphaned code - var test_runner = Engine.get_singleton("TestRunner")
framework.assert_not_null(test_runner, "TestRunner should be accessible")

# FIXED: Orphaned code - var test7_result = framework.end_test()

# Test 8: Autoload Initialization Order Debug
framework.start_test("Autoload Initialization Order")

# FIXED: Orphaned code - var dependency_issues = 0

# Test KB → ModelSwitcherGlobal interaction
var kb_2 = Engine.get_singleton("KB")
# FIXED: Orphaned code - var ms = Engine.get_singleton("ModelSwitcherGlobal")

# FIXED: Orphaned code - var test8_result = framework.end_test()

# FIXED: Orphaned code - var summary = framework.get_test_summary()
# FIXED: Orphaned code - var status = "✓ Available" if Engine.has_singleton(autoload_name) else "✗ Missing"

func run_test() -> bool:
	framework = TestFramework.get_instance()

	# Test 1: Autoload Configuration Analysis
	framework.start_test("Autoload Configuration")

	print("🔧 Autoload System Debug:")

	# Expected autoloads from project.godot

print("  Expected autoloads: %d" % expected_autoloads.size())
for autoload_name in expected_autoloads:
	print("    - %s" % autoload_name)

	# Test autoload accessibility
for autoload_name in expected_autoloads:
	if Engine.has_singleton(autoload_name):
		accessible_autoloads += 1
		print("  ✓ %s: Available as singleton" % autoload_name)
		else:
			print("  ✗ %s: Not available" % autoload_name)

			framework.assert_true(accessible_autoloads >= 3, "At least 3 autoloads should be accessible")

print("📚 Knowledge Base (KB) Debug:")

if kb_available:
if kb:
	print("  ✓ KB autoload accessible")
	print("  Type: %s" % kb.get_class())

	# Test KB methods
	if kb.has_method("load_knowledge_base"):
		print("  ✓ Has load_knowledge_base method")

		# Test loading
if load_result and kb.has_method("get_all_structure_ids"):
print("  ✓ Loaded %d structures" % structure_ids.size())
else:
	print("  ✗ Missing load_knowledge_base method")
	else:
		print("  ✗ KB autoload not available")

print("🔄 ModelSwitcherGlobal Debug:")

if model_switcher_available:
if model_switcher:
	print("  ✓ ModelSwitcherGlobal accessible")
	print("  Type: %s" % model_switcher.get_class())

	# Test ModelSwitcher methods
	if model_switcher.has_method("get_model_names"):
print("  ✓ Has %d registered models" % model_names.size())
for model_name in model_names:
	print("    - %s" % model_name)
	else:
		print("  ✗ Missing get_model_names method")

		# Test signals
		if model_switcher.has_signal("model_visibility_changed"):
			print("  ✓ Has model_visibility_changed signal")
			else:
				print("  ✗ Missing model_visibility_changed signal")
				else:
					print("  ✗ ModelSwitcherGlobal not available")

print("🐛 DebugCmd Debug:")

if OS.is_debug_build():
	framework.assert_true(debug_cmd_available, "DebugCmd should be available in debug builds")

	if debug_cmd_available:
if debug_cmd:
	print("  ✓ DebugCmd accessible in debug build")

	# Test debug command registration
	if debug_cmd.has_method("register_command"):
		print("  ✓ Has register_command method")
		if debug_cmd.has_method("get_registered_commands"):
			print("  ✓ Has get_registered_commands method")
			else:
				print("  ✗ DebugCmd not accessible")
				else:
					print("  ✗ DebugCmd not available in debug build")
					else:
						print("  - DebugCmd check skipped (release build)")
						framework.assert_true(true, "Debug command test skipped in release build")

print("📊 ProjectProfiler Debug:")

if profiler_available:
if profiler:
	print("  ✓ ProjectProfiler accessible")
	print("  Type: %s" % profiler.get_class())

	# Test profiler methods
for method_name in expected_methods:
	if profiler.has_method(method_name):
		print("  ✓ Has %s method" % method_name)
		else:
			print("  ✗ Missing %s method" % method_name)
			else:
				print("  ✗ ProjectProfiler not available")

print("💻 DevConsole Debug:")

if dev_console_available:
if dev_console:
	print("  ✓ DevConsole accessible")
	print("  Type: %s" % dev_console.get_class())
	else:
		print("  ✗ DevConsole not available")

print("🧪 TestRunner Debug:")

if test_runner_available:
if test_runner:
	print("  ✓ TestRunner accessible")
	print("  Type: %s" % test_runner.get_class())

	# Test runner methods
	if test_runner.has_method("run_all_tests"):
		print("  ✓ Has run_all_tests method")
		else:
			print("  ✗ Missing run_all_tests method")
			else:
				print("  ✗ TestRunner not available")

print("⚡ Initialization Order Analysis:")

# Test cross-dependencies between autoloads
if Engine.has_singleton("KB") and Engine.has_singleton("ModelSwitcherGlobal"):
if kb and ms:
	print("  ✓ KB and ModelSwitcher both available")

	# Test if they can interact
	if kb.has_method("is_loaded") and ms.has_method("get_model_names"):
		if kb.is_loaded:
			print("  ✓ KB loaded before dependency test")
			else:
				dependency_issues += 1
				print("  ⚠️ KB not loaded during dependency test")
				else:
					dependency_issues += 1
					print("  ✗ KB or ModelSwitcher inaccessible")
					else:
						dependency_issues += 1
						print("  ✗ Missing KB or ModelSwitcher for dependency test")

						framework.assert_true(dependency_issues <= 1, "Should have minimal autoload dependency issues")
						print("  Dependency issues found: %d" % dependency_issues)

print("\n🔧 Autoload Debug Summary:")
print("Total Autoload Tests: %d" % summary.total_tests)
print("Passed Tests: %d" % summary.passed_tests)
print("Failed Tests: %d" % summary.failed_tests)
print("Autoload System Health: %.1f%%" % summary.success_rate)

# Summary of autoload status
print("\nAutoload Status Summary:")
for autoload_name in expected_autoloads:
print("  %s: %s" % [autoload_name, status])

return (
test1_result
and test2_result
and test3_result
and test4_result
and test5_result
and test6_result
and test7_result
and test8_result
)
