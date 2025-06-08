## Verify Autoloads Script
## Tests all autoload services are properly initialized
## @version: 1.0

extends SceneTree

# === AUTOLOAD LIST ===
const AUTOLOADS = [
	{"name": "KB", "methods": ["search_structures", "get_all_structures"]},
	{
		"name": "KnowledgeService",
		"methods": ["get_structure", "search_structures", "is_initialized"]
	},
	{"name": "StructureAnalysisManager", "methods": ["analyze_structure"]},
	{"name": "AIAssistant", "methods": ["set_current_structure", "ask_question"]},
	{"name": "GeminiAI", "methods": ["initialize", "setup_api_key"]},
	{"name": "UIThemeManager", "methods": ["set_theme_mode", "get_current_theme"]},
	{
		"name": "AccessibilityManager",
		"methods": ["enable_high_contrast", "is_high_contrast_enabled"]
	},
	{"name": "ModelSwitcherGlobal", "methods": ["toggle_model_visibility", "get_model_visibility"]},
	{"name": "DebugCmd", "methods": ["execute_command", "register_command"]},
	{"name": "FeatureFlags", "methods": ["is_enabled", "set_enabled"]},
	{"name": "AIConfig", "methods": ["get_provider_config", "save_provider_config"]},
	{"name": "AIRegistry", "methods": ["register_provider", "get_active_provider"]},
	{"name": "AIIntegration", "methods": ["initialize", "get_available_providers"]}
]

var results: Dictionary = {}
var total_tests: int = 0
var passed_tests: int = 0


# === MAIN ===
func _initialize() -> void:
	print("\n=== NeuroVis Autoload Verification ===")
	print("Testing %d autoload services...\n" % AUTOLOADS.size())

	# Test each autoload
	for autoload_info in AUTOLOADS:
		_test_autoload(autoload_info)

	# Print summary
	_print_summary()

	# Exit with appropriate code
	var exit_code = 0 if passed_tests == total_tests else 1
	quit(exit_code)


func _test_autoload(autoload_info: Dictionary) -> void:
	"""Test a single autoload service"""
	var autoload_name = autoload_info.name
	var required_methods = autoload_info.methods

	print("Testing %s..." % autoload_name)
	results[autoload_name] = {"exists": false, "methods": {}, "status": "FAIL", "error": ""}

	# Check if autoload exists
	var autoload = root.get_node_or_null(autoload_name)
	if not autoload:
		results[autoload_name].error = "Autoload not found"
		print("  ❌ Not found in /root/")
		total_tests += 1
		return

	results[autoload_name].exists = true
	print("  ✅ Found at /root/%s" % autoload_name)

	# Check required methods
	var all_methods_found = true
	for method in required_methods:
		total_tests += 1
		if autoload.has_method(method):
			results[autoload_name].methods[method] = true
			passed_tests += 1
			print("  ✅ Method '%s' found" % method)
		else:
			results[autoload_name].methods[method] = false
			all_methods_found = false
			print("  ❌ Method '%s' missing" % method)

	# Determine overall status
	if all_methods_found:
		results[autoload_name].status = "PASS"
		passed_tests += 1
	else:
		results[autoload_name].status = "PARTIAL"

	total_tests += 1

	# Test specific functionality
	_test_autoload_functionality(autoload_name, autoload)

	print("")


func _test_autoload_functionality(autoload_name: String, autoload: Node) -> void:
	"""Test specific functionality of each autoload"""
	match autoload_name:
		"KnowledgeService":
			_test_knowledge_service(autoload)
		"UIThemeManager":
			_test_theme_manager(autoload)
		"AccessibilityManager":
			_test_accessibility_manager(autoload)
		"FeatureFlags":
			_test_feature_flags(autoload)
		"AIRegistry":
			_test_ai_registry(autoload)


func _test_knowledge_service(service: Node) -> void:
	"""Test KnowledgeService functionality"""
	print("  Testing functionality...")

	# Test structure retrieval
	if service.has_method("get_structure"):
		var hippocampus = service.get_structure("hippocampus")
		if not hippocampus.is_empty():
			print("    ✅ Structure retrieval working")
		else:
			print("    ⚠️  Structure retrieval returned empty")

	# Test search
	if service.has_method("search_structures"):
		var results_search = service.search_structures("memory")
		print("    ✅ Search found %d results for 'memory'" % results_search.size())


func _test_theme_manager(manager: Node) -> void:
	"""Test UIThemeManager functionality"""
	print("  Testing functionality...")

	if manager.has_method("get_current_theme"):
		var current_theme = manager.get_current_theme()
		print("    ✅ Current theme: %s" % str(current_theme))


func _test_accessibility_manager(manager: Node) -> void:
	"""Test AccessibilityManager functionality"""
	print("  Testing functionality...")

	if manager.has_method("is_high_contrast_enabled"):
		var high_contrast = manager.is_high_contrast_enabled()
		print("    ✅ High contrast mode: %s" % str(high_contrast))

	if manager.has_method("get_font_size_multiplier"):
		var font_size = manager.get_font_size_multiplier()
		print("    ✅ Font size multiplier: %.2f" % font_size)


func _test_feature_flags(flags: Node) -> void:
	"""Test FeatureFlags functionality"""
	print("  Testing functionality...")

	# Check some common flags
	var test_flags = ["ai_assistant", "multi_selection", "debug_mode"]
	for flag in test_flags:
		if flags.has_method("is_enabled"):
			var enabled = flags.is_enabled(flag)
			print("    ✅ Flag '%s': %s" % [flag, str(enabled)])


func _test_ai_registry(registry: Node) -> void:
	"""Test AIRegistry functionality"""
	print("  Testing functionality...")

	if registry.has_method("get_available_providers"):
		var providers = registry.get_available_providers()
		print("    ✅ Available providers: %s" % str(providers))

	if registry.has_method("get_active_provider_id"):
		var active = registry.get_active_provider_id()
		print("    ✅ Active provider: %s" % str(active))


func _print_summary() -> void:
	"""Print test summary"""
	print("\n=== SUMMARY ===")
	print("Total autoloads tested: %d" % AUTOLOADS.size())
	print("Total checks performed: %d" % total_tests)
	print("Checks passed: %d" % passed_tests)
	print("Success rate: %.1f%%" % (100.0 * passed_tests / total_tests if total_tests > 0 else 0))

	print("\n=== AUTOLOAD STATUS ===")
	for autoload_name in results:
		var result = results[autoload_name]
		var status_icon = (
			"✅" if result.status == "PASS" else "⚠️" if result.status == "PARTIAL" else "❌"
		)
		print("%s %s: %s" % [status_icon, autoload_name, result.status])
		if not result.error.is_empty():
			print("   Error: %s" % result.error)

	if passed_tests == total_tests:
		print("\n✅ All autoload services are functioning correctly!")
	else:
		print("\n⚠️  Some autoload services need attention.")
		print("Check the details above for specific issues.")
