# A1-NeuroVis Scene Architecture

This document outlines the key scenes in the A1-NeuroVis Godot project and their intended roles and relationships.

## Core Scenes:

Currently, the project structure is in its early stages. The primary scenes planned or existing are:

-   **`res://scenes/node_3d.tscn`**:
    -   **Status:** Exists.
    -   **Purpose:** Currently a placeholder or initial testing scene. Its role may evolve or it may be replaced by more specific scenes.
    -   **Associated Script (if any):** [Please check if a script is attached, e.g., `res://scripts/node_3d.gd` and document here]

-   **`res://scenes/Main.tscn` (Planned/Conceptual)**:
    -   **Status:** To be created.
    -   **Purpose:** Envisioned as the main container scene for the application. It will likely instance and manage other core scenes, such as the primary 3D visualization and the main user interface.
    -   **Associated Script (to be created):** `res://scripts/Main.gd` (or similar)
    -   **Key Children/Instanced Scenes (Planned):**
        -   An instance of `NeuralNet.tscn` (for the 3D visualization).
        -   An instance of `UI.tscn` (for user controls and information display).

-   **`res://scenes/NeuralNet.tscn` (Planned/Conceptual)**:
    -   **Status:** To be created.
    -   **Purpose:** Will contain the core 3D representation of the neural network(s). This includes neuron models, synaptic connections, and any related visual elements or effects.
    -   **Associated Script (to be created):** `res://scripts/NeuralNet.gd` (or similar)
    -   **Key Nodes (Planned):**
        -   `Camera3D` configured for optimal viewing of the network.
        -   `WorldEnvironment` for lighting, skybox, and post-processing effects.
        -   A root `Node3D` to act as the parent for all dynamically generated or loaded neuron and connection instances.

-   **`res://scenes/UI.tscn` (Planned/Conceptual)**:
    -   **Status:** To be created.
    -   **Purpose:** Will house all primary user interface elements. This includes controls for loading data, manipulating the view, adjusting visualization parameters, and displaying information about the neural network.
    -   **Associated Script (to be created):** `res://scripts/UI.gd` (or similar)
    -   **Key UI Elements (Planned):**
        -   File dialog buttons for loading network data.
        -   Camera control buttons (reset view, specific angles).
        -   Sliders/input fields for visualization parameters (e.g., connection strength threshold, neuron size/color mapping).
        -   Information panels or labels.

## Autoloads / Singletons

The project uses several Autoload singletons for global state management and cross-scene functionality:

-   **`KB` (`res://scripts/KnowledgeBase.gd`)**:
    -   **Purpose:** Manages the local anatomical knowledge base loaded from JSON data.
    -   **Global Access:** Available throughout the project as `KB` for accessing structure information and anatomical data.

-   **`ModelSwitcherGlobal` (`res://scripts/ModelSwitcher.gd`)**:
    -   **Purpose:** Manages the visibility state of different 3D brain models globally.
    -   **Global Access:** Available as `ModelSwitcherGlobal` for toggling model visibility, registering models, and handling model-related signals from any scene.

-   **`DebugCmd` (`res://scripts/DebugCommands.gd`)**:
    -   **Purpose:** Provides a debug command system for development and testing (conditionally loaded in debug builds only).
    -   **Global Access:** Available as `DebugCmd` in debug builds for registering and executing debug commands throughout the application.
    -   **Note:** This autoload is excluded from release builds using `OS.is_debug_build()` checks and can be entirely excluded via export settings.

## Scene Instancing and Communication Strategy (To be refined):

-   **Instancing:** Child scenes (like `NeuralNet.tscn` and `UI.tscn`) will typically be instanced as children of `Main.tscn` either directly in the editor or via script in `Main.gd`.
-   **Communication:**
    -   **Signals:** For decoupled communication between major scene components (e.g., a UI button click needing to affect the `NeuralNet` visualization), custom signals defined in relevant scripts or via an Autoload (Singleton) script are preferred.
    -   **Direct Script Calls:** May be used for tightly coupled components, particularly within a single complex scene, or from a parent scene to its direct children.
    -   **Autoloads (Singletons):** Global state and functionality are managed via the Autoloads listed above, providing consistent access across all scenes.

*(This document should be updated as the project evolves and these scenes are implemented and refined.)*