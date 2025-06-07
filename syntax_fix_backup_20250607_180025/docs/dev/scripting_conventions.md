# A1-NeuroVis GDScript Conventions

This document outlines the GDScript coding conventions and best practices to be followed for the A1-NeuroVis project to ensure consistency and readability.

## GDScript Version
- This project uses GDScript compatible with the specified Godot Engine 4.x version (refer to `project_overview.md` for the exact version).

## Naming Conventions:
-   **File Names (Scripts):** `PascalCase.gd` for scripts that primarily define a class (e.g., `PlayerController.gd`, `NeuralNode.gd`). `snake_case.gd` can be used for more utility-focused scripts if not defining a primary class. (Your current project files `Main.gd`, `NeuralNet.gd`, `UI.gd` use PascalCase, which is good for class-like scripts).
-   **Class Names (using `class_name`):** `PascalCase` (e.g., `class_name Neuron`). This is highly recommended for custom node types or resources.
-   **Function Names:** `snake_case()` (e.g., `_ready()`, `_process(delta)`, `calculate_activation()`). Private/internal helper functions can be prefixed with an underscore: `_private_helper_function()`.
-   **Variable Names:** `snake_case` (e.g., `neuron_count`, `is_processing`, `target_node`).
-   **Constant Names:** `ALL_CAPS_SNAKE_CASE` (e.g., `MAX_CONNECTIONS`, `DEFAULT_COLOR`). Use `const` keyword.
-   **Signal Names:** `snake_case` (e.g., `neuron_selected`, `data_loaded`).
-   **Enum Names:** `PascalCase` for the enum itself, and `ALL_CAPS_SNAKE_CASE` for its values (e.g., `enum NeuronState { IDLE, ACTIVATED, PROCESSING }`).

## Node Access:
-   **`@onready` for Initialization:** Use `@onready var my_node_var = get_node("Path/To/Node")` or `@onready var my_typed_node_var: MyNodeType = get_node("Path/To/Node")` for accessing required child nodes within the `_ready()` function's scope. This ensures the node is available.
-   **Unique Names (`%`):** For nodes that are guaranteed to be unique within their parent's scope and are frequently accessed, consider assigning a unique name in the editor (the `%` icon next to the node name) and accessing it via `%UniqueNodeName`.
-   **` Shorthand:** Use the ` shorthand (e.g., `$Path/To/Node`) for concise access, primarily for direct children or stable paths. Be mindful of path changes causing errors.
-   **Exported NodePaths:** For configurable node dependencies, use `@export var target_node_path: NodePath` and then get the node using `get_node(target_node_path)` within `_ready()` or when needed.

## `class_name` Usage:
-   Use `class_name MyCustomClass` (e.g., `class_name NeuronVisualizer`) at the top of scripts that define a reusable custom node type or a custom resource. This allows them to be globally accessible by their class name for instantiation and type checking.

## Signals:
-   Define custom signals using the `signal` keyword at the top of the script (e.g., `signal data_updated(new_data_array)`).
-   Emit signals using `emit_signal("signal_name", argument1, argument2, ...)` or the newer `signal_name.emit(argument1, argument2, ...)`.
-   Connect to signals either through the Godot Editor (Node panel > Signals tab) or in code using `node.signal_name.connect(callable_function)`.
-   Clearly document what data signals carry and when they are emitted.

## Typing:
-   Use static typing wherever practical to improve code clarity, allow for better autocompletion, and catch errors earlier.
    -   `var variable_name: DataType = value`
    -   `func function_name(param1: DataType, param2: DataType) -> ReturnType:`
-   Use Godot's built-in types (e.g., `Node3D`, `Array[String]`, `Dictionary`) and your own `class_name` types.

## Comments:
-   **File-level comments:** Briefly explain the purpose of the script at the top if it's not obvious from the class name.
-   **Function Docstrings:** Use multi-line comments (`""" ... """` or `#` for each line) immediately after a function definition to explain its purpose, arguments, and what it returns, especially for complex or non-obvious functions.
    ```gdscript
    # Calculates the distance to a target.
    # target_position: Vector3 - The global position of the target.
    # returns: float - The calculated distance.
    func calculate_distance_to_target(target_position: Vector3) -> float:
        return global_position.distance_to(target_position)
    ```
-   **Inline Comments:** Use `#` for explaining complex lines or sections of code. Avoid over-commenting obvious code.

## General Best Practices:
-   Keep scripts focused on a single responsibility where possible.
-   Avoid overly long functions; break them down into smaller, manageable pieces.
-   Use meaningful variable and function names.
-   Prioritize readability.