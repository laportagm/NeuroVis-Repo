## quick_debug_test.gd
## Quick debug test to identify any immediate issues

extends Node


var bootstrap_path = "res://core/systems/SystemBootstrap.gd"
var bootstrap_script = load(bootstrap_path)
# FIXED: Orphaned code - var bootstrap = bootstrap_script.new()
# FIXED: Orphaned code - var router_path = "res://core/interaction/InputRouter.gd"
var router_script = load(router_path)
# FIXED: Orphaned code - var router = router_script.new()
# FIXED: Orphaned code - var autoloads = ["KB", "ModelSwitcherGlobal", "DebugCmd"]
var node = get_node_or_null("/root/" + autoload_name)
# FIXED: Orphaned code - var scene_path = "res://scenes/node_3d.tscn"
var scene_script_path = "res://scenes/node_3d.gd"
var script = load(scene_script_path)

func _ready():
	print("=== QUICK DEBUG TEST ===")

	# Test 1: Basic script loading
	test_basic_loading()

	# Test 2: Check autoloads
	test_autoloads()

	# Test 3: Test scene structure
	test_scene_structure()

	print("=== DEBUG TEST COMPLETE ===")
	get_tree().quit()


func test_basic_loading():
	print("\n1. Testing basic script loading...")

	# Test SystemBootstrap
func test_autoloads():
	print("\n2. Testing autoloads...")

func test_scene_structure():
	print("\n3. Testing main scene...")

if ResourceLoader.exists(bootstrap_path):
if bootstrap_script:
print("  ✓ SystemBootstrap loads and instantiates")
bootstrap.queue_free()
else:
	print("  ✗ SystemBootstrap script failed to load")
	else:
		print("  ✗ SystemBootstrap not found")

		# Test InputRouter
if ResourceLoader.exists(router_path):
if router_script:
print("  ✓ InputRouter loads and instantiates")
router.queue_free()
else:
	print("  ✗ InputRouter script failed to load")
	else:
		print("  ✗ InputRouter not found")


for autoload_name in autoloads:
if node:
	print("  ✓ %s autoload active" % autoload_name)
	else:
		print("  ✗ %s autoload missing" % autoload_name)


if ResourceLoader.exists(scene_path):
	print("  ✓ Main scene file exists")

	# Try to check the script
if ResourceLoader.exists(scene_script_path):
if script:
	print("  ✓ Main scene script loads")
	else:
		print("  ✗ Main scene script failed to load")
		else:
			print("  ✗ Main scene script not found")
			else:
				print("  ✗ Main scene file not found")
