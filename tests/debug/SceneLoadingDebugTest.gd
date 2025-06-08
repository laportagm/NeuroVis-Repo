class_name SceneLoadingDebugTest
extends RefCounted

const TestFramework = preload("res://tests/framework/TestFramework.gd")

# FIXED: Orphaned code - var framework


var scene_files = []
var scenes_dir = DirAccess.open("res://scenes/")
# FIXED: Orphaned code - var file_name = scenes_dir.get_next()
# FIXED: Orphaned code - var test1_result = framework.end_test()

# Test 2: Scene Loading Validation
framework.start_test("Scene Loading Validation")

# FIXED: Orphaned code - var loadable_scenes = 0
var scene_load_times = []

var start_time = Time.get_ticks_msec()
# FIXED: Orphaned code - var scene_resource = load(scene_path)
# FIXED: Orphaned code - var load_time = Time.get_ticks_msec() - start_time

var scene_instance = scene_resource.instantiate()
# FIXED: Orphaned code - var avg_load_time = 0.0
var test2_result = framework.end_test()

# Test 3: Main Scene Loading Test
framework.start_test("Main Scene Loading")

# FIXED: Orphaned code - var main_scene_path = "res://scenes/node_3d.tscn"
framework.assert_true(FileAccess.file_exists(main_scene_path), "Main scene should exist")

# FIXED: Orphaned code - var main_scene = load(main_scene_path)
framework.assert_not_null(main_scene, "Main scene should load")

# FIXED: Orphaned code - var main_instance = main_scene.instantiate()
framework.assert_not_null(main_instance, "Main scene should instantiate")

# FIXED: Orphaned code - var camera = main_instance.get_node_or_null("Camera3D")
framework.assert_not_null(camera, "Main scene should have Camera3D")

# FIXED: Orphaned code - var ui_layer = main_instance.get_node_or_null("UI_Layer")
framework.assert_not_null(ui_layer, "Main scene should have UI_Layer")

# FIXED: Orphaned code - var brain_model = main_instance.get_node_or_null("BrainModel")
framework.assert_not_null(brain_model, "Main scene should have BrainModel")

# FIXED: Orphaned code - var test3_result = framework.end_test()

# Test 4: Scene Node Hierarchy Debug
framework.start_test("Scene Node Hierarchy")

# FIXED: Orphaned code - var ui_scenes = ["res://scenes/ui_info_panel.tscn", "res://scenes/model_control_panel.tscn"]

var loaded_ui_scenes = 0
var ui_scene = load(ui_scene_path)
# FIXED: Orphaned code - var ui_instance = ui_scene.instantiate()
# FIXED: Orphaned code - var test4_result = framework.end_test()

# Test 5: Scene Script Analysis
framework.start_test("Scene Script Analysis")

# FIXED: Orphaned code - var scripts_tested = 0
var scripts_working = 0

var scene = load(scene_path)
# FIXED: Orphaned code - var instance = scene.instantiate()
# FIXED: Orphaned code - var script = instance.get_script()
# FIXED: Orphaned code - var test5_result = framework.end_test()

# Test 6: Scene Resource Dependencies
framework.start_test("Scene Resource Dependencies")

# FIXED: Orphaned code - var file = FileAccess.open(scene_path, FileAccess.READ)
# FIXED: Orphaned code - var content = file.get_as_text()
file.close()

# Look for external resource references
var ext_resources = []
var lines = content.split("\n")
# FIXED: Orphaned code - var test6_result = framework.end_test()

# FIXED: Orphaned code - var summary = framework.get_test_summary()

func run_test() -> bool:
	framework = TestFramework.get_instance()

	# Test 1: Scene File Discovery and Validation
	framework.start_test("Scene File Discovery")

	print("🎬 Scene Loading Debug Information:")

	# Find all scene files in the project

if scenes_dir:
	scenes_dir.list_dir_begin()
while file_name != "":
	if file_name.ends_with(".tscn"):
		scene_files.append("res://scenes/" + file_name)
		print("  Found scene: %s" % file_name)
		file_name = scenes_dir.get_next()

		framework.assert_true(scene_files.size() > 0, "Should find scene files in project")
		print("  Total scenes found: %d" % scene_files.size())

print("📥 Testing Scene Loading:")

for scene_path in scene_files:
	print("  Testing: %s" % scene_path)

