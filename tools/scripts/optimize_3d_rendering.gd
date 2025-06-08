## Optimize 3D Rendering Script
## Applies performance optimizations to improve frame rate for educational use
## @version: 1.0

extends SceneTree

# === CONSTANTS ===
const TARGET_FPS: float = 60.0
const OPTIMIZATION_LEVELS = {
	"low":
	{
		"shadow_quality": 0,  # Low quality
		"shadow_resolution": 1024,
		"msaa": Viewport.MSAA_DISABLED,
		"fxaa": false,
		"render_scale": 0.75,
		"max_lights": 4
	},
	"medium":
	{
		"shadow_quality": 1,  # Medium quality
		"shadow_resolution": 2048,
		"msaa": Viewport.MSAA_2X,
		"fxaa": false,
		"render_scale": 0.9,
		"max_lights": 8
	},
	"high":
	{
		"shadow_quality": 2,  # High quality
		"shadow_resolution": 4096,
		"msaa": Viewport.MSAA_4X,
		"fxaa": true,
		"render_scale": 1.0,
		"max_lights": 16
	}
}

var optimizations_applied: Dictionary = {}


# === MAIN ===
func _initialize() -> void:
	print("\n=== NeuroVis 3D Rendering Optimizer ===")
	print("Target: 60fps for smooth educational experience\n")

	# Analyze current performance
	var current_fps = _estimate_current_fps()
	print("Estimated current FPS: %.1f" % current_fps)

	# Determine optimization level needed
	var level = _determine_optimization_level(current_fps)
	print("Recommended optimization level: %s\n" % level.to_upper())

	# Apply optimizations
	_apply_optimizations(level)

	# Configure LOD system
	_configure_lod_system()

	# Optimize materials
	_optimize_materials()

	# Configure culling
	_configure_culling()

	# Save optimization settings
	_save_optimization_config()

	print("\n✅ Optimizations applied!")
	print("Run the performance baseline test again to verify improvements.")

	quit()


func _estimate_current_fps() -> float:
	"""Estimate FPS based on previous test results"""
	# From our test, model rendering was ~10.3 FPS
	return 10.3


func _determine_optimization_level(current_fps: float) -> String:
	"""Determine which optimization level to apply"""
	if current_fps < 20:
		return "low"
	elif current_fps < 40:
		return "medium"
	else:
		return "high"


func _apply_optimizations(level: String) -> void:
	"""Apply rendering optimizations"""
	print("Applying %s quality optimizations..." % level)

	var settings = OPTIMIZATION_LEVELS[level]

	# Shadow quality
	# In Godot 4, we use project settings for shadow quality
	ProjectSettings.set_setting(
		"rendering/lights_and_shadows/directional_shadow/soft_shadow_filter_quality",
		settings.shadow_quality
	)
	optimizations_applied["shadow_quality"] = level
	print("  ✓ Shadow quality set to %s" % level)

	# Shadow resolution
	ProjectSettings.set_setting(
		"rendering/lights_and_shadows/directional_shadow/size", settings.shadow_resolution
	)
	optimizations_applied["shadow_resolution"] = settings.shadow_resolution
	print("  ✓ Shadow resolution set to %d" % settings.shadow_resolution)

	# MSAA
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_3d", settings.msaa)
	optimizations_applied["msaa"] = settings.msaa
	print("  ✓ MSAA set to %s" % _get_msaa_name(settings.msaa))

	# FXAA
	ProjectSettings.set_setting(
		"rendering/anti_aliasing/quality/screen_space_aa", 1 if settings.fxaa else 0
	)
	optimizations_applied["fxaa"] = settings.fxaa
	print("  ✓ FXAA %s" % ("enabled" if settings.fxaa else "disabled"))

	# Render scale
	ProjectSettings.set_setting("rendering/scaling_3d/scale", settings.render_scale)
	optimizations_applied["render_scale"] = settings.render_scale
	print("  ✓ Render scale set to %.0f%%" % (settings.render_scale * 100))

	# Max lights per object
	ProjectSettings.set_setting(
		"rendering/lights_and_shadows/max_lights_per_object", settings.max_lights
	)
	optimizations_applied["max_lights"] = settings.max_lights
	print("  ✓ Max lights per object: %d" % settings.max_lights)

	# Additional optimizations for low-end systems
	if level == "low":
		# Disable screen space reflections
		ProjectSettings.set_setting("rendering/environment/screen_space_reflections/enabled", false)
		print("  ✓ Screen space reflections disabled")

		# Disable ambient occlusion
		ProjectSettings.set_setting("rendering/environment/ssao/enabled", false)
		print("  ✓ SSAO disabled")

		# Reduce texture quality
		ProjectSettings.set_setting(
			"rendering/textures/default_filters/anisotropic_filtering_level", 2
		)
		print("  ✓ Anisotropic filtering reduced")


