# NeuroVis Dependency Mapping

## Overview
This document maps the dependency relationships between modules, autoloads, and systems in the NeuroVis educational platform. Understanding these dependencies is crucial for maintenance, testing, and architectural decisions.

## Autoload Services (Singletons)

### Core Knowledge Services
1. **KB** - `core/knowledge/AnatomicalKnowledgeDatabase.gd` (Legacy)
   - Being phased out in favor of KnowledgeService
   - Still used as fallback in some components

2. **KnowledgeService** - `core/knowledge/KnowledgeService.gd` (Primary)
   - Dependencies: None (self-contained)
   - Used by: UI panels, selection managers, AI services
   - Provides: Structure data, search, normalization

3. **StructureAnalysisManager** - `core/systems/StructureAnalysisManager.gd`
   - Dependencies: KnowledgeService
   - Used by: AI services, educational features
   - Provides: Learning content analysis

### AI Services
4. **AIAssistant** - `core/ai/AIAssistantService.gd`
   - Dependencies: KnowledgeService, StructureAnalysisManager
   - Used by: UI panels, main scene
   - Provides: Educational AI query support

5. **GeminiAI** - `core/ai/GeminiAIService.gd`
   - Dependencies: AIConfig
   - Used by: AIAssistant (as provider)
   - Provides: Gemini API integration

6. **AIConfig** - `core/ai/config/AIConfigurationManager.gd`
   - Dependencies: None
   - Used by: AI services
   - Provides: API key management, configuration

7. **AIRegistry** - `core/ai/AIProviderRegistry.gd`
   - Dependencies: None
   - Used by: AIIntegration
   - Provides: AI provider registration/management

8. **AIIntegration** - `core/ai/AIIntegrationManager.gd`
   - Dependencies: AIRegistry, AIConfig
   - Used by: Main scene
   - Provides: Unified AI interface

### UI & Theme Services
9. **UIThemeManager** - `ui/panels/UIThemeManager.gd`
   - Dependencies: None
   - Used by: All UI components
   - Provides: Enhanced/Minimal themes, styling

10. **AccessibilityManager** - `core/systems/AccessibilityManager.gd`
    - Dependencies: UIThemeManager
    - Used by: UI components
    - Provides: Accessibility features

### Model Management
11. **ModelSwitcherGlobal** - `core/models/ModelVisibilityManager.gd`
    - Dependencies: None
    - Used by: UI panels, main scene
    - Provides: Layer-based model visibility

### Debug & Development
12. **DebugCmd** - `core/systems/DebugCommands.gd`
    - Dependencies: All autoloads (for debugging)
    - Used by: Development/testing
    - Provides: Console commands

13. **FeatureFlags** - `core/features/FeatureFlags.gd`
    - Dependencies: None
    - Used by: All components (feature gating)
    - Provides: Feature toggle system

## Dependency Patterns

### 1. Direct Autoload Access Pattern
Most common pattern using `get_node("/root/AutoloadName")`:
```gdscript
var knowledge_service = get_node("/root/KnowledgeService")
var theme_manager = get_node("/root/UIThemeManager")
```

**Files using this pattern:**
- `ui/panels/ComparativeInfoPanel.gd`
- `core/interaction/BrainStructureSelectionManager.gd`
- `core/visualization/EducationalVisualFeedback.gd`
- `ui/panels/AccessibilitySettingsPanel.gd`
- `core/systems/StructureAnalysisManager.gd`

### 2. Safe Autoload Access Pattern
Defensive pattern using `SafeAutoloadAccess` utility:
```gdscript
var theme_manager = SafeAutoloadAccess.get_theme_manager()
var knowledge_service = SafeAutoloadAccess.get_knowledge_service()
```

**Advantages:**
- Prevents crashes when autoloads missing
- Provides fallback behavior
- Caches autoload validation

### 3. Dynamic Loading Pattern
Used by main scene to avoid circular dependencies:
```gdscript
var MultiStructureSelectionManagerScript = load("res://core/interaction/MultiStructureSelectionManager.gd")
var selection_manager = MultiStructureSelectionManagerScript.new()
```

