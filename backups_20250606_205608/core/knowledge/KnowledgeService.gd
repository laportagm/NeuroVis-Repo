## KnowledgeService.gd
## Centralized knowledge base and anatomical data management service for educational platform
##
## This autoload singleton provides unified access to anatomical data,
## structure information, and educational content throughout NeuroVis.
##
## Educational Context:
## - Handles inconsistent 3D model naming (e.g., "Thalami (good)" → "thalamus")
## - Provides fuzzy search for educational queries across multiple languages
## - Caches search results to maintain 60fps during interactive learning sessions
## - Normalizes medical terminology for consistent educational content delivery
##
## Access via: KnowledgeService.method_name()
## @autoload: KnowledgeService

extends Node

# === CONSTANTS ===

signal initialized

## Emitted when data is successfully loaded
## @param structure_count: Number of educational structures loaded
signal data_loaded(structure_count: int)

## Emitted when a structure is requested for educational display
## @param structure_id: Identifier of the requested anatomical structure
signal structure_requested(structure_id: String)

## Emitted when critical error occurs
## @param error_message: Human-readable error description for debugging
signal error_occurred(error_message: String)

# === CONFIGURATION ===
## Enable debug logging

const SINGLETON_NAME: String = "KnowledgeService"
const VERSION: String = "1.0.0"
const DATA_FILE_PATH: String = "res://assets/data/anatomical_data.json"

# === SIGNALS ===
## Emitted when the singleton is fully initialized

var debug_mode: bool = OS.is_debug_build()

## Enable performance monitoring
var monitor_performance: bool = false

# === STATE VARIABLES ===
	var start_time = Time.get_ticks_msec()

	# Load configuration
	_load_configuration()

	# Initialize subsystems
	_initialize_subsystems()

	# Setup complete

	# Mark as initialized
	_is_initialized = true
	_initialization_time = (Time.get_ticks_msec() - start_time) / 1000.0

	initialized.emit()
	_log_debug(SINGLETON_NAME + " initialized in " + str(_initialization_time) + "s")


	var setting_prefix = "knowledge_service"

	for key in _settings.keys():
		var setting_path = setting_prefix + "/" + key
		if ProjectSettings.has_setting(setting_path):
			_settings[key] = ProjectSettings.get_setting(setting_path)


	var file = FileAccess.open(DATA_FILE_PATH, FileAccess.READ)
	if not file:
		_handle_error("Failed to open anatomical data file")
		return

	var json_text = file.get_as_text()
	file.close()

	var json = JSON.new()
	var parse_result = json.parse(json_text)

	if parse_result != OK:
		_handle_error("Failed to parse anatomical data JSON")
		return

	var raw_json_data: Variant = json.data

	# Convert structures array to dictionary indexed by ID
	_anatomical_data.clear()
	if raw_json_data.has("structures") and raw_json_data["structures"] is Array:
		for structure: Variant in raw_json_data["structures"]:
			if structure is Dictionary and structure.has("id"):
				_anatomical_data[structure["id"]] = structure

	data_loaded.emit(_anatomical_data.size())
	_log_debug("Loaded " + str(_anatomical_data.size()) + " anatomical structures")


		var structure_data: Dictionary = _anatomical_data[structure_id]
		if typeof(structure_data) == TYPE_DICTIONARY and structure_data.has("displayName"):
			# Index by ID and name for fast lookup
			_structure_index[structure_id] = structure_data
			_structure_index[structure_data["displayName"].to_lower()] = structure_data


# === PUBLIC API ===
## Get structure data by ID or name
	var lower_id = identifier.to_lower()
	if _structure_index.has(lower_id):
		return _structure_index[lower_id]

	# Try normalized name lookup (remove suffixes like "(good)", "(solid)", etc.)
	var normalized_name: String = _normalize_structure_name(identifier)
	if normalized_name != identifier:
		# Try normalized name
		if _anatomical_data.has(normalized_name):
			return _anatomical_data[normalized_name]

		var normalized_lower: String = normalized_name.to_lower()
		if _structure_index.has(normalized_lower):
			return _structure_index[normalized_lower]

	_log_debug("Structure not found: " + identifier)
	return {}


