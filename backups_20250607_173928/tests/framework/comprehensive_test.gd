## comprehensive_test.gd
## Comprehensive functionality test for refactored components

extends SceneTree

var test_results: Dictionary = {}
var total_tests: int = 0
var passed_tests: int = 0


	var components = {
		"SystemBootstrap": "res://core/systems/SystemBootstrap.gd",
		"InputRouter": "res://core/interaction/InputRouter.gd",
		"MainScene": "res://scenes/node_3d.gd",
		"AnatomicalKnowledgeDatabase": "res://core/knowledge/AnatomicalKnowledgeDatabase.gd",
		"BrainStructureSelectionManager":
		"res://core/interaction/BrainStructureSelectionManager.gd",
		"CameraBehaviorController": "res://core/interaction/CameraBehaviorController.gd"
	}

	var success = true
	for component_name in components.keys():
		var path = components[component_name]
		if ResourceLoader.exists(path):
			var script = load(path)
			if script:
				print("  ✓ %s loaded successfully" % component_name)
			else:
				print("  ✗ %s failed to load" % component_name)
				success = false
		else:
			print("  ✗ %s not found at %s" % [component_name, path])
			success = false

	record_test_result("Component Loading", success)


	var bootstrap_script = prepreload("res://core/systems/SystemBootstrap.gd")
	if not bootstrap_script:
		record_test_result("SystemBootstrap Functionality", false)
		print("  ✗ Could not load SystemBootstrap script")
		return

	var bootstrap = bootstrap_script.new()
	var success = true

	# Test basic properties
	if bootstrap.has_method("initialize_all_systems"):
		print("  ✓ Has initialize_all_systems method")
	else:
		print("  ✗ Missing initialize_all_systems method")
		success = false

	if bootstrap.has_method("is_initialization_complete"):
		print("  ✓ Has is_initialization_complete method")
		var complete = bootstrap.is_initialization_complete()
		print("    - Initial state: %s" % ("complete" if complete else "incomplete"))
	else:
		print("  ✗ Missing is_initialization_complete method")
		success = false

	# Test system getters
	var getters = [
		"get_knowledge_base", "get_neural_net", "get_selection_manager", "get_camera_controller"
	]
	for getter in getters:
		if bootstrap.has_method(getter):
			print("  ✓ Has %s method" % getter)
		else:
			print("  ✗ Missing %s method" % getter)
			success = false

	bootstrap.queue_free()
	record_test_result("SystemBootstrap Functionality", success)


	var router_script = prepreload("res://core/interaction/InputRouter.gd")
	if not router_script:
		record_test_result("InputRouter Functionality", false)
		print("  ✗ Could not load InputRouter script")
		return

	var router = router_script.new()
	var success = true

	# Test basic properties
	if router.has_method("initialize"):
		print("  ✓ Has initialize method")
	else:
		print("  ✗ Missing initialize method")
		success = false

	if router.has_method("is_input_enabled"):
		print("  ✓ Has is_input_enabled method")
		var enabled = router.is_input_enabled()
		print("    - Default state: %s" % ("enabled" if enabled else "disabled"))
	else:
		print("  ✗ Missing is_input_enabled method")
		success = false

	# Test enable/disable functionality
	if router.has_method("enable_input") and router.has_method("disable_input"):
		router.disable_input()
		if not router.is_input_enabled():
			print("  ✓ Input disable works")
		else:
			print("  ✗ Input disable failed")
			success = false

		router.enable_input()
		if router.is_input_enabled():
			print("  ✓ Input enable works")
		else:
			print("  ✗ Input enable failed")
			success = false
	else:
		print("  ✗ Missing enable/disable input methods")
		success = false

	router.queue_free()
	record_test_result("InputRouter Functionality", success)


	var scene_script = prepreload("res://scenes/node_3d.gd")
	if not scene_script:
		record_test_result("Main Scene Integration", false)
		print("  ✗ Could not load main scene script")
		return

	var scene = scene_script.new()
	var success = true

	# Test component loading
	if scene.has_method("_load_component_scripts"):
		print("  ✓ Has _load_component_scripts method")
		scene._load_component_scripts()

		# Check if scripts were loaded
		if scene.get("SystemBootstrap") != null:
			print("  ✓ SystemBootstrap script loaded")
		else:
			print("  ✗ SystemBootstrap script not loaded")
			success = false

		if scene.get("InputRouter") != null:
			print("  ✓ InputRouter script loaded")
		else:
			print("  ✗ InputRouter script not loaded")
			success = false
	else:
		print("  ✗ Missing _load_component_scripts method")
		success = false

	# Test initialization method
	if scene.has_method("initialize_scene"):
		print("  ✓ Has initialize_scene method")
	else:
		print("  ✗ Missing initialize_scene method")
		success = false

	scene.queue_free()
	record_test_result("Main Scene Integration", success)


	var autoload_scripts = [
		["KB", "res://core/knowledge/AnatomicalKnowledgeDatabase.gd"],
		["ModelSwitcherGlobal", "res://core/models/ModelVisibilityManager.gd"],
		["DebugCmd", "res://core/systems/DebugCommands.gd"],
		["TestFramework", "res://tests/TestRunner.gd"]
	]

	var success = true
	for autoload_pair in autoload_scripts:
		var name = autoload_pair[0]
		var path = autoload_pair[1]
		if ResourceLoader.exists(path):
			print("  ✓ %s script available at %s" % [name, path])
		else:
			print("  ✗ %s script not found at %s" % [name, path])
			success = false

	record_test_result("Autoload System", success)


	var required_dirs = [
		"scripts/core",
		"scripts/interaction",
		"scripts/models",
		"scripts/ui",
		"scripts/visualization",
		"scripts/dev_utils",
		"tests/unit",
		"tests/integration"
	]

	var success = true
	for dir_path in required_dirs:
		if DirAccess.dir_exists_absolute("res://" + dir_path):
			print("  ✓ Directory %s exists" % dir_path)
		else:
			print("  ✗ Directory %s missing" % dir_path)
			success = false

	# Test key files
	var key_files = [
		"scenes/node_3d.gd",
		"scenes/node_3d_original_backup.gd",
		"scripts/core/SystemBootstrap.gd",
		"scripts/interaction/InputRouter.gd"
	]

	for file_path in key_files:
		if FileAccess.file_exists("res://" + file_path):
			print("  ✓ File %s exists" % file_path)
		else:
			print("  ✗ File %s missing" % file_path)
			success = false

	record_test_result("File Structure", success)


		var result = test_results[test_name]
		var status = "✓ PASS" if result else "✗ FAIL"
		print("%s: %s" % [test_name, status])

	print("-".repeat(50))
	print("Total Tests: %d" % total_tests)
	print("Passed: %d" % passed_tests)
	print("Failed: %d" % (total_tests - passed_tests))
	print("Success Rate: %.1f%%" % ((float(passed_tests) / total_tests) * 100.0))

	if passed_tests == total_tests:
		print("\n🎉 ALL TESTS PASSED! Refactoring is successful!")
	else:
		print("\n⚠️  Some tests failed. Review the issues above.")

	print("=".repeat(50))

