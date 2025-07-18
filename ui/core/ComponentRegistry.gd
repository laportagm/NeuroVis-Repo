# Component Registry - Central component factory and lifecycle manager
# Provides unified component creation, caching, and state management

class_name ComponentRegistry
extends RefCounted

# === DEPENDENCIES ===

const FeatureFlags = preload("res://core/features/FeatureFlags.gd")

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

	var component = _factories[component_type].call(config)

	# FIXED: Orphaned code - var cached_component = _component_cache[component_id]
	var component_2 = create_component(component_type, config)

	# FIXED: Orphaned code - var component_3 = _component_cache[component_id]

# Save component state if persistence is enabled
	var component_4 = _component_cache[component_id]
	var component_script = _safe_load_script("res://ui/components/InfoPanelComponent.gd")
	# FIXED: Orphaned code - var panel = component_script.new()
	# ORPHANED REF: panel.configure(config)
	# FIXED: Orphaned code - var enhanced_script = _safe_load_script("res://ui/panels/EnhancedInformationPanel.gd")
	# FIXED: Orphaned code - var factory_script = _safe_load_script("res://ui/panels/InfoPanelFactory.gd")
	# FIXED: Orphaned code - var panel_2 = PanelContainer.new()
	# ORPHANED REF: panel.name = "SettingsPanel"

	var label = Label.new()
	label.text = "Settings Panel (Under Development)"
	# ORPHANED REF: panel.add_child(label)

	# FIXED: Orphaned code - var ai_script = _safe_load_script("res://ui/components/panels/AIAssistantPanel.gd")
	# FIXED: Orphaned code - var panel_3 = ai_script.new()
	# FIXED: Orphaned code - var panel_4 = PanelContainer.new()
	# ORPHANED REF: panel.name = "AIAssistantPanel"

	var label_2 = Label.new()
	label.text = "AI Assistant (Coming Soon)"
	# ORPHANED REF: panel.add_child(label)

	# FIXED: Orphaned code - var component_script_2 = _safe_load_script("res://ui/components/fragments/HeaderComponent.gd")
	# FIXED: Orphaned code - var header = component_script.new()
	# ORPHANED REF: header.configure_header(config)
	# FIXED: Orphaned code - var header_2 = HBoxContainer.new()
	# ORPHANED REF: header.name = "HeaderComponent"

	# Title label
	var title_label = Label.new()
	title_label.text = config.get("title", "Header")
	title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	# ORPHANED REF: header.add_child(title_label)

	# Action buttons
	# ORPHANED REF: var action_list = config.get("actions", [])
	# FIXED: Orphaned code - var button = Button.new()
	# ORPHANED REF: button.text = _get_action_icon(action)
	# ORPHANED REF: button.custom_minimum_size = Vector2(32, 32)
	# ORPHANED REF: button.set_meta("action", action)
	# ORPHANED REF: header.add_child(button)

	# FIXED: Orphaned code - var component_script_3 = _safe_load_script("res://ui/components/fragments/ContentComponent.gd")
	# FIXED: Orphaned code - var content = component_script.new()
	# FIXED: Orphaned code - var content_container = VBoxContainer.new()
	# ORPHANED REF: content_container.name = "ContentComponent"

	var sections = config.get("sections", ["description"])
	# FIXED: Orphaned code - var section = _create_section_component({"name": section_name})
	# ORPHANED REF: content_container.add_child(section)

	# FIXED: Orphaned code - var component_script_4 = _safe_load_script("res://ui/components/fragments/ActionsComponent.gd")
	# FIXED: Orphaned code - var actions = component_script.new()
	# FIXED: Orphaned code - var actions_container = HBoxContainer.new()
	# ORPHANED REF: actions_container.name = "ActionsComponent"

	var buttons = config.get("buttons", [])
	# FIXED: Orphaned code - var button_2 = _create_button_component(button_config)
	# ORPHANED REF: actions_container.add_child(button)

	# FIXED: Orphaned code - var component_script_5 = _safe_load_script("res://ui/components/fragments/SectionComponent.gd")
	# FIXED: Orphaned code - var section_2 = component_script.new()
	# ORPHANED REF: section.configure_section(config)
	# FIXED: Orphaned code - var section_container = VBoxContainer.new()
	# ORPHANED REF: section_container.name = config.get("name", "Section") + "Component"

	# Section header
	var section_header = Button.new()
	section_header.text = "▼ " + config.get("name", "SECTION").to_upper()
	section_header.alignment = HORIZONTAL_ALIGNMENT_LEFT
	section_header.flat = true
	# ORPHANED REF: section_container.add_child(section_header)

	# Section content
	var section_content = VBoxContainer.new()
	section_content.name = "SectionContent"
	# ORPHANED REF: section_container.add_child(section_content)

	# FIXED: Orphaned code - var button_3 = Button.new()

	# ORPHANED REF: button.text = config.get("text", "Button")

	# FIXED: Orphaned code - var label_3 = Label.new()

	label.text = config.get("text", "Label")

	# FIXED: Orphaned code - var container_type = config.get("type", "vbox")

	# ORPHANED REF: "vbox":
	var component_id = component.get_meta("component_id", "")
	# FIXED: Orphaned code - var fallback = PanelContainer.new()
	# ORPHANED REF: fallback.name = "Fallback_" + component_type

	var label_4 = Label.new()
	label.text = "Component: " + component_type + " (Fallback)"
	# ORPHANED REF: fallback.add_child(label)

	# ORPHANED REF: push_warning("[ComponentRegistry] Using fallback for: %s" % component_type)
	# FIXED: Orphaned code - var panel_5 = PanelContainer.new()
	# ORPHANED REF: panel.name = "FallbackInfoPanel"
	# ORPHANED REF: panel.custom_minimum_size = Vector2(300, 200)

	# FIXED: Orphaned code - var vbox = VBoxContainer.new()
	# ORPHANED REF: panel.add_child(vbox)

	# FIXED: Orphaned code - var panel_title = Label.new()
	# ORPHANED REF: panel_title.text = "Information Panel"
	# ORPHANED REF: vbox.add_child(panel_title)

	# FIXED: Orphaned code - var panel_content = Label.new()
	# ORPHANED REF: panel_content.text = "Select a brain structure to see information."
	# ORPHANED REF: panel_content.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	# ORPHANED REF: vbox.add_child(panel_content)

	# FIXED: Orphaned code - var icons = {
