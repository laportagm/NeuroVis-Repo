## ResourceManager.gd
## Centralized resource management system for NeuroVis educational platform
##
## This system handles loading, caching, and efficient resource management
## for educational 3D models, textures, and other assets.
##
## @tutorial: Resource optimization for educational platform
## @version: 1.0

class_name ResourceManager
extends Node

# === CONSTANTS ===

signal resource_loaded(resource_path: String, resource)

## Emitted when a resource fails to load
signal resource_load_failed(resource_path: String, error)

## Emitted when an async resource completes loading
signal resource_async_loaded(resource_path: String, resource)

## Emitted when a resource group is fully loaded
signal resource_group_loaded(group_name: String)

# === PRIVATE VARIABLES ===
# Resource caches by type

const DEFAULT_GROUP = "default"
const PRELOAD_CONFIG_PATH = "res://config/preload_resources.cfg"

# === SIGNALS ===
## Emitted when a resource is loaded successfully

var resource = null

var group_loaded_count = 0
var group_total = resource_paths.size()

# Preload each resource
var resource = load(resource_path)
var load_status = ResourceLoader.load_threaded_request(resource_path)
var resources = _group_resources[group_name]
var unloaded_count = 0

# Unload each resource
var cache_count = _resource_cache.size()
_resource_cache.clear()

var preloaded_count = _preloaded_resources.size()
_preloaded_resources.clear()
_group_resources.clear()
var stats = get_cache_statistics()

var completed_tasks = []

var task = _loading_tasks[resource_path]

# Check loading status
var load_status = ResourceLoader.load_threaded_get_status(resource_path)

ResourceLoader.THREAD_LOAD_LOADED:
	# Loading complete
var resource = ResourceLoader.load_threaded_get(resource_path)

var progress = []
var progress_value = ResourceLoader.load_threaded_get_status(
	resource_path, progress
	)
var size_estimate = 0

"Texture2D":
	# Estimate texture memory (width * height * bytes per pixel)
	size_estimate = resource.get_width() * resource.get_height() * 4
	"PackedScene":
		# Rough estimate for scenes
		size_estimate = 1024 * 50  # 50KB base estimate
		"Mesh":
			# Rough estimate based on vertex count if available
var total = _cache_hits + _cache_misses
var config = ConfigFile.new()
var groups = config.get_sections()
var resources = config.get_value(group_name, "resources", [])
var auto_preload = config.get_value(group_name, "auto_preload", false)

var _resource_cache: Dictionary = {}
var _preloaded_resources: Dictionary = {}
var _loading_tasks: Dictionary = {}
var _group_resources: Dictionary = {}

# Resource statistics
var _cache_hits: int = 0
var _cache_misses: int = 0
var _memory_usage: int = 0
var _preloaded_count: int = 0


# === INITIALIZATION ===

func _ready() -> void:
	print("[ResourceManager] Initializing educational resource manager")
	_load_preload_configuration()


func _process(_delta: float) -> void:
	_update_async_loads()


	# === PUBLIC API ===
	## Get a resource, loading it if not already cached
	## @param resource_path: Path to the resource
	## @param use_sub_threads: Whether to use sub-threads for loading (when supported)
	## @returns: The loaded resource or null if loading failed

func get_resource(resource_path: String, use_sub_threads: bool = false):
	"""Get educational resource with caching"""
	# Check cache first
	if _resource_cache.has(resource_path):
		_cache_hits += 1
		return _resource_cache[resource_path]

		# Check preloaded resources
		if _preloaded_resources.has(resource_path):
			_cache_hits += 1
			return _preloaded_resources[resource_path]

			# Cache miss, load resource
			_cache_misses += 1

			if ResourceLoader.exists(resource_path):
func preload_resources(resource_paths: Array, group_name: String = DEFAULT_GROUP) -> void:
	"""Preload educational resources for faster access"""
	if resource_paths.is_empty():
		return

		print(
		(
		"[ResourceManager] Preloading %d resources in group '%s'"
		% [resource_paths.size(), group_name]
		)
		)

		# Register group if needed
		if not _group_resources.has(group_name):
			_group_resources[group_name] = []

			# Track loaded resources for this group
func load_resource_async(resource_path: String, callback: Callable = Callable()) -> bool:
	"""Load educational resource asynchronously for smoother experience"""
	# Check cache first
	if _resource_cache.has(resource_path):
		_cache_hits += 1
		if callback.is_valid():
			callback.call(resource_path, _resource_cache[resource_path])
			return true

			# Check preloaded
			if _preloaded_resources.has(resource_path):
				_cache_hits += 1
				if callback.is_valid():
					callback.call(resource_path, _preloaded_resources[resource_path])
					return true

					# Cache miss
					_cache_misses += 1

					# Check if resource exists
					if not ResourceLoader.exists(resource_path):
						push_error("[ResourceManager] Resource does not exist: %s" % resource_path)
						resource_load_failed.emit(resource_path, "Resource not found")
						return false

						# Start async load
