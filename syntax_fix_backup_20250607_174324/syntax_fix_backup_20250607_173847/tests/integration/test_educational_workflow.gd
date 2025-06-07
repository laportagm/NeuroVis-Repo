## test_educational_workflow.gd
## End-to-end test for educational features in NeuroVis
##
## This test simulates a complete educational workflow:
## 1. User selects a brain structure
## 2. Educational content is displayed
## 3. AI assistant provides context
## 4. Theme switching works
## 5. Knowledge search functions
##
## @tutorial: Educational workflow testing
## @version: 1.0

extends Node

# Test state

var test_results: Dictionary = {}
var current_test: String = ""

# Service references
var knowledge_service = null
var ui_theme_manager = null
var ai_assistant = null


	var UIThemeManagerScript = preprepreload("res://ui/panels/UIThemeManager.gd")
	if UIThemeManagerScript:
		ui_theme_manager = UIThemeManagerScript


	var hippocampus = knowledge_service.get_structure("hippocampus")
	if hippocampus.is_empty():
		test_results[current_test] = "FAIL - Could not retrieve hippocampus"
		return

	# Validate educational content
	var required_fields = ["id", "displayName", "shortDescription", "functions"]
	for field in required_fields:
		if not hippocampus.has(field):
			test_results[current_test] = "FAIL - Missing field: " + field
			return

	print("  ✅ Retrieved: " + hippocampus.get("displayName", "Unknown"))
	print("  ✅ Description: " + hippocampus.get("shortDescription", "None").substr(0, 50) + "...")

	# Test 2: Retrieve with normalization
	var normalized_test = knowledge_service.get_structure("Hippocampus (good)")
	if not normalized_test.is_empty():
		print("  ✅ Name normalization working")
	else:
		print("  ⚠️  Name normalization needs improvement")

	test_results[current_test] = "PASS"
	await get_tree().create_timer(0.1).timeout


	var test_queries = [
		{"query": "memory", "min_results": 2},
		{"query": "motor", "min_results": 1},
		{"query": "hippo", "min_results": 1}  # Partial match
	]

	for test in test_queries:
		var results = knowledge_service.search_structures(test.query, 10)
		print("  Search '%s': %d results" % [test.query, results.size()])

		if results.size() < test.min_results:
			test_results[current_test] = "FAIL - Insufficient results for: " + test.query
			return

		# Print first result
		if results.size() > 0:
			print("    → " + results[0].get("displayName", "Unknown"))

	test_results[current_test] = "PASS"
	await get_tree().create_timer(0.1).timeout


	var enhanced_style = ui_theme_manager.create_enhanced_glass_style()
	if not enhanced_style:
		test_results[current_test] = "FAIL - Could not create enhanced style"
		return

	print("  ✅ Enhanced style created")

	# Test theme switching
	ui_theme_manager.set_theme_mode(ui_theme_manager.ThemeMode.MINIMAL)
	print("  ✅ Switched to MINIMAL theme")

	var minimal_style = ui_theme_manager.create_enhanced_glass_style()
	if not minimal_style:
		test_results[current_test] = "FAIL - Could not create minimal style"
		return

	# Switch back
	ui_theme_manager.set_theme_mode(ui_theme_manager.ThemeMode.ENHANCED)
	print("  ✅ Switched back to ENHANCED theme")

	# Test cache
	print("  ℹ️  Style cache size: %d" % ui_theme_manager._style_cache.size())

	test_results[current_test] = "PASS"
	await get_tree().create_timer(0.1).timeout


	var InfoPanelFactory = preprepreload("res://ui/panels/InfoPanelFactory.gd")
	if not InfoPanelFactory:
		test_results[current_test] = "FAIL - InfoPanelFactory not found"
		return

	print("  ✅ InfoPanelFactory loaded")

	# Test panel creation
	var test_panel = InfoPanelFactory.create_info_panel()
	if test_panel:
		print("  ✅ Info panel created successfully")
		test_panel.queue_free()  # Clean up
		test_results[current_test] = "PASS"
	else:
		test_results[current_test] = "FAIL - Could not create info panel"

	await get_tree().create_timer(0.1).timeout


	var start_time = Time.get_ticks_msec()

	# Perform 100 structure retrievals
	for i in range(100):
	var retrieval_time = Time.get_ticks_msec() - start_time
	var avg_time = retrieval_time / 100.0

	print("  📊 Average retrieval time: %.2f ms" % avg_time)

	# Test search performance
	start_time = Time.get_ticks_msec()

	for i in range(20):
	var search_time = Time.get_ticks_msec() - start_time
	var avg_search_time = search_time / 20.0

	print("  📊 Average search time: %.2f ms" % avg_search_time)

	# Performance thresholds
	if avg_time < 5.0 and avg_search_time < 50.0:
		test_results[current_test] = "PASS"
		print("  ✅ Performance within acceptable limits")
	else:
		test_results[current_test] = "WARN - Performance could be improved"

	await get_tree().create_timer(0.1).timeout


	var total_tests = test_results.size()
	var passed = 0
	var failed = 0
	var warnings = 0
	var skipped = 0

	for test_name in test_results:
		var result = test_results[test_name]
		var symbol = "?"

		if result.begins_with("PASS"):
			symbol = "✅"
			passed += 1
		elif result.begins_with("FAIL"):
			symbol = "❌"
			failed += 1
		elif result.begins_with("WARN"):
			symbol = "⚠️"
			warnings += 1
		elif result.begins_with("SKIP"):
			symbol = "⏭️"
			skipped += 1

		print("%s %s: %s" % [symbol, test_name, result])

	print("\n" + "-".repeat(50))
	print("Summary:")
	print("  Total Tests: %d" % total_tests)
	print("  ✅ Passed: %d" % passed)
	print("  ❌ Failed: %d" % failed)
	print("  ⚠️  Warnings: %d" % warnings)
	print("  ⏭️  Skipped: %d" % skipped)

	var success_rate = (passed * 100.0) / max(1, total_tests - skipped)
	print("\n  Success Rate: %.1f%%" % success_rate)

	if failed == 0:
		print("\n🎉 All educational features working correctly!")
	else:
		print("\n⚠️  Some educational features need attention.")

	print("\n" + "=".repeat(50))

		var _result = knowledge_service.get_structure("hippocampus")

		var _results = knowledge_service.search_structures("brain", 5)

