# Component Registry - Central component factory and lifecycle manager
# Provides unified component creation, caching, and state management

class_name ComponentRegistry
extends RefCounted

# === DEPENDENCIES ===

const FeatureFlags = preprepreload("res://core/features/FeatureFlags.gd")

# === COMPONENT FACTORIES ===
static var _factories: Dictionary = {}
static var _component_cache: Dictionary = {}
static var _active_components: Dictionary = {}
static var _component_configs: Dictionary = {}

# === PERFORMANCE TRACKING ===
static var _creation_count: int = 0
static var _cache_hits: int = 0
static var _cache_misses: int = 0

# === INITIALIZATION ===
static var _initialized: bool = false


static func _ensure_initialized() -> void:
	if not _initialized:
		_register_core_factories()
		_initialized = true


static func _register_core_factories() -> void:
	"""Register built-in component factories"""

	# UI Panel factories
	register_factory("info_panel", _create_info_panel)
	register_factory("settings_panel", _create_settings_panel)
	register_factory("ai_assistant_panel", _create_ai_assistant_panel)

	# UI Fragment factories
	register_factory("header", _create_header_component)
	register_factory("content", _create_content_component)
	register_factory("actions", _create_actions_component)
	register_factory("section", _create_section_component)

	# Control factories
	register_factory("button", _create_button_component)
	register_factory("label", _create_label_component)
	register_factory("container", _create_container_component)

	print("[ComponentRegistry] Registered %d core factories" % _factories.size())


# === PUBLIC API ===
static func register_factory(component_type: String, factory_function: Callable) -> void:
	"""Register a component factory function"""
	_factories[component_type] = factory_function
	print("[ComponentRegistry] Registered factory: %s" % component_type)


static func create_component(component_type: String, config: Dictionary = {}) -> Control:
	"""Create a new component instance"""
	_ensure_initialized()

	if not _factories.has(component_type):
		push_error("[ComponentRegistry] Unknown component type: %s" % component_type)
		return _create_fallback_component(component_type, config)

	_creation_count += 1

	var component = _factories[component_type].call(config)

	if component:
		_setup_component_metadata(component, component_type, config)
		_register_active_component(component)

		if FeatureFlags.is_enabled(FeatureFlags.DEBUG_COMPONENT_INSPECTOR):
			print("[ComponentRegistry] Created %s (total: %d)" % [component_type, _creation_count])

	return component


static func get_or_create(
	component_id: String, component_type: String, config: Dictionary = {}
) -> Control:
	"""Get existing component or create new one with caching"""
	_ensure_initialized()

	# Check if component exists and is valid
	if _component_cache.has(component_id):
		var cached_component = _component_cache[component_id]
		if is_instance_valid(cached_component):
			_cache_hits += 1
			_update_component_config(cached_component, config)

			if FeatureFlags.is_enabled(FeatureFlags.DEBUG_COMPONENT_INSPECTOR):
				print("[ComponentRegistry] Cache hit: %s" % component_id)

			return cached_component
		else:
			# Clean up invalid reference
			_component_cache.erase(component_id)
			_active_components.erase(component_id)

	# Create new component
	_cache_misses += 1
	var component = create_component(component_type, config)

	if component:
		# Cache the component if pooling is enabled
		if FeatureFlags.is_enabled(FeatureFlags.UI_COMPONENT_POOLING):
			_component_cache[component_id] = component
			component.set_meta("component_id", component_id)

		_component_configs[component_id] = config.duplicate()

		if FeatureFlags.is_enabled(FeatureFlags.DEBUG_COMPONENT_INSPECTOR):
			print("[ComponentRegistry] Cache miss: %s" % component_id)

	return component


static func release_component(component_id: String) -> void:
	"""Release a component from cache (but don't destroy it)"""
	if _component_cache.has(component_id):
		var component = _component_cache[component_id]

		# Save component state if persistence is enabled
		if FeatureFlags.is_enabled(FeatureFlags.UI_STATE_PERSISTENCE) and component:
			_save_component_state(component_id, component)

		_component_cache.erase(component_id)
		_active_components.erase(component_id)

		if FeatureFlags.is_enabled(FeatureFlags.DEBUG_COMPONENT_INSPECTOR):
			print("[ComponentRegistry] Released: %s" % component_id)


