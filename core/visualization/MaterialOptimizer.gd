## MaterialOptimizer.gd
## Optimizes material usage for educational brain visualization
##
## This system reduces draw calls by batching similar materials,
## caching shared resources, and managing material quality based
## on educational importance and device capabilities.
##
## @tutorial: Educational material optimization techniques
## @version: 1.0

class_name MaterialOptimizer
extends Node

# === SIGNALS ===
## Emitted when optimization level changes

signal optimization_level_changed(level: int)

## Emitted when material stats are updated
signal material_stats_updated(stats: Dictionary)

# === CONSTANTS ===
## Material optimization levels for different device capabilities

enum OptimizationLevel {
QUALITY,     # Highest quality materials, individual control
BALANCED,    # Good balance of quality and performance
PERFORMANCE  # Maximum performance, aggressive material sharing
}

# === EXPORTS ===
## Current optimization level

@export var current_level: OptimizationLevel = OptimizationLevel.BALANCED:
	set(value):
@export var educational_context_awareness: bool = true

## Material variation for educational uniqueness
@export_range(0.0, 1.0) var material_variation: float = 0.3:
	set(value):
		material_variation = value
		_update_material_variations()

		## Color brightness for educational visibility
@export_range(0.5, 1.5) var brightness_factor: float = 1.0:
	set(value):
		brightness_factor = value
		_apply_brightness_adjustment()

		# === PRIVATE VARIABLES ===

var structure = _priority_structures[structure_name].node
	_optimize_structure_materials(structure, structure_name)

# FIXED: Orphaned code - var base_material = StandardMaterial3D.new()

# Apply properties to base material
var structure_2 = _priority_structures[structure_name].node
	_apply_batch_material(structure, batch_name, true)

	_material_stats.batched_groups += 1
	material_stats_updated.emit(_material_stats)

# FIXED: Orphaned code - var structure_3 = _priority_structures[structure_name].node
var original_materials = _original_materials[structure_name]

var node_path = NodePath(node_path_str)
# FIXED: Orphaned code - var node = structure.get_node_or_null(node_path)

# FIXED: Orphaned code - var materials = original_materials[node_path_str]

# Apply original materials
var structure_4 = _priority_structures[structure_name].node
	_optimize_structure_materials(structure, structure_name)

	_update_material_stats()
# FIXED: Orphaned code - var node_path_2 = node.get_path_to(node)
# FIXED: Orphaned code - var node_path_str = node_path.get_as_property_path()

# FIXED: Orphaned code - var materials_2 = []
var structure_5 = _priority_structures[structure_name].node
	_optimize_structure_materials(structure, structure_name)

	_update_material_stats()
	material_stats_updated.emit(_material_stats)

	## Apply optimization to a specific structure
var priority = _priority_structures[structure_name].priority

# Apply different strategies based on optimization level
OptimizationLevel.QUALITY:
	# Quality mode - use original materials with minimal sharing
var cache_key = _get_material_hash(original_material)

# FIXED: Orphaned code - var similarity_threshold = 0.8  # 80% similarity

# Find similar material or create new
var shared_material = _find_similar_material(original_material, similarity_threshold)

# FIXED: Orphaned code - var optimized = _create_optimized_material(original_material, priority)

# Cache the new material
var cache_key_2 = _get_material_hash(optimized)
	_material_cache[cache_key] = optimized

	# Apply optimized material
	mesh_instance.set_surface_override_material(material_idx, optimized)
	)

	## Apply performance-focused optimization
var similarity_threshold_2 = 0.6  # 60% similarity

# Educational priority influences sharing
var shared_material_2 = _find_similar_material(original_material, similarity_threshold)

# FIXED: Orphaned code - var simplified = _create_simplified_material(original_material, priority)

# Cache the new material
var cache_key_3 = _get_material_hash(simplified)
	_material_cache[cache_key] = simplified

	# Apply simplified material
	mesh_instance.set_surface_override_material(material_idx, simplified)
	)

	## Process all materials in a structure
var material = node.get_surface_override_material(i)
# FIXED: Orphaned code - var batch = _material_batches[batch_name]
var batch_material = batch.material

# If educational context aware, check if we need a variation
var structure_name = structure.name

# Create variation if needed
var variation = batch_material.duplicate()

# Apply subtle variation
var base_color = variation.albedo_color
var variation_color = base_color

