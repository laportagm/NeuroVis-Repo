extends Node

## Modern Educational Knowledge Service
## Primary service for anatomical content in NeuroVis
## @version: 2.0

# === CONSTANTS ===
const KNOWLEDGE_BASE_PATH = "res://assets/data/anatomical_data.json"

# === SIGNALS ===
signal knowledge_loaded
signal knowledge_load_failed(error: String)

# === VARIABLES ===
var _structures: Dictionary = {}
var _metadata: Dictionary = {}
var _is_initialized: bool = false
var _load_error: String = ""


# === LIFECYCLE ===
func _ready() -> void:
	"""Initialize the knowledge service"""
	_load_knowledge_base()


# === PUBLIC METHODS ===
func is_initialized() -> bool:
	"""Check if service is ready"""
	return _is_initialized


func get_structure(structure_id: String) -> Dictionary:
	"""Get structure data with normalization"""
	if not _is_initialized:
		push_warning("[KnowledgeService] Not initialized")
		return {}

	# Try direct lookup first
	var normalized_id = _normalize_structure_name(structure_id)

	if _structures.has(normalized_id):
		return _structures[normalized_id]

	# Try fuzzy search
	return _fuzzy_search_structure(structure_id)


func search_structures(query: String) -> Array[Dictionary]:
	"""Search structures with fuzzy matching"""
	if not _is_initialized:
		return []

	var results: Array[Dictionary] = []
	var query_lower = query.to_lower()

	for structure in _structures.values():
		if _matches_query(structure, query_lower):
			results.append(structure)

	return results


func get_all_structures() -> Array[Dictionary]:
	"""Get all available structures"""
	if not _is_initialized:
		return []
	return _structures.values()


# === PRIVATE METHODS ===
func _load_knowledge_base() -> void:
	"""Load knowledge base from file"""
	print("[KnowledgeService] Loading knowledge base...")

	var file = FileAccess.open(KNOWLEDGE_BASE_PATH, FileAccess.READ)
	if file == null:
		_load_error = "Cannot open knowledge base file"
		push_error("[KnowledgeService] " + _load_error)
		knowledge_load_failed.emit(_load_error)
		return

	var json_text = file.get_as_text()
	file.close()

	var json = JSON.new()
	var parse_result = json.parse(json_text)

	if parse_result != OK:
		_load_error = "JSON parse error: " + str(parse_result)
		push_error("[KnowledgeService] " + _load_error)
		knowledge_load_failed.emit(_load_error)
		return

	var data = json.get_data()
	_process_knowledge_data(data)


func _process_knowledge_data(data: Dictionary) -> void:
	"""Process loaded knowledge data"""
	if not data.has("structures"):
		_load_error = "Invalid data format"
		push_error("[KnowledgeService] " + _load_error)
		knowledge_load_failed.emit(_load_error)
		return

	_structures.clear()

	for structure in data.structures:
		if structure.has("id"):
			var normalized_id = _normalize_structure_name(structure.id)
			_structures[normalized_id] = structure

	_metadata = data.get("metadata", {})
	_is_initialized = true

	print("[KnowledgeService] Loaded " + str(_structures.size()) + " structures")
	knowledge_loaded.emit()


func _normalize_structure_name(name: String) -> String:
	"""Normalize structure names for consistent lookup"""
	var normalized = name.to_lower()
	normalized = normalized.replace(" (good)", "")
	normalized = normalized.replace(" (bad)", "")
	normalized = normalized.replace("_", " ")
	normalized = normalized.strip_edges()
	return normalized


func _fuzzy_search_structure(query: String) -> Dictionary:
	"""Perform fuzzy search for structure"""
	var query_lower = query.to_lower()

	for structure in _structures.values():
		if structure.has("displayName"):
			if structure.displayName.to_lower().contains(query_lower):
				return structure

	return {}


func _matches_query(structure: Dictionary, query: String) -> bool:
	"""Check if structure matches search query"""
	if structure.has("displayName"):
		if structure.displayName.to_lower().contains(query):
			return true

	if structure.has("shortDescription"):
		if structure.shortDescription.to_lower().contains(query):
			return true

	return false
