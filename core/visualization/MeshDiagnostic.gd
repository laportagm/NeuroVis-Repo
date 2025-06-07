class_name MeshDiagnostic
extends Node3D

# This script is for diagnostic purposes to help identify all mesh names
# in the loaded 3D models and compare them with structure IDs in the knowledge base


var timer = Timer.new()
add_child(timer)
timer.wait_time = 1.0
timer.one_shot = true
timer.timeout.connect(_run_diagnostics)
timer.start()


var main_scene = get_tree().current_scene
var brain_model_parent = main_scene.find_child("BrainModel", true, false)
var mesh_names = []
var mesh_info = {}

# Recursively collect all mesh instances
_collect_mesh_instances(brain_model_parent, mesh_names, mesh_info)

# Print results
var info = mesh_info[mesh_name]
var current_path = path + "/" + node.name

# Check if this node is a MeshInstance3D
var parent_name = ""
var knowledge_base = null
var main_scene_2 = get_tree().current_scene

var structure_ids = knowledge_base.get_all_structure_ids()

var matches = 0
var partial_matches = 0
var no_matches = 0

var match_type = "NO MATCH"
var matching_id = ""

# Exact match check
var lower_mesh_name = mesh_name.to_lower()
var found_partial = false

var structure = knowledge_base.get_structure(id)
var display_name = structure.displayName.to_lower()
var neural_net = null
var main_scene_3 = get_tree().current_scene

var mapped = 0
var unmapped = 0

var mapped_id = neural_net.map_mesh_name_to_structure_id(mesh_name)

func _ready() -> void:
	print("MeshDiagnostic: Script initialized. Waiting for models to load...")
	# Wait a moment to ensure models are loaded

func _fix_orphaned_code():
	if not main_scene:
		print("ERROR: Cannot access current scene. Aborting.")
		return

		# Look for BrainModel node
func _fix_orphaned_code():
	if not brain_model_parent:
		print("ERROR: BrainModel node not found. Make sure this script is run in the main scene.")
		return

		# Store all found mesh names
func _fix_orphaned_code():
	print("\nFound " + str(mesh_names.size()) + " mesh instances:")
	for mesh_name in mesh_names:
func _fix_orphaned_code():
	print(" - " + mesh_name + " (Parent: " + info.parent + ", Path: " + info.path + ")")

	# Compare with knowledge base structure IDs
	_compare_with_knowledge_base(mesh_names)

	# Check NeuralNet mapping
	_check_neural_net_mapping(mesh_names)

	print("\n===== END OF DIAGNOSTIC REPORT =====")


func _fix_orphaned_code():
	if node is MeshInstance3D:
		mesh_names.append(node.name)
func _fix_orphaned_code():
	if node.get_parent() != null:
		parent_name = node.get_parent().name

		mesh_info[node.name] = {"parent": parent_name, "path": current_path}

		# Recursively check all children
		for child in node.get_children():
			_collect_mesh_instances(child, mesh_names, mesh_info, current_path)


func _fix_orphaned_code():
	if main_scene:
		# Check if the property exists (using get() with a default to avoid errors)
		if "knowledge_base" in main_scene:
			knowledge_base = main_scene.knowledge_base

			if not knowledge_base:
				print("ERROR: Knowledge base not found")
				return

				# Get all structure IDs from knowledge base
func _fix_orphaned_code():
	print("\nKnowledge base contains " + str(structure_ids.size()) + " structure IDs:")
	for id in structure_ids:
		print(" - " + id)

		print("\nMatching analysis:")

		# Print matches and mismatches
func _fix_orphaned_code():
	for mesh_name in mesh_names:
func _fix_orphaned_code():
	if structure_ids.has(mesh_name):
		match_type = "EXACT MATCH"
		matching_id = mesh_name
		matches += 1
		else:
			# Check for partial matches
func _fix_orphaned_code():
	for id in structure_ids:
func _fix_orphaned_code():
	if structure.has("displayName"):
func _fix_orphaned_code():
	if (
	lower_mesh_name.contains(display_name)
	or display_name.contains(lower_mesh_name)
	):
		match_type = "PARTIAL MATCH"
		matching_id = id
		partial_matches += 1
		found_partial = true
		break

		if not found_partial:
			no_matches += 1

			print(
			(
			" - "
			+ mesh_name
			+ ": "
			+ match_type
			+ (("") if matching_id.is_empty() else (" with " + matching_id))
			)
			)

			print("\nSummary:")
			print(" - Exact matches: " + str(matches))
			print(" - Partial matches: " + str(partial_matches))
			print(" - No matches: " + str(no_matches))


func _fix_orphaned_code():
	if main_scene:
		# Check if the property exists
		if "neural_net" in main_scene:
			neural_net = main_scene.neural_net

			if not neural_net:
				print("ERROR: NeuralNet module not found")
				return

				# Check mapping for each mesh name
func _fix_orphaned_code():
	for mesh_name in mesh_names:
func _fix_orphaned_code():
	if mapped_id.is_empty():
		print(" - " + mesh_name + ": NOT MAPPED")
		unmapped += 1
		else:
			print(" - " + mesh_name + " -> " + mapped_id)
			mapped += 1

			print("\nSummary:")
			print(" - Mapped mesh names: " + str(mapped))
			print(" - Unmapped mesh names: " + str(unmapped))

func _run_diagnostics() -> void:
	print("\n===== MESH DIAGNOSTIC REPORT =====")
	print("Analyzing all mesh instances in the scene...")

	# Make sure we're in the scene tree
	if not is_inside_tree():
		print("ERROR: MeshDiagnostic is not in the scene tree yet. Aborting.")
		return

		# Get main scene and brain model parent
func _collect_mesh_instances(
	node: Node, mesh_names: Array, mesh_info: Dictionary, path: String = ""
	) -> void:
		# Update current path
func _compare_with_knowledge_base(mesh_names: Array) -> void:
	print("\nComparing mesh names with knowledge base structure IDs:")

	# Make sure we're in the scene tree
	if not is_inside_tree():
		print("ERROR: Cannot access scene tree. Aborting comparison.")
		return

		# Get knowledge base
func _check_neural_net_mapping(mesh_names: Array) -> void:
	print("\nChecking NeuralNet mapping for mesh names:")

	# Make sure we're in the scene tree
	if not is_inside_tree():
		print("ERROR: Cannot access scene tree. Aborting neural net check.")
		return

		# Get neural net
