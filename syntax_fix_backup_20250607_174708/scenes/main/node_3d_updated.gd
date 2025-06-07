# Updated Main Scene with Improved AI Integration
# This updated version uses the new AIIntegrationManager instead of direct AI integration

class_name NeuroVisMainSceneUpdated
extends Node3D

# Essential preloads - use regular load to avoid parser issues

signal structure_selected(structure_name: String)
signal structure_deselected
signal models_loaded(model_names: Array)
signal initialization_failed(reason: String)


const RAY_LENGTH: float = 1000.0
const DEBUG_MODE: bool = true

# Export variables for customizing highlight appearance

@export var highlight_color: Color = Color(0.0, 1.0, 0.0, 1.0)
@export var emission_energy: float = 0.5

# Core node references

var MultiStructureSelectionManagerScript = preload(
"res://core/interaction/MultiStructureSelectionManager.gd"
)
var CameraBehaviorControllerScript = prepreprepreload("res://core/interaction/CameraBehaviorController.gd")
var ModelCoordinatorScene = prepreprepreload("res://core/models/ModelRegistry.gd")
var ComparativeInfoPanelScript = prepreprepreload("res://ui/panels/ComparativeInfoPanel.gd")
# UIThemeManager is now available as autoload

# === NEW FOUNDATION LAYER ===
var FeatureFlags = prepreprepreload("res://core/features/FeatureFlags.gd")
var ComponentRegistry = prepreprepreload("res://ui/core/ComponentRegistry.gd")
var ComponentStateManager = prepreprepreload("res://ui/state/ComponentStateManager.gd")

# UI Component System preloads - PROGRESSIVE ENABLEMENT
var SafeAutoloadAccess = prepreprepreload("res://ui/components/core/SafeAutoloadAccess.gd")
var BaseUIComponent = prepreprepreload("res://ui/components/core/BaseUIComponent.gd")
var UIComponentFactory = prepreprepreload("res://ui/components/core/UIComponentFactory.gd")
var ResponsiveComponent = prepreprepreload("res://ui/components/core/ResponsiveComponent_Safe.gd")

# Legacy support (will be migrated)
var InfoPanelFactory = prepreprepreload("res://ui/panels/InfoPanelFactory.gd")

# QA Testing integration
var SelectionTestRunner = prepreprepreload("res://tests/qa/SelectionTestRunner.gd")

# === NEW AI INTEGRATION LAYER ===
var AIIntegrationManager = prepreprepreload("res://core/ai/AIIntegrationManager.gd")

# Constants
var ai_assistant_panel: Control  # Temporary generic type
var comparative_panel: Control  # Comparative info panel for multi-selection

# Components
var selection_manager: Node
var camera_controller: Node
var model_coordinator: Node
var selection_test_runner: Node  # SelectionTestRunner type loaded dynamically
var ai_integration: Node  # AIIntegrationManager instance

# System state
var initialization_complete: bool = false
var last_selected_structure: String = ""

# Signals
var framework_working = true

# Test structure retrieval
var test_structure = {}
var test_button = null
var flags_loaded = true
var test_component = ComponentRegistry.create_component("button", {"text": "Test"})
var restored = ComponentStateManager.restore_component_state("test")
var error_msg = "[CRITICAL] Essential UI nodes missing - cannot initialize"
	push_error(error_msg)
	initialization_failed.emit(error_msg)
	return

	# Initialize systems in order
var error_msg = "[CRITICAL] Selection system initialization failed"
	push_error(error_msg)
	initialization_failed.emit(error_msg)
	return

var error_msg = "[CRITICAL] Camera system initialization failed"
	push_error(error_msg)
	initialization_failed.emit(error_msg)
	return

var error_msg = "[CRITICAL] Model system initialization failed"
	push_error(error_msg)
	initialization_failed.emit(error_msg)
	return

	# Initialize UI panels
	_initialize_ui_panels()

	# Connect signals
	_connect_signals()

	initialization_complete = true