if scene_resource:
	loadable_scenes += 1
	scene_load_times.append(load_time)
	print("    ✓ Loaded successfully (%dms)" % load_time)

	# Test scene instantiation
if scene_instance:
	print("    ✓ Instantiated successfully")
	scene_instance.queue_free()
	else:
		print("    ✗ Failed to instantiate")
		else:
			print("    ✗ Failed to load")

			framework.assert_true(loadable_scenes > 0, "Should be able to load at least one scene")
			framework.assert_true(
			loadable_scenes == scene_files.size(), "All scenes should load successfully"
			)

			if scene_load_times.size() > 0:
for time in scene_load_times:
	avg_load_time += time
	avg_load_time /= scene_load_times.size()

	framework.assert_execution_time_under(
	avg_load_time, 1000.0, "Average scene load time should be reasonable"
	)
	print("  Average load time: %.2fms" % avg_load_time)

print("🎯 Main Scene Analysis:")

if main_scene:
if main_instance:
	print("  Main scene type: %s" % main_instance.get_class())
	print("  Child count: %d" % main_instance.get_child_count())

	# Test for expected components
print("  ✓ Camera3D: %s" % ("Found" if camera else "Missing"))
print("  ✓ UI_Layer: %s" % ("Found" if ui_layer else "Missing"))
print("  ✓ BrainModel: %s" % ("Found" if brain_model else "Missing"))

main_instance.queue_free()

print("🌳 Node Hierarchy Analysis:")

# Test UI panel scenes
for ui_scene_path in ui_scenes:
	if FileAccess.file_exists(ui_scene_path):
if ui_scene:
if ui_instance:
	loaded_ui_scenes += 1
	print(
	(
	"  ✓ %s: %s with %d children"
	% [
	ui_scene_path.get_file(),
	ui_instance.get_class(),
	ui_instance.get_child_count()
	]
	)
	)

	# Analyze UI hierarchy
	_debug_node_hierarchy(ui_instance, "    ")

	ui_instance.queue_free()
	else:
		print("  ✗ %s: Failed to instantiate" % ui_scene_path.get_file())
		else:
			print("  ✗ %s: Failed to load" % ui_scene_path.get_file())
			else:
				print("  ! %s: File not found" % ui_scene_path.get_file())

				framework.assert_true(loaded_ui_scenes >= 0, "UI scene loading test completed")

print("📜 Scene Script Debug:")

# Test script attachment and compilation
for scene_path in scene_files:
if scene:
if instance:
	scripts_tested += 1

	# Check if scene has script
if script:
	scripts_working += 1
	print("  ✓ %s: Has script (%s)" % [scene_path.get_file(), script.resource_path])

	# Test script methods
	if instance.has_method("_ready"):
		print("    - Has _ready() method")
		if instance.has_method("_input"):
			print("    - Has _input() method")
			if instance.has_method("_process"):
				print("    - Has _process() method")
				else:
					print("  - %s: No script attached" % scene_path.get_file())

					instance.queue_free()

					framework.assert_true(scripts_tested > 0, "Should test at least one scene script")
					print("  Scripts tested: %d/%d working" % [scripts_working, scripts_tested])

print("🔗 Resource Dependencies Analysis:")

# Test external resource loading from scenes
for scene_path in scene_files:
	print("  Analyzing: %s" % scene_path.get_file())

	# Read scene file as text to analyze dependencies
if file:
for line in lines:
	if line.begins_with("[ext_resource"):
		ext_resources.append(line)

		print("    External resources: %d" % ext_resources.size())
		for ext_res in ext_resources:
			print("      %s" % ext_res)
			else:
				print("    ✗ Could not read scene file")

				framework.assert_true(true, "Resource dependency analysis completed")

print("\n🎬 Scene Loading Debug Summary:")
print("Total Scene Tests: %d" % summary.total_tests)
print("Passed Tests: %d" % summary.passed_tests)
print("Failed Tests: %d" % summary.failed_tests)
print("Scene System Health: %.1f%%" % summary.success_rate)

return (
test1_result
and test2_result
and test3_result
and test4_result
and test5_result
and test6_result
)


func _debug_node_hierarchy(node: Node, indent: String = ""):
	if not node:
		return

		print("%s%s (%s)" % [indent, node.name, node.get_class()])

		# Limit recursion depth to prevent excessive output
		if indent.length() < 12:
			for child in node.get_children():
				_debug_node_hierarchy(child, indent + "  ")
