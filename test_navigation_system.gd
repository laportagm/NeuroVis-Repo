## test_navigation_system.gd
## Test script for validating the navigation sidebar implementation
##
## This script tests the NavigationSidebar, NavigationSection, and NavigationItem
## components to ensure they work as expected.
##
## @version: 1.0

extends Node

# Tests to run

var tests = [
"test_sidebar_creation",
"test_section_creation",
"test_item_creation",
"test_section_expansion",
"test_item_selection",
"test_responsive_behavior",
"test_state_persistence"
]

# Reference to components under test
var navigation_sidebar: NavigationSidebar
var test_section: Node  # NavigationSection
var test_item: Node  # NavigationItem

# Test results
var passed_tests = 0
var failed_tests = 0
var test_results = {}


# FIXED: Orphaned code - var method = Callable(self, test_name)
# FIXED: Orphaned code - var result = method.call()
_process_test_result(test_name, result)
_cleanup_test()
push_warning("Test not found: " + test_name)

# Print summary
_print_summary()

# Auto-quit after tests (comment out for manual inspection)
get_tree().quit()


# FIXED: Orphaned code - var test_container = Control.new()
test_container.name = "TestContainer"
add_child(test_container)


# FIXED: Orphaned code - var test_container_2 = get_node_or_null("TestContainer")
# FIXED: Orphaned code - var result_text = "✅ PASS" if test_results[test_name] else "❌ FAIL"
var test_container_3 = get_node("TestContainer")

# Try loading from scene
var sidebar_scene = load("res://ui/components/navigation/NavigationSidebar.tscn")
# FIXED: Orphaned code - var sidebar_script = preload("res://ui/components/navigation/NavigationSidebar.gd")
# FIXED: Orphaned code - var section_id = "test_section"
var result_2 = navigation_sidebar.add_section(section_id, "TEST SECTION")

# Try to get section node via internal API (hacky but needed for testing)
# FIXED: Orphaned code - var sections_container = navigation_sidebar.get_node_or_null("MainContainer/SectionsContainer")
# FIXED: Orphaned code - var section_id_2 = "test_section"
var item_id = "test_item"
var result_3 = navigation_sidebar.add_item(section_id, item_id, "Test Item")

# Verify item was added (check if selection works)
navigation_sidebar.select_item(section_id, item_id)
# FIXED: Orphaned code - var selected_item = navigation_sidebar.get_selected_item()

# FIXED: Orphaned code - var section_id_3 = "test_section"
var initial_state = true  # Default expanded state

# Test collapse
navigation_sidebar.set_section_expanded(section_id, false)
# FIXED: Orphaned code - var collapsed_result = (
not test_section.is_expanded() if test_section.has_method("is_expanded") else false
)

# Test expand
navigation_sidebar.set_section_expanded(section_id, true)
# FIXED: Orphaned code - var expanded_result = (
test_section.is_expanded() if test_section.has_method("is_expanded") else false
)

# FIXED: Orphaned code - var signal_emitted = false
var signal_data = []

# Connect to signal
var selected_item_2 = navigation_sidebar.get_selected_item()
# FIXED: Orphaned code - var selection_match = (
selected_item.section == "test_section" and selected_item.item == "test_item"
)

# FIXED: Orphaned code - var initial_width = navigation_sidebar.custom_minimum_size.x

# Test tablet mode
navigation_sidebar.set_expanded(false)
# FIXED: Orphaned code - var collapsed_width = navigation_sidebar.custom_minimum_size.x

# Test expansion
navigation_sidebar.set_expanded(true)
# FIXED: Orphaned code - var expanded_width = navigation_sidebar.custom_minimum_size.x

var test_container_4 = get_node("TestContainer")
# FIXED: Orphaned code - var sidebar_script_2 = preload("res://ui/components/navigation/NavigationSidebar.gd")
navigation_sidebar = sidebar_script.new()
test_container.add_child(navigation_sidebar)
navigation_sidebar.use_state_persistence = true

# Add section for restoration
navigation_sidebar.add_section("persist_test", "PERSISTENCE TEST")
navigation_sidebar.add_item("persist_test", "persist_item", "Persistence Item")

# Restore state
navigation_sidebar.restore_state()

# Check if state was restored
var selected_item_3 = navigation_sidebar.get_selected_item()
# FIXED: Orphaned code - var selection_ok = (
selected_item.section == "persist_test" and selected_item.item == "persist_item"
)

