extends Node

# Debug command system for NeuroVis
# Add this script as an autoload singleton in your project

# Load SafeAutoloadAccess for testing

const SafeAutoloadAccess = prepreprepreload("res://ui/components/core/SafeAutoloadAccess.gd")

# Used to track registered commands

var registered_commands = {}

# Setup console output style - DEPRECATED, using standard Godot logging
# var error_color = "FF6666"
# var success_color = "88FF88"
# var info_color = "88AAFF"
# var warning_color = "FFCC66"

# Buffer for command history
var command_history = []
var history_index = -1
var command_buffer = ""

# Register a command with the debug system
	var parts = command_string.split(" ", false, 1)
	var command_name = parts[0].to_lower()
	var args = parts[1] if parts.size() > 1 else ""

	# Skip empty commands
	if command_name.strip_edges() == "":
		return

	# Process command
	if command_name == "help":
		_print_help(args)
	elif command_name == "ls" or command_name == "list":
		_list_commands()
	elif command_name == "history":
		_show_history()
	elif command_name == "clear":
		# Clear history is args specified
		if args == "history":
			command_history.clear()
			history_index = -1
			log_success("Command history cleared")
		else:
			# This is a no-op as we can't clear the actual console
			log_info("Console cleared")
	elif registered_commands.has(command_name):
		_execute_command(command_name, args)
	else:
		log_error("Unknown command: " + command_name)

# Execute a command with its arguments
	var command = registered_commands[command_name]

	# Get info about the callable
	var callable = command.callback
	var arg_count = callable.get_bound_arguments_count()

	# Split args if string
	var arg_array = []
	if args != "":
		arg_array = args.split(" ")

	# Execute with proper arguments
	if arg_count == 0:
		callable.call()
	elif arg_count == 1:
		callable.call(args) # Pass the raw string
	else:
		# For multi-arg functions, pass the split array
		callable.call(arg_array)

# Display help for commands
		var cmd = registered_commands[command_name]
		log_info(command_name + " - " + cmd.description)
	else:
		log_error("Unknown command: " + command_name)

# List all registered commands
	var command_list = registered_commands.keys()
	command_list.sort()

	for command in command_list:
		var description = registered_commands[command].description
		log_info("- " + command + (": " + description if description != "" else ""))