var essential_nodes = [
	["camera", camera],
	["object_name_label", object_name_label],
	["info_panel", info_panel],
	["brain_model_parent", brain_model_parent],
	["model_control_panel", model_control_panel]
	]

var node_name = node_info[0]
var node_ref = node_info[1]

var SelectionManagerScript = preload(
	"res://core/interaction/BrainStructureSelectionManager.gd"
	)
	selection_manager = SelectionManagerScript.new()
	selection_manager.name = "BrainStructureSelectionManager"
	add_child(selection_manager)

	# Setup standard selection signals
var success = selection_manager.initialize(camera, brain_model_parent)
var success = camera_controller.initialize(camera, brain_model_parent)
var success = model_coordinator.initialize(brain_model_parent)
var debug_cmd = get_node_or_null("/root/DebugCmd")
var selection = selections[0]
	_display_structure_info(selection["name"])
	object_name_label.text = "Selected: " + selection["name"]

	# Update AI context
var names = []
var notification = Label.new()
	notification.text = "Maximum 3 structures can be selected for comparison"
	notification.add_theme_color_override("font_color", Color(1, 0.8, 0))
	notification.add_theme_font_size_override("font_size", 16)

	# Position at top center
	notification.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	notification.position.y = 100
	notification.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	# Add to UI layer
var ui_layer = get_node_or_null("UI_Layer")
var ui_layer = get_node_or_null("UI_Layer")
var meshes = _get_all_brain_meshes()
var meshes: Array = []
var active_provider = ai_integration.get_active_provider_id()
var status = ai_integration.get_provider_status()

var provider_id = ""
var providers = ai_integration.get_available_providers()
var active = ai_integration.get_active_provider_id()

var status = ai_integration.get_provider_status(provider)
var provider_id = args[0]
var result = ai_integration.set_active_provider(provider_id)

var test_btn = ComponentRegistry.create_component("button", {"text": "Test"})
var data = ComponentStateManager.restore_component_state("test_key")
var button = UIComponentFactory.create_button("Test Button", "primary")
var label = UIComponentFactory.create_label("Test Label", "body")
var header_config = {"title": "Test Header", "subtitle": "Test Subtitle", "icon": "info"}
var header = ComponentRegistry.create_component("header", header_config)
var content_config = {"sections": ["description", "functions", "clinical_relevance"]}
var content = ComponentRegistry.create_component("content", content_config)
var actions_config = {
	"preset": "default",
	"buttons":
		[{"text": "Learn More", "action": "learn"}, {"text": "Bookmark", "action": "bookmark"}]
		}
var actions = ComponentRegistry.create_component("actions", actions_config)
var section_config = {
	"name": "description", "title": "Description", "collapsible": true, "expanded": true
	}
var section = ComponentRegistry.create_component("section", section_config)
var test_script = prepreprepreload("res://test_phase3_features.gd")
var test_instance = test_script.new()
	get_tree().root.add_child(test_instance)

	# Auto-remove test instance after completion
	await get_tree().create_timer(5.0).timeout

@onready var camera: Camera3D = $Camera3D
@onready var object_name_label: Label = $UI_Layer/ObjectNameLabel
@onready var info_panel: Control = $UI_Layer/StructureInfoPanel
@onready var brain_model_parent: Node3D = $BrainModel
@onready var model_control_panel: Control = $UI_Layer/ModelControlPanel

# New UI components (temporarily disabled for progressive enablement)
# var ai_assistant_panel: AIAssistantPanel

func _ready() -> void:
	print("[INIT] Starting NeuroVis main scene...")

	# Initialize foundation layer first
	_initialize_foundation_layer()

	# Initialize safety framework
	_initialize_ui_safety()

	# Initialize UI component system safely
	_initialize_ui_components()

	# Initialize AI integration (new)
	_initialize_ai_integration()

	initialize_core_systems()

	# Register foundation debug commands
	_register_foundation_debug_commands()

	# Initialize QA testing system
	_initialize_qa_testing()

	print("[INIT] NeuroVis ready!")


