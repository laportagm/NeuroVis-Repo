# NeuroVis Current Project State - Tue Jun  3 10:22:29 EDT 2025
## ALWAYS REFERENCE THIS FOR MAXIMUM CLAUDE EFFECTIVENESS

## 🎯 PROJECT OVERVIEW
- **Platform**: Educational neuroscience visualization for medical students
- **Architecture**: Modular Godot 4.4.1 with educational focus
- **Performance Targets**: 60fps, <500MB memory, <100 draw calls
- **Standards**: WCAG 2.1 AA accessibility + medical accuracy

## 📊 CURRENT CODEBASE ANALYSIS
### File Statistics:
- GDScript files: 281
- Scene files: 36
- Educational components: 0
- Total lines of code: 85988

## 🏗️ ARCHITECTURE OVERVIEW
### Directory Structure:
- .claude
- .git
- .github
- .godot
- .vscode
- assets
- config
- core
- data
- docs
- godot-mcp
- patches
- scenes
- scripts
- shaders
- specs
- temp_syntax_check
- test_logs
- test_reports
- tests
- tmp
- tools
- ui

### Core Components:
- core/visualization/RenderingOptimizer.gd
- core/visualization/PerformanceDebugger.gd
- core/visualization/VisualDebugger.gd
- core/visualization/MaterialOptimizer.gd
- core/visualization/DebugVisualizer.gd
- core/visualization/LODSystemEnhanced.gd
- core/visualization/MeshDiagnostic.gd
- core/visualization/MedicalLighting.gd
- core/visualization/SelectionVisualizer.gd
- core/visualization/EducationalVisualFeedback.gd

### UI Components:
- ui/core/ComponentRegistryCompat.gd
- ui/core/SimplifiedComponentFactory.gd
- ui/core/ComponentRegistry.gd
- ui/integration/FoundationDemo.gd
- ui/panels/BrainAnalysisPanel.gd
- ui/panels/AccessibilitySettingsPanel.gd
- ui/panels/minimal_info_panel.gd
- ui/panels/UIThemeManager.gd
- ui/panels/LoadingOverlay.gd
- ui/panels/ModernInfoDisplay.gd

## 📈 RECENT DEVELOPMENT
### Git History (Last 10 commits):
- 2c10ad0 Initial commit of NeuroVis educational neuroscience platform

