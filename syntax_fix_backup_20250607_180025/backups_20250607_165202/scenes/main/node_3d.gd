## NeuroVis Main Scene Controller (Refactored)
## Central hub for the educational neuroscience visualization platform
##
## This scene coordinates all major systems including 3D visualization,
## UI management, AI integration, and user interaction.
##
## @tutorial: See node_3d_config.gd for configuration options
## @version: 5.0 - Refactored for proper code organization

class_name NeuroVisMainScene
extends Node3D

# ===== SIGNALS =====
## Selection events

signal structure_selected(structure_name: String)
signal structure_deselected
signal multi_selection_changed(selections: Array)

## System initialization events
signal system_initialized(system_name: String)
signal initialization_failed(reason: String)
signal scene_initialization_complete

## Model loading events
signal models_loaded(model_names: Array)
signal model_load_failed(model_name: String, error: String)

# ===== CONSTANTS =====
## Essential scripts preloaded for initialization

const SAFE_AUTOLOAD_ACCESS = prepreload("res://ui/components/core/SafeAutoloadAccess.gd")
const UI_COMPONENT_FACTORY_SCRIPT = prepreload("res://ui/components/core/UIComponentFactory.gd")
const AI_INTEGRATION_MANAGER_SCRIPT = prepreload("res://core/ai/AIIntegrationManager.gd")

# ===== EXPORTS =====

@export_group("Visual Settings")
@export var highlight_color: Color = Color(0.0, 1.0, 0.0, 1.0)
@export var emission_energy: float = 0.5

@export_group("System Settings")
@export var enable_debug_mode: bool = true
@export var enable_minimal_ui_fallback: bool = true
@export var initialization_timeout: float = 5.0

@export_group("Feature Toggles")
@export var enable_multi_selection: bool = true
@export var enable_ai_assistant: bool = true
@export var enable_comparative_panel: bool = true
@export var enable_keyboard_shortcuts: bool = true

# ===== ONREADY VARIABLES =====

var initialization_complete: bool = false

## System components
var selection_manager: Node
var camera_controller: Node
var model_coordinator: Node
var ai_integration: Node
var enhanced_model_loader: Node

## UI components
var comparative_panel: Control
var loading_progress: Control
var visual_feedback: Node