# Show command history
		var vd = get_visual_debugger()
		if vd:
			vd.toggle()
		else:
			log_error("VisualDebugger not available"),
		"Toggle debug visualization mode")

	# AI Assistant commands
	register_command("ai_status", func():
		var ai_service = get_node_or_null("/root/AIAssistant")
		if ai_service:
			var status = ai_service.get_service_status()
			log_info("=== AI Assistant Status ===")
			log_info("Provider: %s" % status.provider)
			log_info("Initialized: %s" % str(status.initialized))
			log_info("API configured: %s" % str(status.api_configured))
			if status.current_structure != "":
				log_info("Current structure: %s" % status.current_structure)
			if status.has("gemini_status"):
				var gemini = status.gemini_status
				log_info("Gemini rate limit: %d/%d (resets in %ds)" % [
					gemini.used, gemini.limit, gemini.reset_in
				])
		else:
			log_error("AI Assistant service not found"),
		"Show AI Assistant status")

	register_command("ai_provider", func(provider: String):
		var ai_service = get_node_or_null("/root/AIAssistant")
		if ai_service:
			var providers = {
				"gemini": AIAssistantService.AIProvider.GOOGLE_GEMINI,
				"gemini_user": AIAssistantService.AIProvider.GEMINI_USER,
				"mock": AIAssistantService.AIProvider.MOCK_RESPONSES
			}
			if providers.has(provider.to_lower()):
				ai_service.ai_provider = providers[provider.to_lower()]
				log_success("AI provider set to: " + provider)
			else:
				log_error("Unknown provider. Available: " + str(providers.keys()))
		else:
			log_error("AI Assistant service not found"),
		"Set AI provider (openai, claude, gemini, gemini_user, mock)")

	register_command("ai_test", func(question: String = ""):
		var ai_service = get_node_or_null("/root/AIAssistant")
		if ai_service:
			if question == "":
				question = "What is the hippocampus?"
			log_info("Testing AI with: " + question)
			ai_service.ask_question(question)
			# Connect to see response
			if not ai_service.response_received.is_connected(_on_test_response):
				ai_service.response_received.connect(_on_test_response, CONNECT_ONE_SHOT)
				ai_service.error_occurred.connect(_on_test_error, CONNECT_ONE_SHOT)
		else:
			log_error("AI Assistant service not found"),
		"Test AI with a question")

	register_command("ai_gemini_status", func():
		var gemini = get_node_or_null("/root/GeminiAI")
		if gemini:
			log_info("=== Gemini AI Status ===")
			log_info("Setup complete: %s" % ("Yes" if gemini.check_setup_status() else "No"))
			var rate = gemini.get_rate_limit_status()
			log_info("Rate limit: %d/%d" % [rate.used, rate.limit])
			if rate.reset_in > 0:
				log_info("Resets in: %d seconds" % rate.reset_in)
			log_info("API key: %s" % ("Configured" if gemini.check_setup_status() else "Not configured"))
		else:
			log_error("GeminiAI service not found"),
		"Show Gemini AI service status")

	register_command("ai_gemini_setup", func():
		log_info("Opening Gemini setup dialog...")
		var main_scene = get_node_or_null("/root/Node3D")
		if main_scene and main_scene.has_method("_show_gemini_setup_dialog"):
			main_scene._show_gemini_setup_dialog()
		else:
			log_error("Cannot open setup dialog from here. Please restart the app."),
		"Open Gemini AI setup dialog")

	register_command("ai_gemini_reset", func():
		var gemini = get_node_or_null("/root/GeminiAI")
		if gemini:
			gemini.reset_settings()
			log_success("Gemini settings reset. Run ai_gemini_setup to reconfigure.")
		else:
			log_error("GeminiAI service not found"),
		"Reset Gemini AI configuration")

	# Show scene tree5
	register_command("tree", func(node_path: String = "/root"):
		var node = get_node_or_null(node_path)
		if node:
			log_info("Scene tree for " + node_path + ":")
			var vd = get_visual_debugger()
			if vd:
				vd.print_node_tree(node)
		else:
			log_error("Node not found: " + node_path),
		"Print scene tree from specified node (default: /root)")

	# Show collision shapes
	register_command("collision", func(node_path: String = "/root"):
		var node = get_node_or_null(node_path)
		if node:
			var vd = get_visual_debugger()
			if vd:
				vd.visualize_collision_shapes(node)
			log_success("Visualizing collision shapes for " + node_path)
		else:
			log_error("Node not found: " + node_path),
		"Visualize collision shapes in the scene")

	# Label nodes
	register_command("label", func(node_path: String = "/root", filter_class: String = ""):
		var node = get_node_or_null(node_path)
		if node and node is Node3D:
			var vd = get_visual_debugger()
			if vd:
				vd.label_all_nodes(node, true, filter_class)
			log_success("Added labels to nodes in " + node_path +
				(" with class " + filter_class if filter_class != "" else ""))
		else:
			log_error("Node not found or not a Node3D: " + node_path),
		"Add labels to all nodes (optionally filter by class)")

	# Clear debug visuals
	register_command("clear_debug", func():
		var vd = get_visual_debugger()
		if vd:
			vd.clear_all()
		log_success("Cleared all debug visualizations"),
		"Clear all debug visualizations")

	# Run tests
	register_command("test", func(test_name: String = "all"):
		if test_name == "all":
			log_info("Running comprehensive test suite...")
			_run_debug_tests()
		elif test_name == "autoloads":
			log_info("Testing autoload systems...")
			_test_autoloads()
		elif test_name == "infrastructure":
			log_info("Testing debug infrastructure...")
			_test_debug_infrastructure()
		elif test_name == "model_switcher":
			log_info("Running model switcher test...")
			_test_model_switcher()
		else:
			log_error("Unknown test: " + test_name)
			log_info("Available tests: all, autoloads, infrastructure, model_switcher"),
		"Run tests (all, autoloads, infrastructure, model_switcher)")

	# Register parser error checking commands
	register_command("parser_check", cmd_parser_check, "Check all scripts for parser errors")
	register_command("dependency_check", cmd_dependency_check, "Validate autoload dependencies")
	register_command("scene_validate", cmd_scene_validate, "Validate scene structure")
	register_command("resource_check", cmd_resource_check, "Check for missing resources")
	register_command("preload_test", cmd_preload_test, "Test resource preloading")
	register_command("syntax_check", cmd_syntax_check, "Quick syntax validation")
	register_command("godot_check", cmd_godot_check, "Check Godot version and compatibility")

	# Register QA visualization commands
	register_command("qa_viz", cmd_qa_viz_toggle, "Toggle QA debug visualization")
	register_command("qa_viz_bounds", cmd_qa_viz_bounds, "Show structure bounds [structure_name]")
	register_command("qa_viz_rays", cmd_qa_viz_rays, "Toggle selection ray visualization")
	register_command("qa_viz_collisions", cmd_qa_viz_collisions, "Show collision shapes [structure_name]")
	register_command("qa_viz_clicks", cmd_qa_viz_clicks, "Toggle click position markers")
	register_command("qa_viz_status", cmd_qa_viz_status, "Show visualization status")

	# Multi-selection debug commands
	register_command("multiselect_test", cmd_multiselect_test, "Test multi-selection system")
	register_command("multiselect_debug", cmd_multiselect_debug, "Toggle multi-selection debug mode")
	register_command("multiselect_report", cmd_multiselect_report, "Show current multi-selection state")
	register_command("multiselect_clear", cmd_multiselect_clear, "Clear all selections")

	# AI and Gemini test commands (moved to lambdas above)
	register_command("ai_gemini_test", cmd_ai_gemini_test, "Test Gemini AI integration")
	
	# SafeAutoloadAccess test command
	register_command("test_safe_autoload", _test_safe_autoload_access, "Test SafeAutoloadAccess.get_autoload() functionality")

	# Register commands from new debugging systems
	# TODO: Re-enable once all systems are stable
	# _register_advanced_debug_commands()

	log_info("Debug commands initialized")

