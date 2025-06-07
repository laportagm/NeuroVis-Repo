# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

NeuroVis is an AI-Enhanced Brain Anatomy Visualizer desktop application built with Godot Engine 4.2. It aims to create an advanced, interactive, and intuitive desktop educational tool that enhances learning and understanding of neuroanatomy through intelligent interaction with 3D brain models, supported by an AI assistant for dynamic explanations and Q&A.

## Development Environment

- **Primary Framework:** Godot Engine 4.2
- **Primary Language:** GDScript
- **Development OS:** macOS
- **Target OS:** Windows 10+ and macOS
- **Version Control:** Git

## Common Commands

### Godot Engine Commands

- **Open the Project in Godot Editor:**
  ```bash
  godot -e --path /Users/gagelaporta/11A-NeuroVis\ copy3
  ```

- **Run the Project:**
  ```bash
  godot --path /Users/gagelaporta/11A-NeuroVis\ copy3
  ```

- **Run a Specific Scene:**
  ```bash
  godot /Users/gagelaporta/11A-NeuroVis\ copy3/scenes/node_3d.tscn
  ```

- **Debug Mode:**
  ```bash
  godot -d --path /Users/gagelaporta/11A-NeuroVis\ copy3
  ```

- **Export Project for macOS:**
  ```bash
  godot --headless --path /Users/gagelaporta/11A-NeuroVis\ copy3 --export-release "macOS" /path/to/output/NeuroVis.dmg
  ```

- **Export Project for Windows:**
  ```bash
  godot --headless --path /Users/gagelaporta/11A-NeuroVis\ copy3 --export-release "Windows Desktop" /path/to/output/NeuroVis.exe
  ```

## Project Structure

- **`/assets/`**: Contains all project assets
  - **`/data/`**: Data files for the brain anatomy information (anatomical_data.json)
  - **`/icons/`**: Application icons and UI icons
  - **`/models/`**: 3D models of brain anatomy (Brainstem, Half_Brain, Internal_Structures)
  - **`/textures/`**: Textures for 3D models

- **`/scenes/`**: Godot scene files (.tscn)
  - `node_3d.tscn`: Main 3D visualization scene (entry point)
  - `node_3d.gd`: Main scene script functionality
  - `ui_info_panel.tscn`: Scene for the detailed anatomical information panel
  - `model_control_panel.tscn`: UI for model switching and visibility controls

- **`/scripts/`**: Contains GDScript files organized by domain (MODULAR ARCHITECTURE)
  - **`/core/`**: Core business logic and framework systems
    - `AnatomicalKnowledgeDatabase.gd`: Knowledge base management (Autoload: `KB`)
    - `BrainVisualizationCore.gd`: Core 3D visualization logic
    - `DebugCommands.gd`: Debug command system (Autoload: `DebugCmd`)
    - `DebugController.gd`: Debug system coordination
    - `DebugButtonMasks.gd`: Debug input handling
  - **`/models/`**: Model management and data structures
    - `ModelVisibilityManager.gd`: Model switching/visibility (Autoload: `ModelSwitcherGlobal`)
    - `ModelRegistry.gd`: Model registration and coordination
  - **`/interaction/`**: User interaction systems
    - `BrainStructureSelectionManager.gd`: Structure selection and highlighting
    - `CameraBehaviorController.gd`: Camera movement and controls
    - `KeyInputHandler.gd`: Keyboard input processing
    - `UpdatedInputHandler.gd`: Enhanced input handling
  - **`/ui/`**: UI components and interface management
    - `InformationPanelController.gd`: Info panel management
    - `StructureLabeler.gd`: Structure labeling system
    - `UIDiagnostic.gd`: UI debugging utilities
    - `LoadingOverlay.gd`, `ModernInfoDisplay.gd`, `OnboardingManager.gd`, `UIThemeManager.gd`
  - **`/visualization/`**: Visualization utilities and debugging
    - `VisualDebugger.gd`: Visual debugging system
    - `DebugVisualizer.gd`: Debug visualization helpers
    - `PerformanceDebugger.gd`: Performance monitoring
    - `MeshDiagnostic.gd`: Mesh analysis tools
  - **`/dev_utils/`**: Development and debugging tools
    - `BrainVisDebugger.gd`, `DebugDashboard.gd`, `DevConsole.gd`
    - `ErrorTracker.gd`, `HealthMonitor.gd`, `ProjectProfiler.gd`
    - `ResourceDebugger.gd`, `ResourceLoadTracer.gd`, `TestFramework.gd`
  - **`/tests/`**: Test scripts and utilities
    - `TestRunner.gd`, `ModelSwitcherTest.gd`
  - **`/debug/`**: Debug-specific functionality
    - `GodotDebugRunner.gd`

- **`/tests/`**: Comprehensive testing framework
  - **`/unit/`**: Unit tests for individual components
  - **`/integration/`**: Integration and end-to-end tests
  - **`/debug/`**: Debug-specific test utilities
  - **`/framework/`**: Testing framework infrastructure

- **`/docs/`**: Contains comprehensive project documentation
  - **`/Setup_Documentation/`**: Initial project setup files
  - **`/Roadmap_Docs/`**: Development roadmap and phase details
  - **`/AI_Prompting/`**: Guides for AI-assisted development
  - **`/Expansion/`**: Future content expansion plans

## Application Architecture

The project follows Godot's scene and node-based architecture with a modular script organization:

1. **3D Visualization Core**:
   - 3D brain models loaded and displayed in a Godot 3D scene
   - Camera controls for orbit, zoom, and pan managed by `CameraBehaviorController`
   - Selection system for anatomical structures via `BrainStructureSelectionManager`