# ===== PRIVATE VARIABLES =====
	var start_time = Time.get_ticks_msec()

	# Wait for scene tree to be ready
	await get_tree().process_frame

	# Validate scene structure
	if not is_inside_tree():
		_handle_critical_error("Scene not properly added to tree")
		return

	# Validate essential nodes
	if not _validate_essential_nodes():
		_handle_critical_error("Essential nodes validation failed")
		return

	# Initialize all systems in order
	_initialize_all_systems()

	# Final setup
	_finalize_initialization(start_time)


	var test_structure = SAFE_AUTOLOAD_ACCESS.get_structure_safely("Test")
	if test_structure.has("id"):
		print("[INIT] ✓ UI safety framework operational")
	else:
		print("[INIT] ⚠ UI safety framework has issues - proceeding with caution")


	var SelectionManagerScript = prepreload(
		"res://core/interaction/BrainStructureSelectionManager.gd"
	)
	if not SelectionManagerScript:
		_log_error("Failed to load BrainStructureSelectionManager.gd")
		initialization_failed.emit("Selection system initialization failed")
		return

	selection_manager = SelectionManagerScript.new()
	selection_manager.name = "BrainStructureSelectionManager"
	add_child(selection_manager)

	# Initialize with required nodes
	if selection_manager.has_method("initialize"):
		var success = selection_manager.initialize(camera, brain_model_parent)
		if not success:
			_log_error("Failed to initialize selection manager")
			initialization_failed.emit("Selection manager initialization failed")
			return

	# Configure visual properties
	if selection_manager.has_method("configure_highlight"):
		selection_manager.configure_highlight(highlight_color, emission_energy)

	# Connect signals
	if selection_manager.has_signal("structure_selected"):
		selection_manager.structure_selected.connect(_on_structure_selected)
	if selection_manager.has_signal("selection_cleared"):
		selection_manager.selection_cleared.connect(_on_selection_cleared)

	print("[INIT] ✓ Selection system initialized")
	system_initialized.emit("selection")


	var CameraBehaviorControllerScript = preload(
		"res://core/interaction/CameraBehaviorController.gd"
	)
	if not CameraBehaviorControllerScript:
		_log_error("Failed to load CameraBehaviorController.gd")
		initialization_failed.emit("Camera system initialization failed")
		return

	camera_controller = CameraBehaviorControllerScript.new()
	camera_controller.name = "CameraBehaviorController"
	add_child(camera_controller)

	# Initialize with required nodes
	if camera_controller.has_method("initialize"):
		var success = camera_controller.initialize(camera, brain_model_parent)
		if not success:
			_log_error("Failed to initialize camera controller")
			initialization_failed.emit("Camera controller initialization failed")
			return

	print("[INIT] ✓ Camera system initialized")
	system_initialized.emit("camera")


	var EnhancedModelLoaderScript = prepreload("res://core/models/EnhancedModelLoader.gd")
	if EnhancedModelLoaderScript:
		enhanced_model_loader = EnhancedModelLoaderScript.new()
		enhanced_model_loader.name = "EnhancedModelLoader"
		add_child(enhanced_model_loader)

		# Connect signals
		if enhanced_model_loader.has_signal("model_loading_started"):
			enhanced_model_loader.model_loading_started.connect(_on_model_loading_started)
		if enhanced_model_loader.has_signal("model_loaded"):
			enhanced_model_loader.model_loaded.connect(_on_model_loaded)
		if enhanced_model_loader.has_signal("all_models_loaded"):
			enhanced_model_loader.all_models_loaded.connect(_on_all_models_loaded)
		if enhanced_model_loader.has_signal("model_load_failed"):
			enhanced_model_loader.model_load_failed.connect(_on_model_load_failed)

		# Initialize
		if enhanced_model_loader.has_method("initialize"):
			enhanced_model_loader.initialize(brain_model_parent)
		if enhanced_model_loader.has_method("load_all_models"):
			enhanced_model_loader.load_all_models()
	else:
		# Fallback to basic model loading
		print("[INIT] Enhanced model loader not found, using basic loading")
		_load_models_basic()

	# Initialize model control panel
	if model_control_panel and model_control_panel.has_method("initialize"):
		model_control_panel.initialize()

	print("[INIT] ✓ Model system initialized")
	system_initialized.emit("models")


	var ui_layer_node = get_node_or_null("UI_Layer")
	if not ui_layer_node:
		_log_error("UI_Layer not found for keyboard shortcuts")
		initialization_failed.emit("UI_Layer not found for keyboard shortcuts")
		return

	# TODO: Implement keyboard shortcuts system
	# var KeyboardShortcutsScript = prepreload("res://ui/components/KeyboardShortcuts.gd")
	# if KeyboardShortcutsScript:
	# 	keyboard_shortcuts = KeyboardShortcutsScript.new()
	# 	keyboard_shortcuts.name = "KeyboardShortcuts"
	# 	ui_layer_node.add_child(keyboard_shortcuts)
	print("[INIT] ✓ Keyboard shortcuts system placeholder ready")


	var debug_cmd = get_node_or_null("/root/DebugCmd")
	if not debug_cmd:
		print("[INIT] DebugCmd not available")
		return

	# Register AI debug commands
	debug_cmd.register_command(
		"ai_status", Callable(self, "_debug_ai_status"), "Check AI integration status"
	)
	debug_cmd.register_command(
		"ai_setup", Callable(self, "_debug_ai_setup"), "Show AI setup dialog"
	)
	debug_cmd.register_command(
		"ai_provider", Callable(self, "_debug_ai_provider"), "List or change AI providers"
	)

	print("[INIT] ✓ Debug commands registered")


	var total_time = Time.get_ticks_msec() - start_time

	# Update state
	initialization_complete = true

	# Reset camera if available
	if camera_controller and camera_controller.has_method("reset_view"):
		camera_controller.reset_view()

	print("[INIT] === NeuroVis initialized in " + str(total_time) + "ms ===")

	# Apply model fixes
	call_deferred("_apply_model_fixes")

	# Emit completion signal
	scene_initialization_complete.emit()


	var valid = true

	# Check critical nodes
	if not camera:
		push_error("[CRITICAL] Camera3D node not found")
		valid = false

	if not brain_model_parent:
		push_error("[CRITICAL] BrainModel node not found")
		valid = false

	# Check UI nodes and create fallbacks if needed
	if not get_node_or_null("UI_Layer") and enable_minimal_ui_fallback:
		print("[INIT] Creating fallback UI structure")
		_ensure_minimal_ui()

	return valid


	var ui_layer = get_node_or_null("UI_Layer")
	if not ui_layer:
		print("[INIT] Creating missing UI_Layer")
		ui_layer = CanvasLayer.new()
		ui_layer.name = "UI_Layer"
		add_child(ui_layer)

	# Create missing ObjectNameLabel if needed
	if not object_name_label:
		print("[INIT] Creating missing ObjectNameLabel")
		object_name_label = Label.new()
		object_name_label.name = "ObjectNameLabel"
		object_name_label.text = "Selected: None"
		object_name_label.set_anchors_preset(Control.PRESET_TOP_WIDE)
		object_name_label.position = Vector2(0, 20)
		object_name_label.size = Vector2(200, 26)
		object_name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		ui_layer.add_child(object_name_label)

	# Create minimal info panel if needed
	if not info_panel:
		print("[INIT] Creating minimal StructureInfoPanel")
		info_panel = PanelContainer.new()
		info_panel.name = "StructureInfoPanel"
		info_panel.visible = false
		info_panel.set_anchors_preset(Control.PRESET_CENTER_LEFT)
		info_panel.position = Vector2(20, -250)
		info_panel.size = Vector2(380, 500)

		# Add a simple label for content
		var content_label = RichTextLabel.new()
		content_label.name = "ContentLabel"
		content_label.text = "Structure information will appear here"
		info_panel.add_child(content_label)
		ui_layer.add_child(info_panel)


