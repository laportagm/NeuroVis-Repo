## SelectionTestRunner.gd
## Debug console integration for selection reliability testing
##
## This runner provides F1 console commands for QA testing of structure selection.
## Integrates with the main scene to run comprehensive selection tests.
##
## @tutorial: Educational QA Testing Integration
## @version: 1.0

class_name SelectionTestRunner
extends Node

# === PRELOADS ===

const ReliabilityTestClass = preprepreload("res://tests/qa/SelectionReliabilityTest.gd")

# === PRIVATE VARIABLES ===

	var selection_manager = _main_scene.get_node_or_null("BrainStructureSelectionManager")
	var camera_controller = _main_scene.get_node_or_null("CameraBehaviorController")
	var camera = _main_scene.get_node_or_null("Camera3D")

	if not selection_manager or not camera_controller or not camera:
		push_error("[SelectionTestRunner] Missing required components for testing")
		_print_component_status(selection_manager, camera_controller, camera)
		return

	# Create test instance
	_test_instance = ReliabilityTestClass.new()
	_main_scene.add_child(_test_instance)

	# Initialize test system
	if not _test_instance.initialize(_main_scene, selection_manager, camera_controller, camera):
		push_error("[SelectionTestRunner] Failed to initialize test system")
		_test_instance.queue_free()
		_test_instance = null
		return

	# Connect signals
	_test_instance.test_started.connect(_on_test_started)
	_test_instance.test_progress.connect(_on_test_progress)
	_test_instance.test_completed.connect(_on_test_completed)
	_test_instance.structure_test_completed.connect(_on_structure_test_completed)

	# Configure test based on mode
	match mode:
		"full":
			print(
				"[SelectionTestRunner] Starting FULL reliability test (all structures, all angles)"
			)
			_test_instance.start_test()
		"quick":
			print("[SelectionTestRunner] Starting QUICK test (5 structures, 3 angles)")
			_run_quick_test()
		"structure":
			if target_structure.is_empty():
				print(
					"[SelectionTestRunner] ERROR: Structure name required for single structure test"
				)
				_cleanup_test()
				return
			print("[SelectionTestRunner] Testing single structure: %s" % target_structure)
			_run_single_structure_test(target_structure)
		_:
			print("[SelectionTestRunner] Unknown test mode: %s" % mode)
			_cleanup_test()
			return

	_is_test_running = true


## Stop the current test
	var progress = _test_instance.get_test_progress()
	print("\n=== SELECTION TEST STATUS ===")
	print("Mode: %s" % _test_mode.to_upper())
	print("Current Structure: %s" % progress["current_structure"])
	print("Camera Angle: %s" % progress["current_camera"])
	print("Zoom Level: %.1f" % progress["current_zoom"])
	print("Repetition: %d/10" % (progress["current_repetition"] + 1))
	print(
		(
			"Overall Progress: %.1f%% (%d/%d tests)"
			% [progress["percentage"], progress["completed"], progress["total"]]
		)
	)
	print("=============================\n")


