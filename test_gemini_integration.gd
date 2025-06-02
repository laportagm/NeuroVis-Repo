extends SceneTree

## Test script for Gemini AI integration
## Run with: godot --headless --script test_gemini_integration.gd

# Test results
var test_results = {
    "total": 0,
    "passed": 0,
    "failed": 0,
    "errors": []
}

# Test completion tracking
var tests_complete = false
var timeout_timer = null

func _init():
    print("=== Gemini AI Integration Tests ===")
    
    # Set timeout for all tests
    timeout_timer = Timer.new()
    timeout_timer.one_shot = true
    timeout_timer.timeout.connect(_on_timeout)
    root.add_child(timeout_timer)
    timeout_timer.start(10.0)
    
    # Run tests
    test_autoloads()
    test_gemini_service_integration()
    
    # Mark tests as complete
    tests_complete = true
    _finish_tests()

func test_autoloads():
    print("\n--- Testing Autoloads ---")
    test_results.total += 1
    
    if Engine.has_singleton("GeminiAI"):
        print("✅ GeminiAI autoload is available")
        test_results.passed += 1
    else:
        print("❌ GeminiAI autoload is missing")
        test_results.failed += 1
        test_results.errors.append("GeminiAI autoload not found")
    
    test_results.total += 1
    if Engine.has_singleton("AIAssistant"):
        print("✅ AIAssistant autoload is available")
        test_results.passed += 1
    else:
        print("❌ AIAssistant autoload is missing")
        test_results.failed += 1
        test_results.errors.append("AIAssistant autoload not found")

func test_gemini_service_integration():
    print("\n--- Testing Gemini Integration ---")
    
    # Test GeminiAIService class exists
    test_results.total += 1
    if ClassDB.class_exists("GeminiAIService") or ResourceLoader.exists("res://core/ai/GeminiAIService.gd"):
        print("✅ GeminiAIService class is available")
        test_results.passed += 1
    else:
        print("❌ GeminiAIService class is missing")
        test_results.failed += 1
        test_results.errors.append("GeminiAIService class not found")
    
    # Test AIAssistant has Gemini provider
    test_results.total += 1
    var script_path = "res://core/ai/AIAssistantService.gd"
    if ResourceLoader.exists(script_path):
        var script = load(script_path)
        if script and script.has_script_method("_send_user_gemini_request"):
            print("✅ AIAssistantService has Gemini integration method")
            test_results.passed += 1
        else:
            print("❌ AIAssistantService missing Gemini integration method")
            test_results.failed += 1
            test_results.errors.append("_send_user_gemini_request method not found")
    else:
        print("❌ AIAssistantService script not found")
        test_results.failed += 1
        test_results.errors.append("AIAssistantService script not found")
    
    # Test UI components exist
    test_results.total += 1
    if ResourceLoader.exists("res://ui/panels/GeminiSetupDialog.gd") and ResourceLoader.exists("res://ui/components/controls/GeminiModelSelector.gd"):
        print("✅ Gemini UI components are available")
        test_results.passed += 1
    else:
        print("❌ One or more Gemini UI components are missing")
        test_results.failed += 1
        test_results.errors.append("UI components not found")

func _finish_tests():
    print("\n=== Test Results ===")
    print("Total tests: " + str(test_results.total))
    print("Passed: " + str(test_results.passed))
    print("Failed: " + str(test_results.failed))
    
    if test_results.errors.size() > 0:
        print("\nErrors:")
        for error in test_results.errors:
            print("- " + error)
    
    if test_results.passed == test_results.total:
        print("\n✅ All tests passed!")
    else:
        print("\n❌ Some tests failed. See errors above.")
    
    # Exit with success if all tests passed
    quit(0 if test_results.passed == test_results.total else 1)

func _on_timeout():
    if not tests_complete:
        print("\n❌ Tests timed out")
        test_results.failed += 1
        test_results.errors.append("Test execution timed out")
        _finish_tests()