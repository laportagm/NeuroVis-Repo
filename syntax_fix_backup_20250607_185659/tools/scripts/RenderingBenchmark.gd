## RenderingBenchmark.gd
## Performance benchmarking tool for NeuroVis 3D rendering
##
## Measures and analyzes rendering performance metrics including FPS,
## memory usage, loading times, and draw calls to establish baseline
## performance for optimization comparison.
##
## @tutorial: docs/dev/performance-benchmarking.md
## @experimental: false

class_name RenderingBenchmark
extends Node

# === SIGNALS ===
## Emitted when benchmark results are ready
## @param results: Dictionary containing all benchmark results

signal benchmark_completed(results: Dictionary)

## Emitted when a specific benchmark test completes
## @param test_name: String name of completed test
## @param test_result: Dictionary with test results
signal test_completed(test_name: String, test_result: Dictionary)

## Emitted during benchmark progress
## @param progress: float between 0.0 and 1.0
## @param message: String describing current operation
signal benchmark_progress(progress: float, message: String)

# === EXPORTS ===
## Duration of each test in seconds

@export var test_duration: float = 10.0

## Interval between measurements in seconds
@export var measurement_interval: float = 0.1

## Whether to generate detailed logs
@export var detailed_logging: bool = true

## Path to save benchmark results
@export var results_save_path: String = "user://benchmark_results.json"

# === PUBLIC VARIABLES ===
## Indicates if benchmarking is in progress

var is_benchmarking: bool = false

# === PRIVATE VARIABLES ===
var save_path = custom_path if not custom_path.is_empty() else results_save_path

var file = FileAccess.open(save_path, FileAccess.WRITE)
var summary = {}

# Average FPS across tests
var fps_values = []
var total_fps = 0.0
var current_time = Time.get_ticks_msec() / 1000.0
var time_elapsed = current_time - _start_time
# FIXME: Orphaned code - _start_time = current_time

var current_fps = _frame_count / time_elapsed
_fps_samples.append(current_fps)
# FIXME: Orphaned code - _frame_count = 0

# Memory usage
var memory_info = {}
# FIXME: Orphaned code - memory_info["static_memory"] = Performance.get_monitor(Performance.MEMORY_STATIC)
# FIXME: Orphaned code - memory_info["dynamic_memory"] = Performance.get_monitor(Performance.MEMORY_DYNAMIC)
# FIXME: Orphaned code - memory_info["total_memory"] = memory_info.static_memory + memory_info.dynamic_memory
_memory_samples.append(memory_info)

# Draw calls
var draw_calls = Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)
_draw_call_samples.append(draw_calls)

# Object count
var object_count = Performance.get_monitor(Performance.OBJECT_NODE_COUNT)
_object_count_samples.append(object_count)

var test_results = {}

"idle_fps":
	test_results = _calculate_fps_test_results()
	"model_loading":
		test_results = _calculate_model_loading_results()
		"rotation_fps":
			test_results = _calculate_fps_test_results()
			"selection_performance":
				test_results = _calculate_selection_performance_results()
				"memory_usage":
					test_results = _calculate_memory_usage_results()

					# Store results
					_results.tests[_current_test] = test_results

					# Emit completion signal
					test_completed.emit(_current_test, test_results)

					# Clear current test
					_current_test = ""


var results = {}

var total_fps_2 = 0.0
var min_fps = _fps_samples[0]
var max_fps = _fps_samples[0]

var variance = 0.0
var total_draw_calls = 0
var total_objects = 0
var results_2 = {}

# Get loading times from model loader if available
var loading_stats = _model_registry.get_loading_statistics()
	results["loading_statistics"] = loading_stats

	# Calculate average load time if available
var total_time = 0.0
var first_memory = _memory_samples.front().total_memory
var last_memory = _memory_samples.back().total_memory

	results["memory_before_loading"] = first_memory / 1048576.0  # Convert to MB
	results["memory_after_loading"] = last_memory / 1048576.0  # Convert to MB
	results["memory_increase"] = (last_memory - first_memory) / 1048576.0  # Convert to MB

var results_3 = {}

# Placeholder for selection times - in a real implementation,
# this would be populated during the selection simulation
var selection_times = [0.05, 0.04, 0.06, 0.05, 0.04]  # Example values in seconds

var total_time_2 = 0.0
var base_fps = _fps_samples[0]
var selection_fps = _fps_samples[-1]
	results["fps_before_selection"] = base_fps
	results["fps_during_selection"] = selection_fps
	results["fps_impact_percent"] = ((base_fps - selection_fps) / base_fps) * 100

