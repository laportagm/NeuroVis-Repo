extends Node

## Educational Feature Flags System
## Manages feature toggles for educational platform development
## @version: 1.0

# === CONSTANTS ===
const FEATURES_FILE = "user://feature_flags.cfg"

# === VARIABLES ===
var _features: Dictionary = {}
var _config: ConfigFile


# === LIFECYCLE ===
func _ready() -> void:
	"""Initialize feature flags system"""
	_config = ConfigFile.new()
	_load_default_features()
	_load_feature_config()
	print("[FeatureFlags] Feature flags system ready")


# === PUBLIC METHODS ===
func is_enabled(feature_name: String) -> bool:
	"""Check if educational feature is enabled"""
	return _features.get(feature_name, false)


func enable_feature(feature_name: String, enabled: bool = true) -> void:
	"""Enable/disable educational feature"""
	_features[feature_name] = enabled
	_save_feature_config()
	print("[FeatureFlags] Feature " + feature_name + " set to: " + str(enabled))


func get_all_features() -> Dictionary:
	"""Get all educational feature flags"""
	return _features.duplicate()


# === PRIVATE METHODS ===
func _load_default_features() -> void:
	"""Load default educational feature flags"""
	_features = {
		"enhanced_ui": true,
		"ai_assistant": true,
		"analytics": false,
		"experimental_3d": false,
		"accessibility_enhancements": true,
		"debug_mode": false
	}


func _load_feature_config() -> void:
	"""Load feature configuration from file"""
	var err = _config.load(FEATURES_FILE)
	if err == OK:
		for feature in _features.keys():
			_features[feature] = _config.get_value("features", feature, _features[feature])


func _save_feature_config() -> void:
	"""Save feature configuration to file"""
	for feature in _features.keys():
		_config.set_value("features", feature, _features[feature])
	_config.save(FEATURES_FILE)
