class_name UIDiagnostic
extends Node

# This script provides diagnostic tools specifically for UI issues
# Add this as a child of your main scene and call functions as needed
# It performs robust error checking at each step to avoid crashes


var main_scene = _get_validated_main_scene("check_info_panel")
var info_panel = main_scene.info_panel
var parent = info_panel.get_parent()
var panel_script = info_panel.get_script()
var has_display_structure_data = info_panel.has_method("display_structure_data")
var test_data = {
	"id": "test_structure",
	"displayName": "Test Structure",
	"shortDescription": "This is a test structure for diagnostics",
	"functions": ["Test function 1", "Test function 2"]
	}

	# Temporarily make panel visible for testing
var was_visible = info_panel.visible
	info_panel.visible = true

	# Try to display test data
	_safe_call_method(info_panel, "display_structure_data", [test_data], "check_info_panel")

	# Wait a moment to see results
	await get_tree().create_timer(0.5).timeout

	# Check children again to see if data was applied
var main_scene = _get_validated_main_scene("check_ui_visibility")
var ui_layer = main_scene.get_node_or_null("UI_Layer")
var child_count = ui_layer.get_child_count()
var child = ui_layer.get_child(i)
var viewport = get_viewport()
var main_scene = _get_validated_main_scene("check_structure_selection_flow")
var info_panel = main_scene.info_panel

var signal_list = info_panel.get_signal_list()
var has_panel_closed = false

var connections = info_panel.get_signal_connection_list("panel_closed")
var target_object = connection.callable.get_object()
var was_visible = info_panel.visible if info_panel else false

# Check if the signal exists before trying to emit it
var indent_text = ""
var visible_text = ""
var main_scene = _get_validated_main_scene("test_info_panel_with_data")
var info_panel = main_scene.info_panel
var test_data = {
	"id": "test_structure",
	"displayName": "Test Structure",
	"shortDescription":
		"This is a comprehensive test structure with a longer description to test text wrapping and display capabilities of the info panel.",
		"functions":
			[
			"Primary function: Testing the display",
			"Secondary function: Verifying layout",
			"Additional function: Checking scrolling if needed"
			]
			}

			# Make panel visible
			info_panel.visible = true

			# Force UI_Layer visibility
var ui_layer = main_scene.get_node_or_null("UI_Layer")
var parent = info_panel.get_parent()
var main_scene = _get_validated_main_scene("trace_info_panel_calls")
var info_panel = main_scene.info_panel
var original_method = info_panel.display_structure_data

# Use a more GDScript-friendly approach for function patching
info_panel.display_structure_data = func(structure_data):
var scene = get_tree().current_scene
var signals = object.get_signal_list()

func _ready() -> void:
	print("UIDiagnostic ready. Use run_diagnostics() to start.")


func run_diagnostics() -> void:
	print("\n===== UI DIAGNOSTIC REPORT =====")
	check_info_panel()
	check_ui_visibility()
	check_structure_selection_flow()
	print("===== END UI DIAGNOSTIC REPORT =====")


func check_info_panel() -> void:
	print("\n----- INFO PANEL DIAGNOSTICS -----")

	# Get main scene with validation
func check_ui_visibility() -> void:
	print("\n----- UI VISIBILITY DIAGNOSTICS -----")

	# Get main scene with validation
func check_structure_selection_flow() -> void:
	print("\n----- STRUCTURE SELECTION FLOW DIAGNOSTICS -----")

	# Get main scene with validation
func test_info_panel_with_data() -> void:
	print("\n===== INFO PANEL TEST =====")

	# Get main scene with validation
func trace_info_panel_calls() -> void:
	print("\n===== TRACING INFO PANEL CALLS =====")

	# Get main scene with validation

func _fix_orphaned_code():
	if main_scene == null:
		return

		# Check info panel reference
func _fix_orphaned_code():
	if info_panel == null:
		printerr("UIDiagnostic Error: Info panel reference is null in check_info_panel()")
		return

		print("Info panel class: " + info_panel.get_class())
		print("Info panel visible: " + str(info_panel.visible))

		# Safely check parent
func _fix_orphaned_code():
	if parent == null:
		printerr("UIDiagnostic Error: Info panel has no parent in check_info_panel()")
		else:
			print("Info panel parent: " + parent.name)
			print("Parent visible: " + str(parent.visible))

			# Check info panel's children
			print("\nInfo panel hierarchy:")
			_print_node_tree(info_panel, 1)

			# Check for script