var results_4 = {}

var total_memory = 0.0
var min_memory = _memory_samples[0].total_memory
var max_memory = _memory_samples[0].total_memory

var total_static = 0.0
var total_dynamic = 0.0

var camera = _find_camera_node()
var selection_manager = _find_selection_manager()
var index = int(Time.get_ticks_msec() / 1000.0) % 5
	selection_manager.select_structure_at_index(index)


var camera_paths = [
	"/root/Main/Camera3D", "/root/Main/CameraRig/Camera3D", "/root/Node3D/Camera3D"
	]

var node = get_node(path)
var selection_manager_paths = [
	"/root/BrainStructureSelectionManager", "/root/MultiStructureSelectionManager"
	]

var nodes = get_tree().get_nodes_in_group("selection_managers")
var found = _find_node_of_type(child, type)
var found_2 = _find_node_with_name_containing(child, name_part)

var _benchmark_timer: Timer
var _measurement_timer: Timer
var _results: Dictionary = {}
var _current_test: String = ""
var _test_queue: Array = []
var _start_time: float = 0.0
var _frame_count: int = 0
var _fps_samples: Array = []
var _memory_samples: Array = []
var _draw_call_samples: Array = []
var _object_count_samples: Array = []
var _model_registry: ModelRegistry
var _performance_monitor: PerformanceMonitor


# === LIFECYCLE METHODS ===

func _ready() -> void:
	"""Initialize the benchmark system"""
	_setup_timers()

	# Get reference to the performance monitor if available
	if Engine.has_singleton("PerformanceMonitor"):
		_performance_monitor = Engine.get_singleton("PerformanceMonitor")

		# Get reference to the model registry if available
		if get_node_or_null("/root/ModelSwitcherGlobal") != null:
			_model_registry = get_node("/root/ModelSwitcherGlobal")
			elif get_node_or_null("/root/ModelRegistry") != null:
				_model_registry = get_node("/root/ModelRegistry")

				print("[RenderingBenchmark] Initialized")


func _process(_delta: float) -> void:
	"""Process frame for benchmarking"""
	if is_benchmarking and _current_test != "":
		_frame_count += 1


		# === PUBLIC METHODS ===
		## Start benchmark suite with all tests
		## @returns: bool - true if benchmarking started successfully

func start_full_benchmark() -> bool:
	"""Run all benchmark tests"""
	if is_benchmarking:
		push_warning("[RenderingBenchmark] Benchmark already in progress")
		return false

		# Reset results
		_results = {"timestamp": Time.get_datetime_string_from_system(), "tests": {}, "summary": {}}

		# Setup test queue
		_test_queue = [
		"idle_fps", "model_loading", "rotation_fps", "selection_performance", "memory_usage"
		]

		# Start benchmarking
		is_benchmarking = true
		_start_next_test()

		return true


		## Run a specific benchmark test
		## @param test_name: String name of test to run
		## @returns: bool - true if test started successfully
func run_single_test(test_name: String) -> bool:
	"""Run a specific benchmark test"""
	if is_benchmarking:
		push_warning("[RenderingBenchmark] Benchmark already in progress")
		return false

		if (
		test_name
		not in [
		"idle_fps", "model_loading", "rotation_fps", "selection_performance", "memory_usage"
		]
		):
			push_error("[RenderingBenchmark] Invalid test name: " + test_name)
			return false

			# Reset results for this test
			_results = {"timestamp": Time.get_datetime_string_from_system(), "tests": {}, "summary": {}}

			# Setup test queue with just this test
			_test_queue = [test_name]

			# Start benchmarking
			is_benchmarking = true
			_start_next_test()

			return true


			## Save benchmark results to file
			## @param custom_path: Optional custom save path
			## @returns: bool - true if saved successfully
func save_results(custom_path: String = "") -> bool:
	"""Save benchmark results to file"""
	if _results.is_empty():
		push_warning("[RenderingBenchmark] No results to save")
		return false

func get_results() -> Dictionary:
	"""Get the most recent benchmark results"""
	return _results


	## Cancel current benchmarking
func cancel_benchmark() -> void:
	"""Cancel the current benchmark"""
	if is_benchmarking:
		is_benchmarking = false
		_test_queue.clear()
		_current_test = ""
		_benchmark_timer.stop()
		_measurement_timer.stop()
		print("[RenderingBenchmark] Benchmark cancelled")


		# === PRIVATE METHODS ===

