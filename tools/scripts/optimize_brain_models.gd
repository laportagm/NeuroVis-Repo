## Optimize Brain Models Script
## Applies runtime optimizations to achieve 60fps
## @version: 1.0

extends Node3D

# === CONSTANTS ===
const TARGET_FPS: float = 60.0


# === LIFECYCLE ===
func _ready() -> void:
	print("\n=== Brain Model Optimization ===")

	# Wait for scene to be ready
	await get_tree().process_frame

	# Find and optimize all brain models
	_optimize_all_brain_models()

	# Set up LOD system
	_setup_lod_system()

	# Optimize rendering settings at runtime
	_optimize_runtime_rendering()

	print("\n✅ Brain models optimized for 60fps!")


func _optimize_all_brain_models() -> void:
	"""Find and optimize all brain model meshes"""
	print("Optimizing brain models...")

	var optimized_count = 0
	var brain_models = []

	# Find brain model nodes
	var brain_parent = get_node_or_null("BrainModel")
	if brain_parent:
		_collect_meshes(brain_parent, brain_models)

	# Also check for common brain model names
	var possible_names = ["Half_Brain", "Internal_Structures", "Brainstem", "BrainModel"]
	for model_name in possible_names:
		var model = get_node_or_null(model_name)
		if model:
			_collect_meshes(model, brain_models)

	# Optimize each mesh
	for mesh_instance in brain_models:
		if not mesh_instance is MeshInstance3D:
			continue

		# Set LOD bias for aggressive LOD
		mesh_instance.lod_bias = 3.0

		# Disable shadows for internal structures
		if mesh_instance.name.contains("Internal") or mesh_instance.name.contains("inner"):
			mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		else:
			mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_SHADOWS_ONLY

		# Disable GI
		mesh_instance.gi_mode = GeometryInstance3D.GI_MODE_DISABLED

		# Set visibility range
		mesh_instance.visibility_range_begin = 0.0
		mesh_instance.visibility_range_end = 50.0
		mesh_instance.visibility_range_fade_mode = GeometryInstance3D.VISIBILITY_RANGE_FADE_DISABLED

		# Optimize materials
		for i in range(mesh_instance.get_surface_override_material_count()):
			var mat = mesh_instance.get_surface_override_material(i)
			if mat and mat is StandardMaterial3D:
				_optimize_material(mat)

		optimized_count += 1

	print("  ✓ Optimized %d brain meshes" % optimized_count)


func _optimize_material(mat: StandardMaterial3D) -> void:
	"""Optimize a StandardMaterial3D for performance"""
	# Use simpler shading
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_PER_PIXEL  # Keep per-pixel for quality
	mat.specular_mode = BaseMaterial3D.SPECULAR_SCHLICK_GGX  # Use simpler specular

	# Disable expensive features
	mat.rim_enabled = false
	mat.clearcoat_enabled = false
	mat.anisotropy_enabled = false
	mat.subsurf_scatter_enabled = false
	mat.refraction_enabled = false
	mat.detail_enabled = false

	# Optimize transparency
	if mat.transparency != BaseMaterial3D.TRANSPARENCY_DISABLED:
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
		mat.alpha_scissor_threshold = 0.5
		mat.no_depth_test = false
		mat.depth_draw_mode = BaseMaterial3D.DEPTH_DRAW_OPAQUE_ONLY

	# Reduce texture sizes if possible
	mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS

	# Set cull mode
	mat.cull_mode = BaseMaterial3D.CULL_BACK

	# Disable vertex colors
	mat.vertex_color_use_as_albedo = false


func _setup_lod_system() -> void:
	"""Set up LOD for brain models"""
	print("Setting up LOD system...")

	# Check if LODManager exists
	var lod_manager = get_node_or_null("/root/LODManager")
	if not lod_manager:
		# Try to find it in autoloads
		if Engine.has_singleton("LODManager"):
			lod_manager = Engine.get_singleton("LODManager")

	if lod_manager and lod_manager.has_method("update_thresholds"):
		# Set aggressive LOD thresholds
		var thresholds = [2.0, 5.0, 10.0, 20.0]  # Very aggressive
		lod_manager.update_thresholds(thresholds)
		lod_manager.lod_enabled = true
		print("  ✓ LOD system configured with aggressive thresholds")
	else:
		print("  ⚠ LOD Manager not found")


func _optimize_runtime_rendering() -> void:
	"""Apply runtime rendering optimizations"""
	print("Applying runtime optimizations...")

	var viewport = get_viewport()
	if viewport:
		# Set MSAA
		viewport.msaa_3d = Viewport.MSAA_DISABLED

		# Set screen space AA
		viewport.screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED

		# Disable debanding
		viewport.use_debanding = false

		# Set shadow atlas size
		viewport.shadow_atlas_size = 2048
		viewport.shadow_atlas_16_bits = true

		# Set scaling
		viewport.scaling_3d_mode = Viewport.SCALING_3D_MODE_FSR
		viewport.scaling_3d_scale = 0.75

		print("  ✓ Viewport optimized")

	# Find camera and optimize
	var camera = get_node_or_null("Camera3D")
	if camera and camera is Camera3D:
		camera.near = 0.1
		camera.far = 100.0  # Reduce far plane
		print("  ✓ Camera optimized")

	# Find lights and optimize
	var lights = []
	_find_nodes_of_type(self, "DirectionalLight3D", lights)
	_find_nodes_of_type(self, "OmniLight3D", lights)
	_find_nodes_of_type(self, "SpotLight3D", lights)

	for light in lights:
		if light is DirectionalLight3D:
			light.directional_shadow_mode = DirectionalLight3D.SHADOW_PARALLEL_2_SPLITS
			light.directional_shadow_max_distance = 30.0
		elif light is OmniLight3D or light is SpotLight3D:
			light.shadow_enabled = false

	print("  ✓ Lights optimized")


# === HELPER METHODS ===
func _collect_meshes(node: Node, meshes: Array) -> void:
	"""Recursively collect all MeshInstance3D nodes"""
	if node is MeshInstance3D:
		meshes.append(node)

	for child in node.get_children():
		_collect_meshes(child, meshes)


func _find_nodes_of_type(node: Node, type_name: String, result: Array) -> void:
	"""Find all nodes of a specific type"""
	if node.get_class() == type_name:
		result.append(node)

	for child in node.get_children():
		_find_nodes_of_type(child, type_name, result)
