extends Node

## Legacy Anatomical Knowledge Database
## @deprecated Use KnowledgeService instead for new features
## @version: 1.0

# === CONSTANTS ===
const KNOWLEDGE_BASE_PATH = "res://assets/data/anatomical_data.json"

# === VARIABLES ===
var structures: Dictionary = {}
var version: String = ""
var last_updated: String = ""

# Status tracking
var is_loaded: bool = false
var load_error: String = ""

# === LIFECYCLE ===
func _ready() -> void:
	"""Initialize the knowledge database"""
	load_knowledge_base()

# === PUBLIC METHODS ===
func load_knowledge_base() -> bool:
	"""Load the knowledge base from JSON file"""
	print("[KB] Loading knowledge base from: " + KNOWLEDGE_BASE_PATH)
	
	# Reset status variables
	is_loaded = false
	load_error = ""
	structures.clear()
	
	# Open file
	var file = FileAccess.open(KNOWLEDGE_BASE_PATH, FileAccess.READ)
	if file == null:
		var error_code = FileAccess.get_open_error()
		load_error = "Failed to open knowledge base file. Error code: " + str(error_code)
		push_error("[KB] " + load_error)
		return false
	
	# Read and parse JSON
	var json_text = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var json_parse_result = json.parse(json_text)
	
	if json_parse_result != OK:
		load_error = "Failed to parse JSON. Error: " + str(json_parse_result)
		push_error("[KB] " + load_error)
		return false
	
	var data = json.get_data()
	
	# Validate data structure
	if not data.has("structures"):
		load_error = "Invalid knowledge base format: missing 'structures' key"
		push_error("[KB] " + load_error)
		return false
	
	# Store structures
	for structure in data.structures:
		if structure.has("id"):
			structures[structure.id] = structure
	
	# Store metadata
	if data.has("version"):
		version = data.version
	if data.has("lastUpdated"):
		last_updated = data.lastUpdated
	
	is_loaded = true
	print("[KB] Successfully loaded " + str(structures.size()) + " structures")
	return true

func get_structure(id: String) -> Dictionary:
	"""Get structure data by ID"""
	if not is_loaded:
		push_warning("[KB] Attempting to get structure before knowledge base is loaded")
		return {}
	
	if structures.has(id):
		return structures[id]
	else:
		return {}

func search_structures(query: String) -> Array:
	"""Search structures by query string"""
	if not is_loaded:
		push_warning("[KB] Attempting to search before knowledge base is loaded")
		return []
	
	var results = []
	var query_lower = query.to_lower()
	
	for structure in structures.values():
		if structure.has("displayName"):
			if structure.displayName.to_lower().contains(query_lower):
				results.append(structure)
		elif structure.has("name"):
			if structure.name.to_lower().contains(query_lower):
				results.append(structure)
	
	return results

func get_all_structures() -> Array:
	"""Get all loaded structures"""
	if not is_loaded:
		return []
	return structures.values()

func is_ready() -> bool:
	"""Check if knowledge base is loaded and ready"""
	return is_loaded

func get_load_error() -> String:
	"""Get the last load error message"""
	return load_error
