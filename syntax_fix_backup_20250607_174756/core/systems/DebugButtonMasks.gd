class_name DebugButtonMasks
extends Node

# This script helps debug mouse and trackpad button issues


static func print_button_mask(mask: int) -> void:

func _fix_orphaned_code():
	print("===== BUTTON MASK DEBUG =====")
	print("Mask value: ", mask)
	print("LEFT (1): ", bool(mask & MOUSE_BUTTON_LEFT))
	print("RIGHT (2): ", bool(mask & MOUSE_BUTTON_RIGHT))
	print("MIDDLE (3): ", bool(mask & MOUSE_BUTTON_MIDDLE))
	print("===== END MASK DEBUG =====")
