## DebugManager.gd
## Manages all debug commands and testing utilities for the NeuroVis main scene
##
## This component handles debug command registration and execution,
## providing a centralized location for all debugging functionality.

class_name DebugManager
extends Node

# === DEPENDENCIES ===

var ai_integration: Node
var selection_manager: Node
var info_panel: Control
var comparative_panel: Control

# === AUTOLOAD REFERENCES ===
var DebugCmd = null
var FeatureFlags = null
var ComponentRegistryScript = null
var ComponentStateManagerScript = null
var UIComponentFactoryScript = null


# === INITIALIZATION ===
	var UIComponentFactoryPath = "res://ui/core/UIComponentFactory.gd"
	if ResourceLoader.exists(UIComponentFactoryPath):
		UIComponentFactoryScript = load(UIComponentFactoryPath)
	else:
		push_warning(
			"[DebugManager] Warning: UIComponentFactory not found at " + UIComponentFactoryPath
		)


	var active_provider = ai_integration.get_active_provider_id()
	var status = ai_integration.get_provider_status()

	print("[DebugManager] Info: === AI INTEGRATION STATUS ===")
	print("[DebugManager] Info: Active Provider: %s" % active_provider)
	print("[DebugManager] Info: Status: %s" % str(status))
	print("[DebugManager] Info: Current Structure: %s" % ai_integration.get_current_structure())
	print(
		(
			"[DebugManager] Info: Available Providers: %s"
			% str(ai_integration.get_available_providers())
		)
	)
	print("[DebugManager] Info: ============================\n")


	var provider_id = ""
	if args.size() > 0:
		provider_id = args[0]

	print(
		(
			"[DebugManager] Info: Showing setup dialog for provider: %s"
			% (provider_id if not provider_id.is_empty() else "default")
		)
	)
	ai_integration.show_setup_dialog(provider_id)


		var providers = ai_integration.get_available_providers()
		var active = ai_integration.get_active_provider_id()

		print("[DebugManager] Info: === AVAILABLE AI PROVIDERS ===")
		for provider in providers:
			var status = ai_integration.get_provider_status(provider)
			print(
				(
					"[DebugManager] Info: %s %s - %s"
					% ["►" if provider == active else " ", provider, str(status)]
				)
			)
		print("[DebugManager] Info: =============================\n")

		print("[DebugManager] Info: Use 'ai_provider <provider_id>' to change provider")
	else:
		# Change provider
		var provider_id = args[0]
		var result = ai_integration.set_active_provider(provider_id)

		if result:
			print("[DebugManager] Info: Changed provider to: %s" % provider_id)
		else:
			push_error("[DebugManager] Error: Failed to change provider to: %s" % provider_id)
			print(
				(
					"[DebugManager] Info: Available providers: %s"
					% str(ai_integration.get_available_providers())
				)
			)


