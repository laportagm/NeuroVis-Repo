## Performance Baseline Test
## Establishes performance benchmarks for NeuroVis educational platform
## @version: 1.0

extends SceneTree

# === CONSTANTS ===
const TEST_DURATION: float = 5.0  # Run each test for 5 seconds
const TARGET_FPS: float = 60.0
const ACCEPTABLE_FRAME_TIME: float = 16.67  # milliseconds (1000/60)

# === TEST RESULTS ===
var test_results: Dictionary = {
	"scene_loading": {},
	"model_rendering": {},
	"ui_responsiveness": {},
	"memory_usage": {},
	"overall_score": 0.0
}

var start_time: float = 0.0
var frame_count: int = 0
var frame_times: Array = []
var current_test: String = ""


# === MAIN ===
func _initialize() -> void:
	print("\n=== NeuroVis Performance Baseline Test ===")
	print("Target: 60fps (16.67ms frame time)")
	print("Duration: %.1f seconds per test\n" % TEST_DURATION)

	# Run tests in sequence
	await _test_scene_loading()
	await _test_model_rendering()
	await _test_ui_responsiveness()
	await _test_memory_usage()

	# Calculate overall score
	_calculate_overall_score()

	# Print results
	_print_results()

	# Save results
	_save_results()

	# Exit
	quit()


# === TEST METHODS ===
func _test_scene_loading() -> void:
	"""Test scene loading performance"""
	current_test = "scene_loading"
	print("Testing: Scene Loading...")

	var load_start = Time.get_ticks_msec()

	# Load main scene
	var main_scene = load("res://scenes/main/node_3d.tscn")
	if not main_scene:
		test_results[current_test]["error"] = "Failed to load main scene"
		return

	var load_time = Time.get_ticks_msec() - load_start
	test_results[current_test]["load_time_ms"] = load_time
	test_results[current_test]["target_met"] = load_time < 3000  # 3 second target

	# Instance scene
	var instance_start = Time.get_ticks_msec()
	var instance = main_scene.instantiate()
	var instance_time = Time.get_ticks_msec() - instance_start

	test_results[current_test]["instance_time_ms"] = instance_time
	test_results[current_test]["total_time_ms"] = load_time + instance_time

	if instance:
		instance.queue_free()

	await create_timer(0.1).timeout


func _test_model_rendering() -> void:
	"""Test 3D model rendering performance"""
	current_test = "model_rendering"
	print("Testing: Model Rendering...")

	# Reset frame tracking
	frame_count = 0
	frame_times.clear()
	start_time = Time.get_ticks_msec() / 1000.0

	# Create test scene with models
	var test_scene = Node3D.new()
	root.add_child(test_scene)

	# Add camera
	var camera = Camera3D.new()
	camera.position = Vector3(15, 10, 15)
	camera.look_at(Vector3.ZERO, Vector3.UP)
	test_scene.add_child(camera)

	# Load brain models
	var models = [
		"res://assets/models/Half_Brain.glb", "res://assets/models/Internal_Structures.glb"
	]

	for model_path in models:
		var model = load(model_path)
		if model:
			var instance = model.instantiate()
			test_scene.add_child(instance)

	# Run rendering test
	var test_duration = 0.0
	while test_duration < TEST_DURATION:
		await process_frame
		_track_frame_time()
		test_duration = (Time.get_ticks_msec() / 1000.0) - start_time

	# Calculate results
	_calculate_frame_stats("model_rendering")

	# Cleanup
	test_scene.queue_free()
	await create_timer(0.1).timeout


