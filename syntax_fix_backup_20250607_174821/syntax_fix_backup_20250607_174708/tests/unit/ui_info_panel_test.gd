class_name UIInfoPanelTest
extends Node

# Signal to report test results

signal test_completed(success: bool, message: String)

# Initialize references

var main_scene = null
var info_panel = null
var knowledge_base = null
var timer = null


var required_nodes = [
"MarginContainer/VBoxContainer/TitleBar/StructureName",
"MarginContainer/VBoxContainer/TitleBar/CloseButton",
"MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/DescriptionSection/DescriptionText",
"MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/FunctionsSection/FunctionsList"
]

var required_methods = ["display_structure_data", "clear_data", "_populate_functions_list"]

var structure_ids = knowledge_base.get_all_structure_ids()
var test_structure_id = structure_ids[0]
var structure_data = knowledge_base.get_structure(test_structure_id)
var structure_name_label = info_panel.get_node(
	"MarginContainer/VBoxContainer/TitleBar/StructureName"
	)
var close_button = info_panel.get_node("MarginContainer/VBoxContainer/TitleBar/CloseButton")

# Test if close button signal is connected
var has_close_connection = false
var signal_connections = close_button.get_signal_connection_list("pressed")

var second_structure_id = structure_ids[1]
var second_structure_data = knowledge_base.get_structure(second_structure_id)

func _ready() -> void:
	# Don't run the test automatically in the scene
	if get_parent().name == "tests":
		return

		# Run the test
		run_test()


func run_test() -> void:
	print("\n===== UI INFO PANEL TEST SUITE =====")

	# Set up timer for delayed execution
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.5
	timer.one_shot = true
	timer.timeout.connect(_run_tests)
	timer.start()

	print("UI Info Panel test initialized. Tests will run shortly...")


func _fix_orphaned_code():
	for node_path in required_nodes:
		if not info_panel.has_node(node_path):
			_report_failure("Required UI component not found: " + node_path)
			return

			print("✓ UI panel components verified")

			print("Test 4: Testing info panel methods")
			# Check for expected methods
func _fix_orphaned_code():
	for method in required_methods:
		if not info_panel.has_method(method):
			_report_failure("Required method not found in info panel: " + method)
			return

			print("✓ Info panel methods verified")

			print("Test 5: Testing structure data display")
			# Get a test structure ID
func _fix_orphaned_code():
	if structure_ids.size() == 0:
		_report_failure("No structures found in knowledge base")
		return

func _fix_orphaned_code():
	print("  - Using test structure: " + test_structure_id)

	# Get the structure data
func _fix_orphaned_code():
	if structure_data.is_empty():
		_report_failure("Failed to get structure data for: " + test_structure_id)
		return

		# Initial panel state should be invisible
		if info_panel.visible:
			print("  - Warning: Info panel initially visible, should be hidden until needed")

			# Display the structure data
			print("  - Calling display_structure_data() method")
			info_panel.display_structure_data(structure_data)

			# Panel should now be visible
			await get_tree().create_timer(0.1).timeout  # Wait for visibility change
			if not info_panel.visible:
				_report_failure("Panel did not become visible after displaying structure data")
				return

				# Check if the structure name is displayed
func _fix_orphaned_code():
	if structure_name_label.text != structure_data.displayName:
		_report_failure(
		(
		"Structure name not correctly displayed. Expected: "
		+ structure_data.displayName
		+ ", Got: "
		+ structure_name_label.text
		)
		)
		return

		print("✓ Structure data display works correctly")

		print("Test 6: Testing close button functionality")
		# Get the close button
func _fix_orphaned_code():
	for connection in signal_connections:
		if (
		connection.callable.get_object() == info_panel
		and connection.callable.get_method() == "_on_close_button_pressed"
		):
			has_close_connection = true
			break

			if not has_close_connection:
				_report_failure("Close button is not properly connected to handler function")
				return

				# Simulate close button press
				print("  - Simulating close button press")
				close_button.pressed.emit()

				# Wait for panel to hide
				await get_tree().create_timer(0.1).timeout
				if info_panel.visible:
					_report_failure("Panel did not hide after close button press")
					return

					print("✓ Close button functionality works correctly")

					print("Test 7: Testing display of different structures")
					# Test with a different structure
					if structure_ids.size() > 1:
func _fix_orphaned_code():
	if not second_structure_data.is_empty():
		print("  - Displaying second structure: " + second_structure_id)
		info_panel.display_structure_data(second_structure_data)

		# Wait for update
		await get_tree().create_timer(0.1).timeout

		# Check if the structure name is updated
		if structure_name_label.text != second_structure_data.displayName:
			_report_failure("Second structure name not correctly displayed")
			return

			print("✓ Multiple structure display works correctly")

			print("Test 8: Testing panel clear functionality")
			# Test clear data
			print("  - Calling clear_data() method")
			info_panel.clear_data()

			# Wait for update
			await get_tree().create_timer(0.1).timeout

			# Panel should be hidden after clear
			if info_panel.visible:
				_report_failure("Panel still visible after clear_data()")
				return

				print("✓ Panel clear functionality works correctly")

				# Test the main scene's _display_structure_info method
				print("Test 9: Testing main scene structure info display")
				if main_scene.has_method("_display_structure_info"):
					print("  - Calling _display_structure_info() method")
					main_scene._display_structure_info(test_structure_id)

					# Wait for update
					await get_tree().create_timer(0.2).timeout

					# Panel should be visible again
					if not info_panel.visible:
						_report_failure("Panel did not become visible via main scene _display_structure_info()")
						return

						print("✓ Main scene structure info display works correctly")
						else:
							print("  - Warning: Main scene missing _display_structure_info method")

							# All tests passed
							_report_success("All UI info panel tests passed successfully!")


func _run_tests() -> void:
	# Get required references
	main_scene = get_tree().current_scene
	if main_scene.get_class() == "Control" and main_scene.name == "DebugScene":
		for child in main_scene.get_children():
			if child.get_class() == "Node3D" and child.name == "MainScene":
				main_scene = child
				break

				if not main_scene or main_scene.get_class() != "Node3D":
					_report_failure("Failed to get main scene")
					return

					print("Test 1: Checking for UI info panel reference")
					# First check if UI_Layer exists
					if not main_scene.has_node("UI_Layer"):
						_report_failure("UI_Layer not found in main scene")
						return

						# Get the info panel
						if not main_scene.has_node("UI_Layer/StructureInfoPanel"):
							_report_failure("StructureInfoPanel not found in UI_Layer")
							return

							info_panel = main_scene.get_node("UI_Layer/StructureInfoPanel")
							print("✓ UI info panel found")

							print("Test 2: Checking for knowledge base reference")
							knowledge_base = main_scene.knowledge_base
							if not knowledge_base:
								_report_failure("Failed to find knowledge_base in main scene")
								return

								print("✓ Knowledge base found")
								if not knowledge_base.is_loaded:
									_report_failure("Knowledge base is not loaded")
									return

									print("✓ Knowledge base is properly loaded")

									print("Test 3: Verifying UI panel components")
									# Check for essential UI panel components
func _report_success(message: String) -> void:
	print("\n✓ TEST SUITE PASSED: " + message)
	print("===== END OF UI INFO PANEL TEST SUITE =====\n")
	test_completed.emit(true, message)


func _report_failure(message: String) -> void:
	printerr("\n❌ TEST SUITE FAILED: " + message)
	print("===== END OF UI INFO PANEL TEST SUITE =====\n")
	test_completed.emit(false, message)
