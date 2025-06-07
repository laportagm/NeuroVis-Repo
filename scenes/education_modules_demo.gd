## education_modules_demo.gd
## Demonstrates the educational modularity features of NeuroVis
##
## This demonstration shows integration of brain system switching,
## comparative neuroanatomy, and interactive learning pathways.
##
## @tutorial: Educational module integration
## @version: 1.0

extends Node3D

# === NODE REFERENCES ===

var educational_coordinator: EducationalModuleCoordinator
var current_mode: int = EducationalModuleCoordinator.EducationalMode.FREE_EXPLORATION

# === LIFECYCLE METHODS ===
var brain_switcher = educational_coordinator.get_module("brain_system_switcher")
var comparative = educational_coordinator.get_module("comparative_anatomy")
var pathway = educational_coordinator.get_module("learning_pathway")
var mode_name = EducationalModuleCoordinator.EducationalMode.keys()[mode_value]
mode_selector.add_item(mode_name, mode_value)

# Set current mode
mode_selector.select(current_mode)

var available_systems = brain_switcher.get_available_systems()

# Enable/disable buttons based on available systems
system_switcher_ui.get_node("WholeButton").disabled = not available_systems.has(BrainSystemSwitcher.BrainSystem.WHOLE_BRAIN)
system_switcher_ui.get_node("HalfButton").disabled = not available_systems.has(BrainSystemSwitcher.BrainSystem.HALF_SECTIONAL)
system_switcher_ui.get_node("InternalButton").disabled = not available_systems.has(BrainSystemSwitcher.BrainSystem.INTERNAL_STRUCTURES)
system_switcher_ui.get_node("BrainstemButton").disabled = not available_systems.has(BrainSystemSwitcher.BrainSystem.BRAINSTEM_FOCUS)

var comparative_dropdown = comparative_ui.get_node("ComparisonDropdown")
comparative_dropdown.clear()

# Add available comparisons
var comparisons = comparative.get_available_comparisons()
var pathway_dropdown = pathway_ui.get_node("PathwayDropdown")
pathway_dropdown.clear()

# Add available pathways
var pathways = pathway.get_available_pathways()
var success = educational_coordinator.switch_brain_system(system)

var dropdown = comparative_ui.get_node("ComparisonDropdown")
var selected_id = dropdown.get_selected_metadata()

var success_2 = educational_coordinator.start_comparative_study(selected_id)

var dropdown_2 = pathway_ui.get_node("PathwayDropdown")
var selected_id_2 = dropdown.get_selected_metadata()

var success_3 = educational_coordinator.start_learning_pathway(selected_id)

var success_4 = educational_coordinator.advance_learning_step()

var step = educational_coordinator.get_current_learning_step()
var mode = mode_selector.get_item_id(index)
current_mode = mode

var success_5 = educational_coordinator.set_educational_mode(mode)

var brain_switcher_2 = educational_coordinator.get_module("brain_system_switcher")
var pathway_2 = educational_coordinator.get_module("learning_pathway")
var brain_switcher_3 = educational_coordinator.get_module("brain_system_switcher")
var comparative_2 = educational_coordinator.get_module("comparative_anatomy")

@onready var ui_container = $UI/Container
@onready var system_switcher_ui = $UI/Container/SystemSwitcherPanel
@onready var comparative_ui = $UI/Container/ComparativePanel
@onready var pathway_ui = $UI/Container/PathwayPanel
@onready var status_label = $UI/StatusLabel
@onready var mode_selector = $UI/ModeSelector

# === VARIABLES ===

func _ready() -> void:
	"""Initialize the demo scene"""
	# Initialize the educational coordinator
	educational_coordinator = EducationalModuleCoordinator.new()
	add_child(educational_coordinator)

	if not educational_coordinator.initialize():
		push_error("[EducationDemo] Failed to initialize educational coordinator")
		status_label.text = "Error: Educational system initialization failed"
		return

		status_label.text = "Educational modules initialized successfully"

		# Connect UI signals
		_connect_ui_signals()

		# Initialize UI elements based on available modules
		_initialize_ui_elements()

		# Set up mode selector
		_setup_mode_selector()

		# === UI SETUP ===