# ===== HELPER METHODS =====


	var ui_layer_node = get_node_or_null("UI_Layer")
	if ui_layer_node:
		print("[INIT] Loading progress system placeholder ready")
		# ui_layer_node.add_child(loading_progress)


	var ComparativeInfoPanelScript = prepreload("res://ui/panels/ComparativeInfoPanel.gd")
	if ComparativeInfoPanelScript:
		comparative_panel = ComparativeInfoPanelScript.new()
		comparative_panel.name = "ComparativeInfoPanel"
		comparative_panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER_RIGHT)
		comparative_panel.position.x = -420
		comparative_panel.custom_minimum_size = Vector2(400, 600)
		comparative_panel.hide()

		var ui_layer_node = get_node_or_null("UI_Layer")
		if ui_layer_node:
			ui_layer_node.add_child(comparative_panel)


		var names = []
		for sel in selections:
			names.append(sel.get("name", "Unknown"))
		if object_name_label:
			object_name_label.text = "Comparing: " + ", ".join(names)


	var model_paths = [
		"res://assets/models/Half_Brain.glb",
		"res://assets/models/Internal_Structures.glb",
		"res://assets/models/Brainstem(Solid).glb"
	]

	var loaded_models = []
	for path in model_paths:
		if ResourceLoader.exists(path):
			var model = load(path)
			if model:
				var instance = model.instantiate()
				brain_model_parent.add_child(instance)
				loaded_models.append(instance.name)
				print("[Models] Loaded: " + instance.name)

	if loaded_models.size() > 0:
		models_loaded.emit(loaded_models)


	var meshes: Array = []
	if brain_model_parent:
		_collect_meshes_recursive(brain_model_parent, meshes)
	return meshes


		var models = []
		_collect_meshes_recursive(brain_model_parent, models)

		for model in models:
			# Fix oversized Brainstem if detected
			if "brainstem" in model.name.to_lower() and model.scale.x > 10.0:
				print("[MODEL_FIX] Fixing oversized Brainstem")
				model.scale = Vector3.ONE
				model.position = Vector3.ZERO

			# Ensure all models are visible
			if not model.visible:
				model.visible = true
				print("[MODEL_FIX] Made %s visible" % model.name)

	# Reset camera if needed
	if camera and camera.global_position.length() > 100.0:
		print("[MODEL_FIX] Resetting camera position")
		camera.global_position = Vector3(15, 10, 15)
		camera.look_at(Vector3.ZERO, Vector3.UP)


	var target_energy = 1.0 if camera_visible else 0.5
	for child in camera.get_children():
		if child is DirectionalLight3D:
			child.light_energy = target_energy


