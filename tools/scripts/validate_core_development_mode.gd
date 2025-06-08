#!/usr/bin/env gdscript
# Core Development Mode Validator - Fixed Version
# Checks that essential systems work in simplified mode

extends SceneTree


var title_separator = ""
var all_tests_passed = true

# Test 1: Essential autoloads
var separator = ""
var essential_autoloads = [
"KnowledgeService", "UIThemeManager", "AIAssistant", "ModelSwitcherGlobal", "DebugCmd"
]

var passed = true
var passed_2 = true

# Test that FeatureFlags class is available
var flags_script = preload("res://core/features/FeatureFlags.gd")
# FIXED: Orphaned code - var config = ConfigFile.new()
# FIXED: Orphaned code - var ui_legacy = config.get_value("features", "UI_LEGACY_PANELS", false)
# FIXED: Orphaned code - var ui_modular = config.get_value("features", "UI_MODULAR_COMPONENTS", true)

# FIXED: Orphaned code - var factory_script = preload("res://ui/panels/InfoPanelFactory.gd")
# FIXED: Orphaned code - var panel = factory_script.create_info_panel()
# FIXED: Orphaned code - var ks = get_autoload("KnowledgeService")
# FIXED: Orphaned code - var ids = ks.get_all_structure_ids()
# FIXED: Orphaned code - var theme_manager = get_autoload("UIThemeManager")

func _init():
	print("🔍 Validating Core Development Mode...")

func has_autoload(name: String) -> bool:
	return Engine.has_singleton(name)


func get_autoload(name: String):
	return Engine.get_singleton(name)

for i in range(37):
	title_separator += "="
	print(title_separator)

print("\n📋 Test 1: Essential Autoloads")
all_tests_passed = _test_autoloads() and all_tests_passed

# Test 2: FeatureFlags configuration
print("\n🎛️  Test 2: FeatureFlags Configuration")
all_tests_passed = _test_feature_flags() and all_tests_passed

# Test 3: UI component creation
print("\n🖼️  Test 3: UI Component Creation")
all_tests_passed = _test_ui_components() and all_tests_passed

# Test 4: Knowledge service
print("\n📚 Test 4: Knowledge Service")
all_tests_passed = _test_knowledge_service() and all_tests_passed

# Test 5: Theme system
print("\n🎨 Test 5: Theme System")
all_tests_passed = _test_theme_system() and all_tests_passed

# Final result
for i in range(50):
	separator += "="
	print("\n" + separator)
	if all_tests_passed:
		print("✅ ALL TESTS PASSED - Core Development Mode Ready!")
		print("🚀 You can now work on core architecture with simplified systems")
		else:
			print("❌ SOME TESTS FAILED - Check the issues above")
			print("🛠️  Run ./tools/scripts/restore_full_systems.sh if needed")
			print(separator)

			quit()


for autoload_name in essential_autoloads:
	if has_autoload(autoload_name):
		print("  ✅ " + autoload_name + ": Available")
		else:
			print("  ❌ " + autoload_name + ": Missing!")
			passed = false

			return passed


if flags_script:
	print("  ✅ FeatureFlags: Loaded successfully")

	# Test if the config file was created
if config.load("user://feature_flags.cfg") == OK:
	print("  ✅ FeatureFlags config: Found at user://feature_flags.cfg")

	# Check some key settings
print("  📊 Current simplified flags:")
print("    - Legacy panels: " + ("ON" if ui_legacy else "OFF"))
print("    - Modular components: " + ("ON" if ui_modular else "OFF"))

if ui_legacy and not ui_modular:
	print("  ✅ Core development flags set correctly")
	else:
		print("  ⚠️  Flags may not be set for core development mode")
		else:
			print("  ❌ FeatureFlags config: Not found!")
			passed = false
			else:
				print("  ❌ FeatureFlags: Cannot load!")
				passed = false

				return passed


if factory_script:
	print("  ✅ InfoPanelFactory: Script loaded")

	# Since InfoPanelFactory is not an autoload, we need to use the script directly
	# The create_info_panel is a static method
	if factory_script.has_method("create_info_panel"):
		# Call the static method through the script
if panel:
	print("  ✅ InfoPanel creation: Success")
	panel.queue_free()  # Clean up
	return true
	else:
		print("  ❌ InfoPanel creation: Failed!")
		return false
		else:
			print("  ❌ InfoPanelFactory: create_info_panel method not found!")
			return false
			else:
				print("  ❌ InfoPanelFactory: Script not available!")
				return false


if ks and ks.has_method("get_structure"):
	print("  ✅ KnowledgeService: Available and functional")

	# Test if it has structures loaded
	if ks.has_method("get_all_structure_ids"):
print("  ✅ Structures loaded: " + str(ids.size()) + " available")

return true
else:
	print("  ❌ KnowledgeService: Available but missing methods!")
	return false
	else:
		print("  ❌ KnowledgeService: Not available!")
		return false


if theme_manager:
	print("  ✅ UIThemeManager: Available")

	# Test that it has essential methods
	if theme_manager.has_method("set_theme_mode"):
		print("  ✅ Theme switching: Available")
		return true
		else:
			print("  ❌ Theme switching: Methods missing!")
			return false
			else:
				print("  ❌ UIThemeManager: Failed to get instance!")
				return false
				else:
					print("  ❌ UIThemeManager: Not available!")
					return false


func _test_autoloads() -> bool:
func _test_feature_flags() -> bool:
func _test_ui_components() -> bool:
	# Test InfoPanelFactory (should still work)
func _test_knowledge_service() -> bool:
	if has_autoload("KnowledgeService"):
func _test_theme_system() -> bool:
	if has_autoload("UIThemeManager"):
