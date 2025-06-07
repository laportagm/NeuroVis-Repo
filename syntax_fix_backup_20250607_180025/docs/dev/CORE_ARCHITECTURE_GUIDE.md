# NeuroVis Core Architecture Guide

This guide provides a comprehensive overview of the core architectural components that form the foundation of the NeuroVis educational platform.

## Table of Contents

1. [Introduction](#introduction)
2. [Event System](#event-system)
3. [Service Locator](#service-locator)
4. [Resource Management](#resource-management)
5. [Application State](#application-state)
6. [Core Systems Registry](#core-systems-registry)
7. [Integration Patterns](#integration-patterns)
8. [Migration Guidelines](#migration-guidelines)

## Introduction

The NeuroVis core architecture is designed to provide a robust foundation for educational interactive 3D visualization. The architecture focuses on:

- **Decoupling**: Components communicate without direct references
- **Extensibility**: Easy addition of new features without modifying existing code
- **Testability**: Clear dependencies that can be mocked for testing
- **Performance**: Efficient resource management and state tracking
- **Reliability**: Graceful degradation and fallback mechanisms

This guide covers the key architectural components and how they work together to provide a stable foundation for the educational platform.

## Event System

The Event System enables decoupled communication between components through a centralized event bus.

### Core Functionality

- **Event Registration**: Components register interest in specific events
- **Event Emission**: Components trigger events with optional data
- **Event Tracing**: Debug mode enables event history tracking
- **Education-Specific Events**: Pre-defined events for educational interactions

### Key Files

- `core/events/EventBus.gd`: Core event management system

### Usage Example

```gdscript
# Register for events
EventBus.register("structure_selected", _on_structure_selected)

# Emit events
EventBus.emit("structure_selected", {
    "structure_name": "Hippocampus",
    "position": Vector3(0, 0, 0),
    "educational_context": "Memory formation"
})

# Handle events
func _on_structure_selected(event_name, event_data):
    print("Selected: " + event_data.structure_name)
```

### Educational Context

The event system is particularly useful for educational features:

- Track structure selection patterns for learning analytics
- Coordinate UI updates based on educational interactions
- Enable recording of learning sessions for review
- Support accessibility features with state announcements

## Service Locator

The Service Locator pattern provides a central registry for services with dynamic resolution and fallback support.

### Core Functionality

- **Service Registration**: Register primary and fallback services
- **Service Resolution**: Get services with graceful fallbacks
- **Factory Registration**: Register factories for lazy initialization
- **Educational Service Discovery**: Unified access to educational services

### Key Files

- `core/services/ServiceLocator.gd`: Core service locator implementation

### Usage Example

```gdscript
# Register a service
ServiceLocator.register_service("knowledge_service", KnowledgeService.new())

# Register a fallback
ServiceLocator.register_fallback("knowledge_service", LegacyKB.new())

# Register a factory
ServiceLocator.register_factory("model_manager", func(): return ModelManager.new())

# Get a service
var knowledge = ServiceLocator.get_service("knowledge_service")
```

### Educational Context

The service locator enables:

- Consistent access to educational content services
- Easy testing with mock educational services
- Graceful degradation to simpler implementations when needed
- Progressive enhancement for advanced educational features

## Resource Management

The Resource Management system centralizes asset loading, caching, and memory management for educational 3D models and other resources.

### Core Functionality

- **Resource Caching**: Prevent duplicate loading of the same resource
- **Async Loading**: Non-blocking loading for smoother educational experience
- **Memory Management**: Unload unused resources to free memory
- **Group Management**: Load/unload resources in logical groups
- **Educational Performance**: Optimize memory usage for complex 3D models

### Key Files

- `core/resources/ResourceManager.gd`: Core resource management system

### Usage Example

```gdscript
# Get a resource (loads if not cached)
var brain_model = ResourceManager.get_resource("res://assets/models/brain.glb")

# Preload a group of resources
ResourceManager.preload_resources([
    "res://assets/models/cortex.glb",
    "res://assets/models/brainstem.glb"
], "neuroanatomy")

# Async loading with callback
ResourceManager.load_resource_async("res://assets/models/hippocampus.glb", 
    func(path, resource): _on_hippocampus_loaded(resource))

# Unload when no longer needed
ResourceManager.unload_group("neuroanatomy")
```

### Educational Context

Resource management is critical for educational 3D applications:

- Smooth loading of anatomical models enhances learning experience
- Memory management allows complex educational models on more devices
- Preloading related structures improves educational workflow
- Resource groups map to educational concepts and learning modules

## Application State

The Application State system manages global state with persistence, change notification, and educational session tracking.

### Core Functionality

- **State Management**: Central storage for application state
- **Change Notifications**: Listeners for state changes
- **State Persistence**: Save/load state to disk
- **Group Organization**: Logical grouping of related state
- **Educational Analytics**: Track educational session metrics

### Key Files

- `core/state/AppState.gd`: Core application state management

### Usage Example

```gdscript
# Get/set state values
var theme = AppState.get_state("theme_mode", "enhanced")
AppState.set_state("theme_mode", "minimal")

# Register for change notifications
AppState.register_listener("current_structure", _on_structure_changed)

# Work with state groups
var preferences = AppState.get_state_group("user_preferences")
AppState.update_state_group("model_state", {
    "visible_layers": ["cortex", "ventricles"],
    "cross_section_enabled": true
})

# Educational session tracking
AppState.start_educational_session()
AppState.record_structure_view("Hippocampus")
var stats = AppState.get_session_statistics()
```

### Educational Context

Application state is essential for educational applications:

- Track learning progress across sessions
- Remember user preferences for accessibility
- Record structure viewing patterns for analytics
- Maintain educational session metrics
- Support educational research with detailed interaction data

## Core Systems Registry

The Core Systems Registry manages the lifecycle of core educational systems with graceful fallbacks between implementations.

### Core Functionality

- **System Registration**: Register primary and fallback systems
- **System Resolution**: Get systems with graceful fallbacks
- **Autoload Integration**: Fallback to autoloads when available
- **System Status**: Monitor and report on system status

### Key Files

- `core/systems/CoreSystemsRegistry.gd`: Core systems registry

### Usage Example

```gdscript
# Register systems
CoreSystemsRegistry.register_system("selection_manager", new_selection_system)
CoreSystemsRegistry.register_fallback("selection_manager", legacy_selection_system)

# Get a system
var selection = CoreSystemsRegistry.get_system("selection_manager")

# Check availability
if CoreSystemsRegistry.has_system("visual_feedback"):
    var feedback = CoreSystemsRegistry.get_system("visual_feedback")
    feedback.show_educational_highlight(structure)
```

### Educational Context

The systems registry supports educational platform stability:

- Graceful fallbacks ensure educational features remain available
- Migration between implementations without disruption
- Consistent access to core educational systems
- Support for A/B testing of educational features

## Integration Patterns

These architectural components work together to form a robust foundation for the NeuroVis educational platform.

### Common Integration Patterns

#### System Initialization

```gdscript
# In main scene initialization
func _init_core_architecture():
    # Set up registry
    var registry = CoreSystemsRegistry.new()
    add_child(registry)
    
    # Set up event bus
    var event_bus = EventBus.new()
    add_child(event_bus)
    
    # Set up service locator
    var service_locator = ServiceLocator.new()
    add_child(service_locator)
    
    # Set up resource manager
    var resource_manager = ResourceManager.new()
    add_child(resource_manager)
    
    # Set up app state
    var app_state = AppState.new()
    add_child(app_state)
    
    # Register core systems
    registry.register_system("event_bus", event_bus)
    registry.register_system("service_locator", service_locator)
    registry.register_system("resource_manager", resource_manager)
    registry.register_system("app_state", app_state)
    
    # Register these in service locator too
    service_locator.register_service("event_bus", event_bus)
    service_locator.register_service("registry", registry)
    service_locator.register_service("resource_manager", resource_manager)
    service_locator.register_service("app_state", app_state)
```

#### Component Communication

```gdscript
# Component initialization
func initialize():
    # Get dependencies
    var registry = get_node("/root/CoreSystemsRegistry")
    var event_bus = registry.get_system("event_bus")
    
    # Register for events
    event_bus.register("structure_selected", _on_structure_selected)
    event_bus.register("theme_changed", _on_theme_changed)
    
    # Get initial state
    var app_state = registry.get_system("app_state")
    var theme_mode = app_state.get_state("theme_mode", "enhanced")
    _apply_theme(theme_mode)

# Event handlers
func _on_structure_selected(_event_name, event_data):
    # Update UI with educational content
    var knowledge = ServiceLocator.get_service("knowledge_service")
    var structure_data = knowledge.get_structure(event_data.structure_name)
    _update_educational_panel(structure_data)
    
    # Record for educational analytics
    var app_state = get_node("/root/CoreSystemsRegistry").get_system("app_state")
    app_state.record_structure_view(event_data.structure_name)
```

#### Resource Loading

```gdscript
# Educational model loading
func _load_educational_model(model_name):
    # Get resource manager
    var registry = get_node("/root/CoreSystemsRegistry")
    var resource_manager = registry.get_system("resource_manager")
    
    # Show loading indicator
    _show_loading_indicator()
    
    # Load model asynchronously
    var model_path = "res://assets/models/%s.glb" % model_name
    resource_manager.load_resource_async(model_path, func(path, resource):
        _on_model_loaded(model_name, resource)
    )

# Handle loaded model
func _on_model_loaded(model_name, model_resource):
    # Hide loading indicator
    _hide_loading_indicator()
    
    if model_resource:
        # Create instance and add to scene
        var model_instance = model_resource.instantiate()
        add_child(model_instance)
        
        # Update state
        var app_state = get_node("/root/CoreSystemsRegistry").get_system("app_state")
        app_state.set_state("current_model", model_name)
        
        # Emit event
        var event_bus = get_node("/root/CoreSystemsRegistry").get_system("event_bus")
        event_bus.emit("model_changed", {
            "model_name": model_name,
            "instance": model_instance
        })
    else:
        # Show error
        _show_error_message("Failed to load educational model: " + model_name)
```

## Migration Guidelines

When migrating existing code to use the new architecture, follow these guidelines:

### Gradual Migration Approach

1. **Start with Event System**: Begin by introducing the EventBus for communication
2. **Add Resource Management**: Next, centralize resource loading
3. **Integrate State Management**: Move global state to AppState
4. **Add Service Locator**: Register existing services
5. **Complete with Systems Registry**: Register fully migrated systems

### Component Migration Pattern

1. **Add Architecture Dependencies**:
   ```gdscript
   var _event_bus: EventBus
   var _app_state: AppState
   var _service_locator: ServiceLocator
   var _resource_manager: ResourceManager
   ```

2. **Initialize Architecture References**:
   ```gdscript
   func _ready():
       var registry = get_node("/root/CoreSystemsRegistry")
       _event_bus = registry.get_system("event_bus")
       _app_state = registry.get_system("app_state")
       _service_locator = registry.get_system("service_locator")
       _resource_manager = registry.get_system("resource_manager")
   ```

3. **Replace Direct References with Architecture**:
   ```gdscript
   # Before
   var knowledge_data = KB.get_structure(structure_name)
   info_panel.update_content(knowledge_data)
   
   # After
   var knowledge_service = _service_locator.get_service("knowledge_service")
   var knowledge_data = knowledge_service.get_structure(structure_name)
   _event_bus.emit("educational_content_loaded", {
       "structure_name": structure_name,
       "data": knowledge_data
   })
   ```

4. **Add Graceful Fallbacks**:
   ```gdscript
   func _get_selection_manager():
       var registry = get_node("/root/CoreSystemsRegistry")
       var selection = registry.get_system("selection_manager")
       
       # Fallback to direct access if not in registry
       if not selection and has_node("BrainStructureSelectionManager"):
           selection = get_node("BrainStructureSelectionManager")
       
       return selection
   ```

### Testing During Migration

As you migrate, use these tests to verify integrity:

1. **Component Tests**:
   ```gdscript
   func test_component_with_architecture():
       # Mock architecture components
       var event_bus_mock = EventBusMock.new()
       var app_state_mock = AppStateMock.new()
       
       # Create component with mocks
       var component = ComponentToTest.new()
       component._event_bus = event_bus_mock
       component._app_state = app_state_mock
       
       # Test component behavior
       component._on_structure_selected("structure_selected", {"structure_name": "Hippocampus"})
       
       # Verify expected behavior
       assert_true(event_bus_mock.was_event_emitted("educational_content_loaded"))
       assert_true(app_state_mock.was_state_set("current_structure", "Hippocampus"))
   ```

2. **Integration Tests**:
   ```gdscript
   func test_architecture_integration():
       # Create real architecture components
       var event_bus = EventBus.new()
       var app_state = AppState.new()
       var registry = CoreSystemsRegistry.new()
       
       # Register components
       registry.register_system("event_bus", event_bus)
       registry.register_system("app_state", app_state)
       
       # Create components that use architecture
       var selection_manager = SelectionManager.new()
       var info_panel = InfoPanel.new()
       
       # Initialize components with architecture
       selection_manager._initialize_architecture(registry)
       info_panel._initialize_architecture(registry)
       
       # Test interaction
       selection_manager._handle_selection("Hippocampus")
       
       # Verify expected behavior
       assert_eq(app_state.get_state("current_structure"), "Hippocampus")
   ```

---

By following this architecture guide, you'll ensure that new features and enhancements to the NeuroVis educational platform are built on a solid foundation that promotes maintainability, testability, and extensibility.