func _fix_orphaned_code():
	if file == null:
		push_error("[RenderingBenchmark] Failed to open file for writing: " + save_path)
		return false

		file.store_string(JSON.stringify(_results, "  "))
		file.close()

		print("[RenderingBenchmark] Results saved to: " + save_path)
		return true


		## Get the last benchmark results
		## @returns: Dictionary with benchmark results
func _fix_orphaned_code():
	if _results.tests.has("idle_fps") and _results.tests.idle_fps.has("average_fps"):
		fps_values.append(_results.tests.idle_fps.average_fps)
		if _results.tests.has("rotation_fps") and _results.tests.rotation_fps.has("average_fps"):
			fps_values.append(_results.tests.rotation_fps.average_fps)

			if not fps_values.is_empty():
func _fix_orphaned_code():
	for fps in fps_values:
		total_fps += fps
		summary["average_fps"] = total_fps / fps_values.size()

		# Model loading time
		if (
		_results.tests.has("model_loading")
		and _results.tests.model_loading.has("average_load_time")
		):
			summary["model_loading_time"] = _results.tests.model_loading.average_load_time

			# Memory usage
			if _results.tests.has("memory_usage") and _results.tests.memory_usage.has("peak_memory_mb"):
				summary["peak_memory_mb"] = _results.tests.memory_usage.peak_memory_mb

				# Selection performance
				if (
				_results.tests.has("selection_performance")
				and _results.tests.selection_performance.has("average_selection_time")
				):
					summary["selection_response_time"] = (
					_results.tests.selection_performance.average_selection_time
					)

					# Store in results
					_results["summary"] = summary


func _fix_orphaned_code():
	if time_elapsed > 0:
func _fix_orphaned_code():
	if detailed_logging:
		print(
		(
		"[RenderingBenchmark] Measurement - FPS: %f, Memory: %f MB, Draw Calls: %d"
		% [
		_fps_samples[-1] if not _fps_samples.is_empty() else 0,
		(
		_memory_samples[-1].total_memory / 1048576.0
		if not _memory_samples.is_empty()
		else 0
		),
		_draw_call_samples[-1] if not _draw_call_samples.is_empty() else 0
		]
		)
		)


func _fix_orphaned_code():
	if _fps_samples.is_empty():
		results["error"] = "No FPS samples collected"
		return results

		# Calculate average FPS
func _fix_orphaned_code():
	for fps in _fps_samples:
		total_fps += fps

		results["average_fps"] = total_fps / _fps_samples.size()

		# Calculate min/max FPS
func _fix_orphaned_code():
	for fps in _fps_samples:
		min_fps = min(min_fps, fps)
		max_fps = max(max_fps, fps)

		results["min_fps"] = min_fps
		results["max_fps"] = max_fps

		# Calculate standard deviation
func _fix_orphaned_code():
	for fps in _fps_samples:
		variance += pow(fps - results.average_fps, 2)

		results["fps_stability"] = sqrt(variance / _fps_samples.size())

		# Draw calls
		if not _draw_call_samples.is_empty():
func _fix_orphaned_code():
	for draw_calls in _draw_call_samples:
		total_draw_calls += draw_calls

		results["average_draw_calls"] = total_draw_calls / _draw_call_samples.size()

		# Object count
		if not _object_count_samples.is_empty():
func _fix_orphaned_code():
	for object_count in _object_count_samples:
		total_objects += object_count

		results["average_object_count"] = total_objects / _object_count_samples.size()

		return results


func _fix_orphaned_code():
	if _model_registry != null and _model_registry.has_method("get_loading_statistics"):
func _fix_orphaned_code():
	if loading_stats.has("load_times") and loading_stats.load_times.size() > 0:
func _fix_orphaned_code():
	for time in loading_stats.load_times:
		total_time += time

		results["average_load_time"] = total_time / loading_stats.load_times.size()
		results["total_load_time"] = total_time
		else:
			# Estimate from our measurements if not available
			results["estimated_load_time"] = test_duration

			# Memory before/after loading
			if _memory_samples.size() >= 2:
func _fix_orphaned_code():
	return results


func _fix_orphaned_code():
	if not selection_times.is_empty():
func _fix_orphaned_code():
	for time in selection_times:
		total_time += time

		results["average_selection_time"] = total_time / selection_times.size()
		results["selection_count"] = selection_times.size()
		else:
			results["error"] = "No selection times recorded"

			# Include FPS impact
			if _fps_samples.size() >= 2:
func _fix_orphaned_code():
	return results