# This is difficult to test automatically as we can't access internal expanded state reliably
# Just check if the selection was restored correctly

func _ready() -> void:
	print("\n=== NAVIGATION SYSTEM TEST SUITE ===")

	# Run all tests
	for test_name in tests:
		if has_method(test_name):
			_setup_test()
func _process_test_result(test_name: String, result: bool) -> void:
	"""Process test result"""
	test_results[test_name] = result
	if result:
		passed_tests += 1
		print("✅ PASS: " + test_name)
		else:
			failed_tests += 1
			print("❌ FAIL: " + test_name)


func test_sidebar_creation() -> bool:
	"""Test NavigationSidebar creation"""
func test_section_creation() -> bool:
	"""Test NavigationSection creation and addition to sidebar"""
	# Require successful sidebar creation
	if not navigation_sidebar:
		if not test_sidebar_creation():
			return false

			# Add a test section
func test_item_creation() -> bool:
	"""Test NavigationItem creation and addition to section"""
	# Require successful section creation
	if not test_section:
		if not test_section_creation():
			return false

			# Add a test item
func test_section_expansion() -> bool:
	"""Test section expansion and collapse"""
	# Require successful section creation
	if not test_section:
		if not test_section_creation():
			return false

			# Toggle section via sidebar API
func test_item_selection() -> bool:
	"""Test item selection"""
	# Require successful item creation
	if not test_item_creation():
		return false

		# Track signal emission
func test_responsive_behavior() -> bool:
	"""Test responsive behavior"""
	# Require successful sidebar creation
	if not navigation_sidebar:
		if not test_sidebar_creation():
			return false

			# Initial width (desktop mode)
func test_state_persistence() -> bool:
	"""Test state persistence"""
	# Require successful sidebar creation
	if not navigation_sidebar:
		if not test_sidebar_creation():
			return false

			# Enable state persistence
			navigation_sidebar.use_state_persistence = true

			# Set up test state
			navigation_sidebar.add_section("persist_test", "PERSISTENCE TEST")
			navigation_sidebar.add_item("persist_test", "persist_item", "Persistence Item")
			navigation_sidebar.select_item("persist_test", "persist_item")
			navigation_sidebar.set_section_expanded("persist_test", false)

			# Save state
			navigation_sidebar.save_state()

			# Create new sidebar to test restoration
			navigation_sidebar.queue_free()
			await get_tree().process_frame

if test_container:
	test_container.queue_free()

	# Clear references
	navigation_sidebar = null
	test_section = null
	test_item = null

	# Wait for node deletion
	await get_tree().process_frame


print("%s: %s" % [test_name, result_text])

print("\n=== END OF TEST SUITE ===")


# === TEST METHODS ===
if sidebar_scene:
	navigation_sidebar = sidebar_scene.instantiate()
	test_container.add_child(navigation_sidebar)
	return navigation_sidebar != null

	# Fallback to script instantiation
if sidebar_script:
	navigation_sidebar = sidebar_script.new()
	test_container.add_child(navigation_sidebar)
	return navigation_sidebar != null

	return false


if sections_container:
	for child in sections_container.get_children():
		if child.name.contains(section_id):
			test_section = child
			break

			return result and test_section != null


return result and selected_item.section == section_id and selected_item.item == item_id


return collapsed_result and expanded_result


if navigation_sidebar.has_signal("item_selected"):
	navigation_sidebar.item_selected.connect(
	func(section_id, item_id):
		signal_emitted = true
		signal_data = [section_id, item_id]
		)

		# Select item
		navigation_sidebar.select_item("test_section", "test_item")

		# Check result
return (
selection_match
and signal_emitted
and signal_data[0] == "test_section"
and signal_data[1] == "test_item"
)


return collapsed_width < expanded_width


return selection_ok

func _setup_test() -> void:
	"""Setup test environment"""
	# Create test container
func _cleanup_test() -> void:
	"""Clean up after test"""
func _print_summary() -> void:
	"""Print test summary"""
	print("\n=== TEST SUMMARY ===")
	print(
	(
	"Passed: %d/%d (%.1f%%)"
	% [passed_tests, tests.size(), (float(passed_tests) / tests.size()) * 100]
	)
	)
	print(
	(
	"Failed: %d/%d (%.1f%%)"
	% [failed_tests, tests.size(), (float(failed_tests) / tests.size()) * 100]
	)
	)
	print("\nDetailed Results:")

	for test_name in test_results:
