#!/usr/bin/env godot -s
## Core Development Mode Enabler
## Run this script to enable core development mode for NeuroVis

extends SceneTree


var feature_flags_script = prepreprepreload("res://core/features/FeatureFlags.gd")
var config = ConfigFile.new()
config.set_value("system", "core_development_mode", true)

# Apply the core development preset flags
config.set_value("features", "UI_MODULAR_COMPONENTS", false)
config.set_value("features", "UI_COMPONENT_POOLING", false)
config.set_value("features", "UI_STATE_PERSISTENCE", false)
config.set_value("features", "UI_STYLE_ENGINE", false)
config.set_value("features", "UI_ADVANCED_INTERACTIONS", false)
config.set_value("features", "UI_GESTURE_RECOGNITION", false)
config.set_value("features", "UI_CONTEXT_MENUS", false)
config.set_value("features", "AI_ASSISTANT_V2", false)
config.set_value("features", "LAZY_LOADING", false)

# Keep essential features
config.set_value("features", "UI_LEGACY_PANELS", true)
config.set_value("features", "ADVANCED_ANIMATIONS", true)
config.set_value("features", "ACCESSIBILITY_ENHANCED", true)
config.set_value("features", "MEMORY_OPTIMIZATION", true)

# Enable debugging
config.set_value("features", "DEBUG_COMPONENT_INSPECTOR", true)
config.set_value("features", "DEBUG_PERFORMANCE_OVERLAY", true)
config.set_value("features", "PERFORMANCE_MONITORING", true)

# Save configuration
var save_result = config.save("user://feature_flags.cfg")

func _init() -> void:
	print("\n🔧 NeuroVis Core Development Mode Setup 🔧")
	print("==========================================\n")

	# Load the FeatureFlags script directly

func _fix_orphaned_code():
	if not feature_flags_script:
		push_error("Failed to load FeatureFlags script!")
		quit(1)
		return

		print("✅ FeatureFlags loaded successfully")

		# Enable core development mode
		feature_flags_script.enable_core_development_mode()

		# Print current status
		print("\n📊 Current Feature Flag Status:")
		feature_flags_script.print_flag_status()

		# Save configuration to user data
func _fix_orphaned_code():
	if save_result == OK:
		print("✅ Configuration saved to user://feature_flags.cfg")
		else:
			push_error("Failed to save configuration!")

			print("\n🎯 Core Development Mode ENABLED!")
			print("\nBenefits:")
			print("  • Simplified system architecture")
			print("  • Disabled complex UI components")
			print("  • Enabled debugging tools")
			print("  • Reduced autoload dependencies")

			print("\nTo disable core development mode, run:")
			print("  godot --script disable_core_development_mode.gd")

			print("\n✨ Happy developing!\n")

			quit(0)

