# Test script to help debug the performance freeze
# Attach this to a simple Node3D scene to test the robust initialization

extends Node3D

var performance_debugger: PerformanceDebugger


var test_camera = Camera3D.new()
add_child(test_camera)
await get_tree().process_frame

# Test UI layer creation
var test_ui = CanvasLayer.new()
add_child(test_ui)
await get_tree().process_frame

# Test label creation
var test_label = Label.new()
test_ui.add_child(test_label)
await get_tree().process_frame

performance_debugger.end_function_timing("test_core_initialization")


var selection_manager = SelectionManager.new()
add_child(selection_manager)
await get_tree().process_frame

# Test CameraController creation
var camera_controller = CameraController.new()
add_child(camera_controller)
await get_tree().process_frame

# Test initialization
var camera = get_children().filter(func(child): return child is Camera3D)[0]
var test_signal_emitter = Node.new()
add_child(test_signal_emitter)

# Add a test signal
test_signal_emitter.add_user_signal("test_signal")
test_signal_emitter.test_signal.connect(_on_test_signal)

# Emit the signal
test_signal_emitter.test_signal.emit()
await get_tree().process_frame

performance_debugger.end_function_timing("test_signal_connections")


var child = get_child(i)

func _ready():
	print("[TEST] Starting debug test scene...")

	# Create performance debugger
	performance_debugger = PerformanceDebugger.new()
	add_child(performance_debugger)

	# Start monitoring
	performance_debugger.start_function_timing("_ready")

	# Connect to performance signals
	performance_debugger.performance_freeze_detected.connect(_on_freeze_detected)
	performance_debugger.function_taking_too_long.connect(_on_slow_function)

	# Test each initialization step with timing
	print("[TEST] Testing core initialization...")
	await test_core_initialization()

	print("[TEST] Testing component creation...")
	await test_component_creation()

	print("[TEST] Testing signal connections...")
	await test_signal_connections()

	performance_debugger.end_function_timing("_ready")
	print("[TEST] Debug test completed successfully!")


func test_core_initialization():
	performance_debugger.start_function_timing("test_core_initialization")

	# Test camera creation
	print("[TEST] Creating camera...")
func test_component_creation():
	performance_debugger.start_function_timing("test_component_creation")

	# Test SelectionManager creation
	print("[TEST] Creating SelectionManager...")
func test_signal_connections():
	performance_debugger.start_function_timing("test_signal_connections")

	# Test signal connection without infinite loops
	print("[TEST] Testing signal connections...")

func emergency_break():
	if performance_debugger:
		performance_debugger.emergency_break()

func _fix_orphaned_code():
	print("[TEST] Creating UI layer...")
func _fix_orphaned_code():
	print("[TEST] Creating label...")
func _fix_orphaned_code():
	print("[TEST] Creating CameraController...")
func _fix_orphaned_code():
	print("[TEST] Initializing CameraController...")
func _fix_orphaned_code():
	if camera:
		camera_controller.initialize(camera)
		await get_tree().process_frame

		performance_debugger.end_function_timing("test_component_creation")


func _fix_orphaned_code():
	print("[TEST] Child ", i, ": ", child.get_class(), " - ", child.name)


func _on_test_signal():
	print("[TEST] Test signal received successfully")


func _on_freeze_detected(duration: float, last_function: String):
	print("[TEST] FREEZE DETECTED! Duration: ", duration, "s, Last function: ", last_function)

	# Emergency diagnostics
	print("[TEST] Memory usage: ", performance_debugger.get_memory_usage())
	print("[TEST] Children count: ", get_child_count())

	# List all children
	for i in range(get_child_count()):
func _on_slow_function(function_name: String, duration: float):
	print("[TEST] Slow function detected: ", function_name, " took ", duration, "s")


	# Emergency break function - call this from console if needed
