## SceneManager.gd
## Handles optimized scene loading and management for educational purposes
##
## This system provides efficient scene transitions, resource management,
## and performance optimization for the educational visualization platform.
##
## @tutorial: Educational scene management patterns
## @version: 1.0

class_name SceneManager
extends Node

# === SIGNALS ===
## Emitted before scene change begins, provides current and target scenes

signal scene_changing(from_scene: String, to_scene: String)

## Emitted when scene has successfully changed
signal scene_changed(new_scene: String)

## Emitted during async loading to report progress
signal scene_load_progress(progress_percent: float)

## Emitted when a scene fails to load
signal scene_load_failed(scene_path: String, error: String)

# === CONSTANTS ===
## Educational loading states for clear user feedback

enum LoadingState { IDLE, LOADING, TRANSITIONING, ERROR }  # No loading in progress  # Scene is being loaded  # Visual transition between scenes  # Loading failed

# Minimum loading screen duration for educational awareness

const MIN_LOADING_SCREEN_TIME: float = 0.5
const TRANSITION_TIME: float = 0.3

# === EXPORTED VARIABLES ===
## Path to the loading screen scene

@export_file("*.tscn") var loading_screen_path: String = "res://scenes/ui/loading_overlay.tscn"

## Controls whether to use transitions between scenes
@export var use_transitions: bool = true

## Default loading screen background color
@export var loading_background_color: Color = Color(0.1, 0.1, 0.1, 0.7)

# === PRIVATE VARIABLES ===

var resource = ResourceLoader.load(scene_path)
var loading_scene = load(loading_screen_path)
# FIXME: Orphaned code - _loading_screen = loading_scene.instantiate()
add_child(_loading_screen)

# Initialize loading screen if it has the right methods
var panel = ColorRect.new()
# FIXME: Orphaned code - panel.color = loading_background_color
panel.set_anchors_preset(Control.PRESET_FULL_RECT)
_loading_screen.add_child(panel)

var label = Label.new()
# FIXME: Orphaned code - label.text = "Loading..."
label.set_anchors_preset(Control.PRESET_CENTER)
panel.add_child(label)

add_child(_loading_screen)


## Load a scene asynchronously
var min_time = _loading_start_time + MIN_LOADING_SCREEN_TIME
var current_time = Time.get_ticks_msec() / 1000.0

# Ensure minimum loading screen display time
var wait_time = min_time - current_time
await get_tree().create_timer(wait_time).timeout

# Change to cached scene
_finish_scene_change(_cached_scenes[scene_path], scene_path)

# Begin threaded loading
var load_status = ResourceLoader.load_threaded_get_status(scene_path)

ResourceLoader.THREAD_LOAD_LOADED:
var scene = ResourceLoader.load_threaded_get(scene_path)
var elapsed = (Time.get_ticks_msec() / 1000.0) - _loading_start_time
var progress_array = []
var progress = ResourceLoader.load_threaded_get_status(scene_path, progress_array)
var result = get_tree().change_scene_to_packed(scene)
var panel_2 = ColorRect.new()
	panel.color = Color(0.7, 0.1, 0.1, 0.8)  # Red background for errors
	panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	_loading_screen.add_child(panel)

var vbox = VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_CENTER)
	vbox.size = Vector2(600, 200)
	panel.add_child(vbox)

var title = Label.new()
	title.text = "Loading Error"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 24)
	vbox.add_child(title)

var message = Label.new()
	message.text = error
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	message.add_theme_color_override("font_color", Color(1, 0.9, 0.9))
	vbox.add_child(message)

var button = Button.new()
	button.text = "Return to Main Menu"
	button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	button.pressed.connect(
	func():
		get_tree().change_scene_to_file("res://scenes/main/node_3d.tscn")
		_loading_screen.queue_free()
		_loading_screen = null
		)
		vbox.add_child(button)

		add_child(_loading_screen)

var _current_scene: String = ""
var _loading_state: LoadingState = LoadingState.IDLE
var _loading_screen: Control
var _cached_scenes: Dictionary = {}
var _loading_start_time: float = 0.0


# === LIFECYCLE METHODS ===

func _ready() -> void:
	print("[SceneManager] Initialized")


	# === PUBLIC METHODS ===
	## Change to a new scene with loading screen and progress tracking
	## @param scene_path: Path to the scene file to load
	## @param transition_params: Optional parameters for transition

func change_scene(scene_path: String, transition_params: Dictionary = {}) -> void:
	"""Change to a new scene with educational loading feedback"""
	# Avoid redundant loads and handle invalid states
	if _loading_state != LoadingState.IDLE:
		push_warning(
		"[SceneManager] Scene change already in progress, ignoring request for " + scene_path
		)
		return

		if scene_path.is_empty():
			push_error("[SceneManager] Cannot change to empty scene path")
			return

			_current_scene = get_tree().current_scene.scene_file_path if get_tree().current_scene else ""
			print("[SceneManager] Changing scene from " + _current_scene + " to " + scene_path)

			# Emit signal before beginning transition
			scene_changing.emit(_current_scene, scene_path)

			# Show loading screen
			_show_loading_screen()

			# Set state and track start time
			_loading_state = LoadingState.LOADING
			_loading_start_time = Time.get_ticks_msec() / 1000.0

			# Begin async loading
			_load_scene_async(scene_path, transition_params)


			## Preload a scene into cache for faster loading later
			## @param scene_path: Path to the scene to preload
			## @returns: Boolean indicating success
func preload_scene(scene_path: String) -> bool:
	"""Preload a scene into memory for instant access"""
	if _cached_scenes.has(scene_path):
		print("[SceneManager] Scene already cached: " + scene_path)
		return true

		print("[SceneManager] Preloading scene: " + scene_path)

		if not ResourceLoader.exists(scene_path):
			push_error("[SceneManager] Cannot preload non-existent scene: " + scene_path)
			return false