2. **Information Display**:
   - Local knowledge base (`anatomical_data.json`) managed by `AnatomicalKnowledgeDatabase` (Autoload: `KB`)
   - UI panel managed by `InformationPanelController` displays detailed structure information
   - Structure labeling handled by `StructureLabeler`

3. **Model Management**:
   - Model visibility and switching managed by `ModelVisibilityManager` (Autoload: `ModelSwitcherGlobal`)
   - Model registration and coordination via `ModelRegistry`

4. **AI Assistant Integration**:
   - Online API calls to third-party LLM service 
   - Prompts for neuroanatomy Q&A and explanations

## Autoloads

The project uses the following Autoload singletons for global functionality:

1. **`KB` (`res://scripts/core/AnatomicalKnowledgeDatabase.gd`)**:
   - Manages loading and accessing anatomical data from JSON files globally

2. **`ModelSwitcherGlobal` (`res://scripts/models/ModelVisibilityManager.gd`)**:
   - Manages the visibility state of different 3D brain models globally across all scenes

3. **`DebugCmd` (`res://scripts/core/DebugCommands.gd`)**:
   - Provides a debug command system for development builds (conditionally loaded based on `OS.is_debug_build()`)

4. **`VisualDebugger` (`res://scripts/visualization/VisualDebugger.gd`)**:
   - Global visual debugging system for development and testing

## Key Classes and Resources

1. **AnatomicalKnowledgeDatabase (`scripts/core/AnatomicalKnowledgeDatabase.gd`)**:
   - Loads anatomical data from JSON
   - Provides methods to access structure information
   - Handles errors and status tracking for data loading
   - **Autoload Access:** Available globally as `KB`

2. **ModelVisibilityManager (`scripts/models/ModelVisibilityManager.gd`)**:
   - Manages 3D brain model visibility and registration
   - Handles model switching functionality with signals for UI updates
   - **Autoload Access:** Available globally as `ModelSwitcherGlobal`

3. **BrainVisualizationCore (`scripts/core/BrainVisualizationCore.gd`)**:
   - Manages 3D visualization of neural structures
   - Core class for brain visualization functionality

4. **BrainStructureSelectionManager (`scripts/interaction/BrainStructureSelectionManager.gd`)**:
   - Handles user interaction for selecting anatomical structures
   - Manages selection highlighting and interaction feedback

5. **CameraBehaviorController (`scripts/interaction/CameraBehaviorController.gd`)**:
   - Controls camera movement, orbit, zoom, and pan functionality
   - Manages camera constraints and smooth transitions

6. **InformationPanelController (`scripts/ui/InformationPanelController.gd`)**:
   - Manages the UI panel that displays detailed anatomical information
   - Interfaces with the knowledge base and selection system

7. **Main Scene (node_3d.tscn)**:
   - Entry point for the application
   - Contains the 3D visualization environment
   - Coordinates all major systems and components

8. **Anatomical Data (res://assets/data/anatomical_data.json)**:
   - JSON file storing anatomical information
   - Root object contains: `version` (String), `lastUpdated` (String), and `structures` (Array)
   - Each structure object contains: `id` (String), `displayName` (String), `shortDescription` (String), and `functions` (Array of Strings)

## Development Guidelines

1. **Follow Godot's Best Practices**:
   - Use Godot's scene/node hierarchy for structuring content
   - Use signals for communication between nodes
   - Follow GDScript style guidelines

2. **Modular Architecture**:
   - Keep related functionality grouped in domain-specific directories
   - Use clear, descriptive class names that indicate purpose and domain
   - Minimize cross-domain dependencies where possible
   - Use autoloads for truly global functionality only

3. **Version Control**:
   - Make frequent, small commits with clear messages
   - Work primarily on main/master branch (simplified for solo development)
   - Use Git tags for significant milestones

4. **Documentation**:
   - Document complex logic with comments
   - Keep README.md and documentation files updated
   - Use GDScript docstring format for functions

5. **Error Handling**:
   - Implement robust error handling for file operations and API calls
   - Display user-friendly error messages
   - Log errors for debugging

6. **Testing**:
   - Use the comprehensive testing framework in `/tests/`
   - Write unit tests for individual components
   - Include integration tests for complex workflows
   - Utilize debug utilities for development testing

## Project Roadmap

The project is developed through the following phases:

1. **Phase 1: Core 3D Visualization & Basic Interaction**
   - Render 3D model
   - Implement camera controls
   - Enable click-to-select/highlight of model parts
   - Display static name of selected part

2. **Phase 2: Basic Information Display & Local Knowledge Base**
   - Display detailed information for selected structures
   - Implement local JSON knowledge base

3. **Phase 3: In-App AI via Online API**
   - Integrate online LLM API for Q&A
   - Provide dynamic explanations for selected structures

4. **Phase 4: Packaging and Distribution**
   - Create installable versions for Windows and macOS
   - Setup download distribution

5. **Phase 5: Refinement & Content Expansion**
   - Improve UI/UX based on testing
   - Expand knowledge base content
   - Refine AI prompts

## Recent Major Changes

### Modular Architecture Implementation (Latest)
- **Reorganized scripts** from flat structure to domain-based modules
- **Updated class names** to be more descriptive and domain-specific
- **Fixed autoload paths** and dependencies for new modular structure
- **Resolved parser errors** from reorganization including type scope issues
- **Enhanced maintainability** with clear separation of concerns

This modular structure provides better code organization, easier maintenance, and clearer separation of responsibilities across the application.