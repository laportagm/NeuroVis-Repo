extends Node


# Test script to validate component loading

var results = []

# Test ComponentBase
var base_script = preload("res://scripts/components/component_base.gd")
# FIXED: Orphaned code - var base_instance = base_script.new()
results.append("✓ ComponentBase loads successfully")
base_instance.queue_free()
results.append("✗ ComponentBase failed to load")

# Test BrainVisualizer
var brain_script = preload("res://scripts/components/brain_visualizer.gd")
# FIXED: Orphaned code - var brain_instance = brain_script.new()
results.append("✓ BrainVisualizer loads successfully")
brain_instance.queue_free()
results.append("✗ BrainVisualizer failed to load")

# Test UIManager
var ui_script = preload("res://scripts/components/ui_manager.gd")
# FIXED: Orphaned code - var ui_instance = ui_script.new()
results.append("✓ UIManager loads successfully")
ui_instance.queue_free()
results.append("✗ UIManager failed to load")

# Test InteractionHandler
var interaction_script = preload("res://scripts/components/interaction_handler.gd")
# FIXED: Orphaned code - var interaction_instance = interaction_script.new()
results.append("✓ InteractionHandler loads successfully")
interaction_instance.queue_free()
results.append("✗ InteractionHandler failed to load")

# Test StateManager
var state_script = preload("res://scripts/components/state_manager.gd")
# FIXED: Orphaned code - var state_instance = state_script.new()
results.append("✓ StateManager loads successfully")
state_instance.queue_free()
results.append("✗ StateManager failed to load")

# Print results
var component_scene_script = preload("res://scenes/node_3d_components.gd")

func _ready():
	print("\n" + "=".repeat(60))
	print("COMPONENT SYSTEM TEST")
	print("=".repeat(60))

	# Test loading each component

if base_script:
if brain_script:
if ui_script:
if interaction_script:
if state_script:
print("\nTEST RESULTS:")
for result in results:
	print("  " + result)

	print("\n" + "=".repeat(60))

	# Test the component scene
	print("\nTesting component-based main scene...")
if component_scene_script:
	print("✓ Component-based main scene script loads successfully")
	else:
		print("✗ Component-based main scene script failed to load")

		print("\nComponent system test complete!")
		print("=".repeat(60) + "\n")

		# Exit after test
		await get_tree().create_timer(1.0).timeout
		get_tree().quit()