func _fix_orphaned_code():
	if panel_script == null:
		printerr("UIDiagnostic Error: Info panel has no script attached!")
		else:
			print("Info panel script: " + panel_script.resource_path)

			# Test if panel has the required methods
func _fix_orphaned_code():
	print("Has display_structure_data method: " + str(has_display_structure_data))

	if has_display_structure_data:
		print("Testing with dummy data...")
		# Create test data
func _fix_orphaned_code():
	print("\nInfo panel hierarchy after test data:")
	_print_node_tree(info_panel, 1)

	# Restore visibility
	info_panel.visible = was_visible

	print("----- END INFO PANEL DIAGNOSTICS -----")


func _fix_orphaned_code():
	if main_scene == null:
		return

		# Check UI layer using get_node_or_null for safety
func _fix_orphaned_code():
	if ui_layer == null:
		printerr("UIDiagnostic Error: UI_Layer node not found in check_ui_visibility()")
		return

		print("UI_Layer visible: " + str(ui_layer.visible))
		print("UI_Layer children:")

		# Check all children
func _fix_orphaned_code():
	if child_count == 0:
		print(" - No children found in UI_Layer")
		else:
			for i in range(child_count):
func _fix_orphaned_code():
	if child == null:
		print(" - Error: Null child at index " + str(i))
		else:
			print(
			(
			" - "
			+ child.name
			+ " ("
			+ child.get_class()
			+ "), visible: "
			+ str(child.visible)
			)
			)

			# Check viewport and canvas
			print("\nViewport info:")
func _fix_orphaned_code():
	if viewport == null:
		printerr("UIDiagnostic Error: Viewport is null in check_ui_visibility()")
		else:
			print("Viewport size: " + str(viewport.size))
			print("Viewport GUI embedding: " + str(viewport.gui_embed_subwindows))

			print("----- END UI VISIBILITY DIAGNOSTICS -----")


func _fix_orphaned_code():
	if main_scene == null:
		return

		# Check knowledge base
		if main_scene.knowledge_base == null:
			printerr(
			"UIDiagnostic Error: Knowledge base reference is null in check_structure_selection_flow()"
			)
			return

			print("Knowledge base loaded: " + str(main_scene.knowledge_base.is_loaded))

			# Check neural net
			if main_scene.neural_net == null:
				printerr(
				"UIDiagnostic Error: Neural net reference is null in check_structure_selection_flow()"
				)
				return

				# Check signal connections
				print("\nChecking signal connections:")
func _fix_orphaned_code():
	if info_panel == null:
		printerr(
		"UIDiagnostic Error: Info panel is null in check_structure_selection_flow(), can't check signal connections"
		)
		else:
			# Check if panel_closed signal is connected
func _fix_orphaned_code():
	for signal_info in signal_list:
		if signal_info.name == "panel_closed":
			has_panel_closed = true

			# Check connections
func _fix_orphaned_code():
	print("panel_closed signal has " + str(connections.size()) + " connections")

	for connection in connections:
func _fix_orphaned_code():
	if target_object == null:
		print(" - Connected to: NULL object (possible orphaned signal)")
		else:
			print(
			(
			" - Connected to: "
			+ target_object.name
			+ " -> "
			+ str(connection.callable)
			)
			)

			break

			if not has_panel_closed:
				print("WARNING: Info panel doesn't have panel_closed signal!")

				# Test structure selection flow
				print("\nTesting structure selection flow:")
				print("1. Emitting structure_selected signal with test structure...")

				# Store original panel visibility
func _fix_orphaned_code():
	if not _has_signal(main_scene, "structure_selected"):
		printerr(
		"UIDiagnostic Error: MainScene doesn't have structure_selected signal in check_structure_selection_flow()"
		)
		else:
			# Emit test signal
			main_scene.structure_selected.emit("test_structure")

			# Wait a moment
			await get_tree().create_timer(0.5).timeout

			# Check if panel became visible
			if info_panel:
				print("Info panel visible after selection: " + str(info_panel.visible))
				print("Previous visibility: " + str(was_visible))

				print("----- END STRUCTURE SELECTION FLOW DIAGNOSTICS -----")


				# Helper function to print node tree with error handling
