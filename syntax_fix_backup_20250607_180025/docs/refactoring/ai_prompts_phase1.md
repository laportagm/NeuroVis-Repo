# AI Implementation Prompts for Main Scene Refactoring

## Day 1 Tasks - Component Extraction

### Task 1.1: Analyze Current Architecture
```bash
claude "Role: Senior GDScript architect. Task: Analyze node_3d.gd to identify all distinct responsibilities. Create a detailed component extraction map showing which functions/variables belong to each proposed component. Output: Markdown table with function names, line numbers, and target component."
```

### Task 1.2: Create Component Base Infrastructure
```bash
claude "Role: Godot framework developer. Task: Create the component base class structure in core/components/. Include: 1) ComponentBase class with lifecycle methods, 2) Error handling patterns, 3) Signal definitions for inter-component communication. Reference CLAUDE.md patterns. Test with ./quick_test.sh."
```

## Day 2 Tasks - BrainVisualizer Implementation

### Task 2.1: Extract Brain Visualization Logic
```xml
<task>
  <role>GDScript refactoring specialist</role>
  <context>Extracting brain visualization from node_3d.gd</context>
  <objective>Create BrainVisualizer component</objective>
  <steps>
    1. Create core/components/brain_visualizer.gd
    2. Extract all 3D brain-related functions from node_3d.gd
    3. Identify required node references
    4. Create clean public API
    5. Implement initialization lifecycle
  </steps>
  <constraints>
    - Maintain all existing functionality
    - Use signals for external communication
    - No direct UI references
    - Follow CLAUDE.md conventions
  </constraints>
  <validation>Run ./quick_test.sh after each major change</validation>
  <output_format>unified_diff_patches</output_format>
</task>
```

### Task 2.2: Implement Brain Model Loading
```bash
claude "Acting as 3D visualization expert. Implement the brain model loading system in BrainVisualizer. Requirements: 1) Async loading with progress signals, 2) Model caching, 3) Error recovery for missing models. Include comprehensive error messages. Test model switching functionality."
```

## Day 3 Tasks - UI and Interaction Components

### Task 3.1: Extract UIManager Component
```bash
claude -p "Role: UI architect. Extract all UI management code from node_3d.gd into core/components/ui_manager.gd. Requirements: Panel registry system, standardized show/hide animations, centralized UI state management. Remove all backup/fallback UI creation - panels must exist in scene or fail cleanly. Output: Component implementation with clear API documentation."
```

### Task 3.2: Create InteractionHandler
```xml
<task>
  <role>Input systems developer</role>
  <context>NeuroVis 3D interaction refactoring</context>
  <objective>Extract input handling into dedicated component</objective>
  <implementation>
    - State machine for input modes (navigation, selection, measurement)
    - Clean ray casting abstraction
    - Hover state management
    - Configurable input bindings
  </implementation>
  <api_design>
    class InteractionHandler:
        signal region_hovered(region: BrainRegion)
        signal region_selected(region: BrainRegion)
        signal camera_input(delta: Vector2)
        
        func set_mode(mode: InteractionMode)
        func is_interacting() -> bool
  </api_design>
</task>
```

### Task 3.3: Refactor Main Scene
```bash
claude "Final refactoring step: Simplify node_3d.gd to coordinate components only. Remove all implementation details, leaving only: 1) Component references, 2) Initialization orchestration, 3) High-level signal connections. Target: <200 lines total. Ensure all functionality remains intact."
```

## Validation Scripts

### Create Automated Test Script
```bash
claude "Create scripts/test_refactoring.gd that validates: 1) All components initialize, 2) Brain models load, 3) UI panels respond, 4) Mouse interaction works, 5) No null reference errors. Output TAP-compliant test results."
```

### Performance Comparison
```bash
claude "Create a benchmark script comparing startup time and memory usage before/after refactoring. Measure: scene load time, peak memory, frame time stability. Output: JSON report with metrics."
```