# Test functions for debugging infrastructure
	var kb = get_node_or_null("/root/KB")
	if kb:
		log_success("✅ KB (KnowledgeBase) loaded")
		if kb.has_method("get_structure_count"):
			log_info("   - Structure count: %d" % kb.get_structure_count())
		else:
			log_warning("   - get_structure_count() method missing")
	else:
		log_error("❌ KB (KnowledgeBase) not found")

	var model_switcher = get_node_or_null("/root/ModelSwitcherGlobal")
	if model_switcher:
		log_success("✅ ModelSwitcherGlobal loaded")
		if model_switcher.has_method("get_available_models"):
			var models = model_switcher.get_available_models()
			log_info("   - Available models: %s" % str(models))
		else:
			log_warning("   - get_available_models() method missing")
	else:
		log_error("❌ ModelSwitcherGlobal not found")

	var error_tracker = get_node_or_null("/root/ErrorTracker")
	if error_tracker:
		log_success("✅ ErrorTracker loaded")
	else:
		log_error("❌ ErrorTracker not found")

	var health_monitor = get_node_or_null("/root/HealthMonitor")
	if health_monitor:
		log_success("✅ HealthMonitor loaded")
	else:
		log_error("❌ HealthMonitor not found")

	var test_framework = get_node_or_null("/root/TestFramework")
	if test_framework:
		log_success("✅ TestFramework loaded")
	else:
		log_error("❌ TestFramework not found")

	var error_tracker = get_node_or_null("/root/ErrorTracker")
	if error_tracker:
		if error_tracker.has_method("log_error"):
			log_success("✅ ErrorTracker.log_error() available")
			# Test logging
			if error_tracker.has_method("log_info") or error_tracker.has_method("log_warning"):
				log_info("   - Testing error logging...")
				# We could test actual error logging here if needed
		else:
			log_error("❌ ErrorTracker.log_error() missing")

	# Test HealthMonitor
	var health_monitor = get_node_or_null("/root/HealthMonitor")
	if health_monitor:
		if health_monitor.has_method("get_system_health"):
			log_success("✅ HealthMonitor.get_system_health() available")
		else:
			log_error("❌ HealthMonitor.get_system_health() missing")

	# Test BrainVisDebugger
	var brain_debugger = get_node_or_null("/root/BrainVisDebugger")
	if brain_debugger:
		log_success("✅ BrainVisDebugger loaded")
		if brain_debugger.has_method("validate_all_models"):
			log_info("   - validate_all_models() available")
		else:
			log_warning("   - validate_all_models() method missing")
	else:
		log_error("❌ BrainVisDebugger not found")

	var model_switcher = get_node_or_null("/root/ModelSwitcherGlobal")
	if not model_switcher:
		log_error("❌ ModelSwitcher not available")
		return

	if model_switcher.has_method("get_available_models"):
		var models = model_switcher.get_available_models()
		log_info("   - Found %d models: %s" % [models.size(), str(models)])

		if models.size() > 0:
			log_info("   - Testing model switching...")
			for model_name in models:
				if model_switcher.has_method("switch_to_model"):
					var success = model_switcher.switch_to_model(model_name)
					if success:
						log_success("   ✅ Switched to: " + model_name)
					else:
						log_error("   ❌ Failed to switch to: " + model_name)
				else:
					log_error("   ❌ switch_to_model() method missing")
					break
		else:
			log_warning("   - No models available for testing")
	else:
		log_error("   ❌ get_available_models() method missing")

