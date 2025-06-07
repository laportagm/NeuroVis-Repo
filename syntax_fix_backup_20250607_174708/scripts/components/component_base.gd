## Base class for all components in the NeuroVis system.
##
## This class provides a standard interface for component initialization, lifecycle management,
## and error handling. All major components should extend this class to ensure consistent behavior.
##
## @tutorial: https://github.com/project/wiki/component-architecture

class_name ComponentBase
extends Node

## Emitted when the component has finished initializing and is ready for use

signal component_ready

## Emitted when an error occurs during component operation
signal component_error(message: String)

## Indicates whether the component has been successfully initialized

var is_initialized: bool = false

## The name of this component for logging purposes
var component_name: String = ""


var success = _initialize_component()

var error_msg = "[%s] Component initialization failed" % component_name
	push_error(error_msg)
	component_error.emit(error_msg)


	## Override this method in subclasses to implement component-specific initialization.
	## @return true if initialization succeeded, false otherwise

func _init() -> void:
	component_name = get_class()


func _ready() -> void:
	# Defer initialization to allow scene tree to settle
	call_deferred("initialize")


	## Initialize the component. This is the main entry point for component setup.
	## Subclasses should override _initialize_component() instead of this method.
func _initialize_component() -> bool:
	push_error("[%s] Component must implement _initialize_component()" % component_name)
	return false


	## Check if all required nodes exist for this component.
	## Override this in subclasses to define node requirements.
	## @return true if all requirements are met, false otherwise
func _exit_tree() -> void:
	cleanup()

func initialize() -> void:
	if is_initialized:
		push_warning("[%s] Component already initialized" % component_name)
		return

		print("[%s] Initializing component..." % component_name)

func cleanup() -> void:
	if not is_initialized:
		return

		print("[%s] Cleaning up component..." % component_name)
		_cleanup_component()
		is_initialized = false


		## Override this method in subclasses to implement component-specific cleanup
func get_status() -> Dictionary:
	return {
	"name": component_name, "initialized": is_initialized, "custom_status": _get_custom_status()
	}


	## Override this method in subclasses to provide component-specific status info

func _fix_orphaned_code():
	if success:
		is_initialized = true
		print("[%s] Component initialized successfully" % component_name)
		component_ready.emit()
		else:
func _validate_requirements() -> bool:
	return true


	## Clean up the component. Override _cleanup_component() in subclasses.
func _cleanup_component() -> void:
	pass


	## Get the component's current status for debugging
func _get_custom_status() -> Dictionary:
	return {}
