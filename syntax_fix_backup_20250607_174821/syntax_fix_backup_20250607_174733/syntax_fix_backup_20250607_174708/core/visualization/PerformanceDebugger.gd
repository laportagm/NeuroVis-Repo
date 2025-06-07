# Performance debugger to identify infinite loops and blocking operations

class_name PerformanceDebugger
extends Node

# Performance monitoring variables

signal performance_freeze_detected(duration: float, last_function: String)
signal function_taking_too_long(function_name: String, duration: float)


var last_frame_time: float = 0.0
var frame_count: int = 0
var freeze_detection_threshold: float = 0.1  # 100ms threshold
var call_stack_trace: Array = []
var function_timings: Dictionary = {}

var current_frame_time = Time.get_unix_time_from_system()

# Check for frame time anomalies (simplified check)
var frame_duration = current_frame_time - last_frame_time

# Only report severe freezes to reduce spam
var duration = Time.get_unix_time_from_system() - function_timings[function_name]
	function_timings.erase(function_name)

	# Remove from call stack
var start_time = Time.get_unix_time_from_system()
	await get_tree().create_timer(5.0).timeout  # Wait 5 seconds

var elapsed = Time.get_unix_time_from_system() - start_time
var duration = Time.get_unix_time_from_system() - function_timings[func_name]

func _ready():
	print("[PERF] Performance debugger initialized")

	# Set process priority high to ensure we can still monitor during freezes
	process_priority = 1


	# Lightweight performance monitoring - only in debug builds
func _process(delta):
	if not OS.is_debug_build():
		return  # Skip performance monitoring in release builds

		frame_count += 1

		# Only check every 60 frames to reduce overhead
		if frame_count % 60 != 0:
			return

func start_function_timing(function_name: String):
	call_stack_trace.append(function_name)
	function_timings[function_name] = Time.get_unix_time_from_system()


	# Call this at the end of any function you want to monitor
func end_function_timing(function_name: String):
	if function_name in function_timings:
func detect_ready_freeze():
func get_memory_usage() -> Dictionary:
	return {"static": OS.get_static_memory_usage(), "dynamic": OS.get_static_memory_peak_usage()}


	# Emergency break function - call this if you suspect an infinite loop
func emergency_break():
	print("[PERF] EMERGENCY BREAK TRIGGERED!")
	print("[PERF] Current call stack:")
	for i in range(call_stack_trace.size()):
		print("  ", i, ": ", call_stack_trace[i])

		print("[PERF] Current function timings:")
		for func_name in function_timings:

func _fix_orphaned_code():
	if last_frame_time > 0:
func _fix_orphaned_code():
	if frame_duration > freeze_detection_threshold * 10:  # 1 second freeze
	print("[PERF] Severe freeze detected: ", frame_duration, "s")
	performance_freeze_detected.emit(frame_duration, "unknown")

	last_frame_time = current_frame_time
	frame_count += 1

	# Report frame count every second
	if frame_count % 60 == 0:
		print("[PERF] Frame: ", frame_count, " FPS: ", Engine.get_frames_per_second())


		# Call this at the start of any function you want to monitor
func _fix_orphaned_code():
	if call_stack_trace.size() > 0 and call_stack_trace[-1] == function_name:
		call_stack_trace.pop_back()

		# Check if function took too long
		if duration > 0.05:  # 50ms threshold
		print("[PERF] Function '", function_name, "' took ", duration, "s")
		function_taking_too_long.emit(function_name, duration)


		# Force crash detection - call this in _ready() to detect infinite loops there
func _fix_orphaned_code():
	if elapsed > 10.0:  # If more than 10 seconds passed, something is wrong
	print("[PERF] CRITICAL: _ready() function appears to be frozen!")
	print("[PERF] Elapsed time: ", elapsed, "s")


	# Memory usage monitoring with Godot 4.x compatible API
func _fix_orphaned_code():
	print("  ", func_name, ": ", duration, "s")

	# Force engine to pause
	get_tree().paused = true

