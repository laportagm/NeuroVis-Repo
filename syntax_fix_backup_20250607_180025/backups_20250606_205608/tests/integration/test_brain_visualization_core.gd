# Test Suite for BrainVisualizationCore

extends TestFramework


# Test structure mapping functionality

			var core = BrainVisualizationCore.new()
			assert_not_null(core.structure_map)
			assert_greater_than(core.structure_map.size(), 0)
	)

	# Test 2: Test mesh name to structure ID mapping
	it(
		"should correctly map mesh names to structure IDs",
		func():
			var core = BrainVisualizationCore.new()

			# Test exact match
			var hippocampus_id = core.map_mesh_name_to_structure_id("Hippocampus")
			assert_equals(hippocampus_id, "hippocampus")

			# Test case insensitive
			var amygdala_id = core.map_mesh_name_to_structure_id("AMYGDALA")
			assert_equals(amygdala_id, "amygdala")

			# Test partial match
			var prefrontal_id = core.map_mesh_name_to_structure_id("Prefrontal")
			assert_contains(prefrontal_id, "prefrontal")

			# Test invalid structure
			var invalid_id = core.map_mesh_name_to_structure_id("InvalidStructure")
			assert_equals(invalid_id, "")
	)

	# Test 3: Signal emission validation
	it(
		"should emit neural_net_ready signal",
		func():
			var core = BrainVisualizationCore.new()
			var signal_received = false

			core.neural_net_ready.connect(func(): signal_received = true)
			core._ready()

			await wait_for_signal(core.neural_net_ready, 2.0)
			assert_true(signal_received)
	)


# Test knowledge base integration
			var kb = preload("res://core/knowledge_base/KnowledgeBase.gd").new()
			kb.load_knowledge_base("res://data/anatomical_data.json")

			assert_true(kb.is_loaded)
			assert_greater_than(kb.get_all_structure_ids().size(), 0)
	)

	it(
		"should retrieve structure data",
		func():
			var kb = preload("res://core/knowledge_base/KnowledgeBase.gd").new()
			kb.load_knowledge_base("res://data/anatomical_data.json")

			var hippocampus_data = kb.get_structure("hippocampus")
			assert_not_null(hippocampus_data)
			assert_has_property(hippocampus_data, "displayName")
			assert_has_property(hippocampus_data, "shortDescription")
			assert_has_property(hippocampus_data, "functions")
	)


# Test error handling
			var core = BrainVisualizationCore.new()
			var result = core.map_mesh_name_to_structure_id("")
			assert_equals(result, "")
	)

	it(
		"should handle invalid knowledge base path",
		func():
			var kb = preload("res://core/knowledge_base/KnowledgeBase.gd").new()
			kb.load_knowledge_base("res://invalid/path.json")
			assert_false(kb.is_loaded)
	)

func test_structure_mapping() -> void:
	describe("BrainVisualizationCore Structure Mapping")

	# Test 1: Verify structure_map initialization
	it(
		"should initialize structure_map with expected mappings",
		func():
func test_knowledge_base_integration() -> void:
	describe("Knowledge Base Integration")

	it(
		"should load anatomical data correctly",
		func():
func test_error_handling() -> void:
	describe("Error Handling")

	it(
		"should handle missing structure gracefully",
		func():
