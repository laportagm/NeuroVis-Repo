## run_rendering_benchmark.gd
## Helper script to run the rendering benchmark tool for NeuroVis
##
## This script attaches to the main scene and runs the rendering benchmark
## to establish baseline performance metrics before optimization.

extends Node

# Reference to the benchmark tool

@export var auto_run: bool = true
@export var test_duration: float = 5.0
@export var save_path: String = "user://baseline_benchmark_results.json"


var benchmark_tool: RenderingBenchmark

# Benchmark configuration
var summary = results.summary

func _ready() -> void:
	print("RenderingBenchmark Runner: Initializing...")

	# Create benchmark tool
	benchmark_tool = RenderingBenchmark.new()
	benchmark_tool.test_duration = test_duration
	benchmark_tool.results_save_path = save_path
	add_child(benchmark_tool)

	# Connect signals
	benchmark_tool.benchmark_progress.connect(_on_benchmark_progress)
	benchmark_tool.test_completed.connect(_on_test_completed)
	benchmark_tool.benchmark_completed.connect(_on_benchmark_completed)

	# Add a slight delay before starting benchmark
	if auto_run:
		print("RenderingBenchmark Runner: Starting benchmark in 2 seconds...")
		await get_tree().create_timer(2.0).timeout
		start_benchmark()


func start_benchmark() -> void:
	print("RenderingBenchmark Runner: Starting full benchmark...")
	benchmark_tool.start_full_benchmark()


if summary.has("average_fps"):
	print("  Average FPS: %.2f" % summary.average_fps)

	if summary.has("model_loading_time"):
		print("  Model Loading Time: %.2f seconds" % summary.model_loading_time)

		if summary.has("peak_memory_mb"):
			print("  Peak Memory Usage: %.2f MB" % summary.peak_memory_mb)

			if summary.has("selection_response_time"):
				print("  Selection Response Time: %.2f ms" % (summary.selection_response_time * 1000))

				print("\nResults saved to: " + benchmark_tool.results_save_path)

				# Optional: Add to scene tree to visualize results
				# var results_display = ResultsDisplay.new()
				# results_display.display_results(results)
				# add_child(results_display)

func _on_benchmark_progress(progress: float, message: String) -> void:
	print("RenderingBenchmark Runner: Progress %.1f%% - %s" % [progress * 100, message])


func _on_test_completed(test_name: String, test_result: Dictionary) -> void:
	print("RenderingBenchmark Runner: Test completed - " + test_name)

	# Display some key metrics from this test
	match test_name:
		"idle_fps":
			if test_result.has("average_fps"):
				print("  Average FPS: %.2f" % test_result.average_fps)
				if test_result.has("min_fps"):
					print("  Min FPS: %.2f" % test_result.min_fps)
					if test_result.has("max_fps"):
						print("  Max FPS: %.2f" % test_result.max_fps)
						"model_loading":
							if test_result.has("average_load_time"):
								print("  Average Load Time: %.2f seconds" % test_result.average_load_time)
								if test_result.has("memory_increase"):
									print("  Memory Increase: %.2f MB" % test_result.memory_increase)
									"memory_usage":
										if test_result.has("peak_memory_mb"):
											print("  Peak Memory: %.2f MB" % test_result.peak_memory_mb)
											if test_result.has("average_memory_mb"):
												print("  Average Memory: %.2f MB" % test_result.average_memory_mb)


func _on_benchmark_completed(results: Dictionary) -> void:
	print("RenderingBenchmark Runner: Benchmark completed!")

	# Display summary
	print("\nBenchmark Summary:")
