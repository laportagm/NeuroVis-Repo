extends Node


# Test the hybrid implementation

var hybrid_script = preload("res://scenes/node_3d_hybrid.gd")
# FIXED: Orphaned code - var test_node = Node3D.new()
test_node.set_script(hybrid_script)
test_node.name = "HybridTest"

# Add required child nodes
var camera = Camera3D.new()
camera.name = "Camera3D"
test_node.add_child(camera)

# FIXED: Orphaned code - var ui_layer = CanvasLayer.new()
ui_layer.name = "UI_Layer"
test_node.add_child(ui_layer)

# FIXED: Orphaned code - var brain_model = Node3D.new()
brain_model.name = "BrainModel"
test_node.add_child(brain_model)

# Add UI elements
var label = Label.new()
label.name = "ObjectNameLabel"
ui_layer.add_child(label)

# FIXED: Orphaned code - var status = test_node.get_component_status()

func _ready():
	print("\n" + "=".repeat(60))
	print("TESTING HYBRID COMPONENT ARCHITECTURE")
	print("=".repeat(60))

	# Try to load the hybrid script

if hybrid_script:
	print("✓ Hybrid component script loads successfully!")

	# Create a simple test scene
print("✓ Test scene structure created")

# Add to tree and let it initialize
add_child(test_node)

# Wait for initialization
await get_tree().create_timer(1.0).timeout

# Check status
if test_node.has_method("get_component_status"):
print("\nCOMPONENT STATUS:")
print("  Scene: " + str(status.get("scene", "Unknown")))
print("  Initialized: " + str(status.get("initialized", false)))
if "components" in status:
	print("  Components:")
	for comp_name in status["components"]:
		print("    • " + comp_name + ": " + str(status["components"][comp_name]))

		print("\n✓ Hybrid architecture test complete!")
		else:
			print("✗ Failed to load hybrid script")

			print("=".repeat(60) + "\n")

			# Let it run for a moment
			await get_tree().create_timer(2.0).timeout

			print("Test complete - you can now close this window")
