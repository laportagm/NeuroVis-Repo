# Integration Test for Component Foundation Layer
# Tests FeatureFlags, ComponentRegistry, and ComponentStateManager integration
extends RefCounted

# === DEPENDENCIES ===
const FeatureFlags = preload("res://core/features/FeatureFlags.gd")
const ComponentRegistry = preload("res://ui/core/ComponentRegistry.gd")
const ComponentStateManager = preload("res://ui/state/ComponentStateManager.gd")

# === TEST RESULTS ===
var test_results: Array = []
var total_tests: int = 0
var passed_tests: int = 0

# === MAIN TEST RUNNER ===
func run_all_tests() -> Dictionary:
	"""Run all foundation layer tests"""
	print("\n🧪 RUNNING COMPONENT FOUNDATION TESTS")
	print("=====================================")
	
	_reset_test_state()
	
	# Feature Flag Tests
	test_feature_flags_basic()
	test_feature_flags_persistence()
	test_feature_flags_listeners()
	
	# Component Registry Tests
	test_component_registry_creation()
	test_component_registry_caching()
	test_component_registry_factories()
	
	# State Manager Tests
	test_state_manager_basic()
	test_state_manager_persistence()
	test_state_manager_cleanup()
	
	# Integration Tests
	test_full_integration_workflow()
	test_migration_compatibility()
	
	_print_test_summary()
	
	return {
		"total_tests": total_tests,
		"passed_tests": passed_tests,
		"failed_tests": total_tests - passed_tests,
		"success_rate": float(passed_tests) / float(total_tests) * 100.0 if total_tests > 0 else 0.0,
		"details": test_results
	}

# === FEATURE FLAGS TESTS ===
func test_feature_flags_basic() -> void:
	"""Test basic feature flag functionality"""
	_start_test("FeatureFlags Basic Operations")
	
	# Test default flags
	assert_true(FeatureFlags.is_enabled(FeatureFlags.ADVANCED_ANIMATIONS), "Advanced animations should be enabled by default")
	assert_false(FeatureFlags.is_enabled(FeatureFlags.UI_MODULAR_COMPONENTS), "Modular components should be disabled by default in production")
	
	# Test flag toggling
	var original_state = FeatureFlags.is_enabled(FeatureFlags.UI_COMPONENT_POOLING)
	FeatureFlags.toggle_feature(FeatureFlags.UI_COMPONENT_POOLING)
	assert_not_equal(FeatureFlags.is_enabled(FeatureFlags.UI_COMPONENT_POOLING), original_state, "Flag should toggle")
	FeatureFlags.toggle_feature(FeatureFlags.UI_COMPONENT_POOLING)  # Reset
	
	# Test enable/disable
	FeatureFlags.enable_feature(FeatureFlags.UI_STATE_PERSISTENCE)
	assert_true(FeatureFlags.is_enabled(FeatureFlags.UI_STATE_PERSISTENCE), "Should enable feature")
	FeatureFlags.disable_feature(FeatureFlags.UI_STATE_PERSISTENCE)
	assert_false(FeatureFlags.is_enabled(FeatureFlags.UI_STATE_PERSISTENCE), "Should disable feature")
	
	_end_test()

func test_feature_flags_persistence() -> void:
	"""Test feature flag persistence"""
	_start_test("FeatureFlags Persistence")
	
	# Enable a feature with persistence
	FeatureFlags.enable_feature(FeatureFlags.GESTURE_SUPPORT, true)
	assert_true(FeatureFlags.is_enabled(FeatureFlags.GESTURE_SUPPORT), "Feature should be enabled")
	
	# Test getting all flags
	var all_flags = FeatureFlags.get_all_flags()
	assert_true(typeof(all_flags) == TYPE_DICTIONARY, "Should return dictionary")
	assert_true(all_flags.size() > 0, "Should have flags")
	
	# Test flag status
	var status = FeatureFlags.get_flag_status(FeatureFlags.GESTURE_SUPPORT)
	assert_true(status.has("enabled"), "Status should include enabled state")
	assert_true(status.has("description"), "Status should include description")
	
	_end_test()

