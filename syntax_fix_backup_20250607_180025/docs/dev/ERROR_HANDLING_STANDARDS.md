# Error Handling Standards

This document defines the standardized error handling patterns for the NeuroVis project. All developers and AI agents must follow these conventions to ensure consistent, meaningful, and debuggable error reporting across the codebase.

## Core Principles

1. **Consistent Component Naming**: All error messages must include the component name in square brackets
2. **Appropriate Error Levels**: Use the correct error level for the situation
3. **Meaningful Messages**: Provide context about what went wrong and why
4. **No Silent Failures**: Always log errors, even if handling them gracefully
5. **User-Friendly Fallbacks**: Provide sensible defaults when errors occur

## Error Level Guidelines

### `push_error()` - Critical Failures
Use for errors that prevent core functionality from working correctly:
- Missing required dependencies (autoloads, services)
- Invalid configuration that breaks functionality
- Unrecoverable state errors
- Missing required resources

### `push_warning()` - Non-Critical Issues
Use for issues that degrade functionality but don't break it:
- Missing optional features
- Fallback behavior activated
- Performance degradation warnings
- Deprecated functionality usage

### `print()` - Informational Messages
Use for normal operational logging:
- Successful initialization
- State changes
- Feature activation/deactivation
- Debug information (when appropriate)

## Component Naming Convention

All error messages MUST include the component name in square brackets at the start:

```gdscript
# Correct
push_error("[GeminiAIProvider] API key validation failed")
push_warning("[ModelVisibilityManager] Model not found, using default")
print("[DebugCommands] Debug console initialized")

# Incorrect
push_error("API key validation failed")  # Missing component name
push_error("GeminiAIProvider: API key failed")  # Wrong format
```

## Standard Error Handling Patterns

### Pattern 1: Service Initialization

```gdscript
func _ready() -> void:
    # Check for required dependencies
    if not Engine.has_singleton("KnowledgeService"):
        push_error("[ComponentName] KnowledgeService autoload not found")
        return
    
    # Optional features with warnings
    if not Engine.has_singleton("OptionalService"):
        push_warning("[ComponentName] OptionalService not available, feature X disabled")
    
    # Success logging
    print("[ComponentName] Initialized successfully")
```

### Pattern 2: Resource Loading

```gdscript
func load_resource(path: String) -> Resource:
    if path.is_empty():
        push_error("[ComponentName] Resource path cannot be empty")
        return null
    
    var resource = load(path)
    if not resource:
        push_error("[ComponentName] Failed to load resource: " + path)
        return null
    
    return resource
```

### Pattern 3: API/Service Calls

```gdscript
func make_api_request(endpoint: String) -> Dictionary:
    if api_key.is_empty():
        push_error("[ComponentName] API key not configured")
        return {}
    
    var response = await http_request.request_completed
    
    if response.error != OK:
        push_error("[ComponentName] API request failed: " + str(response.error))
        return {}
    
    if response.status_code != 200:
        push_warning("[ComponentName] API returned status: " + str(response.status_code))
        return {}
    
    return response.data
```

### Pattern 4: Configuration Validation

```gdscript
func validate_config(config: Dictionary) -> bool:
    if not config.has("required_field"):
        push_error("[ComponentName] Missing required configuration field: required_field")
        return false
    
    if not config.has("optional_field"):
        push_warning("[ComponentName] Optional field missing, using default value")
        config["optional_field"] = DEFAULT_VALUE
    
    return true
```

### Pattern 5: Graceful Degradation

```gdscript
func initialize_feature() -> void:
    if not _check_requirements():
        push_warning("[ComponentName] Requirements not met, running in limited mode")
        _limited_mode = true
        return
    
    if not _load_advanced_features():
        push_warning("[ComponentName] Advanced features unavailable")
        _basic_mode = true
    
    print("[ComponentName] Feature initialized in " + 
          ("limited" if _limited_mode else "full") + " mode")
```

## Real-World Examples

### Before: Inconsistent Error Handling
```gdscript
# From GeminiAIProvider.gd (OLD)
func setup(api_key: String) -> bool:
    if api_key == "":
        print("No API key provided")  # Wrong: Should be error, missing component
        return false
    
    _api_key = api_key
    _is_configured = true
    return true

# From ModelVisibilityManager.gd (OLD)
func _ready():
    print("ModelVisibilityManager: Initializing...")  # Wrong format
    if not all_models_node:
        print("ERROR: all_models_node is not set!")  # Wrong: Should use push_error
```

### After: Standardized Error Handling
```gdscript
# From GeminiAIProvider.gd (NEW)
func setup(api_key: String) -> bool:
    if api_key.is_empty():
        push_error("[GeminiAIProvider] API key cannot be empty")
        return false
    
    if not _validate_api_key_format(api_key):
        push_error("[GeminiAIProvider] Invalid API key format")
        return false
    
    _api_key = api_key
    _is_configured = true
    print("[GeminiAIProvider] Successfully configured with API key")
    return true

# From ModelVisibilityManager.gd (NEW)
func _ready() -> void:
    print("[ModelVisibilityManager] Initializing model visibility system")
    
    if not all_models_node:
        push_error("[ModelVisibilityManager] all_models_node not set - cannot manage visibility")
        return
    
    _initialize_model_registry()
    print("[ModelVisibilityManager] Initialization complete")
```