## 🔧 ACTIVE FEATURES
### Educational Components:
- {{CLASS_NAME}}
- {{SCENE_NAME}}Controller
- AccessibilityManager
- ActionsComponent
- Advanced3DFeatures
- AdvancedInteractionSystem
- AIAssistantPanel
- AIAssistantService
- AIConfigurationManager
- AIIntegrationManager
- AIProviderInterface
- AIProviderRegistry
- AnatomicalKnowledgeDatabase
- AppState
- AutoloadDebugTest
- AutoloadHelper
- BaseUIComponent
- BenchmarkRunner
- BrainAnalysisPanel
- BrainStructureInfoPanel
- BrainStructureSelectionManager
- BrainSystemSwitcher
- BrainVisualizationCore
- BrainVisualizer
- CameraBehaviorController
- CameraControllerUnitTest
- CameraControlPanel
- CameraControlsTest
- CameraSystem
- ComparativeAnatomyService
- ComponentBase
- ComponentRegistry
- ComponentRegistryCompat
- ComponentStateManager
- ContentComponent
- CoreSystemsBootstrap
- CoreSystemsRegistry
- DebugButtonMasks
- DebugController
- DebugVisualizer
- DesignSystem
- EducationalModuleCoordinator
- EducationalNotificationSystem
- EducationalTooltipManager
- EducationalVisualFeedback
- EndToEndWorkflowTest
- EnhancedAIAssistant
- EnhancedInfoPanel
- EnhancedInformationPanel
- EnhancedLoadingOverlay
- EnhancedModelControlPanel
- EnhancedStructureInfoPanel
- ErrorHandler
- ErrorNotification
- EventBus
- ExampleFrameworkTest
- GeminiAIProvider
- GeminiAIService
- GeminiModelSelector
- GeminiSetupDialog
- GodotDebugRunner
- GodotEngineDebugTest
- GodotErrorDetectionTest
- HeaderComponent
- InfoPanelComponent
- InfoPanelFactory
- InformationPanelController
- InputRouter
- InputRouterTest
- InputSystem
- InteractionHandler
- InteractiveTooltip
- KeyInputHandler
- KnowledgeBaseTest
- KnowledgeBaseUnitTest
- LearningPathwayManager
- LoadingOverlay
- LoadingStateManager
- LODManager
- LODSystemEnhanced
- MainScene
- MainSceneComponents
- MainSceneHybrid
- MainSceneRobust
- MainSceneSimple
- MaterialLibrary
- MaterialOptimizer
- MedicalCameraController
- MedicalLighting
- MeshDiagnostic
- MinimalInfoPanel
- MockAIProvider
- ModelControlPanel
- ModelLoader
- ModelRegistry
- ModelSwitcherSceneTest
- ModelSwitcherTest
- ModelSwitcherTestCore
- ModelSwitcherUnitTest
- ModelSystem
- ModelVisibilityManager
- ModernInfoDisplay
- ModularInfoPanel
- MultiStructureSelectionManager
- NameMappingTest
- NavigationItem
- NavigationPanel
- NavigationSection
- NavigationSidebar
- NavItem
- NeuroVisDarkTheme
- NeuroVisEnhancedScene
- NeuroVisMainSceneUpdated
- OnboardingManager
- OptimizedNeuroVisRoot
- or node.is_class(class_name):
- PerformanceComparer
- PerformanceDebugger
- PerformanceMonitor
- PerformanceRegressionTest
- RefactoredMainSceneTest
- RenderingBenchmark
- RenderingOptimizer
- ResourceLoadingDebugTest
- ResourceManager
- ResponsiveComponent
- ResponsiveComponentSafe
- SafeUIComponentTest
- SceneLoadingDebugTest
- SceneManager
- SectionComponent
- SelectionDebugVisualizer
- SelectionPerformanceValidator
- SelectionReliabilityTest
- SelectionSystem
- SelectionTestRunner
- SelectionVisualizer
- ServiceLocator
- SimplifiedComponentFactory
- StartupValidator
- StateManager
- StructureInfoPanel
- StructureLabeler
- StructureManager
- StructureSelectionTest
- StyleEngine
- SystemBootstrap
- SystemBootstrapTest
- SystemIntegrationManager
- TestFramework
- TestPlayer
- TestRunnerCLI
- ThemeToggle
- to avoid autoload conflicts - accessed via autoload name "ResourceDebugger"
- UIComponentFactory
- UIComponentPool
- UIDiagnostic
- UIInfoPanelTest
- UIManager
- UISystem
- UnifiedStructureInfoPanel
- UpdatedInputHandlerFixed
- VisualDebugger
./tests/integration/RenderingValidationTest.gd:func _find_node_by_class(class_name: String) -> Node:
./ui/panels/UIDiagnostic.gd:	# Note: Using is operator might not work if MainScene is not a class_name

## ⚠️ KNOWN ISSUES TO WATCH
### Common NeuroVis Development Challenges:
- VBoxContainer configure() method calls - ensure ContentComponent has proper methods
- Type hint compliance - all functions must have parameter and return types
- Educational documentation - all components need learning objectives
- Performance optimization - maintain 60fps for 3D brain interactions
- Accessibility compliance - WCAG 2.1 AA for diverse learning needs

## 🎯 CURRENT DEVELOPMENT PRIORITIES
### Next Steps:
- Fix any ContentComponent configure() method issues
- Ensure all educational components have proper documentation
- Validate medical accuracy of anatomical content
- Optimize performance for educational interactions
- Test accessibility compliance for learning tools

## 📊 PERFORMANCE INDICATORS
### Code Quality Metrics:
- Classes with educational documentation: 0
- Functions with type hints: 3675
- Signal declarations: 523

## 🛡️ CLAUDE OPTIMIZATION NOTES
### For Maximum Effectiveness:
- Always reference this file for current project state
- Use enhanced standards enforcement (Ctrl+Shift+U)
- Include educational context in all development requests
- Validate medical accuracy for anatomical content
- Ensure accessibility compliance in UI changes
- Maintain performance budgets for educational platform
