## test_ai_config.gd
## Test script for verifying AI configuration and integration
##
## This script tests that the AIConfigurationManager, AIProviderRegistry
## and AIIntegrationManager are working properly together.
##
## @version: 1.0

extends Node

func _ready() -> void:
    print("\n=== TESTING AI CONFIGURATION AND INTEGRATION ===")
    
    # Test AIConfigurationManager
    print("\n[TEST] AIConfigurationManager")
    var config_manager = get_node("/root/AIConfig") as AIConfigurationManager
    if config_manager:
        print("✅ AIConfigurationManager autoload found")
        print("  Initialized: " + str(config_manager._is_initialized))
        print("  Default provider: " + config_manager.get_default_provider())
        print("  Available providers: " + str(config_manager.get_all_providers()))
    else:
        print("❌ AIConfigurationManager autoload not found")
    
    # Test AIProviderRegistry
    print("\n[TEST] AIProviderRegistry")
    var registry = get_node("/root/AIRegistry") as AIProviderRegistry
    if registry:
        print("✅ AIProviderRegistry autoload found")
        print("  Initialized: " + str(registry._is_initialized))
        print("  Active provider: " + registry.get_active_provider_id())
        print("  Available providers: " + str(registry.get_all_provider_ids()))
        
        # Test getting a provider
        var provider = registry.get_active_provider()
        if provider:
            print("  Active provider object found: " + str(provider.get_class()))
        else:
            print("❌ Active provider object not found")
    else:
        print("❌ AIProviderRegistry autoload not found")
    
    # Test AIIntegrationManager
    print("\n[TEST] AIIntegrationManager")
    var integration = get_node("/root/AIIntegration") as AIIntegrationManager
    if integration:
        print("✅ AIIntegrationManager autoload found")
        print("  Initialized: " + str(integration._is_initialized))
        print("  Active provider: " + integration.get_active_provider_id())
        print("  Available providers: " + str(integration.get_available_providers()))
    else:
        print("❌ AIIntegrationManager autoload not found")
    
    print("\n=== TEST COMPLETE ===")
    get_tree().quit()