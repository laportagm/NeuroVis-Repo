## MaterialLibrary.gd
## Singleton for managing specialized PBR materials for brain visualization
##
## Provides a centralized system for creating, caching, and applying
## physically-based rendering materials optimized for neuroanatomical structures.
##
## @tutorial: docs/dev/material-system.md
## @experimental: false

class_name MaterialLibrary
extends Node

# === CONSTANTS ===
## Base path for material resources
const MATERIALS_BASE_PATH: String = "res://assets/materials/brain_materials/"

## Base path for shader resources
const SHADERS_BASE_PATH: String = "res://assets/shaders/medical/"

## Default material types
enum MaterialType {
	GRAY_MATTER,
	WHITE_MATTER,
	CEREBROSPINAL_FLUID,
	BLOOD_VESSEL,
	BONE,
	MENINGES,
	GENERIC,
	SELECTED,
	HIGHLIGHTED
}

# === SIGNALS ===
## Emitted when a material is updated
## @param material_name: String name of the updated material
signal material_updated(material_name: String)

## Emitted when a material preset is applied
## @param preset_name: String name of the applied preset
signal preset_applied(preset_name: String)

# === EXPORTS ===
## Subsurface scattering strength for biological tissues
@export var subsurface_scattering_strength: float = 0.3

## Default roughness for brain tissues
@export var default_roughness: float = 0.7

## Default metallic value for brain tissues (generally non-metallic)
@export var default_metallic: float = 0.0

# === PUBLIC VARIABLES ===
## Material quality level (affects shader complexity)
var quality_level: int = 2  # 0=Low, 1=Medium, 2=High

## Whether to use PBR materials
var use_pbr: bool = true

# === PRIVATE VARIABLES ===
var _materials_cache: Dictionary = {}
var _material_presets: Dictionary = {}
var _initialized: bool = false
var _shaders_cache: Dictionary = {}

# === LIFECYCLE METHODS ===
func _ready() -> void:
	"""Initialize the material library"""
	_initialize_library()
	_create_default_materials()
	_create_material_presets()
	print("[MaterialLibrary] Initialized")

# === PUBLIC METHODS ===
## Get a material by type
## @param type: MaterialType enum value
## @returns: Material based on specified type
func get_material_by_type(type: int) -> Material:
	"""Get a predefined material by type"""
	var material_name = ""
	
	match type:
		MaterialType.GRAY_MATTER:
			material_name = "gray_matter"
		MaterialType.WHITE_MATTER:
			material_name = "white_matter"
		MaterialType.CEREBROSPINAL_FLUID:
			material_name = "cerebrospinal_fluid"
		MaterialType.BLOOD_VESSEL:
			material_name = "blood_vessel"
		MaterialType.BONE:
			material_name = "bone"
		MaterialType.MENINGES:
			material_name = "meninges"
		MaterialType.GENERIC:
			material_name = "generic_brain_tissue"
		MaterialType.SELECTED:
			material_name = "selected_structure"
		MaterialType.HIGHLIGHTED:
			material_name = "highlighted_structure"
		_:
			material_name = "generic_brain_tissue"
	
	return get_material(material_name)

## Get a material by name
## @param material_name: String name of the material
## @returns: Material with the specified name
func get_material(material_name: String) -> Material:
	"""Get a material by name, creating it if it doesn't exist"""
	if _materials_cache.has(material_name):
		return _materials_cache[material_name]
	
	# Try to load from file
	var file_path = MATERIALS_BASE_PATH + material_name + ".tres"
	if ResourceLoader.exists(file_path):
		var material = load(file_path)
		if material != null:
			_materials_cache[material_name] = material
			return material
	
	# Create a new default material if not found
	var new_material = _create_default_material()
	_materials_cache[material_name] = new_material
	return new_material

## Apply a material preset to all materials
## @param preset_name: String name of the preset to apply
## @returns: bool indicating success
func apply_preset(preset_name: String) -> bool:
	"""Apply a predefined material preset to all materials"""
	if not _material_presets.has(preset_name):
		push_warning("[MaterialLibrary] Preset not found: " + preset_name)
		return false
	
	var preset = _material_presets[preset_name]
	
	# Apply preset settings to all materials
	for material_name in _materials_cache:
		var material = _materials_cache[material_name]
		_apply_preset_to_material(material, preset)
	
	# Emit signal
	preset_applied.emit(preset_name)
	print("[MaterialLibrary] Applied preset: " + preset_name)
	
	return true

