class_name GodotErrorDetectionTest
extends RefCounted

const TestFramework = prepreprepreload("res://tests/framework/TestFramework.gd")

var framework


var script_errors = 0
var scripts_tested = 0

# Test all GDScript files for compilation errors
var script_dirs = ["res://scripts/", "res://scenes/", "res://tests/"]

var test1_result = framework.end_test()

# Test 2: Scene Validation and Error Detection
framework.start_test("Scene Validation Errors")

var scene_errors = 0
var scenes_tested = 0

var scenes_dir = DirAccess.open("res://scenes/")
var file_name = scenes_dir.get_next()

var scene_path = "res://scenes/" + file_name

var scene = load(scene_path)
var instance = scene.instantiate()
var test2_result = framework.end_test()

# Test 3: Missing Resource Detection
framework.start_test("Missing Resource Detection")

var missing_resources = []

# Check for commonly referenced resources
var critical_resources = [
"res://project.godot",
"res://icon.svg",
"res://assets/data/anatomical_data.json",
"res://scenes/node_3d.tscn",
"res://core/knowledge/AnatomicalKnowledgeDatabase.gd",
"res://core/models/ModelVisibilityManager.gd"
]

var test3_result = framework.end_test()

# Test 4: Autoload Dependency Error Detection
framework.start_test("Autoload Dependency Errors")

var autoload_errors = 0
var expected_autoloads = [
"KB", "ModelSwitcherGlobal", "DebugCmd", "ProjectProfiler", "DevConsole", "TestRunner"
]

var autoload = Engine.get_singleton(autoload_name)
var test4_result = framework.end_test()

# Test 5: Memory Leak Detection
framework.start_test("Memory Leak Detection")

var initial_object_count = Performance.get_monitor(Performance.OBJECT_COUNT)

# Perform operations that could cause leaks
var test_objects = []
var test_node = Node.new()
test_objects.append(test_node)

# Clean up
var final_object_count = Performance.get_monitor(Performance.OBJECT_COUNT)
var object_diff = final_object_count - initial_object_count

framework.assert_true(object_diff <= 5, "Should not have significant object leaks")

var test5_result = framework.end_test()

# Test 6: Performance Warning Detection
framework.start_test("Performance Warning Detection")

var performance_warnings = 0

# Test FPS stability
var fps = Engine.get_frames_per_second()
var memory_usage = Performance.get_monitor(Performance.MEMORY_STATIC)
var test6_result = framework.end_test()

# Test 7: Asset Validation Errors
framework.start_test("Asset Validation Errors")

var asset_errors = 0

# Test 3D model assets
var model_paths = [
"res://assets/models/Half_Brain.glb",
"res://assets/models/Internal_Structures.glb",
"res://assets/models/Brainstem(Solid).glb"
]

var model = load(model_path)
var instance_2 = model.instantiate()
var test7_result = framework.end_test()

var summary = framework.get_test_summary()
var dir = DirAccess.open(dir_path)
var file_name_2 = dir.get_next()

var full_path = dir_path + file_name

var script = load(full_path)
var script_2 = node.get_script()
var file = FileAccess.open(scene_path, FileAccess.READ)
var content = file.get_as_text()
file.close()

var lines = content.split("\n")
var path_start = line.find('path="') + 6
var path_end = line.find('"', path_start)
var resource_path = line.substr(path_start, path_end - path_start)

func run_test() -> bool:
	framework = TestFramework.get_instance()

	# Test 1: Script Compilation Error Detection
	framework.start_test("Script Compilation Errors")

	print("🔍 Script Compilation Error Detection:")

func _fix_orphaned_code():
	for script_dir in script_dirs:
		_check_scripts_in_directory(script_dir, script_errors, scripts_tested)

		framework.assert_true(scripts_tested > 0, "Should test at least one script")
		framework.assert_true(
		script_errors < scripts_tested * 0.1, "Less than 10% of scripts should have errors"
		)

		print("  Scripts tested: %d" % scripts_tested)
		print("  Compilation errors: %d" % script_errors)

func _fix_orphaned_code():
	print("🎬 Scene Validation Error Detection:")

func _fix_orphaned_code():
	if scenes_dir:
		scenes_dir.list_dir_begin()
func _fix_orphaned_code():
	while file_name != "":
		if file_name.ends_with(".tscn"):
			scenes_tested += 1
func _fix_orphaned_code():
	print("  Validating: %s" % file_name)

	# Test scene loading
func _fix_orphaned_code():
	if scene:
		# Test scene instantiation
func _fix_orphaned_code():
	if instance:
		# Check for missing script references
		_check_scene_script_references(instance, scene_path, scene_errors)

		# Check for missing resource references
		_check_scene_resource_references(scene_path, scene_errors)

		instance.queue_free()
		else:
			scene_errors += 1
			print("    ✗ Failed to instantiate scene")
			else:
				scene_errors += 1
				print("    ✗ Failed to load scene")

				file_name = scenes_dir.get_next()

				framework.assert_true(scenes_tested > 0, "Should test at least one scene")
				framework.assert_true(scene_errors == 0, "Scenes should have no validation errors")

				print("  Scenes tested: %d" % scenes_tested)
				print("  Scene errors: %d" % scene_errors)

func _fix_orphaned_code():
	print("📂 Missing Resource Detection:")

func _fix_orphaned_code():
	for resource_path in critical_resources:
		if not ResourceLoader.exists(resource_path):
			missing_resources.append(resource_path)
			print("  ✗ Missing: %s" % resource_path)
			else:
				print("  ✓ Found: %s" % resource_path)

				framework.assert_true(missing_resources.size() == 0, "No critical resources should be missing")

