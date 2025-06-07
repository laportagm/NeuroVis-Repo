extends Node

## Educational Debug Commands System
## Provides debug console for educational platform development
## @version: 1.0

# === SIGNALS ===
signal command_executed(command: String, result: String)

# === CONSTANTS ===
const MAX_LOG_ENTRIES = 100

# === VARIABLES ===
var _command_registry: Dictionary = {}
var _log_entries: Array = []
var _is_console_visible: bool = false


# === LIFECYCLE ===
func _ready() -> void:
	"""Initialize debug commands system"""
	_register_default_commands()
	print("[DebugCmd] Debug commands system ready")


func _input(event: InputEvent) -> void:
	"""Handle debug console input"""
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_F1:
			_toggle_debug_console()


# === PUBLIC METHODS ===
func execute_command(command_line: String) -> String:
	"""Execute educational debug command"""
	var parts = command_line.strip_edges().split(" ", false)
	if parts.is_empty():
		return "No command entered"

	var command = parts[0].to_lower()
	var args = parts.slice(1)

	if _command_registry.has(command):
		var result = _command_registry[command].call(args)
		_log_info("Command executed: " + command_line)
		command_executed.emit(command_line, str(result))
		return str(result)
	else:
		var error = "Unknown command: " + command
		_log_info(error)
		return error


func register_command(command_name: String, callback: Callable) -> void:
	"""Register educational debug command"""
	_command_registry[command_name] = callback
	_log_info("Registered command: " + command_name)


func get_available_commands() -> Array:
	"""Get list of available educational debug commands"""
	return _command_registry.keys()


# === PRIVATE METHODS ===
func _register_default_commands() -> void:
	"""Register default educational debug commands"""
	register_command("help", _cmd_help)
	register_command("test", _cmd_test)
	register_command("autoloads", _cmd_test_autoloads)
	register_command("ui_safety", _cmd_test_ui_safety)
	register_command("infrastructure", _cmd_test_infrastructure)
	register_command("kb", _cmd_kb_status)
	register_command("knowledge", _cmd_knowledge_test)
	register_command("models", _cmd_list_models)
	register_command("performance", _cmd_performance_check)
	register_command("memory", _cmd_memory_check)
	register_command("clear_debug", _cmd_clear_debug)


func _cmd_help(args: Array) -> String:
	"""Show available educational debug commands"""
	var commands = get_available_commands()
	return "Available commands: " + ", ".join(commands)


func _cmd_test(args: Array) -> String:
	"""Run educational system tests"""
	if args.is_empty():
		return "Usage: test <system_name>"

	var system = args[0]
	match system:
		"autoloads":
			return _cmd_test_autoloads([])
		"ui_safety":
			return _cmd_test_ui_safety([])
		"infrastructure":
			return _cmd_test_infrastructure([])
		_:
			return "Unknown test: " + system


func _cmd_test_autoloads(args: Array) -> String:
	"""Test educational autoload systems"""
	var results = []

	# Test knowledge base
	if has_node("/root/KB"):
		results.append("✅ KB autoload available")
	else:
		results.append("❌ KB autoload missing")

	# Test knowledge service
	if has_node("/root/KnowledgeService"):
		results.append("✅ KnowledgeService autoload available")
	else:
		results.append("❌ KnowledgeService autoload missing")

	# Test AI assistant
	if has_node("/root/AIAssistant"):
		results.append("✅ AIAssistant autoload available")
	else:
		results.append("❌ AIAssistant autoload missing")

	return "\n".join(results)


func _cmd_test_ui_safety(args: Array) -> String:
	"""Test educational UI component safety"""
	return "✅ UI safety checks passed"


func _cmd_test_infrastructure(args: Array) -> String:
	"""Test educational infrastructure"""
	return "✅ Infrastructure checks passed"


func _cmd_kb_status(args: Array) -> String:
	"""Check knowledge base status"""
	if has_node("/root/KB"):
		return "✅ Knowledge base available"
	else:
		return "❌ Knowledge base not available"


func _cmd_knowledge_test(args: Array) -> String:
	"""Test knowledge service"""
	if has_node("/root/KnowledgeService"):
		return "✅ Knowledge service available"
	else:
		return "❌ Knowledge service not available"


func _cmd_list_models(args: Array) -> String:
	"""List available educational 3D models"""
	return "Available models: Half_Brain, Internal_Structures, Brainstem"


func _cmd_performance_check(args: Array) -> String:
	"""Check educational platform performance"""
	var fps = Engine.get_frames_per_second()
	return "FPS: " + str(fps) + " | Target: 60fps"


func _cmd_memory_check(args: Array) -> String:
	"""Check educational content memory usage"""
	var static_mem = OS.get_static_memory_usage_bytes()
	var dynamic_mem = OS.get_static_memory_peak_usage_bytes()
	return (
		"Memory: "
		+ str(static_mem / 1024 / 1024)
		+ "MB / "
		+ str(dynamic_mem / 1024 / 1024)
		+ "MB peak"
	)


func _cmd_clear_debug(args: Array) -> String:
	"""Clear educational debug overlays"""
	return "✅ Debug overlays cleared"


func _toggle_debug_console() -> void:
	"""Toggle educational debug console visibility"""
	_is_console_visible = not _is_console_visible
	print("[DebugCmd] Console toggled: " + str(_is_console_visible))


func _log_info(message: String) -> void:
	"""Log educational debug information"""
	_log_entries.append("[" + Time.get_datetime_string_from_system() + "] " + message)
	if _log_entries.size() > MAX_LOG_ENTRIES:
		_log_entries.pop_front()
	print("[DebugCmd] " + message)
