## test_ai_integration.gd
## Test script for the new AI integration architecture
##
## This script tests the new AI provider registry, configuration manager,
## and integration manager to ensure they work correctly together.
##
## @tutorial: AI Integration Testing Guide
## @version: 1.0

@tool
extends Node

# Load required scripts
const AIConfigManagerScript = preload("res://core/ai/config/AIConfigurationManager.gd")
const AIProviderRegistryScript = preload("res://core/ai/AIProviderRegistry.gd")
const AIIntegrationManagerScript = preload("res://core/ai/AIIntegrationManager.gd")
const MockAIProviderScript = preload("res://core/ai/providers/MockAIProvider.gd")
const GeminiAIProviderScript = preload("res://core/ai/providers/GeminiAIProvider.gd")

# Core AI components
var ai_config
var ai_registry
var ai_integration

# Mock setup for testing
var test_ui_layer: Control
var debug_label: Label

# Test states
enum TestState {
    INITIALIZE,
    REGISTER_PROVIDERS,
    TEST_MOCK_PROVIDER,
    TEST_GEMINI_PROVIDER,
    TEST_PROVIDER_SWITCH,
    TEST_CONFIGURATION,
    TEST_STRUCTURE_CONTEXT,
    CLEANUP
}

var current_state: TestState = TestState.INITIALIZE
var test_complete: bool = false
var test_results: Dictionary = {}

func _ready() -> void:
    """Initialize test environment"""
    print("\n=== STARTING AI INTEGRATION TESTS ===")
    
    # Create UI for displaying test results
    _setup_test_ui()
    
    # Start the test sequence
    _run_tests()

func _setup_test_ui() -> void:
    """Setup a simple UI for test results"""
    test_ui_layer = Control.new()
    test_ui_layer.set_anchors_preset(Control.PRESET_FULL_RECT)
    add_child(test_ui_layer)
    
    var panel = PanelContainer.new()
    panel.set_anchors_preset(Control.PRESET_CENTER)
    panel.custom_minimum_size = Vector2(600, 400)
    test_ui_layer.add_child(panel)
    
    var vbox = VBoxContainer.new()
    vbox.add_theme_constant_override("separation", 20)
    panel.add_child(vbox)
    
    var title = Label.new()
    title.text = "AI Integration Test"
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 24)
    vbox.add_child(title)
    
    debug_label = Label.new()
    debug_label.text = "Initializing tests..."
    debug_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
    debug_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
    debug_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    debug_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
    vbox.add_child(debug_label)
    
    var button_container = HBoxContainer.new()
    button_container.alignment = BoxContainer.ALIGNMENT_CENTER
    vbox.add_child(button_container)
    
    var close_button = Button.new()
    close_button.text = "Close"
    close_button.custom_minimum_size = Vector2(100, 40)
    close_button.pressed.connect(func(): queue_free())
    button_container.add_child(close_button)

func _run_tests() -> void:
    """Run the test sequence"""
    # Start with initialization
    _test_initialize()
    
    # Schedule next tests with delays between them
    get_tree().create_timer(0.5).timeout.connect(_test_register_providers)
    get_tree().create_timer(1.0).timeout.connect(_test_mock_provider)
    get_tree().create_timer(2.0).timeout.connect(_test_provider_switch)
    get_tree().create_timer(2.5).timeout.connect(_test_configuration)
    get_tree().create_timer(3.0).timeout.connect(_test_structure_context)
    get_tree().create_timer(4.0).timeout.connect(_finish_tests)

func _log_result(test_name: String, success: bool, message: String = "") -> void:
    """Log a test result"""
    var result = "✅ PASS" if success else "❌ FAIL"
    print("[TEST] %s: %s %s" % [test_name, result, message])
    
    test_results[test_name] = {
        "success": success,
        "message": message
    }
    
    # Update UI
    _update_debug_label()

func _update_debug_label() -> void:
    """Update the debug label with current test results"""
    var text = "=== AI INTEGRATION TEST RESULTS ===\n\n"
    
    for test_name in test_results:
        var result = test_results[test_name]
        var status = "✅ PASS" if result.success else "❌ FAIL"
        text += "%s: %s\n" % [test_name, status]
        if not result.message.is_empty():
            text += "   %s\n" % result.message
    
    if test_complete:
        text += "\n=== TEST COMPLETE ==="
    
    debug_label.text = text

# === TEST IMPLEMENTATIONS ===
func _test_initialize() -> void:
    """Test initializing the AI components"""
    print("[TEST] Initializing AI components...")
    
    # Create and initialize components
    ai_config = AIConfigManagerScript.new()
    ai_registry = AIProviderRegistryScript.new()
    ai_integration = AIIntegrationManagerScript.new()
    
    ai_config.name = "AIConfig"
    ai_registry.name = "AIRegistry"
    ai_integration.name = "AIIntegration"
    
    add_child(ai_config)
    add_child(ai_registry)
    add_child(ai_integration)
    
    # Initialize
    ai_config.initialize()
    ai_registry.initialize()
    ai_integration.initialize()
    
    # Check initialization
    var config_init = ai_config.has_method("get_provider_config")
    var registry_init = ai_registry.has_method("get_provider")
    var integration_init = ai_integration.has_method("ask_question")
    
    var success = config_init and registry_init and integration_init
    var message = ""
    if not success:
        message = "Failed components: %s%s%s" % [
            "Config " if not config_init else "",
            "Registry " if not registry_init else "",
            "Integration " if not integration_init else ""
        ]
    
    _log_result("Initialize Components", success, message)
    current_state = TestState.INITIALIZE