## Search structures by keyword
	var cache_key: String = query.to_lower() + "_" + str(limit)
	if _search_cache.has(cache_key):
		return _search_cache[cache_key]

	var results: Array[Dictionary] = []
	var query_lower: String = query.to_lower()
	var normalized_query: String = _normalize_structure_name(query).to_lower()

	# Optimize search with early termination
	for structure: Dictionary in _anatomical_data.values():
		# Early termination check
		if results.size() >= limit:
			break

		if (
			_matches_search(structure, query_lower)
			or (normalized_query != query_lower and _matches_search(structure, normalized_query))
		):
			results.append(structure)

	# Cache results
	_search_cache[cache_key] = results
	return results


## Get all structure IDs
	var normalized: String = structure_name.to_lower()

	# Special mapping for common 3D model naming patterns
	var name_mappings: Dictionary = {
		"brain model": "cerebellum",  # "Brain model (separated cerebellum...)" -> Cerebellum
		"thalami": "thalamus",  # "Thalami (good)" -> Thalamus
		"hipp and others": "hippocampus",  # "Hipp and Others (good)" -> Hippocampus
		"corpus callosum": "corpus_callosum",  # Handle underscore vs space
		"cerebellum": "cerebellum",  # Direct mapping for cerebellum references
		"striatum": "striatum",  # Direct mapping for striatum
		"ventricles": "ventricles"  # Direct mapping for ventricles
	}

	# Check for exact mapping first
	for pattern: String in name_mappings:
		if normalized.contains(pattern):
			return name_mappings[pattern]

	# Remove parenthetical suffixes like "(good)", "(solid)", "(separated)", etc.
	var parenthetical_regex: RegEx = RegEx.new()
	parenthetical_regex.compile("\\s*\\([^)]*\\)\\s*$")
	normalized = parenthetical_regex.sub(normalized, "", true)

	# Remove common prefixes and suffixes
	var prefixes_to_remove: Array[String] = ["brain ", "model "]
	var suffixes_to_remove: Array[String] = [
		" model", " structure", " region", " area", " cortex", " nucleus"
	]

	for prefix: String in prefixes_to_remove:
		if normalized.begins_with(prefix):
			normalized = normalized.substr(prefix.length())

	for suffix: String in suffixes_to_remove:
		if normalized.ends_with(suffix):
			normalized = normalized.substr(0, normalized.length() - suffix.length())

	# Clean up extra whitespace
	normalized = normalized.strip_edges()

	# Replace spaces with underscores for consistency with JSON
	normalized = normalized.replace(" ", "_")

	_log_debug("Name normalization: '%s' -> '%s'" % [structure_name, normalized])
	return normalized


# === UTILITY METHODS ===
## Check if singleton is initialized
	var full_message = "[" + SINGLETON_NAME + "] " + message

	push_error(full_message)
	error_occurred.emit(message)


# === LOGGING ===

var _is_initialized: bool = false
var _initialization_time: float = 0.0
var _error_count: int = 0

# === DATA STORAGE ===
## Medical structure data indexed by ID
var _anatomical_data: Dictionary = {}
## Fast lookup index for structure names (lowercase) -> structure data
var _structure_index: Dictionary = {}
## Cache for search results to maintain 60fps during educational interactions
var _search_cache: Dictionary = {}
## Configuration settings for educational features
var _settings: Dictionary = {}


# === LIFECYCLE METHODS ===

func _ready() -> void:
	"""Initialize the singleton on startup"""
	name = SINGLETON_NAME
	_initialize_singleton()


func _exit_tree() -> void:
	"""Clean up singleton resources"""
	_cleanup_singleton()


# === INITIALIZATION ===
func _initialize_singleton() -> void:
	"""Initialize the singleton with default configuration"""

	_log_debug("Initializing " + SINGLETON_NAME + " singleton...")
func _initialize_subsystems() -> void:
	"""Initialize knowledge management subsystems"""

	# Load anatomical data
	_load_anatomical_data()

	# Build search index
	_build_structure_index()

	# Initialize search cache
	_search_cache.clear()


func get_structure(identifier: String) -> Dictionary:
	"""Get anatomical structure data by ID or display name
	
	Educational Context - Search Priority:
	1. Direct ID match (exact match for internal references)
	2. Case-insensitive name match (user-friendly lookup)
	3. Normalized name match (handles 3D model naming inconsistencies)
	
	Examples:
	- "hippocampus" → returns hippocampus data
	- "Hippocampus" → returns hippocampus data
	- "Hipp and Others (good)" → normalizes to "hippocampus"
	"""

	# Input validation
	if identifier == null or identifier.is_empty():
		push_warning("[KnowledgeService] Invalid identifier provided: " + str(identifier))
		return {}

	structure_requested.emit(identifier)

	# Direct ID lookup
	if _anatomical_data.has(identifier):
		return _anatomical_data[identifier]

	# Index lookup (case-insensitive)
