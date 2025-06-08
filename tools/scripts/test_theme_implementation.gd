# Test script to verify theme implementation

extends Node


var factory_path = "res://ui/panels/InfoPanelFactory.gd"
var factory = load(factory_path)
InfoPanelFactory.minimal_mode = false
var enhanced_panel = InfoPanelFactory.create_info_panel()
# FIXED: Orphaned code - var minimal_panel = InfoPanelFactory.create_info_panel()
# FIXED: Orphaned code - var required_signals = ["panel_closed", "structure_bookmarked", "structure_selected"]
var all_signals_exist = true

func _ready():
	print("=== Theme Implementation Test ===")

	# Test 1: InfoPanelFactory exists
	print("\nTest 1: InfoPanelFactory exists")

if ResourceLoader.exists(factory_path):
	print("✅ InfoPanelFactory found")

	# Test 2: Can create default panel
	print("\nTest 2: Create default panel (enhanced)")
if enhanced_panel:
	print("✅ Enhanced panel created successfully")
	print("   Class: ", enhanced_panel.get_class())
	enhanced_panel.queue_free()
	else:
		print("❌ Failed to create enhanced panel")

		# Test 3: Can create minimal panel
		print("\nTest 3: Create minimal panel")
		InfoPanelFactory.minimal_mode = true
if minimal_panel:
	print("✅ Minimal panel created successfully")
	print("   Class: ", minimal_panel.get_class())

	# Test 4: Check signals exist
	print("\nTest 4: Verify signals")
for signal_name in required_signals:
	if minimal_panel.has_signal(signal_name):
		print("✅ Signal found: ", signal_name)
		else:
			print("❌ Missing signal: ", signal_name)
			all_signals_exist = false

			minimal_panel.queue_free()
			else:
				print("❌ Failed to create minimal panel")

				# Test 5: Theme persistence
				print("\nTest 5: Theme preference persistence")
				InfoPanelFactory.save_preference()
				print("✅ Preference saved")

				else:
					print("❌ InfoPanelFactory not found at: ", factory_path)

					print("\n=== Test Complete ===")
					get_tree().quit()
