## Apply Aggressive Optimizations Script
## Directly modifies scene to achieve 60fps target
## @version: 1.0

extends SceneTree

# === CONSTANTS ===
const TARGET_FPS: float = 60.0


func _initialize() -> void:
	print("\n=== NeuroVis Aggressive Optimization ===")
	print("Applying direct scene optimizations for 60fps\n")

	# Apply all optimizations
	_optimize_project_settings()

	print("\n✅ Aggressive optimizations complete!")
	print("Project settings have been updated.")
	print("Please restart Godot to apply all changes.")

	quit()


func _optimize_project_settings() -> void:
	"""Apply aggressive project-wide rendering settings"""
	print("Applying project settings...")

	# Renderer settings
	ProjectSettings.set_setting("rendering/renderer/rendering_method", "mobile")
	ProjectSettings.set_setting("rendering/renderer/rendering_method.mobile", "gl_compatibility")

	# Shadow settings
	ProjectSettings.set_setting("rendering/lights_and_shadows/directional_shadow/size", 2048)
	ProjectSettings.set_setting(
		"rendering/lights_and_shadows/directional_shadow/soft_shadow_filter_quality", 0
	)
	ProjectSettings.set_setting("rendering/lights_and_shadows/positional_shadow/atlas_size", 2048)

	# Anti-aliasing
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_3d", 0)  # Disabled
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/screen_space_aa", 0)
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/use_taa", false)

	# Scaling
	ProjectSettings.set_setting("rendering/scaling_3d/mode", 1)  # FSR
	ProjectSettings.set_setting("rendering/scaling_3d/scale", 0.75)

	# Reflections and effects
	ProjectSettings.set_setting("rendering/environment/screen_space_reflections/enabled", false)
	ProjectSettings.set_setting("rendering/environment/ssao/enabled", false)
	ProjectSettings.set_setting("rendering/environment/ssil/enabled", false)
	ProjectSettings.set_setting("rendering/environment/glow/enabled", false)

	# Textures
	ProjectSettings.set_setting("rendering/textures/default_filters/texture_mipmap_bias", 0.5)
	ProjectSettings.set_setting("rendering/textures/default_filters/anisotropic_filtering_level", 0)

	# Mesh LOD
	ProjectSettings.set_setting("rendering/mesh_lod/lod_change/threshold_pixels", 10.0)

	# Occlusion culling
	ProjectSettings.set_setting("rendering/occlusion_culling/use_occlusion_culling", true)
	ProjectSettings.set_setting("rendering/occlusion_culling/occlusion_rays_per_thread", 256)

	ProjectSettings.save()
	print("  ✓ Project settings optimized")
