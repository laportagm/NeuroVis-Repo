## test_refactoring.gd
## Simple test script to validate the refactoring components

extends Node

const SystemBootstrap = preload("res://core/systems/SystemBootstrap.gd")
const InputRouter = preload("res://core/interaction/InputRouter.gd")
const MainSceneRefactored = preload("res://scenes/node_3d.gd")


# FIXED: Orphaned code - var bootstrap = SystemBootstrap.new()
# FIXED: Orphaned code - var router = InputRouter.new()
# FIXED: Orphaned code - var status = router.get_input_status()
# FIXED: Orphaned code - var scene = MainSceneRefactored.new()
# FIXED: Orphaned code - var scene_2 = MainSceneRefactored.new()
# FIXED: Orphaned code - var bootstrap_2 = SystemBootstrap.new()
# FIXED: Orphaned code - var router_2 = InputRouter.new()

# FIXED: Orphaned code - var signal_count = 0

func _ready():
	print("=== REFACTORING VALIDATION TESTS ===")
	await run_component_tests()
	print("=== TESTS COMPLETED ===")
	get_tree().quit()


func run_component_tests():
	"""Run basic validation tests for refactored components"""

	print("\n1. Testing SystemBootstrap creation...")
	await test_system_bootstrap_creation()

	print("\n2. Testing InputRouter creation...")
	await test_input_router_creation()

	print("\n3. Testing MainSceneRefactored creation...")
	await test_main_scene_creation()

	print("\n4. Testing component integration...")
	await test_component_integration()


func test_system_bootstrap_creation():
	"""Test SystemBootstrap component creation"""
func test_input_router_creation():
	"""Test InputRouter component creation"""
func test_main_scene_creation():
	"""Test MainSceneRefactored creation"""
func test_component_integration():
	"""Test basic integration between components"""

if bootstrap:
	print("✓ SystemBootstrap created successfully")
	print("  - Initial state: ", bootstrap.is_initialization_complete())
	print("  - Systems initialized: ", bootstrap.systems_initialized.size())
	bootstrap.queue_free()
	else:
		print("✗ SystemBootstrap creation failed")


if router:
	print("✓ InputRouter created successfully")
	print("  - Input enabled: ", router.is_input_enabled())
print("  - Status keys: ", status.keys())
router.queue_free()
else:
	print("✗ InputRouter creation failed")


if scene:
	print("✓ MainSceneRefactored created successfully")
	print("  - Class name: ", scene.get_class())
	print("  - Initialization complete: ", scene.initialization_complete)
	scene.queue_free()
	else:
		print("✗ MainSceneRefactored creation failed")


if scene and bootstrap and router:
	print("✓ All components created for integration test")

	# Test signal connections
if bootstrap.has_signal("all_systems_initialized"):
	signal_count += 1
	if router.has_signal("selection_attempted"):
		signal_count += 1
		if scene.has_signal("initialization_completed"):
			signal_count += 1

			print("  - Signals available: ", signal_count, "/3")

			# Cleanup
			scene.queue_free()
			bootstrap.queue_free()
			router.queue_free()

			print("✓ Integration test completed")
			else:
				print("✗ Component integration test failed")