## Inter-Module Communication

### UI → Core Data Flow
1. **User Interaction** → `BrainStructureSelectionManager`
2. **Selection Event** → `KnowledgeService.get_structure()`
3. **Data Retrieved** → `InfoPanelFactory.create_panel()`
4. **Panel Update** → Display to user

### Core → UI Event Flow
1. **Model Change** → `ModelSwitcherGlobal` signal
2. **Signal Received** → UI panels update
3. **Theme Applied** → `UIThemeManager.apply_theme()`
4. **Visual Update** → User sees change

### AI Integration Flow
1. **User Query** → `AIAssistantPanel`
2. **Context Set** → `AIAssistant.set_current_structure()`
3. **Provider Called** → `GeminiAI` or other provider
4. **Response Processed** → `AIAssistant` returns to UI
5. **Display Update** → Panel shows response

## Resource Loading

### ResourceManager Pattern
Not implemented as autoload, but provides centralized resource management:
- Caches loaded resources
- Supports async loading
- Groups resources for bulk operations
- Tracks memory usage

**Used for:**
- 3D model loading (.glb files)
- Texture loading
- Scene preloading
- Configuration files

## Critical Dependencies

### 1. Initialization Order
Critical autoloads that must initialize first:
1. `FeatureFlags` - Gates all features
2. `KnowledgeService` - Core data provider
3. `UIThemeManager` - UI styling foundation
4. `ModelSwitcherGlobal` - 3D model management

### 2. Circular Dependency Prevention
- Main scene uses dynamic loading to avoid circular deps
- Components use dependency injection pattern
- Autoloads are self-contained where possible

### 3. Fallback Chains
1. **Knowledge Data**: `KnowledgeService` → `KB` (legacy) → hardcoded defaults
2. **AI Providers**: `GeminiAI` → `MockAIProvider` → error message
3. **UI Themes**: `UIThemeManager` → fallback basic styling

## Testing Considerations

### Unit Testing Dependencies
- Mock autoloads for isolated testing
- Use `SafeAutoloadAccess` for resilient tests
- Test both success and fallback paths

### Integration Testing
- Verify autoload initialization order
- Test inter-module communication
- Validate signal connections

### Debug Commands for Dependency Validation
```
test autoloads       # Verify all autoloads accessible
test infrastructure  # Check core systems
test ui_safety      # Validate UI component safety
kb status          # Check knowledge service
ai_status         # Verify AI services
```

## Recommendations

### 1. Reduce Direct Dependencies
- Use event bus pattern for decoupling
- Implement service locator for optional dependencies
- Consider dependency injection for testability

### 2. Improve Error Handling
- All autoload access should use safe patterns
- Provide meaningful fallbacks
- Log dependency failures clearly

### 3. Documentation
- Document required vs optional dependencies
- Maintain initialization order documentation
- Update this mapping when adding dependencies

## Dependency Graph (ASCII)

```
Main Scene (node_3d.gd)
├── Core Systems
│   ├── BrainStructureSelectionManager
│   │   ├── KnowledgeService
│   │   ├── VisualFeedback
│   │   └── AccessibilityManager
│   ├── CameraBehaviorController
│   └── ModelCoordinator
│       └── ModelSwitcherGlobal
├── UI Layer
│   ├── InfoPanelFactory
│   │   ├── UIThemeManager
│   │   ├── KnowledgeService
│   │   └── SafeAutoloadAccess
│   ├── ComparativeInfoPanel
│   │   ├── KnowledgeService
│   │   └── UIThemeManager
│   └── AIAssistantPanel
│       ├── AIAssistant
│       │   ├── AIConfig
│       │   ├── AIRegistry
│       │   └── GeminiAI
│       └── UIThemeManager
└── Foundation Layer
    ├── FeatureFlags
    ├── ComponentRegistry
    └── ComponentStateManager
```

## Maintenance Notes

Last Updated: 2024-01-06
- Added new AI integration layer dependencies
- Documented SafeAutoloadAccess pattern
- Updated with multi-selection system dependencies