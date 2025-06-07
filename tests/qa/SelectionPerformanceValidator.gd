## SelectionPerformanceValidator.gd
## Performance validation for enhanced selection system
##
## Measures frame rate, selection response time, and memory usage
## to ensure the enhanced selection system maintains 60 FPS performance.
##
## @tutorial: Performance testing for educational applications
## @version: 1.0

class_name SelectionPerformanceValidator
extends Node

# === CONSTANTS ===

signal test_started
signal test_progress(percentage: float)
signal test_completed(results: Dictionary)


# === PUBLIC METHODS ===
## Initialize the performance validator

const TARGET_FPS: float = 60.0
const MAX_SELECTION_TIME_MS: float = 16.67  # One frame at 60 FPS
const TEST_DURATION_SECONDS: float = 10.0
const SAMPLES_PER_SECOND: int = 10

# === PRIVATE VARIABLES ===

var elapsed = (Time.get_ticks_msec() - _test_start_time) / 1000.0
var fps = 1.0 / delta if delta > 0 else 60.0
_frame_times.append(fps)

# Check for FPS drops
var elapsed_2 = (Time.get_ticks_msec() - _test_start_time) / 1000.0
var current_memory = OS.get_static_memory_usage()
_memory_samples.append(current_memory)
_results["memory_peak"] = max(_results["memory_peak"], current_memory)

# Update progress
var progress = get_test_progress()
test_progress.emit(progress)

# Check if test is complete
var viewport_size = _main_scene.get_viewport().get_visible_rect().size
var test_positions = [
viewport_size * 0.5,  # Center
viewport_size * Vector2(0.25, 0.25),  # Top-left
viewport_size * Vector2(0.75, 0.25),  # Top-right
viewport_size * Vector2(0.25, 0.75),  # Bottom-left
viewport_size * Vector2(0.75, 0.75),  # Bottom-right
]

# Test selections at different positions
var pos = test_positions[i % test_positions.size()]
await _test_selection_at_position(pos)
await _main_scene.get_tree().create_timer(0.5).timeout


var start_time = Time.get_ticks_usec()

# Perform selection
var elapsed_us = Time.get_ticks_usec() - start_time
var elapsed_ms = elapsed_us / 1000.0
_selection_times.append(elapsed_ms)

# Also test hover for completeness
await _main_scene.get_tree().create_timer(0.1).timeout

var hover_positions = [
position + Vector2(10, 0),
position + Vector2(-10, 0),
position + Vector2(0, 10),
position + Vector2(0, -10),
]

var sum = 0.0
var report = (
"""# Selection System Performance Validation Report
Generated: %s

## Test Summary
- **Duration**: %.1f seconds
- **Performance Target**: 60 FPS
- **Selection Target**: <16.67ms per selection

## Frame Rate Performance
- **Average FPS**: %.1f
- **Minimum FPS**: %.1f
- **Maximum FPS**: %.1f
- **FPS Drops**: %d (below 54 FPS)
- **Performance**: %s

## Selection Response Time
- **Average Time**: %.2f ms
- **Maximum Time**: %.2f ms
- **Performance**: %s

## Memory Usage
- **Start**: %.2f MB
- **Peak**: %.2f MB
- **End**: %.2f MB
- **Memory Delta**: %.2f MB

## Validation Results
"""
% [
Time.get_datetime_string_from_system(),
_results["test_duration"],
_results["avg_fps"],
_results["min_fps"],
_results["max_fps"],
_results["fps_drops"],
"✅ PASS" if _results["avg_fps"] >= TARGET_FPS * 0.95 else "❌ FAIL",
_results["avg_selection_time"],
_results["max_selection_time"],
"✅ PASS" if _results["avg_selection_time"] < MAX_SELECTION_TIME_MS else "❌ FAIL",
_results["memory_start"] / 1048576.0,
_results["memory_peak"] / 1048576.0,
_results["memory_end"] / 1048576.0,
(_results["memory_end"] - _results["memory_start"]) / 1048576.0
]
)

# Overall validation
var fps_pass = _results["avg_fps"] >= TARGET_FPS * 0.95
var selection_pass = _results["avg_selection_time"] < MAX_SELECTION_TIME_MS
var memory_pass = (_results["memory_end"] - _results["memory_start"]) < 50 * 1048576  # 50MB limit

var timestamp = Time.get_datetime_string_from_system().replace(" ", "_").replace(":", "-")
var file_path = "user://selection_performance_%s.md" % timestamp

var file = FileAccess.open(file_path, FileAccess.WRITE)
var project_path = "res://test_reports/selection_performance_%s.md" % timestamp
var project_file = FileAccess.open(project_path, FileAccess.WRITE)

var _is_testing: bool = false
var _test_start_time: int = 0
var _frame_times: Array[float] = []
var _selection_times: Array[float] = []
var _memory_samples: Array[int] = []
var _main_scene: Node3D
var _selection_manager: Node

# Test results
var _results: Dictionary = {
"avg_fps": 0.0,
"min_fps": 0.0,
"max_fps": 0.0,
"fps_drops": 0,
"avg_selection_time": 0.0,
"max_selection_time": 0.0,
"memory_start": 0,
"memory_peak": 0,
"memory_end": 0,
"test_duration": 0.0
}

# === SIGNALS ===

func _process(delta: float) -> void:
	"""Process frame timing during test"""
	if not _is_testing:
		return

		# Record frame time