# ===== SIGNAL HANDLERS =====


		var selection = selections[0]
		_on_structure_selected(selection.get("name", ""), null)
	else:
		# Multiple selections - show comparative panel
		if info_panel:
			info_panel.hide()
		_show_comparative_panel(selections)

	print("[MultiSelect] Selection changed: %d structures" % selections.size())
	multi_selection_changed.emit(selections)


# ===== AI INTEGRATION HANDLERS =====


		var model_names = enhanced_model_loader.get_loaded_model_names()
		_on_models_loaded(model_names)


	var model_switcher = get_node_or_null("/root/ModelSwitcherGlobal")
	if model_names.size() > 0 and model_switcher:
		var visible_models = (
			model_switcher.get_visible_models()
			if model_switcher.has_method("get_visible_models")
			else []
		)
		if visible_models.is_empty() and model_switcher.has_method("set_model_visibility"):
			print("[Models] No models visible, showing first model: ", model_names[0])
			model_switcher.set_model_visibility(model_names[0], true)

	# Reset camera to view the models
	if camera_controller and camera_controller.has_method("reset_view"):
		camera_controller.reset_view()

	# Update the main signal
	models_loaded.emit(model_names)


	var camera_is_visible = camera.visible
	_log_debug("Camera visibility: " + str(camera_is_visible))

	# Adjust lighting based on camera visibility
	if camera_is_visible:
		# Camera is visible - ensure lighting is optimal
		_adjust_lighting_for_visibility(true)

		# Update UI to show camera is active
		if object_name_label:
			object_name_label.modulate = Color.WHITE
	else:
		# Camera is not visible - dim lighting to conserve resources
		_adjust_lighting_for_visibility(false)

		# Dim UI to indicate inactive state
		if object_name_label:
			object_name_label.modulate = Color(0.7, 0.7, 0.7, 1.0)


	var active_provider = ai_integration.get_active_provider_id()
	var status = ai_integration.get_provider_status()

	print("\n=== AI INTEGRATION STATUS ===")
	print("Active Provider: %s" % active_provider)
	print("Status: %s" % str(status))
	print("Current Structure: %s" % ai_integration.get_current_structure())
	print("Available Providers: %s" % str(ai_integration.get_available_providers()))
	print("============================\n")


	var provider_id = ""
	if args.size() > 0:
		provider_id = args[0]

	print(
		(
			"[AI] Showing setup dialog for provider: %s"
			% (provider_id if not provider_id.is_empty() else "default")
		)
	)
	ai_integration.show_setup_dialog(provider_id)


		var providers = ai_integration.get_available_providers()
		var active = ai_integration.get_active_provider_id()

		print("\n=== AVAILABLE AI PROVIDERS ===")
		for provider in providers:
			var status = ai_integration.get_provider_status(provider)
			print("%s %s - %s" % ["►" if provider == active else " ", provider, str(status)])
		print("=============================\n")

		print("Use 'ai_provider <provider_id>' to change provider")
	else:
		# Change provider
		var provider_id = args[0]
		var result = ai_integration.set_active_provider(provider_id)

		if result:
			print("[AI] Changed provider to: %s" % provider_id)
		else:
			print("[AI] Failed to change provider to: %s" % provider_id)
			print("Available providers: %s" % str(ai_integration.get_available_providers()))


	var feature_flags = get_node_or_null("/root/FeatureFlags")
	if feature_flags:
		print("✓ FeatureFlags: Available")
	else:
		print("✗ FeatureFlags: Not available")

	# Test UI component factory
	if UI_COMPONENT_FACTORY_SCRIPT:
		print("✓ UIComponentFactory: Available")
	else:
		print("✗ UIComponentFactory: Not available")

	print("===============================\n")


		var button = UI_COMPONENT_FACTORY_SCRIPT.create_button("Test Button", "primary")
		if button:
			print("  - Component creation: Working")
			button.queue_free()
		else:
			print("  - Component creation: Failed")
	else:
		print("✗ UIComponentFactory: Not available")

	print("=================================\n")