func _test_ui_responsiveness() -> void:
	"""Test UI responsiveness"""
	current_test = "ui_responsiveness"
	print("Testing: UI Responsiveness...")

	# Reset frame tracking
	frame_count = 0
	frame_times.clear()
	start_time = Time.get_ticks_msec() / 1000.0

	# Create UI test scene
	var ui_test = Control.new()
	ui_test.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.add_child(ui_test)

	# Add test UI elements
	var panel_count = 10
	var panels = []

	for i in panel_count:
		var panel = PanelContainer.new()
		panel.size = Vector2(200, 150)
		panel.position = Vector2(i * 50, i * 30)

		var label = Label.new()
		label.text = "Test Panel %d" % i
		panel.add_child(label)

		ui_test.add_child(panel)
		panels.append(panel)

	# Simulate UI updates
	var test_duration = 0.0
	var update_counter = 0

	while test_duration < TEST_DURATION:
		await process_frame
		_track_frame_time()

		# Update UI elements
		update_counter += 1
		for i in panels.size():
			var panel = panels[i]
			panel.modulate.a = 0.5 + 0.5 * sin(update_counter * 0.1 + i)

		test_duration = (Time.get_ticks_msec() / 1000.0) - start_time

	# Calculate results
	_calculate_frame_stats("ui_responsiveness")

	# Cleanup
	ui_test.queue_free()
	await create_timer(0.1).timeout


func _test_memory_usage() -> void:
	"""Test memory usage patterns"""
	current_test = "memory_usage"
	print("Testing: Memory Usage...")

	# Get initial memory
	var initial_static = OS.get_static_memory_usage()
	var initial_dynamic = Performance.get_monitor(Performance.MEMORY_DYNAMIC)

	test_results[current_test]["initial_static_mb"] = initial_static / 1048576.0
	test_results[current_test]["initial_dynamic_mb"] = initial_dynamic / 1048576.0

	# Load and unload resources
	var resources = []
	for i in 5:
		var model = load("res://assets/models/Internal_Structures.glb")
		if model:
			resources.append(model)

	# Check peak memory
	var peak_static = OS.get_static_memory_usage()
	var peak_dynamic = Performance.get_monitor(Performance.MEMORY_DYNAMIC)

	test_results[current_test]["peak_static_mb"] = peak_static / 1048576.0
	test_results[current_test]["peak_dynamic_mb"] = peak_dynamic / 1048576.0

	# Clear resources
	resources.clear()

	# Force garbage collection
	await create_timer(1.0).timeout

	# Check final memory
	var final_static = OS.get_static_memory_usage()
	var final_dynamic = Performance.get_monitor(Performance.MEMORY_DYNAMIC)

	test_results[current_test]["final_static_mb"] = final_static / 1048576.0
	test_results[current_test]["final_dynamic_mb"] = final_dynamic / 1048576.0

	# Calculate memory leak indicator
	var static_diff = final_static - initial_static
	var dynamic_diff = final_dynamic - initial_dynamic

	test_results[current_test]["static_diff_mb"] = static_diff / 1048576.0
	test_results[current_test]["dynamic_diff_mb"] = dynamic_diff / 1048576.0
	test_results[current_test]["potential_leak"] = static_diff > 10485760  # 10MB threshold


# === HELPER METHODS ===
func _track_frame_time() -> void:
	"""Track frame timing"""
	frame_count += 1
	var frame_time = Performance.get_monitor(Performance.TIME_PROCESS) * 1000.0
	frame_times.append(frame_time)


func _calculate_frame_stats(test_name: String) -> void:
	"""Calculate frame statistics"""
	if frame_times.is_empty():
		return

	# Sort for percentile calculation
	frame_times.sort()

	# Calculate stats
	var avg_frame_time = 0.0
	var max_frame_time = 0.0
	var min_frame_time = 999999.0

	for time in frame_times:
		avg_frame_time += time
		max_frame_time = max(max_frame_time, time)
		min_frame_time = min(min_frame_time, time)

	avg_frame_time /= frame_times.size()

	# Calculate percentiles
	var p95_index = int(frame_times.size() * 0.95)
	var p99_index = int(frame_times.size() * 0.99)

	# Store results
	test_results[test_name]["frame_count"] = frame_count
	test_results[test_name]["avg_frame_time_ms"] = avg_frame_time
	test_results[test_name]["min_frame_time_ms"] = min_frame_time
	test_results[test_name]["max_frame_time_ms"] = max_frame_time
	test_results[test_name]["p95_frame_time_ms"] = frame_times[p95_index]
	test_results[test_name]["p99_frame_time_ms"] = frame_times[p99_index]
	test_results[test_name]["avg_fps"] = 1000.0 / avg_frame_time if avg_frame_time > 0 else 0
	test_results[test_name]["target_met"] = avg_frame_time <= ACCEPTABLE_FRAME_TIME