## Apply a material to a mesh instance
## @param mesh_instance: MeshInstance3D to apply material to
## @param material_name: String name of the material to apply
## @returns: bool indicating success
func apply_material_to_mesh(mesh_instance: MeshInstance3D, material_name: String) -> bool:
	"""Apply a material to a mesh instance"""
	if not mesh_instance or not mesh_instance.mesh:
		push_warning("[MaterialLibrary] Invalid mesh instance")
		return false
	
	var material = get_material(material_name)
	if not material:
		push_warning("[MaterialLibrary] Material not found: " + material_name)
		return false
	
	# Apply to all surfaces
	for i in range(mesh_instance.mesh.get_surface_count()):
		mesh_instance.set_surface_override_material(i, material)
	
	return true

## Apply material based on mesh name
## @param mesh_instance: MeshInstance3D to apply material to
## @returns: bool indicating success
func apply_material_by_name_recognition(mesh_instance: MeshInstance3D) -> bool:
	"""Intelligently apply material based on mesh name"""
	if not mesh_instance or not mesh_instance.mesh:
		push_warning("[MaterialLibrary] Invalid mesh instance")
		return false
	
	var mesh_name = mesh_instance.name.to_lower()
	var material_name = "generic_brain_tissue"
	
	# Determine appropriate material based on mesh name
	if "cortex" in mesh_name or "gray" in mesh_name:
		material_name = "gray_matter"
	elif "white" in mesh_name or "tract" in mesh_name or "fiber" in mesh_name:
		material_name = "white_matter"
	elif "fluid" in mesh_name or "csf" in mesh_name or "ventricle" in mesh_name:
		material_name = "cerebrospinal_fluid"
	elif "vessel" in mesh_name or "artery" in mesh_name or "vein" in mesh_name or "blood" in mesh_name:
		material_name = "blood_vessel"
	elif "bone" in mesh_name or "skull" in mesh_name or "cranium" in mesh_name:
		material_name = "bone"
	elif "dura" in mesh_name or "meninges" in mesh_name or "membrane" in mesh_name:
		material_name = "meninges"
	
	# Apply the determined material
	return apply_material_to_mesh(mesh_instance, material_name)

## Create a custom material with specific properties
## @param properties: Dictionary of material properties
## @returns: Material with specified properties
func create_custom_material(properties: Dictionary) -> Material:
	"""Create a custom material with specified properties"""
	var material
	
	if use_pbr:
		material = StandardMaterial3D.new()
		
		# Apply base properties
		if properties.has("albedo_color"):
			material.albedo_color = properties.albedo_color
		
		if properties.has("metallic"):
			material.metallic = properties.metallic
		else:
			material.metallic = default_metallic
		
		if properties.has("roughness"):
			material.roughness = properties.roughness
		else:
			material.roughness = default_roughness
		
		# PBR specific properties
		if properties.has("normal_enabled") and properties.normal_enabled:
			material.normal_enabled = true
			if properties.has("normal_scale"):
				material.normal_scale = properties.normal_scale
			if properties.has("normal_texture"):
				material.normal_texture = properties.normal_texture
		
		if properties.has("subsurface_scattering_enabled") and properties.subsurface_scattering_enabled:
			material.subsurf_scatter_enabled = true
			if properties.has("subsurface_scattering_strength"):
				material.subsurf_scatter_strength = properties.subsurface_scattering_strength
			else:
				material.subsurf_scatter_strength = subsurface_scattering_strength
		
		if properties.has("emission_enabled") and properties.emission_enabled:
			material.emission_enabled = true
			if properties.has("emission"):
				material.emission = properties.emission
			if properties.has("emission_energy"):
				material.emission_energy_multiplier = properties.emission_energy
	else:
		# Create a simpler material for low-end devices
		material = StandardMaterial3D.new()
		
		# Apply base properties only
		if properties.has("albedo_color"):
			material.albedo_color = properties.albedo_color
		
		material.metallic = 0.0
		material.roughness = 0.9  # Higher roughness for simpler shading
	
	return material

