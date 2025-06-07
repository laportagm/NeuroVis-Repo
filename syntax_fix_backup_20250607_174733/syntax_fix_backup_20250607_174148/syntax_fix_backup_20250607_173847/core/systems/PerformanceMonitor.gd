# Performance Monitoring System for NeuroVis

class_name PerformanceMonitor
extends Node

# === PERFORMANCE METRICS ===

signal performance_warning(metric: MetricType, value: float)
signal performance_critical(metric: MetricType, value: float)
signal performance_improved(metric: MetricType)
signal optimization_suggested(suggestions: Array)

# === STATE ===

enum MetricType {
	FPS, FRAME_TIME, MEMORY_USAGE, GPU_TIME, PHYSICS_TIME, SCRIPT_TIME, DRAW_CALLS, VERTEX_COUNT
}

# === PERFORMANCE THRESHOLDS ===

const THRESHOLDS = {
	"fps_critical": 30,
	"fps_warning": 45,
	"fps_target": 60,
	"frame_time_warning": 22,  # ms (45 fps)
	"frame_time_critical": 33,  # ms (30 fps)
	"memory_warning": 1024,  # MB
	"memory_critical": 2048,  # MB
	"draw_calls_warning": 500,
	"draw_calls_critical": 1000
}

# === SIGNALS ===

var metrics_history: Dictionary = {}
var current_metrics: Dictionary = {}
var monitoring_enabled: bool = true
var sample_rate: float = 0.5  # seconds
var history_size: int = 120  # samples
var performance_issues: Dictionary = {}
var optimization_in_progress: bool = false

# === UI OVERLAY ===
var debug_overlay: CanvasLayer
var debug_panel: Control
var metrics_label: RichTextLabel
var graph_container: Control
var show_overlay: bool = OS.is_debug_build()


	var static_memory = Performance.get_monitor(Performance.MEMORY_STATIC) / 1048576.0  # Convert to MB
	# Note: MEMORY_DYNAMIC not available in Godot 4.4, using static memory only
	current_metrics[MetricType.MEMORY_USAGE] = static_memory

	# Rendering metrics
	current_metrics[MetricType.DRAW_CALLS] = Performance.get_monitor(
		Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME
	)
	current_metrics[MetricType.VERTEX_COUNT] = Performance.get_monitor(
		Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME
	)

	# Physics and script time
	current_metrics[MetricType.PHYSICS_TIME] = Performance.get_monitor(
		Performance.TIME_PHYSICS_PROCESS
	)

	# Add to history
	for metric in current_metrics:
		if metrics_history[metric].size() >= history_size:
			metrics_history[metric].pop_front()
		metrics_history[metric].append(current_metrics[metric])


	var new_issues = {}

	# Check FPS
	if current_metrics[MetricType.FPS] < THRESHOLDS.fps_critical:
		new_issues["fps"] = "critical"
		performance_critical.emit(MetricType.FPS, current_metrics[MetricType.FPS])
	elif current_metrics[MetricType.FPS] < THRESHOLDS.fps_warning:
		new_issues["fps"] = "warning"
		performance_warning.emit(MetricType.FPS, current_metrics[MetricType.FPS])

	# Check memory
	if current_metrics[MetricType.MEMORY_USAGE] > THRESHOLDS.memory_critical:
		new_issues["memory"] = "critical"
		performance_critical.emit(MetricType.MEMORY_USAGE, current_metrics[MetricType.MEMORY_USAGE])
	elif current_metrics[MetricType.MEMORY_USAGE] > THRESHOLDS.memory_warning:
		new_issues["memory"] = "warning"
		performance_warning.emit(MetricType.MEMORY_USAGE, current_metrics[MetricType.MEMORY_USAGE])

	# Check draw calls
	if current_metrics[MetricType.DRAW_CALLS] > THRESHOLDS.draw_calls_critical:
		new_issues["draw_calls"] = "critical"
		performance_critical.emit(MetricType.DRAW_CALLS, current_metrics[MetricType.DRAW_CALLS])
	elif current_metrics[MetricType.DRAW_CALLS] > THRESHOLDS.draw_calls_warning:
		new_issues["draw_calls"] = "warning"
		performance_warning.emit(MetricType.DRAW_CALLS, current_metrics[MetricType.DRAW_CALLS])

	# Check for improvements
	for issue_key in performance_issues:
		if issue_key not in new_issues:
			performance_improved.emit(_get_metric_type_from_key(issue_key))

	performance_issues = new_issues

	# Suggest optimizations if needed
	if performance_issues.size() > 0 and not optimization_in_progress:
		_suggest_optimizations()


