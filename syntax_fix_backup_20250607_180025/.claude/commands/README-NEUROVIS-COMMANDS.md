# NeuroVis Educational Command Architecture

This directory contains comprehensive command files optimized for NeuroVis educational neuroscience workflows, leveraging multiple MCP servers for maximum development efficiency and educational impact.

## Command Overview

### Core Educational Command Categories

#### 1. **create-educational-component.md**
**Primary MCPs**: `godot-mcp`, `filesystem`, `memory`
**Purpose**: Create reusable educational components with comprehensive NeuroVis architecture integration
**Key Features**:
- GDScript educational component generation following NeuroVis standards
- Integration with KnowledgeService, UIThemeManager, and AIAssistant autoloads
- Accessibility compliance (WCAG 2.1 AA) and medical accuracy validation
- Enhanced/Minimal theme support for diverse learning contexts
- Performance optimization for 60fps educational interactions

#### 2. **validate-medical-accuracy.md**
**Primary MCPs**: `fetch`, `memory`, `sequential-thinking`
**Purpose**: Ensure comprehensive medical accuracy across all educational content
**Key Features**:
- External medical database validation (PubMed, WHO ICD, Gray's Anatomy)
- Expert medical review process integration
- Automated terminology validation against medical standards
- Clinical relevance and pathology accuracy verification
- Compliance tracking for medical education accreditation

#### 3. **optimize-3d-performance.md**
**Primary MCPs**: `godot-mcp`, `sequential-thinking`, `playwright`
**Purpose**: Maintain 60fps performance with complex brain models while preserving educational value
**Key Features**:
- Educational priority-based LOD (Level of Detail) system
- Brain model memory management and texture optimization
- Real-time performance monitoring during educational workflows
- Cross-platform performance validation and optimization
- Educational interaction performance preservation

#### 4. **debug-educational-workflow.md**
**Primary MCPs**: `godot-mcp`, `filesystem`, `memory`
**Purpose**: Systematic debugging of educational workflows using DebugCmd integration
**Key Features**:
- DebugCmd system integration for educational workflow diagnostics
- Automated issue detection for learning disruption prevention
- Interactive debugging tools for educational component development
- Root cause analysis for complex educational workflow problems
- Educational quality preservation during debugging processes

#### 5. **manage-anatomical-knowledge.md**
**Primary MCPs**: `sqlite`, `memory`, `fetch`
**Purpose**: Comprehensive management of anatomical knowledge base with medical validation
**Key Features**:
- SQLite database optimization for educational content queries
- Knowledge graph construction for anatomical relationships
- External medical source validation and currency verification
- KnowledgeService integration with backward compatibility
- Educational metadata enhancement and learning objective tracking

#### 6. **collaborative-development.md**
**Primary MCPs**: `github`, `filesystem`, `memory`
**Purpose**: Facilitate educational platform team collaboration with medical review processes
**Key Features**:
- Medical expert review workflow integration
- Educational design collaboration with accessibility specialists
- GitHub repository organization for educational content development
- Quality assurance integration for medical accuracy and educational effectiveness
- Team knowledge management for educational platform expertise

#### 7. **accessibility-compliance-check.md**
**Primary MCPs**: `playwright`, `sequential-thinking`, `filesystem`
**Purpose**: Ensure WCAG 2.1 AA compliance for diverse educational learning needs
**Key Features**:
- Comprehensive automated accessibility testing for educational workflows
- Screen reader compatibility validation for anatomical content
- Keyboard navigation testing for 3D educational interactions
- Manual accessibility auditing procedures for medical education contexts
- Assistive technology integration testing and validation

#### 8. **generate-educational-documentation.md**
**Primary MCPs**: `filesystem`, `memory`, `codecmcp`
**Purpose**: Create comprehensive educational documentation with medical accuracy validation
**Key Features**:
- Automated technical documentation generation from NeuroVis codebase
- Educational content synthesis from knowledge graph relationships
- Medical accuracy documentation with expert validation
- Multi-format accessible documentation generation (HTML, PDF, Markdown)
- Accessibility documentation for inclusive educational design

## MCP Server Integration Strategy

### Multi-Server Command Design
Each command leverages multiple MCP servers for maximum efficiency:

- **Primary MCP**: Main functionality and workflow execution
- **Secondary MCPs**: Supporting functions, validation, and enhancement
- **Integration MCPs**: Cross-system coordination and data synchronization

### NeuroVis Autoload Integration
All commands integrate with NeuroVis autoload services:
- **KnowledgeService**: Educational content and anatomical data
- **AIAssistant**: Educational AI support and contextual learning
- **UIThemeManager**: Enhanced/Minimal theme support for diverse audiences
- **DebugCmd**: Development debugging and educational workflow validation
- **StructureAnalysisManager**: Learning analytics and educational assessment

### Educational Quality Standards
Every command ensures:
- **Medical Accuracy**: Expert validation and authoritative source verification
- **Educational Effectiveness**: Learning objective alignment and assessment integration
- **Accessibility Compliance**: WCAG 2.1 AA standards for inclusive learning
- **Performance Optimization**: 60fps educational interactions with complex 3D models
- **Code Quality**: GDScript 4.4 standards with NeuroVis naming conventions

## Usage Guidelines

### Command Execution
```bash
# Execute educational component creation
claude -f .claude/commands/create-educational-component.md "Create hippocampus learning module"

# Validate medical accuracy for anatomical content
claude -f .claude/commands/validate-medical-accuracy.md "Validate brainstem educational content"

# Optimize 3D performance for complex brain models
claude -f .claude/commands/optimize-3d-performance.md "Optimize cerebral cortex visualization"

# Debug educational workflow issues
claude -f .claude/commands/debug-educational-workflow.md "Debug memory pathway learning workflow"

# Manage anatomical knowledge database
claude -f .claude/commands/manage-anatomical-knowledge.md "Update hippocampus clinical information"

# Coordinate team collaboration for educational features
claude -f .claude/commands/collaborative-development.md "Setup medical expert review for new content"

# Check accessibility compliance for educational interfaces
claude -f .claude/commands/accessibility-compliance-check.md "Validate learning module accessibility"

# Generate comprehensive educational documentation
claude -f .claude/commands/generate-educational-documentation.md "Create user guide for medical students"
```

### Educational Context Requirements
When using commands, always provide:
- **Target Audience**: Medical students, healthcare professionals, educators
- **Educational Level**: Beginner, intermediate, advanced
- **Clinical Context**: Medical relevance and pathology connections
- **Learning Objectives**: Specific educational outcomes and assessment criteria

### Quality Validation
Each command includes:
- **Medical Accuracy Checks**: Expert review and database validation
- **Educational Effectiveness Validation**: Learning outcome verification
- **Accessibility Compliance Testing**: WCAG 2.1 AA standard verification
- **Performance Monitoring**: 60fps maintenance with educational functionality
- **Integration Testing**: NeuroVis autoload service compatibility

## Educational Platform Architecture Integration

### Core System Compatibility
Commands integrate with NeuroVis core architecture:
```
core/
├── ai/ (AIAssistant integration)
├── education/ (Educational module coordination)
├── interaction/ (3D educational interactions)
├── knowledge/ (KnowledgeService integration)
├── models/ (Educational 3D model management)
└── systems/ (DebugCmd and educational system coordination)

ui/
├── components/ (Educational UI component creation)
├── panels/ (Educational information display)
└── theme/ (Enhanced/Minimal educational theming)
```

### Educational Workflow Support
Commands support complete educational workflows:
1. **Content Creation**: Medical accuracy validation and educational design
2. **Development**: Technical implementation with performance optimization
3. **Testing**: Accessibility compliance and educational effectiveness validation
4. **Deployment**: Quality assurance and collaborative review processes
5. **Maintenance**: Documentation generation and knowledge management

## Success Metrics

### Educational Excellence
- Medical accuracy validated by expert review and authoritative sources
- Learning objectives clearly defined and assessment-integrated
- Accessibility compliance ensures inclusive educational access
- Educational effectiveness verified through user testing and feedback

### Technical Quality
- 60fps performance maintained during complex educational interactions
- GDScript 4.4 standards with NeuroVis naming conventions followed
- Integration with all NeuroVis autoload services successful
- Code quality and documentation standards exceeded

### Collaborative Effectiveness
- Medical expert review process streamlined and efficient
- Educational design collaboration enhanced through structured workflows
- Quality assurance integration prevents educational and technical regressions
- Team knowledge management preserves educational platform expertise

---

**NeuroVis Educational Command Architecture** - Transforming neuroanatomy education through systematic, collaborative, and medically-accurate development workflows optimized for diverse learning needs and educational excellence.
