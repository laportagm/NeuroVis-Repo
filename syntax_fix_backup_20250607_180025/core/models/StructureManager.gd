## StructureManager.gd
## Central manager for brain structure data and interaction
##
## This system provides optimized access to brain structure data, relationships,
## and coordinates interaction between visualization, selection and educational components.
##
## @tutorial: Efficient structure management for educational applications
## @version: 1.0

class_name StructureManager
extends Node

# === SIGNALS ===
## Emitted when a structure is selected for educational exploration

signal structure_selected(structure_name: String, structure_data: Dictionary)

## Emitted when structure highlighting state changes
signal structure_highlighted(structure_name: String, highlight_type: String)

## Emitted when related structures are identified
signal related_structures_found(main_structure: String, related: Array)

## Emitted when structure data is loaded or refreshed
signal structure_data_ready(structure_name: String)

## Emitted when a structure comparison is initiated
signal structure_comparison_started(structures: Array)

# === CONSTANTS ===
## Relationship types between brain structures

enum RelationshipType { FUNCTIONAL, ANATOMICAL, DEVELOPMENTAL, PATHOLOGICAL }  # Structures that work together functionally  # Structures physically connected/adjacent  # Structures from same developmental origin  # Structures affected by same pathologies

## Educational highlight types
enum HighlightType { PRIMARY, SECONDARY, RELATED, PATHWAY }  # Main educational focus  # Related to primary - functional connection  # Anatomically connected  # Part of neural pathway

# === PRIVATE VARIABLES ===

var knowledge_service = get_node("/root/KnowledgeService")
var normalized_name = _normalize_structure_name(structure_name)

# Try to get data from knowledge service
var structure_data = {}

var knowledge_service = get_node("/root/KnowledgeService")
var search_results = knowledge_service.search_structures(normalized_name)
var kb = get_node("/root/KB")
var structure_id = _find_structure_id_legacy(normalized_name)
var structure_data = get_structure_data(structure_name)
var highlight_type_str = HighlightType.keys()[highlight_type].to_lower()
highlight_structure(structure_name, highlight_type_str)

# Find related structures
find_related_structures(structure_name)

var cache_key = structure_name
var related = _relationship_cache[cache_key]
related_structures_found.emit(structure_name, related)
var structure_data = get_structure_data(structure_name)
var related_structures = []

var pathologies = structure_data["commonPathologies"]
var affected = _find_structures_with_pathology(pathology, [structure_name])
related_structures.append_array(affected)

# Remove duplicates
var unique_related = []
var highlight_type = "primary" if i == 0 else ("secondary" if i == 1 else "tertiary")
highlight_structure(structure_names[i], highlight_type)

# Emit comparison signal
structure_comparison_started.emit(structure_names)


## End active comparison mode
var knowledge_service = get_node("/root/KnowledgeService")
var results = []
var kb = get_node("/root/KB")
var structure_ids = kb.get_all_structure_ids()

var structure = kb.get_structure(id)
var match_score = _calculate_search_match(structure, query)
var clean_name = name.replace("(good)", "").strip_edges()

# Remove common suffixes
clean_name = clean_name.replace(" (left)", "").replace(" (right)", "")

# If it has a number at the end, remove it
var regex = RegEx.new()
regex.compile("\\s+\\d+$")
clean_name = regex.sub(clean_name, "", true)

# Common structure name mappings
var name_map = {
"hipp and others": "hippocampus",
"corpus callosum": "corpus_callosum",
"medulla oblongata": "medulla",
"medulla_oblongata": "medulla",
"temporal lobe": "temporal_lobe",
"frontal lobe": "frontal_lobe",
"occipital lobe": "occipital_lobe",
"parietal lobe": "parietal_lobe"
}

# Check for direct mapping
var lower_name = clean_name.to_lower()
var kb = get_node("/root/KB")
var lower_name = mesh_name.to_lower()
var structure_ids = kb.get_all_structure_ids()

# Try exact match first
var structure = kb.get_structure(id)
var structure = kb.get_structure(id)
var display_name = structure.displayName.to_lower()
var affected_structures = []

var knowledge_service = get_node("/root/KnowledgeService")
var kb = get_node("/root/KB")
var structure_ids = kb.get_all_structure_ids()

var structure = kb.get_structure(id)
var pathologies = structure.commonPathologies
var score = 0.0
var lower_query = query.to_lower()

