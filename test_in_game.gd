extends Node

func _ready():
	print("\n=== RUNNING IN-GAME TESTS ===\n")
	
	# Wait for everything to initialize
	await get_tree().create_timer(0.5).timeout
	
	# Test debug commands
	if has_node("/root/DebugCmd"):
		var debug_cmd = get_node("/root/DebugCmd")
		print("✅ DebugCmd found - running tests...")
		
		# Run autoload test
		if debug_cmd.has_method("execute_command"):
			debug_cmd.execute_command("test autoloads")
			await get_tree().create_timer(0.5).timeout
			
			# Run UI safety test
			debug_cmd.execute_command("test ui_safety")
			await get_tree().create_timer(0.5).timeout
			
			# Run infrastructure test
			debug_cmd.execute_command("test infrastructure")
			await get_tree().create_timer(0.5).timeout
	else:
		print("❌ DebugCmd not found")
	
	# Test KnowledgeService directly
	if has_node("/root/KnowledgeService"):
		var ks = get_node("/root/KnowledgeService")
		print("\n✅ KnowledgeService found - testing...")
		
		var hippocampus = ks.get_structure("hippocampus")
		if not hippocampus.is_empty():
			print("  ✅ Retrieved hippocampus: " + hippocampus.get("displayName", "Unknown"))
		
		var search = ks.search_structures("memory", 3)
		print("  ✅ Search returned " + str(search.size()) + " results")
	
	# Test UIThemeManager
	var UIThemeManager = load("res://ui/panels/UIThemeManager.gd")
	if UIThemeManager:
		print("\n✅ UIThemeManager loaded - testing style cache...")
		var style = UIThemeManager.create_enhanced_glass_style()
		if style:
			print("  ✅ Style created successfully")
			print("  ✅ Cache enabled: " + str(UIThemeManager._cache_enabled))
			print("  ✅ Cache size: " + str(UIThemeManager._style_cache.size()))
	
	print("\n=== TESTS COMPLETE ===")
	
	# Keep running for a moment to see output
	await get_tree().create_timer(2.0).timeout
	get_tree().quit()