## Update material quality level
## @param level: int quality level (0=Low, 1=Medium, 2=High)
func set_quality_level(level: int) -> void:
	"""Set the material quality level"""
	quality_level = clamp(level, 0, 2)
	
	# Update PBR flag based on quality
	use_pbr = quality_level > 0
	
	# Recreate materials with new quality
	_recreate_materials_for_quality()
	
	print("[MaterialLibrary] Quality level set to: " + str(quality_level))

## Save a material to file
## @param material_name: String name of the material
## @returns: bool indicating success
func save_material(material_name: String) -> bool:
	"""Save a material to file"""
	if not _materials_cache.has(material_name):
		push_warning("[MaterialLibrary] Material not found: " + material_name)
		return false
	
	var material = _materials_cache[material_name]
	var file_path = MATERIALS_BASE_PATH + material_name + ".tres"
	
	var dir = DirAccess.open("res://assets/materials")
	if not dir:
		dir = DirAccess.open("res://")
		dir.make_dir("assets/materials")
		dir = DirAccess.open("res://assets/materials")
		if not dir:
			push_error("[MaterialLibrary] Failed to create materials directory")
			return false
	
	var result = ResourceSaver.save(material, file_path)
	if result != OK:
		push_error("[MaterialLibrary] Failed to save material: " + material_name)
		return false
	
	print("[MaterialLibrary] Saved material: " + material_name)
	return true

## Update a specific material property
## @param material_name: String name of the material
## @param property: String property name
## @param value: Variant property value
## @returns: bool indicating success
func update_material_property(material_name: String, property: String, value) -> bool:
	"""Update a specific property of a material"""
	if not _materials_cache.has(material_name):
		push_warning("[MaterialLibrary] Material not found: " + material_name)
		return false
	
	var material = _materials_cache[material_name]
	
	# Handle standard material properties
	if material is StandardMaterial3D:
		match property:
			"albedo_color":
				material.albedo_color = value
			"metallic":
				material.metallic = value
			"roughness":
				material.roughness = value
			"normal_enabled":
				material.normal_enabled = value
			"normal_scale":
				material.normal_scale = value
			"subsurf_scatter_enabled":
				material.subsurf_scatter_enabled = value
			"subsurf_scatter_strength":
				material.subsurf_scatter_strength = value
			"emission_enabled":
				material.emission_enabled = value
			"emission":
				material.emission = value
			"emission_energy_multiplier":
				material.emission_energy_multiplier = value
			_:
				if material.get(property) != null:
					material.set(property, value)
				else:
					push_warning("[MaterialLibrary] Unknown property: " + property)
					return false
	else:
		# Handle custom shader materials
		if material is ShaderMaterial:
			material.set_shader_parameter(property, value)
	
	# Emit signal
	material_updated.emit(material_name)
	
	return true

# === PRIVATE METHODS ===
func _initialize_library() -> void:
	"""Initialize the material library"""
	# Create materials directory if it doesn't exist
	var dir = DirAccess.open("res://assets")
	if dir:
		if not dir.dir_exists("materials"):
			dir.make_dir("materials")
		if not dir.dir_exists("materials/brain_materials"):
			dir.make_dir("materials/brain_materials")
	
	# Create shaders directory if it doesn't exist
	dir = DirAccess.open("res://assets")
	if dir:
		if not dir.dir_exists("shaders"):
			dir.make_dir("shaders")
		if not dir.dir_exists("shaders/medical"):
			dir.make_dir("shaders/medical")
	
	_initialized = true

