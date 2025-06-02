extends Node

# ProjectProfiler - Placeholder implementation
# Simplified profiler without static function dependencies

static var instance: Node
var performance_data = {}

func _init():
	instance = self

func _ready() -> void:
	print("[ProjectProfiler] Placeholder initialized")
	name = "ProjectProfiler"

static func start_timer(operation_name: String):
	pass  # Placeholder - no operation

static func end_timer(operation_name: String):
	pass  # Placeholder - no operation

static func print_performance_report():
	print("[ProjectProfiler] Performance report placeholder")

static func clear_data():
	pass  # Placeholder - no operation
