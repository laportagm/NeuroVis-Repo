## node_3d_refactored.gd
## This is the refactored version of node_3d.gd that uses the component architecture
##
## To use this refactored version:
## 1. Backup your current node_3d.gd file
## 2. Replace node_3d.gd with this file's content
## 3. Or update your scene to use MainSceneOrchestrator directly

extends MainSceneOrchestrator

# The MainSceneOrchestrator handles all the complexity through components:
# - DebugManager: Debug commands and testing (200 lines)
# - SelectionCoordinator: Selection system (150 lines)
# - UICoordinator: UI management (100 lines)
# - AICoordinator: AI integration (100 lines)
#
# This reduces the original 860-line God Object to focused components

# You can override methods here if needed for scene-specific behavior
# For example:

#func _ready() -> void:
#    super._ready()  # Call parent initialization
#    # Add any scene-specific initialization here

# Or access components directly:
#func custom_method() -> void:
#    var selection = get_component("selection")
#    if selection:
#        selection.clear_selection()