static func destroy_component(component_id: String) -> void:
	"""Completely destroy a component"""
	if _component_cache.has(component_id):
		var component = _component_cache[component_id]
		if is_instance_valid(component):
			component.queue_free()

		_component_cache.erase(component_id)
		_active_components.erase(component_id)
		_component_configs.erase(component_id)

		if FeatureFlags.is_enabled(FeatureFlags.DEBUG_COMPONENT_INSPECTOR):
			print("[ComponentRegistry] Destroyed: %s" % component_id)


# === COMPONENT FACTORIES ===
static func _create_info_panel(config: Dictionary) -> Control:
	"""Create information panel component"""

	# Use new modular system if enabled
	if FeatureFlags.is_enabled(FeatureFlags.UI_MODULAR_COMPONENTS):
		return _create_modular_info_panel(config)
	else:
		return _create_legacy_info_panel(config)


static func _create_modular_info_panel(config: Dictionary) -> Control:
	"""Create new modular info panel"""

	# Try to load the new InfoPanelComponent
	var component_script = _safe_load_script("res://ui/components/InfoPanelComponent.gd")
	if component_script:
		var panel = component_script.new()
		panel.configure(config)
		return panel

	# Fallback to enhanced panel if available
	var enhanced_script = _safe_load_script("res://ui/panels/EnhancedInformationPanel.gd")
	if enhanced_script:
		return enhanced_script.new()

	# Ultimate fallback
	return _create_fallback_panel(config)


static func _create_legacy_info_panel(config: Dictionary) -> Control:
	"""Create legacy info panel using existing factory"""

	var factory_script = _safe_load_script("res://ui/panels/InfoPanelFactory.gd")
	if factory_script and factory_script.has_method("create_info_panel"):
		return factory_script.create_info_panel()

	return _create_fallback_panel(config)


static func _create_settings_panel(_config: Dictionary) -> Control:
	"""Create settings panel component"""
	var panel = PanelContainer.new()
	panel.name = "SettingsPanel"

	var label = Label.new()
	label.text = "Settings Panel (Under Development)"
	panel.add_child(label)

	return panel


static func _create_ai_assistant_panel(config: Dictionary) -> Control:
	"""Create AI assistant panel component"""

	# Try to load AI assistant component
	var ai_script = _safe_load_script("res://ui/components/panels/AIAssistantPanel.gd")
	if ai_script:
		var panel = ai_script.new()
		if panel.has_method("configure"):
			panel.configure(config)
		return panel

	# Fallback AI panel
	var panel = PanelContainer.new()
	panel.name = "AIAssistantPanel"

	var label = Label.new()
	label.text = "AI Assistant (Coming Soon)"
	panel.add_child(label)

	return panel


# === FRAGMENT FACTORIES ===
static func _create_header_component(config: Dictionary) -> Control:
	"""Create header component"""
	# Try to load the new HeaderComponent
	var component_script = _safe_load_script("res://ui/components/fragments/HeaderComponent.gd")
	if component_script:
		var header = component_script.new()
		header.configure_header(config)
		return header

	# Fallback to basic header
	var header = HBoxContainer.new()
	header.name = "HeaderComponent"

	# Title label
	var title_label = Label.new()
	title_label.text = config.get("title", "Header")
	title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(title_label)

	# Action buttons
	var action_list = config.get("actions", [])
	for action in action_list:
		var button = Button.new()
		button.text = _get_action_icon(action)
		button.custom_minimum_size = Vector2(32, 32)
		button.set_meta("action", action)
		header.add_child(button)

	return header


