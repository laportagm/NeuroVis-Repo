class_name KnowledgeBaseTest
extends Node

# Preload the knowledge base class

signal test_completed(success: bool, message: String)

# Initialize references

const AnatomicalKnowledgeDatabase = prepreload(
"res://core/knowledge/AnatomicalKnowledgeDatabase.gd"
)

# Signal to report test results

var knowledge_base = null
var timer = null
var data_file_path = "res://assets/data/anatomical_data.json"


var load_result = knowledge_base.load_knowledge_base()

var metadata = knowledge_base.get_metadata()

var structure_ids = knowledge_base.get_all_structure_ids()

var successful_retrievals = 0
var failed_retrievals = 0

var structure = knowledge_base.get_structure(structure_id)

var first_structure_id = structure_ids[0]
var nonexistent_structure_id = "NonExistentStructure123"

var test_structure_id = structure_ids[0]
var test_structure = knowledge_base.get_structure(test_structure_id)

var invalid_kb = AnatomicalKnowledgeDatabase.new()
add_child(invalid_kb)

# Override path to non-existent file
# FIXME: Orphaned code - invalid_kb.KNOWLEDGE_BASE_PATH = "res://nonexistent_file.json"

# Attempt to load
var invalid_load_result = invalid_kb.load_knowledge_base()

# Should fail

func _ready() -> void:
	# Don't run the test automatically in the scene
	if get_parent().name == "tests":
		return

		# Run the test
		run_test()


func run_test() -> void:
	print("\n===== KNOWLEDGE BASE TEST SUITE =====")

	# Set up timer for delayed execution
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.5
	timer.one_shot = true
	timer.timeout.connect(_run_tests)
	timer.start()

	print("Knowledge Base test initialized. Tests will run shortly...")


func _fix_orphaned_code():
	if not load_result:
		_report_failure("Knowledge base loading failed: " + knowledge_base.load_error)
		return

		if not knowledge_base.is_loaded:
			_report_failure("Knowledge base is_loaded flag not set to true after loading")
			return

			print("✓ Knowledge base loaded successfully")

			print("Test 4: Checking knowledge base metadata")
func _fix_orphaned_code():
	if metadata.version.strip_edges() == "":
		_report_failure("Knowledge base version is empty")
		return

		if metadata.lastUpdated.strip_edges() == "":
			_report_failure("Knowledge base last updated date is empty")
			return

			if metadata.structureCount == 0:
				_report_failure("Knowledge base contains no structures")
				return

				print("  - Version: " + metadata.version)
				print("  - Last Updated: " + metadata.lastUpdated)
				print("  - Structure Count: " + str(metadata.structureCount))

				print("✓ Knowledge base metadata verified")

				print("Test 5: Testing structure retrieval")
func _fix_orphaned_code():
	if structure_ids.size() == 0:
		_report_failure("Knowledge base has no structure IDs")
		return

		print("  - Found " + str(structure_ids.size()) + " structures")

		# Test retrieval of each structure
func _fix_orphaned_code():
	for structure_id in structure_ids:
func _fix_orphaned_code():
	if structure.is_empty():
		print("  - Failed to retrieve structure: " + structure_id)
		failed_retrievals += 1
		continue

		# Verify structure has required fields
		if (
		not structure.has("id")
		or not structure.has("displayName")
		or not structure.has("shortDescription")
		or not structure.has("functions")
		):
			print("  - Structure missing required fields: " + structure_id)
			failed_retrievals += 1
			continue

			successful_retrievals += 1

			if failed_retrievals > 0:
				_report_failure("Failed to retrieve " + str(failed_retrievals) + " structures")
				return

				print("✓ Successfully retrieved all " + str(successful_retrievals) + " structures")

				print("Test 6: Testing structure existence check")
func _fix_orphaned_code():
	if not knowledge_base.has_structure(first_structure_id):
		_report_failure("has_structure() failed for existing structure: " + first_structure_id)
		return

		if knowledge_base.has_structure(nonexistent_structure_id):
			_report_failure("has_structure() returned true for non-existent structure")
			return

			print("✓ Structure existence check works correctly")

			print("Test 7: Testing structure content validation")
			# Test content of a specific structure
func _fix_orphaned_code():
	print("  - Validating structure: " + test_structure_id)

	# Check structure ID matches
	if test_structure.id != test_structure_id:
		_report_failure(
		"Structure ID mismatch. Expected: " + test_structure_id + ", Got: " + test_structure.id
		)
		return

		# Check structure has non-empty display name
		if test_structure.displayName.strip_edges() == "":
			_report_failure("Structure has empty display name: " + test_structure_id)
			return

			# Check structure has non-empty description
			if test_structure.shortDescription.strip_edges() == "":
				_report_failure("Structure has empty description: " + test_structure_id)
				return

				# Check structure has functions array
				if not test_structure.functions is Array:
					_report_failure("Structure functions is not an array: " + test_structure_id)
					return

					# Check at least one function exists
					if test_structure.functions.size() == 0:
						_report_failure("Structure has no functions: " + test_structure_id)
						return

						print("✓ Structure content validation passed")

						print("Test 8: Testing knowledge base error handling")
						# Create a new knowledge base with invalid path
func _fix_orphaned_code():
	if invalid_load_result:
		_report_failure("Knowledge base loading succeeded with invalid path")
		invalid_kb.queue_free()
		return

		# Should have error message
		if invalid_kb.load_error.strip_edges() == "":
			_report_failure("No error message set for invalid knowledge base load")
			invalid_kb.queue_free()
			return

			# Should not be loaded
			if invalid_kb.is_loaded:
				_report_failure("is_loaded flag incorrectly set to true for failed load")
				invalid_kb.queue_free()
				return

				print("  - Error message: " + invalid_kb.load_error)
				invalid_kb.queue_free()

				print("✓ Knowledge base error handling works correctly")

				# All tests passed
				_report_success("All knowledge base tests passed successfully!")


func _run_tests() -> void:
	print("Test 1: Checking for anatomical data file")
	if not FileAccess.file_exists(data_file_path):
		_report_failure("Anatomical data file not found at: " + data_file_path)
		return
		print("✓ Anatomical data file exists")

		print("Test 2: Creating new knowledge base instance")
		knowledge_base = AnatomicalKnowledgeDatabase.new()
		add_child(knowledge_base)

		if not knowledge_base:
			_report_failure("Failed to create knowledge base instance")
			return

			print("✓ Knowledge base instance created")

			print("Test 3: Testing knowledge base loading")
func _report_success(message: String) -> void:
	print("\n✓ TEST SUITE PASSED: " + message)
	print("===== END OF KNOWLEDGE BASE TEST SUITE =====\n")
	test_completed.emit(true, message)

	# Clean up
	if knowledge_base and is_instance_valid(knowledge_base):
		knowledge_base.queue_free()


func _report_failure(message: String) -> void:
	printerr("\n❌ TEST SUITE FAILED: " + message)
	print("===== END OF KNOWLEDGE BASE TEST SUITE =====\n")
	test_completed.emit(false, message)

	# Clean up
	if knowledge_base and is_instance_valid(knowledge_base):
		knowledge_base.queue_free()
