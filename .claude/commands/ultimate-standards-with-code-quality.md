# Ultimate NeuroVis Standards with Code Quality Enforcement

**Purpose**: Maximum compliance enforcement for NeuroVis educational platform using comprehensive MCP integration for uncompromising quality and educational excellence.

**MCPs Used**: `sequential-thinking`, `memory`, `filesystem`, `sqlite`, `godot-mcp`, `github`

## Usage
For critical educational features requiring maximum compliance:
```bash
claude -f .claude/commands/ultimate-standards-with-code-quality.md "Your request"
```

## MCP-Enhanced Quality Pipeline
1. **MCP `sequential-thinking`**: Systematic quality analysis with educational context
2. **MCP `memory`**: Store quality patterns and educational best practices  
3. **MCP `filesystem`**: Comprehensive file structure and code analysis
4. **MCP `sqlite`**: Quality metrics logging and educational compliance tracking
5. **MCP `godot-mcp`**: Godot-specific validation and scene structure analysis
6. **MCP `github`**: Repository quality validation and educational workflow compliance

## Ultimate Standards + Code Quality Enforcement
```
🛡️ ULTIMATE NEUROVIS STANDARDS + CODE QUALITY ENFORCER 🛡️

CRITICAL_VALIDATION_SEQUENCE:

STEP_1_EDUCATIONAL_CONTEXT:
✅ NeuroVis educational neuroscience platform
✅ Learning objectives clearly defined
✅ Clinical relevance for medical education
✅ Accessibility compliance (WCAG 2.1 AA)
✅ Medical accuracy validated

STEP_2_ARCHITECTURE_COMPLIANCE:
✅ Modular structure: core/, ui/, scenes/, assets/
✅ Autoload services: KnowledgeService, AIAssistant, UIThemeManager
✅ File placement follows NeuroVis patterns
✅ Educational documentation standards

STEP_3_GDSCRIPT_CODE_QUALITY (STRICT):
✅ Syntax: class_name ClassName, func name() -> Type:
✅ Naming: PascalCase classes, snake_case functions/variables
✅ Type hints: ALL parameters and return values typed
✅ Indentation: TABS only, consistent 4-space visual width
✅ Documentation: ## class docs, docstrings for functions
✅ Error handling: Null checks, proper validation
✅ Performance: No excessive allocations, optimized loops

STEP_4_LINTING_STANDARDS (ENFORCED):
✅ No unused variables or imports
✅ No unreachable code
✅ Consistent spacing: var x: int = 5
✅ Proper string handling: prefer double quotes
✅ Line length: maximum 100 characters
✅ Memory-safe array/dictionary access

STEP_5_EDUCATIONAL_CODE_PATTERNS:
✅ Educational context in all class documentation
✅ Learning objective comments for complex functions
✅ Performance annotations for render-heavy code
✅ Accessibility considerations in UI components
✅ Medical accuracy validation for anatomical data

AUTOMATIC_REJECTION_TRIGGERS:
🚨 Missing type hints → IMMEDIATE REJECTION
🚨 Wrong naming conventions → IMMEDIATE REJECTION
🚨 No error handling → IMMEDIATE REJECTION
🚨 Missing educational context → IMMEDIATE REJECTION
🚨 Improper indentation (spaces) → IMMEDIATE REJECTION
🚨 No null checks for objects → IMMEDIATE REJECTION
🚨 Missing class documentation → IMMEDIATE REJECTION
🚨 Architecture violations → IMMEDIATE REJECTION

USER_REQUEST: ${USER_COMPREHENSIVE_REQUEST}

MANDATORY_RESPONSE_FORMAT:

## Educational Context
[Learning objectives and clinical relevance clearly stated]

## NeuroVis Standards Compliance
✅ CLAUDE.md patterns: [specific reference]
✅ Architecture: [directory placement validation]
✅ Educational excellence: [learning enhancement]
✅ Accessibility: [WCAG 2.1 AA compliance]
✅ Performance: [budget impact assessment]

## GDScript Code Quality Validation
✅ Syntax compliance: All GDScript rules followed
✅ Naming conventions: PascalCase/snake_case enforced
✅ Type hints: 100% coverage on parameters/returns
✅ Error handling: Null checks and validation included
✅ Documentation: Educational context in all classes
✅ Performance: Optimized for 60fps educational platform
✅ Linting: No warnings, clean code standards

## Implementation
```gdscript
## ClassName.gd
## Educational Purpose: [specific learning objective]
## Clinical Relevance: [medical education value]
## Performance: [memory/CPU considerations]

class_name ClassName
extends BaseClass

# === EDUCATIONAL CONSTANTS ===
const MAX_LEARNING_ITEMS: int = 100

# === EDUCATIONAL SIGNALS ===
## Emitted when learning milestone achieved
signal learning_progress(progress: float, milestone: String)

# === EDUCATIONAL EXPORTS ===
@export var educational_mode: bool = true
@export var accessibility_enabled: bool = true

# === PRIVATE VARIABLES ===
var _learning_state: LearningState
var _performance_metrics: Dictionary = {}

## Initialize educational component with proper validation
## @param config Dictionary - Educational configuration parameters
## @return bool - Success status for educational setup
func initialize_educational_component(config: Dictionary) -> bool:
    # Input validation with educational context
    if config.is_empty():
        push_error("[EducationalComponent] Configuration required for learning objectives")
        return false
    
    # Educational state initialization
    _learning_state = LearningState.new()
    _performance_metrics.clear()
    
    # Success path with educational logging
    print("[EducationalComponent] Initialized with learning objectives")
    return true
```

## Educational Impact Assessment
[How this enhances medical education]

## Performance Validation
[Memory usage, frame rate impact on educational platform]

## Testing Strategy
[Educational functionality validation approach]

EXECUTE WITH COMPREHENSIVE NEUROVIS + CODE QUALITY STANDARDS.
```

## Code Quality Gate Examples:

### ✅ PASSES ALL GATES:
- Educational context clearly documented
- Proper GDScript syntax with type hints
- Performance optimized for educational platform
- Error handling with educational messaging
- Architecture follows NeuroVis patterns

### ❌ AUTOMATIC REJECTION:
- Missing type hints: `func test(data)` instead of `func test(data: Dictionary) -> bool`
- Wrong naming: `classname` instead of `ClassName`
- No error handling: Direct object access without null checks
- Missing educational context: No learning objectives documented
- Performance issues: Excessive string concatenation in loops