# ===== LOGGING UTILITIES =====


var _selected_structure: String = ""
var _selected_structures: Array = []

# ===== LIFECYCLE METHODS =====


@onready var camera: Camera3D = $Camera3D
@onready var object_name_label: Label = $UI_Layer/ObjectNameLabel
@onready var info_panel: Control = $UI_Layer/StructureInfoPanel
@onready var brain_model_parent: Node3D = $BrainModel
@onready var model_control_panel: Control = $UI_Layer/ModelControlPanel

# ===== PUBLIC VARIABLES =====

func _ready() -> void:
	"""Initialize the NeuroVis main scene"""
	print("[INIT] Starting NeuroVis main scene...")

func _process(_delta: float) -> void:
	"""Handle per-frame updates"""
	if not initialization_complete:
		return

	# Handle input
	if Input.is_action_just_pressed("select_structure") and selection_manager:
		if selection_manager.has_method("handle_selection_input"):
			selection_manager.handle_selection_input()


# ===== INITIALIZATION METHODS =====


func _initialize_all_systems() -> void:
	"""Initialize all systems in the configured order"""
	print("[INIT] Initializing core systems...")

	# Initialize in specific order for dependencies
	_initialize_ui_safety()
	_initialize_selection_system()
	_initialize_camera_system()
	_initialize_model_system()
	_initialize_ui_panels()

	# Optional systems
	if enable_ai_assistant:
		_initialize_ai_integration()

	if enable_keyboard_shortcuts:
		_initialize_keyboard_shortcuts()

	if enable_debug_mode:
		_initialize_debug_commands()


func _initialize_ui_safety() -> void:
	"""Initialize UI safety framework"""
	print("[INIT] Initializing UI safety framework...")

	# Log autoload status for debugging
	SAFE_AUTOLOAD_ACCESS.log_autoload_status()

	# Test structure retrieval
func _initialize_selection_system() -> void:
	"""Initialize brain structure selection system"""
	print("[INIT] Initializing selection system...")

	# Load selection manager script
func _initialize_camera_system() -> void:
	"""Initialize camera behavior controller"""
	print("[INIT] Initializing camera system...")

func _initialize_model_system() -> void:
	"""Initialize model system"""
	print("[INIT] Initializing model system...")

	# Create loading progress indicator
	_create_loading_progress()

	# Try enhanced model loader first
func _initialize_ui_panels() -> void:
	"""Initialize UI panels"""
	print("[INIT] Initializing UI panels...")

	# Initialize info panel if available
	if info_panel and info_panel.has_method("initialize"):
		info_panel.initialize()
		info_panel.hide()  # Hide initially until structure selected

	# Create comparative panel if enabled
	if enable_comparative_panel:
		_create_comparative_panel()

	print("[INIT] ✓ UI panels initialized")
	system_initialized.emit("ui")


func _initialize_ai_integration() -> void:
	"""Initialize AI integration with the new architecture"""
	print("[INIT] Initializing AI integration...")

	# Create AI integration manager
	ai_integration = AI_INTEGRATION_MANAGER_SCRIPT.new()
	ai_integration.name = "AIIntegration"
	add_child(ai_integration)

	# Connect to signals
	ai_integration.ai_setup_completed.connect(_on_ai_setup_completed)
	ai_integration.ai_setup_cancelled.connect(_on_ai_setup_cancelled)
	ai_integration.ai_provider_changed.connect(_on_ai_provider_changed)
	ai_integration.ai_response_received.connect(_on_ai_response_received)
	ai_integration.ai_error_occurred.connect(_on_ai_error_occurred)

	print("[INIT] ✓ AI integration initialized")


func _initialize_keyboard_shortcuts() -> void:
	"""Initialize keyboard shortcuts help panel"""
	print("[INIT] Initializing keyboard shortcuts...")

