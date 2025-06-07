## core_architecture_setup.gd
## Setup script for NeuroVis core architecture components
##
## This script initializes and configures the core architectural components
## for the NeuroVis educational platform, providing a foundation for
## decoupled, extensible, and testable educational features.
##
## @tutorial: Core architecture setup for educational platform
## @version: 1.0

extends EditorScript

# === CONSTANTS ===

const AUTOLOAD_CONFIG_PATH = "res://project.godot"
const AUTOLOAD_SECTION = "autoload"

const SCRIPT_PATHS = {
"event_bus": "res://core/events/EventBus.gd",
"service_locator": "res://core/services/ServiceLocator.gd",
"resource_manager": "res://core/resources/ResourceManager.gd",
"app_state": "res://core/state/AppState.gd",
"systems_registry": "res://core/systems/CoreSystemsRegistry.gd"
}

const AUTOLOAD_NAMES = {
"event_bus": "EventBus",
"service_locator": "ServiceLocator",
"resource_manager": "ResourceManager",
"app_state": "AppState",
"systems_registry": "CoreSystemsRegistry"
}


# === EXECUTION ENTRY POINT ===

var current_autoloads = _get_current_autoloads()

# Update project.godot with new autoloads
_update_project_autoloads(current_autoloads)

# Create config directory and files if needed
_create_config_files()

var all_exist = true

var script_path = SCRIPT_PATHS[component]
var file_exists = FileAccess.file_exists(script_path)

var directories = ["res://config", "res://config/presets"]

var current_autoloads_2 = {}

var config = ConfigFile.new()
var err = config.load(AUTOLOAD_CONFIG_PATH)

var keys = config.get_section_keys(AUTOLOAD_SECTION)
var value = config.get_value(AUTOLOAD_SECTION, key)
current_autoloads[key] = value
var config_2 = ConfigFile.new()
var err_2 = config.load(AUTOLOAD_CONFIG_PATH)

var autoload_name = AUTOLOAD_NAMES[component]
var script_path_2 = SCRIPT_PATHS[component]
var autoload_value = "*" + script_path

var preload_path = "res://config/preload_resources.cfg"
var preload_config = ConfigFile.new()

# Add example resource groups
preload_config.set_value(
"brain_models",
"resources",
[
"res://assets/models/Half_Brain.glb",
"res://assets/models/Internal_Structures.glb",
"res://assets/models/Brainstem(Solid).glb"
]
)
preload_config.set_value("brain_models", "auto_preload", true)

preload_config.set_value(
"ui_resources",
"resources",
[
"res://assets/icons/brain_icon.png",
"res://assets/icons/settings_icon.png",
"res://assets/icons/info_icon.png"
]
)
preload_config.set_value("ui_resources", "auto_preload", false)

preload_config.save(preload_path)
var presets_path = "res://config/presets/feature_presets.cfg"
var presets_config = ConfigFile.new()

# Add default presets
presets_config.set_value("development", "UI_MODULAR_COMPONENTS", true)
presets_config.set_value("development", "UI_COMPONENT_POOLING", true)
presets_config.set_value("development", "UI_STATE_PERSISTENCE", true)
presets_config.set_value("development", "DEBUG_COMPONENT_INSPECTOR", true)

presets_config.set_value("production", "UI_MODULAR_COMPONENTS", false)
presets_config.set_value("production", "UI_LEGACY_PANELS", true)
presets_config.set_value("production", "UI_COMPONENT_POOLING", false)
presets_config.set_value("production", "DEBUG_COMPONENT_INSPECTOR", false)

presets_config.save(presets_path)

func _fix_orphaned_code():
	print("\nNeuroVis core architecture setup complete!")
	print("Please restart the Godot editor for changes to take effect.")
	print("================================================\n")


	# === VERIFICATION FUNCTIONS ===
func _fix_orphaned_code():
	for component in SCRIPT_PATHS:
func _fix_orphaned_code():
	if file_exists:
		print("✓ Found: " + script_path)
		else:
			print("✗ Missing: " + script_path)
			all_exist = false

			return all_exist


func _fix_orphaned_code():
	for dir_path in directories:
		if not DirAccess.dir_exists_absolute(dir_path):
			print("Creating directory: " + dir_path)
			DirAccess.make_dir_recursive_absolute(dir_path)
			else:
				print("Directory already exists: " + dir_path)


				# === AUTOLOAD CONFIGURATION ===
func _fix_orphaned_code():
	if err != OK:
		print("Failed to load project.godot. Error: " + str(err))
		return current_autoloads

		if config.has_section(AUTOLOAD_SECTION):
func _fix_orphaned_code():
	for key in keys:
func _fix_orphaned_code():
	print("Found existing autoload: " + key + " = " + value)

	return current_autoloads


func _fix_orphaned_code():
	if err != OK:
		print("Failed to load project.godot. Error: " + str(err))
		return

		# Add or update autoloads
		for component in AUTOLOAD_NAMES:
func _fix_orphaned_code():
	if current_autoloads.has(autoload_name):
		print("Autoload already exists: " + autoload_name + ". Skipping.")
		else:
			print("Adding new autoload: " + autoload_name + " = " + autoload_value)
			config.set_value(AUTOLOAD_SECTION, autoload_name, autoload_value)

			# Save project.godot
			err = config.save(AUTOLOAD_CONFIG_PATH)
			if err != OK:
				print("Failed to save project.godot. Error: " + str(err))
				else:
					print("Project autoloads updated successfully!")


					# === CONFIG FILE CREATION ===
func _fix_orphaned_code():
	if not FileAccess.file_exists(preload_path):
		print("Creating preload resources config: " + preload_path)
func _fix_orphaned_code():
	print("Preload resources config already exists: " + preload_path)

	# Create feature_presets.cfg
func _fix_orphaned_code():
	if not FileAccess.file_exists(presets_path):
		print("Creating feature presets config: " + presets_path)
func _fix_orphaned_code():
	print("Feature presets config already exists: " + presets_path)

func _run() -> void:
	print("\n=== NEUROVIS CORE ARCHITECTURE SETUP ===")

	# Verify script existence
	if not _verify_script_files():
		print("Script verification failed. Aborting setup.")
		return

		# Create directories if needed
		_ensure_directories_exist()

		# Check current autoloads
func _verify_script_files() -> bool:
	"""Verify that all required script files exist"""
	print("\nVerifying script files...")
func _ensure_directories_exist() -> void:
	"""Create required directories if they don't exist"""
	print("\nEnsuring required directories exist...")

func _get_current_autoloads() -> Dictionary:
	"""Get current autoloads from project.godot"""
	print("\nReading current autoloads...")
func _update_project_autoloads(current_autoloads: Dictionary) -> void:
	"""Update project.godot with new autoloads"""
	print("\nUpdating project autoloads...")

func _create_config_files() -> void:
	"""Create configuration files for architecture components"""
	print("\nCreating configuration files...")

	# Create preload_resources.cfg
	@tool
