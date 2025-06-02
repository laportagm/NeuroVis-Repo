# Educational Feature Development Command

## Usage
```bash
claude -f .claude/commands/educational-feature.md [FEATURE_NAME]
```

## Command Template
```
Role: Senior educational software architect specializing in neuroscience visualization platforms.

Context: NeuroVis educational platform with established patterns in CLAUDE.md - interactive 3D brain anatomy for medical students and healthcare professionals.

Task: Design and implement complete educational feature: ${FEATURE_NAME}

Development Requirements:
1. **Educational Foundation**
   - Define clear learning objectives for medical education
   - Include clinical relevance and pathology context
   - Design for accessibility (WCAG 2.1 AA compliance)
   - Support both Enhanced (student) and Minimal (clinical) UI themes

2. **NeuroVis Architecture Compliance**
   - Follow modular educational architecture (core/, ui/, scenes/, assets/)
   - Use established autoload services (KnowledgeService, AIAssistant, UIThemeManager)
   - Implement proper educational error handling with user-friendly messages
   - Maintain 60fps performance with <500MB memory educational budget

3. **Code Quality Standards**
   - PascalCase class names with educational purpose documentation
   - snake_case methods with learning objective comments
   - Comprehensive class documentation with educational context
   - Educational signals for learning analytics integration

4. **Feature Implementation**
   - Create appropriate directory structure for educational feature
   - Implement core business logic in core/ with educational services integration
   - Design educational UI components in ui/ with theme system compliance
   - Add educational content to anatomical_data.json if needed
   - Include educational testing scenarios and validation

5. **Integration Points**
   - Educational panel system via InfoPanelFactory
   - 3D model interaction through BrainStructureSelectionManager
   - Educational AI assistance integration with AIAssistantService
   - Learning progress tracking with StructureAnalysisManager

Output Deliverables:
- Complete file structure for educational feature
- Documented GDScript classes with educational context
- Educational UI components with accessibility compliance
- Test scenarios for educational functionality validation
- Learning objectives and clinical relevance documentation
- Performance impact assessment for educational platform

Reference Patterns:
- Study existing educational components in ui/panels/
- Follow KnowledgeService patterns for educational content access
- Use UIThemeManager for consistent educational theming
- Implement educational signals for learning analytics

Execute with focus on medical education excellence and clinical accuracy.
```

## Example Usage
```bash
# Develop interactive quiz system
claude -f .claude/commands/educational-feature.md "Interactive Anatomy Quiz System"

# Create accessibility helper
claude -f .claude/commands/educational-feature.md "Enhanced Accessibility Navigation"

# Build progress tracking
claude -f .claude/commands/educational-feature.md "Learning Progress Dashboard"
```