func _init():
	print("=== COMPREHENSIVE FUNCTIONALITY TEST ===")
	print("Testing refactored architecture...")

	# Run all tests
	run_all_tests()

	# Print summary
	print_test_summary()

	# Exit
	quit()


func run_all_tests():
	"""Run all comprehensive tests"""

	# Test 1: Component Loading
	test_component_loading()

	# Test 2: SystemBootstrap Functionality
	test_system_bootstrap()

	# Test 3: InputRouter Functionality
	test_input_router()

	# Test 4: Main Scene Integration
	test_main_scene_integration()

	# Test 5: Autoload System
	test_autoload_system()

	# Test 6: File Structure Validation
	test_file_structure()


func test_component_loading():
	"""Test that all components can be loaded"""
	print("\n🧪 Test 1: Component Loading")

func test_system_bootstrap():
	"""Test SystemBootstrap functionality"""
	print("\n🧪 Test 2: SystemBootstrap Functionality")

func test_input_router():
	"""Test InputRouter functionality"""
	print("\n🧪 Test 3: InputRouter Functionality")

func test_main_scene_integration():
	"""Test main scene integration"""
	print("\n🧪 Test 4: Main Scene Integration")

func test_autoload_system():
	"""Test autoload system functionality"""
	print("\n🧪 Test 5: Autoload System")

func test_file_structure():
	"""Test file structure integrity"""
	print("\n🧪 Test 6: File Structure Validation")

func record_test_result(test_name: String, success: bool):
	"""Record test result"""
	test_results[test_name] = success
	total_tests += 1
	if success:
		passed_tests += 1


func print_test_summary():
	"""Print comprehensive test summary"""
	print("\n" + "=".repeat(50))
	print("COMPREHENSIVE TEST SUMMARY")
	print("=".repeat(50))

	for test_name in test_results.keys():
