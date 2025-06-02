# NeuroVis Testing Standards
*Version 1.0 - Generated: 2025-05-27*

## Overview

This document establishes comprehensive testing standards for the NeuroVis project to ensure code quality, reliability, and maintainability.

## Table of Contents
1. [Testing Philosophy](#testing-philosophy)
2. [Test Structure](#test-structure)
3. [Testing Frameworks](#testing-frameworks)
4. [Naming Conventions](#naming-conventions)
5. [Test Categories](#test-categories)
6. [Writing Test Guidelines](#writing-test-guidelines)
7. [Test Execution](#test-execution)
8. [Coverage Requirements](#coverage-requirements)
9. [CI/CD Integration](#cicd-integration)

---

## Testing Philosophy

### Core Principles
- **Quality First**: Tests ensure features work correctly and prevent regressions
- **Fast Feedback**: Tests run quickly to provide immediate feedback during development
- **Maintainable**: Tests are easy to understand, modify, and maintain
- **Comprehensive**: Tests cover critical functionality, edge cases, and error conditions
- **Isolated**: Tests are independent and don't affect each other

### Testing Pyramid
```
    /\
   /  \    Unit Tests (70%)
  /____\   - Fast, isolated, focused
 /      \  Integration Tests (20%)
/________\ - Component interaction
    E2E       End-to-End Tests (10%)
           - Full workflow validation
```

---

## Test Structure

### Directory Organization
```
tests/
├── unit/                   # Unit tests (70% of tests)
│   ├── core/              # Core system tests
│   │   ├── knowledge/     # Knowledge base tests
│   │   ├── models/        # Model management tests
│   │   └── systems/       # System coordination tests
│   ├── ui/                # UI component tests
│   │   └── panels/        # Panel component tests
│   └── interaction/       # Interaction system tests
├── integration/           # Integration tests (20% of tests)
│   ├── workflow/          # User workflow tests
│   ├── data/              # Data integration tests
│   └── performance/       # Performance integration
├── e2e/                   # End-to-end tests (10% of tests)
│   ├── scenarios/         # Complete user scenarios
│   └── regression/        # Regression test scenarios
└── framework/             # Testing infrastructure
    ├── TestFramework.gd   # Core testing framework
    ├── TestAssertions.gd  # Custom assertions
    ├── TestUtilities.gd   # Test utility functions
    └── MockObjects.gd     # Mock object factories
```

---

## Testing Frameworks

### Primary Framework: GUT (Godot Unit Testing)
- **Installation**: Available through Godot Asset Library
- **Documentation**: [GUT Testing Framework](https://github.com/bitwes/Gut)
- **Configuration**: Located in `tests/framework/`

### Custom Test Framework
For NeuroVis-specific testing needs:

```gdscript
# tests/framework/NeuroVisTestFramework.gd
class_name NeuroVisTestFramework
extends GutTest

# Custom assertions for brain structure testing
func assert_structure_loaded(structure_name: String) -> void:
    assert_true(KB.has_structure(structure_name), 
                "Structure should be loaded: " + structure_name)

func assert_model_visible(model_name: String) -> void:
    assert_true(ModelSwitcherGlobal.is_model_visible(model_name),
                "Model should be visible: " + model_name)

func assert_panel_displayed(panel_type: String) -> void:
    var panel = get_tree().get_nodes_in_group("info_panels")
    assert_gt(panel.size(), 0, "Info panel should be displayed")
```

---

## Naming Conventions

### Test File Naming
- **Unit Tests**: `ClassNameTest.gd` or `feature_name_test.gd`
- **Integration Tests**: `IntegrationDescriptionTest.gd`
- **E2E Tests**: `E2EScenarioNameTest.gd`

### Test Method Naming
```gdscript
# Pattern: test_[method_name]_[condition]_[expected_result]
func test_load_structure_with_valid_id_returns_true():
    pass

func test_load_structure_with_empty_id_returns_false():
    pass

func test_camera_controller_focus_centers_on_structure():
    pass
```

### Test Class Structure
```gdscript
## BrainVisualizationCoreTest.gd
## Unit tests for BrainVisualizationCore functionality

class_name BrainVisualizationCoreTest
extends NeuroVisTestFramework

# === TEST SETUP ===
var brain_core: BrainVisualizationCore
var mock_knowledge_base: MockKnowledgeBase

func before_each():
    """Setup before each test"""
    brain_core = BrainVisualizationCore.new()
    mock_knowledge_base = MockKnowledgeBase.new()
    add_child(brain_core)

func after_each():
    """Cleanup after each test"""
    if brain_core:
        brain_core.queue_free()
    if mock_knowledge_base:
        mock_knowledge_base.queue_free()

# === UNIT TESTS ===
func test_initialize_sets_initialized_flag():
    """Test that initialization sets the initialized flag"""
    # Arrange
    assert_false(brain_core.is_initialized())
    
    # Act
    var result = brain_core.initialize()
    
    # Assert
    assert_true(result, "Initialize should return true")
    assert_true(brain_core.is_initialized(), "Should be marked as initialized")

func test_load_structure_with_invalid_id_fails():
    """Test that loading invalid structure fails gracefully"""
    # Arrange
    brain_core.initialize()
    var invalid_id = "nonexistent_structure"
    
    # Act
    var result = brain_core.load_structure(invalid_id)
    
    # Assert
    assert_false(result, "Should fail with invalid structure ID")
```

---

## Test Categories

### Unit Tests (70% of test suite)

**Purpose**: Test individual components in isolation

**Characteristics**:
- Fast execution (< 10ms per test)
- No external dependencies
- Isolated from other components
- Focus on single responsibility

**Example Areas**:
- Knowledge base data retrieval
- Model visibility management
- UI component behavior
- Math utility functions

```gdscript
func test_knowledge_base_get_structure_returns_correct_data():
    # Arrange
    var structure_id = "Hippocampus"
    var expected_name = "Hippocampus"
    
    # Act
    var structure = KB.get_structure(structure_id)
    
    # Assert
    assert_eq(structure.displayName, expected_name)
    assert_true(structure.has("functions"))
    assert_gt(structure.functions.size(), 0)
```

### Integration Tests (20% of test suite)

**Purpose**: Test component interactions and data flow

**Characteristics**:
- Moderate execution time (< 100ms per test)
- Tests multiple components together
- Validates communication between systems
- Database and file system interaction

**Example Areas**:
- Brain structure selection workflow
- Model loading and display pipeline
- UI panel data binding
- Camera and model coordination

```gdscript
func test_brain_structure_selection_displays_info_panel():
    # Arrange
    var main_scene = load("res://scenes/main/node_3d.tscn").instantiate()
    add_child(main_scene)
    await main_scene.initialize_core_systems()
    
    # Act
    main_scene.selection_manager.select_structure("Cerebellum")
    await get_tree().process_frame
    
    # Assert
    var info_panel = main_scene.get_node("UI_Layer/StructureInfoPanel")
    assert_not_null(info_panel, "Info panel should be created")
    assert_true(info_panel.visible, "Info panel should be visible")
```

### End-to-End Tests (10% of test suite)

**Purpose**: Test complete user workflows

**Characteristics**:
- Slower execution (< 1000ms per test)
- Tests entire application flow
- User scenario validation
- Cross-system integration

**Example Scenarios**:
- Complete brain exploration workflow
- Model switching and information display
- Error handling and recovery
- Performance under load

```gdscript
func test_complete_brain_exploration_workflow():
    # Arrange
    var app = load_main_application()
    
    # Act & Assert - Step by step workflow
    # 1. Application loads successfully
    assert_true(app.is_initialized())
    
    # 2. Brain models are visible
    assert_model_visible("Half_Brain")
    
    # 3. User selects a structure
    simulate_structure_click("Frontal_Lobe")
    await wait_for_ui_update()
    
    # 4. Information panel displays
    assert_panel_displayed("StructureInfoPanel")
    
    # 5. Information is correct
    var displayed_info = get_displayed_structure_info()
    assert_eq(displayed_info.structure_name, "Frontal Lobe")
```

---

## Writing Test Guidelines

### Test Structure: AAA Pattern
```gdscript
func test_example():
    # ARRANGE - Set up test conditions
    var component = ComponentUnderTest.new()
    var input_data = {"key": "value"}
    
    # ACT - Execute the behavior being tested
    var result = component.process_data(input_data)
    
    # ASSERT - Verify the expected outcome
    assert_not_null(result)
    assert_eq(result.status, "success")
```

### Best Practices

#### 1. One Assertion Per Concept
```gdscript
# Good - Tests one specific behavior
func test_load_structure_returns_valid_data():
    var structure = KB.get_structure("Hippocampus")
    assert_not_null(structure)

func test_loaded_structure_has_display_name():
    var structure = KB.get_structure("Hippocampus")
    assert_true(structure.has("displayName"))

# Avoid - Tests multiple concepts
func test_load_structure_everything():
    var structure = KB.get_structure("Hippocampus")
    assert_not_null(structure)
    assert_true(structure.has("displayName"))
    assert_gt(structure.functions.size(), 0)
```

#### 2. Descriptive Test Names
```gdscript
# Good - Clear intent
func test_camera_focus_centers_on_selected_structure():
    pass

func test_model_switcher_hides_unselected_models():
    pass

# Avoid - Unclear purpose
func test_camera_stuff():
    pass

func test_models():
    pass
```

#### 3. Proper Error Testing
```gdscript
func test_load_structure_with_null_id_throws_error():
    # Test error conditions explicitly
    assert_signal_emitted_with_parameters(
        KB, "error_occurred", 
        ["Structure ID cannot be null"]
    )
    KB.load_structure(null)
```

#### 4. Mock External Dependencies
```gdscript
func test_structure_selection_without_ui_dependency():
    # Arrange
    var mock_ui = MockUIManager.new()
    selection_manager.ui_manager = mock_ui
    
    # Act
    selection_manager.select_structure("Cerebellum")
    
    # Assert
    assert_eq(mock_ui.last_displayed_structure, "Cerebellum")
```

---

## Test Execution

### Local Development
```bash
# Run all tests
./tools/quality/test-runner.sh

# Run unit tests only
./tools/quality/test-runner.sh --unit

# Run with verbose output
./tools/quality/test-runner.sh --verbose

# Run specific test category
./tools/quality/test-runner.sh --integration
```

### Godot Editor
1. Open Godot Editor
2. Navigate to Project → Tools → GUT
3. Select test directory
4. Click "Run Tests"

### Command Line (Direct Godot)
```bash
# Run specific test file
godot --headless --script tests/unit/core/KnowledgeBaseTest.gd

# Run test suite with GUT
godot --headless res://tests/TestSuite.tscn
```

---

## Coverage Requirements

### Coverage Targets
- **Unit Tests**: 80% code coverage minimum
- **Critical Paths**: 95% coverage required
- **New Features**: 100% coverage required
- **Bug Fixes**: Include regression tests

### Coverage Exclusions
- Generated code
- Third-party libraries
- Debug-only code
- Platform-specific code

### Coverage Reporting
```bash
# Generate coverage report
./tools/quality/test-runner.sh --coverage

# View coverage report
open tools/reports/coverage/index.html
```

---

## CI/CD Integration

### Pre-commit Testing
```bash
# Automated testing in git hooks
./tools/git-hooks/pre-commit
```

### Continuous Integration
```yaml
# .github/workflows/tests.yml (example)
name: NeuroVis Tests
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Setup Godot
        uses: lihop/setup-godot@v1
        with:
          godot-version: 4.2
      - name: Run Tests
        run: ./tools/quality/test-runner.sh
```

### Test Automation
- **Pre-commit**: Fast unit tests only
- **Pull Request**: Full test suite
- **Nightly**: Extended tests + performance
- **Release**: All tests + manual validation

---

## Performance Testing

### Performance Test Structure
```gdscript
func test_brain_model_loading_performance():
    # Arrange
    var start_time = Time.get_ticks_msec()
    var max_loading_time = 2000  # 2 seconds max
    
    # Act
    model_manager.load_model("Half_Brain.glb")
    await model_manager.model_loaded
    
    # Assert
    var loading_time = Time.get_ticks_msec() - start_time
    assert_lt(loading_time, max_loading_time, 
              "Model loading should complete within 2 seconds")
```

### Memory Testing
```gdscript
func test_memory_cleanup_after_model_unload():
    # Arrange
    var initial_memory = OS.get_static_memory_usage_by_type()
    
    # Act
    model_manager.load_model("Half_Brain.glb")
    await model_manager.model_loaded
    model_manager.unload_model("Half_Brain.glb")
    await get_tree().process_frame
    
    # Assert
    var final_memory = OS.get_static_memory_usage_by_type()
    assert_approximately(initial_memory, final_memory, 0.1,
                        "Memory should return to baseline after unload")
```

---

## Testing Tools and Utilities

### Mock Objects
```gdscript
# tests/framework/MockObjects.gd
class_name MockKnowledgeBase
extends Node

var mock_structures = {}
var method_calls = []

func get_structure(id: String) -> Dictionary:
    method_calls.append({"method": "get_structure", "params": [id]})
    return mock_structures.get(id, {})

func add_mock_structure(id: String, data: Dictionary):
    mock_structures[id] = data
```

### Test Utilities
```gdscript
# tests/framework/TestUtilities.gd
class_name TestUtilities

static func create_test_structure(name: String) -> Dictionary:
    return {
        "id": name,
        "displayName": name,
        "shortDescription": "Test structure",
        "functions": ["Test function"]
    }

static func simulate_click_at_position(position: Vector2):
    var event = InputEventMouseButton.new()
    event.position = position
    event.button_index = MOUSE_BUTTON_LEFT
    event.pressed = true
    Input.parse_input_event(event)
```

---

## Maintenance and Evolution

### Regular Reviews
- **Weekly**: Test failure analysis
- **Monthly**: Coverage and performance review
- **Quarterly**: Testing strategy evaluation

### Test Refactoring
- Remove obsolete tests
- Update tests for API changes
- Optimize slow tests
- Improve test readability

### Documentation Updates
- Keep testing standards current
- Update examples and guidelines
- Document new testing patterns
- Share best practices

---

*This document is maintained alongside the codebase and should be updated as testing practices evolve.*