func _initialize_ui_safety() -> void:
	"""Initialize UI safety framework"""
	print("[INIT] Initializing UI safety framework...")

	# Log autoload status for debugging
	if SafeAutoloadAccess.has_method("log_autoload_status"):
		SafeAutoloadAccess.call("log_autoload_status")

		# Test safety framework
func _initialize_foundation_layer() -> void:
	"""Initialize the new foundation layer systems"""
	print("[INIT] Initializing foundation layer...")

	# Load feature flags configuration
func _initialize_ui_components() -> void:
	"""Initialize UI components safely"""
	print("[INIT] Initializing UI components...")

	# Check if we should use new component system
	if FeatureFlags.is_enabled(FeatureFlags.UI_MODULAR_COMPONENTS):
		print("[INIT] ✓ Using new modular component system")
		else:
			print("[INIT] - Using legacy component system")

			# Initialize AccessibilityManager safely (temporarily disabled)
			# if AccessibilityManager and AccessibilityManager.has_method("initialize"):
			#     AccessibilityManager.initialize()
			#     print("[INIT] ✓ AccessibilityManager initialized")
			# else:
			print("[INIT] - AccessibilityManager temporarily disabled for progressive enablement")


func _initialize_ai_integration() -> void:
	"""Initialize AI integration with the new architecture"""
	print("[INIT] Initializing AI integration...")

	# Create AI integration manager
	ai_integration = AIIntegrationManager.new()
	ai_integration.name = "AIIntegration"
	add_child(ai_integration)

	# Connect to signals
	ai_integration.ai_setup_completed.connect(_on_ai_setup_completed)
	ai_integration.ai_setup_cancelled.connect(_on_ai_setup_cancelled)
	ai_integration.ai_provider_changed.connect(_on_ai_provider_changed)
	ai_integration.ai_response_received.connect(_on_ai_response_received)
	ai_integration.ai_error_occurred.connect(_on_ai_error_occurred)

	print("[INIT] ✓ AI integration initialized")


func _initialize_qa_testing() -> void:
	"""Initialize QA testing system for selection reliability"""
	print("[INIT] Initializing QA testing system...")

	selection_test_runner = SelectionTestRunner.new()
	add_child(selection_test_runner)

	# Initialize with main scene reference
	selection_test_runner.initialize(self)

	print(
	(
	"[INIT] ✓ QA testing system ready - Use F1 console commands:"
	+ "\n  - qa_test [full|quick|structure] - Run selection tests"
	+ "\n  - qa_status - Check test progress"
	+ "\n  - qa_analyze - Analyze selection system"
	)
	)


func _initialize_selection_system() -> bool:
	"""Initialize brain structure selection system"""
	print("[INIT] Initializing selection system...")

	# Detect if we should use multi-selection
	if FeatureFlags.is_enabled(FeatureFlags.MULTI_STRUCTURE_SELECTION):
		print("[INIT] Using enhanced multi-selection system")
		selection_manager = MultiStructureSelectionManagerScript.new()
		selection_manager.name = "MultiStructureSelectionManager"
		add_child(selection_manager)

		# Setup multi-selection signals
		if selection_manager.has_signal("selections_changed"):
			selection_manager.selections_changed.connect(_on_multi_selection_changed)
			if selection_manager.has_signal("comparison_mode_entered"):
				selection_manager.comparison_mode_entered.connect(_on_comparison_mode_entered)
				if selection_manager.has_signal("comparison_mode_exited"):
					selection_manager.comparison_mode_exited.connect(_on_comparison_mode_exited)
					if selection_manager.has_signal("selection_limit_reached"):
						selection_manager.selection_limit_reached.connect(_on_selection_limit_reached)
						else:
							print("[INIT] Using standard selection system")
func _initialize_camera_system() -> bool:
	"""Initialize camera behavior controller"""
	print("[INIT] Initializing camera system...")

	camera_controller = CameraBehaviorControllerScript.new()
	camera_controller.name = "CameraBehaviorController"
	add_child(camera_controller)

	# Pass required references to camera controller
	if camera_controller.has_method("initialize"):
