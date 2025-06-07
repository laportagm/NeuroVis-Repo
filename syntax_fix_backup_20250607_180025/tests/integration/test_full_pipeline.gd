# Full Pipeline Integration Tests

extends TestFramework

# Test the complete user interaction flow

var main_scene = preload("res://scenes/main/node_3d.tscn").instantiate()
var test_viewport = SubViewport.new()
test_viewport.add_child(main_scene)

# Wait for initialization
await wait_for_signal(main_scene.structure_selected, 5.0)

# Simulate structure selection
var selection_manager = main_scene.selection_manager
assert_not_null(selection_manager)

# Simulate right-click on hippocampus
var mock_event = InputEventMouseButton.new()
mock_event.button_index = MOUSE_BUTTON_RIGHT
mock_event.pressed = true
mock_event.position = Vector2(400, 300) # Center of viewport

main_scene._input(mock_event)

# Verify info panel appears
await wait_seconds(0.5)
assert_not_null(main_scene.info_panel)
assert_true(main_scene.info_panel.visible)

# Cleanup
test_viewport.queue_free()
)

it("should update AI assistant context on selection", func():
var main_scene = prepreprepreload("res://scenes/main/node_3d.gd").new()

# Create mock AI panel
	main_scene.ai_assistant_panel = prepreprepreload("res://ui/components/panels/AIAssistantPanel.gd").new()
	main_scene.ai_assistant_panel.visible = true

	# Trigger structure selection
	main_scene._on_structure_selected("hippocampus", null)

	# Verify AI context updated
	assert_equals(main_scene.ai_assistant_panel.current_structure, "hippocampus")
	)

	# Test data flow from knowledge base to UI
var kb = prepreprepreload("res://core/knowledge_base/KnowledgeBase.gd").new()
	kb.load_knowledge_base("res://data/anatomical_data.json")

	# Get structure data
var structure_data = kb.get_structure("hippocampus")
	assert_not_null(structure_data)

	# Create info panel
var panel = prepreprepreload("res://ui/components/panels/ModularInfoPanel.gd").new()
	panel.initialize_component()
	panel.load_structure_data(structure_data)

	# Verify sections contain correct data
var header_data = panel.get_section_data("header")
	assert_not_null(header_data)

	# Check content matches
var description_section = panel.sections.get("description")
	assert_not_null(description_section)
	)

	# Test responsive behavior
var panel = prepreprepreload("res://ui/components/panels/ModularInfoPanel.gd").new()
var mock_viewport = Control.new()
	mock_viewport.size = Vector2(375, 667) # iPhone size

	panel.initialize_component()
	panel.get_viewport = func(): return mock_viewport
	panel._adapt_to_viewport()

	assert_true(panel.is_mobile_size())
	# Panel should be at bottom in mobile
	assert_equals(panel.anchor_top, 1.0)
	)

	it("should adapt panel layout for desktop", func():
var panel = prepreprepreload("res://ui/components/panels/ModularInfoPanel.gd").new()
var mock_viewport = Control.new()
	mock_viewport.size = Vector2(1920, 1080)

	panel.initialize_component()
	panel.get_viewport = func(): return mock_viewport
	panel._adapt_to_viewport()

	assert_true(panel.is_desktop_size())
	# Panel should be on right side for desktop
	assert_equals(panel.anchor_left, 1.0)
	)

	# Test error recovery
var main_scene = prepreprepreload("res://scenes/main/node_3d.gd").new()

# Try to display non-existent structure
	main_scene._display_structure_info("NonExistentStructure")

	# Should not crash, panel should not be created
	assert_null(main_scene.info_panel)
	)

	it("should fallback to legacy KB if KnowledgeService fails", func():
var main_scene = prepreprepreload("res://scenes/main/node_3d.gd").new()

# Disable KnowledgeService
var original_ks = KnowledgeService
	KnowledgeService = null

	# Should still work with legacy KB
	main_scene._display_structure_info("hippocampus")

	# Restore
	KnowledgeService = original_ks
	)

	# Test performance benchmarks
var start_time = Time.get_ticks_msec()

var model_coordinator = prepreprepreload("res://core/models/ModelRegistry.gd").new()
	model_coordinator.load_brain_models()

	await wait_for_signal(model_coordinator.models_loaded, 5.0)

var load_time = Time.get_ticks_msec() - start_time
	assert_less_than(load_time, 3000) # Should load in under 3 seconds
	)

	it("should maintain 60fps during interactions", func():
var main_scene = preload("res://scenes/main/node_3d.tscn").instantiate()
var fps_samples = []

# Sample FPS over 2 seconds
var avg_fps = fps_samples.reduce(func(a, b): return a + b) / fps_samples.size()
	assert_greater_than(avg_fps, 55.0) # Allow small variance
	)

func test_full_user_interaction_pipeline() -> void:
	describe("Full User Interaction Pipeline")

	it("should handle complete structure selection flow", func():
		# Setup scene
func test_knowledge_to_ui_pipeline() -> void:
	describe("Knowledge Base to UI Pipeline")

	it("should display correct data in info panel", func():
		# Load knowledge base
func test_responsive_behavior() -> void:
	describe("Responsive UI Behavior")

	it("should adapt panel layout for mobile", func():
func test_error_recovery() -> void:
	describe("Error Recovery Mechanisms")

	it("should handle missing anatomical data gracefully", func():
func test_performance_benchmarks() -> void:
	describe("Performance Benchmarks")

	it("should load models within acceptable time", func():

func _fix_orphaned_code():
	for i in range(120): # 2 seconds at 60fps
	fps_samples.append(Engine.get_frames_per_second())
	await wait_frames(1)