# Vary the color slightly
	variation_color = Color(
	clamp(base_color.r + (randf() - 0.5) * material_variation * 0.2, 0, 1),
	clamp(base_color.g + (randf() - 0.5) * material_variation * 0.2, 0, 1),
	clamp(base_color.b + (randf() - 0.5) * material_variation * 0.2, 0, 1),
	base_color.a
	)

	variation.albedo_color = variation_color

	batch.variations[structure_name] = variation

	# Apply variation material to all meshes
	_apply_material_to_structure(structure, batch.variations[structure_name])
	# Apply shared batch material to all meshes
	_apply_material_to_structure(structure, batch_material)

	## Apply a material to all meshes in a structure
var best_match = null
var best_score = 0.0

var cached_material = _material_cache[cache_key]

var similarity = _calculate_material_similarity(material, cached_material)

# FIXED: Orphaned code - var score = 0.0
var total_factors = 6.0  # Number of factors we're considering

var mat_a = material_a as StandardMaterial3D
var mat_b = material_b as StandardMaterial3D

# Compare albedo color (most important)
# FIXED: Orphaned code - var color_similarity = 1.0 - mat_a.albedo_color.distance_to(mat_b.albedo_color)
	score += color_similarity * 2.0  # Double weight for color
	total_factors += 1.0  # Adjust for double weight

	# Compare metallic property
var metallic_similarity = 1.0 - abs(mat_a.metallic - mat_b.metallic)
	score += metallic_similarity

	# Compare roughness
var roughness_similarity = 1.0 - abs(mat_a.roughness - mat_b.roughness)
	score += roughness_similarity

	# Compare transparency mode (exact match check)
# FIXED: Orphaned code - var transparency_match = int(mat_a.transparency) == int(mat_b.transparency)
	score += 1.0 if transparency_match else 0.0

	# Compare shading mode
var shading_match = int(mat_a.shading_mode) == int(mat_b.shading_mode)
	score += 1.0 if shading_match else 0.0

	# Compare emission (important for highlighted educational structures)
# FIXED: Orphaned code - var emission_similarity = 1.0 - mat_a.emission.distance_to(mat_b.emission)
	score += emission_similarity

var optimized_2 = original.duplicate() as StandardMaterial3D

# Optimization settings based on priority
var simplified_2 = original.duplicate() as StandardMaterial3D

# Apply aggressive simplifications
	simplified.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	simplified.disable_ambient_light = true
	simplified.disable_receive_shadows = true
	simplified.roughness = 1.0  # Maximize roughness for performance

	# Only keep emission if high priority (for highlighting)
# FIXED: Orphaned code - var mat = material as StandardMaterial3D
var hash_parts = []

# Include key properties in hash
	hash_parts.append(str(mat.albedo_color))
	hash_parts.append(str(mat.metallic))
	hash_parts.append(str(mat.roughness))
	hash_parts.append(str(mat.transparency))
	hash_parts.append(str(mat.shading_mode))

# FIXED: Orphaned code - var batch_2 = _material_batches[batch_name]

# Clear existing variations if variation is 0
var structure_6 = _priority_structures[structure_name].node
	_apply_material_to_structure(structure, batch.material)


	# Update variations for each structure
var structure_7 = _priority_structures[structure_name].node

# Create variation if needed
var variation_2 = batch.material.duplicate()

# Apply variation
var base_color_2 = variation.albedo_color
var variation_color_2 = Color(
	clamp(base_color.r + (randf() - 0.5) * material_variation * 0.2, 0, 1),
	clamp(base_color.g + (randf() - 0.5) * material_variation * 0.2, 0, 1),
	clamp(base_color.b + (randf() - 0.5) * material_variation * 0.2, 0, 1),
	base_color.a
	)

	variation.albedo_color = variation_color

	batch.variations[structure_name] = variation

	# Apply variation
	_apply_material_to_structure(structure, batch.variations[structure_name])

	## Apply brightness adjustment to all materials
var batch_3 = _material_batches[batch_name]
	_adjust_material_brightness(batch.material, brightness_factor)

	# Adjust variations too
var std_material = material as StandardMaterial3D

# Adjust albedo brightness
var albedo = std_material.albedo_color
var hsv = Color.from_hsv(albedo.h, albedo.s, clamp(albedo.v * factor, 0.0, 1.0), albedo.a)
	std_material.albedo_color = hsv

	# Adjust emission if enabled
var emission = std_material.emission
	std_material.emission = emission * factor

	## Update material optimization statistics
var total_materials = 0
var batched_materials = 0

