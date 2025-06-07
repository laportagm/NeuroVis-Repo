# Command: Create Educational Component

**Purpose**: Create reusable educational components for NeuroVis platform with comprehensive MCP integration for maximum development efficiency and educational impact.

**MCPs Used**: `godot-mcp` (primary), `filesystem`, `memory`, `sequential-thinking`, `sqlite`

## Overview
This command creates educational components that integrate seamlessly with NeuroVis architecture, ensuring medical accuracy, accessibility compliance, and optimal learning outcomes for medical students and healthcare professionals.

## Educational Component Creation Pipeline

### Phase 1: Component Analysis & Planning
**Use MCP `sequential-thinking`** to systematically analyze component requirements:
- Educational objectives and target learning outcomes
- Integration points with existing NeuroVis systems
- Performance requirements for 60fps educational interactions
- Accessibility needs for diverse learners

**Use MCP `memory`** to:
- Search existing educational component patterns
- Store component design decisions and educational rationale
- Create relationships between anatomical concepts
- Track clinical relevance and pathology connections

### Phase 2: Educational Context Definition
**Educational Requirements Analysis**:
- Target audience: medical students, neuroscience researchers, healthcare professionals
- Learning level: beginner, intermediate, advanced
- Clinical relevance and pathology integration
- Assessment and progress tracking capabilities
- WCAG 2.1 AA accessibility compliance

**Use MCP `memory`** to:
- Create entities for educational concepts being implemented
- Establish relationships with existing anatomical knowledge
- Store learning pathway dependencies
- Maintain medical terminology accuracy

### Phase 3: Technical Architecture Design
**Use MCP `filesystem`** to:
- Analyze existing educational component patterns in `ui/components/`
- Review core educational systems in `core/education/`
- Examine theme integration patterns with `UIThemeManager`
- Study accessibility implementations

**NeuroVis Architecture Integration**:
- `KnowledgeService` integration for educational content
- `UIThemeManager` support for Enhanced/Minimal themes
- `AIAssistant` integration for contextual learning support
- `DebugCmd` integration for development debugging
- `StructureAnalysisManager` for learning analytics

### Phase 4: Component Implementation
**Use MCP `godot-mcp`** to:
- Create educational scene structure with proper node hierarchy
- Add interactive components for learning engagement
- Configure educational materials and accessibility features
- Implement proper signal patterns for educational events

**Use MCP `filesystem`** to:
- Create component GDScript files following NeuroVis naming conventions
- Implement educational UI layouts with responsive design
- Add proper documentation with learning objectives
- Ensure proper error handling and validation