func is_scene_cached(scene_path: String) -> bool:
	"""Check if a scene is available in the preload cache"""
	return _cached_scenes.has(scene_path)


	## Clear the scene cache to free memory
func clear_scene_cache() -> void:
	"""Clear all cached scenes from memory"""
	_cached_scenes.clear()
	print("[SceneManager] Scene cache cleared")


	## Get the current loading state
func get_loading_state() -> LoadingState:
	"""Get the current loading state for UI feedback"""
	return _loading_state


	## Get current scene path
func get_current_scene() -> String:
	"""Get the path of the currently active scene"""
	return _current_scene


	# === PRIVATE METHODS ===
	## Show the loading screen overlay

func _fix_orphaned_code():
	if not resource or not resource is PackedScene:
		push_error("[SceneManager] Failed to preload scene: " + scene_path)
		return false

		_cached_scenes[scene_path] = resource
		print("[SceneManager] Scene preloaded successfully: " + scene_path)
		return true


		## Check if a scene is currently cached
func _fix_orphaned_code():
	if _loading_screen.has_method("set_background_color"):
		_loading_screen.set_background_color(loading_background_color)

		if _loading_screen.has_method("show_loading_screen"):
			_loading_screen.show_loading_screen()

			print("[SceneManager] Loading screen displayed")
			else:
				push_warning("[SceneManager] Loading screen not found at path: " + loading_screen_path)
				# Create simple loading label as fallback
				_create_fallback_loading_screen()


				## Create a simple fallback loading screen
func _fix_orphaned_code():
	if current_time < min_time:
func _fix_orphaned_code():
	if not ResourceLoader.exists(scene_path):
		_handle_loading_error("Scene file not found: " + scene_path)
		return

		ResourceLoader.load_threaded_request(scene_path)

		# Wait for loading to complete
		while true:
func _fix_orphaned_code():
	if scene:
		# Cache the loaded scene
		_cached_scenes[scene_path] = scene

		# Ensure minimum loading screen time
func _fix_orphaned_code():
	if elapsed < MIN_LOADING_SCREEN_TIME:
		await get_tree().create_timer(MIN_LOADING_SCREEN_TIME - elapsed).timeout

		_finish_scene_change(scene, scene_path)
		else:
			_handle_loading_error("Scene loaded but returned null: " + scene_path)
			return

			ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				# Update progress
func _fix_orphaned_code():
	if not progress_array.is_empty():
		scene_load_progress.emit(progress_array[0] * 100)

		# Update loading screen if it has the method
		if _loading_screen and _loading_screen.has_method("update_progress"):
			_loading_screen.update_progress(progress_array[0])

			await get_tree().create_timer(0.1).timeout

			ResourceLoader.THREAD_LOAD_FAILED:
				_handle_loading_error("Scene failed to load: " + scene_path)
				return

				_:
					_handle_loading_error("Unknown error loading scene: " + scene_path)
					return


					## Complete the scene change process
func _fix_orphaned_code():
	if result != OK:
		_handle_loading_error("Failed to change scene with error code: " + str(result))
		return

		# Update current scene reference
		_current_scene = scene_path

		# Clean up loading screen
		if _loading_screen:
			_loading_screen.queue_free()
			_loading_screen = null

			# Reset state
			_loading_state = LoadingState.IDLE

			# Emit completion signal
			scene_changed.emit(scene_path)
			print("[SceneManager] Scene changed to: " + scene_path)


			## Handle loading errors
func _show_loading_screen() -> void:
	"""Display the educational loading screen with feedback"""
	if _loading_screen != null:
		_loading_screen.queue_free()

		if ResourceLoader.exists(loading_screen_path):
func _create_fallback_loading_screen() -> void:
	"""Create minimal loading indicator if proper screen unavailable"""
	_loading_screen = Control.new()
	_loading_screen.set_anchors_preset(Control.PRESET_FULL_RECT)

func _load_scene_async(scene_path: String, transition_params: Dictionary) -> void:
	"""Load scene in background thread with educational progress tracking"""
	# Check if scene is cached first
	if _cached_scenes.has(scene_path):
		print("[SceneManager] Using cached scene: " + scene_path)
func _finish_scene_change(scene: PackedScene, scene_path: String) -> void:
	"""Finalize scene change with proper transitions"""
	if not scene:
		_handle_loading_error("Invalid scene provided to _finish_scene_change")
		return

		# Set transition state
		_loading_state = LoadingState.TRANSITIONING

		# Apply transition effect if enabled
		if use_transitions and _loading_screen and _loading_screen.has_method("transition_out"):
			# Fade out loading screen first
			_loading_screen.transition_out()
			await get_tree().create_timer(TRANSITION_TIME).timeout

			# Change scene
func _handle_loading_error(error: String) -> void:
	"""Process scene loading errors with educational feedback"""
	push_error("[SceneManager] " + error)

	_loading_state = LoadingState.ERROR

	# Update loading screen if it exists and has error handling
	if _loading_screen:
		if _loading_screen.has_method("show_error"):
			_loading_screen.show_error(error)
			else:
				# Update generic loading screen with error
				_loading_screen.queue_free()
				_create_error_screen(error)
				else:
					_create_error_screen(error)

					# Emit error signal
					scene_load_failed.emit(_current_scene, error)


					## Create an error screen
func _create_error_screen(error: String) -> void:
	"""Create educational error feedback for loading failures"""
	_loading_screen = Control.new()
	_loading_screen.set_anchors_preset(Control.PRESET_FULL_RECT)