func _create_default_materials() -> void:
	"""Create the default set of materials"""
	# Gray matter - slightly pinkish with subsurface scattering
	var gray_matter = _create_brain_material(
		Color(0.85, 0.71, 0.65),  # Pinkish gray
		0.8,  # Higher roughness
		0.0,  # Non-metallic
		true  # Enable subsurface scattering
	)
	_materials_cache["gray_matter"] = gray_matter
	
	# White matter - white with fiber-like quality
	var white_matter = _create_brain_material(
		Color(0.95, 0.95, 0.9),  # Off-white
		0.5,  # Medium roughness
		0.1,  # Slight metallic for fiber-like appearance
		true  # Enable subsurface scattering
	)
	_materials_cache["white_matter"] = white_matter
	
	# Cerebrospinal fluid - transparent blue
	var csf = _create_brain_material(
		Color(0.7, 0.85, 0.95, 0.6),  # Transparent blue
		0.2,  # Low roughness (more glossy)
		0.0,  # Non-metallic
		false  # No subsurface scattering
	)
	csf.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_materials_cache["cerebrospinal_fluid"] = csf
	
	# Blood vessel - dark red
	var blood_vessel = _create_brain_material(
		Color(0.8, 0.1, 0.1),  # Dark red
		0.6,  # Medium roughness
		0.1,  # Slight metallic
		true  # Enable subsurface scattering
	)
	_materials_cache["blood_vessel"] = blood_vessel
	
	# Bone - ivory
	var bone = _create_brain_material(
		Color(0.95, 0.92, 0.88),  # Ivory
		0.6,  # Medium roughness
		0.0,  # Non-metallic
		true  # Enable subsurface scattering
	)
	_materials_cache["bone"] = bone
	
	# Meninges - thin membrane
	var meninges = _create_brain_material(
		Color(0.9, 0.85, 0.8, 0.7),  # Translucent beige
		0.3,  # Low roughness
		0.0,  # Non-metallic
		true  # Enable subsurface scattering
	)
	meninges.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_materials_cache["meninges"] = meninges
	
	# Generic brain tissue
	var generic = _create_brain_material(
		Color(0.8, 0.75, 0.7),  # Neutral beige
		0.7,  # Medium-high roughness
		0.0,  # Non-metallic
		true  # Enable subsurface scattering
	)
	_materials_cache["generic_brain_tissue"] = generic
	
	# Selected structure - highlighted version
	var selected = _create_brain_material(
		Color(0.3, 0.7, 1.0),  # Bright blue
		0.5,  # Medium roughness
		0.3,  # Slight metallic
		false  # No subsurface scattering
	)
	selected.emission_enabled = true
	selected.emission = Color(0.3, 0.7, 1.0, 0.5)
	selected.emission_energy_multiplier = 1.2
	_materials_cache["selected_structure"] = selected
	
	# Highlighted structure (hover)
	var highlighted = _create_brain_material(
		Color(0.9, 0.9, 0.2),  # Yellow
		0.5,  # Medium roughness
		0.1,  # Slight metallic
		false  # No subsurface scattering
	)
	highlighted.emission_enabled = true
	highlighted.emission = Color(0.9, 0.9, 0.2, 0.3)
	highlighted.emission_energy_multiplier = 0.8
	_materials_cache["highlighted_structure"] = highlighted

func _create_brain_material(color: Color, roughness: float, metallic: float, enable_sss: bool) -> StandardMaterial3D:
	"""Create a brain material with the specified properties"""
	var material = StandardMaterial3D.new()
	
	# Basic properties
	material.albedo_color = color
	material.roughness = roughness
	material.metallic = metallic
	
	if enable_sss and quality_level > 0:
		material.subsurf_scatter_enabled = true
		material.subsurf_scatter_strength = subsurface_scattering_strength
		material.subsurf_scatter_skin_mode = false
	
	# Higher quality materials get normal mapping
	if quality_level > 1:
		# We would load normal maps here if available
		pass
	
	return material

func _create_default_material() -> StandardMaterial3D:
	"""Create a default generic material"""
	return _create_brain_material(
		Color(0.8, 0.8, 0.8),  # Light gray
		0.7,  # Medium-high roughness
		0.0,  # Non-metallic
		false  # No subsurface scattering
	)