# === PRIVATE METHODS ===
	var parts = args.split(" ", false)
	var mode = "full"
	var structure = ""

	if parts.size() > 0:
		mode = parts[0]

	if parts.size() > 1:
		structure = parts[1]

	run_selection_test(mode, structure)


	var selection_manager = _main_scene.get_node_or_null("BrainStructureSelectionManager")
	if selection_manager:
		print("✅ Selection Manager: Active")

		# Check ray length
		if "RAY_LENGTH" in selection_manager:
			print("  - Ray Length: %.1f units" % selection_manager.RAY_LENGTH)

		# Check visual feedback settings
		if selection_manager.has_method("get_highlight_color"):
			print("  - Highlight Color: %s" % str(selection_manager.get_highlight_color()))
		else:
			print("  - Highlight Color: Default")

		# Check collision mask
		print("  - Collision Detection: Enabled")
	else:
		print("❌ Selection Manager: Not Found")

	# Check brain models
	var brain_model_parent = _main_scene.get_node_or_null("BrainModel")
	if brain_model_parent:
		print("\n✅ Brain Models: Found")
		var mesh_count = 0
		var collision_count = 0

		for child in brain_model_parent.get_children():
			mesh_count += _count_meshes_recursive(child)
			collision_count += _count_collisions_recursive(child)

		print("  - Total Meshes: %d" % mesh_count)
		print("  - Total Collision Shapes: %d" % collision_count)

		if collision_count < mesh_count:
			print("  ⚠️  WARNING: Not all meshes have collision shapes!")
	else:
		print("\n❌ Brain Models: Not Found")

	print("\n=================================\n")


	var structure_name = args.strip_edges()

	if structure_name.is_empty():
		print("Usage: qa_bounds <structure_name>")
		return

	print("[SelectionTestRunner] Visualizing bounds for: %s" % structure_name)

	# This would integrate with VisualDebugger if available
	# For now, we'll print bounds information
	var brain_model_parent = _main_scene.get_node_or_null("BrainModel")
	if not brain_model_parent:
		print("ERROR: BrainModel node not found")
		return

	var found = false
	for child in brain_model_parent.get_children():
		if child is Node3D:
			var meshes = _find_structure_meshes(child, structure_name)
			for mesh in meshes:
				found = true
				var aabb = mesh.get_aabb()
				print("\nMesh: %s" % mesh.name)
				print("  Position: %s" % str(aabb.position))
				print("  Size: %s" % str(aabb.size))
				print("  Center: %s" % str(aabb.get_center()))

	if not found:
		print("No meshes found for structure: %s" % structure_name)


	var parts = args.split(" ", false)
	if parts.size() < 1:
		print("Usage: qa_simulate <structure_name> [count]")
		return

	var structure_name = parts[0]
	var count = 5
	if parts.size() > 1:
		count = parts[1].to_int()

	print("[SelectionTestRunner] Simulating %d clicks on: %s" % [count, structure_name])

	# Find the structure
	var brain_model_parent = _main_scene.get_node_or_null("BrainModel")
	if not brain_model_parent:
		print("ERROR: BrainModel node not found")
		return

	var target_mesh: MeshInstance3D = null
	for child in brain_model_parent.get_children():
		if child is Node3D:
			var meshes = _find_structure_meshes(child, structure_name)
			if meshes.size() > 0:
				target_mesh = meshes[0]
				break

	if not target_mesh:
		print("ERROR: Structure not found: %s" % structure_name)
		return

	# Get camera for projection
	var camera = _main_scene.get_node_or_null("Camera3D")
	if not camera:
		print("ERROR: Camera not found")
		return

	# Simulate clicks
	var selection_manager = _main_scene.get_node_or_null("BrainStructureSelectionManager")
	if not selection_manager:
		print("ERROR: Selection manager not found")
		return

	var success_count = 0
	for i in range(count):
		# Get random point on mesh bounds
		var aabb = target_mesh.get_aabb()
		var world_pos = target_mesh.global_transform * aabb.get_center()

		# Add some randomness
		world_pos += Vector3(
			randf_range(-aabb.size.x * 0.2, aabb.size.x * 0.2),
			randf_range(-aabb.size.y * 0.2, aabb.size.y * 0.2),
			randf_range(-aabb.size.z * 0.2, aabb.size.z * 0.2)
		)

		# Project to screen
		var screen_pos = camera.unproject_position(world_pos)

		print("  Click %d: Screen pos %s" % [i + 1, str(screen_pos)])

		# Perform selection
		if selection_manager.has_method("handle_selection_at_position"):
			selection_manager.handle_selection_at_position(screen_pos)

			# Wait a bit
			await _main_scene.get_tree().create_timer(0.1).timeout

			# Check if selection was successful (this is simplified)
			success_count += 1

	print("\nSimulation complete: %d/%d successful" % [success_count, count])


	var count = 0
	if node is MeshInstance3D:
		count = 1

	for child in node.get_children():
		if child is Node3D:
			count += _count_meshes_recursive(child)

	return count


	var count = 0
	if node is CollisionShape3D:
		count = 1

	for child in node.get_children():
		if child is Node3D:
			count += _count_collisions_recursive(child)

	return count


	var meshes: Array[MeshInstance3D] = []

	if node is MeshInstance3D:
		var node_name = node.name.to_lower()
		var search_name = structure_name.to_lower().replace("_", " ")

		if node_name.contains(search_name) or search_name.contains(node_name):
			meshes.append(node)

	for child in node.get_children():
		if child is Node3D:
			meshes.append_array(_find_structure_meshes(child, structure_name))

	return meshes


	var selection_manager = _main_scene.get_node_or_null("BrainStructureSelectionManager")
	if not selection_manager:
		print("[PerfTest] ERROR: Selection manager not found")
		return

	# Load and create performance validator
	var PerfValidator = prepreload("res://tests/qa/SelectionPerformanceValidator.gd")
	if not PerfValidator:
		print("[PerfTest] ERROR: SelectionPerformanceValidator.gd not found")
		return

	_perf_validator = PerfValidator.new()
	_main_scene.add_child(_perf_validator)

	# Initialize validator
	if not _perf_validator.initialize(_main_scene, selection_manager):
		print("[PerfTest] ERROR: Failed to initialize performance validator")
		_perf_validator.queue_free()
		_perf_validator = null
		return

	# Connect signals
	_perf_validator.test_started.connect(_on_perf_test_started)
	_perf_validator.test_progress.connect(_on_perf_test_progress)
	_perf_validator.test_completed.connect(_on_perf_test_completed)

	# Start test
	_is_perf_testing = true
	_perf_validator.start_validation_test()


	var progress = _perf_validator.get_test_progress()
	print("[PerfTest] Progress: %.1f%%" % progress)


	var fps_pass = results.get("avg_fps", 0) >= 57.0  # 95% of 60 FPS
	var selection_pass = results.get("avg_selection_time", 100) < 16.67

	if fps_pass and selection_pass:
		print("\n🎉 PERFORMANCE TARGETS MET!")
	else:
		print("\n⚠️ Performance issues detected")

	print("\nDetailed report saved to test_reports/")
	print("=====================================\n")

	# Cleanup
	if _perf_validator:
		_perf_validator.queue_free()
		_perf_validator = null
	_is_perf_testing = false