func _fix_orphaned_code():
	for i in range(indent):
		indent_text += "  "

func _fix_orphaned_code():
	if node is Control:
		visible_text = ", visible: " + str(node.visible)

		print(indent_text + "- " + node.name + " (" + node.get_class() + ")" + visible_text)

		# Print children
		for child in node.get_children():
			if child == null:
				print(indent_text + "  - ERROR: null child detected")
				else:
					_print_node_tree(child, indent + 1)


					# Add this method to test a specific issue with the UI info panel
func _fix_orphaned_code():
	if main_scene == null:
		return

		# Get info panel
func _fix_orphaned_code():
	if info_panel == null:
		printerr("UIDiagnostic Error: Info panel reference is null in test_info_panel_with_data()")
		return

		# Create comprehensive test data
func _fix_orphaned_code():
	if ui_layer == null:
		printerr("UIDiagnostic Error: UI_Layer not found in test_info_panel_with_data()")
		else:
			ui_layer.visible = true

			# Display test data
			print("Displaying test data in info panel...")
			if not info_panel.has_method("display_structure_data"):
				printerr(
				"UIDiagnostic Error: Info panel doesn't have display_structure_data method in test_info_panel_with_data()"
				)
				return

				_safe_call_method(
				info_panel, "display_structure_data", [test_data], "test_info_panel_with_data"
				)

				# Check result - safely check parent
				print("Info panel visible: " + str(info_panel.visible))

func _fix_orphaned_code():
	if parent == null:
		printerr("UIDiagnostic Error: Info panel has no parent in test_info_panel_with_data()")
		else:
			print("Parent visible: " + str(parent.visible))

			print("Test completed. Check the UI in the game window.")
			print("===== END INFO PANEL TEST =====")


			# Check if the UI info panel is actually receiving function calls
func _fix_orphaned_code():
	if main_scene == null:
		return

		# Get info panel
func _fix_orphaned_code():
	if info_panel == null:
		printerr("UIDiagnostic Error: Info panel reference is null in trace_info_panel_calls()")
		return

		# Check if the method exists before attempting to patch it
		if not info_panel.has_method("display_structure_data"):
			printerr(
			"UIDiagnostic Error: Info panel doesn't have display_structure_data method in trace_info_panel_calls()"
			)
			return

			# Create a monkey patch for the display_structure_data method
func _fix_orphaned_code():
	print("TRACE: display_structure_data called with data: " + str(structure_data))
	original_method.call(structure_data)

	print("Tracing enabled for info_panel.display_structure_data")
	print("Try selecting a structure now to see if the method is called.")
	print("===== TRACING SETUP COMPLETE =====")


	# Helper function to get and validate the main scene
func _fix_orphaned_code():
	if scene == null:
		printerr("UIDiagnostic Error: Current scene is null in " + context + "()")
		return null

		# Check if scene is the expected type
		# Note: Using is operator might not work if MainScene is not a class_name
		# so we also check get_class() as a fallback
		if not (scene.get_script() and scene.get_script().get_path().ends_with("MainScene.gd")):
			printerr("UIDiagnostic Error: Current scene is not a MainScene in " + context + "()")
			printerr("UIDiagnostic Error: Got " + scene.get_class() + " instead")
			return null

			return scene


			# Helper function to safely call a method with error handling
func _fix_orphaned_code():
	for s in signals:
		if s.name == signal_name:
			return true

			return false

func _print_node_tree(node: Node, indent: int = 0) -> void:
	if node == null:
		print("Error: Attempted to print node tree for null node")
		return

func _get_validated_main_scene(context: String) -> Node:
func _safe_call_method(object: Object, method_name: String, args: Array, context: String) -> void:
	if not object.has_method(method_name):
		printerr(
		(
		"UIDiagnostic Error: Object doesn't have method '"
		+ method_name
		+ "' in "
		+ context
		+ "()"
		)
		)
		return

		# GDScript doesn't have try/catch, so we'll have to be more careful
		if args.size() > 0:
			# We can't safely check if this will work beforehand
			object.callv(method_name, args)
			else:
				object.call(method_name)


				# Helper function to check if an object has a signal
func _has_signal(object: Object, signal_name: String) -> bool:
	if object == null:
		return false

