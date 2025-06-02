#!/usr/bin/env gdscript
# Core Development Mode Enabler
# Run this script to simplify systems during core architecture work

extends SceneTree

func _init():
	print("🔧 Enabling Core Development Mode...")
	
	# Apply conservative FeatureFlags preset
	FeatureFlags.apply_preset("core_development")
	
	# Disable complex systems
	FeatureFlags.disable_feature(FeatureFlags.UI_MODULAR_COMPONENTS, true)
	FeatureFlags.disable_feature(FeatureFlags.UI_COMPONENT_POOLING, true)
	FeatureFlags.disable_feature(FeatureFlags.UI_STATE_PERSISTENCE, true)
	FeatureFlags.disable_feature(FeatureFlags.UI_STYLE_ENGINE, true)
	FeatureFlags.disable_feature(FeatureFlags.UI_ADVANCED_INTERACTIONS, true)
	
	# Keep essential educational features
	FeatureFlags.enable_feature(FeatureFlags.UI_LEGACY_PANELS, true)
	FeatureFlags.enable_feature(FeatureFlags.ADVANCED_ANIMATIONS, true)
	FeatureFlags.enable_feature(FeatureFlags.ACCESSIBILITY_ENHANCED, true)
	
	# Enable development debugging
	FeatureFlags.enable_feature(FeatureFlags.DEBUG_COMPONENT_INSPECTOR, true)
	FeatureFlags.enable_feature(FeatureFlags.PERFORMANCE_MONITORING, true)
	
	print("✅ Core Development Mode Enabled")
	print("📊 Current flag status:")
	FeatureFlags.print_flag_status()
	
	quit()
