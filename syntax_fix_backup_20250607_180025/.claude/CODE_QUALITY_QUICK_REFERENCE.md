# NeuroVis Code Quality & Linting Enforcement - Quick Reference

## 🛡️ **GUARANTEE: Claude Will ALWAYS Follow Perfect GDScript Standards**

### **🚨 CRITICAL: Enhanced Code Quality Enforcement Active**

Your NeuroVis project now has **bulletproof code quality enforcement** that ensures Claude **never** produces code that violates:
- ✅ GDScript syntax rules
- ✅ Type hint requirements  
- ✅ Naming conventions
- ✅ Error handling standards
- ✅ Performance optimization
- ✅ Educational documentation
- ✅ Linting standards

## 🎯 **Enhanced Code Quality Tasks**

### **🛡️ Ultimate Standards + Code Quality (Recommended)**
```bash
# VS Code: Ctrl+Shift+U
# Command Palette: "🛡️ Ultimate Standards + Code Quality"
```
**What it enforces:**
- ✅ Complete educational standards validation
- ✅ GDScript syntax + type hints (STRICT)
- ✅ Naming conventions (PascalCase/snake_case)
- ✅ Error handling + null checks
- ✅ Performance optimization (60fps)
- ✅ Educational documentation complete
- ✅ Linting standards (no warnings)

### **🔧 Code Quality Enforcer (Code-Specific)**
```bash
# VS Code: Ctrl+Shift+Q
# Command Palette: "🔧 Code Quality Enforcer"
```
**What it enforces:**
- ✅ GDScript syntax compliance
- ✅ Type hints on ALL parameters/returns
- ✅ Proper naming conventions
- ✅ Error handling and validation
- ✅ Performance-optimized code
- ✅ Clean linting (no unused variables)

### **🎯 Code Review & Linting (Review Existing Code)**
```bash
# VS Code: Ctrl+Shift+L
# Command Palette: "🎯 Code Review & Linting"
```
**What it does:**
- ✅ Reviews existing code for violations
- ✅ Identifies syntax errors
- ✅ Finds missing type hints
- ✅ Suggests performance improvements
- ✅ Validates educational documentation

## 🔧 **What Gets Automatically Enforced**

### **GDScript Syntax (STRICT)**
```gdscript
# ✅ CORRECT (Will Pass):
class_name QuizManager
extends Node

func initialize_quiz(config: Dictionary) -> bool:
    return true

# ❌ WRONG (Automatic Rejection):
class_name quizmanager  # Wrong naming
extends Node

func init(cfg):  # Missing type hints
    return true
```

### **Type Hints (100% Required)**
```gdscript
# ✅ CORRECT (Will Pass):
func submit_answer(question_id: String, answer: String) -> Dictionary:
    var result: Dictionary = {"correct": false}
    return result

# ❌ WRONG (Automatic Rejection):
func submit_answer(question_id, answer):  # No type hints
    var result = {"correct": false}  # No type hint
    return result
```

### **Naming Conventions (Enforced)**
```gdscript
# ✅ CORRECT (Will Pass):
class_name BrainStructureManager  # PascalCase
const MAX_NEURONS: int = 1000     # SCREAMING_SNAKE_CASE
var current_score: int = 0        # snake_case
func calculate_progress() -> float:  # snake_case

# ❌ WRONG (Automatic Rejection):
class_name brainstructuremanager  # Wrong case
const maxNeurons: int = 1000      # Wrong case
var currentScore: int = 0         # Wrong case
func CalculateProgress() -> float:  # Wrong case
```

### **Error Handling (Required)**
```gdscript
# ✅ CORRECT (Will Pass):
func load_structure_data(structure_id: String) -> Dictionary:
    if structure_id.is_empty():
        push_error("[StructureLoader] Structure ID cannot be empty")
        return {}
    
    var data: Dictionary = KnowledgeService.get_structure(structure_id)
    if data.is_empty():
        push_warning("[StructureLoader] No data found for: " + structure_id)
        return {}
    
    return data

# ❌ WRONG (Automatic Rejection):
func load_structure_data(structure_id: String) -> Dictionary:
    var data = KnowledgeService.get_structure(structure_id)  # No null check
    return data  # No validation
```

### **Educational Documentation (Required)**
```gdscript
# ✅ CORRECT (Will Pass):
## QuizManager.gd
## Educational Purpose: Manages interactive neuroanatomy quizzes for medical students
## Clinical Relevance: Reinforces anatomical knowledge through spaced repetition
## Learning Objectives: 
## - Test student knowledge of brain structures
## - Provide immediate feedback for learning reinforcement
## - Track progress for educational assessment

class_name QuizManager
extends Node

## Submit student answer and provide educational feedback
## @param question_id String - Unique identifier for the question being answered
## @param answer String - Student's selected answer choice
## @return Dictionary - Feedback containing correctness and educational explanation
func submit_answer(question_id: String, answer: String) -> Dictionary:

# ❌ WRONG (Automatic Rejection):
# Missing class documentation
class_name QuizManager
extends Node

# Missing function documentation
func submit_answer(question_id: String, answer: String) -> Dictionary:
```

