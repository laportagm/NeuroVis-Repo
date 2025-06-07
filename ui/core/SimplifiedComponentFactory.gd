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
var factory_script = _safe_load_script("res://ui/panels/InfoPanelFactory.gd")
var panel = factory_script.create_info_panel()
var enhanced_script = _safe_load_script("res://ui/panels/EnhancedInformationPanel.gd")
var panel_2 = enhanced_script.new()
var panel_3 = PanelContainer.new()
	panel.name = "SettingsPanel"
	panel.custom_minimum_size = Vector2(300, 200)

var vbox = VBoxContainer.new()
	panel.add_child(vbox)

var title = Label.new()
	title.text = "Settings"
	vbox.add_child(title)

var content = Label.new()
	content.text = "Settings panel (simplified for core development)"
	content.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(content)

var panel_4 = PanelContainer.new()
	panel.name = "AIAssistantPanel"
	panel.custom_minimum_size = Vector2(350, 250)

var vbox_2 = VBoxContainer.new()
	panel.add_child(vbox)

var title_2 = Label.new()
	title.text = "AI Assistant"
	vbox.add_child(title)

var content_2 = Label.new()
	content.text = "AI Assistant (simplified - full features coming in Phase 3)"
	content.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(content)

var button = Button.new()
	button.text = config.get("text", "Button")

var label = Label.new()
	label.text = config.get("text", "Label")

var container_type = config.get("type", "vbox")

"vbox":
var panel_5 = PanelContainer.new()
	panel.name = "BasicInfoPanel"
	panel.custom_minimum_size = Vector2(300, 200)

var vbox_3 = VBoxContainer.new()
	panel.add_child(vbox)

var title_3 = Label.new()
	title.text = "Structure Information"
	vbox.add_child(title)

var content_3 = Label.new()
	content.text = "Select a brain structure to see information."
	content.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(content)

var fallback = PanelContainer.new()
	fallback.name = "Fallback_" + component_type

var label_2 = Label.new()
	label.text = "Component: " + component_type + " (Simplified)"
	fallback.add_child(label)

func _fix_orphaned_code():
	return _create_info_panel_direct(config)
	"settings_panel":
		return _create_settings_panel_direct(config)
		"ai_assistant_panel":
			return _create_ai_assistant_panel_direct(config)
			"button":
				return _create_button_direct(config)
				"label":
					return _create_label_direct(config)
					"container":
						return _create_container_direct(config)
						_:
							return _create_fallback_component(component_type)


							static func get_or_create(
							component_id: String, component_type: String, config: Dictionary = {}
							) -> Control:
								"""Simplified version - always create new (no caching complexity)"""

func _fix_orphaned_code():
	if component:
		component.set_meta("component_id", component_id)
		return component


		# === DIRECT COMPONENT CREATION (Simple, No Caching) ===
		static func _create_info_panel_direct(_config: Dictionary) -> Control:
			"""Create info panel using existing factory"""

			# Use existing InfoPanelFactory - this is the most reliable approach
func _fix_orphaned_code():
	if factory_script and factory_script.has_method("create_info_panel"):
func _fix_orphaned_code():
	if panel:
		print("[SimplifiedFactory] Created info panel via InfoPanelFactory")
		return panel

		# Fallback to EnhancedInformationPanel directly
func _fix_orphaned_code():
	if enhanced_script:
func _fix_orphaned_code():
	print("[SimplifiedFactory] Created info panel via EnhancedInformationPanel")
	return panel

	# Ultimate fallback
	return _create_basic_info_panel()


	static func _create_settings_panel(_config: Dictionary) -> Control:
		"""Create simple settings panel"""
func _fix_orphaned_code():
	return panel


	static func _create_ai_assistant_panel(_config: Dictionary) -> Control:
		"""Create simple AI assistant panel"""
func _fix_orphaned_code():
	return panel


	static func _create_button_direct(config: Dictionary) -> Control:
		"""Create simple button"""
func _fix_orphaned_code():
	if config.has("tooltip"):
		button.tooltip_text = config.get("tooltip")

		if config.has("size"):
			button.custom_minimum_size = config.get("size")

			return button


			static func _create_label_direct(config: Dictionary) -> Control:
				"""Create simple label"""
func _fix_orphaned_code():
	if config.get("autowrap", false):
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

		return label


		static func _create_container_direct(config: Dictionary) -> Control:
			"""Create simple container"""
func _fix_orphaned_code():
	return VBoxContainer.new()
	"hbox":
		return HBoxContainer.new()
		"panel":
			return PanelContainer.new()
			"scroll":
				return ScrollContainer.new()
				_:
					return Control.new()


					# === FALLBACK METHODS ===
					static func _create_basic_info_panel() -> Control:
						"""Create very basic info panel as ultimate fallback"""
func _fix_orphaned_code():
	print("[SimplifiedFactory] Created basic fallback info panel")
	return panel


	static func _create_fallback_component(component_type: String) -> Control:
		"""Create fallback for unknown component types"""
func _fix_orphaned_code():
	print("[SimplifiedFactory] Created fallback for: " + component_type)
	return fallback


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
