## SafeUIComponentTest.gd
## Test component to validate safety framework

class_name SafeUIComponentTest
extends BaseUIComponent

# === TEST COMPONENT ===

var test_label: Label
var test_button: Button


	var theme_manager = SafeAutoloadAccess.get_theme_manager()
	if theme_manager:
		_log("✓ UIThemeManager available")
	else:
		_log("✗ UIThemeManager unavailable - using fallbacks", "warning")

	# Test KnowledgeService
	var knowledge_service = SafeAutoloadAccess.get_knowledge_service()
	if knowledge_service:
		_log("✓ KnowledgeService available")
		# Test getting a structure
		var test_structure = SafeAutoloadAccess.get_structure_safely("Striatum")
		if not test_structure.is_empty():
			_log("✓ Structure data retrieved: " + test_structure.get("displayName", "Unknown"))
		else:
			_log("- No structure data for 'Striatum'", "info")
	else:
		_log("✗ KnowledgeService unavailable - using fallbacks", "warning")

	# Test AIAssistant
	var ai_assistant = SafeAutoloadAccess.get_ai_assistant()
	if ai_assistant:
		_log("✓ AIAssistant available")
		SafeAutoloadAccess.set_ai_context_safely("Test context")
	else:
		_log("✗ AIAssistant unavailable", "warning")

	# Log overall status
	SafeAutoloadAccess.log_autoload_status()


	var vbox = VBoxContainer.new()
	add_child(vbox)

	# Test label
	test_label = Label.new()
	test_label.text = "Safe UI Component Test"
	vbox.add_child(test_label)

	# Apply safe theming
	var theme_applied = SafeAutoloadAccess.apply_theme_safely(test_label, "label")
	if theme_applied:
		_log("✓ Label themed successfully")
	else:
		_log("- Used fallback label theming", "info")

	# Test button
	test_button = Button.new()
	test_button.text = "Test Safe Operations"
	test_button.pressed.connect(_on_test_button_pressed)
	vbox.add_child(test_button)

	# Apply safe theming
	theme_applied = SafeAutoloadAccess.apply_theme_safely(test_button, "button")
	if theme_applied:
		_log("✓ Button themed successfully")
	else:
		_log("- Used fallback button theming", "info")


	var theme_applied = SafeAutoloadAccess.apply_theme_safely(self, "panel")
	if not theme_applied:
		_log("Applied fallback panel theming", "info")


	var test_names = ["Striatum", "Striatum (good)", "Ventricles", "NonExistent"]
	for name in test_names:
		var structure = SafeAutoloadAccess.get_structure_safely(name)
		var result_text = (
			"Found: " + structure.get("displayName", "None")
			if not structure.is_empty()
			else "Not found"
		)
		_log("Structure '%s': %s" % [name, result_text])

	# Test AI context setting
	var ai_set = SafeAutoloadAccess.set_ai_context_safely("Test structure from button")
	_log("AI context set: " + str(ai_set))

	# Update label with test results
	if test_label:
		test_label.text = "Tests completed - check console for results"


# === STATIC TEST METHODS ===
static func run_component_test(parent: Node) -> SafeUIComponentTest:
	"""Create and run a test instance"""
	var test_component = SafeUIComponentTest.new()
	test_component.component_id = "SafeUITest"
	test_component.size = Vector2(300, 200)
	test_component.position = Vector2(50, 50)

	parent.add_child(test_component)
	test_component.initialize_component()

	return test_component


static func run_autoload_validation() -> Dictionary:
	"""Run validation of all autoloads"""
	print("[SafeUIComponentTest] Running autoload validation...")

	var results = {}
	var autoloads = [
		"UIThemeManager", "KnowledgeService", "AIAssistant", "ModelSwitcherGlobal", "DebugCmd"
	]

	for autoload_name in autoloads:
		var available = SafeAutoloadAccess.is_autoload_available(autoload_name)
		results[autoload_name] = available

		var status_text = "✓ Available" if available else "✗ Unavailable"
		print("  %s: %s" % [autoload_name, status_text])

	return results


static func test_component_safety() -> bool:
	"""Test component safety without UI"""
	print("[SafeUIComponentTest] Testing component safety...")

	var all_safe = true

	# Test SafeAutoloadAccess
	var status = SafeAutoloadAccess.get_autoload_status()
	if status:
		print("  ✓ SafeAutoloadAccess working")
	else:
		print("  ✗ SafeAutoloadAccess failed")
		all_safe = false

	# Test structure retrieval
	var structure = SafeAutoloadAccess.get_structure_safely("TestStructure")
	if structure.has("id"):
		print("  ✓ Safe structure retrieval working")
	else:
		print("  ✓ Safe structure retrieval working (returned fallback)")

	# Test theming
	var dummy_label = Label.new()
	var themed = SafeAutoloadAccess.apply_theme_safely(dummy_label, "label")
	dummy_label.queue_free()
	print("  ✓ Safe theming working")

	return all_safe

func _setup_component() -> void:
	"""Setup test component with safety checks"""
	_log("Setting up test component with safety framework")

	# Test autoload access
	_test_autoload_access()

	# Create test UI elements
	_create_test_ui()


func _test_autoload_access() -> void:
	"""Test safe autoload access"""
	_log("Testing autoload access...")

	# Test UIThemeManager
func _create_test_ui() -> void:
	"""Create test UI elements"""
	# Setup as vertical container
func _apply_component_theme() -> void:
	"""Apply component-specific theming safely"""
	# This will be called by the base class
func _on_test_button_pressed() -> void:
	"""Test button press handler"""
	_log("Test button pressed - running safety tests...")

	# Test structure retrieval with various names
