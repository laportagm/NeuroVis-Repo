## test_ui_safety.gd
## Test script to validate UI safety framework
extends Node

const SafeUIComponentTest = preload("res://ui/components/core/SafeUIComponentTest.gd")
const UIComponentFactory = preload("res://ui/components/core/UIComponentFactory.gd")

func _ready() -> void:
	print("=== UI Safety Framework Test ===")
	
	# Test 1: Component safety
	print("\n1. Testing component safety...")
	var safety_passed = SafeUIComponentTest.test_component_safety()
	print("Component safety test: " + ("PASSED" if safety_passed else "FAILED"))
	
	# Test 2: Autoload validation
	print("\n2. Testing autoload validation...")
	var autoload_results = SafeUIComponentTest.run_autoload_validation()
	
	# Test 3: Factory component creation
	print("\n3. Testing factory component creation...")
	_test_factory_components()
	
	# Test 4: Create actual test component
	print("\n4. Creating visual test component...")
	var test_component = SafeUIComponentTest.run_component_test(self)
	
	print("\n=== UI Safety Test Complete ===")
	
	# Cleanup after 5 seconds
	await get_tree().create_timer(5.0).timeout
	if test_component:
		test_component.queue_free()
	queue_free()

func _test_factory_components() -> void:
	"""Test factory component creation"""
	var test_parent = Control.new()
	add_child(test_parent)
	
	# Test button creation
	var button = UIComponentFactory.create_button("Test Button", "primary")
	if button:
		test_parent.add_child(button)
		print("  ✓ Button creation successful")
	else:
		print("  ✗ Button creation failed")
	
	# Test label creation
	var label = UIComponentFactory.create_label("Test Label", "body")
	if label:
		test_parent.add_child(label)
		print("  ✓ Label creation successful")
	else:
		print("  ✗ Label creation failed")
	
	# Test panel creation
	var panel = UIComponentFactory.create_panel("default")
	if panel:
		test_parent.add_child(panel)
		print("  ✓ Panel creation successful")
	else:
		print("  ✗ Panel creation failed")
	
	# Cleanup
	test_parent.queue_free()

