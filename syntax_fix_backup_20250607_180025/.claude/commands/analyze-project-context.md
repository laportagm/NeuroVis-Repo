# Analyze NeuroVis Project Context

**Purpose:** Comprehensive project state analysis for enhanced Claude Code CLI effectiveness
**MCP Servers:** filesystem, godot-mcp, sequential-thinking, memory, sqlite
**Autoload Integration:** All NeuroVis core services (KB, KnowledgeService, AIAssistant, UIThemeManager, AccessibilityManager, DebugCmd, AIConfig)

## Command

```bash
claude execute --mcp-server filesystem,godot-mcp,sequential-thinking,memory --prompt 'You are an expert NeuroVis educational medical visualization project analyst with deep Godot 4.4 and GDScript expertise. Perform comprehensive project state analysis for optimal development context.

ANALYSIS WORKFLOW:

**Phase 1: Project Structure Analysis**
1. Analyze core directory structure in /Users/gagelaporta/Desktop/Neuro/NeuroVis-Repo/
2. Identify all .gd files and their purposes
3. Map educational component architecture
4. Check for any backup or duplicate files causing conflicts
5. Verify assets/data/anatomical_data.json structure

**Phase 2: Autoload Service Assessment**
1. Analyze core/systems/ autoload services status
2. Check AIAssistantService.gd and GeminiAIService.gd integration
3. Verify UIThemeManager.gd educational theming
4. Assess AccessibilityManager.gd WCAG 2.1 AA compliance
5. Review DebugCommands.gd system functionality
6. Validate AIConfigurationManager.gd setup

**Phase 3: Educational Content Analysis**
1. Review scenes/main/ educational workflows
2. Analyze ui/panels/ for medical education interfaces
3. Check core/education/ learning pathway systems
4. Assess core/models/ 3D brain visualization components
5. Verify medical terminology accuracy systems

**Phase 4: Error Detection & Issue Identification**
1. Scan for GDScript syntax errors and parse issues
2. Check for indentation problems in class bodies
3. Identify @tool annotation placement issues
4. Look for class name conflicts or duplicate definitions
5. Verify signal connections and autoload dependencies

**Phase 5: Performance & Quality Assessment**
1. Analyze 3D rendering optimization for 60fps target
2. Check memory usage patterns in educational modules
3. Review LOD systems for complex brain models
4. Assess accessibility implementation quality
5. Validate medical accuracy validation systems

**Phase 6: Documentation & Configuration Status**
1. Review .claude/commands/ existing command structure
2. Check project.godot configuration
3. Assess CLAUDE.md and documentation completeness
4. Verify MCP server integration readiness

**ANALYSIS REQUIREMENTS:**
- Use sequential-thinking for complex multi-step analysis
- Store findings in memory for persistent context
- Focus on educational integrity and medical accuracy
- Maintain Godot 4.4 and GDScript best practices
- Prioritize autoload service dependencies
- Consider 60fps performance targets
- Ensure WCAG 2.1 AA accessibility compliance

**OUTPUT FORMAT:**
Provide structured analysis with:
1. **Project Health Summary** - Overall status and critical issues
2. **Autoload Service Status** - Each service functionality state
3. **Educational Architecture Map** - Learning systems organization
4. **Error Report** - Prioritized list of issues requiring attention
5. **Performance Analysis** - 3D visualization and UI optimization status
6. **Medical Accuracy Assessment** - Terminology and content validation
7. **Development Readiness** - What can be safely worked on vs. what needs fixing first
8. **Recommended Next Steps** - Priority order for development tasks

Store this analysis in memory with tags: ["project-context", "neurovis-state", "development-readiness"] for future command reference.'
```

## Educational Context

This command provides essential project understanding for:
- Medical visualization accuracy maintenance
- Educational workflow preservation
- 3D brain model interaction systems
- Accessibility compliance verification
- Learning objective completion tracking

## Usage Instructions

1. **Run before any development session:**
   `claude-code analyze-project-context`
2. **Wait for complete analysis** before proceeding with specific tasks
3. **Reference stored memory** in subsequent commands using tags
4. **Re-run when major changes occur** to maintain current context

## Integration with Development Workflow

- **Before educational component creation:** Understand current UI architecture
- **Before 3D model modifications:** Check performance baseline and LOD systems
- **Before autoload changes:** Verify service dependencies and integration points
- **Before medical content updates:** Confirm accuracy validation systems
- **Before accessibility improvements:** Assess current compliance status

## Memory Integration

Analysis results stored with searchable tags enable:
- Quick context retrieval: 'Retrieve memories tagged with "project-context"'
- Issue tracking: 'Search memories for "critical-errors"'
- Progress monitoring: 'Compare current state with "baseline-analysis"'

## Performance Considerations

- Analysis optimized for 60fps educational experience maintenance
- Focus on identifying performance bottlenecks in 3D brain visualization
- Memory usage assessment for educational module loading
- UI responsiveness verification for medical student workflows

## Expected Analysis Output Structure

### 1. Project Health Summary
- Overall codebase stability rating
- Critical blocking issues requiring immediate attention
- Educational system integrity status
- Medical accuracy validation state

### 2. Autoload Service Status
- **KB (Legacy):** Migration status and compatibility
- **KnowledgeService:** Educational content service functionality
- **AIAssistant:** Learning support system status
- **UIThemeManager:** Enhanced/Minimal theme switching capability
- **AccessibilityManager:** WCAG 2.1 AA compliance level
- **DebugCmd:** Development tool availability

### 3. Educational Architecture Map
- Core educational systems organization
- Learning pathway coordinator status
- 3D brain model interaction workflow
- UI component factory patterns
- Knowledge base integration points

### 4. Error Report (Priority Ordered)
- **P0 Critical:** Blocking educational functionality
- **P1 High:** Impacting medical accuracy or accessibility
- **P2 Medium:** Performance or user experience issues
- **P3 Low:** Code quality and maintenance items

### 5. Performance Analysis
- 60fps target achievement status
- Memory usage patterns in educational modules
- 3D rendering optimization opportunities
- LOD system effectiveness for brain models
- UI responsiveness benchmarks

### 6. Medical Accuracy Assessment
- Anatomical terminology validation systems
- Educational content verification processes
- Clinical relevance accuracy checks
- Learning objective alignment verification

### 7. Development Readiness Matrix
- **Safe to modify:** Components with stable foundations
- **Requires caution:** Areas with complex dependencies
- **Needs fixing first:** Blocking issues preventing development
- **Documentation required:** Under-documented critical systems

### 8. Recommended Next Steps
1. **Immediate priorities:** Critical error resolution
2. **Short-term goals:** Performance and accessibility improvements
3. **Medium-term objectives:** Educational feature enhancements
4. **Long-term vision:** Platform scalability and advanced features

## Command Variations

### Quick Health Check
```bash
claude execute --mcp-server filesystem --prompt 'Run quick NeuroVis health check focusing on critical errors and autoload service status only.'
```

### Performance Focus
```bash
claude execute --mcp-server filesystem,sequential-thinking --prompt 'Analyze NeuroVis project focusing specifically on 3D rendering performance and educational module efficiency.'
```

### Educational Content Focus
```bash
claude execute --mcp-server filesystem,memory --prompt 'Deep analysis of NeuroVis educational content systems, learning pathways, and medical accuracy validation.'
```

This command serves as your project 'health check' and context foundation for all subsequent NeuroVis development tasks.