func unload_group(group_name: String) -> void:
	"""Unload a group of educational resources to free memory"""
	if not _group_resources.has(group_name):
		push_warning("[ResourceManager] No resource group found: %s" % group_name)
		return

		print("[ResourceManager] Unloading resource group: %s" % group_name)

		# Get resources in this group
func clear_cache(keep_preloaded: bool = true) -> void:
	"""Clear educational resource cache to free memory"""
func get_cache_statistics() -> Dictionary:
	"""Get educational resource usage statistics"""
	return {
	"cache_size": _resource_cache.size(),
	"preloaded_count": _preloaded_count,
	"cache_hits": _cache_hits,
	"cache_misses": _cache_misses,
	"hit_ratio": _calculate_hit_ratio(),
	"memory_usage_kb": _memory_usage / 1024,
	"active_async_loads": _loading_tasks.size(),
	"resource_groups": _group_resources.size()
	}


	## Print resource cache statistics
func print_cache_statistics() -> void:
	"""Print educational resource statistics for debugging"""

func _fix_orphaned_code():
	if use_sub_threads and ResourceLoader.has_cached(resource_path):
		resource = ResourceLoader.load_threaded(resource_path)
		else:
			resource = load(resource_path)

			if resource:
				_cache_resource(resource_path, resource)
				return resource
				else:
					push_error("[ResourceManager] Failed to load resource: %s" % resource_path)
					resource_load_failed.emit(resource_path, "Load failed")
					else:
						push_error("[ResourceManager] Resource does not exist: %s" % resource_path)
						resource_load_failed.emit(resource_path, "Resource not found")

						return null


						## Preload a set of resources for better performance
						## @param resource_paths: Array of resource paths to preload
						## @param group_name: Optional group name for bulk operations
func _fix_orphaned_code():
	for resource_path in resource_paths:
		if ResourceLoader.exists(resource_path):
func _fix_orphaned_code():
	if resource:
		_preloaded_resources[resource_path] = resource
		_group_resources[group_name].append(resource_path)
		_preloaded_count += 1
		group_loaded_count += 1

		# Update memory usage estimate
		_update_memory_usage(resource)

		# Emit signal
		resource_loaded.emit(resource_path, resource)
		else:
			push_warning("[ResourceManager] Failed to preload: %s" % resource_path)
			else:
				push_warning("[ResourceManager] Resource does not exist: %s" % resource_path)

				print(
				(
				"[ResourceManager] Preloaded %d/%d resources in group '%s'"
				% [group_loaded_count, group_total, group_name]
				)
				)

				if group_loaded_count > 0:
					resource_group_loaded.emit(group_name)


					## Load a resource asynchronously
					## @param resource_path: Path to the resource
					## @param callback: Optional callback when resource is loaded
					## @returns: true if async load was started, false otherwise
func _fix_orphaned_code():
	if load_status == OK:
		_loading_tasks[resource_path] = {
		"path": resource_path, "callback": callback, "progress": 0.0
		}
		print("[ResourceManager] Started async load: %s" % resource_path)
		return true
		else:
			push_error(
			(
			"[ResourceManager] Failed to start async load: %s (Error: %d)"
			% [resource_path, load_status]
			)
			)
			resource_load_failed.emit(resource_path, "Async load failed")
			return false


			## Unload resources by group to free memory
			## @param group_name: Name of the group to unload
func _fix_orphaned_code():
	for resource_path in resources:
		if _preloaded_resources.has(resource_path):
			_preloaded_resources.erase(resource_path)
			unloaded_count += 1

			if _resource_cache.has(resource_path):
				_resource_cache.erase(resource_path)
				unloaded_count += 1

				# Remove group
				_group_resources.erase(group_name)

				print("[ResourceManager] Unloaded %d resources from group '%s'" % [unloaded_count, group_name])

				# Force garbage collection
				if unloaded_count > 0:
					print("[ResourceManager] Requesting garbage collection")
					OS.delay_msec(10)  # Small delay to allow frame to complete
					ResourceLoader.load("res://empty.tres")  # Dummy load to trigger GC


					## Clear all cached resources to free memory
					## @param keep_preloaded: Whether to keep preloaded resources
func _fix_orphaned_code():
	print("[ResourceManager] Cleared %d cached resources" % cache_count)

	if not keep_preloaded:
func _fix_orphaned_code():
	print("[ResourceManager] Cleared %d preloaded resources" % preloaded_count)

	# Reset stats
	_cache_hits = 0
	_cache_misses = 0
	_memory_usage = 0

	# Force garbage collection
	print("[ResourceManager] Requesting garbage collection")
	OS.delay_msec(10)  # Small delay to allow frame to complete
	ResourceLoader.load("res://empty.tres")  # Dummy load to trigger GC


	## Get resource cache statistics
	## @returns: Dictionary with cache stats
func _fix_orphaned_code():
	print("\n=== RESOURCE MANAGER STATISTICS ===")
	print("Cached resources: %d" % stats.cache_size)
	print("Preloaded resources: %d" % stats.preloaded_count)
	print("Cache hits: %d" % stats.cache_hits)
	print("Cache misses: %d" % stats.cache_misses)
	print("Hit ratio: %.1f%%" % (stats.hit_ratio * 100))
	print("Estimated memory usage: %.2f MB" % (stats.memory_usage_kb / 1024))
	print("Active async loads: %d" % stats.active_async_loads)
	print("Resource groups: %d" % stats.resource_groups)

	# Print group details
	if not _group_resources.is_empty():
		print("\nResource groups:")
		for group_name in _group_resources:
			print("- %s: %d resources" % [group_name, _group_resources[group_name].size()])

			print("===================================\n")


			# === PRIVATE METHODS ===
func _fix_orphaned_code():
	for resource_path in _loading_tasks:
func _fix_orphaned_code():
	if resource:
		# Cache resource
		_cache_resource(resource_path, resource)

		# Notify via callback
		if task.callback.is_valid():
			task.callback.call(resource_path, resource)

			# Emit signal
			resource_async_loaded.emit(resource_path, resource)
			else:
				push_error(
				(
				"[ResourceManager] Async load completed but resource is null: %s"
				% resource_path
				)
				)
				resource_load_failed.emit(resource_path, "Async load returned null")

				# Mark for removal
				completed_tasks.append(resource_path)

				ResourceLoader.THREAD_LOAD_IN_PROGRESS:
					# Still loading, update progress
func _fix_orphaned_code():
	if not progress.is_empty():
		task.progress = progress[0]

		ResourceLoader.THREAD_LOAD_FAILED:
			# Loading failed
			push_error("[ResourceManager] Async load failed: %s" % resource_path)
			resource_load_failed.emit(resource_path, "Async load failed")
			completed_tasks.append(resource_path)

			# Remove completed tasks
			for resource_path in completed_tasks:
				_loading_tasks.erase(resource_path)


func _fix_orphaned_code():
	if resource.has_method("get_faces_count"):
		size_estimate = resource.get_faces_count() * 160  # ~160 bytes per triangle
		else:
			size_estimate = 1024 * 100  # 100KB base estimate
			"AudioStream":
				# Estimate based on length for AudioStreamWAV
				if resource.has_method("get_length"):
					size_estimate = int(resource.get_length() * 44100 * 2 * 2)  # 44.1kHz, 16-bit stereo
					else:
						size_estimate = 1024 * 200  # 200KB base estimate
						_:
							# Default estimate for other resource types
							size_estimate = 1024  # 1KB base estimate

							_memory_usage += size_estimate


func _fix_orphaned_code():
	if total == 0:
		return 0.0
		return float(_cache_hits) / float(total)


func _fix_orphaned_code():
	if config.load(PRELOAD_CONFIG_PATH) != OK:
		print("[ResourceManager] No preload configuration found at: %s" % PRELOAD_CONFIG_PATH)
		return

		print("[ResourceManager] Loading preload configuration...")

		# Process each resource group
func _fix_orphaned_code():
	for group_name in groups:
func _fix_orphaned_code():
	if auto_preload:
		print("[ResourceManager] Auto-preloading group: %s" % group_name)
		preload_resources(resources, group_name)
		else:
			print("[ResourceManager] Registered group for manual preload: %s" % group_name)
			# Just register the group for later loading
			if not _group_resources.has(group_name):
				_group_resources[group_name] = []

func _update_async_loads() -> void:
	"""Update async loading tasks"""
	if _loading_tasks.is_empty():
		return

		# Process each loading task
func _cache_resource(resource_path: String, resource) -> void:
	"""Add resource to cache and update stats"""
	_resource_cache[resource_path] = resource
	_update_memory_usage(resource)
	resource_loaded.emit(resource_path, resource)


func _update_memory_usage(resource) -> void:
	"""Update memory usage estimate based on resource type"""
	# These are rough estimates since GDScript doesn't expose actual memory usage
func _calculate_hit_ratio() -> float:
	"""Calculate cache hit ratio"""
func _load_preload_configuration() -> void:
	"""Load resource preload configuration"""
