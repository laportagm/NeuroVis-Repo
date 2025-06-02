# Parser Error Prevention Guide

This comprehensive guide helps you fix and prevent GDScript parser errors in the NeuroVis educational platform.

## 🚀 Quick Fixes

### Run Syntax Validation
```bash
# Run our comprehensive syntax checker
./tools/scripts/validate_syntax.sh

# Or use Godot directly
/Applications/Godot.app/Contents/MacOS/Godot --headless --check-only --script your_file.gd
```

### Pre-commit Hook Integration
The project automatically runs syntax validation on every commit via pre-commit hooks.

## 🐛 Common Parser Errors & Solutions

### 1. Indentation Errors

#### ❌ WRONG
```gdscript
func example():
var data = "test"
    if data:
  print(data)
```

#### ✅ CORRECT
```gdscript
func example():
    var data: String = "test"
    if data:
        print(data)
```

**Rule:** Always use 4 spaces for indentation, never tabs.

### 2. Type Hint Errors

#### ❌ WRONG
```gdscript
func process_data(input):
    var result = input * 2
    return result
```

#### ✅ CORRECT
```gdscript
func process_data(input: int) -> int:
    var result: int = input * 2
    return result
```

**Rule:** Always provide type hints for function parameters and return values.

### 3. Variable Declaration Errors

#### ❌ WRONG
```gdscript
var my_variable  # No type hint
var another_var = some_function()  # Inferred type can cause issues
```

#### ✅ CORRECT
```gdscript
var my_variable: String = ""
var another_var: Dictionary = some_function()
```

**Rule:** Explicitly declare variable types, especially for complex types.

### 4. Signal Declaration Errors

#### ❌ WRONG
```gdscript
signal my_signal(String, int)  # Old syntax
signal another_signal  # No parameters defined when needed
```

#### ✅ CORRECT
```gdscript
signal my_signal(text: String, count: int)
signal another_signal()
```

**Rule:** Use new signal syntax with typed parameters.

### 5. Class Declaration Errors

#### ❌ WRONG
```gdscript
extends Node
class_name MyClass  # Wrong order
```

#### ✅ CORRECT
```gdscript
class_name MyClass
extends Node
```

**Rule:** `class_name` must come before `extends`.

### 6. Export Variable Errors

#### ❌ WRONG
```gdscript
@export var speed = 100  # No type hint
@export var player: Player  # Missing default value for complex types
```

#### ✅ CORRECT
```gdscript
@export var speed: float = 100.0
@export var player: Player = null
```

**Rule:** Export variables need explicit types and appropriate default values.

### 7. Enum Declaration Errors

#### ❌ WRONG
```gdscript
enum { OPTION_A, OPTION_B }  # Anonymous enum
enum MyEnum { optionA, optionB }  # Wrong naming convention
```

#### ✅ CORRECT
```gdscript
enum MyEnum { OPTION_A, OPTION_B }
enum State { IDLE, RUNNING, JUMPING }
```

**Rule:** Use named enums with ALL_CAPS values.

### 8. Array and Dictionary Type Errors

#### ❌ WRONG
```gdscript
var items = []  # No type specification
var data = {}   # No type specification
```

#### ✅ CORRECT
```gdscript
var items: Array[String] = []
var data: Dictionary = {}
var positions: Array[Vector3] = []
```

**Rule:** Specify array/dictionary content types when possible.

### 9. Function Call Errors

#### ❌ WRONG
```gdscript
some_function(param1, param2,)  # Trailing comma
another_function( param )  # Unnecessary spaces
```

#### ✅ CORRECT
```gdscript
some_function(param1, param2)
another_function(param)
```

**Rule:** No trailing commas, minimal spacing in function calls.

### 10. String Formatting Errors

#### ❌ WRONG
```gdscript
var message = "Hello " + name + "!"  # String concatenation
var formatted = "Value: %s" % value  # Old format syntax
```

#### ✅ CORRECT
```gdscript
var message: String = "Hello %s!" % name
var formatted: String = "Value: {value}".format({"value": value})
```

**Rule:** Use proper string formatting methods.

## 🛡️ Prevention Strategies

### 1. Use IDE/Editor with GDScript Support

#### VS Code Setup
```json
{
    "godot_tools.editor_path": "/Applications/Godot.app/Contents/MacOS/Godot",
    "files.associations": {
        "*.gd": "gdscript"
    },
    "editor.tabSize": 4,
    "editor.insertSpaces": true
}
```

### 2. Enable Pre-commit Hooks
```bash
# Install pre-commit hooks (run once)
pre-commit install

# The hooks will automatically check:
# - GDScript syntax validation
# - Naming convention verification
# - Type hint requirements
# - Indentation consistency
```

### 3. Regular Syntax Validation
```bash
# Run comprehensive syntax check
./tools/scripts/validate_syntax.sh

# Quick project validation
./tools/scripts/quick_test.sh
```

### 4. Follow Naming Conventions

