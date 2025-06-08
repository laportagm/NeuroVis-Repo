extends SceneTree


func _init():
	print("🔧 Fixing FeatureFlags for Core Development Mode...")

	# Create proper config
	var config = ConfigFile.new()

	# Core development settings - simplified mode
	config.set_value("features", "UI_MODULAR_COMPONENTS", false)  # OFF - use legacy
	config.set_value("features", "UI_LEGACY_PANELS", true)  # ON - simple panels
	config.set_value("features", "UI_COMPONENT_POOLING", false)  # OFF
	config.set_value("features", "UI_STATE_PERSISTENCE", false)  # OFF
	config.set_value("features", "UI_STYLE_ENGINE", false)  # OFF
	config.set_value("features", "UI_ADVANCED_INTERACTIONS", false)  # OFF
	config.set_value("features", "UI_GESTURE_RECOGNITION", false)  # OFF
	config.set_value("features", "UI_CONTEXT_MENUS", false)  # OFF
	config.set_value("features", "UI_SMOOTH_ANIMATIONS", false)  # OFF - simpler

	# Keep these enabled
	config.set_value("features", "ADVANCED_ANIMATIONS", true)
	config.set_value("features", "ACCESSIBILITY_ENHANCED", true)
	config.set_value("features", "PERFORMANCE_MONITORING", true)
	config.set_value("features", "DEBUG_COMPONENT_INSPECTOR", true)
	config.set_value("features", "DEBUG_PERFORMANCE_OVERLAY", true)
	config.set_value("features", "MEMORY_OPTIMIZATION", true)

	# Disable advanced features
	config.set_value("features", "GESTURE_SUPPORT", false)
	config.set_value("features", "AI_ASSISTANT_V2", false)
	config.set_value("features", "LAZY_LOADING", false)
	config.set_value("features", "UI_ACCESSIBILITY_MODE", false)
	config.set_value("features", "UI_MINIMAL_THEME", false)

	# Force debug override to false
	config.set_value("system", "ignore_debug_overrides", true)

	# Save configuration
	var save_result = config.save("user://feature_flags.cfg")

	if save_result == OK:
		print("✅ Feature flags saved to user://feature_flags.cfg")
		print("✅ Core development mode configured:")
		print("   - UI_LEGACY_PANELS: ON")
		print("   - UI_MODULAR_COMPONENTS: OFF")
		print("   - Complex UI features: DISABLED")
		print("   - Debug tools: ENABLED")
	else:
		print("❌ Failed to save feature flags!")

	print("\n⚠️  IMPORTANT: Restart NeuroVis for changes to take effect!")

	quit()