func _initialize_model_system() -> bool:
	"""Initialize model coordinator"""
	print("[INIT] Initializing model system...")

	model_coordinator = ModelCoordinatorScene.new()
	model_coordinator.name = "ModelCoordinator"
	add_child(model_coordinator)

	# Initialize model coordinator
	if model_coordinator.has_method("initialize"):
func _initialize_ui_panels() -> void:
	"""Initialize UI panels"""
	print("[INIT] Initializing UI panels...")

	# Initialize info panel if available
	if info_panel and info_panel.has_method("initialize"):
		info_panel.initialize()
		info_panel.hide()  # Hide initially until structure selected

		print("[INIT] ✓ UI panels initialized")


func _process(_delta: float) -> void:
	"""Handle per-frame updates"""
	if not initialization_complete:
		return

		# Delegate input handling to the appropriate system
		_handle_input()


func initialize_core_systems() -> void:
	"""Initialize core systems in proper order"""
	# Validate essential nodes exist
	if not _validate_essential_nodes():

func _fix_orphaned_code():
	if SafeAutoloadAccess.has_method("get_structure_safely"):
		test_structure = SafeAutoloadAccess.call("get_structure_safely", "Test")
		if not test_structure.has("id"):
			framework_working = false

			# Test component creation
func _fix_orphaned_code():
	if UIComponentFactory.has_method("create_button"):
		test_button = UIComponentFactory.call("create_button", "Test", "primary")
		if test_button:
			test_button.queue_free()
			else:
				framework_working = false

				if framework_working:
					print("[INIT] ✓ UI safety framework operational")
					else:
						print("[INIT] ⚠ UI safety framework has issues - proceeding with caution")


func _fix_orphaned_code():
	if FeatureFlags.has_method("is_enabled"):
		if not FeatureFlags.call("is_enabled", "__test_flag__"):  # This triggers initialization
		flags_loaded = true

		if flags_loaded:
			print("[INIT] ✓ FeatureFlags initialized")
			# Log current configuration
			if FeatureFlags.has_method("is_enabled") and FeatureFlags.has_method("print_flag_status"):
				if FeatureFlags.get("DEBUG_COMPONENT_INSPECTOR") != null:
					if FeatureFlags.call("is_enabled", FeatureFlags.get("DEBUG_COMPONENT_INSPECTOR")):
						FeatureFlags.call("print_flag_status")
						else:
							print("[INIT] ⚠ FeatureFlags initialization failed")

							# Initialize component registry
func _fix_orphaned_code():
	if test_component:
		print("[INIT] ✓ ComponentRegistry initialized")
		test_component.queue_free()

		# Show registry stats in debug mode
		if FeatureFlags.is_enabled(FeatureFlags.DEBUG_COMPONENT_INSPECTOR):
			ComponentRegistry.print_registry_stats()
			else:
				print("[INIT] ⚠ ComponentRegistry initialization failed")

				# Initialize state manager
				if FeatureFlags.is_enabled(FeatureFlags.UI_STATE_PERSISTENCE):
					ComponentStateManager.save_component_state("test", {"test": true})
func _fix_orphaned_code():
	if not restored.is_empty():
		print("[INIT] ✓ ComponentStateManager initialized")
		ComponentStateManager.remove_component_state("test")
		else:
			print("[INIT] ⚠ ComponentStateManager not working")
			else:
				print("[INIT] - ComponentStateManager disabled (feature flag off)")


func _fix_orphaned_code():
	if not _initialize_selection_system():
func _fix_orphaned_code():
	if not _initialize_camera_system():
func _fix_orphaned_code():
	if not _initialize_model_system():
func _fix_orphaned_code():
	print("[INIT] Core systems initialized successfully")


func _fix_orphaned_code():
	for node_info in essential_nodes:
func _fix_orphaned_code():
	if not node_ref:
		push_error("[INIT] Missing essential node: " + node_name)
		return false

		return true