func initialize(main_scene: Node3D, selection_manager: Node) -> bool:
	"""Initialize performance validation system"""
	if not main_scene or not selection_manager:
		push_error("[PerfValidator] Missing required components")
		return false

		_main_scene = main_scene
		_selection_manager = selection_manager

		set_process(false)  # Will enable during testing

		print("[PerfValidator] Initialized successfully")
		return true


		## Start performance validation test
func start_validation_test() -> void:
	"""Begin performance validation testing"""
	if _is_testing:
		push_warning("[PerfValidator] Test already in progress")
		return

		print("[PerfValidator] Starting performance validation test")
		_is_testing = true
		_test_start_time = Time.get_ticks_msec()

		# Clear previous data
		_frame_times.clear()
		_selection_times.clear()
		_memory_samples.clear()

		# Record initial memory
		_results["memory_start"] = OS.get_static_memory_usage()

		# Start processing
		set_process(true)
		test_started.emit()

		# Start test sequence
		_run_test_sequence()


		## Stop the validation test
func stop_test() -> void:
	"""Stop the current test"""
	if not _is_testing:
		return

		_complete_test()


		## Get current test progress
func get_test_progress() -> float:
	"""Get test progress as percentage"""
	if not _is_testing:
		return 0.0

func _fix_orphaned_code():
	return min(elapsed / TEST_DURATION_SECONDS * 100.0, 100.0)


	# === PRIVATE METHODS ===
func _fix_orphaned_code():
	if fps < TARGET_FPS * 0.9:  # 10% tolerance
	_results["fps_drops"] += 1

	# Sample memory periodically
func _fix_orphaned_code():
	if int(elapsed * SAMPLES_PER_SECOND) > _memory_samples.size():
func _fix_orphaned_code():
	if elapsed >= TEST_DURATION_SECONDS:
		_complete_test()


func _fix_orphaned_code():
	for i in range(int(TEST_DURATION_SECONDS * 2)):  # 2 selections per second
	if not _is_testing:
		break

func _fix_orphaned_code():
	if _selection_manager.has_method("handle_selection_at_position"):
		_selection_manager.handle_selection_at_position(position)

		# Measure time
func _fix_orphaned_code():
	if _selection_manager.has_method("handle_hover_at_position"):
func _fix_orphaned_code():
	for hover_pos in hover_positions:
		_selection_manager.handle_hover_at_position(hover_pos)
		await _main_scene.get_tree().create_timer(0.05).timeout


func _fix_orphaned_code():
	for value in values:
		sum += value

		return sum / values.size()


func _fix_orphaned_code():
	if fps_pass and selection_pass and memory_pass:
		report += "### ✅ ALL PERFORMANCE TARGETS MET\n"
		report += "The enhanced selection system maintains target performance.\n"
		else:
			report += "### ⚠️ PERFORMANCE ISSUES DETECTED\n"
			if not fps_pass:
				report += (
				"- Frame rate below target (%.1f < %.1f FPS)\n" % [_results["avg_fps"], TARGET_FPS]
				)
				if not selection_pass:
					report += (
					"- Selection response time too high (%.2fms > %.2fms)\n"
					% [_results["avg_selection_time"], MAX_SELECTION_TIME_MS]
					)
					if not memory_pass:
						report += (
						"- Excessive memory usage (%.1f MB increase)\n"
						% ((_results["memory_end"] - _results["memory_start"]) / 1048576.0)
						)

						# Recommendations
						report += "\n## Recommendations\n"

						if _results["fps_drops"] > 5:
							report += "- Consider reducing multi-ray sample count for better performance\n"

							if _results["max_selection_time"] > 20.0:
								report += "- Optimize structure size calculations or implement caching\n"

								if _results["avg_selection_time"] > 10.0:
									report += "- Consider spatial partitioning for ray queries\n"

									# Save report
									_save_report(report)


func _fix_orphaned_code():
	if file:
		file.store_string(report_content)
		file.close()
		print("[PerfValidator] Report saved to: %s" % file_path)

		# Also save to project directory
func _fix_orphaned_code():
	if project_file:
		project_file.store_string(report_content)
		project_file.close()
		print("[PerfValidator] Report also saved to: %s" % project_path)

func _run_test_sequence() -> void:
	"""Run automated selection test sequence"""
	# Simulate rapid selections across screen
	_simulate_rapid_selections()


func _simulate_rapid_selections() -> void:
	"""Simulate rapid selection clicks to test performance"""
func _test_selection_at_position(position: Vector2) -> void:
	"""Test selection performance at a specific position"""
func _complete_test() -> void:
	"""Complete the test and calculate results"""
	_is_testing = false
	set_process(false)

	# Record final memory
	_results["memory_end"] = OS.get_static_memory_usage()
	_results["test_duration"] = (Time.get_ticks_msec() - _test_start_time) / 1000.0

	# Calculate FPS statistics
	if not _frame_times.is_empty():
		_results["avg_fps"] = _calculate_average(_frame_times)
		_results["min_fps"] = _frame_times.min()
		_results["max_fps"] = _frame_times.max()

		# Calculate selection time statistics
		if not _selection_times.is_empty():
			_results["avg_selection_time"] = _calculate_average(_selection_times)
			_results["max_selection_time"] = _selection_times.max()

			# Generate report
			_generate_performance_report()

			test_completed.emit(_results)


func _calculate_average(values: Array) -> float:
	"""Calculate average of an array"""
	if values.is_empty():
		return 0.0

func _generate_performance_report() -> void:
	"""Generate performance validation report"""
func _save_report(report_content: String) -> void:
	"""Save performance report to file"""