"close": "×",
"bookmark": "⭐",
"share": "📤",
"settings": "⚙",
"help": "?",
"expand": "⛶",
"collapse": "⛶"
	}
	# FIXED: Orphaned code - var stats = get_registry_stats()
	# FIXED: Orphaned code - var cleaned_count = 0

# Clean up invalid cache entries

	var _state = component.get_state()
# Store state in ComponentStateManager when available

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
	# ORPHANED REF: register_factory("header", _create_header_component)
	# ORPHANED REF: register_factory("content", _create_content_component)
	# ORPHANED REF: register_factory("actions", _create_actions_component)
	# ORPHANED REF: register_factory("section", _create_section_component)

		# Control factories
	# ORPHANED REF: register_factory("button", _create_button_component)
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
	# ORPHANED REF: if is_instance_valid(cached_component):
	_cache_hits += 1
	# ORPHANED REF: _update_component_config(cached_component, config)

	if FeatureFlags.is_enabled(FeatureFlags.DEBUG_COMPONENT_INSPECTOR):
	print("[ComponentRegistry] Cache hit: %s" % component_id)

	# ORPHANED REF: return cached_component
else:
			# Clean up invalid reference
	_component_cache.erase(component_id)
	_active_components.erase(component_id)

			# Create new component
	_cache_misses += 1
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
	if FeatureFlags.is_enabled(FeatureFlags.UI_STATE_PERSISTENCE) and component:
	_save_component_state(component_id, component)

	_component_cache.erase(component_id)
	_active_components.erase(component_id)

	if FeatureFlags.is_enabled(FeatureFlags.DEBUG_COMPONENT_INSPECTOR):
	print("[ComponentRegistry] Released: %s" % component_id)


static func destroy_component(component_id: String) -> void:
	"""Completely destroy a component"""
	if _component_cache.has(component_id):
	if is_instance_valid(component):
	component.queue_free()

	_component_cache.erase(component_id)
	_active_components.erase(component_id)
	_component_configs.erase(component_id)

	if FeatureFlags.is_enabled(FeatureFlags.DEBUG_COMPONENT_INSPECTOR):
	print("[ComponentRegistry] Destroyed: %s" % component_id)


		# === COMPONENT FACTORIES ===
static func _create_info_panel(config: Dictionary) -> Control:
	# ORPHANED REF: """Create information panel component"""

			# Use new modular system if enabled
	if FeatureFlags.is_enabled(FeatureFlags.UI_MODULAR_COMPONENTS):
	return _create_modular_info_panel(config)
else:
	return _create_legacy_info_panel(config)


static func _create_modular_info_panel(config: Dictionary) -> Control:
	# ORPHANED REF: """Create new modular info panel"""

						# Try to load the new InfoPanelComponent
	if component_script:
	# ORPHANED REF: return panel

# Fallback to enhanced panel if available
	# ORPHANED REF: if enhanced_script:
	# ORPHANED REF: return enhanced_script.new()

	# Ultimate fallback
	return _create_fallback_panel(config)


static func _create_legacy_info_panel(config: Dictionary) -> Control:
	# ORPHANED REF: """Create legacy info panel using existing factory"""

	# ORPHANED REF: if factory_script and factory_script.has_method("create_info_panel"):
	# ORPHANED REF: return factory_script.create_info_panel()

	return _create_fallback_panel(config)