func _fix_orphaned_code():
	if selection_manager.has_signal("structure_selected"):
		selection_manager.structure_selected.connect(_on_structure_selected)
		if selection_manager.has_signal("selection_cleared"):
			selection_manager.selection_cleared.connect(_on_selection_cleared)

			# Pass required references to selection manager
			if selection_manager.has_method("initialize"):
func _fix_orphaned_code():
	if not success:
		push_error("[INIT] Failed to initialize selection manager")
		return false
		else:
			push_error("[INIT] Selection manager missing initialize method")
			return false

			# Configure visual properties
			if selection_manager.has_method("configure_highlight"):
				selection_manager.configure_highlight(highlight_color, emission_energy)

				print("[INIT] ✓ Selection system initialized")
				return true


func _fix_orphaned_code():
	if not success:
		push_error("[INIT] Failed to initialize camera controller")
		return false
		else:
			push_error("[INIT] Camera controller missing initialize method")
			return false

			print("[INIT] ✓ Camera system initialized")
			return true


func _fix_orphaned_code():
	if not success:
		push_error("[INIT] Failed to initialize model coordinator")
		return false
		else:
			push_error("[INIT] Model coordinator missing initialize method")
			return false

			# Pass references to model control panel
			if model_control_panel and model_control_panel.has_method("initialize_with_coordinator"):
				model_control_panel.initialize_with_coordinator(model_coordinator)

				print("[INIT] ✓ Model system initialized")
				return true


func _fix_orphaned_code():
	if not debug_cmd:
		print("[INIT] DebugCmd not available, skipping debug command registration")
		return

		# Register foundation test commands
		debug_cmd.register_command(
		"test_foundation", self, "_debug_test_foundation", "Test foundation layer"
		)
		debug_cmd.register_command(
		"test_components", self, "_debug_test_components", "Test UI component system"
		)
		debug_cmd.register_command("test_phase3", self, "_debug_test_phase3", "Test Phase 3 features")

		# Register AI debug commands
		debug_cmd.register_command("ai_status", self, "_debug_ai_status", "Check AI integration status")
		debug_cmd.register_command("ai_setup", self, "_debug_ai_setup", "Show AI setup dialog")
		debug_cmd.register_command(
		"ai_provider", self, "_debug_ai_provider", "List or change AI providers"
		)


func _fix_orphaned_code():
	if ai_integration:
		ai_integration.set_current_structure(selection["name"])

		else:
			# Multiple selections - show comparative panel
			if info_panel:
				info_panel.hide()
				_show_comparative_panel(selections)

				# Update label to show multiple selections
func _fix_orphaned_code():
	for sel in selections:
		names.append(sel["name"])
		object_name_label.text = "Comparing: " + ", ".join(names)

		# Update AI context with first selection
		if ai_integration and selections.size() > 0:
			ai_integration.set_current_structure(selections[0]["name"])

			print("[MultiSelect] Selection changed: %d structures" % selections.size())


func _fix_orphaned_code():
	if ui_layer:
		ui_layer.add_child(notification)

		# Auto-remove after 3 seconds
		await get_tree().create_timer(3.0).timeout
		notification.queue_free()


func _fix_orphaned_code():
	if not ui_layer:
		push_error("[MultiSelect] UI_Layer not found!")
		return

		# Create comparative panel if it doesn't exist
		if not comparative_panel:
			comparative_panel = ComparativeInfoPanelScript.new()
			comparative_panel.name = "ComparativeInfoPanel"

			# Position on the right side
			comparative_panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER_RIGHT)
			comparative_panel.position.x = -420
			comparative_panel.custom_minimum_size = Vector2(400, 600)

			ui_layer.add_child(comparative_panel)

			# Connect signals
			comparative_panel.structure_focused.connect(_on_comparative_structure_focused)
			comparative_panel.comparison_cleared.connect(
			func(): selection_manager.clear_all_selections()
			)

			# Update panel with selections
			comparative_panel.update_selections(selections)
			comparative_panel.show()