# === PARSER ERROR CHECKING COMMANDS ===

	var script_files = []
	_collect_script_files("res://", script_files)

	var errors = 0
	var total = script_files.size()

	for file_path in script_files:
		var script = load(file_path)
		if not script:
			log_error("❌ Parse error: %s" % file_path)
			errors += 1
		elif _args == "verbose":
			log_success("✅ OK: %s" % file_path.get_file())

	log_info("Parser check complete: %d/%d files passed" % [total - errors, total])
	if errors == 0:
		log_success("🎉 No parser errors found!")
	else:
		log_error("Found %d parser error(s)" % errors)

	var required_autoloads = [
		"KnowledgeService",
		"UIThemeManager",
		"ModelSwitcherGlobal",
		"StructureAnalysisManager",
		"DebugCmd"
	]

	var missing = []
	for autoload_name in required_autoloads:
		if Engine.has_singleton(autoload_name):
			log_success("✅ %s available" % autoload_name)
		else:
			log_error("❌ %s missing" % autoload_name)
			missing.append(autoload_name)

	if missing.size() == 0:
		log_success("✅ All dependencies available")
	else:
		log_error("Missing dependencies: %s" % str(missing))

	var scene_path = _args if _args != "" else "res://scenes/main/node_3d.tscn"

	log_info("🎬 Validating scene: %s" % scene_path)

	if not ResourceLoader.exists(scene_path):
		log_error("❌ Scene not found: %s" % scene_path)
		return

	var scene = load(scene_path)
	if not scene:
		log_error("❌ Failed to load scene: %s" % scene_path)
		return

	if not scene is PackedScene:
		log_error("❌ Not a scene file: %s" % scene_path)
		return

	var instance = scene.instantiate()
	if not instance:
		log_error("❌ Failed to instantiate scene")
		return

	log_success("✅ Scene validated successfully")

	# Check for required nodes in main scene
	if scene_path.ends_with("node_3d.tscn"):
		_validate_main_scene_structure(instance)

	instance.queue_free()

	var critical_resources = [
		"res://project.godot",
		"res://icon.svg",
		"res://assets/data/anatomical_data.json",
		"res://scenes/main/node_3d.tscn",
		"res://core/knowledge/KnowledgeService.gd",
		"res://core/models/ModelVisibilityManager.gd"
	]

	var missing = []
	for resource_path in critical_resources:
		if ResourceLoader.exists(resource_path):
			log_success("✅ Found: %s" % resource_path.get_file())
		else:
			log_error("❌ Missing: %s" % resource_path)
			missing.append(resource_path)

	if missing.size() == 0:
		log_success("✅ All critical resources found")
	else:
		log_error("Missing %d resource(s)" % missing.size())

	var test_path = _args if _args != "" else "res://scenes/main/node_3d.tscn"

	log_info("⚡ Testing preload: %s" % test_path)

	if not ResourceLoader.exists(test_path):
		log_error("❌ Resource not found: %s" % test_path)
		return

	var start_time = Time.get_ticks_msec()
	var resource = load(test_path)
	var load_time = Time.get_ticks_msec() - start_time

	if resource:
		log_success("✅ Loaded in %d ms" % load_time)
		log_info("   Type: %s" % resource.get_class())
	else:
		log_error("❌ Failed to load resource")

	var core_files = [
		"res://scenes/main/node_3d.gd",
		"res://core/knowledge/KnowledgeService.gd",
		"res://core/models/ModelVisibilityManager.gd",
		"res://ui/panels/UIThemeManager.gd"
	]

	var errors = 0
	for file_path in core_files:
		if ResourceLoader.exists(file_path):
			var script = load(file_path)
			if script:
				log_success("✅ %s" % file_path.get_file())
			else:
				log_error("❌ %s" % file_path.get_file())
				errors += 1
		else:
			log_error("❌ Missing: %s" % file_path.get_file())
			errors += 1

	if errors == 0:
		log_success("✅ All core files syntax OK")
	else:
		log_error("Found %d syntax error(s)" % errors)

	var version_info = Engine.get_version_info()
	log_info("   Version: %d.%d.%d %s" % [
		version_info.major,
		version_info.minor,
		version_info.patch,
		version_info.status
	])

	log_info("   Hash: %s" % version_info.hash)
	log_info("   Platform: %s" % OS.get_name())
	log_info("   Debug build: %s" % str(OS.is_debug_build()))

	# Check for Godot 4 features
	if version_info.major >= 4:
		log_success("✅ Godot 4+ detected")
	else:
		log_warning("⚠️ Godot 3 detected - may have compatibility issues")

	# Check renderer
	var renderer = RenderingServer.get_rendering_device()
	if renderer:
		log_success("✅ Vulkan renderer available")
	else:
		log_warning("⚠️ Using compatibility renderer")

