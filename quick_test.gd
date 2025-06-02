extends Node3D

func _ready():
	print("\n=== QUICK NEUROVIS TEST ===")
	
	# Test 1: Check critical autoloads
	var autoloads_ok = true
	for autoload in ["KnowledgeService", "UIThemeManager", "ModelSwitcherGlobal"]:
		if has_node("/root/" + autoload):
			print("✅ " + autoload + " loaded")
		else:
			print("❌ " + autoload + " missing")
			autoloads_ok = false
	
	# Test 2: Quick functionality test
	if has_node("/root/KnowledgeService"):
		var ks = get_node("/root/KnowledgeService")
		var test_data = ks.get_structure("hippocampus")
		if not test_data.is_empty():
			print("✅ Knowledge retrieval working")
		else:
			print("❌ Knowledge retrieval failed")
	
	# Test 3: Theme system
	var UIThemeManager = load("res://ui/panels/UIThemeManager.gd")
	if UIThemeManager:
		var style = UIThemeManager.create_enhanced_glass_style()
		if style:
			print("✅ Theme system working")
		else:
			print("❌ Theme system failed")
	
	print("\n=== TEST COMPLETE ===")
	print("Overall: " + ("PASS" if autoloads_ok else "FAIL"))
	
	# Exit after brief delay
	await get_tree().create_timer(0.5).timeout
	get_tree().quit(0 if autoloads_ok else 1)