## test_syntax.gd
## Simple syntax test to verify UI safety framework compiles correctly

extends Node

const SafeAutoloadAccess = preload("res://ui/components/core/SafeAutoloadAccess.gd")
const UIComponentFactory = preload("res://ui/components/core/UIComponentFactory.gd")


	var theme_manager = SafeAutoloadAccess.get_theme_manager()
	print("Theme manager: ", theme_manager != null)

	# Test UIComponentFactory
	print("Testing UIComponentFactory...")
	var test_button = UIComponentFactory.create_button("Test", "primary")
	print("Button created: ", test_button != null)

	if test_button:
		test_button.queue_free()

	print("=== Syntax Test Complete ===")
	queue_free()

func _ready() -> void:
	print("=== Syntax Test Started ===")

	# Test SafeAutoloadAccess
	print("Testing SafeAutoloadAccess...")
