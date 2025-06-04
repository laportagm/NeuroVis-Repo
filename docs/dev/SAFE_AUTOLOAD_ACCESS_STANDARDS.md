# Safe Autoload Access Standards

## Overview

This document establishes mandatory standards for safely accessing autoload services in the NeuroVis project to prevent AI-caused crashes and ensure robust operation when services are unavailable.

## The Problem

**Unsafe Pattern (NEVER USE):**
```gdscript
# DANGEROUS - Will crash if service is missing
KnowledgeService.get_structure(id)
ModelSwitcherGlobal.toggle_model_visibility(name)
FeatureFlags.is_enabled(flag)
```

**Consequences:**
- Immediate crashes when autoloads are missing
- AI agents cause runtime errors
- Difficult debugging in development
- Unpredictable behavior in production

## Safe Autoload Access Pattern

### Core Pattern
```gdscript
# SAFE - Always use this pattern
if has_node("/root/ServiceName"):
    var service = get_node("/root/ServiceName")
    if service.has_method("method_name"):
        var result = service.method_name(parameters)
    else:
        push_warning("[ComponentName] Warning: ServiceName.method_name not available")
        # Graceful fallback behavior
else:
    push_warning("[ComponentName] Warning: ServiceName not available")
    # Graceful fallback behavior
```

### Pattern Breakdown

1. **Node Existence Check**: `has_node("/root/ServiceName")`
   - Verifies the autoload service exists
   - Prevents null reference errors

2. **Node Reference**: `get_node("/root/ServiceName")`
   - Gets safe reference to the service
   - Only called after existence verification

3. **Method Verification**: `service.has_method("method_name")`
   - Ensures the method exists before calling
   - Prevents method not found errors

4. **Warning Messages**: Consistent error reporting
   - Uses `[ComponentName]` prefix
   - Descriptive context about what's missing

5. **Graceful Fallbacks**: Always handle failure cases
   - Continue operation when possible
   - Disable features gracefully when unavailable

## Service-Specific Patterns

### KnowledgeService
```gdscript
# Safe KnowledgeService access
func get_structure_safely(structure_id: String) -> Dictionary:
    if has_node("/root/KnowledgeService"):
        var knowledge_service = get_node("/root/KnowledgeService")
        if knowledge_service.has_method("is_initialized") and knowledge_service.is_initialized():
            if knowledge_service.has_method("get_structure"):
                return knowledge_service.get_structure(structure_id)
            else:
                push_warning("[ComponentName] Warning: KnowledgeService.get_structure not available")
        else:
            push_warning("[ComponentName] Warning: KnowledgeService not initialized")
    else:
        push_warning("[ComponentName] Warning: KnowledgeService not available")
    
    return {} # Safe fallback
```

### ModelSwitcherGlobal
```gdscript
# Safe ModelSwitcherGlobal access
func toggle_model_safely(model_name: String) -> bool:
    if has_node("/root/ModelSwitcherGlobal"):
        var model_switcher = get_node("/root/ModelSwitcherGlobal")
        if model_switcher.has_method("toggle_model_visibility"):
            model_switcher.toggle_model_visibility(model_name)
            return true
        else:
            push_warning("[ComponentName] Warning: ModelSwitcherGlobal.toggle_model_visibility not available")
    else:
        push_warning("[ComponentName] Warning: ModelSwitcherGlobal not available")
    
    return false # Safe fallback
```

### FeatureFlags
```gdscript
# Safe FeatureFlags access
func is_feature_enabled_safely(feature_name: String) -> bool:
    if has_node("/root/FeatureFlags"):
        var feature_flags = get_node("/root/FeatureFlags")
        if feature_flags.has_method("is_enabled"):
            return feature_flags.is_enabled(feature_name)
        else:
            push_warning("[ComponentName] Warning: FeatureFlags.is_enabled not available")
    else:
        push_warning("[ComponentName] Warning: FeatureFlags not available")
    
    return false # Safe fallback (feature disabled)
```

### DebugCmd
```gdscript
# Safe DebugCmd access
func register_debug_commands_safely() -> void:
    if has_node("/root/DebugCmd"):
        var debug_cmd = get_node("/root/DebugCmd")
        if debug_cmd.has_method("register_command"):
            debug_cmd.register_command("command_name", _handler, "Description")
        else:
            push_warning("[ComponentName] Warning: DebugCmd.register_command not available")
    else:
        push_warning("[ComponentName] Warning: DebugCmd not available")
```

