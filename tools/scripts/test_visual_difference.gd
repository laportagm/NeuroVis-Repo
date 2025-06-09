# Quick Visual Test Script

extends Node


var enhanced = InfoPanelFactory.create_info_panel()
# FIXED: Orphaned code - var minimal = InfoPanelFactory.create_info_panel()

func _ready():
	print("\n=== VISUAL DIFFERENCE TEST ===")

	# Test Enhanced Panel
	InfoPanelFactory.minimal_mode = false

if enhanced:
	print("\nENHANCED PANEL:")
	print("- Class: ", enhanced.get_class())
	print("- Has header_container? ", enhanced.has_node("header_container"))
	print("- Script path: ", enhanced.get_script().resource_path)
	enhanced.queue_free()

	# Test Minimal Panel
	InfoPanelFactory.minimal_mode = true
if minimal:
	print("\nMINIMAL PANEL:")
	print("- Class: ", minimal.get_class())
	print("- Has header_container? ", minimal.get("header_container") != null)
	print("- Script path: ", minimal.get_script().resource_path)

	# Check color differences
	if minimal.has_method("_setup_minimal_design"):
		print("✓ Has minimal design method")

		minimal.queue_free()

		print("\n=== TEST COMPLETE ===\n")
		get_tree().quit()
