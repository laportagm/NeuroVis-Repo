extends SceneTree

class_name BenchmarkRunner

var benchmark_results = {}
var start_time = 0


var kb_start = Time.get_ticks_msec()
var kb_load_count = 100

var file = FileAccess.open("res://assets/data/anatomical_data.json", FileAccess.READ)
var json_string = file.get_as_text()
var json = JSON.new()
	json.parse(json_string)
	file.close()

var kb_duration = Time.get_ticks_msec() - kb_start
var kb_avg = float(kb_duration) / float(kb_load_count)

	benchmark_results["data_kb_loading_avg_ms"] = kb_avg
var json_start = Time.get_ticks_msec()
var json_test_data = '{"test": "data", "array": [1, 2, 3, 4, 5], "nested": {"value": 42}}'
var json_iterations = 10000

var json = JSON.new()
	json.parse(json_test_data)

var json_duration = Time.get_ticks_msec() - json_start
var json_avg = float(json_duration) / float(json_iterations)

	benchmark_results["data_json_parsing_avg_ms"] = json_avg
var model_paths = [
	"res://assets/models/Half_Brain.glb",
	"res://assets/models/Internal_Structures.glb",
	"res://assets/models/Brainstem(Solid).glb"
	]

var total_load_time = 0
var loaded_models = 0

var load_start = Time.get_ticks_msec()
var scene = load(model_path)
var instance = scene.instantiate()
var load_time = Time.get_ticks_msec() - load_start
	total_load_time += load_time
var avg_load_time = float(total_load_time) / float(loaded_models) if loaded_models > 0 else 0
	benchmark_results["rendering_avg_model_load_ms"] = avg_load_time
	benchmark_results["rendering_total_models_loaded"] = loaded_models

	# Simulate transform calculations
var transform_start = Time.get_ticks_msec()
var transform_iterations = 100000

var transform = Transform3D()
	transform = transform.rotated(Vector3.UP, randf() * PI)
	transform = transform.translated(Vector3(randf(), randf(), randf()))

var transform_duration = Time.get_ticks_msec() - transform_start
var transform_avg = float(transform_duration) / float(transform_iterations)

	benchmark_results["rendering_transform_calc_avg_ms"] = transform_avg
var memory_start = Time.get_ticks_msec()
var large_arrays = []
var array_count = 100
var array_size = 10000

var large_array = []
var memory_alloc_time = Time.get_ticks_msec() - memory_start

# Memory cleanup
var cleanup_start = Time.get_ticks_msec()
	large_arrays.clear()
var cleanup_time = Time.get_ticks_msec() - cleanup_start

	benchmark_results["memory_allocation_ms"] = memory_alloc_time
	benchmark_results["memory_cleanup_ms"] = cleanup_time
	benchmark_results["memory_objects_created"] = array_count * array_size

var fs_start = Time.get_ticks_msec()
var file_ops = 1000

var test_path = "res://assets/data/anatomical_data.json"
	DirAccess.dir_exists_absolute(test_path.get_base_dir())
	FileAccess.file_exists(test_path)

var fs_duration = Time.get_ticks_msec() - fs_start
var fs_avg = float(fs_duration) / float(file_ops)

	benchmark_results["system_file_ops_avg_ms"] = fs_avg
var string_start = Time.get_ticks_msec()
var string_ops = 50000
var test_strings = []

var test_str = "test_string_%d" % i
	test_str = test_str.to_upper()
	test_str = test_str.replace("_", "-")
	test_strings.append(test_str)

var string_duration = Time.get_ticks_msec() - string_start
var string_avg = float(string_duration) / float(string_ops)

	benchmark_results["system_string_ops_avg_ms"] = string_avg
var total_duration = Time.get_ticks_msec() - start_time

var file = FileAccess.open("benchmark-results.json", FileAccess.WRITE)
var summary_content = (
	"""# 📊 Performance Benchmark Results

	## Summary
	- **Total Duration:** %dms
	- **Platform:** %s
	- **Godot Version:** %s
	- **Timestamp:** %s

	## Key Metrics
	| Category | Metric | Value |
	|----------|--------|-------|
	| Data | Knowledge Base Loading | %.2fms avg |
	| Data | JSON Parsing | %.4fms avg |
	| Rendering | Model Loading | %.2fms avg |
	| Memory | Allocation | %dms |
	| System | File Operations | %.4fms avg |

	## Performance Status
	"""
	% [
	benchmark_results.get("meta_total_duration_ms", 0),
	benchmark_results.get("meta_platform", "Unknown"),
	str(benchmark_results.get("meta_godot_version", {})),
	benchmark_results.get("meta_timestamp", "Unknown"),
	benchmark_results.get("data_kb_loading_avg_ms", 0),
	benchmark_results.get("data_json_parsing_avg_ms", 0),
	benchmark_results.get("rendering_avg_model_load_ms", 0),
	benchmark_results.get("memory_allocation_ms", 0),
	benchmark_results.get("system_file_ops_avg_ms", 0)
	]
	)

	# Add performance status indicators