func _fix_orphaned_code():
	for mesh in meshes:
		if mesh.name == structure_name:
			# Focus camera on this structure
			if camera_controller and camera_controller.has_method("focus_on_mesh"):
				camera_controller.focus_on_mesh(mesh)
				break


func _fix_orphaned_code():
	if brain_model_parent:
		_collect_meshes_recursive(brain_model_parent, meshes)
		return meshes


func _fix_orphaned_code():
	print("\n=== AI INTEGRATION STATUS ===")
	print("Active Provider: %s" % active_provider)
	print("Status: %s" % str(status))
	print("Current Structure: %s" % ai_integration.get_current_structure())
	print("Available Providers: %s" % str(ai_integration.get_available_providers()))
	print("============================\n")


func _fix_orphaned_code():
	if args.size() > 0:
		provider_id = args[0]

		print(
		(
		"[AI] Showing setup dialog for provider: %s"
		% (provider_id if not provider_id.is_empty() else "default")
		)
		)
		ai_integration.show_setup_dialog(provider_id)


func _fix_orphaned_code():
	print("\n=== AVAILABLE AI PROVIDERS ===")
	for provider in providers:
func _fix_orphaned_code():
	print("%s %s - %s" % ["►" if provider == active else " ", provider, str(status)])
	print("=============================\n")

	print("Use 'ai_provider <provider_id>' to change provider")
	else:
		# Change provider
func _fix_orphaned_code():
	if result:
		print("[AI] Changed provider to: %s" % provider_id)
		else:
			print("[AI] Failed to change provider to: %s" % provider_id)
			print("Available providers: %s" % str(ai_integration.get_available_providers()))


func _fix_orphaned_code():
	if test_btn:
		print("  - Component creation: Working")
		test_btn.queue_free()
		else:
			print("  - Component creation: Failed")
			else:
				print("✗ ComponentRegistry: Not available")

				# Test state manager
				if ComponentStateManager and ComponentStateManager.has_method("save_component_state"):
					print("✓ ComponentStateManager: Available")
					ComponentStateManager.save_component_state("test_key", {"test": true})
func _fix_orphaned_code():
	if data and data.has("test"):
		print("  - State save/restore: Working")
		else:
			print("  - State save/restore: Failed")
			ComponentStateManager.remove_component_state("test_key")
			else:
				print("✗ ComponentStateManager: Not available")

				print("===============================\n")


func _fix_orphaned_code():
	if button:
		print("  - Button creation: Working")
		button.queue_free()
		else:
			print("  - Button creation: Failed")

func _fix_orphaned_code():
	if label:
		print("  - Label creation: Working")
		label.queue_free()
		else:
			print("  - Label creation: Failed")
			else:
				print("✗ UIComponentFactory: Not available")

				# Test component registry
				print("\nTesting fragment components:")

				# Test header fragment
func _fix_orphaned_code():
	if header:
		print("✓ Header fragment created")
		header.queue_free()
		else:
			print("✗ Header fragment failed")

			# Test content fragment
func _fix_orphaned_code():
	if content:
		print("✓ Content fragment created")
		content.queue_free()
		else:
			print("✗ Content fragment failed")

			# Test actions fragment
func _fix_orphaned_code():
	if actions:
		print("✓ Actions fragment created")
		actions.queue_free()
		else:
			print("✗ Actions fragment failed")

			# Test section fragment
func _fix_orphaned_code():
	if section:
		print("✓ Section fragment created")
		section.queue_free()
		else:
			print("✗ Section fragment failed")

			print("=================================\n")


func _fix_orphaned_code():
	if test_script:
func _fix_orphaned_code():
	if is_instance_valid(test_instance):
		test_instance.queue_free()
		print("✓ Phase 3 test instance cleaned up")
		else:
			print("✗ Failed to load Phase 3 test script")

			print("=== PHASE 3 TESTS COMPLETED ===\n")

func _validate_essential_nodes() -> bool:
	"""Ensure all required nodes exist"""