# Count original materials
var structure_materials = _original_materials[structure_name]
var batch_4 = _material_batches[batch_name]

# Count how many structures are in this batch
var structures_in_batch = batch.structures.size()

# Estimate how many materials would have been used
var batch_original_count = 0
var structure_materials_2 = _original_materials[structure_name]
var shared_count = _material_cache.size()
# FIXED: Orphaned code - var estimated_original = total_materials
var estimated_optimized = shared_count + (total_materials - batched_materials)
# FIXED: Orphaned code - var draw_call_reduction = estimated_original - estimated_optimized

# Update stats
	_material_stats.total_materials = total_materials
	_material_stats.shared_materials = shared_count
	_material_stats.batched_groups = _material_batches.size()
	_material_stats.draw_call_reduction = draw_call_reduction
	_material_stats.memory_saved = draw_call_reduction * 2048  # Rough estimate: 2KB per material

	# Emit update signal
	material_stats_updated.emit(_material_stats)

	## Integrate with LOD system if available
var lod_system = get_node_or_null("../LODSystem")
# FIXED: Orphaned code - var structure_8 = _priority_structures[structure_name].node
var current_priority = _priority_structures[structure_name].priority

# Adjust priority based on LOD level
var adjusted_priority = current_priority
var mapped_priority
	0:  # LODSystemEnhanced.StructurePriority.PRIMARY
	mapped_priority = 4  # Highest priority
	1:  # LODSystemEnhanced.StructurePriority.SECONDARY
	mapped_priority = 3  # High priority
	2:  # LODSystemEnhanced.StructurePriority.SUPPORTING
	mapped_priority = 2  # Medium priority
	_:  # LODSystemEnhanced.StructurePriority.BACKGROUND
	mapped_priority = 1  # Low priority

	# Update priority and optimize
	update_structure_priority(structure_name, mapped_priority)

# FIXED: Orphaned code - var _material_cache: Dictionary = {}
# FIXED: Orphaned code - var _material_batches: Dictionary = {}
# FIXED: Orphaned code - var _material_stats: Dictionary = {
	"total_materials": 0,
	"shared_materials": 0,
	"batched_groups": 0,
	"draw_call_reduction": 0,
	"memory_saved": 0
	}

# FIXED: Orphaned code - var _priority_structures: Dictionary = {}
# FIXED: Orphaned code - var _original_materials: Dictionary = {}
# FIXED: Orphaned code - var _initialized: bool = false

# === LIFECYCLE METHODS ===

func _ready() -> void:
	print("[MaterialOptimizer] Initializing educational material optimization")
	await get_tree().process_frame
	_initialized = true
	_apply_optimization_level()
	print("[MaterialOptimizer] Initialized with " + OptimizationLevel.keys()[current_level] + " optimization")

	# === PUBLIC METHODS ===
	## Register a structure for material optimization
	## @param structure: Node3D root of the structure
	## @param structure_name: String name of the structure
	## @param priority: int priority level (higher = more educational importance)
	## @returns: bool indicating success
func _process_structure_materials(structure: Node3D, structure_name: String, process_func: Callable) -> void:
	"""Apply material processing function to all materials in structure"""
	if not structure or not structure.is_inside_tree():
		return

		# Check if part of batch first
		for batch_name in _material_batches:
			if structure_name in _material_batches[batch_name].structures:
				_apply_batch_material(structure, batch_name)
				return

				# Process individual materials
				_process_node_materials(structure, structure_name, process_func)

				## Process materials in a node and its children
func _process_node_materials(node: Node, structure_name: String, process_func: Callable) -> void:
	"""Recursively process materials in a node hierarchy"""
	if node is MeshInstance3D and node.mesh != null:
		for i in range(node.get_surface_override_material_count()):

func register_structure(structure: Node3D, structure_name: String, priority: int = 1) -> bool:
	"""Register a brain structure for educational material optimization"""
	if not structure or not structure.is_inside_tree():
		push_warning("[MaterialOptimizer] Cannot register invalid structure: " + structure_name)
		return false

		print("[MaterialOptimizer] Registering structure: " + structure_name)

		# Store structure priority
		_priority_structures[structure_name] = {
		"node": structure,
		"priority": priority
		}

		# Store original materials
		_store_original_materials(structure, structure_name)

		# Apply current optimization level
		_optimize_structure_materials(structure, structure_name)

		return true

		## Update structure educational priority
		## @param structure_name: String name of the structure
		## @param priority: int priority level (higher = more educational importance)
		## @returns: bool indicating success
