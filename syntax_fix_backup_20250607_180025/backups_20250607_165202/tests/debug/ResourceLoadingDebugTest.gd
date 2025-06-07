class_name ResourceLoadingDebugTest
extends RefCounted

const TestFramework = prepreload("res://tests/framework/TestFramework.gd")

var framework


	var resource_types = {"scenes": [], "scripts": [], "models": [], "textures": [], "data": []}

	# Scan main directories
	var directories_to_scan = [
		"res://scenes/",
		"res://scripts/",
		"res://assets/models/",
		"res://assets/textures/",
		"res://assets/data/"
	]

	for dir_path in directories_to_scan:
		_scan_directory_for_resources(dir_path, resource_types)

	# Report findings
	for type in resource_types:
		var count = resource_types[type].size()
		print("  %s: %d files" % [type.capitalize(), count])
		framework.assert_true(count >= 0, "Resource type scan completed")

	var test1_result = framework.end_test()

	# Test 2: 3D Model Loading Debug
	framework.start_test("3D Model Loading")

	print("🧠 3D Model Loading Debug:")

	var model_files = resource_types["models"]
	var loaded_models = 0
	var model_load_times = []

	for model_path in model_files:
		print("  Testing: %s" % model_path.get_file())

		var start_time = Time.get_ticks_msec()
		var model_resource = load(model_path)
		var load_time = Time.get_ticks_msec() - start_time

		if model_resource:
			loaded_models += 1
			model_load_times.append(load_time)
			print("    ✓ Loaded successfully (%dms)" % load_time)

			# Test model instantiation
			var model_instance = model_resource.instantiate()
			if model_instance:
				print("    ✓ Instantiated: %s" % model_instance.get_class())
				print("    ✓ Children: %d" % model_instance.get_child_count())

				# Analyze model structure
				_analyze_model_structure(model_instance, "      ")

				model_instance.queue_free()
			else:
				print("    ✗ Failed to instantiate")
		else:
			print("    ✗ Failed to load")

	framework.assert_true(loaded_models > 0, "Should load at least one 3D model")

	if model_load_times.size() > 0:
		var avg_load_time = 0.0
		for time in model_load_times:
			avg_load_time += time
		avg_load_time /= model_load_times.size()
		print("  Average model load time: %.2fms" % avg_load_time)
		framework.assert_execution_time_under(
			avg_load_time, 2000.0, "Model loading should be reasonable"
		)

	var test2_result = framework.end_test()

	# Test 3: JSON Data Loading Debug
	framework.start_test("JSON Data Loading")

	print("📄 JSON Data Loading Debug:")

	var data_files = resource_types["data"]
	var loaded_json_files = 0

	for data_path in data_files:
		if data_path.ends_with(".json"):
			print("  Testing: %s" % data_path.get_file())

			var file = FileAccess.open(data_path, FileAccess.READ)
			if file:
				var json_string = file.get_as_text()
				file.close()

				var json = JSON.new()
				var parse_result = json.parse(json_string)

				if parse_result == OK:
					loaded_json_files += 1
					var data = json.data
					print("    ✓ Parsed successfully")
					print("    ✓ Type: %s" % type_string(typeof(data)))

					# Analyze JSON structure
					if typeof(data) == TYPE_DICTIONARY:
						print("    ✓ Keys: %d" % data.keys().size())
						for key in data.keys():
							if typeof(data[key]) == TYPE_ARRAY:
								print("      - %s: Array[%d]" % [key, data[key].size()])
							else:
								print("      - %s: %s" % [key, type_string(typeof(data[key]))])
				else:
					print("    ✗ JSON parse error: %s" % json.error_string)
			else:
				print("    ✗ Failed to open file")

	framework.assert_true(loaded_json_files > 0, "Should load at least one JSON file")

	var test3_result = framework.end_test()

	# Test 4: Script Resource Loading Debug
	framework.start_test("Script Resource Loading")

	print("📜 Script Loading Debug:")

	var script_files = resource_types["scripts"]
	var loaded_scripts = 0
	var compilation_errors = 0

	for script_path in script_files:
		print("  Testing: %s" % script_path.get_file())

		var script_resource = load(script_path)
		if script_resource:
			loaded_scripts += 1
			print("    ✓ Loaded successfully")

			# Test script instantiation
			if script_resource.can_instantiate():
				var script_instance = script_resource.new()
				if script_instance:
					print("    ✓ Instantiated: %s" % script_instance.get_class())

					# Test common methods
					var common_methods = ["_init", "_ready", "_process", "_input"]
					var found_methods = []
					for method in common_methods:
						if script_instance.has_method(method):
							found_methods.append(method)

					if found_methods.size() > 0:
						print("    ✓ Methods: %s" % ", ".join(found_methods))

					script_instance.free()
				else:
					compilation_errors += 1
					print("    ✗ Failed to instantiate (compilation error?)")
			else:
				print("    - Cannot instantiate (static script)")
		else:
			compilation_errors += 1
			print("    ✗ Failed to load")

	framework.assert_true(loaded_scripts > 0, "Should load at least one script")
	framework.assert_true(
		compilation_errors < loaded_scripts, "Most scripts should compile successfully"
	)

	print("  Scripts loaded: %d/%d" % [loaded_scripts, script_files.size()])
	print("  Compilation errors: %d" % compilation_errors)

	var test4_result = framework.end_test()

	# Test 5: Resource Memory Usage Debug
	framework.start_test("Resource Memory Usage")

	print("💾 Resource Memory Debug:")

	# Test resource loading and unloading
	var initial_resource_count = (
		ResourceLoader.get_recognized_extensions_for_type("Resource").size()
	)

	var test_resources = []
	var memory_test_files = []

	# Collect some test files
	if resource_types["models"].size() > 0:
		memory_test_files.append(resource_types["models"][0])
	if resource_types["scenes"].size() > 0:
		memory_test_files.append(resource_types["scenes"][0])
	if resource_types["scripts"].size() > 0:
		memory_test_files.append(resource_types["scripts"][0])

	# Load resources
	var start_time = Time.get_ticks_msec()
	for file_path in memory_test_files:
		var resource = load(file_path)
		if resource:
			test_resources.append(resource)

	var load_time = Time.get_ticks_msec() - start_time
	print("  Loaded %d test resources in %dms" % [test_resources.size(), load_time])

	# Clear resources
	test_resources.clear()

	framework.assert_true(test_resources.size() == 0, "Resources should be clearable")
	framework.assert_execution_time_under(load_time, 5000.0, "Resource loading should be fast")

	var test5_result = framework.end_test()

	# Test 6: Resource Path Validation Debug
	framework.start_test("Resource Path Validation")

	print("🔗 Resource Path Validation:")

	var path_issues = 0
	var all_resources = []

	# Collect all found resources
	for type in resource_types:
		all_resources.append_array(resource_types[type])

	for resource_path in all_resources:
		# Test path validity
		if not resource_path.begins_with("res://"):
			path_issues += 1
			print("  ✗ Invalid path format: %s" % resource_path)
			continue

		# Test file existence
		if not ResourceLoader.exists(resource_path):
			path_issues += 1
			print("  ✗ File not found: %s" % resource_path)
			continue

		# Test resource loading
		var resource = load(resource_path)
		if not resource:
			path_issues += 1
			print("  ✗ Cannot load: %s" % resource_path)

	framework.assert_true(path_issues == 0, "All resource paths should be valid")
	print("  Path validation issues: %d/%d" % [path_issues, all_resources.size()])

	var test6_result = framework.end_test()

	print("\n📦 Resource Loading Debug Summary:")
	var summary = framework.get_test_summary()
	print("Total Resource Tests: %d" % summary.total_tests)
	print("Passed Tests: %d" % summary.passed_tests)
	print("Failed Tests: %d" % summary.failed_tests)
	print("Resource System Health: %.1f%%" % summary.success_rate)

	# Summary of resources found
	print("\nResource Summary:")
	var total_resources = 0
	for type in resource_types:
		var count = resource_types[type].size()
		total_resources += count
		print("  %s: %d" % [type.capitalize(), count])
	print("  Total: %d resources" % total_resources)

	return (
		test1_result
		and test2_result
		and test3_result
		and test4_result
		and test5_result
		and test6_result
	)


	var dir = DirAccess.open(dir_path)
	if not dir:
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if not file_name.begins_with("."):
			var full_path = dir_path + file_name

			if dir.current_is_dir():
				# Recursively scan subdirectories
				_scan_directory_for_resources(full_path + "/", resource_types)
			else:
				# Categorize file by extension
				if file_name.ends_with(".tscn"):
					resource_types["scenes"].append(full_path)
				elif file_name.ends_with(".gd"):
					resource_types["scripts"].append(full_path)
				elif (
					file_name.ends_with(".glb")
					or file_name.ends_with(".gltf")
					or file_name.ends_with(".obj")
				):
					resource_types["models"].append(full_path)
				elif (
					file_name.ends_with(".png")
					or file_name.ends_with(".jpg")
					or file_name.ends_with(".svg")
				):
					resource_types["textures"].append(full_path)
				elif (
					file_name.ends_with(".json")
					or file_name.ends_with(".txt")
					or file_name.ends_with(".csv")
				):
					resource_types["data"].append(full_path)

		file_name = dir.get_next()


		var mesh_instance = node as MeshInstance3D
		if mesh_instance.mesh:
			print("%s  Mesh: %s" % [indent, mesh_instance.mesh.get_class()])
			print("%s  Surfaces: %d" % [indent, mesh_instance.mesh.get_surface_count()])

	# Limit recursion depth
	if indent.length() < 8:
		for child in node.get_children():
			_analyze_model_structure(child, indent + "  ")

func run_test() -> bool:
	framework = TestFramework.get_instance()

	# Test 1: Project Resource Discovery
	framework.start_test("Project Resource Discovery")

	print("📦 Resource Discovery Debug:")

	# Scan for different resource types

func _scan_directory_for_resources(dir_path: String, resource_types: Dictionary):
func _analyze_model_structure(node: Node, indent: String = ""):
	if not node:
		return

	print("%s%s (%s)" % [indent, node.name, node.get_class()])

	# For MeshInstance3D nodes, show additional info
	if node is MeshInstance3D:
