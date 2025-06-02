# NeuroVis Standards Enforcement Wrapper

## Critical Usage
```bash
# ALWAYS use this wrapper for ANY Claude request:
claude -f .claude/commands/standards-wrapper.md "Your actual request here"
```

## Standards Enforcement Command
```
🛡️ NEUROVIS STANDARDS ENFORCEMENT WRAPPER 🛡️

MANDATORY PRE-RESPONSE VALIDATION:

CONTEXT_CHECK:
✅ NeuroVis educational neuroscience visualization platform
✅ Project path: /Users/gagelaporta/11A-NeuroVis copy3  
✅ Standards source: CLAUDE.md (MUST reference)
✅ Target: Medical students + healthcare professionals
✅ Platform: Godot 4.4.1 educational platform

ARCHITECTURE_VALIDATION:
✅ Modular educational structure confirmed:
   - core/ → Educational business logic and services
   - ui/ → Educational interface components  
   - scenes/ → Educational workflow scenes
   - assets/ → Educational content and 3D models
✅ Autoload services: KnowledgeService, AIAssistant, UIThemeManager
✅ Educational themes: Enhanced (student) + Minimal (clinical)

CODE_STANDARDS_VALIDATION:
✅ GDScript conventions: PascalCase classes, snake_case methods
✅ Educational documentation: Learning objectives + clinical relevance
✅ Performance budgets: 60fps, <500MB memory, <100 draw calls
✅ Accessibility: WCAG 2.1 AA compliance required
✅ Error handling: Educational context with user-friendly messages

MANDATORY_RESPONSE_REQUIREMENTS:
✅ Educational purpose clearly stated for all changes
✅ Learning objectives preservation/enhancement explained
✅ Clinical accuracy maintained (medical terminology validated)
✅ Architecture compliance with NeuroVis modular patterns
✅ Accessibility considerations for diverse learning needs
✅ Performance impact assessment against educational budgets
✅ Explicit CLAUDE.md standards reference included

REJECTION_CRITERIA (Response will be rejected if missing):
❌ No educational context or learning objective consideration
❌ No CLAUDE.md standards reference
❌ Architecture violations (wrong directory placement)
❌ No accessibility consideration for UI changes
❌ No clinical accuracy validation for medical content
❌ Performance impact ignored for educational platform

USER_REQUEST: ${USER_ACTUAL_REQUEST}

EXECUTE WITH MANDATORY NEUROVIS EDUCATIONAL EXCELLENCE STANDARDS.
```

## Example Usage:
```bash
# Develop new feature
claude -f .claude/commands/standards-wrapper.md "Add interactive anatomy quiz system"

# Fix bugs  
claude -f .claude/commands/standards-wrapper.md "Fix memory leak in 3D brain model loading"

# Code review
claude -f .claude/commands/standards-wrapper.md "Review educational panel code for standards compliance"
```