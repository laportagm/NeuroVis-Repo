extends Node

## Educational Model Visibility Manager
## Manages 3D model layer visibility for progressive learning
## @version: 1.0

# === SIGNALS ===
signal visibility_changed(model_name: String, visible: bool)
signal layer_switched(layer_name: String)

# === CONSTANTS ===
const DEFAULT_MODELS = ["Half_Brain", "Internal_Structures", "Brainstem"]

# === VARIABLES ===
var _model_registry: Dictionary = {}
var _visible_models: Array = []
var _current_layer: String = "default"

# === LIFECYCLE ===
func _ready() -> void:
	"""Initialize model visibility manager"""
	_initialize_model_registry()
	print("[ModelVisibilityManager] Model visibility system ready")

# === PUBLIC METHODS ===
func register_model(model_name: String, model_node: Node3D) -> void:
	"""Register a 3D model for educational visibility management"""
	_model_registry[model_name] = {
		"node": model_node,
		"visible": model_node.visible,
		"layer": "default"
	}
	print("[ModelVisibilityManager] Registered model: " + model_name)

func set_model_visible(model_name: String, visible: bool) -> void:
	"""Set educational model visibility"""
	if _model_registry.has(model_name):
		var model_info = _model_registry[model_name]
		model_info.node.visible = visible
		model_info.visible = visible
		
		if visible and model_name not in _visible_models:
			_visible_models.append(model_name)
		elif not visible and model_name in _visible_models:
			_visible_models.erase(model_name)
		
		visibility_changed.emit(model_name, visible)

func switch_to_layer(layer_name: String) -> void:
	"""Switch to educational model layer"""
	_current_layer = layer_name
	_apply_layer_visibility()
	layer_switched.emit(layer_name)

func get_visible_models() -> Array:
	"""Get currently visible educational models"""
	return _visible_models.duplicate()

func is_model_visible(model_name: String) -> bool:
	"""Check if educational model is visible"""
	if _model_registry.has(model_name):
		return _model_registry[model_name].visible
	return false

# === PRIVATE METHODS ===
func _initialize_model_registry() -> void:
	"""Initialize the educational model registry"""
	for model_name in DEFAULT_MODELS:
		_model_registry[model_name] = {
			"node": null,
			"visible": true,
			"layer": "default"
		}

func _apply_layer_visibility() -> void:
	"""Apply educational layer visibility rules"""
	print("[ModelVisibilityManager] Applying layer: " + _current_layer)
	
	for model_name in _model_registry:
		var model_info = _model_registry[model_name]
		if model_info.node:
			var should_be_visible = _should_model_be_visible_in_layer(model_name, _current_layer)
			set_model_visible(model_name, should_be_visible)

func _should_model_be_visible_in_layer(model_name: String, layer: String) -> bool:
	"""Determine if model should be visible in educational layer"""
	# Educational visibility logic would be implemented here
	return true