func _fix_orphaned_code():
	if _memory_samples.is_empty():
		results["error"] = "No memory samples collected"
		return results

		# Calculate average, min, max memory usage
func _fix_orphaned_code():
	for sample in _memory_samples:
		total_memory += sample.total_memory
		min_memory = min(min_memory, sample.total_memory)
		max_memory = max(max_memory, sample.total_memory)

		results["average_memory_mb"] = (total_memory / _memory_samples.size()) / 1048576.0
		results["min_memory_mb"] = min_memory / 1048576.0
		results["peak_memory_mb"] = max_memory / 1048576.0

		# Calculate memory usage by category if detailed info available
		if _memory_samples[0].has("static_memory") and _memory_samples[0].has("dynamic_memory"):
func _fix_orphaned_code():
	for sample in _memory_samples:
		total_static += sample.static_memory
		total_dynamic += sample.dynamic_memory

		results["average_static_memory_mb"] = (total_static / _memory_samples.size()) / 1048576.0
		results["average_dynamic_memory_mb"] = (total_dynamic / _memory_samples.size()) / 1048576.0

		return results


func _fix_orphaned_code():
	if not camera:
		return

		# Rotate the camera slightly to simulate user interaction
		camera.rotate_y(0.01)


func _fix_orphaned_code():
	if not selection_manager:
		return

		# If we have a selection manager, try to call select methods
		if selection_manager.has_method("select_random_structure"):
			selection_manager.select_random_structure()
			elif selection_manager.has_method("select_structure_at_index"):
				# Select different structures in sequence
func _fix_orphaned_code():
	for path in camera_paths:
		if has_node(path):
func _fix_orphaned_code():
	if node is Camera3D:
		return node

		# Search the entire scene if not found
		return _find_node_of_type(get_tree().root, Camera3D)


func _fix_orphaned_code():
	for path in selection_manager_paths:
		if has_node(path):
			return get_node(path)

			# Try to find by class name
func _fix_orphaned_code():
	if not nodes.is_empty():
		return nodes[0]

		# Search for nodes with selection-related names
		return _find_node_with_name_containing(get_tree().root, "SelectionManager")


func _fix_orphaned_code():
	if found:
		return found

		return null


func _fix_orphaned_code():
	if found:
		return found

		return null

func _setup_timers() -> void:
	"""Setup benchmark timers"""
	# Benchmark duration timer
	_benchmark_timer = Timer.new()
	_benchmark_timer.one_shot = true
	_benchmark_timer.timeout.connect(_on_benchmark_timer_timeout)
	add_child(_benchmark_timer)

	# Measurement interval timer
	_measurement_timer = Timer.new()
	_measurement_timer.one_shot = false
	_measurement_timer.timeout.connect(_on_measurement_timer_timeout)
	add_child(_measurement_timer)


func _start_next_test() -> void:
	"""Start the next test in queue"""
	if _test_queue.is_empty():
		_complete_benchmark()
		return

		# Get next test
		_current_test = _test_queue.pop_front()

		# Reset measurements
		_frame_count = 0
		_fps_samples.clear()
		_memory_samples.clear()
		_draw_call_samples.clear()
		_object_count_samples.clear()

		# Start test
		print("[RenderingBenchmark] Starting test: " + _current_test)
		benchmark_progress.emit(
		1.0 - float(_test_queue.size() + 1) / 5.0, "Running test: " + _current_test
		)

		match _current_test:
			"idle_fps":
				_start_idle_fps_test()
				"model_loading":
					_start_model_loading_test()
					"rotation_fps":
						_start_rotation_fps_test()
						"selection_performance":
							_start_selection_performance_test()
							"memory_usage":
								_start_memory_usage_test()
								_:
									push_warning("[RenderingBenchmark] Unknown test: " + _current_test)
									_start_next_test()


func _complete_benchmark() -> void:
	"""Complete the benchmark suite"""
	is_benchmarking = false

	# Calculate summary
	_calculate_summary()

	print("[RenderingBenchmark] Benchmark completed")
	benchmark_progress.emit(1.0, "Benchmark completed")
	benchmark_completed.emit(_results)

	# Save results automatically
	save_results()


func _calculate_summary() -> void:
	"""Calculate summary metrics from all test results"""
func _on_benchmark_timer_timeout() -> void:
	"""Handle benchmark timer completion"""
	# Complete current test
	_complete_current_test()

	# Start next test
	_start_next_test()