func _initialize_debug_commands() -> void:
	"""Register debug commands if debug mode is enabled"""

func _finalize_initialization(start_time: int) -> void:
	"""Complete initialization and perform final setup"""
func _validate_essential_nodes() -> bool:
	"""Ensure all required nodes exist"""
func _ensure_minimal_ui() -> void:
	"""Create minimal UI structure if nodes are missing"""
func _create_loading_progress() -> void:
	"""Create loading progress indicator"""
	# TODO: Implement loading progress system
	# var LoadingProgressScript = prepreload("res://ui/components/LoadingProgress.gd")
	# if LoadingProgressScript:
	# 	loading_progress = LoadingProgressScript.new()
	# 	loading_progress.name = "LoadingProgress"
func _create_comparative_panel() -> void:
	"""Create comparative info panel"""
func _show_comparative_panel(selections: Array) -> void:
	"""Show the comparative information panel"""
	if not comparative_panel:
		_create_comparative_panel()

	if comparative_panel:
		if comparative_panel.has_method("update_selections"):
			comparative_panel.update_selections(selections)
		comparative_panel.show()

		# Update label
func _load_models_basic() -> void:
	"""Basic model loading fallback"""
func _get_all_brain_meshes() -> Array:
	"""Get all brain mesh instances from the brain model parent"""
func _collect_meshes_recursive(node: Node, meshes: Array) -> void:
	"""Recursively collect all MeshInstance3D nodes"""
	if node is MeshInstance3D:
		meshes.append(node)
	for child in node.get_children():
		_collect_meshes_recursive(child, meshes)


func _apply_model_fixes() -> void:
	"""Apply quick fixes for oversized models and camera positioning"""
	print("[MODEL_FIX] Applying model fixes...")

	# Fix oversized models in BrainModel container
	if brain_model_parent:
func _adjust_lighting_for_visibility(camera_visible: bool) -> void:
	"""Adjust scene lighting based on camera visibility"""
	if not camera:
		return

	# Adjust directional light intensity
func _on_structure_selected(structure_name: String, _mesh: MeshInstance3D) -> void:
	"""Handle selection of a brain structure"""
	print("[Selection] Structure selected: %s" % structure_name)

	# Update state
	_selected_structure = structure_name

	# Update UI
	if object_name_label:
		object_name_label.text = "Selected: " + structure_name

	# Show structure info
	_display_structure_info(structure_name)

	# Update AI context
	if ai_integration and ai_integration.has_method("set_current_structure"):
		ai_integration.set_current_structure(structure_name)

	# Emit signal for external listeners
	structure_selected.emit(structure_name)


func _on_selection_cleared() -> void:
	"""Handle clearing of structure selection"""
	print("[Selection] Selection cleared")

	# Update state
	_selected_structure = ""

	# Update UI
	if object_name_label:
		object_name_label.text = "Selected: None"

	# Hide info panel
	if info_panel:
		info_panel.hide()

	# Clear AI context
	if ai_integration and ai_integration.has_method("set_current_structure"):
		ai_integration.set_current_structure("")

	# Emit signal for external listeners
	structure_deselected.emit()


func _on_multi_selection_changed(selections: Array) -> void:
	"""Handle changes to multi-selection state"""
	# Update state
	_selected_structures = selections

	# Update UI based on number of selections
	if selections.size() == 0:
		_on_selection_cleared()
	elif selections.size() == 1:
		# Single selection
		if comparative_panel:
			comparative_panel.hide()
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


func _on_ai_response_received(question: String, _response: String) -> void:
	"""Handle AI response"""
	print("[AI] Response received for question: %s" % question)
	# Update UI with response
	# This would typically update the AI assistant panel


func _on_ai_error_occurred(error_message: String) -> void:
	"""Handle AI error"""
	push_warning("[AI] Error: %s" % error_message)
	# Could show an error notification here


# ===== MODEL LOADING HANDLERS =====


func _on_model_loading_started(total_models: int) -> void:
	"""Handle start of model loading"""
	print("[Models] Starting to load %d models" % total_models)
	if loading_progress and loading_progress.has_method("start_loading"):
		loading_progress.start_loading(total_models)