### UIThemeManager
```gdscript
# Safe UIThemeManager access
func apply_theme_safely(control: Control) -> void:
    if has_node("/root/UIThemeManager"):
        var theme_manager = get_node("/root/UIThemeManager")
        if theme_manager.has_method("apply_theme_to_control"):
            theme_manager.apply_theme_to_control(control)
        else:
            push_warning("[ComponentName] Warning: UIThemeManager.apply_theme_to_control not available")
    else:
        push_warning("[ComponentName] Warning: UIThemeManager not available")
        # Fallback: Use default Godot theming
```

## Signal Connection Safety

### Safe Signal Connection Pattern
```gdscript
# Safe signal connection
func connect_to_service_safely() -> void:
    if has_node("/root/ServiceName"):
        var service = get_node("/root/ServiceName")
        if service.has_signal("signal_name"):
            if not service.signal_name.is_connected(_on_signal_handler):
                service.signal_name.connect(_on_signal_handler)
        else:
            push_warning("[ComponentName] Warning: ServiceName.signal_name not available")
    else:
        push_warning("[ComponentName] Warning: ServiceName not available")
```

### Safe Signal Disconnection
```gdscript
# Safe signal disconnection
func disconnect_from_service_safely() -> void:
    if has_node("/root/ServiceName"):
        var service = get_node("/root/ServiceName")
        if service.has_signal("signal_name"):
            if service.signal_name.is_connected(_on_signal_handler):
                service.signal_name.disconnect(_on_signal_handler)
```

## Implementation Examples

### Before (Unsafe)
```gdscript
class_name UnsafeComponent
extends Node

func _ready() -> void:
    # DANGEROUS - Will crash if services missing
    KnowledgeService.knowledge_base_loaded.connect(_on_knowledge_loaded)
    var structure = KnowledgeService.get_structure("hippocampus")
    ModelSwitcherGlobal.toggle_model_visibility("brain")
    DebugCmd.register_command("test", _test, "Test command")
```

### After (Safe)
```gdscript
class_name SafeComponent
extends Node

func _ready() -> void:
    _connect_knowledge_service_safely()
    var structure = _get_structure_safely("hippocampus")
    _toggle_model_safely("brain")
    _register_debug_commands_safely()

func _connect_knowledge_service_safely() -> void:
    if has_node("/root/KnowledgeService"):
        var knowledge_service = get_node("/root/KnowledgeService")
        if knowledge_service.has_signal("knowledge_base_loaded"):
            knowledge_service.knowledge_base_loaded.connect(_on_knowledge_loaded)
        else:
            push_warning("[SafeComponent] Warning: KnowledgeService.knowledge_base_loaded signal not available")
    else:
        push_warning("[SafeComponent] Warning: KnowledgeService not available")

func _get_structure_safely(structure_id: String) -> Dictionary:
    if has_node("/root/KnowledgeService"):
        var knowledge_service = get_node("/root/KnowledgeService")
        if knowledge_service.has_method("get_structure"):
            return knowledge_service.get_structure(structure_id)
        else:
            push_warning("[SafeComponent] Warning: KnowledgeService.get_structure not available")
    else:
        push_warning("[SafeComponent] Warning: KnowledgeService not available")
    return {}

func _toggle_model_safely(model_name: String) -> void:
    if has_node("/root/ModelSwitcherGlobal"):
        var model_switcher = get_node("/root/ModelSwitcherGlobal")
        if model_switcher.has_method("toggle_model_visibility"):
            model_switcher.toggle_model_visibility(model_name)
        else:
            push_warning("[SafeComponent] Warning: ModelSwitcherGlobal.toggle_model_visibility not available")
    else:
        push_warning("[SafeComponent] Warning: ModelSwitcherGlobal not available")

func _register_debug_commands_safely() -> void:
    if has_node("/root/DebugCmd"):
        var debug_cmd = get_node("/root/DebugCmd")
        if debug_cmd.has_method("register_command"):
            debug_cmd.register_command("test", _test, "Test command")
        else:
            push_warning("[SafeComponent] Warning: DebugCmd.register_command not available")
    else:
        push_warning("[SafeComponent] Warning: DebugCmd not available")
```

## Static Context Handling

### Problem: Static Functions Can't Access Scene Tree
```gdscript
# PROBLEM - Static function can't use has_node()
static func static_function() -> void:
    # This will fail - no scene tree access
    if has_node("/root/KnowledgeService"):
        var service = get_node("/root/KnowledgeService")
```

### Solution: Pass Node Reference
```gdscript
# SOLUTION - Pass a node reference for tree access
static func static_function_safe(context_node: Node) -> void:
    if context_node and context_node.is_inside_tree():
        if context_node.has_node("/root/KnowledgeService"):
            var service = context_node.get_node("/root/KnowledgeService")
            if service.has_method("method_name"):
                service.method_name()
            else:
                push_warning("[StaticContext] Warning: Service method not available")
        else:
            push_warning("[StaticContext] Warning: KnowledgeService not available")
    else:
        push_warning("[StaticContext] Warning: No valid context node provided")
```

## Common Autoload Services

| Service | Path | Common Methods | Common Signals |
|---------|------|----------------|----------------|
| KnowledgeService | `/root/KnowledgeService` | `get_structure()`, `search_structures()`, `is_initialized()` | `knowledge_base_loaded` |
| ModelSwitcherGlobal | `/root/ModelSwitcherGlobal` | `toggle_model_visibility()`, `get_model_names()`, `is_model_visible()` | `model_visibility_changed` |
| FeatureFlags | `/root/FeatureFlags` | `is_enabled()`, `enable_feature()`, `disable_feature()` | `feature_changed` |
| DebugCmd | `/root/DebugCmd` | `register_command()`, `execute_command()` | `command_executed` |
| UIThemeManager | `/root/UIThemeManager` | `apply_theme_to_control()`, `set_theme_mode()` | `theme_changed` |
| AIAssistantService | `/root/AIAssistantService` | `send_query()`, `is_available()` | `response_received`, `error_occurred` |

## Best Practices

### 1. Always Use Safe Patterns
- Never access autoloads directly
- Always check node existence first
- Always verify method availability
- Always provide graceful fallbacks

### 2. Consistent Error Messages
- Use `[ComponentName]` prefix
- Include specific context about what's missing
- Use `push_warning()` for missing services
- Use `push_error()` for critical failures

### 3. Graceful Degradation
- Continue operation when possible
- Disable features gracefully when services unavailable
- Provide user feedback for missing functionality
- Use safe defaults for return values

### 4. Method Verification
- Check `has_method()` before calling
- Verify service state (e.g., `is_initialized()`)
- Handle method signature changes gracefully

### 5. Signal Safety
- Check `has_signal()` before connecting
- Use `is_connected()` to avoid duplicate connections
- Safely disconnect in cleanup methods

## Migration Checklist

- [ ] Replace all direct autoload access with safe patterns
- [ ] Add node existence checks
- [ ] Add method verification
- [ ] Implement graceful fallbacks
- [ ] Add appropriate warning messages
- [ ] Test with missing autoloads
- [ ] Verify no crashes occur
- [ ] Update static function calls

## Testing Safe Access

### Manual Testing
1. Disable autoloads in project.godot
2. Run the application
3. Verify no crashes occur
4. Check warning messages appear
5. Verify graceful degradation

### Automated Testing
```gdscript
# Test script for safe autoload access
func test_safe_autoload_access():
    # Temporarily disable autoload
    var original_service = get_node_or_null("/root/KnowledgeService")
    if original_service:
        original_service.queue_free()
    
    # Test component with missing service
    var component = load("res://path/to/component.gd").new()
    add_child(component)
    
    # Verify no crashes and proper warnings
    assert(component != null, "Component should handle missing services")
    
    # Restore service if needed
    # ... restoration code
```

## Validation Tools

### Verification Script
Create `tools/scripts/verify_safe_autoload_access.gd`:
```gdscript
# Scan all .gd files for unsafe autoload access patterns
func scan_for_unsafe_patterns():
    var unsafe_patterns = [
        "KnowledgeService\\.",
        "ModelSwitcherGlobal\\.",
        "FeatureFlags\\.",
        "DebugCmd\\.",
        "UIThemeManager\\."
    ]
    
    # Implementation to scan files and report unsafe patterns
```

## AI Agent Guidelines

### For AI Agents Working on NeuroVis

1. **NEVER use direct autoload access**
   - Always use the safe patterns documented here
   - Check node existence before access
   - Verify method availability

2. **Always provide fallbacks**
   - Handle missing services gracefully
   - Use safe default values
   - Continue operation when possible

3. **Follow naming conventions**
   - Use `[ComponentName]` in warning messages
   - Include specific context in error messages
   - Use appropriate log levels

4. **Test your changes**
   - Verify code works with missing autoloads
   - Check for warning messages
   - Ensure no crashes occur

By following these standards, AI agents can safely modify the NeuroVis codebase without causing crashes due to missing autoload services.