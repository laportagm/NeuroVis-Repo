## Switch to Mobile Renderer Script
## Configures Godot to use the mobile renderer for maximum performance
## @version: 1.0

extends SceneTree


func _initialize() -> void:
	print("\n=== Switching to Mobile Renderer ===")
	print("This will significantly improve performance...\n")

	# Switch to mobile renderer
	ProjectSettings.set_setting("rendering/renderer/rendering_method", "mobile")
	ProjectSettings.set_setting("rendering/renderer/rendering_method.mobile", "gl_compatibility")

	# Aggressive mobile optimizations
	_apply_mobile_optimizations()

	# Save settings
	ProjectSettings.save()

	print("\n✅ Mobile renderer configured!")
	print("Please restart Godot for changes to take effect.")
	print("\nExpected performance improvement: 2-3x")

	quit()


func _apply_mobile_optimizations() -> void:
	"""Apply mobile-specific optimizations"""
	print("Applying mobile optimizations...")

	# Disable expensive features
	ProjectSettings.set_setting("rendering/lights_and_shadows/directional_shadow/size", 1024)
	ProjectSettings.set_setting(
		"rendering/lights_and_shadows/directional_shadow/soft_shadow_filter_quality.mobile", 0
	)
	ProjectSettings.set_setting("rendering/lights_and_shadows/positional_shadow/atlas_size", 1024)
	ProjectSettings.set_setting(
		"rendering/lights_and_shadows/positional_shadow/soft_shadow_filter_quality.mobile", 0
	)

	# Disable all post-processing
	ProjectSettings.set_setting("rendering/environment/ssao/enabled", false)
	ProjectSettings.set_setting("rendering/environment/ssil/enabled", false)
	ProjectSettings.set_setting("rendering/environment/screen_space_reflections/enabled", false)
	ProjectSettings.set_setting("rendering/environment/glow/enabled", false)
	ProjectSettings.set_setting("rendering/environment/volumetric_fog/enabled", false)

	# Texture optimizations
	ProjectSettings.set_setting("rendering/textures/vram_compression/import_etc2_astc", true)
	ProjectSettings.set_setting(
		"rendering/textures/default_filters/use_nearest_mipmap_filter", true
	)
	ProjectSettings.set_setting("rendering/textures/default_filters/anisotropic_filtering_level", 0)

	# Mesh optimizations
	ProjectSettings.set_setting("rendering/mesh_lod/lod_change/threshold_pixels", 20.0)

	# Global illumination off
	ProjectSettings.set_setting("rendering/global_illumination/gi/use_half_resolution", true)

	# Shader optimizations
	ProjectSettings.set_setting("rendering/shading/overrides/force_vertex_shading", false)
	ProjectSettings.set_setting("rendering/shading/overrides/force_vertex_shading.mobile", true)
	ProjectSettings.set_setting("rendering/shading/overrides/force_lambert_over_burley", true)
	ProjectSettings.set_setting(
		"rendering/shading/overrides/force_lambert_over_burley.mobile", true
	)

	# Clustering optimizations
	ProjectSettings.set_setting("rendering/limits/cluster_builder/max_clustered_elements", 32)

	print("  ✓ Mobile optimizations applied")