# === HELPER FUNCTIONS ===

	var dir = DirAccess.open(dir_path)
	if not dir:
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if dir.current_is_dir() and not file_name.begins_with(".") and file_name != "tmp":
			_collect_script_files(dir_path + "/" + file_name, files)
		elif file_name.ends_with(".gd"):
			files.append(dir_path + "/" + file_name)

		file_name = dir.get_next()

	var required_nodes = {
		"Camera3D": "$Camera3D",
		"UI_Layer": "$UI_Layer",
		"BrainModel": "$BrainModel"
	}

	var missing = []
	for node_name in required_nodes:
		var path = required_nodes[node_name]
		if scene_instance.has_node(path):
			log_success("   ✅ %s found" % node_name)
		else:
			log_error("   ❌ %s missing at %s" % [node_name, path])
			missing.append(node_name)

	if missing.size() == 0:
		log_success("   ✅ Scene structure validated")
	else:
		log_error("   Missing nodes: %s" % str(missing))

# === QA VISUALIZATION COMMANDS ===

# Reference to debug visualizer
		var current = _qa_debug_viz._show_rays if "_show_rays" in _qa_debug_viz else false
		_qa_debug_viz.set_show_rays(not current)
		log_info("Ray visualization: %s" % ("ENABLED" if not current else "DISABLED"))

		var current = _qa_debug_viz._show_click_positions if "_show_click_positions" in _qa_debug_viz else false
		_qa_debug_viz.set_show_clicks(not current)
		log_info("Click markers: %s" % ("ENABLED" if not current else "DISABLED"))

		var status = _qa_debug_viz.get_status()
		log_info("=== QA Visualization Status ===")
		log_info("Enabled: %s" % str(status.get("enabled", false)))
		log_info("Bounds: %s (%d active)" % [str(status.get("bounds", false)), status.get("active_bounds", 0)])
		log_info("Rays: %s (%d active)" % [str(status.get("rays", false)), status.get("active_rays", 0)])
		log_info("Collisions: %s" % str(status.get("collisions", false)))
		log_info("Click Markers: %s (%d active)" % [str(status.get("clicks", false)), status.get("active_clicks", 0)])
		log_info("==============================")

	var main_scene = get_node_or_null("/root/Node3D")
	if not main_scene:
		log_error("Main scene not found - cannot create QA visualizer")
		return

	# Load and create visualizer
	var DebugVizScript = preprepreload("res://tests/qa/SelectionDebugVisualizer.gd")
	if not DebugVizScript:
		log_error("SelectionDebugVisualizer.gd not found")
		return

	_qa_debug_viz = DebugVizScript.new()
	main_scene.add_child(_qa_debug_viz)
	_qa_debug_viz.initialize(main_scene)

	log_success("QA Debug Visualizer created")

# === MULTI-SELECTION DEBUG COMMANDS ===
	var main_scene = get_node_or_null("/root/MainScene")
	if not main_scene:
		main_scene = get_node_or_null("/root/Node3D")

	if not main_scene:
		log_error("Main scene not found")
		return

	var selection_manager = main_scene.get_node_or_null("MultiStructureSelectionManager")
	if not selection_manager:
		log_error("MultiStructureSelectionManager not found")
		return

	log_success("✅ Multi-selection manager found")
	log_info("Current selections: %d" % selection_manager.get_selection_count())

	# Test selection states
	var selections = selection_manager.get_selection_info()
	for sel in selections:
		log_info("  - %s (%s)" % [sel["name"], sel["state"]])

	log_success("=== Test Complete ===")

	var main_scene = get_node_or_null("/root/MainScene")
	if not main_scene:
		main_scene = get_node_or_null("/root/Node3D")

	if not main_scene:
		log_error("Main scene not found")
		return

	var selection_manager = main_scene.get_node_or_null("MultiStructureSelectionManager")
	if not selection_manager:
		log_error("MultiStructureSelectionManager not found")
		return

	# Toggle debug mode (would need to implement this in MultiStructureSelectionManager)
	if selection_manager.has_method("toggle_debug_mode"):
		selection_manager.toggle_debug_mode()
		log_success("Multi-selection debug mode toggled")
	else:
		log_warning("Debug mode not implemented in MultiStructureSelectionManager")

	var main_scene = get_node_or_null("/root/MainScene")
	if not main_scene:
		main_scene = get_node_or_null("/root/Node3D")

	if not main_scene:
		log_error("Main scene not found")
		return

	var selection_manager = main_scene.get_node_or_null("MultiStructureSelectionManager")
	if not selection_manager:
		log_error("MultiStructureSelectionManager not found")
		return

	log_info("=== Multi-Selection State Report ===")

	var count = selection_manager.get_selection_count()
	log_info("Total selections: %d/%d" % [count, 3])

	var selections = selection_manager.get_selection_info()
	for i in range(selections.size()):
		var sel = selections[i]
		var state_color = ""
		match sel["state"]:
			0: state_color = "FFD700"  # Gold
			1: state_color = "00CED1"  # Turquoise
			2: state_color = "9370DB"  # Purple

		log_info("[color=#%s]%d. %s (%s)[/color]" % [state_color, i+1, sel["name"], sel["state"]])

	# Check comparison mode
	var mode = "SINGLE"
	if selection_manager.has_method("is_comparison_mode"):
		if selection_manager.is_comparison_mode():
			mode = "COMPARISON"
	elif selection_manager.get("_is_comparison_mode"):
		if selection_manager._is_comparison_mode:
			mode = "COMPARISON"

	log_info("Mode: " + mode)

	log_success("=== Report Complete ===")

	var main_scene = get_node_or_null("/root/MainScene")
	if not main_scene:
		main_scene = get_node_or_null("/root/Node3D")

	if not main_scene:
		log_error("Main scene not found")
		return

	var selection_manager = main_scene.get_node_or_null("MultiStructureSelectionManager")
	if not selection_manager:
		log_error("MultiStructureSelectionManager not found")
		return

	selection_manager.clear_all_selections()
	log_success("All selections cleared")

