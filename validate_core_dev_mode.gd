#!/usr/bin/env godot -s
## Core Development Mode Validator
## Verifies that core development mode is properly configured
extends SceneTree

func _init() -> void:
	print("\n🔍 Core Development Mode Validation")
	print("===================================\n")
	
	var all_checks_passed := true
	
	# Check 1: FeatureFlags autoload
	print("1️⃣ Checking FeatureFlags autoload...")
	if Engine.has_singleton("FeatureFlags"):
		print("   ✅ FeatureFlags is loaded as autoload")
		
		var FeatureFlagsRef = Engine.get_singleton("FeatureFlags")
		
		# Check if core development mode is enabled
		if FeatureFlagsRef.call("is_core_development_mode"):
			print("   ✅ Core development mode is ENABLED")
		else:
			print("   ❌ Core development mode is DISABLED")
			all_checks_passed = false
	else:
		print("   ❌ FeatureFlags autoload not found!")
		print("      Make sure FeatureFlags is enabled in project.godot")
		all_checks_passed = false
	
	# Check 2: Feature flag configuration
	print("\n2️⃣ Checking feature flag configuration...")
	var feature_flags = load("res://core/features/FeatureFlags.gd")
	if feature_flags:
		
		# Check complex features are disabled
		var complex_features = [
			"UI_MODULAR_COMPONENTS",
			"UI_COMPONENT_POOLING", 
			"UI_STATE_PERSISTENCE",
			"UI_STYLE_ENGINE",
			"UI_ADVANCED_INTERACTIONS"
		]
		
		var complex_disabled := true
		for feature in complex_features:
			if feature_flags.is_enabled(feature):
				print("   ❌ %s is enabled (should be disabled)" % feature)
				complex_disabled = false
			else:
				print("   ✅ %s is disabled" % feature)
		
		if not complex_disabled:
			all_checks_passed = false
		
		# Check essential features are enabled
		var essential_features = [
			"UI_LEGACY_PANELS",
			"ADVANCED_ANIMATIONS",
			"ACCESSIBILITY_ENHANCED"
		]
		
		var essential_enabled := true
		for feature in essential_features:
			if feature_flags.is_enabled(feature):
				print("   ✅ %s is enabled" % feature)
			else:
				print("   ❌ %s is disabled (should be enabled)" % feature)
				essential_enabled = false
		
		if not essential_enabled:
			all_checks_passed = false
	
	# Check 3: Configuration file
	print("\n3️⃣ Checking configuration file...")
	var config = ConfigFile.new()
	if config.load("user://feature_flags.cfg") == OK:
		print("   ✅ Configuration file exists")
		
		if config.has_section_key("system", "core_development_mode"):
			var mode = config.get_value("system", "core_development_mode")
			if mode:
				print("   ✅ Core development mode flag is set to true")
			else:
				print("   ❌ Core development mode flag is set to false")
				all_checks_passed = false
		else:
			print("   ❌ Core development mode flag not found in config")
			all_checks_passed = false
	else:
		print("   ❌ Configuration file not found at user://feature_flags.cfg")
		all_checks_passed = false
	
	# Check 4: Autoload configuration
	print("\n4️⃣ Checking autoload configuration...")
	var required_autoloads = [
		"KB",
		"KnowledgeService",
		"StructureAnalysisManager", 
		"AIAssistant",
		"UIThemeManager",
		"ModelSwitcherGlobal",
		"DebugCmd",
		"FeatureFlags"
	]
	
	var autoloads_ok := true
	for autoload_name in required_autoloads:
		if Engine.has_singleton(autoload_name):
			print("   ✅ %s is loaded" % autoload_name)
		else:
			print("   ❌ %s is missing" % autoload_name)
			autoloads_ok = false
	
	if not autoloads_ok:
		all_checks_passed = false
		print("\n   ⚠️  Some autoloads are missing. This is expected in headless mode.")
	
	# Summary
	print("\n" + "=".repeat(40))
	if all_checks_passed:
		print("✅ VALIDATION PASSED")
		print("\nCore development mode is properly configured!")
		print("\nYou can now:")
		print("• Run the project with simplified systems")
		print("• Focus on core architecture development")
		print("• Use debugging tools without UI complexity")
	else:
		print("❌ VALIDATION FAILED")
		print("\nPlease run: ./enable_core_dev.sh")
		print("or: godot --script enable_core_development_mode.gd")
	print("=".repeat(40) + "\n")
	
	quit(0 if all_checks_passed else 1)