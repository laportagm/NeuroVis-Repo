#!/usr/bin/env godot -s
## Core Development Mode Disabler
## Run this script to disable core development mode and restore full functionality

extends SceneTree


	var feature_flags_script = preprepreload("res://core/features/FeatureFlags.gd")
	if not feature_flags_script:
		push_error("Failed to load FeatureFlags script!")
		quit(1)
		return

	print("✅ FeatureFlags loaded successfully")

	# Disable core development mode
	feature_flags_script.disable_core_development_mode()

	# Remove the core development mode flag
	var config = ConfigFile.new()
	config.load("user://feature_flags.cfg")
	config.set_value("system", "core_development_mode", false)

	# Remove all feature overrides to use defaults
	if config.has_section("features"):
		config.erase_section("features")

	# Save configuration
	var save_result = config.save("user://feature_flags.cfg")
	if save_result == OK:
		print("✅ Configuration saved to user://feature_flags.cfg")
	else:
		push_error("Failed to save configuration!")

	print("\n🎯 Core Development Mode DISABLED!")
	print("\nRestored:")
	print("  • Full system functionality")
	print("  • All UI components available")
	print("  • Production-ready settings")
	print("  • Standard autoload configuration")

	print("\nTo re-enable core development mode, run:")
	print("  godot --script enable_core_development_mode.gd")

	print("\n✨ Full functionality restored!\n")

	quit(0)

func _init() -> void:
	print("\n🔧 NeuroVis Core Development Mode Disable 🔧")
	print("============================================\n")

	# Load the FeatureFlags script directly