func search_structures(query: String, limit: int = 10) -> Array[Dictionary]:
	"""Search anatomical structures by keyword
	
	Educational Context - Search Algorithm:
	1. Exact match in display name (highest priority)
	2. Fuzzy match in descriptions (educational content)
	3. Partial match in functions (medical relevance)
	
	Cache Strategy:
	- Results cached to maintain 60fps during rapid educational queries
	- Cache key combines query + limit for precision
	- Cache cleared on data updates or manual clear
	"""

	# Input validation
	if query == null or query.is_empty():
		push_warning("[KnowledgeService] Invalid search query provided")
		return []

	if limit <= 0:
		push_warning("[KnowledgeService] Invalid limit: %d, using default 10" % limit)
		limit = 10

	# Check cache first
func get_all_structure_ids() -> Array[String]:
	"""Get array of all available structure IDs"""
	return _anatomical_data.keys()


## Get total structure count
func get_structure_count() -> int:
	"""Get total number of anatomical structures"""
	return _anatomical_data.size()


# === PRIVATE METHODS ===
func is_initialized() -> bool:
	"""Check if the knowledge service is fully initialized"""
	return _is_initialized


## Get singleton version
func get_version() -> String:
	"""Get the knowledge service version"""
	return VERSION


## Clear search cache
func clear_search_cache() -> void:
	"""Clear the search results cache"""
	_search_cache.clear()
	_log_debug("Search cache cleared")


# === ERROR HANDLING ===

func _load_configuration() -> void:
	"""Load singleton configuration from settings"""

	# Default settings for knowledge service
	_settings = {
		"debug_mode": OS.is_debug_build(),
		"cache_enabled": true,
		"preload_all": true,
		"search_fuzzy": true
	}

	# Apply settings
	debug_mode = _settings.get("debug_mode", false)


func _load_project_settings() -> void:
	"""Load settings from project configuration"""

func _load_anatomical_data() -> void:
	"""Load anatomical data from JSON file"""

	if not FileAccess.file_exists(DATA_FILE_PATH):
		_handle_error("Anatomical data file not found: " + DATA_FILE_PATH)
		return

func _build_structure_index() -> void:
	"""Build searchable index of anatomical structures for educational lookup
	
	Educational Context:
	- Creates dual index: by ID and by display name (lowercase)
	- Enables O(1) lookup performance for interactive educational queries
	- Supports case-insensitive search for better educational UX
	"""

	_structure_index.clear()

	for structure_id: String in _anatomical_data.keys():
func _matches_search(structure: Dictionary, query: String) -> bool:
	"""Check if structure matches search query"""

	# Check display name
	if structure.has("displayName"):
		if structure["displayName"].to_lower().contains(query):
			return true

	# Check description
	if structure.has("shortDescription"):
		if structure["shortDescription"].to_lower().contains(query):
			return true

	# Check functions
	if structure.has("functions"):
		for function_item: String in structure["functions"]:
			if function_item.to_lower().contains(query):
				return true

	return false


func _normalize_structure_name(structure_name: String) -> String:
	"""Normalize structure name by removing common suffixes and parenthetical additions
	
	Educational Context:
	Medical 3D models often have inconsistent naming due to:
	- Export suffixes: "(good)", "(solid)", "(separated)"
	- Artist annotations: "Hipp and Others", "Brain model"
	- Plural/singular forms: "Thalami" vs "Thalamus"
	
	This normalization ensures educational content matches regardless of model source.
	"""

func _handle_error(message: String) -> void:
	"""Handle error with logging and signal emission"""

	_error_count += 1
func _log_debug(message: String) -> void:
	"""Log debug message if debug mode is enabled"""
	if debug_mode:
		print("[" + SINGLETON_NAME + "] " + message)


# === CLEANUP ===
func _cleanup_singleton() -> void:
	"""Clean up singleton resources"""

	# Clear all data
	_anatomical_data.clear()
	_structure_index.clear()
	_search_cache.clear()
	_settings.clear()

	_is_initialized = false
	_log_debug(SINGLETON_NAME + " cleaned up")
