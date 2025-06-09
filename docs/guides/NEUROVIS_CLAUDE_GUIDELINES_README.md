# 🧠 NeuroVis Claude Code CLI Prompt Guidelines

This document provides a quick reference for using the optimized Claude Code CLI prompt generation guidelines for the NeuroVis project.

## 📋 Quick Access to Guidelines

The complete guidelines are stored in: `NEUROVIS_CLAUDE_PROMPT_GUIDELINES.json`

## 🚀 Key Improvements for NeuroVis

### 1. **Project-Specific Context**
- All examples now use GDScript and Godot 4.4 specifics
- References to your autoload services (KB, KnowledgeService, AIAssistant, etc.)
- Medical education and anatomical accuracy requirements
- Performance targets (60fps) and accessibility standards (WCAG 2.1 AA)

### 2. **Optimized MCP Server Selection**
- **godot-mcp**: For scene manipulation, node operations, and Godot-specific tasks
- **filesystem**: For code analysis, refactoring, and multi-file operations
- **sequential-thinking**: For complex educational workflows and architecture planning
- **memory**: For maintaining context across related files during refactoring

### 3. **NeuroVis-Specific Prompt Patterns**
- Educational Component Pattern
- Anatomical Data Integration Pattern
- 3D Visualization Enhancement Pattern
- AI Service Integration Pattern

## 💡 Example Usage

### Creating an Educational Feature:
```bash
claude execute --mcp-server godot-mcp --prompt 'You are an expert Godot developer specializing in medical education software. Create a new educational panel for displaying neural pathway information. Requirements: 1) Extend the base EducationalPanel class from ui/panels/base/, 2) Integrate with KB autoload for anatomical data, 3) Include learning objective tracking, 4) Support AccessibilityManager for screen readers, 5) Add smooth animations for student engagement, 6) Follow the project signal patterns for selection events. Output complete GDScript implementation with proper documentation.'
```

### Debugging 3D Performance:
```bash
claude execute --mcp-server sequential-thinking --prompt 'You are a Godot 3D performance expert. Analyze the brain model rendering pipeline for performance bottlenecks preventing 60fps. Consider: 1) Current scene structure in scenes/main/node_3d.tscn, 2) ModelSwitcherGlobal autoload integration, 3) Material and shader optimization, 4) LOD implementation possibilities, 5) Profiling data from Godot monitor. Provide step-by-step optimization plan with specific GDScript code changes.'
```

### Adding AI Integration:
```bash
claude execute --mcp-server filesystem --prompt 'You are an AI integration specialist for Godot. Implement a new educational feature using GeminiAI service to generate contextual explanations for brain structures. Include: 1) Integration with existing GeminiAIService.gd, 2) Caching mechanism for API responses, 3) Fallback to KB service when offline, 4) Loading states in UI, 5) Medical accuracy validation. Output complete implementation with error handling.'
```

## 🎯 Quick Reference Checklist

When generating prompts for NeuroVis, ensure they include:

✅ **Role Definition**: "You are an expert Godot 4.4 developer specializing in..."
✅ **Project Context**: Mention relevant autoloads and services
✅ **Educational Purpose**: Specify medical education requirements
✅ **Technical Requirements**: 60fps target, accessibility compliance
✅ **Output Format**: Complete GDScript code with proper structure
✅ **Integration Points**: How it connects with existing services
✅ **Error Handling**: Use DebugCmd for logging
✅ **Testing Requirements**: Specify test scenarios

## 📚 Common NeuroVis Services to Reference

- **KB**: Anatomical Knowledge Database
- **KnowledgeService**: Educational content management
- **AIAssistant**: General AI interface
- **GeminiAI**: Google Gemini integration
- **UIThemeManager**: UI consistency
- **AccessibilityManager**: WCAG compliance
- **ModelSwitcherGlobal**: 3D model management
- **DebugCmd**: Debug command system
- **AIConfig**: AI configuration

## 🔧 VS Code Integration

These guidelines work seamlessly with your VS Code setup. Use the enhanced tasks:
- `Ctrl+Shift+P` → "Tasks: Run Task" → "🚀 Optimized Claude Request"
- Or use the quick command: `./run_claude_code.sh`

## 💬 Need Help?

1. Review the full guidelines in `NEUROVIS_CLAUDE_PROMPT_GUIDELINES.json`
2. Check existing examples in the "Complete NeuroVis Examples" section
3. Use the pattern templates for common tasks
4. Reference the quality checklist before finalizing prompts

Remember: The goal is to generate prompts that are immediately actionable, specific to your Godot/GDScript environment, and aligned with your educational platform's requirements.