func _initialize_ui_elements() -> void:
	"""Initialize UI elements based on available modules"""
	# System Switcher UI

func _fix_orphaned_code():
	if brain_switcher:
		system_switcher_ui.visible = true
		_update_system_switcher_ui(brain_switcher)
		else:
			system_switcher_ui.visible = false

			# Comparative Anatomy UI
func _fix_orphaned_code():
	if comparative:
		comparative_ui.visible = true
		_update_comparative_ui(comparative)
		else:
			comparative_ui.visible = false

			# Learning Pathway UI
func _fix_orphaned_code():
	if pathway:
		pathway_ui.visible = true
		_update_pathway_ui(pathway)
		else:
			pathway_ui.visible = false

func _fix_orphaned_code():
	for comparison in comparisons:
		comparative_dropdown.add_item(comparison.title, comparison.id)

func _fix_orphaned_code():
	for p in pathways:
		pathway_dropdown.add_item(p.name, p.id)

		# Update next button state
		pathway_ui.get_node("NextButton").disabled = pathway._current_pathway_id.is_empty()

		# === ACTIONS ===
func _fix_orphaned_code():
	if success:
		status_label.text = "Switching to " + BrainSystemSwitcher.BrainSystem.keys()[system]
		else:
			status_label.text = "Failed to switch brain system"

func _fix_orphaned_code():
	if selected_id == null or selected_id.is_empty():
		status_label.text = "Please select a comparison"
		return

func _fix_orphaned_code():
	if success:
		status_label.text = "Starting comparative study: " + dropdown.get_item_text(dropdown.selected)
		else:
			status_label.text = "Failed to start comparative study"

func _fix_orphaned_code():
	if selected_id == null or selected_id.is_empty():
		status_label.text = "Please select a pathway"
		return

func _fix_orphaned_code():
	if success:
		status_label.text = "Starting pathway: " + dropdown.get_item_text(dropdown.selected)
		pathway_ui.get_node("NextButton").disabled = false
		else:
			status_label.text = "Failed to start pathway"

func _fix_orphaned_code():
	if success:
func _fix_orphaned_code():
	if not step.is_empty():
		status_label.text = "Current step: " + step.title
		else:
			status_label.text = "Pathway completed"
			pathway_ui.get_node("NextButton").disabled = true
			else:
				status_label.text = "Failed to advance pathway or pathway complete"
				pathway_ui.get_node("NextButton").disabled = true

				# === SIGNAL HANDLERS ===
func _fix_orphaned_code():
	if success:
		status_label.text = "Mode changed to: " + EducationalModuleCoordinator.EducationalMode.keys()[mode]

		# Update UI visibility based on mode
		match mode:
			EducationalModuleCoordinator.EducationalMode.FREE_EXPLORATION:
				system_switcher_ui.visible = true
				comparative_ui.visible = false
				pathway_ui.visible = false

				EducationalModuleCoordinator.EducationalMode.GUIDED_LEARNING:
					system_switcher_ui.visible = true
					comparative_ui.visible = false
					pathway_ui.visible = true

					EducationalModuleCoordinator.EducationalMode.COMPARATIVE_STUDY:
						system_switcher_ui.visible = false
						comparative_ui.visible = true
						pathway_ui.visible = false

						EducationalModuleCoordinator.EducationalMode.ASSESSMENT,
						EducationalModuleCoordinator.EducationalMode.CLINICAL_CASE:
							system_switcher_ui.visible = false
							comparative_ui.visible = false
							pathway_ui.visible = true
							else:
								status_label.text = "Failed to change mode"
								# Revert selection
								mode_selector.select(mode_selector.get_item_index(current_mode))