# === FOUNDATION TESTING COMMANDS ===
		var test_btn = ComponentRegistryScript.create_component("button", {"text": "Test"})
		if test_btn:
			print("[DebugManager] Info:   - Component creation: Working")
			test_btn.queue_free()
		else:
			push_warning("[DebugManager] Warning:   - Component creation: Failed")
	else:
		push_warning("[DebugManager] Warning: ✗ ComponentRegistry: Not available")

	# Test state manager
	if (
		ComponentStateManagerScript
		and ComponentStateManagerScript.has_method("save_component_state")
	):
		print("[DebugManager] Info: ✓ ComponentStateManager: Available")
		ComponentStateManagerScript.save_component_state("test_key", {"test": true})
		var data = ComponentStateManagerScript.restore_component_state("test_key")
		if data and data.has("test"):
			print("[DebugManager] Info:   - State save/restore: Working")
		else:
			push_warning("[DebugManager] Warning:   - State save/restore: Failed")
		ComponentStateManagerScript.remove_component_state("test_key")
	else:
		push_warning("[DebugManager] Warning: ✗ ComponentStateManager: Not available")

	print("[DebugManager] Info: ===============================\n")


		var button = UIComponentFactoryScript.create_button("Test Button", "primary")
		if button:
			print("[DebugManager] Info:   - Button creation: Working")
			button.queue_free()
		else:
			push_warning("[DebugManager] Warning:   - Button creation: Failed")

		var label = UIComponentFactoryScript.create_label("Test Label", "body")
		if label:
			print("[DebugManager] Info:   - Label creation: Working")
			label.queue_free()
		else:
			push_warning("[DebugManager] Warning:   - Label creation: Failed")
	else:
		push_warning("[DebugManager] Warning: ✗ UIComponentFactory: Not available")

	# Test component registry
	print("[DebugManager] Info: Testing fragment components:")

	# Test header fragment
	var header_config = {"title": "Test Header", "subtitle": "Test Subtitle", "icon": "info"}
	var header = ComponentRegistryScript.create_component("header", header_config)
	if header:
		print("[DebugManager] Info: ✓ Header fragment created")
		header.queue_free()
	else:
		push_warning("[DebugManager] Warning: ✗ Header fragment failed")

	# Test content fragment
	var content_config = {"sections": ["description", "functions", "clinical_relevance"]}
	var content = ComponentRegistryScript.create_component("content", content_config)
	if content:
		print("[DebugManager] Info: ✓ Content fragment created")
		content.queue_free()
	else:
		push_warning("[DebugManager] Warning: ✗ Content fragment failed")

	# Test actions fragment
	var actions_config = {
		"preset": "default",
		"buttons":
		[{"text": "Learn More", "action": "learn"}, {"text": "Bookmark", "action": "bookmark"}]
	}
	var actions = ComponentRegistryScript.create_component("actions", actions_config)
	if actions:
		print("[DebugManager] Info: ✓ Actions fragment created")
		actions.queue_free()
	else:
		push_warning("[DebugManager] Warning: ✗ Actions fragment failed")

	# Test section fragment
	var section_config = {
		"name": "description", "title": "Description", "collapsible": true, "expanded": true
	}
	var section = ComponentRegistryScript.create_component("section", section_config)
	if section:
		print("[DebugManager] Info: ✓ Section fragment created")
		section.queue_free()
	else:
		push_warning("[DebugManager] Warning: ✗ Section fragment failed")

	print("[DebugManager] Info: =================================\n")


	var test_script = preload("res://test_phase3_features.gd")
	if test_script:
		var test_instance = test_script.new()
		get_tree().root.add_child(test_instance)

		# Auto-remove test instance after completion
		await get_tree().create_timer(5.0).timeout
		if is_instance_valid(test_instance):
			test_instance.queue_free()
			print("[DebugManager] Info: ✓ Phase 3 test instance cleaned up")
	else:
		push_error("[DebugManager] Error: ✗ Failed to load Phase 3 test script")

	print("[DebugManager] Info: === PHASE 3 TESTS COMPLETED ===\n")

func _ready() -> void:
	"""Initialize debug manager and get autoload references"""
	_get_autoload_references()
	_register_debug_commands()


func setup(dependencies: Dictionary) -> void:
	"""Setup debug manager with required dependencies"""
	ai_integration = dependencies.get("ai_integration")
	selection_manager = dependencies.get("selection_manager")
	info_panel = dependencies.get("info_panel")
	comparative_panel = dependencies.get("comparative_panel")


# === DEBUG COMMAND REGISTRATION ===

func _get_autoload_references() -> void:
	"""Get references to autoload singletons with safe access patterns"""
	# Safe DebugCmd access
	if has_node("/root/DebugCmd"):
		DebugCmd = get_node("/root/DebugCmd")
	else:
		push_warning("[DebugManager] Warning: DebugCmd not available")

	# Safe FeatureFlags access
	if has_node("/root/FeatureFlags"):
		FeatureFlags = get_node("/root/FeatureFlags")
	else:
		push_warning("[DebugManager] Warning: FeatureFlags not available")

	# Safe ComponentRegistry access
	if has_node("/root/ComponentRegistry"):
		ComponentRegistryScript = get_node("/root/ComponentRegistry")
	else:
		push_warning("[DebugManager] Warning: ComponentRegistry not available")

	# Safe ComponentStateManager access
	if has_node("/root/ComponentStateManager"):
		ComponentStateManagerScript = get_node("/root/ComponentStateManager")
	else:
		push_warning("[DebugManager] Warning: ComponentStateManager not available")

	# Get UI component factory from preload
func _register_debug_commands() -> void:
	"""Register all debug commands with the debug system"""
	if not DebugCmd:
		push_warning(
			"[DebugManager] Warning: DebugCmd not available, skipping command registration"
		)
		return

	# Verify DebugCmd has the register_command method
	if not DebugCmd.has_method("register_command"):
		push_warning("[DebugManager] Warning: DebugCmd.register_command method not available")
		return

	# AI commands
	DebugCmd.register_command("ai_status", _debug_ai_status, "Check AI integration status")
	DebugCmd.register_command("ai_setup", _debug_ai_setup, "Show AI setup dialog [provider_id]")
	DebugCmd.register_command(
		"ai_provider", _debug_ai_provider, "List or change AI providers [provider_id]"
	)

	# Foundation testing commands
	DebugCmd.register_command(
		"test_foundation", _debug_test_foundation, "Test foundation layer components"
	)
	DebugCmd.register_command("test_components", _debug_test_components, "Test UI component system")
	DebugCmd.register_command(
		"test_phase3",
		_debug_test_phase3,
		"Test Phase 3 features (StyleEngine & AdvancedInteractions)"
	)

	print("[DebugManager] Info: Debug commands registered")