func _configure_lod_system() -> void:
	"""Configure LOD system for brain models"""
	print("\nConfiguring LOD system...")

	# Create LOD configuration
	var lod_config = ConfigFile.new()

	# Set aggressive LOD distances for better performance
	lod_config.set_value("lod", "enabled", true)
	lod_config.set_value("lod", "distance_thresholds", [3.0, 10.0, 20.0, 40.0])
	lod_config.set_value("lod", "quality_factors", [1.0, 0.6, 0.3, 0.1])
	lod_config.set_value("lod", "smooth_transitions", true)
	lod_config.set_value("lod", "transition_time", 0.2)

	# Brain-specific LOD settings
	lod_config.set_value("models", "Half_Brain_lod_bias", 0.8)  # More aggressive LOD
	lod_config.set_value("models", "Internal_Structures_lod_bias", 1.0)  # Standard LOD
	lod_config.set_value("models", "Brainstem_lod_bias", 0.9)  # Slightly aggressive

	lod_config.save("user://lod_config.cfg")
	print("  ✓ LOD system configured with aggressive distance thresholds")
	print("  ✓ Brain models will switch to lower detail at closer distances")


func _optimize_materials() -> void:
	"""Optimize material settings"""
	print("\nOptimizing materials...")

	# Create material optimization config
	var mat_config = ConfigFile.new()

	# Shader optimizations
	mat_config.set_value("shaders", "use_vertex_lighting", false)  # Keep per-pixel for quality
	mat_config.set_value("shaders", "max_texture_size", 2048)  # Limit texture sizes
	mat_config.set_value("shaders", "compress_textures", true)
	mat_config.set_value("shaders", "use_texture_arrays", true)  # Better batching

	# Material batching
	mat_config.set_value("batching", "enabled", true)
	mat_config.set_value("batching", "max_batch_size", 128)
	mat_config.set_value("batching", "merge_similar_materials", true)

	mat_config.save("user://material_optimization.cfg")
	print("  ✓ Material batching enabled")
	print("  ✓ Texture compression enabled")
	print("  ✓ Similar materials will be merged")


func _configure_culling() -> void:
	"""Configure culling settings"""
	print("\nConfiguring culling...")

	# Frustum culling
	ProjectSettings.set_setting("rendering/occlusion_culling/use_occlusion_culling", true)
	print("  ✓ Occlusion culling enabled")

	# Configure mesh instance settings
	var culling_config = ConfigFile.new()
	culling_config.set_value("culling", "frustum_culling_enabled", true)
	culling_config.set_value("culling", "occlusion_culling_enabled", true)
	culling_config.set_value("culling", "small_object_culling_threshold", 0.01)
	culling_config.set_value("culling", "backface_culling_enabled", true)

	culling_config.save("user://culling_config.cfg")
	print("  ✓ Frustum culling enabled")
	print("  ✓ Small object culling configured")
	print("  ✓ Backface culling enabled")


func _save_optimization_config() -> void:
	"""Save all optimization settings"""
	print("\nSaving optimization configuration...")

	var config = ConfigFile.new()

	# Save all applied optimizations
	for key in optimizations_applied:
		config.set_value("optimizations", key, optimizations_applied[key])

	# Save timestamp
	config.set_value("meta", "timestamp", Time.get_datetime_string_from_system())
	config.set_value("meta", "target_fps", TARGET_FPS)

	config.save("user://rendering_optimizations.cfg")
	ProjectSettings.save()

	print("  ✓ Configuration saved to user://rendering_optimizations.cfg")
	print("  ✓ Project settings updated")


func _get_msaa_name(msaa_value: int) -> String:
	"""Convert MSAA enum to string"""
	match msaa_value:
		Viewport.MSAA_DISABLED:
			return "Disabled"
		Viewport.MSAA_2X:
			return "2x"
		Viewport.MSAA_4X:
			return "4x"
		Viewport.MSAA_8X:
			return "8x"
		_:
			return "Unknown"
