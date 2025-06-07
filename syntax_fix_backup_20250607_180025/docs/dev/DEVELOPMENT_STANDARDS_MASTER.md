# NeuroVis Development Standards Master Document
*Version 1.0 - Generated: 2025-05-27*

## Overview

This document establishes comprehensive development standards for the NeuroVis project to ensure code quality, consistency, and maintainability for both human and AI collaborators.

## Table of Contents
1. [Project Structure Standards](#project-structure-standards)
2. [Code Quality Standards](#code-quality-standards)
3. [Git Workflow Standards](#git-workflow-standards)
4. [Testing Standards](#testing-standards)
5. [Documentation Standards](#documentation-standards)
6. [AI Collaboration Guidelines](#ai-collaboration-guidelines)
7. [Performance Standards](#performance-standards)
8. [Tools and Automation](#tools-and-automation)

---

## Project Structure Standards

### Directory Organization
```
NeuroVis/
├── core/                    # Core business logic
│   ├── knowledge/          # Knowledge base management
│   ├── models/             # 3D model management
│   ├── interaction/        # User interaction systems
│   ├── visualization/      # Visualization utilities
│   └── systems/           # Core system coordination
├── ui/                     # User interface components
│   └── panels/            # UI panel components
├── scenes/                 # Godot scene files
│   ├── main/              # Main application scenes
│   ├── debug/             # Debug and testing scenes
│   └── ui/                # UI-specific scenes
├── assets/                 # Game assets
│   ├── data/              # JSON data files
│   ├── models/            # 3D models
│   └── textures/          # Texture files
├── tests/                  # Testing framework
│   ├── unit/              # Unit tests
│   ├── integration/       # Integration tests
│   └── framework/         # Testing infrastructure
├── docs/                   # Documentation
│   ├── dev/               # Development documentation
│   ├── user/              # User documentation
│   └── api/               # API documentation
└── tools/                  # Development tools
    ├── scripts/           # Utility scripts
    ├── templates/         # Code templates
    └── quality/           # Quality assurance tools
```

### File Naming Conventions
- **Scripts**: `PascalCase.gd` for classes, `snake_case.gd` for utilities
- **Scenes**: `snake_case.tscn`
- **Assets**: `snake_case` with appropriate extensions
- **Documentation**: `UPPER_CASE.md` for standards, `lower_case.md` for guides

---

## Code Quality Standards

### GDScript Conventions
Based on `docs/dev/scripting_conventions.md`:

#### Naming
- **Classes**: `PascalCase` (e.g., `BrainVisualizationCore`)
- **Functions**: `snake_case()` (e.g., `load_brain_model()`)
- **Variables**: `snake_case` (e.g., `selected_structure`)
- **Constants**: `ALL_CAPS_SNAKE_CASE` (e.g., `MAX_ZOOM_DISTANCE`)
- **Signals**: `snake_case` (e.g., `structure_selected`)

#### Code Structure
```gdscript
# File header with class documentation
## BrainVisualizationCore.gd
## Manages 3D visualization of neural structures
## Core class for brain visualization functionality

class_name BrainVisualizationCore
extends Node3D

# === CONSTANTS ===
const MAX_STRUCTURES: int = 50
const DEFAULT_ZOOM: float = 5.0

# === SIGNALS ===
signal structure_loaded(structure_name: String)
signal visualization_ready()

# === EXPORTS ===
@export var auto_load_models: bool = true
@export var debug_mode: bool = false

# === PRIVATE VARIABLES ===
var _current_model: Node3D
var _is_initialized: bool = false

# === PUBLIC METHODS ===
func initialize() -> bool:
    """Initialize the visualization system"""
    # Implementation here
    pass

# === PRIVATE METHODS ===
func _setup_materials() -> void:
    """Setup default materials for structures"""
    # Implementation here
    pass
```

### Error Handling Standards
```gdscript
# Standard error handling pattern
func load_structure(structure_id: String) -> bool:
    if structure_id.is_empty():
        push_error("[BrainVis] Structure ID cannot be empty")
        return false
    
    if not KB.has_structure(structure_id):
        push_warning("[BrainVis] Structure not found: " + structure_id)
        return false
    
    # Success path
    return true
```

### Performance Standards
- **Frame Rate**: Maintain 60fps on target hardware
- **Memory**: Monitor memory usage, implement proper cleanup
- **Loading**: Async loading for models > 1MB
- **Profiling**: Use built-in profiler for optimization

---

## Git Workflow Standards

### Commit Message Format
```
<type>(<scope>): <description>

[optional body]

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

### Commit Types
- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code formatting (no logic changes)
- **refactor**: Code restructuring
- **test**: Adding or modifying tests
- **chore**: Maintenance tasks

### Branch Strategy
- **main**: Production-ready code
- **develop**: Integration branch for features
- **feature/**: New features (`feature/brain-structure-selection`)
- **fix/**: Bug fixes (`fix/camera-controls-lag`)
- **docs/**: Documentation updates

### Pre-commit Checklist
- [ ] Code follows naming conventions
- [ ] No debug print statements
- [ ] Error handling implemented
- [ ] Comments added for complex logic
- [ ] Tests pass (when available)
- [ ] No sensitive data committed

---

## Testing Standards

### Test Structure
```
tests/
├── unit/                  # Individual component tests
│   ├── core/             # Core system tests
│   ├── ui/               # UI component tests
│   └── models/           # Model management tests
├── integration/          # Cross-system tests
│   ├── workflow/         # User workflow tests
│   └── performance/      # Performance tests
└── framework/            # Testing infrastructure
    ├── test_runner.gd    # Test execution
    └── assertions.gd     # Custom assertions
```

### Test Naming Convention
```gdscript
# TestClassNameTest.gd
class_name BrainVisualizationCoreTest
extends GutTest

func test_initialize_returns_true_when_successful():
    # Test implementation
    pass

func test_load_structure_fails_with_empty_id():
    # Test implementation
    pass
```

### Testing Requirements
- **Unit Tests**: All public methods
- **Integration Tests**: User workflows
- **Performance Tests**: Critical paths
- **Error Tests**: Error handling paths

---

## Documentation Standards

### Code Documentation
```gdscript
## BrainStructureSelectionManager.gd
## Handles user interaction for selecting anatomical structures
## 
## This class manages the selection system for brain structures,
## including highlighting, interaction feedback, and selection events.
##
## @tutorial: https://docs.neurovis.com/brain-selection
## @experimental

class_name BrainStructureSelectionManager
extends Node

## Emitted when a brain structure is selected
## @param structure_name: The name of the selected structure
## @param mesh: The MeshInstance3D that was selected
signal structure_selected(structure_name: String, mesh: MeshInstance3D)

## Configure highlight colors for selection feedback
## @param selection_color: Color for selected structures
## @param hover_color: Color for hovered structures
func configure_highlight_colors(selection_color: Color, hover_color: Color) -> void:
    """Configure the colors used for selection and hover feedback"""
    # Implementation
    pass
```

### Documentation Requirements
- **Class Documentation**: Purpose, usage, examples
- **Method Documentation**: Parameters, return values, side effects
- **Signal Documentation**: When emitted, parameters
- **Complex Logic**: Inline comments explaining why, not what

---

## AI Collaboration Guidelines

### Enhanced CLAUDE.md Integration
- **Context Preservation**: Maintain project state in documentation
- **Pattern Recognition**: Document established patterns for AI reference
- **Code Generation**: Provide templates for consistent AI-generated code
- **Error Resolution**: Maintain error pattern database for AI debugging

### AI-Friendly Code Patterns
```gdscript
# Clear, descriptive naming for AI understanding
func handle_brain_structure_selection_event(structure_name: String) -> void:
    """Handle user selection of a brain structure"""
    # Clear implementation with descriptive variable names
    var selected_structure_data = KB.get_structure(structure_name)
    var info_panel = InfoPanelFactory.create_info_panel()
    info_panel.display_structure_info(selected_structure_data)
```

---

## Performance Standards

### Frame Rate Requirements
- **Target**: 60fps on recommended hardware
- **Minimum**: 30fps on minimum hardware
- **Monitoring**: Built-in performance tracking

### Memory Management
- **Texture Streaming**: For large brain models
- **Model LOD**: Level-of-detail for distant structures
- **Garbage Collection**: Proper resource cleanup

### Loading Performance
- **Async Loading**: All models > 1MB
- **Progress Feedback**: Loading indicators for users
- **Caching**: Intelligent asset caching

---

## Tools and Automation

### Development Tools
```
tools/
├── setup/
│   ├── setup-dev-environment.sh    # Automated environment setup
│   └── install-dependencies.sh     # Install required tools
├── quality/
│   ├── lint-gdscript.sh            # Code linting
│   ├── format-code.sh              # Auto-formatting
│   └── run-tests.sh                # Test execution
├── build/
│   ├── build-project.sh            # Automated builds
│   └── export-release.sh           # Release packaging
└── templates/
    ├── gdscript-class.gd           # Class template
    ├── scene-controller.gd         # Scene controller template
    └── autoload-singleton.gd       # Autoload template
```

### VS Code Configuration
- **Extensions**: GDScript language support
- **Settings**: Consistent formatting and linting
- **Snippets**: Common code patterns
- **Tasks**: Build and test automation

### Pre-commit Hooks
- **Syntax Check**: Validate GDScript syntax
- **Style Check**: Enforce coding standards
- **Test Check**: Run relevant tests
- **Documentation Check**: Validate documentation

---

## Implementation Phases

### Phase 1: Foundation (Week 1)
- [x] Master standards document
- [ ] Code templates
- [ ] Basic git hooks
- [ ] VS Code configuration

### Phase 2: Quality (Weeks 2-3)
- [ ] Testing framework
- [ ] Linting pipeline
- [ ] Documentation generation
- [ ] Performance monitoring

### Phase 3: Automation (Week 4+)
- [ ] CI/CD pipeline
- [ ] Advanced quality gates
- [ ] Automated testing
- [ ] Release automation

---

## Maintenance and Evolution

### Regular Reviews
- **Monthly**: Standards effectiveness review
- **Quarterly**: Tool updates and improvements
- **Annually**: Major standards revision

### Metrics Tracking
- **Code Quality**: Complexity, duplication, coverage
- **Development Velocity**: Feature completion time
- **Error Rates**: Bug frequency and resolution time
- **Documentation Coverage**: Code documentation percentage

### Continuous Improvement
- **Feedback Integration**: Developer experience feedback
- **Tool Evolution**: New tool evaluation and adoption
- **Standard Updates**: Regular standard refinement
- **Best Practice Sharing**: Document successful patterns

---

*This document is a living standard that evolves with the project. All team members and AI collaborators should reference and contribute to its improvement.*