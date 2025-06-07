# CLAUDE.md

This file provides comprehensive guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**A1-NeuroVis** is an advanced educational neuroscience visualization platform built with Godot 4.4.1 for interactive brain anatomy exploration. It's designed specifically for **medical students**, **neuroscience researchers**, and **healthcare professionals** as a comprehensive learning tool for neuroanatomy education.

### Educational Mission

NeuroVis transforms traditional anatomical learning by providing:

- Interactive 3D brain exploration with educational context
- Structured learning pathways for different skill levels
- Clinical relevance and pathology information
- AI-powered anatomical query assistance
- Accessibility compliance for diverse learning needs
- Progress tracking and assessment tools

## Current Architecture (2024)

The project follows a **modern, educational-focused modular architecture** organized by function:

### Core System Structure

```
├── core/                           # Business logic & core systems
│   ├── ai/                        # AI services for educational support
│   │   └── AIAssistantService.gd  # Educational AI query service
│   ├── interaction/               # User interaction handling
│   │   ├── BrainStructureSelectionManager.gd  # 3D structure selection
│   │   └── CameraBehaviorController.gd        # Educational camera controls
│   ├── knowledge/                 # Educational content management
│   │   ├── AnatomicalKnowledgeDatabase.gd     # Legacy KB (being phased out)
│   │   └── KnowledgeService.gd               # Modern educational content service
│   ├── models/                    # 3D model management for education
│   │   ├── ModelRegistry.gd       # Educational model coordination
│   │   └── ModelVisibilityManager.gd  # Layer-based learning support
│   └── systems/                   # Core educational systems
│       ├── DebugCommands.gd       # Development & educational debugging
│       └── StructureAnalysisManager.gd  # Educational content analysis
├── ui/                            # Educational user interface
│   ├── components/                # Reusable educational UI components
│   │   ├── core/                 # Base UI component system
│   │   ├── panels/               # Educational panel components
│   │   └── controls/             # Accessible UI controls
│   ├── panels/                    # Main educational interface panels
│   │   ├── UIThemeManager.gd     # Enhanced/Minimal educational themes
│   │   ├── InfoPanelFactory.gd   # Educational panel creation
│   │   └── EnhancedInformationPanel.gd  # Primary educational panel
│   └── theme/                     # Educational design system
├── scenes/                        # Godot scenes for educational workflows
│   ├── main/                     # Primary educational interface
│   │   ├── node_3d.tscn         # Main educational scene
│   │   └── node_3d.gd           # Educational workflow controller
│   └── debug/                    # Development and testing scenes
├── assets/                        # Educational content assets
│   ├── data/                     # Anatomical knowledge base
│   │   └── anatomical_data.json  # Educational content database
│   └── models/                   # 3D educational models (.glb)
├── tests/                         # Educational feature testing
├── tools/                         # Educational development tools
└── docs/                         # Educational platform documentation
```

## Development Standards & Code Quality

### **CRITICAL: All development must follow established standards**

#### **Code Quality Enforcement**

- **Pre-commit hooks**: Automatically run quality checks before commits
- **VS Code integration**: Formatting and linting on save
- **Automated syntax validation**: GDScript syntax checking
- **Naming convention enforcement**: Automated pattern validation

#### **GDScript Coding Standards**

Based on `docs/dev/scripting_conventions.md` and `docs/dev/DEVELOPMENT_STANDARDS_MASTER.md`:

##### **Naming Conventions (ENFORCED by pre-commit hooks)**

```gdscript
# Classes: PascalCase with class_name
class_name BrainStructureSelectionManager
extends Node

# Functions: snake_case()
func handle_structure_selection() -> void:
func _setup_visual_feedback() -> void:  # Private functions with underscore

# Variables: snake_case
var selected_structure: String
var _internal_state: bool  # Private variables with underscore

# Constants: ALL_CAPS_SNAKE_CASE
const MAX_SELECTION_DISTANCE: float = 100.0
const DEFAULT_HIGHLIGHT_COLOR: Color = Color.CYAN

# Signals: snake_case
signal structure_selected(structure_name: String, mesh: MeshInstance3D)
signal selection_cleared()

# Enums: PascalCase with ALL_CAPS values
enum SelectionState { NONE, HOVERING, SELECTED, CONFIRMED }
```

##### **File Naming Patterns (ENFORCED)**

- **Classes**: `PascalCase.gd` (e.g., `BrainStructureSelectionManager.gd`)
- **Utilities**: `snake_case.gd` (e.g., `math_utilities.gd`)
- **Scenes**: `snake_case.tscn` (e.g., `main_educational_scene.tscn`)
- **Assets**: `snake_case` with extensions (e.g., `brain_model_v2.glb`)

