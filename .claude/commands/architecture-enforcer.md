# NeuroVis Architecture Pattern Enforcer

**Purpose**: Prevents architectural violations in NeuroVis educational platform development using comprehensive MCP validation.

**MCPs Used**: `filesystem`, `memory`, `sequential-thinking`, `sqlite`

## Usage
```bash
claude -f .claude/commands/architecture-enforcer.md "Your development request"
```

## MCP-Enhanced Validation Process
1. **Use MCP `filesystem`** to analyze current project structure
2. **Use MCP `memory`** to store and retrieve architectural patterns
3. **Use MCP `sequential-thinking`** for systematic architecture validation
4. **Use MCP `sqlite`** to log architectural compliance metrics

## Architecture Enforcement Rules
```
🏗️ NEUROVIS ARCHITECTURE PATTERN ENFORCER 🏗️

MANDATORY ARCHITECTURE VALIDATION:

DIRECTORY_PLACEMENT_RULES (STRICT ENFORCEMENT):

core/ → Educational Business Logic ONLY
├── core/knowledge/ → Educational content services, search, normalization
├── core/ai/ → Educational AI assistance, tutoring systems  
├── core/interaction/ → 3D selection, camera controls, educational workflows
├── core/models/ → Educational 3D model management, layer visualization
└── core/systems/ → Educational analytics, progress tracking, debugging

ui/ → Educational User Interface ONLY
├── ui/components/ → Reusable educational interface elements
├── ui/panels/ → Educational information displays, study interfaces
└── ui/theme/ → Educational design system, accessibility themes

scenes/ → Educational Workflows ONLY
├── scenes/main/ → Primary educational interface scenes
└── scenes/debug/ → Educational testing and debugging scenes

assets/ → Educational Content ONLY
├── assets/data/ → Anatomical knowledge base, educational metadata
└── assets/models/ → 3D educational models with learning context

AUTOLOAD_SERVICES_VALIDATION:
✅ KnowledgeService → Primary educational content service
✅ AIAssistant → Educational AI support 
✅ UIThemeManager → Enhanced/Minimal educational themes
✅ ModelSwitcherGlobal → Layer-based educational visualization
✅ StructureAnalysisManager → Learning content analysis

CODE_PATTERN_ENFORCEMENT:
✅ PascalCase classes with educational documentation
✅ snake_case methods with learning objective comments
✅ Educational signals for analytics integration
✅ Performance compliance (60fps, <500MB memory, <100 draw calls)
✅ Accessibility compliance (WCAG 2.1 AA)
✅ Educational error handling with user-friendly messages

DANGER_ZONE_PROTECTION:
🚫 NEVER EDIT: project.godot (autoload configuration)
🚫 NEVER EDIT: assets/models/*.glb (3D brain models)  
🚫 NEVER EDIT: assets/data/anatomical_data.json (without medical review)
🚫 NEVER EDIT: .git/hooks/pre-commit (quality enforcement)

VIOLATION_REJECTION_RULES:
❌ Wrong directory placement → AUTOMATIC REJECTION
❌ Breaking autoload dependencies → AUTOMATIC REJECTION
❌ Violating educational naming conventions → AUTOMATIC REJECTION
❌ Missing educational documentation → AUTOMATIC REJECTION
❌ Ignoring performance budgets → AUTOMATIC REJECTION

USER_REQUEST: ${USER_ARCHITECTURE_REQUEST}

MANDATORY_ARCHITECTURE_COMPLIANCE_CHECK:
1. ✅ File placement follows NeuroVis educational structure?
2. ✅ Dependencies use established autoload services?
3. ✅ Code patterns follow educational conventions?
4. ✅ Performance budgets respected for educational platform?
5. ✅ Educational context preserved in all architectural decisions?

RESPONSE_REQUIREMENTS:
- Explicitly validate directory placement against NeuroVis structure
- Confirm autoload service usage patterns
- State educational justification for architectural decisions
- Validate performance impact on educational platform
- Reference CLAUDE.md architecture patterns

EXECUTE WITH RIGID NEUROVIS ARCHITECTURE COMPLIANCE.
```

## Architecture Examples:

### ✅ CORRECT Architecture:
```
Request: "Add quiz system"
Response: "Creating educational quiz in core/systems/QuizManager.gd with UI in ui/panels/QuizPanel.gd following NeuroVis educational architecture..."
```

### ❌ WRONG Architecture:
```
Request: "Add quiz system"  
Response: "Creating quiz.gd in root directory..."
(VIOLATION: Wrong placement, no educational context)
```

### ✅ CORRECT Autoload Usage:
```gdscript
# Use established educational services
var structure_data = KnowledgeService.get_structure("hippocampus")
UIThemeManager.apply_educational_theme()
```

### ❌ WRONG Autoload Usage:
```gdscript
# Creating new singleton instead of using established services
var my_data_service = MyDataService.new()
```