func test_feature_flags_listeners() -> void:
	"""Test feature flag listener system"""
	_start_test("FeatureFlags Listeners")
	
	# Use array/dictionary for reference semantics in lambda
	var listener_state = {
		"called": false,
		"flag": "",
		"old_value": false,
		"new_value": false
	}
	
	# Add listener
	var callback = func(flag_name: String, old_val: bool, new_val: bool):
		listener_state.called = true
		listener_state.flag = flag_name
		listener_state.old_value = old_val
		listener_state.new_value = new_val
	
	FeatureFlags.add_listener(FeatureFlags.LAZY_LOADING, callback)
	
	# Change flag to trigger listener
	FeatureFlags.enable_feature(FeatureFlags.LAZY_LOADING)
	
	assert_true(listener_state.called, "Listener should be called")
	assert_equal(listener_state.flag, FeatureFlags.LAZY_LOADING, "Should receive correct flag name")
	assert_true(listener_state.new_value, "Should receive new value")
	
	# Clean up
	FeatureFlags.remove_listener(FeatureFlags.LAZY_LOADING, callback)
	
	_end_test()

# === COMPONENT REGISTRY TESTS ===
func test_component_registry_creation() -> void:
	"""Test component creation through registry"""
	_start_test("ComponentRegistry Creation")
	
	# Test basic component creation
	var button = ComponentRegistry.create_component("button", {"text": "Test Button"})
	assert_not_null(button, "Should create button component")
	assert_true(button is Button, "Should be Button instance")
	assert_equal(button.text, "Test Button", "Should apply configuration")
	
	# Test fallback component creation
	var unknown = ComponentRegistry.create_component("unknown_type", {})
	assert_not_null(unknown, "Should create fallback component")
	assert_true(unknown.name.begins_with("Fallback_"), "Should be fallback component")
	
	# Test panel creation
	var panel = ComponentRegistry.create_component("info_panel", {})
	assert_not_null(panel, "Should create info panel")
	
	_end_test()

func test_component_registry_caching() -> void:
	"""Test component caching functionality"""
	_start_test("ComponentRegistry Caching")
	
	# Enable component pooling for this test
	FeatureFlags.enable_feature(FeatureFlags.UI_COMPONENT_POOLING)
	
	var component_id = "test_panel_123"
	var config = {"title": "Test Panel"}
	
	# Create component
	var panel1 = ComponentRegistry.get_or_create(component_id, "info_panel", config)
	assert_not_null(panel1, "Should create component")
	
	# Get same component (should be cached)
	var panel2 = ComponentRegistry.get_or_create(component_id, "info_panel", config)
	assert_equal(panel1, panel2, "Should return cached component")
	
	# Test registry stats
	var stats = ComponentRegistry.get_registry_stats()
	assert_true(stats.cache_hits > 0, "Should have cache hits")
	assert_true(stats.total_created > 0, "Should have created components")
	
	# Clean up
	ComponentRegistry.release_component(component_id)
	
	_end_test()

func test_component_registry_factories() -> void:
	"""Test component factory registration"""
	_start_test("ComponentRegistry Factories")
	
	# Register custom factory
	var custom_factory = func(config: Dictionary) -> Control:
		var label = Label.new()
		label.text = config.get("custom_text", "Custom Component")
		label.name = "CustomComponent"
		return label
	
	ComponentRegistry.register_factory("custom_test", custom_factory)
	
	# Create component using custom factory
	var custom = ComponentRegistry.create_component("custom_test", {"custom_text": "Hello World"})
	assert_not_null(custom, "Should create custom component")
	assert_true(custom is Label, "Should be Label instance")
	assert_equal(custom.text, "Hello World", "Should apply custom configuration")
	
	_end_test()

