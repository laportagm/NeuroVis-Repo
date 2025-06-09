extends SceneTree


func _init():
	print("\n=== Testing Scene Loading ===\n")

	# Check if main scene can be loaded
	var main_scene_path = "res://scenes/main/node_3d.tscn"
	if ResourceLoader.exists(main_scene_path):
		print("✅ Main scene file exists")
		var scene = load(main_scene_path)
		if scene:
			print("✅ Main scene loaded successfully")
			var instance = scene.instantiate()
			if instance:
				print("✅ Main scene instantiated")
				print("   Scene name: " + instance.name)
				print("   Children count: " + str(instance.get_child_count()))

				# Check for BrainModel node
				var brain_model = instance.get_node_or_null("BrainModel")
				if brain_model:
					print("✅ BrainModel node found")
					print("   BrainModel children: " + str(brain_model.get_child_count()))
				else:
					print("❌ BrainModel node not found")
			else:
				print("❌ Failed to instantiate main scene")
		else:
			print("❌ Failed to load main scene")
	else:
		print("❌ Main scene file not found")

	# Check model files
	print("\n=== Checking Model Files ===")
	var model_paths = [
		"res://assets/models/Half_Brain.glb",
		"res://assets/models/Internal_Structures.glb",
		"res://assets/models/Brainstem(Solid).glb"
	]

	for path in model_paths:
		if ResourceLoader.exists(path):
			print("✅ Model exists: " + path)
			var model = load(path)
			if model:
				print("   ✅ Model loaded successfully")
			else:
				print("   ❌ Failed to load model")
		else:
			print("❌ Model not found: " + path)

	quit()