func update_structure_priority(structure_name: String, priority: int) -> bool:
	"""Update the educational priority of a structure"""
	if not _priority_structures.has(structure_name):
		push_warning("[MaterialOptimizer] Structure not registered: " + structure_name)
		return false

		if _priority_structures[structure_name].priority == priority:
			return true  # No change needed

			_priority_structures[structure_name].priority = priority

			# If using educational context, adjust materials based on new priority
			if educational_context_awareness:
func create_material_batch(material_properties: Dictionary, structures: Array, batch_name: String) -> bool:
	"""Create a shared material batch for related educational structures"""
	if material_properties.is_empty() or structures.is_empty() or batch_name.is_empty():
		push_warning("[MaterialOptimizer] Invalid batch parameters")
		return false

		print("[MaterialOptimizer] Creating material batch: " + batch_name)

		# Create base material
func restore_original_materials(structure_name: String) -> bool:
	"""Restore original educational materials to a structure"""
	if not _priority_structures.has(structure_name) or not _original_materials.has(structure_name):
		push_warning("[MaterialOptimizer] Cannot restore materials for: " + structure_name)
		return false

		print("[MaterialOptimizer] Restoring original materials for: " + structure_name)

func update_optimization_strategy(strategy_level: OptimizationLevel) -> bool:
	"""Update material optimization strategy for educational performance"""
	if strategy_level == current_level:
		return true  # No change needed

		current_level = strategy_level
		_apply_optimization_level()

		print("[MaterialOptimizer] Updated to " + OptimizationLevel.keys()[current_level] + " optimization")
		return true

		## Get material optimization statistics
		## @returns: Dictionary with optimization statistics
func get_optimization_stats() -> Dictionary:
	"""Get educational material optimization metrics"""
	_update_material_stats()
	return _material_stats.duplicate()

	## Force refresh all materials
	## @returns: bool indicating success
func refresh_all_materials() -> bool:
	"""Refresh all educational structure materials"""
	if not _initialized:
		push_warning("[MaterialOptimizer] Cannot refresh - system not initialized")
		return false

		for structure_name in _priority_structures:

if current_level != value:
	current_level = value
	_apply_optimization_level()
	optimization_level_changed.emit(current_level)

	## Enable educational material context awareness
return true

## Create a shared material batch
## @param material_properties: Dictionary of properties to match
## @param structures: Array of structure names to apply to
## @param batch_name: String identifier for the batch
## @returns: bool indicating success
for property in material_properties:
	if property in base_material:
		base_material.set(property, material_properties[property])

		# Create batch entry
		_material_batches[batch_name] = {
		"material": base_material,
		"structures": structures,
		"variations": {}
		}

		# Apply to structures
		for structure_name in structures:
			if _priority_structures.has(structure_name):
return true

## Restore original materials for a structure
## @param structure_name: String name of the structure
## @returns: bool indicating success
for node_path_str in original_materials:
if node and node is MeshInstance3D:
for i in range(materials.size()):
	if i < node.get_surface_override_material_count():
		node.set_surface_override_material(i, materials[i])

		return true

		## Update memory strategy to handle material quality vs. performance
		## @param strategy_level: OptimizationLevel to apply
		## @returns: bool indicating success
return true

# === PRIVATE METHODS ===
## Store original materials for future restoration
for i in range(node.get_surface_override_material_count()):
	materials.append(node.get_surface_override_material(i))

	if not materials.is_empty():
		_original_materials[structure_name][node_path_str] = materials.duplicate()

		# Process children
		for child in node.get_children():
			_store_node_materials(child, structure_name)

			## Apply optimization based on current level
if priority > 2:
	# High priority educational structures keep original materials
	restore_original_materials(structure_name)
	else:
		# Other structures use minimal optimization
		_apply_quality_optimization(structure, structure_name)

		OptimizationLevel.BALANCED:
			# Balanced mode - moderate sharing based on priority
			if priority > 3:
				# Very high educational priority keeps original materials
				restore_original_materials(structure_name)
				else:
					_apply_balanced_optimization(structure, structure_name, priority)

					OptimizationLevel.PERFORMANCE:
						# Performance mode - aggressive sharing and simplification
						_apply_performance_optimization(structure, structure_name, priority)

						## Apply quality-focused optimization