##### **Code Structure Standards**

```gdscript
## BrainStructureSelectionManager.gd
## Handles educational 3D structure selection with learning context
##
## This system manages user interaction for selecting anatomical structures,
## providing visual feedback, educational tooltips, and learning analytics.
##
## @tutorial: Educational selection patterns
## @version: 2.0

class_name BrainStructureSelectionManager
extends Node

# === CONSTANTS ===
const MAX_SELECTION_DISTANCE: float = 1000.0
const HIGHLIGHT_FADE_DURATION: float = 0.3

# === SIGNALS ===
## Emitted when user selects a brain structure for educational exploration
## @param structure_name: Display name of the selected anatomical structure
## @param mesh: The MeshInstance3D node that was selected
signal structure_selected(structure_name: String, mesh: MeshInstance3D)

# === EXPORTS (Educational Configuration) ===
@export var educational_mode: bool = true
@export var highlight_color: Color = Color.CYAN
@export_group(\"Educational Features\")
@export var show_learning_tooltips: bool = true
@export var track_learning_progress: bool = true

# === PRIVATE VARIABLES ===
var _selected_mesh: MeshInstance3D
var _is_initialized: bool = false
var _educational_overlay: Control

# === PUBLIC METHODS ===
## Initialize the selection system for educational use
## @returns: bool - true if initialization successful
func initialize_educational_selection() -> bool:
    \"\"\"Initialize the educational selection system with learning features\"\"\"
    if _is_initialized:
        push_warning(\"[Selection] Already initialized\")
        return false

    _setup_educational_features()
    _is_initialized = true
    return true

## Configure highlight colors for educational feedback
## @param selection_color: Color for selected structures
## @param hover_color: Color for hovered structures
func configure_educational_colors(selection_color: Color, hover_color: Color) -> void:
    \"\"\"Configure colors used for educational selection feedback\"\"\"
    highlight_color = selection_color
    # Implementation...

# === PRIVATE METHODS ===
func _setup_educational_features() -> void:
    \"\"\"Setup educational-specific selection features\"\"\"
    if educational_mode:
        _create_learning_tooltips()
        _initialize_progress_tracking()

func _create_learning_tooltips() -> void:
    \"\"\"Create educational tooltips for selected structures\"\"\"
    # Implementation...
```

##### **Error Handling Standards (REQUIRED)**

```gdscript
# Standard error handling pattern for educational features
func load_educational_content(structure_id: String) -> Dictionary:
    # Input validation with educational context
    if structure_id.is_empty():
        push_error(\"[EducationalContent] Structure ID cannot be empty\")
        return {}

    # Educational service availability check
    if not KnowledgeService.is_initialized():
        push_error(\"[EducationalContent] Knowledge service not available\")
        return {}

    # Educational content validation
    var content = KnowledgeService.get_structure(structure_id)
    if content.is_empty():
        push_warning(\"[EducationalContent] No educational content for: \" + structure_id)
        return {}

    # Success path with educational logging
    print(\"[EducationalContent] Loaded content for: \" + structure_id)
    return content
```

### **Project Structure Maintenance**

#### **Directory Organization Rules**

- **NEVER** add files to root directory except documentation
- **ALWAYS** place educational scripts in appropriate `core/` subdirectories
- **MAINTAIN** separation between UI (`ui/`) and business logic (`core/`)
- **PRESERVE** educational context in all new directories

#### **File Placement Guidelines**

```bash
# Educational content management
core/knowledge/          # Educational data services, search, normalization
core/ai/                # Educational AI assistance, tutoring systems
core/systems/           # Educational analytics, progress tracking

# Educational interactions
core/interaction/       # 3D selection, camera controls, gesture recognition
core/models/           # Educational model management, layer visualization

# Educational UI components
ui/components/         # Reusable educational UI elements
ui/panels/            # Educational information panels, study interfaces
ui/theme/             # Educational design system, accessibility themes

# Educational workflows
scenes/main/          # Primary educational interface scenes
scenes/debug/         # Educational debugging and testing scenes

# Educational assets
assets/data/          # Anatomical knowledge base, educational metadata
assets/models/        # 3D educational models with learning context
```

#### **New File Creation Process**

1. **Choose appropriate directory** based on functionality
2. **Follow naming conventions** (enforced by pre-commit hooks)
3. **Include educational context** in documentation
4. **Add proper class documentation** with learning objectives
5. **Update related documentation** in `docs/dev/`

### **Quality Assurance & Linting**

#### **Pre-commit Quality Checks (AUTOMATIC)**