# === OPTIMIZATION SUGGESTIONS ===
	var suggestions = []

	if "fps" in performance_issues:
		suggestions.append(
			{
				"issue": "Low FPS",
				"severity": performance_issues["fps"],
				"suggestions":
				[
					"Reduce model complexity",
					"Enable frustum culling",
					"Reduce shadow quality",
					"Lower texture resolution"
				]
			}
		)

	if "memory" in performance_issues:
		suggestions.append(
			{
				"issue": "High Memory Usage",
				"severity": performance_issues["memory"],
				"suggestions":
				[
					"Unload unused models",
					"Reduce texture sizes",
					"Clear cache",
					"Enable texture streaming"
				]
			}
		)

	if "draw_calls" in performance_issues:
		suggestions.append(
			{
				"issue": "Too Many Draw Calls",
				"severity": performance_issues["draw_calls"],
				"suggestions":
				[
					"Enable mesh batching",
					"Use texture atlases",
					"Implement LOD system",
					"Reduce material variations"
				]
			}
		)

	if suggestions.size() > 0:
		optimization_suggested.emit(suggestions)


# === AUTO-OPTIMIZATION ===
	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = Color(0, 0, 0, 0.7)
	panel_style.corner_radius_top_left = 8
	panel_style.corner_radius_top_right = 8
	panel_style.corner_radius_bottom_left = 8
	panel_style.corner_radius_bottom_right = 8
	debug_panel.add_theme_stylebox_override("panel", panel_style)

	debug_overlay.add_child(debug_panel)

	# Metrics text
	metrics_label = RichTextLabel.new()
	metrics_label.bbcode_enabled = true
	metrics_label.fit_content = true
	metrics_label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	metrics_label.add_theme_constant_override("margin_left", 10)
	metrics_label.add_theme_constant_override("margin_top", 10)
	metrics_label.add_theme_constant_override("margin_right", 10)
	metrics_label.add_theme_constant_override("margin_bottom", 10)

	debug_panel.add_child(metrics_label)

	# Toggle visibility
	debug_overlay.visible = show_overlay


	var text = "[b]Performance Monitor[/b]\n\n"

	# FPS
	var fps_color = _get_metric_color(MetricType.FPS, current_metrics[MetricType.FPS])
	text += "[color=%s]FPS: %.1f[/color]\n" % [fps_color.to_html(), current_metrics[MetricType.FPS]]

	# Frame time
	var frame_time = current_metrics[MetricType.FRAME_TIME] * 1000  # Convert to ms
	var frame_color = _get_metric_color(MetricType.FRAME_TIME, frame_time)
	text += "[color=%s]Frame: %.1f ms[/color]\n" % [frame_color.to_html(), frame_time]

	# Memory
	var mem_color = _get_metric_color(
		MetricType.MEMORY_USAGE, current_metrics[MetricType.MEMORY_USAGE]
	)
	text += (
		"[color=%s]Memory: %.1f MB[/color]\n"
		% [mem_color.to_html(), current_metrics[MetricType.MEMORY_USAGE]]
	)

	# Draw calls
	var draw_color = _get_metric_color(
		MetricType.DRAW_CALLS, current_metrics[MetricType.DRAW_CALLS]
	)
	text += (
		"[color=%s]Draw Calls: %d[/color]\n"
		% [draw_color.to_html(), current_metrics[MetricType.DRAW_CALLS]]
	)

	# Vertices
	text += "Vertices: %d\n" % current_metrics[MetricType.VERTEX_COUNT]

	# Issues
	if performance_issues.size() > 0:
		text += "\n[color=yellow]⚠ Performance Issues:[/color]\n"
		for issue in performance_issues:
			text += "• %s\n" % issue.capitalize()

	metrics_label.text = text


	var samples = int(duration / sample_rate)
	var history = metrics_history[MetricType.FPS]

	if history.size() < samples:
		samples = history.size()

	if samples == 0:
		return 0.0

	var sum = 0.0
	for i in range(history.size() - samples, history.size()):
		sum += history[i]

	return sum / samples


func _ready() -> void:
	# Initialize metrics history
	for metric in MetricType.values():
		metrics_history[metric] = []
		current_metrics[metric] = 0.0

	# Create debug overlay
	if show_overlay:
		_create_debug_overlay()

	# Start monitoring
	_start_monitoring()


# === MONITORING ===
func _enter_tree() -> void:
	if not Engine.has_singleton("PerformanceMonitor"):
		Engine.register_singleton("PerformanceMonitor", self)


func _exit_tree() -> void:
	monitoring_enabled = false
	if Engine.has_singleton("PerformanceMonitor"):
		Engine.unregister_singleton("PerformanceMonitor")

func apply_auto_optimizations() -> void:
	"""Apply automatic optimizations based on performance"""
	optimization_in_progress = true

	print("[Performance] Applying automatic optimizations...")

	# FPS optimizations
	if current_metrics[MetricType.FPS] < THRESHOLDS.fps_warning:
		_optimize_for_fps()

	# Memory optimizations
	if current_metrics[MetricType.MEMORY_USAGE] > THRESHOLDS.memory_warning:
		_optimize_memory_usage()

	# Draw call optimizations
	if current_metrics[MetricType.DRAW_CALLS] > THRESHOLDS.draw_calls_warning:
		_optimize_draw_calls()

	optimization_in_progress = false
	print("[Performance] Optimizations applied")


