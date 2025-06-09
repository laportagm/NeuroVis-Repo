# Simplified Component Factory for Core Development
# Replaces ComponentRegistry with direct, simple component creation
# Use during core architecture development to reduce complexity

class_name SimplifiedComponentFactory
extends RefCounted


# === STATIC INTERFACE (Compatible with ComponentRegistry) ===
static func create_component(component_type: String, config: Dictionary = {}) -> Control:
	"""Create component using direct, simple approach"""

		"info_panel":
	var component = create_component(component_type, config)
	# FIXED: Orphaned code - var factory_script = _safe_load_script("res://ui/panels/InfoPanelFactory.gd")
	# FIXED: Orphaned code - var panel = factory_script.create_info_panel()
	# FIXED: Orphaned code - var enhanced_script = _safe_load_script("res://ui/panels/EnhancedInformationPanel.gd")
	# FIXED: Orphaned code - var panel_2 = enhanced_script.new()
	# FIXED: Orphaned code - var panel_3 = PanelContainer.new()
	# ORPHANED REF: panel.name = "SettingsPanel"
	# ORPHANED REF: panel.custom_minimum_size = Vector2(300, 200)

	# FIXED: Orphaned code - var vbox = VBoxContainer.new()
	# ORPHANED REF: panel.add_child(vbox)

	# FIXED: Orphaned code - var title = Label.new()
	# ORPHANED REF: title.text = "Settings"
	# ORPHANED REF: vbox.add_child(title)

	# FIXED: Orphaned code - var content = Label.new()
	# ORPHANED REF: content.text = "Settings panel (simplified for core development)"
	# ORPHANED REF: content.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	# ORPHANED REF: vbox.add_child(content)

	# FIXED: Orphaned code - var panel_4 = PanelContainer.new()
	# ORPHANED REF: panel.name = "AIAssistantPanel"
	# ORPHANED REF: panel.custom_minimum_size = Vector2(350, 250)

	# FIXED: Orphaned code - var vbox_2 = VBoxContainer.new()
	# ORPHANED REF: panel.add_child(vbox)

	# FIXED: Orphaned code - var title_2 = Label.new()
	# ORPHANED REF: title.text = "AI Assistant"
	# ORPHANED REF: vbox.add_child(title)

	# FIXED: Orphaned code - var content_2 = Label.new()
	# ORPHANED REF: content.text = "AI Assistant (simplified - full features coming in Phase 3)"
	# ORPHANED REF: content.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	# ORPHANED REF: vbox.add_child(content)

	# FIXED: Orphaned code - var button = Button.new()
	# ORPHANED REF: button.text = config.get("text", "Button")

	# FIXED: Orphaned code - var label = Label.new()
	# ORPHANED REF: label.text = config.get("text", "Label")

	# FIXED: Orphaned code - var container_type = config.get("type", "vbox")

	# ORPHANED REF: "vbox":
	var panel_5 = PanelContainer.new()
	# ORPHANED REF: panel.name = "BasicInfoPanel"
	# ORPHANED REF: panel.custom_minimum_size = Vector2(300, 200)

	# FIXED: Orphaned code - var vbox_3 = VBoxContainer.new()
	# ORPHANED REF: panel.add_child(vbox)

	# FIXED: Orphaned code - var title_3 = Label.new()
	# ORPHANED REF: title.text = "Structure Information"
	# ORPHANED REF: vbox.add_child(title)

	# FIXED: Orphaned code - var content_3 = Label.new()
	# ORPHANED REF: content.text = "Select a brain structure to see information."
	# ORPHANED REF: content.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	# ORPHANED REF: vbox.add_child(content)

	# FIXED: Orphaned code - var fallback = PanelContainer.new()
	# ORPHANED REF: fallback.name = "Fallback_" + component_type

	var label_2 = Label.new()
	# ORPHANED REF: label.text = "Component: " + component_type + " (Simplified)"
	# ORPHANED REF: fallback.add_child(label)

	return _create_info_panel_direct(config)
		"settings_panel":
	return _create_settings_panel_direct(config)
		"ai_assistant_panel":
	return _create_ai_assistant_panel_direct(config)
	# ORPHANED REF: "button":
	return _create_button_direct(config)
	# ORPHANED REF: "label":
	return _create_label_direct(config)
		"container":
	return _create_container_direct(config)
