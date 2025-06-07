# NeuroVis Debugging and Testing Guide

This guide explains how to use the debugging and testing tools that have been set up for the NeuroVis project.

## Fixed Issues (Updated)

### Class Name Conflicts

**Issue**: `class_name MainScene` was duplicated in multiple script files, causing the error:
```
Parse Error: Class "MainScene" hides a global script class.
```

**Solution**: Removed the `class_name MainScene` declaration from the node_3d.gd script, as only one script should define a global class name.

### UID Conflicts

If you encounter warnings like:

```
WARNING: UID duplicate detected between res://scenes/node_3d_new.tscn and res://scenes/node_3d.tscn.
WARNING: UID duplicate detected between res://scenes/ui_info_panel_new.tscn and res://scenes/ui_info_panel.tscn.
```

These happen because of scene file UIDs (Unique Identifiers) that conflict. Each scene file should have a unique UID.

#### How to Fix

1. Use the `launch_test.sh` script which handles this automatically:
   ```bash
   ./launch_test.sh
   ```

2. Manually fix (if needed):
   - Open `node_3d_new.tscn` and `ui_info_panel_new.tscn` in a text editor
   - Change the UIDs in the first line of each file to new unique values 
   - For example:
     ```
     [gd_scene load_steps=4 format=3 uid="uid://c0fcwv8j6p128"]
     ```
     ```
     [gd_scene load_steps=4 format=3 uid="uid://chrbwl4afpb3c"]
     ```

### Invalid UID References

**Issue**: Scene files referenced other scenes with invalid UIDs:
```
WARNING: res://scenes/node_3d.tscn:4 - ext_resource, invalid UID: uid://flp3nkt8v7kn
```

**Solution**: Updated the node_3d.tscn file to reference the correct UID of the ui_info_panel.tscn resource.

## Debug Scene

A dedicated debug scene has been created to help you test and debug your application. To use it:

1. Open the debug scene in the Godot editor:
   ```bash
   godot -e --path /Users/gagelaporta/A1-NeuroVis scenes/debug_scene.tscn
   ```

2. Run the debug scene:
   ```bash
   godot --path /Users/gagelaporta/A1-NeuroVis scenes/debug_scene.tscn
   ```

The debug scene provides the following features:
- Run the main scene with debug visualizations
- Run automated tests for the model switcher
- Toggle debug visualizations
- View test results and debug logs

## Model Switcher Issues

If models aren't appearing or switching between them isn't working:

1. Check the console for error messages
2. Verify that model files exist in the expected locations
3. Use the ModelControlPanel to try toggling visibility
4. See `MODEL_SWITCHER_FIXES.md` for more detailed information

## Debugging Tools

### Debug Visualizer

The `DebugVisualizer` script adds visual debugging helpers to your scene:

- Raycasts are visualized as red lines
- Collision shapes are outlined with green wireframes
- Model labels show the names of objects in the scene

When you run the main scene through the debug console, these visualizations are automatically added.

### Visual Debugger

The `VisualDebugger` class provides static methods for adding temporary debug visuals. Use it like this:

```gdscript
# Add a label in 3D space
VisualDebugger.add_label("Object Name", object_position)

# Draw a ray
VisualDebugger.draw_ray(ray_start, ray_end, 2.0)  # Duration in seconds

# Draw shapes
VisualDebugger.draw_box(position, Vector3(1, 1, 1))
VisualDebugger.draw_sphere(position, 0.5)

# Highlight a mesh
VisualDebugger.highlight_mesh(mesh_instance, Color(1, 0, 0, 0.5))

# Visualize raycasts
VisualDebugger.visualize_raycast(click_position, camera)

# Print node tree
VisualDebugger.print_node_tree(node)
```

Toggle all debug visuals with:
```gdscript
VisualDebugger.toggle()
```

### Debug Commands

The `debug_commands.gd` script provides a command system for debugging. To use it:

1. Add the script as an autoload in your project settings (as "DebugCommands")
2. Access the commands from your script:

```gdscript
# Run a command
DebugCommands.run_command("debug_toggle")

# Register your own command
DebugCommands.register_command("my_command", func(args): print("Command ran with: " + args), "My custom command")
```

Built-in commands:
- `debug_toggle` - Toggle debug visualizations
- `tree [node_path]` - Print scene tree structure
- `collision [node_path]` - Visualize collision shapes
- `label [node_path] [filter_class]` - Add labels to nodes
- `clear_debug` - Clear all debug visualizations
- `test [test_name]` - Run tests
- `help [command]` - Show help
- `ls` or `list` - List available commands
- `history` - Show command history
- `clear [history]` - Clear console or history

## UI Panel Issues

If the information panels aren't displaying correctly:

1. Check structure naming and ensure they match with data in `anatomical_data.json`
2. Verify signal connections between UI elements
3. Check the console for any null object references

## Script Error Handling

Many errors have been addressed with improved error handling:

1. Added null checks for scene objects
2. Added safety checks before model loading
3. Improved error reporting in console
4. Added debugging logging (lines starting with "DEBUG:")

## Automated Testing

The project includes multiple automated tests for different components of the application. Use the debug scene to run these tests easily.

### Model Switcher Test

This test verifies the model switching functionality:

1. Use the debug scene and click "ModelSwitcher Test", or
2. Run the test directly:
   ```bash
   godot -d --path /Users/gagelaporta/A1-NeuroVis tests/model_switcher_test.tscn
   ```

The test checks:
- Model switcher initialization
- Control panel connections
- Model registration
- Visibility toggling
- UI updates

### UI Info Panel Test

This test verifies the UI information panel functionality:

1. Use the debug scene and click "Info Panel Test"

The test checks:
- Panel initialization and references
- Structure data display
- Close button functionality
- Panel visibility toggling
- Integration with main scene

### Knowledge Base Test

This test verifies the knowledge base functionality:

1. Use the debug scene and click "Knowledge Base Test"

The test checks:
- Knowledge base data loading
- Metadata validation
- Structure retrieval and content validation
- Error handling

### Camera Controls Test

This test verifies the camera control functionality:

1. Use the debug scene and click "Camera Test"

The test checks:
- Camera initialization
- Camera transform updates
- Zoom limits
- Input handling
- Look-at functionality

### Structure Selection Test

This test verifies the structure selection functionality:

1. Use the debug scene and click "Selection Test"

The test checks:
- Raycast selection
- Structure highlighting
- UI updates on selection
- Signal emission
- Integration with info panel

### Creating Your Own Tests

To create a new test:

1. Create a new GDScript in the `tests` directory
2. Extend the `Node` class
3. Add a `test_completed` signal
4. Implement the `run_test` method
5. Use `_report_success` and `_report_failure` to report results

Example:
```gdscript
class_name MyTest
extends Node

signal test_completed(success: bool, message: String)

func run_test() -> void:
    # Perform test logic
    if test_passes:
        _report_success("Test passed successfully")
    else:
        _report_failure("Test failed because...")

func _report_success(message: String) -> void:
    emit_signal("test_completed", true, message)

func _report_failure(message: String) -> void:
    emit_signal("test_completed", false, message)
```

## Running with Debug Mode

To run the application with debug output enabled:

```bash
godot -d --path /Users/gagelaporta/A1-NeuroVis
```

This enables verbose logging and allows you to see detailed output from your application.

## Camera Controls

If camera controls aren't responding:

1. Middle mouse button: Rotate the camera
2. Scroll wheel: Zoom in/out
3. Arrow keys: Move camera position

## Common Issues

1. **Missing Models**: Ensure all .glb files are in assets/models/
2. **Invisible UI**: Check that CanvasLayer is properly configured
3. **Scene Hierarchy**: If you've modified scenes, ensure proper node nesting
4. **Script References**: After code changes, verify all referenced functions exist
5. **Class Name Conflicts**: Only define a class_name once across your entire project. Use unique class names to avoid conflicts.
6. **UID Conflicts**: Be careful when duplicating scenes. Godot by default gives each scene a unique UID, but when copying files manually, ensure UIDs are updated.
7. **Reference Management**: When manually editing scene files, ensure all references to other resources use valid UIDs.

## Best Practices for Debugging

1. **Use print statements strategically**:
   ```gdscript
   print("DEBUG: Value of variable: " + str(my_variable))
   ```

2. **Group related debug info**:
   ```gdscript
   print("\n=== MODEL LOADING ===")
   print("Loading model: " + model_path)
   print("Model scale: " + str(model_scale))
   print("=====================\n")
   ```

3. **Use conditionals to control debug output**:
   ```gdscript
   if DEBUG_MODE:
       print("Detailed debug info...")
   ```

4. **Log different levels of information**:
   ```gdscript
   DebugCommands.log_info("Normal operation info")
   DebugCommands.log_warning("Warning: something unusual")
   DebugCommands.log_error("Error: something failed")
   ```

5. **Check object validity before using**:
   ```gdscript
   if is_instance_valid(object) and object is Node and object.is_inside_tree():
       # Proceed with operations on the object
   ```

## Launch Script

The `launch_test.sh` script has been updated to:
1. Make backups of original scene files
2. Use files with corrected UIDs and scripts
3. Automatically launch the Godot editor with the fixed project