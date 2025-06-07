# NeuroVis AI Architecture Guide

## Overview

This document describes the modular AI architecture implemented in NeuroVis. The architecture follows clean separation of concerns with a flexible provider-based approach that makes it easy to swap between different AI services while maintaining the educational focus of the platform.

## Design Goals

1. **Modularity**: Separate AI concerns into cohesive modules with clear responsibilities
2. **Extensibility**: Make it easy to add new AI providers or models
3. **Configurability**: Centralize configuration management
4. **Maintainability**: Reduce coupling between components for easier maintenance
5. **Testability**: Support isolated testing of components
6. **Educational Context**: Maintain educational focus in AI interactions
7. **Security**: Handle API keys and credentials securely

## Architecture Components

### Core Components

1. **AIProviderInterface**: A common interface that all AI providers must implement
2. **AIProviderRegistry**: Service locator pattern implementation for managing AI providers
3. **AIConfigurationManager**: Centralized configuration management for AI providers
4. **AIIntegrationManager**: High-level manager that connects the AI system to the main application

### Provider Implementations

1. **MockAIProvider**: A test implementation that provides canned responses
2. **GeminiAIProvider**: Google Gemini API implementation
3. (Future) Support for Claude, OpenAI, and other providers

### UI Components

1. **GeminiSetupDialog**: Setup wizard for Gemini API (moved to core/ai/ui/setup/)
2. (Future) Other provider-specific setup UIs

## Directory Structure

```
core/ai/
├── AIProviderRegistry.gd        # Service locator for providers
├── AIIntegrationManager.gd      # Main integration point with the app
├── providers/
│   ├── AIProviderInterface.gd   # Common interface for all providers
│   ├── MockAIProvider.gd        # Mock implementation for testing
│   ├── GeminiAIProvider.gd      # Gemini-specific implementation
│   └── ...                      # Other provider implementations
├── config/
│   └── AIConfigurationManager.gd # Configuration management
└── ui/
    └── setup/
        ├── GeminiSetupDialog.gd  # Gemini setup dialog
        └── GeminiSetupDialog.tscn
```

## Initialization Flow

1. Create and initialize AIConfigurationManager
2. Create and initialize AIProviderRegistry (references AIConfigurationManager)
3. Register providers with AIProviderRegistry
4. Create and initialize AIIntegrationManager (references AIProviderRegistry)
5. Connect AIIntegrationManager to the main scene

## Usage Examples

### Basic Usage in Main Scene

```gdscript
# In the main scene's _ready function
func _initialize_ai_integration() -> void:
    """Initialize AI integration with the new architecture"""
    print("[INIT] Initializing AI integration...")
    
    # Create AI integration manager
    ai_integration = AIIntegrationManager.new()
    ai_integration.name = "AIIntegration"
    add_child(ai_integration)
    
    # Connect to signals
    ai_integration.ai_setup_completed.connect(_on_ai_setup_completed)
    ai_integration.ai_setup_cancelled.connect(_on_ai_setup_cancelled)
    ai_integration.ai_provider_changed.connect(_on_ai_provider_changed)
    ai_integration.ai_response_received.connect(_on_ai_response_received)
    ai_integration.ai_error_occurred.connect(_on_ai_error_occurred)
    
    print("[INIT] ✓ AI integration initialized")
```

### Asking Questions

```gdscript
# Ask a question about the current structure
func _on_ask_button_pressed() -> void:
    var question = question_input.text
    if question.is_empty():
        return
    
    ai_integration.ask_question(question)
    question_input.text = ""
```

### Handling Responses

```gdscript
# Handle AI responses
func _on_ai_response_received(question: String, response: String) -> void:
    var chat_display = get_node("ChatDisplay")
    chat_display.add_message("You", question)
    chat_display.add_message("AI", response)
```

### Setting Current Structure

```gdscript
# Update AI context when a structure is selected
func _on_structure_selected(structure_name: String, _mesh: MeshInstance3D) -> void:
    # Update AI context
    ai_integration.set_current_structure(structure_name)
    
    # ... other selection handling
```

## Adding a New AI Provider

