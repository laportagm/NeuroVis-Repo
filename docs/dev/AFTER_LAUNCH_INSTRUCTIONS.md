# Instructions After Launching

After launching the project with `launch_test.sh`, you may need to:

1. If the scene doesn't load properly, open each scene separately in the Godot editor:
   - Open `node_3d.tscn` in the editor
   - Open `ui_info_panel.tscn` in the editor
   - Open `model_control_panel.tscn` in the editor

2. Resave each scene to ensure proper UIDs and connections.

3. After saving, run the project again to test the model visibility toggling.

4. The model switcher panel should appear at the bottom left of the screen with checkboxes for each loaded model.

5. Clicking on a model in the 3D view should display its information in the info panel.

## Project Fixes Applied

The following issues have been fixed to ensure proper functionality:

1. **Class Name Conflict**
   - Renamed `MainScene` class to `NeuroVisMainScene` in `node_3d.gd` to avoid global class name conflict

2. **Scene UID Conflicts**
   - Fixed duplicate UIDs between `node_3d_new.tscn` and `node_3d.tscn`
   - Fixed duplicate UIDs between `ui_info_panel_new.tscn` and `ui_info_panel.tscn`
   - Assigned unique UIDs: `uid://c0fcwv8j6p128` and `uid://chrbwl4afpb3c` respectively

3. **Reference Fixes**
   - Updated scene references to use the correct UIDs
   - Fixed cross-references between scenes

4. **Parse Errors**
   - Fixed parse error in `knowledge_base_test.gd` related to line continuation

## Launch Script Enhancements

The `launch_test.sh` script has been improved for better reliability:

1. **Backup Functionality**
   - Only creates backups if they don't already exist
   - Preserves original scenes when needed

2. **UID Management**
   - Ensures scene files use unique UIDs to prevent conflicts
   - Displays clear messages about which scenes are being used

3. **Script Updates**
   - Applies `node_3d_modified.gd` to `node_3d.gd` for correct functionality

## Troubleshooting

If models are not appearing:
- Check the console for errors about missing models
- Verify that the file paths in `node_3d.gd` match your project structure

If model switching doesn't work:
- Check for signal connection errors in the console
- Verify that model_switcher.register_model() is being called

If the UI panels are not visible:
- Check the scene hierarchy to ensure they are under the UI_Layer node
- Verify that the visibility settings are correct

If you still see UID warnings:
- The editor may need to be restarted completely
- Try running `godot -e --path /Users/gagelaporta/A1-NeuroVis --clear-cache`

## Common Issues & Solutions

1. **If models don't appear:**
   - Check if model files exist in `assets/models/`
   - Use the ModelControlPanel checkboxes to toggle visibility

2. **If UI elements are missing:**
   - Check the scene hierarchy in the Godot editor
   - Ensure all UI elements are properly parented to the UI_Layer

3. **For additional debugging information:**
   - See `DEBUG_GUIDE.md` for detailed debugging guidance
   - Check console output for "DEBUG:" lines with useful info

## Model Switching System

See `MODEL_SWITCHER_FIXES.md` for details on the model switching system architecture and functionality.

## Next Steps

Now that the basic functionality has been fixed, consider these next steps for development:

1. Add more anatomical structures to the knowledge base
2. Implement detailed camera controls for better navigation
3. Add search functionality to find specific structures
4. Implement the AI assistant integration for Q&A
5. Enhance visual appearance with better shaders and lighting

Refer to the project roadmap documents in the `docs/` folder for more details on future development plans.