func _on_model_loaded(model_name: String, index: int) -> void:
	"""Handle individual model loaded"""
	print("[Models] Loaded model %d: %s" % [index + 1, model_name])
	if loading_progress and loading_progress.has_method("update_progress"):
		loading_progress.update_progress(model_name)


func _on_all_models_loaded(successful_count: int, total_count: int) -> void:
	"""Handle completion of all model loading"""
	print(
		(
			"[Models] Loading complete: %d/%d models loaded successfully"
			% [successful_count, total_count]
		)
	)

	if loading_progress:
		loading_progress.complete_loading()

	# Get list of loaded models from enhanced loader
	if enhanced_model_loader and enhanced_model_loader.has_method("get_loaded_model_names"):
func _on_models_loaded(model_names: Array) -> void:
	"""Handle successful model loading"""
	if loading_progress:
		loading_progress.complete_loading()

	print("[Models] Successfully loaded models: ", model_names)

	# Ensure at least one model is visible
func _on_model_load_failed(model_path: String, error: String) -> void:
	"""Handle model loading failure"""
	push_error("[Model] Failed to load %s: %s" % [model_path, error])
	model_load_failed.emit(model_path, error)

	if loading_progress and loading_progress.has_method("show_error"):
		loading_progress.show_error(error)


# ===== CAMERA & MODEL SIGNAL HANDLERS =====


func _on_camera_3d_visibility_changed() -> void:
	"""Handle camera visibility changes"""
	print("[DEBUG] Camera visibility changed")

	if not camera:
		_log_warning("Camera reference not available")
		return

func _on_brain_model_script_changed() -> void:
	"""Handle brain model script changes"""
	print("[DEBUG] Brain model script changed")

	if not brain_model_parent:
		_log_warning("Brain model parent reference not available")
		return

	# Refresh dependent systems
	if selection_manager and selection_manager.has_method("refresh_model_references"):
		selection_manager.refresh_model_references()

	if camera_controller and camera_controller.has_method("recalculate_bounds"):
		camera_controller.recalculate_bounds()

	if enhanced_model_loader and enhanced_model_loader.has_method("refresh_model_list"):
		enhanced_model_loader.refresh_model_list()


func _on_brain_model_tree_exiting() -> void:
	"""Handle brain model cleanup when exiting scene tree"""
	print("[DEBUG] Brain model tree exiting - performing cleanup")

	# Clear selection to prevent invalid references
	if selection_manager:
		if selection_manager.has_method("clear_selection"):
			selection_manager.clear_selection()
		elif selection_manager.has_method("clear_all_selections"):
			selection_manager.clear_all_selections()

	# Clear model reference
	brain_model_parent = null

	# Update UI
	if object_name_label:
		object_name_label.text = "Selected: No Model Available"
	if info_panel:
		info_panel.hide()

	# Reset camera
	if camera_controller and camera_controller.has_method("reset_view"):
		camera_controller.reset_view()


# ===== DEBUG COMMANDS =====


func _debug_ai_status(_args: Array = []) -> void:
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
func _debug_test_foundation(_args: Array = []) -> void:
	"""Debug command to test foundation layer"""
	print("\n=== TESTING FOUNDATION LAYER ===")

	# Test feature flags
func _debug_test_components(_args: Array = []) -> void:
	"""Debug command to test UI component system"""
	print("\n=== TESTING UI COMPONENT SYSTEM ===")

	# Test component factory
	if UI_COMPONENT_FACTORY_SCRIPT:
		print("✓ UIComponentFactory: Available")
func _log_debug(message: String) -> void:
	"""Log debug messages"""
	if enable_debug_mode:
		print("[DEBUG] " + message)


func _log_warning(message: String) -> void:
	"""Log warning messages"""
	push_warning("[WARNING] " + message)


func _log_error(message: String) -> void:
	"""Log error messages"""
	push_error("[ERROR] " + message)


# ===== ERROR HANDLING =====


func _handle_critical_error(error: String) -> void:
	"""Handle critical errors that prevent initialization"""
	push_error("[CRITICAL] " + error)
	initialization_failed.emit(error)