if _material_cache.has(cache_key):
	# Use cached material only for exact duplicates
	mesh_instance.set_surface_override_material(material_idx, _material_cache[cache_key])
	_material_stats.shared_materials += 1
	else:
		# Store in cache for future sharing
		_material_cache[cache_key] = original_material
		)

		## Apply balanced optimization
if shared_material:
	# Use shared material
	mesh_instance.set_surface_override_material(material_idx, shared_material)
	_material_stats.shared_materials += 1
	else:
		# Create new material with minor optimization
if educational_context_awareness and priority > 1:
	similarity_threshold = 0.7  # Higher threshold for important structures

	# Find similar material with low threshold
if shared_material:
	# Use shared material
	mesh_instance.set_surface_override_material(material_idx, shared_material)
	_material_stats.shared_materials += 1
	else:
		# Create simplified material
if material:
	process_func.call(node, i, material)

	# Process children
	for child in node.get_children():
		_process_node_materials(child, structure_name, process_func)

		## Apply a batch material to a structure
if educational_context_awareness and material_variation > 0.0 and not force:
if not batch.variations.has(structure_name):
if variation is StandardMaterial3D:
for cache_key in _material_cache:
if cached_material is StandardMaterial3D:
if similarity >= threshold and similarity > best_score:
	best_match = cached_material
	best_score = similarity

	return best_match

	## Calculate similarity between materials
return score / total_factors

## Create an optimized version of a material
if priority < 2:  # Low priority
# Reduce texture size if any
optimized.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS

# Disable features not needed for distance viewing
optimized.disable_ambient_light = true
optimized.proximity_fade_enabled = false
optimized.distance_fade_mode = BaseMaterial3D.DISTANCE_FADE_DISABLED
else:
	# Higher priority gets better quality
	optimized.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS

	return optimized

	## Create a simplified version of a material
if priority < 3:
	simplified.emission_enabled = false

	# Clear normal mapping for performance
	simplified.normal_enabled = false

	# Disable advanced effects
	simplified.rim_enabled = false
	simplified.clearcoat_enabled = false
	simplified.anisotropy_enabled = false
	simplified.ao_enabled = false
	simplified.heightmap_enabled = false
	simplified.subsurf_scatter_enabled = false
	simplified.refraction_enabled = false

	return simplified

	## Get a hash for material caching
if mat.emission_enabled:
	hash_parts.append(str(mat.emission))

	return ", ".join(hash_parts)

	## Update material variations based on settings
if material_variation <= 0.0:
	batch.variations.clear()

	# Apply base material to all structures
	for structure_name in batch.structures:
		if _priority_structures.has(structure_name):
for structure_name in batch.structures:
	if _priority_structures.has(structure_name):
if not batch.variations.has(structure_name):
if variation is StandardMaterial3D:
for structure_name in batch.variations:
	_adjust_material_brightness(batch.variations[structure_name], brightness_factor)

	# Adjust cached materials
	for cache_key in _material_cache:
		_adjust_material_brightness(_material_cache[cache_key], brightness_factor)

		# Update stats
		_update_material_stats()

		## Adjust brightness of a single material
if std_material.emission_enabled:
for structure_name in _original_materials:
for node_path in structure_materials:
	total_materials += structure_materials[node_path].size()

	# Count batched materials
	for batch_name in _material_batches:
for structure_name in batch.structures:
	if _original_materials.has(structure_name):
for node_path in structure_materials:
	batch_original_count += structure_materials[node_path].size()

	batched_materials += batch_original_count

	# Estimate draw call reduction
if not lod_system or not lod_system is LODSystemEnhanced:
	return

	# Connect to LOD signals
	if not lod_system.lod_level_changed.is_connected(_on_lod_level_changed):
		lod_system.lod_level_changed.connect(_on_lod_level_changed)

		if not lod_system.structure_priority_changed.is_connected(_on_structure_priority_changed):
			lod_system.structure_priority_changed.connect(_on_structure_priority_changed)

			# === SIGNAL HANDLERS ===
			## Handle LOD level changes
if new_level > 0:
	adjusted_priority = max(1, current_priority - new_level)

	# Only reoptimize if priority actually changed
	if adjusted_priority != current_priority:
		_priority_structures[structure_name].priority = adjusted_priority
		_optimize_structure_materials(structure, structure_name)

		## Handle structure priority changes
func _store_original_materials(structure: Node3D, structure_name: String) -> void:
	"""Store original materials for educational integrity"""
	if not structure or not structure.is_inside_tree():
		return

		if not _original_materials.has(structure_name):
			_original_materials[structure_name] = {}

			_store_node_materials(structure, structure_name)

			## Store materials from a specific node
