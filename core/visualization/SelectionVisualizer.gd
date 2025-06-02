## SelectionVisualizer.gd
## Advanced visual feedback system for brain structure selection
##
## Provides professional-grade visual feedback for selected anatomical
## structures with configurable effects optimized for educational clarity.
##
## @tutorial: docs/dev/selection-visualization.md
## @experimental: false

class_name SelectionVisualizer
extends Node

# === CONSTANTS ===
## Shader for standard selection highlighting
const SELECTION_SHADER_PATH: String = "res://assets/shaders/medical/selection_highlight.gdshader"

## Material for selection outline effect
const OUTLINE_MATERIAL_PATH: String = "res://assets/materials/brain_materials/selection_outline.tres"

## Default highlight colors
const DEFAULT_PRIMARY_COLOR: Color = Color(0.3, 0.7, 1.0, 0.5)
const DEFAULT_SECONDARY_COLOR: Color = Color(0.9, 0.9, 0.2, 0.5)
const DEFAULT_MULTI_SELECT_COLOR: Color = Color(0.8, 0.4, 0.9, 0.5)

# === SIGNALS ===
## Emitted when a structure is highlighted
## @param structure_name: String name of highlighted structure
## @param mesh_instance: MeshInstance3D that was highlighted
signal structure_highlighted(structure_name: String, mesh_instance: MeshInstance3D)

## Emitted when a highlight is cleared
## @param structure_name: String name of structure no longer highlighted
signal highlight_cleared(structure_name: String)

## Emitted when visualization settings change
## @param setting_name: String name of changed setting
signal visualization_setting_changed(setting_name: String)

# === EXPORTS ===
## Primary selection color
@export var primary_color: Color = DEFAULT_PRIMARY_COLOR:
	set(value):
		primary_color = value
		_update_material_colors()
		visualization_setting_changed.emit("primary_color")

## Secondary (hover) color
@export var secondary_color: Color = DEFAULT_SECONDARY_COLOR:
	set(value):
		secondary_color = value
		_update_material_colors()
		visualization_setting_changed.emit("secondary_color")

## Multi-selection color
@export var multi_select_color: Color = DEFAULT_MULTI_SELECT_COLOR:
	set(value):
		multi_select_color = value
		_update_material_colors()
		visualization_setting_changed.emit("multi_select_color")

## Enable selection pulse animation
@export var enable_pulse: bool = true:
	set(value):
		enable_pulse = value
		_update_all_materials()
		visualization_setting_changed.emit("enable_pulse")

## Pulse speed for animation
@export_range(0.5, 5.0, 0.1) var pulse_speed: float = 3.0:
	set(value):
		pulse_speed = value
		_update_all_materials()
		visualization_setting_changed.emit("pulse_speed")

## Highlight intensity
@export_range(0.1, 2.0, 0.1) var highlight_intensity: float = 1.0:
	set(value):
		highlight_intensity = value
		_update_all_materials()
		visualization_setting_changed.emit("highlight_intensity")

## Enable outline effect
@export var enable_outline: bool = true:
	set(value):
		enable_outline = value
		_update_outline_visibility()
		visualization_setting_changed.emit("enable_outline")

## Enable educational mode (enhanced visualization)
@export var educational_mode: bool = true:
	set(value):
		educational_mode = value
		_update_all_materials()
		visualization_setting_changed.emit("educational_mode")

## Use shader-based selection (vs material swapping)
@export var use_shader_selection: bool = true:
	set(value):
		if use_shader_selection != value:
			use_shader_selection = value
			_recreate_highlighted_structures()
			visualization_setting_changed.emit("use_shader_selection")

# === PUBLIC VARIABLES ===
## Whether depth fade effect is enabled for selection visualization
var depth_fade_enabled: bool = true

# === PRIVATE VARIABLES ===
var _selection_shader: Shader
var _outline_material: Material
var _highlighted_structures: Dictionary = {}
var _original_materials: Dictionary = {}
var _highlight_materials: Dictionary = {}
var _outline_meshes: Dictionary = {}
var _initialized: bool = false

# === LIFECYCLE METHODS ===
func _ready() -> void:
	"""Initialize the selection visualizer"""
	_load_resources()
	_initialized = true
	print("[SelectionVisualizer] Initialized")