var kb_loading = benchmark_results.get("data_kb_loading_avg_ms", 0)
var file = FileAccess.open("performance-summary.md", FileAccess.WRITE)

func _init():
	print("📊 NeuroVis Performance Benchmark Runner Starting...")
	start_time = Time.get_ticks_msec()

	run_all_benchmarks()

	generate_benchmark_report()
	quit()


func run_all_benchmarks():
	print("🔍 Running performance benchmarks...")

	# Data processing benchmarks
	run_data_benchmarks()

	# Rendering benchmarks (simplified for headless)
	run_rendering_benchmarks()

	# Memory benchmarks
	run_memory_benchmarks()

	# System benchmarks
	run_system_benchmarks()


func run_data_benchmarks():
	print("📊 Data Processing Benchmarks")
	print("==========================================")

	# Knowledge base loading benchmark
func run_rendering_benchmarks():
	print("\n🎨 Rendering Benchmarks (Headless Mode)")
	print("==========================================")

	# Simulate model loading time
func run_memory_benchmarks():
	print("\n💾 Memory Benchmarks")
	print("==========================================")

	# Memory allocation benchmark
func run_system_benchmarks():
	print("\n⚙️  System Benchmarks")
	print("==========================================")

	# File system operations
func generate_benchmark_report():
func generate_performance_summary():

func _fix_orphaned_code():
	for i in range(kb_load_count):
func _fix_orphaned_code():
	if file:
func _fix_orphaned_code():
	print("  Knowledge Base Loading: %.2fms avg (%d iterations)" % [kb_avg, kb_load_count])

	# JSON parsing benchmark
func _fix_orphaned_code():
	for i in range(json_iterations):
func _fix_orphaned_code():
	print("  JSON Parsing: %.4fms avg (%d iterations)" % [json_avg, json_iterations])


func _fix_orphaned_code():
	for model_path in model_paths:
func _fix_orphaned_code():
	if scene:
func _fix_orphaned_code():
	if instance:
		instance.queue_free()
		loaded_models += 1
func _fix_orphaned_code():
	print("  Model Load (%s): %dms" % [model_path.get_file(), load_time])

func _fix_orphaned_code():
	for i in range(transform_iterations):
func _fix_orphaned_code():
	print(
	(
	"  Transform Calculations: %.6fms avg (%d iterations)"
	% [transform_avg, transform_iterations]
	)
	)


func _fix_orphaned_code():
	for i in range(array_count):
func _fix_orphaned_code():
	for j in range(array_size):
		large_array.append(Vector3(randf(), randf(), randf()))
		large_arrays.append(large_array)

func _fix_orphaned_code():
	print(
	(
	"  Large Object Allocation: %dms (%d objects)"
	% [memory_alloc_time, array_count * array_size]
	)
	)
	print("  Memory Cleanup: %dms" % cleanup_time)


func _fix_orphaned_code():
	for i in range(file_ops):
func _fix_orphaned_code():
	print("  File System Operations: %.4fms avg (%d operations)" % [fs_avg, file_ops])

	# String operations
func _fix_orphaned_code():
	for i in range(string_ops):
func _fix_orphaned_code():
	print("  String Operations: %.6fms avg (%d operations)" % [string_avg, string_ops])


func _fix_orphaned_code():
	print("\n📈 Benchmark Summary")
	print("==================================================")
	print("Total Benchmark Duration: %dms" % total_duration)
	print("Godot Version: %s" % Engine.get_version_info())
	print("Platform: %s" % OS.get_name())

	# Add metadata
	benchmark_results["meta_total_duration_ms"] = total_duration
	benchmark_results["meta_timestamp"] = Time.get_datetime_string_from_system()
	benchmark_results["meta_godot_version"] = Engine.get_version_info()
	benchmark_results["meta_platform"] = OS.get_name()

	# Save results to JSON
func _fix_orphaned_code():
	if file:
		file.store_string(JSON.stringify(benchmark_results, "\t"))
		file.close()
		print("📄 Saved: benchmark-results.json")

		# Generate performance summary for CI
		generate_performance_summary()


func _fix_orphaned_code():
	if kb_loading < 10:
		summary_content += "✅ Knowledge Base Loading: Excellent (< 10ms)\n"
		elif kb_loading < 50:
			summary_content += "⚠️ Knowledge Base Loading: Good (< 50ms)\n"
			else:
				summary_content += "❌ Knowledge Base Loading: Needs Improvement (> 50ms)\n"

func _fix_orphaned_code():
	if file:
		file.store_string(summary_content)
		file.close()
		print("📄 Generated: performance-summary.md")