**GDScript Implementation Standards**:
```gdscript
## EducationalComponentName.gd
## Educational purpose: [Specific learning objective]
## Clinical relevance: [Medical education value and pathology connections]
## Target audience: [Medical students/Researchers/Professionals]
## Accessibility: WCAG 2.1 AA compliant with screen reader support

class_name EducationalComponentName
extends Control

# === CONSTANTS ===
const MAX_LEARNING_ITEMS: int = 50
const DEFAULT_INTERACTION_TIMEOUT: float = 30.0

# === SIGNALS ===
## Emitted when educational milestone is achieved
## @param progress float - Learning progress percentage (0.0-1.0)
## @param concept String - Anatomical concept mastered
signal learning_milestone_achieved(progress: float, concept: String)

## Emitted when accessibility feature is activated
## @param feature_type String - Type of accessibility feature used
signal accessibility_feature_used(feature_type: String)

# === EXPORTS ===
@export_group("Educational Configuration")
@export var educational_level: EducationalLevel = EducationalLevel.INTERMEDIATE
@export var enable_clinical_notes: bool = true
@export var track_learning_progress: bool = true

@export_group("Accessibility Features")
@export var enable_screen_reader: bool = true
@export var enable_high_contrast: bool = false
@export var enable_keyboard_navigation: bool = true

# === PRIVATE VARIABLES ===
var _knowledge_service: KnowledgeService
var _ui_theme_manager: UIThemeManager
var _ai_assistant: AIAssistantService
var _is_initialized: bool = false
var _current_learning_data: Dictionary = {}

# === INITIALIZATION ===
func _ready() -> void:
    _initialize_educational_component()

## Initialize educational component with NeuroVis service integration
func _initialize_educational_component() -> void:
    # Validate NeuroVis autoload services
    if not _validate_neurovis_services():
        push_error("[EducationalComponent] Required NeuroVis services not available")
        return
    
    _setup_educational_features()
    _configure_accessibility()
    _initialize_learning_tracking()
    _is_initialized = true

# === PUBLIC METHODS ===
## Display educational content for specific anatomical structure
## @param structure_id String - Anatomical structure identifier
## @param learning_context Dictionary - Educational context and objectives
## @return bool - Success status
func display_educational_content(structure_id: String, learning_context: Dictionary) -> bool:
    if not _is_initialized:
        push_error("[EducationalComponent] Component not initialized")
        return false
    
    if structure_id.is_empty():
        push_warning("[EducationalComponent] Structure ID cannot be empty")
        return false
    
    var structure_data = _knowledge_service.get_structure(structure_id)
    if structure_data.is_empty():
        push_warning("[EducationalComponent] No educational content for: " + structure_id)
        return false
    
    _display_structure_information(structure_data, learning_context)
    _track_learning_interaction(structure_id)
    return true

## Configure accessibility features for diverse learners
## @param accessibility_config Dictionary - Accessibility configuration
func configure_accessibility(accessibility_config: Dictionary) -> void:
    if accessibility_config.has("screen_reader"):
        enable_screen_reader = accessibility_config["screen_reader"]
    
    if accessibility_config.has("high_contrast"):
        enable_high_contrast = accessibility_config["high_contrast"]
        _apply_high_contrast_theme()
    
    if accessibility_config.has("keyboard_navigation"):
        enable_keyboard_navigation = accessibility_config["keyboard_navigation"]
        _setup_keyboard_navigation()
    
    accessibility_feature_used.emit("configuration_updated")

# === PRIVATE METHODS ===
func _validate_neurovis_services() -> bool:
    _knowledge_service = KnowledgeService
    _ui_theme_manager = UIThemeManager
    _ai_assistant = AIAssistant
    
    return (_knowledge_service != null and 
            _ui_theme_manager != null and 
            _ai_assistant != null)

func _setup_educational_features() -> void:
    # Configure theme support for Enhanced/Minimal modes
    if _ui_theme_manager:
        _ui_theme_manager.theme_changed.connect(_on_theme_changed)
    
    # Enable AI assistant integration for contextual learning
    if _ai_assistant:
        _ai_assistant.query_completed.connect(_on_ai_query_completed)

func _configure_accessibility() -> void:
    if enable_screen_reader:
        _setup_screen_reader_support()
    
    if enable_keyboard_navigation:
        _setup_keyboard_navigation()

func _track_learning_interaction(structure_id: String) -> void:
    _current_learning_data["last_structure"] = structure_id
    _current_learning_data["interaction_time"] = Time.get_unix_time_from_system()
    
    if track_learning_progress:
        learning_milestone_achieved.emit(0.1, structure_id)

# === SIGNAL HANDLERS ===
func _on_theme_changed(new_theme: UIThemeManager.ThemeMode) -> void:
    # Adapt component appearance for Enhanced/Minimal themes
    match new_theme:
        UIThemeManager.ThemeMode.ENHANCED:
            _apply_enhanced_educational_styling()
        UIThemeManager.ThemeMode.MINIMAL:
            _apply_minimal_clinical_styling()

func _on_ai_query_completed(query: String, response: String) -> void:
    # Handle AI assistant educational responses
    if response.length() > 0:
        _display_ai_educational_context(response)
```