The project uses comprehensive pre-commit hooks (`.git/hooks/pre-commit`):

```bash
# Quality checks run automatically on every commit:
✅ GDScript syntax validation
✅ Educational naming convention verification
✅ Debug statement detection (warnings)
✅ Secret/credential detection
✅ Large file detection (>5MB)
✅ Educational documentation requirements
✅ TODO/FIXME comment tracking
✅ Custom GDScript linting (when available)
```

#### **VS Code Integration (AUTOMATIC)**

Configuration in `.vscode/settings.json` provides:

- **Format on save**: Automatic code formatting
- **Educational linting**: GDScript quality checking
- **Tab standardization**: 4-space tabs for educational code
- **Educational file associations**: Proper syntax highlighting
- **Educational debugging**: Breakpoint and debugging support

#### **Manual Quality Commands**

```bash
# Run comprehensive quality checks
./tools/scripts/quick_test.sh

# Validate educational system integrity
test autoloads && test ui_safety && test infrastructure

# Check educational development environment
./tools/scripts/validate_integration.sh
```

### **Performance Standards for Educational Platform**

#### **Educational Performance Requirements**

- **UI Responsiveness**: 60fps educational interface interactions
- **3D Visualization**: Stable performance with complex anatomical models
- **Educational Content Loading**: <3 seconds from launch to first interaction
- **Memory Management**: Stable usage during extended educational sessions
- **Educational Accessibility**: WCAG 2.1 AA compliance maintained

#### **Performance Monitoring**

```bash
# In-game performance monitoring (F1 console)
performance              # Check educational platform performance
memory                  # Monitor educational content memory usage
models                  # List loaded educational 3D models
tree UI_Layer          # Inspect educational UI structure
```

### **Git Workflow Standards**

#### **Commit Message Format (ENFORCED)**

```
<type>(<scope>): <description>

[optional body explaining educational context]

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

#### **Educational Commit Types**

- **feat**: New educational feature
- **fix**: Educational bug fix
- **docs**: Educational documentation
- **style**: Educational code formatting
- **refactor**: Educational architecture improvement
- **test**: Educational testing additions
- **chore**: Educational maintenance

#### **Branch Strategy for Educational Development**

- **main**: Production educational platform
- **develop**: Educational feature integration
- **feature/educational-***: New educational features
- **fix/educational-***: Educational bug fixes
- **docs/educational-***: Educational documentation

#### **Pre-commit Checklist (AUTOMATIC + MANUAL)**

- [x] **Automatic**: GDScript syntax validation
- [x] **Automatic**: Educational naming conventions
- [x] **Automatic**: No secrets or credentials
- [x] **Automatic**: File size validation
- [ ] **Manual**: Educational context in commit message
- [ ] **Manual**: Educational documentation updated
- [ ] **Manual**: Accessibility compliance verified

## Active Autoload Systems (project.godot)

These singleton systems provide the educational platform foundation:

### **Primary Educational Services**

- **`KB`** - `core/knowledge/AnatomicalKnowledgeDatabase.gd` (Legacy, being phased out)
- **`KnowledgeService`** - `core/knowledge/KnowledgeService.gd` (**Primary educational content service**)
- **`AIAssistant`** - `core/ai/AIAssistantService.gd` (Educational AI support)

### **UI & Theme Management**

- **`UIThemeManager`** - `ui/panels/UIThemeManager.gd` (Enhanced/Minimal educational themes)

### **3D Model Management for Education**

- **`ModelSwitcherGlobal`** - `core/models/ModelVisibilityManager.gd` (Layer-based educational visualization)

### **Educational Analytics & Systems**

- **`StructureAnalysisManager`** - `core/systems/StructureAnalysisManager.gd` (Learning content analysis)
- **`DebugCmd`** - `core/systems/DebugCommands.gd` (Development & educational debugging)

### **Commented Out (Not Currently Active)**

```gdscript
# Development tools (enable as needed for educational feature development)
;ProjectProfiler=\"*res://tools/scripts/ProjectProfiler.gd\"
;TestFramework=\"*res://tools/scripts/TestFramework.gd\"
;BrainVisDebugger=\"*res://tools/scripts/BrainVisDebugger.gd\"
```

## Educational Application Flow

### **1. Entry Point**: Educational Main Scene

- **Scene**: `scenes/main/node_3d.tscn` (main educational interface)
- **Controller**: `scenes/main/node_3d.gd` (`NeuroVisMainScene` class)

### **2. Educational Initialization Sequence**

1. **Safety Framework**: UI component safety and autoload verification
2. **Core Educational Systems**: Selection manager → Camera controller → Model coordinator
3. **Educational UI**: Theme application → Panel factory → Educational features
4. **Knowledge Services**: Anatomical database → AI assistant → Educational content

### **3. Educational Interaction Flow**

1. **Structure Selection**: Right-click raycast-based selection with educational context
2. **Information Display**: Educational panels via `InfoPanelFactory` with learning-focused content
3. **AI Assistance**: Contextual educational queries and explanations
4. **Progress Tracking**: Learning analytics and educational workflow support

## Educational UI Architecture

### **Theme System for Learning**

The educational platform supports two primary themes optimized for different learning contexts:

#### **Enhanced Theme** (Gaming/Engaging Style)

- **File**: `ui/panels/UIThemeManager.gd`
- **Target**: Students, interactive learning sessions
- **Features**: Glassmorphism effects, vibrant colors, gamification elements
- **Usage**: `UIThemeManager.set_theme_mode(UIThemeManager.ThemeMode.ENHANCED)`

#### **Minimal Theme** (Professional/Clinical Style)

- **Target**: Clinical training, professional presentations
- **Features**: Clean design, medical-grade aesthetics, accessibility-first
- **Usage**: `UIThemeManager.set_theme_mode(UIThemeManager.ThemeMode.MINIMAL)`

### **Educational Panel System**

```gdscript
# Current Active Implementation (Unified System)
InfoPanelFactory.create_info_panel() → AdaptiveInfoPanel
├── Enhanced mode: Engaging educational interface
├── Minimal mode: Clinical/professional interface
├── Educational features: Study questions, clinical notes, progress tracking
└── Accessibility: Screen reader support, keyboard navigation