# === STATE MANAGER TESTS ===
func test_state_manager_basic() -> void:
	"""Test basic state management functionality"""
	_start_test("ComponentStateManager Basic")
	
	# Enable state persistence for this test
	FeatureFlags.enable_feature(FeatureFlags.UI_STATE_PERSISTENCE)
	
	var component_id = "test_component_state"
	var test_state = {
		"scroll_position": 150,
		"expanded_sections": ["functions", "clinical"],
		"user_notes": "Test note"
	}
	
	# Save state
	ComponentStateManager.save_component_state(component_id, test_state)
	assert_true(ComponentStateManager.has_component_state(component_id), "Should have saved state")
	
	# Restore state
	var restored_state = ComponentStateManager.restore_component_state(component_id)
	assert_not_null(restored_state, "Should restore state")
	assert_equal(restored_state.scroll_position, 150, "Should restore scroll position")
	assert_equal(restored_state.expanded_sections.size(), 2, "Should restore expanded sections")
	
	# Test state age
	var age = ComponentStateManager.get_state_age(component_id)
	assert_true(age >= 0, "Should have valid age")
	
	_end_test()

func test_state_manager_persistence() -> void:
	"""Test state persistence to disk"""
	_start_test("ComponentStateManager Persistence")
	
	FeatureFlags.enable_feature(FeatureFlags.UI_STATE_PERSISTENCE)
	
	var component_id = "persistent_test_component"
	var persistent_state = {
		"theme_preference": "minimal",
		"bookmarked_structures": ["hippocampus", "cortex"]
	}
	
	# Save persistent state
	ComponentStateManager.save_component_state(component_id, persistent_state, true)
	
	# Get persistent states
	var persistent_states = ComponentStateManager.get_persistent_states()
	assert_true(persistent_states.has(component_id), "Should have persistent state")
	
	# Test state info
	var state_info = ComponentStateManager.get_component_state_info(component_id)
	assert_true(state_info.exists, "State should exist")
	assert_true(state_info.persistent, "Should be marked as persistent")
	
	_end_test()

func test_state_manager_cleanup() -> void:
	"""Test state cleanup functionality"""
	_start_test("ComponentStateManager Cleanup")
	
	FeatureFlags.enable_feature(FeatureFlags.UI_STATE_PERSISTENCE)
	
	# Create some test states
	for i in range(5):
		var component_id = "cleanup_test_" + str(i)
		var state = {"test_data": i}
		ComponentStateManager.save_component_state(component_id, state)
	
	# Get stats before cleanup
	var stats_before = ComponentStateManager.get_state_stats()
	assert_true(stats_before.total_states >= 5, "Should have test states")
	
	# Clear session states
	ComponentStateManager.clear_session_states()
	
	# Verify cleanup
	assert_false(ComponentStateManager.has_component_state("cleanup_test_0"), "Session state should be cleared")
	
	_end_test()

# === INTEGRATION TESTS ===
func test_full_integration_workflow() -> void:
	"""Test complete workflow using all foundation systems"""
	_start_test("Full Integration Workflow")
	
	# Enable new systems
	FeatureFlags.enable_feature(FeatureFlags.UI_MODULAR_COMPONENTS)
	FeatureFlags.enable_feature(FeatureFlags.UI_COMPONENT_POOLING)
	FeatureFlags.enable_feature(FeatureFlags.UI_STATE_PERSISTENCE)
	
	# Create component with state
	var component_id = "integration_test_panel"
	var config = {
		"structure_name": "hippocampus",
		"theme": "enhanced"
	}
	
	# Step 1: Create component through registry
	var panel = ComponentRegistry.get_or_create(component_id, "info_panel", config)
	assert_not_null(panel, "Should create panel")
	
	# Step 2: Save component state
	var state = {
		"selected_structure": "hippocampus",
		"expanded_sections": ["functions"],
		"scroll_position": 100
	}
	ComponentStateManager.save_component_state(component_id, state)
	
	# Step 3: Simulate component recreation (cache hit)
	var panel2 = ComponentRegistry.get_or_create(component_id, "info_panel", config)
	assert_equal(panel, panel2, "Should return cached component")
	
	# Step 4: Restore state
	var restored_state = ComponentStateManager.restore_component_state(component_id)
	assert_equal(restored_state.selected_structure, "hippocampus", "Should restore structure")
	assert_equal(restored_state.scroll_position, 100, "Should restore scroll position")
	
	# Step 5: Clean up
	ComponentRegistry.release_component(component_id)
	ComponentStateManager.remove_component_state(component_id)
	
	_end_test()