### Phase 5: Educational Content Integration
**Use MCP `sqlite`** to:
- Log educational component usage and effectiveness
- Track learning progression and assessment data
- Store accessibility feature usage analytics
- Maintain clinical accuracy validation records

**Knowledge Base Integration**:
- Add component-specific educational metadata to `anatomical_data.json`
- Include learning objectives, clinical relevance, and assessment criteria
- Ensure medical terminology accuracy and pathology connections

### Phase 6: Testing & Validation
**Educational Component Testing**:
- Create comprehensive tests in `tests/integration/`
- Validate learning objective achievement
- Test accessibility compliance (screen readers, keyboard navigation)
- Verify performance targets (60fps, <3s loading)
- Validate clinical accuracy and medical terminology

**Use MCP `godot-mcp`** to:
- Run educational component in test scenes
- Validate 3D interaction performance
- Test theme switching between Enhanced/Minimal modes
- Verify proper integration with NeuroVis autoloads

### Phase 7: Documentation & Integration
**Use MCP `memory`** to:
- Store component documentation and usage patterns
- Create relationships with related educational concepts
- Maintain integration guidelines and best practices

**Documentation Requirements**:
- Educational component API documentation
- Learning objective achievement guidelines
- Accessibility feature documentation
- Integration examples with existing NeuroVis systems

## Educational Quality Checklist

### Code Quality Standards
- [ ] Follows GDScript 4.4 syntax and NeuroVis naming conventions
- [ ] Proper educational context in class and method documentation
- [ ] Type hints for all parameters and return values
- [ ] Error handling with educational context messaging
- [ ] Performance optimized for 60fps educational interactions
- [ ] Memory-safe implementation for extended learning sessions

### Educational Excellence
- [ ] Clear learning objectives defined and documented
- [ ] Clinical relevance and pathology connections established
- [ ] Multiple educational levels supported (beginner/intermediate/advanced)
- [ ] Progress tracking and assessment integration implemented
- [ ] AI assistant integration for contextual learning support

### Technical Integration
- [ ] Proper integration with `KnowledgeService` for educational content
- [ ] `UIThemeManager` support for Enhanced/Minimal themes
- [ ] `AIAssistant` integration for educational queries
- [ ] `DebugCmd` integration for development debugging
- [ ] Accessibility features implemented per WCAG 2.1 AA standards

### Medical Accuracy
- [ ] Anatomical terminology verified against medical standards
- [ ] Clinical information validated by medical professionals
- [ ] Pathology connections accurate and educationally relevant
- [ ] Educational content peer-reviewed for medical accuracy

## MCP Integration Workflow

```bash
# 1. Initialize component development
memory.create_entities([{
  "name": "ComponentName",
  "entityType": "educational_component",
  "observations": ["Learning objectives", "Target audience", "Clinical relevance"]
}])

# 2. Analyze existing patterns
filesystem.search_files("ui/components/", "*.gd")
memory.search_nodes("educational component patterns")

# 3. Create implementation
godot-mcp.create_scene("ui/components/educational/", "component_scene.tscn")
filesystem.write_file("ui/components/educational/ComponentName.gd", "implementation")

# 4. Validate and test
sqlite.append_insight("Educational component validation results")
godot-mcp.run_project("test educational component integration")

# 5. Document and store knowledge
memory.add_observations([{
  "entityName": "ComponentName",
  "contents": ["Implementation patterns", "Integration guidelines", "Usage examples"]
}])
```

## Success Criteria

- Educational component enhances learning outcomes for target audience
- Maintains 60fps performance during complex anatomical interactions
- Supports both Enhanced and Minimal educational themes seamlessly
- Passes comprehensive accessibility compliance testing (WCAG 2.1 AA)
- Integrates seamlessly with existing NeuroVis educational workflow
- Includes comprehensive documentation and testing coverage
- Validates medical accuracy and clinical relevance
- Enables effective progress tracking and assessment integration