static func _create_settings_panel(_config: Dictionary) -> Control:
	# ORPHANED REF: """Create settings panel component"""
	# ORPHANED REF: return panel


static func _create_ai_assistant_panel(config: Dictionary) -> Control:
	# ORPHANED REF: """Create AI assistant panel component"""

	# Try to load AI assistant component
	# ORPHANED REF: if ai_script:
	# ORPHANED REF: if panel.has_method("configure"):
	# ORPHANED REF: panel.configure(config)
	# ORPHANED REF: return panel

	# Fallback AI panel
	# ORPHANED REF: return panel


# === FRAGMENT FACTORIES ===
static func _create_header_component(config: Dictionary) -> Control:
	# ORPHANED REF: """Create header component"""
	# Try to load the new HeaderComponent
	if component_script:
	# ORPHANED REF: return header

# Fallback to basic header
	for action in action_list:
	# ORPHANED REF: return header


static func _create_content_component(config: Dictionary) -> Control:
	# ORPHANED REF: """Create content component"""
	# Try to load the new ContentComponent
	if component_script:
	# ORPHANED REF: if content.has_method("configure_content"):
	# ORPHANED REF: content.configure_content(config)
	# ORPHANED REF: return content

	# Fallback to basic content
	for section_name in sections:
	# ORPHANED REF: return content_container


static func _create_actions_component(config: Dictionary) -> Control:
	# ORPHANED REF: """Create actions component"""
	# Try to load the new ActionsComponent
	if component_script:
	# ORPHANED REF: if actions.has_method("configure_actions"):
	# ORPHANED REF: actions.configure_actions(config)
	# ORPHANED REF: elif actions.has_method("configure"):
	# ORPHANED REF: actions.configure(config)
	# ORPHANED REF: return actions

		# Fallback to basic actions
	for button_config in buttons:
	# ORPHANED REF: return actions_container


static func _create_section_component(config: Dictionary) -> Control:
	# ORPHANED REF: """Create section component"""
	# Try to load the new SectionComponent
	if component_script:
	# ORPHANED REF: return section

# Fallback to basic section
	# ORPHANED REF: return section_container


# === CONTROL FACTORIES ===
static func _create_button_component(config: Dictionary) -> Control:
	# ORPHANED REF: """Create button component"""
	if config.has("icon"):
	# ORPHANED REF: button.text = config.get("icon", "") + " " + button.text

	if config.has("size"):
	# ORPHANED REF: button.custom_minimum_size = config.get("size")

	if config.has("tooltip"):
	# ORPHANED REF: button.tooltip_text = config.get("tooltip")

	# ORPHANED REF: return button


static func _create_label_component(config: Dictionary) -> Control:
	"""Create label component"""
	if config.has("autowrap") and config.get("autowrap"):
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	return label


static func _create_container_component(config: Dictionary) -> Control:
	"""Create container component"""
	return VBoxContainer.new()
"hbox":
	return HBoxContainer.new()
	# ORPHANED REF: "panel":
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
	# ORPHANED REF: return fallback


static func _create_fallback_panel(_config: Dictionary) -> Control:
	# ORPHANED REF: """Create basic fallback panel"""
	# ORPHANED REF: return panel


static func _get_action_icon(action: String) -> String:
	# ORPHANED REF: """Get icon for action button"""
	# ORPHANED REF: return icons.get(action, "•")


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
	print("\n=== COMPONENT REGISTRY STATS ===")
	# ORPHANED REF: print("Components created: %d" % stats.total_created)
	# ORPHANED REF: print("Cache hits: %d" % stats.cache_hits)
	# ORPHANED REF: print("Cache misses: %d" % stats.cache_misses)
	# ORPHANED REF: print("Hit ratio: %.2f%%" % (stats.hit_ratio * 100))
	# ORPHANED REF: print("Active components: %d" % stats.active_components)
	# ORPHANED REF: print("Cached components: %d" % stats.cached_components)
	# ORPHANED REF: print("Registered factories: %d" % stats.registered_factories)
	print("===============================\n")


static func cleanup_registry() -> void:
	"""Clean up invalid references and optimize memory"""
	for component_id in _component_cache.keys():
	if not is_instance_valid(_component_cache[component_id]):
	_component_cache.erase(component_id)
	_active_components.erase(component_id)
	_component_configs.erase(component_id)
	# ORPHANED REF: cleaned_count += 1

	# ORPHANED REF: if cleaned_count > 0:
	# ORPHANED REF: print("[ComponentRegistry] Cleaned up %d invalid references" % cleaned_count)


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

	print("[ComponentRegistry] Saved state for: %s" % component_id)


static func _safe_load_script(script_path: String) -> Script:
	"""Safely load a script, returning null if not found"""
	if ResourceLoader.exists(script_path):
	return load(script_path)
	return null


static func _create_fallback_component(component_type: String, _config: Dictionary) -> Control:
	# ORPHANED REF: """Create fallback component when factory not found"""

	return null
