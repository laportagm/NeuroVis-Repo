## DynamicQualityManager.gd
## Automatically adjusts rendering quality to maintain target FPS
## @version: 1.0

class_name DynamicQualityManager
extends Node

# === SIGNALS ===
signal quality_changed(new_level: int)
signal performance_critical(fps: float)

# === CONSTANTS ===
const TARGET_FPS: float = 60.0
const MIN_FPS: float = 30.0
const SAMPLE_INTERVAL: float = 1.0
const ADJUSTMENT_INTERVAL: float = 3.0

enum QualityLevel { ULTRA_LOW, LOW, MEDIUM, HIGH, ULTRA }

const QUALITY_PRESETS = {
	QualityLevel.ULTRA_LOW:
	{
		"render_scale": 0.5,
		"shadow_size": 512,
		"shadow_enabled": false,
		"msaa": Viewport.MSAA_DISABLED,
		"lod_bias": 4.0,
		"max_fps": 0  # Unlimited
	},
	QualityLevel.LOW:
	{
		"render_scale": 0.65,
		"shadow_size": 1024,
		"shadow_enabled": true,
		"msaa": Viewport.MSAA_DISABLED,
		"lod_bias": 3.0,
		"max_fps": 0
	},
	QualityLevel.MEDIUM:
	{
		"render_scale": 0.8,
		"shadow_size": 2048,
		"shadow_enabled": true,
		"msaa": Viewport.MSAA_2X,
		"lod_bias": 2.0,
		"max_fps": 0
	},
	QualityLevel.HIGH:
	{
		"render_scale": 0.9,
		"shadow_size": 2048,
		"shadow_enabled": true,
		"msaa": Viewport.MSAA_2X,
		"lod_bias": 1.0,
		"max_fps": 60
	},
	QualityLevel.ULTRA:
	{
		"render_scale": 1.0,
		"shadow_size": 4096,
		"shadow_enabled": true,
		"msaa": Viewport.MSAA_4X,
		"lod_bias": 0.0,
		"max_fps": 60
	}
}

# === VARIABLES ===
var current_quality: QualityLevel = QualityLevel.MEDIUM
var enabled: bool = true
var fps_samples: Array[float] = []
var last_adjustment_time: float = 0.0
var viewport: Viewport
var directional_light: DirectionalLight3D


# === LIFECYCLE ===
func _ready() -> void:
	print("[DynamicQuality] Initializing dynamic quality system...")

	# Get viewport
	viewport = get_viewport()

	# Find directional light
	var lights = get_tree().get_nodes_in_group("lights")
	if lights.is_empty():
		# Try to find by type
		for node in get_tree().get_nodes_in_group("Node3D"):
			if node is DirectionalLight3D:
				directional_light = node
				break
	else:
		directional_light = lights[0] as DirectionalLight3D

	# Start with low quality for safety
	_apply_quality_preset(QualityLevel.LOW)

	print("[DynamicQuality] System ready - starting at LOW quality")


func _process(delta: float) -> void:
	if not enabled:
		return

	# Sample FPS
	var current_fps = Engine.get_frames_per_second()
	fps_samples.append(current_fps)

	# Keep only recent samples
	if fps_samples.size() > 60:
		fps_samples.pop_front()

	# Check if we should adjust quality
	var current_time = Time.get_ticks_msec() / 1000.0
	if current_time - last_adjustment_time > ADJUSTMENT_INTERVAL:
		_evaluate_and_adjust_quality()
		last_adjustment_time = current_time


# === PUBLIC METHODS ===
func set_quality_level(level: QualityLevel) -> void:
	"""Manually set quality level"""
	if level != current_quality:
		_apply_quality_preset(level)


func get_average_fps() -> float:
	"""Get average FPS from recent samples"""
	if fps_samples.is_empty():
		return 0.0

	var sum = 0.0
	for fps in fps_samples:
		sum += fps
	return sum / fps_samples.size()


func enable_dynamic_adjustment(enable: bool) -> void:
	"""Enable or disable dynamic quality adjustment"""
	enabled = enable
	print("[DynamicQuality] Dynamic adjustment %s" % ("enabled" if enable else "disabled"))


# === PRIVATE METHODS ===
func _evaluate_and_adjust_quality() -> void:
	"""Evaluate performance and adjust quality if needed"""
	var avg_fps = get_average_fps()

	if avg_fps < 10.0:  # No valid samples yet
		return

	print("[DynamicQuality] Average FPS: %.1f" % avg_fps)

	# Critical performance - immediate action
	if avg_fps < MIN_FPS:
		performance_critical.emit(avg_fps)
		if current_quality > QualityLevel.ULTRA_LOW:
			print("[DynamicQuality] Performance critical! Reducing quality...")
			_apply_quality_preset(current_quality - 1)
		return

	# Adjust quality based on FPS
	if avg_fps < TARGET_FPS * 0.9:  # Below 90% of target
		if current_quality > QualityLevel.ULTRA_LOW:
			print("[DynamicQuality] FPS below target, reducing quality...")
			_apply_quality_preset(current_quality - 1)
	elif avg_fps > TARGET_FPS * 1.1:  # Above 110% of target
		if current_quality < QualityLevel.HIGH:  # Don't go to ULTRA automatically
			print("[DynamicQuality] FPS above target, increasing quality...")
			_apply_quality_preset(current_quality + 1)


func _apply_quality_preset(level: QualityLevel) -> void:
	"""Apply a quality preset"""
	var preset = QUALITY_PRESETS[level]

	print("[DynamicQuality] Applying %s quality preset" % _get_quality_name(level))

	# Apply viewport settings
	if viewport:
		viewport.scaling_3d_scale = preset.render_scale
		viewport.msaa_3d = preset.msaa

		# Shadow atlas - only for SubViewport
		if viewport is SubViewport:
			viewport.shadow_atlas_size = preset.shadow_size

	# Apply shadow settings
	if directional_light:
		directional_light.shadow_enabled = preset.shadow_enabled
		if preset.shadow_enabled:
			directional_light.directional_shadow_max_distance = (
				20.0 if level < QualityLevel.HIGH else 50.0
			)

	# Apply LOD bias to all meshes
	var meshes = get_tree().get_nodes_in_group("mesh_instances")
	if meshes.is_empty():
		# Find by type
		for node in get_tree().get_nodes_in_group("Node3D"):
			if node is MeshInstance3D:
				meshes.append(node)

	for mesh in meshes:
		if mesh is MeshInstance3D:
			mesh.lod_bias = preset.lod_bias

	# Set max FPS
	Engine.max_fps = preset.max_fps

	# Update current quality
	current_quality = level
	quality_changed.emit(level)

	# Clear FPS samples to get fresh data
	fps_samples.clear()


func _get_quality_name(level: QualityLevel) -> String:
	"""Get human-readable quality level name"""
	match level:
		QualityLevel.ULTRA_LOW:
			return "Ultra Low"
		QualityLevel.LOW:
			return "Low"
		QualityLevel.MEDIUM:
			return "Medium"
		QualityLevel.HIGH:
			return "High"
		QualityLevel.ULTRA:
			return "Ultra"
		_:
			return "Unknown"