func _create_material_presets() -> void:
	"""Create material presets for different visualization modes"""
	# Standard educational preset
	_material_presets["educational"] = {
		"gray_matter": {"albedo_color": Color(0.85, 0.71, 0.65), "roughness": 0.8, "subsurf_scatter_enabled": true},
		"white_matter": {"albedo_color": Color(0.95, 0.95, 0.9), "roughness": 0.5, "subsurf_scatter_enabled": true},
		"cerebrospinal_fluid": {"albedo_color": Color(0.7, 0.85, 0.95, 0.6), "roughness": 0.2, "transparency": BaseMaterial3D.TRANSPARENCY_ALPHA},
		"blood_vessel": {"albedo_color": Color(0.8, 0.1, 0.1), "roughness": 0.6, "subsurf_scatter_enabled": true},
		"global_settings": {"subsurface_scattering_strength": 0.3}
	}
	
	# Clinical preset (more subtle, professional)
	_material_presets["clinical"] = {
		"gray_matter": {"albedo_color": Color(0.75, 0.72, 0.70), "roughness": 0.7, "subsurf_scatter_enabled": false},
		"white_matter": {"albedo_color": Color(0.9, 0.9, 0.88), "roughness": 0.6, "subsurf_scatter_enabled": false},
		"cerebrospinal_fluid": {"albedo_color": Color(0.8, 0.85, 0.9, 0.5), "roughness": 0.3, "transparency": BaseMaterial3D.TRANSPARENCY_ALPHA},
		"blood_vessel": {"albedo_color": Color(0.7, 0.2, 0.2), "roughness": 0.7, "subsurf_scatter_enabled": false},
		"global_settings": {"subsurface_scattering_strength": 0.1}
	}
	
	# High contrast preset (for accessibility)
	_material_presets["high_contrast"] = {
		"gray_matter": {"albedo_color": Color(0.9, 0.6, 0.6), "roughness": 0.5, "subsurf_scatter_enabled": false},
		"white_matter": {"albedo_color": Color(1.0, 1.0, 0.9), "roughness": 0.5, "subsurf_scatter_enabled": false},
		"cerebrospinal_fluid": {"albedo_color": Color(0.4, 0.7, 1.0, 0.7), "roughness": 0.3, "transparency": BaseMaterial3D.TRANSPARENCY_ALPHA},
		"blood_vessel": {"albedo_color": Color(0.9, 0.1, 0.1), "roughness": 0.5, "subsurf_scatter_enabled": false},
		"global_settings": {"subsurface_scattering_strength": 0.0}
	}

func _apply_preset_to_material(material: Material, preset: Dictionary) -> void:
	"""Apply preset settings to a specific material"""
	# Skip if not a StandardMaterial3D
	if not material is StandardMaterial3D:
		return
	
	# Apply global settings
	if preset.has("global_settings"):
		var globals = preset.global_settings
		if globals.has("subsurface_scattering_strength"):
			subsurface_scattering_strength = globals.subsurface_scattering_strength
	
	# Find material name
	var material_name = ""
	for key in _materials_cache:
		if _materials_cache[key] == material:
			material_name = key
			break
	
	if material_name.is_empty():
		return
	
	# Apply specific settings for this material
	if preset.has(material_name):
		var settings = preset[material_name]
		
		for property in settings:
			match property:
				"albedo_color":
					material.albedo_color = settings.albedo_color
				"roughness":
					material.roughness = settings.roughness
				"metallic":
					material.metallic = settings.metallic
				"subsurf_scatter_enabled":
					material.subsurf_scatter_enabled = settings.subsurf_scatter_enabled
					if material.subsurf_scatter_enabled:
						material.subsurf_scatter_strength = subsurface_scattering_strength
				"transparency":
					material.transparency = settings.transparency
				_:
					if material.get(property) != null:
						material.set(property, settings[property])

func _recreate_materials_for_quality() -> void:
	"""Recreate all materials based on current quality level"""
	var material_names = _materials_cache.keys()
	
	for name in material_names:
		var old_material = _materials_cache[name]
		var color = old_material.albedo_color
		var roughness = old_material.roughness
		var metallic = old_material.metallic
		var enable_sss = old_material.subsurf_scatter_enabled
		
		# Create new material with current quality settings
		var new_material = _create_brain_material(color, roughness, metallic, enable_sss)
		
		# Copy additional properties if needed
		if old_material.emission_enabled:
			new_material.emission_enabled = true
			new_material.emission = old_material.emission
			new_material.emission_energy_multiplier = old_material.emission_energy_multiplier
		
		if old_material.transparency != BaseMaterial3D.TRANSPARENCY_DISABLED:
			new_material.transparency = old_material.transparency
		
		# Replace in cache
		_materials_cache[name] = new_material