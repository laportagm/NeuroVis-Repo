class_name ModelSwitcherSceneTest
extends Node

# Signal to report test results
signal test_completed(success: bool, message: String)

# Initialize references
var main_scene = null
var model_switcher = null
var model_control_panel = null
var timer = null

func _ready() -> void:
	# Don't run the test automatically in the scene
	if get_parent().name == "tests":
		return
	
	# Run the test
	run_test()

func run_test() -> void:
	print("\n===== MODEL SWITCHER TEST SUITE =====")
	
	# Set up timer for delayed execution
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.5
	timer.one_shot = true
	timer.timeout.connect(_run_tests)
	timer.start()
	
	print("Model switcher test initialized. Tests will run shortly...")

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
	
	print("Test 1: Checking for model switcher reference")
	model_switcher = ModelSwitcherGlobal
	if not model_switcher:
		_report_failure("Failed to access ModelSwitcherGlobal")
		return
	print("✓ Model switcher global reference found")
	
	print("Test 2: Checking for model control panel")
	model_control_panel = main_scene.model_control_panel
	if not model_control_panel:
		_report_failure("Failed to find model_control_panel in main scene")
		return
	print("✓ Model control panel found")
	
	print("Test 3: Checking for registered models")
	var model_names = model_switcher.get_model_names()
	if model_names.size() == 0:
		_report_failure("No models registered with model_switcher")
		return
	print("✓ Found " + str(model_names.size()) + " registered models: " + str(model_names))
	
	print("Test 4: Testing model visibility toggling")
	# Test toggling the first model
	if model_names.size() > 0:
		var test_model_name = model_names[0]
		var initial_visibility = model_switcher.is_model_visible(test_model_name)
		
		print("  - Initial visibility of " + test_model_name + ": " + str(initial_visibility))
		print("  - Toggling visibility...")
		
		# Toggle via model switcher
		model_switcher.toggle_model_visibility(test_model_name)
		
		# Check if toggle worked
		var new_visibility = model_switcher.is_model_visible(test_model_name)
		print("  - New visibility: " + str(new_visibility))
		
		if new_visibility == initial_visibility:
			_report_failure("Failed to toggle model visibility")
			return
			
		# Toggle back to initial state
		model_switcher.toggle_model_visibility(test_model_name)
		print("  - Reset to initial visibility")
		
		print("✓ Model visibility toggle works")
	
	print("Test 5: Testing UI control connection")
	if model_names.size() > 0:
		var _test_model_name = model_names[0]
		
		# Check if model control panel has method to update button state
		if not model_control_panel.has_method("update_button_state"):
			_report_failure("Model control panel doesn't have expected method")
			return
			
		print("  - UI control methods verified")
		
		# Check buttons exist in UI
		var has_buttons = false
		if model_control_panel.has_node("MarginContainer/VBoxContainer/ModelsContainer"):
			for child in model_control_panel.get_node("MarginContainer/VBoxContainer/ModelsContainer").get_children():
				if child is CheckButton:
					has_buttons = true
					break
		else:
			print("  - Warning: ModelsContainer node path not found")
			
		if not has_buttons:
			_report_failure("Model control panel doesn't have expected buttons")
			return
			
		print("✓ UI control setup verified")
	
	print("Test 6: Validating model references")
	var brain_model_parent = main_scene.brain_model_parent
	if not brain_model_parent:
		_report_failure("Brain model parent not found")
		return
		
	if brain_model_parent.get_child_count() == 0:
		_report_failure("No model children found in brain_model_parent")
		return
		
	print("✓ Model references valid")
	
	# All tests passed
	_report_success("All model switcher tests passed successfully!")

func _report_success(message: String) -> void:
	print("\n✓ TEST SUITE PASSED: " + message)
	print("===== END OF MODEL SWITCHER TEST SUITE =====\n")
	emit_signal("test_completed", true, message)

func _report_failure(message: String) -> void:
	printerr("\n❌ TEST SUITE FAILED: " + message)
	print("===== END OF MODEL SWITCHER TEST SUITE =====\n")
	emit_signal("test_completed", false, message)