## Component-Specific Guidelines

### AI Components
```gdscript
# Use clear prefixes for AI-related errors
push_error("[GeminiAIProvider] API request failed: " + error_message)
push_warning("[AIAssistant] Fallback response used due to API timeout")
```

### UI Components
```gdscript
# Include UI state information when relevant
push_error("[NavigationPanel] Failed to create navigation item for: " + item_name)
push_warning("[ThemeManager] Custom theme not found, using default")
```

### System Components
```gdscript
# System errors should include technical details
push_error("[DebugCommands] Command execution failed: " + command + " - " + error)
push_warning("[SystemBootstrap] Optional system not available: " + system_name)
```

### Educational Components
```gdscript
# Educational components should be user-friendly
push_error("[KnowledgeService] Educational content missing for: " + structure_name)
push_warning("[EducationalModule] Some features disabled in current mode")
```

## Error Message Templates

### Missing Dependencies
```gdscript
push_error("[ComponentName] Required dependency 'DependencyName' not found")
push_warning("[ComponentName] Optional dependency 'DependencyName' not available, feature X disabled")
```

### Invalid Input
```gdscript
push_error("[ComponentName] Invalid parameter 'param_name': expected Type, got " + str(value))
push_error("[ComponentName] Parameter 'param_name' cannot be empty/null")
```

### Resource Failures
```gdscript
push_error("[ComponentName] Failed to load resource at path: " + resource_path)
push_error("[ComponentName] Resource type mismatch: expected " + expected_type + ", got " + actual_type)
```

### State Errors
```gdscript
push_error("[ComponentName] Invalid state transition: " + current_state + " -> " + requested_state)
push_error("[ComponentName] Component not initialized, call initialize() first")
```

## Best Practices

### 1. Early Validation
```gdscript
func process_data(data: Dictionary) -> void:
    # Validate early and return
    if not _validate_data(data):
        push_error("[ComponentName] Invalid data provided")
        return
    
    # Process valid data
    _process_valid_data(data)
```

### 2. Chained Error Context
```gdscript
func high_level_operation() -> bool:
    if not low_level_operation():
        push_error("[ComponentName] High-level operation failed due to low-level error")
        return false
    return true
```

### 3. User-Actionable Messages
```gdscript
# Good: Tells user what to do
push_error("[GeminiAIProvider] API key not set. Please configure in Settings > AI Integration")

# Bad: Vague error
push_error("[GeminiAIProvider] Configuration error")
```

### 4. Performance Considerations
```gdscript
# Use conditional logging for performance-sensitive code
if OS.is_debug_build():
    print("[ComponentName] Processing frame: " + str(frame_count))
```

## Migration Checklist

When updating existing code to follow these standards:

1. **Identify all error outputs**: Search for `print("ERROR`, `print("Warning`, etc.
2. **Add component names**: Ensure all messages start with `[ComponentName]`
3. **Use correct error levels**: Convert prints to appropriate push_error/push_warning
4. **Validate error paths**: Ensure all error conditions are properly handled
5. **Test error scenarios**: Verify errors appear correctly in the console
6. **Update documentation**: Add error handling notes to function documentation

## Guidelines for AI Agents

When AI agents work on the NeuroVis codebase, they should:

1. **Always use component names** in square brackets for any error/warning/info messages
2. **Match the error level** to the severity of the issue
3. **Provide context** about what failed and why
4. **Include relevant data** in error messages (paths, values, states)
5. **Follow existing patterns** in the component being modified
6. **Never remove error handling** without explicit justification
7. **Test error paths** when modifying error-prone code

### AI Agent Examples

```gdscript
# When creating new components
class_name NewComponent
extends Node

func _ready() -> void:
    # Always include component name
    print("[NewComponent] Initializing")
    
    # Check dependencies with proper error handling
    if not Engine.has_singleton("RequiredService"):
        push_error("[NewComponent] RequiredService not found")
        return
    
    print("[NewComponent] Initialization complete")

# When modifying existing components
# Original:
print("Processing data...")

# Updated by AI:
print("[ExistingComponent] Processing data...")
```

## Validation Tools

Use these debug commands to validate error handling:

```bash
# Check for non-standard error messages
grep -r "print.*ERROR" --include="*.gd"
grep -r "print.*Warning" --include="*.gd"

# Find messages without component names
grep -r "push_error(\"[^[]" --include="*.gd"
grep -r "push_warning(\"[^[]" --include="*.gd"
```

## Summary

Consistent error handling is crucial for maintaining a professional, debuggable codebase. By following these standards:

- Developers can quickly identify which component generated an error
- Error severity is immediately apparent
- Issues can be traced through the system
- Users receive helpful, actionable feedback
- The codebase maintains a consistent, professional appearance

Remember: **Every error message tells a story. Make it a clear one.**