# === AI ASSISTANT TEST COMMANDS ===
	var ai_assistant = get_node_or_null("/root/AIAssistant")
	if not ai_assistant:
		log_error("AIAssistant service not found!")
		return

	log_success("✅ AIAssistant service found")

	# Show current status
	var status = ai_assistant.get_service_status()
	log_info("📊 Service Status:")
	for key in status:
		log_info("  - %s: %s" % [key, status[key]])

	# Connect to signals for test
	if not ai_assistant.response_received.is_connected(_on_ai_response_test):
		ai_assistant.response_received.connect(_on_ai_response_test)
	if not ai_assistant.error_occurred.is_connected(_on_ai_error_test):
		ai_assistant.error_occurred.connect(_on_ai_error_test)

	# Test with a simple question
	log_info("📝 Sending test question...")
	ai_assistant.update_context("Hippocampus")
	ai_assistant.ask_question("What is the main function of the hippocampus?")

	var gemini_service = get_node_or_null("/root/GeminiAI")
	if not gemini_service:
		log_error("GeminiAI service not found!")
		return

	log_success("✅ GeminiAI service found")

	# Check setup status
	if not gemini_service.check_setup_status():
		log_warning("⚠️ Gemini needs setup - use 'ai_gemini_setup' command")
		return

	log_success("✅ Gemini is configured and ready")

	# Check rate limit status
	var rate_status = gemini_service.get_rate_limit_status()
	log_info("📊 Rate Limit Status:")
	for key in rate_status:
		log_info("  - %s: %s" % [key, rate_status[key]])

	# Test AI Assistant with GEMINI_USER provider
	var ai_assistant = get_node_or_null("/root/AIAssistant")
	if ai_assistant:
		# Set provider to GEMINI_USER
		ai_assistant.ai_provider = AIAssistantService.AIProvider.GEMINI_USER
		log_info("🔄 Set AI provider to GEMINI_USER")

		# Connect signals if needed
		if not ai_assistant.response_received.is_connected(_on_ai_response_test):
			ai_assistant.response_received.connect(_on_ai_response_test)
		if not ai_assistant.error_occurred.is_connected(_on_ai_error_test):
			ai_assistant.error_occurred.connect(_on_ai_error_test)

		# Test question
		log_info("📝 Sending test question via Gemini...")
		ai_assistant.ask_question("Hello, this is a test. Please respond briefly.")
	else:
		log_error("AIAssistant not found for testing")

	var ai_assistant = get_node_or_null("/root/AIAssistant")
	if ai_assistant:
		log_success("✅ AIAssistant service: ACTIVE")
		var status = ai_assistant.get_service_status()
		for key in status:
			log_info("  - %s: %s" % [key, status[key]])
	else:
		log_error("❌ AIAssistant service: NOT FOUND")

	# Check GeminiAI
	var gemini_service = get_node_or_null("/root/GeminiAI")
	if gemini_service:
		log_success("✅ GeminiAI service: ACTIVE")
		if gemini_service.check_setup_status():
			log_info("  - Setup: COMPLETE")
			var rate_status = gemini_service.get_rate_limit_status()
			for key in rate_status:
				log_info("  - %s: %s" % [key, rate_status[key]])
		else:
			log_warning("  - Setup: INCOMPLETE (use 'ai_gemini_setup')")
	else:
		log_error("❌ GeminiAI service: NOT FOUND")