func _calculate_overall_score() -> void:
	"""Calculate overall performance score"""
	var total_score = 0.0
	var test_count = 0

	# Scene loading score (0-25 points)
	if test_results.has("scene_loading") and test_results.scene_loading.has("target_met"):
		total_score += 25.0 if test_results.scene_loading.target_met else 12.5
		test_count += 1

	# Model rendering score (0-35 points)
	if test_results.has("model_rendering") and test_results.model_rendering.has("avg_fps"):
		var fps_score = clamp(test_results.model_rendering.avg_fps / TARGET_FPS, 0.0, 1.0)
		total_score += fps_score * 35.0
		test_count += 1

	# UI responsiveness score (0-25 points)
	if test_results.has("ui_responsiveness") and test_results.ui_responsiveness.has("avg_fps"):
		var fps_score = clamp(test_results.ui_responsiveness.avg_fps / TARGET_FPS, 0.0, 1.0)
		total_score += fps_score * 25.0
		test_count += 1

	# Memory usage score (0-15 points)
	if test_results.has("memory_usage") and test_results.memory_usage.has("potential_leak"):
		total_score += 15.0 if not test_results.memory_usage.potential_leak else 7.5
		test_count += 1

	test_results["overall_score"] = total_score
	test_results["grade"] = _get_grade(total_score)


func _get_grade(score: float) -> String:
	"""Convert score to letter grade"""
	if score >= 90:
		return "A"
	elif score >= 80:
		return "B"
	elif score >= 70:
		return "C"
	elif score >= 60:
		return "D"
	else:
		return "F"


func _print_results() -> void:
	"""Print test results"""
	print("\n=== PERFORMANCE BASELINE RESULTS ===\n")

	# Scene Loading
	if test_results.has("scene_loading"):
		var sl = test_results.scene_loading
		print("Scene Loading:")
		print("  Load Time: %.1fms" % sl.get("load_time_ms", 0))
		print("  Instance Time: %.1fms" % sl.get("instance_time_ms", 0))
		print("  Total Time: %.1fms" % sl.get("total_time_ms", 0))
		print("  Target Met: %s\n" % str(sl.get("target_met", false)))

	# Model Rendering
	if test_results.has("model_rendering"):
		var mr = test_results.model_rendering
		print("Model Rendering:")
		print("  Average FPS: %.1f" % mr.get("avg_fps", 0))
		print("  Average Frame Time: %.2fms" % mr.get("avg_frame_time_ms", 0))
		print("  95th Percentile: %.2fms" % mr.get("p95_frame_time_ms", 0))
		print("  99th Percentile: %.2fms" % mr.get("p99_frame_time_ms", 0))
		print("  Target Met: %s\n" % str(mr.get("target_met", false)))

	# UI Responsiveness
	if test_results.has("ui_responsiveness"):
		var ui = test_results.ui_responsiveness
		print("UI Responsiveness:")
		print("  Average FPS: %.1f" % ui.get("avg_fps", 0))
		print("  Average Frame Time: %.2fms" % ui.get("avg_frame_time_ms", 0))
		print("  Target Met: %s\n" % str(ui.get("target_met", false)))

	# Memory Usage
	if test_results.has("memory_usage"):
		var mem = test_results.memory_usage
		print("Memory Usage:")
		print("  Initial: %.1fMB" % mem.get("initial_dynamic_mb", 0))
		print("  Peak: %.1fMB" % mem.get("peak_dynamic_mb", 0))
		print("  Final: %.1fMB" % mem.get("final_dynamic_mb", 0))
		print("  Potential Leak: %s\n" % str(mem.get("potential_leak", false)))

	# Overall Score
	print("=== OVERALL PERFORMANCE ===")
	print("Score: %.1f/100" % test_results.get("overall_score", 0))
	print("Grade: %s" % test_results.get("grade", "N/A"))

	if test_results.overall_score >= 60:
		print("✅ Performance baseline ACCEPTABLE for educational use")
	else:
		print("❌ Performance needs optimization before release")


func _save_results() -> void:
	"""Save results to file"""
	var file = FileAccess.open("user://performance_baseline.json", FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(test_results, "\t")
		file.store_string(json_string)
		file.close()
		print("\nResults saved to: user://performance_baseline.json")