# === PUBLIC METHODS ===
## Highlight a structure with visual feedback
## @param mesh_instance: MeshInstance3D to highlight
## @param structure_name: String name of the structure
## @param is_primary: bool whether this is primary selection (vs hover)
## @param selection_index: int index for multi-selection color variation
## @returns: bool indicating success
func highlight_structure(mesh_instance: MeshInstance3D, structure_name: String, 
		is_primary: bool = true, selection_index: int = 0) -> bool:
	"""Highlight a structure with visual feedback"""
	if not _initialized or not mesh_instance or not mesh_instance.is_inside_tree():
		return false
	
	# Check if already highlighted
	if _highlighted_structures.has(structure_name):
		var existing_data = _highlighted_structures[structure_name]
		
		# Update if same mesh but different highlight type
		if existing_data.mesh_instance == mesh_instance and existing_data.is_primary != is_primary:
			existing_data.is_primary = is_primary
			_update_highlight_material(structure_name, is_primary, selection_index)
			return true
		
		# If different mesh, clear the old one first
		clear_highlight(structure_name)
	
	# Choose highlighting method based on settings
	if use_shader_selection:
		_highlight_with_shader(mesh_instance, structure_name, is_primary, selection_index)
	else:
		_highlight_with_material_swap(mesh_instance, structure_name, is_primary, selection_index)
	
	# Add outline effect if enabled
	if enable_outline:
		_add_outline_effect(mesh_instance, structure_name)
	
	# Store highlight data
	_highlighted_structures[structure_name] = {
		"mesh_instance": mesh_instance,
		"is_primary": is_primary,
		"selection_index": selection_index
	}
	
	# Emit signal
	structure_highlighted.emit(structure_name, mesh_instance)
	
	return true

## Clear highlight from a structure
## @param structure_name: String name of the structure to clear
## @returns: bool indicating success
func clear_highlight(structure_name: String) -> bool:
	"""Clear highlight from a structure"""
	if not _highlighted_structures.has(structure_name):
		return false
	
	var highlight_data = _highlighted_structures[structure_name]
	var mesh_instance = highlight_data.mesh_instance
	
	# Restore original material if using material swap
	if not use_shader_selection and _original_materials.has(structure_name):
		var original_materials = _original_materials[structure_name]
		
		for i in range(original_materials.size()):
			if mesh_instance and mesh_instance.is_inside_tree():
				mesh_instance.set_surface_override_material(i, original_materials[i])
		
		_original_materials.erase(structure_name)
	
	# Remove overlay mesh if using shader
	if use_shader_selection and mesh_instance and mesh_instance.is_inside_tree():
		var parent = mesh_instance.get_parent()
		var overlay_name = mesh_instance.name + "_highlight_overlay"
		
		if parent.has_node(overlay_name):
			var overlay = parent.get_node(overlay_name)
			parent.remove_child(overlay)
			overlay.queue_free()
	
	# Remove outline if present
	if _outline_meshes.has(structure_name):
		var outline_mesh = _outline_meshes[structure_name]
		if outline_mesh and outline_mesh.is_inside_tree():
			var parent = outline_mesh.get_parent()
			parent.remove_child(outline_mesh)
			outline_mesh.queue_free()
		
		_outline_meshes.erase(structure_name)
	
	# Remove from highlighted structures
	_highlighted_structures.erase(structure_name)
	
	# Clean up cached highlight materials
	if _highlight_materials.has(structure_name):
		_highlight_materials.erase(structure_name)
	
	# Emit signal
	highlight_cleared.emit(structure_name)
	
	return true

## Clear all highlights
## @returns: bool indicating success
func clear_all_highlights() -> bool:
	"""Clear all structure highlights"""
	var structure_names = _highlighted_structures.keys()
	
	for structure_name in structure_names:
		clear_highlight(structure_name)
	
	return true

## Check if a structure is highlighted
## @param structure_name: String name of the structure
## @returns: bool indicating if structure is highlighted
func is_structure_highlighted(structure_name: String) -> bool:
	"""Check if a structure is currently highlighted"""
	return _highlighted_structures.has(structure_name)

## Create a custom highlight material
## @param color: Color for highlight
## @param intensity: float intensity of highlight
## @param with_pulse: bool whether to enable pulse animation
## @returns: Material configured with requested properties
func create_highlight_material(color: Color, intensity: float = 1.0, with_pulse: bool = true) -> Material:
	"""Create a custom highlight material for special cases"""
	if not _selection_shader:
		push_warning("[SelectionVisualizer] Selection shader not loaded")
		return null
	
	var material = ShaderMaterial.new()
	material.shader = _selection_shader
	
	# Configure shader parameters
	material.set_shader_parameter("highlight_color", color)
	material.set_shader_parameter("highlight_intensity", intensity)
	material.set_shader_parameter("enable_pulse", with_pulse)
	material.set_shader_parameter("pulse_speed", pulse_speed)
	material.set_shader_parameter("educational_mode", educational_mode)
	material.set_shader_parameter("depth_fade_enabled", depth_fade_enabled)
	
	return material