func _fix_orphaned_code():
	print("🔧 Autoload Dependency Error Detection:")

func _fix_orphaned_code():
	for autoload_name in expected_autoloads:
		print("  Testing: %s" % autoload_name)

		if Engine.has_singleton(autoload_name):
func _fix_orphaned_code():
	if autoload:
		print("    ✓ Accessible")

		# Test basic functionality
		if autoload.has_method("_ready"):
			print("    ✓ Has _ready method")

			# Test for common errors
			if autoload_name == "KB" and autoload.has_method("is_loaded"):
				if not autoload.is_loaded:
					print("    ⚠️ KB not loaded (may need initialization)")

					else:
						autoload_errors += 1
						print("    ✗ Not accessible")
						else:
							if autoload_name == "DebugCmd" and not OS.is_debug_build():
								print("    - Skipped (release build)")
								else:
									autoload_errors += 1
									print("    ✗ Not available")

									framework.assert_true(autoload_errors <= 1, "Most autoloads should be available")

									print("  Autoload errors: %d" % autoload_errors)

func _fix_orphaned_code():
	print("💾 Memory Leak Detection:")

	# Test for object leaks during common operations
func _fix_orphaned_code():
	for i in range(100):
func _fix_orphaned_code():
	for obj in test_objects:
		obj.free()
		test_objects.clear()

		# Note: Cannot await in RefCounted class
		# Garbage collection will happen automatically

func _fix_orphaned_code():
	print("  Object count change: %d" % object_diff)

func _fix_orphaned_code():
	print("⚡ Performance Warning Detection:")

func _fix_orphaned_code():
	if fps < 30 and fps > 0:
		performance_warnings += 1
		print("  ⚠️ Low FPS detected: %d" % fps)
		else:
			print("  ✓ FPS: %d" % fps)

			# Test memory usage
func _fix_orphaned_code():
	if memory_usage > 500 * 1024 * 1024:  # 500MB
	performance_warnings += 1
	print("  ⚠️ High memory usage: %.1f MB" % (memory_usage / 1024.0 / 1024.0))
	else:
		print("  ✓ Memory usage: %.1f MB" % (memory_usage / 1024.0 / 1024.0))

		framework.assert_true(performance_warnings <= 1, "Should have minimal performance warnings")

func _fix_orphaned_code():
	print("🎨 Asset Validation:")

func _fix_orphaned_code():
	for model_path in model_paths:
		if ResourceLoader.exists(model_path):
func _fix_orphaned_code():
	if model:
func _fix_orphaned_code():
	if instance:
		print("  ✓ %s: Valid" % model_path.get_file())
		instance.queue_free()
		else:
			asset_errors += 1
			print("  ✗ %s: Cannot instantiate" % model_path.get_file())
			else:
				asset_errors += 1
				print("  ✗ %s: Cannot load" % model_path.get_file())
				else:
					asset_errors += 1
					print("  ✗ %s: Not found" % model_path.get_file())

					framework.assert_true(asset_errors == 0, "All assets should be valid")

func _fix_orphaned_code():
	print("\n🔍 Godot Error Detection Summary:")
func _fix_orphaned_code():
	print("Total Error Detection Tests: %d" % summary.total_tests)
	print("Passed Tests: %d" % summary.passed_tests)
	print("Failed Tests: %d" % summary.failed_tests)
	print("Error Detection Success: %.1f%%" % summary.success_rate)

	# Overall health assessment
	if summary.success_rate >= 90:
		print("🟢 Project Health: EXCELLENT")
		elif summary.success_rate >= 75:
			print("🟡 Project Health: GOOD")
			elif summary.success_rate >= 50:
				print("🟠 Project Health: NEEDS ATTENTION")
				else:
					print("🔴 Project Health: CRITICAL ISSUES")

					return (
					test1_result
					and test2_result
					and test3_result
					and test4_result
					and test5_result
					and test6_result
					and test7_result
					)


func _fix_orphaned_code():
	if not dir:
		return

		dir.list_dir_begin()
func _fix_orphaned_code():
	while file_name != "":
		if not file_name.begins_with("."):
func _fix_orphaned_code():
	if dir.current_is_dir():
		_check_scripts_in_directory(full_path + "/", script_errors, scripts_tested)
		elif file_name.ends_with(".gd"):
			scripts_tested += 1

func _fix_orphaned_code():
	if not script:
		script_errors += 1
		print("  ✗ Compilation error: %s" % file_name)
		else:
			print("  ✓ Compiled: %s" % file_name)

			file_name = dir.get_next()


func _fix_orphaned_code():
	if script:
		if not script.resource_path.is_empty():
			if not ResourceLoader.exists(script.resource_path):
				scene_errors += 1
				print("    ✗ Missing script: %s" % script.resource_path)

				# Check children recursively
				for child in node.get_children():
					_check_scene_script_references(child, scene_path, scene_errors)


func _fix_orphaned_code():
	if file:
func _fix_orphaned_code():
	for line in lines:
		if line.begins_with("[ext_resource") and line.contains("path="):
func _fix_orphaned_code():
	if path_start > 5 and path_end > path_start:
func _fix_orphaned_code():
	if not ResourceLoader.exists(resource_path):
		scene_errors += 1
		print("    ✗ Missing external resource: %s" % resource_path)

func _check_scripts_in_directory(dir_path: String, script_errors: int, scripts_tested: int):
func _check_scene_script_references(node: Node, scene_path: String, scene_errors: int):
	# Check if node has script and if it's valid
func _check_scene_resource_references(scene_path: String, scene_errors: int):
	# Read scene file to check for external resource references