# Helper functions for AI testing
	var knowledge_service = SafeAutoloadAccess.get_autoload("KnowledgeService")
	if knowledge_service:
		log_success("✅ KnowledgeService retrieved successfully")
		log_info("  Type: %s" % knowledge_service.get_class())
	else:
		log_error("❌ Failed to get KnowledgeService")
	
	# Test 2: Get UIThemeManager
	log_info("\nTest 2: Getting UIThemeManager...")
	var theme_manager = SafeAutoloadAccess.get_autoload("UIThemeManager")
	if theme_manager:
		log_success("✅ UIThemeManager retrieved successfully")
		log_info("  Type: %s" % theme_manager.get_class())
	else:
		log_error("❌ Failed to get UIThemeManager")
	
	# Test 3: Try non-existent autoload
	log_info("\nTest 3: Getting non-existent autoload...")
	var non_existent = SafeAutoloadAccess.get_autoload("NonExistentAutoload")
	if non_existent:
		log_error("❌ Unexpected: Got a node for non-existent autoload")
	else:
		log_success("✅ Correctly returned null for non-existent autoload")
	
	# Test 4: Direct tree access comparison
	log_info("\nTest 4: Comparing with direct tree access...")
	var direct_ks = get_tree().root.get_node_or_null("/root/KnowledgeService")
	var safe_ks = SafeAutoloadAccess.get_autoload("KnowledgeService")
	if direct_ks == safe_ks:
		log_success("✅ SafeAutoloadAccess returns same node as direct access")
	else:
		log_error("❌ SafeAutoloadAccess returns different node than direct access")
	
	# Test 5: Check if SafeAutoloadAccess itself is available
	log_info("\nTest 5: Checking SafeAutoloadAccess autoload...")
	if Engine.has_singleton("SafeAutoloadAccess"):
		log_success("✅ SafeAutoloadAccess is registered as autoload")
	else:
		log_error("❌ SafeAutoloadAccess not found in autoloads")
	
	log_info("\n=== Test Complete ===")

var _qa_debug_viz: Node3D = null