# === AI DEBUG COMMANDS ===
func _debug_ai_status(args: Array = []) -> void:
	"""Debug command to check AI integration status"""
	if not ai_integration:
		push_warning("[DebugManager] Warning: AI integration not initialized")
		return

func _debug_ai_setup(args: Array = []) -> void:
	"""Debug command to show AI setup dialog"""
	if not ai_integration:
		push_warning("[DebugManager] Warning: AI integration not initialized")
		return

func _debug_ai_provider(args: Array = []) -> void:
	"""Debug command to list or change AI providers"""
	if not ai_integration:
		push_warning("[DebugManager] Warning: AI integration not initialized")
		return

	if args.size() == 0:
		# List providers
func _debug_test_foundation(args: Array = []) -> void:
	"""Debug command to test foundation layer"""
	print("[DebugManager] Info: === TESTING FOUNDATION LAYER ===")

	# Test feature flags
	if FeatureFlags and FeatureFlags.has_method("is_enabled"):
		print("[DebugManager] Info: ✓ FeatureFlags: Available")
		# Safe access to feature flag constants
		if FeatureFlags.has_method("get") or "UI_MODULAR_COMPONENTS" in FeatureFlags:
			print(
				(
					"[DebugManager] Info:   - UI_MODULAR_COMPONENTS: %s"
					% (
						"Enabled"
						if FeatureFlags.is_enabled(FeatureFlags.UI_MODULAR_COMPONENTS)
						else "Disabled"
					)
				)
			)
		if FeatureFlags.has_method("is_enabled"):
			print(
				(
					"[DebugManager] Info:   - MULTI_STRUCTURE_SELECTION: %s"
					% (
						"Enabled"
						if FeatureFlags.is_enabled("multi_structure_selection")
						else "Disabled"
					)
				)
			)
		if FeatureFlags.has_method("get") or "UI_STYLE_ENGINE" in FeatureFlags:
			print(
				(
					"[DebugManager] Info:   - UI_STYLE_ENGINE: %s"
					% (
						"Enabled"
						if FeatureFlags.is_enabled(FeatureFlags.UI_STYLE_ENGINE)
						else "Disabled"
					)
				)
			)
	else:
		push_warning("[DebugManager] Warning: ✗ FeatureFlags: Not available")

	# Test component registry
	if ComponentRegistryScript and ComponentRegistryScript.has_method("create_component"):
		print("[DebugManager] Info: ✓ ComponentRegistry: Available")
func _debug_test_components(args: Array = []) -> void:
	"""Debug command to test UI component system"""
	print("[DebugManager] Info: === TESTING UI COMPONENT SYSTEM ===")

	# Test component factory
	if UIComponentFactoryScript and UIComponentFactoryScript.has_method("create_button"):
		print("[DebugManager] Info: ✓ UIComponentFactory: Available")

		# Test creating various components
func _debug_test_phase3(args: Array = []) -> void:
	"""Test Phase 3: StyleEngine and AdvancedInteractionSystem"""
	print("[DebugManager] Info: === TESTING PHASE 3: STYLE ENGINE & ADVANCED INTERACTIONS ===")

	# Enable Phase 3 features for testing with safety checks
	if FeatureFlags and FeatureFlags.has_method("enable_feature"):
		if "UI_STYLE_ENGINE" in FeatureFlags:
			FeatureFlags.enable_feature(FeatureFlags.UI_STYLE_ENGINE)
		if "UI_ADVANCED_INTERACTIONS" in FeatureFlags:
			FeatureFlags.enable_feature(FeatureFlags.UI_ADVANCED_INTERACTIONS)
		if "UI_SMOOTH_ANIMATIONS" in FeatureFlags:
			FeatureFlags.enable_feature(FeatureFlags.UI_SMOOTH_ANIMATIONS)
		if "UI_CONTEXT_MENUS" in FeatureFlags:
			FeatureFlags.enable_feature(FeatureFlags.UI_CONTEXT_MENUS)
		if "UI_GESTURE_RECOGNITION" in FeatureFlags:
			FeatureFlags.enable_feature(FeatureFlags.UI_GESTURE_RECOGNITION)
	else:
		push_warning("[DebugManager] Warning: FeatureFlags.enable_feature not available")

	# Load test script