## Update visualization settings
## @param settings: Dictionary of settings to update
## @returns: bool indicating success
func update_settings(settings: Dictionary) -> bool:
	"""Update multiple visualization settings at once"""
	if settings.has("primary_color"):
		primary_color = settings.primary_color
	
	if settings.has("secondary_color"):
		secondary_color = settings.secondary_color
	
	if settings.has("multi_select_color"):
		multi_select_color = settings.multi_select_color
	
	if settings.has("enable_pulse"):
		enable_pulse = settings.enable_pulse
	
	if settings.has("pulse_speed"):
		pulse_speed = settings.pulse_speed
	
	if settings.has("highlight_intensity"):
		highlight_intensity = settings.highlight_intensity
	
	if settings.has("enable_outline"):
		enable_outline = settings.enable_outline
	
	if settings.has("educational_mode"):
		educational_mode = settings.educational_mode
	
	if settings.has("depth_fade_enabled"):
		depth_fade_enabled = settings.depth_fade_enabled
		_update_all_materials()
	
	# If visualization method changed, recreate all highlights
	if settings.has("use_shader_selection") and settings.use_shader_selection != use_shader_selection:
		use_shader_selection = settings.use_shader_selection
		_recreate_highlighted_structures()
	
	return true

# === PRIVATE METHODS ===
func _load_resources() -> void:
	"""Load required shader and material resources"""
	# Load selection shader
	_selection_shader = load(SELECTION_SHADER_PATH)
	if not _selection_shader:
		push_error("[SelectionVisualizer] Failed to load selection shader: " + SELECTION_SHADER_PATH)
	
	# Load or create outline material
	if ResourceLoader.exists(OUTLINE_MATERIAL_PATH):
		_outline_material = load(OUTLINE_MATERIAL_PATH)
	else:
		# Create default outline material if not found
		_outline_material = StandardMaterial3D.new()
		_outline_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		_outline_material.albedo_color = Color(1, 1, 1, 1)
		_outline_material.cull_mode = BaseMaterial3D.CULL_FRONT
		
		# Save for future use
		var dir = DirAccess.open("res://assets/materials/brain_materials")
		if not dir:
			var parent_dir = DirAccess.open("res://assets/materials")
			if not parent_dir:
				parent_dir = DirAccess.open("res://assets")
				parent_dir.make_dir("materials")
			
			parent_dir = DirAccess.open("res://assets/materials")
			parent_dir.make_dir("brain_materials")
		
		ResourceSaver.save(_outline_material, OUTLINE_MATERIAL_PATH)

func _highlight_with_shader(mesh_instance: MeshInstance3D, structure_name: String, 
		is_primary: bool, selection_index: int) -> void:
	"""Highlight a structure using a shader overlay approach"""
	if not mesh_instance or not mesh_instance.is_inside_tree() or not mesh_instance.mesh:
		return
	
	var parent = mesh_instance.get_parent()
	var highlight_color = _get_highlight_color(is_primary, selection_index)
	
	# Create a duplicate mesh for the highlight effect
	var overlay = MeshInstance3D.new()
	overlay.name = mesh_instance.name + "_highlight_overlay"
	overlay.mesh = mesh_instance.mesh
	overlay.global_transform = mesh_instance.global_transform
	
	# Create and configure highlight shader material
	var material = ShaderMaterial.new()
	material.shader = _selection_shader
	
	# Set shader parameters
	material.set_shader_parameter("highlight_color", highlight_color)
	material.set_shader_parameter("highlight_intensity", highlight_intensity)
	material.set_shader_parameter("enable_pulse", enable_pulse)
	material.set_shader_parameter("pulse_speed", pulse_speed)
	material.set_shader_parameter("outline_only", false)
	material.set_shader_parameter("educational_mode", educational_mode)
	material.set_shader_parameter("multi_selection", selection_index > 0)
	material.set_shader_parameter("selection_index", selection_index)
	material.set_shader_parameter("depth_fade_enabled", depth_fade_enabled)
	
	# Store for future updates
	_highlight_materials[structure_name] = material
	
	# Apply to all surfaces
	for i in range(mesh_instance.mesh.get_surface_count()):
		overlay.set_surface_override_material(i, material)
	
	# Add to scene
	parent.add_child(overlay)

