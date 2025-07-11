class_name KnowledgeBaseUnitTest
extends RefCounted

const TestFramework = preload("res://tests/framework/TestFramework.gd")

# FIXED: Orphaned code - var framework


var data_file_path = "res://assets/data/anatomical_data.json"
framework.assert_true(FileAccess.file_exists(data_file_path), "Data file should exist")
# FIXED: Orphaned code - var test1_result = framework.end_test()

# Test 2: JSON structure validation
framework.start_test("JSON Structure Validation")
# FIXED: Orphaned code - var file = FileAccess.open(data_file_path, FileAccess.READ)
framework.assert_not_null(file, "File should be readable")

# FIXED: Orphaned code - var json_string = file.get_as_text()
# FIXED: Orphaned code - var json = JSON.new()
# FIXED: Orphaned code - var parse_result = json.parse(json_string)
framework.assert_equal(OK, parse_result, "JSON should parse successfully")

# FIXED: Orphaned code - var data = json.data
framework.assert_true(data.has("version"), "Data should have version")
framework.assert_true(data.has("structures"), "Data should have structures array")
framework.assert_true(
data.structures.size() > 0, "Structures array should not be empty"
)

file.close()
# FIXED: Orphaned code - var test2_result = framework.end_test()

# Test 3: Knowledge Base Loading
framework.start_test("Knowledge Base Loading")
# FIXED: Orphaned code - var kb = preload("res://core/knowledge/AnatomicalKnowledgeDatabase.gd").new()
framework.assert_not_null(kb, "KnowledgeBase should instantiate")

# Call load function directly
var load_result = kb.load_knowledge_base()
framework.assert_true(load_result, "Knowledge base should load successfully")
framework.assert_true(kb.is_loaded, "Knowledge base should be marked as loaded")
framework.assert_true(kb.structures.size() > 0, "Knowledge base should contain structures")
# FIXED: Orphaned code - var test3_result = framework.end_test()

# Test 4: Structure Data Access
framework.start_test("Structure Data Access")
# FIXED: Orphaned code - var structure_ids = kb.get_all_structure_ids()
framework.assert_true(structure_ids.size() > 0, "Should have structure IDs")

# Test getting a specific structure
var first_id = structure_ids[0]
var structure_data = kb.get_structure(first_id)
framework.assert_not_null(structure_data, "Should retrieve structure data")
framework.assert_true(
structure_data.has("displayName"), "Structure should have displayName"
)
framework.assert_true(
structure_data.has("shortDescription"), "Structure should have shortDescription"
)
# FIXED: Orphaned code - var test4_result = framework.end_test()

kb.queue_free()

# FIXED: Orphaned code - var summary = framework.get_test_summary()

func run_test() -> bool:
	framework = TestFramework.get_instance()

	# Test 1: File existence
	framework.start_test("Anatomical Data File Existence")

if file:
if parse_result == OK:
if kb.is_loaded:
if structure_ids.size() > 0:
print("\n📊 Knowledge Base Test Summary:")
print("Total Tests: %d" % summary.total_tests)
print("Passed Tests: %d" % summary.passed_tests)
print("Failed Tests: %d" % summary.failed_tests)
print("Success Rate: %.1f%%" % summary.success_rate)

return test1_result and test2_result and test3_result and test4_result