# Check display name
var display_name = structure.displayName.to_lower()
var description = structure.shortDescription.to_lower()
var clinical = structure.clinicalRelevance.to_lower()
var current_data = get_structure_data(_current_structure, true)

var _structure_cache: Dictionary = {}
var _relationship_cache: Dictionary = {}
var _current_structure: String = ""
var _highlighted_structures: Dictionary = {}
var _comparison_active: bool = false
var _comparison_structures: Array = []


# === LIFECYCLE METHODS ===

func _ready() -> void:
	print("[StructureManager] Initialized")
	# Connect to knowledge service if available
	if has_node("/root/KnowledgeService"):

func get_structure_data(structure_name: String, force_refresh: bool = false) -> Dictionary:
	"""Get educational data for a brain structure with efficient caching"""
	# Check cache first unless forced refresh
	if not force_refresh and _structure_cache.has(structure_name):
		return _structure_cache[structure_name]

		# Normalize name for consistent lookups
func select_structure(structure_name: String, highlight_type: int = HighlightType.PRIMARY) -> bool:
	"""Select a brain structure for educational focus"""
	if structure_name.is_empty():
		push_warning("[StructureManager] Empty structure name provided")
		return false

		print("[StructureManager] Selecting structure: " + structure_name)

		# Get structure data
func highlight_structure(structure_name: String, highlight_type: String = "primary") -> void:
	"""Apply visual highlighting to a brain structure"""
	if structure_name.is_empty():
		return

		# Track highlighted structure
		_highlighted_structures[structure_name] = highlight_type

		# Emit signal for visualization systems
		structure_highlighted.emit(structure_name, highlight_type)


		## Clear highlighting from a structure
		## @param structure_name: Name of the structure to unhighlight
func unhighlight_structure(structure_name: String) -> void:
	"""Remove highlighting from a brain structure"""
	if _highlighted_structures.has(structure_name):
		_highlighted_structures.erase(structure_name)

		# Use empty type to indicate unhighlighting
		structure_highlighted.emit(structure_name, "")


		## Find structures related to the specified structure
		## @param structure_name: Name of the structure to find relationships for
		## @param relationship_type: Type of relationship to find (from RelationshipType enum)
		## @returns: Array of related structure names
func find_related_structures(structure_name: String, relationship_type: int = -1) -> Array:
	"""Find educationally relevant related brain structures"""
	if structure_name.is_empty():
		return []

		# Check cache for faster access
func start_comparison(structure_names: Array) -> void:
	"""Start educational comparison between multiple brain structures"""
	if structure_names.size() < 2:
		push_warning("[StructureManager] Need at least 2 structures to compare")
		return

		print("[StructureManager] Starting comparison of: " + str(structure_names))

		_comparison_active = true
		_comparison_structures = structure_names.duplicate()

		# Highlight all structures in comparison mode
		for i in range(structure_names.size()):
func end_comparison() -> void:
	"""End structure comparison mode"""
	if not _comparison_active:
		return

		# Clear highlights
		for structure in _comparison_structures:
			unhighlight_structure(structure)

			_comparison_active = false
			_comparison_structures.clear()


			## Get the currently selected structure
func get_current_structure() -> String:
	"""Get the currently selected educational structure"""
	return _current_structure


	## Search for structures matching a query
	## @param query: The search term
	## @param limit: Maximum number of results to return
	## @returns: Array of matching structure data dictionaries
func search_structures(query: String, limit: int = 5) -> Array:
	"""Search for brain structures using educational context"""
	if query.is_empty():
		return []

		if has_node("/root/KnowledgeService"):

func _fix_orphaned_code():
	if knowledge_service.has_signal("knowledge_base_loaded"):
		knowledge_service.knowledge_base_loaded.connect(_on_knowledge_base_loaded)
		else:
			push_warning(
			"[StructureManager] Warning: KnowledgeService does not have knowledge_base_loaded signal"
			)
			else:
				push_warning("[StructureManager] Warning: KnowledgeService not available")


				# === PUBLIC METHODS ===
				## Get structure data with optimized caching
				## @param structure_name: The name of the structure to retrieve
				## @param force_refresh: If true, bypasses cache and forces fresh data retrieval
				## @returns: Dictionary containing structure data
func _fix_orphaned_code():
	if has_node("/root/KnowledgeService"):
func _fix_orphaned_code():
	if knowledge_service.has_method("is_initialized") and knowledge_service.is_initialized():
		if knowledge_service.has_method("get_structure"):
			structure_data = knowledge_service.get_structure(normalized_name)
			else:
				push_warning(
				"[StructureManager] Warning: KnowledgeService.get_structure not available"
				)

				# Attempt fuzzy search if exact match fails
				if structure_data.is_empty() and knowledge_service.has_method("search_structures"):
func _fix_orphaned_code():
	if not search_results.is_empty():
		structure_data = search_results[0]
		else:
			push_warning("[StructureManager] Warning: KnowledgeService not initialized")
			else:
				push_warning("[StructureManager] Warning: KnowledgeService not available")

				# Fallback to legacy knowledge base if needed
				if structure_data.is_empty() and has_node("/root/KB"):
func _fix_orphaned_code():
	if kb.has_method("is_loaded") and kb.is_loaded:
func _fix_orphaned_code():
	if not structure_id.is_empty() and kb.has_method("get_structure"):
		structure_data = kb.get_structure(structure_id)
		else:
			push_warning("[StructureManager] Warning: KB not loaded")

			# Cache the result if valid
			if not structure_data.is_empty():
				_structure_cache[structure_name] = structure_data
				structure_data_ready.emit(structure_name)
				else:
					push_warning("[StructureManager] No data found for structure: " + structure_name)

					return structure_data


					## Select a structure for educational focus
					## @param structure_name: Name of the structure to select
					## @param highlight_type: Type of highlighting to apply (from HighlightType enum)
					## @returns: Whether the selection was successful
func _fix_orphaned_code():
	if structure_data.is_empty():
		push_warning("[StructureManager] Cannot select structure with no data: " + structure_name)
		return false

		# Update current structure
		_current_structure = structure_name

		# Emit selection signal with data
		structure_selected.emit(structure_name, structure_data)

		# Trigger highlighting based on type
func _fix_orphaned_code():
	return true


	## Highlight a structure without full selection
	## @param structure_name: Name of the structure to highlight
	## @param highlight_type: String indicating highlight style
func _fix_orphaned_code():
	if relationship_type >= 0:
		cache_key += "_" + str(relationship_type)

		if _relationship_cache.has(cache_key):
func _fix_orphaned_code():
	return related

	# Get structure data
func _fix_orphaned_code():
	if structure_data.is_empty():
		return []

		# Extract relationships based on type
func _fix_orphaned_code():
	if relationship_type < 0 or relationship_type == RelationshipType.FUNCTIONAL:
		# Functional relationships
		if structure_data.has("functionalConnections"):
			related_structures.append_array(structure_data["functionalConnections"])
			elif structure_data.has("related") and structure_data["related"] is Array:
				related_structures.append_array(structure_data["related"])

				if relationship_type < 0 or relationship_type == RelationshipType.ANATOMICAL:
					# Anatomical relationships
					if structure_data.has("anatomicalConnections"):
						related_structures.append_array(structure_data["anatomicalConnections"])

						if relationship_type < 0 or relationship_type == RelationshipType.PATHOLOGICAL:
							# Pathological relationships
							if structure_data.has("commonPathologies") and structure_data["commonPathologies"] is Array:
func _fix_orphaned_code():
	for pathology in pathologies:
		# Find other structures with the same pathology
func _fix_orphaned_code():
	for item in related_structures:
		if not item in unique_related and item != structure_name:
			unique_related.append(item)

			# Cache the result
			_relationship_cache[cache_key] = unique_related

			# Emit signal
			related_structures_found.emit(structure_name, unique_related)

			return unique_related


			## Start a comparison between multiple structures
			## @param structure_names: Array of structure names to compare
func _fix_orphaned_code():
	if knowledge_service.has_method("is_initialized") and knowledge_service.is_initialized():
		if knowledge_service.has_method("search_structures"):
			return knowledge_service.search_structures(query, limit)
			else:
				push_warning(
				"[StructureManager] Warning: KnowledgeService.search_structures not available"
				)
				else:
					push_warning("[StructureManager] Warning: KnowledgeService not initialized")

					# Fallback search implementation for legacy KB
func _fix_orphaned_code():
	if has_node("/root/KB"):
func _fix_orphaned_code():
	if kb.has_method("is_loaded") and kb.is_loaded:
		if kb.has_method("get_all_structure_ids"):
func _fix_orphaned_code():
	for id in structure_ids:
		if kb.has_method("get_structure"):
func _fix_orphaned_code():
	if structure is Dictionary:
func _fix_orphaned_code():
	if match_score > 0:
		structure["match_score"] = match_score
		results.append(structure)

		# Sort by match score
		results.sort_custom(func(a, b): return a.match_score > b.match_score)

		# Limit results
		if results.size() > limit:
			results = results.slice(0, limit)
			else:
				push_warning("[StructureManager] Warning: KB.get_all_structure_ids not available")
				else:
					push_warning("[StructureManager] Warning: KB not loaded")

					return results


					# === PRIVATE METHODS ===
					## Normalize structure name for consistent lookup
func _fix_orphaned_code():
	if name_map.has(lower_name):
		return name_map[lower_name]

		return clean_name


		## Find structure ID in legacy knowledge base
func _fix_orphaned_code():
	if not kb.has_method("is_loaded") or not kb.is_loaded:
		return ""

		if not kb.has_method("get_all_structure_ids") or not kb.has_method("get_structure"):
			push_warning("[StructureManager] Warning: KB missing required methods")
			return ""

func _fix_orphaned_code():
	for id in structure_ids:
func _fix_orphaned_code():
	if structure is Dictionary and structure.has("displayName"):
		if structure.displayName.to_lower() == lower_name:
			return id

			# Try partial match
			for id in structure_ids:
func _fix_orphaned_code():
	if structure is Dictionary and structure.has("displayName"):
func _fix_orphaned_code():
	if lower_name.contains(display_name) or display_name.contains(lower_name):
		return id

		return ""


		## Find structures associated with a specific pathology
func _fix_orphaned_code():
	if has_node("/root/KnowledgeService"):
func _fix_orphaned_code():
	if knowledge_service.has_method("is_initialized") and knowledge_service.is_initialized():
		# Use new KnowledgeService API if available
		if knowledge_service.has_method("get_structures_by_pathology"):
			return knowledge_service.get_structures_by_pathology(pathology, exclude)

			# Fallback implementation for legacy KB
			if has_node("/root/KB"):
func _fix_orphaned_code():
	if kb.has_method("is_loaded") and kb.is_loaded:
		if kb.has_method("get_all_structure_ids") and kb.has_method("get_structure"):
func _fix_orphaned_code():
	for id in structure_ids:
		if id in exclude:
			continue

func _fix_orphaned_code():
	if structure is Dictionary and structure.has("commonPathologies"):
func _fix_orphaned_code():
	if pathologies is Array and pathology in pathologies:
		affected_structures.append(structure.get("displayName", id))

		return affected_structures


		## Calculate search match score for a structure
func _fix_orphaned_code():
	if structure.has("displayName"):
func _fix_orphaned_code():
	if display_name == lower_query:
		score += 100.0  # Exact match
		elif display_name.begins_with(lower_query):
			score += 50.0  # Begins with query
			elif display_name.contains(lower_query):
				score += 25.0  # Contains query

				# Check description
				if structure.has("shortDescription"):
func _fix_orphaned_code():
	if description.contains(lower_query):
		score += 10.0

		# Check functions
		if structure.has("functions") and structure.functions is Array:
			for function in structure.functions:
				if function.to_lower().contains(lower_query):
					score += 15.0
					break

					# Check clinical relevance
					if structure.has("clinicalRelevance"):
func _fix_orphaned_code():
	if clinical.contains(lower_query):
		score += 5.0

		return score


		## Handle knowledge base loaded event
func _fix_orphaned_code():
	if not current_data.is_empty():
		structure_data_ready.emit(_current_structure)

		# Refresh comparison if active
		if _comparison_active and not _comparison_structures.is_empty():
			start_comparison(_comparison_structures)

func _normalize_structure_name(name: String) -> String:
	"""Normalize structure names for consistent educational mapping"""
	if name.is_empty():
		return ""

		# Remove common parenthetical additions
func _find_structure_id_legacy(mesh_name: String) -> String:
	"""Legacy structure ID lookup for backward compatibility"""
	if not has_node("/root/KB"):
		return ""

func _find_structures_with_pathology(pathology: String, exclude: Array = []) -> Array:
	"""Find structures affected by the same pathology for educational linking"""
func _calculate_search_match(structure: Dictionary, query: String) -> float:
	"""Calculate educational search relevance for brain structures"""
	if not structure is Dictionary:
		return 0.0

func _on_knowledge_base_loaded() -> void:
	"""Respond to knowledge base updates to refresh structure data"""
	print("[StructureManager] Knowledge base loaded - clearing caches")
	# Clear caches to ensure fresh data
	_structure_cache.clear()
	_relationship_cache.clear()

	# Refresh current structure if needed
	if not _current_structure.is_empty():