static func _create_content_component(config: Dictionary) -> Control:
	"""Create content component"""
	# Try to load the new ContentComponent
	var component_script = _safe_load_script("res://ui/components/fragments/ContentComponent.gd")
	if component_script:
		var content = component_script.new()
		if content.has_method("configure_content"):
			content.configure_content(config)
		return content

	# Fallback to basic content
	var content_container = VBoxContainer.new()
	content_container.name = "ContentComponent"

	var sections = config.get("sections", ["description"])
	for section_name in sections:
		var section = _create_section_component({"name": section_name})
		content_container.add_child(section)

	return content_container


static func _create_actions_component(config: Dictionary) -> Control:
	"""Create actions component"""
	# Try to load the new ActionsComponent
	var component_script = _safe_load_script("res://ui/components/fragments/ActionsComponent.gd")
	if component_script:
		var actions = component_script.new()
		if actions.has_method("configure_actions"):
			actions.configure_actions(config)
		elif actions.has_method("configure"):
			actions.configure(config)
		return actions

	# Fallback to basic actions
	var actions_container = HBoxContainer.new()
	actions_container.name = "ActionsComponent"

	var buttons = config.get("buttons", [])
	for button_config in buttons:
		var button = _create_button_component(button_config)
		actions_container.add_child(button)

	return actions_container


static func _create_section_component(config: Dictionary) -> Control:
	"""Create section component"""
	# Try to load the new SectionComponent
	var component_script = _safe_load_script("res://ui/components/fragments/SectionComponent.gd")
	if component_script:
		var section = component_script.new()
		section.configure_section(config)
		return section

	# Fallback to basic section
	var section_container = VBoxContainer.new()
	section_container.name = config.get("name", "Section") + "Component"

	# Section header
	var section_header = Button.new()
	section_header.text = "▼ " + config.get("name", "SECTION").to_upper()
	section_header.alignment = HORIZONTAL_ALIGNMENT_LEFT
	section_header.flat = true
	section_container.add_child(section_header)

	# Section content
	var section_content = VBoxContainer.new()
	section_content.name = "SectionContent"
	section_container.add_child(section_content)

	return section_container


# === CONTROL FACTORIES ===
static func _create_button_component(config: Dictionary) -> Control:
	"""Create button component"""
	var button = Button.new()

	button.text = config.get("text", "Button")

	if config.has("icon"):
		button.text = config.get("icon", "") + " " + button.text

	if config.has("size"):
		button.custom_minimum_size = config.get("size")

	if config.has("tooltip"):
		button.tooltip_text = config.get("tooltip")

	return button


static func _create_label_component(config: Dictionary) -> Control:
	"""Create label component"""
	var label = Label.new()

	label.text = config.get("text", "Label")

	if config.has("autowrap") and config.get("autowrap"):
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	return label


static func _create_container_component(config: Dictionary) -> Control:
	"""Create container component"""
	var container_type = config.get("type", "vbox")

	match container_type:
		"vbox":
			return VBoxContainer.new()
		"hbox":
			return HBoxContainer.new()
		"panel":
			return PanelContainer.new()
		"scroll":
			return ScrollContainer.new()
		_:
			return Control.new()


# === UTILITY METHODS ===
static func _setup_component_metadata(
	component: Control, component_type: String, config: Dictionary
) -> void:
	"""Setup component metadata"""
	component.set_meta("component_type", component_type)
	component.set_meta("creation_time", Time.get_unix_time_from_system())
	component.set_meta("config", config.duplicate())


static func _register_active_component(component: Control) -> void:
	"""Register component as active"""
	var component_id = component.get_meta("component_id", "")
	if component_id != "":
		_active_components[component_id] = component


static func _update_component_config(component: Control, new_config: Dictionary) -> void:
	"""Update component configuration"""
	if component.has_method("update_config"):
		component.update_config(new_config)
	elif component.has_method("configure"):
		component.configure(new_config)


static func _save_component_state(component_id: String, component: Control) -> void:
	"""Save component state for persistence"""
	if component.has_method("get_state"):
	var fallback = PanelContainer.new()
	fallback.name = "Fallback_" + component_type

	var label = Label.new()
	label.text = "Component: " + component_type + " (Fallback)"
	fallback.add_child(label)

	push_warning("[ComponentRegistry] Using fallback for: %s" % component_type)
	return fallback