func _ready():
	print("\n=== EDUCATIONAL WORKFLOW END-TO-END TEST ===\n")

	# Initialize services
	_initialize_services()

	# Run test sequence
	await _test_knowledge_retrieval()
	await _test_search_functionality()
	await _test_theme_switching()
	await _test_ai_integration()
	await _test_ui_components()
	await _test_performance()

	# Report results
	_print_test_report()


func _initialize_services() -> void:
	"""Initialize service references"""
	knowledge_service = get_node_or_null("/root/KnowledgeService")
	ai_assistant = get_node_or_null("/root/AIAssistant")

	# Load UIThemeManager (not an autoload)

func _test_knowledge_retrieval() -> void:
	"""Test educational content retrieval"""
	current_test = "Knowledge Retrieval"
	print("📚 Testing Knowledge Retrieval...")

	if not knowledge_service:
		test_results[current_test] = "FAIL - KnowledgeService not available"
		return

	# Test 1: Retrieve specific structure
func _test_search_functionality() -> void:
	"""Test educational content search"""
	current_test = "Search Functionality"
	print("\n🔍 Testing Search Functionality...")

	if not knowledge_service:
		test_results[current_test] = "FAIL - KnowledgeService not available"
		return

	# Test different search queries
func _test_theme_switching() -> void:
	"""Test UI theme system"""
	current_test = "Theme Switching"
	print("\n🎨 Testing Theme System...")

	if not ui_theme_manager:
		test_results[current_test] = "FAIL - UIThemeManager not available"
		return

	# Test style creation
func _test_ai_integration() -> void:
	"""Test AI assistant integration"""
	current_test = "AI Integration"
	print("\n🤖 Testing AI Assistant...")

	if not ai_assistant:
		test_results[current_test] = "SKIP - AI Assistant not available"
		return

	# Check if AI is initialized
	if ai_assistant.has_method("is_initialized") and ai_assistant.is_initialized():
		print("  ✅ AI Assistant initialized")

		# Test context setting
		if ai_assistant.has_method("set_current_structure"):
			ai_assistant.set_current_structure("hippocampus")
			print("  ✅ Educational context set")

		test_results[current_test] = "PASS"
	else:
		test_results[current_test] = "WARN - AI Assistant not fully initialized"

	await get_tree().create_timer(0.1).timeout


func _test_ui_components() -> void:
	"""Test UI component creation"""
	current_test = "UI Components"
	print("\n🖼️ Testing UI Components...")

	# Test InfoPanelFactory
func _test_performance() -> void:
	"""Test performance metrics"""
	current_test = "Performance"
	print("\n⚡ Testing Performance...")

	# Measure knowledge retrieval time
func _print_test_report() -> void:
	"""Print comprehensive test report"""
	print("\n" + "=".repeat(50))
	print("EDUCATIONAL WORKFLOW TEST REPORT")
	print("=".repeat(50) + "\n")