func _fix_orphaned_code():
	if brain_switcher:
		_update_system_switcher_ui(brain_switcher)

		"pathway_start", "pathway_complete":
			# Pathway started or completed, update pathway UI
func _fix_orphaned_code():
	if pathway:
		_update_pathway_ui(pathway)

func _fix_orphaned_code():
	if brain_switcher:
		_update_system_switcher_ui(brain_switcher)

		"comparison":
func _fix_orphaned_code():
	if comparative:
		_update_comparative_ui(comparative)

func _connect_ui_signals() -> void:
	"""Connect UI signals to handlers"""
	# Connect system switcher UI
	system_switcher_ui.get_node("WholeButton").pressed.connect(
	func(): _switch_brain_system(BrainSystemSwitcher.BrainSystem.WHOLE_BRAIN))
	system_switcher_ui.get_node("HalfButton").pressed.connect(
	func(): _switch_brain_system(BrainSystemSwitcher.BrainSystem.HALF_SECTIONAL))
	system_switcher_ui.get_node("InternalButton").pressed.connect(
	func(): _switch_brain_system(BrainSystemSwitcher.BrainSystem.INTERNAL_STRUCTURES))
	system_switcher_ui.get_node("BrainstemButton").pressed.connect(
	func(): _switch_brain_system(BrainSystemSwitcher.BrainSystem.BRAINSTEM_FOCUS))

	# Connect comparative UI
	comparative_ui.get_node("CompareButton").pressed.connect(_start_comparison)

	# Connect pathway UI
	pathway_ui.get_node("StartButton").pressed.connect(_start_pathway)
	pathway_ui.get_node("NextButton").pressed.connect(_advance_pathway)

	# Connect mode selector
	mode_selector.item_selected.connect(_on_mode_selected)

	# Connect coordinator signals
	educational_coordinator.educational_environment_changed.connect(_on_environment_changed)
	educational_coordinator.learning_objective_completed.connect(_on_objective_completed)
	educational_coordinator.educational_content_ready.connect(_on_content_ready)

func _setup_mode_selector() -> void:
	"""Set up the educational mode selector"""
	mode_selector.clear()

	# Add all educational modes
	for mode_value in EducationalModuleCoordinator.EducationalMode.values():
func _update_system_switcher_ui(brain_switcher) -> void:
	"""Update the system switcher UI based on available systems"""
func _update_comparative_ui(comparative) -> void:
	"""Update the comparative anatomy UI based on available comparisons"""
func _update_pathway_ui(pathway) -> void:
	"""Update the learning pathway UI based on available pathways"""
func _switch_brain_system(system: int) -> void:
	"""Switch to a specific brain system"""
func _start_comparison() -> void:
	"""Start a comparative anatomy study"""
func _start_pathway() -> void:
	"""Start a learning pathway"""
func _advance_pathway() -> void:
	"""Advance to the next step in the current pathway"""
func _on_mode_selected(index: int) -> void:
	"""Handle mode selection from dropdown"""
func _on_environment_changed(change_type: String) -> void:
	"""Handle educational environment changes"""
	print("[EducationDemo] Environment changed: " + change_type)

	# Refresh UI elements based on change type
	match change_type:
		"mode_change":
			# Mode was changed, update all UI
			_initialize_ui_elements()

			"system_change":
				# Brain system changed, update relevant UI
func _on_objective_completed(objective_id: String, pathway_id: String) -> void:
	"""Handle learning objective completion"""
	print("[EducationDemo] Objective completed: " + objective_id + " in pathway: " + pathway_id)

	# In a real implementation, this might update progress indicators, show celebration, etc.
	status_label.text = "Objective completed: " + objective_id

func _on_content_ready(content_type: String) -> void:
	"""Handle educational content ready notification"""
	print("[EducationDemo] Content ready: " + content_type)

	# Update relevant UI
	match content_type:
		"brain_system":