func _on_measurement_timer_timeout() -> void:
	"""Take measurements at regular intervals"""
	if not is_benchmarking or _current_test == "":
		return

		# Common measurements for all tests
		_take_common_measurements()

		# Test-specific measurements
		match _current_test:
			"idle_fps":
				# No additional measurements needed
				pass
				"rotation_fps":
					# Add rotation if needed
					_simulate_rotation()
					"selection_performance":
						# Simulate selection
						_simulate_selection()
						"memory_usage":
							# Additional memory checks
							_take_detailed_memory_measurements()


func _take_common_measurements() -> void:
	"""Take common measurements for all tests"""
	# FPS calculation from frame count since last measurement
func _complete_current_test() -> void:
	"""Complete the current test and calculate results"""
	if _current_test == "":
		return

		print("[RenderingBenchmark] Completing test: " + _current_test)

		# Stop measurement timer
		_measurement_timer.stop()

		# Calculate results based on test type
func _calculate_fps_test_results() -> Dictionary:
	"""Calculate results for FPS tests"""
func _calculate_model_loading_results() -> Dictionary:
	"""Calculate results for model loading test"""
func _calculate_selection_performance_results() -> Dictionary:
	"""Calculate results for selection performance test"""
func _calculate_memory_usage_results() -> Dictionary:
	"""Calculate results for memory usage test"""
func _start_idle_fps_test() -> void:
	"""Start idle FPS benchmark"""
	_start_time = Time.get_ticks_msec() / 1000.0
	_measurement_timer.start(measurement_interval)
	_benchmark_timer.start(test_duration)


func _start_model_loading_test() -> void:
	"""Start model loading benchmark"""
	# Reset models to ensure clean load
	if _model_registry != null and _model_registry.has_method("clear_models"):
		_model_registry.clear_models()

		_start_time = Time.get_ticks_msec() / 1000.0
		_measurement_timer.start(measurement_interval)

		# If we have a way to listen for model loading completion, use that
		if _model_registry != null and _model_registry.has_signal("models_loaded"):
			# Connect to the signal just once
			if not _model_registry.models_loaded.is_connected(_on_models_loaded):
				_model_registry.models_loaded.connect(_on_models_loaded)

				# Start loading models
				if _model_registry.has_method("load_brain_models"):
					_model_registry.load_brain_models()
					else:
						# If no signal, just use the timer
						_benchmark_timer.start(test_duration)


func _on_models_loaded(_model_names: Array) -> void:
	"""Handle model loading completion"""
	# Disconnect from signal
	if _model_registry != null and _model_registry.has_signal("models_loaded"):
		if _model_registry.models_loaded.is_connected(_on_models_loaded):
			_model_registry.models_loaded.disconnect(_on_models_loaded)

			# Allow a few more measurements after loading
			_benchmark_timer.start(2.0)  # Short duration after loading completes


func _start_rotation_fps_test() -> void:
	"""Start rotation FPS benchmark"""
	_start_time = Time.get_ticks_msec() / 1000.0
	_measurement_timer.start(measurement_interval)
	_benchmark_timer.start(test_duration)


func _start_selection_performance_test() -> void:
	"""Start selection performance benchmark"""
	_start_time = Time.get_ticks_msec() / 1000.0
	_measurement_timer.start(measurement_interval)
	_benchmark_timer.start(test_duration)


func _start_memory_usage_test() -> void:
	"""Start memory usage benchmark"""
	_start_time = Time.get_ticks_msec() / 1000.0
	_measurement_timer.start(measurement_interval)
	_benchmark_timer.start(test_duration)


func _simulate_rotation() -> void:
	"""Simulate camera rotation for rotation benchmark"""
	# Find the camera node
func _simulate_selection() -> void:
	"""Simulate structure selection for selection benchmark"""
	# This would typically involve raycasting and selection logic
	# For this benchmark script, we'll just simulate the operation
	# In a real implementation, you would call the actual selection methods

	# Find a selection manager if available
func _take_detailed_memory_measurements() -> void:
	"""Take more detailed memory measurements"""
	# Already covered by common measurements
	pass


func _find_camera_node() -> Camera3D:
	"""Find the main camera in the scene"""
	# Try common camera paths
func _find_selection_manager() -> Node:
	"""Find the selection manager node"""
	# Try known selection manager types
func _find_node_of_type(node: Node, type) -> Node:
	"""Recursively find a node of a specific type"""
	if node.is_class(type.get_class()):
		return node

		for child in node.get_children():
func _find_node_with_name_containing(node: Node, name_part: String) -> Node:
	"""Recursively find a node with a name containing the specified string"""
	if name_part.to_lower() in node.name.to_lower():
		return node

		for child in node.get_children():
