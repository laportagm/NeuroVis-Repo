## SafeAutoloadAccess.gd
## Utility for safely accessing autoloads with fallbacks
## Prevents crashes when autoloads are missing or not ready

extends RefCounted

# === SINGLETON INSTANCE ===
static var _instance


static func instance():
	if not _instance:
		_instance = new()
	return _instance


# === AUTOLOAD STATUS CACHE ===

const CHECK_INTERVAL: float = 1.0  # Recheck every second

# === SAFE AUTOLOAD ACCESS METHODS ===


## Safely access UIThemeManager
static func get_theme_manager() -> Node:
	return _safe_get_autoload("UIThemeManager")


## Safely access KnowledgeService
static func get_knowledge_service() -> Node:
	return _safe_get_autoload("KnowledgeService")


## Safely access AIAssistant
static func get_ai_assistant() -> Node:
	return _safe_get_autoload("AIAssistant")


## Safely access ModelSwitcherGlobal
static func get_model_switcher() -> Node:
	return _safe_get_autoload("ModelSwitcherGlobal")


## Safely access DebugCmd
static func get_debug_cmd() -> Node:
	return _safe_get_autoload("DebugCmd")


## Safely get any autoload by name
static func get_autoload(autoload_name: String) -> Node:
	"""Public method to safely get any autoload by name"""
	return _safe_get_autoload(autoload_name)


# === CORE SAFE ACCESS METHOD ===
static func _safe_get_autoload(autoload_name: String) -> Node:
	"""Safely get an autoload with caching and validation"""

	var inst = instance()
	var current_time = Time.get_ticks_msec() / 1000.0

	# Check if we need to revalidate
	var last_check = inst._last_check_time.get(autoload_name)
	if last_check == null:
		last_check = 0.0
	if current_time - last_check > CHECK_INTERVAL:
		inst._validate_autoload(autoload_name)
		inst._last_check_time[autoload_name] = current_time

	# Return cached result or null
	if inst._autoload_status.get(autoload_name) or false:
		# Access autoload via scene tree (avoids Engine.get_singleton warnings)
		var tree = Engine.get_main_loop() as SceneTree
		if tree and tree.root:
			return tree.root.get_node_or_null(autoload_name)
		return null
	else:
		return null

	var node = null

	# Access autoload via scene tree (avoids Engine.get_singleton warnings)
	var tree = Engine.get_main_loop() as SceneTree
	if tree and tree.root:
		node = tree.root.get_node_or_null(autoload_name)
	var is_valid = false

	if node:
		# Check if the node has expected methods (basic validation)
		match autoload_name:
			"UIThemeManager":
				# UIThemeManager uses static methods, just check if node exists
				is_valid = true
			"KnowledgeService":
				is_valid = node.has_method("get_structure") and node.has_method("is_initialized")
			"AIAssistant":
				is_valid = node.has_method("set_current_structure") or node.has_method("initialize")
			"ModelSwitcherGlobal":
				is_valid = node.has_method("toggle_model_visibility")
			"DebugCmd":
				is_valid = node.has_method("register_command")
			_:
				is_valid = true  # Assume valid for unknown autoloads

	_autoload_status[autoload_name] = is_valid


# === FALLBACK METHODS ===


## Apply theme styling with fallback
static func apply_theme_safely(control: Control, style_type: String = "panel") -> bool:
	"""Apply theme styling with fallback to basic styling"""
	if not control:
		return false

	# UIThemeManager uses static methods, so we can call them directly
	# Check if UIThemeManager class is available
	if is_autoload_available("UIThemeManager"):
		match style_type:
			"panel":
				UIThemeManager.apply_glass_panel(control)
				return true
			"button":
				UIThemeManager.apply_modern_button(control, Color.WHITE, "default")
				return true
			"label":
				UIThemeManager.apply_modern_label(control, 14, Color.WHITE)
				return true

	# Fallback styling
	_apply_fallback_styling(control, style_type)
	return false