func get_current_fps() -> float:
	"""Get current FPS"""
	return current_metrics.get(MetricType.FPS, 0.0)


func get_average_fps(duration: float = 1.0) -> float:
	"""Get average FPS over duration"""
func get_memory_usage() -> float:
	"""Get current memory usage in MB"""
	return current_metrics.get(MetricType.MEMORY_USAGE, 0.0)


func toggle_overlay() -> void:
	"""Toggle debug overlay visibility"""
	show_overlay = not show_overlay
	if debug_overlay:
		debug_overlay.visible = show_overlay


func set_monitoring_enabled(enabled: bool) -> void:
	"""Enable/disable monitoring"""
	monitoring_enabled = enabled
	if enabled and not is_inside_tree():
		_start_monitoring()


# === SINGLETON SETUP ===

func _start_monitoring() -> void:
	"""Start performance monitoring loop"""
	if not monitoring_enabled:
		return

	while monitoring_enabled:
		_sample_metrics()
		_analyze_performance()
		_update_overlay()

		await get_tree().create_timer(sample_rate).timeout


func _sample_metrics() -> void:
	"""Sample current performance metrics"""
	# FPS and frame time
	current_metrics[MetricType.FPS] = Performance.get_monitor(Performance.TIME_FPS)
	current_metrics[MetricType.FRAME_TIME] = Performance.get_monitor(Performance.TIME_PROCESS)

	# Memory usage
func _analyze_performance() -> void:
	"""Analyze performance and detect issues"""
func _suggest_optimizations() -> void:
	"""Generate optimization suggestions based on current issues"""
func _optimize_for_fps() -> void:
	"""Apply FPS optimizations"""
	# Reduce shadow quality
	RenderingServer.directional_shadow_atlas_set_size(2048, true)

	# Reduce MSAA
	get_viewport().msaa_3d = Viewport.MSAA_2X

	# Enable frustum culling
	get_viewport().use_occlusion_culling = true

	# Reduce particle count
	get_tree().call_group("particles", "reduce_emission_amount", 0.5)


func _optimize_memory_usage() -> void:
	"""Apply memory optimizations"""
	# Clear unused resources
	OS.low_processor_usage_mode = true

	# Unload distant models
	get_tree().call_group("brain_models", "unload_if_distant")

	# Compress textures
	get_tree().call_group("textured_objects", "use_compressed_textures")


func _optimize_draw_calls() -> void:
	"""Apply draw call optimizations"""
	# Enable batching
	get_tree().call_group("batchable", "enable_batching")

	# Merge materials
	get_tree().call_group("materials", "use_shared_materials")


# === DEBUG OVERLAY ===
func _create_debug_overlay() -> void:
	"""Create performance debug overlay"""
	debug_overlay = CanvasLayer.new()
	debug_overlay.layer = 99
	add_child(debug_overlay)

	# Background panel
	debug_panel = Panel.new()
	debug_panel.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	debug_panel.custom_minimum_size = Vector2(300, 200)
	debug_panel.position = Vector2(10, 10)

func _update_overlay() -> void:
	"""Update debug overlay display"""
	if not debug_overlay or not debug_overlay.visible:
		return

func _get_metric_color(metric: MetricType, value: float) -> Color:
	"""Get color based on metric performance"""
	match metric:
		MetricType.FPS:
			if value >= THRESHOLDS.fps_target:
				return Color.GREEN
			elif value >= THRESHOLDS.fps_warning:
				return Color.YELLOW
			else:
				return Color.RED

		MetricType.FRAME_TIME:
			if value <= 16.7:  # 60 fps
				return Color.GREEN
			elif value <= THRESHOLDS.frame_time_warning:
				return Color.YELLOW
			else:
				return Color.RED

		MetricType.MEMORY_USAGE:
			if value <= THRESHOLDS.memory_warning:
				return Color.GREEN
			elif value <= THRESHOLDS.memory_critical:
				return Color.YELLOW
			else:
				return Color.RED

		MetricType.DRAW_CALLS:
			if value <= THRESHOLDS.draw_calls_warning:
				return Color.GREEN
			elif value <= THRESHOLDS.draw_calls_critical:
				return Color.YELLOW
			else:
				return Color.RED

		_:
			return Color.WHITE


func _get_metric_type_from_key(key: String) -> MetricType:
	"""Convert issue key to metric type"""
	match key:
		"fps":
			return MetricType.FPS
		"memory":
			return MetricType.MEMORY_USAGE
		"draw_calls":
			return MetricType.DRAW_CALLS
		_:
			return MetricType.FPS


# === PUBLIC API ===
