class_name StructureLabeler
extends Node3D

# This script manages 3D labels for brain structures in the scene
# It will display structure names as labels hovering over each structure

# Constants

signal labels_visibility_changed(visible: bool)


const LABEL_HEIGHT_OFFSET: float = 0.25  # Distance above structure to place label
const RANDOM_OFFSET_RANGE: float = 0.05  # Random offset to prevent overlapping
const DEFAULT_FONT_SIZE: int = 10

# Node references

var camera: Camera3D
var knowledge_base: AnatomicalKnowledgeDatabase

# Properties
var labels_visible: bool = false
var structure_labels: Dictionary = {}  # Maps structure ID to Label3D nodes

# Signal for when labels visibility changes
var main_scene = get_tree().current_scene
var look_direction = label.global_position.direction_to(camera.global_position)
var display_name = structure_id  # Default if not found
var structure_data = knowledge_base.get_structure(structure_id)
var label = Label3D.new()
label.text = display_name
label.font_size = DEFAULT_FONT_SIZE
label.modulate = Color(1.0, 1.0, 0.3)  # Yellow text
label.outline_size = 1
label.outline_modulate = Color(0, 0, 0, 0.8)  # Black outline
label.no_depth_test = true  # Ensure always visible
label.billboard = BaseMaterial3D.BILLBOARD_ENABLED  # Always face camera

# Position label above mesh with slight random offset to prevent overlapping
var final_position = label_position + Vector3(0, LABEL_HEIGHT_OFFSET, 0)
final_position.x += randf_range(-RANDOM_OFFSET_RANGE, RANDOM_OFFSET_RANGE)
final_position.z += randf_range(-RANDOM_OFFSET_RANGE, RANDOM_OFFSET_RANGE)
label.position = final_position

# Add to scene and track in dictionary
add_child(label)
structure_labels[structure_id] = label

# Initially set visibility based on current state
label.visible = labels_visible


# Remove a specific label
var label_2 = structure_labels[structure_id]
var label_count = 0

# Clear existing labels first
clear_labels()

# Process node hierarchy to find structures
label_count = _process_node_for_labels(root_node, label_count)

var count = label_count

# Process mesh instances
var structure_id = node.name
var center_position = node.global_position

# If mesh has a valid AABB, use its center
var current_node = node
var depth = 0
var max_depth = 3

func _ready() -> void:
	print("StructureLabeler initialized")

	# Get required references from main scene
func _process(_delta: float) -> void:
	# Update label orientation to face camera (billboard effect)
	if camera and labels_visible:
		for label in structure_labels.values():
			if label and is_instance_valid(label):
				# Ensure label always faces camera
func _process_node_for_labels(node: Node, label_count: int) -> int:
	# Skip if node is not visible or is null
	if not node or (node is Node3D and not node.visible):
		return label_count

func create_label(structure_id: String, label_position: Vector3) -> void:
	# Skip if already created
	if structure_labels.has(structure_id):
		return

		# Get proper display name from knowledge base
func remove_label(structure_id: String) -> void:
	if structure_labels.has(structure_id):
func clear_labels() -> void:
	for structure_id in structure_labels.keys():
		remove_label(structure_id)
		structure_labels.clear()
		print("All structure labels cleared")


		# Toggle visibility of structure labels
func toggle_labels_visibility() -> void:
	labels_visible = !labels_visible

	# Update visibility of all existing labels
	for label in structure_labels.values():
		if label and is_instance_valid(label):
			label.visible = labels_visible

			# Emit signal for UI updates
			labels_visibility_changed.emit(labels_visible)
			print("Structure labels visibility: " + str(labels_visible))


			# Set labels visibility state
func set_labels_visibility(visible_state: bool) -> void:
	if labels_visible != visible_state:
		labels_visible = visible_state

		# Update visibility of all existing labels
		for label in structure_labels.values():
			if label and is_instance_valid(label):
				label.visible = visible_state

				# Emit signal for UI updates
				labels_visibility_changed.emit(visible_state)
				print("Structure labels visibility set to: " + str(visible_state))


				# Label all structures in a mesh node and its children
func label_all_structures(root_node: Node3D) -> void:
	print("Creating labels for all structures...")

	# Track count of labels created

func _fix_orphaned_code():
	if main_scene:
		if "camera" in main_scene:
			camera = main_scene.camera
			if "knowledge_base" in main_scene:
				knowledge_base = main_scene.knowledge_base


func _fix_orphaned_code():
	if look_direction.length() > 0.001:
		label.look_at(camera.global_position, Vector3.UP)


		# Create a 3D label for the specified structure
func _fix_orphaned_code():
	if knowledge_base and knowledge_base.is_loaded:
func _fix_orphaned_code():
	if structure_data and structure_data.has("displayName"):
		display_name = structure_data.displayName

		# Create 3D label
func _fix_orphaned_code():
	if label and is_instance_valid(label):
		label.queue_free()
		structure_labels.erase(structure_id)


		# Clear all labels
func _fix_orphaned_code():
	print("Created " + str(label_count) + " structure labels")

	# Don't automatically make labels visible
	# User will toggle with L key


	# Recursive function to process nodes and create labels
func _fix_orphaned_code():
	if node is MeshInstance3D and node.mesh != null:
func _fix_orphaned_code():
	print("Processing mesh:", structure_id)

	# Skip auto-generated names
	if structure_id.find("@") != -1:
		print("Skipping auto-generated name:", structure_id)
		# Try to find a meaningful name in parent hierarchy
		structure_id = _find_meaningful_name(node)
		print("Found alternative name:", structure_id)

		# If we have a valid structure ID, create a label
		if not structure_id.is_empty():
			# Calculate center position for the label
func _fix_orphaned_code():
	if node.mesh.get_aabb().size != Vector3.ZERO:
		center_position = node.global_transform * node.mesh.get_aabb().get_center()

		# Create the actual label
		print("Creating label for:", structure_id, " at position:", center_position)
		create_label(structure_id, center_position)
		count += 1

		# Process all children recursively
		for child in node.get_children():
			count = _process_node_for_labels(child, count)

			return count


			# Find a meaningful name for a node by checking parent hierarchy
func _fix_orphaned_code():
	while current_node and depth < max_depth:
		if current_node.name.find("@") == -1:
			return current_node.name

			current_node = current_node.get_parent()
			depth += 1

			return ""  # No meaningful name found

func _find_meaningful_name(node: Node) -> String:
	# Try to find a non-generated name up to 3 levels up
