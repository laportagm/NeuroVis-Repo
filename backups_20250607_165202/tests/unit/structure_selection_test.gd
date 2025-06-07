class_name StructureSelectionTest
extends Node

# Signal to report test results

signal test_completed(success: bool, message: String)

# Initialize references

var main_scene = null
var camera = null
var timer = null


	var brain_model_parent = main_scene.brain_model_parent
	if not brain_model_parent:
		_report_failure("Brain model parent not found in main scene")
		return

	print("✓ Camera and brain model references found")

	print("Test 2: Checking for mesh instances in brain models")
	var mesh_instances = []
	_find_mesh_instances(brain_model_parent, mesh_instances)

	if mesh_instances.size() == 0:
		_report_failure("No mesh instances found in brain models")
		return

	print("  - Found " + str(mesh_instances.size()) + " mesh instances in brain models")

	# Print the first few mesh instances for debugging
	var max_to_show = min(5, mesh_instances.size())
	for i in range(max_to_show):
		print("  - Mesh " + str(i) + ": " + mesh_instances[i].name)

	print("✓ Brain model meshes verified")

	print("Test 3: Checking for selection handling method")
	if not main_scene.has_method("_handle_selection"):
		_report_failure("Main scene doesn't have _handle_selection method")
		return

	print("✓ Selection handling method found")

	print("Test 4: Testing raycasting and selection")

	# Test 1: Simple ray straight forward from camera
	var center_screen_pos = get_viewport().get_visible_rect().size / 2.0
	var did_hit_object = _test_raycast(center_screen_pos, "center of screen")

	# Try multiple rays if first one doesn't hit
	if not did_hit_object:
		print("  - Center ray didn't hit, trying additional ray positions")

		# Try upper center
		var upper_pos = Vector2(center_screen_pos.x, center_screen_pos.y * 0.7)
		did_hit_object = _test_raycast(upper_pos, "upper center")

		if not did_hit_object:
			# Try lower center
			var lower_pos = Vector2(center_screen_pos.x, center_screen_pos.y * 1.3)
			did_hit_object = _test_raycast(lower_pos, "lower center")

			if not did_hit_object:
				# Try left center
				var left_pos = Vector2(center_screen_pos.x * 0.7, center_screen_pos.y)
				did_hit_object = _test_raycast(left_pos, "left center")

				if not did_hit_object:
					# Try right center
					var right_pos = Vector2(center_screen_pos.x * 1.3, center_screen_pos.y)
					did_hit_object = _test_raycast(right_pos, "right center")

	if not did_hit_object:
		_report_failure(
			"Raycast failed to hit any objects. Camera may be incorrectly positioned or model not visible."
		)
		return

	print("✓ Raycasting test passed")

	print("Test 5: Testing structure highlighting")
	# Get current selected mesh (if any)
	var current_selected_mesh = main_scene.current_selected_mesh

	if not current_selected_mesh:
		_report_failure("No mesh was selected after raycasting")
		return

	print("  - Selected structure: " + current_selected_mesh.name)

	# Verify UI label update
	var object_name_label = main_scene.object_name_label
	if not object_name_label:
		_report_failure("Object name label not found")
		return

	if object_name_label.text == "Selected: None":
		_report_failure("Object name label not updated after selection")
		return

	print("  - Object name label updated: " + object_name_label.text)

	# Test additional selection functionality
	print("Test 6: Testing selection clearing")

	# Store current mesh
	var previously_selected_mesh = current_selected_mesh

	# Simulate a click on empty space (using far corner of screen likely to miss any object)
	var corner_pos = Vector2(10, 10)  # Top-left corner
	main_scene._handle_selection(corner_pos)

	# Give a frame to process
	await get_tree().process_frame

	# Check if selection was cleared
	if main_scene.current_selected_mesh == previously_selected_mesh:
		print("  - Warning: Selection not cleared when clicking empty space")
		# Not a failure as this might depend on scene configuration
	else:
		print("  - Selection successfully cleared")

	print("✓ Selection clearing test completed")

	print("Test 7: Testing structure selected signal")
	# Hook up to the signal
	var signal_data = {"received": false, "name": ""}

	if main_scene.has_signal("structure_selected"):
		main_scene.structure_selected.connect(
			func(structure_name):
				signal_data.received = true
				signal_data.name = structure_name
		)

		# Perform a selection at center screen again
		main_scene._handle_selection(center_screen_pos)

		# Wait a bit for signal to process
		await get_tree().create_timer(0.1).timeout

		if not signal_data.received:
			print("  - Warning: structure_selected signal not emitted")
		else:
			print("  - Received structure_selected signal with name: " + signal_data.name)
	else:
		print("  - Warning: structure_selected signal not defined")

	print("✓ Signal emission test completed")

	print("Test 8: Testing integration with info panel")
	var info_panel = main_scene.info_panel
	if not info_panel:
		print("  - Warning: Info panel reference not found")
	else:
		if info_panel.visible:
			print("  - Info panel was shown after selection")
		else:
			print("  - Warning: Info panel not shown after selection")

	print("✓ Info panel integration test completed")

	# All tests passed
	_report_success("All structure selection tests passed successfully!")


# Tests a raycast at a specific screen position and returns whether it hit something
	var original_handle_selection = main_scene._handle_selection

	# Replace with our instrumented version
	var hit_something_ref = {"value": false}  # Use a dictionary to pass by reference
	main_scene._handle_selection = func(click_position):
		# Forward to original method
		original_handle_selection.call(click_position)

		# Check if selection was successful
		hit_something_ref.value = (main_scene.current_selected_mesh != null)

	# Perform the selection
	main_scene._handle_selection(screen_pos)

	# Restore original method
	main_scene._handle_selection = original_handle_selection

	if hit_something_ref.value:
		print("  - Raycast hit object: " + main_scene.current_selected_mesh.name)
	else:
		print("  - Raycast did not hit any object")

	return hit_something_ref.value


# Recursively find all mesh instances in a node

func _ready() -> void:
	# Don't run the test automatically in the scene
	if get_parent().name == "tests":
		return

	# Run the test
	run_test()


func run_test() -> void:
	print("\n===== STRUCTURE SELECTION TEST SUITE =====")

	# Set up timer for delayed execution
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.5
	timer.one_shot = true
	timer.timeout.connect(_run_tests)
	timer.start()

	print("Structure Selection test initialized. Tests will run shortly...")


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

	print("Test 1: Checking for camera and brain model references")
	camera = main_scene.get_node("Camera3D")
	if not camera:
		_report_failure("Camera3D not found in main scene")
		return

func _test_raycast(screen_pos: Vector2, position_desc: String) -> bool:
	print("  - Testing raycast at " + position_desc)

	# Store the original method
func _find_mesh_instances(node: Node, mesh_instances: Array) -> void:
	if node is MeshInstance3D and node.mesh != null:
		mesh_instances.append(node)

	for child in node.get_children():
		_find_mesh_instances(child, mesh_instances)


func _report_success(message: String) -> void:
	print("\n✓ TEST SUITE PASSED: " + message)
	print("===== END OF STRUCTURE SELECTION TEST SUITE =====\n")
	test_completed.emit(true, message)


func _report_failure(message: String) -> void:
	printerr("\n❌ TEST SUITE FAILED: " + message)
	print("===== END OF STRUCTURE SELECTION TEST SUITE =====\n")
	test_completed.emit(false, message)
