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
	_test_config_manager()

	# Test AIProviderRegistry
	_test_provider_registry()

	# Test AIIntegrationManager
	_test_integration_manager()

	print("\n=== TEST COMPLETE ===")
	get_tree().quit()


func _test_config_manager() -> void:
	print("\n[TEST] AIConfigurationManager")

	var config_manager = get_node("/root/AIConfig") as AIConfigurationManager
	if config_manager:
		print("✅ AIConfigurationManager autoload found")
		if config_manager.has_method("get_default_provider"):
			print("  Default provider: " + config_manager.get_default_provider())
		if config_manager.has_method("get_all_providers"):
			print("  Available providers: " + str(config_manager.get_all_providers()))
	else:
		print("❌ AIConfigurationManager autoload not found")


func _test_provider_registry() -> void:
	print("\n[TEST] AIProviderRegistry")

	var registry = get_node("/root/AIRegistry") as AIProviderRegistry
	if registry:
		print("✅ AIProviderRegistry autoload found")
		if registry.has_method("get_active_provider_id"):
			print("  Active provider: " + registry.get_active_provider_id())
		if registry.has_method("get_all_provider_ids"):
			print("  Available providers: " + str(registry.get_all_provider_ids()))

		# Test getting a provider
		var provider = registry.get_active_provider()
		if provider:
			print("  Active provider object found: " + str(provider.get_class()))
		else:
			print("❌ Active provider object not found")
	else:
		print("❌ AIProviderRegistry autoload not found")


func _test_integration_manager() -> void:
	print("\n[TEST] AIIntegrationManager")

	var integration = get_node("/root/AIIntegration") as AIIntegrationManager
	if integration:
		print("✅ AIIntegrationManager autoload found")
		if integration.has_method("get_active_provider_id"):
			print("  Active provider: " + integration.get_active_provider_id())
		if integration.has_method("get_available_providers"):
			print("  Available providers: " + str(integration.get_available_providers()))
	else:
		print("❌ AIIntegrationManager autoload not found")