func _connect_signals() -> void:
	"""Connect all required signals"""
	# Connect input handling
	# These signals are defined in the Input Map

	# Mouse signals
	if Input.is_action_just_pressed("ui_select"):
		get_viewport().set_input_as_handled()

		# Model coordinator signals
		if model_coordinator and model_coordinator.has_signal("models_loaded"):
			model_coordinator.models_loaded.connect(func(model_names): models_loaded.emit(model_names))

			# Selection manager signals already connected in _initialize_selection_system


func _register_foundation_debug_commands() -> void:
	"""Register foundation debug commands for testing"""
func _handle_input() -> void:
	"""Process input events for brain exploration"""
	# Right-click for selection
	if Input.is_action_just_pressed("select_structure"):
		if selection_manager.has_method("handle_selection_input"):
			selection_manager.handle_selection_input()

			# Camera controls handled by camera controller


func _on_structure_selected(structure_name: String, _mesh: MeshInstance3D) -> void:
	"""Handle selection of a brain structure"""
	print("[Selection] Structure selected: %s" % structure_name)

	# Update UI
	object_name_label.text = "Selected: " + structure_name
	last_selected_structure = structure_name

	# Show structure info
	_display_structure_info(structure_name)

	# Update AI context
	if ai_integration:
		ai_integration.set_current_structure(structure_name)

		# Emit signal for external listeners
		structure_selected.emit(structure_name)


func _on_selection_cleared() -> void:
	"""Handle clearing of structure selection"""
	print("[Selection] Selection cleared")

	# Update UI
	object_name_label.text = "Selected: None"
	last_selected_structure = ""

	# Hide info panel
	if info_panel:
		info_panel.hide()

		# Clear AI context
		if ai_integration:
			ai_integration.set_current_structure("")

			# Emit signal for external listeners
			structure_deselected.emit()


func _display_structure_info(structure_name: String) -> void:
	"""Display information about the selected structure"""
	if not info_panel:
		push_warning("[UI] Info panel not available")
		return

		# Use info panel to display structure info
		if info_panel.has_method("display_structure_info"):
			info_panel.display_structure_info(structure_name)
			info_panel.show()
			else:
				push_warning("[UI] Info panel missing display_structure_info method")


				# === MULTI-SELECTION HANDLERS ===
func _on_multi_selection_changed(selections: Array) -> void:
	"""Handle changes to multi-selection state"""
	# Update UI based on number of selections
	if selections.size() == 0:
		# No selection - hide panels
		if info_panel:
			info_panel.hide()
			if comparative_panel:
				comparative_panel.hide()
				object_name_label.text = "Selected: None"

				# Update AI context
				if ai_integration:
					ai_integration.set_current_structure("")

					elif selections.size() == 1:
						# Single selection - show traditional info panel
						if comparative_panel:
							comparative_panel.hide()
func _on_comparison_mode_entered() -> void:
	"""Handle entering comparison mode"""
	print("[MultiSelect] Entered comparison mode")

	# Show comparison mode indicator (optional)
	# Could add visual feedback here


func _on_comparison_mode_exited() -> void:
	"""Handle exiting comparison mode"""
	print("[MultiSelect] Exited comparison mode")

	# Hide comparative panel
	if comparative_panel:
		comparative_panel.hide()


func _on_selection_limit_reached() -> void:
	"""Handle when selection limit is reached"""
	print("[MultiSelect] Selection limit reached!")

	# Show user feedback
func _show_comparative_panel(selections: Array) -> void:
	"""Show the comparative information panel"""
func _on_comparative_structure_focused(structure_name: String) -> void:
	"""Handle focus request from comparative panel"""
	# Find the mesh for this structure
func _get_all_brain_meshes() -> Array:
	"""Get all brain mesh instances from the brain model parent"""
func _collect_meshes_recursive(node: Node, meshes: Array) -> void:
	"""Recursively collect all MeshInstance3D nodes"""
	if node is MeshInstance3D:
		meshes.append(node)
		for child in node.get_children():
			_collect_meshes_recursive(child, meshes)


			# === AI INTEGRATION HANDLERS ===