func _test_register_providers() -> void:
    """Test registering AI providers"""
    print("[TEST] Registering AI providers...")
    
    # Check if MockAIProvider is already registered
    var initial_providers = ai_registry.get_all_provider_ids()
    var mock_exists = initial_providers.has("mock_provider")
    
    # Check if gemini provider is already registered (by AIProviderRegistry initialization)
    var gemini_registered = false
    if not ai_registry.get_provider("gemini"):
        # Create and register GeminiAIProvider only if not already registered
        var gemini_provider = GeminiAIProviderScript.new()
        gemini_provider.name = "GeminiAI"
        add_child(gemini_provider)
        
        gemini_registered = ai_registry.register_provider("gemini", gemini_provider)
    else:
        # Gemini already registered during initialization
        gemini_registered = true
        print("[TEST] Gemini provider already registered by AIProviderRegistry")
    
    # Check results
    var providers = ai_registry.get_all_provider_ids()
    var success = gemini_registered and providers.has("gemini")
    var message = "Registered providers: %s" % str(providers)
    
    _log_result("Register Providers", success, message)
    current_state = TestState.REGISTER_PROVIDERS

func _test_mock_provider() -> void:
    """Test using the mock provider"""
    print("[TEST] Testing mock provider...")
    
    # Set mock provider as active
    ai_registry.set_active_provider("mock_provider")
    
    # Verify active provider
    var active_id = ai_registry.get_active_provider_id()
    var success = active_id == "mock_provider"
    
    # Get the mock provider
    var mock_provider = ai_registry.get_active_provider()
    if mock_provider:
        # Set a test structure
        if mock_provider.has_method("set_current_structure"):
            mock_provider.set_current_structure("hippocampus")
        
        # Test asking a question
        mock_provider.response_received.connect(func(response):
            var has_hippocampus = "hippocampus" in response.to_lower()
            _log_result("Mock Provider Response", has_hippocampus, 
                "Response %s mention hippocampus" % ("did" if has_hippocampus else "did not"))
        )
        
        mock_provider.ask_question("What does this structure do?")
    else:
        success = false
    
    _log_result("Activate Mock Provider", success, "Active provider: %s" % active_id)
    current_state = TestState.TEST_MOCK_PROVIDER

func _test_provider_switch() -> void:
    """Test switching between providers"""
    print("[TEST] Testing provider switching...")
    
    # First ensure the gemini provider exists
    var providers = ai_registry.get_all_provider_ids()
    if not providers.has("gemini"):
        _log_result("Switch Provider (Registry)", false, "Gemini provider not found in registry. Available: %s" % str(providers))
        current_state = TestState.TEST_PROVIDER_SWITCH
        return
    
    # Test switching via registry
    var switch_success = ai_registry.set_active_provider("gemini")
    var active_id = ai_registry.get_active_provider_id()
    var provider = ai_registry.get_active_provider()
    
    var success = switch_success and active_id == "gemini" and provider != null
    _log_result("Switch Provider (Registry)", success, "Active provider: %s" % active_id)
    
    # Test switching via integration manager
    var integration_switch = ai_integration.set_active_provider("mock_provider")
    var integration_active = ai_integration.get_active_provider_id()
    
    success = integration_switch and integration_active == "mock_provider"
    _log_result("Switch Provider (Integration)", success, "Integration active provider: %s" % integration_active)
    
    current_state = TestState.TEST_PROVIDER_SWITCH

func _test_configuration() -> void:
    """Test configuration management"""
    print("[TEST] Testing configuration management...")
    
    # Test saving provider config
    var mock_config = {
        "provider": "mock_provider",
        "test_value": "test"
    }
    ai_config.set_provider_config("mock_provider", mock_config)
    
    # Test retrieving provider config
    var retrieved_config = ai_config.get_provider_config("mock_provider")
    var config_success = retrieved_config.has("test_value") and retrieved_config.test_value == "test"
    
    _log_result("Configuration Management", config_success, 
        "Retrieved config %s correct test_value" % ("has" if config_success else "missing"))
    
    current_state = TestState.TEST_CONFIGURATION

func _test_structure_context() -> void:
    """Test structure context handling"""
    print("[TEST] Testing structure context handling...")
    
    # Set structure via integration manager
    ai_integration.set_current_structure("amygdala")
    
    # Check if structure was set
    var structure = ai_integration.get_current_structure()
    var success = structure == "amygdala"
    
    _log_result("Structure Context", success, "Current structure: %s" % structure)
    
    current_state = TestState.TEST_STRUCTURE_CONTEXT

func _finish_tests() -> void:
    """Complete the test sequence"""
    print("[TEST] Completing tests...")
    
    # Calculate overall success
    var total_tests = test_results.size()
    var passed_tests = 0
    
    for test_name in test_results:
        if test_results[test_name].success:
            passed_tests += 1
    
    var success_rate = float(passed_tests) / total_tests
    var overall_success = success_rate > 0.8  # 80% success rate required
    
    _log_result("Overall Test Results", overall_success, 
        "Passed %d/%d tests (%.1f%%)" % [passed_tests, total_tests, success_rate * 100])
    
    test_complete = true
    _update_debug_label()
    
    print("=== AI INTEGRATION TESTS COMPLETED ===")
    current_state = TestState.CLEANUP
    
    # Clean up providers
    # We don't actually remove them here to avoid breaking any connections
    # In a real test, you might want to free them properly