_:
	return _create_fallback_component(component_type)


	static func get_or_create(
component_id: String, component_type: String, config: Dictionary = {}
	) -> Control:
	"""Simplified version - always create new (no caching complexity)"""

	if component:
	component.set_meta("component_id", component_id)
	return component


	# === DIRECT COMPONENT CREATION (Simple, No Caching) ===
static func _create_info_panel_direct(_config: Dictionary) -> Control:
	# ORPHANED REF: """Create info panel using existing factory"""

		# Use existing InfoPanelFactory - this is the most reliable approach
	# ORPHANED REF: if factory_script and factory_script.has_method("create_info_panel"):
	# ORPHANED REF: if panel:
	# ORPHANED REF: print("[SimplifiedFactory] Created info panel via InfoPanelFactory")
	# ORPHANED REF: return panel

	# Fallback to EnhancedInformationPanel directly
	# ORPHANED REF: if enhanced_script:
	# ORPHANED REF: print("[SimplifiedFactory] Created info panel via EnhancedInformationPanel")
	# ORPHANED REF: return panel

# Ultimate fallback
	return _create_basic_info_panel()


static func _create_settings_panel(_config: Dictionary) -> Control:
	# ORPHANED REF: """Create simple settings panel"""
	# ORPHANED REF: return panel


static func _create_ai_assistant_panel(_config: Dictionary) -> Control:
	# ORPHANED REF: """Create simple AI assistant panel"""
	# ORPHANED REF: return panel


static func _create_button_direct(config: Dictionary) -> Control:
	# ORPHANED REF: """Create simple button"""
	if config.has("tooltip"):
	# ORPHANED REF: button.tooltip_text = config.get("tooltip")

	if config.has("size"):
	# ORPHANED REF: button.custom_minimum_size = config.get("size")

	# ORPHANED REF: return button


static func _create_label_direct(config: Dictionary) -> Control:
	# ORPHANED REF: """Create simple label"""
	if config.get("autowrap", false):
	# ORPHANED REF: label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	# ORPHANED REF: return label


static func _create_container_direct(config: Dictionary) -> Control:
	"""Create simple container"""
	return VBoxContainer.new()
		"hbox":
	return HBoxContainer.new()
	# ORPHANED REF: "panel":
	return PanelContainer.new()
		"scroll":
	return ScrollContainer.new()
_:
	return Control.new()


				# === FALLBACK METHODS ===
static func _create_basic_info_panel() -> Control:
	# ORPHANED REF: """Create very basic info panel as ultimate fallback"""
	# ORPHANED REF: print("[SimplifiedFactory] Created basic fallback info panel")
	# ORPHANED REF: return panel


static func _create_fallback_component(component_type: String) -> Control:
	# ORPHANED REF: """Create fallback for unknown component types"""
	# ORPHANED REF: print("[SimplifiedFactory] Created fallback for: " + component_type)
	# ORPHANED REF: return fallback


# === UTILITY METHODS ===
static func _safe_load_script(script_path: String) -> Script:
	"""Safely load script without errors"""
	if ResourceLoader.exists(script_path):
	return load(script_path)
	return null


		# === COMPATIBILITY METHODS ===
		# These methods provide compatibility with ComponentRegistry interface
static func register_factory(_component_type: String, _factory_function: Callable) -> void:
	"""No-op for compatibility"""
	pass


static func release_component(_component_id: String) -> void:
	"""No-op for compatibility"""
	pass


static func destroy_component(_component_id: String) -> void:
	"""No-op for compatibility"""
	pass


static func get_registry_stats() -> Dictionary:
	"""Return empty stats for compatibility"""
	return {
"total_created": 0,
"cache_hits": 0,
"cache_misses": 0,
"hit_ratio": 0.0,
"active_components": 0,
"cached_components": 0,
"registered_factories": 0
	}


static func print_registry_stats() -> void:
	"""Print simplified stats"""
	print("\n=== SIMPLIFIED COMPONENT FACTORY ===")
	print("Mode: Core Development (No Caching)")
	print("Components: Created directly as needed")
	print("Complexity: Minimal")
	print("===================================\n")

	pass