# Educational Panel Features:
├── Quick Facts (always visible for rapid learning)
├── Functions (expandable, with clinical context)
├── Clinical Relevance (expandable, pathology information)
├── Study Questions (interactive educational content)
├── Progress Tracking (learning analytics integration)
└── AI Assistant Integration (contextual educational support)
```

### **Deprecated Panel Implementations**

**⚠️ These files exist but should NOT be used for new development:**

- `ui/panels/minimal_info_panel.gd` (Merged into AdaptiveInfoPanel)
- `scenes/ui_info_panel.gd` (Legacy, superseded by enhanced system)
- `ui/panels/ModernInfoDisplay.gd` (Deprecated in favor of EnhancedInformationPanel)

## Educational Development Commands

### **Launch Educational Platform**

```bash
# Primary development launch
godot --path \"/Users/gagelaporta/1NeuroPro/NeuroVisProject/1/(4)NeuroVis copy\"

# Quick test suite (validates educational features)
./tools/scripts/quick_test.sh

# Development environment validation
./tools/scripts/validate_integration.sh
```

### **Educational Feature Testing**

```bash
# Comprehensive educational system testing
./tools/scripts/test_components.gd    # UI component validation
./tools/scripts/test_refactoring.gd   # Architecture validation
./tools/scripts/test_theme_implementation.gd  # Theme system testing
```

## Educational Debug Commands (F1 + Enter)

The in-game debug console provides educational development tools:

### **Educational System Testing**

- `test autoloads` - Validate educational services (KB, KnowledgeService, AIAssistant)
- `test infrastructure` - Check educational platform foundation
- `test ui_safety` - Validate educational UI component safety

### **Educational Content Management**

- `kb status` - Check knowledge base status and educational content availability
- `kb search [term]` - Search educational anatomical database
- `knowledge [structure]` - Test educational content retrieval

### **Educational Feature Debugging**

- `models` - List available educational 3D models
- `tree [node_path]` - Inspect educational scene structure
- `clear_debug` - Clear educational debug overlays

### **Educational Analytics**

- `performance` - Check educational platform performance metrics
- `memory` - Monitor educational content memory usage

## Educational Knowledge Base System

### **Modern Educational Content Service (Primary)**

- **Service**: `KnowledgeService` (autoload)
- **File**: `core/knowledge/KnowledgeService.gd`
- **Data Source**: `assets/data/anatomical_data.json`
- **Features**: Educational content normalization, fuzzy search, clinical context

#### **Educational Content Access Patterns**

```gdscript
# Primary educational content access
var structure_data = KnowledgeService.get_structure(\"hippocampus\")
var search_results = KnowledgeService.search_structures(\"memory\")

# Educational content structure:
{
    \"id\": \"hippocampus\",
    \"displayName\": \"Hippocampus\",
    \"shortDescription\": \"Essential for memory formation and spatial navigation\",
    \"functions\": [\"Memory consolidation\", \"Spatial navigation\", \"Pattern separation\"],
    \"clinicalRelevance\": \"Critical in Alzheimer's disease pathology\",
    \"educationalLevel\": \"intermediate\",
    \"learningObjectives\": [\"Identify location\", \"Understand function\", \"Recognize pathology\"]
}
```

### **Educational Structure Name Normalization**

The educational platform handles complex 3D model naming through intelligent normalization:

- Model: `\"Striatum (good)\"` → Educational Content: `\"Striatum\"`
- Model: `\"Hipp and Others (good)\"` → Educational Content: `\"Hippocampus\"`
- Handled by: `KnowledgeService._normalize_structure_name()`

### **Legacy Knowledge Base (Being Phased Out)**

- **Service**: `KB` (autoload)
- **Status**: ⚠️ Legacy system, migrate to KnowledgeService for new educational features
- **Usage**: Only for backwards compatibility

## Educational Interaction Systems

### **Educational Structure Selection**

- **File**: `core/interaction/BrainStructureSelectionManager.gd`
- **Function**: Handles educational 3D structure selection with learning context
- **Features**: Visual highlighting, educational tooltips, learning progress tracking

### **Educational Camera System**

- **File**: `core/interaction/CameraBehaviorController.gd`
- **Function**: Manages camera for optimal educational viewing
- **Features**: Preset educational views, structure focusing, guided tour support

### **Educational Model Management**

- **File**: `core/models/ModelRegistry.gd`
- **Function**: Coordinates educational 3D model loading and layer management
- **Features**: Progressive disclosure, educational model presets, learning sequence support

## Educational Data Architecture

### **Educational Knowledge Base**

- **Primary File**: `assets/data/anatomical_data.json`
- **Format**: Educational JSON with learning-focused metadata

```json
{
  \"structures\": [
    {
      \"id\": \"structure_id\",
      \"displayName\": \"User-friendly name\",
      \"shortDescription\": \"Educational description\",
      \"functions\": [\"Learning-focused function list\"],
      \"clinicalRelevance\": \"Medical/clinical importance\",
      \"educationalLevel\": \"beginner|intermediate|advanced\",
      \"learningObjectives\": [\"Specific learning goals\"],
      \"commonPathologies\": [\"Associated medical conditions\"]
    }
  ]
}
```

### **Educational 3D Models**

- **Location**: `assets/models/`
- **Format**: GLTF (.glb files) optimized for educational use
- **Examples**:
  - `Half_Brain.glb` (Sectional anatomy education)
  - `Internal_Structures.glb` (Deep brain education)
  - `Brainstem(Solid).glb` (Brainstem education)

## Educational Controls (In-App)

### **Primary Educational Interactions**

- **Right-click**: Select brain structures (triggers educational content display)
- **Left-click + drag**: Orbit camera for optimal educational viewing
- **Mouse wheel**: Zoom for detailed educational examination
- **F**: Focus view on educational model bounds
- **R**: Reset camera for educational overview

### **Educational Camera Presets**

- **1**: Front view (standard educational perspective)
- **3**: Right sagittal view (educational sectional anatomy)
- **7**: Top view (educational superior perspective)

### **Educational Debug Access**

- **F1**: Open educational debug console
- **F1 + Enter**: Execute educational debug commands

## Common Educational Development Issues

### **Educational Content Not Displaying**

```bash
# Diagnosis
kb status                    # Check knowledge base initialization
knowledge [structure_name]   # Test specific educational content access

# Common Causes:
# 1. Structure name normalization mismatch
# 2. KnowledgeService not initialized
# 3. JSON educational content malformed
```

### **Educational Panel Not Showing**

```bash
# Diagnosis
test ui_safety              # Validate educational UI component safety
tree UI_Layer               # Check educational UI scene structure

# Common Causes:
# 1. InfoPanelFactory cannot create educational panel type
# 2. Theme system not properly initialized
# 3. Educational autoloads missing
```

### **Educational Model Loading Issues**

```bash
# Diagnosis
models                      # List available educational models
test infrastructure         # Check educational model system

# Common Causes:
# 1. Educational model file missing from assets/models/
# 2. ModelRegistry educational configuration incorrect
# 3. Educational model format incompatible
```

## Educational Platform Documentation

### **Educational Development Guides**

- **`docs/Setup_Documentation/`** - Educational platform technical setup
- **`docs/dev/`** - Educational feature development guides
- **`docs/Roadmap_Docs/`** - Educational platform development phases

### **Educational Architecture**

- **`docs/refactoring/`** - Educational architecture evolution guides
- **Current file** - Comprehensive educational development reference

## Recent Educational Platform Changes

### **✅ Completed Educational Enhancements**

- **Educational Architecture**: Migration from flat to modular educational system
- **Enhanced Educational Content**: KnowledgeService with educational metadata normalization
- **Educational UI Theming**: Enhanced/Minimal themes optimized for learning contexts
- **Educational Testing**: Comprehensive testing framework for educational features
- **Educational Accessibility**: WCAG 2.1 compliance for diverse learning needs

### **🚧 In Progress Educational Features**

- **Educational State Management**: User preference persistence for educational settings
- **Educational Analytics**: Learning progress tracking and assessment tools
- **Advanced Educational Interactions**: Multi-modal input for enhanced learning
- **Educational Collaboration**: Multi-user educational sessions and guided tours

### **📋 Planned Educational Enhancements**

- **Educational AI Enhancement**: Advanced contextual learning support
- **Educational Assessment**: Integrated quizzing and knowledge evaluation
- **Educational Workflow**: Structured learning pathways and curriculum integration
- **Educational Platform Integration**: LMS connectivity and institutional support

## Educational Troubleshooting

### **Educational Platform Startup Issues**

1. **Check Educational Autoloads**: Ensure all educational services in project.godot are accessible
2. **Validate Educational Content**: Confirm `assets/data/anatomical_data.json` exists and is valid
3. **Test Educational UI**: Run `test ui_safety` to validate educational component framework

### **Educational Content Access Problems**

1. **KnowledgeService Status**: Run `kb status` to check educational content initialization
2. **Educational Search**: Use `kb search [term]` to test educational content retrieval
3. **Structure Normalization**: Check educational name mapping via debug console

### **Educational Performance Issues**

1. **Educational Memory**: Monitor educational content memory usage with `memory` command
2. **Educational Performance**: Check platform performance metrics with `performance` command
3. **Educational UI**: Verify educational theme system not causing excessive redraws

### **Code Quality Issues**

1. **Pre-commit Failures**: Address naming conventions, syntax errors, or documentation requirements
2. **Educational Standards**: Review `docs/dev/DEVELOPMENT_STANDARDS_MASTER.md`
3. **Linting Errors**: Check VS Code output for GDScript linting issues

## Educational Quick Reference

### **Essential Educational Development Commands**

```bash
# Launch educational platform
godot --path \"/Users/gagelaporta/1NeuroPro/NeuroVisProject/1/(4)NeuroVis copy\"

# Validate educational systems
./tools/scripts/quick_test.sh

# Test educational components
test autoloads && test ui_safety && test infrastructure
```

### **Educational Content Access**

```gdscript
# Primary educational content service
var structure = KnowledgeService.get_structure(\"hippocampus\")
var results = KnowledgeService.search_structures(\"memory\")

# Educational panel creation
var panel = InfoPanelFactory.create_info_panel()
panel.display_structure_info(structure)

# Educational theme management
UIThemeManager.set_theme_mode(UIThemeManager.ThemeMode.ENHANCED)  # Student-friendly
UIThemeManager.set_theme_mode(UIThemeManager.ThemeMode.MINIMAL)   # Clinical/professional
```

### **Educational Feature Development Checklist**

- [ ] **Code Quality**: Pre-commit hooks pass automatically
- [ ] **Educational Content**: Added to `anatomical_data.json` with learning metadata
- [ ] **Educational UI**: Uses `UIThemeManager` for consistent theming
- [ ] **Educational Logic**: Content accessed via `KnowledgeService` (not legacy KB)
- [ ] **Educational Panels**: Created via `InfoPanelFactory` for adaptability
- [ ] **Educational Testing**: Features tested with `test autoloads` and `test ui_safety`
- [ ] **Educational Accessibility**: WCAG 2.1 compliance verified
- [ ] **Educational Performance**: Target performance validated (60fps, <3s loading)
- [ ] **Educational Documentation**: Class documentation with learning objectives included
- [ ] **Educational Standards**: Follows established naming conventions and architecture patterns

### **Quality Assurance Checklist**

- [ ] **Naming Conventions**: PascalCase classes, snake_case functions/variables
- [ ] **Educational Context**: All new code includes educational purpose documentation
- [ ] **Error Handling**: Proper validation and educational error messages
- [ ] **Performance**: Maintains 60fps educational interface performance
- [ ] **Accessibility**: Educational features work with screen readers and keyboard navigation
- [ ] **Testing**: Educational functionality validated through debug console commands

## Header Metadata

**Version:** 2.1.0
**Maintainer:** Gage LaPorta
**Last Updated:** 2024-05-28
**Project Path:** `/Users/gagelaporta/1NeuroPro/NeuroVisProject/1/(4)NeuroVis copy`
**Godot Version:** 4.4.1

> WHY: Version tracking prevents confusion about which documentation applies to current codebase.

## Quick-Start Commands

```bash
# Install dependencies
pre-commit install

# Run project
godot --path \"/Users/gagelaporta/1NeuroPro/NeuroVisProject/1/(4)NeuroVis copy\"

# Test suite
./tools/scripts/quick_test.sh

# Lint check
test autoloads && test ui_safety && test infrastructure

# Clean build artifacts
rm -rf .godot/
```

> WHY: One-command setup reduces onboarding friction for new developers and AI agents.

## System Requirements

**Godot Build Hash:** `4.4.1.stable.official [46f4ac4fe]`
**Operating System:** macOS 14.5+ (Silicon/Intel compatible)
**Minimum GPU:** Metal-compatible graphics (integrated Intel/AMD sufficient)
**RAM:** 8GB minimum, 16GB recommended for large brain models
**Storage:** 2GB for project + models

> WHY: Hardware requirements prevent environment-related bugs and performance issues.

## Dependencies

**Core Dependencies:**

- Godot Engine 4.4.1 (educational 3D platform)
- Pre-commit hooks v3.6.0+ (code quality)

**External Addons:** None currently required
**Tool Scripts:**

- `tools/scripts/quick_test.sh` (test runner)
- `tools/scripts/validate_integration.sh` (environment checker)
- `tools/scripts/ProjectProfiler.gd` (performance analysis)

> WHY: Version pinning prevents dependency conflicts and ensures reproducible builds.

## CI / Automation

**Provider:** Local pre-commit hooks (GitHub Actions planned)
**Pipeline Stages:**

1. GDScript syntax validation
2. Naming convention enforcement
3. Educational documentation checks
4. Secret detection
5. Large file detection

**Badge URL:** *TBD - GitHub Actions integration pending*

> WHY: Automated quality gates catch issues before they reach main branch.

## Secrets Handling

**Environment File:** `.env.example` (template for local development)
**Required Keys:**

- `ANTHROPIC_API_KEY` (AI assistant features)
- `GODOT_DEBUG_PORT` (remote debugging)

**Never Touch List:**

- Production API keys in environment variables
- User analytics data files
- Medical imagery patient data

> WHY: Proper secret management prevents data breaches and regulatory violations.

## Danger-Zone Paths

**Claude MUST NOT Edit:**

- `project.godot` (autoload configuration)
- `assets/models/*.glb` (3D brain models)
- `assets/data/anatomical_data.json` (medical knowledge base)
- `.git/hooks/pre-commit` (quality enforcement)
- User preference files in `user://`

> WHY: These files require domain expertise or contain sensitive/expensive-to-replace data.

## Update Protocol

**CLAUDE.md Editor:** Project maintainer only
**Review Rule:** All changes require testing with `./quick_test.sh`
**Change Log:** Track major updates in `CHANGELOG.md`
**Approval Process:** Educational content changes need medical review

> WHY: Controlled updates prevent documentation drift and maintain educational accuracy.

## Release Workflow

**Version Format:** Semantic Versioning (SemVer)
**Tag Rule:** `v{MAJOR}.{MINOR}.{PATCH}` (e.g., v2.1.0)
**Build Artifacts Location:** `exports/` directory
**Release Checklist:**

1. Update version in project.godot
2. Test educational workflows
3. Export for target platforms
4. Tag release in git

> WHY: Consistent releases enable stable educational platform deployment.

## Performance Budgets

**Frame Rate:** 60fps minimum for educational interactions
**Draw Calls:** <100 per frame (brain model complexity limit)
**Texture Memory:** <500MB total (all brain textures loaded)
**Build Size:** <2GB exported application
**Loading Time:** <3 seconds from launch to first interaction

> WHY: Performance boundaries ensure smooth educational experience across target hardware.

## Accessibility Checklist

**Font Size:** 16px minimum (educational text legibility)
**Contrast Ratio:** 4.5:1 minimum (WCAG AA compliance)
**Keyboard Navigation:** All UI accessible via Tab/Enter/Arrow keys
**Screen Reader:** All educational content has semantic markup
**Color Blindness:** UI functional without color dependency

> WHY: Inclusive design ensures educational platform serves diverse learning needs.

## Testing Targets

**Code Coverage:** 70% minimum for core educational systems
**Performance Regression Gate:** >5% frame rate drop fails CI
**Educational Content:** 100% of anatomical data validated
**UI Coverage:** All educational panels tested in both themes
**Load Testing:** 1-hour continuous session stability

> WHY: Quality thresholds prevent regressions in educational functionality.

## Logging & Telemetry

**Log Levels:** DEBUG, INFO, WARN, ERROR
**File Paths:** `user://logs/neurovis.log` (local development)
**PII Redaction:** Automatically strip user-identifiable learning data
**Retention:** 30 days local, anonymized analytics only
**Format:** JSON structured logging for educational analytics

> WHY: Proper logging enables debugging while protecting student privacy.

## Analytics / Privacy Policy

**Data Collected:** Educational interaction patterns (anonymized)
**Opt-in Toggle:** Required user consent for learning analytics
**Storage:** Local-only unless explicitly opted into research
**Compliance:** FERPA-compliant for educational use
**Data Export:** User can export/delete their learning data

> WHY: Transparent data practices build trust and ensure regulatory compliance.

## Architecture Diagram

**Location:** `docs/architecture/system_overview.png`
**Format:** SVG (editable) + PNG (viewable)
**ASCII Fallback:**

```
User Interface (ui/)
├─ Enhanced Theme (student-friendly)
├─ Minimal Theme (clinical)
└─ InfoPanel Factory
    ↓
Core Systems (core/)
├─ Knowledge Service (educational content)
├─ AI Assistant (learning support)
├─ Model Manager (3D brain models)
└─ Analytics (learning progress)
    ↓
3D Engine (Godot 4.4.1)
```

> WHY: Visual architecture aids understanding for new developers and system maintenance.

## Glossary

**KB:** Knowledge Base (legacy educational content system)
**KnowledgeService:** Modern educational content management system
**MCP:** Model Context Protocol (AI agent communication)
**InfoPanel:** Educational information display component
**Enhanced/Minimal:** UI theme modes for different learning contexts
**Autoload:** Godot singleton service available globally

> WHY: Shared vocabulary reduces miscommunication in educational development.

## AI Guardrails

**MAY:**

- Add new educational features following established patterns
- Fix bugs in core/ and ui/ directories
- Update educational content in anatomical_data.json
- Create new GDScript files following naming conventions

**MUST NOT:**

- Modify project.godot autoload configuration
- Delete or rename existing 3D brain models
- Change medical terminology without domain expert review
- Edit pre-commit hooks or quality enforcement

**Limits:**

- Max diff size: 500 lines per file
- Context trim: Keep last 50 messages for educational context

> WHY: Boundaries prevent AI from making changes requiring human domain expertise.

## MCP / Slash-Command Reference

**Syntax Examples:**

```bash
# Educational content search
/kb search hippocampus

# Test educational systems
/test autoloads ui_safety infrastructure

# Performance monitoring
/debug performance memory models
```

**JSON Command Shapes:**

```json
{
  \"command\": \"kb_search\",
  \"parameters\": {
    \"term\": \"hippocampus\",
    \"limit\": 10
  }
}
```

> WHY: Standardized commands enable consistent AI-agent interaction patterns.

## Pre-commit Install

```bash
pre-commit install
```

Run this command once after cloning to enable automatic code quality checks.

> WHY: One-line setup ensures all developers use the same quality standards.

## Error Code Registry

**EDU-001:** Educational content not found in knowledge base
**EDU-002:** 3D brain model failed to load or render
**EDU-003:** UI theme switching error in educational interface
**EDU-004:** AI assistant service unavailable or timeout
**EDU-005:** User preference save/load failure
**EDU-006:** Educational analytics data corruption
**EDU-007:** Scene initialization failed
**EDU-008:** Autoload dependency not found
**EDU-009:** Invalid educational content format
**EDU-010:** Memory limit exceeded during model loading

> WHY: Enumerated errors enable faster debugging and user support.

## License & Contribution

**License:** MIT License (SPDX-License-Identifier: MIT)
**Contribution Guide:** See `CONTRIBUTING.md`
**Code of Conduct:** Educational platform maintains inclusive learning environment
**Medical Content:** Requires domain expert review for anatomical accuracy

> WHY: Clear licensing and contribution rules protect both project and contributors.

## Hardware Profile Script

**Path:** `tools/hardware_dump.sh`
**Purpose:** Collect system specs for performance optimization
**Usage:** `./tools/hardware_dump.sh > hardware_profile.txt`
**Output:**

- GPU model, driver version, Metal support level
- System memory (total/available)
- OS version and architecture
- Godot renderer capabilities
- Display configuration (resolution, refresh rate)

> WHY: Hardware profiling helps optimize educational platform for user devices.

---

**NeuroVis Educational Platform** - Transforming neuroanatomy education through interactive 3D visualization, AI-powered learning assistance, and accessibility-first design for medical students and healthcare professionals.
