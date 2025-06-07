## test_progressive_ui.gd
## Progressive UI component testing

extends Node

# Test core components first

const SafeAutoloadAccess = preload("res://ui/components/core/SafeAutoloadAccess.gd")
const BaseUIComponent = preload("res://ui/components/core/BaseUIComponent.gd")
const UIComponentFactory = preload("res://ui/components/core/UIComponentFactory.gd")


	var status = SafeAutoloadAccess.get_autoload_status()
	print("    ✓ SafeAutoloadAccess working, found " + str(status.size()) + " autoloads")

	# Test UIComponentFactory
	print("  Testing UIComponentFactory...")
	var button = UIComponentFactory.create_button("Test Button", "primary")
	if button:
		print("    ✓ UIComponentFactory working")
		button.queue_free()
	else:
		print("    ✗ UIComponentFactory failed")

	# Test BaseUIComponent
	print("  Testing BaseUIComponent...")
	var base_component = BaseUIComponent.new()
	if base_component:
		print("    ✓ BaseUIComponent working")
		base_component.queue_free()
	else:
		print("    ✗ BaseUIComponent failed")


	var responsive_script = load("res://ui/components/core/ResponsiveComponent.gd")
	if responsive_script:
		print("    ✓ ResponsiveComponent script loaded successfully")

		# Try to instantiate it
		var responsive_instance = responsive_script.new()
		if responsive_instance:
			print("    ✓ ResponsiveComponent instantiated successfully")
			responsive_instance.queue_free()
		else:
			print("    ✗ ResponsiveComponent instantiation failed")
	else:
		print("    ✗ ResponsiveComponent script failed to load")

func _ready() -> void:
	print("=== Progressive UI Component Test ===")

	# Test 1: Core components
	print("\n1. Testing core components...")
	_test_core_components()

	# Test 2: Try to load ResponsiveComponent
	print("\n2. Testing ResponsiveComponent...")
	_test_responsive_component()

	print("\n=== Progressive Test Complete ===")
	queue_free()


func _test_core_components() -> void:
	"""Test the core components that should work"""

	# Test SafeAutoloadAccess
	print("  Testing SafeAutoloadAccess...")
func _test_responsive_component() -> void:
	"""Test ResponsiveComponent separately"""

	print("  Attempting to load ResponsiveComponent...")

	# Try to load ResponsiveComponent dynamically
