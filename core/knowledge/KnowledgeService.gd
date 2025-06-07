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

## Tracks singleton initialization state
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
var parenthetical_regex: RegEx = RegEx.new()
	parenthetical_regex.compile("\\s*\\([^)]*\\)\\s*$")
	normalized = parenthetical_regex.sub(normalized, "", true)

	# Remove common prefixes and suffixes
var prefixes_to_remove: Array[String] = ["brain ", "model "]
var suffixes_to_remove: Array[String] = [
	" model", " structure", " region", " area", " cortex", " nucleus"
	]

var full_message = "[" + SINGLETON_NAME + "] " + message

	push_error(full_message)
	error_occurred.emit(message)


	# === LOGGING ===

var _is_initialized: bool = false
var _initialization_time: float = 0.0
var _error_count: int = 0

## Core educational data storage
var _anatomical_data: Dictionary = {}
## Fast lookup index for anatomical structures
var _structure_index: Dictionary = {}
## Performance cache for educational search results
var _search_cache: Dictionary = {}
## Educational configuration settings
var _settings: Dictionary = {}

# === LIFECYCLE METHODS ===
var _is_initialized_2: bool = false
var _initialization_time_2: float = 0.0
var _error_count_2: int = 0

# === DATA STORAGE ===
## Medical structure data indexed by ID
var _anatomical_data_2: Dictionary = {}
## Fast lookup index for structure names (lowercase) -> structure data
var _structure_index_2: Dictionary = {}
## Cache for search results to maintain 60fps during educational interactions
var _search_cache_2: Dictionary = {}
## Configuration settings for educational features
var _settings_2: Dictionary = {}

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


	# === PUBLIC API ===
	## Get structure data by ID or name

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

				# Wait for initialization
				if not _is_initialized:
					push_warning("[KnowledgeService] Service not yet initialized")
					return {}

					# Direct ID lookup (fastest)
					if _anatomical_data.has(identifier):
						return _anatomical_data[identifier]

						# Case-insensitive lookup by name or ID
func search_structures(query: String, limit: int = 10) -> Array[Dictionary]:
	"""Search anatomical structures by keyword for educational queries

	Educational Context:
		- Fuzzy search across multiple fields (name, functions, clinical relevance)
		- Results cached to maintain interactive performance
		- Normalized query handles medical terminology variations
		"""

		if query.is_empty():
			return []

			# Check cache first for performance
func get_all_structure_ids() -> Array[String]:
	"""Get list of all available anatomical structure IDs"""
	return _anatomical_data.keys()


	## Get structure count
func get_structure_count() -> int:
	"""Get total number of loaded anatomical structures"""
	return _anatomical_data.size()


	## Check if singleton is initialized
func is_initialized() -> bool:
	"""Check if the knowledge service is ready for use"""
	return _is_initialized


	## Get service version
func get_version() -> String:
	"""Get the current version of the knowledge service"""
	return VERSION


	## Clear search cache
func clear_search_cache() -> void:
	"""Clear cached search results (useful after data updates)"""
	_search_cache.clear()
	_log_debug("Search cache cleared")


	# === PRIVATE METHODS ===

func _fix_orphaned_code():
	if typeof(structure_data) == TYPE_DICTIONARY and structure_data.has("displayName"):
		# Index by ID and name for fast lookup
		_structure_index[structure_id] = structure_data
		_structure_index[structure_data["displayName"].to_lower()] = structure_data


func _fix_orphaned_code():
	for pattern: String in name_mappings:
		if normalized.contains(pattern):
			return name_mappings[pattern]

			# Remove parenthetical suffixes like "(good)", "(solid)", "(separated)", etc.
func _fix_orphaned_code():
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
	if structure.has("displayName") and query in structure["displayName"].to_lower():
		return true

		# Check ID
		if structure.has("id") and query in structure["id"].to_lower():
			return true

			# Check functions
			if structure.has("functions") and structure["functions"] is Array:
				for function: String in structure["functions"]:
					if query in function.to_lower():
						return true

						# Check clinical relevance
						if structure.has("clinicalRelevance") and query in structure["clinicalRelevance"].to_lower():
							return true

							return false


func _normalize_structure_name(structure_name: String) -> String:
	"""Normalize structure names from 3D models to match knowledge base IDs

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
	"""Clean up singleton resources on exit"""

	_anatomical_data.clear()
	_structure_index.clear()
	_search_cache.clear()
	_settings.clear()

	_is_initialized = false
	_log_debug(SINGLETON_NAME + " singleton cleaned up")