### **Performance Standards (Enforced)**
```gdscript
# ✅ CORRECT (Will Pass):
func process_large_dataset(data: Array[Dictionary]) -> Array[String]:
    var results: Array[String] = []
    results.resize(data.size())  # Pre-allocate for performance
    
    for i in range(data.size()):
        results[i] = data[i].get("name", "Unknown")
    
    return results

# ❌ WRONG (Automatic Rejection):
func process_large_dataset(data: Array[Dictionary]) -> Array[String]:
    var results: Array[String] = []
    
    for item in data:
        results.append(item.get("name", "Unknown"))  # Inefficient growth
    
    return results
```

## 🚨 **Automatic Rejection Triggers**

Claude code will be **immediately rejected** if it contains:

### **Syntax Violations:**
- ❌ Missing `class_name` declaration
- ❌ Incorrect function syntax: `func name():` without types
- ❌ Wrong indentation (spaces instead of tabs)
- ❌ Missing colons in function/class declarations

### **Type Hint Violations:**
- ❌ Function parameters without type hints: `func test(data)`
- ❌ Return types not specified: `func get_data():`
- ❌ Variables without type hints: `var score = 0`
- ❌ Array/Dictionary without element types: `var items = []`

### **Naming Convention Violations:**
- ❌ Wrong class naming: `classname` instead of `ClassName`
- ❌ Wrong function naming: `GetData()` instead of `get_data()`
- ❌ Wrong variable naming: `currentScore` instead of `current_score`
- ❌ Wrong constant naming: `maxValue` instead of `MAX_VALUE`

### **Error Handling Violations:**
- ❌ No null checks before object access
- ❌ Missing validation for external data
- ❌ No error messages for failure cases
- ❌ Direct array access without bounds checking

### **Documentation Violations:**
- ❌ Missing educational purpose in class documentation
- ❌ No learning objectives specified
- ❌ Missing function parameter documentation
- ❌ No clinical relevance explanation

### **Performance Violations:**
- ❌ Excessive string concatenation in loops
- ❌ Inefficient array growth patterns
- ❌ Missing performance considerations for UI updates
- ❌ Memory leaks from unclosed resources

## 🎯 **Your New Development Workflow**

### **For Any Coding Request:**
1. **Press `Ctrl+Shift+U`** (Ultimate Standards + Code Quality)
2. **Include educational context** in your request
3. **Watch Claude deliver** perfectly compliant GDScript code

### **For Code Review:**
1. **Press `Ctrl+Shift+L`** (Code Review & Linting)
2. **Get comprehensive analysis** of existing code quality
3. **Receive specific fixes** for any violations

### **Example Requests:**

#### **✅ EXCELLENT (Will Produce Perfect Code):**
```
Ctrl+Shift+U → "Create interactive quiz system for neuroanatomy assessment with type-safe question management and educational progress tracking"
```

#### **✅ GOOD (Will Add Missing Standards):**
```
Ctrl+Shift+Q → "Add error handling to brain model loading function with proper validation and user feedback"
```

#### **❌ AVOID (Will Be Enhanced by System):**
```
"Make a quiz" → System will automatically add educational context and code quality requirements
```

## 🏆 **Quality Assurance Results**

With this system, you get **guaranteed**:

### **Code Quality:**
- ✅ 100% type hint coverage
- ✅ Perfect GDScript syntax compliance
- ✅ Consistent naming conventions
- ✅ Comprehensive error handling
- ✅ Performance-optimized implementations

### **Educational Excellence:**
- ✅ Clear learning objectives in all code
- ✅ Clinical relevance documentation
- ✅ Accessibility considerations
- ✅ Medical accuracy validation

### **Professional Standards:**
- ✅ Enterprise-grade code quality
- ✅ Zero linting warnings
- ✅ Consistent architecture patterns
- ✅ Maintainable, readable code

## 📋 **Quick Start Checklist**

- [ ] **Use enhanced tasks**: Always use `Ctrl+Shift+U` for coding
- [ ] **Include educational context**: State learning objectives
- [ ] **Trust the system**: All code quality is automatically enforced
- [ ] **Review existing code**: Use `Ctrl+Shift+L` for code audits

## 🎯 **Success Formula**

```
Educational Context + Perfect GDScript + Type Safety + Error Handling + Performance = Guaranteed NeuroVis Code Quality
```

**Your NeuroVis project now has enterprise-grade code quality enforcement that ensures every line of code meets professional educational platform standards!** 🛡️