func test_migration_compatibility() -> void:
	"""Test compatibility with existing systems"""
	_start_test("Migration Compatibility")
	
	# Test legacy mode
	ComponentRegistry.set_legacy_mode(true)
	assert_true(FeatureFlags.is_enabled(FeatureFlags.UI_LEGACY_PANELS), "Should enable legacy panels")
	assert_false(FeatureFlags.is_enabled(FeatureFlags.UI_MODULAR_COMPONENTS), "Should disable modular components")
	
	# Test new mode
	ComponentRegistry.set_legacy_mode(false)
	assert_false(FeatureFlags.is_enabled(FeatureFlags.UI_LEGACY_PANELS), "Should disable legacy panels")
	assert_true(FeatureFlags.is_enabled(FeatureFlags.UI_MODULAR_COMPONENTS), "Should enable modular components")
	
	# Test migration helpers
	FeatureFlags.begin_migration(FeatureFlags.UI_LEGACY_PANELS, FeatureFlags.UI_MODULAR_COMPONENTS, true)
	assert_true(FeatureFlags.is_enabled(FeatureFlags.UI_MODULAR_COMPONENTS), "Should enable new system")
	assert_true(FeatureFlags.is_enabled(FeatureFlags.UI_LEGACY_PANELS), "Should keep old system as fallback")
	
	_end_test()

# === TEST UTILITIES ===
func _reset_test_state() -> void:
	"""Reset test state"""
	test_results.clear()
	total_tests = 0
	passed_tests = 0
	
	# Reset systems to known state
	FeatureFlags.reset_to_defaults()
	ComponentRegistry.reset_registry()
	ComponentStateManager.clear_session_states()

func _start_test(test_name: String) -> void:
	"""Start a new test"""
	total_tests += 1
	print("  🔍 " + test_name)

func _end_test(passed: bool = true) -> void:
	"""End current test"""
	if passed:
		passed_tests += 1
		print("    ✅ PASSED")
	else:
		print("    ❌ FAILED")

func assert_true(condition: bool, message: String = "") -> void:
	"""Assert that condition is true"""
	if not condition:
		var error_msg = "Assertion failed: " + message
		test_results.append({"type": "assertion_error", "message": error_msg})
		print("    ❌ " + error_msg)
		_end_test(false)

func assert_false(condition: bool, message: String = "") -> void:
	"""Assert that condition is false"""
	assert_true(not condition, message)

func assert_equal(actual, expected, message: String = "") -> void:
	"""Assert that values are equal"""
	if actual != expected:
		var error_msg = "Expected: %s, Got: %s - %s" % [expected, actual, message]
		test_results.append({"type": "assertion_error", "message": error_msg})
		print("    ❌ " + error_msg)
		_end_test(false)

func assert_not_equal(actual, expected, message: String = "") -> void:
	"""Assert that values are not equal"""
	if actual == expected:
		var error_msg = "Values should not be equal: %s - %s" % [actual, message]
		test_results.append({"type": "assertion_error", "message": error_msg})
		print("    ❌ " + error_msg)
		_end_test(false)

func assert_not_null(value, message: String = "") -> void:
	"""Assert that value is not null"""
	if value == null:
		var error_msg = "Value should not be null - " + message
		test_results.append({"type": "assertion_error", "message": error_msg})
		print("    ❌ " + error_msg)
		_end_test(false)

func _print_test_summary() -> void:
	"""Print test summary"""
	print("\n📊 TEST SUMMARY")
	print("================")
	print("Total Tests: %d" % total_tests)
	print("Passed: %d" % passed_tests)
	print("Failed: %d" % (total_tests - passed_tests))
	print("Success Rate: %.1f%%" % (float(passed_tests) / float(total_tests) * 100.0 if total_tests > 0 else 0.0))
	
	if passed_tests == total_tests:
		print("🎉 ALL TESTS PASSED - Foundation layer is ready!")
	else:
		print("⚠️  Some tests failed - Review implementation before proceeding")
	
	print("================\n")

# === STANDALONE RUNNER ===
static func run_foundation_tests() -> Dictionary:
	"""Static method to run tests from outside"""
	var tester = new()
	return tester.run_all_tests()