1. Create a new provider class that extends AIProviderInterface
2. Implement all required methods
3. Register the provider with AIProviderRegistry
4. (Optional) Create a provider-specific setup dialog

Example:

```gdscript
# 1. Create provider class
class_name MyNewAIProvider
extends AIProviderInterface

# 2. Implement required methods
func initialize() -> bool:
    # Implementation
    return true

func ask_question(question: String, context: Dictionary = {}) -> String:
    # Implementation
    return ""

# ... implement other required methods

# 3. Register the provider
func register_my_provider():
    var provider = MyNewAIProvider.new()
    AIRegistry.register_provider("my_provider", provider)
```

## Configuration

The AIConfigurationManager handles provider configurations with a simple API:

```gdscript
# Get configuration
var config = AIConfig.get_provider_config("gemini")

# Update configuration
config.temperature = 0.7
AIConfig.set_provider_config("gemini", config)

# Save API key securely
AIConfig.save_api_key("gemini", "AIza...")
```

## Testing

A test script is provided at `test_ai_integration.gd` that validates the core functionality of the AI architecture. To run the test:

1. Create a new scene with a Node as the root
2. Attach the `test_ai_integration.gd` script to the root node
3. Run the scene

The test verifies:
- Component initialization
- Provider registration
- Mock provider functionality
- Provider switching
- Configuration management
- Structure context handling

## Educational Context Integration

The AI architecture is specifically designed to enhance the educational experience:

1. **Structure Context**: The active brain structure being studied is automatically provided to the AI
2. **Educational Prompts**: AI prompts include educational context and learning objectives
3. **Tailored Responses**: Responses are formatted for educational clarity at the appropriate level
4. **Visual Integration**: AI explanations complement the 3D visualization

Example of educational context handling:

```gdscript
# In GeminiAIProvider
func _build_educational_prompt(question: String) -> String:
    """Build an educational prompt with appropriate context"""
    var prompt = educational_prompts.system_prompt
    
    # Add structure context if available
    if not current_structure.is_empty():
        prompt += " " + educational_prompts.structure_context_template.format({
            "structure_name": current_structure
        })
    
    # Add question
    prompt += "\n\nQuestion: " + question
    
    return prompt
```

## Security Considerations

1. **API Key Storage**: API keys are stored in encrypted files using Godot's encryption methods
2. **Machine-specific Encryption**: Keys are encrypted using `OS.get_unique_id()` as the encryption key
3. **Rate Limiting**: Built-in rate limit tracking prevents excessive API usage
4. **Error Handling**: Robust error handling throughout the system

## Best Practices

1. **Always use AIIntegrationManager** for application code, not direct provider access
2. **Handle AI errors gracefully** by connecting to error signals
3. **Check setup status** before attempting to use AI functionality
4. **Provide meaningful context** for better AI responses
5. **Use the service locator pattern** for accessing providers, not direct references
6. **Keep API keys secure** using the AIConfigurationManager
7. **Include educational context** to ensure responses support learning objectives

## Debugging

The AI architecture includes several debug commands for troubleshooting:

- `ai_status` - Display status of the AI system
- `ai_provider` - Show current and available providers
- `ai_test` - Run a test query
- `ai_gemini_status` - Show Gemini provider status
- `ai_gemini_setup` - Open Gemini setup dialog
- `ai_gemini_reset` - Reset Gemini settings

## Future Enhancements

1. **Local model support**: Add support for local AI models
2. **Advanced prompt engineering**: Improve educational prompts with examples
3. **Caching layer**: Add response caching for common queries
4. **Analytics**: Track usage patterns to improve educational outcomes
5. **Multi-provider queries**: Compare responses from different providers
6. **Adaptive difficulty**: Adjust explanations based on user's learning progress
7. **Interactive tutorials**: AI-guided educational tutorials

## Conclusion

This architecture provides a solid foundation for AI integration in NeuroVis, with clean separation of concerns and extensibility for future AI providers. By following the patterns established here, we maintain a maintainable and flexible AI system that enhances the educational experience while keeping educational context at the forefront of AI interactions.