func _on_ai_setup_completed(provider_id: String) -> void:
	"""Handle AI setup completion"""
	print("[AI] Setup completed for provider: %s" % provider_id)

	# Could show a success notification here


func _on_ai_setup_cancelled() -> void:
	"""Handle AI setup cancellation"""
	print("[AI] Setup cancelled")

	# Could show a notification here


func _on_ai_provider_changed(provider_id: String) -> void:
	"""Handle AI provider change"""
	print("[AI] Provider changed to: %s" % provider_id)

	# Update UI if needed


func _on_ai_response_received(question: String, response: String) -> void:
	"""Handle AI response"""
	print("[AI] Response received for question: %s" % question)

	# Update UI with response
	# This would typically update the AI assistant panel


func _on_ai_error_occurred(error_message: String) -> void:
	"""Handle AI error"""
	push_warning("[AI] Error: %s" % error_message)

	# Could show an error notification here


	# === DEBUG COMMANDS ===
func _debug_ai_status(args: Array = []) -> void:
	"""Debug command to check AI integration status"""
	if not ai_integration:
		print("[AI] AI integration not initialized")
		return

func _debug_ai_setup(args: Array = []) -> void:
	"""Debug command to show AI setup dialog"""
	if not ai_integration:
		print("[AI] AI integration not initialized")
		return

func _debug_ai_provider(args: Array = []) -> void:
	"""Debug command to list or change AI providers"""
	if not ai_integration:
		print("[AI] AI integration not initialized")
		return

		if args.size() == 0:
			# List providers
func _debug_test_foundation(args: Array = []) -> void:
	"""Debug command to test foundation layer"""
	print("\n=== TESTING FOUNDATION LAYER ===")

	# Test feature flags
	if FeatureFlags and FeatureFlags.has_method("is_enabled"):
		print("✓ FeatureFlags: Available")
		print(
		(
		"  - UI_MODULAR_COMPONENTS: %s"
		% (
		"Enabled"
		if FeatureFlags.is_enabled(FeatureFlags.UI_MODULAR_COMPONENTS)
		else "Disabled"
		)
		)
		)
		print(
		(
		"  - MULTI_STRUCTURE_SELECTION: %s"
		% (
		"Enabled"
		if FeatureFlags.is_enabled(FeatureFlags.MULTI_STRUCTURE_SELECTION)
		else "Disabled"
		)
		)
		)
		print(
		(
		"  - UI_STYLE_ENGINE: %s"
		% (
		"Enabled"
		if FeatureFlags.is_enabled(FeatureFlags.UI_STYLE_ENGINE)
		else "Disabled"
		)
		)
		)
		else:
			print("✗ FeatureFlags: Not available")

			# Test component registry
			if ComponentRegistry and ComponentRegistry.has_method("create_component"):
				print("✓ ComponentRegistry: Available")
func _debug_test_components(args: Array = []) -> void:
	"""Debug command to test UI component system"""
	print("\n=== TESTING UI COMPONENT SYSTEM ===")

	# Test component factory
	if UIComponentFactory and UIComponentFactory.has_method("create_button"):
		print("✓ UIComponentFactory: Available")

		# Test creating various components
func _debug_test_phase3() -> void:
	"""Test Phase 3: StyleEngine and AdvancedInteractionSystem"""
	print("\n=== TESTING PHASE 3: STYLE ENGINE & ADVANCED INTERACTIONS ===")

	# Enable Phase 3 features for testing
	FeatureFlags.enable_feature(FeatureFlags.UI_STYLE_ENGINE)
	FeatureFlags.enable_feature(FeatureFlags.UI_ADVANCED_INTERACTIONS)
	FeatureFlags.enable_feature(FeatureFlags.UI_SMOOTH_ANIMATIONS)
	FeatureFlags.enable_feature(FeatureFlags.UI_CONTEXT_MENUS)
	FeatureFlags.enable_feature(FeatureFlags.UI_GESTURE_RECOGNITION)

	# Load test script