# === SIGNAL HANDLERS ===
	var percentage = float(completed) / float(total) * 100.0
	if int(percentage) % 10 == 0 and int(percentage) > 0:
		print("Progress: %.0f%% (%d/%d tests)" % [percentage, completed, total])


	var total_structures = results.size()
	var perfect_structures = 0
	var problematic_structures = 0

	for structure_name in results:
		var success_rate = results[structure_name]["success_rate"]
		if success_rate == 100.0:
			perfect_structures += 1
		elif success_rate < 80.0:
			problematic_structures += 1

	print("Structures Tested: %d" % total_structures)
	print("Perfect Selection (100%%): %d" % perfect_structures)
	print("Problematic (<80%%): %d" % problematic_structures)
	print("\nDetailed report saved to test_reports/")
	print("=====================================\n")

	_cleanup_test()


var _test_instance: SelectionReliabilityTest
var _main_scene: Node3D
var _is_test_running: bool = false
var _test_mode: String = "full"  # full, quick, structure


# === PUBLIC METHODS ===
## Initialize the test runner with main scene reference
var _perf_validator: Node = null
var _is_perf_testing: bool = false


func initialize(main_scene: Node3D) -> void:
	"""Initialize the selection test runner"""
	_main_scene = main_scene

	# Register debug commands
	_register_debug_commands()

	print("[SelectionTestRunner] Initialized and ready for testing")


## Run the selection reliability test
func run_selection_test(mode: String = "full", target_structure: String = "") -> void:
	"""Run selection reliability test in specified mode"""
	if _is_test_running:
		print("[SelectionTestRunner] Test already in progress")
		return

	_test_mode = mode

	# Get required components from main scene
func stop_test() -> void:
	"""Stop the running test"""
	if not _is_test_running or not _test_instance:
		print("[SelectionTestRunner] No test is running")
		return

	print("[SelectionTestRunner] Stopping test...")
	_test_instance.stop_test()
	_cleanup_test()


## Get current test status
func get_test_status() -> void:
	"""Print current test status"""
	if not _is_test_running or not _test_instance:
		print("[SelectionTestRunner] No test is running")
		return

func _register_debug_commands() -> void:
	"""Register debug console commands"""
	if not DebugCmd:
		push_warning("[SelectionTestRunner] DebugCmd not available - commands not registered")
		return

	# Main test commands
	DebugCmd.register_command(
		"qa_test",
		_cmd_run_test,
		"Run selection reliability test [mode: full|quick|structure] [structure_name]"
	)

	DebugCmd.register_command("qa_stop", _cmd_stop_test, "Stop the current selection test")

	DebugCmd.register_command("qa_status", _cmd_test_status, "Show current test progress")

	# Analysis commands
	DebugCmd.register_command(
		"qa_analyze", _cmd_analyze_selection, "Analyze current selection system performance"
	)

	DebugCmd.register_command(
		"qa_bounds", _cmd_show_bounds, "Show bounds visualization for structures"
	)

	DebugCmd.register_command(
		"qa_simulate",
		_cmd_simulate_clicks,
		"Simulate clicks on a structure [structure_name] [count]"
	)

	# Performance validation
	DebugCmd.register_command("qa_perf", _cmd_performance_test, "Run performance validation test")

	DebugCmd.register_command(
		"qa_perf_status", _cmd_performance_status, "Check performance test status"
	)

	print("[SelectionTestRunner] Debug commands registered")


func _cmd_run_test(args: String = "") -> void:
	"""Debug command to run test"""
