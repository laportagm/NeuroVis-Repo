## ModelLoader.gd
## Asynchronous 3D model loading utility for NeuroVis
##
## Handles loading, caching, and error management for 3D brain models
## with progress tracking and background loading capabilities.
##
## @tutorial: docs/dev/model-loading.md
## @experimental: false

class_name ModelLoader
extends RefCounted

# === CONSTANTS ===

signal model_loaded(model_path: String, model_resource: PackedScene)

## Emitted when model loading fails
## @param model_path: String path that failed to load
## @param error_message: String description of the error
signal model_load_failed(model_path: String, error_message: String)

## Emitted during loading progress
## @param model_path: String path being loaded
## @param progress: float between 0.0 and 1.0
signal loading_progress(model_path: String, progress: float)

# === EXPORTS ===
## Enable model caching

const MAX_CONCURRENT_LOADS: int = 3
const CACHE_SIZE_LIMIT: int = 50

# === SIGNALS ===
## Emitted when a model finishes loading
## @param model_path: String path to the loaded model
## @param model_resource: PackedScene loaded model resource

@export var enable_caching: bool = true

# === PUBLIC VARIABLES ===

var is_loading: bool = false

# === PRIVATE VARIABLES ===
		var model_path = _loading_queue.pop_front()
		_start_model_load(model_path)


	var loader = ResourceLoader.load_threaded_request(model_path)
	if loader != OK:
		model_load_failed.emit(model_path, "Failed to start threaded load")
		return

	_active_loads[model_path] = true
	is_loading = _active_loads.size() > 0


		var progress = []
		var status = ResourceLoader.load_threaded_get_status(model_path, progress)

		if status == ResourceLoader.THREAD_LOAD_LOADED:
			var resource = ResourceLoader.load_threaded_get(model_path)
			_on_model_loaded(model_path, resource)
		elif status == ResourceLoader.THREAD_LOAD_FAILED:
			_on_model_load_failed(model_path, "Loading failed")
		else:
			loading_progress.emit(model_path, progress[0] if progress.size() > 0 else 0.0)


		var oldest_key = _model_cache.keys()[0]
		_model_cache.erase(oldest_key)

var _model_cache: Dictionary = {}
var _loading_queue: Array = []
var _active_loads: Dictionary = {}
var _is_initialized: bool = false


# === LIFECYCLE METHODS ===

func _ready() -> void:
	"""Initialize the ModelLoader component"""
	_is_initialized = true


func _process(delta: float) -> void:
	"""Called every frame to check loading progress"""
	if not _is_initialized:
		return

	if _active_loads.size() > 0:
		_check_loading_progress()


# === PUBLIC METHODS ===
## Load a 3D model asynchronously
## @param model_path: String path to the model file
## @return: bool true if loading started successfully
func _process_loading_queue() -> void:
	"""Process the model loading queue"""

	while _loading_queue.size() > 0 and _active_loads.size() < MAX_CONCURRENT_LOADS:

func load_model_async(model_path: String) -> bool:
	"""Load a 3D model file asynchronously with progress tracking"""

	# Validation
	if model_path.is_empty():
		model_load_failed.emit(model_path, "Model path cannot be empty")
		return false

	# Check cache first
	if enable_caching and _model_cache.has(model_path):
		model_loaded.emit(model_path, _model_cache[model_path])
		return true

	# Add to loading queue
	if not _loading_queue.has(model_path):
		_loading_queue.append(model_path)
		_process_loading_queue()

	return true


## Get cached model if available
## @param model_path: String path to the model
## @return: PackedScene or null if not cached
func get_cached_model(model_path: String) -> PackedScene:
	"""Get a cached model resource"""

	if enable_caching and _model_cache.has(model_path):
		return _model_cache[model_path]

	return null


## Clear the model cache
func clear_cache() -> void:
	"""Clear all cached models"""
	_model_cache.clear()


# === PRIVATE METHODS ===

func _start_model_load(model_path: String) -> void:
	"""Start loading a specific model"""

func _check_loading_progress() -> void:
	"""Check progress of active loads"""

	for model_path in _active_loads.keys():
func _on_model_loaded(model_path: String, resource: PackedScene) -> void:
	"""Handle successful model load"""

	_active_loads.erase(model_path)
	is_loading = _active_loads.size() > 0

	# Cache the model
	if enable_caching:
		_model_cache[model_path] = resource
		_enforce_cache_limits()

	model_loaded.emit(model_path, resource)


func _on_model_load_failed(model_path: String, error: String) -> void:
	"""Handle failed model load"""

	_active_loads.erase(model_path)
	is_loading = _active_loads.size() > 0
	model_load_failed.emit(model_path, error)


func _enforce_cache_limits() -> void:
	"""Enforce cache size limits"""

	while _model_cache.size() > CACHE_SIZE_LIMIT:
