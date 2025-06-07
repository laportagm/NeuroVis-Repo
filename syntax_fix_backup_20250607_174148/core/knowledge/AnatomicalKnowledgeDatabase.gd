class_name AnatomicalKnowledgeDatabase
extends Node

# Path to the knowledge base file

const KNOWLEDGE_BASE_PATH = "res://assets/data/anatomical_data.json"

# Structure data

var structures: Dictionary = {}
var version: String = ""
var last_updated: String = ""

# Status tracking
var is_loaded: bool = false
var load_error: String = ""

	var file = FileAccess.open(KNOWLEDGE_BASE_PATH, FileAccess.READ)

	# Check if the file was opened successfully
	if file == null:
		var file_open_error_code = FileAccess.get_open_error()
		load_error = "Failed to open knowledge base file. Error code: " + str(file_open_error_code)
		print(load_error)
		return false

	# Read the file content
	var json_text = file.get_as_text()
	file.close()

	# Parse the JSON
	var json = JSON.new()
	var json_parse_result = json.parse(json_text)

	if json_parse_result != OK:
		load_error = (
			"Failed to parse knowledge base JSON. Error at line "
			+ str(json.get_error_line())
			+ ": "
			+ json.get_error_message()
		)
		print(load_error)
		return false

	# Get the data
	var data = json.get_data()

	# Validate the data
	if not data is Dictionary:
		load_error = "Knowledge base data is not in the expected format."
		print(load_error)
		return false

	if not data.has("structures") or not data.has("version") or not data.has("lastUpdated"):
		load_error = "Knowledge base data is missing required fields."
		print(load_error)
		return false

	# Store the data
	version = data.version
	last_updated = data.lastUpdated

	# Process structures and create lookup by ID
	for structure in data.structures:
		if structure.has("id"):
			structures[structure.id] = structure

	# Mark as successfully loaded
	is_loaded = true
	print(
		(
			"Knowledge base loaded successfully. Version: "
			+ version
			+ ", Last Updated: "
			+ last_updated
		)
	)
	print("Loaded " + str(structures.size()) + " anatomical structures.")

	return true

func _ready() -> void:
	# Attempt to load the knowledge base on startup
	load_knowledge_base()

func load_knowledge_base() -> bool:
	print("Loading knowledge base from: " + KNOWLEDGE_BASE_PATH)

	# Reset status variables
	is_loaded = false
	load_error = ""
	structures.clear()

	# Create a new file access object
func get_structure(id: String) -> Dictionary:
	if not is_loaded:
		print("Warning: Attempting to get structure before knowledge base is loaded.")
		return {}

	if structures.has(id):
		return structures[id]

	print("Warning: Structure with ID '" + id + "' not found in knowledge base.")
	return {}


# Get all structure IDs
func get_all_structure_ids() -> Array:
	return structures.keys()


# Check if a structure ID exists
func has_structure(id: String) -> bool:
	return structures.has(id)


# Get knowledge base metadata
func get_metadata() -> Dictionary:
	return {
		"version": version,
		"lastUpdated": last_updated,
		"structureCount": structures.size(),
		"isLoaded": is_loaded,
		"loadError": load_error
	}


# Get structure count (for testing framework compatibility)
func get_structure_count() -> int:
	return structures.size()


# Get all structures as array (for testing framework compatibility)
func get_all_structures() -> Array:
	return structures.values()


# Get structure by ID (alias for get_structure for testing compatibility)
func get_structure_by_id(id: String) -> Dictionary:
	return get_structure(id)