static func _create_fallback_panel(_config: Dictionary) -> Control:
	"""Create basic fallback panel"""
	var panel = PanelContainer.new()
	panel.name = "FallbackInfoPanel"
	panel.custom_minimum_size = Vector2(300, 200)

	var vbox = VBoxContainer.new()
	panel.add_child(vbox)

	var panel_title = Label.new()
	panel_title.text = "Information Panel"
	vbox.add_child(panel_title)

	var panel_content = Label.new()
	panel_content.text = "Select a brain structure to see information."
	panel_content.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(panel_content)

	return panel


static func _get_action_icon(action: String) -> String:
	"""Get icon for action button"""
	var icons = {
		"close": "×",
		"bookmark": "⭐",
		"share": "📤",
		"settings": "⚙",
		"help": "?",
		"expand": "⛶",
		"collapse": "⛶"
	}
	return icons.get(action, "•")


# === PERFORMANCE AND DEBUGGING ===
static func get_registry_stats() -> Dictionary:
	"""Get registry performance statistics"""
	return {
		"total_created": _creation_count,
		"cache_hits": _cache_hits,
		"cache_misses": _cache_misses,
		"hit_ratio":
		(
			float(_cache_hits) / float(_cache_hits + _cache_misses)
			if (_cache_hits + _cache_misses) > 0
			else 0.0
		),
		"active_components": _active_components.size(),
		"cached_components": _component_cache.size(),
		"registered_factories": _factories.size()
	}


static func print_registry_stats() -> void:
	"""Print registry statistics"""
	var stats = get_registry_stats()
	print("\n=== COMPONENT REGISTRY STATS ===")
	print("Components created: %d" % stats.total_created)
	print("Cache hits: %d" % stats.cache_hits)
	print("Cache misses: %d" % stats.cache_misses)
	print("Hit ratio: %.2f%%" % (stats.hit_ratio * 100))
	print("Active components: %d" % stats.active_components)
	print("Cached components: %d" % stats.cached_components)
	print("Registered factories: %d" % stats.registered_factories)
	print("===============================\n")


static func cleanup_registry() -> void:
	"""Clean up invalid references and optimize memory"""
	var cleaned_count = 0

	# Clean up invalid cache entries
	for component_id in _component_cache.keys():
		if not is_instance_valid(_component_cache[component_id]):
			_component_cache.erase(component_id)
			_active_components.erase(component_id)
			_component_configs.erase(component_id)
			cleaned_count += 1

	if cleaned_count > 0:
		print("[ComponentRegistry] Cleaned up %d invalid references" % cleaned_count)


static func reset_registry() -> void:
	"""Reset registry (for testing)"""
	_component_cache.clear()
	_active_components.clear()
	_component_configs.clear()
	_creation_count = 0
	_cache_hits = 0
	_cache_misses = 0
	print("[ComponentRegistry] Registry reset")


# === MIGRATION HELPERS ===
static func set_legacy_mode(enabled: bool) -> void:
	"""Toggle legacy mode for gradual migration"""
	if enabled:
		FeatureFlags.enable_feature(FeatureFlags.UI_LEGACY_PANELS)
		FeatureFlags.disable_feature(FeatureFlags.UI_MODULAR_COMPONENTS)
	else:
		FeatureFlags.disable_feature(FeatureFlags.UI_LEGACY_PANELS)
		FeatureFlags.enable_feature(FeatureFlags.UI_MODULAR_COMPONENTS)

	print("[ComponentRegistry] Legacy mode: %s" % ("enabled" if enabled else "disabled"))

		var _state = component.get_state()
		# Store state in ComponentStateManager when available
		print("[ComponentRegistry] Saved state for: %s" % component_id)


static func _safe_load_script(script_path: String) -> Script:
	"""Safely load a script, returning null if not found"""
	if ResourceLoader.exists(script_path):
		return load(script_path)
	return null


static func _create_fallback_component(component_type: String, _config: Dictionary) -> Control:
	"""Create fallback component when factory not found"""
