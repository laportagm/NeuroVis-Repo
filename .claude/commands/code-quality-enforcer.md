# GDScript Code Quality & Linting Enforcer

## Purpose
Ensures Claude ALWAYS follows proper GDScript syntax, linting, and formatting rules.

## Usage
```bash
claude -f .claude/commands/code-quality-enforcer.md "Your coding request"
```

## Code Quality Enforcement
```
🔧 GDSCRIPT CODE QUALITY & LINTING ENFORCER 🔧

MANDATORY CODE STANDARDS VALIDATION:

GDSCRIPT_SYNTAX_RULES (STRICT):
✅ Proper class_name declaration: class_name ClassName
✅ Correct extends syntax: extends BaseClass
✅ Function declarations: func function_name() -> ReturnType:
✅ Variable declarations with types: var variable_name: Type = value
✅ Signal declarations: signal signal_name(parameters)
✅ Enum declarations: enum EnumName { VALUE_ONE, VALUE_TWO }

NAMING_CONVENTIONS (ENFORCED):
✅ Classes: PascalCase (BrainStructureManager, QuizSystem)
✅ Functions: snake_case (initialize_quiz, get_structure_data)
✅ Variables: snake_case (current_score, selected_structure)
✅ Constants: SCREAMING_SNAKE_CASE (MAX_QUESTIONS, DEFAULT_TIMEOUT)
✅ Signals: snake_case (question_answered, quiz_completed)
✅ Private members: _underscore_prefix (_internal_state, _setup_ui)

INDENTATION_RULES (STRICT):
✅ Use TABS (not spaces) for indentation
✅ Consistent 4-space visual width
✅ Proper nesting for functions, classes, control structures
✅ Aligned function parameters on multi-line declarations

CODE_STRUCTURE_REQUIREMENTS:
✅ Class documentation with ## comments
✅ Function documentation with docstrings
✅ Type hints for all parameters and return values
✅ Error handling with proper try/catch or validation
✅ Performance considerations (avoid excessive allocations)

LINTING_STANDARDS:
✅ No unused variables or imports
✅ No unreachable code
✅ Proper null checking before object access
✅ Consistent spacing around operators
✅ Proper string formatting and concatenation
✅ Memory-safe array/dictionary access

EDUCATIONAL_CODE_PATTERNS:
✅ Educational context in class/function documentation
✅ Learning objective comments for complex logic
✅ Accessibility considerations in UI code
✅ Performance annotations for render-heavy functions
✅ Medical accuracy validation for anatomical data

QUALITY_GATES (AUTOMATIC REJECTION):
❌ Missing type hints on function parameters
❌ Inconsistent naming conventions
❌ Missing error handling for external data access
❌ Unused variables or dead code
❌ Improper indentation (spaces instead of tabs)
❌ Missing educational context in documentation
❌ No null checks for object references
❌ Performance issues (excessive string concatenation, etc.)

CODE_FORMATTING_RULES:
✅ Opening braces on same line: if condition:
✅ Proper spacing: var x: int = 5 (not var x:int=5)
✅ Consistent quote usage: prefer double quotes "text"
✅ Line length: maximum 100 characters
✅ Proper import organization: built-ins first, then project imports

USER_REQUEST: ${USER_CODE_REQUEST}

MANDATORY_CODE_RESPONSE_FORMAT:

## Educational Context
[Learning objectives and clinical relevance]

## Code Quality Validation
✅ GDScript syntax compliance verified
✅ Naming conventions enforced
✅ Type hints included for all parameters
✅ Error handling implemented
✅ Performance optimized for educational platform
✅ Educational documentation complete

## Implementation
```gdscript
## ClassName.gd
## Educational purpose: [specific learning objective]
## Clinical relevance: [medical education value]

class_name ClassName
extends BaseClass

# === CONSTANTS ===
const MAX_ITEMS: int = 100

# === SIGNALS ===
## Emitted when educational milestone reached
signal milestone_achieved(progress: float)

# === EXPORTS ===
@export var educational_mode: bool = true

# === PRIVATE VARIABLES ===
var _internal_state: bool = false

# === PUBLIC METHODS ===
## Initialize educational features
## @param config Dictionary - Educational configuration
## @return bool - Success status
func initialize_education(config: Dictionary) -> bool:
    if config.is_empty():
        push_error("[Education] Config cannot be empty")
        return false
    
    _internal_state = true
    return true
```

## Performance Impact
[Memory usage, performance considerations]

## Testing Approach
[How to validate the educational functionality]

EXECUTE WITH ABSOLUTE GDSCRIPT CODE QUALITY COMPLIANCE.
```

## Code Quality Examples:

### ✅ EXCELLENT Code (Passes All Checks):
```gdscript
## QuizManager.gd
## Educational purpose: Manages interactive neuroanatomy quizzes for medical students
## Clinical relevance: Reinforces anatomical knowledge through spaced repetition

class_name QuizManager
extends Node

# === CONSTANTS ===
const MAX_QUESTIONS_PER_QUIZ: int = 20
const DEFAULT_TIME_LIMIT: float = 30.0

# === SIGNALS ===
## Emitted when student answers a question
## @param is_correct bool - Whether answer was correct
## @param question_id String - Unique question identifier
signal question_answered(is_correct: bool, question_id: String)

# === EXPORTS ===
@export var quiz_difficulty: QuizDifficulty = QuizDifficulty.INTERMEDIATE
@export var enable_hints: bool = true

# === PRIVATE VARIABLES ===
var _current_questions: Array[QuizQuestion] = []
var _student_score: int = 0

# === PUBLIC METHODS ===
## Initialize quiz system with educational parameters
## @param config Dictionary - Quiz configuration with question pool
## @return bool - True if initialization successful
func initialize_quiz(config: Dictionary) -> bool:
    if not config.has("questions") or config["questions"].is_empty():
        push_error("[QuizManager] No questions provided in config")
        return false
    
    _current_questions = config["questions"]
    _student_score = 0
    return true

## Submit student answer and provide educational feedback
## @param question_id String - Question being answered
## @param answer String - Student's selected answer
## @return Dictionary - Feedback with correctness and explanation
func submit_answer(question_id: String, answer: String) -> Dictionary:
    var question: QuizQuestion = _find_question(question_id)
    if question == null:
        push_warning("[QuizManager] Question not found: " + question_id)
        return {"error": "Question not found"}
    
    var is_correct: bool = question.check_answer(answer)
    if is_correct:
        _student_score += 1
    
    question_answered.emit(is_correct, question_id)
    
    return {
        "correct": is_correct,
        "explanation": question.get_explanation(),
        "clinical_notes": question.get_clinical_relevance()
    }

# === PRIVATE METHODS ===
func _find_question(question_id: String) -> QuizQuestion:
    for question in _current_questions:
        if question.get_id() == question_id:
            return question
    return null
```

### ❌ BAD Code (Automatic Rejection):
```gdscript
# Missing class documentation
class_name quizmanager  # Wrong naming convention
extends Node

var questions  # No type hint
var score=0  # No spacing, no type

func init(cfg):  # No type hints, poor naming
    questions=cfg.questions  # No spacing, no null check
    
func answer(id,ans):  # No type hints
    for q in questions:  # No null check
        if q.id==id:  # No spacing
            return q.check(ans)
```