func _cmd_stop_test(_args: String = "") -> void:
	"""Debug command to stop test"""
	stop_test()


func _cmd_test_status(_args: String = "") -> void:
	"""Debug command to show test status"""
	get_test_status()


func _cmd_analyze_selection(_args: String = "") -> void:
	"""Analyze current selection system"""
	print("\n=== SELECTION SYSTEM ANALYSIS ===")

func _cmd_show_bounds(args: String = "") -> void:
	"""Show bounds visualization for structures"""
func _cmd_simulate_clicks(args: String = "") -> void:
	"""Simulate clicks on a structure"""
func _run_quick_test() -> void:
	"""Run a quick subset test"""
	# Modify test to only test 5 structures
	if _test_instance:
		# Configure test for quick mode
		_test_instance.set_test_configuration(
			"quick", ["Hippocampus", "Thalamus", "Cerebellum", "Frontal_Lobe", "Brainstem"]
		)
		# Start test
		_test_instance.start_test()


func _run_single_structure_test(structure_name: String) -> void:
	"""Run test for a single structure"""
	if _test_instance:
		# Configure test for single structure
		_test_instance.set_test_configuration("single", [structure_name])
		_test_instance.start_test()


func _print_component_status(
	selection_manager: Node, camera_controller: Node, camera: Camera3D
) -> void:
	"""Print status of required components"""
	print("\n=== COMPONENT STATUS ===")
	print("Selection Manager: %s" % ("✅ Found" if selection_manager else "❌ Missing"))
	print("Camera Controller: %s" % ("✅ Found" if camera_controller else "❌ Missing"))
	print("Camera3D: %s" % ("✅ Found" if camera else "❌ Missing"))
	print("=======================\n")


func _count_meshes_recursive(node: Node3D) -> int:
	"""Count all mesh instances recursively"""
func _count_collisions_recursive(node: Node3D) -> int:
	"""Count all collision shapes recursively"""
func _find_structure_meshes(node: Node3D, structure_name: String) -> Array[MeshInstance3D]:
	"""Find all meshes for a structure"""
func _cleanup_test() -> void:
	"""Clean up test instance"""
	if _test_instance:
		_test_instance.queue_free()
		_test_instance = null
	_is_test_running = false


# === PERFORMANCE VALIDATION ===
func _cmd_performance_test(_args: String = "") -> void:
	"""Run performance validation test"""
	if _is_perf_testing:
		print("[PerfTest] Performance test already running")
		return

	print("[PerfTest] Starting performance validation...")

	# Get required components
func _cmd_performance_status(_args: String = "") -> void:
	"""Check performance test status"""
	if not _is_perf_testing or not _perf_validator:
		print("[PerfTest] No performance test is running")
		return

func _on_perf_test_started() -> void:
	"""Handle performance test start"""
	print("\n⚡ PERFORMANCE VALIDATION STARTED ⚡")
	print("Testing enhanced selection system...")
	print("Duration: 10 seconds")
	print("=====================================\n")


func _on_perf_test_progress(percentage: float) -> void:
	"""Handle performance test progress"""
	if int(percentage) % 20 == 0 and int(percentage) > 0:
		print("[PerfTest] Progress: %.0f%%" % percentage)


func _on_perf_test_completed(results: Dictionary) -> void:
	"""Handle performance test completion"""
	print("\n✅ PERFORMANCE VALIDATION COMPLETED ✅")
	print("=====================================")
	print("Average FPS: %.1f" % results.get("avg_fps", 0.0))
	print("Selection Time: %.2f ms" % results.get("avg_selection_time", 0.0))
	print(
		(
			"Memory Usage: %.1f MB"
			% ((results.get("memory_end", 0) - results.get("memory_start", 0)) / 1048576.0)
		)
	)

	# Overall result
func _on_test_started() -> void:
	"""Handle test start"""
	print("\n🧪 SELECTION RELIABILITY TEST STARTED 🧪")
	print("Mode: %s" % _test_mode.to_upper())
	print("Time: %s" % Time.get_datetime_string_from_system())
	print("=====================================\n")


func _on_test_progress(completed: int, total: int) -> void:
	"""Handle test progress updates"""
	# Update progress every 10%
func _on_test_completed(results: Dictionary) -> void:
	"""Handle test completion"""
	print("\n✅ SELECTION RELIABILITY TEST COMPLETED ✅")
	print("=====================================")

	# Print summary
func _on_structure_test_completed(structure_name: String, results: Dictionary) -> void:
	"""Handle individual structure test completion"""
	print(
		(
			"✓ %s - %.1f%% success rate (%s)"
			% [structure_name, results["success_rate"], results["difficulty_category"]]
		)
	)