func _ready() -> void:
	# Toggle debug mode
	register_command("debug_toggle", func():

func register_command(command_name: String, callback: Callable, description: String = "") -> void:
	registered_commands[command_name] = {
		"callback": callback,
		"description": description
	}
	print_debug("Registered command: " + command_name)

# Run a debug command
func run_command(command_string: String) -> void:
	# Add to history
	if command_string.strip_edges() != "":
		command_history.append(command_string)
		history_index = command_history.size()

	# Split command and args
func get_command_count() -> int:
	return registered_commands.size()

# Utility methods for logging - Using standard Godot logging
func log_error(message: String) -> void:
	push_error("[DebugCommands] " + message)

func log_success(message: String) -> void:
	if OS.is_debug_build():
		print("[DebugCommands] Success: " + message)

func log_info(message: String) -> void:
	if OS.is_debug_build():
		print("[DebugCommands] Info: " + message)

func log_warning(message: String) -> void:
	push_warning("[DebugCommands] " + message)

# Helper function to safely load VisualDebugger
func get_visual_debugger():
	return preprepreload("res://core/visualization/VisualDebugger.gd")

# AI test response handlers
func cmd_parser_check(_args: String = "") -> void:
	"""Check all scripts for parser errors"""
	log_info("🔍 Running parser error check...")

func cmd_dependency_check(_args: String = "") -> void:
	"""Validate all autoload dependencies"""
	log_info("🔗 Checking dependencies...")

func cmd_scene_validate(_args: String = "") -> void:
	"""Validate scene structure"""
func cmd_resource_check(_args: String = "") -> void:
	"""Check for missing resources"""
	log_info("📂 Checking critical resources...")

func cmd_preload_test(_args: String = "") -> void:
	"""Test resource preloading"""
func cmd_syntax_check(_args: String = "") -> void:
	"""Quick syntax validation"""
	log_info("📝 Quick syntax check...")

func cmd_godot_check(_args: String = "") -> void:
	"""Check Godot version and compatibility"""
	log_info("🎮 Godot Environment Check:")

func cmd_qa_viz_toggle(_args: String = "") -> void:
	"""Toggle QA debug visualization"""
	_ensure_qa_viz_exists()
	if _qa_debug_viz:
		_qa_debug_viz.toggle_debug_draw()

func cmd_qa_viz_bounds(args: String = "") -> void:
	"""Show structure bounds visualization"""
	if args.is_empty():
		log_error("Usage: qa_viz_bounds <structure_name>")
		return

	_ensure_qa_viz_exists()
	if _qa_debug_viz:
		_qa_debug_viz.show_structure_bounds(args)

func cmd_qa_viz_rays(_args: String = "") -> void:
	"""Toggle selection ray visualization"""
	_ensure_qa_viz_exists()
	if _qa_debug_viz:
func cmd_qa_viz_collisions(args: String = "") -> void:
	"""Show collision shapes"""
	_ensure_qa_viz_exists()
	if _qa_debug_viz:
		_qa_debug_viz.show_collision_shapes(args)

func cmd_qa_viz_clicks(_args: String = "") -> void:
	"""Toggle click position markers"""
	_ensure_qa_viz_exists()
	if _qa_debug_viz:
func cmd_qa_viz_status(_args: String = "") -> void:
	"""Show visualization status"""
	_ensure_qa_viz_exists()
	if _qa_debug_viz:
func cmd_multiselect_test():
	"""Test multi-selection system functionality"""
	log_info("=== Multi-Selection System Test ===")

	# Find selection manager
func cmd_multiselect_debug():
	"""Toggle multi-selection debug visualization"""
func cmd_multiselect_report():
	"""Show detailed multi-selection state"""
func cmd_multiselect_clear():
	"""Clear all multi-selections"""
func cmd_ai_test(_args: String = "") -> void:
	"""Test AI Assistant integration"""
	log_info("=== Testing AI Assistant Integration ===")

func cmd_ai_gemini_test(_args: String = "") -> void:
	"""Test Gemini AI integration specifically"""
	log_info("=== Testing Gemini AI Integration ===")

	# Check GeminiAI service
func cmd_ai_status(_args: String = "") -> void:
	"""Show detailed AI service status"""
	log_info("=== AI Services Status ===")

	# Check AIAssistant

func _execute_command(command_name: String, args: String) -> void:
func _print_help(command_name: String = "") -> void:
	if command_name.strip_edges() == "":
		log_info("Available commands: (Type 'help <command>' for details)")
		_list_commands()
		return

	if command_name == "help":
		log_info("help [command] - Display help for all commands or a specific command")
	elif command_name == "ls" or command_name == "list":
		log_info("ls/list - List all available commands")
	elif command_name == "history":
		log_info("history - Show command history")
	elif command_name == "clear":
		log_info("clear [history] - Clear console or command history")
	elif registered_commands.has(command_name):
func _list_commands() -> void:
func _show_history() -> void:
	log_info("Command history:")

	for i in range(command_history.size()):
		print("[" + str(i + 1) + "] " + command_history[i])

# Get count of registered commands
func _on_test_response(_question: String, response: String) -> void:
	log_success("AI Response: " + response.left(200) + ("..." if response.length() > 200 else ""))

func _on_test_error(error: String) -> void:
	log_error("AI Error: " + error)

# Register built-in commands
func _run_debug_tests():
	log_info("=== A1-NeuroVis Debug Test Suite ===")
	_test_autoloads()
	_test_debug_infrastructure()
	_test_model_switcher()
	log_success("=== Test Suite Complete ===")

func _test_autoloads():
	log_info("🔍 Testing Autoload Registration:")

func _test_debug_infrastructure():
	log_info("🧪 Testing Debug Infrastructure:")

	# Test ErrorTracker
func _test_model_switcher():
	log_info("🔄 Testing Model Switcher:")

func _collect_script_files(dir_path: String, files: Array) -> void:
	"""Recursively collect all GDScript files"""
func _validate_main_scene_structure(scene_instance: Node) -> void:
	"""Validate main scene has required nodes"""
	log_info("   🔍 Checking main scene structure...")

func _ensure_qa_viz_exists() -> void:
	"""Ensure QA debug visualizer exists"""
	if _qa_debug_viz:
		return

	# Find main scene
func _on_ai_response_test(question: String, response: String) -> void:
	log_success("✅ AI Response received!")
	log_info("❓ Question: %s" % question)
	log_info("💬 Response: %s" % (response.substr(0, 200) + "..." if response.length() > 200 else response))

func _on_ai_error_test(error: String) -> void:
	log_error("❌ AI Error: %s" % error)

# SafeAutoloadAccess test function
func _test_safe_autoload_access(_args: String = "") -> void:
	"""Test SafeAutoloadAccess.get_autoload() functionality"""
	log_info("=== Testing SafeAutoloadAccess.get_autoload() ===")
	
	# Test 1: Get KnowledgeService
	log_info("Test 1: Getting KnowledgeService...")