static func _apply_fallback_styling(control: Control, style_type: String) -> void:
	"""Apply basic fallback styling when UIThemeManager is unavailable"""
	if not control:
		return

	match style_type:
		"panel":
			if control is PanelContainer:
				var style_box = StyleBoxFlat.new()
				style_box.bg_color = Color(0.2, 0.2, 0.2, 0.8)
				style_box.corner_radius_top_left = 8
				style_box.corner_radius_top_right = 8
				style_box.corner_radius_bottom_left = 8
				style_box.corner_radius_bottom_right = 8
				style_box.border_width_left = 1
				style_box.border_width_right = 1
				style_box.border_width_top = 1
				style_box.border_width_bottom = 1
				style_box.border_color = Color(0.4, 0.4, 0.4, 0.6)
				control.add_theme_stylebox_override("panel", style_box)

		"button":
			if control is Button:
				var style_box = StyleBoxFlat.new()
				style_box.bg_color = Color(0.3, 0.3, 0.3, 0.9)
				style_box.corner_radius_top_left = 4
				style_box.corner_radius_top_right = 4
				style_box.corner_radius_bottom_left = 4
				style_box.corner_radius_bottom_right = 4
				control.add_theme_stylebox_override("normal", style_box)

		"label":
			if control is Label:
				control.add_theme_color_override("font_color", Color.WHITE)


## Get structure data safely
static func get_structure_safely(structure_id: String) -> Dictionary:
	"""Get structure data with fallback to empty dictionary"""
	if structure_id.is_empty():
		return {}

	var knowledge_service = get_knowledge_service()
	if knowledge_service and knowledge_service.has_method("get_structure"):
		if knowledge_service.has_method("is_initialized") and knowledge_service.is_initialized():
			return knowledge_service.get_structure(structure_id)

	# Fallback: try legacy KB
	var kb = _safe_get_autoload("KB")
	if kb and kb.has_method("get_structure"):
		return kb.get_structure(structure_id)

	# Ultimate fallback
	return {
		"id": structure_id,
		"displayName": structure_id,
		"shortDescription": "Structure information unavailable - knowledge base not loaded",
		"functions": []
	}


## Set AI context safely
static func set_ai_context_safely(context: String) -> bool:
	"""Set AI assistant context with fallback"""
	var ai_assistant = get_ai_assistant()
	if ai_assistant and ai_assistant.has_method("set_current_structure"):
		ai_assistant.set_current_structure(context)
		return true
	return false


# === UTILITY METHODS ===


## Check if specific autoload is available
static func is_autoload_available(autoload_name: String) -> bool:
	"""Check if a specific autoload is available and functional"""
	var inst = instance()
	inst._validate_autoload(autoload_name)
	return inst._autoload_status.get(autoload_name) or false


## Get status of all autoloads
static func get_autoload_status() -> Dictionary:
	"""Get the status of all tracked autoloads"""
	var inst = instance()
	var status = {}
	var autoloads = [
		"UIThemeManager", "KnowledgeService", "AIAssistant", "ModelSwitcherGlobal", "DebugCmd"
	]

	for autoload_name in autoloads:
		inst._validate_autoload(autoload_name)
		status[autoload_name] = inst._autoload_status.get(autoload_name) or false

	return status


## Log autoload status for debugging
static func log_autoload_status() -> void:
	"""Log the status of all autoloads for debugging"""
	var status = get_autoload_status()
	print("[SafeAutoloadAccess] Autoload Status:")
	for autoload_name in status:
		var status_text = "✓ Available" if status[autoload_name] else "✗ Unavailable"
		print("  %s: %s" % [autoload_name, status_text])


var _autoload_status: Dictionary = {}
var _last_check_time: Dictionary = {}  # Used for caching validation timing


func _validate_autoload(autoload_name: String) -> void:
	"""Validate if an autoload exists and is ready"""