func _store_node_materials(node: Node, structure_name: String) -> void:
	"""Process a node to store its materials"""
	if node is MeshInstance3D and node.mesh != null:
func _apply_optimization_level() -> void:
	"""Apply current optimization level to all materials"""
	if not _initialized:
		return

		# Clear material cache when changing strategies
		_material_cache.clear()

		# Apply to all registered structures
		for structure_name in _priority_structures:
func _optimize_structure_materials(structure: Node3D, structure_name: String) -> void:
	"""Apply educational material optimization to a structure"""
	if not structure or not structure.is_inside_tree():
		return

func _apply_quality_optimization(structure: Node3D, structure_name: String) -> void:
	"""Apply minimal optimization, focusing on educational quality"""
	_process_structure_materials(structure, structure_name, func(mesh_instance, material_idx, original_material):
		# In quality mode, we only cache exact duplicates
func _apply_balanced_optimization(structure: Node3D, structure_name: String, priority: int) -> void:
	"""Apply balanced optimization with educational context awareness"""
	_process_structure_materials(structure, structure_name, func(mesh_instance, material_idx, original_material):
		# In balanced mode, we group similar materials
func _apply_performance_optimization(structure: Node3D, structure_name: String, priority: int) -> void:
	"""Apply aggressive optimization, focusing on performance"""
	_process_structure_materials(structure, structure_name, func(mesh_instance, material_idx, original_material):
		# In performance mode, we heavily share materials
func _apply_batch_material(structure: Node3D, batch_name: String, force: bool = false) -> void:
	"""Apply shared batch material to an educational structure"""
	if not _material_batches.has(batch_name) or not structure:
		return

func _apply_material_to_structure(structure: Node3D, material: Material) -> void:
	"""Apply a shared material to all meshes in a structure"""
	if not structure or not structure.is_inside_tree():
		return

		if structure is MeshInstance3D and structure.mesh != null:
			for i in range(structure.get_surface_override_material_count()):
				structure.set_surface_override_material(i, material)

				# Process children
				for child in structure.get_children():
					_apply_material_to_structure(child, material)

					## Find a similar material in the cache
func _find_similar_material(material: Material, threshold: float) -> Material:
	"""Find similar educational material to reduce draw calls"""
	if not material or _material_cache.is_empty():
		return null

		# Only process StandardMaterial3D for now
		if not material is StandardMaterial3D:
			return null

func _calculate_material_similarity(material_a: Material, material_b: Material) -> float:
	"""Calculate educational material similarity for batching"""
	if not material_a is StandardMaterial3D or not material_b is StandardMaterial3D:
		return 0.0

func _create_optimized_material(original: Material, priority: int) -> Material:
	"""Create educationally optimized material with balanced quality"""
	if not original is StandardMaterial3D:
		return original.duplicate()

func _create_simplified_material(original: Material, priority: int) -> Material:
	"""Create simplified material for maximum educational performance"""
	if not original is StandardMaterial3D:
		return original.duplicate()

func _get_material_hash(material: Material) -> String:
	"""Create a hash key for material caching"""
	if not material is StandardMaterial3D:
		return str(material.get_instance_id())

func _update_material_variations() -> void:
	"""Update material variations for educational distinctiveness"""
	if not _initialized or not educational_context_awareness:
		return

		# Update all batch variations
		for batch_name in _material_batches:
func _apply_brightness_adjustment() -> void:
	"""Adjust material brightness for educational visibility"""
	if not _initialized:
		return

		# Adjust brightness of all batch materials
		for batch_name in _material_batches:
func _adjust_material_brightness(material: Material, factor: float) -> void:
	"""Adjust educational material brightness for visibility"""
	if material is StandardMaterial3D:
func _update_material_stats() -> void:
	"""Update educational material optimization metrics"""
func _integrate_with_lod_system() -> void:
	"""Integrate with LOD system for coordinated educational optimization"""
	# Find LOD system
func _on_lod_level_changed(structure_name: String, new_level: int) -> void:
	"""Adjust material quality when LOD level changes"""
	if not educational_context_awareness or not _priority_structures.has(structure_name):
		return

		# Higher LOD (less detail) should use simpler materials
func _on_structure_priority_changed(structure_name: String, priority: int) -> void:
	"""Adjust material quality when structure educational priority changes"""
	if not educational_context_awareness:
		return

		# Convert LOD priority to our scale (approximately)
