class_name GodotEngineDebugTest
extends RefCounted

const TestFramework = preprepreload("res://tests/framework/TestFramework.gd")

var framework


	var version_info = Engine.get_version_info()
	framework.assert_true(version_info.has("major"), "Engine should have version info")
	framework.assert_true(version_info.major >= 4, "Should be Godot 4.x or higher")
	framework.assert_not_null(OS.get_name(), "Should have OS name")

	var test1_result = framework.end_test()

	# Test 2: Resource System Debug
	framework.start_test("Resource System Debug")

	print("📁 Resource System Status:")
	print("  User data dir: %s" % OS.get_user_data_dir())
	print("  Executable path: %s" % OS.get_executable_path())

	# Test basic resource loading
	var test_resource_exists = ResourceLoader.exists("res://project.godot")
	framework.assert_true(test_resource_exists, "Project file should be accessible")

	# Test resource loading capabilities
	var project_settings = load("res://project.godot")
	framework.assert_not_null(project_settings, "Should be able to load project settings")

	var test2_result = framework.end_test()

	# Test 3: Node System Debug
	framework.start_test("Node System Debug")

	print("🌳 Node System Testing:")

	# Test basic node creation
	var test_node = Node.new()
	framework.assert_not_null(test_node, "Should create basic Node")
	framework.assert_equal("Node", test_node.get_class(), "Node should report correct class")

	# Test 3D node creation
	var test_node3d = Node3D.new()
	framework.assert_not_null(test_node3d, "Should create Node3D")
	framework.assert_equal("Node3D", test_node3d.get_class(), "Node3D should report correct class")

	# Test node hierarchy
	test_node.add_child(test_node3d)
	framework.assert_equal(1, test_node.get_child_count(), "Parent should have one child")
	framework.assert_equal(test_node3d, test_node.get_child(0), "Child should be retrievable")

	print("  ✓ Basic node creation: OK")
	print("  ✓ Node hierarchy: OK")

	var test3_result = framework.end_test()

	# Test 4: Signal System Debug
	framework.start_test("Signal System Debug")

	print("📡 Signal System Testing:")

	# Test signal connection
	var signal_test_node = Node.new()
	var signal_received = false
	var signal_callback = func(): signal_received = true

	signal_test_node.tree_entered.connect(signal_callback)
	framework.assert_true(
		signal_test_node.tree_entered.is_connected(signal_callback), "Signal should be connected"
	)

	print("  ✓ Signal connection: OK")

	var test4_result = framework.end_test()

	# Test 5: Memory and Performance Debug
	framework.start_test("Memory and Performance Debug")

	print("💾 Memory and Performance Status:")

	var start_time = Time.get_ticks_msec()

	# Test object creation performance
	var objects = []
	for i in range(1000):
		objects.append(Node.new())

	var creation_time = Time.get_ticks_msec() - start_time
	framework.assert_execution_time_under(creation_time, 100.0, "1000 node creation should be fast")

	print("  ✓ Created 1000 nodes in %dms" % creation_time)

	# Cleanup
	for obj in objects:
		obj.free()
	objects.clear()

	print("  ✓ Memory cleanup: OK")

	var test5_result = framework.end_test()

	# Test 6: File System Access Debug
	framework.start_test("File System Access Debug")

	print("📂 File System Testing:")

	# Test file access patterns
	var files_to_check = [
		"res://project.godot",
		"res://assets/data/anatomical_data.json",
		"res://scenes/node_3d.tscn",
		"res://core/knowledge/AnatomicalKnowledgeDatabase.gd"
	]

	var accessible_files = 0
	for file_path in files_to_check:
		if FileAccess.file_exists(file_path):
			accessible_files += 1
			print("  ✓ %s: Accessible" % file_path)
		else:
			print("  ✗ %s: Not found" % file_path)

	framework.assert_true(accessible_files > 0, "At least some project files should be accessible")

	# Test directory access
	var dir = DirAccess.open("res://")
	framework.assert_not_null(dir, "Should be able to open res:// directory")

	if dir:
		dir.list_dir_begin()
		var file_count = 0
		var file_name = dir.get_next()
		while file_name != "":
			file_count += 1
			file_name = dir.get_next()

		framework.assert_true(file_count > 0, "res:// directory should contain files")
		print("  ✓ Found %d items in res:// directory" % file_count)

	var test6_result = framework.end_test()

	# Test 7: Script Loading and Compilation Debug
	framework.start_test("Script Loading Debug")

	print("📜 Script System Testing:")

	# Test script loading
	var scripts_to_test = [
		"res://core/knowledge/AnatomicalKnowledgeDatabase.gd",
		"res://core/models/ModelVisibilityManager.gd",
		"res://tests/framework/TestFramework.gd"
	]

	var loaded_scripts = 0
	for script_path in scripts_to_test:
		if ResourceLoader.exists(script_path):
			var script = load(script_path)
			if script:
				loaded_scripts += 1
				print("  ✓ %s: Loaded successfully" % script_path)
			else:
				print("  ✗ %s: Failed to load" % script_path)
		else:
			print("  ✗ %s: Not found" % script_path)

	framework.assert_true(loaded_scripts > 0, "Should be able to load project scripts")

	var test7_result = framework.end_test()

	# Test 8: Error Handling and Recovery Debug
	framework.start_test("Error Handling Debug")

	print("⚠️ Error Handling Testing:")

	# Test graceful handling of invalid operations
	var error_handled = true

	# Test invalid file access
	var invalid_file = FileAccess.open("res://nonexistent_file.json", FileAccess.READ)
	framework.assert_null(invalid_file, "Invalid file access should return null")

	# Test invalid resource loading
	var invalid_resource = load("res://nonexistent_resource.tres")
	framework.assert_null(invalid_resource, "Invalid resource should return null")

	# Test invalid node operations
	var orphan_node = Node.new()
	var invalid_child = orphan_node.get_node_or_null("NonexistentChild")
	framework.assert_null(invalid_child, "Invalid node path should return null")

	print("  ✓ Error conditions handled gracefully")

	var test8_result = framework.end_test()

	print("\n🔍 Godot Engine Debug Summary:")
	var summary = framework.get_test_summary()
	print("Total Debug Tests: %d" % summary.total_tests)
	print("Passed Tests: %d" % summary.passed_tests)
	print("Failed Tests: %d" % summary.failed_tests)
	print("Engine Health: %.1f%%" % summary.success_rate)

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

func run_test() -> bool:
	framework = TestFramework.get_instance()

	# Test 1: Engine Information and Capabilities
	framework.start_test("Engine Information Debug")

	print("🔧 Godot Engine Debug Information:")
	print("  Version: %s" % Engine.get_version_info())
	print("  Platform: %s" % OS.get_name())
	print("  Debug Build: %s" % OS.is_debug_build())
	print("  Process ID: %d" % OS.get_process_id())
	print("  Architecture: %s" % Engine.get_architecture_name())