func _highlight_with_material_swap(mesh_instance: MeshInstance3D, structure_name: String,
		is_primary: bool, selection_index: int) -> void:
	"""Highlight a structure by swapping its materials"""
	if not mesh_instance or not mesh_instance.is_inside_tree() or not mesh_instance.mesh:
		return
	
	var highlight_color = _get_highlight_color(is_primary, selection_index)
	
	# Store original materials
	var original_materials = []
	for i in range(mesh_instance.get_surface_override_material_count()):
		original_materials.append(mesh_instance.get_surface_override_material(i))
	
	_original_materials[structure_name] = original_materials
	
	# Create highlight material
	var highlight_material = StandardMaterial3D.new()
	highlight_material.albedo_color = highlight_color
	highlight_material.emission_enabled = true
	highlight_material.emission = highlight_color
	highlight_material.emission_energy_multiplier = highlight_intensity
	
	if enable_pulse:
		# Note: Material swap method doesn't support pulse animation
		# We'd need to manually animate in _process
		pass
	
	# Store for future updates
	_highlight_materials[structure_name] = highlight_material
	
	# Apply to all surfaces
	for i in range(mesh_instance.mesh.get_surface_count()):
		mesh_instance.set_surface_override_material(i, highlight_material)

func _add_outline_effect(mesh_instance: MeshInstance3D, structure_name: String) -> void:
	"""Add outline effect to a highlighted structure"""
	if not mesh_instance or not mesh_instance.is_inside_tree() or not mesh_instance.mesh:
		return
	
	var parent = mesh_instance.get_parent()
	
	# Create outline mesh (slightly larger version of original)
	var outline = MeshInstance3D.new()
	outline.name = mesh_instance.name + "_outline"
	outline.mesh = mesh_instance.mesh
	outline.global_transform = mesh_instance.global_transform
	
	# Scale slightly larger for outline effect
	outline.scale = mesh_instance.scale * 1.05
	
	# Apply outline material
	for i in range(mesh_instance.mesh.get_surface_count()):
		outline.set_surface_override_material(i, _outline_material)
	
	# Add to scene
	parent.add_child(outline)
	
	# Store for cleanup
	_outline_meshes[structure_name] = outline

func _get_highlight_color(is_primary: bool, selection_index: int) -> Color:
	"""Get appropriate highlight color based on selection state"""
	if selection_index > 0:
		return multi_select_color
	elif is_primary:
		return primary_color
	else:
		return secondary_color

func _update_material_colors() -> void:
	"""Update all highlight material colors"""
	for structure_name in _highlighted_structures:
		var highlight_data = _highlighted_structures[structure_name]
		_update_highlight_material(structure_name, highlight_data.is_primary, highlight_data.selection_index)

func _update_highlight_material(structure_name: String, is_primary: bool, selection_index: int) -> void:
	"""Update a specific highlight material"""
	if not _highlight_materials.has(structure_name):
		return
	
	var material = _highlight_materials[structure_name]
	var highlight_color = _get_highlight_color(is_primary, selection_index)
	
	if material is ShaderMaterial:
		material.set_shader_parameter("highlight_color", highlight_color)
		material.set_shader_parameter("multi_selection", selection_index > 0)
		material.set_shader_parameter("selection_index", selection_index)
	elif material is StandardMaterial3D:
		material.albedo_color = highlight_color
		material.emission = highlight_color

func _update_all_materials() -> void:
	"""Update all highlight materials with current settings"""
	for structure_name in _highlight_materials:
		var material = _highlight_materials[structure_name]
		var highlight_data = _highlighted_structures.get(structure_name)
		
		if not highlight_data:
			continue
		
		if material is ShaderMaterial:
			material.set_shader_parameter("highlight_intensity", highlight_intensity)
			material.set_shader_parameter("enable_pulse", enable_pulse)
			material.set_shader_parameter("pulse_speed", pulse_speed)
			material.set_shader_parameter("educational_mode", educational_mode)
			material.set_shader_parameter("depth_fade_enabled", depth_fade_enabled)
		elif material is StandardMaterial3D:
			material.emission_energy_multiplier = highlight_intensity

func _update_outline_visibility() -> void:
	"""Update visibility of all outline effects"""
	for structure_name in _outline_meshes:
		var outline_mesh = _outline_meshes[structure_name]
		if outline_mesh and outline_mesh.is_inside_tree():
			outline_mesh.visible = enable_outline

func _recreate_highlighted_structures() -> void:
	"""Recreate all highlighted structures after switching visualization method"""
	var structures_to_recreate = {}
	
	# Store current highlight data
	for structure_name in _highlighted_structures:
		structures_to_recreate[structure_name] = _highlighted_structures[structure_name].duplicate()
	
	# Clear all highlights
	clear_all_highlights()
	
	# Recreate highlights with new method
	for structure_name in structures_to_recreate:
		var data = structures_to_recreate[structure_name]
		highlight_structure(data.mesh_instance, structure_name, data.is_primary, data.selection_index)