```gdscript
# Classes: PascalCase
class_name BrainStructureManager
extends Node

# Functions and variables: snake_case
func handle_structure_selection() -> void:
var selected_structure: String

# Constants: ALL_CAPS_SNAKE_CASE
const MAX_SELECTION_DISTANCE: float = 100.0

# Private members: underscore prefix
var _internal_state: bool
func _setup_internal() -> void:
```

### 5. Use Type-Safe Patterns

```gdscript
# Safe null checking
func get_structure_safely(id: String) -> Dictionary:
    if not KnowledgeService.is_initialized():
        push_error("[Parser] KnowledgeService not available")
        return {}
    
    var result: Dictionary = KnowledgeService.get_structure(id)
    if result.is_empty():
        push_warning("[Parser] No structure found: " + id)
        return {}
    
    return result

# Safe array access
func get_item_safely(items: Array, index: int) -> Variant:
    if index < 0 or index >= items.size():
        push_error("[Parser] Array index out of bounds: " + str(index))
        return null
    return items[index]
```

## 🔧 Debugging Parser Errors

### 1. Read Error Messages Carefully
```
Parse Error: Expected type hint after ':' at line 42
```
This tells you exactly what's wrong and where.

### 2. Check Common Issues First
- Indentation (4 spaces, no tabs)
- Missing type hints
- Class/extends order
- Signal syntax

### 3. Use Godot's Built-in Checker
```bash
# Check specific file
godot --headless --check-only --script path/to/file.gd

# Check all files in project
find . -name "*.gd" -exec godot --headless --check-only --script {} \;
```

### 4. Incremental Testing
- Comment out problematic sections
- Add code back piece by piece
- Test after each addition

## 🎯 Educational Platform Specific Rules

### 1. Educational Error Handling
```gdscript
func load_educational_content(structure_id: String) -> Dictionary:
    # Input validation with educational context
    if structure_id.is_empty():
        push_error("[Educational] Structure ID cannot be empty")
        return {}
    
    # Service availability check
    if not KnowledgeService.is_initialized():
        push_error("[Educational] Knowledge service not available")
        return {}
    
    # Content validation
    var content: Dictionary = KnowledgeService.get_structure(structure_id)
    if content.is_empty():
        push_warning("[Educational] No content for: " + structure_id)
        return {}
    
    return content
```

### 2. Educational Documentation Requirements
```gdscript
## BrainStructureManager.gd
## Manages educational brain structure selection and interaction
##
## This system handles user interaction with 3D brain models for educational
## purposes, providing visual feedback and learning analytics.
##
## @tutorial: Educational interaction patterns
## @version: 2.0

class_name BrainStructureManager
extends Node

# === EDUCATIONAL CONSTANTS ===
const MAX_SELECTION_DISTANCE: float = 1000.0
const LEARNING_TOOLTIP_DELAY: float = 0.5

# === EDUCATIONAL SIGNALS ===
## Emitted when user selects a structure for learning
signal structure_selected(structure_name: String, educational_data: Dictionary)
```

### 3. Performance-Safe Educational Code
```gdscript
# Safe 3D model access for education
func get_brain_model_safely() -> MeshInstance3D:
    var model_container: Node3D = get_node_or_null("ModelContainer")
    if not model_container:
        push_error("[Educational] Model container not found")
        return null
    
    var brain_mesh: MeshInstance3D = model_container.get_node_or_null("BrainMesh")
    if not brain_mesh:
        push_error("[Educational] Brain mesh not loaded")
        return null
    
    return brain_mesh
```

## 📋 Pre-commit Checklist

Before committing code, ensure:

- [ ] **Syntax**: All GDScript files pass syntax validation
- [ ] **Types**: All functions and variables have type hints
- [ ] **Naming**: Following project naming conventions
- [ ] **Documentation**: Educational classes have proper documentation
- [ ] **Testing**: Code tested with `test autoloads && test ui_safety`
- [ ] **Performance**: No performance regressions in educational features

## 🔍 Automated Checking

The project includes automated parser error checking:

1. **Pre-commit Hooks**: Run on every commit
2. **Syntax Validator**: `./tools/scripts/validate_syntax.sh`
3. **Quick Test**: `./tools/scripts/quick_test.sh`
4. **Integration Test**: `./tools/scripts/validate_integration.sh`

## 📞 Getting Help

If you encounter parser errors:

1. Run `./tools/scripts/validate_syntax.sh` for detailed error analysis
2. Check this guide for common patterns
3. Review the error log: `syntax_errors.log`
4. Test with `test autoloads && test ui_safety`

## 🎓 Educational Platform Notes

The NeuroVis educational platform has specific requirements:

- **Medical Accuracy**: Content changes need domain expert review
- **Accessibility**: Code must maintain WCAG 2.1 compliance
- **Performance**: Maintain 60fps for educational interactions
- **Type Safety**: Critical for educational content integrity

---

**Remember**: Parser errors are preventable with proper tooling and conventions. Use the automated checks and follow the established patterns for error-free educational development.