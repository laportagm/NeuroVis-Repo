extends SceneTree


func _init():
	print("\n=== Testing Scene Fixes ===\n")

	# Test SimpleCameraController
	print("1. Testing SimpleCameraController...")
	var camera_script = load("res://core/interaction/SimpleCameraController.gd")
	if camera_script:
		print("   ✅ SimpleCameraController loads successfully")
		var instance = camera_script.new()
		if instance:
			print("   ✅ Can instantiate SimpleCameraController")
		else:
			print("   ❌ Failed to instantiate SimpleCameraController")
	else:
		print("   ❌ Failed to load SimpleCameraController")

	# Test BrainStructureSelectionManagerEnhanced
	print("\n2. Testing BrainStructureSelectionManagerEnhanced...")
	var selection_script = load("res://core/interaction/BrainStructureSelectionManagerEnhanced.gd")
	if selection_script:
		print("   ✅ BrainStructureSelectionManagerEnhanced loads successfully")
		var instance = selection_script.new()
		if instance:
			print("   ✅ Can instantiate BrainStructureSelectionManagerEnhanced")
		else:
			print("   ❌ Failed to instantiate BrainStructureSelectionManagerEnhanced")
	else:
		print("   ❌ Failed to load BrainStructureSelectionManagerEnhanced")

	# Test main scene
	print("\n3. Testing Main Scene...")
	var main_scene = load("res://scenes/main/node_3d.tscn")
	if main_scene:
		print("   ✅ Main scene loads")
		var instance = main_scene.instantiate()
		if instance:
			print("   ✅ Main scene instantiates")

			# Check if _ready runs without errors
			instance._ready()
			print("   ✅ Main scene _ready() executes")
		else:
			print("   ❌ Failed to instantiate main scene")
	else:
		print("   ❌ Failed to load main scene")

	print("\n=== Test Complete ===")
	quit()
