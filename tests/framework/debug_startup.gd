extends Node

func _ready():
	print("=== STARTUP DEBUG ===")
	print("Running from: ", get_tree().current_scene.scene_file_path)
	print("Scene name: ", get_tree().current_scene.name)
	print("Scene children:")
	for child in get_tree().current_scene.get_children():
		print("  - ", child.name, " (", child.get_class(), ")")
		if child.get_script():
			print("    Script: ", child.get_script().resource_path)
		else:
			print("    No script")
	
	# Check autoloads
	print("\nAutoloads:")
	print("  KB: ", "Available" if get_node_or_null("/root/KB") else "Missing")
	print("  ModelSwitcherGlobal: ", "Available" if get_node_or_null("/root/ModelSwitcherGlobal") else "Missing")
	print("  DebugCmd: ", "Available" if get_node_or_null("/root/DebugCmd") else "Missing")
	
	print("=== END DEBUG ===")